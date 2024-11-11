package egovframework.zaol.board.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.zaol.home.service.HomeVO;
import egovframework.zaol.manage.service.ManageService;
import egovframework.zaol.manage.service.ManageVO;
import egovframework.zaol.theme.service.ThemeVO;
import egovframework.zaol.board.service.BoardService;
import egovframework.zaol.board.service.BoardVO;
import egovframework.zaol.common.OraclePaginationInfo;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;
import egovframework.zaol.dash.service.DashVO;

public class BoardController extends BaseController  {

//고도화 시작-----------------------------------------------------------------------------------------------------------------------------------
	@Resource(name = "propertiesService") 
	protected EgovPropertyService propertiesService;
	
	@Resource(name = "boardService") 
	private   BoardService boardService;
	
	//공지사항 리스트 페이지
    @RequestMapping(value="/board_notice_home.do")
    public String board_notice_home(@ModelAttribute("boardVO") BoardVO vo, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
                            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {   
    	
    	
    	request.setCharacterEncoding("UTF-8");
    	response.setCharacterEncoding("UTF-8");
	String users_id = null;
	String urlRediect = null;
	HttpSession session = getSession();
	if(session != null)
	{
		users_id = (String)session.getAttribute("userId");
	}

    if(users_id != null)
    {
    	
	  	/** 페이징 */
	      if( vo.getPageUnit() == 0 ) { vo.setPageUnit(propertiesService.getInt("pageUnit")); }
	      if( vo.getPageSize() == 0 ) { vo.setPageSize(propertiesService.getInt("pageSize")); }
	
	      OraclePaginationInfo view01Cnt = new OraclePaginationInfo();
	
	      view01Cnt.setCurrentPageNo     (vo.getPageIndex());
	      view01Cnt.setRecordCountPerPage(vo.getPageUnit() );
	      view01Cnt.setPageSize          (vo.getPageSize() );
	      /** 페이징 */
	      int cpNo  = view01Cnt.getCurrentPageNo(); // 현재 페이지
	      int pSize = view01Cnt.getPageSize();      // 보여줄 페이지 사이즈
	
	      vo.setFirstIndex             (view01Cnt.getFirstRecordIndex()  );
	      vo.setLastIndex              (view01Cnt.getLastRecordIndex()   );
	      vo.setRecordCountPerPage     (view01Cnt.getRecordCountPerPage());
	      vo.setBoard_gubun("NOTICE");
	      
	      List noticeList =  boardService.noticeListPage( vo );   
	      view01Cnt.setTotalRecordCount  (boardService.noticeListPageCnt( vo )   );
	
	     
	      model.addAttribute("noticeList"      , noticeList     );
	      model.addAttribute("num" , view01Cnt.getTotalRecordCount()-(cpNo-1)*pSize);
	      model.addAttribute("view01Cnt" , view01Cnt);
//	        urlRediect = "admin/board/notice_list" ;
	        urlRediect = "/SH/board/notice/list" ;
	        
	      
//	      return "/SH/board/notice/list";    	// 나중에 삭제
	   }else{	    		
			jsHelper.Alert("권한이 불충분합니다.");
			return  "redirect:/main_home.do";
	   }
	    	
      	return urlRediect;  
    	
    }
    
    
    /**
     *  공지사항 입력 페이지
     */
    @RequestMapping(value="/board_notice_Insert.do")
    public String noticeInsert(HttpServletRequest request ,HttpServletResponse response ,@ModelAttribute("manageVO") ManageVO manageVO
    		                   ,ModelMap model) throws Exception
    {
    	String users_id = null;
    	String urlRediect = null;
    	HttpSession session = getSession();
    	if(session != null)
    	{
    		users_id = (String)session.getAttribute("userId");
    	}
    	
    	CommonSessionVO commonSessionVO = new CommonSessionVO();
        commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
        
        if(users_id != null)
        {
		    	  urlRediect = "admin/board/notice_add" ;
		    	
        }else
        {
			 jsHelper.Alert("세션이 만료 되었습니다.");
			 jsHelper.RedirectUrl("/main_home.do");
        }   
		  
	    return urlRediect;
// 	   return "admin/board/notice_add";  // 나중에 삭제		
 		    	
    }
    
    //공지사항 상세보기 페이지
    @RequestMapping(value="/board_notice_Content.do")
    public String board_notice_Content(@ModelAttribute("boardVO") BoardVO vo, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
                            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {    	 
    	String users_id = null;
    	String urlRediect = null;
    	HttpSession session = getSession();
    	if(session != null)
    	{
    		users_id = (String)session.getAttribute("userId");
    	}
    	
//    	CommonSessionVO commonSessionVO = new CommonSessionVO();
//        commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
        
        if(users_id != null)
        { 
//	    	if("admin".equals(commonSessionVO.getUser_id()))
//	    	{
    			vo.setBoard_gubun("NOTICE");
		    	List noticeList =  boardService.noticeDetail( vo );   
			    model.addAttribute("noticeList", noticeList);
			    model.addAttribute("userid", users_id);
			    
			    return "/SH/board/notice/detail";    	// 삭제요망
		    	}else
		    	{	    		
		    		jsHelper.Alert("권한이 불충분합니다.");
		    		return  "redirect:/main_home.do";
		    	}
		    	
	        
            // return urlRediect;
	         
    	
	      
    	
    }
    	
    
    //공지사항 등록 페이지
    @RequestMapping(value="/board_notice_register.do")
    public String board_notice_register(@ModelAttribute("boardVO") BoardVO vo, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
                            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {    	 
    	return "/SH/board/notice/register";    	
    }
    
    
    
    //Q&A 리스트 페이지
    @RequestMapping(value="/board_qna_home.do")
    public String board_qna_home(@ModelAttribute("boardVO") BoardVO vo, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
                            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {   
    	
    	
    	request.setCharacterEncoding("UTF-8");
    	response.setCharacterEncoding("UTF-8");
	String users_id = null;
	String urlRediect = null;
	HttpSession session = getSession();
	if(session != null)
	{
		users_id = (String)session.getAttribute("userId");
	}

    if(users_id != null)
    {
    	
	  	/** 페이징 */
	      if( vo.getPageUnit() == 0 ) { vo.setPageUnit(propertiesService.getInt("pageUnit")); }
	      if( vo.getPageSize() == 0 ) { vo.setPageSize(propertiesService.getInt("pageSize")); }
	
	      OraclePaginationInfo view01Cnt = new OraclePaginationInfo();
	
	      view01Cnt.setCurrentPageNo     (vo.getPageIndex());
	      view01Cnt.setRecordCountPerPage(vo.getPageUnit() );
	      view01Cnt.setPageSize          (vo.getPageSize() );
	      /** 페이징 */
	      int cpNo  = view01Cnt.getCurrentPageNo(); // 현재 페이지
	      int pSize = view01Cnt.getPageSize();      // 보여줄 페이지 사이즈
	
	      vo.setFirstIndex             (view01Cnt.getFirstRecordIndex()  );
	      vo.setLastIndex              (view01Cnt.getLastRecordIndex()   );
	      vo.setRecordCountPerPage     (view01Cnt.getRecordCountPerPage());
	      vo.setBoard_gubun("QNA");
	      
	      List qnaList =  boardService.qnaListPage( vo );
	      view01Cnt.setTotalRecordCount  (boardService.noticeListPageCnt( vo )   );
	
	     
	      model.addAttribute("qnaList"      , qnaList     );
	      model.addAttribute("num" , view01Cnt.getTotalRecordCount()-(cpNo-1)*pSize);
	      model.addAttribute("view01Cnt" , view01Cnt);
	      //urlRediect = "admin/board/notice_list" ;
	        
	      
	      urlRediect = "/SH/board/qna/list"; 
	      
	   }else{	    		
			jsHelper.Alert("권한이 불충분합니다.");
			return  "redirect:/main_home.do";
	   }
	    	
	      return urlRediect;  
    	
    }
    
    //Q&A 상세보기 페이지
    @RequestMapping(value="/board_qna_Content.do")
    public String board_qna_Content(@ModelAttribute("boardVO") BoardVO vo, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
                            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {    	 
    	String users_id = null;
    	String urlRediect = null;
    	HttpSession session = getSession();
    	if(session != null)
    	{
    		users_id = (String)session.getAttribute("userId");
    	}
    	
//    	CommonSessionVO commonSessionVO = new CommonSessionVO();
//        commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
        
        if(users_id != null)
        { 
//	    	if("admin".equals(commonSessionVO.getUser_id()))
//	    	{
    			vo.setBoard_gubun("QNA");

    			//qna 조회수 증가
    			boardService.board_cnt_UpdateStart(vo);

    			List qnaList =  boardService.noticeDetail( vo );  
			    model.addAttribute("qnaList", qnaList);
			    model.addAttribute("userid", users_id);
			    
		    
			    return "/SH/board/qna/detail";    	// 삭제요망
		}else
		{	    		
			jsHelper.Alert("권한이 불충분합니다.");
			return  "redirect:/main_home.do";
		}
    	
    	    	
    }
    
    //Q&A 등록 페이지
    @RequestMapping(value="/board_qna_register.do")
    public String board_qna_register(@ModelAttribute("boardVO") BoardVO vo, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
                            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {    
    	String users_id = null;
    	String urlRediect = null;
    	HttpSession session = getSession();
    	if(session != null)
    	{
    		users_id = (String)session.getAttribute("userId");
    	}
    	
        if(users_id != null)
        { 
			    model.addAttribute("userid", users_id);
			    return "/SH/board/qna/register";   
		}else
		{	    		
			jsHelper.Alert("권한이 불충분합니다.");
			return  "redirect:/main_home.do";
		}
    	 	
    }
    
    
    
  //Q&A 답글쓰기 클릭
    @RequestMapping(value="/board_qna_re_register.do")
    public String board_qna_re_register(@ModelAttribute("boardVO") BoardVO vo, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
                            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {
    	String users_id = null;
    	String urlRediect = null;
    	HttpSession session = getSession();
    	if(session != null)
    	{
    		users_id = (String)session.getAttribute("userId");
    	}
    	
        if(users_id != null)
        {
        	vo.setBoard_gubun("QNA");
	    	List qnaList =  boardService.noticeDetail( vo );   
		    model.addAttribute("qnaList", qnaList);
		    model.addAttribute("userid", users_id);
		    
		    return "/SH/board/qna/register";
		    
		    
		}else
		{
			jsHelper.Alert("권한이 불충분합니다.");
			return  "redirect:/main_home.do";
		}
    	 	
    }
}
