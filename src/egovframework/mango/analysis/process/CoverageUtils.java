package egovframework.mango.analysis.process;

import java.awt.geom.AffineTransform;
import java.awt.geom.NoninvertibleTransformException;
import java.awt.image.RenderedImage;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.media.jai.JAI;
import javax.media.jai.ROI;
import javax.media.jai.RenderedOp;

import org.geotools.coverage.Category;
import org.geotools.coverage.CoverageFactoryFinder;
import org.geotools.coverage.GridSampleDimension;
import org.geotools.coverage.grid.GridCoverage2D;
import org.geotools.coverage.grid.GridCoverageFactory;
import org.geotools.data.collection.ListFeatureCollection;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.feature.simple.SimpleFeatureBuilder;
import org.geotools.geometry.jts.JTS;
import org.geotools.image.ImageWorker;
import org.geotools.image.jai.Registry;
import org.geotools.image.util.ColorUtilities;
import org.geotools.process.ProcessException;
import org.geotools.process.spatialstatistics.core.FeatureTypes;
import org.geotools.process.spatialstatistics.gridcoverage.RasterCropOperation;
import org.geotools.process.spatialstatistics.gridcoverage.RasterHelper;
import org.geotools.referencing.CRS;
import org.geotools.referencing.operation.transform.AffineTransform2D;
import org.geotools.util.ClassChanger;
import org.geotools.util.factory.GeoTools;
import org.geotools.util.logging.Logging;
import org.jaitools.media.jai.rangelookup.RangeLookupTable;
import org.jaitools.media.jai.vectorize.VectorizeDescriptor;
import org.jaitools.media.jai.vectorize.VectorizeOpImage;
import org.jaitools.media.jai.vectorize.VectorizeRIF;
import org.jaitools.numeric.Range;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Polygon;
import org.locationtech.jts.geom.util.AffineTransformation;
import org.locationtech.jts.operation.overlayng.CoverageUnion;
import org.locationtech.jts.operation.union.CascadedPolygonUnion;
import org.locationtech.jts.simplify.DouglasPeuckerSimplifier;
import org.opengis.coverage.grid.GridCoverage;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;
import org.opengis.geometry.MismatchedDimensionException;
import org.opengis.metadata.spatial.PixelOrientation;
import org.opengis.referencing.FactoryException;
import org.opengis.referencing.crs.CoordinateReferenceSystem;
import org.opengis.referencing.operation.MathTransform;
import org.opengis.referencing.operation.TransformException;

import it.geosolutions.jaiext.JAIExt;
import it.geosolutions.jaiext.range.NoDataContainer;
import it.geosolutions.jaiext.range.RangeFactory;
import it.geosolutions.jaiext.vectorbin.ROIGeometry;

/**
 * Coverage2D Utilities
 * 
 * A utility class for handling GridCoverage2D operations. 
 * Provides functionality for cropping, vectorizing, and reclassifying raster data.
 * 
 * @author MangoSystem
 */
public class CoverageUtils {
    protected static final Logger LOGGER = Logging.getLogger(CoverageUtils.class);

    private static final double NODATA = -9999.0d;

    static {
        JAIExt.initJAIEXT();
        Registry.registerRIF(JAI.getDefaultInstance(), new VectorizeDescriptor(),
                new VectorizeRIF(), Registry.JAI_TOOLS_PRODUCT);
    }

    public static Range<Double> toRange(double minValue, double maxValue, boolean minIncluded,
            boolean maxIncluded) {
        return new Range<>(minValue, minIncluded, maxValue, maxIncluded);
    }

    public static List<Range<Double>> getRange(double minValue, double maxValue,
            boolean minIncluded, boolean maxIncluded) {
        List<Range<Double>> ranges = new ArrayList<>();
        ranges.add(toRange(minValue, maxValue, minIncluded, maxIncluded));
        return ranges;
    }

    public static int[] getPixelValues(List<Range<Double>> ranges, int value) {
        return getPixelValues(ranges, value, 0);
    }

    public static int[] getPixelValues(List<Range<Double>> ranges, int initValue, int increment) {
        int[] pixelValues = new int[ranges.size()];
        int value = initValue;
        for (int index = 0; index < ranges.size(); index++) {
            pixelValues[index] = value;
            value += increment;
        }
        return pixelValues;
    }

