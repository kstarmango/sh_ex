package egovframework.mango.analysis.business.web;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.geotools.data.collection.ListFeatureCollection;
import org.geotools.data.simple.SimpleFeatureIterator;
import org.json.simple.parser.JSONParser;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.io.WKTReader;
import org.opengis.feature.simple.SimpleFeature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import egovframework.mango.analysis.business.service.AnalysisBusinessService;
import egovframework.mango.config.SHResource;
import egovframework.mango.util.SHJsonHelper;
import egovframework.mango.util.Util;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.zaol.common.web.BaseController;
import egovframework.zaol.common.web.JavaScriptHelper;
import net.sf.json.JSONObject;

@Controller
public class AnalysisBusinessController extends BaseController {

	private static Logger logger = LogManager.getLogger(AnalysisBusinessController.class);
	private ObjectMapper mapper;

	private static JavaScriptHelper javaScriptHelper = new JavaScriptHelper();

	@Autowired
	private AnalysisBusinessService analyBizService;

	@PostConstruct
	public void initIt() throws NullPointerException {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}

	@RequestMapping(value = { RequestMappingConstants.WEB_ANAL_BIZ_BASIC_LOCATION }, method = { RequestMethod.GET,
			RequestMethod.POST })
	public String basicLocationOverlap(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "inputFeature", required = false) String inputFeature,
			@RequestParam(value = "overlayLyrs", required = false) String overlayLyrs, ModelMap model)
			throws NullPointerException, Exception {

		String exportId = getResultExportId();
		response.setHeader("export_key", exportId);

		JSONObject obj = new JSONObject();
		response.setContentType("text/html;	charset=" + javaScriptHelper.GetEncodingType());
		PrintWriter out = response.getWriter();

		try {
			WKTReader reader = new WKTReader();

			Geometry geom = reader.read(inputFeature);
			Map<String, Object> result = analyBizService.intersectLyrs(exportId, geom, overlayLyrs);

			obj.put("result", true);
			obj.put("data", result);

		} catch (NullPointerException e) {
			obj.put("result", false);
			obj.put("data", "");

		} catch (Exception e) {
			obj.put("result", false);
			obj.put("data", "");
		}

		out.println(obj.toString());
		model.addAttribute("resultData", obj);

		return "analysis/location/popup/basicLocOverlapPopup.part";
	}

	@RequestMapping(value = { RequestMappingConstants.WEB_ANAL_SIMILAR_BIZ }, method = { RequestMethod.GET,
			RequestMethod.POST })
	public void similarBiz(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "inputFeature", required = false) String inputFeature,
			@RequestParam(value = "analyType", required = false) String analyType,
			@RequestParam(value = "buffer", required = false) Double buffer,
			@RequestParam(value = "overlayLyr", required = false) String overlayLyr, ModelMap model)
			throws NullPointerException, Exception {

		String exportId = getResultExportId();
		response.setHeader("export_key", exportId);
		JSONObject obj = new JSONObject();
		response.setContentType("text/html;	charset=" + javaScriptHelper.GetEncodingType());
		PrintWriter out = response.getWriter();

		try {

			WKTReader reader = new WKTReader();
			Geometry geom = reader.read(inputFeature);
			String geomType = geom.getGeometryType();

			if (analyType.equals("nearby")) { // 인근
				// if (geomType == "Polygon") {
				// get Centroid
				geom = geom.getCentroid();
				// }

				Double length = Util.transformUnit(5179, 4326, buffer);

				// buffer
				Geometry bufferGeom = geom.buffer(length);

				ListFeatureCollection intersectFeatures = analyBizService.intersectLyr(exportId, bufferGeom,
						overlayLyr);

				String result = SHJsonHelper.featureCollectionToGeoJson(intersectFeatures);

				obj.put("result", result);
				// intersect

			} else if (analyType.equals("overlap")) { // 중첩
				// intersect
				ListFeatureCollection intersectFeatures = analyBizService.intersectLyr(exportId, geom, overlayLyr);

				String result = SHJsonHelper.featureCollectionToGeoJson(intersectFeatures);

				obj.put("result", true);
				obj.put("data", result);
			} else if (analyType.equals("adjoin")) { // 인접
				Geometry polyGeom = null;
				geom = geom.getCentroid();
				// if (geomType == "Point") {
				// getFeature in landsys_gis.ctnu_lgstr_su
				String layerNm = SHResource.getValue("lsmd.schema") + "." + SHResource.getValue("lsmd.layer.nm");
				ListFeatureCollection features = analyBizService.intersectLyr(exportId, geom, layerNm);

				SimpleFeatureIterator sfi = features.features();
				while (sfi.hasNext()) {
					SimpleFeature sf = sfi.next();
					if (sf != null) {
						polyGeom = (Geometry) sf.getDefaultGeometry();
					}
				}

				// }
				// intersect
				String result = "";
				if (polyGeom == null) {
					result = "해당 포인트에 중첩되는 피쳐가 없습니다.";
				} else {
					ListFeatureCollection intersectFeatures = analyBizService.intersectLyr(exportId, polyGeom,
							overlayLyr);

					result = SHJsonHelper.featureCollectionToGeoJson(intersectFeatures);
				}
				obj.put("result", true);
				obj.put("data", result);
			}

			// out.println(obj.toString());

		} catch (NullPointerException e) {
			obj.put("result", false);
			obj.put("data", "");

			// out.println(obj.toString());
			// System.out.println(e);
		} catch (Exception e) {
			obj.put("result", false);
			obj.put("data", "");

			// out.println(obj.toString());
			// System.out.println(e);
		}
		out.println(obj.toString());

	}

