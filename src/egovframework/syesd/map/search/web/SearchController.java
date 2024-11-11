package egovframework.syesd.map.search.web;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
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

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import egovframework.syesd.admin.layer.service.AdminLayerService;
import egovframework.syesd.admin.table.service.AdminTableService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.syesd.cmmn.menu.service.MenuService;
import egovframework.syesd.portal.gis.service.GisService;
import egovframework.zaol.common.service.CommonService;
import egovframework.zaol.common.web.BaseController;
import egovframework.zaol.gisinfo.service.GisBasicVO;
import egovframework.zaol.gisinfo.service.GisinfoService;

@Controller
public class SearchController extends BaseController {
	private static Logger logger = LogManager.getLogger(SearchController.class);
	private ObjectMapper mapper;
	
	@Resource(name = "gisService")
	private GisService gisService;

	@Resource(name = "adminLayerService")
	private AdminLayerService adminLayerService;

	@Resource(name = "adminTableService")
	private AdminTableService adminTableService;

	@Resource(name = "logsService")
	private LogsService logsService;
	
	@Resource(name = "menuService")
	private MenuService menuService;
	
	private static final String validUrl   = RequestMappingConstants.WEB_MAIN;
	private static final String invalidUrl = RequestMappingConstants.WEB_LOGIN;
	
	/* service 구하기      */ @Resource(name = "gisinfoService"   ) private   GisinfoService gisinfoService;
    /* 공통 service 구하기 */ @Resource(name = "CommonService"    ) private   CommonService commonservice;

    @PostConstruct
	public void initIt() throws NullPointerException {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}
		
	/* 속성검색 브라우저 팝업   */
    @RequestMapping(value="/searchListPopup.do")
    public String searchListPopup(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO, ModelMap model) throws NullPointerException, IOException 
    {
    	response.setCharacterEncoding("UTF-8");
    	request.setCharacterEncoding("UTF-8");

    	HttpSession session = getSession();
    	String userS_id = null;
    	if(session != null){
    		userS_id = (String)session.getAttribute("userId");
    	}

        if( userS_id != null ){
        	
	    	return "map/popup/searchListPopup.part";
	    }else{
	    	jsHelper.Alert("비정상적인 접근 입니다.");
	    	return  "redirect:/main_home.do";
	    }
    }
}
