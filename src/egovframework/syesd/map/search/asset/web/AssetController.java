package egovframework.syesd.map.search.asset.web;

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
public class AssetController extends BaseController {
	private static Logger logger = LogManager.getLogger(AssetController.class);
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
    
    @RequestMapping(value="/search/asset.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String searchAsset (HttpServletRequest request, HttpServletResponse response, ModelMap model, @ModelAttribute("gisvo") GisBasicVO gisvo) throws SQLException, NullPointerException, IOException
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

       	return "map/search/asset.sub";

       }else{
       	jsHelper.Alert("비정상적인 접근 입니다.");
       	jsHelper.RedirectUrl(invalidUrl);
       }
       return null;
	}
    
    @RequestMapping(value=RequestMappingConstants.WEB_GIS_DATA_ASSET, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisAssetList(HttpServletRequest request,
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

				if("ASSET_APT".equals(search_type) == true) {
					dataList = gisService.selectAssetApt(query);

					//query.clear();
					query.put("TABLE_SPACE", "LANDSYS_GIS");
					query.put("TABLE_NM", "tb_assets_regstr_apt");

					query.put("LAYER_TP_NM", "tg_assets_regstr_apt_manage");
					modelAndView.addObject("geometryInfo", gisService.selectTableGeomTypeInfo(query));
					modelAndView.addObject("tableSpace", "LANDSYS_GIS");
					modelAndView.addObject("tableNm", "tb_assets_regstr_apt");
				}
				if("ASSET_MLTDWL".equals(search_type) == true) {
					dataList = gisService.selectAssetMltdwl(query);

					//query.clear();
					query.put("TABLE_SPACE", "LANDSYS_GIS");
					query.put("TABLE_NM", "tb_assets_regstr_mltdwl");

					query.put("LAYER_TP_NM", "tg_assets_regstr_mltdwl_manage");
					modelAndView.addObject("geometryInfo", gisService.selectTableGeomTypeInfo(query));
					modelAndView.addObject("tableSpace", "LANDSYS_GIS");
					modelAndView.addObject("tableNm", "tb_assets_regstr_mltdwl");
				}
				if("ASSET_ETC".equals(search_type) == true) {
					dataList = gisService.selectAssetEtc(query);

					//query.clear();
					query.put("TABLE_SPACE", "LANDSYS_GIS");
					query.put("TABLE_NM", "tb_assets_regstr_etc");

					query.put("LAYER_TP_NM", "tg_assets_regstr_etc_eqb_manage");
					modelAndView.addObject("geometryInfo", gisService.selectTableGeomTypeInfo(query));
					modelAndView.addObject("tableSpace", "LANDSYS_GIS");
					modelAndView.addObject("tableNm", "tb_assets_regstr_etc");
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

    @RequestMapping(value=RequestMappingConstants.WEB_GIS_DATA_ASSET_APT_COND, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisAssetAptCondtion(HttpServletRequest request,
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
				modelAndView.addObject("assetsClassInfo", gisService.selectAssetAptAssetsClass());
				modelAndView.addObject("prdlstClassInfo", gisService.selectAssetAptPrdlstClass(null));
				modelAndView.addObject("bsnsCodeInfo", gisService.selectAssetAptBsnsCode());
				modelAndView.addObject("stndrdInfo", gisService.selectAssetAptStndrd());
				modelAndView.addObject("assetsChangeInfo", gisService.selectAssetAptAssetsChange());
				modelAndView.addObject("changeDcsnInfo", gisService.selectAssetAptChangeDcsn());
				modelAndView.addObject("acqsDeInfo", gisService.selectAssetAptAcqsDe());
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
    
    @RequestMapping(value=RequestMappingConstants.WEB_GIS_DATA_ASSET_APT_PRD, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisAssetAptPrdCondtion(HttpServletRequest request,
									HttpServletResponse response,
									@RequestParam(value="assets_cl",   required=false) String  assetsCl,
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
		        query.put("ASSETS_CL", assetsCl);
		
				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("prdlstClassInfo", gisService.selectAssetAptPrdlstClass(query));
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

    @RequestMapping(value=RequestMappingConstants.WEB_GIS_DATA_ASSET_MLT_COND, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisAssetMltCondtion(HttpServletRequest request,
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
				modelAndView.addObject("assetsClassInfo", gisService.selectAssetMltdwlAssetsClass());
				modelAndView.addObject("prdlstClassInfo", gisService.selectAssetMltdwlPrdlstClass(null));
				modelAndView.addObject("bsnsCodeInfo", gisService.selectAssetMltdwlBsnsCode());
				modelAndView.addObject("stndrdInfo", gisService.selectAssetMltdwlStndrd());
				modelAndView.addObject("assetsChangeInfo", gisService.selectAssetMltdwlAssetsChange());
				modelAndView.addObject("changeDcsnInfo", gisService.selectAssetMltdwlChangeDcsn());
				modelAndView.addObject("acqsDeInfo", gisService.selectAssetMltdwlAcqsDe());
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

    @RequestMapping(value=RequestMappingConstants.WEB_GIS_DATA_ASSET_MLT_PRD, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisAssetMltPrdCondtion(HttpServletRequest request,
									HttpServletResponse response,
									@RequestParam(value="assets_cl",   required=false) String  assetsCl,
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
		        query.put("ASSETS_CL", assetsCl);
	
				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("prdlstClassInfo", gisService.selectAssetMltdwlPrdlstClass(query));
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
	
    //자산대장 기타추가
  	@RequestMapping(value=RequestMappingConstants.WEB_GIS_DATA_ASSET_ETC_COND, method = {RequestMethod.GET, RequestMethod.POST})
  	public ModelAndView gisAssetEtcCondtion(HttpServletRequest request,
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
  				modelAndView.addObject("assetsClassInfo", gisService.selectAssetEtcAssetsClass());
  				modelAndView.addObject("prdlstClassInfo", gisService.selectAssetEtcPrdlstClass(null));
  				modelAndView.addObject("bsnsCodeInfo", gisService.selectAssetEtcBsnsCode());
  				modelAndView.addObject("stndrdInfo", gisService.selectAssetEtcStndrd());
  				modelAndView.addObject("assetsChangeInfo", gisService.selectAssetEtcAssetsChange());
  				modelAndView.addObject("changeDcsnInfo", gisService.selectAssetEtcChangeDcsn());
  				modelAndView.addObject("acqsDeInfo", gisService.selectAssetEtcAcqsDe());
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

  	@RequestMapping(value=RequestMappingConstants.WEB_GIS_DATA_ASSET_ETC_PRD, method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisAssetEtcPrdCondtion(HttpServletRequest request,
									HttpServletResponse response,
									@RequestParam(value="assets_cl",   required=false) String  assetsCl,
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
		        query.put("ASSETS_CL", assetsCl);
		
				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("prdlstClassInfo", gisService.selectAssetEtcPrdlstClass(query));
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
