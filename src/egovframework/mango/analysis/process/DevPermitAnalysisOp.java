package egovframework.mango.analysis.process;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.TreeMap;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.geotools.coverage.grid.GridCoverage2D;
import org.geotools.data.DataStore;
import org.geotools.data.DataStoreFinder;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.data.simple.SimpleFeatureIterator;
import org.geotools.factory.CommonFactoryFinder;
import org.geotools.filter.text.cql2.CQL;
import org.geotools.filter.text.cql2.CQLException;
import org.geotools.geometry.jts.JTS;
import org.geotools.geometry.jts.JTSFactoryFinder;
import org.geotools.geometry.jts.ReferencedEnvelope;
import org.geotools.process.spatialstatistics.core.DataStatistics;
import org.geotools.process.spatialstatistics.core.StatisticsVisitorResult;
import org.geotools.process.spatialstatistics.gridcoverage.RasterHelper;
import org.geotools.referencing.CRS;
import org.geotools.util.logging.Logging;
import org.jaitools.numeric.Range;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.Polygon;
import org.locationtech.jts.util.Stopwatch;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.filter.Filter;
import org.opengis.filter.FilterFactory2;
import org.opengis.filter.expression.Expression;
import org.opengis.referencing.FactoryException;
import org.opengis.referencing.NoSuchAuthorityCodeException;
import org.opengis.referencing.crs.CoordinateReferenceSystem;

/**
 * 개발행위 허가 분석: 가능지역들의 교집합 버전
 * 
 * 표고 ∩ 경사(도시지역의 녹지지역과 기타지역) ∩ 비오톱유형 ∩ 개별비오톱
 * 
 * Analyzes development permit eligibility based on DEM, slope, and ecological data.
 * 
 */
public class DevPermitAnalysisOp {
    protected static final Logger LOGGER = Logging.getLogger(DevPermitAnalysisProcess.class);

    static final GeometryFactory gf = JTSFactoryFinder.getGeometryFactory(null);

    static final FilterFactory2 ff = CommonFactoryFinder.getFilterFactory2(null);

    private CoordinateReferenceSystem measureCRS; // 면적 계산용

    // Analysis Constants
    static final String BT_TYPE_CQL = "ty_evl > 1";

    static final String BT_INDV_CQL = "indvdlz_evl > 1";

    static final Double DEM_MAX_VAL = 50d;

    static final Double[] SLOPE_MAX_VALS = { 12d, 18d };

    static final Stopwatch stopWatch = new Stopwatch();

    public DevPermitAnalysisOp() {
        try {
            this.measureCRS = CRS.decode("EPSG:5179");
        } catch (NoSuchAuthorityCodeException e) {
           LOGGER.log(Level.SEVERE, "변환오류 ");
        } catch (FactoryException e) {
        	LOGGER.log(Level.SEVERE, "변환오류 ");
        }
    }

