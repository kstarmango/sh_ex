package egovframework.mango.analysis.life.service;

import java.io.IOException;
import java.net.URI;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.http.HttpHeaders;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.geojson.FeatureCollection;
import org.geotools.data.DataStore;
import org.geotools.data.DataUtilities;
import org.geotools.data.collection.ListFeatureCollection;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.data.simple.SimpleFeatureIterator;
import org.geotools.factory.CommonFactoryFinder;
import org.geotools.feature.DefaultFeatureCollection;
import org.geotools.feature.simple.SimpleFeatureBuilder;
import org.geotools.feature.simple.SimpleFeatureTypeBuilder;
import org.geotools.filter.text.cql2.CQL;
import org.geotools.geometry.jts.JTS;
import org.geotools.geometry.jts.WKTReader2;
import org.geotools.process.Process;
import org.geotools.process.spatialstatistics.BufferExpressionProcessFactory;
import org.geotools.process.spatialstatistics.BufferStatisticsProcessFactory;
import org.geotools.process.spatialstatistics.IntersectProcessFactory;
import org.geotools.process.spatialstatistics.MultipleRingBufferProcessFactory;
import org.geotools.process.spatialstatistics.PointStatisticsProcessFactory;
import org.geotools.process.spatialstatistics.SelectFeaturesProcessFactory;
import org.geotools.process.spatialstatistics.enumeration.DistanceUnit;
import org.geotools.referencing.CRS;
import org.geotools.referencing.GeodeticCalculator;
import org.geotools.referencing.crs.DefaultGeocentricCRS;
import org.geotools.referencing.crs.DefaultGeographicCRS;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.MultiPolygon;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.Polygon;
import org.locationtech.jts.io.ParseException;
import org.locationtech.jts.operation.distance.DistanceOp;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;
import org.opengis.feature.type.AttributeDescriptor;
import org.opengis.feature.type.AttributeType;
import org.opengis.filter.Filter;
import org.opengis.filter.FilterFactory;
import org.opengis.filter.expression.Expression;
import org.opengis.referencing.crs.CoordinateReferenceSystem;
import org.springframework.jdbc.datasource.SingleConnectionDataSource;
import org.springframework.stereotype.Service;

import egovframework.mango.config.SHAnalysisBaseService;
import egovframework.mango.config.SHDataStore;
import egovframework.mango.config.SHResource;
import egovframework.mango.util.SHJsonHelper;
import egovframework.mango.util.Util;

@Service
public class AnalysisLifeService extends SHAnalysisBaseService {

	private static Logger logger = LogManager.getLogger(AnalysisLifeService.class);

