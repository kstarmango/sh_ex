package egovframework.mango.analysis.developer.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.geotools.coverage.grid.GridCoverage2D;
import org.geotools.data.DataStore;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.geometry.jts.JTS;
import org.geotools.process.spatialstatistics.HistogramGridCoverageProcessFactory;
import org.geotools.process.spatialstatistics.RasterClipByGeometryProcessFactory;
import org.geotools.process.spatialstatistics.RasterReclassProcessFactory;
import org.geotools.process.spatialstatistics.RasterSlopeProcessFactory;
import org.geotools.process.spatialstatistics.core.DataStatistics;
import org.geotools.process.spatialstatistics.core.HistogramProcessResult;
import org.geotools.process.spatialstatistics.core.HistogramProcessResult.HistogramItem;
import org.geotools.process.spatialstatistics.core.StatisticsVisitorResult;
import org.geotools.process.spatialstatistics.enumeration.SlopeType;
import org.geotools.process.spatialstatistics.gridcoverage.RasterHelper;
import org.geotools.referencing.CRS;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.io.WKTReader;
import org.opengis.referencing.crs.CoordinateReferenceSystem;
import org.opengis.referencing.operation.MathTransform;
import org.springframework.stereotype.Service;

import egovframework.mango.analysis.process.DevPermitAnalysisProcess;
import egovframework.mango.analysis.process.DevPermitReport;
import egovframework.mango.config.SHDataStore;
import egovframework.mango.config.SHResource;
import egovframework.mango.util.SHJsonHelper;
import egovframework.mango.util.Util;

@Service
public class AnalysisDeveloperService {
	public GridCoverage2D rasterSlope(String exportId, GridCoverage2D inputCoverage, Geometry geom, SlopeType slopeType, double zFactor)
			throws NullPointerException, Exception {

		Map<String, Object> resultMap = executeSlope(inputCoverage, geom, slopeType, zFactor);

		//
		GridCoverage2D result = (GridCoverage2D) resultMap.get(RasterSlopeProcessFactory.RESULT.key);
		Util.tiffExport(exportId, "result", result);
		//
		// JSONArray ja = SHJsonHelper.simpleFeatureCollectionToJson(result);

//		SHDataStore.dispose(dataStore);
		rasterSlopeResult(exportId, inputCoverage, geom, slopeType, zFactor);
		return result;
	}

	public Map<String, Object> rasterSlopeResult(String exportId, GridCoverage2D inputCoverage, Geometry geom, SlopeType slopeType,
			double zFactor) throws NullPointerException, Exception {

		Map<String, Object> resultMap = executeSlope(inputCoverage, geom, slopeType, zFactor);

		GridCoverage2D coverage = (GridCoverage2D) resultMap.get(RasterSlopeProcessFactory.RESULT.key);

		DataStatistics statistics = new DataStatistics();
		StatisticsVisitorResult ret = statistics.getStatistics(coverage, 0);
		double minimum = ret.getMinimum();
		double maximum = ret.getMaximum();
		double mean = ret.getMean();

		Map<String, Object> result = new HashMap<>();

		result.put("min", minimum);
		result.put("max", maximum);
		result.put("mean", mean);

		// 재분류
		RasterReclassProcessFactory reFactory = new RasterReclassProcessFactory();
		org.geotools.process.Process reProcess = reFactory.create();
		Map<String, Object> reParam = new HashMap<>();

		String ranges = "0.0 10.0 10; 10.0 20.0 20; 20.0 30.0 30; 30.0 40.0 40; 40.0 50.0 50; 50.0 60.0 60; 60.0 70.0 70; 70.0 80.0 80; 80.0 90.0 90";

		reParam.put(RasterReclassProcessFactory.inputCoverage.key, coverage);
		reParam.put(RasterReclassProcessFactory.bandIndex.key, (int) minimum);
		reParam.put(RasterReclassProcessFactory.ranges.key, ranges);
		reParam.put(RasterReclassProcessFactory.retainMissingValues.key, true);

		Map<String, Object> reResult = reProcess.execute(reParam, null);

		GridCoverage2D reCoverage = (GridCoverage2D) reResult.get(RasterReclassProcessFactory.RESULT.key);
		Util.tiffExport(exportId, "result", reCoverage);

		HistogramGridCoverageProcessFactory hFactory = new HistogramGridCoverageProcessFactory();
		org.geotools.process.Process hProcess = hFactory.create();
		Map<String, Object> hParam = new HashMap<>();

		hParam.put(HistogramGridCoverageProcessFactory.inputCoverage.key, reCoverage);
		hParam.put(HistogramGridCoverageProcessFactory.bandIndex.key, 0);

		Map<String, Object> hResult = hProcess.execute(hParam, null);
		HistogramProcessResult hpr = (HistogramProcessResult) hResult.get("result");
		String cellSizeStr = hpr.getCellSize();
		//A5179≈A×0.793
		double area3857To5179 = 0.793;
		double cellSize = Double.parseDouble(cellSizeStr);
		List<HistogramItem> items =hpr.getHistogramItems();
		for(HistogramItem item : items) {
			int frequency = item.getFrequency();
			double area = (cellSize * cellSize * area3857To5179) * frequency ;
			item.setFrequency((int) Math.floor(area));
		}
		result.put("result", hpr);
		Util.mapExport(exportId, "result", result);
		return result;
	}

