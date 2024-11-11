package egovframework.zaol.manage.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;


import egovframework.zaol.manage.service.ManageService;
import egovframework.zaol.manage.service.ManageVO;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.zaol.common.OraclePaginationInfo;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;


@Controller
public class ManageController extends BaseController  {

//고도화 시작-----------------------------------------------------------------------------------------------------------------------------------
	@Resource(name = "propertiesService") 
	protected EgovPropertyService propertiesService;
	
	@Resource(name = "manageService") 
	private   ManageService manageService;
	
	//사용자관리 리스트 페이지
    @RequestMapping(value="/manage_user_list.do")
    public String manage_user_home(@ModelAttribute("manageVO") ManageVO manageVO ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
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
	    	if("admin".equals(commonSessionVO.getUser_id()))
	    	{
	    		/** 페이징 */
		        if( manageVO.getPageUnit() == 0 ) { manageVO.setPageUnit(propertiesService.getInt("pageUnit")); }
		        if( manageVO.getPageSize() == 0 ) { manageVO.setPageSize(propertiesService.getInt("pageSize")); }
		        
		        OraclePaginationInfo view01Cnt = new OraclePaginationInfo();
		        
		        view01Cnt.setCurrentPageNo     (manageVO.getPageIndex());
		        view01Cnt.setRecordCountPerPage(manageVO.getPageUnit() );
		        view01Cnt.setPageSize          (manageVO.getPageSize() );
		        
		        int cpNo  = view01Cnt.getCurrentPageNo(); // 현재 페이지
		        int pSize = view01Cnt.getPageSize();      // 보여줄 페이지 사이즈
		        
		        manageVO.setFirstIndex             (view01Cnt.getFirstRecordIndex());
		        manageVO.setLastIndex              (view01Cnt.getLastRecordIndex());
		        manageVO.setRecordCountPerPage     (view01Cnt.getRecordCountPerPage());
		        
		        List userList =  manageService.selectUserList(manageVO);   
		        view01Cnt.setTotalRecordCount  (manageService.selectUserListCnt(manageVO ));
		        
		        model.addAttribute("num" , view01Cnt.getTotalRecordCount()-(cpNo-1)*pSize);
		        model.addAttribute("userList"      , userList     );
		        model.addAttribute("view01Cnt" , view01Cnt);
		          urlRediect = "admin/user/list" ;
		        
//		          return "admin/user/list"; // 나중에 삭제
	        }else
	    	{	    		
	    		jsHelper.Alert("권한이 불충분합니다.");
	    		jsHelper.RedirectUrl("/dashboard.do");
	    	}
	    	
	    }else{	    		
	    	jsHelper.Alert("세션이 만료 되었습니다.");
        	jsHelper.RedirectUrl("/main_home.do");
//	    		return  "redirect:/main_home.do"; // 나중에 삭제
	    }
	    	
        
        
      return urlRediect;
    }

	   
    
    //사용자관리 상세보기 페이지
    @RequestMapping(value="/manage_user_detail.do")
    public String manage_user_content(@ModelAttribute("manageVO") ManageVO manageVO ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
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
	    	if("admin".equals(commonSessionVO.getUser_id()))
	    	{
             manageVO.setUser_id(manageVO.getSeq());
    	     manageVO.setAdminYn("adminCerti");
    	     ManageVO view01    = manageService.selectUserInfo(manageVO);
	         model.addAttribute("view01", view01);
    	
	           urlRediect = "admin/user/detail" ;
		        
		    	}else
		    	{	    		
		    		jsHelper.Alert("권한이 불충분합니다.");
		    		jsHelper.RedirectUrl("/dashboard.do");
		    	}
		    	
	        }else
	        {
	        	jsHelper.Alert("세션이 만료 되었습니다.");
	        	jsHelper.RedirectUrl("/main_home.do");
	        }   
            return urlRediect;
