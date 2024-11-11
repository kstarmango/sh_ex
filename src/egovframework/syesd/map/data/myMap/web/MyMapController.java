package egovframework.syesd.map.data.myMap.web;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.file.service.FileService;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.zaol.common.service.CommonService;
import egovframework.zaol.common.web.BaseController;
import egovframework.zaol.gisinfo.service.GisBasicVO;
import egovframework.zaol.gisinfo.service.GisinfoService;
import net.sf.json.JSONArray;

@Controller
public class MyMapController extends BaseController{
	private static Logger logger = LogManager.getLogger(MyMapController.class);
	private ObjectMapper mapper;
	
	private static final String validUrl   = RequestMappingConstants.WEB_MAIN;
	private static final String invalidUrl = RequestMappingConstants.WEB_LOGIN;
	
	/* service 구하기      */ @Resource(name = "gisinfoService"   ) private   GisinfoService gisinfoService;
    /* 공통 service 구하기 */ @Resource(name = "CommonService"    ) private   CommonService commonservice;
    
    @Resource(name = "fileService")
	private FileService fileService;

    @Resource(name = "logsService")
	private LogsService logsService;
    
    @PostConstruct
	public void initIt() throws NullPointerException {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}
    
    @RequestMapping(value="/data/myMap.do", method = {RequestMethod.GET, RequestMethod.POST})
    public String dataMyMap (HttpServletRequest request, HttpServletResponse response, ModelMap model, @ModelAttribute("gisvo") GisBasicVO gisvo) throws SQLException, NullPointerException, IOException{
    	HttpSession session = getSession();
		String userS_id = null;
	   	if(session != null){
	   		userS_id = (String)session.getAttribute("userId");
	   	}
	   	
	   	if( userS_id != null ){
	   		session.setAttribute("progrmNo", request.getParameter("progrm_no"));
	       	
	       	HashMap<String, Object> vo = new HashMap<String, Object>();
	       	vo.put("KEY", RequestMappingConstants.KEY);
	       	
	       	JSONArray jsonArray = new JSONArray();
	    	model.addAttribute("shareUserList", jsonArray.fromObject(commonservice.selectUserShare(vo)));
	    	model.addAttribute("currentProgrm", request.getParameter("progrm_no"));
	    	
	    	/* 이력 */
	    	try 
			{
	        	HashMap<String, Object> query = new HashMap<String, Object>();
	        	query.put("KEY", RequestMappingConstants.KEY);
	        	query.put("PREFIX", "LOG");
	        	query.put("USER_ID", userS_id);
	        	query.put("PROGRM_URL", request.getRequestURI());
	        	
	    		/* 프로그램 사용 이력 등록 */
				logsService.insertUserProgrmLogs(query);
			} 
			catch (SQLException e) 
			{
				logger.error("이력 등록 실패");
			}
	    	
	       	return "map/data/myMap.sub";

	       }else{
	       	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
	       }
	       return null;
	}
    
