package egovframework.mango.analysis.business.service;

import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.MultiPolygon;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.Polygon;
import org.locationtech.jts.io.ParseException;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;
import org.opengis.feature.type.AttributeDescriptor;
import org.opengis.filter.Filter;
import org.opengis.filter.FilterFactory;
import org.opengis.filter.FilterFactory2;
import org.opengis.filter.Or;
import org.opengis.filter.PropertyIsEqualTo;
import org.opengis.filter.expression.Expression;
import org.opengis.filter.spatial.DWithin;
import org.opengis.filter.spatial.Intersects;
import org.springframework.jdbc.datasource.SingleConnectionDataSource;
import org.springframework.stereotype.Service;

import egovframework.mango.analysis.biz.web.AnalysisBizController;
import egovframework.mango.config.SHAnalysisBaseService;
import egovframework.mango.config.SHDataStore;
import egovframework.mango.config.SHResource;
import egovframework.mango.util.SHJsonHelper;
import egovframework.mango.util.Util;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.geotools.data.DataStore;
import org.geotools.data.Query;
import org.geotools.data.collection.ListFeatureCollection;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.data.simple.SimpleFeatureIterator;
import org.geotools.factory.CommonFactoryFinder;
import org.geotools.feature.simple.SimpleFeatureBuilder;
import org.geotools.feature.simple.SimpleFeatureTypeBuilder;
import org.geotools.filter.text.cql2.CQL;
import org.geotools.geometry.jts.WKTReader2;
import org.geotools.process.Process;
import org.geotools.process.spatialstatistics.BufferExpressionProcessFactory;
import org.geotools.process.spatialstatistics.IntersectProcessFactory;
import org.geotools.process.spatialstatistics.MultipleRingBufferProcessFactory;
import org.geotools.process.spatialstatistics.SelectFeaturesProcessFactory;
import org.geotools.process.spatialstatistics.enumeration.DistanceUnit;
import org.geotools.referencing.CRS;
import org.geotools.referencing.crs.DefaultGeographicCRS;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

@Service
public class AnalysisBusinessService extends SHAnalysisBaseService {
	private static Logger logger = LogManager.getLogger(AnalysisBusinessService.class);

	// intersect
	public Map<String, Object> intersectLyrs(String exportId, Geometry inputGeom, String overlayLyrs) throws NullPointerException, Exception {

		Map<String, Object> result = new HashMap<>();

		String[] lyrLs = overlayLyrs.split(",");

		int size = lyrLs.length;

		for (int i = 0; i < size; i++) {
			String layer = lyrLs[i].trim();

			ListFeatureCollection ls = intersectLyr(null, inputGeom, layer);
			String lsGeoJson = SHJsonHelper.featureCollectionToGeoJson(ls);
			result.put(layer.split("\\.")[1], lsGeoJson);

			Util.shpExport(exportId, layer, ls);
		}

		ListFeatureCollection list = null;
		try {
			SimpleFeature srcSf = SHJsonHelper.createPolygonFeature("source", "the_geom", inputGeom.toText());
			list = new ListFeatureCollection(srcSf.getFeatureType());
			list.add(srcSf);
			Util.shpExport(exportId, "source", list);
		} catch (NullPointerException e) {
			list = null;
			logger.debug(e);
		} catch (Exception e) {
			list = null;
			logger.debug(e);
		}

		return result;
	}

	public ListFeatureCollection intersectLyr(Geometry inputGeom, String overapLyr) throws NullPointerException, Exception {
		return intersectLyr(null, inputGeom, overapLyr);
	}

	public ListFeatureCollection intersectLyr(String exportId, Geometry inputGeom, String overapLyr) throws NullPointerException, Exception {
		DataStore dataStore = null;
		ListFeatureCollection list = null;
		try {
			String schema = overapLyr.split("\\.")[0];
			String lyrName = overapLyr.split("\\.")[1];

			dataStore = SHDataStore.getNewDataStore(schema);

			SimpleFeatureCollection sfc = dataStore.getFeatureSource(lyrName).getFeatures();

			FilterFactory2 ff = CommonFactoryFinder.getFilterFactory2();

			String geomName = "the_geom";
			try {
				geomName = sfc.getSchema().getGeometryDescriptor().getName().getLocalPart();
			} catch (NullPointerException e) {
				logger.debug(e);
			} catch (Exception e) {
				logger.debug(e);
			}

			Intersects intersects = ff.intersects(ff.property(geomName), ff.literal(inputGeom));

			SimpleFeatureCollection result = sfc.subCollection(intersects);

			if (exportId != null) {
				Util.shpExport(exportId, lyrName, result);
			}

			list = new ListFeatureCollection(result);
		} finally {
			SHDataStore.dispose(dataStore);
		}

		return list;
	}

	public Map<String, String> lyrIntersect(String exportId, String inputLyr, Geometry geom, String overlayLyrs)
			throws NullPointerException, Exception {

		Map<String, String> result = new HashMap<>();

		DataStore inputDataStore = null;
		try {

			String inputSchema = inputLyr.split("\\.")[0];
			String inputLyrName = inputLyr.split("\\.")[1];
			SimpleFeatureCollection isfc = null;
			int totalOverLyrCount = 0;

			if (geom != null) {
				isfc = intersectLyr(exportId, geom, inputLyr);
				Util.shpExport(exportId, inputLyr, isfc);
			} else {
				inputDataStore = SHDataStore.getNewDataStore(inputSchema);
				isfc = inputDataStore.getFeatureSource(inputLyrName).getFeatures();
				Util.shpExport(exportId, inputLyrName, isfc);
			}

			String[] lyrLs = overlayLyrs.split(",");
			int size = lyrLs.length;

			for (int i = 0; i < size; i++) {
				String overlapSchema = lyrLs[i].split("\\.")[0].trim();
				String overlayLyrName = lyrLs[i].split("\\.")[1].trim();

				DataStore overlapDataStore = null;
				try {
					overlapDataStore = SHDataStore.getNewDataStore(overlapSchema);
					SimpleFeatureCollection osfc = overlapDataStore.getFeatureSource(overlayLyrName).getFeatures();

					String sifc = spatialIntersect(exportId, isfc, osfc);
					result.put(overlayLyrName, sifc);

					Query query = new Query();
					totalOverLyrCount = overlapDataStore.getFeatureSource(overlayLyrName).getCount(query);

					String totalDataNum = overlayLyrName + "_totalDataNum";
					result.put(totalDataNum, String.valueOf(totalOverLyrCount));
				} finally {
					SHDataStore.dispose(overlapDataStore);
				}
			}
		} finally {
			SHDataStore.dispose(inputDataStore);
		}
		Util.mapExport(exportId, "result", result);
		return result;
	}

