package egovframework.mango.analysis.cmmn.service;

import java.awt.image.BufferedImage;
import java.util.HashMap;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.geotools.coverage.grid.GridCoverage2D;
import org.geotools.data.DataStore;
import org.geotools.data.collection.ListFeatureCollection;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.factory.CommonFactoryFinder;
import org.geotools.feature.simple.SimpleFeatureBuilder;
import org.geotools.feature.simple.SimpleFeatureTypeBuilder;
import org.geotools.geometry.jts.ReferencedEnvelope;
import org.geotools.map.FeatureLayer;
import org.geotools.map.GridCoverageLayer;
import org.geotools.map.MapContent;
import org.geotools.process.spatialstatistics.BufferExpressionProcessFactory;
import org.geotools.process.spatialstatistics.KernelDensityProcessFactory;
import org.geotools.process.spatialstatistics.MultipleRingBufferProcessFactory;
import org.geotools.process.spatialstatistics.PointStatisticsProcessFactory;
import org.geotools.process.spatialstatistics.RasterToImageProcessFactory;
import org.geotools.process.spatialstatistics.ReprojectProcess;
import org.geotools.process.spatialstatistics.core.FeatureTypes;
import org.geotools.process.spatialstatistics.core.MapToImageParam;
import org.geotools.process.spatialstatistics.enumeration.KernelType;
import org.geotools.referencing.CRS;
import org.geotools.renderer.GTRenderer;
import org.geotools.styling.Style;
import org.json.simple.JSONArray;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.LinearRing;
import org.locationtech.jts.geom.Polygon;
import org.opengis.filter.Filter;
import org.opengis.filter.FilterFactory2;
import org.opengis.referencing.crs.CoordinateReferenceSystem;
import org.opengis.referencing.operation.MathTransform;
import org.springframework.stereotype.Service;

import egovframework.mango.config.SHDataStore;
import egovframework.mango.util.SHImageHelper;
import egovframework.mango.util.SHJsonHelper;
import egovframework.mango.util.Util;

@Service
public class AnalysisCmmnService {

	private static Logger logger = LogManager.getLogger(AnalysisCmmnService.class);

	public JSONArray getBufferFeatures(String exportId, String schema, String inputFeatures, String distance, String distanceUnit,
			boolean outsideOnly, boolean dissolve) throws NullPointerException, Exception {

		DataStore dataStore = null;
		JSONArray ja = new JSONArray();
		try {
			dataStore = SHDataStore.getNewDataStore(schema);
			SimpleFeatureCollection sfc = dataStore.getFeatureSource(inputFeatures).getFeatures();

			//
			MultipleRingBufferProcessFactory factory = new MultipleRingBufferProcessFactory();
			org.geotools.process.Process process = factory.create();
			Map<String, Object> param = new HashMap<>();

			param.put(MultipleRingBufferProcessFactory.inputFeatures.key, sfc);
			param.put(MultipleRingBufferProcessFactory.distances.key, distance);
			param.put(MultipleRingBufferProcessFactory.distanceUnit.key, distanceUnit);
			param.put(MultipleRingBufferProcessFactory.outsideOnly.key, outsideOnly);
			param.put(MultipleRingBufferProcessFactory.dissolve.key, dissolve);

			//
			Map<String, Object> resultMap = process.execute(param, null);

			//
			SimpleFeatureCollection resultCollection = (SimpleFeatureCollection) resultMap
					.get(BufferExpressionProcessFactory.RESULT.key);
			
			Util.shpExport(exportId, "result", resultCollection);

			//
			ja = SHJsonHelper.simpleFeatureCollectionToJson(resultCollection);
			Util.mapExport(exportId, "result", ja);
		} finally {
			SHDataStore.dispose(dataStore);
		}
		return ja;
	}