    public DevPermitReport execute(Geometry userArea, CoordinateReferenceSystem userCRS,
            GridCoverage2D demCoverage, GridCoverage2D slopeCoverage,
            SimpleFeatureCollection urbanAreaFeatures, SimpleFeatureCollection biotopeTypeFeatures,
            SimpleFeatureCollection biotopeIndvFeatures) {

        // userArea와 userCRS 는 4326(SH 기본 좌표계이며 API의 모든 기본 입력)
        final DevPermitReport result = new DevPermitReport();
        userArea.setUserData(userCRS);

        // 모든 연산은 gridCRS에 맞춰 수행 후 결과값 계산시 면적계산은 measureCRS, 반환값은 userCRS로
        CoordinateReferenceSystem gridCRS = demCoverage.getCoordinateReferenceSystem();
        CoordinateReferenceSystem featureCRS = urbanAreaFeatures.getSchema()
                .getCoordinateReferenceSystem();

        Geometry gridMask = FeatureUtils.confirmTransform(userArea, userCRS, gridCRS);
        Geometry featureMask = FeatureUtils.confirmTransform(userArea, userCRS, featureCRS);

        // Step 1: Process DEM data below 50m elevation
        GridCoverage2D clippedDem = CoverageUtils.cropCoverage(demCoverage, gridMask);
        SimpleFeatureCollection demFeatures = processDemData(clippedDem, gridMask);
        if (!isValidFeatureCollection(demFeatures, "표고 조건")) {
            return result;
        }

        // Step 2: Process slope and urban area data
        SimpleFeatureCollection urbanArea = filterFeatures(urbanAreaFeatures, featureMask, null,
                gridCRS, true);
        if (!isValidFeatureCollection(urbanArea, "도시지역")) {
            return result;
        }
        //System.out.println("도시지역 Elapsed time: " + stopWatch.getTimeString());

        GridCoverage2D clippedSlope = CoverageUtils.cropCoverage(slopeCoverage, gridMask);
        SimpleFeatureCollection slopeFeatures = processSlopeData(clippedSlope, gridMask, urbanArea);
        if (!isValidFeatureCollection(slopeFeatures, "경사 조건")) {
            return result;
        }

        // Step 3: Process biotope type evaluation
        SimpleFeatureCollection bioTypes = filterFeatures(biotopeTypeFeatures, featureMask,
                BT_TYPE_CQL, gridCRS, true);
        if (!isValidFeatureCollection(bioTypes, "비오톱유형평가 조건")) {
            return result;
        }

        // Step 4: Process individual biotope evaluation
        SimpleFeatureCollection bioIndvs = filterFeatures(biotopeIndvFeatures, featureMask,
                BT_INDV_CQL, gridCRS, true);
        if (!isValidFeatureCollection(bioIndvs, "개별비오톱평가 조건")) {
            return result;
        }

        // Step 5: Calculate development-permit feasible areas
        Geometry permitGeometry = calculateFeasibleArea(demFeatures, slopeFeatures, bioTypes,
                bioIndvs, gridCRS);
        if (permitGeometry == null || permitGeometry.isEmpty()) {
            LOGGER.log(Level.INFO, "해당지역은 개발행위 가능지역이 없습니다.");
            return result;
        }

        // Generate final permit result
        generatePermitResult(result, permitGeometry, clippedDem, clippedSlope, bioTypes, bioIndvs,
                userCRS);

        return result;
    }

    private SimpleFeatureCollection processDemData(GridCoverage2D demCoverage, Geometry gridMask) {
        if (demCoverage == null) {
            LOGGER.log(Level.SEVERE, "demCoverage is null");
            return null;
        }

        List<Range<Double>> ranges = CoverageUtils.getRange(0d, DEM_MAX_VAL, true, false);
        int[] pixelValues = CoverageUtils.getPixelValues(ranges, 1);
        SimpleFeatureCollection demFeatures = CoverageUtils.vectorize(demCoverage, 0, false, ranges,
                pixelValues, gridMask);
        if (!isValidFeatureCollection(demFeatures, "표고 조건")) {
            return null;
        }

       // System.out.println("DEM Elapsed time: " + stopWatch.getTimeString());
        return demFeatures;
    }

