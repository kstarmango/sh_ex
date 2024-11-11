package egovframework.mango.analysis.quest.web;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.simple.JSONArray;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.io.WKTReader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.mango.analysis.quest.service.AnalysisQuestService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.zaol.common.web.BaseController;
import net.sf.json.JSONObject;

@Controller
public class AnalysisQuestController extends BaseController {
	
	private static Logger logger = LogManager.getLogger(AnalysisQuestController.class);
	
	@Autowired
	private AnalysisQuestService questService;
	
	@RequestMapping(value = { RequestMappingConstants.WEB_ANAL_QUEST_STAT }, method = { RequestMethod.GET, RequestMethod.POST })
	public String getIntersectQuest(HttpServletRequest request, HttpServletResponse response,
		@RequestParam(value = "inputWKT", required = false) String inputWKT, ModelMap model) throws NullPointerException, Exception {
		Map<String, JSONArray> result = new HashMap<>();
		
		try {
			result = questService.getIntersectQuest(inputWKT);	
			
		} catch (NullPointerException e) {
			logger.debug("파싱오류 ", e);
		} catch (Exception e) {
			logger.debug("파싱오류 ", e);
		}		
		
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		
		JSONObject obj = new JSONObject();
		obj.put("result", result.toString());
  	
	  	PrintWriter out = response.getWriter();
	  	out.println(obj.toString());
	  	
	  	model.addAttribute("resultData", obj);
	  	
  		return "analysis/destination/popup/destinationPopup.part";
	}
}