	public String spatialIntersect(SimpleFeatureCollection inputLyr, SimpleFeatureCollection overlayLyr)
			throws NullPointerException, Exception {
		return spatialIntersect(null, inputLyr, overlayLyr);
	}

	public String spatialIntersect(String exportId, SimpleFeatureCollection inputLyr,
			SimpleFeatureCollection overlayLyr) throws NullPointerException, Exception {
		try {
			// IntersectProcessFactory factory = new IntersectProcessFactory();
			// Process process = factory.create();

			// Map<String, Object> param = new HashMap<>();
			// inputLyr = Util.simpleFeatureCollectionTypeFix(inputLyr);
			// param.put(IntersectProcessFactory.inputFeatures.key, inputLyr);
			// overlayLyr = Util.simpleFeatureCollectionTypeFix(overlayLyr);
			// param.put(IntersectProcessFactory.overlayFeatures.key, overlayLyr);

			SimpleFeatureIterator overIt = null;
			List<SimpleFeature> overTotList = new ArrayList<>();
			try {
				overIt = overlayLyr.features();
				while (overIt.hasNext()) {
					SimpleFeature sf = overIt.next();
					if (sf != null) {
						Geometry g = (Geometry) sf.getDefaultGeometry();
						if (g != null) {
							overTotList.add(sf);
						}
					}
				}
			} finally {
				try {
					if (overIt != null) {
						overIt.close();
					}
				} catch (NullPointerException e) {
					logger.debug(e);
				} catch (Exception e) {
					logger.debug(e);
				}
			}

			ListFeatureCollection resultCollection = new ListFeatureCollection(overlayLyr.getSchema());
			SimpleFeatureIterator inputIt = null;
			try {
				inputIt = inputLyr.features();
				while (inputIt.hasNext()) {
					SimpleFeature sf = inputIt.next();
					if (sf != null) {
						Geometry g = (Geometry) sf.getDefaultGeometry();
						if (g != null) {
							for (int overIdx = overTotList.size(); overIdx > 0; overIdx--) {
								SimpleFeature overSf = overTotList.get(overIdx - 1);
								Geometry overG = (Geometry) overSf.getDefaultGeometry();
								if (g.intersects(overG)) {
									resultCollection.add(overSf);
								}
							}
						}
					}
				}
			} finally {
				try {
					if (inputIt != null) {
						inputIt.close();
					}
				} catch (NullPointerException e) {
					logger.debug(e);
				} catch (Exception e) {
					logger.debug(e);
				}
			}

			// Map<String, Object> resultMap = process.execute(param, null);

			// SimpleFeatureCollection resultCollection = (SimpleFeatureCollection)
			// resultMap
			// .get(BufferExpressionProcessFactory.RESULT.key);

			if (exportId != null) {
				Util.shpExport(exportId, overlayLyr.getSchema().getTypeName(), resultCollection);
			}

			String result = SHJsonHelper.featureCollectionToGeoJson(resultCollection);

			return result;
		} catch (NullPointerException e) {
			logger.debug(e);
			return null;
		} catch (Exception e) {
			logger.debug(e);
			return null;
		}
	}

