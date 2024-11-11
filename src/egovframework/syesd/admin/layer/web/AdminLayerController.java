package egovframework.syesd.admin.layer.web;

import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.syesd.admin.code.service.AdminCodeService;
import egovframework.syesd.admin.layer.service.AdminLayerService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.zaol.common.OraclePaginationInfo;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;

@Controller
public class AdminLayerController extends BaseController  {

	private static Logger logger = LogManager.getLogger(AdminLayerController.class);

	private ObjectMapper mapper;

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "adminLayerService")
	private AdminLayerService adminLayerService;

	@Resource(name = "adminCodeService")
	private AdminCodeService adminCodeService;

	@Resource(name = "logsService")
	private LogsService logsService;

	private static final String validUrl   = RequestMappingConstants.WEB_MAIN;
	private static final String invalidUrl = RequestMappingConstants.WEB_LOGIN;

    @PostConstruct
	public void initIt() throws SQLException {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}

    @RequestMapping(value = RequestMappingConstants.WEB_MNG_LAYER_AUTH,
			method = {RequestMethod.GET, RequestMethod.POST})
	public String mngLayerAuth(HttpServletRequest request,
					   	   	  HttpServletResponse response,
					   	   	  @RequestParam(value="pageSort",  required=false) String  pageSort,
					   	   	  @RequestParam(value="pageOrder", required=false) String  pageOrder,
			   	   	  		  @RequestParam(value="pageIndex", required=false) Integer pageIndex,
			   	   	  		  @RequestParam(value="pageUnit",  required=false) Integer pageUnit,
			   	   	  		  @RequestParam(value="pageSize",  required=false) Integer pageSize,
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
		        	/* 컨텐츠 */
		        	if(pageIndex == null || pageIndex == 0)  pageIndex = 1;
		        	if(pageUnit  == null || pageUnit  == 0)  pageUnit  = propertiesService.getInt("pageUnit");
		        	if(pageSize  == null || pageSize  == 0)  pageSize  = propertiesService.getInt("pageSize");
		        	if(pageSort  == null || pageSort  == "") pageSort  = "INS_DT";
		        	if(pageOrder == null || pageOrder == "") pageOrder = "DESC";

		        	OraclePaginationInfo view01Cnt = new OraclePaginationInfo();
		        	view01Cnt.setCurrentPageNo     (pageIndex);
		        	view01Cnt.setRecordCountPerPage(pageUnit );
		        	view01Cnt.setPageSize          (pageSize );

		        	HashMap<String, Object> query = new HashMap<String, Object>();
		        	query.put("KEY", RequestMappingConstants.KEY);
		        	query.put("USE_YN", 		"");
		        	query.put("PAGE_SORT", 		pageSort);
		        	query.put("PAGE_ORDER", 	pageOrder);
		        	query.put("FIRST_INDEX", 	view01Cnt.getFirstRecordIndex());
		        	query.put("LAST_INDEX",  	view01Cnt.getLastRecordIndex());

		        	view01Cnt.setTotalRecordCount(adminLayerService.selectLayerAuthPagingListCount(query));

			        model.addAttribute("layerInfoList"	  , adminLayerService.selectLayerAuthPagingList(query));
			        model.addAttribute("num"			  , view01Cnt.getTotalRecordCount() - (pageIndex - 1) * pageSize);
		        	model.addAttribute("pageIndex"        , pageIndex);
		        	model.addAttribute("pageSort"         , pageSort);
		        	model.addAttribute("pageOrder"        , pageOrder);
			        model.addAttribute("view01Cnt"		  , view01Cnt);

		        	/* 이력 */
		        	try
					{
		            	HashMap<String, Object> param = new HashMap<String, Object>();
		            	param.put("KEY", RequestMappingConstants.KEY);
				       	param.put("PREFIX", "LOG");
		            	param.put("USER_ID", userId);
		            	param.put("PROGRM_URL", request.getRequestURI());
		            	param.put("AUDIT_CD", "CD00000013");
		            	param.put("TRGET_USER_ID", "");

		        		/* 프로그램 사용 이력 등록 */
						logsService.insertUserProgrmLogs(param);

						/* 감사로그 - 목록 조회 */
						logsService.insertUserAuditLogs(param);
					}
					catch (SQLException e)
					{
						logger.error("이력 등록 실패");
					}

		        	return "admin/auth/layerAuthMapng.page";
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

    @RequestMapping(value = RequestMappingConstants.WEB_MNG_LAYER_AUTH_DETAIL,
				method = RequestMethod.POST)
	public ModelAndView mngLayerAuthDetail(HttpServletRequest request,
						              HttpServletResponse response,
						   		 	  @RequestParam(value="id", required=true) String l_auth_no) throws SQLException, NullPointerException, IOException
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
		        	if("".equals(l_auth_no) == false)
		        	{
						HashMap<String, Object> query = new HashMap<String, Object>();
						query.put("KEY", RequestMappingConstants.KEY);
						query.put("L_AUTH_NO", l_auth_no);

						ModelAndView modelAndView = new ModelAndView();
						modelAndView.addObject("layerInfo", adminLayerService.selectLayerAuthList(query));
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
    
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_LAYER_AUTH_EDIT,
				method = RequestMethod.POST)
	public ModelAndView mngLayerAuthEdit(HttpServletRequest request,
						              HttpServletResponse response,
						   		 	  @RequestParam(value="id", required=true) String l_auth_no,
						   		 	  @RequestParam(value="use_yn", required=false) String use_yn,
						   		 	  @RequestParam(value="bass_yn", required=false) String bass_yn) throws SQLException, NullPointerException, IOException
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
		        	if(use_yn != null || bass_yn != null)
		        	{
		            	HashMap<String, Object> query = new HashMap<String, Object>();
		            	query.put("KEY", RequestMappingConstants.KEY);
		            	query.put("L_AUTH_NO",  l_auth_no);
		            	query.put("UPD_USER",  userId);

		            	if(use_yn != null && "".equals(use_yn) == false)
		            		query.put("USE_YN",  use_yn);

		            	if(bass_yn != null && "".equals(bass_yn) == false)
		            		query.put("BASS_YN",  bass_yn);

		                ModelAndView modelAndView = new ModelAndView();
	                	modelAndView.addObject("layerInfo", adminLayerService.updateLayerAuth(query)); 	// fake
		                modelAndView.addObject("result", "Y");											 	// real
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

    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_LAYER_AUTH_ADD},
			method = {RequestMethod.POST})
	public ModelAndView mngLayerAuthInsert(HttpServletRequest request,
			   	   	  		      HttpServletResponse response,
			   	   	  		      @RequestParam(value="auth_desc",  required=false) String auth_desc,
			   	   	  		      @RequestParam(value="bass_yn",  required=false) String bass_yn,
			   	   	  		      @RequestParam(value="use_yn",  required=false) String use_yn,
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
					if("".equals(auth_desc) == false && "".equals(bass_yn) == false && "".equals(use_yn) == false)
					{
					   	/* 컨텐츠 */
					   	HashMap<String, Object> query = new HashMap<String, Object>();
					   	query.put("KEY", RequestMappingConstants.KEY);
					   	query.put("INS_USER", userId);
					   	query.put("PREFIX", "AUTH");
					   	query.put("AUTH_DESC", auth_desc);
					   	query.put("BASS_YN", bass_yn);
					   	query.put("USE_YN", use_yn);

					   	ModelAndView modelAndView = new ModelAndView();
					   	modelAndView.addObject("layerInfo", adminLayerService.insertLayerAuth(query));
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


    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_LAYER_AUTH_LAYERS},
			method = {RequestMethod.POST})
	public ModelAndView mngProgrmListByAuthNo(HttpServletRequest request,
			   	   	  		      HttpServletResponse response,
			   	   	  		      @RequestParam(value="id",  required=true) String l_auth_no,
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
					if("".equals(l_auth_no) == false)
					{
					   	/* 컨텐츠 */
					   	HashMap<String, Object> query = new HashMap<String, Object>();
					   	query.put("KEY", RequestMappingConstants.KEY);
					   	query.put("L_AUTH_NO", l_auth_no);

					   	ModelAndView modelAndView = new ModelAndView();
					   	modelAndView.addObject("layerInfo", adminLayerService.selectLayerListByAuthNo(query));
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


    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_LAYER_AUTH_LAYERS_EDIT},
			method = {RequestMethod.POST})
	public ModelAndView mngLayerListEditByAuthNo(HttpServletRequest request,
			   	   	  		      HttpServletResponse response,
			   	   	  		      @RequestParam(value="l_auth_no",  required=true) String l_auth_no,
			   	   	  		      @RequestParam(value="l_auth_data",  required=true) String l_auth_data,
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
					if("".equals(l_auth_no) == false && l_auth_data != null)
					{
						List<Map<String, Object>> dataList = mapper.readValue(l_auth_data, List.class);

					   	/* 컨텐츠 */
					   	HashMap<String, Object> query = new HashMap<String, Object>();
					   	query.put("KEY", RequestMappingConstants.KEY);
					   	query.put("INS_USER", userId);
					   	query.put("PREFIX", "LOG");
					   	query.put("L_AUTH_NO", l_auth_no);
					   	query.put("L_AUTH_DATA", dataList);

					   	ModelAndView modelAndView = new ModelAndView();
					   	modelAndView.addObject("layerInfo", adminLayerService.insertLayerListByAuthNo(query));
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


    @RequestMapping(value = RequestMappingConstants.WEB_MNG_LAYER,
			method = {RequestMethod.GET, RequestMethod.POST})
	public String mngLayer(HttpServletRequest request,
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
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
		        String userId = commonSessionVO.getUser_id();
		        String userAdmYn = commonSessionVO.getUser_admin_yn();

		        if("Y".equals(userAdmYn) == true && "".equals(userId) == false)
		        {
		        	/* 컨텐츠 */
		        	//HashMap<String, Object> query = new HashMap<String, Object>();
		        	//query.put("KEY", RequestMappingConstants.KEY);

		        	
		        	//List layerServerList = adminLayerService.selectServerList(query);
		        	//model.addAttribute("serverList"  	, layerServerList);
			        //model.addAttribute("serverType"   	, adminCodeService.selectCodeListByGroupId("CD00000004"));

		        	/* 이력 */
		        	try
					{
		            	HashMap<String, Object> param = new HashMap<String, Object>();
		            	param.put("KEY", RequestMappingConstants.KEY);
				       	param.put("PREFIX", "LOG");
		            	param.put("USER_ID", userId);
		            	param.put("PROGRM_URL", request.getRequestURI());
		            	param.put("AUDIT_CD", "CD00000013");
		            	param.put("TRGET_USER_ID", "");

		        		/* 프로그램 사용 이력 등록 */
						logsService.insertUserProgrmLogs(param);

						/* 감사로그 - 목록 조회 */
						logsService.insertUserAuditLogs(param);
					}
					catch (SQLException e)
					{
						logger.error("이력 등록 실패");
					}

		        	return "admin/auth/layerManage.page";
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
    
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_LAYER_GROUP,
			method = {RequestMethod.GET, RequestMethod.POST})
	public String mngLayerGroup(HttpServletRequest request,
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
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
		        String userId = commonSessionVO.getUser_id();
		        String userAdmYn = commonSessionVO.getUser_admin_yn();

		        if("Y".equals(userAdmYn) == true && "".equals(userId) == false)
		        {

		        	/* 이력 */
		        	try
					{
		            	HashMap<String, Object> param = new HashMap<String, Object>();
		            	param.put("KEY", RequestMappingConstants.KEY);
				       	param.put("PREFIX", "LOG");
		            	param.put("USER_ID", userId);
		            	param.put("PROGRM_URL", request.getRequestURI());
		            	param.put("AUDIT_CD", "CD00000013");
		            	param.put("TRGET_USER_ID", "");

		        		/* 프로그램 사용 이력 등록 */
						logsService.insertUserProgrmLogs(param);

						/* 감사로그 - 목록 조회 */
						logsService.insertUserAuditLogs(param);
					}
					catch (SQLException e)
					{
						logger.error("이력 등록 실패");
					}

		        	return "admin/auth/layerGroupManage.page";
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
    
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_LAYER_MAPNG,
			method = {RequestMethod.GET, RequestMethod.POST})
	public String mngLayerMapng(HttpServletRequest request,
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
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
		        String userId = commonSessionVO.getUser_id();
		        String userAdmYn = commonSessionVO.getUser_admin_yn();

		        if("Y".equals(userAdmYn) == true && "".equals(userId) == false)
		        {

		        	/* 이력 */
		        	try
					{
		            	HashMap<String, Object> param = new HashMap<String, Object>();
		            	param.put("KEY", RequestMappingConstants.KEY);
				       	param.put("PREFIX", "LOG");
		            	param.put("USER_ID", userId);
		            	param.put("PROGRM_URL", request.getRequestURI());
		            	param.put("AUDIT_CD", "CD00000013");
		            	param.put("TRGET_USER_ID", "");

		        		/* 프로그램 사용 이력 등록 */
						logsService.insertUserProgrmLogs(param);

						/* 감사로그 - 목록 조회 */
						logsService.insertUserAuditLogs(param);
					}
					catch (SQLException e)
					{
						logger.error("이력 등록 실패");
					}

		        	return "admin/auth/layerMapngManage.page";
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
    
    @RequestMapping(value="/MapngLayerList.do")
	public ModelAndView MapngLayerList(HttpServletRequest request, HttpServletResponse response) throws SQLException, NullPointerException, IOException {
	    response.setCharacterEncoding("UTF-8");

	    String GRP_NO = request.getParameter("grp_no");

	    HashMap<String, Object> query = new HashMap<>();
	    query.put("GRP_NO", GRP_NO);

	    ObjectMapper mapper = new ObjectMapper();
	    HashMap<String, Object> responseMap = new HashMap<>();

	    // 그룹별 매핑 레이어 목록 조회
	    /*responseMap.put("MapngLayerData", adminLayerService.MapngLayerList(query));

	    String jsonResponse = mapper.writeValueAsString(responseMap);
	    response.setCharacterEncoding("UTF-8");
	    response.setContentType("application/json; charset=UTF-8");
	    response.getWriter().print(jsonResponse);*/
	    
	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.addObject("MapngLayerData", adminLayerService.MapngLayerList(query));
	    modelAndView.setViewName("jsonView");

	    return modelAndView;
	}
    
    @RequestMapping(value="/NonMapngLayerList.do")
   	public void NonMapngLayerList(HttpServletRequest request, HttpServletResponse response) throws SQLException, NullPointerException, IOException {
   	    response.setCharacterEncoding("UTF-8");

   	    ObjectMapper mapper = new ObjectMapper();
   	    HashMap<String, Object> responseMap = new HashMap<>();

   	    // 그룹 매핑 없는 레이어 목록 조회
   	    responseMap.put("LayerAddList", adminLayerService.NonMapngLayerList());

   	    String jsonResponse = mapper.writeValueAsString(responseMap);
   	    response.setCharacterEncoding("UTF-8");
   	    response.setContentType("application/json; charset=UTF-8");
   	    response.getWriter().print(jsonResponse);
   	}
    
    @RequestMapping(value="/MapngLayerAdd.do")
	public void MapngLayerAdd(HttpServletRequest request, HttpServletResponse response) throws SQLException, NullPointerException, IOException {
	    response.setCharacterEncoding("UTF-8");

	    HttpSession session = getSession();
	    CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
        String userId = commonSessionVO.getUser_id();
        
        // 레이어 번호 배열을 받아옵니다.
        String layerNoString = request.getParameter("layer_no");
        String grpNo = request.getParameter("grp_no");

	    String[] layerNos = layerNoString != null ? layerNoString.split("&") : new String[0];
	    
	    ObjectMapper mapper = new ObjectMapper();
	    HashMap<String, Object> responseMap = new HashMap<>();
	    
	    try {
	        if (layerNos.length > 0) {
	            for (String layerNo : layerNos) {
	                // 각 레이어 번호마다 쿼리 맵을 생성하고 데이터를 추가합니다.
	                HashMap<String, Object> query = new HashMap<>();
	                query.put("LAYER_NO", layerNo);
	                query.put("GRP_NO", grpNo);
	                query.put("INS_USER", userId);
	                query.put("KEY", RequestMappingConstants.KEY);
	                query.put("PREFIX", "MAPNG");

	                adminLayerService.updateLayerInfo(query); // 레이어 정보 테이블 : 사용여부(N -> Y) 업데이트
	                
	                // 레이어가 존재하는지 확인
	                Integer count = (Integer) adminLayerService.checkLayerExists(query);
	                logger.info("count>> "+count);
	                if (count > 0) {
	                    // 레이어가 존재하면 레이어-그룹 매핑 테이블 업데이트
	                    adminLayerService.updateLayer(query);
	                } else {
	                    // 레이어가 존재하지 않으면 레이어-그룹 매핑 테이블 삽입
	                    adminLayerService.insertLayer(query);
	                }
	                
	            }

	        } else {
	            responseMap.put("error", "레이어 번호가 전달되지 않았습니다.");
	        }
	    } catch (SQLException e) {
	        responseMap.put("error", "매핑 추가 중 오류가 발생했습니다");
	    }

	    String jsonResponse = mapper.writeValueAsString(responseMap);
	    response.setContentType("application/json; charset=UTF-8");
	    response.getWriter().print(jsonResponse);
	}
    
    
    @RequestMapping(value="/MapngLayerDel.do")
	public void MapngLayerDel(HttpServletRequest request, HttpServletResponse response) throws SQLException, NullPointerException, IOException {
	    response.setCharacterEncoding("UTF-8");

	    HttpSession session = getSession();
	    CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
        String userId = commonSessionVO.getUser_id();
        
        // 레이어 번호 배열을 받아옵니다.
        String layerNoString = request.getParameter("layer_no");
        String grpNo = request.getParameter("grp_no");

	    String[] layerNos = layerNoString != null ? layerNoString.split("&") : new String[0];
	    
	    ObjectMapper mapper = new ObjectMapper();
	    HashMap<String, Object> responseMap = new HashMap<>();
	    
	    try {
	        if (layerNos.length > 0) {
	            for (String layerNo : layerNos) {
	                // 각 레이어 번호마다 쿼리 맵을 생성하고 데이터를 추가합니다.
	                HashMap<String, Object> query = new HashMap<>();
	                query.put("LAYER_NO", layerNo);
	                query.put("GRP_NO", grpNo);
	                query.put("INS_USER", userId);
	                query.put("KEY", RequestMappingConstants.KEY);

	                adminLayerService.MapngLayerDel(query); // 레이어 정보 테이블 : 사용여부(Y -> N) 업데이트
	            }

	        } else {
	            responseMap.put("error", "레이어 번호가 전달되지 않았습니다.");
	        }
	    } catch (SQLException e) {
	        responseMap.put("error", "매핑 해제 중 오류가 발생했습니다");
	    }

	    String jsonResponse = mapper.writeValueAsString(responseMap);
	    response.setContentType("application/json; charset=UTF-8");
	    response.getWriter().print(jsonResponse);
	}
    
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_LAYER_SERVER,
			method = {RequestMethod.GET, RequestMethod.POST})
	public String mngLayerServer(HttpServletRequest request,
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
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
		        String userId = commonSessionVO.getUser_id();
		        String userAdmYn = commonSessionVO.getUser_admin_yn();

		        if("Y".equals(userAdmYn) == true && "".equals(userId) == false)
		        {
		        	/* 컨텐츠 */
		        	HashMap<String, Object> query = new HashMap<String, Object>();
		        	query.put("KEY", RequestMappingConstants.KEY);

		        	
		        	List layerServerList = adminLayerService.selectServerList(query);
		        	model.addAttribute("serverList"  	, layerServerList);
			        model.addAttribute("serverType"   	, adminCodeService.selectCodeListByGroupId("CD00000004"));

		        	/* 이력 */
		        	try
					{
		            	HashMap<String, Object> param = new HashMap<String, Object>();
		            	param.put("KEY", RequestMappingConstants.KEY);
				       	param.put("PREFIX", "LOG");
		            	param.put("USER_ID", userId);
		            	param.put("PROGRM_URL", request.getRequestURI());
		            	param.put("AUDIT_CD", "CD00000013");
		            	param.put("TRGET_USER_ID", "");

		        		/* 프로그램 사용 이력 등록 */
						logsService.insertUserProgrmLogs(param);

						/* 감사로그 - 목록 조회 */
						logsService.insertUserAuditLogs(param);
					}
					catch (SQLException e)
					{
						logger.error("이력 등록 실패");
					}

		        	return "admin/auth/layerServerManage.page";
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

    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_LAYER_LIST},
					method = {RequestMethod.POST})
	public ModelAndView mngLayerList(HttpServletRequest request,
		   	   	  		      HttpServletResponse response,
		   	   	  		      ModelMap model) throws SQLException, NullPointerException, IOException
	{
		response.setCharacterEncoding("UTF-8");

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			HashMap<String, Object> query = new HashMap<String, Object>();
		   	query.put("KEY", RequestMappingConstants.KEY);

			ModelAndView modelAndView = new ModelAndView();
			modelAndView.addObject("layerInfo", adminLayerService.selectLayerList(query));
			modelAndView.addObject("result", "Y");
			modelAndView.setViewName("jsonView");

			return modelAndView;
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			jsHelper.RedirectUrl(invalidUrl);
		}

		return null;

	}

    @RequestMapping(value = RequestMappingConstants.WEB_MNG_LAYER_EDIT,
					method = RequestMethod.POST)
	public ModelAndView mngLayerEdit(HttpServletRequest request,
						             HttpServletResponse response,
						   		 	 @RequestParam(value="layer_no", required=true) String layer_no) throws SQLException, NullPointerException, IOException
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
		        	if("".equals(layer_no) == false)
		        	{	
		        		String min_zoom = request.getParameter("min_zoom");
		        		String max_zoom = request.getParameter("max_zoom");
		        		
		    	    	HashMap<String, Object> param = new HashMap<String, Object>();
		    	    	param.put("KEY", RequestMappingConstants.KEY);
				       	param.put("PREFIX", "LOG");
				       	param.put("INS_USER", userId);
		    	    	param.put("UPD_USER", userId);
		            	param.put("LAYER_NO", request.getParameter("layer_no"));
		            	param.put("SERVER_NO", request.getParameter("server_no"));
		            	param.put("LAYER_CD", request.getParameter("layer_cd"));
		            	param.put("LAYER_CD_NM", request.getParameter("layer_cd_nm"));
		            	param.put("SERVER_NO", request.getParameter("server_nm"));
		            	param.put("LAYER_DP_NM", request.getParameter("layer_dp_nm"));
		            	param.put("LAYER_TP_NM", request.getParameter("layer_tp_nm"));
		            	param.put("LAYER_DESC", request.getParameter("layer_desc"));
		            	param.put("MIN_ZOOM", Integer.parseInt(min_zoom));
		            	param.put("MAX_ZOOM", Integer.parseInt(max_zoom));
		            	param.put("STYLES_NM", request.getParameter("styles_nm"));
		            	param.put("PARAMTR", request.getParameter("paramtr"));
		            	param.put("FLTER", request.getParameter("flter"));
		            	param.put("PRJCTN", request.getParameter("prjctn"));
		            	param.put("INFOGRAPHIC_URL", request.getParameter("infographic_url"));
		            	param.put("TABLE_NM", request.getParameter("table_nm"));
		            	param.put("USE_YN", request.getParameter("use_yn"));

		            	String result = "Y";
		    	    	try
		    	    	{
		    	    		adminLayerService.updateLayerInfoByNo(param);
		    	    	}
		    	    	catch(SQLException e)
		    	    	{
		    	    		result = "N";
		    	    	}

		    	    	ModelAndView modelAndView = new ModelAndView();
		    	    	modelAndView.addObject("result", result);
		    	        modelAndView.setViewName("jsonView");

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
    
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_LAYER_TYPE_SET,
			method = RequestMethod.POST)
public ModelAndView mngLayerTypeSet(HttpServletRequest request,
				             HttpServletResponse response) throws SQLException, NullPointerException, IOException
{
response.setCharacterEncoding("UTF-8");
ModelAndView modelAndView = new ModelAndView();
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
        		
    	    	HashMap<String, Object> param = new HashMap<String, Object>();
    	    	
    	        modelAndView.setViewName("jsonView");
    	        modelAndView.addObject("result",adminLayerService.layerTypeSet(param));

    	        return modelAndView;
        	}
        }
        else
        {
    		jsHelper.Alert("권한이 없습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
    		jsHelper.RedirectUrl(invalidUrl);
    		return modelAndView;
        }
	}
	else
	{
    	jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
    	jsHelper.RedirectUrl(invalidUrl);
    	return modelAndView;
    }
return modelAndView;
}

    @RequestMapping(value = RequestMappingConstants.WEB_MNG_LAYER_ADD,
					method = RequestMethod.POST)
	public ModelAndView mngLayerAdd(HttpServletRequest request,
						            HttpServletResponse response
						            ) throws SQLException, NullPointerException, IOException
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
		        	HashMap<String, Object> param = new HashMap<String, Object>();
		        	
		        	String min_zoom = request.getParameter("new_min_zoom");
	        		String max_zoom = request.getParameter("new_max_zoom");
		        	
		        	param.put("KEY", RequestMappingConstants.KEY);
			       	param.put("INS_USER", userId);
	    	    	param.put("UPD_USER", userId);
	            	param.put("LAYER_DP_NM", request.getParameter("new_layer_dp_nm"));
	            	param.put("LAYER_TP_NM", request.getParameter("new_layer_tp_nm"));
	            	param.put("LAYER_CD", request.getParameter("new_layer_cd"));
	            	param.put("LAYER_CD_NM", request.getParameter("new_layer_cd_nm"));
	            	param.put("LAYER_DESC", request.getParameter("new_layer_desc"));
	            	param.put("SERVER_NM", request.getParameter("new_server_nm"));
	            	param.put("MIN_ZOOM", Integer.parseInt(min_zoom));
	            	param.put("MAX_ZOOM", Integer.parseInt(max_zoom));
	            	param.put("STYLES_NM", request.getParameter("new_styles_nm"));
	            	param.put("PARAMTR", request.getParameter("new_paramtr"));
	            	param.put("FLTER", request.getParameter("new_flter"));
	            	param.put("PRJCTN", request.getParameter("new_prjctn"));
	            	param.put("TABLE_NM", request.getParameter("new_table_nm"));
	            	param.put("USE_YN", request.getParameter("new_use_yn"));
		        	
	            	adminLayerService.layeradd(param);
		        	
		        	ModelAndView modelAndView = new ModelAndView();
		        	modelAndView.setViewName("jsonView");
		        	
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
    
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_LAYER_DELETE,
			method = RequestMethod.POST)
public ModelAndView mngLayerDel(HttpServletRequest request,
				            HttpServletResponse response
				            ) throws SQLException, NullPointerException, IOException
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
        	HashMap<String, Object> param = new HashMap<String, Object>();
        	
        	String min_zoom = request.getParameter("new_min_zoom");
    		String max_zoom = request.getParameter("new_max_zoom");
        	
        	param.put("KEY", RequestMappingConstants.KEY);
	       	param.put("INS_USER", userId);
	    	param.put("UPD_USER", userId);
	    	param.put("LAYER_NO", request.getParameter("layer_no"));
        	
        	adminLayerService.layerDel(param);
        	
        	ModelAndView modelAndView = new ModelAndView();
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
    
    
    
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_LAYER_FILE_DELETE)
    public ModelAndView file_delete(HttpServletRequest request,
	  		      HttpServletResponse response,
	  		    @RequestParam(value="file_grp",  required=true) String file_grp) throws SQLException, NullPointerException, IOException {
    	HashMap<String, Object> query = new HashMap<String, Object>();
    	query.put("file_grp", file_grp);
    	adminLayerService.delete_File(query);
    	ModelAndView modelAndView = new ModelAndView();
    	modelAndView.setViewName("jsonView");
    	return modelAndView;
    }
    
    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_LAYER_INFOG_EDIT},
			method = {RequestMethod.POST})
	public ModelAndView mngLayerInforaphicEdit(HttpServletRequest request,
						   	   	  		      HttpServletResponse response,
						   	   	  		      @RequestParam(value="id",  required=true) String layer_no,
						   	   	  		      @RequestParam(value="file_grp",  required=true) String file_grp,
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
					if("".equals(layer_no) == false && "".equals(file_grp) == false)
					{
						Map data = getParameterMap(request);

					   	/* 컨텐츠 */
					   	HashMap<String, Object> query = new HashMap<String, Object>();
					   	query.put("KEY", RequestMappingConstants.KEY);
					   	query.put("INS_USER", userId);
					   	query.put("PREFIX", "LOG");
					   	query.put("LAYER_NO", layer_no);
					   	query.put("FILE_GRP", file_grp);

					   	ModelAndView modelAndView = new ModelAndView();
					   	modelAndView.addObject("fileInfo", adminLayerService.updateLayerInfographicByNo(query));
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

    @RequestMapping(value = RequestMappingConstants.WEB_MNG_LAYER_DESC,
				method = RequestMethod.POST)
	public ModelAndView mngLayerDesc(HttpServletRequest request,
						              HttpServletResponse response,
						   		 	  @RequestParam(value="id", required=true) String layer_no) throws SQLException, NullPointerException, IOException
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
		        	if("".equals(layer_no) == false)
		        	{
						HashMap<String, Object> query = new HashMap<String, Object>();
						query.put("KEY", RequestMappingConstants.KEY);
						query.put("LAYER_NO", layer_no);

						ModelAndView modelAndView = new ModelAndView();
						modelAndView.addObject("layerDesc", adminLayerService.selectLayerDesc(query));
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

    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_LAYER_DESC_ADD},
			method = {RequestMethod.POST})
	public ModelAndView mngLayerDescAdd(HttpServletRequest request,
			   	   	  		      HttpServletResponse response,
			   	   	  		      @RequestParam(value="desc_layer_no",  required=true) String layer_no,
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
					if("".equals(layer_no) == false)
					{
						Map data = getParameterMap(request);

					   	/* 컨텐츠 */
					   	HashMap<String, Object> query = new HashMap<String, Object>();
					   	query.put("KEY", RequestMappingConstants.KEY);
					   	query.put("INS_USER", userId);
					   	query.put("PREFIX", "DESC");
					   	query.put("DESC_DATA", data);

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

    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_LAYER_DESC_EDIT},
			method = {RequestMethod.POST})
	public ModelAndView mngLayerDescEditByNo(HttpServletRequest request,
						   	   	  		      HttpServletResponse response,
						   	   	  		      @RequestParam(value="desc_no",  required=true) String desc_no,
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
					if("".equals(desc_no) == false)
					{
						Map data = getParameterMap(request);

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

    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_LAYER_GROUP_LIST},
    				method = {RequestMethod.POST})
	public ModelAndView mngLayerGroupList(HttpServletRequest request,
	   	   	  		      HttpServletResponse response,
	   	   	  		      ModelMap model) throws SQLException, NullPointerException, IOException
	{
		response.setCharacterEncoding("UTF-8");

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			HashMap<String, Object> query = new HashMap<String, Object>();
		   	query.put("KEY", RequestMappingConstants.KEY);

			ModelAndView modelAndView = new ModelAndView();
			modelAndView.addObject("groupInfo", adminLayerService.selectLayerGroupList(query));
			modelAndView.addObject("result", "Y");
			modelAndView.setViewName("jsonView");

			return modelAndView;
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			jsHelper.RedirectUrl(invalidUrl);
		}

		return null;

	}
    
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_LAYER_GROUP_EDIT,
			method = RequestMethod.POST)
	public ModelAndView mngLayerGroupEdit(HttpServletRequest request,
					             HttpServletResponse response,
					   		 	 @RequestParam(value="grp_no", required=true) String grp_no) throws SQLException, NullPointerException, IOException
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
	        	if("".equals(grp_no) == false)
	        	{
	    	    	HashMap<String, Object> param = new HashMap<String, Object>();
	    	    	param.put("KEY", RequestMappingConstants.KEY);
			       	param.put("PREFIX", "LOG");
			       	param.put("INS_USER", userId);
	    	    	param.put("UPD_USER", userId);
	            	param.put("grp_no", request.getParameter("grp_no"));
	            	param.put("p_grp_no", request.getParameter("p_grp_no"));
	            	param.put("grp_nm", request.getParameter("grp_nm"));
	            	param.put("grp_desc", request.getParameter("grp_desc"));
	            	param.put("grp_order", request.getParameter("grp_order"));
	            	param.put("USE_YN", request.getParameter("use_yn"));
	
	            	String result = "Y";
	    	    	try
	    	    	{
	    	    		adminLayerService.updateLayerGroupInfoByNo(param);
	    	    	}
	    	    	catch(SQLException e)
	    	    	{
	    	    		result = "N";
	    	    	}
	
	    	    	ModelAndView modelAndView = new ModelAndView();
	    	    	modelAndView.addObject("result", result);
	    	        modelAndView.setViewName("jsonView");
	
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
    
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_LAYER_GROUP_ADD_SETTING,
			method = RequestMethod.POST)
	public ModelAndView mngLayerGroupAddSetting(HttpServletRequest request,
					             HttpServletResponse response) throws SQLException, NullPointerException, IOException
	{
	response.setCharacterEncoding("UTF-8");
	
	String referer = request.getHeader("referer");
	HashMap<String, Object> param = new HashMap<String, Object>();
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
	        	ModelAndView modelAndView = new ModelAndView();
	        	
	        	modelAndView.addObject("maxLayerGroupNo", adminLayerService.maxLayerGroupNo(param)); // maxLayerGroupNo
	        	modelAndView.addObject("layerGroupOrderList", adminLayerService.layerGroupOrderList(param));// layerGroupOrderList
	        	
	        	
    	        modelAndView.setViewName("jsonView");

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
    
    // 코드 추가
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_LAYER_GROUP_ADD, 
    		method = RequestMethod.POST)
 	public ModelAndView mngLayerGroupAdd(HttpServletRequest request, 
 					   	   	 HttpServletResponse response,
 					   	     @RequestParam(value="newGroupNo",  required=false) String newGroupNo,
	 					   	 @RequestParam(value="newParentGroupNo",  required=false) String newParentGroupNo,
	 					   	 @RequestParam(value="newGroupOrder",  required=false) String newGroupOrder,
	 					   	 @RequestParam(value="newGroupNm",  required=false) String newGroupNm,
	 					   	 @RequestParam(value="newGroupDesc",  required=false) int newGroupDesc,
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
 		        	
 		        	
 		        	HashMap<String, Object> query = new HashMap<String, Object>();
 		        	
 		        	ModelAndView modelAndView = new ModelAndView();
 		        	
 		        	query.put("newGroupNo", newGroupNo);
 		        	query.put("newParentGroupNo", newParentGroupNo);
 		        	query.put("newGroupOrder", newGroupOrder);
 		        	query.put("newGroupNm", newGroupNm);
 		        	query.put("newGroupDesc", newGroupDesc);
 		        	query.put("userId", userId);
 		        	query.put("KEY", RequestMappingConstants.KEY);
 		        	
 		        	logger.info("newGroupNo : "+newGroupNo);
 		        	logger.info("newParentGroupNo : "+newParentGroupNo);
 		        	logger.info("newGroupOrder : "+newGroupOrder);
 		        	logger.info("newGroupNm : "+newGroupNm);
 		        	logger.info("newGroupDesc : "+newGroupDesc);
 		        	logger.info("userId : "+userId);
 		        	logger.info("KEY : "+RequestMappingConstants.KEY);
 		        	
 		        	//adminCodeService.orderAdd(query);
 		        	
 		        	
	                modelAndView.setViewName("jsonView");
 		        	
 		        	
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


    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_SERVER_LIST},
					method = {RequestMethod.POST})
	public ModelAndView mngServerList(HttpServletRequest request,
			   	   	  		      HttpServletResponse response,
			   	   	  		      ModelMap model) throws SQLException, NullPointerException, IOException
	{
		response.setCharacterEncoding("UTF-8");

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			HashMap<String, Object> query = new HashMap<String, Object>();
		   	query.put("KEY", RequestMappingConstants.KEY);

			ModelAndView modelAndView = new ModelAndView();
			modelAndView.addObject("serverInfo", adminLayerService.selectServerList(query));
			modelAndView.addObject("result", "Y");
			modelAndView.setViewName("jsonView");

			return modelAndView;
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			jsHelper.RedirectUrl(invalidUrl);
		}

		return null;

	}

    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_SERVER_ADD},
			method = {RequestMethod.POST})
	public ModelAndView mngServerAdd(HttpServletRequest request,
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
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
				String userId = commonSessionVO.getUser_id();
				String userAdmYn = commonSessionVO.getUser_admin_yn();

				if("Y".equals(userAdmYn) == true && "".equals(userId) == false)
				{
					Map data = getParameterMap(request);

				   	/* 컨텐츠 */
				   	HashMap<String, Object> query = new HashMap<String, Object>();
				   	query.put("KEY", RequestMappingConstants.KEY);
				   	query.put("INS_USER", userId);
				   	query.put("PREFIX", "SERVER");
				   	query.put("SERVER_DATA", data);

				   	ModelAndView modelAndView = new ModelAndView();
				   	modelAndView.addObject("serverInfo", adminLayerService.insertServer(query));
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

    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_SERVER_EDIT},
				    method = {RequestMethod.POST})
	public ModelAndView mngServerEditByNo(HttpServletRequest request,
						   	   	  		      HttpServletResponse response,
						   	   	  		      @RequestParam(value="m_server_no",  required=true) String server_no,
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
					if("".equals(server_no) == false)
					{
						Map data = getParameterMap(request);

					   	/* 컨텐츠 */
					   	HashMap<String, Object> query = new HashMap<String, Object>();
					   	query.put("KEY", RequestMappingConstants.KEY);
					   	query.put("INS_USER", userId);
					   	query.put("PREFIX", "LOG");
					   	query.put("SERVER_NO", server_no);
					   	query.put("SERVER_DATA", data);

					   	ModelAndView modelAndView = new ModelAndView();
					   	modelAndView.addObject("serverInfo", adminLayerService.insertServerByNo(query));
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

}