	public GridCoverage2D getDensity(String exportId, String schema, String inputFeatures, KernelType kernelType, String populationField,
			String searchRadius, double cellSize, Double minX, Double maxX, Double minY, Double maxY) throws NullPointerException, Exception {

		DataStore dataStore = null;
		GridCoverage2D result = null;
		try {
			dataStore = SHDataStore.getNewDataStore(schema);

			SimpleFeatureCollection sfc = dataStore.getFeatureSource(inputFeatures).getFeatures();
			Filter filter = null;

			ReferencedEnvelope env = null;
			CoordinateReferenceSystem sourceCrs = CRS.decode("EPSG:4326");
			CoordinateReferenceSystem targetCrs = CRS.decode("EPSG:3857");
			if (minX != null && maxX != null && minY != null && maxY != null) {
				double dminx = 0, dmaxx = 0, dminy = 0, dmaxy = 0;
				dminx = minX;
				dmaxx = maxX;
				dminy = minY;
				dmaxy = maxY;

				double[] sourcePoints = new double[4];
				double[] targetPoints = new double[4];
				sourcePoints[0] = minX;
				sourcePoints[1] = minY;
				sourcePoints[2] = maxX;
				sourcePoints[3] = maxY;

				MathTransform mt = CRS.findMathTransform(sourceCrs, targetCrs);
				mt.transform(sourcePoints, 0, targetPoints, 0, 2);

				env = new ReferencedEnvelope(targetPoints[0], targetPoints[2], targetPoints[1], targetPoints[3],
						targetCrs);
				GeometryFactory geometryFactory = new GeometryFactory();

				Coordinate[] coordinates = new Coordinate[] { new Coordinate(dminx, dminy),
						new Coordinate(dminx, dmaxy), new Coordinate(dmaxx, dmaxy), new Coordinate(dmaxx, dminy),
						new Coordinate(dminx, dminy) };

				LinearRing linearRing = geometryFactory.createLinearRing(coordinates);

				Polygon polygon = geometryFactory.createPolygon(linearRing, null);

				FilterFactory2 ff = CommonFactoryFinder.getFilterFactory2(null);
				Filter intersects = ff.intersects(ff.property("the_geom"), ff.literal(polygon));

				sfc = sfc.subCollection(intersects);

			}

			sfc = ReprojectProcess.process(sfc, sourceCrs, targetCrs, null);

			//
			KernelDensityProcessFactory factory = new KernelDensityProcessFactory();
			org.geotools.process.Process process = factory.create();
			Map<String, Object> param = new HashMap<>();

//		ReferencedEnvelope extent = null;
//				
//		if (minX != null && maxX != null && minY != null && maxY != null) {
//			double dminx = 0, dmaxx = 0, dminy =0, dmaxy = 0;
//			dminx = Double.parseDouble(minX);
//			dmaxx = Double.parseDouble(maxX);
//			dminy = Double.parseDouble(minY);
//			dmaxy = Double.parseDouble(maxY);
//			extent = new ReferencedEnvelope(dminx, dmaxx, dminy, dmaxy, sfc.getSchema().getCoordinateReferenceSystem());			
//		}

			param.put(KernelDensityProcessFactory.inputFeatures.key, sfc);
			param.put(KernelDensityProcessFactory.populationField.key, populationField);
			param.put(KernelDensityProcessFactory.kernelType.key, kernelType);
			param.put(KernelDensityProcessFactory.cellSize.key, cellSize);
			param.put(KernelDensityProcessFactory.searchRadius.key, searchRadius);
			param.put(KernelDensityProcessFactory.extent.key, env);

			//
			Map<String, Object> resultMap = process.execute(param, null);

			//
			result = (GridCoverage2D) resultMap.get(KernelDensityProcessFactory.RESULT.key);
			Util.tiffExport(exportId, "result", result);

			//
			// JSONArray ja = SHJsonHelper.simpleFeatureCollectionToJson(result);
		} finally {
			SHDataStore.dispose(dataStore);
		}
		return result;
	}

	public BufferedImage getImage(GridCoverage2D coverage, String bbox, CoordinateReferenceSystem crs, Style style,
			Integer width, Integer height, String format, Boolean transparent, String bgColor) throws NullPointerException, Exception {

		RasterToImageProcessFactory factory = new RasterToImageProcessFactory();
		org.geotools.process.Process process = factory.create();
		Map<String, Object> param = new HashMap<>();

		param.put(RasterToImageProcessFactory.coverage.key, coverage);
		param.put(RasterToImageProcessFactory.bbox.key, bbox);
		param.put(RasterToImageProcessFactory.crs.key, crs);
		param.put(RasterToImageProcessFactory.style.key, style);
		param.put(RasterToImageProcessFactory.width.key, width);
		param.put(RasterToImageProcessFactory.height.key, height);
		param.put(RasterToImageProcessFactory.format.key, format);
		param.put(RasterToImageProcessFactory.transparent.key, transparent);
		param.put(RasterToImageProcessFactory.bgColor.key, bgColor);

		Map<String, Object> resultMap = process.execute(param, null);

		MapToImageParam mapImage = (MapToImageParam) resultMap.get(RasterToImageProcessFactory.RESULT.key);

		BufferedImage result = SHImageHelper.getBufferedImage(mapImage);

		return result;
	}

	public JSONArray getPointStatistics(String exportId, String inputSchema, String overlaySchema, String polygonFeatures, String pointFeatures, String countField,
			String statisticsFields) throws NullPointerException, Exception {

		DataStore dataStore = null;
		DataStore tgdataStore = null;
		JSONArray ja = new JSONArray();
		try {
			dataStore = SHDataStore.getNewDataStore(inputSchema);
			tgdataStore = SHDataStore.getNewDataStore(overlaySchema);
			SimpleFeatureCollection polygon = dataStore.getFeatureSource(polygonFeatures).getFeatures();
			SimpleFeatureCollection point = tgdataStore.getFeatureSource(pointFeatures).getFeatures();

			//
			PointStatisticsProcessFactory factory = new PointStatisticsProcessFactory();
			org.geotools.process.Process process = factory.create();
			Map<String, Object> param = new HashMap<>();

			param.put(PointStatisticsProcessFactory.polygonFeatures.key, polygon);
			param.put(PointStatisticsProcessFactory.pointFeatures.key, point);
			param.put(PointStatisticsProcessFactory.countField.key, countField);
			param.put(PointStatisticsProcessFactory.statisticsFields.key, statisticsFields + "." + countField);

			//
			Map<String, Object> resultMap = process.execute(param, null);

			//
			SimpleFeatureCollection resultCollection = (SimpleFeatureCollection) resultMap
					.get(PointStatisticsProcessFactory.RESULT.key);
			
			Util.shpExport(exportId, "result", resultCollection);

			//
			ja = SHJsonHelper.simpleFeatureCollectionToJson(resultCollection);
			Util.mapExport(exportId, "result", ja);
		} finally {
			SHDataStore.dispose(dataStore);
			SHDataStore.dispose(tgdataStore);
		}
		return ja;
	}

}
