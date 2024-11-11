package egovframework.mango.analysis.quest.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.geotools.data.DataStore;
import org.geotools.data.collection.ListFeatureCollection;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.data.simple.SimpleFeatureIterator;
import org.geotools.factory.CommonFactoryFinder;
import org.geotools.feature.simple.SimpleFeatureBuilder;
import org.geotools.feature.simple.SimpleFeatureTypeBuilder;
import org.geotools.geometry.jts.WKTReader2;
import org.geotools.process.Process;
import org.geotools.process.spatialstatistics.IntersectProcessFactory;
import org.geotools.process.spatialstatistics.enumeration.DistanceUnit;
import org.geotools.referencing.CRS;
import org.geotools.referencing.crs.DefaultGeographicCRS;
import org.json.JSONException;
import org.json.XML;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.MultiPolygon;
import org.locationtech.jts.geom.Polygon;
import org.locationtech.jts.io.ParseException;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;
import org.opengis.filter.FilterFactory2;
import org.opengis.filter.spatial.Intersects;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import egovframework.mango.config.SHDataStore;
import egovframework.mango.config.SHResource;
import egovframework.mango.util.SHJsonHelper;

@Service
public class AnalysisQuestService {

	private static Logger logger = LogManager.getLogger(AnalysisQuestService.class);

	@Autowired
	private AnalysisQuestServiceData data;

