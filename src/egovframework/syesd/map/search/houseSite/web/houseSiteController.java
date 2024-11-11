package egovframework.syesd.map.search.houseSite.web;

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
public class houseSiteController extends BaseController {
	private static Logger logger = LogManager.getLogger(houseSiteController.class);
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
    
    @RequestMapping(value="/search/houseSite.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String searchHouseSite (HttpServletRequest request, HttpServletResponse response, ModelMap model, @ModelAttribute("gisvo") GisBasicVO gisvo) throws SQLException, NullPointerException, IOException
	{
		
		HttpSession session = getSession();
		String userS_id = null;
	   	if(session != null){
	   		userS_id = (String)session.getAttribute("userId");
	   	}

       if( userS_id != null ){

       	List SIGList = gisinfoService.sig_list(gisvo);
       //	List GISCodeList = gisinfoService.gis_code_list(gisvo);

       	model.addAttribute("SIGList", SIGList);
       	//model.addAttribute("GISCodeList", GISCodeList); 사용x

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

       	return "map/search/houseSite.sub";

       }else{
       	jsHelper.Alert("비정상적인 접근 입니다.");
       	jsHelper.RedirectUrl(invalidUrl);
       }
       return null;
	}
    								
    @RequestMapping(value=RequestMappingConstants.WEB_GIS_DATA_BUILD_LAND, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisBuildLandList(HttpServletRequest request,
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
		
				if("SITE".equals(search_type) == true) {
					dataList = gisService.selectBuildLandSiteDataList(query);
		
					//query.clear();
					query.put("TABLE_SPACE", "LANDSYS_GIS");
					query.put("TABLE_NM", "tb_land");
		
					query.put("LAYER_TP_NM", "tg_land_manage");
					modelAndView.addObject("geometryInfo", gisService.selectTableGeomTypeInfo(query));
					modelAndView.addObject("tableSpace", "LANDSYS_GIS");
					modelAndView.addObject("tableNm", "tb_land");
				}
				if("LICENS".equals(search_type) == true) {
					dataList = gisService.selectBuildLandLicensList(query);
		
					//query.clear();
					query.put("TABLE_SPACE", "LANDSYS_GIS");
					query.put("TABLE_NM", "tb_cnfm_prmisn");
		
					query.put("LAYER_TP_NM", "tg_cnfm_prmisn_manage");
					modelAndView.addObject("geometryInfo", gisService.selectTableGeomTypeInfo(query));
					modelAndView.addObject("tableSpace", "LANDSYS_GIS");
					modelAndView.addObject("tableNm", "tb_cnfm_prmisn");
				}
				if("UNSALE_PAPR".equals(search_type) == true) {
					dataList = gisService.selectBuildLandUnSalePaprList(query);
		
					//query.clear();
					query.put("TABLE_SPACE", "LANDSYS_GIS");
					query.put("TABLE_NM", "tb_un_sale_area");
		
					query.put("LAYER_TP_NM", "tg_un_sale_area");
					modelAndView.addObject("geometryInfo", gisService.selectTableGeomTypeInfo(query));
					modelAndView.addObject("tableSpace", "LANDSYS_GIS");
					modelAndView.addObject("tableNm", "tb_un_sale_area");
				}
				if("REMNDR_PAPR".equals(search_type) == true) {
					dataList = gisService.selectBuildLandRemndrPaprList(query);
		
					//query.clear();
					query.put("TABLE_SPACE", "LANDSYS_GIS");
					query.put("TABLE_NM", "tb_remndr_area");
		
					query.put("LAYER_TP_NM", "tg_remndr_area_manage");
					modelAndView.addObject("geometryInfo", gisService.selectTableGeomTypeInfo(query));
					modelAndView.addObject("tableSpace", "LANDSYS_GIS");
					modelAndView.addObject("tableNm", "tb_remndr_area");
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
    
    @RequestMapping(value = RequestMappingConstants.WEB_GIS_DATA_SITE_COND, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisBuildLandSiteCondtion(HttpServletRequest request,
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
				modelAndView.addObject("prposBsnsNmInfo", gisService.selectSiteBsnsNm());
				modelAndView.addObject("prposNmInfo", gisService.selectSitePrposNm());
				modelAndView.addObject("sttusInfo", gisService.selectSiteSttus());
				modelAndView.addObject("spfcInfo", gisService.selectSiteSpfc());
				modelAndView.addObject("lndcgrInfo", gisService.selectSiteLndcgr());
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
    
    @RequestMapping(value = RequestMappingConstants.WEB_GIS_DATA_LICENS_COND, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisBuildLandLicensCondtion(HttpServletRequest request,
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
				modelAndView.addObject("prposBsnsNmInfo", gisService.selectLicensBsnsNm());
				modelAndView.addObject("suplyTyInfo", gisService.selectLicensSuplyTy());
				modelAndView.addObject("prposInfo", gisService.selectLicensPrpos());
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

    
	
    @RequestMapping(value = RequestMappingConstants.WEB_GIS_DATA_UNSALE_COND, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisBuildLandUnsaleCondtion(HttpServletRequest request,
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
				modelAndView.addObject("dstrcNmInfo", gisService.selectUnSalePaprDstrcNm());
				modelAndView.addObject("sleMthInfo", gisService.selectUnSalePaprSleMth());
				modelAndView.addObject("pcStdrInfo", gisService.selectUnSalePaprPcStdr());
				modelAndView.addObject("suplyTrgetStdrInfo", gisService.selectUnSalePaprSuplyTrgetStdr());
				modelAndView.addObject("spfcInfo", gisService.selectUnSalePaprSpfc());
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
    
    @RequestMapping(value = RequestMappingConstants.WEB_GIS_DATA_REMNDR_COND, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisBuildLandRemndrCondtion(HttpServletRequest request,
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
				modelAndView.addObject("cmptncGuInfo", gisService.selectRemndrPaprCmptncGu());
				modelAndView.addObject("lndcgrInfo", gisService.selectRemndrPaprLndcgr());
				modelAndView.addObject("cmptncCnterInfo", gisService.selectRemndrPaprCmptncCnter());
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

}