    private SimpleFeatureCollection processSlopeData(GridCoverage2D slopeCoverage,
            Geometry gridMask, SimpleFeatureCollection urbanArea) {
        if (slopeCoverage == null) {
            LOGGER.log(Level.SEVERE, "slopeCoverage is null");
            return null;
        }

        // 도시지역을 녹지지역과 기타지역으로 분류
        // 녹지지역 12도 이하, 기타지역 18도 이하의 지역만 가능지역으로 설정
        List<Geometry> geometries = new ArrayList<>();
        Map<Double, Geometry> map = this.processUrbanData(urbanArea, "ucode");
        for (Entry<Double, Geometry> entry : map.entrySet()) {
            double val = entry.getKey();
            Geometry geometry = entry.getValue();
            double maxVal = val == SLOPE_MAX_VALS[0] ? SLOPE_MAX_VALS[0] : SLOPE_MAX_VALS[0];
            List<Range<Double>> ranges = CoverageUtils.getRange(0d, maxVal, true, false);
            int[] pixelValues = CoverageUtils.getPixelValues(ranges, 1, 0);
            SimpleFeatureCollection slopeFeatures = CoverageUtils.vectorize(slopeCoverage, 0, false,
                    ranges, pixelValues, geometry);
            if (!isValidFeatureCollection(slopeFeatures, "경사 조건")) {
                continue;
            }
            geometries.add(FeatureUtils.unionGeometries(slopeFeatures));
        }
       // System.out.println("Slope Elapsed time: " + stopWatch.getTimeString());

        CoordinateReferenceSystem crs = slopeCoverage.getCoordinateReferenceSystem();
        return FeatureUtils.buildFeatures(FeatureUtils.unionGeometries(geometries), "Slope",
                Polygon.class, crs);
    }

    private boolean isValidFeatureCollection(SimpleFeatureCollection features, String message) {
        if (features == null || features.size() == 0) {
            LOGGER.log(Level.INFO, "해당지역은 " + message + "과 일치하는 영역이 없습니다.");
            return false;
        }
        return true;
    }

    private Map<Double, Geometry> processUrbanData(SimpleFeatureCollection features, String field) {
        Map<Double, List<Geometry>> map = new HashMap<>();
        final Expression exp = ff.property(field);

        try (SimpleFeatureIterator featureIter = features.features()) {
            while (featureIter.hasNext()) {
                SimpleFeature feature = featureIter.next();
                String val = exp.evaluate(feature, String.class);
                Double key = val.startsWith("UQA4") ? SLOPE_MAX_VALS[0] : SLOPE_MAX_VALS[1];
                Geometry geometry = (Geometry) feature.getDefaultGeometry();
                if (geometry != null && !geometry.isEmpty()) {
                    //map.computeIfAbsent(key, k -> new ArrayList<>()).add(geometry);
                	
                	List<Geometry> geoms = map.get(key); 
                    if (geoms == null) {
                    	geoms = new ArrayList<>(); 
                        map.put(key, geoms);      
                    }
                    geoms.add(geometry);
                }
            }
        }

        Map<Double, Geometry> ret = new HashMap<>();
        for (Map.Entry<Double, List<Geometry>> entry : map.entrySet()) {
            List<Geometry> geometries = entry.getValue();
            Geometry multiPolygon = (geometries.size() == 1) ? geometries.get(0)
                    : FeatureUtils.unionGeometries(geometries);
            if (multiPolygon != null) {
                ret.put(entry.getKey(), multiPolygon);
            }
        }
        return ret;
    }

    private Geometry calculateFeasibleArea(SimpleFeatureCollection demFeatures,
            SimpleFeatureCollection slopeFeatures, SimpleFeatureCollection bioTypes,
            SimpleFeatureCollection bioIndvs, CoordinateReferenceSystem crs) {
        Geometry demGeometry = FeatureUtils.unionGeometries(demFeatures, crs);
        Geometry slopeGeometry = FeatureUtils.unionGeometries(slopeFeatures, crs);
        Geometry bioTypesGeometry = FeatureUtils.unionGeometries(bioTypes, crs);
        Geometry bioIndvsGeometry = FeatureUtils.unionGeometries(bioIndvs, crs);

        Geometry permitGeometry = FeatureUtils.calculateIntersection(demGeometry, slopeGeometry,
                bioTypesGeometry, bioIndvsGeometry);
        if (permitGeometry == null || permitGeometry.isEmpty()) {
            return null;
        }
        permitGeometry = permitGeometry.buffer(0); // tolerance
        permitGeometry.setUserData(crs);

        //System.out.println("개발행위 가능지역 Elapsed time: " + stopWatch.getTimeString());
        return permitGeometry;
    }