	public Map<String, Object> executeSlope(GridCoverage2D inputCoverage, Geometry geom, SlopeType slopeType,
			double zFactor) throws NullPointerException, Exception {
		// Crop Coverage 실행
		RasterClipByGeometryProcessFactory cropFactory = new RasterClipByGeometryProcessFactory();
		org.geotools.process.Process cropProcess = cropFactory.create();
		Map<String, Object> cropParam = new HashMap<>();

		CoordinateReferenceSystem crs = inputCoverage.getCoordinateReferenceSystem();

//		CoordinateReferenceSystem sourceCRS = CRS.decode("EPSG:3857");
//		MathTransform transform = CRS.findMathTransform(sourceCRS, crs, true);
//		
//		geom = JTS.transform(geom, transform);
//		geom.setUserData(crs);

		cropParam.put(RasterClipByGeometryProcessFactory.inputCoverage.key, inputCoverage);
		cropParam.put(RasterClipByGeometryProcessFactory.cropShape.key, geom);
		Map<String, Object> cropResult = cropProcess.execute(cropParam, null);

//		GridCoverage2D cropCoverage = (GridCoverage2D) cropResult
//				.get(RasterClipByGeometryProcessFactory.RESULT.key);
//		
//		
//		// 경사도 분석 실행 
//		RasterSlopeProcessFactory sFactory = new RasterSlopeProcessFactory();
//		org.geotools.process.Process sProcess = sFactory.create();
//		Map<String, Object> sParam = new HashMap<>();
//		
//		
//		sParam.put(RasterSlopeProcessFactory.inputCoverage.key, cropCoverage);
//		sParam.put(RasterSlopeProcessFactory.slopeType.key, slopeType);
//		sParam.put(RasterSlopeProcessFactory.zFactor.key, zFactor);
//
//		//
//		Map<String, Object> sResult = sProcess.execute(sParam, null);

		return cropResult;
	}

	public Map<String, Object> analysisDevelopment(String exportId, String userArea) throws NullPointerException, Exception {

		URIBuilder uriBuilder = new URIBuilder().setScheme(SHResource.getValue("sh.server.schema"))
				.setHost(SHResource.getValue("sh.server.url")).setPath("/shex/api/develop/availResult")
				.addParameter("userArea", userArea);

		CloseableHttpClient httpClient = HttpClients.createDefault();
		HttpPost request = new HttpPost(uriBuilder.toString());
		request.addHeader("export_key", exportId);

		HttpResponse response = httpClient.execute(request);

		String resultS = EntityUtils.toString(response.getEntity(), "utf-8");

		JSONParser jsonParser = new JSONParser();
		JSONObject targetObj = (JSONObject) jsonParser.parse(resultS);

		Map<String, Object> data = (Map<String, Object>) targetObj.get("DATA");

		Map<String, Object> result = (Map<String, Object>) data.get("result");
		
		Util.mapExport(exportId, "result", result);

		return result;
	}
	