//	         return "admin/user/detail"; // 삭제요망
    	    	
    }
    
    // 비밀번호 초기화
    @RequestMapping(value="/user_pass_reset.do")
    public String memResetpass(@ModelAttribute("manageVO") ManageVO manageVO ,HttpServletRequest  request ,HttpServletResponse response ,ModelMap model) throws Exception
    {
    
    	String users_id = null;
    	
    	HttpSession session = getSession();
    	if(session != null)
    	{
    		users_id = (String)session.getAttribute("userId");
    	}
    	
    	CommonSessionVO commonSessionVO = new CommonSessionVO();
        commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
        
        if(users_id != null)
        {
	    	if("admin".equals(commonSessionVO.getUser_id()))
	    	{
    		
	    		manageService.resetPass(manageVO); 
	    		jsHelper.AlertAndHistoryGo("비밀번호가 [SH123456]으로 초기화 되었습니다.", -1);
	  		
          }else
	      {	    		
	    		jsHelper.Alert("권한이 불충분합니다.");
	    		jsHelper.RedirectUrl("/main_home.do");
	      }
		    	
	    }else
	    {
	        	jsHelper.Alert("세션이 만료 되었습니다.");
	        	jsHelper.RedirectUrl("/main_home.do");
	    }
	    
         return null;
	         
    }
    
    // 권한수정실행
    @RequestMapping(value="/user_auth_upt.do")
    public void memAuthudp01(@ModelAttribute("manageVO"  ) ManageVO manageVO ,HttpServletRequest  request ,HttpServletResponse response ,ModelMap model) throws Exception
    {
      String users_id = null;
    	
    	HttpSession session = getSession();
    	if(session != null)
    	{
    		users_id = (String)session.getAttribute("userId");
    	}
    	
    	CommonSessionVO commonSessionVO = new CommonSessionVO();
        commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
        
        if(users_id != null)
        {
	    	if("admin".equals(commonSessionVO.getUser_id()))
	    	{
    		
    	     manageService.memAuthudp01(manageVO); 
    		 jsHelper.AlertAndUrlGo("수정이 완료 되었습니다.", "/manage_user_list.do");
    		
    		 }else
   	      {	    		
   	    		jsHelper.Alert("권한이 불충분합니다.");
   	    		jsHelper.RedirectUrl("/dashboard.do");
   	      }
   		    	
   	    }else
   	    {
   	        	jsHelper.Alert("세션이 만료 되었습니다.");
   	        	jsHelper.RedirectUrl("/main_home.do");
   	    }
            
    }
    // 사용자 접속 기록 페이지
     
    @RequestMapping(value="/memAccessed.do")
    public String memAccessed(HttpServletRequest request, HttpServletResponse response ,@ModelAttribute("manageVO") ManageVO manageVO ,ModelMap model) throws Exception
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
    	
    	CommonSessionVO commonSessionVO = new CommonSessionVO();
        commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
        
        if(users_id != null)
        {
	    	if("admin".equals(commonSessionVO.getUser_id()))
	    	{
	    	
	    	/** 페이징 */
	        if( manageVO.getPageUnit() == 0 ) { manageVO.setPageUnit(propertiesService.getInt("pageUnit")); }
	        if( manageVO.getPageSize() == 0 ) { manageVO.setPageSize(propertiesService.getInt("pageSize")); }
	
	        OraclePaginationInfo view01Cnt = new OraclePaginationInfo();
	
	        view01Cnt.setCurrentPageNo     (manageVO.getPageIndex());
	        view01Cnt.setRecordCountPerPage(manageVO.getPageUnit() );
	        view01Cnt.setPageSize          (manageVO.getPageSize() );
	        int cpNo  = view01Cnt.getCurrentPageNo(); // 현재 페이지
	        int pSize = view01Cnt.getPageSize();      // 보여줄 페이지 사이즈
	        manageVO.setFirstIndex             (view01Cnt.getFirstRecordIndex()  );
	        manageVO.setLastIndex              (view01Cnt.getLastRecordIndex()   );
	        manageVO.setRecordCountPerPage     (view01Cnt.getRecordCountPerPage());
	       
	        List userHistList =  manageService.memAccessList( manageVO );   
	        view01Cnt.setTotalRecordCount  (manageService.memAccessListCnt( manageVO )   );
	        model.addAttribute("num" , view01Cnt.getTotalRecordCount()-(cpNo-1)*pSize);
	       
	        /** 페이징 */
	        model.addAttribute("userHistList"      , userHistList     );
	        model.addAttribute("view01Cnt" , view01Cnt);
        
        	
        
        	  urlRediect = "admin/user/history" ;
	        
	    	}else
	    	{	    		
	    		jsHelper.Alert("권한이 불충분합니다.");
	    		jsHelper.RedirectUrl("/dashboard.do");
	    	}
	    	
        }else
        {
        	jsHelper.Alert("세션이 만료 되었습니다.");
        	jsHelper.RedirectUrl("/main_home.do");
        }   
        
        return urlRediect;
