package egovframework.syesd.admin.data.web;

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
import egovframework.syesd.admin.data.service.AdminDataService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.zaol.common.OraclePaginationInfo;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;

@Controller
public class AdminDataController extends BaseController  {

	private static Logger logger = LogManager.getLogger(AdminDataController.class);  

	private ObjectMapper mapper;
	
	@Resource(name = "propertiesService") 
	private EgovPropertyService propertiesService;
	
	@Resource(name = "adminDataService") 
	private AdminDataService adminDataService;
	
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

    @RequestMapping(value = RequestMappingConstants.WEB_MNG_TABLE_DATA, 
 			method = {RequestMethod.GET, RequestMethod.POST})
 	public String mngTableData(HttpServletRequest request, 
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
		        	
		        	query.put("CONFM_YN",  		request.getParameter("s_serch_confm_yn"));
		        	query.put("SERCH_GB", 		request.getParameter("s_serch_gb"));
		        	query.put("SERCH_NM", 		request.getParameter("s_serch_nm"));
		        	query.put("START_DATE", 	request.getParameter("s_serch_start_dt"));
		        	query.put("PAGE_SORT", 		pageSort);
		        	query.put("PAGE_ORDER", 	pageOrder);
		        	query.put("FIRST_INDEX", 	view01Cnt.getFirstRecordIndex());
		        	query.put("LAST_INDEX",  	view01Cnt.getLastRecordIndex());
		        	
		        	List dataList = adminDataService.selectDataList(query);
		        	
		        	view01Cnt.setTotalRecordCount(adminDataService.selectDataListCount(query));
		
		        	model.addAttribute("s_serch_gb"       , request.getParameter("s_serch_gb"));
		        	model.addAttribute("s_serch_nm"       , request.getParameter("s_serch_nm"));
		        	model.addAttribute("s_serch_start_dt" , request.getParameter("s_serch_start_dt"));
			        model.addAttribute("num"			  , view01Cnt.getTotalRecordCount() - (pageIndex - 1) * pageSize);
		        	model.addAttribute("pageIndex"        , pageIndex);
		        	model.addAttribute("pageSort"         , pageSort);
		        	model.addAttribute("pageOrder"        , pageOrder);
			        model.addAttribute("dataList"		  , dataList);
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
 		        	
 		        	return "admin/data/dataManage.page";
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
        
    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_TABLE_DATA_DETAIL},
				method = {RequestMethod.POST})
	public ModelAndView mngTableDataDetail(HttpServletRequest request, 
					   	   	  		      HttpServletResponse response,
					   	   	  		      @RequestParam(value="id",  required=true) String req_no,
					   	   	  		      ModelMap model) throws SQLException, NullPointerException, IOException
	{   
		response.setCharacterEncoding("UTF-8");
		
		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			HashMap<String, Object> query = new HashMap<String, Object>();
		   	query.put("REQ_NO", req_no);
		   	
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.addObject("dataInfo", adminDataService.selectDataDetail(query));
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
    
    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_TABLE_DATA_EDIT},
			method = {RequestMethod.POST})
	public ModelAndView mngTableDataEditByNo(HttpServletRequest request, 
						   	   	  		      HttpServletResponse response,
						   	   	  		      @RequestParam(value="id",  required=true) String req_no,
						   	   	  		      @RequestParam(value="nm",  required=true) String table_nm,
						   	   	  		      @RequestParam(value="data",  required=true) String req_data,
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
					if("".equals(req_no) == false)
					{
						List<Map<String, Object>> dataList = mapper.readValue(req_data, List.class);
						
					   	/* 컨텐츠 */
					   	HashMap<String, Object> query = new HashMap<String, Object>();
					   	query.put("KEY", RequestMappingConstants.KEY);
					   	query.put("CFM_USER", userId);
					   	query.put("REQ_NO", req_no);
					   	query.put("TABLE_NM", table_nm);
					   	query.put("REQ_DATA", dataList);
					   	
					   	ModelAndView modelAndView = new ModelAndView();
					   	modelAndView.addObject("dataInfo", adminDataService.updateDataByReqNo(query));
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
