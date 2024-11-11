package egovframework.mango.analysis.biz.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.geotools.data.DataStore;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.factory.CommonFactoryFinder;
import org.geotools.process.Process;
import org.geotools.process.spatialstatistics.BufferExpressionProcessFactory;
import org.geotools.process.spatialstatistics.IntersectProcessFactory;
import org.geotools.process.spatialstatistics.MultipleRingBufferProcessFactory;
import org.geotools.process.spatialstatistics.enumeration.DistanceUnit;
import org.json.simple.JSONArray;
import org.opengis.filter.FilterFactory;
import org.opengis.filter.expression.Expression;
import org.springframework.stereotype.Service;

import egovframework.mango.config.SHDataStore;
import egovframework.mango.util.SHJsonHelper;
import egovframework.mango.util.Util;

@Service
public class AnalysisBizService {

	private static Logger logger = LogManager.getLogger(AnalysisBizService.class);

	public JSONArray getIntersectFeatures(String exportId, String schema, String inputFeatures, String overlayFeatures)
			throws NullPointerException, Exception {

		DataStore dataStore = null;
		JSONArray ja = new JSONArray();
		try {
			dataStore = SHDataStore.getNewDataStore(schema);
			SimpleFeatureCollection sfcInput = dataStore.getFeatureSource(inputFeatures).getFeatures();
			SimpleFeatureCollection sfcOverlay = dataStore.getFeatureSource(overlayFeatures).getFeatures();

			//
			IntersectProcessFactory factory = new IntersectProcessFactory();
			Process process = factory.create();
			Map<String, Object> param = new HashMap<>();

			param.put(IntersectProcessFactory.inputFeatures.key, sfcInput);
			param.put(IntersectProcessFactory.overlayFeatures.key, sfcOverlay);
			//
			Map<String, Object> resultMap = process.execute(param, null);

			//
			SimpleFeatureCollection resultCollection = (SimpleFeatureCollection) resultMap
					.get(IntersectProcessFactory.RESULT.key);

			//
			ja = SHJsonHelper.simpleFeatureCollectionToJson(resultCollection);

			if (exportId != null) {
				Util.shpExport(exportId, "intersects", resultCollection);
			}
		} catch (NullPointerException e) {
			ja = new JSONArray();
			logger.debug(e);
		} catch (Exception e) {
			ja = new JSONArray();
			logger.debug(e);
		} finally {
			SHDataStore.dispose(dataStore);
		}
		return ja;
	}

	// 버퍼 중첩 분석 : 멀티링
	public JSONArray getMultipleRingBufferIntersectFeatures(String exportId, String inputFeatureSchema,
			String inputFeatures, String targetFeatureSchema, String targetFeatures, String distance,
			String distanceUnit, boolean outsideOnly, boolean dissolve) throws NullPointerException, Exception {

		DataStore targetDataStore = null;
		JSONArray ja = new JSONArray();
		try {
			// sourceDataStore = SHDataStore.getDataStore();
			// if (targetFeatureSchema != null) {
			targetDataStore = SHDataStore.getNewDataStore(targetFeatureSchema);
			// }

			// 멀티링 실행
			SimpleFeatureCollection sfcBufferInput = targetDataStore.getFeatureSource(targetFeatures).getFeatures();

			MultipleRingBufferProcessFactory factory = new MultipleRingBufferProcessFactory();
			Process process = factory.create();
			Map<String, Object> param = new HashMap<>();

			param.put(MultipleRingBufferProcessFactory.inputFeatures.key, sfcBufferInput);
			param.put(MultipleRingBufferProcessFactory.distances.key, distance);
			param.put(MultipleRingBufferProcessFactory.distanceUnit.key, distanceUnit);
			param.put(MultipleRingBufferProcessFactory.outsideOnly.key, outsideOnly);
			param.put(MultipleRingBufferProcessFactory.dissolve.key, dissolve);

			Map<String, Object> resultMap = process.execute(param, null);

			SimpleFeatureCollection bufferResultCollection = (SimpleFeatureCollection) resultMap
					.get(MultipleRingBufferProcessFactory.RESULT.key);

			// 중첩 실행
			DataStore inputDataStore = null;
			try {
				// if (inputFeatureSchema != targetFeatureSchema) {
				inputDataStore = SHDataStore.getNewDataStore(inputFeatureSchema);
				// }

				SimpleFeatureCollection sfcIntersectInput = inputDataStore.getFeatureSource(inputFeatures)
						.getFeatures();

				IntersectProcessFactory factory2 = new IntersectProcessFactory();
				Process process2 = factory2.create();
				Map<String, Object> param2 = new HashMap<>();

				param2.put(IntersectProcessFactory.inputFeatures.key, sfcIntersectInput);
				param2.put(IntersectProcessFactory.overlayFeatures.key, bufferResultCollection);

				Map<String, Object> finalMap = process2.execute(param2, null);

				SimpleFeatureCollection resultCollection = (SimpleFeatureCollection) finalMap
						.get(IntersectProcessFactory.RESULT.key);

				Util.shpExport(exportId, "result", sfcIntersectInput);

				ja = SHJsonHelper.simpleFeatureCollectionToJson(resultCollection);
			} catch (NullPointerException e) {
				ja = new JSONArray();
				logger.debug(e);
			} catch (Exception e) {
				ja = new JSONArray();
				logger.debug(e);
			} finally {
				SHDataStore.dispose(inputDataStore);
			}
		} finally {
			SHDataStore.dispose(targetDataStore);
		}
		return ja;
	}