	/*
	 * 대상지 탐색(통계) 지역을 받아서 (wkt) 해당 지역의 건축물대장, 토지특성등의 정보 불러오기 (API사용)
	 * 
	 */
	public Map<String, JSONArray> getIntersectQuest(String inputWKT) throws NullPointerException, Exception {

		Map<String, JSONArray> resultJson = new HashMap<>();
		if (inputWKT != null && inputWKT.length() > 0) {

			// 중첩되는 지적도 뜯어오기 : inputWKT를 폴리곤으로 변환. 지적도와 intersect
			//SimpleFeature polygon = createPolygonFeature(inputWKT);
//		SimpleFeature[] arr = new SimpleFeature[1];
//		arr[0] = polygon;

			// SimpleFeatureCollection sfcInput = new
			// ListFeatureCollection(polygon.getFeatureType(), arr);

//		//지적도 레이어 가져오기
//		DataStore dataStore = SHDataStore.getNewDataStore(SHResource.getValue("lsmd.schema"));
//		SimpleFeatureCollection lsmdCollection = dataStore.getFeatureSource(SHResource.getValue("lsmd.layer.nm")).getFeatures();
//	
//		//인터섹트 진행
//		ListFeatureCollection lsmdFeatrueCollection = intersectLyr((Geometry) polygon.getDefaultGeometry(), lsmdCollection);				
//		
//		//결과에서 PNU 코드를 가져와서 건축물대장, 토지특성 등의 정보 추출
//		SimpleFeatureIterator lsmdIt = lsmdFeatrueCollection.features();

			List<Map<String, Object>> pnuList = interectParcel(inputWKT, null, 3857);
			Iterator<Map<String, Object>> pnuIt = pnuList.iterator();

			JSONArray buldList = new JSONArray();
			JSONArray landList = new JSONArray();
			JSONArray indvdList = new JSONArray();
			JSONArray apartList = new JSONArray();
			JSONArray indvdHouseList = new JSONArray();

			String pnu = "";

			// 합계 및 평균값
			Map<String, Map<String, Double>> sourceStat = new HashMap<>();

//		Map<String, Double> buldValue = new HashMap<>();
//		sourceStat.put("buld", buldValue);
			sourceStat.put("buld", new HashMap<String, Double>());
			// sourceStat.put("land", new HashMap<>());
			sourceStat.put("landPrice", new HashMap<String, Double>());
			sourceStat.put("apartPrice", new HashMap<String, Double>());
			sourceStat.put("indvdPrice", new HashMap<String, Double>());

			sourceStat.get("landPrice").put("sum", 0.0);
			sourceStat.get("landPrice").put("count", 0.0);

			sourceStat.get("apartPrice").put("sum", 0.0);
			sourceStat.get("apartPrice").put("count", 0.0);

			sourceStat.get("indvdPrice").put("sum", 0.0);
			sourceStat.get("indvdPrice").put("count", 0.0);

			while (pnuIt.hasNext()) {
				Map<String, Object> parcel = pnuIt.next();

//			pnu = (String) lsmdSf.getAttribute(SHResource.getValue("lsmd.pnu.column"));
				pnu = (String) parcel.get("pnu");

				JSONObject buld = getBrTitleInfo(pnu);
				if ((Long) buld.get("totalCount") > 0) {
					buld.put("pnu", pnu);
					// 건축물대장정보 넣기
					buldList.add(buld);
				}

				JSONObject land = getLandCharacteristics(pnu);
				if (land != null && Integer.parseInt((String) land.get("totalCount")) > 0) {
					landList.add(land);
				}

				JSONObject landPrice = getIndvdLandPriceAttr(pnu);
//			if (!sourceStat.get("landPrice").containsKey("sum")) {
//				sourceStat.get("landPrice").put("sum", 0.0);
//			}
//			if (!sourceStat.get("landPrice").containsKey("count")) {
//				sourceStat.get("landPrice").put("count", 0.0);
//			}
				if (landPrice != null && Integer.parseInt((String) landPrice.get("totalCount")) > 0) {

					JSONArray fields = (JSONArray) landPrice.get("field");
					JSONObject field = (JSONObject) fields
							.get(Integer.parseInt((String) landPrice.get("totalCount")) - 1);

					sourceStat.get("landPrice").put("sum", Double.sum(sourceStat.get("landPrice").get("sum"),
							Double.parseDouble((String) field.get("pblntfPclnd"))));
					sourceStat.get("landPrice").put("count", sourceStat.get("landPrice").get("count") + 1);

					indvdList.add(landPrice);
				}

				JSONObject apartPrice = getApartHousingPriceAttr(pnu, "1");
//			if (!sourceStat.get("apartPrice").containsKey("sum")) {
//				sourceStat.get("apartPrice").put("sum", 0.0);
//			}
//			if (!sourceStat.get("apartPrice").containsKey("count")) {
//				sourceStat.get("apartPrice").put("count", 0.0);
//			}
				if (apartPrice != null && Integer.parseInt((String) apartPrice.get("totalCount")) > 0) {

					JSONArray fields = (JSONArray) apartPrice.get("field");

					for (int i = 0; i < fields.size(); i++) {
						JSONObject field = (JSONObject) fields.get(i);
						sourceStat.get("apartPrice").put("sum", Double.sum(sourceStat.get("apartPrice").get("sum"),
								Double.parseDouble((String) field.get("pblntfPc"))));
						sourceStat.get("apartPrice").put("count", sourceStat.get("apartPrice").get("count") + 1);

					}

					apartList.add(apartPrice);

					Double totalPage = Math.ceil(Double.parseDouble((String) apartPrice.get("totalCount")) / 1000);

					if (totalPage > 1) {

						for (int curPage = 2; curPage <= totalPage; curPage++) {
							JSONObject curApartPrice = getApartHousingPriceAttr(pnu, "" + curPage);

							JSONArray curFields = (JSONArray) curApartPrice.get("field");

							for (int j = 0; j < curFields.size(); j++) {
								JSONObject curField = (JSONObject) curFields.get(j);
								sourceStat.get("apartPrice").put("sum",
										Double.sum(sourceStat.get("apartPrice").get("sum"),
												Double.parseDouble((String) curField.get("pblntfPc"))));
								sourceStat.get("apartPrice").put("count",
										sourceStat.get("apartPrice").get("count") + 1);
							}

							apartList.add(curApartPrice);
						}
					}

				}

				JSONObject indvdPrice = getIndvdHousingPriceAttr(pnu);
//			if (!sourceStat.get("indvdPrice").containsKey("sum")) {
//				sourceStat.get("indvdPrice").put("sum", 0.0);
//			}
//			if (!sourceStat.get("indvdPrice").containsKey("count")) {
//				sourceStat.get("indvdPrice").put("count", 0.0);
//			}
				if (indvdPrice != null && Integer.parseInt((String) indvdPrice.get("totalCount")) > 0) {

					JSONArray fields = (JSONArray) indvdPrice.get("field");
					JSONObject field = (JSONObject) fields
							.get(Integer.parseInt((String) indvdPrice.get("totalCount")) - 1);

					sourceStat.get("indvdPrice").put("sum", Double.sum(sourceStat.get("indvdPrice").get("sum"),
							Double.parseDouble((String) field.get("housePc"))));
					sourceStat.get("indvdPrice").put("count", sourceStat.get("indvdPrice").get("count") + 1);

					indvdHouseList.add(indvdPrice);
				}

			}

			sourceStat.get("landPrice").put("avg",
					sourceStat.get("landPrice").get("sum") / sourceStat.get("landPrice").get("count"));
			indvdList.add(sourceStat.get("landPrice"));

			sourceStat.get("apartPrice").put("avg",
					sourceStat.get("apartPrice").get("sum") / sourceStat.get("apartPrice").get("count"));
			apartList.add(sourceStat.get("apartPrice"));

			sourceStat.get("indvdPrice").put("avg",
					sourceStat.get("indvdPrice").get("sum") / sourceStat.get("indvdPrice").get("count"));
			indvdHouseList.add(sourceStat.get("indvdPrice"));

//		JSONArray ja = SHJsonHelper.simpleFeatureCollectionToJson(lsmdFeatrueCollection);
//		resultJson.put("lsmd", ja);
			JSONArray lsmd = new JSONArray();
			for (Map<String, Object> tt : pnuList) {
				JSONObject json = new JSONObject();
				for (Map.Entry<String, Object> entry : tt.entrySet()) {
					String key = entry.getKey();
					Object value = entry.getValue();
					json.put(key, value);
				}
				lsmd.add(json);
			}
			resultJson.put("lsmd", lsmd);

			// 건축물대장
			resultJson.put("buld", buldList);
			// 토지특성
			resultJson.put("land", landList);
			// 개별공시지가
			resultJson.put("landPrice", indvdList);
			// 공동주택가격
			resultJson.put("apartPrice", apartList);
			// 개별주택가격
			resultJson.put("indvdPrice", indvdHouseList);

			// 통계값
			JSONArray statistics = new JSONArray();

			statistics.add(data.selectIndvdlzHousePc(pnu.substring(0, 5)));
			statistics.add(data.selectCopertnHousePc(pnu.substring(0, 5)));
			statistics.add(data.selectPnilp(pnu.substring(0, 5)));
			statistics.add(data.selectBild(pnu.substring(0, 5)));

			resultJson.put("statistics", statistics);

//		SHDataStore.dispose(dataStore);

			return resultJson;
		} else {
			return resultJson;
		}
	}

