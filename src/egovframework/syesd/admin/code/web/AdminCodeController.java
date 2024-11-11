package egovframework.syesd.admin.code.web;

import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
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
import egovframework.syesd.admin.code.service.AdminCodeService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.syesd.cmmn.util.EgovProperties;
import egovframework.zaol.common.OraclePaginationInfo;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;
import oracle.jdbc.OracleDriver;
//import oracle.net.aso.p;

@Controller
public class AdminCodeController extends BaseController  {

	private static Logger logger = LogManager.getLogger(AdminCodeController.class);  

	private ObjectMapper mapper;
	
	@Resource(name = "propertiesService") 
	private EgovPropertyService propertiesService;
	
	@Resource(name = "adminCodeService") 
	private AdminCodeService adminCodeService;
	
	@Resource(name = "logsService") 
	private LogsService logsService;
	
	private static final String validUrl   = RequestMappingConstants.WEB_MAIN;
	private static final String invalidUrl =  RequestMappingConstants.WEB_LOGIN;
		
    @PostConstruct
	public void initIt() throws SQLException {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}

    @RequestMapping(value = RequestMappingConstants.WEB_MNG_CODE, 
 			method = {RequestMethod.GET, RequestMethod.POST})
 	public String mngLayerAuth(HttpServletRequest request, 
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
 		        	OraclePaginationInfo view01Cnt = new OraclePaginationInfo();
 		        	
 		        	HashMap<String, Object> query = new HashMap<String, Object>();
 		        	query.put("KEY", RequestMappingConstants.KEY);
 		        	
 		        	List codeList = adminCodeService.selectCodeGroupList(query);
 		        	
 		        	view01Cnt.setTotalRecordCount(codeList.size());
 		        	
 			        model.addAttribute("codeList",  codeList);
 			        model.addAttribute("view01Cnt", view01Cnt);
 			        
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
 		        	
 		        	return "admin/code/codeManage.page";
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
    
    // 코드 수정
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_CODE_EDIT, 
 			method = {RequestMethod.GET, RequestMethod.POST})
 	public ModelAndView mngCodeUpd(HttpServletRequest request, 
 					   	   	 HttpServletResponse response,
 					   	     @RequestParam(value="code",  required=true) String code,
 					   	     @RequestParam(value="p_code",  required=true) String p_code,
 					   	     @RequestParam(value="code_order",  required=true) int code_order,
 					   	     @RequestParam(value="code_nm",  required=true) String code_nm,
 					   	     @RequestParam(value="use_yn",  required=true) String use_yn,
 					   	     @RequestParam(value="code_desc",  required=true) String code_desc,
 					   	     @RequestParam(value="defaultorder",  required=true) int defaultorder,
 					   	     @RequestParam(value="defaultpcode",  required=true) String defaultpcode,
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
 		        	//OraclePaginationInfo view01Cnt = new OraclePaginationInfo();
 		        	
 		        	
 		        	HashMap<String, Object> query = new HashMap<String, Object>();
 		        	query.put("KEY", RequestMappingConstants.KEY);
 		        	query.put("code", code);
 		        	query.put("p_code", p_code);
 		        	query.put("code_order", code_order);
 		        	query.put("new_p_code", p_code);
 		        	query.put("new_code_order", code_order);
 		        	query.put("code_nm", code_nm);
 		        	query.put("use_yn", use_yn);
 		        	query.put("code_desc", code_desc);
 		        	query.put("UPD_USER", userId);
 		        	query.put("defaultorder", defaultorder);
 		        	query.put("defaultpcode", defaultpcode);
 		        	
 		        	logger.info("***********************************p_code : "+p_code);
 		        	logger.info("***********************************defaultpcode : "+defaultpcode);
 		        	
 		        	if(p_code.equals(defaultpcode)) {
 		        		if(code_order <= defaultorder) {
 	 		        		query.put("checkorder", true);
 	 		        	}else {
 	 		        		
 	 		        	}
 		        		adminCodeService.updateCode(query);
 		        	}else {
 		        		adminCodeService.codeorderedit(query);
 		        	}
 		        	
 		        	
 		        	
 		        	
 		        	
 		        	
 		        	ModelAndView modelAndView = new ModelAndView();
 		        	
 		        	//modelAndView.addObject("result", "Y");
 		        	modelAndView.addObject(query);
	                modelAndView.setViewName("jsonView");
 		        	
 		        	//view01Cnt.setTotalRecordCount(codeList.size());
 		        	
 			        //model.addAttribute("codeList",  codeList);
 			        //model.addAttribute("view01Cnt", view01Cnt);
 			        
 		        	/* 이력 */
 		        	/*try 
 					{
 		            	HashMap<String, Object> param = new HashMap<String, Object>();
 		            	param.put("KEY", RequestMappingConstants.KEY);
				       	param.put("PREFIX", "LOG");
 		            	param.put("USER_ID", userId);
 		            	param.put("PROGRM_URL", request.getRequestURI());
 		            	param.put("AUDIT_CD", "CD00000013");
 		            	param.put("TRGET_USER_ID", "");
 		            	
 		        		 프로그램 사용 이력 등록 
 						//logsService.insertUserProgrmLogs(param);
 						
 						 감사로그 - 목록 조회 
 						//logsService.insertUserAuditLogs(param);
 					} 
 					catch (SQLException e) 
 					{
 						//logger.error("이력 등록 실패");
 					}*/
 		        	
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
    
 // 코드 창 기본 세팅
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_CODE_ADD_SETTING, 
 			method = {RequestMethod.GET, RequestMethod.POST})
 	public ModelAndView mngCodeAddSetting(HttpServletRequest request, 
 					   	   	 HttpServletResponse response,
 					   	     @RequestParam(value="code",  required=false) String code,
 					   	     @RequestParam(value="p_code",  required=false) String p_code,
 					   	     @RequestParam(value="code_order",  required=false) String code_order,
 					   	     @RequestParam(value="code_nm",  required=false) String code_nm,
 					   	     @RequestParam(value="use_yn",  required=false) String use_yn,
 					   	     @RequestParam(value="code_desc",  required=false) String code_desc,
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
 		        	query.put("code", code);
 		        	query.put("p_code", p_code);
 		        	query.put("code_nm", code_nm);
 		        	query.put("use_yn", use_yn);
 		        	query.put("code_desc", code_desc);
 		        	
 		        	ModelAndView modelAndView = new ModelAndView();
 		        	
 		        	String topcode = adminCodeService.topcodesearch();
 		        	List p_codelist = adminCodeService.p_code_search(query);
 		        	logger.info("p_codelist"+p_codelist);
 		        	modelAndView.addObject("pcodelist", p_codelist);
 		        	
 		        	modelAndView.addObject("topcode", topcode);
 		        	if(code.equals("")) {
 		        		int maxorder = adminCodeService.maxorder(query);
 		        		modelAndView.addObject("maxorder", maxorder);
 		        	}else {
 		        		query.put("code_order", Integer.parseInt(code_order));
 		        		query.put("code", code);
 		        		int orderlist = adminCodeService.ordersearch(query);
 		        		modelAndView.addObject("orderlist", orderlist);
 		        	}
 		        	
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
 // 상위 코드 불러오기
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_P_CODE_SET, 
 			method = {RequestMethod.GET, RequestMethod.POST})
 	public ModelAndView mngPcodeSet(HttpServletRequest request, 
 					   	   	 HttpServletResponse response,
 					   	   	 @RequestParam(value="p_code",  required=false) String p_code,
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
 		        	
 		        	List pcodelist = adminCodeService.p_code_search(query);
 		        	
 		        	modelAndView.addObject("pcodelist",pcodelist);
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
    
 // 상위 코드 불러오기
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_CODE_ORDER_SET, 
 			method = {RequestMethod.GET, RequestMethod.POST})
 	public ModelAndView mngCodeOrderSet(HttpServletRequest request, 
 					   	   	 HttpServletResponse response,
 					   	   	 @RequestParam(value="p_code",  required=false) String p_code,
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
 		        	
 		        	
 		        	if(p_code.equals("")) {
 		        		int maxorder = adminCodeService.maxorder(query);
 		        		modelAndView.addObject("maxorder", maxorder);
 		        	}else {
 		        		query.put("code", p_code);
 	 		        	int editcodeorder = adminCodeService.ordersearch(query);
 	 		        	
 		        		modelAndView.addObject("orderlist", editcodeorder);
 		        	}
 		        	
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
    
    // 상위 코드 변경
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_CODE_ORDER_CHANGE, 
 			method = {RequestMethod.GET, RequestMethod.POST})
 	public ModelAndView mngCodeOrderChange(HttpServletRequest request, 
 					   	   	 HttpServletResponse response,
 					   	     @RequestParam(value="new_p_code",  required=false) String new_p_code,
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
 		        	
 		        	if(new_p_code.equals("")) {
 		        		int maxorder = adminCodeService.maxorder(query);
 		        		modelAndView.addObject("maxorder", maxorder);
 		        	}else {
 		        		query.put("code", new_p_code);
 	 		        	int orderlist = adminCodeService.ordersearch(query);
 	 		        	logger.info("orderlist : "+orderlist);
 	 		        	modelAndView.addObject("orderlist", orderlist);
 		        	}
 		        	
 		        	
 		        	
 		        	
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
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_CODE_ADD, 
 			method = {RequestMethod.GET, RequestMethod.POST})
 	public ModelAndView mngCodeAdd(HttpServletRequest request, 
 					   	   	 HttpServletResponse response,
 					   	     @RequestParam(value="new_code",  required=false) String new_code,
	 					   	 @RequestParam(value="new_p_code",  required=false) String new_p_code,
	 					   	 @RequestParam(value="new_code_nm",  required=false) String new_code_nm,
	 					   	 @RequestParam(value="new_use_yn",  required=false) String new_use_yn,
	 					   	 @RequestParam(value="new_code_order",  required=false) int new_code_order,
	 					   	 @RequestParam(value="new_code_desc",  required=false) String new_code_desc,
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
 		        	
 		        	query.put("new_code", new_code);
 		        	query.put("new_p_code", new_p_code);
 		        	query.put("new_code_nm", new_code_nm);
 		        	query.put("new_use_yn", new_use_yn);
 		        	query.put("new_code_order", new_code_order);
 		        	query.put("new_code_desc", new_code_desc);
 		        	query.put("userId", userId);
 		        	query.put("KEY", RequestMappingConstants.KEY);
 		        	
 		        	logger.info("new_code : "+new_code);
 		        	logger.info("new_p_code : "+new_p_code);
 		        	logger.info("new_code_nm : "+new_code_nm);
 		        	logger.info("new_use_yn : "+new_use_yn);
 		        	logger.info("new_code_order : "+new_code_order);
 		        	logger.info("new_code_desc : "+new_code_desc);
 		        	logger.info("userId : "+userId);
 		        	logger.info("KEY : "+RequestMappingConstants.KEY);
 		        	
 		        	adminCodeService.orderAdd(query);
 		        	
 		        	
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
    
 // 삭제 추가
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_CODE_DELETE, 
 			method = {RequestMethod.GET, RequestMethod.POST})
 	public ModelAndView mngCodeDelete(HttpServletRequest request, 
 					   	   	 HttpServletResponse response,
 					   	     @RequestParam(value="code",  required=false) String code,
	 					   	 @RequestParam(value="p_code",  required=false) String p_code,
	 					   	 @RequestParam(value="code_nm",  required=false) String code_nm,
	 					   	 @RequestParam(value="use_yn",  required=false) String use_yn,
	 					   	 @RequestParam(value="code_order",  required=false) int code_order,
	 					   	 @RequestParam(value="code_desc",  required=false) String code_desc,
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
 		        	
 		        	query.put("code", code);
 		        	query.put("p_code", p_code);
 		        	query.put("code_nm", code_nm);
 		        	query.put("use_yn", use_yn);
 		        	query.put("code_order", code_order);
 		        	query.put("code_desc", code_desc);
 		        	query.put("userId", userId);
 		        	query.put("KEY", RequestMappingConstants.KEY);
 		        	
 		        	logger.info("code : "+code);
 		        	logger.info("p_code : "+p_code);
 		        	logger.info("code_nm : "+code_nm);
 		        	logger.info("use_yn : "+use_yn);
 		        	logger.info("code_order : "+code_order);
 		        	logger.info("code_desc : "+code_desc);
 		        	logger.info("userId : "+userId);
 		        	logger.info("KEY : "+RequestMappingConstants.KEY);
 		        	
 		        	adminCodeService.codeDelete(query);
 		        	
 		        	
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
    
    
    
}
