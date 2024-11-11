package egovframework.syesd.portal.board.web;

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
import egovframework.zaol.gisinfo.service.GisBasicVO;

@Controller
public class BoardController extends BaseController  {

	private static Logger logger = LogManager.getLogger(BoardController.class);
	
	private ObjectMapper mapper;
	
	@Resource(name = "propertiesService") 
	private EgovPropertyService propertiesService;
	
	@Resource(name = "adminBoardService")
	private AdminBoardService adminBoardService;
	
	@Resource(name = "logsService") 
	private LogsService logsService;
	
	@Resource(name = "menuService")
	private MenuService menuService;
	
	private static final String validUrl   = RequestMappingConstants.WEB_MAIN;
	private static final String invalidUrl = RequestMappingConstants.WEB_LOGIN;
		
    @PostConstruct
	public void initIt() throws NullPointerException {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}
    
    /**
     * left 페이지 ( from login )
     * @throws SQLException 
     **/
    @RequestMapping(value = RequestMappingConstants.WEB_BOARD_LEFT,
    				method = {RequestMethod.GET, RequestMethod.POST})
    public String main_left(HttpServletRequest request,
    						  HttpServletResponse response, ModelMap model) throws SQLException 
    {   
    	HashMap<String, Object> param = new HashMap<String, Object>();
    	param.put("lcode", 40);
    	model.addAttribute("menu",menuService.selectLeftMenuInfo(param));
    	return "/portal/board/leftMenu.jsp";
    }
    
    @RequestMapping(value = "/getLeft.do")
    public ModelAndView getLeft(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO) throws SQLException 
    {
    	
    	response.setCharacterEncoding("UTF-8");
    	
    	HashMap<String, Object> param = new HashMap<String, Object>();
    	param.put("lcode", request.getParameter("lcode"));
    	//model.addAttribute("menu",menuService.selectLeftMenuInfo(param))
    	
    	HttpSession session = getSession();
		String userS_id = null;
	   	if(session != null){
	   		userS_id = (String)session.getAttribute("userId");
	   	}
	   	param.put("USER_ID",userS_id);
	   	param.put("KEY", RequestMappingConstants.KEY);
	   	
    	/*JSONObject obj = new JSONObject();
    	obj.put("list",menuService.selectLeftMenuInfo(param));
    	
    	PrintWriter out = response.getWriter();
		out.println(obj.toString());*/
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.addObject("list", menuService.selectLeftMenuInfo(param));
		modelAndView.addObject("result", "Y");
		modelAndView.setViewName("jsonView");
		
		

		return modelAndView;
    }

    /**
     * 공지사항 페이지
     * @throws IOException 
     * @throws NullPointerException 
     **/
    @RequestMapping(value = RequestMappingConstants.WEB_NOTICE, 
					method = {RequestMethod.GET, RequestMethod.POST})
	public String boardNotice(HttpServletRequest request, 
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
		        
		        if("".equals(userId) == false)
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
		        	
		        	if("N".equals(userAdmYn) == true)
		        		query.put("USE_YN", "Y");
		        	
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
						logger.error("이력 등록 실패" );
					}
		        	
		        	return "portal/board/notice.page";
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
    
    /**
     * 질의응답 페이지
     **/
    @RequestMapping(value = RequestMappingConstants.WEB_QNA, 
				method = {RequestMethod.GET, RequestMethod.POST})
	public String boardQna(HttpServletRequest request, 
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
		        
		        if("".equals(userId) == false)
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

		        	if("N".equals(userAdmYn) == true)
		        	query.put("USE_YN", "Y");
		        	
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
						logger.error("이력 등록 실패" );
					}
		        	
		        	return "portal/board/qna.page";
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
 
    
    @RequestMapping(value = {RequestMappingConstants.WEB_NOTICE_CHECK_NEW,
    						 RequestMappingConstants.WEB_QNA_CHECK_NEW},
					method = RequestMethod.POST)    
	public ModelAndView boardArticleCheckNew(HttpServletRequest request, 
								             HttpServletResponse response) throws SQLException, NullPointerException, IOException
	{   
		request.setCharacterEncoding("UTF-8"); 
		
		List checkNew = null;
		String result = "Y";
		try
		{
			checkNew = adminBoardService.selectBoardArticleCheckNew();
		} 
		catch(SQLException e)
		{
			result = "N";
		}
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.addObject("isNew", checkNew);
		modelAndView.addObject("result", result);
		modelAndView.setViewName("jsonView");
		
		return modelAndView;
	}
    
}