    private void generatePermitResult(DevPermitReport result, Geometry permitGeometry,
            GridCoverage2D demCoverage, GridCoverage2D slopeCoverage,
            SimpleFeatureCollection bioTypes, SimpleFeatureCollection bioIndvs,
            CoordinateReferenceSystem outputCRS) {

        CoordinateReferenceSystem gridCRS = demCoverage.getCoordinateReferenceSystem();
        SimpleFeatureCollection permitFc = FeatureUtils.buildFeatures(permitGeometry, "Permit",
                Polygon.class, gridCRS);

        GridCoverage2D permitDem = CoverageUtils.cropCoverage(demCoverage, permitGeometry);
        GridCoverage2D permitSlope = CoverageUtils.cropCoverage(slopeCoverage, permitGeometry);

        SimpleFeatureCollection permitTypes = FeatureUtils.clipFeatures(bioTypes, permitGeometry);
        SimpleFeatureCollection permitIndvs = FeatureUtils.clipFeatures(bioIndvs, permitGeometry);

        result.setGeometry(FeatureUtils.confirmTransform(permitGeometry, gridCRS, outputCRS));
        result.setArea(
                FeatureUtils.confirmTransform(permitGeometry, gridCRS, measureCRS).getArea()); // 면적은 DEM(5179)의 CRS로

        result.setPermit(FeatureUtils.transformFeatures(permitFc, outputCRS));
        result.setMeanDem(getMeanFromCoverage(permitDem));
        result.setMeanSlope(getMeanFromCoverage(permitSlope));

        result.setBiotopeTypesStat(getCategorizedStat(
                FeatureUtils.transformFeatures(permitTypes, measureCRS), "evl_grad"));
        result.setBiotopeIndivisualsStat(getCategorizedStat(
                FeatureUtils.transformFeatures(permitIndvs, measureCRS), "evl_grad"));

        result.setBiotopeTypes(FeatureUtils.transformFeatures(permitTypes, outputCRS));
        result.setBiotopeIndivisuals(FeatureUtils.transformFeatures(permitIndvs, outputCRS));

        result.setStatus(true);

        //System.out.println("분석결과 생성 Elapsed time: " + stopWatch.getTimeString());
    }

    private double getMeanFromCoverage(GridCoverage2D coverage) {
        if (coverage == null)
            return 0.0d;
        DataStatistics dataStat = new DataStatistics();
        StatisticsVisitorResult result = dataStat.getStatistics(coverage, 0);
        return result.getMean();
    }

    private Map<String, Double> getCategorizedStat(SimpleFeatureCollection features, String field) {
        Map<String, Double> map = new TreeMap<>();
        final Expression exp = ff.property(field);

        try (SimpleFeatureIterator featureIter = features.features()) {
            while (featureIter.hasNext()) {
                SimpleFeature feature = featureIter.next();
                String key = exp.evaluate(feature, String.class);
                Geometry geometry = (Geometry) feature.getDefaultGeometry();
                if (geometry != null && !geometry.isEmpty()) {
                    //map.merge(key, geometry.getArea(), Double::sum);
                	
                	Double area = geometry.getArea();
                	if (map.containsKey(key)) {
                	    map.put(key, map.get(key) + area); 
                	} else {
                	    map.put(key, area); 
                	}
                }
            }
        }
        return map;
    }

    private SimpleFeatureCollection filterFeatures(SimpleFeatureCollection features,
            Geometry maskArea, String cql, CoordinateReferenceSystem targetCRS, boolean clip) {
        Filter filter = createFilter(features, maskArea, cql);
        SimpleFeatureCollection clipped = clip
                ? FeatureUtils.clipFeatures(features.subCollection(filter), maskArea)
                : features.subCollection(filter);
        return (targetCRS != null) ? FeatureUtils.transformFeatures(clipped, targetCRS) : clipped;
    }

