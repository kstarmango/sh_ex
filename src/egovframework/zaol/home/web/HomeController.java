package egovframework.zaol.home.web;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.ModelAndView;

import egovframework.zaol.home.service.HomeVO;
import egovframework.zaol.manage.service.ManageService;
import egovframework.zaol.manage.service.ManageVO;
import egovframework.zaol.mbersbscrb.service.MbersbscrbService;
import egovframework.zaol.mbersbscrb.service.MbersbscrbVO;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.zaol.common.CommonUtil;
import egovframework.zaol.common.ICencryptUtils;
import egovframework.zaol.common.OraclePaginationInfo;
import egovframework.zaol.common.service.CommonService;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;
import egovframework.zaol.gisinfo.service.GisinfoPostgreVO;
import egovframework.zaol.gisinfo.service.GisinfoService;
import egovframework.zaol.home.service.HomeService;
import egovframework.zaol.util.service.StringUtil;
import egovframework.zaol.common.PostsqlPaginationInfo;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.comparator.LastModifiedFileComparator;
import org.apache.commons.io.filefilter.FileFileFilter;

@Controller
public class HomeController extends BaseController  {

    /** EgovPropertyService */ @Resource(name = "propertiesService") protected EgovPropertyService propertiesService;
    /** service Common */      @Resource(name = "CommonService"    ) private   CommonService       commonservice;
    /** service HoME*/      @Resource(name = "homeService"      ) private   HomeService         homeService;
    						
    public static Base64 enBase64 = new Base64(); 
    @Resource(name = "gisinfoService")     private   GisinfoService       gisinfoService;   
    @Resource(name = "mbersbscrbService")  private  MbersbscrbService mbersbscrbService;
    @Resource(name = "manageService") private   ManageService manageService;
    