    public static GridCoverage2D cropCoverage(GridCoverage2D inputCoverage, Geometry cropShape) {
        if (cropShape == null) {
            return inputCoverage;
        }

        GridCoverage2D cropped = null;
        try {
            cropShape = transformToCoverageCRS(inputCoverage, cropShape);
            RasterCropOperation cropOperation = new RasterCropOperation();
            cropped = cropOperation.execute(inputCoverage, cropShape);
        } catch(NullPointerException e) {
        	LOGGER.log(Level.SEVERE, "Error croping  coverage: ", e);
		} catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error croping  coverage: ", e);
        }
        return cropped;
    }

    private static Geometry transformToCoverageCRS(GridCoverage2D inputCoverage,
            Geometry cropShape) {
        Object userData = cropShape.getUserData();
        CoordinateReferenceSystem targetCRS = inputCoverage.getCoordinateReferenceSystem();
        if (userData instanceof CoordinateReferenceSystem
                && !CRS.equalsIgnoreMetadata((CoordinateReferenceSystem) userData, targetCRS)) {
            try {
                MathTransform transform = CRS
                        .findMathTransform((CoordinateReferenceSystem) userData, targetCRS, true);
                cropShape = JTS.transform(cropShape, transform);
                cropShape.setUserData(targetCRS);
            } catch(NullPointerException e) {
            	LOGGER.log(Level.SEVERE, "Error croping  coverage: ", e);
    		}  catch (FactoryException | MismatchedDimensionException | TransformException e) {
                LOGGER.log(Level.WARNING, "Error transforming crop shape: ", e);
            }
        }
        return cropShape;
    }

    public static SimpleFeatureCollection vectorize(GridCoverage2D coverage, int bandIndex,
            Boolean insideEdges, List<Range<Double>> ranges, int[] pixelValues) {
        return vectorize(coverage, bandIndex, insideEdges, ranges, pixelValues, null);
    }

    public static SimpleFeatureCollection vectorize(GridCoverage2D coverage, int bandIndex,
            Boolean insideEdges, List<Range<Double>> ranges, int[] pixelValues,
            Geometry roiGeometry) {
        coverage = prepareCoverageForVectorization(coverage, bandIndex, ranges, pixelValues);

        RenderedImage source = coverage.getRenderedImage();
        AffineTransform mt2D = (AffineTransform) coverage.getGridGeometry()
                .getGridToCRS2D(PixelOrientation.UPPER_LEFT);
        AffineTransformation trans = new AffineTransformation(mt2D.getScaleX(), mt2D.getShearX(),
                mt2D.getTranslateX(), mt2D.getShearY(), mt2D.getScaleY(), mt2D.getTranslateY());

        ROI roi = (roiGeometry != null && !roiGeometry.isEmpty()) ? prepareROI(roiGeometry, mt2D)
                : null;
        List<Geometry> polygons = vectorizeSourceImage(source, bandIndex, insideEdges, roi);

        return buildFeatureCollection(polygons, trans, coverage.getCoordinateReferenceSystem());
    }

    private static GridCoverage2D prepareCoverageForVectorization(GridCoverage2D coverage,
            int bandIndex, List<Range<Double>> ranges, int[] pixelValues) {
        Double noData = RasterHelper.getNoDataValue(coverage);
        boolean hasClassificationRanges = ranges != null && !ranges.isEmpty();
        if (hasClassificationRanges) {
            coverage = reclass(coverage, bandIndex, ranges, pixelValues, noData);
        }
        return coverage;
    }

    private static List<Geometry> vectorizeSourceImage(RenderedImage source, int bandIndex,
            Boolean insideEdges, ROI roi) {
        final double filterThreshold = 0.0d;
        final int filterMethod = 0;
        List<Double> outsideValues = new ArrayList<>(Collections.singletonList(NODATA));
        VectorizeOpImage opImage = new VectorizeOpImage(source, roi, bandIndex, outsideValues,
                insideEdges, true, filterThreshold, filterMethod);
        return opImage.getAttribute(VectorizeDescriptor.VECTOR_PROPERTY_NAME);
    }

    private static SimpleFeatureCollection buildFeatureCollection(List<Geometry> polygons,
            AffineTransformation trans, CoordinateReferenceSystem crs) {
        SimpleFeatureType featureType = FeatureTypes.getDefaultType("Polygons", Polygon.class, crs);
        featureType = FeatureTypes.add(featureType, "id", Integer.class);
        featureType = FeatureTypes.add(featureType, "value", Integer.class);

        SimpleFeatureBuilder builder = new SimpleFeatureBuilder(featureType);
        ListFeatureCollection featureCollection = new ListFeatureCollection(featureType);
        Map<Integer, List<Geometry>> map = new HashMap<>();

        for (Geometry polygon : polygons) {
            Integer key = ((Double) polygon.getUserData()).intValue();
            if (key == 0)
                continue; // NoData

            polygon.setUserData(null);
            polygon.apply(trans);
            if (polygon.isEmpty())
                continue;

            //map.computeIfAbsent(key, k -> new ArrayList<>()).add(polygon);
            
            List<Geometry> geoms = map.get(key); 
            if (geoms == null) {
            	geoms = new ArrayList<>(); 
                map.put(key, geoms);      
            }
            geoms.add(polygon);
        }

        int id = 1;
        for (Map.Entry<Integer, List<Geometry>> entry : map.entrySet()) {
            List<Geometry> geometries = entry.getValue();
            Geometry multiPolygon = (geometries.size() == 1) ? geometries.get(0)
                    : unionGeometries(geometries);
            if (multiPolygon != null) {
                SimpleFeature feature = builder.buildFeature("Polygons." + id++);
                feature.setDefaultGeometry(multiPolygon);
                feature.setAttribute("id", id);
                feature.setAttribute("value", entry.getKey());
                featureCollection.add(feature);
            }
        }
        return featureCollection;
    }

    private static Geometry unionGeometries(List<Geometry> geometries) {
        try {
            GeometryFactory gf = geometries.get(0).getFactory();
            Geometry geometry = gf.buildGeometry(geometries);
            return CoverageUnion.union(geometry.buffer(0));
        } catch(NullPointerException e) {
        	LOGGER.log(Level.SEVERE, "Error croping  coverage: ", e);
        	 return CascadedPolygonUnion.union(geometries);
		} catch (Exception e) {
            LOGGER.log(Level.INFO, "Union failed, using cascaded union instead.", e);
            return CascadedPolygonUnion.union(geometries);
        }
    }

    public static ROI prepareROI(Geometry roi, AffineTransform mt2d) throws ProcessException {
        try {
            Geometry rasterSpaceGeometry = JTS.transform(roi,
                    new AffineTransform2D(mt2d.createInverse()));
            Geometry simplifiedGeometry = DouglasPeuckerSimplifier.simplify(rasterSpaceGeometry, 1);
            return new ROIGeometry(simplifiedGeometry);
        } catch(NullPointerException e) {
        	 throw new ProcessException("Failed to prepare ROI.", e);
		} catch (MismatchedDimensionException | NoninvertibleTransformException
                | TransformException e) {
            throw new ProcessException("Failed to prepare ROI.", e);
        }
    }

    public static GridCoverage2D reclass(GridCoverage2D coverage, int bandIndex,
            List<Range<Double>> ranges, int[] pixelValues, double noData) {
        RenderedImage sourceImage = coverage.getRenderedImage();
        ImageWorker worker = new ImageWorker(sourceImage);
        worker.retainBands(new int[] { bandIndex });
        worker.setROI(org.geotools.coverage.util.CoverageUtilities.getROIProperty(coverage));
        worker.setBackground(new double[] { noData });

        Object lookupTable = JAIExt.isJAIExtOperation("RLookup")
                ? getRangeLookupTableJAIEXT(ranges, pixelValues, noData,
                        ColorUtilities.getTransferType(ranges.size()))
                : getRangeLookupTable(ranges, pixelValues, noData);

        RenderedOp indexedClassification = worker.rangeLookup(lookupTable).getRenderedOperation();
        GridSampleDimension outSampleDimension = new GridSampleDimension("classification",
                new Category[] { Category.NODATA }, null);
        GridCoverageFactory factory = CoverageFactoryFinder
                .getGridCoverageFactory(GeoTools.getDefaultHints());

        HashMap<String, Object> properties = new HashMap<>();
        properties.put(NoDataContainer.GC_NODATA, new NoDataContainer(NODATA));
        org.geotools.coverage.util.CoverageUtilities.setROIProperty(properties, worker.getROI());

        return factory.create("Reclassified", indexedClassification, coverage.getGridGeometry(),
                new GridSampleDimension[] { outSampleDimension }, new GridCoverage[] { coverage },
                properties);
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
    private static RangeLookupTable getRangeLookupTable(List<Range<Double>> ranges,
            final int[] pixelValues, final Number noDataValue) {
        RangeLookupTable.Builder rltBuilder = new RangeLookupTable.Builder();
        Class<? extends Number> widestClass = noDataValue.getClass();

        for (int i = 0; i < ranges.size(); i++) {
            Range<Double> range = ranges.get(i);
            widestClass = ClassChanger.getWidestClass(widestClass, range.getMin().getClass());
            int reference = pixelValues != null && pixelValues.length == ranges.size()
                    ? pixelValues[i]
                    : i + 1;
            rltBuilder.add(range, convert(reference, noDataValue.getClass()));
        }

        rltBuilder.add(new Range<>(getClassMinimum(widestClass).doubleValue(), true,
                getClassMaximum(widestClass).doubleValue(), true), noDataValue);
        return rltBuilder.build();
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
    private static it.geosolutions.jaiext.rlookup.RangeLookupTable getRangeLookupTableJAIEXT(
            List<Range<Double>> ranges, final int[] pixelValues, final Number noDataValue,
            final int transferType) {
        it.geosolutions.jaiext.rlookup.RangeLookupTable.Builder rltBuilder = new it.geosolutions.jaiext.rlookup.RangeLookupTable.Builder();
        Class<? extends Number> widestClass = it.geosolutions.jaiext.range.Range.DataType
                .classFromType(transferType);

        for (int i = 0; i < ranges.size(); i++) {
            Range<Double> range = ranges.get(i);
            widestClass = ClassChanger.getWidestClass(widestClass, range.getMin().getClass());
            int reference = pixelValues != null && pixelValues.length == ranges.size()
                    ? pixelValues[i]
                    : i + 1;
            int rangeType = it.geosolutions.jaiext.range.Range.DataType
                    .dataTypeFromClass(range.getMin().getClass());
            it.geosolutions.jaiext.range.Range rangeJaiext = RangeFactory
                    .convert(RangeFactory.create(range.getMin(), range.isMinIncluded(),
                            range.getMax(), range.isMaxIncluded()), rangeType);
            rltBuilder.add(rangeJaiext, convert(reference, widestClass));
        }

        int rangeType = it.geosolutions.jaiext.range.Range.DataType.dataTypeFromClass(widestClass);
        it.geosolutions.jaiext.range.Range rangeJaiext = RangeFactory
                .convert(RangeFactory.create(getClassMinimum(widestClass).doubleValue(),
                        getClassMaximum(widestClass).doubleValue()), rangeType);
        rltBuilder.add(rangeJaiext, noDataValue);

        return rltBuilder.build();
    }

    private static Number getClassMinimum(Class<? extends Number> numberClass) throws UnsupportedOperationException{
        if (numberClass.equals(Double.class))
            return Double.MIN_VALUE;
        if (numberClass.equals(Float.class))
            return Float.MIN_VALUE;
        if (numberClass.equals(Long.class))
            return Long.MIN_VALUE;
        if (numberClass.equals(Integer.class))
            return Integer.MIN_VALUE;
        if (numberClass.equals(Short.class))
            return Short.MIN_VALUE;
        if (numberClass.equals(Byte.class))
            return Byte.MIN_VALUE;
        throw new UnsupportedOperationException(
                "Class " + numberClass + " can't be used in a value Range");
    }

    private static Number getClassMaximum(Class<? extends Number> numberClass)  throws UnsupportedOperationException{
        if (numberClass.equals(Double.class))
            return Double.MAX_VALUE;
        if (numberClass.equals(Float.class))
            return Float.MAX_VALUE;
        if (numberClass.equals(Long.class))
            return Long.MAX_VALUE;
        if (numberClass.equals(Integer.class))
            return Integer.MAX_VALUE;
        if (numberClass.equals(Short.class))
            return Short.MAX_VALUE;
        if (numberClass.equals(Byte.class))
            return Byte.MAX_VALUE;
        throw new UnsupportedOperationException(
                "Class " + numberClass + " can't be used in a value Range");
    }

    private static Number convert(Number val, Class<? extends Number> type)  throws UnsupportedOperationException{
        if (val == null)
            return null;
        if (Double.class.equals(type))
            return val instanceof Double ? val : Double.valueOf(val.doubleValue());
        if (Float.class.equals(type))
            return val instanceof Float ? val : Float.valueOf(val.floatValue());
        if (Integer.class.equals(type))
            return val instanceof Integer ? val : Integer.valueOf(val.intValue());
        if (Byte.class.equals(type))
            return val instanceof Byte ? val : Byte.valueOf(val.byteValue());
        if (Short.class.equals(type))
            return val instanceof Short ? val : Short.valueOf(val.shortValue());
        throw new UnsupportedOperationException(
                "Class " + type + " can't be used in a value Range");
    }
}