	/*
	 * 기초생활인프라분석 : 기본 입지분석(거리) 포인트(단일)의 버퍼 거리를 받아서 해당 반경 내에 속하는 시설 뽑아내기 : 직선 거리 기준으로
	 * 추출 멀티링 버퍼 => 인터섹트
	 */
	public Map<String, JSONArray> getMultiRingInterSect(String exportId, String inputWKT,
			List<Map<String, Object>> targetList, String distances) throws NullPointerException, Exception {

		DataStore srcDataStore = null;
		Map<String, JSONArray> newResults = new HashMap<>();
		try {
			srcDataStore = SHDataStore.getDataStore();

			WKTReader2 reader = new WKTReader2();
			// Geometry geometry = reader.read(inputWKT);
			Geometry pt = reader.read(inputWKT);

			SimpleFeature sfeature = createPointFeature(pt);
			SimpleFeature[] arr = new SimpleFeature[1];
			arr[0] = sfeature;

			SimpleFeatureCollection sfcInput = new ListFeatureCollection(sfeature.getFeatureType(), arr);

			// 멀티링 실행
			MultipleRingBufferProcessFactory factory = new MultipleRingBufferProcessFactory();
			Process process = factory.create();
			Map<String, Object> param = new HashMap<>();

			param.put(MultipleRingBufferProcessFactory.inputFeatures.key, sfcInput);
			param.put(MultipleRingBufferProcessFactory.distances.key, distances);
			param.put(MultipleRingBufferProcessFactory.distanceUnit.key, DistanceUnit.Meters);

			Map<String, Object> resultMap = process.execute(param, null);

			SimpleFeatureCollection bufferResultCollection = (SimpleFeatureCollection) resultMap
					.get(MultipleRingBufferProcessFactory.RESULT.key);

			Util.shpExport(exportId, "multiring", bufferResultCollection);

			// target이 여러개

			Map<String, Object> targetMap = new HashMap<>();
			String currentSchema = "";

			SimpleFeatureTypeBuilder newTypeBuilder = new SimpleFeatureTypeBuilder();
			newTypeBuilder.init(bufferResultCollection.getSchema());
			newTypeBuilder.add("gubun", String.class);
			newTypeBuilder.add("d_distance", Double.class);
			newTypeBuilder.add("nearest_nm", String.class);
			newTypeBuilder.add("count", Integer.class);
			newTypeBuilder.add("sub_features", Object.class);

			SimpleFeatureType newSchema = newTypeBuilder.buildFeatureType();
			SimpleFeatureBuilder newFeatureBuilder = new SimpleFeatureBuilder(newSchema);

			GeometryFactory gf = new GeometryFactory();
			for (int i = 0; i < targetList.size(); i++) {
				ListFeatureCollection newFc = new ListFeatureCollection(newSchema);

				targetMap = targetList.get(i);
				String schema = (String) targetMap.get("schema");
				String targetLayer = (String) targetMap.get("layer");
				String gubun = (String) targetMap.get("gubun");
				String name = (String) targetMap.get("name");

				// FilterFactory ff = CommonFactoryFinder.getFilterFactory();
				DataStore targetDataStore = null;

				try {
					targetDataStore = SHDataStore.getNewDataStore(schema);

					SimpleFeatureIterator multiIt = bufferResultCollection.features();
					Double nearest = null;
					SimpleFeature nearestSf = null;

					int newTargetId = 0;
					while (multiIt.hasNext()) {
						SimpleFeatureTypeBuilder targetTypeBuilder = new SimpleFeatureTypeBuilder();
						SimpleFeatureType targetSchema = targetDataStore.getFeatureSource(targetLayer).getSchema();
						targetTypeBuilder.init(targetSchema);

						targetTypeBuilder.add("d_distance", Double.class);
						targetTypeBuilder.add("d_buffer", Double.class);
						SimpleFeatureType newTargetSchema = targetTypeBuilder.buildFeatureType();
						SimpleFeatureBuilder targetSimpleFeatureBuilder = new SimpleFeatureBuilder(newTargetSchema);
						ListFeatureCollection newMultiFc = new ListFeatureCollection(newTargetSchema);

						int intersectsCnt = 0;
						SimpleFeature multiSf = multiIt.next();
						Geometry multiGeom = (Geometry) multiSf.getDefaultGeometry();

						MultiPolygon multiPolygon = (MultiPolygon) multiGeom;
						Polygon[] polygonsWithoutHoles = new Polygon[multiPolygon.getNumGeometries()];

						for (int X = 0; X < multiPolygon.getNumGeometries(); X++) {
							Polygon polygon = (Polygon) multiPolygon.getGeometryN(X);

							// 홀 없이 외곽 링만으로 새로운 폴리곤 생성
							// LinearRing[] inRings = new LinearRing[0];
							// new Polygon(
							Polygon polygonWithoutHoles = new Polygon(polygon.getExteriorRing(), null, gf);
							polygonsWithoutHoles[X] = polygonWithoutHoles;
						}

						// 홀 없는 멀티폴리곤 생성
						multiGeom = new MultiPolygon(polygonsWithoutHoles, gf);

						// multiGeom = multiGeom.buffer(0);
						SimpleFeatureCollection targetSfc = targetDataStore.getFeatureSource(targetLayer).getFeatures();
						SimpleFeatureIterator targetIt = null;

						try {
							targetIt = targetSfc.features();
							while (targetIt.hasNext()) {
								SimpleFeature targetSf = targetIt.next();
								Geometry targetGeom = (Geometry) targetSf.getDefaultGeometry();

								try {
									if (multiGeom.intersects(targetGeom.getCentroid())) {
										newTargetId++;
										SimpleFeature newTargetSf = targetSimpleFeatureBuilder
												.buildFeature("" + newTargetId);

										List<AttributeDescriptor> targetDescs = targetSf.getFeatureType()
												.getAttributeDescriptors();
										for (AttributeDescriptor desc : targetDescs) {
											Object o = targetSf.getAttribute(desc.getLocalName());
											newTargetSf.setAttribute(desc.getLocalName(), o);
										}

										intersectsCnt++;
//								double dis = multiGeom.distance(targetGeom.getCentroid());

										// 직선거리 m단위 구하기
										CoordinateReferenceSystem crs = CRS.decode("EPSG:4326");
										GeodeticCalculator gc = new GeodeticCalculator(crs);
//								gc.setStartingPosition(
//										JTS.toDirectPosition(targetGeom.getCentroid(), crs));
										gc.setStartingPosition(
												JTS.toDirectPosition(DistanceOp.closestPoints(targetGeom, pt)[0], crs));
										gc.setDestinationPosition(JTS.toDirectPosition(pt.getCoordinate(), crs));

										double dis = gc.getOrthodromicDistance();
										newTargetSf.setAttribute("d_distance", dis);
										newTargetSf.setAttribute("d_buffer", multiSf.getAttribute("distance"));
										newMultiFc.add(newTargetSf);

										if (nearest == null || dis < nearest) {
											nearest = dis;
											nearestSf = targetSf;
										}
									}
								} catch(NullPointerException e) {
									logger.debug(e);
								} catch (Exception e) {
									logger.debug(e);
								}

							}

						} finally {
							try {
								targetIt.close();
							} catch(NullPointerException e) {
								logger.debug(e);
							} catch (Exception e) {
								logger.debug(e);
							}
						}

						SimpleFeature newSf = newFeatureBuilder.buildFeature("" + 1);
						List<AttributeType> attributeTypes = multiSf.getFeatureType().getTypes();
						for (AttributeType type : attributeTypes) {
							newSf.setAttribute(type.getName(), multiSf.getAttribute(type.getName()));
							// sf.getAttribute(type.getName());
						}

						newSf.setAttribute("gubun", (String) gubun);
						newSf.setAttribute("d_distance", (Double) nearest);
						newSf.setAttribute("count", intersectsCnt);
						if (nearestSf != null) {
							newSf.setAttribute("nearest_nm", (String) nearestSf.getAttribute(name));
						} else {
							newSf.setAttribute("nearest_nm", nearestSf);
						}

						Util.shpExport(exportId, targetLayer + "_" + multiSf.getAttribute("distance"), newMultiFc);

						JSONArray ja = SHJsonHelper.simpleFeatureCollectionToJson(newMultiFc);
						newSf.setAttribute("sub_features", ja);
						newFc.add(newSf);
					}

					JSONArray ja = SHJsonHelper.simpleFeatureCollectionToJson(newFc);
					Util.shpExport(exportId, targetLayer, newFc);
					newResults.put(targetLayer, ja);
				} finally {
					SHDataStore.dispose(targetDataStore);
				}
			}
		} finally {
			SHDataStore.dispose(srcDataStore);
		}

		Util.mapExport(exportId, "result", newResults);
		return newResults;
	}