    @RequestMapping(value="/imgLoading.do")
    public void imgLoading(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {
    	System.out.println("Default order");

    	String dir = "C:\\Users\\jonehong\\Desktop\\asssqq";
    	File[] f_list = new File(dir).listFiles();
    	Arrays.sort(f_list, LastModifiedFileComparator.LASTMODIFIED_COMPARATOR);
    	System.out.println("\nLast Modified Ascending Order (LASTMODIFIED_COMPARATOR)");
    	
    	String f_list_dir = null;
    	for (File file : f_list) {
    		if(file.isDirectory()){
    			System.out.printf("File: %-20s Last Modified:" + new Date(file.lastModified()) + "\n", file.getName());
    			f_list_dir = file.getName();
    		}    		
    	}
    	
    	
    	File directory = new File(dir+"\\"+f_list_dir);
    	File[] files = directory.listFiles((FileFilter) FileFileFilter.FILE);
    	
    	Arrays.sort(files, LastModifiedFileComparator.LASTMODIFIED_COMPARATOR);
    	System.out.println("\nLast Modified Descending Order (LASTMODIFIED_REVERSE)");

    	File img = null;
    	for (File file : files) {
    		
    		String ck = file.getName().substring(file.getName().lastIndexOf(".")+1).toLowerCase();
    		if( ck.equals("jpg") || ck.equals("jpeg") || ck.equals("png") || ck.equals("gif") ){
    			System.out.printf("File: %-20s Last Modified:" + new Date(file.lastModified()) + "\n", file.getName());
    			img =  file;
    		}
    	}
    	
    	
    	FileInputStream fis = null;
    	BufferedInputStream in = null;
        ByteArrayOutputStream bStream = null;
        try{
            fis = new FileInputStream(img);
            in = new BufferedInputStream(fis);
            bStream = new ByteArrayOutputStream();
            int imgByte;
            while ((imgByte = in.read()) != -1) {
            	bStream.write(imgByte);
            }
            response.setContentLength(bStream.size());
	
            bStream.writeTo(response.getOutputStream());
            response.getOutputStream().flush();
            response.getOutputStream().close();

        } catch (Exception e) {
        	e.printStackTrace();
        } 
        finally {
        	if (bStream != null) {
        		try {
        			bStream.close();
        		} catch (Exception est) {
        			est.printStackTrace();
        		}
        	}
       
        	if (in != null) {
        		try {in.close();}
        		catch (Exception ei) { ei.printStackTrace();	}
        	}
        	if (fis != null) {
        		try {fis.close();}
                catch (Exception efis) { efis.printStackTrace(); }
        	}
        }
    }
    
    @RequestMapping(value="/homeMain01.do")
    public String homeMain01(@ModelAttribute("homeVO"  ) HomeVO homeVO
                            ,@ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO, GisinfoPostgreVO vo
                            ,HttpServletRequest  request
                            ,HttpServletResponse response
                            ,ModelMap model
                            ) throws Exception
    {
    	   	
    /*	 HttpSession session = getSession();
         String userS_id = (String)session.getAttribute("userId");        
         
       if(userS_id == null){*/
    	   
       
    	/*
		//상세항목 선택지 리스트
    	List sigList  = gisinfoService.select_sig(vo);
    	List codeList_land  = gisinfoService.code_list_land(vo);
    	List codeList_buld  = gisinfoService.code_list_buld(vo);
    	List codeList_ps  = gisinfoService.code_list_ps(vo);    	
    	model.addAttribute("sigList"        , sigList       );
    	model.addAttribute("codeList_land"        , codeList_land       );
    	model.addAttribute("codeList_buld"        , codeList_buld       );
    	model.addAttribute("codeList_ps"        , codeList_ps       );
    	    	
    	//상세항목 선택지 범위(MAX/MIN)
    	String[] val_list = {"parea", "pnilp", "h_h", "a_flr", "p_area", "c_area"};
    	for( int i=0; i<val_list.length; i++ ) {
    		vo.setPAREA(null);
    		vo.setPNILP(null);
    		vo.setH_H(null);
    		vo.setA_FLR(null);
    		vo.setP_AREA(null);
    		vo.setC_AREA(null);
    		
    		if( val_list[i] == "parea"		){ vo.setPAREA("a"); }
			else if( val_list[i] == "pnilp"	){ vo.setPNILP("a"); }
			else if( val_list[i] == "h_h"	){ vo.setH_H("a"); }
			else if( val_list[i] == "a_flr"	){ vo.setA_FLR("a"); }
			else if( val_list[i] == "p_area"	){ vo.setP_AREA("a"); }
			else if( val_list[i] == "c_area"	){ vo.setC_AREA("a"); }
    		
    		int v_max = gisinfoService.max_val(vo);
    		int v_min = gisinfoService.min_val(vo);
    		
    		model.addAttribute("max_"+val_list[i], v_max );
        	model.addAttribute("min_"+val_list[i], v_min );
    	}
    	
    	//상세항목 분석지역 리스트
    	List sub_p_recovery  = gisinfoService.sub_p_recovery(vo);
    	List sub_p_housing  = gisinfoService.sub_p_housing(vo);
    	List sub_p_decline  = gisinfoService.sub_p_decline(vo);   
    	model.addAttribute("sub_p_recovery", sub_p_recovery);
    	model.addAttribute("sub_p_housing", sub_p_housing);  
   		*/
   		
    	return "/SH/back/Login_Main";
    	
//       	}else{
//       		
//       		session.setAttribute(set, arg1)
//       		jsHelper.RedirectUrl("/homeMain01.do");
//       		return null;
//       }
    	
       
    }
    
    
    
    @RequestMapping(value="/homeMain02.do")
    public String homeMain02(@ModelAttribute("homeVO"  ) HomeVO homeVO
                            ,GisinfoPostgreVO vo
                            ,HttpServletRequest  request
                            ,HttpServletResponse response
                            ,ModelMap model
                            ) throws Exception
    {
    	
//        HttpSession session = getSession();
//        String userS_id = (String)session.getAttribute("userId");        
        
        String homeMainUrl = "";
        
//        if(userS_id != null){
       	
	        homeMainUrl = "/SH/HomeMain";
	        /*
        }else{        	
           jsHelper.Alert("비정상적인 접근방식 입니다.");
       	   jsHelper.RedirectUrl("/homeMain01.do");
           homeMainUrl = null;        	 
        }
        */
        return homeMainUrl;
    }
   

    /**
     * 회원가입 페이지
     */
    @RequestMapping(value="/memberreg.do")
    public String memberreg(@ModelAttribute("homeVO"  ) HomeVO homeVO
                            ,HttpServletRequest  request
                            ,HttpServletResponse response
                            ,ModelMap model
                            ) throws Exception
    {
           
    	 List deptTopList =     homeService.deptTopList01     ( homeVO );  /* 목록조회 리스트       */
    	 
    	 model.addAttribute("deptTopList"      , deptTopList     );
    	 return "SH/Member_reg";
    }
    
    /**
     * 회원 가입 실행
     */
    @RequestMapping(value="/memberregStart.do")
    public String memberregStart(@ModelAttribute("homeVO"  ) HomeVO homeVO
                            ,HttpServletRequest  request
                            ,HttpServletResponse response
                            ,ModelMap model
                            ) throws Exception
    {
           
    	 String user_id      = CommonUtil.NVL(request.getParameter("user_id"     ),"");
         String user_password = CommonUtil.NVL(request.getParameter("user_password"),"");
         
    	 homeService.shMemberInsert(homeVO);    	 
    	jsHelper.AlertAndClose("회원가입이 완료 되었습니다.");
    	return null;
    }
    
    /**
     * 회원정보 변경 수정 화면
     */
    @RequestMapping(value="/memberupt.do")
    @Transactional     
    public String memberupt(@ModelAttribute("homeVO"  ) HomeVO homeVO
                                       ,HttpServletRequest  request
                                       ,HttpServletResponse response
                                       ,SessionStatus status
                                       ,ModelMap model
                                       ) throws Exception
    {

        //session 값 세팅 decrypt
        HttpSession     session         = request.getSession(false);            // 세션객체
        CommonSessionVO commonSessionVO = null;

        if (session != null)
        {
            commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
        }

        if(commonSessionVO != null) 
        {
        	homeVO.setUser_id( StringUtil.nullConvert(commonSessionVO.getUser_id() ) );
        }//end if

        HomeVO view01    = homeService.selectMebersinfo(homeVO);
        List deptTopList = homeService.deptTopList01(view01 );  
        List midList 	 = homeService.selectMidleList(view01.getTop_cd());
        view01.setParent_dept_sub(view01.getMiddle_cd());
        view01.setParent_dept_top2(view01.getTop_cd());
        List subList 	 = homeService.selectSubList(view01);
        
        
        model.addAttribute("view01", view01);
        model.addAttribute("deptTopList"      , deptTopList     );
        model.addAttribute("midList", midList);
        model.addAttribute("subList", subList);
       
        return "SH/Member_upt";
    }
    
    /**
     * 회원 수정 실행
     */
    @RequestMapping(value="/memberutpStart.do")
    public String memberutpStart(@ModelAttribute("homeVO"  ) HomeVO homeVO
                            ,HttpServletRequest  request
                            ,HttpServletResponse response
                            ,ModelMap model
                            ) throws Exception
    {
    	    	 
        HttpSession     session         = request.getSession(false);            
        CommonSessionVO commonSessionVO = null;

        if (session != null){ commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); }
        
        if(commonSessionVO != null){ homeVO.setUser_id( StringUtil.nullConvert(commonSessionVO.getUser_id() ) ); /* 사용자ID */ }//end if
           
        String o_user_password = CommonUtil.NVL(request.getParameter("o_user_password"),"");
        String user_password   = CommonUtil.NVL(request.getParameter("user_password"  ),"");
        String passconfirm     = CommonUtil.NVL(request.getParameter("passconfirm"    ),"");
        
         
        HomeVO view01 = (HomeVO)homeService.selectMebersinfo(homeVO);

        if(!o_user_password.equals(decrypt(view01.getUser_pass())))
        {
            jsHelper.AlertAndUrlGo("기존비밀번호가 일치하지 않아 수정에 실패하였습니다.", "/memberupt.do");
        }else{
        	homeService.updateMemberupt(homeVO);            
            jsHelper.AlertAndClose("정상적으로 수정 되었습니다.");
        	
        }

        return null;
    }
    
