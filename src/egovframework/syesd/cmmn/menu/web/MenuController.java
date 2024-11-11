package egovframework.syesd.cmmn.menu.web;

import java.io.IOException;
import java.sql.SQLException;

/**
 * 메뉴 컨트롤러 클래스
 *
 * @author  유창범
 * @since   2020.07.22
 * @version 1.0
 * @see
 * <pre>
 *   == 개정이력(Modification Information) ==
 *
 *         수정일                        수정자                                수정내용
 *   ----------------    ------------    ---------------------------
 *   2020.07.22          유창범                           최초 생성
 *
 * </pre>
 */

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.menu.service.MenuService;
import egovframework.zaol.common.service.CommonService;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;
import egovframework.zaol.gisinfo.service.GisinfoService;

@Controller
public class MenuController extends BaseController  {

	private static Logger logger = LogManager.getLogger(MenuController.class);
	
	@Resource(name = "propertiesService") 
	private EgovPropertyService propertiesService;
	
	@Resource(name = "menuService") 
	private MenuService menuService;
	
	private ObjectMapper mapper;

	private static final String validUrl   = RequestMappingConstants.WEB_MAIN;
	private static final String invalidUrl = RequestMappingConstants.WEB_LOGIN;
	
	/* service 구하기      */ @Resource(name = "gisinfoService"   ) private   GisinfoService gisinfoService;
    /* 공통 service 구하기 */ @Resource(name = "CommonService"    ) private   CommonService commonservice;
	
    @PostConstruct
	public void initIt() throws SQLException {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}
	
    @RequestMapping(value = RequestMappingConstants.API_MENU_AUTH, 
					method = RequestMethod.POST)
	public ModelAndView selectMenuAuth(HttpServletRequest request, 
						   			   HttpServletResponse response) throws SQLException, NullPointerException, IOException
	{    
    	/* API KEY 접근 경로 확인 */
    	String referer = request.getHeader("referer");
    	if(referer != null && "".equals(referer) == false)  
    	{
	        HttpSession session = request.getSession(false);
	    	if(session != null) 
	    	{
	    		CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
	    		if(commonSessionVO != null) 
	    		{
					// 메뉴 권한 체크
					HashMap<String, Object> param = new HashMap<String, Object>();
					param.put("KEY", RequestMappingConstants.KEY);
					param.put("PROGRM_URL", request.getRequestURI());
					param.put("USER_ID", session.getAttribute("userId"));				
					
					String check = menuService.checkIsAuthMenu(param);
					
			        ModelAndView modelAndView = new ModelAndView();
			        modelAndView.addObject("result", check);
			        modelAndView.setViewName("jsonView");

			        return modelAndView;
	    		}
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
     * TOP 메뉴 조회 액션
     */      
    @RequestMapping(value = RequestMappingConstants.API_MENU_TOP, 
    				method = RequestMethod.POST)
    public ModelAndView selectTopMenuInfo(HttpServletRequest request, 
    						   			  HttpServletResponse response) throws SQLException, NullPointerException, IOException
    {
    	/* API KEY 접근 경로 확인 */
    	String referer = request.getHeader("referer");
    	if(referer != null && "".equals(referer) == false)  
    	{		
	        HttpSession session = request.getSession(false);
	    	if(session != null) 
	    	{
	    		CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
	    		if(commonSessionVO != null) 
	    		{    						   				  
			    	HashMap<String, Object> param = new HashMap<String, Object>();
			    	param.put("KEY", RequestMappingConstants.KEY);
			    	param.put("USER_ID", session.getAttribute("userId"));
			    	
			    	List list = menuService.selectTopMenuInfo(param);
			    	
			    	//String result = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(list);
			    	//System.out.println(result);
			    	
			        ModelAndView modelAndView = new ModelAndView();
			        modelAndView.addObject("result", list);
			        modelAndView.setViewName("jsonView");
			        
			        return modelAndView;
	    		}
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
     * SUB 메뉴 조회  액션
     */  
    @RequestMapping(value = RequestMappingConstants.API_MENU_SUB, 
    				method = RequestMethod.POST)
    public ModelAndView selectSubMenuInfo(HttpServletRequest request, 
    						   			  HttpServletResponse response) throws SQLException, NullPointerException, IOException
    {
    	/* API KEY 접근 경로 확인 */
    	String referer = request.getHeader("referer");
    	if(referer != null && "".equals(referer) == false)  
    	{		
	        HttpSession session = request.getSession(false);
	    	if(session != null) 
	    	{
	    		CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
	    		if(commonSessionVO != null) 
	    		{  
			    	HashMap<String, Object> param = new HashMap<String, Object>();
			    	param.put("KEY", RequestMappingConstants.KEY);
			    	param.put("USER_ID", session.getAttribute("userId"));
			    	
			    	List list = menuService.selectSubMenuInfo(param);
			    	
			    	//String result = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(list);
			    	//System.out.println(result);
			    	
					ModelAndView modelAndView = new ModelAndView();
					modelAndView.addObject("result", list);
					modelAndView.setViewName("jsonView");
					
					return modelAndView;
				}
			}
    	}
    	else
    	{
    		jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
     	   	jsHelper.RedirectUrl(invalidUrl);
     	}  
    	
 	   	return null;
    }
    
    @RequestMapping(value = "/cmmn/code.do", method = RequestMethod.POST)
    public ModelAndView getCode(HttpServletRequest request, HttpServletResponse response
    		,@RequestParam(value="code",  required=true) String code
    		,@RequestParam(value="sCode",  required=true) String sCode) throws SQLException, NullPointerException, IOException 
	{
    	HttpSession session = getSession();
		String userS_id = null;
	   	if(session != null){
	   		userS_id = (String)session.getAttribute("userId");
	   	}
		if( userS_id != null ){
			HashMap<String, Object> vo = new HashMap<String, Object>();
		    vo.put("code", 	code);
		    vo.put("sCode", sCode);
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.addObject("codeInfo", gisinfoService.sCode_list(vo));
			modelAndView.addObject("result", "Y");
			modelAndView.setViewName("jsonView");

			return modelAndView;
		}else{
	       	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
	     }
	   	
    	return null;
	}
    
}