	/*
	 * 기초생활인프라분석 : 네트워크 입지분석(거리) 포인트(단일)의 네트워크 거리를 받아서 해당 반경 내에 속하는 시설 뽑아내기 추출 네트워크
	 * 거리 => 인터섹트
	 */
	public Map<String, JSONArray> getNetworkInterSect(String exportId, String inputWKT,
			List<Map<String, Object>> targetList, Integer walkMin) throws NullPointerException, Exception {

		DataStore srcDataStore = null;
		SingleConnectionDataSource datasource = null;
		Map<String, JSONArray> newResults = new HashMap<>();
		try {
			srcDataStore = SHDataStore.getDataStore();
			datasource = openServiceAreaDataSource();

			WKTReader2 reader = new WKTReader2();
			Geometry geo = (Geometry) reader.read(inputWKT);
			Point pt = geo.getCentroid();

			String serviceAreaWKT = excuteServiceArea(datasource, pt.getX(), pt.getY(), 4326, walkMin);

			// 서비스 영역 폴리곤
			SimpleFeature sfeature = createPolygonFeature(serviceAreaWKT);
			SimpleFeature[] arr = new SimpleFeature[1];
			arr[0] = sfeature;

			SimpleFeatureCollection sfcInput = new ListFeatureCollection(sfeature.getFeatureType(), arr);

			Geometry serviceAreaGeom = (Geometry) sfeature.getDefaultGeometry();
			Polygon servicePolygon = (Polygon) serviceAreaGeom;

			// 자치구 가져오기 (자치구 시설수를 구해야함)
			srcDataStore = SHDataStore.getNewDataStore(SHResource.getValue("sgg.schema"));
			SimpleFeatureCollection sggAllInput = srcDataStore.getFeatureSource(SHResource.getValue("sgg.layer.nm"))
					.getFeatures();

			SelectFeaturesProcessFactory factory1 = new SelectFeaturesProcessFactory();
			Process process1 = factory1.create();
			Map<String, Object> param1 = new HashMap<>();

			Filter sggFilter = CQL.toFilter("CONTAINS(the_geom, " + inputWKT + ")");

			param1.put(SelectFeaturesProcessFactory.inputFeatures.key, sggAllInput);
			param1.put(SelectFeaturesProcessFactory.filter.key, sggFilter);

			Map<String, Object> sggMap = process1.execute(param1, null);

			SimpleFeatureCollection sggInput = (SimpleFeatureCollection) sggMap
					.get(SelectFeaturesProcessFactory.RESULT.key);

			Util.shpExport(exportId, SHResource.getValue("sgg.layer.nm"), sfcInput);

			// 중첩으로 기초생활시설 가져오기
			// count, 구분, 거리계산 필요
			// target이 여러개

			Map<String, Object> targetMap = new HashMap<>();

			SimpleFeatureTypeBuilder newTypeBuilder = new SimpleFeatureTypeBuilder();
			newTypeBuilder.init(sfcInput.getSchema());
			newTypeBuilder.add("gubun", String.class);
			newTypeBuilder.add("d_distance", Double.class);
			newTypeBuilder.add("nearest_nm", String.class);
			newTypeBuilder.add("count", Integer.class);
			newTypeBuilder.add("sub_features", Object.class);
			newTypeBuilder.add("shortestPath", Object.class);

			newTypeBuilder.add("sgg_count", Integer.class);
			newTypeBuilder.add("sgg_name", String.class);
			newTypeBuilder.add("sid_count", Integer.class);

			SimpleFeatureType newSchema = newTypeBuilder.buildFeatureType();
			SimpleFeatureBuilder newFeatureBuilder = new SimpleFeatureBuilder(newSchema);

			for (int i = 0; i < targetList.size(); i++) {
				ListFeatureCollection newFc = new ListFeatureCollection(newSchema);

				targetMap = targetList.get(i);
				String schema = (String) targetMap.get("schema");
				String targetLayer = (String) targetMap.get("layer");
				String gubun = (String) targetMap.get("gubun");
				String name = (String) targetMap.get("name");

				DataStore targetDataStore = null;

				try {
					targetDataStore = SHDataStore.getNewDataStore(schema);

					int intersectsCnt = 0;
					Double nearest = null;
					SimpleFeature nearestSf = null;

					SimpleFeatureCollection targetSfc = targetDataStore.getFeatureSource(targetLayer).getFeatures();

					// 포인트집계. 자치구 내의 시설수 구하기
					PointStatisticsProcessFactory factory2 = new PointStatisticsProcessFactory();
					Process process2 = factory2.create();
					Map<String, Object> param2 = new HashMap<>();

					param2.put(PointStatisticsProcessFactory.polygonFeatures.key, sggInput);
					param2.put(PointStatisticsProcessFactory.pointFeatures.key, targetSfc);

					Map<String, Object> staticMap = process2.execute(param2, null);

					SimpleFeatureCollection staticCollection = (SimpleFeatureCollection) staticMap
							.get(SelectFeaturesProcessFactory.RESULT.key);

					// System.out.println(SHJsonHelper.simpleFeatureCollectionToJson(staticCollection));

					SimpleFeatureIterator targetIt = null;
//					if (targetLayer.indexOf("hsptl_asemby") >= 0) {
//						System.out.println();
//
//					}
					ListFeatureCollection newMultiFc = new ListFeatureCollection(targetSfc.getSchema());
					try {
						targetIt = targetSfc.features();
						while (targetIt.hasNext()) {
							SimpleFeature targetSf = targetIt.next();
							Geometry targetGeom = (Geometry) targetSf.getDefaultGeometry();

							if (servicePolygon.intersects(targetGeom.getCentroid())) {
								newMultiFc.add(targetSf);
								intersectsCnt++;
//						double dis = multiGeom.distance(targetGeom.getCentroid());

								// 직선거리 m단위 구하기
								CoordinateReferenceSystem crs = CRS.decode("EPSG:4326");
								GeodeticCalculator gc = new GeodeticCalculator(crs);
//						gc.setStartingPosition(
//								JTS.toDirectPosition(targetGeom.getCentroid(), crs));
								gc.setStartingPosition(
										JTS.toDirectPosition(DistanceOp.closestPoints(targetGeom, pt)[0], crs));
								gc.setDestinationPosition(JTS.toDirectPosition(pt.getCoordinate(), crs));

								double dis = gc.getOrthodromicDistance();

								if (nearest == null || dis < nearest) {
									nearest = dis;
									nearestSf = targetSf;
								}
							}
						}

					} finally {
						try {
							targetIt.close();
						} catch (NullPointerException e) {
							logger.debug(e);
						} catch (Exception e) {
							logger.debug(e);
						}
					}

					Util.shpExport(exportId, targetLayer + "_subs", newMultiFc);

					SimpleFeature newSf = newFeatureBuilder.buildFeature("" + 1);
					List<AttributeType> attributeTypes = sfeature.getFeatureType().getTypes();
					for (AttributeType type : attributeTypes) {
						newSf.setAttribute(type.getName(), sfeature.getAttribute(type.getName()));
					}

					newSf.setAttribute("gubun", (String) gubun);
					newSf.setAttribute("d_distance", (Double) nearest);
					newSf.setAttribute("count", intersectsCnt);
					if (nearestSf != null) {
						newSf.setAttribute("nearest_nm", (String) nearestSf.getAttribute(name));
					} else {
						newSf.setAttribute("nearest_nm", nearestSf);
					}

					JSONArray subFeatures = SHJsonHelper.simpleFeatureCollectionToJson(newMultiFc);
					newSf.setAttribute("sub_features", subFeatures);
					if (staticCollection.features().hasNext()) {
						newSf.setAttribute("sgg_count", staticCollection.features().next().getAttribute("count"));
						newSf.setAttribute("sgg_name",
								staticCollection.features().next().getAttribute("signgu_korean_nm"));
					} else {
						newSf.setAttribute("sgg_count", 0);
						newSf.setAttribute("sgg_name", "-");
					}
					newSf.setAttribute("sid_count", targetSfc.size());
					newFc.add(newSf);

					try {
						if (nearestSf != null) {
							newSf.setAttribute("shortestPath", excuteShortestPath(datasource, pt.getX(), pt.getY(), 4326,
									DistanceOp.closestPoints((Geometry) nearestSf.getDefaultGeometry(), pt)[0].x,
									DistanceOp.closestPoints((Geometry) nearestSf.getDefaultGeometry(), pt)[0].y));
						}
					} catch (NullPointerException e) {
						logger.debug("Null 오류");
					} catch (Exception e) {
						logger.debug("오류 발생 ");
					}

					Util.shpExport(exportId, targetLayer, newFc);
					JSONArray ja = SHJsonHelper.simpleFeatureCollectionToJson(newFc);
					newResults.put(targetLayer, ja);
				} finally {
					SHDataStore.dispose(targetDataStore);
				}
			}

		} catch(NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		} finally {
			SHDataStore.dispose(srcDataStore);
			destroyServiceAreaDatasource(datasource);
		}

		Util.mapExport(exportId, "result", newResults);
		return newResults;
	}