//	   return "admin/user/history";// 나중에 삭제
    }
    
    //사용자관리 시스템현황 페이지
    @RequestMapping(value="/manage_stat_home.do")
    public String manage_stat_home(@ModelAttribute("manageVO") ManageVO vo, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
                            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {    	 
    	return "admin/stat/main";    	
    }
    
    
    // 관리자용 공지사항 리스트 페이지
     
    @RequestMapping(value="/noticeAdminListPage.do")
    public String noticeAdminListPage(HttpServletRequest request ,HttpServletResponse response ,@ModelAttribute("manageVO") ManageVO manageVO ,ModelMap model) throws Exception
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
	
	CommonSessionVO commonSessionVO = new CommonSessionVO();
    commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
    
    if(users_id != null)
    {
    	if("admin".equals(commonSessionVO.getUser_id()))
    	{
    	
	  	/** 페이징 */
	      if( manageVO.getPageUnit() == 0 ) { manageVO.setPageUnit(propertiesService.getInt("pageUnit")); }
	      if( manageVO.getPageSize() == 0 ) { manageVO.setPageSize(propertiesService.getInt("pageSize")); }
	
	      OraclePaginationInfo view01Cnt = new OraclePaginationInfo();
	
	      view01Cnt.setCurrentPageNo     (manageVO.getPageIndex());
	      view01Cnt.setRecordCountPerPage(manageVO.getPageUnit() );
	      view01Cnt.setPageSize          (manageVO.getPageSize() );
	      /** 페이징 */
	      int cpNo  = view01Cnt.getCurrentPageNo(); // 현재 페이지
	      int pSize = view01Cnt.getPageSize();      // 보여줄 페이지 사이즈
	
	      manageVO.setFirstIndex             (view01Cnt.getFirstRecordIndex()  );
	      manageVO.setLastIndex              (view01Cnt.getLastRecordIndex()   );
	      manageVO.setRecordCountPerPage     (view01Cnt.getRecordCountPerPage());
	      manageVO.setBoard_gubun("NOTICE");
	      
	      List noticeList =  manageService.noticeListPage( manageVO );   
	      view01Cnt.setTotalRecordCount  (manageService.noticeListPageCnt( manageVO )   );
	
	     
	      model.addAttribute("noticeList"      , noticeList     );
	      model.addAttribute("num" , view01Cnt.getTotalRecordCount()-(cpNo-1)*pSize);
	      model.addAttribute("view01Cnt" , view01Cnt);
	        urlRediect = "admin/board/notice_list" ;
	        
	    	}else
	    	{	    		
	    		jsHelper.Alert("권한이 불충분합니다.");
	    		jsHelper.RedirectUrl("/dashboard.do");
	    	}
	    	
      }else
      {
      	jsHelper.Alert("세션이 만료 되었습니다.");
      	jsHelper.RedirectUrl("/main_home.do");
      }   
      
      return urlRediect;
//	   return "admin/board/notice_list";// 나중에 삭제
      
  		
    }
    
    /**
     *  공지사항 입력 페이지
     */
    @RequestMapping(value="/noticeInsert.do")
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
			if("admin".equals(commonSessionVO.getUser_id()))
			{
			
				  urlRediect = "admin/board/notice_add" ;
			    
			}else
			{	    		
				jsHelper.Alert("권한이 불충분합니다.");
				jsHelper.RedirectUrl("/dashboard.do");
			}
		    	
		}else
		{
		  	jsHelper.Alert("세션이 만료 되었습니다.");
		  	jsHelper.RedirectUrl("/main_home.do");
		}   
		  
	    return urlRediect;
