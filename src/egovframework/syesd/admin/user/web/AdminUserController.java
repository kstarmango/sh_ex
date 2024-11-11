package egovframework.syesd.admin.user.web;

import java.io.IOException;

/**
 * 관리자 - 사용자 컨트롤러 클래스
 *
 * @author  유창범
 * @since   2020.07.22
 * @version 1.0
 * @see
 * <pre>
 *   == 개정이력(Modification Information) ==
 *
 *         수정일                        수정자                                수정내용
 *   ----------------    ------------    ---------------------------
 *   2020.07.22          유창범                           최초 생성
 *
 * </pre>
 */

import java.net.URL;
import java.sql.SQLException;
import java.util.Arrays;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.syesd.admin.progrm.service.AdminProgrmService;
import egovframework.syesd.admin.code.service.AdminCodeService;
import egovframework.syesd.admin.layer.service.AdminLayerService;
import egovframework.syesd.admin.user.service.AdminUserService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.syesd.cmmn.util.KeyGenerateUtil;
import egovframework.syesd.portal.user.service.UserService;
import egovframework.zaol.common.OraclePaginationInfo;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;

@Controller
public class AdminUserController extends BaseController  {

	private static Logger logger = LogManager.getLogger(AdminUserController.class);

	private ObjectMapper mapper;

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "adminUserService")
	private AdminUserService adminUserService;

	@Resource(name = "adminCodeService")
	private AdminCodeService adminCodeService;

	@Resource(name = "adminProgrmService")
	private AdminProgrmService adminProgrmService;

	@Resource(name = "adminLayerService")
	private AdminLayerService adminLayerService;

	@Resource(name = "userService")
	private UserService userService;

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

    @RequestMapping(value = RequestMappingConstants.WEB_MNG_USER,
					method = {RequestMethod.GET, RequestMethod.POST})
	public String mngUser(HttpServletRequest request,
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
	            	query.put("USE_YN",    		request.getParameter("s_serch_use_yn"));
	            	query.put("LOCK_YN",   		request.getParameter("s_serch_lock_yn"));
	            	query.put("CONFM_YN",  		request.getParameter("s_serch_confm_yn"));
	            	query.put("SERCH_GB", 		request.getParameter("s_serch_gb"));
	            	query.put("SERCH_NM", 		request.getParameter("s_serch_nm"));
	            	query.put("START_DATE", 	request.getParameter("s_serch_start_dt"));
	            	query.put("PAGE_SORT", 		pageSort);
	            	query.put("PAGE_ORDER", 	pageOrder);
	            	query.put("FIRST_INDEX", 	view01Cnt.getFirstRecordIndex());
	            	query.put("LAST_INDEX",  	view01Cnt.getLastRecordIndex());

	            	logger.info("KEY!!!!"+RequestMappingConstants.KEY);
	            	
	            	List userList = adminUserService.selectUserInfos(query);

	            	view01Cnt.setTotalRecordCount(adminUserService.selectUserInfosCount(query));

	            	HashMap<String, Object> query2 = new HashMap<String, Object>();
	            	query2.put("USE_YN", "Y");

			        model.addAttribute("progrmAuthList"	  , adminProgrmService.selectProgrmAuthList(query2));
			        model.addAttribute("layerAuthList"	  , adminLayerService.selectLayerAuthList(query2));
	            	model.addAttribute("s_serch_use_yn"   , request.getParameter("s_serch_use_yn"));
	            	model.addAttribute("s_serch_lock_yn"  , request.getParameter("s_serch_lock_yn"));
	            	model.addAttribute("s_serch_confm_yn" , request.getParameter("s_serch_confm_yn"));
	            	model.addAttribute("s_serch_gb"       , request.getParameter("s_serch_gb"));
	            	model.addAttribute("s_serch_nm"       , request.getParameter("s_serch_nm"));
	            	model.addAttribute("s_serch_start_dt" , request.getParameter("s_serch_start_dt"));
			        model.addAttribute("num"			  , view01Cnt.getTotalRecordCount() - (pageIndex - 1) * pageSize);
	            	model.addAttribute("pageIndex"        , pageIndex);
	            	model.addAttribute("pageSort"         , pageSort);
	            	model.addAttribute("pageOrder"        , pageOrder);
			        model.addAttribute("userList"		  , userList);
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

	            	return "admin/user/userManage.page";
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

    @RequestMapping(value = RequestMappingConstants.WEB_MNG_USER_DETAIL,
					method = {RequestMethod.POST})
	public ModelAndView mngUserDetail(HttpServletRequest request,
				   	   	  			 HttpServletResponse response,
				   	   	  		     @RequestParam(value="id",  required=true) String user_id,
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

	            if(("Y".equals(userAdmYn) == true && "".equals(userId) == false) || (user_id != null && userId.equals(user_id) == true))
	            {
	            	if("".equals(user_id) == false)
	            	{
		            	/* 컨텐츠 */
		            	HashMap<String, Object> query = new HashMap<String, Object>();
		            	query.put("KEY", RequestMappingConstants.KEY);
		            	query.put("USER_ID", user_id);

		                ModelAndView modelAndView = new ModelAndView();
		                modelAndView.addObject("userInfo", adminUserService.selectUserInfoDetail(query));
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
			            	param.put("AUDIT_CD", "CD00000014");
			            	param.put("TRGET_USER_ID", user_id);

		            		/* 프로그램 사용 이력 등록 */
		    				logsService.insertUserProgrmLogs(param);

		    				/* 감사로그 - 상세 조회 */
		    				logsService.insertUserAuditLogs(param);
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


    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_USER_CONFM,
    						 RequestMappingConstants.WEB_MNG_USER_USE,
    						 RequestMappingConstants.WEB_MNG_USER_LOCK,
    						 RequestMappingConstants.WEB_MNG_USER_PAUTH,
    						 RequestMappingConstants.WEB_MNG_USER_LAUTH},
					method = {RequestMethod.POST})
	public ModelAndView mngUserInfoChange(HttpServletRequest request,
					   	   	  			  HttpServletResponse response,
					   	   	  		      @RequestParam(value="id",  required=true) String user_id,
					   	   	  		      @RequestParam(value="confm_yn",  required=false) String confm_yn,
					   	   	  		      @RequestParam(value="use_yn",  required=false) String use_yn,
					   	   	  		      @RequestParam(value="lock_yn",  required=false) String lock_yn,
					   	   	  		      @RequestParam(value="p_auth_no",  required=false) String p_auth_no,
					   	   	  		      @RequestParam(value="l_auth_no",  required=false) String l_auth_no,
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
		        	if(confm_yn != null || use_yn != null || lock_yn != null || p_auth_no != null || l_auth_no != null)
		        	{
		            	HashMap<String, Object> query = new HashMap<String, Object>();
		            	query.put("KEY", RequestMappingConstants.KEY);
		            	query.put("USER_ID",  user_id);
		            	query.put("UPD_USER",  userId);
		            		
		            	query.put("INS_USER",  userId);
		            	query.put("PREFIX", "LOG");
		            	
		            	if(confm_yn != null && "".equals(confm_yn) == false)
		            		query.put("CONFM_YN",  confm_yn);

		            	if(use_yn != null && "".equals(use_yn) == false)
		            		query.put("USE_YN",  use_yn);

		            	if(lock_yn != null && "".equals(lock_yn) == false)
		            		query.put("LOCK_YN",  lock_yn);

		            	if(p_auth_no != null && "".equals(p_auth_no) == false)
		            		query.put("P_AUTH_NO",  p_auth_no);

		            	if(l_auth_no != null && "".equals(l_auth_no) == false)
		            		query.put("L_AUTH_NO",  l_auth_no);
		            	

		                ModelAndView modelAndView = new ModelAndView();
	                	modelAndView.addObject("userInfo", adminUserService.updateUserInfoChange(query)); 	// fake
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
			            	param.put("TRGET_USER_ID", user_id);

		            		/* 프로그램 사용 이력 등록 */
		    				logsService.insertUserProgrmLogs(param);

		    				if("".equals(confm_yn) == false)
		    				{
			    				param.put("AUDIT_CD", "CD00000021");
			    				/* 감사로그 - 사용/미사용 */
			    				logsService.insertUserAuditLogs(param);
		    				}

		    				if("".equals(use_yn) == false)
		    				{
			    				param.put("AUDIT_CD", "Y".equals(use_yn) ? "CD00000022" : "CD00000023");
			    				/* 감사로그 - 사용/미사용 */
			    				logsService.insertUserAuditLogs(param);
		    				}

		    				if("".equals(lock_yn) == false)
		    				{
			    				param.put("AUDIT_CD", "Y".equals(lock_yn) ? "CD00000018" : "CD00000019");

			    				/* 감사로그 - 잠금/해제 */
			    				logsService.insertUserAuditLogs(param);
		    				}

		    				if("".equals(p_auth_no) == false || "".equals(l_auth_no) == false)
		    				{
			    				param.put("AUDIT_CD", "CD00000024");

			    				/* 감사로그 - 권한수정 */
			    				logsService.insertUserAuditLogs(param);
		    				}

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

    @RequestMapping(value = RequestMappingConstants.WEB_MNG_USER_PWD,
					method = {RequestMethod.POST})
	public ModelAndView mngUserPwdChange(HttpServletRequest request,
					   	   	  			 HttpServletResponse response,
					   	   	  		     @RequestParam(value="id",  required=true) String user_id,
					   	   	  		     @RequestParam(value="pwd", required=true) String user_pwd,
					   	   	  		     @RequestParam(value="length", required=true) Integer length,
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

		        if(("Y".equals(userAdmYn) == true && "".equals(userId) == false) || (user_id != null && userId.equals(user_id) == true))
		        {
		        	if("".equals(user_id) == false && "".equals(user_pwd) == false && length > 4)
		        	{
		            	HashMap<String, Object> query = new HashMap<String, Object>();
		            	query.put("KEY", RequestMappingConstants.KEY);
		            	query.put("USER_ID",  user_id);
		            	query.put("UPD_USER",  userId);

		            	query.put("INS_USER",  userId);
		            	query.put("PREFIX", "LOG");

		            	if(referer.contains(RequestMappingConstants.WEB_MNG_USER) == true)	// 관리자 암호초기화 - 7자리 랜덤 패스워드 생성
		            	{
		            		user_pwd = KeyGenerateUtil.shuffleString(length);
		            		query.put("USER_PWD", user_pwd); 	// real
		            		query.put("PWD_RESET_YN", "Y"); 	// real
		            		
		        		}
		            	else																// 사용자 암호 변경
		            	{
		            		query.put("USER_PWD", user_pwd); 	// real
		            		query.put("PWD_RESET_YN", "N"); 	// real
		            	}

		                ModelAndView modelAndView = new ModelAndView();
		                modelAndView.addObject("userInfo", adminUserService.updateUserPwdChange(query)); // fake
		                modelAndView.addObject("newPwd", user_pwd);
		                modelAndView.addObject("result", "Y");											 // real
		                modelAndView.setViewName("jsonView");

		                /* 이력 */
		            	try
		    			{
			            	HashMap<String, Object> param = new HashMap<String, Object>();
			            	param.put("KEY", RequestMappingConstants.KEY);
					       	param.put("PREFIX", "LOG");
			            	param.put("USER_ID", userId);
			            	param.put("PROGRM_URL", request.getRequestURI());
			            	param.put("AUDIT_CD", "CD00000020");
			            	param.put("TRGET_USER_ID", user_id);

		            		/* 프로그램 사용 이력 등록 */
		    				logsService.insertUserProgrmLogs(param);

		    				/* 감사로그 - 패스워드초기화 */
		    				logsService.insertUserAuditLogs(param);
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


    @RequestMapping(value = RequestMappingConstants.WEB_MNG_USER_ID_DUP,
					method = RequestMethod.POST)
    public ModelAndView userIdDuplicateYn(HttpServletRequest request,
    						              HttpServletResponse response,
							   		 	  @RequestParam(value="user_id", required=true) String userId) throws SQLException, NullPointerException, IOException
    {
    	request.setCharacterEncoding("UTF-8");

    	HashMap<String, Object> param = new HashMap<String, Object>();
    	param.put("KEY", RequestMappingConstants.KEY);
    	param.put("USER_ID", userId);

    	String result = "Y";
    	try
    	{
    		result = userService.checkExistUserId(param);
    	}
    	catch(SQLException e)
    	{
    		result = "Y";
    	}

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("result", result);
        modelAndView.setViewName("jsonView");

        return modelAndView;
    }

    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_USER_PWD_DUP},
					method = {RequestMethod.POST})
	public ModelAndView passwordDuplicateYn(HttpServletRequest request,
							   		 	  HttpServletResponse response,
							   		 	  @RequestParam(value="id", required=true) String userId,
							   		 	  @RequestParam(value="pwd", required=true) String userPwd) throws SQLException, NullPointerException, IOException
	{
		response.setCharacterEncoding("UTF-8");

		HttpSession session =  getSession();
		if(session == null ){
			session = request.getSession(); // 세션 없으면 세션 생성
		}

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("KEY", RequestMappingConstants.KEY);
		param.put("USER_ID", userId);
		param.put("USER_PASS", userPwd);

		String result = "Y";
		try
		{
			result = userService.checkReusePassword(param);
		}
		catch(SQLException e)
		{
			result = "Y";
		}

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.addObject("result", result);
		modelAndView.setViewName("jsonView");

		return modelAndView;
	}

    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_USER_PWD_RST},
			method = {RequestMethod.POST})
	public ModelAndView checkResetPassword(HttpServletRequest request,
								   		   HttpServletResponse response,
								   		   @RequestParam(value="id", required=true) String userId) throws SQLException, NullPointerException, IOException
	{
		response.setCharacterEncoding("UTF-8");

		HttpSession session =  getSession();
		if(session == null ){
			session = request.getSession(); // 세션 없으면 세션 생성
		}

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("KEY", RequestMappingConstants.KEY);
		param.put("USER_ID", userId);
		param.put("NUM", RequestMappingConstants.WEB_MNG_USER_PWD_NUM);
		param.put("UNIT", RequestMappingConstants.WEB_MNG_USER_PWD_UNIT_ENG);

		String result = "Y";
		try
		{
			result = userService.checkResetPassword(param);
		}
		catch(SQLException e)
		{
			result = "Y";
		}

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.addObject("result", result);
		modelAndView.setViewName("jsonView");

		return modelAndView;
	}

    @RequestMapping(value = RequestMappingConstants.WEB_MNG_USER_LOGIN_HISTORY,
			method = {RequestMethod.GET, RequestMethod.POST})
	public String mngUserHistory(HttpServletRequest request,
						   	   	 HttpServletResponse response,
						   	   	 @RequestParam(value="pageSort",  required=false) String  pageSort,
						   	   	 @RequestParam(value="pageOrder", required=false) String  pageOrder,
				   	   	  		 @RequestParam(value="pageIndex", required=false) Integer pageIndex,
				   	   	  		 @RequestParam(value="pageUnit",  required=false) Integer pageUnit,
				   	   	  		 @RequestParam(value="pageSize",  required=false) Integer pageSize,
				   	   	  		 @RequestParam(value="s_serch_member",  required=false)String[] s_serch_member,
				   	   	  		 @RequestParam(value="logoutYn", required=false) String  logoutYn,
				   	   	  		 @RequestParam(value="initLogoutYn", required=false) String  initLogoutYn,
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
		        	if(pageSort  == null || pageSort  == "") pageSort  = "ins_dt";	// 소문자 사용
		        	if(pageOrder == null || pageOrder == "") pageOrder = "desc";	// 소문자 사용

		        	OraclePaginationInfo view01Cnt = new OraclePaginationInfo();
		        	view01Cnt.setCurrentPageNo     (pageIndex);
		        	view01Cnt.setRecordCountPerPage(pageUnit );
		        	view01Cnt.setPageSize          (pageSize );

		        	HashMap<String, Object> query = new HashMap<String, Object>();
		        	query.put("KEY", RequestMappingConstants.KEY);
		        	query.put("SERCH_GB", 		request.getParameter("s_serch_gb"));
		        	query.put("SERCH_NM", 		request.getParameter("s_serch_nm"));
		        	query.put("START_DATE", 	request.getParameter("s_serch_start_dt"));
		        	query.put("END_DATE", 		request.getParameter("s_serch_end_dt"));
		        	query.put("PAGE_SORT", 		pageSort);
		        	query.put("PAGE_ORDER", 	pageOrder);
		        	query.put("FIRST_INDEX", 	view01Cnt.getFirstRecordIndex());
		        	query.put("LAST_INDEX",  	view01Cnt.getLastRecordIndex());
		        	query.put("P_PROGRM_NO",	"PROGRM00000000000020");
		        	query.put("SERCH_MEM", 		s_serch_member);
		        	if(initLogoutYn == null) {
		        		query.put("LOGOUTYN","Y");
			        }else {
		        		query.put("LOGOUTYN",logoutYn);
			        }

		        	List userLoginList = adminUserService.selectUserLoginHistory(query);
		        	List userLoginListExcel = adminUserService.selectUserLoginHistoryExcel(query);
		        	
		        	view01Cnt.setTotalRecordCount(adminUserService.selectUserLoginHistoryCount(query));

		        	model.addAttribute("s_serch_gb"       , request.getParameter("s_serch_gb"));
		        	model.addAttribute("s_serch_nm"       , request.getParameter("s_serch_nm"));
		        	model.addAttribute("s_serch_start_dt" , request.getParameter("s_serch_start_dt"));
		        	model.addAttribute("s_serch_end_dt"   , request.getParameter("s_serch_end_dt"));
		        	model.addAttribute("s_serch_member"   , s_serch_member != null ? Arrays.toString(s_serch_member) : null);
		        	model.addAttribute("userMemberType"   , adminCodeService.selectCodeListByGroupId("CD00000041"));
		        	model.addAttribute("num"			  , view01Cnt.getTotalRecordCount() - (pageIndex - 1) * pageSize);
		        	model.addAttribute("pageIndex"        , pageIndex);
		        	model.addAttribute("pageSort"         , pageSort);
		        	model.addAttribute("pageOrder"        , pageOrder);
			        model.addAttribute("userHistList"	  , userLoginList);
			        model.addAttribute("userHistListExcel" , userLoginListExcel);
			        model.addAttribute("view01Cnt"		  , view01Cnt);
			        if(initLogoutYn == null) {
			        	model.addAttribute("logoutYn","Y");
			        }else {
			        	model.addAttribute("logoutYn",logoutYn);
			        }
				   
			        

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

		        	return "admin/user/loginHistory.page";
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

    @RequestMapping(value = RequestMappingConstants.WEB_MNG_USER_AUDIT_HISTORY,
			method = {RequestMethod.GET, RequestMethod.POST})
	public String mngUserAuditLog(HttpServletRequest request,
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
		        	query.put("SERCH_GB", 		request.getParameter("s_serch_gb"));
		        	query.put("SERCH_NM", 		request.getParameter("s_serch_nm"));
		        	query.put("START_DATE", 	request.getParameter("s_serch_start_dt"));
		        	query.put("END_DATE", 		request.getParameter("s_serch_end_dt"));
		        	query.put("PAGE_SORT", 		pageSort);
		        	query.put("PAGE_ORDER", 	pageOrder);
		        	query.put("FIRST_INDEX", 	view01Cnt.getFirstRecordIndex());
		        	query.put("LAST_INDEX",  	view01Cnt.getLastRecordIndex());

		        	List userAuditList = adminUserService.selectUserAuditHistory(query);

		        	view01Cnt.setTotalRecordCount(adminUserService.selectUserAuditHistoryCount(query));

		        	model.addAttribute("s_serch_gb"       , request.getParameter("s_serch_gb"));
		        	model.addAttribute("s_serch_nm"       , request.getParameter("s_serch_nm"));
		        	model.addAttribute("s_serch_start_dt" , request.getParameter("s_serch_start_dt"));
		        	model.addAttribute("s_serch_end_dt"   , request.getParameter("s_serch_end_dt"));
			        model.addAttribute("num"			  , view01Cnt.getTotalRecordCount() - (pageIndex - 1) * pageSize);
		        	model.addAttribute("pageIndex"        , pageIndex);
		        	model.addAttribute("pageSort"         , pageSort);
		        	model.addAttribute("pageOrder"        , pageOrder);
			        model.addAttribute("userAuditList"	  , userAuditList);
			        model.addAttribute("view01Cnt"		  , view01Cnt);

		        	/* 이력 */
		        	try
					{
		        		String auditLogYn = (String) session.getAttribute("AUDIT_LOG_YN");
		        		if(pageIndex == 1 && (null == auditLogYn || "N".equals(auditLogYn) == true)) {
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

							session.setAttribute("AUDIT_LOG_YN", "Y");
		        		}
					}
					catch (SQLException e)
					{
						logger.error("이력 등록 실패");
					}

		        	return "admin/user/auditHistory.page";
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
