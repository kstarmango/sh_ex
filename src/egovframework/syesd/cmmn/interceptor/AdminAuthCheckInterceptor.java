package egovframework.syesd.cmmn.interceptor;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.menu.service.MenuService;
import egovframework.syesd.cmmn.util.EgovProperties;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;
import egovframework.zaol.common.web.JavaScriptHelper;
import egovframework.zaol.util.service.StringUtil;

public class AdminAuthCheckInterceptor extends HandlerInterceptorAdapter {
	
	private static Logger logger = LogManager.getLogger(AdminAuthCheckInterceptor.class);
	
	private JavaScriptHelper jsHelper = null;
	
	@Resource(name = "menuService") 
	private MenuService menuService;
	
	private static final String checkUrl = RequestMappingConstants.WEB_ROOT + RequestMappingConstants.ADMIN_ROOT;
	private static final String invalidUrl = RequestMappingConstants.WEB_LOGIN;

    /**
     *  로그인 검사 
     * @throws IOException 
     * @throws NullPointerException 
     * @throws SQLException 
     */
    @Override
    public boolean preHandle(HttpServletRequest request,
            				 HttpServletResponse response, 
            				 Object handler) throws NullPointerException, IOException, SQLException 
    {
        jsHelper = new JavaScriptHelper();
        jsHelper.SetResponse(response);
        
        HttpSession session = request.getSession(); //request.getSession(false);
        
        /* 메뉴 권한 체크 */
        String requestURI = request.getRequestURI(); //.toLowerCase();    	
        if(requestURI.indexOf(checkUrl) >= 0)
        { 
        	if(session == null) 
        	{                
        		jsHelper.RedirectUrl(invalidUrl);
                return false;
        	} 
        	else 
        	{
        		CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
        		if(commonSessionVO == null) 
        		{
                    jsHelper.RedirectUrl(invalidUrl);
                    return false;
        		}
        		else 
        		{
        			// 메뉴 권한 체크
        			HashMap<String, Object> param = new HashMap<String, Object>();
        	    	param.put("KEY", RequestMappingConstants.KEY);
        	    	param.put("PROGRM_URL", request.getRequestURI());
        			
        			String apiKey = (String) session.getAttribute("apiKey");
        			if(apiKey == null || "".equals(apiKey) == true)
        				param.put("USER_ID", session.getAttribute("userId"));
        			else
        				param.put("API_KEY", apiKey);
        			
        			String check = menuService.checkIsAuthMenu(param);
        	    	if(check == null || "N".equals(check) == true) 
        	    	{
        	    		jsHelper.AlertAndUrlGo("권한이 없습니다.\\n\\n관리자에게 문의하시길 바랍니다.", invalidUrl);
                        return false;
        	    	}
        		}
        	}
        }
        
        BaseController curController = (BaseController)handler;
        curController.jsHelper.SetRequest(request);
        curController.jsHelper.SetResponse(response);
        curController.setSession(session);
        
    	return true;
    }
    
    /**
     * 뷰에 필수 전달값 전달
     */
    @Override
    public void postHandle(HttpServletRequest request
                          ,HttpServletResponse response
                          ,Object handler
                          ,ModelAndView modelAndView) throws SQLException, NullPointerException, IOException
    {
    	logger.info("Admin postHandle#############");
    	logger.info("request :::"+request.getParameter("tile"));
    	
    	/* 사용자 정보 */
    	HttpSession session = request.getSession(false);
        if (session != null)
        {
            CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
            if(commonSessionVO != null && modelAndView != null)
            {
                modelAndView.addObject("sesUserId"      	, StringUtil.nullConvert(commonSessionVO.getUser_id()     	)); 	/* 사용자 ID 	*/
                modelAndView.addObject("sesUserName"      	, StringUtil.nullConvert(commonSessionVO.getUser_name()     )); 	/* 사용자 이름    */
                modelAndView.addObject("sesUserPosition"    , StringUtil.nullConvert(commonSessionVO.getUser_position() )); 	/* 사용자 직급    */
                modelAndView.addObject("sesUserAdminYn"     , StringUtil.nullConvert(commonSessionVO.getUser_admin_yn() )); 	/* 관리자 여부    */
            }
        }
        
        /* 메뉴 Navigation */
        String requestURI = request.getRequestURI(); //.toLowerCase();    	
        if(requestURI.indexOf(checkUrl) >= 0)
        { 
        	HashMap<String, Object> param = new HashMap<String, Object>();
        	param.put("PROGRM_URL", request.getRequestURI());
        	
			
            modelAndView.addObject("sesMenuNavigation"	, menuService.selectAdminMenuNm(param));
            modelAndView.addObject("sesUrlNavigation"	, request.getRequestURI());
        }
        
        String viewName = modelAndView.getViewName();
    	if(request.getParameter("tile") == null) {
    		viewName = viewName.replace(".page", ".tile");
    		modelAndView.setViewName(viewName);
    	}
    	
    	//super.postHandle(request, response, handler, modelAndView);
    	
    	try {
			super.postHandle(request, response, handler, modelAndView);
		} catch (SQLException | NullPointerException | IOException e) {
			// TODO Auto-generated catch block
			logger.error("AdminAuth postHandle SQLException | NullPointerException | IOException error");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			logger.error("AdminAuth postHandle Exception error");
		}
    }
    
}
