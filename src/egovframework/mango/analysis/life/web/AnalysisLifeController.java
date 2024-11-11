package egovframework.mango.analysis.life.web;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.io.WKTReader;
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
import egovframework.mango.analysis.life.service.AnalysisLifeService;
import egovframework.mango.config.SHResource;
import egovframework.mango.util.SHJsonHelper;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.zaol.common.web.BaseController;

@Controller
public class AnalysisLifeController extends BaseController {

	private static Logger logger = LogManager.getLogger(AnalysisLifeController.class);
	
	private ObjectMapper mapper;

	@Autowired
	private AnalysisLifeService lifeService;
	
	@Autowired
	private AnalysisBusinessService bizService;
		
	@PostConstruct
	public void initIt() throws NullPointerException, Exception {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}
	
	// 기초생활 인프라 : 기본 입지분석(거리)
	/* targetListStr 예시
	 *  
	 *  {"target":[{"schema":"landsys_gis","layer":"rdnmadr_bass_map_subway_statn",
	 *  "gubun":"지하철","name":"korean_subway_nm"},
	 *  {"schema":"landsys_gis","layer":"univ","gubun":"대학교","name":"schul_nm"},
	 *  {"schema":"landsys_gis","layer":"hsptl_asemby","gubun":"병의원","name":"hsptl_cl_nm"}]}
	 *  
	 */
	@RequestMapping(value = { RequestMappingConstants.WEB_ANAL_DISTANCE_LIFE }, method = { RequestMethod.POST })
	public String buffer(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "inputWKT", required = false) String inputWKT,
			@RequestParam(value = "distance", required = false) String distances,
			@RequestParam(value = "targetListStr", required = false) String targetListStr,
			ModelMap model) 
					throws NullPointerException, Exception {

		String exportId = getResultExportId();
		response.setHeader("export_key", exportId);
		
		List<Map<String, Object>> targetList = new ArrayList<>();
		JSONParser jsonParser = new JSONParser();
		JSONObject targetObj = (JSONObject) jsonParser.parse(targetListStr);
		
		try {
			targetList = (List<Map<String, Object>>) targetObj.get("target");
			
		} catch(NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		}
		
		Map<String, JSONArray> resultList = lifeService.getMultiRingInterSect(exportId, inputWKT, targetList, distances);

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		
		JSONObject obj = new JSONObject();
    	obj.put("result", resultList);
    	
    	PrintWriter out = response.getWriter();
    	out.println(obj.toString());
		model.addAttribute("resultData", obj);
			
		return "analysis/location/popup/distancePopup.part";
	}
	
	
	// 기초생활 인프라 : 네트워크 기본 입지분석(거리)
	/* targetListStr 예시
	 *  {target:[{schema: 'landsys_gis',layer: 'rdnmadr_bass_map_subway_statn'},
	 *  {schema: 'landsys_gis',layer: 'univ']}
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = { RequestMappingConstants.WEB_ANAL_NETWORK_LIFE }, method = { RequestMethod.POST })
	public String network(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "inputWKT", required = false) String inputWKT,
			@RequestParam(value = "distance", required = false) Integer distance,
			@RequestParam(value = "walkMin", required = false) Integer walkMin,
			@RequestParam(value = "targetListStr", required = false) String targetListStr,
			ModelMap model) 
					throws NullPointerException, Exception {

		String exportId = getResultExportId();
		response.setHeader("export_key", exportId);
		
		List<Map<String, Object>> targetList = new ArrayList<>();
		JSONParser jsonParser = new JSONParser();
		JSONObject targetObj = (JSONObject) jsonParser.parse(targetListStr);
		
		if (distance != null && distance != 0) {
			if (walkMin == null || walkMin != 0) {
				walkMin =  (int) Math.ceil(distance/60.);
			}
		}
		
		if(walkMin <= 0) {
			walkMin = 1;
		}
		
		
		try {
			targetList = (List<Map<String, Object>>) targetObj.get("target");
			
		} catch(NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		}
		
		
		Map<String, JSONArray> result = lifeService.getNetworkInterSect(exportId, inputWKT, targetList, walkMin);

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		
		JSONObject obj = new JSONObject();
	  	obj.put("result",result);
	  	
	  	PrintWriter out = response.getWriter();
	  	out.println(obj.toString());
	  	model.addAttribute("resultData", obj);
		
		return "analysis/location/popup/networkPopup.part";
	}
	
		// 주소 검색 후 좌표정보로 지적 데이터 intersect
		@SuppressWarnings({ "unchecked" })
		@RequestMapping(value = { RequestMappingConstants.WEB_GIS_LG_STR }, method = { RequestMethod.GET })
		public void getLgStr(HttpServletRequest request, HttpServletResponse response,
				@RequestParam(value = "inputWKT", required = false) String inputWKT) 
						throws NullPointerException, Exception {
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");

			WKTReader reader = new WKTReader();
			Geometry geom = reader.read(inputWKT);
			
			String layerNm = SHResource.getValue("lsmd.schema") + "." + SHResource.getValue("lsmd.layer.nm");
			
			
			SimpleFeatureCollection sf = bizService.intersectLyr(geom, layerNm);
			
			JSONParser jp = new JSONParser();
			
			Map<String, Object> result = new HashMap<>();
			String sf2 = SHJsonHelper.featureCollectionToGeoJson(sf);
			
			result.put("DATA", jp.parse(sf2));
			
			JSONObject obj = new JSONObject();
	  	obj.put("result", result);
	  	
	  	PrintWriter out = response.getWriter();
	  	out.println(obj.toString());
		}

}