	// 버퍼 중첩 분석 : 교집합 분석
	public List<JSONArray> getBufferIntersectFeatures(String exportId, String inputFeatureSchema, String inputFeatures,
			List<Map<String, Object>> targetList) throws NullPointerException, Exception {

		DataStore sourceDataStore = null;
		List<JSONArray> list = new ArrayList<>();
		try {
			sourceDataStore = SHDataStore.getNewDataStore(inputFeatureSchema);

			SimpleFeatureCollection sfcIntersectInput = sourceDataStore.getFeatureSource(inputFeatures).getFeatures();

			// target이 여러개

			Map<String, Object> targetMap = new HashMap<>();

			for (int i = 0; i < targetList.size(); i++) {
				targetMap = targetList.get(i);
				String schema = (String) targetMap.get("schema");
				String targetLayer = (String) targetMap.get("layer");
				Long distanceLong = (Long) targetMap.get("distance");

				FilterFactory ff = CommonFactoryFinder.getFilterFactory();
				Expression distance = ff.literal(distanceLong);

				DataStore targetDataStore = null;
				try {
					targetDataStore = SHDataStore.getNewDataStore(schema);

					SimpleFeatureCollection sfcBufferInput = targetDataStore.getFeatureSource(targetLayer)
							.getFeatures();

					BufferExpressionProcessFactory factory = new BufferExpressionProcessFactory();
					Process process = factory.create();
					Map<String, Object> param = new HashMap<>();

					param.put(BufferExpressionProcessFactory.inputFeatures.key, sfcBufferInput);
					param.put(BufferExpressionProcessFactory.distance.key, distance);
					param.put(BufferExpressionProcessFactory.distanceUnit.key, DistanceUnit.Meters);

					Map<String, Object> bufferResultMap = process.execute(param, null);

					SimpleFeatureCollection bufferResultCollection = (SimpleFeatureCollection) bufferResultMap
							.get(BufferExpressionProcessFactory.RESULT.key);

					// 중첩분석 진행
					IntersectProcessFactory factory2 = new IntersectProcessFactory();
					Process process2 = factory2.create();
					Map<String, Object> param2 = new HashMap<>();

					param2.put(IntersectProcessFactory.inputFeatures.key, sfcIntersectInput);
					param2.put(IntersectProcessFactory.overlayFeatures.key, bufferResultCollection);

					Map<String, Object> finalMap = process2.execute(param2, null);

					SimpleFeatureCollection resultCollection = (SimpleFeatureCollection) finalMap
							.get(IntersectProcessFactory.RESULT.key);

					Util.shpExport(exportId, targetLayer, resultCollection);

					JSONArray ja = SHJsonHelper.simpleFeatureCollectionToJson(resultCollection);
					list.add(ja);
				} finally {
					SHDataStore.dispose(targetDataStore);
				}

			}

		} catch (NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		} finally {
			SHDataStore.dispose(sourceDataStore);
		}

		return list;
	}

}
