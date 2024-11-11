package egovframework.zaol.common;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import egovframework.zaol.ad.cms.service.UserMenuVO;
import egovframework.zaol.cms.service.UserMenuService;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;
import egovframework.zaol.common.web.JavaScriptHelper;
import egovframework.zaol.util.service.StringUtil;

public class UserAuthCheckInterceptor extends HandlerInterceptorAdapter {

    private JavaScriptHelper jsHelper = null;
    private String menu_id = null;
    private String sh_user_id = null;
    private Logger log;

    @Resource( name="userMenuService" )
    private UserMenuService userMenuService;

    // 사용자 로그인 검사
    @Override
    public boolean preHandle(HttpServletRequest request,
            HttpServletResponse response, Object handler) throws Exception {

        log = LogManager.getLogger(this.getClass());
        BaseController      curController = (BaseController)handler;        // 현재 컨트롤러 클래스( BaseController로 캐스팅 해 공용 메소드만 사용)
        HttpSession         session = request.getSession(false);            // 세션객체

        // javascript Helper 클래스 생성
        jsHelper = new JavaScriptHelper();
        jsHelper.SetResponse(response);

        // 컨트롤러에 필요 정보 전달
        curController.jsHelper.SetRequest(request);
        curController.jsHelper.SetResponse(response);
        curController.setSession(session);
        curController.setMenu_id(menu_id);

        //주소 url 객체
        String requestURI = request.getRequestURI();
        String requestURILowerCase = requestURI.toLowerCase();

        // RequestURI 를 검사해 login 또는 logout 이 포함되어 있으면 세션 검사를 하지 않는다.
        if( requestURILowerCase.indexOf("login") >= 0 || requestURILowerCase.indexOf("logout") >= 0
                || requestURILowerCase.indexOf("/homemain.") >= 0
                || requestURILowerCase.indexOf("ajax") >= 0
                || requestURILowerCase.indexOf("popview") >= 0
                || requestURILowerCase.indexOf("excl") >= 0
                || requestURILowerCase.indexOf("filedown") >= 0
            )
        {
            return true;
        }

        else {
        	sh_user_id = StringUtil.isNullToString((String)request.getParameter("sh_user_id"));

            //url만 호출 시 menu_id 조회
            if( sh_user_id == null || sh_user_id.equals("") ) {
             //   menu_id = userMenuService.getmenu_idfromURI(requestURILowerCase);
            }

            // 메뉴 Id 값 검사 - 메인화면을 제외한 나머지 화면은 menuId가 없으면 되돌린다.
            if( sh_user_id == null || sh_user_id.equals("") ) {
                //jsHelper.AlertAndHistoryGo("잘못된 접근입니다.", -1);
                //return false;
            }

            // 메뉴 접근권한 검사
            else {
            	String login_chk = userMenuService.getmenu_idLoginAuth(sh_user_id);

                // session 검사
                if (!("").equals(login_chk) || login_chk == null)
                {
                	if (session == null) {
	                    // 처리를 끝냄 - 컨트롤로 요청이 가지 않음.
	                    jsHelper.AlertAndUrlGo("세션이 만료되었습니다. 로그인 후 이용해주세요.", "/");
	                    return false;

                	} else {
                		CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");

                		if (commonSessionVO == null) {
		                    // 처리를 끝냄 - 컨트롤로 요청이 가지 않음.
		                    jsHelper.AlertAndUrlGo("로그인 후 이용해주세요.", "/");
		                    return false;
                		}
                	}
                }

            }
        }

        return true;
    }

    /**
     * 뷰에 필수 전달값 전달
     */
    @Override
    public void postHandle(HttpServletRequest request
                          ,HttpServletResponse response
                          ,Object handler
                          ,ModelAndView modelAndView
                          ) throws Exception
    {

        //session 값 세팅
        HttpSession     session         = request.getSession(false);            // 세션객체
        CommonSessionVO commonSessionVO = null;

        if (session != null)
        {
        	//HomeController.java의 actionLogin01.do에서 session에 넣어놓은값을 여기서 CommonSessionVO에 적용 (2011-11-05 양중목 주석 추가)
            commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");

            if(commonSessionVO != null && modelAndView != null)
            {
                modelAndView.addObject("sesUserId"      , StringUtil.nullConvert(commonSessionVO.getUser_id()     )); 		/* 사용자 ID      */
                modelAndView.addObject("sesUserName"      , StringUtil.nullConvert(commonSessionVO.getUser_name()     )); 	/* 사용자 이름        */
                modelAndView.addObject("sesUserPosition"      , StringUtil.nullConvert(commonSessionVO.getUser_position()    )); /* 사용자 직급        */
                modelAndView.addObject("sesTopcd"      , StringUtil.nullConvert(commonSessionVO.getTop_cd()    )); /* 사용자 직급        */
                modelAndView.addObject("sesMiddlecd"      , StringUtil.nullConvert(commonSessionVO.getMiddle_cd()    )); /* 사용자 직급        */
                modelAndView.addObject("sesSubcd"      , StringUtil.nullConvert(commonSessionVO.getSub_cd()    )); /* 사용자 직급        */
                modelAndView.addObject("sesUserauth"      , StringUtil.nullConvert(commonSessionVO.getUser_auth()   )); /* 사용자 직급        */
               
            }//end if

        }//end if
  
      }
}
