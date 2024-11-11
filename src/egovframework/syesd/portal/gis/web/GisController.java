package egovframework.syesd.portal.gis.web;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.docx4j.docProps.variantTypes.Array;
import org.geotools.factory.CommonFactoryFinder;
import org.geotools.styling.*;
import org.geotools.styling.Style;
import org.geotools.styling.StyleFactory;
import org.geotools.styling.StyledLayerDescriptor;
import org.geotools.xml.styling.SLDParser;
import org.opengis.filter.FilterFactory;
import org.xml.sax.SAXException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.dataformat.xml.XmlMapper;

import egovframework.mango.config.SHDataStore;
import egovframework.mango.util.SHJsonHelper;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.syesd.admin.layer.service.AdminLayerService;
import egovframework.syesd.admin.table.service.AdminTableService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.file.service.FileService;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.syesd.cmmn.menu.service.MenuService;
import egovframework.syesd.cmmn.util.EgovProperties;
import egovframework.syesd.portal.gis.service.GisService;
import egovframework.zaol.common.service.CommonService;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;
import egovframework.zaol.gisinfo.service.GisBasicVO;
import egovframework.zaol.gisinfo.service.GisinfoService;
import net.sf.json.JSONArray;

@Controller
public class GisController extends BaseController {

	private static Logger logger = LogManager.getLogger(GisController.class);

	private ObjectMapper mapper;

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

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
	
	@Resource(name = "fileService")
	private FileService fileService;


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

