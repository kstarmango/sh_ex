package egovframework.syesd.admin.table.web;

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
import egovframework.syesd.admin.table.service.AdminTableService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.zaol.common.OraclePaginationInfo;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;

@Controller
public class AdminTableController extends BaseController  {

	private static Logger logger = LogManager.getLogger(AdminTableController.class);  

	private ObjectMapper mapper;
	
	@Resource(name = "propertiesService") 
	private EgovPropertyService propertiesService;
	
	@Resource(name = "adminTableService") 
	private AdminTableService adminTableService;
	
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

    @RequestMapping(value = RequestMappingConstants.WEB_MNG_TABLE_COMMENT, 
 			method = {RequestMethod.GET, RequestMethod.POST})
 	public String mngTableComment(HttpServletRequest request, 
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
 		        	
 		        	return "admin/table/tableManage.page";
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

    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_TABLE_SPACE_LIST},
					method = {RequestMethod.POST})
	public ModelAndView mngTableSpaceList(HttpServletRequest request, 
						   	  		      HttpServletResponse response,
						   	  		      ModelMap model) throws SQLException, NullPointerException, IOException
	{   
		response.setCharacterEncoding("UTF-8");
		
		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.addObject("spaceInfo", adminTableService.selectTableSpaceList());
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
	    
    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_TABLE_COMMENT_LIST},
					method = {RequestMethod.POST})
	public ModelAndView mngTableCommentList(HttpServletRequest request, 
		   	   	  		      HttpServletResponse response,
		   	   	  		      @RequestParam(value="gis_yn",  required=true) String gis_yn,
				   	   	  	  @RequestParam(value="space",  required=true) String table_space,
				   	   	  	  @RequestParam(value="nm",  required=true) String table_nm,
		   	   	  		      ModelMap model) throws SQLException, NullPointerException, IOException
	{   
		response.setCharacterEncoding("UTF-8");
		
		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			HashMap<String, Object> query = new HashMap<String, Object>();
		   	query.put("TABLE_SPACE", table_space);
		   	query.put("TABLE_NM", table_nm);
		   	query.put("GIS_YN", gis_yn);
		   	
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.addObject("tableInfo", adminTableService.selectTableCommentList(query));
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
    
    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_TABLE_COMMENT_EDIT},
					method = {RequestMethod.POST})
	public ModelAndView mngTableCommentEdit(HttpServletRequest request, 
					   	   	  		      HttpServletResponse response,
					   	   	  		      @RequestParam(value="space",  required=true) String table_space,
			 					   	   	  @RequestParam(value="nm", required=true) String table_nm,
			 					   	  	  @RequestParam(value="comment", required=true) String table_comment,
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
					query.put("KEY", RequestMappingConstants.KEY);
					query.put("USER_ID", userId);					
					query.put("PREFIX", "LOG");
					query.put("TABLE_SPACE", table_space);
					query.put("TABLE_NM", table_nm);
				   	query.put("COMMENT", table_comment);
				 
				   	// 백업
			   		try 
					{
			   			logsService.insertBackupTableCommentLogs(query);
					} 
					catch (SQLException e) 
					{
						logger.error("테이블 코멘트 백업 실패");
					}
			   		
					// 적용		   	
					ModelAndView modelAndView = new ModelAndView();
					modelAndView.addObject("tableInfo", adminTableService.updateTableComment(query));
					modelAndView.addObject("result", "Y");
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
    
    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_COLUMN_COMMENT_LIST},
				method = {RequestMethod.POST})
	public ModelAndView mngColumnCommentList(HttpServletRequest request, 
	   	   	  		      HttpServletResponse response,
			   	   	  	  @RequestParam(value="space",  required=true) String table_space,
			   	   	  	  @RequestParam(value="nm",  required=true) String table_nm,	   	   	  		      
	   	   	  		      ModelMap model) throws SQLException, NullPointerException, IOException
	{   
		response.setCharacterEncoding("UTF-8");
		
		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			HashMap<String, Object> query = new HashMap<String, Object>();
			query.put("TABLE_SPACE", table_space);
		   	query.put("TABLE_NM", table_nm);
		   	
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.addObject("columnInfo", adminTableService.selectColumnCommentList(query));
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
    
    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_COLUMN_COMMENT_EDIT},
			method = {RequestMethod.POST})
	public ModelAndView mngColumnCommentEdit(HttpServletRequest request, 
				   	   	  		      HttpServletResponse response,
				   	   	  		      @RequestParam(value="space",  required=true) String table_space,
		 					   	   	  @RequestParam(value="nm", required=true) String table_nm,
		 					   	  	  @RequestParam(value="column_data", required=true) String column_data,
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
					query.put("KEY", RequestMappingConstants.KEY);
					query.put("USER_ID", userId);					
					query.put("PREFIX", "LOG");
					query.put("TABLE_SPACE", table_space);
					query.put("TABLE_NM", table_nm);
					
 		        	// 백업
			   		try 
					{
			   			logsService.insertBackupColumnCommentLogs(query);
					} 
					catch (SQLException e) 
					{
						logger.error("컬럼 코멘트 백업 실패");
					}
			   		
					// 적용			
					int resultCount = 0;
					List<Map<String, Object>> dataList = mapper.readValue(column_data, List.class);
					for(Map<String, Object> data : dataList) {
					   	logger.info(String.format("name : %-30s, comment : %-30s", data.get("column_nm") , data.get("column_comment")));
					   	
						query.put("COLUMN_NM", data.get("column_nm"));
					   	query.put("COMMENT", data.get("column_comment"));
					   	
					   	adminTableService.updateColumnComment(query);
					   	
					   	resultCount++;
					}
					
					ModelAndView modelAndView = new ModelAndView();
					modelAndView.addObject("tableInfo", resultCount);
					modelAndView.addObject("result", "Y");
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