    @RequestMapping(value="/data/map/sel.do", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView dataMapSel (HttpServletRequest request, HttpServletResponse response, ModelMap model
    		,@RequestParam(value="curPage",  required=true) int curPage
    		,@RequestParam(value="firstIndex",  required=true) int firstIndex
    		,@RequestParam(value="lastIndex",  required=true) int lastIndex) throws SQLException, NullPointerException, IOException{
    	
    	HttpSession session = getSession();
		String userS_id = null;
	   	if(session != null){
	   		userS_id = (String)session.getAttribute("userId");
	   	}
		if( userS_id != null ){
			HashMap<String, Object> vo = new HashMap<String, Object>();
		    vo.put("KEY", 		 RequestMappingConstants.KEY);
		    vo.put("INS_USER", userS_id);
		    vo.put("firstIndex", firstIndex);
		    vo.put("lastIndex", lastIndex);
			ModelAndView modelAndView = new ModelAndView();  
			modelAndView.addObject("myDataInfo", fileService.selMyMapList(vo));
			modelAndView.addObject("myDataCnt", fileService.selMyMapListPageCnt(vo));
			modelAndView.addObject("curPage", curPage);
			modelAndView.addObject("result", "Y");
			modelAndView.setViewName("jsonView");

			return modelAndView;
		}else{
	       	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
	     }
	   	
    	return null;  
    }
    
    @RequestMapping(value="/data/map/selByLayerInfo.do", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView dataMapSelByLayerInfo (HttpServletRequest request, HttpServletResponse response, ModelMap model
    		,@RequestParam(value="mapNo",  required=true) String mapNo) throws SQLException, NullPointerException, IOException{
    	
    	HttpSession session = getSession();
		String userS_id = null;
	   	if(session != null){
	   		userS_id = (String)session.getAttribute("userId");
	   	}
		if( userS_id != null ){
			HashMap<String, Object> vo = new HashMap<String, Object>();
		    vo.put("KEY", 		 RequestMappingConstants.KEY);
		    vo.put("INS_USER", userS_id);
		    vo.put("mapNo", mapNo);
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.addObject("myLayerInfo", fileService.selByLayerInfo(vo));
			modelAndView.addObject("result", "Y");
			modelAndView.setViewName("jsonView");

			return modelAndView;
		}else{
	       	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
	     }
	   	
    	return null;  
    }
    
    @RequestMapping(value="/data/map/ins.do", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView dataMapIns (HttpServletRequest request, HttpServletResponse response, ModelMap model
    		,@RequestParam(value="title",  required=true) String title		
    		,@RequestParam(value="posX",  required=true) double posX
    		,@RequestParam(value="posY",  required=true) double posY
    		,@RequestParam(value="scale",  required=true) double scale
    		,@RequestParam(value="layerList",  required=true) String layerList
    		,@RequestParam(value="share",  required=true) String share) throws SQLException, NullPointerException, IOException{
    	HttpSession session = getSession();
		String userS_id = null;
	   	if(session != null){
	   		userS_id = (String)session.getAttribute("userId");
	   	}
	   	
	   	if( userS_id != null ){
	   		HashMap<String, Object> map = new HashMap<String, Object>();
	   		logger.info("title :: "+title);
	   		logger.info("share :: "+share.toString());
	   		//{"cmd.exe", "/c", "D:\\sh_local\\load_tiger.bat", "TEST_LAND_EXPORT_4326_.zip" , "landsys_usr", "test8", "0" , "4326", "2024\8\"}
	   		try {
			     
			    HashMap<String, Object> vo = new HashMap<String, Object>();
			    vo.put("KEY", 		 RequestMappingConstants.KEY);
			    vo.put("FPREFIX",   "MAP");
			    vo.put("INS_USER",  userS_id);
			    vo.put("mainTitle", title);
			    vo.put("posX", posX);
			    vo.put("posY", posY);
			    vo.put("scale", scale);
			    vo.put("layerList", layerList);
   				vo.put("othbc_yn", "Y");
   				vo.put("use_yn", "Y");
   				vo.put("shareList", share);
   				
			    int result = fileService.insMyMap(vo);
			    // 결과 반환
				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("result", result);
				modelAndView.addObject("msg", "마이맵 등록 및 공유하기가 등록되었습니다.");
				modelAndView.setViewName("jsonView");
				return modelAndView;
			} catch (SQLException e) {
			    logger.info("에러입니다.");
			}
       }else{
	       	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
	       }
	   	
	   	return null;
	}
    
    @RequestMapping(value="/data/map/del.do", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView dataMapDel (HttpServletRequest request, HttpServletResponse response, ModelMap model
    		,@RequestParam(value="mapNo",  required=true) String mapNo) throws SQLException, NullPointerException, IOException{
    	HttpSession session = getSession();
		String userS_id = null;
	   	if(session != null){
	   		userS_id = (String)session.getAttribute("userId");
	   	}
	   	
	   	if( userS_id != null ){
	   		HashMap<String, Object> vo = new HashMap<String, Object>();
	   		vo.put("INS_USER",  userS_id);
	   		vo.put("mapNo", mapNo);
	   		
	   		int result = fileService.delMyMap(vo);
	   		// 결과 반환
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.addObject("result", result);
			modelAndView.addObject("msg", "선택한 마이맵이 삭제되었습니다.");
			modelAndView.setViewName("jsonView");
			return modelAndView;
	   	}else{
	       	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
	       }
	   	
	   	return null;
    }
}