	@RequestMapping(value=RequestMappingConstants.WEB_GIS,
					method = {RequestMethod.GET, RequestMethod.POST})
    public String dashboardMain(HttpServletRequest request,
								HttpServletResponse response,
								ModelMap model) throws SQLException, NullPointerException, IOException
    {
		logger.info("WEB_GIS>>>>>>"+request.getSession().getId());
    	response.setCharacterEncoding("UTF-8");

    	String referer = request.getHeader("referer");
    	if(referer != null && "".equals(referer) == false)
    	{
			URL url = new URL(referer);
			String host = url.getHost();

	    	HttpSession session = getSession();
	    	if(session != null)
	    	{
	    		CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
	            String userId = commonSessionVO.getUser_id();
	            String userAdmYn = commonSessionVO.getUser_admin_yn();
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

            	
            	HashMap<String, Object> param = new HashMap<String, Object>();
            	param.put("lcode", 39);
            	model.addAttribute("menu",menuService.selectLeftMenuInfo(param));
            	
            	//2024.08.22 마이데이터 공유기능 추가로 인해 추가
            	HashMap<String, Object> vo = new HashMap<String, Object>();
    	       	vo.put("KEY", RequestMappingConstants.KEY);
            	JSONArray jsonArray = new JSONArray();
            	model.addAttribute("shareUserList", jsonArray.fromObject(commonservice.selectUserShare(vo)));
            	
            	return "portal/content.jsp";
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

	@RequestMapping(value=RequestMappingConstants.WEB_GIS_DATA_GEOMETRY,
			method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisDataGeometryList(HttpServletRequest request,
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

				List dataList = null;

				if("SITE".equals(search_type) == true) {
					dataList = gisService.selectTableBuildLandSiteGeometry(conditions);
				}
				if("LICENS".equals(search_type) == true) {
					dataList = gisService.selectTableBuildLandLicensGeometry(conditions);
				}
				if("UNSALE_PAPR".equals(search_type) == true) {
					dataList = gisService.selectTableBuildLandUnSalePaprGeometry(conditions);
				}
				if("REMNDR_PAPR".equals(search_type) == true) {
					dataList = gisService.selectTableBuildLandRemndrPaprGeometry(conditions);
				}
				if("APT".equals(search_type) == true) {
					dataList = gisService.selectTableRentalAptGeometry(conditions);
				}
				if("MLTDWL".equals(search_type) == true) {
					dataList = gisService.selectTableRentalMltdwlGeometry(conditions);
				}
				if("CTY_LVLH".equals(search_type) == true) {
					dataList = gisService.selectTableRentalCtyLvlhGeometry(conditions);
				}
				if("LFSTS_RENT".equals(search_type) == true) {
					dataList = gisService.selectTableRentalLfstsGeometry(conditions);
				}
				if("LNGTR_SAFETY".equals(search_type) == true) {
					dataList = gisService.selectTableRentalLngtrSafetyGeometry(conditions);
				}
				if("ASSET_APT".equals(search_type) == true) {
					dataList = gisService.selectTableAssetAptGeometry(conditions);
				}
				if("ASSET_MLTDWL".equals(search_type) == true) {
					dataList = gisService.selectTableAssetMltdwlGeometry(conditions);
				}
				if("ASSET_ETC".equals(search_type) == true) {
					dataList = gisService.selectTableAssetEtcGeometry(conditions);
				}


				ModelAndView modelAndView = new ModelAndView();
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


	@RequestMapping(value=RequestMappingConstants.WEB_GIS_LAYER_LIST,
					method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView gisLayerList(HttpServletRequest request,
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

	            HashMap<String, Object> query = new HashMap<String, Object>();
	            query.put("KEY", RequestMappingConstants.KEY);
				query.put("USER_ID", userId);
				query.put("LAYER_NM", layerNm);

				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("headEngInfo", Arrays.asList(new String[]{ "layer_no", "no", "grp_nm", "grp_path", "layer_nm", "layer_tp_nm", "layer_desc"}));
				modelAndView.addObject("headKorInfo", Arrays.asList(new String[]{ "HIDDEN", "순서", "구분", "경로", "레이어한글명", "레이어영문명", "설명"}));
				//기존modelAndView.addObject("layerInfo", gisService.selectLayerDescList(query));
				modelAndView.addObject("layerInfo", gisService.selectLayerAuthList(query));
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
	
	@RequestMapping(value=RequestMappingConstants.WEB_GIS_EX_LAYER_LIST,
					method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView gisExLayerList(HttpServletRequest request,
									HttpServletResponse response,
									@RequestParam(value="layerNm",   required=false) String  layerNm,
									@RequestParam(value = "layerOpt", required = false) String layerOpt,
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

	            HashMap<String, Object> query = new HashMap<String, Object>();
	            query.put("KEY", RequestMappingConstants.KEY);
				query.put("USER_ID", userId);
				query.put("LAYER_NM", layerNm);

				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("headEngInfo", Arrays.asList(new String[]{ "layer_no", "no", "grp_nm", "grp_path", "layer_nm", "layer_tp_nm", "layer_desc"}));
				modelAndView.addObject("headKorInfo", Arrays.asList(new String[]{ "HIDDEN", "순서", "구분", "경로", "레이어한글명", "레이어영문명", "설명"}));
				//기존modelAndView.addObject("layerInfo", gisService.selectLayerDescList(query));
				List layerList = gisService.selectLayerAuthList(query);
				if (layerOpt != null) {
					List layerListEx = gisService.selectExLayerAuthList(query);
					layerList.addAll(layerListEx);
				}
				//List layerListEx = gisService.selectExLayerAuthList(query);
				//layerList.addAll(layerListEx);
				modelAndView.addObject("layerInfo", layerList);
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

	@RequestMapping(value=RequestMappingConstants.WEB_GIS_LAYER_SEARCH_FEATURES, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisLayerSearchFeatures(HttpServletRequest request,
			HttpServletResponse response,
			@RequestParam(value="layerNm", required=false) String  layerNm,
			@RequestParam(value="fieldNm", required=false) String  fieldNm,
			@RequestParam(value="searchTxt", required=false) String  searchTxt,
			ModelMap model) throws SQLException, NullPointerException, IOException {
		try {
			String jsonStr = SHDataStore.getSearchedFeatures(layerNm, fieldNm, searchTxt);
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.addObject("result", jsonStr);
			modelAndView.setViewName("jsonView");
			return modelAndView;
		} catch(NullPointerException e) {
			logger.info("오류입니다.");
			return null;
		}
	}

	@RequestMapping(value=RequestMappingConstants.WEB_GIS_LAYER_SEARCH_MY_DATA, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisLayerSearchMyData(HttpServletRequest request,
			HttpServletResponse response,
			@RequestParam(value="mainTitle", required=false) String  mainTitle,
			ModelMap model) throws SQLException, NullPointerException, IOException {

  	response.setCharacterEncoding("UTF-8");
  	request.setCharacterEncoding("UTF-8");

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
    	HttpSession session = getSession();
    	if(session != null) {
    		CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
        String userId = commonSessionVO.getUser_id();
        String userAdmYn = commonSessionVO.getUser_admin_yn();

        HashMap<String, Object> query = new HashMap<String, Object>();
        query.put("MAIN_TITLE", mainTitle);

				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("layerInfo", gisService.selectLayerMyDataList(query));
				
				modelAndView.addObject("result", "Y");
				modelAndView.setViewName("jsonView");

      	/* 이력 */
      	try {
        	HashMap<String, Object> param = new HashMap<String, Object>();
        	param.put("KEY", RequestMappingConstants.KEY);
       		param.put("PREFIX", "LOG");
        	param.put("USER_ID", userId);
        	param.put("PROGRM_URL", request.getRequestURI());

      		/* 프로그램 사용 이력 등록 */
  				logsService.insertUserProgrmLogs(param);
  			} catch (SQLException e) {
  				logger.error("이력 등록 실패");
  			}

				return modelAndView;
    	} else {
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

	@RequestMapping(value=RequestMappingConstants.WEB_GIS_LAYER_SEARCH_MY_DATA_COLUMN_INFO, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisLayerSearchMyDataField(HttpServletRequest request,
			HttpServletResponse response,
			@RequestParam(value="tableCatalog", required=false) String  tableCatalog,
			@RequestParam(value="tableName", required=false) String  tableName,
			ModelMap model) throws SQLException, NullPointerException, IOException {

  	response.setCharacterEncoding("UTF-8");
  	request.setCharacterEncoding("UTF-8");

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
    	HttpSession session = getSession();
    	if(session != null) {
    		CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
        String userId = commonSessionVO.getUser_id();
        String userAdmYn = commonSessionVO.getUser_admin_yn();

        HashMap<String, Object> query = new HashMap<String, Object>();
        query.put("TABLE_CATALOG", tableCatalog);
        query.put("TABLE_NAME", tableName);

				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("columnListInfo", gisService.selectLayerMyDataCommentList(query));
				
				modelAndView.addObject("result", "Y");
				modelAndView.setViewName("jsonView");

      	/* 이력 */
      	try {
        	HashMap<String, Object> param = new HashMap<String, Object>();
        	param.put("KEY", RequestMappingConstants.KEY);
       		param.put("PREFIX", "LOG");
        	param.put("USER_ID", userId);
        	param.put("PROGRM_URL", request.getRequestURI());

      		/* 프로그램 사용 이력 등록 */
  				logsService.insertUserProgrmLogs(param);
  			} catch (SQLException e) {
  				logger.error("이력 등록 실패");
  			}

				return modelAndView;
    	} else {
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

	@RequestMapping(value=RequestMappingConstants.WEB_GIS_LAYER_DESC,
					method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisLayerDesc(HttpServletRequest request,
									HttpServletResponse response,
									@RequestParam(value="layerNo",   required=false) String  layerNo,
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
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
				String userId = commonSessionVO.getUser_id();
				String userAdmYn = commonSessionVO.getUser_admin_yn();

		        HashMap<String, Object> query = new HashMap<String, Object>();
				query.put("LAYER_NO", layerNo);

				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("descInfo", gisService.selectLayerDesc(query));
				modelAndView.addObject("descEditEable", "Y".equals(userAdmYn) == true ? "Y" : "N");
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
	
	@RequestMapping(value = {RequestMappingConstants.WEB_GIS_LAYER_DESC_ADD},
			method = {RequestMethod.POST})
	public ModelAndView gisLayerDescAdd(HttpServletRequest request,
			   	   	  		      HttpServletResponse response,
			   	   	  		      @RequestParam(value="edit_desc_layer_no",  required=true) String layer_no,
			   	   	  		      ModelMap model) throws SQLException, NullPointerException, IOException{
		response.setCharacterEncoding("UTF-8");

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			URL url = new URL(referer);
			String host = url.getHost();

			HttpSession session = getSession();
			if(session != null)
			{
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
				String userId = commonSessionVO.getUser_id();
				String userAdmYn = commonSessionVO.getUser_admin_yn();

				if("Y".equals(userAdmYn) == true && "".equals(userId) == false)
				{
					if("".equals(layer_no) == false)
					{
						Map data = getParameterMap(request);
						Map editdata = new HashMap<String, Object>();
						Iterator<String> keys = data.keySet().iterator();
				        while( keys.hasNext() ){
				            String key = keys.next();
				            if(key.equals("EDIT_DESC_LAYER_NO"))
				            	editdata.put("DESC_LAYER_NO", data.get(key));
				            
				            if(key.equals("EDIT_DESC_DATA_DESC"))
				            	editdata.put("DESC_DATA_DESC", data.get(key));
				            
				            if(key.equals("EDIT_DESC_DATA_ORIGIN"))
				            	editdata.put("DESC_DATA_ORIGIN", data.get(key));
				            
				            if(key.equals("EDIT_DESC_NO"))
				            	editdata.put("DESC_NO", data.get(key));
				            
				            if(key.equals("EDIT_DESC_DATA_STDDE"))
				            	editdata.put("DESC_DATA_STDDE", data.get(key));
				            
				            if(key.equals("EDIT_DESC_DATA_NM"))
				            	editdata.put("DESC_DATA_NM", data.get(key));
				            
				            if(key.equals("EDIT_DESC_DATA_RM"))
				            	editdata.put("DESC_DATA_RM", data.get(key));
				            
				            if(key.equals("EDIT_DESC_DATA_UPD_CYCLE"))
				            	editdata.put("DESC_DATA_UPD_CYCLE", data.get(key));
				            
				            logger.info( String.format("키 : %s, 값 : %s", key, data.get(key)) );
				        }
				        
					   	/* 컨텐츠 */
					   	HashMap<String, Object> query = new HashMap<String, Object>();
					   	query.put("KEY", RequestMappingConstants.KEY);
					   	query.put("INS_USER", userId);
					   	//query.put("PREFIX", "DESC");
					   	query.put("PREFIX", data.get("EDIT_DESC_LAYER_NO"));
					   	query.put("DESC_DATA", editdata);

					   	ModelAndView modelAndView = new ModelAndView();
					   	modelAndView.addObject("layerDesc", adminLayerService.insertLayerDesc(query));
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
						jsHelper.Alert("입력된 정보가 옳바르지 않습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
						jsHelper.RedirectUrl(invalidUrl);
					}
				}
				else
				{
					jsHelper.Alert("권한이 없습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
					jsHelper.RedirectUrl(invalidUrl);
				}
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
	
	
    @RequestMapping(value = {RequestMappingConstants.WEB_GIS_LAYER_DESC_EDIT},
					 method = {RequestMethod.POST})
	public ModelAndView gisLayerDescEditByNo(HttpServletRequest request,
		   	   	  			  				HttpServletResponse response,
		   	   	  			  				@RequestParam(value="edit_desc_no",  required=true) String desc_no,
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
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
				String userId = commonSessionVO.getUser_id();
				String userAdmYn = commonSessionVO.getUser_admin_yn();

				if("Y".equals(userAdmYn) == true && "".equals(userId) == false)
				{
					Map data = getParameterMap(request);
					data.put("DESC_LAYER_NO", 		data.get("EDIT_DESC_LAYER_NO"));
					data.put("DESC_DATA_NM", 		data.get("EDIT_DESC_DATA_NM"));
					data.put("DESC_DATA_DESC", 		data.get("EDIT_DESC_DATA_DESC"));
					data.put("DESC_DATA_ORIGIN", 	data.get("EDIT_DESC_DATA_ORIGIN"));
					data.put("DESC_DATA_STDDE", 	data.get("EDIT_DESC_DATA_STDDE"));
					data.put("DESC_DATA_RM", 		data.get("EDIT_DESC_DATA_RM"));
					data.put("DESC_DATA_UPD_CYCLE", data.get("EDIT_DESC_DATA_UPD_CYCLE"));

				   	/* 컨텐츠 */
				   	HashMap<String, Object> query = new HashMap<String, Object>();
				   	query.put("KEY", RequestMappingConstants.KEY);
				   	query.put("INS_USER", userId);
				   	query.put("PREFIX", "LOG");
				   	query.put("DESC_NO", desc_no);
				   	query.put("DESC_DATA", data);

				   	ModelAndView modelAndView = new ModelAndView();
				   	modelAndView.addObject("layerDesc", adminLayerService.insertLayerDescByNo(query));
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
		    		jsHelper.Alert("권한이 없습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
		    		jsHelper.RedirectUrl(invalidUrl);
		        }
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

	@RequestMapping(value=RequestMappingConstants.WEB_GIS_LAYER_BY_AUTH,
					method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView gisLayerByAuth(HttpServletRequest request,
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

	            HashMap<String, Object> query = new HashMap<String, Object>();
	            query.put("KEY", RequestMappingConstants.KEY);
				query.put("USER_ID", userId);

				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("layerInfo", gisService.selectLayerAuthList(query));
				//modelAndView.addObject("layerInfo", gisService.selectExLayerAuthList(query));  연계레이어 목록 불러오는 service,,,,,
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

	@RequestMapping(value=RequestMappingConstants.WEB_GIS_LAYER_ADDITIONAL,
					method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisLayerAdditionalByNo(HttpServletRequest request,
												HttpServletResponse response,
												@RequestParam(value="layer_no",   required=false) String  layerNo,
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

				HashMap<String, Object> query = new HashMap<String, Object>();
				query.put("LAYER_NO", layerNo);

				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("layerInfo", gisService.selectLayerAdditionalByNo(query));
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

	@RequestMapping(value=RequestMappingConstants.WEB_GIS_LAYER_STYLE,
					method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisLayerStyle(HttpServletRequest request,
								HttpServletResponse response,
								@RequestParam(value="style",   required=false) String  style,
								@RequestParam(value="workspaces",   required=false) String  workspaces,
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

		        List<String> data = new ArrayList<String>();
		       // String geoserverDataDir = System.getenv("GEOSERVER_DATA_DIR");
		       // String geoserverDataDir = "C:" + File.separator + "WorkSpace" + File.separator + "eGovFrameDev-3.9.0-64bit" + File.separator + "bin" + File.separator + "geoserver-2.17.3-bin" + File.separator + "data_dir";
		        //String fileNm = System.getProperty("GEOSERVER_DATA_DIR") + File.separator + "workspaces" + File.separator + workspaces + File.separator + "styles" + File.separator + style + ".sld";
		        
		        //운영서버
		        //String geoserverDataDir = "C:\\SH2024\\data\\geoserver_ad";
		        
		      //  String geoserverDataDir = EgovProperties.getProperty("g.geoserverDataDir");
		        //geoserverDataDir = geoserverDataDir.replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
		        //String fileNm = geoserverDataDir + File.separator + "workspaces" + File.separator + workspaces + File.separator + "styles" + File.separator + style + ".sld";
		        //fileNm = fileNm.replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
		       // logger.info("@@@@@@@@@@@@@@@@@@@범례@@@@@@@@@@@@@@@@@@@@"+fileNm);
		        
		        String geoserverDataDir = EgovProperties.getProperty("g.geoserverDataDir");
		        
		        if (geoserverDataDir != null && !"".equals(geoserverDataDir))
		        {
			        // 수정 : 외부 입력값 필터링
		        	String fileNm = geoserverDataDir + File.separator + "workspaces" + File.separator + workspaces + File.separator + "styles" + File.separator + style + ".sld";
			        fileNm = fileNm.replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(">", "");
			        File sldFile = new File(fileNm); 
		
			        //File sldFile = new File(fileNm);
			        StyleFactory styleFactory = CommonFactoryFinder.getStyleFactory();
	
			        SLDParser stylereader = new SLDParser(styleFactory, sldFile);
			        
			        StyledLayerDescriptor sld = stylereader.parseSLD();
			        for (StyledLayer styledLayer : sld.getStyledLayers()) {
		                if (styledLayer instanceof NamedLayer) {
		                    NamedLayer namedLayer = (NamedLayer) styledLayer;
		                    for (Style namedLayerStyle : namedLayer.getStyles()) {
		                        for (FeatureTypeStyle featureTypeStyle : namedLayerStyle.featureTypeStyles()) {
		                            for (Rule rule : featureTypeStyle.rules()) {
		                                // Rule의 Description에서 Title을 가져옴
		                                Description description = rule.getDescription();
		                                if (description != null && description.getTitle() != null) {
		                                	logger.info("Rule Title: " + description.getTitle().toString());
		                                    data.add(description.getTitle().toString());
		                                } else {
		                                    /*description.get
		                                    data.add(description.getName().toString());*/
		                                    String ruleName = rule.getName();
		                                    logger.info("Rule Name: " + ruleName);
	                                        data.add(ruleName.toString());
		                                }
		                            }
		                        }
		                    }
		                }
		            }
		        } 
				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("styleInfo", data);
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

	@RequestMapping(value=RequestMappingConstants.WEB_GIS_LAYER_HEAD_INFO,
			method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisLayerHeadInfo(HttpServletRequest request,
									HttpServletResponse response,
									@RequestParam(value="table_space",   required=false) String  tableSpace,
									@RequestParam(value="table_nm",   required=false) String  tableNm,
									@RequestParam(value="layer_tp_nm",   required=false) String  layerTpNm,
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

		        HashMap<String, Object> query = new HashMap<String, Object>();
	            query.put("KEY", RequestMappingConstants.KEY);
				query.put("USER_ID", userId);
				query.put("TABLE_SPACE", tableSpace.toUpperCase());
				query.put("TABLE_NM", tableNm.toUpperCase());
				query.put("LAYER_TP_NM", layerTpNm.toUpperCase());


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
				modelAndView.addObject("tablePkInfo", gisService.selectTablePkColumn(query));
				modelAndView.addObject("tableEditInfo", gisService.selectTableAttrEditAuth(query));
				modelAndView.addObject("headEngInfo", headEngList);
				modelAndView.addObject("headKorInfo", headKorList);
				modelAndView.addObject("geometryInfo", gisService.selectTableGeomTypeInfo(query));
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

	@RequestMapping(value=RequestMappingConstants.WEB_GIS_LAYER_CNTC_HEAD_INFO,
			method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisLayerCntcHeadInfo(HttpServletRequest request,
									HttpServletResponse response,
									@RequestParam(value="layer_no",   required=false) String  layerNo,
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

		        HashMap<String, Object> query = new HashMap<String, Object>();
	            query.put("KEY", RequestMappingConstants.KEY);
				query.put("USER_ID", userId);
				query.put("LAYER_NO", layerNo);

				List headList = null;
				List<String> headEngList = new ArrayList<String>();
				List<String> headKorList = new ArrayList<String>();

				headList = gisService.selectCntcColumnCommentList(query);
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
				modelAndView.addObject("tablePkInfo", "");
				modelAndView.addObject("tableEditInfo", "N");
				modelAndView.addObject("headEngInfo", headEngList);
				modelAndView.addObject("headKorInfo", headKorList);
				modelAndView.addObject("geometryInfo", "");
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

	@RequestMapping(value=RequestMappingConstants.WEB_GIS_LAYER_BY_APIKEY,
					method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisLayerByApikey(HttpServletRequest request,
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
				// 파라메터 리셋
				session.setAttribute("apiParam", "");

				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
	            String userId = commonSessionVO.getUser_id();
	            String userAdmYn = commonSessionVO.getUser_admin_yn();

		        HashMap<String, Object> query = new HashMap<String, Object>();
				query.put("API_KEY", (String) session.getAttribute("apiKey"));

				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("layerInfo", gisService.selectLayerByApikey(query));
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

	@RequestMapping(value=RequestMappingConstants.WEB_GIS_GEOCODING_EPSG_LIST,
					method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView gisGeocodingEpsgList(HttpServletRequest request,
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

				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("epsgInfo", gisService.selectGeocoingEpsgList());
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

	@RequestMapping(value=RequestMappingConstants.WEB_GIS_SHAPEUPLOAD_EPSG_LIST,
					method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView gisShapeUploadEpsgList(HttpServletRequest request,
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

				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("epsgInfo", gisService.selectShapeUploadEpsgList());
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
	
	//레이어 컬럼 추출 2024.09.10 LEK 연계용
	@RequestMapping(value="/web/cmmn/gisLayerColumnInfo.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView gisLayerColoumnInfo(HttpServletRequest request,
							HttpServletResponse response,
							@RequestParam(value="table_space",   required=false) String  tableSpace,
							@RequestParam(value="table_nm",   required=false) String  tableNm,
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

		        HashMap<String, Object> query = new HashMap<String, Object>();
	            query.put("KEY", RequestMappingConstants.KEY);
				query.put("USER_ID", userId);
				query.put("TABLE_SPACE", tableSpace.toUpperCase());
				query.put("TABLE_NM", tableNm.toUpperCase());

				List headList = null;
				List<String> headEngList = new ArrayList<String>();
				List<String> headKorList = new ArrayList<String>();

				headList = gisService.selectColumnCommentList(query);
				
				if(headList.size() == 0) {
					headList = gisService.selectViewColumnCommentList(query);
				}
				
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
				modelAndView.addObject("headEngInfo", headEngList); //물리명
				modelAndView.addObject("headKorInfo", headKorList);	//논리명
				modelAndView.addObject("allInfo", headList);	//전체 컬럼 정보
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
	
	 @RequestMapping(value="/web/cmmn/dataExport.do", method = {RequestMethod.GET, RequestMethod.POST})
	 public void dataExport (HttpServletRequest request, HttpServletResponse response, ModelMap model
			,@RequestParam(value="format",  required=true) String format		
    		,@RequestParam(value="layerList",  required=true) String layerList
    		,@RequestParam(value="geom",  required=true) String geom
    		,@RequestParam(value="exportType",  required=true) String type
    		,@RequestParam(value="areaPer",  required=false) String areaPer) throws SQLException, NullPointerException, IOException, InterruptedException{
		 	
		 HttpSession session = getSession();
			String userS_id = null;
		   	if(session != null){
		   		userS_id = (String)session.getAttribute("userId");
		   	}
		   	
		   	if( userS_id != null ){
		   		HashMap<String, Object> map = new HashMap<String, Object>();
		   		//{"cmd.exe", "/c", "D:\\sh_local\\load_tiger.bat", "TEST_LAND_EXPORT_4326_.zip" , "landsys_usr", "test8", "0" , "4326", "2024\8\"}
		   		
		   		//파일포맷[SHP | CSV] 압축파일명 스키마 테이블 변환EPSG 도형 도형EPSG 모드
		   		//String [] commands = {"cmd.exe", "/c", "D:\\sh_local\\export_tiger.bat", format , layerList, "4326", geom , "4326", type}; 
		   		
		   		List list = new ArrayList<>();
		   		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		   		InputStream in = null;
		   		try {
				     
		   			if(layerList.indexOf(",") == -1) {
		   				int _idx = layerList.indexOf(".");
		   				String schema = layerList.substring(0, _idx);
		   				String tableNm = layerList.substring(_idx+1);
		   				
		   				userS_id = userS_id.replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
		   				tableNm = tableNm.replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
		   				type = type.replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
		   				
		   				//String fileNm = userS_id+"_"+tableNm+"_"+type;
		   				String fileNm = tableNm+"_"+type;
		   				fileNm = fileNm.replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
		   				
		   				Map<String, Object> mapReceiver = new HashMap<String, Object>();
			   			mapReceiver.put("file_name",fileNm);
			   			mapReceiver.put("FILE_NAME",fileNm+".zip");
			   			mapReceiver.put("SAVE_NAME",RequestMappingConstants.TOMCAT_PATH + RequestMappingConstants.TEMPORARY_FOLDER+fileNm+".zip");
			   			list.add(mapReceiver);
			   			
			   			String bathFile = "";
			   			if("local".equals(EgovProperties.active)) {
			   				bathFile = "D:\\sh_local\\export_tiger.bat";
			   			}else if("dev".equals(EgovProperties.active)) {
			   				bathFile = "D:\\sh_local\\export_tiger.bat";
			   			}else if("prod".equals(EgovProperties.active)) {
			   				bathFile = "C:\\SH2024\\Tomcat9_9.0.96\\sh_local\\export_tiger.bat";
			   			}
			   			//String bathFile = EgovProperties.getProperty("g.export.bat");
					    //bathFile = bathFile.replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
					    
			   			String [] commands = null;
		   				if("intersects".equals(type)) {
		   					//commands = new String[]{"cmd.exe", "/c", "D:\\sh_local\\export_tiger.bat", format , fileNm, schema, tableNm, "4326", geom , "4326", type, areaPer};
		   					//commands = new String[]{"cmd.exe", "/c", "C:\\SH2024\\Tomcat8_8.5.57\\sh_local\\export_tiger.bat", format , fileNm, schema, tableNm, "4326", geom , "4326", type, areaPer}; 
		   					
		   					commands = new String[]{"cmd.exe", "/c", bathFile, format , fileNm, schema, tableNm, "4326", geom , "3857", type, areaPer};
		   				}else {
		   					//commands = new String[]{"cmd.exe", "/c", "D:\\sh_local\\export_tiger.bat", format , fileNm, schema, tableNm, "4326", geom , "4326", type}; 
		   					//commands = new String[]{"cmd.exe", "/c", "C:\\SH2024\\Tomcat8_8.5.57\\sh_local\\export_tiger.bat", format , fileNm, schema, tableNm, "4326", geom , "4326", type};
		   					
		   					commands = new String[]{"cmd.exe", "/c", bathFile, format , fileNm, schema, tableNm, "4326", geom , "3857", type};
		   				}
		   				
		   				Process p = Runtime.getRuntime().exec(commands);
					    p.waitFor();
					    in = p.getInputStream();
					    int c = -1;
					    
					    try
					    {
					    	while((c = in.read()) != -1)
						    {
						        baos.write(c);
						    }
					    }
				        catch( IOException e)
					    {
				        	logger.error("오류입니다.");
					    }
					    finally {
					    	// 수정 
					    	in.close();
							baos.flush();
						    baos.close();
					    }
					}else {
						String[] layerArr = layerList.split(",");
						
			   			for (int i = 0; i  < layerArr.length; i++) {
			   				int _idx = layerArr[i].indexOf(".");
			   				String schema = layerArr[i].substring(0, _idx);
			   				String tableNm = layerArr[i].substring(_idx+1);
			   				
			   				//String fileNm = userS_id+"_"+tableNm+"_"+i+"_"+type;
			   				String fileNm = tableNm+"_"+i+"_"+type;
			   				Map<String, Object> mapReceiver = new HashMap<String, Object>();
				   			mapReceiver.put("file_name",fileNm);
				   			mapReceiver.put("FILE_NAME",fileNm+".zip");
				   			mapReceiver.put("SAVE_NAME",RequestMappingConstants.TOMCAT_PATH + RequestMappingConstants.TEMPORARY_FOLDER+fileNm+".zip");
				   			list.add(mapReceiver);
			   				
				   			String bathFile = "";
				   			if("local".equals(EgovProperties.active)) {
				   				bathFile = "D:\\sh_local\\export_tiger.bat";
				   			}else if("dev".equals(EgovProperties.active)) {
				   				bathFile = "D:\\sh_local\\export_tiger.bat";
				   			}else if("prod".equals(EgovProperties.active)) {
				   				bathFile = "C:\\SH2024\\Tomcat9_9.0.96\\sh_local\\export_tiger.bat";
				   			}
				   			
				   			//String bathFile = EgovProperties.getProperty("g.export.bat");
						    //bathFile = bathFile.replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
						     
			   				String [] commands = null;
			   				if("intersects".equals(type)) {
			   					//commands = new String[]{"cmd.exe", "/c", "D:\\sh_local\\export_tiger.bat", format , fileNm, schema, tableNm, "4326", geom , "4326", type, areaPer}; 
			   					//commands = new String[]{"cmd.exe", "/c", "C:\\SH2024\\Tomcat8_8.5.57\\sh_local\\export_tiger.bat", format , fileNm, schema, tableNm, "4326", geom , "4326", type, areaPer};
			   					
			   					commands = new String[]{"cmd.exe", "/c", bathFile, format , fileNm, schema, tableNm, "4326", geom , "3857", type, areaPer};
			   				}else {
			   					//commands = new String[]{"cmd.exe", "/c", "D:\\sh_local\\export_tiger.bat", format , fileNm, schema, tableNm, "4326", geom , "4326", type}; 
			   					//commands = new String[]{"cmd.exe", "/c", "C:\\SH2024\\Tomcat8_8.5.57\\sh_local\\export_tiger.bat", format , fileNm, schema, tableNm, "4326", geom , "4326", type};
			   					
			   					commands = new String[]{"cmd.exe", "/c", bathFile, format , fileNm, schema, tableNm, "4326", geom , "3857", type};
			   				}
			   				
			   				Process p = Runtime.getRuntime().exec(commands);
						    p.waitFor();
						    in = p.getInputStream();
						    int c = -1;
						    try {
						    	while((c = in.read()) != -1)
							    {
							        baos.write(c);
							    }
						    	/*String responseBat = new String(baos.toByteArray());
							    logger.info("Response From Exe : "+responseBat);*/
						    }catch(IOException e) {
						    	logger.error("에러입니다.");
						    }finally {
						    	in.close();
								baos.flush();
							    baos.close();
						    }
			   			}
			   			
					}
		   		 fileService.dataExportDownload(request, response,list);// 데이터 다운로드
			    
			     // 결과 반환
				/*ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("msg", "데이터 추출이 완료되었습니다.");
				modelAndView.setViewName("jsonView");
				return modelAndView;*/
				   
		   		 //return null;
				} catch (SQLException e) {
				    logger.info("오류입니다.");
				}finally {
					in.close();
					baos.flush();
					baos.close();
			    } 
		   		
	       }else{
		       	jsHelper.Alert("비정상적인 접근 입니다.");
		       	jsHelper.RedirectUrl(invalidUrl);
		       }
		   	
		   	//return null;
	 }
}