	// 건축물대장 정보 가져오기
	public JSONObject getBrTitleInfo(String pnu) throws IOException {

		URIBuilder uriBuilder = new URIBuilder().setScheme("http").setHost(SHResource.getValue("data.api.url"))
				// .setPath("/ned/data/getLandCharacteristics")
				.setPath(SHResource.getValue("getBrTitleInfo.path")).addParameter("sigunguCd", pnu.substring(0, 5))
				.addParameter("bjdongCd", pnu.substring(5, 10))
				.addParameter("platGbCd", "" + (Integer.valueOf(pnu.substring(10, 11)) - 1))
				.addParameter("bun", pnu.substring(11, 15)).addParameter("ji", pnu.substring(15, 19))
				.addParameter("ServiceKey", SHResource.getValue("data.api.key"));

		CloseableHttpClient httpClient = HttpClients.createDefault();
		HttpGet request = new HttpGet(uriBuilder.toString());
		request.setHeader("Content-Type", "application/json");

		HttpResponse response = httpClient.execute(request);
		String result = EntityUtils.toString(response.getEntity());

		// xmlToJson(result);
//		System.out.println(xmlToJson(result));
		JSONObject data = new JSONObject();

		try {
			JSONParser jsonParser = new JSONParser();
//			JSONObject targetObj = (JSONObject) jsonParser.parse(result);
			JSONObject targetObj = (JSONObject) jsonParser.parse(xmlToJson(result));
			data = (JSONObject) ((JSONObject) targetObj.get("response")).get("body");

//			data = (Map<String, Object>) targetObj.get("response");

		} catch (NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		}

		httpClient.close();
//		System.out.println(result);

		return data;
	}

	// 토지특성 정보 가져오기
	public JSONObject getLandCharacteristics(String pnu) throws IOException {

		URIBuilder uriBuilder = new URIBuilder().setScheme("https").setHost(SHResource.getValue("vworld.api.url"))
				// .setPath("/ned/data/getLandCharacteristics")
				.setPath(SHResource.getValue("getLandCharacteristics.path")).addParameter("pnu", pnu)
				.addParameter("pageNo", "1").addParameter("stdrYear", SHResource.getValue("vworld.api.stdrYear"))
				.addParameter("numOfRows", "1000").addParameter("format", "json")
				.addParameter("domain", SHResource.getValue("vworld.api.domain"))
				.addParameter("key", SHResource.getValue("vworld.api.key"));

		CloseableHttpClient httpClient = HttpClients.createDefault();
		HttpGet request = new HttpGet(uriBuilder.toString());
		request.setHeader("Content-Type", "application/json");

		HttpResponse response = httpClient.execute(request);
		String result = EntityUtils.toString(response.getEntity());
		JSONObject data = new JSONObject();

		try {
			JSONParser jsonParser = new JSONParser();
			JSONObject targetObj = (JSONObject) jsonParser.parse(result);
			data = (JSONObject) targetObj.get("landCharacteristicss");

			if (data.isEmpty()) {
				data = (JSONObject) targetObj.get("response");
			}
//			data = (Map<String, Object>) targetObj.get("response");

		} catch (NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		}

		// System.out.println(data);
		httpClient.close();
//		System.out.println(result);

		return data;
	}

