package egovframework.syesd.admin.apikey.web;

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
import egovframework.syesd.admin.apikey.service.AdminApikeyService;
import egovframework.syesd.admin.progrm.service.AdminProgrmService;
import egovframework.syesd.admin.layer.service.AdminLayerService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.zaol.common.OraclePaginationInfo;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;

@Controller
public class AdminApikeyController extends BaseController  {

	private static Logger logger = LogManager.getLogger(AdminApikeyController.class);
	
	private ObjectMapper mapper;
	
	@Resource(name = "propertiesService") 
	private EgovPropertyService propertiesService;

	@Resource(name = "adminApikeyService") 
	private AdminApikeyService adminApikeyService;
	
	@Resource(name = "adminProgrmService") 
	private AdminProgrmService adminProgrmService;
	
	@Resource(name = "adminLayerService") 
	private AdminLayerService adminLayerService;
	
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
    
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_APIKEY, 
					method = {RequestMethod.GET, RequestMethod.POST})
	public String mngApiKey(HttpServletRequest request, 
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
		        	
		        	List apiKeyList = adminApikeyService.selectApikeyInfos(query);
		        	
		        	view01Cnt.setTotalRecordCount(adminApikeyService.selectApikeyInfosCount(query));
		
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
			        model.addAttribute("apiKeyList"		  , apiKeyList);
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
		        	
		        	return "admin/openapi/apikeyManage.page";
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
    
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_APIKEY_DETAIL, 
				method = {RequestMethod.POST})
	public ModelAndView mngApikeyDetail(HttpServletRequest request, 
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
		                modelAndView.addObject("apikeyInfo", adminApikeyService.selectApikeyInfoDetail(query));
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
    
    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_APIKEY_EDIT},
				 	method = {RequestMethod.POST})
	public ModelAndView mngApikeyUpdate(HttpServletRequest request, 
				   	   	  		      HttpServletResponse response,
				   	   	  		      @RequestParam(value="id",  required=true) String user_id,
				   	   	  		      @RequestParam(value="sys_nm",  required=true) String sys_nm,
				   	   	  		      @RequestParam(value="site_url",  required=true) String site_url,
				   	   	  		      @RequestParam(value="sys_desc",  required=false) String sys_desc,
				   	   	  		      @RequestParam(value="use_purps",  required=false) String use_purps,
				   	   	  		      @RequestParam(value="devlop_server1",  required=true) String devlop_server1,
				   	   	  		      @RequestParam(value="use_last_dt1",  required=true) String use_last_dt1,
				   	   	  		      @RequestParam(value="devlop_server2",  required=false) String devlop_server2,
				   	   	  		      @RequestParam(value="use_last_dt2",  required=false) String use_last_dt2,			   	   	  		      
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
					if("".equals(user_id) == false)
					{
					   	/* 컨텐츠 */
					   	HashMap<String, Object> query = new HashMap<String, Object>();
					   	query.put("KEY", RequestMappingConstants.KEY);
					   	query.put("PREFIX", "LOG");
					   	query.put("INS_USER", userId);
					   	query.put("UPD_USER", userId);
					   	query.put("USER_ID", user_id);
					   	query.put("SYS_NM", sys_nm);
					   	query.put("SITE_URL", site_url);
					   	query.put("SYS_DESC", sys_desc);
					   	query.put("USE_PURPS", use_purps);
					   	query.put("DEVLOP_SERVER1", devlop_server1);
					   	query.put("DEVLOP_SERVER2", devlop_server2);
					   	query.put("USE_LAST_DT1", use_last_dt1);
					   	query.put("USE_LAST_DT2", use_last_dt2);
				   	
					   	ModelAndView modelAndView = new ModelAndView();
					   	modelAndView.addObject("apikeyInfo", adminApikeyService.updateApikey(query));
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
    
    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_APIKEY_ADD},
					method = {RequestMethod.POST})
	public ModelAndView mngApikeyInsert(HttpServletRequest request, 
				   	   	  		      HttpServletResponse response,
				   	   	  		      @RequestParam(value="dept_nm",  required=false) String dept_nm,
				   	   	  		      @RequestParam(value="user_nm",  required=true) String user_nm,
				   	   	  		      @RequestParam(value="telno",  required=false) String telno,
				   	   	  		      @RequestParam(value="email",  required=false) String email,
				   	   	  		      @RequestParam(value="p_auth_no",  required=true) String p_auth_no,
				   	   	  		      @RequestParam(value="l_auth_no",  required=true) String l_auth_no,
				   	   	  		      @RequestParam(value="sys_nm",  required=true) String sys_nm,
				   	   	  		      @RequestParam(value="site_url",  required=true) String site_url,
				   	   	  		      @RequestParam(value="sys_desc",  required=false) String sys_desc,
				   	   	  		      @RequestParam(value="use_purps",  required=false) String use_purps,
				   	   	  		      @RequestParam(value="devlop_server1",  required=true) String devlop_server1,
				   	   	  		      @RequestParam(value="devlop_server2",  required=false) String devlop_server2,
				   	   	  		      @RequestParam(value="use_last_dt1",  required=true) String use_last_dt1,
				   	   	  		      @RequestParam(value="use_last_dt2",  required=false) String use_last_dt2,
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
					if("".equals(user_nm) == false && "".equals(sys_nm) == false && "".equals(site_url) == false&& "".equals(devlop_server1) == false&& "".equals(use_last_dt1) == false )
					{
					   	/* 컨텐츠 */
					   	HashMap<String, Object> query = new HashMap<String, Object>();
					   	query.put("KEY", RequestMappingConstants.KEY);
					   	
					   	// 생성 사용자
					   	query.put("INS_USER", userId);

					   	// 사용자 <-> APIKEY 연결
					   	query.put("USER_ID", user_nm);
					   	
					   	// 사용자 등록
					   	query.put("DEPT_NM", dept_nm);
					   	query.put("USER_NM", user_nm);
					   	query.put("PASSWORD", RequestMappingConstants.KEY_P);
					   	query.put("TELNO", telno);
					   	query.put("EMAIL", email);
					   	query.put("SBSCRB_CD", "CD00000044");
					   	query.put("P_AUTH_NO", p_auth_no);
					   	query.put("L_AUTH_NO", l_auth_no);
					   	
					   	// APIKEY 등록
					   	query.put("SYS_NM", sys_nm);
					   	query.put("SITE_URL", site_url);
					   	query.put("SYS_DESC", sys_desc);
					   	query.put("USE_PURPS", use_purps);
					   	query.put("USE_LAST_DT1", use_last_dt1);
					   	query.put("DEVLOP_SERVER1", devlop_server1);
					   	query.put("USE_LAST_DT2", use_last_dt2);
					   	query.put("DEVLOP_SERVER2", devlop_server2);
					   	
					   	ModelAndView modelAndView = new ModelAndView();
					   	modelAndView.addObject("userInfo", adminApikeyService.insertUserInfo(query));
					   	modelAndView.addObject("apikeyInfo", adminApikeyService.insertApikey(query));
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
