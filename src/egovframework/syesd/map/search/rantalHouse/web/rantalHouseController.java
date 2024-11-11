package egovframework.syesd.map.search.rantalHouse.web;

import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

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

import egovframework.syesd.admin.layer.service.AdminLayerService;
import egovframework.syesd.admin.table.service.AdminTableService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.syesd.cmmn.menu.service.MenuService;
import egovframework.syesd.portal.gis.service.GisService;
import egovframework.zaol.common.service.CommonService;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;
import egovframework.zaol.gisinfo.service.GisBasicVO;
import egovframework.zaol.gisinfo.service.GisinfoService;

@Controller
public class rantalHouseController extends BaseController {
	private static Logger logger = LogManager.getLogger(rantalHouseController.class);
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
    
    @RequestMapping(value="/search/rantalHouse.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String searchRantalHouse (HttpServletRequest request, HttpServletResponse response, ModelMap model, @ModelAttribute("gisvo") GisBasicVO gisvo) throws SQLException, NullPointerException, IOException 
	{
		
		HttpSession session = getSession();
		String userS_id = null;
	   	if(session != null){
	   		userS_id = (String)session.getAttribute("userId");
	   	}

       if( userS_id != null ){

       	List SIGList = gisinfoService.sig_list(gisvo);
       //	List GISCodeList = gisinfoService.gis_code_list(gisvo); 사용X

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

       	return "map/search/rantalHouse.sub";

       }else{
       	jsHelper.Alert("비정상적인 접근 입니다.");
       	jsHelper.RedirectUrl(invalidUrl);
       }
       return null;
	}
    
    @RequestMapping(value = RequestMappingConstants.WEB_GIS_DATA_RENTAL, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisRentalList(HttpServletRequest request,
									HttpServletResponse response,
									ModelMap model) throws SQLException, NullPointerException, IOException
	{
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
		
		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			HttpSession session = getSession();
			if(session != null)
			{
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
		        String userId = commonSessionVO.getUser_id();
		        String userAdmYn = commonSessionVO.getUser_admin_yn();
		        Map conditions = getParameterMap(request);
		        String search_type = (String)conditions.get("SEARCH_TYPE");
		
		        HashMap<String, Object> query = new HashMap<String, Object>();
		        query.put("KEY", RequestMappingConstants.KEY);
				query.put("USER_ID", userId);
				query.put("CONDITIONS", conditions);
		
				List headList = null;
				List<String> headEngList = new ArrayList<String>();
				List<String> headKorList = new ArrayList<String>();
				List dataList = null;
		
				ModelAndView modelAndView = new ModelAndView();
		
				if("APT".equals(search_type) == true) {
					dataList = gisService.selectRentalAptList(query);
		
					//query.clear();
					query.put("TABLE_SPACE", "LANDSYS_GIS");
					query.put("TABLE_NM", "tb_apt_hsmp");
		
					query.put("LAYER_TP_NM", "tg_apt_hsmp_buld_manage");
					modelAndView.addObject("geometryInfo", gisService.selectTableGeomTypeInfo(query));
					modelAndView.addObject("tableSpace", "LANDSYS_GIS");
					modelAndView.addObject("tableNm", "tb_apt_hsmp");
				}
				if("MLTDWL".equals(search_type) == true) {
					dataList = gisService.selectRentalMltdwlList(query);
		
					//query.clear();
					query.put("TABLE_SPACE", "LANDSYS_GIS");
					query.put("TABLE_NM", "TB_MLTDWL");
		
					query.put("LAYER_TP_NM", "TG_MLTDWL_MANAGE");
					modelAndView.addObject("geometryInfo", gisService.selectTableGeomTypeInfo(query));
					modelAndView.addObject("tableSpace", "LANDSYS_GIS");
					modelAndView.addObject("tableNm", "TB_MLTDWL");
				}
				if("CTY_LVLH".equals(search_type) == true) {
					dataList = gisService.selectRentalCityLvlhList(query);
		
					//query.clear();
					query.put("TABLE_SPACE", "LANDSYS_GIS");
					query.put("TABLE_NM", "tb_cty_lvlh_house");
		
					query.put("LAYER_TP_NM", "tg_cty_lvlh_house_manage");
					modelAndView.addObject("geometryInfo", gisService.selectTableGeomTypeInfo(query));
					modelAndView.addObject("tableSpace", "LANDSYS_GIS");
					modelAndView.addObject("tableNm", "tb_cty_lvlh_house");
				}
				if("LFSTS_RENT".equals(search_type) == true) {
					dataList = gisService.selectRentalLfstsRentList(query);
		
					//query.clear();
					query.put("TABLE_SPACE", "LANDSYS_GIS");
					query.put("TABLE_NM", "TG_LFSTS_RENT_MANAGE");
		
					query.put("LAYER_TP_NM", "TG_LFSTS_RENT_MANAGE");
					modelAndView.addObject("geometryInfo", gisService.selectTableGeomTypeInfo(query));
					modelAndView.addObject("tableSpace", "LANDSYS_GIS");
					modelAndView.addObject("tableNm", "TG_LFSTS_RENT_MANAGE");
				}
				if("LNGTR_SAFETY".equals(search_type) == true) {
					dataList = gisService.selectRentalLngtrSafetyList(query);
		
					//query.clear();
					query.put("TABLE_SPACE", "LANDSYS_GIS");
					query.put("TABLE_NM", "TG_LNGTR_SAFETY_MANAGE");
		
					query.put("LAYER_TP_NM", "TG_LNGTR_SAFETY_MANAGE");
					modelAndView.addObject("geometryInfo", gisService.selectTableGeomTypeInfo(query));
					modelAndView.addObject("tableSpace", "LANDSYS_GIS");
					modelAndView.addObject("tableNm", "TG_LNGTR_SAFETY_MANAGE");
				}
		
				headList = gisService.selectColumnCommentList(query);
				Iterator it = headList.iterator();
				while(it.hasNext()) {
					Map<String, String> map = (Map)it.next();
					for( Map.Entry<String, String> elem : map.entrySet() ){
						String key = elem.getKey();
						if(key.equals("column_nm") == true || key.equals("column_comment") == true) {
							String val = elem.getValue();
		
							if(key.equals("column_nm") == true)
								headEngList.add(val);
							else if(key.equals("column_comment") == true)
								headKorList.add(val);
						}
					}
				}
		
				modelAndView.addObject("tablePkInfo", gisService.selectTablePkColumn(query));
				modelAndView.addObject("tableEditInfo", gisService.selectTableAttrEditAuth(query));
				modelAndView.addObject("headEngInfo", headEngList);
				modelAndView.addObject("headKorInfo", headKorList);
				modelAndView.addObject("dataInfo", dataList);
				modelAndView.addObject("result", "Y");
				modelAndView.setViewName("jsonView");
		
				return modelAndView;
			}
			else
			{
		    	jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
		    	jsHelper.RedirectUrl(invalidUrl);
		    }
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			jsHelper.RedirectUrl(invalidUrl);
		}
		
		return null;
	}
	
    @RequestMapping(value=RequestMappingConstants.WEB_GIS_DATA_APT_COND, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisRentalAptCondtion(HttpServletRequest request,
											HttpServletResponse response,
											ModelMap model) throws SQLException, NullPointerException, IOException
	{
		response.setCharacterEncoding("UTF-8");

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			URL url = new URL(referer);
			String host = url.getHost();

			HttpSession session = getSession();
			if(session != null)
			{
				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("rentHsmpInfo", gisService.selectRentAptHsmpNm());
				modelAndView.addObject("rentSeInfo", gisService.selectRentAptRentSe());
				modelAndView.addObject("rentTyInfo", gisService.selectRentAptRentTy(null));
				modelAndView.addObject("seInfo", gisService.selectRentAptSe());
				modelAndView.addObject("atdrcInfo", gisService.selectRentAptAtdrc());
				modelAndView.addObject("cnterInfo", gisService.selectRentAptCnter());
				modelAndView.addObject("result", "Y");
				modelAndView.setViewName("jsonView");

		    	return modelAndView;
			}
			else
			{
		    	jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
		    	jsHelper.RedirectUrl(invalidUrl);
		    }
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			   	jsHelper.RedirectUrl(invalidUrl);
		}

		return null;
	}
	
    @RequestMapping(value=RequestMappingConstants.WEB_GIS_DATA_APT_RENTTY, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisRentalAptTypeCondtion(HttpServletRequest request,
										HttpServletResponse response,
										@RequestParam(value="rent_se",   required=false) String  rentSe,
										ModelMap model) throws SQLException, NullPointerException, IOException
	{
		response.setCharacterEncoding("UTF-8");
		
		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			URL url = new URL(referer);
			String host = url.getHost();
		
			HttpSession session = getSession();
			if(session != null)
			{
				HashMap<String, Object> query = new HashMap<String, Object>();
		        query.put("RENT_SE", rentSe);
		
				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("rentTyInfo", gisService.selectRentAptRentTy(query));
				modelAndView.addObject("result", "Y");
				modelAndView.setViewName("jsonView");
		
		    	return modelAndView;
			}
			else
			{
		    	jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
		    	jsHelper.RedirectUrl(invalidUrl);
		    }
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			   	jsHelper.RedirectUrl(invalidUrl);
		}
		
		return null;
	}
	
	@RequestMapping(value=RequestMappingConstants.WEB_GIS_DATA_MLTDWL_COND, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisRentalMltdwlCondtion(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws SQLException, NullPointerException, IOException
	{
		response.setCharacterEncoding("UTF-8");
		
		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			URL url = new URL(referer);
			String host = url.getHost();
		
			HttpSession session = getSession();
			if(session != null)
			{
				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("bsnsNmInfo", gisService.selectMltdwBsnsNm());
				modelAndView.addObject("bsnsCodeInfo", gisService.selectMltdwlBsnsCode());
				modelAndView.addObject("dongInfo", gisService.selectMltdwlDong());
				modelAndView.addObject("atdrcInfo", gisService.selectMltdwlAtdrc());
				modelAndView.addObject("cnterInfo", gisService.selectMltdwlCnter());
				modelAndView.addObject("buldStrctInfo", gisService.selectMltdwlBuldStrct());
				modelAndView.addObject("result", "Y");
				modelAndView.setViewName("jsonView");
		
		    	return modelAndView;
			}
			else
			{
		    	jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
		    	jsHelper.RedirectUrl(invalidUrl);
		    }
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			   	jsHelper.RedirectUrl(invalidUrl);
		}
		
		return null;
	}
	
	@RequestMapping(value=RequestMappingConstants.WEB_GIS_DATA_CTY_COND, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisRentalCityLvlhCondtion(HttpServletRequest request,
												HttpServletResponse response,
												ModelMap model) throws SQLException, NullPointerException, IOException
	{
		response.setCharacterEncoding("UTF-8");
		
		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			URL url = new URL(referer);
			String host = url.getHost();
		
			HttpSession session = getSession();
			if(session != null)
			{
				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("bsnsNmInfo", gisService.selectCityLvlhBsnsNm());
				modelAndView.addObject("bsnsCodeInfo", gisService.selectCityLvlhBsnsCode());
				modelAndView.addObject("dongInfo", gisService.selectCityLvlhDong());
				modelAndView.addObject("atdrcInfo", gisService.selectCityLvlhAtdrc());
				modelAndView.addObject("cnterInfo", gisService.selectCityLvlhCnter());
				modelAndView.addObject("result", "Y");
				modelAndView.setViewName("jsonView");
		
		    	return modelAndView;
			}
			else
			{
		    	jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
		    	jsHelper.RedirectUrl(invalidUrl);
		    }
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			   	jsHelper.RedirectUrl(invalidUrl);
		}
		
		return null;
	}
	
	@RequestMapping(value=RequestMappingConstants.WEB_GIS_DATA_LFSTS_COND, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisRentalLfstsCondtion(HttpServletRequest request,
											HttpServletResponse response,
											ModelMap model) throws SQLException, NullPointerException, IOException
	{
		response.setCharacterEncoding("UTF-8");
		
		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			URL url = new URL(referer);
			String host = url.getHost();
		
			HttpSession session = getSession();
			if(session != null)
			{
				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("bsnsCodeInfo", gisService.selectLfstsBsnsCode());
				modelAndView.addObject("dongInfo", gisService.selectLfstsDong());
				modelAndView.addObject("atdrcInfo", gisService.selectLfstsAtdrc());
				modelAndView.addObject("cnterInfo", gisService.selectLfstsCnter());
				modelAndView.addObject("result", "Y");
				modelAndView.setViewName("jsonView");
		
		    	return modelAndView;
			}
			else
			{
		    	jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
		    	jsHelper.RedirectUrl(invalidUrl);
		    }
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			   	jsHelper.RedirectUrl(invalidUrl);
		}
		
		return null;
	}
	
	@RequestMapping(value=RequestMappingConstants.WEB_GIS_DATA_LNGTR_COND, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisRentalLngtrSafetyCondtion(HttpServletRequest request,
												HttpServletResponse response,
												ModelMap model) throws SQLException, NullPointerException, IOException
	{
		response.setCharacterEncoding("UTF-8");
		
		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			URL url = new URL(referer);
			String host = url.getHost();
		
			HttpSession session = getSession();
			if(session != null)
			{
				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("bsnsCodeInfo", gisService.selectLngtrSafetyBsnsCode());
				modelAndView.addObject("dongInfo", gisService.selectLngtrSafetyDong());
				modelAndView.addObject("atdrcInfo", gisService.selectLngtrSafetyAtdrc());
				modelAndView.addObject("cnterInfo", gisService.selectLngtrSafetyCnter());
				modelAndView.addObject("result", "Y");
				modelAndView.setViewName("jsonView");
		
		    	return modelAndView;
			}
			else
			{
		    	jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
		    	jsHelper.RedirectUrl(invalidUrl);
		    }
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			   	jsHelper.RedirectUrl(invalidUrl);
		}
		
		return null;
	}
	
	@RequestMapping(value=RequestMappingConstants.WEB_GIS_DATA_RENTAL_STATS, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisRentalStats(HttpServletRequest request,
								HttpServletResponse response,
								@RequestParam(value="layerNm",   required=false) String  layerNm,
								ModelMap model) throws SQLException, NullPointerException, IOException
	{
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
		
		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			HttpSession session = getSession();
			if(session != null)
			{
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
		        String userId = commonSessionVO.getUser_id();
		        String userAdmYn = commonSessionVO.getUser_admin_yn();
		
				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("statAptInfo", gisService.selectRentalAptStat());						// 아파트
				modelAndView.addObject("statMltdwlInfo", gisService.selectRentalMltdwlStat());					// 다가구
				modelAndView.addObject("statCityLvlhInfo", gisService.selectRentalCityLvlhStat());				// 도시형생활주택
				modelAndView.addObject("statLfstsRentInfo", gisService.selectRentalLfstsRentStat());			// 전세임대
				modelAndView.addObject("statLngtrSafetyInfo", gisService.selectRentalLngtrSafetyStat());		// 장기안심
				modelAndView.addObject("result", "Y");
				modelAndView.setViewName("jsonView");
		
		    	/* 이력 */
		    	try
				{
		        	HashMap<String, Object> param = new HashMap<String, Object>();
		        	param.put("KEY", RequestMappingConstants.KEY);
			       	param.put("PREFIX", "LOG");
		        	param.put("USER_ID", userId);
		        	param.put("PROGRM_URL", request.getRequestURI());
		
		    		/* 프로그램 사용 이력 등록 */
					logsService.insertUserProgrmLogs(param);
				}
				catch (SQLException e)
				{
					logger.error("이력 등록 실패");
				}
		
				return modelAndView;
			}
			else
			{
		    	jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
		    	jsHelper.RedirectUrl(invalidUrl);
		    }
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			jsHelper.RedirectUrl(invalidUrl);
		}
		
		return null;
	}
	
	@RequestMapping(value=RequestMappingConstants.WEB_GIS_DATA_RENTAL_TOTAL, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisRentalTotal(HttpServletRequest request,
							HttpServletResponse response,
							ModelMap model) throws SQLException, NullPointerException, IOException
	{
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
		
		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			HttpSession session = getSession();
			if(session != null)
			{
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
		        String userId = commonSessionVO.getUser_id();
		        String userAdmYn = commonSessionVO.getUser_admin_yn();
		
		        Map conditions = getParameterMap(request);
		        String search_type = (String)conditions.get("SEARCH_TYPE");
		        String search_key = (String)conditions.get("KEY");
		        String search_value = (String)conditions.get("VALUE");
		
		        conditions.put(search_key.toUpperCase(), search_value.toUpperCase());
		
		        HashMap<String, Object> query = new HashMap<String, Object>();
		        query.put("KEY", RequestMappingConstants.KEY);
				query.put("USER_ID", userId);
				query.put("CONDITIONS", conditions);
		
				List headList = null;
				List<String> headEngList = new ArrayList<String>();
				List<String> headKorList = new ArrayList<String>();
				List dataList = null;
		
				ModelAndView modelAndView = new ModelAndView();
		
				// 마스터 정보
				if("APT".equals(search_type) == true) {
					dataList = gisService.selectRentalAptList(query);
		
					//query.clear();
					query.put("TABLE_SPACE", "LANDSYS_GIS");
					query.put("TABLE_NM", "tb_apt_hsmp");
				}
				if("MLTDWL".equals(search_type) == true) {
					dataList = gisService.selectRentalMltdwlList(query);
		
					//query.clear();
					query.put("TABLE_SPACE", "LANDSYS_GIS");
					query.put("TABLE_NM", "TB_MLTDWL");
				}
				if("CTY_LVLH".equals(search_type) == true) {
					dataList = gisService.selectRentalCityLvlhList(query);
		
					//query.clear();
					query.put("TABLE_SPACE", "LANDSYS_GIS");
					query.put("TABLE_NM", "tb_cty_lvlh_house");
				}
				if("LFSTS_RENT".equals(search_type) == true) {
					dataList = gisService.selectRentalLfstsRentList(query);
		
					//query.clear();
					query.put("TABLE_SPACE", "LANDSYS_GIS");
					query.put("TABLE_NM", "TG_LFSTS_RENT_MANAGE");
				}
				if("LNGTR_SAFETY".equals(search_type) == true) {
					dataList = gisService.selectRentalLngtrSafetyList(query);
		
					//query.clear();
					query.put("TABLE_SPACE", "LANDSYS_GIS");
					query.put("TABLE_NM", "TG_LNGTR_SAFETY_MANAGE");
				}
		
				String bsns_code = (String)((Map)dataList.get(0)).get("bsns_code");
				query.put("BSNS_CODE", bsns_code);
		
				modelAndView.addObject("bsnsNmInfo", gisService.selectBsnsNmByCode(query));
		
				headList = gisService.selectColumnCommentList(query);
				Iterator it = headList.iterator();
				while(it.hasNext()) {
					Map<String, String> map = (Map)it.next();
					for(Map.Entry<String, String> elem : map.entrySet() ){
						String key = elem.getKey();
						if(key.equals("column_nm") == true || key.equals("column_comment") == true) {
							String val = elem.getValue();
		
							if(key.equals("column_nm") == true)
								headEngList.add(val);
							else if(key.equals("column_comment") == true)
								headKorList.add(val);
						}
					}
				}
		
				modelAndView.addObject("headEngInfo", headEngList);
				modelAndView.addObject("headKorInfo", headKorList);
				modelAndView.addObject("dataInfo", dataList);
		
				// 동호 정보
				if("APT".equals(search_type) == true || "MLTDWL".equals(search_type) == true || "CTY_LVLH".equals(search_type) == true) {
					List subHeadList = null;
					List<String> subHeadEngList = new ArrayList<String>();
					List<String> subHeadKorList = new ArrayList<String>();
					List subDataList = null;
		
					if("APT".equals(search_type) == true) {
						String bsns_code1 = (String)((Map)dataList.get(0)).get("bsns_code");
						query.put("BSNS_CODE", bsns_code1);
		
						subDataList = gisService.selectRentalAptDongHoList(query);
					} else if("MLTDWL".equals(search_type) == true) {
						String mltdwl_code = (String)((Map)dataList.get(0)).get("mltdwl_code");
						query.put("MLTDWL_CODE", mltdwl_code);
		
						subDataList = gisService.selectRentalMltdwlDongHoList(query);
					} else if("CTY_LVLH".equals(search_type) == true) {
						String cty_code = (String)((Map)dataList.get(0)).get("cty_code");
						query.put("CTY_CODE", cty_code);
		
						subDataList = gisService.selectRentalCtyLvlhDongHoList(query);
					}
		
					query.put("TABLE_SPACE", "LANDSYS_GIS");
					query.put("TABLE_NM", "tb_dong_table");
		
					subHeadList = gisService.selectColumnCommentList(query);
					Iterator it1 = subHeadList.iterator();
					while(it1.hasNext()) {
						Map<String, String> map = (Map)it1.next();
						for(Map.Entry<String, String> elem : map.entrySet() ){
							String key = elem.getKey();
							if(key.equals("column_nm") == true || key.equals("column_comment") == true) {
								String val = elem.getValue();
		
								if(key.equals("column_nm") == true)
									subHeadEngList.add(val);
								else if(key.equals("column_comment") == true)
									subHeadKorList.add(val);
							}
						}
					}
		
					modelAndView.addObject("subHeadEngInfo", subHeadEngList);
					modelAndView.addObject("subHeadKorInfo", subHeadKorList);
					modelAndView.addObject("subDataInfo", subDataList);
				}
		
				modelAndView.addObject("result", "Y");
				modelAndView.setViewName("jsonView");
		
				return modelAndView;
			}
			else
			{
		    	jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
		    	jsHelper.RedirectUrl(invalidUrl);
		    }
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			jsHelper.RedirectUrl(invalidUrl);
		}
		
		return null;
	}
	
	@RequestMapping(value=RequestMappingConstants.WEB_GIS_DATA_RENTAL_APT_K, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisRentalAptk(HttpServletRequest request,
							HttpServletResponse response,
							@RequestParam(value="bsns_code",   required=false) String  bsns_code,
							ModelMap model) throws SQLException, NullPointerException, IOException
	{
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
		
		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			HttpSession session = getSession();
			if(session != null)
			{
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
		        String userId = commonSessionVO.getUser_id();
		        String userAdmYn = commonSessionVO.getUser_admin_yn();
		
		        Map conditions = getParameterMap(request);
		
		        HashMap<String, Object> query = new HashMap<String, Object>();
		        query.put("KEY", RequestMappingConstants.KEY);
				query.put("USER_ID", userId);
				query.put("BSNS_CODE", bsns_code);
				query.put("TABLE_SPACE", "LANDSYS_GIS");
				query.put("TABLE_NM", "TB_K_APT");
		
				List headList = null;
				List<String> headEngList = new ArrayList<String>();
				List<String> headKorList = new ArrayList<String>();
		
				headList = gisService.selectColumnCommentList(query);
				Iterator it = headList.iterator();
				while(it.hasNext()) {
					Map<String, String> map = (Map)it.next();
					for( Map.Entry<String, String> elem : map.entrySet() ){
						String key = elem.getKey();
						if(key.equals("column_nm") == true || key.equals("column_comment") == true) {
							String val = elem.getValue();
		
							if(key.equals("column_nm") == true)
								headEngList.add(val);
							else if(key.equals("column_comment") == true)
								headKorList.add(val);
						}
					}
				}
		
				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("headEngInfo", headEngList);
				modelAndView.addObject("headKorInfo", headKorList);
				modelAndView.addObject("dataInfo", gisService.selectRentalAptkList(query));
				modelAndView.addObject("result", "Y");
				modelAndView.setViewName("jsonView");
		
		    	/* 이력 */
		    	try
				{
		        	HashMap<String, Object> param = new HashMap<String, Object>();
		        	param.put("KEY", RequestMappingConstants.KEY);
			       	param.put("PREFIX", "LOG");
		        	param.put("USER_ID", userId);
		        	param.put("PROGRM_URL", request.getRequestURI());
		
		    		/* 프로그램 사용 이력 등록 */
					logsService.insertUserProgrmLogs(param);
				}
				catch (SQLException e)
				{
					logger.error("이력 등록 실패");
				}
		
				return modelAndView;
			}
			else
			{
		    	jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
		    	jsHelper.RedirectUrl(invalidUrl);
		    }
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			jsHelper.RedirectUrl(invalidUrl);
		}
		
		return null;
	}
}
