package egovframework.syesd.map.search.build.web;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.XML;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.SerializationFeature;

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
public class BuildController extends BaseController {
	private static Logger logger = LogManager.getLogger(BuildController.class);
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
    
    @RequestMapping(value="/search/build.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String searchBuild (HttpServletRequest request, HttpServletResponse response, ModelMap model, @ModelAttribute("gisvo") GisBasicVO gisvo) throws SQLException, NullPointerException, IOException
	{
		HttpSession session = getSession();
		String userS_id = null;
	   	if(session != null){
	   		userS_id = (String)session.getAttribute("userId");
	   	}

       if( userS_id != null ){
	    List<Map<String, Object>> SIDOList = gisinfoService.sido_list(gisvo);
	    gisvo.setSido_cd(SIDOList.get(0).get("sido_cd").toString());
       	List SIGList = gisinfoService.sig_list(gisvo);
       	//List GISCodeList = gisinfoService.gis_code_list(gisvo);
       	
       	HashMap<String, Object> param = new HashMap<String, Object>();
    	param.put("code", "SBS000"); //SBS000 집합건물구분코드
       	List<?> setBuldSeList = gisinfoService.pCode_list(param);//SBS000 집합건물구분코드
       	param.put("code", "PRPOSC"); //PRPOSC 주요용도코드 및 세부용도코드
       	List<Map<String, Object>> mainPrposList = gisinfoService.pCode_list(param);	//PRPOSC 주요용도코드
       	param.put("sCode", mainPrposList.get(0).get("pcode"));
       	List<?> subPrposList = gisinfoService.sCode_list(param);	//PRPOSC 세부용도코드
     	model.addAttribute("setBuldSeList", setBuldSeList); //집합건물구분코드 코드 리스트
     	model.addAttribute("mainPrposList", mainPrposList); //주요용도코드 리스트
     	model.addAttribute("subPrposList", subPrposList); 	//세부용도코드 리스트
     	
    	model.addAttribute("SIDOList", SIDOList);
       	model.addAttribute("SIGList", SIGList);
       	//model.addAttribute("GISCodeList", GISCodeList);


       	gisvo.setUser_id(userS_id);
       
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
       	return "map/search/build.sub";

       }else{
       	jsHelper.Alert("비정상적인 접근 입니다.");
       	jsHelper.RedirectUrl(invalidUrl);
       }
       return null;
	}
    
    //건축물 검색 리스트 표출
    @RequestMapping(value="/searchBuldList_popup.do")
    public String searchList_popup(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO, ModelMap model) throws SQLException, NullPointerException, IOException
    {	
    	response.setCharacterEncoding("UTF-8");
    	request.setCharacterEncoding("UTF-8");

    	HttpSession session = getSession();
    	String userS_id = null;
    	if(session != null){
    		userS_id = (String)session.getAttribute("userId");
    	}

        if( userS_id != null ){
        	
        	String sig = request.getParameter("sig");
        	String emd = request.getParameter("emd");
        	if( sig.equals("0000") ){ gisVO.setSig(null); }
        	if( emd.equals("0000") ){ gisVO.setEmd(null); }
        	
        	String kind = request.getParameter("kind");
        	String cnt_kind = request.getParameter("cnt_kind");
        	model.addAttribute("kind", kind);
        	model.addAttribute("cnt_kind", cnt_kind);
        	
        	List gbList = gisinfoService.search_build_list(gisVO);
    		model.addAttribute("gbList", gbList); 
    		model.addAttribute("gb", "기본검색");
        	
        	return "map/popup/buildSearchList.part";

        }else{
        	jsHelper.Alert("비정상적인 접근 입니다.");
        	return  "redirect:/main_home.do";
        }
    }
    
    //건축물 검색 상세조회
    @RequestMapping(value="/search/build/detail.do")
    public String searchBuildDetail(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO, ModelMap model) throws SQLException, NullPointerException, IOException
    {	
    	response.setCharacterEncoding("UTF-8");
    	request.setCharacterEncoding("UTF-8");

    	HttpSession session = getSession();
    	String userS_id = null;
    	if(session != null){
    		userS_id = (String)session.getAttribute("userId");
    	}

        if( userS_id != null ){
        	
        
        	String pnu = request.getParameter("pnu");
        	gisVO.setPnu(pnu);
        	model.addAttribute("pnu", pnu);
        	
        	//토지정보
        	List land_list_1 = gisinfoService.gis_land_detail_1(gisVO);	//토지특성정보 //sn_apmm_nv_land_11
        	model.addAttribute("land_list_1", land_list_1);
    		List land_list_2 = gisinfoService.gis_land_detail_2(gisVO);	//토지소유정보 //sn_land_kind_11
    		model.addAttribute("land_list_2", land_list_2);
    		List land_list_3 = gisinfoService.gis_land_detail_3(gisVO);	//토지이용계획정보 //sn_land_olnlp_11
    		model.addAttribute("land_list_3", land_list_3);
    		
    		return "map/popup/Content_SH_View_Detail_popup.part";

        }else{
        	jsHelper.Alert("비정상적인 접근 입니다.");
        	return  "redirect:/main_home.do";
        }
    }

}