    /**
     * 비밀번호 초기화
     */
    @RequestMapping(value="/memResetpass99.do")
    public String memResetpass(@ModelAttribute("homeVO"  ) HomeVO homeVO
    						,HttpServletRequest  request
                            ,HttpServletResponse response
                            ,ModelMap model
                            ) throws Exception{
    
    	HttpSession     session         = request.getSession(false);            
        CommonSessionVO commonSessionVO = null;

        if (session != null){ commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); }
        
        if(commonSessionVO != null){ homeVO.setUser_id( StringUtil.nullConvert(commonSessionVO.getUser_id() ) ); /* 사용자ID */ }//end if
           
        homeVO.setUser_id(request.getParameter("id"));
        homeService.resetPass(homeVO);   
        
    	jsHelper.AlertAndClose("비밀번호가 [SH1234]으로 초기화 되었습니다.");
    	return null;
    }
    
    /**
     * 권한 수정 실행
     */
    @RequestMapping(value="/memAuthudp01.do")
    public void memAuthudp01(@ModelAttribute("homeVO"  ) HomeVO homeVO
                            ,HttpServletRequest  request
                            ,HttpServletResponse response
                            ,ModelMap model
                            ) throws Exception
    {
    	    	 
        HttpSession     session         = request.getSession(false);            
        CommonSessionVO commonSessionVO = null;

        if (session != null){ commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); }
        
        if(commonSessionVO != null){ homeVO.setUser_id( StringUtil.nullConvert(commonSessionVO.getUser_id() ) ); /* 사용자ID */ }//end if
           
        String user_id = CommonUtil.NVL(request.getParameter("user_id"),"");
        homeVO.setUser_id(user_id);
    	
    	if("admin".equals(commonSessionVO.getUser_id())){
    		
    		  homeService.memAuthudp01(homeVO); 
    		  
    		  
    		 jsHelper.AlertAndUrlGo("수정이 완료 되었습니다.", "/userListpage.do");
    		
    	}else{
    		
    		jsHelper.Alert("권한이 불충분합니다.");
    	  
    	}
    }
         
    /**
     * 관리자 유저 리스트 페이지
     */
    @RequestMapping(value="/userListpage.do")
    public String userListpage(HttpServletRequest request
    		                   ,HttpServletResponse response
    		                   ,@ModelAttribute("homeVO") HomeVO homeVO
    		                   ,ModelMap model) throws Exception
    {
    	request.setCharacterEncoding("UTF-8");
    	response.setCharacterEncoding("UTF-8");
    	
    	HttpSession session = getSession();
    	CommonSessionVO commonSessionVO = new CommonSessionVO();
        commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
    	
    	if("admin".equals(commonSessionVO.getUser_id())){
	    	
	    	/** 페이징 */
	        if( homeVO.getPageUnit() == 0 ) { homeVO.setPageUnit(propertiesService.getInt("pageUnit")); }
	        if( homeVO.getPageSize() == 0 ) { homeVO.setPageSize(propertiesService.getInt("pageSize")); }
	
	        OraclePaginationInfo view01Cnt = new OraclePaginationInfo();
	
	        view01Cnt.setCurrentPageNo     (homeVO.getPageIndex());
	        view01Cnt.setRecordCountPerPage(homeVO.getPageUnit() );
	        view01Cnt.setPageSize          (homeVO.getPageSize() );
	
	        homeVO.setFirstIndex             (view01Cnt.getFirstRecordIndex()  );
	        homeVO.setLastIndex              (view01Cnt.getLastRecordIndex()   );
	        homeVO.setRecordCountPerPage     (view01Cnt.getRecordCountPerPage());
	       
	        List boardList =  homeService.userListPage( homeVO );   
	             view01Cnt.setTotalRecordCount  (homeService.userListCnt( homeVO )   );
	        
	       
	        /** 페이징 */
	        model.addAttribute("boardList"      , boardList     );
	        model.addAttribute("paginationInfo" , view01Cnt);
        
        	return "/SH/Stats_page";
        
    	}else{
    		
    		jsHelper.Alert("권한이 불충분합니다.");
    	    return null;
    	}
        
		
    }
    
    /**
     * 관리자 유저 상세 페이지
     */
    @RequestMapping(value="/userDetailpage.do")
    public String userDetailpage(HttpServletRequest request
    		                   ,HttpServletResponse response
    		                   ,@ModelAttribute("homeVO") HomeVO homeVO
    		                   ,ModelMap model) throws Exception
    {
    	request.setCharacterEncoding("UTF-8");
    	response.setCharacterEncoding("UTF-8");
    	
    	
    	HttpSession session = getSession();
    	CommonSessionVO commonSessionVO = new CommonSessionVO();
        commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
        
        String user_id = CommonUtil.NVL(request.getParameter("user_id"),"");
        homeVO.setUser_id(user_id);
    	
    	if("admin".equals(commonSessionVO.getUser_id())){
    		
    		  HomeVO view01    = homeService.selectMebersinfo(homeVO);
    	      model.addAttribute("view01", view01);
    	     
    		
    		return "/SH/Stats_detail";
    		
    	}else{
    		
    		jsHelper.Alert("권한이 불충분합니다.");
    	    return null;
    	}
    }
    
  /**
   * 공지사항 리스트 페이지
   */
  @RequestMapping(value="/noticeListPage.do")
  public String noticeListPage(HttpServletRequest request
  		                   ,HttpServletResponse response
  		                   ,@ModelAttribute("homeVO") HomeVO homeVO
  		                   ,ModelMap model) throws Exception
  {
  	request.setCharacterEncoding("UTF-8");
  	response.setCharacterEncoding("UTF-8");
    
	/** 페이징 */
    if( homeVO.getPageUnit() == 0 ) { homeVO.setPageUnit(propertiesService.getInt("pageUnit")); }
    if( homeVO.getPageSize() == 0 ) { homeVO.setPageSize(propertiesService.getInt("pageSize")); }

    OraclePaginationInfo view01Cnt = new OraclePaginationInfo();

    view01Cnt.setCurrentPageNo     (homeVO.getPageIndex());
    view01Cnt.setRecordCountPerPage(homeVO.getPageUnit() );
    view01Cnt.setPageSize          (homeVO.getPageSize() );

    homeVO.setFirstIndex             (view01Cnt.getFirstRecordIndex()  );
    homeVO.setLastIndex              (view01Cnt.getLastRecordIndex()   );
    homeVO.setRecordCountPerPage     (view01Cnt.getRecordCountPerPage());
    homeVO.setBg_gb("NOTICE");
    
    List noticeList =  homeService.noticeListPage( homeVO );   
         view01Cnt.setTotalRecordCount  (homeService.noticeListPageCnt( homeVO )   );
    
   /** 페이징 */
   int cpNo  = view01Cnt.getCurrentPageNo(); // 현재 페이지
   int pSize = view01Cnt.getPageSize();      // 보여줄 페이지 사이즈
   
    model.addAttribute("noticeList"      , noticeList     );
    model.addAttribute("num" , view01Cnt.getTotalRecordCount()-(cpNo-1)*pSize);
    model.addAttribute("paginationInfo" , view01Cnt);
  
    return "/SH/Notice_page";
		
  }
    
  /**
   *  공지사항 상세
   */
  @RequestMapping(value="/noticeDetailpage.do")
  public String noticeDetailpage(HttpServletRequest request
  		                   ,HttpServletResponse response
  		                   ,@ModelAttribute("homeVO") HomeVO homeVO
  		                   ,ModelMap model) throws Exception
  {
  	request.setCharacterEncoding("UTF-8");
  	response.setCharacterEncoding("UTF-8");
  	
  	
  	HttpSession session = getSession();
  	CommonSessionVO commonSessionVO = new CommonSessionVO();
    commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
      
    String board_sno = CommonUtil.NVL(request.getParameter("board_sno"),"");
	homeVO.setSeq(board_sno);
		
	HomeVO view01    = homeService.selectBoardData(homeVO);
	model.addAttribute("view01", view01);
	return "/SH/Notice_detail";			
  	
  }
  
  /**
   *  공지사항 수정 페이지
   */
  @RequestMapping(value="/noticeUppage.do")
  public String noticeUppage(HttpServletRequest request
  		                   ,HttpServletResponse response
  		                   ,@ModelAttribute("homeVO") HomeVO homeVO
  		                   ,ModelMap model) throws Exception
  {
  	request.setCharacterEncoding("UTF-8");
  	response.setCharacterEncoding("UTF-8");
  	
  	
  	HttpSession session = getSession();
  	CommonSessionVO commonSessionVO = new CommonSessionVO();
    commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
      
    String board_sno = CommonUtil.NVL(request.getParameter("tset"),"");
	homeVO.setSeq(board_sno);
		
	HomeVO view01    = homeService.selectBoardData(homeVO);
	model.addAttribute("view01", view01);
	return "/SH/Notice_update";			
  	
  }
   
   /**
    * 공지사항 수정 실행
    */
   @RequestMapping(value="/noticeUppageStart.do")
   public void noticeUppageStart(@ModelAttribute("homeVO"  ) HomeVO homeVO
                          ,HttpServletRequest  request
                          ,HttpServletResponse response
                          ,ModelMap model
                          ) throws Exception
   {
  	    	 
      HttpSession     session         = request.getSession(false);            
      CommonSessionVO commonSessionVO = null;

      if (session != null){ commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); }
      
      if(commonSessionVO != null){ homeVO.setUser_id( StringUtil.nullConvert(commonSessionVO.getUser_id() ) ); /* 사용자ID */ }//end if
      int boadsnp = Integer.parseInt(CommonUtil.NVL(request.getParameter("tset"),""));
      homeVO.setSeq_int(boadsnp);      

		String notice_yn = request.getParameter( "notice_yn" );
		if( notice_yn == "" || notice_yn == null ){ }else{ homeVO.setUse_at(notice_yn); }
  	
      if("admin".equals(commonSessionVO.getUser_id()))
      {
          
         homeService.updateNoticeupt(homeVO);            
         jsHelper.AlertAndUrlGo("수정이 완료 되었습니다.", "/noticeListPage.do");
      	      
      }else{
    	  
    	 jsHelper.AlertAndUrlGo("권한이 불충분 합니다.", "/noticeListPage.do");
      	
      }     
   } 
   
     
   /**
    * 공지사항 삭제
    */
   @RequestMapping(value="/nDelStart.do")
   public void nDelStart(@ModelAttribute("homeVO"  ) HomeVO homeVO
                          ,HttpServletRequest  request
                          ,HttpServletResponse response
                          ,ModelMap model
                          ) throws Exception
   {
  	    	 
      HttpSession     session         = request.getSession(false);            
      CommonSessionVO commonSessionVO = null;

      if (session != null){ commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); }
      
      if(commonSessionVO != null){ homeVO.setUser_id( StringUtil.nullConvert(commonSessionVO.getUser_id() ) ); /* 사용자ID */ }//end if
      int boadsnp = Integer.parseInt(CommonUtil.NVL(request.getParameter("tset"),""));
      String idss = CommonUtil.NVL(request.getParameter("ids"),"");
      homeVO.setSeq_int(boadsnp);
      
      if("admin".equals(commonSessionVO.getUser_id()))
      {
          
         homeService.qDelStar(homeVO);            
         jsHelper.AlertAndUrlGo("삭제가 완료 되었습니다.", "/noticeListPage.do");
      	      
      }else{
    	  
    	 jsHelper.AlertAndUrlGo("권한이 불충분 합니다.", "/noticeListPage.do");
      	
      }     
   } 
   
   /**
    * QnA 리스트 페이지
    */
   @RequestMapping(value="/qistPage.do")
   public String qistPage(HttpServletRequest request
   		                   ,HttpServletResponse response
   		                   ,@ModelAttribute("homeVO") HomeVO homeVO
   		                   ,ModelMap model) throws Exception
   {
   	request.setCharacterEncoding("UTF-8");
   	response.setCharacterEncoding("UTF-8");
     
 	/** 페이징 */
     if( homeVO.getPageUnit() == 0 ) { homeVO.setPageUnit(propertiesService.getInt("pageUnit")); }
     if( homeVO.getPageSize() == 0 ) { homeVO.setPageSize(propertiesService.getInt("pageSize")); }

     OraclePaginationInfo view01Cnt = new OraclePaginationInfo();

     view01Cnt.setCurrentPageNo     (homeVO.getPageIndex());
     view01Cnt.setRecordCountPerPage(homeVO.getPageUnit() );
     view01Cnt.setPageSize          (homeVO.getPageSize() );

     homeVO.setFirstIndex             (view01Cnt.getFirstRecordIndex()  );
     homeVO.setLastIndex              (view01Cnt.getLastRecordIndex()   );
     homeVO.setRecordCountPerPage     (view01Cnt.getRecordCountPerPage());
     homeVO.setBg_gb("QNA");
     
     List qsList =  homeService.qListPage( homeVO );   
          view01Cnt.setTotalRecordCount  (homeService.qListPageCnt( homeVO )   );
     /** 페이징 */
     int cpNo  = view01Cnt.getCurrentPageNo(); // 현재 페이지
     int pSize = view01Cnt.getPageSize();      // 보여줄 페이지 사이즈
     
     model.addAttribute("qsList"      , qsList     );
     
     model.addAttribute("paginationInfo" , view01Cnt);
     model.addAttribute("num" , view01Cnt.getTotalRecordCount()-(cpNo-1)*pSize);
   
     return "/SH/Qna_page"; 
 		
   }
  
   /**
    *  QNA 상세
    */
   @RequestMapping(value="/qDetailpage.do")
   public String qDetailpage(HttpServletRequest request
   		                   ,HttpServletResponse response
   		                   ,@ModelAttribute("homeVO") HomeVO homeVO
   		                   ,ModelMap model) throws Exception
   {
   	request.setCharacterEncoding("UTF-8");
   	response.setCharacterEncoding("UTF-8");
   	
   	
   	HttpSession session = getSession();
   	CommonSessionVO commonSessionVO = new CommonSessionVO();
     commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
       
    String board_sno = CommonUtil.NVL(request.getParameter("board_sno"),"");
 	homeVO.setSeq(board_sno);
 		
 	HomeVO view01    = homeService.selectBoardData(homeVO);
 	model.addAttribute("view01", view01);
 	return "/SH/Qna_detail";			
   	
   }
   
   /**
    *  QNA 수정 페이지
    */
   @RequestMapping(value="/qUppage.do")
   public String qUppage(HttpServletRequest request
   		                   ,HttpServletResponse response
   		                   ,@ModelAttribute("homeVO") HomeVO homeVO
   		                   ,ModelMap model) throws Exception
   {
   	request.setCharacterEncoding("UTF-8");
   	response.setCharacterEncoding("UTF-8");
   	
   	
   	HttpSession session = getSession();
   	CommonSessionVO commonSessionVO = new CommonSessionVO();
     commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
       
     String board_sno = CommonUtil.NVL(request.getParameter("tset"),"");
 	homeVO.setSeq(board_sno);
 		
 	HomeVO view01    = homeService.selectBoardData(homeVO);
 	model.addAttribute("view01", view01);
 	return "/SH/Qna_update";			
   	
   }
   
   /**
    * QNA  수정 실행
    */
   @RequestMapping(value="/qUppageStart.do")
   public void qUppageStart(@ModelAttribute("homeVO"  ) HomeVO homeVO
                          ,HttpServletRequest  request
                          ,HttpServletResponse response
                          ,ModelMap model
                          ) throws Exception
   {
  	    	 
      HttpSession     session         = request.getSession(false);            
      CommonSessionVO commonSessionVO = null;

      if (session != null){ commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); }
      
      if(commonSessionVO != null){ homeVO.setUser_id( StringUtil.nullConvert(commonSessionVO.getUser_id() ) ); /* 사용자ID */ }//end if
      int boadsnp = Integer.parseInt(CommonUtil.NVL(request.getParameter("tset"),""));
      String idss = CommonUtil.NVL(request.getParameter("ids"),"");
      
      homeVO.setSeq_int(boadsnp);
      
      if(idss.equals(commonSessionVO.getUser_id()))
      {          
         homeService.updateQeupt(homeVO);            
         jsHelper.AlertAndUrlGo("수정이 완료 되었습니다.", "/qistPage.do");
      	      
      }else{
    	  
    	 jsHelper.AlertAndUrlGo("권한이 불충분 합니다.", "/qistPage.do");
      	
      }     
   } 
   
   /**
    * Qna 삭제
    */
   @RequestMapping(value="/qDelStart.do")
   public void qDelStart(@ModelAttribute("homeVO"  ) HomeVO homeVO
                          ,HttpServletRequest  request
                          ,HttpServletResponse response
                          ,ModelMap model
                          ) throws Exception
   {
  	    	 
      HttpSession     session         = request.getSession(false);            
      CommonSessionVO commonSessionVO = null;

      if (session != null){ commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); }
      
      if(commonSessionVO != null){ homeVO.setUser_id( StringUtil.nullConvert(commonSessionVO.getUser_id() ) ); /* 사용자ID */ }//end if
      int boadsnp = Integer.parseInt(CommonUtil.NVL(request.getParameter("tset"),""));
      String idss = CommonUtil.NVL(request.getParameter("ids"),"");
      homeVO.setSeq_int(boadsnp);
      
      if(idss.equals(commonSessionVO.getUser_id()))
      {
          
         homeService.qDelStar(homeVO);            
         jsHelper.AlertAndUrlGo("삭제가 완료 되었습니다.", "/qistPage.do");
      	      
      }else{
    	  
    	 jsHelper.AlertAndUrlGo("권한이 불충분 합니다.", "/qistPage.do");
      	
      }     
   }  
   
   
   /**
    *  Qna 입력 페이지
    */
   @RequestMapping(value="/qInsert.do")
   public String qInsert(HttpServletRequest request
   		                   ,HttpServletResponse response
   		                   ,@ModelAttribute("homeVO") HomeVO homeVO
   		                   ,ModelMap model) throws Exception
   {
   		request.setCharacterEncoding("UTF-8");
	   	response.setCharacterEncoding("UTF-8");
	   	
	   	
	   	HttpSession session = getSession();
	   	
	   	if(session != null ){    		
    		session = request.getSession(); // 세션 없으면 세션 생성
    	}
	   	CommonSessionVO commonSessionVO = new CommonSessionVO();
	    commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); 
	       
	    String user_ids = CommonUtil.NVL(commonSessionVO.getUser_id(),"");
	  
	    if("".equals(commonSessionVO.getUser_id())){
	    
		  jsHelper.Alert("권한이 불충분 합니다.");
		  return "/SH/Qna_page";	    		
	    	
	    }else{
	   	    homeVO.setUser_id(user_ids);
	  	    HomeVO view01 = homeService.selectMebersinfo(homeVO);
	  	    model.addAttribute("view01", view01);
	      return "/SH/Qna_new";	
	    }
   }
   
   /**
    * qna 입력 실행
    */
   @RequestMapping(value="/qInserteStart.do")
   public void qInserteStart(@ModelAttribute("homeVO"  ) HomeVO homeVO
                          ,HttpServletRequest  request
                          ,HttpServletResponse response
                          ,ModelMap model
                          ) throws Exception
   {
  	    	 
      HttpSession     session         = request.getSession(false);            
      CommonSessionVO commonSessionVO = null;

      if (session != null){ commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); }
      
      if(commonSessionVO != null){ homeVO.setUser_id( StringUtil.nullConvert(commonSessionVO.getUser_id() ) ); /* 사용자ID */ }//end if
      String idss = CommonUtil.NVL(request.getParameter("idsfilter"),"");
      String namss = CommonUtil.NVL(request.getParameter("nameFiter"),"");
      
      homeVO.setRegest_id(idss);
      homeVO.setBoard_gubun("QNA");
      homeVO.setUser_nm(namss);
      
      
         homeService.qInserteStart(homeVO);            
         jsHelper.AlertAndUrlGo("입력이 완료 되었습니다.", "/qistPage.do");
      	
          
   } 
   
   /**
    * 자료신청 리스트 페이지
    */
   @RequestMapping(value="/referPage.do")
   public String referPage(HttpServletRequest request
   		                   ,HttpServletResponse response
   		                   ,@ModelAttribute("homeVO") HomeVO homeVO
   		                   ,ModelMap model) throws Exception
   {
   	request.setCharacterEncoding("UTF-8");
   	response.setCharacterEncoding("UTF-8");
     
 	/** 페이징 */
     if( homeVO.getPageUnit() == 0 ) { homeVO.setPageUnit(propertiesService.getInt("pageUnit")); }
     if( homeVO.getPageSize() == 0 ) { homeVO.setPageSize(propertiesService.getInt("pageSize")); }

     OraclePaginationInfo view01Cnt = new OraclePaginationInfo();

     view01Cnt.setCurrentPageNo     (homeVO.getPageIndex());
     view01Cnt.setRecordCountPerPage(homeVO.getPageUnit() );
     view01Cnt.setPageSize          (homeVO.getPageSize() );

     homeVO.setFirstIndex             (view01Cnt.getFirstRecordIndex()  );
     homeVO.setLastIndex              (view01Cnt.getLastRecordIndex()   );
     homeVO.setRecordCountPerPage     (view01Cnt.getRecordCountPerPage());
     homeVO.setBg_gb("LBRTYBBS");
     
     List qsList =  homeService.qListPage( homeVO );   
          view01Cnt.setTotalRecordCount  (homeService.qListPageCnt( homeVO ));     
     
     int cpNo  = view01Cnt.getCurrentPageNo(); // 현재 페이지
     int pSize = view01Cnt.getPageSize();      // 보여줄 페이지 사이즈
         
     /** 페이징 */
     model.addAttribute("qsList"      , qsList     );
     model.addAttribute("num" , view01Cnt.getTotalRecordCount()-(cpNo-1)*pSize);
     model.addAttribute("paginationInfo" , view01Cnt);
   
     return "/SH/Refer_page"; 
 		
   }
   
   /**
    *  자료신청 상세
    */
   @RequestMapping(value="/rDetailpage.do")
   public String rDetailpage(HttpServletRequest request
   		                   ,HttpServletResponse response
   		                   ,@ModelAttribute("homeVO") HomeVO homeVO
   		                   ,ModelMap model) throws Exception
   {
   	request.setCharacterEncoding("UTF-8");
   	response.setCharacterEncoding("UTF-8");
   	
   	
   	HttpSession session = getSession();
   	CommonSessionVO commonSessionVO = new CommonSessionVO();
     commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
       
    String board_sno = CommonUtil.NVL(request.getParameter("board_sno"),"");
 	homeVO.setSeq(board_sno);
 		
 	HomeVO view01    = homeService.selectBoardData(homeVO);
 	model.addAttribute("view01", view01);
 	return "/SH/Refer_detail";			
   	
   }
   
   /**
    *  자료신청 수정 페이지
    */
   @RequestMapping(value="/rUppage.do")
   public String rUppage(HttpServletRequest request
   		                   ,HttpServletResponse response
   		                   ,@ModelAttribute("homeVO") HomeVO homeVO
   		                   ,ModelMap model) throws Exception
   {
   	request.setCharacterEncoding("UTF-8");
   	response.setCharacterEncoding("UTF-8");
   	
   	
   	HttpSession session = getSession();
   	CommonSessionVO commonSessionVO = new CommonSessionVO();
     commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
       
     String board_sno = CommonUtil.NVL(request.getParameter("tset"),"");
 	homeVO.setSeq(board_sno);
 		
 	HomeVO view01    = homeService.selectBoardData(homeVO);
 	model.addAttribute("view01", view01);
 	return "/SH/Refer_update";			
   	
   }
   
   /**
    * 자료신청  수정 실행
    */
   @RequestMapping(value="/rUppageStart.do")
   public void rUppageStart(@ModelAttribute("homeVO"  ) HomeVO homeVO
                          ,HttpServletRequest  request
                          ,HttpServletResponse response
                          ,ModelMap model
                          ) throws Exception
   {
  	    	 
      HttpSession     session         = request.getSession(false);            
      CommonSessionVO commonSessionVO = null;

      if (session != null){ commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); }
      
      if(commonSessionVO != null){ homeVO.setUser_id( StringUtil.nullConvert(commonSessionVO.getUser_id() ) ); /* 사용자ID */ }//end if
      int boadsnp = Integer.parseInt(CommonUtil.NVL(request.getParameter("tset"),""));
      String idss = CommonUtil.NVL(request.getParameter("ids"),"");
      
      homeVO.setSeq_int(boadsnp);
      
      if(idss.equals(commonSessionVO.getUser_id()))
      {          
         homeService.updateQeupt(homeVO);            
         jsHelper.AlertAndUrlGo("수정이 완료 되었습니다.", "/referPage.do");
      	      
      }else{
    	  
    	 jsHelper.AlertAndUrlGo("권한이 불충분 합니다.", "/referPage.do");
      	
      }     
   } 
   
   /**
    * 자료신청 삭제 
    */
   @RequestMapping(value="/rDelStart.do")
   public void rDelStart(@ModelAttribute("homeVO"  ) HomeVO homeVO
                          ,HttpServletRequest  request
                          ,HttpServletResponse response
                          ,ModelMap model
                          ) throws Exception
   {
  	    	 
      HttpSession     session         = request.getSession(false);            
      CommonSessionVO commonSessionVO = null;

      if (session != null){ commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); }
      
      if(commonSessionVO != null){ homeVO.setUser_id( StringUtil.nullConvert(commonSessionVO.getUser_id() ) ); /* 사용자ID */ }//end if
      int boadsnp = Integer.parseInt(CommonUtil.NVL(request.getParameter("tset"),""));
      String idss = CommonUtil.NVL(request.getParameter("ids"),"");
      homeVO.setSeq_int(boadsnp);
      
      if(idss.equals(commonSessionVO.getUser_id()))
      {
          
         homeService.qDelStar(homeVO);            
         jsHelper.AlertAndUrlGo("삭제가 완료 되었습니다.", "/referPage.do");
      	      
      }else{
    	  
    	 jsHelper.AlertAndUrlGo("권한이 불충분 합니다.", "/referPage.do");
      	
      }     
   } 
   
   /**
    *  자료신청 입력 페이지
    */
   @RequestMapping(value="/rInsert.do")
   public String rInsert(HttpServletRequest request
   		                   ,HttpServletResponse response
   		                   ,@ModelAttribute("homeVO") HomeVO homeVO
   		                   ,ModelMap model) throws Exception
   {
		request.setCharacterEncoding("UTF-8");
	   	response.setCharacterEncoding("UTF-8");
	   	
	   	
	   	HttpSession session = getSession();
	   	
	   	if(session != null ){    		
    		session = request.getSession(); // 세션 없으면 세션 생성
    	}
	   	CommonSessionVO commonSessionVO = new CommonSessionVO();
	    commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); 
	       
	    String user_ids = CommonUtil.NVL(commonSessionVO.getUser_id(),"");
	  
	    if("".equals(commonSessionVO.getUser_id())){
	    
		  jsHelper.Alert("권한이 불충분 합니다.");
		  return "/SH/Refer_page";	    		
	    	
	    }else{
	   	    homeVO.setUser_id(user_ids);
	  	    HomeVO view01 = homeService.selectMebersinfo(homeVO);
	  	    model.addAttribute("view01", view01);
	      return "/SH/Refer_new";	
	    }
   }
   
   /**
    * 자료신청 입력 실행
    */
   @RequestMapping(value="/rinserteStart.do")
   public void rinserteStart(@ModelAttribute("homeVO"  ) HomeVO homeVO
                          ,HttpServletRequest  request
                          ,HttpServletResponse response
                          ,ModelMap model
                          ) throws Exception
   {
  	    	 
      HttpSession     session         = request.getSession(false);            
      CommonSessionVO commonSessionVO = null;

      if (session != null){ commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); }
      
      if(commonSessionVO != null){ homeVO.setUser_id( StringUtil.nullConvert(commonSessionVO.getUser_id() ) ); /* 사용자ID */ }//end if
      String idss = CommonUtil.NVL(request.getParameter("idsfilter"),"");
      String namss = CommonUtil.NVL(request.getParameter("nameFiter"),"");
      
      homeVO.setRegest_id(idss);
      homeVO.setBoard_gubun("LBRTYBBS");
      homeVO.setUser_nm(namss);
      
    
         homeService.qInserteStart(homeVO);            
         jsHelper.AlertAndUrlGo("입력이 완료 되었습니다.", "/referPage.do");
         
   } 
   
   
    /**
	 * 중분류 가져오기
	 *
		 */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/deptSearch.do")
	public String deptSearch(
			HttpServletResponse response,
			HttpServletRequest request,
			@ModelAttribute("homeVO") HomeVO homeVO,
    		ModelMap model)
            throws Exception {

    	String parent_dept_top = StringUtil.isNullToString((String)request.getParameter("parent_dept_top"));


		List midList 	= homeService.selectMidleList(parent_dept_top);
		model.addAttribute("midList", midList);
		
		//

		StringBuffer sbufXML = new StringBuffer();
		HomeVO homevo = null;

		if (midList == null) {
			sbufXML.append( "" );
		} else {
			for( int i=0; i<midList.size(); i++ ) {
				homevo = (HomeVO)midList.get(i);

				sbufXML.append( homevo.getMiddle_cd() + "|" + homevo.getDept_name() + "@");
			}
		}

		model.addAttribute("sbufXML", sbufXML);

		return "SH/ajaxSelectList";
    }
    
    /**
	 * 소분류 가져오기
	 *
	 * @param String
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/deptSubSearch.do")
	public String deptSubSearch(
			HttpServletResponse response,
			HttpServletRequest request,
			@ModelAttribute("homeVO") HomeVO homeVO,
    		ModelMap model)
            throws Exception {

    	String parent_dept_sub = StringUtil.isNullToString((String)request.getParameter("parent_dept_sub"));
    	String parent_dept_top2 = StringUtil.isNullToString((String)request.getParameter("parent_dept_top2"));
    	
    	homeVO.setParent_dept_sub(parent_dept_sub);
    	homeVO.setParent_dept_top2(parent_dept_top2);

		List subList 	= homeService.selectSubList(homeVO); 
		model.addAttribute("subList", subList);
		//

		StringBuffer sbufXML = new StringBuffer();
		HomeVO homevo = null;

		if (subList == null) {
			sbufXML.append( "" );
		} else {
			for( int i=0; i<subList.size(); i++ ) {
				homevo = (HomeVO)subList.get(i);

				sbufXML.append( homevo.getSub_cd() + "|" + homevo.getDept_name() + "@");
			}
		}

		model.addAttribute("sbufXML", sbufXML);

		return "SH/ajaxSelectList";
    }
    
    /**
     *  아이디 중복체크 
     */
    @RequestMapping(value="/userIdDplctAjax01.do")
    public String userIdDplctAjax01(
            @ModelAttribute("homeVO") HomeVO homeVO,
            HttpServletRequest  request,
            HttpServletResponse response,
            ModelMap model)
            throws Exception
    {
        
        String rslt_login_id = ""; /* 결과 로그인ID */

        homeVO.setUser_id(CommonUtil.NVL( request.getParameter("user_id") ) ); /* 로그인ID    */

        HomeVO view01 = homeService.userIdDplctAjax01(homeVO);

        if(view01 != null)
        {
            rslt_login_id     = CommonUtil.NVL(view01.getUser_id(),"");       /* 로그인ID */
        }
     
        StringBuffer sbufXML = new StringBuffer();
        sbufXML.append(rslt_login_id); /* 결과 사용자 ID  */
        model.addAttribute("sbufXML", sbufXML);

        return "SH/ajaxSelectList";

    }
    /*
     * 패스워드 암호화
     * */
    public static String encrypt(String enc){
    	
    	return new String(Base64.encodeBase64(enc.getBytes()));
    }
    
    /*
     * 패스워드 복호화
     * */
    public static String decrypt(String dec){
    	
    	return new String(Base64.decodeBase64(dec.getBytes()));
    	
    }

    
    
    /**
     * 공지사항 알림 팝업창
     */
    @RequestMapping(value="/jsp/SH/popup_notice.do")
    public String popup_notice(HttpServletRequest request
    		                   ,HttpServletResponse response
    		                   ,@ModelAttribute("homeVO") HomeVO homeVO
    		                   ,ModelMap model) throws Exception
    {
    	request.setCharacterEncoding("UTF-8");
    	response.setCharacterEncoding("UTF-8");

    	
    	homeVO.setSeq(request.getParameter("seq"));
	     System.out.println("알림팝업");
	    List noticePopup  = homeService.noticePopup(homeVO);   
	  	model.addAttribute("noticePopup", noticePopup);
	
	    
	    return "/SH/pop_notice";
    }
    
    
    //고도화 시작-----------------------------------------------------------------------------------------------------------------------------------
   
    
    /**
     * 메인 페이지
     * */
    /*
    @RequestMapping(value="/main_home.do")
    public String main_home(@ModelAttribute("homeVO"  ) HomeVO homeVO, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
                            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {    	 
    	return "/SH/login/Main";    	
    }*/
    
    /**
     * 로그인 액션
     */
    /*
    @RequestMapping(value="/homeLogin01.do")
    public String homeLogin01(@ModelAttribute("mbersbscrbVO"  ) MbersbscrbVO mbersbscrbVO
                            ,@ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO, GisinfoPostgreVO vo
                            ,HttpServletRequest  request
                            ,HttpServletResponse response
                            ,ModelMap model
                            ) throws Exception
    {
    	request.setCharacterEncoding("UTF-8");
    	response.setCharacterEncoding("UTF-8");
    	
    	HttpSession session =  getSession();
    	
    	if(session == null ){    		
    		session = request.getSession(); // 세션 없으면 세션 생성
    	}
    	
    	String sh_user_pw = ICencryptUtils.encryption(mbersbscrbVO.getUser_pass());
    	String auth_yn = "";
    	
    	ManageVO mVo = new ManageVO();
    	mVo.setUser_id(mbersbscrbVO.getUser_id());
    	
    	ManageVO homeLogin = manageService.selectUserInfo(mVo);
    	    	
    	if( homeLogin == null || !(sh_user_pw).equals(homeLogin.getUser_pass())){
    		
    	   jsHelper.Alert("아이디 또는 비밀번호가 정확하지 않습니다.\\n\\n다시 확인하여 주시기 바랍니다.");
    	   jsHelper.RedirectUrl("/main_home.do");
    	}else if(("Y").equals(homeLogin.getDel_yn())){
    		
    	   jsHelper.Alert("현재 삭제 된 계정입니다.\\n\\n관리자에게 문의하시길 바랍니다.");	
    	   jsHelper.RedirectUrl("/main_home.do");
    	}
    	else{
        	commonSessionVO.setUser_id(homeLogin.getUser_id());			   
        	commonSessionVO.setUser_name(homeLogin.getUser_name());        
        	commonSessionVO.setUser_position(homeLogin.getUser_position());
        	commonSessionVO.setUser_auth(homeLogin.getUser_auth());
        	auth_yn = homeLogin.getUser_auth();
        	
        	session.setAttribute("SessionVO", commonSessionVO);
        	
        	mbersbscrbVO.setUser_name(homeLogin.getUser_name());
        	mbersbscrbVO.setUser_position(homeLogin.getUser_position());
        	mbersbscrbVO.setIn_out("in");
        	mbersbscrbService.selectLoginOutHist(mbersbscrbVO);
        	
        	if("0".equals(auth_yn) || "1".equals(auth_yn) || "2".equals(auth_yn) || "3".equals(auth_yn)){
        		session.setAttribute("userId", homeLogin.getUser_id());
        		session.setAttribute("userAuth", auth_yn);
        		session.setAttribute("userNm", homeLogin.getUser_name());
        	}else{
        		session.setAttribute("userId", null);
        		session.setAttribute("userNm", homeLogin.getUser_name());
        	}
        		
        	jsHelper.RedirectUrl("/dashboard.do");
    		
    	}
    	
        return null;
    }*/
    
    /**
     * header 페이지
     * */
    /*
    @RequestMapping(value="/main_header.do")
    public String main_header(@ModelAttribute("homeVO"  ) HomeVO homeVO, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
                            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {    	 
    	return "/SH/Main_Header";    	
    }*/
    
    /**
     * footer 페이지
     * */
    /*
    @RequestMapping(value="/main_footer.do")
    public String main_footer(@ModelAttribute("homeVO"  ) HomeVO homeVO, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
                              ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {    	 
    	return "/SH/Main_Footer";    	
    }*/
    
}