    private Filter createFilter(SimpleFeatureCollection features, Geometry maskArea, String cql) {
        Filter filter = Filter.INCLUDE;
        if (maskArea != null && !maskArea.isEmpty()) {
            String geomField = features.getSchema().getGeometryDescriptor().getLocalName();
            filter = ff.and(ff.bbox(ff.property(geomField), JTS.toEnvelope(maskArea)),
                    ff.intersects(ff.property(geomField), ff.literal(maskArea)));
        }

        if (cql != null && !cql.isEmpty()) {
            try {
                filter = ff.and(filter, CQL.toFilter(cql));
            } catch (CQLException e) {
                LOGGER.log(Level.SEVERE, "CQL parsing error: ", e);
            }
        }
        return filter;
    }

//    public static void main(String[] args) throws Exception {
//        System.setProperty("org.geotools.referencing.forceXY", "true");
//
//        DataStore dataStore = connectToDataStore();
//        if (dataStore == null) {
//            throw new IOException("Could not connect to the database.");
//        }
//
//        SimpleFeatureCollection urbanAreaFeatures = loadFeatures(dataStore, "lsmd_cont_uq111");
//        SimpleFeatureCollection biotopeTypeFeatures = loadFeatures(dataStore,
//                "eclgy_sttus_btp_ty_evl");
//        SimpleFeatureCollection biotopeIndvFeatures = loadFeatures(dataStore,
//                "eclgy_sttus_indvdlz_btp_evl");
//
//        String demFile = "E:\\Project_Documents\\2024년\\SH\\SHEX\\data\\dem_seoul.tif";
//        String slopeFile = "E:\\Project_Documents\\2024년\\SH\\SHEX\\data\\slope_seoul.tif";
//
//        GridCoverage2D demCoverage = RasterHelper.openGeoTiffFile(demFile);
//        GridCoverage2D slopeCoverage = RasterHelper.openGeoTiffFile(slopeFile);
//        CoordinateReferenceSystem crs = demCoverage.getCoordinateReferenceSystem();
//
//        Point ll = gf.createPoint(new Coordinate(126.99117, 37.56507));
//        Point ur = gf.createPoint(new Coordinate(127.00014, 37.57187));
//
//        ReferencedEnvelope extent = new ReferencedEnvelope(126.99117, 127.00014, 37.56507, 37.57187,
//                crs);
//        Geometry maskArea = JTS.toGeometry(extent);
//        maskArea = ur.buffer(0.01, 24);
//
//        stopWatch.reset();
//
//        DevPermitAnalysisOp process = new DevPermitAnalysisOp();
//        DevPermitReport ret = process.execute(maskArea, crs, demCoverage, slopeCoverage,
//                urbanAreaFeatures, biotopeTypeFeatures, biotopeIndvFeatures);
//
//        System.out.println("Area: " + ret.getArea());
//        System.out.println("Geometry - Points: " + ret.getGeometry().getNumPoints());
//        for (Entry<String, Double> entry : ret.getBiotopeTypesStat().entrySet()) {
//            System.out.println("BiotopeTypes: " + entry);
//        }
//
//        for (Entry<String, Double> entry : ret.getBiotopeIndivisualsStat().entrySet()) {
//            System.out.println("BiotopeIndivisuals: " + entry);
//        }
//
//        System.out.println("Elapsed time: " + stopWatch.getTimeString());
//    }

//    private static DataStore connectToDataStore() throws IOException {
//        Map<String, Object> params = new HashMap<>();
//        params.put("dbtype", "postgis");
//        params.put("host", "dev.syesd.co.kr");
//        params.put("port", 5466);
//        params.put("database", "shgis");
//        params.put("schema", "landsys_gis");
//        params.put("user", "shgis");
//        params.put("passwd", "shgis");
//
//        return DataStoreFinder.getDataStore(params);
//    }
//
//    private static SimpleFeatureCollection loadFeatures(DataStore dataStore, String tableName)
//            throws IOException {
//        return dataStore.getFeatureSource(tableName).getFeatures();
//    }
}
