package egovframework.syesd.map.search.land.web;

import java.io.BufferedReader;
import java.io.File;
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
import org.json.JSONException;
import org.json.XML;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

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
import egovframework.zaol.common.Globals;
import egovframework.zaol.common.service.CommonService;
import egovframework.zaol.common.web.BaseController;
import egovframework.zaol.gisinfo.service.GisBasicVO;
import egovframework.zaol.gisinfo.service.GisinfoService;

@Controller
public class LandController extends BaseController {
	private static Logger logger = LogManager.getLogger(LandController.class);
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
    
    @RequestMapping(value="/search/land.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String searchLand (HttpServletRequest request, HttpServletResponse response, ModelMap model, @ModelAttribute("gisvo") GisBasicVO gisvo) throws SQLException, NullPointerException, IOException 
	{
		HttpSession session = getSession();
		String userS_id = null;
	   	if(session != null){
	   		userS_id = (String)session.getAttribute("userId");
	   	}

       if( userS_id != null ){
    	   
    	List<Map<String, Object>> SIDOList = gisinfoService.sido_list(gisvo);
   	    gisvo.setSido_cd(SIDOList.get(0).get("sido_cd").toString());
   	    model.addAttribute("SIDOList", SIDOList);
   	    
       	List SIGList = gisinfoService.sig_list(gisvo);
       	//List GISCodeList = gisinfoService.gis_code_list(gisvo);

       	model.addAttribute("SIGList", SIGList);
       	//model.addAttribute("GISCodeList", GISCodeList);
       	
       	HashMap<String, Object> param = new HashMap<String, Object>();
    	param.put("code", "PRTOWN"); //PRTOWN 소유
       	List<?> PRTOWNList = gisinfoService.pCode_list(param);//PRTOWN 소유
       	model.addAttribute("PRTOWNList", PRTOWNList);
       	
       	param.put("code", "JIMOK"); //JIMOK 지목
       	List<?> JIMOKList = gisinfoService.pCode_list(param);//JIMOK 지목
       	model.addAttribute("JIMOKList", JIMOKList);
       	
       	param.put("code", "SPFC"); //SPFC 용도지역
       	List<?> SPFCList = gisinfoService.pCode_list(param);//SPFC 용도지역
       	model.addAttribute("SPFCList", SPFCList);
       	
       	param.put("code", "LAND_USE"); //LAND_USE 토지이용상황
       	List<?> LANDUSEList = gisinfoService.pCode_list(param);//LAND_USE 토지이용상황
       	model.addAttribute("LANDUSEList", LANDUSEList);
       	
    	param.put("code", "GEO_HL"); //GEO_HL 지형고저
       	List<?> GEOHLList = gisinfoService.pCode_list(param);//GEO_HL 지형고저
       	model.addAttribute("GEOHLList", GEOHLList);
       	
       	param.put("code", "GEO_FORM"); //GEO_FORM 지형형상
       	List<?> GEOFORMList = gisinfoService.pCode_list(param);//GEO_FORM 지형형상
       	model.addAttribute("GEOFORMList", GEOFORMList); 
       	
       	param.put("code", "ROAD_SIDE"); //ROAD_SIDE 도로접면
       	List<?> ROADSIDEList = gisinfoService.pCode_list(param);//ROAD_SIDE 도로접면
       	model.addAttribute("ROADSIDEList", ROADSIDEList);

       	gisvo.setUser_id(userS_id);
       	//List GISBookMark = gisinfoService.gis_search_bookmark(gisvo);

       	//model.addAttribute("GISBookMark", GISBookMark);


//       	model.addAttribute("geoserverURL", "http://connect.miraens.com:59900/geoserver/SH_LM/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20");
//       	model.addAttribute("geoserverURL", "http://128.134.95.129:8080/geoserver/SH_LM/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20");

       	model.addAttribute("geoserverURL", "http://dev.syesd.co.kr:12101/geoserver/SH_LM/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20");

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
       	return "map/search/land.sub";

       }else{
       	jsHelper.Alert("비정상적인 접근 입니다.");
       	jsHelper.RedirectUrl(invalidUrl);
       }
       return null;
	}
    
    /* 자산검색   */
    @RequestMapping(value="/searchList_popup.do")
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

        	String[] gbRequestList = request.getParameterValues("gb");
        	String kind = request.getParameter("kind");
        	String cnt_kind = request.getParameter("cnt_kind");
        	model.addAttribute("kind", kind);
        	model.addAttribute("cnt_kind", cnt_kind);
        	//공간분석
        	String space_gb = request.getParameter("space_gb");
        	String[] space_gb_cd02 = request.getParameterValues("space_gb_cd02");
        	String[] space_gb_cd03 = request.getParameterValues("space_gb_cd03");
        	if(space_gb != null){
        		ArrayList<String> gbArrayList02 = new ArrayList<String>();
        		if(space_gb.equals("01")){
        			for(int i=0; i<space_gb_cd02.length; i++){
            			String gbKind = space_gb_cd02[i];
            			if(		gbKind.equals("1")){ gbArrayList02.add("근린재생 일반형"); }
            			else if(gbKind.equals("2")){ gbArrayList02.add("근린재생 중심시가지형"); }
            			else if(gbKind.equals("3")){ gbArrayList02.add("도시경제기반형"); }
            	    }
        			String[] array = gbArrayList02.toArray(new String[gbArrayList02.size()]);
        			gisVO.setCity_activation_val(array);
        			gisVO.setCity_activation(space_gb_cd03);
        			model.addAttribute("city_activation_02", space_gb_cd02);
        			model.addAttribute("city_activation_03", space_gb_cd03);
        		}else if(space_gb.equals("02")){
        			for(int i=0; i<space_gb_cd02.length; i++){
            			String gbKind = space_gb_cd02[i];
            			if(		gbKind.equals("1")){ gbArrayList02.add("계획수립"); }
            			else if(gbKind.equals("2")){ gbArrayList02.add("설계/공사"); }
            			else if(gbKind.equals("3")){ gbArrayList02.add("완료"); }
            			else if(gbKind.equals("4")){ gbArrayList02.add("후보지"); }
            	    }
        			String[] array = gbArrayList02.toArray(new String[gbArrayList02.size()]);
        			gisVO.setHouse_envment_val(array);
        			gisVO.setHouse_envment(space_gb_cd03);
        			model.addAttribute("house_envment_02", space_gb_cd02);
        			model.addAttribute("house_envment_03", space_gb_cd03);
        		}else if(space_gb.equals("03")){
        			for(int i=0; i<space_gb_cd02.length; i++){
            			String gbKind = space_gb_cd02[i];
            			if(		gbKind.equals("1")){ gbArrayList02.add("도시재생활성화사업"); }
            			else if(gbKind.equals("2")){ gbArrayList02.add("주거환경관리사업"); }
            	    }
        			String[] array = gbArrayList02.toArray(new String[gbArrayList02.size()]);
        			gisVO.setHope_land_val(array);
        			gisVO.setHope_land(space_gb_cd03);
        			model.addAttribute("hope_land_02", space_gb_cd02);
        			model.addAttribute("hope_land_03", space_gb_cd03);
        		}else if(space_gb.equals("04")){
        			for(int i=0; i<space_gb_cd02.length; i++){
            			String gbKind = space_gb_cd02[i];
            			if(		gbKind.equals("1")){ gbArrayList02.add("도시환경(뉴타운)"); }
            			else if(gbKind.equals("2")){ gbArrayList02.add("재개발"); }
            			else if(gbKind.equals("3")){ gbArrayList02.add("재개발(뉴타운)"); }
            			else if(gbKind.equals("4")){ gbArrayList02.add("재건축"); }
            			else if(gbKind.equals("5")){ gbArrayList02.add("재건축(공동)"); }
            			else if(gbKind.equals("6")){ gbArrayList02.add("재건축(뉴타운)"); }
            	    }
        			String[] array = gbArrayList02.toArray(new String[gbArrayList02.size()]);
        			gisVO.setRelease_area_val(array);
        			gisVO.setRelease_area(space_gb_cd03);
        			model.addAttribute("release_area_02", space_gb_cd02);
        			model.addAttribute("release_area_03", space_gb_cd03);
        		}
        	}
        	String sub_p_decline_gb = request.getParameter("sub_p_decline_gb");
        	String[] sub_p_decline_val = request.getParameterValues("sub_p_decline_val");
        	String[] sub_p_decline = request.getParameterValues("sub_p_decline");
        	if(sub_p_decline_gb != null){
    			gisVO.setSub_p_decline_val(sub_p_decline_val);
    			gisVO.setSub_p_decline(sub_p_decline);
    			model.addAttribute("sub_p_decline_02", sub_p_decline_val);
        		model.addAttribute("sub_p_decline_03", sub_p_decline);
        	}
        	String public_transport_val = request.getParameter("public_transport_val");
        	String[] public_transport = request.getParameterValues("public_transport");
        	if(public_transport_val != null){
        		if(		public_transport_val.equals("01")){ gisVO.setPublic_transport_val("1호선"); }
    			else if(public_transport_val.equals("02")){ gisVO.setPublic_transport_val("2호선"); }
    			else if(public_transport_val.equals("03")){ gisVO.setPublic_transport_val("3호선"); }
    			else if(public_transport_val.equals("04")){ gisVO.setPublic_transport_val("4호선"); }
    			else if(public_transport_val.equals("05")){ gisVO.setPublic_transport_val("5호선"); }
    			else if(public_transport_val.equals("06")){ gisVO.setPublic_transport_val("6호선"); }
    			else if(public_transport_val.equals("07")){ gisVO.setPublic_transport_val("7호선"); }
    			else if(public_transport_val.equals("08")){ gisVO.setPublic_transport_val("8호선"); }
    			else if(public_transport_val.equals("09")){ gisVO.setPublic_transport_val("9호선"); }
    			else if(public_transport_val.equals("10")){ gisVO.setPublic_transport_val("경의중앙선"); }
    			else if(public_transport_val.equals("11")){ gisVO.setPublic_transport_val("분당선"); }
    			else if(public_transport_val.equals("12")){ gisVO.setPublic_transport_val("신분당선"); }
        		gisVO.setPublic_transport(public_transport);
        		model.addAttribute("public_transport_02", public_transport_val);
        		model.addAttribute("public_transport_03", public_transport);
        	}


        	if(kind.equals("tab-01")){
        		//기본검색
        		if( gbRequestList != null ){
        			ArrayList<String> prtown = new ArrayList<String>();
        			for(int i=0; i<gbRequestList.length; i++){
            			String gbKind = gbRequestList[i];
            			if(		gbKind.equals("00")){ prtown.add("00"); }
            			else if(gbKind.equals("01")){ prtown.add("01"); }
            			else if(gbKind.equals("02")){ prtown.add("02"); }
            			else if(gbKind.equals("03")){ prtown.add("03"); }
            			else if(gbKind.equals("04")){ prtown.add("04"); }
            			else if(gbKind.equals("05")){ prtown.add("05"); }
            			else if(gbKind.equals("06")){ prtown.add("06"); }
            			else if(gbKind.equals("07")){ prtown.add("07"); }
            			else if(gbKind.equals("08")){ prtown.add("08"); }
            			else if(gbKind.equals("09")){ prtown.add("09"); }
            	    }
        			String[] array = prtown.toArray(new String[prtown.size()]);
            		gisVO.setGb(array);

            		List gbList = gisinfoService.gis_search_land_list(gisVO);
            		model.addAttribute("gbList", gbList);
            		model.addAttribute("gb", "기본검색");
        		}


        		//자산검색
        		if( request.getParameter("guk_land") != null ){				//국유지일반재산(캠코)토지
        			ArrayList<String> guk_land = new ArrayList<String>();
        			if( request.getParameter("guk_land_01") != null ){ guk_land.add("대부대상"); }
        			if( request.getParameter("guk_land_02") != null ){ guk_land.add("매각대상"); }
        			if( request.getParameter("guk_land_03") != null ){ guk_land.add("매각제한재산"); }
        			if( request.getParameter("guk_land_04") != null ){ guk_land.add("사용중인재산"); }
        			String[] guk_land_array = guk_land.toArray(new String[guk_land.size()]);
            		gisVO.setGuk_land_value(guk_land_array);

            		List guk_landList = gisinfoService.gis_search_land_list_guk_land(gisVO);
            		model.addAttribute("guk_landList", guk_landList);
            		model.addAttribute("guk_land", "국유지일반재산(캠코)토지");
        		}
        		if( request.getParameter("tmseq_land") != null ){			//위탁관리 시유지
        			ArrayList<String> tmseq_land = new ArrayList<String>();
        			if( request.getParameter("tmseq_land_01") != null ){ tmseq_land.add("관리대상"); }
        			if( request.getParameter("tmseq_land_02") != null ){ tmseq_land.add("관리제외"); }
        			String[] tmseq_land_array = tmseq_land.toArray(new String[tmseq_land.size()]);
            		gisVO.setTmseq_land_value(tmseq_land_array);

            		List tmseq_landList = gisinfoService.gis_search_land_list_tmseq_land(gisVO);
            		model.addAttribute("tmseq_landList", tmseq_landList);
            		model.addAttribute("tmseq_land", "위탁관리 시유지");
        		}
        		if( request.getParameter("region_land") != null ){			//자치구위임관리 시유지

        			List region_landList = gisinfoService.gis_search_land_list_region_land(gisVO);
            		model.addAttribute("region_landList", region_landList);
            		model.addAttribute("region_land", "자치구위임관리 시유지");
        		}
        		if( request.getParameter("owned_city") != null ){			//자치구 보유관리토지(시유지)
        			ArrayList<String> owned_city = new ArrayList<String>();
        			if( request.getParameter("owned_city_01") != null ){ owned_city.add("일반재산"); }
        			if( request.getParameter("owned_city_02") != null ){ owned_city.add("행정재산"); }
        			String[] owned_city_array = owned_city.toArray(new String[owned_city.size()]);
            		gisVO.setOwned_city_value(owned_city_array);

            		List owned_cityList = gisinfoService.gis_search_land_list_owned_city(gisVO);
            		model.addAttribute("owned_cityList", owned_cityList);
            		model.addAttribute("owned_city", "자치구 보유관리토지(시유지)");
        		}
        		if( request.getParameter("owned_guyu") != null ){			//자치구 보유관리토지(구유지)
        			ArrayList<String> owned_guyu = new ArrayList<String>();
        			if( request.getParameter("owned_guyu_01") != null ){ owned_guyu.add("일반재산"); }
        			if( request.getParameter("owned_guyu_02") != null ){ owned_guyu.add("행정재산"); }
        			String[] owned_guyu_array = owned_guyu.toArray(new String[owned_guyu.size()]);
            		gisVO.setOwned_guyu_value(owned_guyu_array);

            		List owned_guyuList = gisinfoService.gis_search_land_list_owned_guyu(gisVO);
            		model.addAttribute("owned_guyuList", owned_guyuList);
            		model.addAttribute("owned_guyu", "자치구 보유관리토지(구유지)");
        		}
        		if( request.getParameter("residual_land") != null ){			//SH잔여지

        			List residual_landList = gisinfoService.gis_search_land_list_residual_land(gisVO);
            		model.addAttribute("residual_landList", residual_landList);
            		model.addAttribute("residual_land", "SH잔여지");
        		}
    			if( request.getParameter("unsold_land") != null ){			//SH미매각지

    				List unsold_landList = gisinfoService.gis_search_land_list_unsold_land(gisVO);
            		model.addAttribute("unsold_landList", unsold_landList);
            		model.addAttribute("unsold_land", "SH미매각지");
    			}
    			if( request.getParameter("invest") != null ){			//SH현물출자

    				List investList = gisinfoService.gis_search_land_list_invest(gisVO);
            		model.addAttribute("investList", investList);
            		model.addAttribute("invest", "SH현물출자");
    			}
    			if( request.getParameter("public_site") != null ){			//공공기관 이전부지

    				List public_siteList = gisinfoService.gis_search_land_list_public_site(gisVO);
            		model.addAttribute("public_siteList", public_siteList);
            		model.addAttribute("public_site", "공공기관 이전부지");
    			}
    			if( request.getParameter("public_parking") != null ){			//공영주차장

    				List public_parkingList = gisinfoService.gis_search_land_list_public_parking(gisVO);
            		model.addAttribute("public_parkingList", public_parkingList);
            		model.addAttribute("public_parking", "공영주차장");
    			}
    			if( request.getParameter("generations") != null ){			//역세권사업 후보지
    				ArrayList<String> generations = new ArrayList<String>();
        			if( request.getParameter("generations_01") != null ){ generations.add("완료"); }
        			if( request.getParameter("generations_02") != null ){ generations.add("진행"); }
        			if( request.getParameter("generations_03") != null ){ generations.add("준비"); }
        			String[] generations_array = generations.toArray(new String[generations.size()]);
            		gisVO.setGenerations_value(generations_array);

            		List generationsList = gisinfoService.gis_search_land_list_generations(gisVO);
            		model.addAttribute("generationsList", generationsList);
            		model.addAttribute("generations", "역세권사업 후보지");
    			}
    			if( request.getParameter("council_land") != null ){			//임대주택 단지

    				List council_landList = gisinfoService.gis_search_land_list_council_land(gisVO);
            		model.addAttribute("council_landList", council_landList);
            		model.addAttribute("council_land", "임대주택 단지");
    			}
    			if( request.getParameter("minuse") != null ){			//저이용공공시설

    				List minuseList = gisinfoService.gis_search_land_list_minuse(gisVO);
            		model.addAttribute("minuseList", minuseList);
            		model.addAttribute("minuse", "저이용공공시설");
    			}
    			if( request.getParameter("industry") != null ){			//공공부지 혼재지역

    				List industryList = gisinfoService.gis_search_land_list_industry(gisVO);
            		model.addAttribute("industryList", industryList);
            		model.addAttribute("industry", "공공부지 혼재지역");
    			}
    			if( request.getParameter("priority") != null ){			//중점활용 시유지

    				List priorityList = gisinfoService.gis_search_land_list_priority(gisVO);
            		model.addAttribute("priorityList", priorityList);
            		model.addAttribute("priority", "중점활용 시유지");
    			}

        	}else if(kind.equals("tab-02")){
        		//기본검색
        		if( gbRequestList != null ){
        			ArrayList<String> prpos= new ArrayList<String>();
            		for(int i=0; i<gbRequestList.length; i++){
            			String gbKind = gbRequestList[i];
            			if(		gbKind.equals("01000")){ prpos.add("01000"); } //단독주택
            			else if(gbKind.equals("02000")){ prpos.add("02000"); } //공동주택
            			else if(gbKind.equals("03000")){ prpos.add("03000"); } //제1종근린생활시설
            			else if(gbKind.equals("04000")){ prpos.add("04000"); } //제2종근린생활시설
            			else if(gbKind.equals("05000")){ prpos.add("05000"); } //문화및집회시설
            			else if(gbKind.equals("06000")){ prpos.add("06000"); } //종교시설
            			else if(gbKind.equals("07000")){ prpos.add("07000"); } //판매시설
            			else if(gbKind.equals("08000")){ prpos.add("08000"); } //운수시설
            			else if(gbKind.equals("09000")){ prpos.add("09000"); } //의료시설
            			else if(gbKind.equals("10000")){ prpos.add("10000"); } //교육연구시설
            			else if(gbKind.equals("11000")){ prpos.add("11000"); } //노유자시설
            			else if(gbKind.equals("12000")){ prpos.add("12000"); } //수련시설
            			else if(gbKind.equals("13000")){ prpos.add("13000"); } //운동시설
            			else if(gbKind.equals("14000")){ prpos.add("14000"); } //업무시설
            			else if(gbKind.equals("15000")){ prpos.add("15000"); } //숙박시설
            			else if(gbKind.equals("16000")){ prpos.add("16000"); } //위락시설
            			else if(gbKind.equals("17000")){ prpos.add("17000"); } //공장
            			else if(gbKind.equals("18000")){ prpos.add("18000"); } //창고시설
            			else if(gbKind.equals("19000")){ prpos.add("19000"); } //위험물저장및처리시설
            			else if(gbKind.equals("20000")){ prpos.add("20000"); } //자동차관련시설
            			else if(gbKind.equals("21000")){ prpos.add("21000"); } //동.식물관련시설
            			else if(gbKind.equals("22000")){ prpos.add("22000"); } //분뇨.쓰레기처리시설
            			else if(gbKind.equals("23000")){ prpos.add("23000"); } //교정및군사시설
            			else if(gbKind.equals("24000")){ prpos.add("24000"); } //방송통신시설
            			else if(gbKind.equals("25000")){ prpos.add("25000"); } //발전시설
            			else if(gbKind.equals("26000")){ prpos.add("26000"); } //묘지관련시설
            			else if(gbKind.equals("27000")){ prpos.add("27000"); } //관광휴게시설
            			else if(gbKind.equals("29000")){ prpos.add("29000"); } //장례시설
            			else if(gbKind.equals("30000")){ prpos.add("30000"); } //자원순환관련시설
            			else if(gbKind.equals("Z0000")){ prpos.add("Z3000"); prpos.add("Z5000"); prpos.add("Z6000"); prpos.add("Z8000"); prpos.add("Z9000"); } //기타
            	    }
            		String[] array = prpos.toArray(new String[prpos.size()]);
            		gisVO.setGb(array);
            		String gbnm = request.getParameter("gbname");
            		logger.info(gbnm);
            		gisVO.setGbname(gbnm);

            		List gbList = gisinfoService.gis_search_buld_list(gisVO);
            		model.addAttribute("gbList", gbList);
            		model.addAttribute("gb", "기본검색");
        		}



        		//자산검색
        		if( request.getParameter("guk_buld") != null ){				//국유지일반재산(캠코)건물
        			ArrayList<String> guk_buld = new ArrayList<String>();
        			if( request.getParameter("guk_buld_01") != null ){ guk_buld.add("대부대상"); }
        			if( request.getParameter("guk_buld_02") != null ){ guk_buld.add("매각대상"); }
        			if( request.getParameter("guk_buld_03") != null ){ guk_buld.add("매각제한재산"); }
        			if( request.getParameter("guk_buld_04") != null ){ guk_buld.add("사용중인재산"); }
        			String[] guk_buld_array = guk_buld.toArray(new String[guk_buld.size()]);
            		gisVO.setGuk_buld_value(guk_buld_array);

            		List guk_buldList = gisinfoService.gis_search_buld_list_guk_buld(gisVO);
            		model.addAttribute("guk_buldList", guk_buldList);
            		model.addAttribute("guk_buld", "국유지일반재산(캠코)건물");
        		}
        		if( request.getParameter("tmseq_buld") != null ){			//위탁관리 건물

        			List tmseq_buldList = gisinfoService.gis_search_buld_list_tmseq_buld(gisVO);
            		model.addAttribute("tmseq_buldList", tmseq_buldList);
            		model.addAttribute("tmseq_buld", "위탁관리 건물");
        		}
        		if( request.getParameter("region_buld") != null ){			//자치구위임관리 건물

        			List region_buldList = gisinfoService.gis_search_buld_list_region_buld(gisVO);
            		model.addAttribute("region_buldList", region_buldList);
            		model.addAttribute("region_buld", "자치구위임관리 건물");
        		}
        		if( request.getParameter("owned_region") != null ){			//자치구 보유관리건물(자치구)
        			ArrayList<String> owned_region = new ArrayList<String>();
        			if( request.getParameter("owned_region_01") != null ){ owned_region.add("일반재산"); }
        			if( request.getParameter("owned_region_02") != null ){ owned_region.add("행정재산"); }
        			String[] owned_region_array = owned_region.toArray(new String[owned_region.size()]);
            		gisVO.setOwned_region_value(owned_region_array);

        			List owned_regionList = gisinfoService.gis_search_buld_list_owned_region(gisVO);
            		model.addAttribute("owned_regionList", owned_regionList);
            		model.addAttribute("owned_region", "자치구 보유관리건물(자치구)");
        		}
        		if( request.getParameter("owned_seoul") != null ){			//자치구 보유관리건물(서울시)

        			List owned_seoulList = gisinfoService.gis_search_buld_list_owned_seoul(gisVO);
            		model.addAttribute("owned_seoulList", owned_seoulList);
            		model.addAttribute("owned_seoul", "자치구 보유관리건물(서울시)");
        		}
        		if( request.getParameter("cynlst") != null ){			//재난위험시설
        			ArrayList<String> cynlst = new ArrayList<String>();
        			if( request.getParameter("cynlst_01") != null ){ cynlst.add("D"); }
        			if( request.getParameter("cynlst_02") != null ){ cynlst.add("E"); }
        			String[] cynlst_array = cynlst.toArray(new String[cynlst.size()]);
            		gisVO.setCynlst_value(cynlst_array);

            		List cynlstList = gisinfoService.gis_search_buld_list_cynlst(gisVO);
            		model.addAttribute("cynlstList", cynlstList);
            		model.addAttribute("cynlst", "재난위험시설");
        		}
    			if( request.getParameter("public_buld_a") != null ){			//공공건축물(국공립)

    				List public_buld_aList = gisinfoService.gis_search_buld_list_public_buld_a(gisVO);
            		model.addAttribute("public_buld_aList", public_buld_aList);
            		model.addAttribute("public_buld_a", "공공건축물(국공립)");
    			}
    			if( request.getParameter("public_buld_b") != null ){			//공공건축물(서울시)

    				List public_buld_bList = gisinfoService.gis_search_buld_list_public_buld_b(gisVO);
            		model.addAttribute("public_buld_bList", public_buld_bList);
            		model.addAttribute("public_buld_b", "공공건축물(서울시)");
    			}
    			if( request.getParameter("public_buld_c") != null ){			//공공건축물(자치구)

    				List public_buld_cList = gisinfoService.gis_search_buld_list_public_buld_c(gisVO);
            		model.addAttribute("public_buld_cList", public_buld_cList);
            		model.addAttribute("public_buld_c", "공공건축물(자치구)");
    			}
    			if( request.getParameter("public_asbu") != null ){			//공공기관 이전건물

    				List public_asbuList = gisinfoService.gis_search_buld_list_public_asbu(gisVO);
            		model.addAttribute("public_asbuList", public_asbuList);
            		model.addAttribute("public_asbu", "공공기관 이전건물");
    			}
    			if( request.getParameter("purchase") != null ){			//매입임대

    				List purchaseList = gisinfoService.gis_search_buld_list_purchase(gisVO);
            		model.addAttribute("purchaseList", purchaseList);
            		model.addAttribute("purchase", "매입임대");
    			}
    			if( request.getParameter("declining") != null ){			//노후매입임대

    				List decliningList = gisinfoService.gis_search_buld_list_declining(gisVO);
            		model.addAttribute("decliningList", decliningList);
            		model.addAttribute("declining", "노후매입임대");
    			}

        	}else if(kind.equals("tab-03")){
        		gisVO.setKind(null);
        		//기본검색
        		if( gbRequestList != null ){
        			ArrayList<String> district = new ArrayList<String>();
        			for(int i=0; i<gbRequestList.length; i++){
            			String gbKind = gbRequestList[i];
            			if(		gbKind.equals("01")){ district.add("우면2"); }
            			else if(gbKind.equals("02")){ district.add("발산"); }
            			else if(gbKind.equals("03")){ district.add("신정3"); }
            			else if(gbKind.equals("04")){ district.add("장지"); }
            			else if(gbKind.equals("05")){ district.add("강일2"); }
            			else if(gbKind.equals("06")){ district.add("강일"); }
            			else if(gbKind.equals("07")){ district.add("문정"); }
            			else if(gbKind.equals("08")){ district.add("상계 장암"); }
            			else if(gbKind.equals("09")){ district.add("내곡"); }
            			else if(gbKind.equals("10")){ district.add("마천"); }
            			else if(gbKind.equals("11")){ district.add("세곡"); }
            			else if(gbKind.equals("12")){ district.add("세곡2"); }
            			else if(gbKind.equals("13")){ district.add("신내2"); }
            			else if(gbKind.equals("14")){ district.add("신내3"); }
            			else if(gbKind.equals("15")){ district.add("신정4"); }
            			else if(gbKind.equals("16")){ district.add("천왕2"); }
            			else if(gbKind.equals("17")){ district.add("항동"); }
            			else if(gbKind.equals("18")){ district.add("위례"); }
            			else if(gbKind.equals("19")){ district.add("은평"); }
            			else if(gbKind.equals("20")){ district.add("천왕"); }
            			else if(gbKind.equals("21")){ district.add("상암2"); }
            			else if(gbKind.equals("22")){ district.add("마곡"); gisVO.setKind("99"); model.addAttribute("dist_kind", "22"); }
            			else if(gbKind.equals("23")){ district.add("오금"); }
            			else if(gbKind.equals("24")){ district.add("개포 구룡마을"); }
            			else if(gbKind.equals("25")){ district.add("고덕강일"); }
            			else if(gbKind.equals("26")){ district.add("장월"); }
            	    }
        			String[] array = district.toArray(new String[district.size()]);
        			gisVO.setGb(array);


        			//Table에 한글값 적용부분
        			//판매구분
            		String[] soldoutList = request.getParameterValues("soldout");
            		if(soldoutList!=null){
            			ArrayList<String> soldout = new ArrayList<String>();
                		for(int i=0; i<soldoutList.length; i++){
                			String soldoutKind = soldoutList[i];
                			if(		soldoutKind.equals("01")){ soldout.add("판매대상"); }
                			else if(soldoutKind.equals("02")){ soldout.add("자체사용"); }
                			else if(soldoutKind.equals("03")){ soldout.add("무상공급"); }
                	    }
                		String[] array_soldout = soldout.toArray(new String[soldout.size()]);
                		gisVO.setSoldout(array_soldout);
            		}
            		//지구
            		String[] sectorList = request.getParameterValues("sector");
            		if(sectorList!=null){
            			ArrayList<String> sector = new ArrayList<String>();
                		for(int i=0; i<sectorList.length; i++){
                			String sectorKind = sectorList[i];
                			if(		sectorKind.equals("01")){ sector.add("1지구"); sector.add("2지구"); sector.add("3지구"); }
                			else if(sectorKind.equals("02")){ sector.add("1지구"); }
                			else if(sectorKind.equals("03")){ sector.add("2지구"); }
                			else if(sectorKind.equals("03")){ sector.add("3지구"); }
                	    }
                		String[] array_sector = sector.toArray(new String[sector.size()]);
                		gisVO.setSector(array_sector);
            		}
            		//용도지역
            		String[] spkfcList = request.getParameterValues("spkfc");
            		if(spkfcList!=null){
            			ArrayList<String> spkfc = new ArrayList<String>();
                		for(int i=0; i<spkfcList.length; i++){
                			String spkfcKind = spkfcList[i];
                			if(		spkfcKind.equals("01")){ spkfc.add("제1종일반주거지역"); }
                			else if(spkfcKind.equals("02")){ spkfc.add("제3종일반주거지역"); }
                			else if(spkfcKind.equals("03")){ spkfc.add("준주거지역"); }
                			else if(spkfcKind.equals("04")){ spkfc.add("준공업지역"); }
                			else if(spkfcKind.equals("05")){ spkfc.add("일반상업지역"); }
                			else if(spkfcKind.equals("06")){ spkfc.add("제2종일반주거지역"); }
                			else if(spkfcKind.equals("07")){ spkfc.add("자연녹지지역"); }
                	    }
                		String[] array_spkfc = spkfc.toArray(new String[spkfc.size()]);
                		gisVO.setSpkfc(array_spkfc);
            		}
            		//단지구분
            		String[] fill_gbList = request.getParameterValues("fill_gb");
            		if(fill_gbList!=null){
            			ArrayList<String> fill_gb = new ArrayList<String>();
                		for(int i=0; i<fill_gbList.length; i++){
                			String fill_gbKind = fill_gbList[i];
                			if(		fill_gbKind.equals("01")){ fill_gb.add("비산업단지"); }
                			else if(fill_gbKind.equals("02")){ fill_gb.add("산업단지"); }
                	    }
                		String[] array_fill_gb = fill_gb.toArray(new String[fill_gb.size()]);
                		gisVO.setFill_gb(array_fill_gb);
            		}
            		//용도
            		String[] useuList = request.getParameterValues("useu");
            		if(useuList!=null){
            			ArrayList<String> useu = new ArrayList<String>();
                		for(int i=0; i<useuList.length; i++){
                			String useuKind = useuList[i];
                			if(		useuKind.equals("01")){ useu.add("주거시설용지"); }
                			else if(useuKind.equals("02")){ useu.add("산업시설용지"); }
                			else if(useuKind.equals("03")){ useu.add("지원시설용지"); }
                			else if(useuKind.equals("04")){ useu.add("상업용지"); }
                			else if(useuKind.equals("05")){ useu.add("업무용지"); }
                			else if(useuKind.equals("06")){ useu.add("기반시설용지"); }
                			else if(useuKind.equals("07")){ useu.add("기타시설용지"); }
                	    }
                		String[] array_useu = useu.toArray(new String[useu.size()]);
                		gisVO.setUseu(array_useu);
            		}
            		//세부용도
            		String[] usesList = request.getParameterValues("uses");
            		if(usesList!=null){
            			ArrayList<String> uses = new ArrayList<String>();
                		for(int i=0; i<usesList.length; i++){
                			String usesKind = usesList[i];
                			if(		usesKind.equals("01")){ uses.add("단독주택용지"); }
                			else if(usesKind.equals("02")){ uses.add("공동주택용지"); }
                			else if(usesKind.equals("03")){ uses.add("산업시설용지"); }
                			else if(usesKind.equals("04")){ uses.add("지원시설용지"); }
                			else if(usesKind.equals("05")){ uses.add("상업용지"); }
                			else if(usesKind.equals("06")){ uses.add("업무용지"); }
                			else if(usesKind.equals("07")){ uses.add("종합의료시설용지"); }
                			else if(usesKind.equals("08")){ uses.add("공공청사용지"); }
                			else if(usesKind.equals("09")){ uses.add("학교용지"); }
                			else if(usesKind.equals("10")){ uses.add("사회복지시설"); }
                			else if(usesKind.equals("11")){ uses.add("주차장용지"); }
                			else if(usesKind.equals("12")){ uses.add("열공급설비"); }
                			else if(usesKind.equals("13")){ uses.add("전기공급설비"); }
                			else if(usesKind.equals("14")){ uses.add("보육시설용지"); }
                			else if(usesKind.equals("15")){ uses.add("방수설비용지"); }
                			else if(usesKind.equals("16")){ uses.add("도로"); }
                			else if(usesKind.equals("17")){ uses.add("보행자도로"); }
                			else if(usesKind.equals("18")){ uses.add("철도용지"); }
                			else if(usesKind.equals("19")){ uses.add("광장"); }
                			else if(usesKind.equals("20")){ uses.add("근린공원"); }
                			else if(usesKind.equals("21")){ uses.add("어린이공원"); }
                			else if(usesKind.equals("22")){ uses.add("문화공원"); }
                			else if(usesKind.equals("23")){ uses.add("경관녹지"); }
                			else if(usesKind.equals("24")){ uses.add("연결녹지"); }
                			else if(usesKind.equals("25")){ uses.add("유수지"); }
                			else if(usesKind.equals("26")){ uses.add("종교용지"); }
                			else if(usesKind.equals("27")){ uses.add("주유소용지"); }
                			else if(usesKind.equals("28")){ uses.add("가스충전소용지"); }
                			else if(usesKind.equals("29")){ uses.add("편익시설용지"); }
                			else if(usesKind.equals("30")){ uses.add("택시차고지"); }
                	    }
                		String[] array_uses = uses.toArray(new String[uses.size()]);
                		gisVO.setUses(array_uses);
            		}
            		//판매여부
            		String[] soldgbList = request.getParameterValues("soldgb");
            		if(soldgbList!=null){
            			ArrayList<String> soldgb = new ArrayList<String>();
                		for(int i=0; i<soldgbList.length; i++){
                			String soldgbKind = soldgbList[i];
                			if(		soldgbKind.equals("01")){ soldgb.add("미"); }
                			else if(soldgbKind.equals("02")){ soldgb.add("판매"); }
                	    }
                		String[] array_soldgb = soldgb.toArray(new String[soldgb.size()]);
                		gisVO.setSoldgb(array_soldgb);
            		}


        			List gbList = gisinfoService.gis_search_dist_list(gisVO);
            		model.addAttribute("gbList", gbList);
            		model.addAttribute("gb", "기본검색");
        		}


        		//자산검색
        		if( request.getParameter("residual") != null ){				//잔여지

        			List residualList = gisinfoService.gis_search_dist_list_residual(gisVO);
            		model.addAttribute("residualList", residualList);
            		model.addAttribute("residual", "잔여지");
        		}
        		if( request.getParameter("unsold") != null ){			//미매각지

        			List unsoldList = gisinfoService.gis_search_dist_list_unsold(gisVO);
            		model.addAttribute("unsoldList", unsoldList);
            		model.addAttribute("unsold", "미매각지");
        		}


        	}


    		return "map/popup/Content_SH_SearchList_popup.part";

        }else{
        	jsHelper.Alert("비정상적인 접근 입니다.");
        	return  "redirect:/main_home.do";
        }




    }

    /* 자산검색 상세정보 - 팝업창  */
    @RequestMapping(value="/Content_SH_View_Detail_old.do")
    public String Content_SH_View_Detail_old(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO, ModelMap model) throws SQLException, NullPointerException, IOException, JSONException
    {
    	response.setCharacterEncoding("UTF-8");
    	request.setCharacterEncoding("UTF-8");
    	int totalCount = 0;

    	String pnu = request.getParameter("pnu");
    	logger.info("pnu::::::::::"+pnu);
    	gisVO.setPnu(pnu);
    	model.addAttribute("pnu", pnu);
    	String sn = request.getParameter("sn");
    	logger.info("sn::::::::::"+sn);
    	gisVO.setSn(sn);
    	model.addAttribute("sn", sn);

    	//토지정보
    	List land_list_1 = gisinfoService.gis_land_detail_1(gisVO);	//토지특성정보 //sn_apmm_nv_land_11
    	model.addAttribute("land_list_1", land_list_1);
		List land_list_2 = gisinfoService.gis_land_detail_2(gisVO);	//토지소유정보 //sn_land_kind_11
		model.addAttribute("land_list_2", land_list_2);
		List land_list_3 = gisinfoService.gis_land_detail_3(gisVO);	//토지이용계획정보 //sn_land_olnlp_11
		model.addAttribute("land_list_3", land_list_3);
//		List land_list_4 = gisinfoService.gis_land_detail_4(gisVO);	//sn_idp_11
//		model.addAttribute("land_list_4", land_list_4);

		//건물정보
		//List buld_list_1 = gisinfoService.gis_buld_detail_1(gisVO);	//sn_dboh - 총괄표제부
		//model.addAttribute("buld_list_1_olddata", buld_list_1);
		//List buld_list_2 = gisinfoService.gis_buld_detail_2(gisVO);	//sn_bdfc - 전유부
		//model.addAttribute("buld_list_2_olddata", buld_list_2);
		//List buld_list_3 = gisinfoService.gis_buld_detail_3(gisVO);	//sn_bdhd - 표제부
		//model.addAttribute("buld_list_3_olddata", buld_list_3);

		//건물정보 - api 사용
		String sigunguCd = pnu.substring(0,5);
		String bjdongCd = pnu.substring(5,10);
		String platGbCd = pnu.substring(10,11);
		String bun = pnu.substring(11,15);
		String ji = pnu.substring(15,19);
		//String keyUrl = "o9zW2lZLR06hqlpgGQSjOTtf3jfGdFdrtrxwBM%2FshNmdqU%2Btzasq46ZYQasDYVW43Bs%2BxAXwgmBdxYjH5NLE4Q%3D%3D";
		//String keyUrl = "o9zW2lZLR06hqlpgGQSjOTtf3jfGdFdrtrxwBM%2FshNmdqU%2Btzasq46ZYQ3131443Bs%2BxAXwgmBdxYjH5NLE4Q%3D%3D";
		String keyUrl = "INzG2mIfcyuSdo2nnOzShtb2Uu876cATRp47R5dANGi3XIZW8QMTxiQ8LlarLS8OabiMtBnX7jFUhP%2FC76dByA%3D%3D"; //240523갱신 - 260523만료
		if(platGbCd.equals("1")) {
			platGbCd = "0";
		}else if(platGbCd.equals("2")) {
			platGbCd = "1";
		}

		//건물정보 - 표제부 api
		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/1613000/BldRgstService_v2/getBrTitleInfo"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "="+keyUrl); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("sigunguCd","UTF-8") + "=" + URLEncoder.encode(sigunguCd, "UTF-8")); /*행정표준코드*/
        urlBuilder.append("&" + URLEncoder.encode("bjdongCd","UTF-8") + "=" + URLEncoder.encode(bjdongCd, "UTF-8")); /*행정표준코드*/
        urlBuilder.append("&" + URLEncoder.encode("platGbCd","UTF-8") + "=" + URLEncoder.encode(platGbCd, "UTF-8")); /*0:대지 1:산 2:블록*/
        urlBuilder.append("&" + URLEncoder.encode("bun","UTF-8") + "=" + URLEncoder.encode(bun, "UTF-8")); /*번*/
        urlBuilder.append("&" + URLEncoder.encode("ji","UTF-8") + "=" + URLEncoder.encode(ji, "UTF-8")); /*지*/
        urlBuilder.append("&" + URLEncoder.encode("startDate","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*YYYYMMDD*/
        urlBuilder.append("&" + URLEncoder.encode("endDate","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*YYYYMMDD*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("10000", "UTF-8")); /*페이지당 목록 수*/
        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
        
        logger.info("표제부api!!!!!!!!!"+urlBuilder.toString());
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        logger.info("Response code: " + conn.getResponseCode());
        BufferedReader rd = null;
        StringBuilder sb = new StringBuilder();
        String line;
        try {
        	if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
                rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            } else {
                rd = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
            }
           
            while ((line = rd.readLine()) != null) {
                sb.append(line);
            }
        }catch(IOException e) {
        	logger.error("오류입니다.");
        }finally {
        	rd.close();
            conn.disconnect();
        }
        
        

        org.json.JSONObject jObject = XML.toJSONObject(sb.toString());
        ObjectMapper mapper = new ObjectMapper();
        mapper.enable(SerializationFeature.INDENT_OUTPUT);
        Object json = mapper.readValue(jObject.toString(), Object.class);
        String output = mapper.writeValueAsString(json);

        //logger.info(output);
        output = output.replace("mgmBldrgstPk", "manage_bild_regstr"); // 건물 번호
        output = output.replace("platPlc", "plot_lc"); // 소재지
        output = output.replace("crtnDay", "creat_de"); // 데이터 기준일
        output = output.replace("newPlatPlc", "rn_plot_lc"); // 소재지(도로명)
        output = output.replace("bldNm", "buld_nm"); // 건물명
        output = output.replace("splotNm", "spcl_nmfpc"); // 특수 지명
        output = output.replace("block", "blck"); // 블록
        output = output.replace("bylotCnt", "else_lot_co"); // 외필지 수
        output = output.replace("platArea", "plot_ar"); // 대지 면적
        output = output.replace("archArea", "bildng_ar"); // 건축 면적
        output = output.replace("bcRat", "bdtldr"); // 건폐율
        output = output.replace("totArea", "totar"); // 연면적
        output = output.replace("vlRat", "cpcty_rt"); // 용적률
        output = output.replace("vlRatEstmTotArea", "cpcty_rt_calc_totar"); // 용적률 산정 연면적
        output = output.replace("strctCdNm", "strct_code_nm"); // 구조
        output = output.replace("etcStrct", "etc_strct"); // 기타 구조
        output = output.replace("mainPurpsCdNm", "main_prpos_code_nm"); // 주용도
        output = output.replace("etcPurps", "etc_prpos"); // 기타용도
        output = output.replace("roofCdNm", "rf_code_nm"); // 지붕코드
        output = output.replace("etcRoof", "etc_rf"); // 기타 지붕
        output = output.replace("hhldCnt", "hshld_co"); // 세대수
        output = output.replace("fmlyCnt", "funitre_co"); // 가구수
        output = output.replace("heit", "hg"); // 높이
        output = output.replace("grndFlrCnt", "ground_floor_co"); // 지상 층 수
        output = output.replace("ugrndFlrCnt", "undgrnd_floor_co"); // 지하 층 수
        output = output.replace("rideUseElvtCnt", "rdng_elvtr_co"); // 승용 승강기 수
        output = output.replace("emgenUseElvtCnt", "emgnc_elvtr_co"); // 비상용 승강기 수
        output = output.replace("atchBldCnt", "atach_bild_co"); // 부속 건축물 수
        output = output.replace("atchBldArea", "atach_bild_ar"); // 부속 건축물 면적
        output = output.replace("totDongTotArea", "floor_dong_totar"); // 총 동 연면적
        output = output.replace("indrMechUtcnt", "insdhous_mchne_alge"); // 옥내 기계식 대수
        output = output.replace("indrMechArea", "insdhous_mchne_ar"); // 옥내 기계식 면적
        output = output.replace("oudrMechUtcnt", "outhous_mchne_alge"); // 옥외 기계식 대수
        output = output.replace("oudrMechArea", "outhous_mchne_ar"); // 옥외 기계식 면적
        output = output.replace("indrAutoUtcnt", "insdhous_self_alge"); // 옥내 자주식 대수
        output = output.replace("indrAutoArea", "insdhous_self_ar"); // 옥내 자주식 면적
        output = output.replace("oudrAutoUtcnt", "outhous_self_alge"); // 옥외 자주식 대수
        output = output.replace("oudrAutoArea", "outhous_self_ar"); // 옥외 자주식 면적
        output = output.replace("pmsDay", "prmisn_de"); // 허가일
        output = output.replace("stcnsDay", "strwrk_de"); // 착공일
        output = output.replace("useAprDay", "use_confm_de"); // 사용승인일
        output = output.replace("hoCnt", "ho_co"); // 호 수
        output = output.replace("pmsnoKikCdNm", "prmisn_no_instt_code_nm"); // 허가번호 기관
        output = output.replace("pmsnoGbCdNm", "prmisn_no_se_code_nm"); // 허가번호 구분

        Map<String, Object> map3 = mapper.readValue(output, Map.class);
        map3 = (Map<String, Object>) map3.get("response");
        map3 = (Map<String, Object>) map3.get("body");
        logger.info("totalcount1"+map3.get("totalCount"));
        totalCount = (int) map3.get("totalCount");
        map3 = (Map<String, Object>) map3.get("items");


        if(totalCount == 1) {
        	ArrayList<Map<String, Object>> list3 = new ArrayList<Map<String, Object>>();
        	list3.add((Map<String, Object>) map3.get("item"));
        	model.addAttribute("buld_list_3", list3);
        }else {
        	model.addAttribute("buld_list_3",map3.get("item"));
        }

        model.addAttribute("buld_list_3_sel",output);

        // 건물정보 - 전유부 api
        urlBuilder = new StringBuilder("http://apis.data.go.kr/1613000/BldRgstService_v2/getBrExposInfo"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "="+keyUrl); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("sigunguCd","UTF-8") + "=" + URLEncoder.encode(sigunguCd, "UTF-8")); /*행정표준코드*/
        urlBuilder.append("&" + URLEncoder.encode("bjdongCd","UTF-8") + "=" + URLEncoder.encode(bjdongCd, "UTF-8")); /*행정표준코드*/
        urlBuilder.append("&" + URLEncoder.encode("platGbCd","UTF-8") + "=" + URLEncoder.encode(platGbCd, "UTF-8")); /*0:대지 1:산 2:블록*/
        urlBuilder.append("&" + URLEncoder.encode("bun","UTF-8") + "=" + URLEncoder.encode(bun, "UTF-8")); /*번*/
        urlBuilder.append("&" + URLEncoder.encode("ji","UTF-8") + "=" + URLEncoder.encode(ji, "UTF-8")); /*지*/
        urlBuilder.append("&" + URLEncoder.encode("startDate","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*YYYYMMDD*/
        urlBuilder.append("&" + URLEncoder.encode("endDate","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*YYYYMMDD*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("10000", "UTF-8")); /*페이지당 목록 수*/
        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/

        
        logger.info("전유부api!!!!!!!!!"+urlBuilder.toString());
        url = new URL(urlBuilder.toString());
        conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        logger.info("Response code: " + conn.getResponseCode());
     
        try {
        	 if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
                 rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
             } else {
                 rd = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
             }
             sb = new StringBuilder();
             while ((line = rd.readLine()) != null) {
                 sb.append(line);
             }
        }catch(IOException e) {
        	logger.error("오류입니다.");
        }finally {
        	rd.close();
            conn.disconnect();
        }
        
        

        jObject = XML.toJSONObject(sb.toString());
        mapper = new ObjectMapper();
        mapper.enable(SerializationFeature.INDENT_OUTPUT);
        json = mapper.readValue(jObject.toString(), Object.class);
        output = mapper.writeValueAsString(json);

        //logger.info(output);

        output = output.replace("mgmBldrgstPk", "manage_bild_regstr"); // 건물 정보
        output = output.replace("hoNm", "ho_nm"); // 호명
        output = output.replace("crtnDay", "creat_de"); // 데이터 기준 일자
        output = output.replace("platPlc", "plot_lc"); // 소재지
        output = output.replace("newPlatPlc", "rn_plot_lc"); // 소재지(도로명)
        output = output.replace("bldNm", "buld_nm"); // 건물명
        output = output.replace("splotNm", "spcl_nmfpc"); // 특수 지명
        output = output.replace("block", "blck"); // 블록
        output = output.replace("dongNm", "dong_nm"); // 동명
        output = output.replace("flrGbCdNm", "floor_se_code_nm"); // 층 구분명
        output = output.replace("flrNo", "floor_no"); // 층 번호

        Map<String, Object> map2 = mapper.readValue(output, Map.class);

        map2 = (Map<String, Object>) map2.get("response");
        map2 = (Map<String, Object>) map2.get("body");
        totalCount = (int) map2.get("totalCount");
        map2 = (Map<String, Object>) map2.get("items");


        if(totalCount == 1) {
        	ArrayList<Map<String, Object>> list2 = new ArrayList<Map<String, Object>>();
        	list2.add((Map<String, Object>) map2.get("item"));
        	model.addAttribute("buld_list_2", list2);
        }else {


        	// 건물, 동, 호 정렬 코드
        	if(map2.get("item") != null) {
        		ArrayList<Map<String, Object>> list2 = new ArrayList<Map<String, Object>>();
	        	list2 = (ArrayList<Map<String, Object>>) map2.get("item");
	        	SortedMap<String, Object> sortmap = new TreeMap<>();

	        	for(Map<String,Object> e : list2) {
	        		logger.info(e.get("ho_nm"));
	        		String dong = (String.valueOf(e.get("dong_nm"))).replaceAll("[^0-9]","").toString();
	        		String flrNo = String.valueOf(e.get("floor_no")).toString();
	        		String ho = ( String.valueOf(e.get("ho_nm"))).replaceAll("[^0-9]","").toString();

	        		if("".equals(dong)) {
	        			dong = "0";
	        		}

	        		if("".equals(flrNo)) {
	        			flrNo = "0";
	        		}

	        		if("".equals(ho)) {
	        			ho = "0";
	        		}

	        		String sortkey = String.format("%03d",Integer.parseInt(dong)) + String.format("%02d",Integer.parseInt(flrNo)) + String.format("%04d",Integer.parseInt(ho));

	        		Map<String, Object> sortdata = new HashMap<String, Object>();

	        		sortdata.put("manage_bild_regstr", e.get("manage_bild_regstr"));
	        		sortdata.put("buld_nm", e.get("buld_nm"));
	        		sortdata.put("dong_nm", e.get("dong_nm"));
	        		sortdata.put("floor_no", e.get("floor_no"));
	        		sortdata.put("ho_nm", e.get("ho_nm"));
	        		sortdata.put("creat_de", e.get("creat_de"));
	        		sortdata.put("plot_lc", e.get("plot_lc"));
	        		sortdata.put("rn_plot_lc", e.get("rn_plot_lc"));
	        		sortdata.put("spcl_nmfpc", e.get("spcl_nmfpc"));
	        		sortdata.put("blck", e.get("blck"));
	        		sortdata.put("floor_se_code_nm", e.get("floor_se_code_nm"));


	        		sortmap.put(sortkey, sortdata);
	        	}

	        	ArrayList<Map<String, Object>> selectmodel = new ArrayList<Map<String, Object>>();
	        	for(String key : sortmap.keySet()) {
	        		selectmodel.add((Map<String, Object>) sortmap.get(key));
	        	}
	        	model.addAttribute("selectmodel", selectmodel);
        	}else {
        		model.addAttribute("buld_list_2", map2.get("item"));
        	}
        }

        model.addAttribute("buld_list_2_sel",output);

	    // 건물정보 - 총괄표제부 api
        urlBuilder = new StringBuilder("http://apis.data.go.kr/1613000/BldRgstService_v2/getBrRecapTitleInfo"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "="+keyUrl); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("sigunguCd","UTF-8") + "=" + URLEncoder.encode(sigunguCd, "UTF-8")); /*행정표준코드*/
        urlBuilder.append("&" + URLEncoder.encode("bjdongCd","UTF-8") + "=" + URLEncoder.encode(bjdongCd, "UTF-8")); /*행정표준코드*/
        urlBuilder.append("&" + URLEncoder.encode("platGbCd","UTF-8") + "=" + URLEncoder.encode(platGbCd, "UTF-8")); /*0:대지 1:산 2:블록*/
        urlBuilder.append("&" + URLEncoder.encode("bun","UTF-8") + "=" + URLEncoder.encode(bun, "UTF-8")); /*번*/
        urlBuilder.append("&" + URLEncoder.encode("ji","UTF-8") + "=" + URLEncoder.encode(ji, "UTF-8")); /*지*/
        urlBuilder.append("&" + URLEncoder.encode("startDate","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*YYYYMMDD*/
        urlBuilder.append("&" + URLEncoder.encode("endDate","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*YYYYMMDD*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("10000", "UTF-8")); /*페이지당 목록 수*/
        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/

        logger.info("총괄표제부api!!!!!!!!!"+urlBuilder.toString());
        url = new URL(urlBuilder.toString());
        conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        logger.info("Response code: " + conn.getResponseCode());
        
        
        try {
        	if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
                rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            } else {
                rd = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
            }
            sb = new StringBuilder();
            while ((line = rd.readLine()) != null) {
                sb.append(line);
            }
       }catch(IOException e) {
       		logger.error("오류입니다.");
       }finally {
       		rd.close();
           conn.disconnect();
       }
        jObject = XML.toJSONObject(sb.toString());
        mapper = new ObjectMapper();
        mapper.enable(SerializationFeature.INDENT_OUTPUT);
        json = mapper.readValue(jObject.toString(), Object.class);
        output = mapper.writeValueAsString(json);

        //logger.info(output);

        output = output.replace("mgmBldrgstPk", "manage_bild_regstr"); // 건물 번호
        output = output.replace("platPlc", "plot_lc"); // 소재지
        output = output.replace("crtnDay", "creat_de"); // 데이터 기준일
        output = output.replace("newPlatPlc", "rn_plot_lc"); // 소재지(도로명)
        output = output.replace("bldNm", "buld_nm"); // 건물명
        output = output.replace("splotNm", "spcl_nmfpc"); // 특수 지명
        output = output.replace("block", "blck"); // 블록
        output = output.replace("bylotCnt", "else_lot_co"); // 외필지 수
        output = output.replace("platArea", "plot_ar"); // 대지 면적
        output = output.replace("archArea", "bildng_ar"); // 건축 면적
        output = output.replace("bcRat", "bdtldr"); // 건폐율
        output = output.replace("totArea", "totar"); // 연면적
        output = output.replace("vlRat", "cpcty_rt"); // 용적률
        output = output.replace("vlRatEstmTotArea", "cpcty_rt_calc_totar"); // 용적률 산정 연면적
        output = output.replace("mainPurpsCdNm", "main_prpos_code_nm"); // 주용도
        output = output.replace("etcPurps", "etc_prpos"); // 기타용도
        output = output.replace("hhldCnt", "hshld_co"); // 세대수
        output = output.replace("fmlyCnt", "funitre_co"); // 가구수
        output = output.replace("mainBldCnt", "main_bild_co"); // 주 건축물 수
        output = output.replace("atchBldCnt", "atach_bild_co"); // 부속 건축물 수
        output = output.replace("atchBldArea", "atach_bild_ar"); // 부속 건축물 면적
        output = output.replace("totPkngCnt", "floor_parkng_co"); // 총 주차 수
        output = output.replace("indrMechUtcnt", "insdhous_mchne_alge"); // 옥내 기계식 대수
        output = output.replace("indrMechArea", "insdhous_mchne_ar"); // 옥내 기계식 면적
        output = output.replace("oudrMechUtcnt", "outhous_mchne_alge"); // 옥외 기계식 대수
        output = output.replace("oudrMechArea", "outhous_mchne_ar"); // 옥외 기계식 면적
        output = output.replace("indrAutoUtcnt", "insdhous_self_alge"); // 옥내 자주식 대수
        output = output.replace("indrAutoArea", "insdhous_self_ar"); // 옥내 자주식 면적
        output = output.replace("oudrAutoUtcnt", "outhous_self_alge"); // 옥외 자주식 대수
        output = output.replace("oudrAutoArea", "outhous_self_ar"); // 옥외 자주식 면적
        output = output.replace("pmsDay", "prmisn_de"); // 허가일
        output = output.replace("stcnsDay", "strwrk_de"); // 착공일
        output = output.replace("useAprDay", "use_confm_de"); // 사용승인일
        output = output.replace("hoCnt", "ho_co"); // 호 수
        output = output.replace("pmsnoKikCdNm", "prmisn_no_instt_code_nm"); // 허가번호 기관
        output = output.replace("pmsnoGbCdNm", "prmisn_no_se_code_nm"); // 허가번호 구분

        Map<String, Object> map1 = mapper.readValue(output, Map.class);

        map1 = (Map<String, Object>) map1.get("response");
        map1 = (Map<String, Object>) map1.get("body");
        //logger.info("totalcount1"+map1.get("totalCount"));
        totalCount = (int) map1.get("totalCount");
        map1 = (Map<String, Object>) map1.get("items");

        if(totalCount == 1) {
        	ArrayList<Map<String, Object>> list1 = new ArrayList<Map<String, Object>>();
        	list1.add((Map<String, Object>) map1.get("item"));
        	model.addAttribute("buld_list_1", list1);
        }else {
        	model.addAttribute("buld_list_1", map1.get("item"));
        }

        model.addAttribute("buld_list_1_sel",output);

		//자산정보
		String sh_kind = request.getParameter("sh_kind");
		logger.info("sh_kind::::::::::"+sh_kind);
    	gisVO.setKind(sh_kind);

		List sh_list = null;	//자산정보
		if(		"guk_land".equals(sh_kind)			){ sh_list = gisinfoService.gis_sh_detail_guk_land(gisVO); }
		else if("tmseq_land".equals(sh_kind)		){ sh_list = gisinfoService.gis_sh_detail_tmseq_land(gisVO); }
		else if("region_land".equals(sh_kind)		){ sh_list = gisinfoService.gis_sh_detail_region_land(gisVO); }
		else if("owned_city".equals(sh_kind)		){ sh_list = gisinfoService.gis_sh_detail_owned_city(gisVO); }
		else if("owned_guyu".equals(sh_kind)		){ sh_list = gisinfoService.gis_sh_detail_owned_guyu(gisVO); }
		else if("residual_land".equals(sh_kind)		){ sh_list = gisinfoService.gis_sh_detail_residual_land(gisVO); }
		else if("unsold_land".equals(sh_kind)		){ sh_list = gisinfoService.gis_sh_detail_unsold_land(gisVO); }
		else if("invest".equals(sh_kind)			){ sh_list = gisinfoService.gis_sh_detail_invest(gisVO); }
		else if("public_site".equals(sh_kind)		){ sh_list = gisinfoService.gis_sh_detail_public_site(gisVO); }
		else if("public_parking".equals(sh_kind)	){ sh_list = gisinfoService.gis_sh_detail_public_parking(gisVO); }
		else if("generations".equals(sh_kind)		){ sh_list = gisinfoService.gis_sh_detail_generations(gisVO); }
		else if("council_land".equals(sh_kind)		){ sh_list = gisinfoService.gis_sh_detail_council_land(gisVO); }
		else if("minuse".equals(sh_kind)			){ sh_list = gisinfoService.gis_sh_detail_minuse(gisVO); }
		else if("industry".equals(sh_kind)			){ sh_list = gisinfoService.gis_sh_detail_industry(gisVO); }
		else if("priority".equals(sh_kind)			){ sh_list = gisinfoService.gis_sh_detail_priority(gisVO); }

		else if("guk_buld".equals(sh_kind)			){ sh_list = gisinfoService.gis_sh_detail_guk_buld(gisVO); }
		else if("tmseq_buld".equals(sh_kind)		){ sh_list = gisinfoService.gis_sh_detail_tmseq_buld(gisVO); }
		else if("region_buld".equals(sh_kind)		){ sh_list = gisinfoService.gis_sh_detail_region_buld(gisVO); }
		else if("owned_region".equals(sh_kind)		){ sh_list = gisinfoService.gis_sh_detail_owned_region(gisVO); }
		else if("owned_seoul".equals(sh_kind)		){ sh_list = gisinfoService.gis_sh_detail_owned_seoul(gisVO); }
		else if("cynlst".equals(sh_kind)			){ sh_list = gisinfoService.gis_sh_detail_cynlst(gisVO); }
		else if("public_buld_a".equals(sh_kind)		){ sh_list = gisinfoService.gis_sh_detail_public_buld_a(gisVO); }
		else if("public_buld_b".equals(sh_kind)		){ sh_list = gisinfoService.gis_sh_detail_public_buld_b(gisVO); }
		else if("public_buld_c".equals(sh_kind)		){ sh_list = gisinfoService.gis_sh_detail_public_buld_c(gisVO); }
		else if("public_asbu".equals(sh_kind)		){ sh_list = gisinfoService.gis_sh_detail_public_asbu(gisVO); }
		else if("purchase".equals(sh_kind)			){ sh_list = gisinfoService.gis_sh_detail_purchase(gisVO); }
		else if("declining".equals(sh_kind)			){ sh_list = gisinfoService.gis_sh_detail_declining(gisVO); }

		else if("residual".equals(sh_kind)			){ sh_list = gisinfoService.gis_sh_detail_residual(gisVO); }
		else if("unsold".equals(sh_kind)			){ sh_list = gisinfoService.gis_sh_detail_unsold(gisVO); }

		model.addAttribute("sh_list", sh_list);
		model.addAttribute("sh_kind", "data_"+sh_kind);

		//관련사업정보(공간분석)
		if(request.getParameter("city_activation_val") != null){
			String[] space_gb_cd02 = request.getParameterValues("city_activation_val");
			ArrayList<String> gbArrayList02 = new ArrayList<String>();
			for(int i=0; i<space_gb_cd02.length; i++){
    			String gbKind = space_gb_cd02[i];
    			if(		gbKind.equals("1")){ gbArrayList02.add("근린재생 일반형"); }
    			else if(gbKind.equals("2")){ gbArrayList02.add("근린재생 중심시가지형"); }
    			else if(gbKind.equals("3")){ gbArrayList02.add("도시경제기반형"); }
    	    }
			String[] array = gbArrayList02.toArray(new String[gbArrayList02.size()]);
			gisVO.setCity_activation_val(array);

			List data_list_1 = gisinfoService.gis_data_detail_1(gisVO);	//도시재생활정화지역
			model.addAttribute("data_list_1", data_list_1);
		}
		if(request.getParameter("house_envment_val") != null){
			String[] space_gb_cd02 = request.getParameterValues("house_envment_val");
			ArrayList<String> gbArrayList02 = new ArrayList<String>();
			for(int i=0; i<space_gb_cd02.length; i++){
    			String gbKind = space_gb_cd02[i];
    			if(		gbKind.equals("1")){ gbArrayList02.add("계획수립"); }
    			else if(gbKind.equals("2")){ gbArrayList02.add("설계/공사"); }
    			else if(gbKind.equals("3")){ gbArrayList02.add("완료"); }
    			else if(gbKind.equals("4")){ gbArrayList02.add("후보지"); }
    	    }
			String[] array = gbArrayList02.toArray(new String[gbArrayList02.size()]);
			gisVO.setHouse_envment_val(array);

			List data_list_2 = gisinfoService.gis_data_detail_2(gisVO); //주거환경관리사업
			model.addAttribute("data_list_2", data_list_2);
		}
		if(request.getParameter("hope_land_val") != null){
			String[] space_gb_cd02 = request.getParameterValues("hope_land_val");
			ArrayList<String> gbArrayList02 = new ArrayList<String>();
			for(int i=0; i<space_gb_cd02.length; i++){
    			String gbKind = space_gb_cd02[i];
    			if(		gbKind.equals("1")){ gbArrayList02.add("도시재생활성화사업"); }
    			else if(gbKind.equals("2")){ gbArrayList02.add("주거환경관리사업"); }
    	    }
			String[] array = gbArrayList02.toArray(new String[gbArrayList02.size()]);
			gisVO.setHope_land_val(array);

			List data_list_3 = gisinfoService.gis_data_detail_3(gisVO); //희망지
			model.addAttribute("data_list_3", data_list_3);
		}
		if(request.getParameter("release_area_val") != null){
			String[] space_gb_cd02 = request.getParameterValues("release_area_val");
			ArrayList<String> gbArrayList02 = new ArrayList<String>();
			for(int i=0; i<space_gb_cd02.length; i++){
    			String gbKind = space_gb_cd02[i];
    			if(		gbKind.equals("1")){ gbArrayList02.add("도시환경(뉴타운)"); }
    			else if(gbKind.equals("2")){ gbArrayList02.add("재개발"); }
    			else if(gbKind.equals("3")){ gbArrayList02.add("재개발(뉴타운)"); }
    			else if(gbKind.equals("4")){ gbArrayList02.add("재건축"); }
    			else if(gbKind.equals("5")){ gbArrayList02.add("재건축(공동)"); }
    			else if(gbKind.equals("6")){ gbArrayList02.add("재건축(뉴타운)"); }
    	    }
			String[] array = gbArrayList02.toArray(new String[gbArrayList02.size()]);
			gisVO.setRelease_area_val(array);

			List data_list_4 = gisinfoService.gis_data_detail_4(gisVO); //해제구역
			model.addAttribute("data_list_4", data_list_4);
		}
		if(request.getParameter("sub_p_decline_val") != null){
			List data_list_5 = gisinfoService.gis_data_detail_5(gisVO); //도시재생쇠퇴지역
			model.addAttribute("data_list_5", data_list_5);
		}
		if(request.getParameter("public_transport_val") != null){
			String public_transport_val = request.getParameter("public_transport_val");
			if(		public_transport_val.equals("01")){ gisVO.setPublic_transport_val("1호선"); }
			else if(public_transport_val.equals("02")){ gisVO.setPublic_transport_val("2호선"); }
			else if(public_transport_val.equals("03")){ gisVO.setPublic_transport_val("3호선"); }
			else if(public_transport_val.equals("04")){ gisVO.setPublic_transport_val("4호선"); }
			else if(public_transport_val.equals("05")){ gisVO.setPublic_transport_val("5호선"); }
			else if(public_transport_val.equals("06")){ gisVO.setPublic_transport_val("6호선"); }
			else if(public_transport_val.equals("07")){ gisVO.setPublic_transport_val("7호선"); }
			else if(public_transport_val.equals("08")){ gisVO.setPublic_transport_val("8호선"); }
			else if(public_transport_val.equals("09")){ gisVO.setPublic_transport_val("9호선"); }
			else if(public_transport_val.equals("10")){ gisVO.setPublic_transport_val("경의중앙선"); }
			else if(public_transport_val.equals("11")){ gisVO.setPublic_transport_val("분당선"); }
			else if(public_transport_val.equals("12")){ gisVO.setPublic_transport_val("신분당선"); }

			List data_list_6 = gisinfoService.gis_data_detail_6(gisVO); //대중교통역세권
			model.addAttribute("data_list_6", data_list_6);
		}

    	// 현장조사카드 여부 확인
    	String inputFileName = "SH노후매입임대_" + pnu + ".hwp";
    	String inputFilePath = Globals.HWP_FILE_PATH + Globals.CONTEXT_MARK + inputFileName;	//버에 템플릿 파일경로 입력
    	
    	inputFilePath = inputFilePath.replaceAll("\\.", "").replaceAll("/", "").replaceAll("\\\\", "");
    	File f = new File(inputFilePath);
    	if(f.exists()) {
			model.addAttribute("cardName",inputFileName);
    	} else {

    	}
    	
    	HashMap priceList = gisinfoService.search_price_detail(gisVO);
    	logger.info("건축물검색상세보기!!!!!!!!"+priceList.toString());
		model.addAttribute("priceList", priceList); 
		model.addAttribute("gb", "기본검색");
		JSONObject jsonObject = new JSONObject(priceList);
		model.addAttribute("priceListJson", jsonObject); 
		
    	return "map/popup/Content_SH_View_Detail_popup.part";
    }
    
    @RequestMapping(value="/Content_SH_View_Detail.do")
    public String Content_SH_View_Detail(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO, ModelMap model) throws SQLException, NullPointerException, IOException, JSONException
    {
    	response.setCharacterEncoding("UTF-8");
    	request.setCharacterEncoding("UTF-8");
    	int totalCount = 0;

    	String pnu = request.getParameter("pnu");
    	logger.info("pnu::::::::::"+pnu);
    	gisVO.setPnu(pnu);
    	model.addAttribute("pnu", pnu);
    	String sn = request.getParameter("sn");
    	logger.info("sn::::::::::"+sn);
    	gisVO.setSn(sn);
    	model.addAttribute("sn", sn);

    	//토지정보
    	List land_list_1 = gisinfoService.gis_land_detail_1(gisVO);	//토지특성정보 //sn_apmm_nv_land_11
    	model.addAttribute("land_list_1", land_list_1);
		List land_list_2 = gisinfoService.gis_land_detail_2(gisVO);	//토지소유정보 //sn_land_kind_11
		model.addAttribute("land_list_2", land_list_2);
		List land_list_3 = gisinfoService.gis_land_detail_3(gisVO);	//토지이용계획정보 //sn_land_olnlp_11
		model.addAttribute("land_list_3", land_list_3);
		
		//건물정보
		//건물정보 - api 사용
		String sigunguCd = pnu.substring(0,5);
		String bjdongCd = pnu.substring(5,10);
		String platGbCd = pnu.substring(10,11);
		String bun = pnu.substring(11,15);
		String ji = pnu.substring(15,19);
		
		String keyUrl = "INzG2mIfcyuSdo2nnOzShtb2Uu876cATRp47R5dANGi3XIZW8QMTxiQ8LlarLS8OabiMtBnX7jFUhP%2FC76dByA%3D%3D"; //240523갱신 - 260523만료
		
		if(platGbCd.equals("1")) {
			platGbCd = "0";
		}else if(platGbCd.equals("2")) {
			platGbCd = "1";
		}
		
		StringBuilder urlBuilder;
		URL url;
		HttpURLConnection conn;
		BufferedReader rd = null;
		
		org.json.JSONObject jObject;
		ObjectMapper mapper;
		Object json;
		String output;
		StringBuilder sb = null;
		String line;
		
		// 건물정보 - 총괄표제부 api
        urlBuilder = new StringBuilder("http://apis.data.go.kr/1613000/BldRgstService_v2/getBrRecapTitleInfo"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "="+keyUrl); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("sigunguCd","UTF-8") + "=" + URLEncoder.encode(sigunguCd, "UTF-8")); /*행정표준코드*/
        urlBuilder.append("&" + URLEncoder.encode("bjdongCd","UTF-8") + "=" + URLEncoder.encode(bjdongCd, "UTF-8")); /*행정표준코드*/
        urlBuilder.append("&" + URLEncoder.encode("platGbCd","UTF-8") + "=" + URLEncoder.encode(platGbCd, "UTF-8")); /*0:대지 1:산 2:블록*/
        urlBuilder.append("&" + URLEncoder.encode("bun","UTF-8") + "=" + URLEncoder.encode(bun, "UTF-8")); /*번*/
        urlBuilder.append("&" + URLEncoder.encode("ji","UTF-8") + "=" + URLEncoder.encode(ji, "UTF-8")); /*지*/
        urlBuilder.append("&" + URLEncoder.encode("startDate","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*YYYYMMDD*/
        urlBuilder.append("&" + URLEncoder.encode("endDate","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*YYYYMMDD*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("10000", "UTF-8")); /*페이지당 목록 수*/
        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/

        url = new URL(urlBuilder.toString());
        conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        logger.info("Response code: " + conn.getResponseCode());
        
        
        try {
        	if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
                rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            } else {
                rd = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
            }
            sb = new StringBuilder();
            while ((line = rd.readLine()) != null) {
                sb.append(line);
            }
       }catch(IOException e) {
       		logger.error("오류입니다.");
       }finally {
       		rd.close();
           conn.disconnect();
       }
 

        jObject = XML.toJSONObject(sb.toString());
        mapper = new ObjectMapper();
        mapper.enable(SerializationFeature.INDENT_OUTPUT);
        json = mapper.readValue(jObject.toString(), Object.class);
        output = mapper.writeValueAsString(json);
        Map<String, Object> map1 = mapper.readValue(output, Map.class);

        map1 = (Map<String, Object>) map1.get("response");
        map1 = (Map<String, Object>) map1.get("body");
        //logger.info("totalcount1"+map1.get("totalCount"));
        totalCount = (int) map1.get("totalCount");
        map1 = (Map<String, Object>) map1.get("items");

        if(totalCount == 1) {
        	ArrayList<Map<String, Object>> list1 = new ArrayList<Map<String, Object>>();
        	list1.add((Map<String, Object>) map1.get("item"));
        	model.addAttribute("buld_list_init_1", list1);
        }else {
        	model.addAttribute("buld_list_init_1", map1.get("item"));
        }

        model.addAttribute("buld_list_1_init_sel",output);
        
      //건물정보 - 표제부 api
		urlBuilder= new StringBuilder("http://apis.data.go.kr/1613000/BldRgstService_v2/getBrTitleInfo"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "="+keyUrl); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("sigunguCd","UTF-8") + "=" + URLEncoder.encode(sigunguCd, "UTF-8")); /*행정표준코드*/
        urlBuilder.append("&" + URLEncoder.encode("bjdongCd","UTF-8") + "=" + URLEncoder.encode(bjdongCd, "UTF-8")); /*행정표준코드*/
        urlBuilder.append("&" + URLEncoder.encode("platGbCd","UTF-8") + "=" + URLEncoder.encode(platGbCd, "UTF-8")); /*0:대지 1:산 2:블록*/
        urlBuilder.append("&" + URLEncoder.encode("bun","UTF-8") + "=" + URLEncoder.encode(bun, "UTF-8")); /*번*/
        urlBuilder.append("&" + URLEncoder.encode("ji","UTF-8") + "=" + URLEncoder.encode(ji, "UTF-8")); /*지*/
        urlBuilder.append("&" + URLEncoder.encode("startDate","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*YYYYMMDD*/
        urlBuilder.append("&" + URLEncoder.encode("endDate","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*YYYYMMDD*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("10000", "UTF-8")); /*페이지당 목록 수*/
        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/

        url = new URL(urlBuilder.toString());
        conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        logger.info("Response code: " + conn.getResponseCode());
        
        try {
        	if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
                rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            } else {
                rd = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
            }
            sb = new StringBuilder();
            
            while ((line = rd.readLine()) != null) {
                sb.append(line);
            }
       }catch(IOException e) {
       		logger.error("오류입니다.");
       }finally {
       		rd.close();
           conn.disconnect();
       }

        jObject = XML.toJSONObject(sb.toString());
        mapper = new ObjectMapper();
        mapper.enable(SerializationFeature.INDENT_OUTPUT);
        json = mapper.readValue(jObject.toString(), Object.class);
        output = mapper.writeValueAsString(json);
        Map<String, Object> map3 = mapper.readValue(output, Map.class);
        map3 = (Map<String, Object>) map3.get("response");
        map3 = (Map<String, Object>) map3.get("body");
        logger.info("totalcount1"+map3.get("totalCount"));
        totalCount = (int) map3.get("totalCount");
        map3 = (Map<String, Object>) map3.get("items");


        if(totalCount == 1) {
        	ArrayList<Map<String, Object>> list3 = new ArrayList<Map<String, Object>>();
        	list3.add((Map<String, Object>) map3.get("item"));
        	model.addAttribute("buld_list_init_3", list3);
        }else {
        	model.addAttribute("buld_list_init_3",map3.get("item"));
        }
        model.addAttribute("buld_list_init_3_sel",output);
        
	
		//가격정보
    	List price_list_1 = gisinfoService.search_price_pnilp(gisVO);
    	model.addAttribute("price_list_1", price_list_1);
    	List price_list_2 = gisinfoService.search_price_indvdlz_house(gisVO);
    	model.addAttribute("price_list_2", price_list_2);
    	return "map/popup/Content_SH_View_Detail_popup.part";
    }
    
    
    @RequestMapping(value="/search/buildInfo/detail.do") 
    public ModelAndView searchBuildInfoDetail(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO, ModelMap model) throws SQLException, NullPointerException, IOException, JSONException
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
        	logger.info("pnu::::::::::"+pnu);
        	ModelAndView modelAndView = new ModelAndView();
        	
        	int totalCount = 0;
    		//건물정보 - api 사용
    		String sigunguCd = pnu.substring(0,5);
    		String bjdongCd = pnu.substring(5,10);
    		String platGbCd = pnu.substring(10,11);
    		String bun = pnu.substring(11,15);
    		String ji = pnu.substring(15,19);
    		
    		String keyUrl = "INzG2mIfcyuSdo2nnOzShtb2Uu876cATRp47R5dANGi3XIZW8QMTxiQ8LlarLS8OabiMtBnX7jFUhP%2FC76dByA%3D%3D"; //240523갱신 - 260523만료
    		
    		if(platGbCd.equals("1")) {
    			platGbCd = "0";
    		}else if(platGbCd.equals("2")) {
    			platGbCd = "1";
    		}
    		
    		StringBuilder urlBuilder;
    		URL url;
    		HttpURLConnection conn;
    		BufferedReader rd = null;
    		
    		org.json.JSONObject jObject;
    		ObjectMapper mapper;
    		Object json;
    		String output;
    		StringBuilder sb = null;
    		String line;
    		
    		// 건물정보 - 총괄표제부 api
            urlBuilder = new StringBuilder("http://apis.data.go.kr/1613000/BldRgstService_v2/getBrRecapTitleInfo"); /*URL*/
            urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "="+keyUrl); /*Service Key*/
            urlBuilder.append("&" + URLEncoder.encode("sigunguCd","UTF-8") + "=" + URLEncoder.encode(sigunguCd, "UTF-8")); /*행정표준코드*/
            urlBuilder.append("&" + URLEncoder.encode("bjdongCd","UTF-8") + "=" + URLEncoder.encode(bjdongCd, "UTF-8")); /*행정표준코드*/
            urlBuilder.append("&" + URLEncoder.encode("platGbCd","UTF-8") + "=" + URLEncoder.encode(platGbCd, "UTF-8")); /*0:대지 1:산 2:블록*/
            urlBuilder.append("&" + URLEncoder.encode("bun","UTF-8") + "=" + URLEncoder.encode(bun, "UTF-8")); /*번*/
            urlBuilder.append("&" + URLEncoder.encode("ji","UTF-8") + "=" + URLEncoder.encode(ji, "UTF-8")); /*지*/
            urlBuilder.append("&" + URLEncoder.encode("startDate","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*YYYYMMDD*/
            urlBuilder.append("&" + URLEncoder.encode("endDate","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*YYYYMMDD*/
            urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("10000", "UTF-8")); /*페이지당 목록 수*/
            urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/

            url = new URL(urlBuilder.toString());
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Content-type", "application/json");
            logger.info("Response code: " + conn.getResponseCode());
            
            try {
            	if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
                    rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
                } else {
                    rd = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
                }
                sb = new StringBuilder();
                while ((line = rd.readLine()) != null) {
                    sb.append(line);
                }
           }catch(IOException e) {
           		logger.error("오류입니다.");
           }finally {
           		rd.close();
               conn.disconnect();
           }
      
            jObject = XML.toJSONObject(sb.toString());
            mapper = new ObjectMapper();
            mapper.enable(SerializationFeature.INDENT_OUTPUT);
            json = mapper.readValue(jObject.toString(), Object.class);
            output = mapper.writeValueAsString(json);

            //logger.info(output);

            output = output.replace("mgmBldrgstPk", "manage_bild_regstr"); // 건물 번호
            output = output.replace("platPlc", "plot_lc"); // 소재지
            output = output.replace("crtnDay", "creat_de"); // 데이터 기준일
            output = output.replace("newPlatPlc", "rn_plot_lc"); // 소재지(도로명)
            output = output.replace("bldNm", "buld_nm"); // 건물명
            output = output.replace("splotNm", "spcl_nmfpc"); // 특수 지명
            output = output.replace("block", "blck"); // 블록
            output = output.replace("bylotCnt", "else_lot_co"); // 외필지 수
            output = output.replace("platArea", "plot_ar"); // 대지 면적
            output = output.replace("archArea", "bildng_ar"); // 건축 면적
            output = output.replace("bcRat", "bdtldr"); // 건폐율
            output = output.replace("totArea", "totar"); // 연면적
            output = output.replace("vlRat", "cpcty_rt"); // 용적률
            output = output.replace("vlRatEstmTotArea", "cpcty_rt_calc_totar"); // 용적률 산정 연면적
            output = output.replace("mainPurpsCdNm", "main_prpos_code_nm"); // 주용도
            output = output.replace("etcPurps", "etc_prpos"); // 기타용도
            output = output.replace("hhldCnt", "hshld_co"); // 세대수
            output = output.replace("fmlyCnt", "funitre_co"); // 가구수
            output = output.replace("mainBldCnt", "main_bild_co"); // 주 건축물 수
            output = output.replace("atchBldCnt", "atach_bild_co"); // 부속 건축물 수
            output = output.replace("atchBldArea", "atach_bild_ar"); // 부속 건축물 면적
            output = output.replace("totPkngCnt", "floor_parkng_co"); // 총 주차 수
            output = output.replace("indrMechUtcnt", "insdhous_mchne_alge"); // 옥내 기계식 대수
            output = output.replace("indrMechArea", "insdhous_mchne_ar"); // 옥내 기계식 면적
            output = output.replace("oudrMechUtcnt", "outhous_mchne_alge"); // 옥외 기계식 대수
            output = output.replace("oudrMechArea", "outhous_mchne_ar"); // 옥외 기계식 면적
            output = output.replace("indrAutoUtcnt", "insdhous_self_alge"); // 옥내 자주식 대수
            output = output.replace("indrAutoArea", "insdhous_self_ar"); // 옥내 자주식 면적
            output = output.replace("oudrAutoUtcnt", "outhous_self_alge"); // 옥외 자주식 대수
            output = output.replace("oudrAutoArea", "outhous_self_ar"); // 옥외 자주식 면적
            output = output.replace("pmsDay", "prmisn_de"); // 허가일
            output = output.replace("stcnsDay", "strwrk_de"); // 착공일
            output = output.replace("useAprDay", "use_confm_de"); // 사용승인일
            output = output.replace("hoCnt", "ho_co"); // 호 수
            output = output.replace("pmsnoKikCdNm", "prmisn_no_instt_code_nm"); // 허가번호 기관
            output = output.replace("pmsnoGbCdNm", "prmisn_no_se_code_nm"); // 허가번호 구분

            Map<String, Object> map1 = mapper.readValue(output, Map.class);

            map1 = (Map<String, Object>) map1.get("response");
            map1 = (Map<String, Object>) map1.get("body");
            //logger.info("totalcount1"+map1.get("totalCount"));
            totalCount = (int) map1.get("totalCount");
            map1 = (Map<String, Object>) map1.get("items");

            if(totalCount == 1) {
            	ArrayList<Map<String, Object>> list1 = new ArrayList<Map<String, Object>>();
            	list1.add((Map<String, Object>) map1.get("item"));
            	modelAndView.addObject("buld_list_1", list1);
            }else {
            	modelAndView.addObject("buld_list_1", map1.get("item"));
            }

            modelAndView.addObject("buld_list_1_sel",output);
            
    		
    		// 건물정보 - 전유부 api
            urlBuilder = new StringBuilder("http://apis.data.go.kr/1613000/BldRgstService_v2/getBrExposInfo"); /*URL*/
            urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "="+keyUrl); /*Service Key*/
            urlBuilder.append("&" + URLEncoder.encode("sigunguCd","UTF-8") + "=" + URLEncoder.encode(sigunguCd, "UTF-8")); /*행정표준코드*/
            urlBuilder.append("&" + URLEncoder.encode("bjdongCd","UTF-8") + "=" + URLEncoder.encode(bjdongCd, "UTF-8")); /*행정표준코드*/
            urlBuilder.append("&" + URLEncoder.encode("platGbCd","UTF-8") + "=" + URLEncoder.encode(platGbCd, "UTF-8")); /*0:대지 1:산 2:블록*/
            urlBuilder.append("&" + URLEncoder.encode("bun","UTF-8") + "=" + URLEncoder.encode(bun, "UTF-8")); /*번*/
            urlBuilder.append("&" + URLEncoder.encode("ji","UTF-8") + "=" + URLEncoder.encode(ji, "UTF-8")); /*지*/
            urlBuilder.append("&" + URLEncoder.encode("startDate","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*YYYYMMDD*/
            urlBuilder.append("&" + URLEncoder.encode("endDate","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*YYYYMMDD*/
            urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("10000", "UTF-8")); /*페이지당 목록 수*/
            urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
            
            logger.info("전유부!!!!!!!!!!::"+urlBuilder.toString());  
            url = new URL(urlBuilder.toString());
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Content-type", "application/json");
            logger.info("Response code: " + conn.getResponseCode());
            
            try {
            	if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
                    rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
                } else {
                    rd = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
                }
                sb = new StringBuilder();
                while ((line = rd.readLine()) != null) {
                    sb.append(line);
                }
           }catch(IOException e) {
           		logger.error("오류입니다.");
           }finally {
           		rd.close();
               conn.disconnect();
           }    

            jObject = XML.toJSONObject(sb.toString());
            mapper = new ObjectMapper();
            mapper.enable(SerializationFeature.INDENT_OUTPUT);
            json = mapper.readValue(jObject.toString(), Object.class);
            output = mapper.writeValueAsString(json);

            //logger.info(output);

            output = output.replace("mgmBldrgstPk", "manage_bild_regstr"); // 건물 정보
            output = output.replace("hoNm", "ho_nm"); // 호명
            output = output.replace("crtnDay", "creat_de"); // 데이터 기준 일자
            output = output.replace("platPlc", "plot_lc"); // 소재지
            output = output.replace("newPlatPlc", "rn_plot_lc"); // 소재지(도로명)
            output = output.replace("bldNm", "buld_nm"); // 건물명
            output = output.replace("splotNm", "spcl_nmfpc"); // 특수 지명
            output = output.replace("block", "blck"); // 블록
            output = output.replace("dongNm", "dong_nm"); // 동명
            output = output.replace("flrGbCdNm", "floor_se_code_nm"); // 층 구분명
            output = output.replace("flrNo", "floor_no"); // 층 번호

            Map<String, Object> map2 = mapper.readValue(output, Map.class);

            map2 = (Map<String, Object>) map2.get("response");
            map2 = (Map<String, Object>) map2.get("body");
            totalCount = (int) map2.get("totalCount");
            map2 = (Map<String, Object>) map2.get("items");


            if(totalCount == 1) {
            	ArrayList<Map<String, Object>> list2 = new ArrayList<Map<String, Object>>();
            	list2.add((Map<String, Object>) map2.get("item"));
            	modelAndView.addObject("buld_list_2", list2);
            }else {


            	// 건물, 동, 호 정렬 코드
            	if(map2.get("item") != null) {
            		ArrayList<Map<String, Object>> list2 = new ArrayList<Map<String, Object>>();
    	        	list2 = (ArrayList<Map<String, Object>>) map2.get("item");
    	        	SortedMap<String, Object> sortmap = new TreeMap<>();

    	        	for(Map<String,Object> e : list2) {
    	        		logger.info(e.get("ho_nm"));
    	        		String dong = (String.valueOf(e.get("dong_nm"))).replaceAll("[^0-9]","").toString();
    	        		String flrNo = String.valueOf(e.get("floor_no")).toString();
    	        		String ho = ( String.valueOf(e.get("ho_nm"))).replaceAll("[^0-9]","").toString();

    	        		if("".equals(dong)) {
    	        			dong = "0";
    	        		}

    	        		if("".equals(flrNo)) {
    	        			flrNo = "0";
    	        		}

    	        		if("".equals(ho)) {
    	        			ho = "0";
    	        		}

    	        		String sortkey = String.format("%03d",Integer.parseInt(dong)) + String.format("%02d",Integer.parseInt(flrNo)) + String.format("%04d",Integer.parseInt(ho));

    	        		Map<String, Object> sortdata = new HashMap<String, Object>();

    	        		sortdata.put("manage_bild_regstr", e.get("manage_bild_regstr"));
    	        		sortdata.put("buld_nm", e.get("buld_nm"));
    	        		sortdata.put("dong_nm", e.get("dong_nm"));
    	        		sortdata.put("floor_no", e.get("floor_no"));
    	        		sortdata.put("ho_nm", e.get("ho_nm"));
    	        		sortdata.put("creat_de", e.get("creat_de"));
    	        		sortdata.put("plot_lc", e.get("plot_lc"));
    	        		sortdata.put("rn_plot_lc", e.get("rn_plot_lc"));
    	        		sortdata.put("spcl_nmfpc", e.get("spcl_nmfpc"));
    	        		sortdata.put("blck", e.get("blck"));
    	        		sortdata.put("floor_se_code_nm", e.get("floor_se_code_nm"));


    	        		sortmap.put(sortkey, sortdata);
    	        	}

    	        	ArrayList<Map<String, Object>> selectmodel = new ArrayList<Map<String, Object>>();
    	        	for(String key : sortmap.keySet()) {
    	        		selectmodel.add((Map<String, Object>) sortmap.get(key));
    	        	}
    	        	modelAndView.addObject("selectmodel", selectmodel);
            	}else {
            		modelAndView.addObject("buld_list_2", map2.get("item"));
            	}
            }

            modelAndView.addObject("buld_list_2_sel",output);
            
            //건물정보 - 표제부 api
    		urlBuilder= new StringBuilder("http://apis.data.go.kr/1613000/BldRgstService_v2/getBrTitleInfo"); /*URL*/
            urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "="+keyUrl); /*Service Key*/
            urlBuilder.append("&" + URLEncoder.encode("sigunguCd","UTF-8") + "=" + URLEncoder.encode(sigunguCd, "UTF-8")); /*행정표준코드*/
            urlBuilder.append("&" + URLEncoder.encode("bjdongCd","UTF-8") + "=" + URLEncoder.encode(bjdongCd, "UTF-8")); /*행정표준코드*/
            urlBuilder.append("&" + URLEncoder.encode("platGbCd","UTF-8") + "=" + URLEncoder.encode(platGbCd, "UTF-8")); /*0:대지 1:산 2:블록*/
            urlBuilder.append("&" + URLEncoder.encode("bun","UTF-8") + "=" + URLEncoder.encode(bun, "UTF-8")); /*번*/
            urlBuilder.append("&" + URLEncoder.encode("ji","UTF-8") + "=" + URLEncoder.encode(ji, "UTF-8")); /*지*/
            urlBuilder.append("&" + URLEncoder.encode("startDate","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*YYYYMMDD*/
            urlBuilder.append("&" + URLEncoder.encode("endDate","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*YYYYMMDD*/
            urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("10000", "UTF-8")); /*페이지당 목록 수*/
            urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/

            url = new URL(urlBuilder.toString());
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Content-type", "application/json");
            logger.info("Response code: " + conn.getResponseCode());
            
            try {
            	if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
                    rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
                } else {
                    rd = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
                }
                sb = new StringBuilder();
                while ((line = rd.readLine()) != null) {
                    sb.append(line);
                }
           }catch(IOException e) {
           		logger.error("오류입니다.");
           }finally {
           		rd.close();
               conn.disconnect();
           } 

            jObject = XML.toJSONObject(sb.toString());
            mapper = new ObjectMapper();
            mapper.enable(SerializationFeature.INDENT_OUTPUT);
            json = mapper.readValue(jObject.toString(), Object.class);
            output = mapper.writeValueAsString(json);

            //logger.info(output);
            output = output.replace("mgmBldrgstPk", "manage_bild_regstr"); // 건물 번호
            output = output.replace("platPlc", "plot_lc"); // 소재지
            output = output.replace("crtnDay", "creat_de"); // 데이터 기준일
            output = output.replace("newPlatPlc", "rn_plot_lc"); // 소재지(도로명)
            output = output.replace("bldNm", "buld_nm"); // 건물명
            output = output.replace("splotNm", "spcl_nmfpc"); // 특수 지명
            output = output.replace("block", "blck"); // 블록
            output = output.replace("bylotCnt", "else_lot_co"); // 외필지 수
            output = output.replace("platArea", "plot_ar"); // 대지 면적
            output = output.replace("archArea", "bildng_ar"); // 건축 면적
            output = output.replace("bcRat", "bdtldr"); // 건폐율
            output = output.replace("totArea", "totar"); // 연면적
            output = output.replace("vlRat", "cpcty_rt"); // 용적률
            output = output.replace("vlRatEstmTotArea", "cpcty_rt_calc_totar"); // 용적률 산정 연면적
            output = output.replace("strctCdNm", "strct_code_nm"); // 구조
            output = output.replace("etcStrct", "etc_strct"); // 기타 구조
            output = output.replace("mainPurpsCdNm", "main_prpos_code_nm"); // 주용도
            output = output.replace("etcPurps", "etc_prpos"); // 기타용도
            output = output.replace("roofCdNm", "rf_code_nm"); // 지붕코드
            output = output.replace("etcRoof", "etc_rf"); // 기타 지붕
            output = output.replace("hhldCnt", "hshld_co"); // 세대수
            output = output.replace("fmlyCnt", "funitre_co"); // 가구수
            output = output.replace("heit", "hg"); // 높이
            output = output.replace("grndFlrCnt", "ground_floor_co"); // 지상 층 수
            output = output.replace("ugrndFlrCnt", "undgrnd_floor_co"); // 지하 층 수
            output = output.replace("rideUseElvtCnt", "rdng_elvtr_co"); // 승용 승강기 수
            output = output.replace("emgenUseElvtCnt", "emgnc_elvtr_co"); // 비상용 승강기 수
            output = output.replace("atchBldCnt", "atach_bild_co"); // 부속 건축물 수
            output = output.replace("atchBldArea", "atach_bild_ar"); // 부속 건축물 면적
            output = output.replace("totDongTotArea", "floor_dong_totar"); // 총 동 연면적
            output = output.replace("indrMechUtcnt", "insdhous_mchne_alge"); // 옥내 기계식 대수
            output = output.replace("indrMechArea", "insdhous_mchne_ar"); // 옥내 기계식 면적
            output = output.replace("oudrMechUtcnt", "outhous_mchne_alge"); // 옥외 기계식 대수
            output = output.replace("oudrMechArea", "outhous_mchne_ar"); // 옥외 기계식 면적
            output = output.replace("indrAutoUtcnt", "insdhous_self_alge"); // 옥내 자주식 대수
            output = output.replace("indrAutoArea", "insdhous_self_ar"); // 옥내 자주식 면적
            output = output.replace("oudrAutoUtcnt", "outhous_self_alge"); // 옥외 자주식 대수
            output = output.replace("oudrAutoArea", "outhous_self_ar"); // 옥외 자주식 면적
            output = output.replace("pmsDay", "prmisn_de"); // 허가일
            output = output.replace("stcnsDay", "strwrk_de"); // 착공일
            output = output.replace("useAprDay", "use_confm_de"); // 사용승인일
            output = output.replace("hoCnt", "ho_co"); // 호 수
            output = output.replace("pmsnoKikCdNm", "prmisn_no_instt_code_nm"); // 허가번호 기관
            output = output.replace("pmsnoGbCdNm", "prmisn_no_se_code_nm"); // 허가번호 구분

            Map<String, Object> map3 = mapper.readValue(output, Map.class);
            map3 = (Map<String, Object>) map3.get("response");
            map3 = (Map<String, Object>) map3.get("body");
            logger.info("totalcount1"+map3.get("totalCount"));
            totalCount = (int) map3.get("totalCount");
            map3 = (Map<String, Object>) map3.get("items");


            if(totalCount == 1) {
            	ArrayList<Map<String, Object>> list3 = new ArrayList<Map<String, Object>>();
            	list3.add((Map<String, Object>) map3.get("item"));
            	modelAndView.addObject("buld_list_3", list3);
            }else {
            	modelAndView.addObject("buld_list_3",map3.get("item"));
            }
            modelAndView.addObject("buld_list_3_sel",output);
            
			modelAndView.addObject("result", "Y");
			modelAndView.setViewName("jsonView");

			return modelAndView;
		}else{
	       	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
	     }
	   	
    	return null;
    }
    
    @RequestMapping(value="/search/priceInfo/detail.do") 
    public String searchPriceInfoDetail(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO, ModelMap model) throws SQLException, NullPointerException, IOException
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
        	logger.info("pnu::::::::::"+pnu);
        	ModelAndView modelAndView = new ModelAndView();
        	
        	HashMap priceList = gisinfoService.search_price_detail(gisVO);
        	logger.info("건축물검색상세보기!!!!!!!!"+priceList.toString());
        	model.addAttribute("priceList", priceList); 
    		JSONObject jsonObject = new JSONObject(priceList);
    		model.addAttribute("priceListJson", jsonObject); 
    		return "map/popup/priceInfo.part";
        }else{
        	jsHelper.Alert("비정상적인 접근 입니다.");
        	jsHelper.RedirectUrl(invalidUrl);
        }
        return null;
    }

		/* 분석 검색 결과   */
    @RequestMapping(value="/analyResultList_popup.do")
    public String analyResultList_popup(HttpServletRequest request, HttpServletResponse response, GisBasicVO gisVO, ModelMap model) throws SQLException, NullPointerException, IOException
    {
        Map<String, Object> dataMap = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        
        // UTF-8 인코딩 설정
        request.setCharacterEncoding("UTF-8");

        // 모든 파라미터를 순회하여 dataMap에 추가
        Map<String, String[]> parameterMap = request.getParameterMap();
        for (Map.Entry<String, String[]> entry : parameterMap.entrySet()) {
            String key = entry.getKey();
            String[] valueArray = entry.getValue();

            // value가 JSON 문자열로 들어온 경우 JSON으로 파싱
            if (valueArray.length == 1) {
                String value = valueArray[0];
                if (value.startsWith("{") || value.startsWith("[")) {
                    // JSON 형식으로 파싱하여 추가
                    dataMap.put(key, mapper.readValue(value, Object.class));
                } else {
                    // 단순 문자열이면 그대로 추가
                    dataMap.put(key, value);
                }
            } else {
                // 여러 값이 배열로 들어온 경우
                dataMap.put(key, valueArray);
            }
        }

        // dataMap을 JSON으로 직렬화하여 Model에 추가
        String jsonString = mapper.writeValueAsString(dataMap);
        model.addAttribute("resultData", jsonString);

        return "map/popup/analysisResultList.part";
    }
}