	// 개별공시지가 정보 가져오기
	public JSONObject getIndvdLandPriceAttr(String pnu) throws IOException {

		URIBuilder uriBuilder = new URIBuilder().setScheme("https").setHost(SHResource.getValue("vworld.api.url"))
				.setPath(SHResource.getValue("getIndvdLandPriceAttr.path")).addParameter("pnu", pnu)
				.addParameter("pageNo", "1").addParameter("stdrYear", SHResource.getValue("vworld.api.stdrYear"))
				.addParameter("numOfRows", "1000").addParameter("format", "json")
				.addParameter("domain", SHResource.getValue("vworld.api.domain"))
				.addParameter("key", SHResource.getValue("vworld.api.key"));

		CloseableHttpClient httpClient = HttpClients.createDefault();
		HttpGet request = new HttpGet(uriBuilder.toString());
		request.setHeader("Content-Type", "application/json");

		HttpResponse response = httpClient.execute(request);
		String result = EntityUtils.toString(response.getEntity());
		JSONObject data = new JSONObject();

		try {
			JSONParser jsonParser = new JSONParser();
			JSONObject targetObj = (JSONObject) jsonParser.parse(result);
			data = (JSONObject) targetObj.get("indvdLandPrices");

			if (data.isEmpty()) {
				data = (JSONObject) targetObj.get("response");
			}

		} catch (NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		}

		// System.out.println(data);
		httpClient.close();
//			System.out.println(result);

		return data;
	}

	// 공동주택가격 정보 가져오기
	public JSONObject getApartHousingPriceAttr(String pnu, String page) throws IOException {

		URIBuilder uriBuilder = new URIBuilder().setScheme("https").setHost(SHResource.getValue("vworld.api.url"))
				.setPath(SHResource.getValue("getApartHousingPriceAttr.path")).addParameter("pnu", pnu)
				.addParameter("pageNo", page).addParameter("stdrYear", SHResource.getValue("vworld.api.stdrYear"))
				.addParameter("numOfRows", "1000").addParameter("format", "json")
				.addParameter("domain", SHResource.getValue("vworld.api.domain"))
				.addParameter("key", SHResource.getValue("vworld.api.key"));

		CloseableHttpClient httpClient = HttpClients.createDefault();
		HttpGet request = new HttpGet(uriBuilder.toString());
		request.setHeader("Content-Type", "application/json");

		HttpResponse response = httpClient.execute(request);
		String result = EntityUtils.toString(response.getEntity());
		JSONObject data = new JSONObject();

		try {
			JSONParser jsonParser = new JSONParser();
			JSONObject targetObj = (JSONObject) jsonParser.parse(result);
			data = (JSONObject) targetObj.get("apartHousingPrices");

			if (data.isEmpty()) {
				data = (JSONObject) targetObj.get("response");
			}

		} catch (NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		}

		// System.out.println(data);
		httpClient.close();
//				System.out.println(result);

		return data;
	}

	// 개별주택가격 정보 가져오기
	public JSONObject getIndvdHousingPriceAttr(String pnu) throws IOException {

		URIBuilder uriBuilder = new URIBuilder().setScheme("https").setHost(SHResource.getValue("vworld.api.url"))
				.setPath(SHResource.getValue("getIndvdHousingPriceAttr.path")).addParameter("pnu", pnu)
				.addParameter("pageNo", "1").addParameter("stdrYear", SHResource.getValue("vworld.api.stdrYear"))
				.addParameter("numOfRows", "1000").addParameter("format", "json")
				.addParameter("domain", SHResource.getValue("vworld.api.domain"))
				.addParameter("key", SHResource.getValue("vworld.api.key"));

		CloseableHttpClient httpClient = HttpClients.createDefault();
		HttpGet request = new HttpGet(uriBuilder.toString());
		request.setHeader("Content-Type", "application/json");

		HttpResponse response = httpClient.execute(request);
		String result = EntityUtils.toString(response.getEntity());
		JSONObject data = new JSONObject();

		try {
			JSONParser jsonParser = new JSONParser();
			JSONObject targetObj = (JSONObject) jsonParser.parse(result);
			data = (JSONObject) targetObj.get("indvdHousingPrices");

			if (data.isEmpty()) {
				data = (JSONObject) targetObj.get("response");
			}

		} catch (NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		}

		// System.out.println(data);
		httpClient.close();
//					System.out.println(result);

		return data;
	}