//	관련사업 입지 분석
	@RequestMapping(value = { RequestMappingConstants.WEB_ANAL_RELATED_BIZ }, method = { RequestMethod.GET,
			RequestMethod.POST })
	public void relatedBiz(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "inputLyr", required = false) String inputLyr,
			@RequestParam(value = "analyArea", required = false) String analyArea,
			@RequestParam(value = "overlayLyrs", required = false) String overlayLyrs, ModelMap model)
			throws NullPointerException, Exception {

		String exportId = getResultExportId();
		response.setHeader("export_key", exportId);

		JSONObject obj = new JSONObject();
		response.setContentType("text/html;	charset=" + javaScriptHelper.GetEncodingType());
		PrintWriter out = response.getWriter();

		try {
			Geometry geom = null;
			if (analyArea != null && !analyArea.equals("")) {
				WKTReader reader = new WKTReader();
				geom = reader.read(analyArea);
			}

			Map<String, String> result = analyBizService.lyrIntersect(exportId, inputLyr, geom, overlayLyrs);

			obj.put("result", true);
			obj.put("data", result);

			// feature collectoin intersect feature collection
		} catch (NullPointerException e) {
			obj.put("result", false);
			obj.put("data", "");
			// out.println(obj.toString());
			// System.out.println(e);
		} catch (Exception e) {
			obj.put("result", false);
			obj.put("data", "");
			// out.println(obj.toString());
			// System.out.println(e);
		}
		out.println(obj.toString());
	}

	// 반경거리 중첩 분석
	/*
	 * targetListStr 예시 교집합 {target:[{schema: 'landsys_gis',layer:
	 * 'rdnmadr_bass_map_subway_statn',distance: 500}, {schema: 'landsys_gis',layer:
	 * 'univ',distance: 1000}]} targetListStr로 나머지
	 * 
	 * 멀티링 distance로 , 포함해서 targetListStr에서 distance 빼고 보내라
	 * 
	 * type : multiring, intersect
	 */
	@RequestMapping(value = { RequestMappingConstants.WEB_ANAL_BUFFER_BIZ }, method = { RequestMethod.POST })
	public void buffer(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "inputSchema", required = false) String inputSchema,
			@RequestParam(value = "inputFeatures", required = true) String inputFeatures,
			@RequestParam(value = "distance", required = false) String distance,
			@RequestParam(value = "unit", required = false) String distanceUnit,
			@RequestParam(value = "targetSchema", required = false) String targetSchema,
			@RequestParam(value = "targetFeatures", required = false) String targetFeatures,
			@RequestParam(value = "outsideOnly", required = false) String outsideOnly,
			@RequestParam(value = "dissolve", required = false) String dissolve,
			@RequestParam(value = "sggCd", required = true) String sggCd,
			@RequestParam(value = "type", required = false) String analysisType,
			@RequestParam(value = "targetListStr", required = false) String targetListStr)
			throws NullPointerException, Exception {

		boolean boutsideOnly = true;
		boolean bdissolve = false;

		if (outsideOnly != null) {
			try {
				boutsideOnly = Boolean.valueOf(outsideOnly);
			} catch (NullPointerException e) {
				logger.debug(e);
			} catch (Exception e) {
				logger.debug(e);
			}
		}

		if (dissolve != null) {
			try {
				bdissolve = Boolean.valueOf(dissolve);
			} catch (NullPointerException e) {
				logger.debug(e);
			} catch (Exception e) {
				logger.debug(e);
			}
		}

//			JSONArray result = null;
		String exportId = getResultExportId();
		response.setHeader("export_key", exportId);
		List resultList = new ArrayList<>();
		if (analysisType.equals("multiring")) {

			List result = analyBizService.getMultipleRingBufferIntersectFeatures(exportId, inputSchema, inputFeatures,
					targetSchema, targetFeatures, distance, distanceUnit, boutsideOnly, bdissolve, sggCd);

			resultList.add(result);

		} else {
			List<Map<String, Object>> targetList = new ArrayList<>();
			JSONParser jsonParser = new JSONParser();
			org.json.simple.JSONObject obj = (org.json.simple.JSONObject) jsonParser.parse(targetListStr);

			try {
//					targetList = new ObjectMapper().readValue(targetListStr, new TypeReference<Map<String, Object>>() {});
				targetList = (List<Map<String, Object>>) obj.get("target");

			} catch (NullPointerException e) {
				logger.debug(e);
			} catch (Exception e) {
				logger.debug(e);
			}

			resultList = analyBizService.getBufferIntersectFeatures(exportId, inputSchema, inputFeatures, targetList,
					sggCd);
		}

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		JSONObject obj = new JSONObject();
		obj.put("result", resultList);

		PrintWriter out = response.getWriter();
		out.println(obj.toString());

	}

	// 네트워크 중첩 분석
	/*
	 * targetListStr 예시 교집합 {target:[{schema: 'landsys_gis',layer:
	 * 'rdnmadr_bass_map_subway_statn',distance: 500}, {schema: 'landsys_gis',layer:
	 * 'univ',distance: 1000}]} targetListStr로 나머지
	 * 
	 * 멀티링 distance로 , 포함해서 targetListStr에서 distance 빼고 보내라 type : multiring,
	 * intersect
	 */
	@RequestMapping(value = { RequestMappingConstants.WEB_ANAL_NETWORK_BIZ }, method = { RequestMethod.POST })
	public void network(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "inputSchema", required = false) String inputSchema,
			@RequestParam(value = "inputFeatures", required = true) String inputFeatures,
			@RequestParam(value = "distance", required = false) String distance,
			@RequestParam(value = "unit", required = false) String distanceUnit,
			@RequestParam(value = "targetSchema", required = false) String targetSchema,
			@RequestParam(value = "targetFeatures", required = false) String targetFeatures,
			@RequestParam(value = "outsideOnly", required = false) String outsideOnly,
			@RequestParam(value = "dissolve", required = false) String dissolve,
			@RequestParam(value = "sggCd", required = false) String sggCd,
			@RequestParam(value = "type", required = false) String analysisType,
			@RequestParam(value = "targetListStr", required = false) String targetListStr)
			throws NullPointerException, Exception {

		boolean boutsideOnly = true;
		boolean bdissolve = false;

		if (outsideOnly != null) {
			try {
				boutsideOnly = Boolean.valueOf(outsideOnly);
			} catch (NullPointerException e) {
				logger.debug(e);
			} catch (Exception e) {
				logger.debug(e);
			}
		}

		if (dissolve != null) {
			try {
				bdissolve = Boolean.valueOf(dissolve);
			} catch (NullPointerException e) {
				logger.debug(e);
			} catch (Exception e) {
				logger.debug(e);
			}
		}

		// JSONArray result = null;
		String exportId = getResultExportId();
		response.setHeader("export_key", exportId);
		List resultList = new ArrayList<>();
		if (analysisType.equals("multiring")) {

			List result = analyBizService.getMultipleRingBufferIntersectFeatures(exportId, inputSchema, inputFeatures,
					targetSchema, targetFeatures, distance, distanceUnit, boutsideOnly, bdissolve, sggCd);

			resultList.add(result);

		} else {
			List<Map<String, Object>> targetList = new ArrayList<>();
			JSONParser jsonParser = new JSONParser();
			org.json.simple.JSONObject obj = (org.json.simple.JSONObject) jsonParser.parse(targetListStr);

			try {
				// targetList = new ObjectMapper().readValue(targetListStr, new
				// TypeReference<Map<String, Object>>() {});
				targetList = (List<Map<String, Object>>) obj.get("target");

			} catch (NullPointerException e) {
				logger.debug(e);
			} catch (Exception e) {
				logger.debug(e);
			}

			resultList = analyBizService.getNetworkIntersectFeatures(exportId, inputSchema, inputFeatures, targetList,
					sggCd);
		}

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		JSONObject obj = new JSONObject();
		obj.put("result", resultList);

		PrintWriter out = response.getWriter();
		out.println(obj.toString());

	}

}
