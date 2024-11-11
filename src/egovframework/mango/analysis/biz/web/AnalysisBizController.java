package egovframework.mango.analysis.biz.web;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
//import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import egovframework.mango.analysis.biz.service.AnalysisBizService;
import egovframework.zaol.common.web.BaseController;


@Controller
public class AnalysisBizController extends BaseController {
	
	private static Logger logger = LogManager.getLogger(AnalysisBizController.class);

	private ObjectMapper mapper;

	@Autowired
	private AnalysisBizService analysisBizService;
	
	private static final String MULTI_BUFFER = "/web/analysis/biz/buffer.do"; 
	
	@PostConstruct
	public void initIt() throws NullPointerException, Exception {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}
	
	// 버퍼 중첩 분석 
	/* targetListStr 예시
	 *  {target:[{schema: 'landsys_gis',layer: 'rdnmadr_bass_map_subway_statn',distance: 500},
	 *  {schema: 'landsys_gis',layer: 'univ',distance: 1000}]}
	 */
	@RequestMapping(value = { MULTI_BUFFER }, method = { RequestMethod.POST, RequestMethod.GET })
	public void buffer(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "inputSchema", required = false) String inputSchema,
			@RequestParam(value = "inputFeatures", required = true) String inputFeatures,
			@RequestParam(value = "distance", required = false) String distance,
			@RequestParam(value = "unit", required = false) String distanceUnit,
			@RequestParam(value = "targetSchema", required = false) String targetSchema,
			@RequestParam(value = "targetFeatures", required = false) String targetFeatures,
			@RequestParam(value = "outsideOnly", required = false) String outsideOnly,
			@RequestParam(value = "dissolve", required = false) String dissolve,
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
		
//		JSONArray result = null;
		String exportId = getResultExportId();
		response.setHeader("export_key", exportId);
		List<JSONArray> resultList = new ArrayList<>();
		if (analysisType.equals("multiring")) {
			
			JSONArray result = analysisBizService.getMultipleRingBufferIntersectFeatures(exportId, inputSchema, inputFeatures, 
					targetSchema, targetFeatures, distance, distanceUnit, boutsideOnly, bdissolve);
			
			resultList.add(result);
			
		} else {
			List<Map<String, Object>> targetList = new ArrayList<>();
			//String targetListStr = request.getParameter("targetListStr");
			JSONParser jsonParser = new JSONParser();
			JSONObject obj = (JSONObject) jsonParser.parse(targetListStr);
			
			
			try {
//				targetList = new ObjectMapper().readValue(targetListStr, new TypeReference<Map<String, Object>>() {});
				targetList = (List<Map<String, Object>>) obj.get("target");
				
				
			} catch (NullPointerException e) {
				logger.debug(e);
			} catch (Exception e) {
				logger.debug(e);
			}
			
			resultList = analysisBizService.getBufferIntersectFeatures(exportId, inputSchema, inputFeatures, targetList);
		}

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		
		JSONObject obj = new JSONObject();
    	obj.put("result",resultList);
    	
    	PrintWriter out = response.getWriter();
    	out.println(obj.toString());


		/*
		 * JsonFactory jsonFactory = new JsonFactory(); try (JsonGenerator jsonGenerator
		 * = jsonFactory.createGenerator(response.getOutputStream())) { ObjectMapper
		 * objectMapper = new ObjectMapper(); jsonGenerator.writeStartArray();
		 * 
		 * int size = result.size(); for (int i = 0; i < size; i++) {
		 * objectMapper.writeValue(jsonGenerator, result.get(i)); jsonGenerator.flush();
		 * // 데이터를 강제로 플러시하여 전송 }
		 * 
		 * jsonGenerator.writeEndArray(); }
		 */

	}
	
}