	// 서비스 영역 가져오기
	public String excuteServiceArea(SingleConnectionDataSource datasource, Double coordX, Double coordY, Integer srid,
			Integer walkMin) throws IOException {

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
		param.put("walk_min", walkMin);
		param.put("walk_speed", 60);
		param.put("distance", 60 * walkMin);
		param.put("edge_or_node", "node");
		param.put("convex_radius", 0.7);

		Map<String, Object> serviceAreaMap = getServiceArea(datasource, param);

		return (String) serviceAreaMap.get("service_area");
	}

	// 최단거리 link 가져오기
	public Map<String, Object> excuteShortestPath(SingleConnectionDataSource datasource, Double start_coord_x, Double start_coord_y, Integer srid,
			Double end_coord_x, Double end_coord_y) throws IOException {

//		URIBuilder uriBuilder = new URIBuilder().setScheme(SHResource.getValue("sh.server.schema"))
//				.setHost(SHResource.getValue("sh.server.url")).setPath("/shex/api/network/shortestPath")
//				.addParameter("start_coord_x", start_coord_x.toString())
//				.addParameter("start_coord_y", start_coord_y.toString())
//				.addParameter("end_coord_x", end_coord_x.toString())
//				.addParameter("end_coord_y", end_coord_y.toString());

//		if (srid != 0 && srid != null) {
//			uriBuilder.addParameter("srid", srid.toString());
//		}
//
//		CloseableHttpClient httpClient = HttpClients.createDefault();
//		HttpPost request = new HttpPost(uriBuilder.toString());
//
//		HttpResponse response = httpClient.execute(request);
//		String result = EntityUtils.toString(response.getEntity());
//
//		Map<String, Object> data = new HashMap<>();
//
//		try {
//			JSONParser jsonParser = new JSONParser();
//			JSONObject targetObj = (JSONObject) jsonParser.parse(result);
//
//			data = (Map<String, Object>) targetObj.get("DATA");
//
//		} catch (Exception e) {
//		}
//
//		httpClient.close();
		Map<String, Object> param = new HashMap<>();
		param.put("start_coord_x", start_coord_x);
		param.put("start_coord_y", start_coord_y);
		param.put("end_coord_x", end_coord_x);
		param.put("end_coord_y", end_coord_y);
		param.put("srid", srid);
		Map<String, Object> shortestMap = getShortestPath(datasource, param);

		return shortestMap;
	}

