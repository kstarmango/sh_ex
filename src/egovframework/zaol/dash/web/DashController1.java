package egovframework.zaol.dash.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.zaol.gisinfo.service.GisinfoService;
import egovframework.zaol.home.service.HomeVO;
import egovframework.zaol.common.service.CommonService;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;
import egovframework.zaol.dash.service.DashService1;
import egovframework.zaol.dash.service.DashVO;

@Controller
public class DashController1 extends BaseController  {

//고도화 시작-----------------------------------------------------------------------------------------------------------------------------------
	/* EgovPropertyService */ @Resource(name = "propertiesService") protected EgovPropertyService propertiesService;
	/* service 구하기      */ @Resource(name = "dashService1"   ) private   DashService1 dashService;
	/* 공통 service 구하기 */ @Resource(name = "CommonService"    ) private   CommonService commonservice;
	
    
    @RequestMapping(value="/dashboard.do")
	//@RequestMapping(value=RequestMappingConstants.WEB_DASHBOARD)
    public String main_home(@ModelAttribute("dashVO"  ) DashVO dashVO, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
                            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {    	 
    	HttpSession session = getSession();
    	String userS_id = null;
    	if(session != null){ 
    		userS_id = (String)session.getAttribute("userId");
    	}
    	
        if( userS_id != null ){
        	List SIGList = dashService.dashBoard_List(dashVO);    	
        	model.addAttribute("SIGList", SIGList);
        	
//        	List data1 = dashService.dashBoard_data1(dashVO);    	
        	List data2 = dashService.dashBoard_data2(dashVO);
        	List data3 = dashService.dashBoard_data3(dashVO);
//        	List data4 = dashService.dashBoard_data4(dashVO);
//        	model.addAttribute("data1", data1);
        	model.addAttribute("data2", data2);
        	model.addAttribute("data3", data3);
//        	model.addAttribute("data4", data4);
        	
        	return "/SH_/dashboard/Main"; 
        }else{
        	jsHelper.Alert("비정상적인 접근 입니다.");        	
        	return  "redirect:/main_home.do";
        }
    	   	
    }
    
    
    @RequestMapping(value="/dashboard_Content.do")
    public String dashboard_Content(@ModelAttribute("dashVO"  ) DashVO dashVO, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
                            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {    	 
    	return "/SH_/dashboard/Content";    	
    }
    
    
}