// 	   return "admin/board/notice_add";  // 나중에 삭제		
 		    	
    }
    
    /**
     * 공지사항 입력 실행
     */
    @RequestMapping(value="/noticeInserteStart.do")
    public void noticeInserteStart(@ModelAttribute("manageVO"  ) ManageVO manageVO , HttpServletResponse response ,ModelMap model ) throws Exception
    {
        String users_id = null;
    	
    	HttpSession session = getSession();
    	if(session != null)
    	{
    		users_id = (String)session.getAttribute("userId");
    	}
    	/*
    	CommonSessionVO commonSessionVO = new CommonSessionVO();
        commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
        
        if(users_id != null)
        {
	    	if("admin".equals(commonSessionVO.getUser_id()))
	    	{*/
    	manageVO.setUser_id(users_id);
    	manageVO.setBoard_gubun("NOTICE");
    	manageService.noticeInserteStart(manageVO);
/*    	jsHelper.AlertAndUrlGo("입력이 완료 되었습니다.", "/noticeAdminListPage.do");*/
    	jsHelper.AlertAndUrlGo("입력이 완료 되었습니다.", "/board_notice_home.do");
    	
    	 /*}else
 	      {	    		
 	    		jsHelper.Alert("권한이 불충분합니다.");
 	    		jsHelper.RedirectUrl("/main_home.do");
 	      }
 		    	
 	    }else
 	    {
 	        	jsHelper.Alert("세션이 만료 되었습니다.");
 	        	jsHelper.RedirectUrl("/main_home.do");
 	    }*/
              
    } 
    
    
    
    /**
     *  공지사항 수정 페이지
     */
    @RequestMapping(value="/noticeAdminDetailpage.do")
    public String noticeAdminDetailpage(HttpServletRequest request ,HttpServletResponse response ,@ModelAttribute("manageVO") ManageVO vo
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
//        	if("admin".equals(commonSessionVO.getUser_id()))
//        	{
        		vo.setBoard_gubun("NOTICE");
		    	List noticeList =  manageService.noticeUpdatePage( vo );   
			    model.addAttribute("noticeList", noticeList);
        		
		    	  urlRediect = "admin/board/notice_edit" ;
		        
//		    	}else
//		    	{	    		
//		    		jsHelper.Alert("권한이 불충분합니다.");
//		    		jsHelper.RedirectUrl("/dashboard.do");
//		    	}
		    	
		  }else
		  {
		  	jsHelper.Alert("세션이 만료 되었습니다.");
		  	jsHelper.RedirectUrl("/main_home.do");
		  }   
		  
	    return urlRediect;
// 	   return "admin/board/notice_add";  // 나중에 삭제		
 		    	
    }
    
    
    /**
     * 공지사항 수정 실행
     */
    @RequestMapping(value="/noticeUpdateStart.do")
    public void noticeUpdateStart(@ModelAttribute("manageVO"  ) ManageVO manageVO , HttpServletResponse response ,ModelMap model ) throws Exception
    {
      /*String users_id = null;
    	
    	HttpSession session = getSession();
    	if(session != null)
    	{
    		users_id = (String)session.getAttribute("userId");
    	}
    	
    	CommonSessionVO commonSessionVO = new CommonSessionVO();
        commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
        
        if(users_id != null)
        {
	    	if("admin".equals(commonSessionVO.getUser_id()))
	    	{*/
   	    
    	manageVO.setBoard_gubun("NOTICE");
    	manageService.noticeUpdateStart(manageVO);
    	jsHelper.AlertAndUrlGo("수정이 완료 되었습니다.", "/noticeAdminListPage.do");
    	
    	 /*}else
 	      {	    		
 	    		jsHelper.Alert("권한이 불충분합니다.");
 	    		jsHelper.RedirectUrl("/main_home.do");
 	      }
 		    	
 	    }else
 	    {
 	        	jsHelper.Alert("세션이 만료 되었습니다.");
 	        	jsHelper.RedirectUrl("/main_home.do");
 	    }*/
              
    } 
    
    /**
     * QNA 입력 실행
     */
    @RequestMapping(value="/qnaInserteStart.do")
    public void qnaInserteStart(@ModelAttribute("manageVO"  ) ManageVO manageVO , HttpServletResponse response ,ModelMap model ) throws Exception
    {
        String users_id = null;
    	
    	HttpSession session = getSession();
    	if(session != null)
    	{
    		users_id = (String)session.getAttribute("userId");
    	}
    	/*
    	CommonSessionVO commonSessionVO = new CommonSessionVO();
        commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
        */
        if(users_id != null)
        {
    	manageVO.setUser_id(users_id);
    	manageVO.setBoard_gubun("QNA");
    	manageService.qnaInserteStart(manageVO);
    	jsHelper.AlertAndUrlGo("입력이 완료 되었습니다.", "/board_qna_home.do");
 		    	
 	    }else
 	    {
 	        	jsHelper.Alert("세션이 만료 되었습니다.");
 	        	jsHelper.RedirectUrl("/main_home.do");
 	    }
              
    }
    
    
    /**
     *  QNA 수정 페이지
     */
    @RequestMapping(value="/qnaDetailpage.do")
    public String qnaDetailpage(HttpServletRequest request ,HttpServletResponse response ,@ModelAttribute("manageVO") ManageVO vo
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
        		vo.setBoard_gubun("QNA");
		    	List qnaList =  manageService.noticeUpdatePage( vo );   
			    model.addAttribute("qnaList", qnaList);
			    model.addAttribute("userid", users_id);
        		
			    urlRediect = "admin/board/qna_edit" ;
		  }else
		  {
		  	jsHelper.Alert("세션이 만료 되었습니다.");
		  	jsHelper.RedirectUrl("/main_home.do");
		  }   
		  
	    return urlRediect;
