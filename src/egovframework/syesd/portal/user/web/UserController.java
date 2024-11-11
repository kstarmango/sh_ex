package egovframework.syesd.portal.user.web;

import java.io.IOException;
import java.net.MalformedURLException;

/**
 * 사용자 컨트롤러 클래스
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
import java.util.HashMap;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.syesd.cmmn.menu.service.MenuService;
import egovframework.syesd.cmmn.util.EgovProperties;
import egovframework.syesd.portal.user.service.UserService;
import egovframework.syesd.sso.user.service.SsoUserService;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;

@Controller
public class UserController extends BaseController  {

	private static Logger logger = LogManager.getLogger(UserController.class);

	private ObjectMapper mapper;

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "userService")
	private UserService userService;

	@Resource(name = "ssoUserService")
	private SsoUserService ssoUserService;

	@Resource(name = "menuService")
	private MenuService menuService;

	@Resource(name = "logsService")
	private LogsService logsService;

	private static final String validUrl   =  RequestMappingConstants.WEB_MAIN;
	private static final String invalidUrl = RequestMappingConstants.WEB_LOGIN;

	private static final String howto_sso  = "auto"; //"signup";
	private static final String signupUrl  = RequestMappingConstants.WEB_SIGNUP_FORM;
	

    @PostConstruct
	public void initIt() throws NullPointerException {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}

    /**
     * WEB 로그인 액션
     * @throws IOException 
     * @throws NullPointerException 
     */
    @RequestMapping(value = {RequestMappingConstants.WEB_MEM_LOGIN},
					method = {RequestMethod.POST})
	public String webLogin(HttpServletRequest request,
			   		 	   HttpServletResponse response,
			   		 	   @RequestParam(value="user_id", required=false) String userId,
			   		 	   @RequestParam(value="user_pass", required=false) String userPwd,
			   		 	   @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO) throws SQLException, NullPointerException, IOException
	{
    	response.setCharacterEncoding("UTF-8");
    	HttpSession session =  getSession();
    	if(session == null ){
    		session = request.getSession(); // 세션 없으면 세션 생성
    	}

    	// 파라미터로 전달된 csrf 토큰 값
    	String _csrf = request.getParameter("_csrf");

    	// 세션에 저장된 토큰 값과 일치 여부 검증
    	if (request.getSession().getAttribute("CSRF_TOKEN").equals(_csrf))
    	{
	    	HashMap<String, Object> param = new HashMap<String, Object>();
	    	param.put("KEY", RequestMappingConstants.KEY);
	    	param.put("PREFIX", "LOG");
	    	param.put("USER_ID", userId);
	    	param.put("USER_PASS", userPwd);
	    	param.put("USER_SSO", "N");
	    	param.put("PROGRM_URL", request.getRequestURI());
	    	param.put("USER_AGENT", request.getHeader("User-Agent"));
	    	param.put("USER_IPADDR", (request.getHeader("X-FORWARDED-FOR") == null ? request.getRemoteAddr() : request.getHeader("X-FORWARDED-FOR")));

	    	
	    	String referer = request.getHeader("referer");
	    	if(referer != null && "".equals(referer) == false)
	    	{
				URL url = new URL(referer);
				String host = url.getHost();

		    	/* 사용자 존재 확인 */
		    	String check = userService.checkExistUserId(param);
		    	if(check == null || "N".equals(check))
		    	{
		    		/* 로그인 시도 기록 */
		    		param.put("REASON","CD00000028");
		    		logsService.insertUserLoginAttemptLogs(param);

		    		jsHelper.Alert("미등록 계정 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
		     	   	jsHelper.RedirectUrl(invalidUrl);
		     	}
		    	else
		    	{
		        	/* 사용자 비밀번호 확인 */
		    		check = userService.checkValidPassword(param);
			    	if(check != null && "N".equals(check))
			    	{
			     		/* 로그인 시도 기록 */
			    		param.put("REASON","CD00000026");
			     		logsService.insertUserLoginAttemptLogs(param);

			     		String temp = userService.selectUserLoginAttempt(param);
			     		int attemptCnt = Integer.valueOf(temp);
			     		if(attemptCnt + 1 <= RequestMappingConstants.CONST_LOGIN_ATTEMPT)
			     		{
			     			/* 로그인 횟수 업데이트  */
			     			param.put("ATTEMPT_CNT", Integer.valueOf(attemptCnt) + 1);
			        		userService.updateUserLoginAttempt(param);

				    		jsHelper.Alert("아이디 또는 비밀번호가 정확하지 않습니다.\\n\\n다시 확인하여 주시기 바랍니다.");
				     	   	jsHelper.RedirectUrl(invalidUrl);
			     		}
			     		else
			     		{
			     			/* 로그인 잠금  업데이트 */
			        		param.put("LOCK_YN", "Y");
			        		param.put("ATTEMPT_CNT", Integer.valueOf(attemptCnt) + 1);
			        		userService.updateUserLoginLock(param);

				      	   	jsHelper.Alert("로그인 시도 " + RequestMappingConstants.CONST_LOGIN_ATTEMPT + "회 초과로 계정이 잠겼습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
				      	   	jsHelper.RedirectUrl(invalidUrl);
			     		}
			    	}
			    	else
				    {
			    		/* 사용자 정보 확인 */ 
				    	HashMap<String, Object> data = userService.selectUserInfo(param);

				    	if(("N").equals(data.get("confm_yn")))
				      	{
				    		/* 로그인 시도 기록 */
				    		param.put("REASON","CD00000029");
				    		logsService.insertUserLoginAttemptLogs(param);

				     	   	jsHelper.Alert("현재 승인 대기 중 계정 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
				     	   	jsHelper.RedirectUrl(invalidUrl);
				     	}
				    	else if(("N").equals(data.get("use_yn")))
				      	{
				    		/* 로그인 시도 기록 */
				    		param.put("REASON","CD00000031");
				    		logsService.insertUserLoginAttemptLogs(param);

				     		jsHelper.Alert("현재 삭제 된 계정 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
				     		jsHelper.RedirectUrl(invalidUrl);
				     	}
				    	else if(("Y").equals(data.get("lock_yn")))
				    	{
				    		/* 로그인 시도 기록 */
				    		param.put("REASON","CD00000030");
				    		logsService.insertUserLoginAttemptLogs(param);

				      	   	jsHelper.Alert("현재 잠긴 계정 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
				      	   	jsHelper.RedirectUrl(invalidUrl);
					    }
				    	else
				    	{
				    		/* 세션 생성 */
				        	commonSessionVO.setUser_id((String)data.get("user_id"));
				        	commonSessionVO.setUser_name((String)data.get("user_nm"));
				        	commonSessionVO.setUser_position((String)data.get("dept_nm"));
				        	commonSessionVO.setUser_admin_yn((String)data.get("p_admin_yn"));
				        	commonSessionVO.setUser_auth((String)data.get("p_auth_no"));
				        	commonSessionVO.setUser_auth_desc((String)data.get("p_auth_desc"));
				        	commonSessionVO.setUser_lauth((String)data.get("l_auth_no"));
				        	commonSessionVO.setUser_lauth_desc((String)data.get("l_auth_desc"));

				        	session.setAttribute("userId", (String)data.get("user_id"));
			        		session.setAttribute("userNm", (String)data.get("user_nm"));
			        		session.setAttribute("deptNm", (String)data.get("dept_nm"));
			        		session.setAttribute("userAdminYn", (String)data.get("p_admin_yn"));
			        		session.setAttribute("userProgrmAuth", (String)data.get("p_auth_no"));
			        		session.setAttribute("userLayerAuth", (String)data.get("l_auth_no"));
			        		
			        		try {
			        			session.setAttribute("userTopMenu", menuService.selectTopMenuInfo(param));
								session.setAttribute("userSubMenu", menuService.selectSubMenuInfo(param));
								session.setAttribute("userMoveMenu", menuService.selectFirstMoveMenuInfo(param));
							} catch (SQLException e1) {
								// TODO Auto-generated catch block
								logger.error("이력 등록 실패");
							}
			        		
			        		session.setAttribute("ssoLogin", "N");
			        		session.setAttribute("apiKey", "");
			        		session.setAttribute("apiHost", host);
			        		session.setMaxInactiveInterval(RequestMappingConstants.MAX_SESSION_TIMEOUT);
			        		session.setAttribute("SessionVO", commonSessionVO);

			        		
			        		
			    			try
			    			{
				        		/* 로그인 잠금 해제 */
				        		param.put("LOCK_YN", "N");
				        		param.put("ATTEMPT_CNT", 0);
				        		userService.updateUserLoginLock(param);

			    				/* LOGIN 이력 등록 */
			    				logsService.insertUserProgrmLogs(param);
			    			}
			    			catch (SQLException e)
			    			{
			    				logger.error("이력 등록 실패");
			    			}
			    			
			    			jsHelper.RedirectUrl(validUrl);
			    			
			    			
				    	}
				    }
		    	}
	    	}
	    	else
	    	{
	    		/* 로그인 시도 기록 */
	    		param.put("REASON","CD00000027");
	    		logsService.insertUserLoginAttemptLogs(param);

	    		jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
	     	   	jsHelper.RedirectUrl(invalidUrl);
	    	}
    	}
    	else
    	{
    		response.sendRedirect(invalidUrl);
    	}

    	return null;
	}

    /**
     *  API SSO 로그인 액션
     */
    @RequestMapping(value = {RequestMappingConstants.WEB_SSO_LOGIN},
					method = {RequestMethod.GET, RequestMethod.POST})
	public String apiSsoLogin(HttpServletRequest request,
			   		 	   	  HttpServletResponse response,
			   		 	   	  @RequestParam(value="user_id", required=true) String userId,
			   		 	   	  @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO) throws SQLException, NullPointerException, IOException
	{
    	response.setCharacterEncoding("UTF-8");

    	HttpSession session =  getSession();
    	if(session == null ){
    		session = request.getSession(); // 세션 없으면 세션 생성
    	}
    
    	HashMap<String, Object> param = new HashMap<String, Object>();
    	param.put("KEY", RequestMappingConstants.KEY);
    	param.put("PREFIX", "LOG");
    	param.put("USER_ID", userId);
    	param.put("USER_PASS", "");
    	param.put("USER_SSO", "Y");
    	param.put("PROGRM_URL", request.getRequestURI());
    	param.put("USER_AGENT", request.getHeader("User-Agent"));
    	param.put("USER_IPADDR", (request.getHeader("X-FORWARDED-FOR") == null ? request.getRemoteAddr() : request.getHeader("X-FORWARDED-FOR")));

    	//String referer = request.getHeader("referer");
    	String referer = "http://127.0.0.1:38080/";
    	/*if(referer != null && "".equals(referer) == false)
    	{*/
			URL url = new URL(referer);
			String host = url.getHost();

	    	/* 사용자 존재 확인 */
	    	String check = userService.checkExistUserId(param);
	    	if(check == null || "N".equals(check))
	    	{
	    		/* 로그인 시도 기록 */
	    		param.put("REASON","CD00000028");
	    		logsService.insertUserLoginAttemptLogs(param);

				/* SSO 처리 방안 */
	    		if("signup".equals(howto_sso) == true)
	    		{
		    		/* 신규 가입으로 처리 */
		    		jsHelper.Alert("미등록 계정 입니다.\\n\\n신규 사용자 등록 페이지로 이동합니다.");
		     	   	jsHelper.RedirectUrl(signupUrl + "?user_id=" + userId);

		     	   	return null;
	    		}
	    		else
	    		{
	    	    	try
	    	    	{
		    			/* SSO연계 정보 추출  */
		    			Map<String, Object> data = ssoUserService.selectUserInfo(param);

		    			/* 사용자 자동 등록 */
		    	    	String userNm = (String)data.get("USER_HNGLD_NM");
		    	    	String userPwd = RequestMappingConstants.KEY_P;
		    	    	String userDeptNm = (String)data.get("DEPT_NM");

		    	    	HashMap<String, Object> useInfo = new HashMap<String, Object>();
		    	    	useInfo.put("KEY", RequestMappingConstants.KEY);
		    	    	useInfo.put("USER_ID", userId);
		    	    	useInfo.put("USER_NM", userNm);
		    	    	useInfo.put("PASSWORD", userPwd);
		    	    	useInfo.put("DEPT_NM", userDeptNm);
		    	    	useInfo.put("TELNO", "");
		    	    	useInfo.put("USE_YN", "Y");
		    	    	useInfo.put("SBSCRB_CD", "CD00000043");
		    	    	useInfo.put("CONFM_YN", "Y");

	    	    		userService.insertUserInfo(useInfo);
	    	    	}
	    	    	catch(SQLException e)
	    	    	{
			    		/* 신규 가입으로 처리 */
			    		jsHelper.Alert("미등록 계정 입니다.\\n\\n신규 사용자 등록 페이지로 이동합니다.");
			     	   	jsHelper.RedirectUrl(signupUrl + "?user_id=" + userId);

			     	   	return null;
	    	    	}
	    		}
	     	}

    		/* 사용자 정보 확인 */
	    	HashMap<String, Object> data = userService.selectUserInfo(param);
	    	
	    	// sso 로그인 부서 업데이트
	    	Map<String, Object> ssoData = ssoUserService.selectUserInfo(param);
	    	
	    	HashMap<String, Object> deptParam = new HashMap<String, Object>();
	    	
	    	
			String dept = (String)data.get("dept_nm");
	    	String ssoDept = (String)ssoData.get("DEPT_NM");
	    	
	    	deptParam.put("KEY", RequestMappingConstants.KEY);
	    	deptParam.put("DEPT_NM", ssoDept);
	    	deptParam.put("USER_ID", userId);
	    	

	    
	    	
	    	if(!dept.equals(ssoDept)) {
	    		userService.userDeptUpdate(deptParam);
	    	}
	    	
	    	

	    	if(("N").equals(data.get("confm_yn")))
	      	{
	    		/* 로그인 시도 기록 */
	    		param.put("REASON","CD00000029");
	    		logsService.insertUserLoginAttemptLogs(param);

	     	   	jsHelper.Alert("현재 승인 대기 중 계정 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
	     	   	jsHelper.RedirectUrl(invalidUrl);
	     	}
	    	else if(("N").equals(data.get("use_yn")))
	      	{
	    		/* 로그인 시도 기록 */
	    		param.put("REASON","CD00000031");
	    		logsService.insertUserLoginAttemptLogs(param);

	     		jsHelper.Alert("현재 삭제 된 계정 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
	     		jsHelper.RedirectUrl(invalidUrl);
	     	}
	    	else if(("Y").equals(data.get("lock_yn")))
	    	{
	    		/* 로그인 시도 기록 */
	    		param.put("REASON","CD00000030");
	    		logsService.insertUserLoginAttemptLogs(param);

	      	   	jsHelper.Alert("현재 잠긴 계정 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
	      	   	jsHelper.RedirectUrl(invalidUrl);
		    }
	    	else
	    	{
	    		/* 세션 생성 */
	        	commonSessionVO.setUser_id((String)data.get("user_id"));
	        	commonSessionVO.setUser_name((String)data.get("user_nm"));
	        	commonSessionVO.setUser_position((String)ssoData.get("DEPT_NM"));
	        	commonSessionVO.setUser_admin_yn((String)data.get("p_admin_yn"));
	        	commonSessionVO.setUser_auth((String)data.get("p_auth_no"));
	        	commonSessionVO.setUser_auth_desc((String)data.get("p_auth_desc"));
	        	commonSessionVO.setUser_lauth((String)data.get("l_auth_no"));
	        	commonSessionVO.setUser_lauth_desc((String)data.get("l_auth_desc"));

	        	session.setAttribute("userId", (String)data.get("user_id"));
        		session.setAttribute("userNm", (String)data.get("user_nm"));
        		session.setAttribute("deptNm", (String)ssoData.get("DEPT_NM"));
        		session.setAttribute("userAdminYn", (String)data.get("p_admin_yn"));
        		session.setAttribute("userProgrmAuth", (String)data.get("p_auth_no"));
        		session.setAttribute("userLayerAuth", (String)data.get("l_auth_no"));
        		try {
					session.setAttribute("userTopMenu", menuService.selectTopMenuInfo(param));
					session.setAttribute("userSubMenu", menuService.selectSubMenuInfo(param));
	        		session.setAttribute("userMoveMenu", menuService.selectFirstMoveMenuInfo(param));
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					logger.error("이력 등록 실패");
				}
        		
        		session.setAttribute("ssoLogin", "Y");
        		session.setAttribute("apiKey", "");
        		session.setAttribute("apiHost", host);
        		session.setMaxInactiveInterval(RequestMappingConstants.MAX_SESSION_TIMEOUT);
        		session.setAttribute("SessionVO", commonSessionVO);

    			try
    			{
	        		/* 로그인 잠금 해제 */
	        		param.put("LOCK_YN", "N");
	        		param.put("ATTEMPT_CNT", 0);
	        		userService.updateUserLoginLock(param);

    				/* LOGIN 이력 등록 */
    				logsService.insertUserProgrmLogs(param);
    			}
    			catch (SQLException e)
    			{
    				logger.error("이력 등록 실패");
    			}

        		/* 메인 이동 */
    			jsHelper.RedirectUrl(validUrl);
	    	}
    	/*}
    	else
    	{
    		 로그인 시도 기록
    		param.put("REASON","CD00000027");
    		logsService.insertUserLoginAttemptLogs(param);

    		jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
     	   	jsHelper.RedirectUrl(invalidUrl);
    	}*/

    	return null;
	}


    /**
     *  API KEY 로그인 액션
     */
    @RequestMapping(value = {RequestMappingConstants.WEB_KEY_LOGIN},
					method = {RequestMethod.GET, RequestMethod.POST})
	public String apiKeyLogin(HttpServletRequest request,
			   		 	   HttpServletResponse response,
			   		 	   @RequestParam(value="apiKey", required=false) String apiKey,
			   		 	   @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO) throws SQLException, NullPointerException, IOException
	{
    	response.setCharacterEncoding("UTF-8");

    	HttpSession session =  getSession();
    	if(session == null ){
    		session = request.getSession(); // 세션 없으면 세션 생성
    	}

    	HashMap<String, Object> param = new HashMap<String, Object>();
    	param.put("KEY", RequestMappingConstants.KEY);
    	param.put("PREFIX", "LOG");
    	param.put("API_KEY", apiKey);
    	param.put("PROGRM_URL", request.getRequestURI());
    	param.put("USER_AGENT", request.getHeader("User-Agent"));
    	param.put("USER_IPADDR", (request.getHeader("X-FORWARDED-FOR") == null ? request.getRemoteAddr() : request.getHeader("X-FORWARDED-FOR")));

    	/* API KEY 접근 경로 확인 */
    	//String referer = request.getHeader("referer");
    	String referer = "http://esd2.syesd.co.kr:22122/";
    	/*if(referer != null && "".equals(referer) == false)
    	{*/
	    	/* API KEY 존재 확인 */
	    	String check = userService.checkExistApiKey(param);
	    	if(check == null || "N".equals(check))
	    	{
	    		/* API KEY 로그인 시도 기록 */
	    		param.put("REASON","CD00000036");
	     	   	logsService.insertApiKeyLoginAttemptLogs(param);

	    		jsHelper.Alert("미등록 API KEY 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
	     	   	jsHelper.RedirectUrl(invalidUrl);
	     	}
	    	else
	    	{
	    		/* API 접속 HOST 확인 */
	    		URL url = new URL(referer);
	    		String host = url.getHost();

	    		param.put("API_HOST", host);

	    		/* API KEY 정보 확인 */
		    	HashMap<String, Object> data = userService.selectApiKeyInfo(param);

		    	String user_yn = (String)data.get("use_yn");
		    	String confm_yn = (String)data.get("confm_yn");
		    	String product_server = (String)data.get("product_server");
		    	String develop_server1 = (String)data.get("develop_server1");
		    	String develop_server2 = (String)data.get("develop_server2");
		    	String develop_server1_expire = (String)data.get("develop_server1_expire");
		    	String develop_server2_expire = (String)data.get("develop_server2_expire");

		    	if(("N").equals(confm_yn))
		      	{
		    		/* API KEY 로그인 시도 기록 */
		    		param.put("REASON","CD00000037");
		     	   	logsService.insertApiKeyLoginAttemptLogs(param);

		     	   	jsHelper.Alert("현재 승인 대기 중 API KEY 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
		     	   	jsHelper.RedirectUrl(invalidUrl);
		     	}
		    	else if(("N").equals(user_yn))
		      	{
		    		/* API KEY 로그인 시도 기록 */
		    		param.put("REASON","CD00000039");
		     	   	logsService.insertApiKeyLoginAttemptLogs(param);

		     		jsHelper.Alert("현재 삭제 된 API KEY 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
		     		jsHelper.RedirectUrl(invalidUrl);
		     	}
		    	else if(("N").equals(product_server) && ((("Y").equals(develop_server1) && ("Y").equals(develop_server1_expire)) ||
		    											 (("Y").equals(develop_server2) && ("Y").equals(develop_server2_expire))))
		    	{
		    		/* API KEY 로그인 시도 기록 */
		    		param.put("REASON","CD00000038");
		     	   	logsService.insertApiKeyLoginAttemptLogs(param);

		     	   	jsHelper.Alert("접속 IP(" + host + ")는 사용 기간이 만료되었습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
		     	   	jsHelper.RedirectUrl(invalidUrl);
		    	}
		    	else if(("N").equals(product_server) && ("N").equals(develop_server1) && ("N").equals(develop_server2))
		    	{
		    		/* API KEY 로그인 시도 기록 */
		    		param.put("REASON","CD00000035");
		     	   	logsService.insertApiKeyLoginAttemptLogs(param);

		     	   	jsHelper.Alert("접속 허용된 서버가 아닙니다.\\n\\n관리자에게 문의하시길 바랍니다.");
		     	   	jsHelper.RedirectUrl(invalidUrl);
		    	}
		    	else
		    	{
		    		/* 세션 생성 */
		        	commonSessionVO.setUser_id((String)data.get("user_id"));
		        	commonSessionVO.setUser_name((String)data.get("user_nm"));
		        	commonSessionVO.setUser_position((String)data.get("dept_nm"));
		        	commonSessionVO.setUser_admin_yn("N");
		        	commonSessionVO.setUser_auth((String)data.get("p_auth_no"));
		        	commonSessionVO.setUser_auth_desc((String)data.get("p_auth_desc"));
		        	commonSessionVO.setUser_lauth((String)data.get("l_auth_no"));
		        	commonSessionVO.setUser_lauth_desc((String)data.get("l_auth_desc"));

		        	session.setAttribute("userId", (String)data.get("user_id"));
	        		session.setAttribute("userNm", (String)data.get("user_nm"));
	        		session.setAttribute("deptNm", (String)data.get("dept_nm"));
	        		session.setAttribute("userAdminYn", "N");
	        		session.setAttribute("userProgrmAuth", (String)data.get("p_auth_no"));
	        		session.setAttribute("userLayerAuth", (String)data.get("l_auth_no"));
	        		try {
						session.setAttribute("userTopMenu", menuService.selectTopMenuInfo(param));
						session.setAttribute("userSubMenu", menuService.selectSubMenuInfo(param));
		        		session.setAttribute("userMoveMenu", menuService.selectFirstMoveMenuInfo(param));
					} catch (SQLException e1) {
						// TODO Auto-generated catch block
						logger.error("이력 등록 실패");
					}
	        		session.setAttribute("ssoLogin", "N");
	        		session.setAttribute("apiKey", apiKey);
	        		session.setAttribute("apiHost", host);
	        		session.setAttribute("apiParam", request.getQueryString());
	        		session.setMaxInactiveInterval(RequestMappingConstants.MAX_SESSION_TIMEOUT);
	        		session.setAttribute("SessionVO", commonSessionVO);

	    			try
	    			{
	    				param.put("USER_ID", (String)data.get("user_id"));

	    				/* LOGIN 이력 등록 */
	    				logsService.insertUserProgrmLogs(param);
	    			}
	    			catch (SQLException e)
	    			{
	    				logger.error("이력 등록 실패");
	    			}

	        		/* 메인 이동 */
	    			jsHelper.RedirectUrl(validUrl);
		    	}
	    	}
    	/*}
    	else
    	{
    		 API KEY 로그인 시도 기록
    		param.put("REASON","CD00000034");
     	   	logsService.insertApiKeyLoginAttemptLogs(param);

    		jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
     	   	jsHelper.RedirectUrl(invalidUrl);
     	}*/

    	return null;
	}

    /**
     * 로그아웃 액션
     * @throws IOException 
     * @throws NullPointerException 
     */
    @RequestMapping(value = RequestMappingConstants.WEB_LOGOUT,
					method = RequestMethod.GET)
    public String logut(HttpServletRequest request,
				   		HttpServletResponse response,
    					@ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO) throws NullPointerException, IOException 
    {
    	response.setCharacterEncoding("UTF-8");

        HttpSession session = getSession();
        if (session != null) {
        	/* LOGOUT 이벤트  */
        	session.invalidate();
        }

		/* 메인 이동 */
		jsHelper.RedirectUrl(invalidUrl);

        return null;
    }

}