	public JSONArray getIntersectFeatures(String schema, String inputFeatures, String overlayFeatures)
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
		} finally {
			SHDataStore.dispose(dataStore);
		}
		return ja;
	}

	// 버퍼 중첩 분석 : 멀티링
	public List getMultipleRingBufferIntersectFeatures(String exportId, String inputFeatureSchema, String inputFeatures,
			String targetFeatureSchema, String targetFeatures, String distance, String distanceUnit,
			boolean outsideOnly, boolean dissolve, String sggCd) throws NullPointerException, Exception {

		DataStore targetDataStore = null;
		List list = new ArrayList<>();
		Map<String, JSONObject> sourceResult = new HashMap<>();
		Map<String, List<JSONObject>> targetResult = new HashMap<>();
		try {
			targetDataStore = SHDataStore.getNewDataStore(targetFeatureSchema);

			// 멀티링 실행
			SimpleFeatureCollection sfcBufferInput = targetDataStore.getFeatureSource(targetFeatures).getFeatures();

			// 타겟에서 선택된 자치구만 잘라오기 필요!
			targetDataStore = SHDataStore.getNewDataStore(SHResource.getValue("sgg.schema"));
			SimpleFeatureCollection sggAllInput = targetDataStore.getFeatureSource(SHResource.getValue("sgg.layer.nm"))
					.getFeatures();

			SelectFeaturesProcessFactory factory1 = new SelectFeaturesProcessFactory();
			Process process1 = factory1.create();
			Map<String, Object> param1 = new HashMap<>();

			Filter sggFilter = CQL.toFilter("signgu_code = " + sggCd);

			param1.put(SelectFeaturesProcessFactory.inputFeatures.key, sggAllInput);
			param1.put(SelectFeaturesProcessFactory.filter.key, sggFilter);

			Map<String, Object> sggMap = process1.execute(param1, null);

			SimpleFeatureCollection sggInput = (SimpleFeatureCollection) sggMap
					.get(SelectFeaturesProcessFactory.RESULT.key);

			Util.shpExport(exportId, SHResource.getValue("sgg.layer.nm"), sggInput);

			FilterFactory2 ff = CommonFactoryFinder.getFilterFactory2();
			Intersects filter = ff.intersects(ff.property("the_geom"),
					ff.literal(sggInput.features().next().getDefaultGeometry()));

			SimpleFeatureCollection filterBuffer = sfcBufferInput.subCollection(filter);

			if (targetFeatures.equals("z_upis_c_uq151")) {
				Filter road = ff.or(ff.like(ff.property("road_role"), "PMI0001"),
						ff.like(ff.property("road_role"), "PMI0002"));
				filterBuffer = filterBuffer.subCollection(road);
			}

			MultipleRingBufferProcessFactory factory = new MultipleRingBufferProcessFactory();
			Process process = factory.create();
			Map<String, Object> param = new HashMap<>();

//		String[] distanceArr = distance.split(",");
//
//		Double distance1 = Double.parseDouble(distanceArr[0]);
//		Double distance2 = Double.parseDouble(distanceArr[1]);
//		Double distance3 = Double.parseDouble(distanceArr[2]);
//
//		Double distance1Double = Util.transformUnit(CRS.decode("EPSG:5179"), CRS.decode("EPSG:4326"), distance1);
//		Double distance2Double = Util.transformUnit(CRS.decode("EPSG:5179"), CRS.decode("EPSG:4326"), distance2);
//		Double distance3Double = Util.transformUnit(CRS.decode("EPSG:5179"), CRS.decode("EPSG:4326"), distance3);
//
//		String unitDistance = distance1Double + "," + distance2Double + "," + distance3Double;

			param.put(MultipleRingBufferProcessFactory.inputFeatures.key, filterBuffer);
//		param.put(MultipleRingBufferProcessFactory.distances.key, unitDistance);
			param.put(MultipleRingBufferProcessFactory.distances.key, distance);

			param.put(MultipleRingBufferProcessFactory.distanceUnit.key, DistanceUnit.Meters);
			param.put(MultipleRingBufferProcessFactory.outsideOnly.key, outsideOnly);
			param.put(MultipleRingBufferProcessFactory.dissolve.key, dissolve);

			Map<String, Object> resultMap = process.execute(param, null);

			SimpleFeatureCollection bufferResultCollection = (SimpleFeatureCollection) resultMap
					.get(MultipleRingBufferProcessFactory.RESULT.key);

			Util.shpExport(exportId, "buffer", bufferResultCollection);

			// 중첩 실행
			DataStore inputDataStore = null;
			try {
				inputDataStore = SHDataStore.getNewDataStore(inputFeatureSchema);

				SimpleFeatureCollection sfcIntersectInput = inputDataStore.getFeatureSource(inputFeatures)
						.getFeatures();

				JSONParser jparser = new JSONParser();

				GeometryFactory gf = new GeometryFactory();

				try {
					Map<String, SimpleFeature> sourceMap = new HashMap<>();
					SimpleFeatureIterator sfi = null;
					try {
						sfi = sfcIntersectInput.features();
						int sourceId = 1;
						while (sfi.hasNext()) {
							SimpleFeature sf = sfi.next();
							sourceMap.put("" + sourceId, sf);
							sourceId++;
						}
					} finally {
						try {
							sfi.close();
						} catch (NullPointerException npe) {
							logger.debug(npe);
						} catch (Exception e) {
							logger.debug(e);
						}
					}

					SimpleFeatureIterator sfi2 = null;
					try {

						sfi2 = bufferResultCollection.features();
						while (sfi2.hasNext()) {
							SimpleFeature sf2 = sfi2.next();

							Geometry o2 = (Geometry) sf2.getDefaultGeometry();
							MultiPolygon multiPolygon = (MultiPolygon) o2;
							Polygon[] polygonsWithoutHoles = new Polygon[multiPolygon.getNumGeometries()];

							for (int X = 0; X < multiPolygon.getNumGeometries(); X++) {
								Polygon polygon = (Polygon) multiPolygon.getGeometryN(X);
								// 홀 없이 외곽 링만으로 새로운 폴리곤 생성
								Polygon polygonWithoutHoles = new Polygon(polygon.getExteriorRing(), null, gf);
								polygonsWithoutHoles[X] = polygonWithoutHoles;
							}

							// 홀 없는 멀티폴리곤 생성
							o2 = new MultiPolygon(polygonsWithoutHoles, gf);

							Iterator<String> sourceKeyIt = sourceMap.keySet().iterator();
							while (sourceKeyIt.hasNext()) {
								String sourceKey = sourceKeyIt.next();
								SimpleFeature sf = sourceMap.get(sourceKey);

								// try {

								// SimpleFeature sf = sfi.next();
								Geometry o1 = (Geometry) sf.getDefaultGeometry();
								if (o1.intersects(o2)) {

									if (!sourceResult.containsKey(sourceKey)) {
										String jo = SHJsonHelper.featureToGeoJson(sf);
										sourceResult.put(sourceKey, (JSONObject) jparser.parse(jo));
									}

									if (!targetResult.containsKey(sourceKey)) {
										List<JSONObject> targetList = new ArrayList<>();
										targetResult.put(sourceKey, targetList);
									}

									List<JSONObject> targetSfList = targetResult.get(sourceKey);

									String jo = SHJsonHelper.featureToGeoJson(sf2);
									targetSfList.add((JSONObject) jparser.parse(jo));
								}
							}

						}
					} catch (NullPointerException e) {
						logger.debug(e);
					} catch (Exception e) {
						logger.debug(e);
					} finally {
						try {
							sfi2.close();
						} catch (NullPointerException e2) {
							logger.debug(e2);
						} catch (Exception e2) {
							logger.debug(e2);
						}
					}

				} catch (NullPointerException e) {
					logger.debug(e);
				
				} catch (Exception e) {
					logger.debug(e);
				}
			} finally {
				SHDataStore.dispose(inputDataStore);
			}
		} finally {
			SHDataStore.dispose(targetDataStore);
		}

		list.add(sourceResult);
		list.add(targetResult);

		Util.mapExport(exportId, "result", list);

//
//		IntersectProcessFactory factory2 = new IntersectProcessFactory();
//		Process process2 = factory2.create();
//		Map<String, Object> param2 = new HashMap<>();
//
//		param2.put(IntersectProcessFactory.inputFeatures.key, sfcIntersectInput);
//		param2.put(IntersectProcessFactory.overlayFeatures.key, bufferResultCollection);
//
//		Map<String, Object> finalMap = process2.execute(param2, null);
//
//		SimpleFeatureCollection resultCollection = (SimpleFeatureCollection) finalMap
//				.get(IntersectProcessFactory.RESULT.key);
//
//		JSONArray ja = SHJsonHelper.simpleFeatureCollectionToJson(resultCollection);

		return list;
	}

	// 버퍼 중첩 분석 : 교집합 분석
	public List getBufferIntersectFeatures(String exportId, String inputFeatureSchema, String inputFeatures,
			List<Map<String, Object>> targetList, String sggCd) throws NullPointerException, Exception {

		DataStore srcDataStore = null;
		List list = new ArrayList<>();
		Map<String, JSONObject> sourceResult = new HashMap<>();
		Map<String, Map<String, List<JSONObject>>> targetResult = new HashMap<>();
		Map<String, Integer> totalCntMap = new HashMap<>();
		totalCntMap.put("total", 0);
		try {
			srcDataStore = SHDataStore.getNewDataStore(inputFeatureSchema);

			SimpleFeatureCollection sfcIntersectInput = srcDataStore.getFeatureSource(inputFeatures).getFeatures();

			// target이 여러개
			Map<String, Object> targetMap = new HashMap<>();
			JSONParser jparser = new JSONParser();

			// 타겟에서 선택된 자치구만 잘라오기 필요!
			srcDataStore = SHDataStore.getNewDataStore(SHResource.getValue("sgg.schema"));
			SimpleFeatureCollection sggAllInput = srcDataStore.getFeatureSource(SHResource.getValue("sgg.layer.nm"))
					.getFeatures();

			SelectFeaturesProcessFactory factory1 = new SelectFeaturesProcessFactory();
			Process process1 = factory1.create();
			Map<String, Object> param1 = new HashMap<>();

			Filter sggFilter = CQL.toFilter("signgu_code = " + sggCd);

			param1.put(SelectFeaturesProcessFactory.inputFeatures.key, sggAllInput);
			param1.put(SelectFeaturesProcessFactory.filter.key, sggFilter);

			Map<String, Object> sggMap = process1.execute(param1, null);

			SimpleFeatureCollection sggInput = (SimpleFeatureCollection) sggMap
					.get(SelectFeaturesProcessFactory.RESULT.key);

			Util.shpExport(exportId, SHResource.getValue("sgg.layer.nm"), sggInput);

			Geometry sggGeom = (Geometry) sggInput.features().next().getDefaultGeometry();
			FilterFactory2 ff = CommonFactoryFinder.getFilterFactory2();
			Intersects filter = ff.intersects(ff.property("the_geom"), ff.literal(sggGeom));

			Map<String, SimpleFeature> sourceMap = new HashMap<>();
			SimpleFeatureIterator sfi = null;
			try {
				sfi = sfcIntersectInput.features();
				int sourceId = 1;
				int totCnt = 0;
				while (sfi.hasNext()) {
					sourceId++;
					SimpleFeature sf = sfi.next();

					Geometry srcGeom = (Geometry) sf.getDefaultGeometry();
					if (srcGeom == null) {
						continue;
					}
					if (srcGeom.intersects(sggGeom)) {
						sourceMap.put("" + sourceId, sf);
						totCnt++;
					}
				}
				totalCntMap.put("total", totCnt);
			} finally {
				try {
					sfi.close();
				} catch (NullPointerException npe) {
					logger.debug(npe);
				} catch (Exception e) {
					logger.debug(e);
				}
			}

			for (int i = 0; i < targetList.size(); i++) {
				Iterator<String> sourceKeyIt = sourceMap.keySet().iterator();

				targetMap = targetList.get(i);
				String schema = (String) targetMap.get("schema");
				String targetLayer = (String) targetMap.get("layer");
				Long distanceLong = (Long) targetMap.get("distance");

				DataStore targetDataStore = null;
				try {
					targetDataStore = SHDataStore.getNewDataStore(schema);

					SimpleFeatureCollection tempInput = targetDataStore.getFeatureSource(targetLayer).getFeatures();
					SimpleFeatureCollection sfcBufferInput = tempInput.subCollection(filter);

					if (targetLayer.equals("z_upis_c_uq151")) {
						Filter road = ff.or(ff.like(ff.property("road_role"), "PMI0001"),
								ff.like(ff.property("road_role"), "PMI0002"));

						sfcBufferInput = sfcBufferInput.subCollection(road);
					}

					BufferExpressionProcessFactory factory = new BufferExpressionProcessFactory();
					Process process = factory.create();
					Map<String, Object> param = new HashMap<>();

//				Double distanceDouble = Util.transformUnit(CRS.decode("EPSG:5179"), CRS.decode("EPSG:4326"),
//						Double.parseDouble("" + distanceLong));
					Expression distance = ff.literal(distanceLong);

					param.put(BufferExpressionProcessFactory.inputFeatures.key, sfcBufferInput);
					param.put(BufferExpressionProcessFactory.distanceUnit.key, DistanceUnit.Meters);
					param.put(BufferExpressionProcessFactory.distance.key, distance);

					Map<String, Object> bufferResultMap = process.execute(param, null);

					SimpleFeatureCollection bufferResultCollection = (SimpleFeatureCollection) bufferResultMap
							.get(BufferExpressionProcessFactory.RESULT.key);

					// Util.shpExport(exportId, targetLayer, bufferResultCollection);

					SimpleFeatureIterator targetSfi = null;
					List<SimpleFeature> targetSfRawList = new ArrayList<>();

					// 결과파일을 shp파일로 생성하기 위해 피쳐컬렉션 생
					SimpleFeatureTypeBuilder newTypeBuilder = new SimpleFeatureTypeBuilder();
					newTypeBuilder.init(bufferResultCollection.getSchema());
					SimpleFeatureType newSchema = newTypeBuilder.buildFeatureType();
					ListFeatureCollection bufferResultForShpFc = new ListFeatureCollection(newSchema);

					try {
						targetSfi = bufferResultCollection.features();

						// Geometry tagetBufferResult = null;
						while (targetSfi.hasNext()) {
							SimpleFeature sf = targetSfi.next();
							targetSfRawList.add(sf);

							// Geometry g = (Geometry) sf.getDefaultGeometry();
							// if (tagetBufferResult == null) {
							// tagetBufferResult = g;
							// } else {
							// tagetBufferResult = tagetBufferResult.union(g);
							// }
						}
					} finally {
						try {
							targetSfi.close();
						} catch (NullPointerException e) {
							logger.debug(e);
							return null;
						} catch (Exception e) {
							logger.debug(e);
							return null;
						}
					}

					// SimpleFeatureIterator sfi = bufferResultCollection.features();
					// while(sfi.hasNext()) {
					// SimpleFeature sf = sfi.next();
					// System.out.println(sf.getDefaultGeometry());
					// }

					// 중첩분석 진행
					// IntersectProcessFactory factory2 = new IntersectProcessFactory();
					// Process process2 = factory2.create();
					// Map<String, Object> param2 = new HashMap<>();

//			param2.put(IntersectProcessFactory.inputFeatures.key, polygonIntersectInput);
//			param2.put(IntersectProcessFactory.overlayFeatures.key, bufferResultCollection);
					// param2.put(IntersectProcessFactory.inputFeatures.key, sfcIntersectInput);
					// param2.put(IntersectProcessFactory.overlayFeatures.key,
					// bufferResultCollection);

					totalCntMap.put(targetLayer, 0);
					
					ListFeatureCollection srcIntersectsFc = new ListFeatureCollection(sfcIntersectInput.getSchema());

					while (sourceKeyIt.hasNext()) {
						String sourceKey = sourceKeyIt.next();
						SimpleFeature sf = sourceMap.get(sourceKey);
						try {
							// SimpleFeature sf = sfi.next();

							boolean isIntersects = false;
							Geometry o1 = (Geometry) sf.getDefaultGeometry();
							for (SimpleFeature sf2 : targetSfRawList) {
								Geometry o2 = (Geometry) sf2.getDefaultGeometry();
								
								if (sggGeom.intersects(o2)) {
									bufferResultForShpFc.add(sf2);
								}
								isIntersects = false;
								if (o1.intersects(o2)) {
									isIntersects = true;
									srcIntersectsFc.add(sf);

									if (!sourceResult.containsKey(sourceKey)) {
										String jo = SHJsonHelper.featureToGeoJson(sf);
										sourceResult.put(sourceKey, (JSONObject) jparser.parse(jo));
									}

									if (!targetResult.containsKey(sourceKey)) {
										Map<String, List<JSONObject>> targetSfMap = new HashMap<>();
										targetResult.put(sourceKey, targetSfMap);
									}

									Map<String, List<JSONObject>> targetSfMap = targetResult.get(sourceKey);
									if (!targetSfMap.containsKey(targetLayer)) {
										List<JSONObject> targetSfList = new ArrayList<>();
										targetSfMap.put(targetLayer, targetSfList);
									}

									List<JSONObject> targetSfList = targetSfMap.get(targetLayer);
									String jo = SHJsonHelper.featureToGeoJson(sf2);
									targetSfList.add((JSONObject) jparser.parse(jo));
								}
							}

							if (isIntersects) {
								if (totalCntMap.containsKey(targetLayer)) {
									int targetCnt = totalCntMap.get(targetLayer);
									totalCntMap.put(targetLayer, targetCnt + 1);
								} else {
									totalCntMap.put(targetLayer, 1);
								}
							}
						} catch (NullPointerException e) {
							logger.debug(e);
						} catch (Exception e) {
							logger.debug(e);
						}
					}

					Util.shpExport(exportId, targetLayer + "_Buffer", bufferResultForShpFc);
					Util.shpExport(exportId, targetLayer + "_Intersects" ,srcIntersectsFc);

					// Map<String, Object> finalMap = process2.execute(param2, null);

					// SimpleFeatureCollection resultCollection = (SimpleFeatureCollection) finalMap
					// .get(IntersectProcessFactory.RESULT.key);

					// JSONArray ja = SHJsonHelper.simpleFeatureCollectionToJson(resultCollection);
					// list.add(ja);
				} finally {
					SHDataStore.dispose(targetDataStore);
				}

			}

		} finally {
			SHDataStore.dispose(srcDataStore);
		}

		list.add(sourceResult);
		list.add(targetResult);
		list.add(totalCntMap);

		Util.mapExport(exportId, "result", list);
		return list;
	}

	// 네트워크 중첩 분석 : 멀티링
	public List getMultipleRingNetworkIntersectFeatures(String inputFeatureSchema, String inputFeatures,
			String targetFeatureSchema, String targetFeatures, String distance, String distanceUnit,
			boolean outsideOnly, boolean dissolve) throws NullPointerException, Exception {

		DataStore targetDataStore = null;
		List list = new ArrayList<>();
		Map<String, JSONObject> sourceResult = new HashMap<>();
		Map<String, List<JSONObject>> targetResult = new HashMap<>();
		try {
			targetDataStore = SHDataStore.getNewDataStore(targetFeatureSchema);

			// 멀티링 실행
			SimpleFeatureCollection sfcBufferInput = targetDataStore.getFeatureSource(targetFeatures).getFeatures();

			MultipleRingBufferProcessFactory factory = new MultipleRingBufferProcessFactory();
			Process process = factory.create();
			Map<String, Object> param = new HashMap<>();

			param.put(MultipleRingBufferProcessFactory.inputFeatures.key, sfcBufferInput);
//				param.put(MultipleRingBufferProcessFactory.distances.key, unitDistance);
			param.put(MultipleRingBufferProcessFactory.distances.key, distance);

			param.put(MultipleRingBufferProcessFactory.distanceUnit.key, DistanceUnit.Meters);
			param.put(MultipleRingBufferProcessFactory.outsideOnly.key, outsideOnly);
			param.put(MultipleRingBufferProcessFactory.dissolve.key, dissolve);

			Map<String, Object> resultMap = process.execute(param, null);

			SimpleFeatureCollection bufferResultCollection = (SimpleFeatureCollection) resultMap
					.get(MultipleRingBufferProcessFactory.RESULT.key);

			// 중첩 실행
			DataStore inputDataStore = null;
			try {
				inputDataStore = SHDataStore.getNewDataStore(inputFeatureSchema);

				SimpleFeatureCollection sfcIntersectInput = inputDataStore.getFeatureSource(inputFeatures)
						.getFeatures();

				JSONParser jparser = new JSONParser();

				GeometryFactory gf = new GeometryFactory();

				try {
					Map<String, SimpleFeature> sourceMap = new HashMap<>();
					SimpleFeatureIterator sfi = null;
					try {
						sfi = sfcIntersectInput.features();
						int sourceId = 1;
						while (sfi.hasNext()) {
							SimpleFeature sf = sfi.next();
							sourceMap.put("" + sourceId, sf);
							sourceId++;
						}
					} finally {
						try {
							sfi.close();
						} catch (NullPointerException npe) {
							logger.debug(npe);
						} catch (Exception e) {
							logger.debug(e);
						}
					}

					SimpleFeatureIterator sfi2 = null;
					try {
						sfi2 = bufferResultCollection.features();
						while (sfi2.hasNext()) {
							SimpleFeature sf2 = sfi2.next();

							Geometry o2 = (Geometry) sf2.getDefaultGeometry();
							MultiPolygon multiPolygon = (MultiPolygon) o2;
							Polygon[] polygonsWithoutHoles = new Polygon[multiPolygon.getNumGeometries()];

							for (int X = 0; X < multiPolygon.getNumGeometries(); X++) {
								Polygon polygon = (Polygon) multiPolygon.getGeometryN(X);
								// 홀 없이 외곽 링만으로 새로운 폴리곤 생성
								Polygon polygonWithoutHoles = new Polygon(polygon.getExteriorRing(), null, gf);
								polygonsWithoutHoles[X] = polygonWithoutHoles;
							}

							// 홀 없는 멀티폴리곤 생성
							o2 = new MultiPolygon(polygonsWithoutHoles, gf);

							Iterator<String> sourceKeyIt = sourceMap.keySet().iterator();
							while (sourceKeyIt.hasNext()) {
								String sourceKey = sourceKeyIt.next();
								SimpleFeature sf = sourceMap.get(sourceKey);

								// try {

								// SimpleFeature sf = sfi.next();
								Geometry o1 = (Geometry) sf.getDefaultGeometry();
								if (o1.intersects(o2)) {

									if (!sourceResult.containsKey(sourceKey)) {
										String jo = SHJsonHelper.featureToGeoJson(sf);
										sourceResult.put(sourceKey, (JSONObject) jparser.parse(jo));
									}

									if (!targetResult.containsKey(sourceKey)) {
										List<JSONObject> targetList = new ArrayList<>();
										targetResult.put(sourceKey, targetList);
									}

									List<JSONObject> targetSfList = targetResult.get(sourceKey);

									String jo = SHJsonHelper.featureToGeoJson(sf2);
									targetSfList.add((JSONObject) jparser.parse(jo));
								}
							}

						}
					} catch (NullPointerException e) {
						logger.debug(e);
					} catch (Exception e) {
						logger.debug(e);
					} finally {
						try {
							sfi2.close();
						} catch (NullPointerException e2) {
							logger.debug(e2);
						} catch (Exception e2) {
							logger.debug(e2);
						}
					}

				} catch (NullPointerException e) {
					logger.debug(e);
				} catch (Exception e) {
					logger.debug(e);
				}
			} finally {
				SHDataStore.dispose(inputDataStore);
			}
		} finally {
			SHDataStore.dispose(targetDataStore);
		}

		list.add(sourceResult);
		list.add(targetResult);

		return list;
	}

	// 네트워크 중첩 분석 : 교집합 분석
	public List getNetworkIntersectFeatures(String exportKey, String inputFeatureSchema, String inputFeatures,
			List<Map<String, Object>> targetList, String sggCd) throws NullPointerException, Exception {

		DataStore inputDataStore = null;
		Map<String, Object> targetMap = new HashMap<>();
		List list = new ArrayList<>();
		Map<String, JSONObject> sourceResult = new HashMap<>();
		Map<String, Map<String, List<JSONObject>>> targetResult = new HashMap<>();
		Map<String, Map<String, List<JSONObject>>> targetSAreaResult = new HashMap<>();
		Map<String, Integer> totalCntMap = new HashMap<>();
		totalCntMap.put("total", 0);
		try {
			inputDataStore = SHDataStore.getNewDataStore(inputFeatureSchema);

			SimpleFeatureCollection sfcIntersectInput = inputDataStore.getFeatureSource(inputFeatures).getFeatures();

			// target이 여러개
			JSONParser jparser = new JSONParser();

			DataStore srcDataStore = null;
			try {
				srcDataStore = SHDataStore.getNewDataStore(SHResource.getValue("sgg.schema"));
				SimpleFeatureCollection sggAllInput = srcDataStore.getFeatureSource(SHResource.getValue("sgg.layer.nm"))
						.getFeatures();

				SelectFeaturesProcessFactory factory1 = new SelectFeaturesProcessFactory();
				Process process1 = factory1.create();
				Map<String, Object> param1 = new HashMap<>();

				Filter sggFilter = CQL.toFilter("signgu_code = " + sggCd);

				param1.put(SelectFeaturesProcessFactory.inputFeatures.key, sggAllInput);
				param1.put(SelectFeaturesProcessFactory.filter.key, sggFilter);

				Map<String, Object> sggMap = process1.execute(param1, null);

				SimpleFeatureCollection sggInput = (SimpleFeatureCollection) sggMap
						.get(SelectFeaturesProcessFactory.RESULT.key);

				Util.shpExport(exportKey, SHResource.getValue("sgg.layer.nm"), sggInput);

				Geometry sggGeom = (Geometry) sggInput.features().next().getDefaultGeometry();
				FilterFactory2 ff = CommonFactoryFinder.getFilterFactory2();
				Filter filter = ff.intersects(ff.property("the_geom"), ff.literal(sggGeom));

				Map<String, SimpleFeature> sourceMap = new HashMap<>();
				SimpleFeatureIterator sfi = null;
				try {
					sfi = sfcIntersectInput.features();
					int sourceId = 1;
					int totCnt = 0;
					while (sfi.hasNext()) {
						sourceId++;
						SimpleFeature sf = sfi.next();

						Geometry srcGeom = (Geometry) sf.getDefaultGeometry();
						if (srcGeom != null && srcGeom.intersects(sggGeom)) {
							sourceMap.put("" + sourceId, sf);
							totCnt++;
						}
					}
					totalCntMap.put("total", totCnt);
				} finally {
					try {
						sfi.close();
					} catch (NullPointerException e) {
						logger.debug(e);
					} catch (Exception e) {
						logger.debug(e);
					}
				}

				for (int i = 0; i < targetList.size(); i++) {
					Iterator<String> sourceKeyIt = sourceMap.keySet().iterator();
					targetMap = targetList.get(i);
					String schema = (String) targetMap.get("schema");
					String targetLayer = (String) targetMap.get("layer");
					Long paramValue = (Long) targetMap.get("value");
					String paramType = (String) targetMap.get("paramType");

					totalCntMap.put(targetLayer, 0);
					if (paramType.equals("distance")) {
						paramValue = (long) Math.ceil(paramValue / 60.);
					}

					if (paramValue <= 0) {
						paramValue = (long) 1;
					}

					// FilterFactory ff = CommonFactoryFinder.getFilterFactory();

					DataStore targetDatsStore = null;

					try {
						targetDatsStore = SHDataStore.getNewDataStore(schema);
						SimpleFeatureCollection tempCollection = targetDatsStore.getFeatureSource(targetLayer)
								.getFeatures();

						if ("z_upis_c_uq151".equals(targetLayer.toLowerCase())) {
							PropertyIsEqualTo pmi0001Filter = ff.equals(ff.property("road_role"),
									ff.literal("PMI0001"));
							PropertyIsEqualTo pmi0002Filter = ff.equals(ff.property("road_role"),
									ff.literal("PMI0002"));
							Or or = ff.or(pmi0001Filter, pmi0002Filter);

							filter = ff.and(filter, or);
						}

						SimpleFeatureCollection targetCollection = tempCollection.subCollection(filter);

						// 서비스에어리어 또는 멀티링버퍼 레이어 생성
						SimpleFeatureTypeBuilder sftb = new SimpleFeatureTypeBuilder();
						sftb.init(targetCollection.getSchema());
						sftb.remove("the_geom");
						sftb.add("the_geom", MultiPolygon.class);

						SimpleFeatureType sAreaFtype = sftb.buildFeatureType();
						ListFeatureCollection sAreaFeatureCollection = new ListFeatureCollection(sAreaFtype);

						sftb = new SimpleFeatureTypeBuilder();
						sftb.init(sfcIntersectInput.getSchema());

						SimpleFeatureType srcIntersectsFtype = sftb.buildFeatureType();
						ListFeatureCollection srcIntersectsFeatureCollection = new ListFeatureCollection(
								srcIntersectsFtype);
						/////////////////////////////////

						List<Map<String, Object>> sf2List = new ArrayList<>();

						try {

							SimpleFeatureIterator sfi2 = null;
							SingleConnectionDataSource serviceAreaDatasource = null;

							try {
								sfi2 = targetCollection.features();
								serviceAreaDatasource = openServiceAreaDataSource();

								while (sfi2.hasNext()) {
									SimpleFeature sf2 = sfi2.next();

									Map<String, Object> sf2Map = new HashMap<>();

									sf2List.add(sf2Map);
									sf2Map.put("sf", sf2);

									Geometry o2Temp = (Geometry) sf2.getDefaultGeometry();

									Point centroid = null;

									// o2 지오메트리가 네트워크 영역이 되어야함!!
									if (o2Temp.getGeometryType() == "Point") {
										centroid = (Point) o2Temp;
									} else {
										centroid = o2Temp.getInteriorPoint();
									}

									// 서비스 영역 가져오기
									String serviceAreaWKT = excuteServiceArea(serviceAreaDatasource, centroid.getX(),
											centroid.getY(), 4326, paramValue);
									// 서비스 영역 폴리곤
									SimpleFeature serviceAreaFeature = createPolygonFeature(serviceAreaWKT);

									sf2Map.put("sArea", serviceAreaFeature);
									sAreaFeatureCollection.add(serviceAreaFeature);

								}
							} finally {

								try {
									if (sfi2 != null) {
										sfi2.close();
									}
								} catch (NullPointerException e) {
									sfi2 = null;
								} catch (Exception e) {
									sfi2 = null;
								}

								destroyServiceAreaDatasource(serviceAreaDatasource);
							}

							Util.shpExport(exportKey, targetLayer + "_service_area", sAreaFeatureCollection);

							while (sourceKeyIt.hasNext()) {
								String sourceKey = sourceKeyIt.next();
								SimpleFeature sf = sourceMap.get(sourceKey);
								Geometry o1 = (Geometry) sf.getDefaultGeometry();
								boolean isIntersects = false;
								// SimpleFeature sf = sfi.next();
								for (Map<String, Object> sf2Map : sf2List) {
									SimpleFeature sf2sf = (SimpleFeature) sf2Map.get("sArea");
									SimpleFeature sf2 = (SimpleFeature) sf2Map.get("sf");
									Geometry o2 = (Geometry) sf2sf.getDefaultGeometry();
									isIntersects = false;
									if (o1.intersects(o2)) {
										isIntersects = true;

										srcIntersectsFeatureCollection.add(sf);

										if (!sourceResult.containsKey(sourceKey)) {
											String jo = SHJsonHelper.featureToGeoJson(sf);
											sourceResult.put(sourceKey, (JSONObject) jparser.parse(jo));
										}

										if (!targetResult.containsKey(sourceKey)) {
											Map<String, List<JSONObject>> targetSfMap = new HashMap<>();
											targetResult.put(sourceKey, targetSfMap);
										}

										if (!targetSAreaResult.containsKey(sourceKey)) {
											Map<String, List<JSONObject>> targetSfMap = new HashMap<>();
											targetSAreaResult.put(sourceKey, targetSfMap);
										}

										Map<String, List<JSONObject>> targetSfMap = targetResult.get(sourceKey);
										if (!targetSfMap.containsKey(targetLayer)) {
											List<JSONObject> targetSfList = new ArrayList<>();
											targetSfMap.put(targetLayer, targetSfList);
										}

										List<JSONObject> targetSfList = targetSfMap.get(targetLayer);
										String jo = SHJsonHelper.featureToGeoJson(sf2);
										targetSfList.add((JSONObject) jparser.parse(jo));

										Map<String, List<JSONObject>> targetSfAreaMap = targetSAreaResult
												.get(sourceKey);
										if (!targetSfAreaMap.containsKey(targetLayer)) {
											List<JSONObject> targetSfAreaList = new ArrayList<>();
											targetSfAreaMap.put(targetLayer, targetSfAreaList);
										}

										List<JSONObject> targetSfAreaList = targetSfAreaMap.get(targetLayer);
										String joSArea = SHJsonHelper.featureToGeoJson(sf2sf);
										targetSfAreaList.add((JSONObject) jparser.parse(joSArea));
									}

									if (isIntersects) {
										if (totalCntMap.containsKey(targetLayer)) {
											int targetCnt = totalCntMap.get(targetLayer);
											totalCntMap.put(targetLayer, targetCnt + 1);
										} else {
											totalCntMap.put(targetLayer, 1);
										}
									}
								}

							}

							Util.shpExport(exportKey, targetLayer + "_Intersects", srcIntersectsFeatureCollection);
						} catch (NullPointerException e) {
							logger.debug(e);
						} catch (Exception e) {
							logger.debug(e);
						}
					} finally {
						SHDataStore.dispose(targetDatsStore);
					}

					// Map<String, Object> finalMap = process2.execute(param2, null);

					// SimpleFeatureCollection resultCollection = (SimpleFeatureCollection) finalMap
					// .get(IntersectProcessFactory.RESULT.key);

					// JSONArray ja = SHJsonHelper.simpleFeatureCollectionToJson(resultCollection);
					// list.add(ja);

				}
			} catch (NullPointerException e) {
				logger.debug(e);
			} catch (Exception e) {
				logger.debug(e);
			} finally {
				SHDataStore.dispose(srcDataStore);
			}
		} finally {
			SHDataStore.dispose(inputDataStore);
		}

		list.add(sourceResult);
		list.add(targetResult);
		list.add(targetSAreaResult);
		list.add(totalCntMap);
		Util.mapExport(exportKey, "result", list);
		return list;
	}

	// 서비스 영역 가져오기
	public String excuteServiceArea(SingleConnectionDataSource datasource, Double coordX, Double coordY, Integer srid,
			Long walkSpeed) throws IOException {

//		URIBuilder uriBuilder = new URIBuilder().setScheme(SHResource.getValue("sh.server.schema"))
//				.setHost(SHResource.getValue("sh.server.url")).setPath("/shex/api/network/serviceArea")
//				.addParameter("coord_x", coordX.toString()).addParameter("coord_y", coordY.toString())
//				.addParameter("walk_min", walkSpeed.toString());
//
//		if (srid != 0 && srid != null) {
//			uriBuilder.addParameter("srid", srid.toString());
//		}
//
//		CloseableHttpClient httpClient = HttpClients.createDefault();
//		HttpPost request = new HttpPost(uriBuilder.toString());
//
//		HttpResponse response = httpClient.execute(request);
//		String result = EntityUtils.toString(response.getEntity());
//		String serviceAreaWKT = null;
//
//		try {
//			JSONParser jsonParser = new JSONParser();
//			JSONObject targetObj = (JSONObject) jsonParser.parse(result);
//
//			Map<String, Object> data = (Map<String, Object>) targetObj.get("DATA");
//
//			serviceAreaWKT = (String) data.get("service_area");
//
//		} catch (Exception e) {
//			// TODO: handle exception
//		}
//
//		httpClient.close();

		Map<String, Object> param = new HashMap<>();
		param.put("coord_x", coordX);
		param.put("coord_y", coordY);
		param.put("srid", srid);
		param.put("walk_min", walkSpeed);
		param.put("walk_speed", 60);
		param.put("distance", 60 * walkSpeed);
		param.put("edge_or_node", "node");
		param.put("convex_radius", 0.7);

		Map<String, Object> serviceAreaMap = getServiceArea(datasource, param);

		return (String) serviceAreaMap.get("service_area");
	}

	private static SimpleFeature createPolygonFeature(String polygonWKT) throws NullPointerException, Exception{

		return SHJsonHelper.createPolygonFeature("service_area", "the_geom", polygonWKT);
	}

}