	public Map<String, Object> analysisDevelopmentNew(String exportId, String userAreaStr) throws NullPointerException, Exception {

		DataStore dataStore = null;
		Map<String, Object> returnMap = new HashMap<>();
		try {

			dataStore = SHDataStore.getNewDataStore("landsys_gis");

			SimpleFeatureCollection urbanAreaFeatures = dataStore.getFeatureSource("lsmd_cont_uq111").getFeatures();
			SimpleFeatureCollection biotopeTypeFeatures = dataStore.getFeatureSource("eclgy_sttus_btp_ty_evl")
					.getFeatures();
			SimpleFeatureCollection biotopeIndvFeatures = dataStore.getFeatureSource("eclgy_sttus_indvdlz_btp_evl")
					.getFeatures();

			String demFile = SHResource.getValue("dev.dem.file.path");
			String slopeFile = SHResource.getValue("dev.slope.file.path");

			GridCoverage2D demCoverage = RasterHelper.openGeoTiffFile(demFile);
			GridCoverage2D slopeCoverage = RasterHelper.openGeoTiffFile(slopeFile);
			CoordinateReferenceSystem crs = demCoverage.getCoordinateReferenceSystem();

			CoordinateReferenceSystem userAreaCrs = CRS.decode("EPSG:3857");

			WKTReader reader = new WKTReader();
			Geometry userArea = reader.read(userAreaStr);
			
			userArea = Util.transform(userAreaCrs, crs, userArea);

			DevPermitAnalysisProcess process = new DevPermitAnalysisProcess();
			DevPermitReport ret = process.execute(userArea, crs, demCoverage, slopeCoverage, urbanAreaFeatures,
					biotopeTypeFeatures, biotopeIndvFeatures);

			List<Entry<String, Double>> bioTypeList = new ArrayList<>();
			returnMap.put("BiotopeTypes", bioTypeList);
			for (Entry<String, Double> entry : ret.getBiotopeTypesStat().entrySet()) {
//				System.out.println("BiotopeTypes: " + entry);
				double val = entry.getValue();
				val = Math.round(val * 100.) / 100.;
				entry.setValue(val);
				bioTypeList.add(entry);
			}

			List<Entry<String, Double>> bioIndList = new ArrayList<>();
			returnMap.put("BiotopeIndivisuals", bioIndList);
			for (Entry<String, Double> entry : ret.getBiotopeIndivisualsStat().entrySet()) {
//				System.out.println("BiotopeIndivisuals: " + entry);
				double val = entry.getValue();
				val = Math.round(val * 100.) / 100.;
				entry.setValue(val);
				bioIndList.add(entry);
			}

			JSONParser jp = new JSONParser();

			returnMap.put("status", ret.getStatus()); // 분석 상태
			double val = ret.getArea();
			val = Math.round(val * 100.) / 100.;
			ret.setArea(val);
			returnMap.put("area", ret.getArea()); // 개발행위 가능지역 면적
			returnMap.put("geometry", jp.parse(SHJsonHelper.geometryToGeoJson(ret.getGeometry()))); // 개발행위 가능지역 지오메트리
			returnMap.put("permit", jp.parse(SHJsonHelper.featureCollectionToGeoJson(ret.getPermit()))); // 개발행위 가능지역
																											// 레이어
			Util.shpExport(exportId, "permit", ret.getPermit());
			
			val = ret.getMeanDem();
			val = Math.round(val * 100.) / 100.;
			ret.setMeanDem(val);
			returnMap.put("meanDem", ret.getMeanDem()); // 개발행위 가능지역 내 평균 표고
			val = ret.getMeanSlope();
			val = Math.round(val * 100.) / 100.;
			ret.setMeanSlope(val);
			returnMap.put("meanSlope", ret.getMeanSlope()); // 개발행위 가능지역 내 평균 경사도
			
			SimpleFeatureCollection bioTypeSfc = ret.getBiotopeTypes();
			if(bioTypeSfc != null) {
				String bioTypeJson = SHJsonHelper.featureCollectionToGeoJson(bioTypeSfc);
				returnMap.put("biotopeTypes", jp.parse(bioTypeJson)); 
			}
			Util.shpExport(exportId, "biotopeTypes", ret.getBiotopeTypes());
			
			SimpleFeatureCollection bioIndiSfc = ret.getBiotopeIndivisuals();
			if(bioIndiSfc != null) {
				String bioIndiJson = SHJsonHelper.featureCollectionToGeoJson(bioIndiSfc);
				returnMap.put("biotopeIndivisuals", jp.parse(bioIndiJson)); 
			}
			Util.shpExport(exportId, "biotopeIndivisuals", ret.getBiotopeIndivisuals());
			Util.mapExport(exportId, "result.txt", returnMap);
			
		} finally {
			SHDataStore.dispose(dataStore);
		}
		return returnMap;
	}
}