	private static SimpleFeature createPointFeature(Geometry g) {

		SimpleFeatureTypeBuilder typeBuilder = new SimpleFeatureTypeBuilder();
		typeBuilder.setName("Location");
		typeBuilder.setCRS(DefaultGeographicCRS.WGS84);

		typeBuilder.add("the_geom", Geometry.class);

		final SimpleFeatureType TYPE = typeBuilder.buildFeatureType();

		SimpleFeatureBuilder builder = new SimpleFeatureBuilder(TYPE);
		builder.add(g);

		SimpleFeature feature = builder.buildFeature(null);

		return feature;
	}

	private static SimpleFeature createPointFeature(Point point) {

		SimpleFeatureTypeBuilder typeBuilder = new SimpleFeatureTypeBuilder();
		typeBuilder.setName("Location");
		typeBuilder.setCRS(DefaultGeographicCRS.WGS84);

		typeBuilder.add("the_geom", Point.class);

		final SimpleFeatureType TYPE = typeBuilder.buildFeatureType();

		SimpleFeatureBuilder builder = new SimpleFeatureBuilder(TYPE);
		builder.add(point);

		SimpleFeature feature = builder.buildFeature(null);

		return feature;
	}

	private static SimpleFeature createPolygonFeature(String polygonWKT) {

		WKTReader2 reader = new WKTReader2();
		// Geometry geometry = reader.read(inputWKT);
		Polygon polygon = null;
		try {
			polygon = (Polygon) reader.read(polygonWKT);
		} catch (ParseException e) {
			try {
				polygon = (Polygon) reader.read(polygonWKT).buffer(0.00001);
			} catch (ParseException pe) {
				polygon = null;
			} catch (Exception ee) {
				polygon = null;
			}
		} catch(ClassCastException cce) {
			try {
				polygon = (Polygon) reader.read(polygonWKT).buffer(0.00001);
			} catch (ParseException pe) {
				polygon = null;
			} catch (Exception ee) {
				polygon = null;
			}
		}

		SimpleFeatureTypeBuilder typeBuilder = new SimpleFeatureTypeBuilder();
		typeBuilder.setName("serviceArea");
		typeBuilder.setCRS(DefaultGeographicCRS.WGS84);

		typeBuilder.add("the_geom", Polygon.class);

		final SimpleFeatureType TYPE = typeBuilder.buildFeatureType();

		SimpleFeatureBuilder builder = new SimpleFeatureBuilder(TYPE);
		builder.add(polygon);

		SimpleFeature feature = builder.buildFeature(null);

		return feature;
	}

}
