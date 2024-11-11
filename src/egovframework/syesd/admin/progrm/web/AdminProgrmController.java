package egovframework.syesd.admin.progrm.web;

import java.io.IOException;
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
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.zaol.common.OraclePaginationInfo;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;

@Controller
public class AdminProgrmController extends BaseController  {

	private static Logger logger = LogManager.getLogger(AdminProgrmController.class);

	private ObjectMapper mapper;
	
	@Resource(name = "propertiesService") 
	private EgovPropertyService propertiesService;
	
	@Resource(name = "adminProgrmService") 
	private AdminProgrmService adminProgrmService;
	
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
    
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_PROGRM_AUTH, 
			method = {RequestMethod.GET, RequestMethod.POST})
	public String mngProgrmAuth(HttpServletRequest request, 
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
		        	
		        	view01Cnt.setTotalRecordCount(adminProgrmService.selectProgrmAuthPagingListCount(query));
		        	
			        model.addAttribute("progrmInfoList"	  , adminProgrmService.selectProgrmAuthPagingList(query));
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
		        	
		        	return "admin/auth/progAuthMapng.page";
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
    
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_PROGRM_AUTH_DETAIL, 
				method = RequestMethod.POST)    
	public ModelAndView mngProgrmAuthDetail(HttpServletRequest request, 
						              HttpServletResponse response,
						   		 	  @RequestParam(value="id", required=true) String p_auth_no) throws SQLException, NullPointerException, IOException
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
		        	if("".equals(p_auth_no) == false)
		        	{		
						HashMap<String, Object> query = new HashMap<String, Object>();
						query.put("KEY", RequestMappingConstants.KEY);
						query.put("P_AUTH_NO", p_auth_no);
						
						ModelAndView modelAndView = new ModelAndView();
						modelAndView.addObject("progrmInfo", adminProgrmService.selectProgrmAuthList(query));
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
    
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_PROGRM_AUTH_EDIT, 
				method = RequestMethod.POST)    
	public ModelAndView mngProgrmAuthEdit(HttpServletRequest request, 
						              HttpServletResponse response,
						   		 	  @RequestParam(value="id", required=true) String p_auth_no,
						   		 	  @RequestParam(value="use_yn", required=false) String use_yn,
						   		 	  @RequestParam(value="admin_yn", required=false) String admin_yn,
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
		        	if(use_yn != null || admin_yn != null || bass_yn != null)
		        	{
		            	HashMap<String, Object> query = new HashMap<String, Object>();
		            	query.put("KEY", RequestMappingConstants.KEY);
		            	query.put("P_AUTH_NO",  p_auth_no);
		            	query.put("UPD_USER",  userId);
		            	
		            	if(use_yn != null && "".equals(use_yn) == false)
		            		query.put("USE_YN",  use_yn);
		            	
		            	if(admin_yn != null && "".equals(admin_yn) == false)
		            		query.put("ADMIN_YN",  admin_yn);
		            	
		            	if(bass_yn != null && "".equals(bass_yn) == false)
		            		query.put("BASS_YN",  bass_yn);
		    
		                ModelAndView modelAndView = new ModelAndView();
	                	modelAndView.addObject("progrmInfo", adminProgrmService.updateProgrmAuth(query)); 	// fake
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
    
    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_PROGRM_AUTH_ADD},
			method = {RequestMethod.POST})
	public ModelAndView mngProgrmAuthInsert(HttpServletRequest request, 
			   	   	  		      HttpServletResponse response,
			   	   	  		      @RequestParam(value="auth_desc",  required=false) String auth_desc,
			   	   	  		      @RequestParam(value="admin_yn",  required=true) String admin_yn,
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
					if("".equals(auth_desc) == false && "".equals(admin_yn) == false && "".equals(bass_yn) == false && "".equals(use_yn) == false)
					{
					   	/* 컨텐츠 */
					   	HashMap<String, Object> query = new HashMap<String, Object>();
					   	query.put("KEY", RequestMappingConstants.KEY);
					   	query.put("INS_USER", userId);
					   	query.put("PREFIX", "AUTH");
					   	query.put("AUTH_DESC", auth_desc);
					   	query.put("ADMIN_YN", admin_yn);
					   	query.put("BASS_YN", bass_yn);
					   	query.put("USE_YN", use_yn);
					   	
					   	ModelAndView modelAndView = new ModelAndView();
					   	modelAndView.addObject("progrmInfo", adminProgrmService.insertProgrmAuth(query));
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
    
    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_PROGRM_AUTH_PROGRMS},
			method = {RequestMethod.POST})
	public ModelAndView mngProgrmListByAuthNo(HttpServletRequest request, 
			   	   	  		      HttpServletResponse response,
			   	   	  		      @RequestParam(value="id",  required=true) String p_auth_no,
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
					if("".equals(p_auth_no) == false)
					{
					   	/* 컨텐츠 */
					   	HashMap<String, Object> query = new HashMap<String, Object>();
					   	query.put("KEY", RequestMappingConstants.KEY);
					   	query.put("P_AUTH_NO", p_auth_no);
					   	
					   	ModelAndView modelAndView = new ModelAndView();
					   	modelAndView.addObject("progrmInfo", adminProgrmService.selectProgrmListByAuthNo(query));
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
    
    
    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_PROGRM_AUTH_PROGRMS_EDIT},
			method = {RequestMethod.POST})
	public ModelAndView mngProgrmListEditByAuthNo(HttpServletRequest request, 
			   	   	  		      HttpServletResponse response,
			   	   	  		      @RequestParam(value="t_p_auth_no",  required=true) String p_auth_no,
			   	   	  		      @RequestParam(value="t_progrms",  required=true) String[] progrms,
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
					if("".equals(p_auth_no) == false && progrms != null)
					{
					   	/* 컨텐츠 */
					   	HashMap<String, Object> query = new HashMap<String, Object>();
					   	query.put("KEY", RequestMappingConstants.KEY);
					   	query.put("INS_USER", userId);
					   	query.put("PREFIX", "LOG");
					   	query.put("P_AUTH_NO", p_auth_no);
					   	query.put("PROGRMS", progrms);
					   	
					   	ModelAndView modelAndView = new ModelAndView();
					   	modelAndView.addObject("progrmInfo", adminProgrmService.insertProgrmListByAuthNo(query));
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
    
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_PROGRM, 
			method = {RequestMethod.GET, RequestMethod.POST})
	public String mngProgrm(HttpServletRequest request, 
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
		        	query.put("USE_YN", 		"");
		        	query.put("MENU_YN", 		"Y");
		        	
		        	List progrmList = adminProgrmService.selectProgrmList(query);
		        	
		        	view01Cnt.setTotalRecordCount(progrmList.size());
		        	
			        model.addAttribute("progrmList"	  	  , progrmList);
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
		        	
		        	return "admin/auth/progManage.page";
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
    
    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_PROGRM_NUM_BYID},
			method = {RequestMethod.POST})
	public ModelAndView mngProgrmNumById(HttpServletRequest request, 
			   	   	  		      HttpServletResponse response,
			   	   	  		      @RequestParam(value="id",  required=true) String p_progrm_no,
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
				   	query.put("P_PROGRM_NO", p_progrm_no);
				   	
				   	ModelAndView modelAndView = new ModelAndView();
				   	modelAndView.addObject("progrmInfo", adminProgrmService.selectProgrmNumById(query));
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
}
