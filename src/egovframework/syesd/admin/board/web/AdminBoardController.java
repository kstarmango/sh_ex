package egovframework.syesd.admin.board.web;

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
import egovframework.syesd.admin.board.service.AdminBoardService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.syesd.cmmn.menu.service.MenuService;
import egovframework.zaol.common.OraclePaginationInfo;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;

@Controller
public class AdminBoardController extends BaseController  {

	private static Logger logger = LogManager.getLogger(AdminBoardController.class);

	private ObjectMapper mapper;
	
	@Resource(name = "propertiesService") 
	private EgovPropertyService propertiesService;
	
	@Resource(name = "adminBoardService")
	private AdminBoardService adminBoardService;
	
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

    @RequestMapping(value = RequestMappingConstants.WEB_MNG_NOTICE, 
					method = {RequestMethod.GET, RequestMethod.POST})
	public String mngNotice(HttpServletRequest request, 
			   	   	  HttpServletResponse response,
			   	   	  @RequestParam(value="pageSort",  required=false) String  pageSort,
			   	   	  @RequestParam(value="pageOrder", required=false) String  pageOrder,
	   	   	  		  @RequestParam(value="pageIndex", required=false) Integer pageIndex,
	   	   	  		  @RequestParam(value="pageUnit",  required=false) Integer pageUnit,
	   	   	  		  @RequestParam(value="pageSize",  required=false) Integer pageSize,
	   	   	  		  @RequestParam(value="boardType", required=false) String  boardType,
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
		        	query.put("ARTICLE_CD", boardType);
		        	//query.put("USE_YN", "Y");
		        	query.put("SERCH_GB", 		request.getParameter("s_serch_gb"));
		        	query.put("SERCH_NM", 		request.getParameter("s_serch_nm"));
		        	query.put("START_DATE", 	request.getParameter("s_serch_start_dt"));
		        	query.put("PAGE_SORT", 		pageSort);
		        	query.put("PAGE_ORDER", 	pageOrder);
		        	query.put("FIRST_INDEX", 	view01Cnt.getFirstRecordIndex());
		        	query.put("LAST_INDEX",  	view01Cnt.getLastRecordIndex());
		        	
		        	List articleList = adminBoardService.selectNoticeArticleList(query);
		        	
		        	view01Cnt.setTotalRecordCount(adminBoardService.selectNoticeArticleListCount(query));
		
		        	model.addAttribute("s_serch_gb"       , request.getParameter("s_serch_gb"));
		        	model.addAttribute("s_serch_nm"       , request.getParameter("s_serch_nm"));
		        	model.addAttribute("s_serch_start_dt" , request.getParameter("s_serch_start_dt"));
		        	model.addAttribute("boardType"        , boardType);
			        model.addAttribute("num"			  , view01Cnt.getTotalRecordCount() - (pageIndex - 1) * pageSize);
		        	model.addAttribute("pageIndex"        , pageIndex);
		        	model.addAttribute("pageSort"         , pageSort);
		        	model.addAttribute("pageOrder"        , pageOrder);
			        model.addAttribute("boardList"		  , articleList);
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
		        	
		        	return "admin/board/noticeManage.page";
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
    
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_QNA, 
					method = {RequestMethod.GET, RequestMethod.POST})
	public String mngQna(HttpServletRequest request, 
				   	   	  HttpServletResponse response,
			   	  		  @RequestParam(value="pageIndex", required=false) Integer pageIndex,
			   	  		  @RequestParam(value="pageUnit",  required=false) Integer pageUnit,
			   	  		  @RequestParam(value="pageSize",  required=false) Integer pageSize,
			   	  		  @RequestParam(value="boardType", required=false) String  boardType,
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
		        	
		        	OraclePaginationInfo view01Cnt = new OraclePaginationInfo();
		        	view01Cnt.setCurrentPageNo     (pageIndex);
		        	view01Cnt.setRecordCountPerPage(pageUnit );
		        	view01Cnt.setPageSize          (pageSize );
		        	
		        	HashMap<String, Object> query = new HashMap<String, Object>();
		        	query.put("KEY", RequestMappingConstants.KEY);
		        	query.put("ARTICLE_CD", boardType);
		        	//query.put("USE_YN", "Y");
		        	query.put("SERCH_GB", 		request.getParameter("s_serch_gb"));
		        	query.put("SERCH_NM", 		request.getParameter("s_serch_nm"));
		        	query.put("FIRST_INDEX", 	view01Cnt.getFirstRecordIndex());
		        	query.put("LAST_INDEX",  	view01Cnt.getLastRecordIndex());
		        	
		        	List articleList = adminBoardService.selectQnaArticleList(query);
		        	
		        	view01Cnt.setTotalRecordCount(adminBoardService.selectQnaArticleListCount(query));
		
		        	model.addAttribute("s_serch_gb"       , request.getParameter("s_serch_gb"));
		        	model.addAttribute("s_serch_nm"       , request.getParameter("s_serch_nm"));
		        	model.addAttribute("boardType"        , boardType);
			        model.addAttribute("num"			  , view01Cnt.getTotalRecordCount() - (pageIndex - 1) * pageSize);
		        	model.addAttribute("pageIndex"        , pageIndex);
			        model.addAttribute("boardList"		  , articleList);
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
		        	
		        	return "admin/board/qnaManage.page";
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
	    
    
    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_NOTICE_DETAIL,
    						 RequestMappingConstants.WEB_MNG_QNA_DETAIL	
    						},
					method = {RequestMethod.POST})
	public ModelAndView mngBoardArticleDetail(HttpServletRequest request, 
					   	   	  			HttpServletResponse response,
					   	   	  		    @RequestParam(value="notice_no",  required=true) String article_no,
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
		        
		        if("".equals(userId) == false)
		        {
		        	if("".equals(article_no) == false)
		        	{
		            	/* 컨텐츠 */
		            	HashMap<String, Object> query = new HashMap<String, Object>();
		            	query.put("KEY", RequestMappingConstants.KEY);
		            	query.put("ARTICLE_NO", article_no);
		            	//query.put("USE_YN", "Y");
		            	
		                ModelAndView modelAndView = new ModelAndView();
		                modelAndView.addObject("boardInfo", adminBoardService.selectBoardArticleDetail(query));
		                modelAndView.addObject("result", "Y");
		                modelAndView.setViewName("jsonView");
		
		            	/* 이력 */
		            	try 
		    			{
		            		/*
		            		if(adminBoardService.updateBoardArticleViewCnt(query) < 1)
		            		{
		            			logger.error("조회수 업데이트 실패");
		            		}
		            		*/
		            		
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
    
    
    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_NOTICE_ADD,
    						 RequestMappingConstants.WEB_MNG_QNA_ADD},
					method = {RequestMethod.POST})
	public ModelAndView mngBoardArticleInsert(HttpServletRequest request, 
						   	   	  		      HttpServletResponse response,
						   	   	  		      @RequestParam(value="article_cd",  required=true) String article_cd,					   	   	  		    
						   	   	  		      @RequestParam(value="article_title",  required=true) String article_title,
						   	   	  		      @RequestParam(value="article_contents",  required=true) String article_contents,
						   	   	  		      @RequestParam(value="article_pop_start_dt",  required=false) String article_pop_start_dt,
						   	   	  		      @RequestParam(value="article_pop_end_dt",  required=false) String article_pop_end_dt,					   	   	  		    
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
		        
		        if("".equals(userId) == false)
		        {
		        	if("".equals(article_cd) == false)
		        	{
		            	/* 컨텐츠 */
		            	HashMap<String, Object> query = new HashMap<String, Object>();
		            	query.put("KEY", RequestMappingConstants.KEY);
		            	query.put("UPD_USER", userId);
		            	query.put("ARTICLE_CD", article_cd);
		            	query.put("ARTICLE_TITLE", article_title);
		            	query.put("ARTICLE_CONTENTS", article_contents);
		
		            	if(article_pop_start_dt != null && "".equals(article_pop_start_dt) == false)
		            		query.put("ARTICLE_POP_START_DT", article_pop_start_dt);
		            	
		            	if(article_pop_end_dt != null && "".equals(article_pop_end_dt) == false)
		            		query.put("ARTICLE_POP_END_DT", article_pop_end_dt);
		            	
		                ModelAndView modelAndView = new ModelAndView();
		                modelAndView.addObject("boardInfo", adminBoardService.insertBoardArticle(query));
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
    
    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_NOTICE_EDIT,
    						 RequestMappingConstants.WEB_MNG_QNA_EDIT},
			method = {RequestMethod.POST})
    public ModelAndView mngBoardArticleUpdate(HttpServletRequest request, 
						   	   	  		      HttpServletResponse response,
						   	   	  		      @RequestParam(value="article_no",  required=true) String article_no,
						   	   	  		      @RequestParam(value="article_title",  required=true) String article_title,
						   	   	  		      @RequestParam(value="article_contents",  required=true) String article_contents,
						   	   	  		      @RequestParam(value="article_pop_start_dt",  required=false) String article_pop_start_dt,
						   	   	  		      @RequestParam(value="article_pop_end_dt",  required=false) String article_pop_end_dt,					   	   	  		    
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
		        
		        if("".equals(userId) == false)
		        {
		        	if("".equals(article_no) == false)
		        	{
		            	/* 컨텐츠 */
		            	HashMap<String, Object> query = new HashMap<String, Object>();
		            	query.put("KEY", RequestMappingConstants.KEY);
		            	query.put("UPD_USER", userId);
		            	query.put("ARTICLE_NO", article_no);
		            	query.put("ARTICLE_TITLE", article_title);
		            	query.put("ARTICLE_CONTENTS", article_contents);
		            	
		            	if(article_pop_start_dt != null && "".equals(article_pop_start_dt) == false)
		            		query.put("ARTICLE_POP_START_DT", article_pop_start_dt);
		            	
		            	if(article_pop_end_dt != null && "".equals(article_pop_end_dt) == false)
		            		query.put("ARTICLE_POP_END_DT", article_pop_end_dt);
		            	
		                ModelAndView modelAndView = new ModelAndView();
		                modelAndView.addObject("boardInfo", adminBoardService.updateBoardArticle(query));
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
	    
    
    @RequestMapping(value = RequestMappingConstants.WEB_MNG_QNA_READD,
				 method = {RequestMethod.POST})
	public ModelAndView mngBoardArticleReplyInsert(HttpServletRequest request, 
			   	   	  		      HttpServletResponse response,
			   	   	  		      @RequestParam(value="article_cd",  required=true) String article_cd,
			   	   	  		      @RequestParam(value="article_no",  required=true) String article_no,
			   	   	  		      @RequestParam(value="article_title",  required=true) String article_title,
			   	   	  		      @RequestParam(value="article_contents",  required=true) String article_contents,
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
		
		if("".equals(userId) == false)
		{
			if("".equals(article_cd) == false)
			{
			   	/* 컨텐츠 */
			   	HashMap<String, Object> query = new HashMap<String, Object>();
			   	query.put("KEY", RequestMappingConstants.KEY);
			   	query.put("UPD_USER", userId);
			   	query.put("ARTICLE_CD", article_cd);
			   	query.put("ARTICLE_NO", article_no);
			   	query.put("ARTICLE_TITLE", article_title);
			   	query.put("ARTICLE_CONTENTS", article_contents);
			
			   	ModelAndView modelAndView = new ModelAndView();
			   	modelAndView.addObject("boardInfo", adminBoardService.insertBoardArticleReply(query));
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
    

    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_NOTICE_USEYN,
    						 RequestMappingConstants.WEB_MNG_QNA_USEYN},
					method = {RequestMethod.POST})
	public ModelAndView mngBoardArticleUseYn(HttpServletRequest request, 
						   	   	  		     HttpServletResponse response,
						   	   	  		     @RequestParam(value="article_no",  required=true) String article_no,
						   	   	  		     @RequestParam(value="use_yn",  required=true) String use_yn,
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
		        
		        if("".equals(userId) == false)
		        {
		        	if("".equals(article_no) == false)
		        	{
		            	/* 컨텐츠 */
		            	HashMap<String, Object> query = new HashMap<String, Object>();
		            	query.put("KEY", RequestMappingConstants.KEY);
		            	query.put("UPD_USER", userId);
		            	query.put("ARTICLE_NO", article_no);
		            	query.put("USE_YN", use_yn);
		            	
		                ModelAndView modelAndView = new ModelAndView();
		                modelAndView.addObject("boardInfo", adminBoardService.updateBoardArticleUse(query));
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

    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_NOTICE_VIEW_CNT,
							 RequestMappingConstants.WEB_MNG_QNA_VIEW_CNT},
					method = {RequestMethod.POST})
	public ModelAndView mngBoardArticleViewCnt(HttpServletRequest request, 
							   	   	  		     HttpServletResponse response,
							   	   	  		     @RequestParam(value="article_no",  required=true) String article_no,
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
				
				if("".equals(userId) == false)
				{
					if("".equals(article_no) == false)
					{
					   	/* 컨텐츠 */
					   	HashMap<String, Object> query = new HashMap<String, Object>();
					   	query.put("KEY", RequestMappingConstants.KEY);
					   	query.put("ARTICLE_NO", article_no);
				   	
					   	ModelAndView modelAndView = new ModelAndView();
					   	modelAndView.addObject("views", adminBoardService.updateBoardArticleViewCntBySeq(query));
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
    
    // 2022.10.17 
    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_NOTICE_DELETE},method = {RequestMethod.POST})
    public ModelAndView mngBoardArticleDelete(HttpServletRequest request, 
		   	   	  		      HttpServletResponse response,
		   	   	  		      @RequestParam(value="article_no",  required=true) String article_no,					   	   	  		    			   	   	  		    
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
				
				if("".equals(userId) == false)
				{
					if("".equals(article_no) == false)
					{
						HashMap<String, Object> query = new HashMap<String, Object>();
						query.put("KEY", RequestMappingConstants.KEY);
						query.put("ARTICLE_NO", article_no);
						query.put("UPD_USER", userId);
						query.put("PROGRM_URL", request.getRequestURI());
						//adminBoardService.deleteNoticeArticle(query);
						 ModelAndView modelAndView = new ModelAndView();
			             modelAndView.addObject("boardDelete", adminBoardService.deleteNoticeArticle(query));
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
    
    
    
    
    // 2022.10.18 
    @RequestMapping(value = {RequestMappingConstants.WEB_MNG_QNA_DELETE},method = {RequestMethod.POST})
    public ModelAndView mngBoardQnaDelete(HttpServletRequest request, 
		   	   	  		      HttpServletResponse response,
		   	   	  		      @RequestParam(value="article_no",  required=true) List<String> article_no,					   	   	  		    			   	   	  		    
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
				
				if("".equals(userId) == false)
				{
					if("".equals(article_no) == false)
					{
						/*
						 * for(String no : article_no) { adminBoardService.deleteQnaArticle(no); }
						 */
					   for(int i=0; i<article_no.size(); i++) {
							HashMap<String, Object> query = new HashMap<String, Object>();
							query.put("KEY", RequestMappingConstants.KEY);
							query.put("ARTICLE_NO", article_no.get(i));
							query.put("UPD_USER", userId);
							query.put("PROGRM_URL", request.getRequestURI());
							adminBoardService.deleteQnaArticle(query);
						   
					   }
					   
					   //modelAndView.addObject("boardDelete", adminBoardService.deleteQnaArticle(query));
						 ModelAndView modelAndView = new ModelAndView();
						 modelAndView.addObject("result", "Y");
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
    
    
}