	private static SimpleFeature createPolygonFeature(String polygonWKT) throws NullPointerException, Exception {

		WKTReader2 reader = new WKTReader2();
		// Geometry geometry = reader.read(inputWKT);
//		Polygon polygon = null;
//		MultiPolygon multiPolygon = null;
		Geometry geom = null;

		try {
//			polygon = (Polygon) reader.read(polygonWKT);
			geom = reader.read(polygonWKT);
//			multiPolygon = (MultiPolygon) reader.read(polygonWKT);

		} catch (ParseException e) {
			logger.debug("파싱오류 ", e);
		}

		SimpleFeatureTypeBuilder typeBuilder = new SimpleFeatureTypeBuilder();
		typeBuilder.setName("drawLayer");
//		typeBuilder.setCRS(CRS.decode("EPSG:3857"));
		typeBuilder.setCRS(DefaultGeographicCRS.WGS84);

//		typeBuilder.add("the_geom", MultiPolygon.class);
		if (geom.getGeometryType().equals("MultiPolygon")) {
			typeBuilder.add("the_geom", MultiPolygon.class);
		} else {
			typeBuilder.add("the_geom", Polygon.class);
		}

		final SimpleFeatureType TYPE = typeBuilder.buildFeatureType();

		SimpleFeatureBuilder builder = new SimpleFeatureBuilder(TYPE);
		builder.add(geom);

		SimpleFeature feature = builder.buildFeature(null);

		return feature;
	}

	private ListFeatureCollection intersectLyr(Geometry inputGeom, SimpleFeatureCollection overapLyr) throws NullPointerException, Exception {

		FilterFactory2 ff = CommonFactoryFinder.getFilterFactory2();
		Intersects intersects = ff.intersects(ff.property("the_geom"), ff.literal(inputGeom));
		SimpleFeatureCollection result = overapLyr.subCollection(intersects);
		ListFeatureCollection list = new ListFeatureCollection(result);

		return list;
	}

	// 지적도 가져오기 (중심점 기준으로)
	public List<Map<String, Object>> interectParcel(String areaWkt, String layerNm, Integer srid) throws IOException {

		URIBuilder uriBuilder = new URIBuilder().setScheme(SHResource.getValue("sh.server.schema", "https"))
				.setHost(SHResource.getValue("sh.server.url", "shgis.syesd.co.kr"))
				.setPath("/shex/api/geocode/interectParcel").addParameter("area_wkt", areaWkt);

		if (srid != null && srid != 0) {
			uriBuilder.addParameter("srid", srid.toString());
		}

		if (layerNm != null) {
			uriBuilder.addParameter("layer_nm", layerNm);
		}

		CloseableHttpClient httpClient = HttpClients.createDefault();
		HttpPost request = new HttpPost(uriBuilder.toString());

		HttpResponse response = httpClient.execute(request);
		String result = EntityUtils.toString(response.getEntity());

		List<Map<String, Object>> data = new ArrayList<>();

		try {
			JSONParser jsonParser = new JSONParser();
			JSONObject targetObj = (JSONObject) jsonParser.parse(result);

			data = (List<Map<String, Object>>) targetObj.get("DATA");

		} catch (NullPointerException e) {
			logger.debug("파싱오류 ");
		} catch (Exception e) {
			logger.debug("파싱오류 ");
		}

		httpClient.close();
//			System.out.println(result);

		return data;
	}

	private String xmlToJson(String xml) {
		org.json.JSONObject jObject;
		String output = null;
		try {
			jObject = XML.toJSONObject(xml);
			ObjectMapper mapper = new ObjectMapper();
			mapper.enable(SerializationFeature.INDENT_OUTPUT);
			Object json = mapper.readValue(jObject.toString(), Object.class);
			output = mapper.writeValueAsString(json);
		} catch (NullPointerException e) {
			logger.debug("파싱오류 ");
		} catch (Exception e) {
			logger.debug("파싱오류 ");
		}

		return output;
	}

}
