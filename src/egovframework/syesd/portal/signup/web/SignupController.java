package egovframework.syesd.portal.signup.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.syesd.portal.user.service.UserService;
import egovframework.zaol.common.web.BaseController;

@Controller
public class SignupController extends BaseController  {

	private static Logger logger = LogManager.getLogger(SignupController.class);

	private ObjectMapper mapper;

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "userService")
	private UserService userService;

	@Resource(name = "logsService")
	private LogsService logsService;

	private static final String validUrl   = RequestMappingConstants.WEB_MAIN;
	private static final String invalidUrl = RequestMappingConstants.WEB_LOGIN;

    @PostConstruct
	public void initIt() throws NullPointerException {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}

    ////////////////////////////////////////////////////////////////////////////////
	/**
     * 1. 회원가입 폼 호출
     **/
    @RequestMapping(value = RequestMappingConstants.WEB_SIGNUP_FORM,
					method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView signupForm(HttpServletRequest  request ,
						 	 HttpServletResponse response) throws SQLException, NullPointerException, IOException 
	{
    	HttpSession session =  getSession();
    	if(session == null ){
    		session = request.getSession(); // 세션 없으면 세션 생성
    	}

    	// 세션에 토큰 저장
    	session.setAttribute("CSRF_TOKEN",UUID.randomUUID().toString());

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("user_id", request.getParameter("user_id"));
        modelAndView.addObject("sbscrb_cd", (request.getParameter("user_id") == null || request.getParameter("user_id") == "" ? "CD00000042" : "CD00000043"));
        modelAndView.setViewName("/SH/portal/user/signupForm");

		return modelAndView;
	}

    /**
     * 2. 회원 등록
     */
    @RequestMapping(value = RequestMappingConstants.WEB_SIGNUP_SUBMIT,
					method = RequestMethod.POST)
    public ModelAndView signupSubmit(HttpServletRequest  request,
                                     HttpServletResponse response) throws SQLException, NullPointerException, IOException 
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
	    	String userId = request.getParameter("user_id");
	    	String userNm = request.getParameter("user_name");
	    	String userPwd1 = request.getParameter("user_pass");
	    	String userPwd2 = request.getParameter("re_user_pass");
	    	String userDept = request.getParameter("user_position");
	    	String userTelno = request.getParameter("user_phone");
	    	String sbscrbCd = request.getParameter("sbscrb_cd");

	    	HashMap<String, Object> param = new HashMap<String, Object>();
	    	param.put("KEY", RequestMappingConstants.KEY);
	    	param.put("USER_ID", userId);
	    	param.put("USER_NM", userNm);
	    	param.put("PASSWORD", userPwd1);
	    	param.put("RE_PASSWORD", userPwd2);
	    	param.put("DEPT_NM", userDept);
	    	param.put("TELNO", userTelno.replaceAll("-", ""));
	    	param.put("USE_YN", "N");
	    	param.put("SBSCRB_CD", sbscrbCd);
	    	param.put("CONFM_YN", "N");

	    	/*
	    	if(userPwd1 == null || "".equals(userPwd1) == true)
	    	{
	    		param.put("PASSWORD", new String(KeyGenerateUtil.decrypt(KeyGenerateUtil.decodeHex("c7f1c5376dd325294d5a93e35977a502"), RequestMappingConstants.KEY_ENC)));
	    	}
	    	*/

	    	String result = "Y";
	    	try
	    	{
	    		userService.insertUserInfo(param);
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
			response.sendRedirect(invalidUrl);
		}

		return null;
    }

    ////////////////////////////////////////////////////////////////////////////////
    /**
     * 1. 아이디 찾기 폼 호출
     */
    @RequestMapping(value = RequestMappingConstants.WEB_FIND_USER_FORM,
					method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView findUserForm(HttpServletRequest  request,
    					       HttpServletResponse response) throws SQLException, NullPointerException, IOException 
    {
    	HttpSession session =  getSession();
    	if(session == null ){
    		session = request.getSession(); // 세션 없으면 세션 생성
    	}

    	// 세션에 토큰 저장
    	session.setAttribute("CSRF_TOKEN",UUID.randomUUID().toString());

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("mode", "find");
        modelAndView.setViewName("/SH/portal/user/findUserForm");

		return modelAndView;
    }

    /**
     * 2. 아이디 찾기
     */
    @RequestMapping(value = RequestMappingConstants.WEB_FIND_USER_SUBMIT,
					method = RequestMethod.POST)
    public ModelAndView findUserSubmit(HttpServletRequest  request,
            						   HttpServletResponse response) throws SQLException, NullPointerException, IOException 
	{
		request.setCharacterEncoding("UTF-8");

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
	    	param.put("USER_NAME", request.getParameter("user_name"));
	    	param.put("USER_PHONE", request.getParameter("user_phone").replaceAll("-", ""));

	    	List userIds = null;
			String result = "fail";
	    	try
	    	{
	    		userIds = userService.selectUserIdsById(param);
	    		if(userIds != null && userIds.size() > 0)
	    		{
	    			result = "success";
	    		}
	    	}
	    	catch(SQLException e)
	    	{
	    		result = "fail";
	    	}


			ModelAndView modelAndView = new ModelAndView();
			modelAndView.addObject("userIdList", userIds);
			modelAndView.addObject("mode", result);
	        //modelAndView.setViewName("/SH/user/user_find_id");
	        modelAndView.setViewName("/SH/user/findUserForm");

			return modelAndView;
		}
		else
		{
			response.sendRedirect(invalidUrl);
		}

		return null;
	}

}