// 	   return "admin/board/notice_add";  // 나중에 삭제		
 		    	
    }
    
    /**
     * QNA 수정 실행
     */
    @RequestMapping(value="/qnaUpdateStart.do")
    public void qnaUpdateStart(@ModelAttribute("manageVO"  ) ManageVO manageVO , HttpServletResponse response ,ModelMap model ) throws Exception
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
			manageVO.setBoard_gubun("QNA");
			manageService.noticeUpdateStart(manageVO);
			jsHelper.AlertAndUrlGo("수정이 완료 되었습니다.", "/board_qna_home.do");
			
		}else{
			jsHelper.Alert("세션이 만료 되었습니다.");
			jsHelper.RedirectUrl("/main_home.do");
		}   
  		  
    } 
    
    
    /**
     * QNA 삭제 실행
     */
    @RequestMapping(value="/qnaDeleteStart.do")
    public void qnaDeleteStart(@ModelAttribute("manageVO"  ) ManageVO manageVO , HttpServletResponse response ,ModelMap model ) throws Exception
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
			manageVO.setBoard_gubun("QNA");
			manageVO.setUse_at("N");
			model.addAttribute("userid", users_id);
			manageService.noticeUpdateStart(manageVO);
			jsHelper.AlertAndUrlGo("삭제가 완료 되었습니다.", "/board_qna_home.do");
			
			
		}else{
			jsHelper.Alert("세션이 만료 되었습니다.");
			jsHelper.RedirectUrl("/main_home.do");
		}   
		
  		  
    } 
    
    /**
     * QNA 댓글 입력 실행
     */
    @RequestMapping(value="/qna_reInserteStart.do")
    public void qna_reInserteStart(@ModelAttribute("manageVO"  ) ManageVO manageVO , HttpServletResponse response ,ModelMap model ) throws Exception
    {
        String users_id = null;
    	
    	HttpSession session = getSession();
    	if(session != null)
    	{
    		users_id = (String)session.getAttribute("userId");
    	}
    	/*
    	CommonSessionVO commonSessionVO = new CommonSessionVO();
        commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
        */
        if(users_id != null)
        {
    	manageVO.setUser_id(users_id);
    	manageVO.setBoard_gubun("QNA");
    	manageService.qna_reInserteStart(manageVO);
    	jsHelper.AlertAndUrlGo("입력이 완료 되었습니다.", "/board_qna_home.do");
 		    	
 	    }else
 	    {
 	        	jsHelper.Alert("세션이 만료 되었습니다.");
 	        	jsHelper.RedirectUrl("/main_home.do");
 	    }
              
    }
    
    

    
}
