package egovframework.syesd.portal.main.web;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.UUID;

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
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.syesd.cmmn.menu.service.MenuService;
import egovframework.zaol.common.web.BaseController;

@Controller
public class MainController extends BaseController  {

	private static Logger logger = LogManager.getLogger(MainController.class);

	private ObjectMapper mapper;

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "logsService")
	private LogsService logsService;
	

	@Resource(name = "menuService")
	private MenuService menuService;

    @PostConstruct
	public void initIt() throws NullPointerException {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}

    /**
     * login 페이지 ( from index )
     **/
    @RequestMapping(value = RequestMappingConstants.WEB_LOGIN,
    				method = RequestMethod.GET)
    public String login(HttpServletRequest request,
					    HttpServletResponse response, ModelMap model)
    {
    	
    	HttpSession session =  getSession();
    	if(session == null ){
    		session = request.getSession(); // 세션 없으면 세션 생성
    	}

    	session.setAttribute("CSRF_TOKEN",UUID.randomUUID().toString());

    	return "common/login.part"; 
    }

    
    /**
     * header 페이지 ( from login )
     **/
    @RequestMapping(value = RequestMappingConstants.WEB_MAIN_HEADER,
    				method = {RequestMethod.GET, RequestMethod.POST})
    public String main_header(HttpServletRequest request,
    						  HttpServletResponse response, ModelMap model)
    {   
    	return "/portal/header.jsp";
    }

    /**
     * left 페이지 ( from login )
     **/
    @RequestMapping(value = RequestMappingConstants.WEB_MAIN_LEFT,
    				method = {RequestMethod.GET, RequestMethod.POST})
    public String main_left(HttpServletRequest request,
    						  HttpServletResponse response, ModelMap model) throws NullPointerException
    {   
    	HashMap<String, Object> param = new HashMap<String, Object>();
    	param.put("lcode", 39);
    	try {
			model.addAttribute("menu",menuService.selectLeftMenuInfo(param));
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			logger.error("이력 등록 실패");
		}
    	return "/portal/leftMenu.jsp";
    }
    
    
    /**
     * footer 페이지 ( from login )
     **/
    @RequestMapping(value = RequestMappingConstants.WEB_MAIN_FOOTER,
    				method = {RequestMethod.GET, RequestMethod.POST})
    public String main_footer(HttpServletRequest request,
    				 		  HttpServletResponse response, ModelMap model)
    {
    	return "/portal/footer.jsp";
    }
    
    @RequestMapping(value = "/layout/content.do",
			method = {RequestMethod.GET, RequestMethod.POST})
	public String  main_test(HttpServletRequest request,
				 		  HttpServletResponse response, ModelMap model,ModelAndView modelAndView)
	{//ModelAndView  String
    	//modelAndView.setViewName("layout/content.tiles");
    	// return new ModelAndView("layout/content.tiles");
	return "layout/content.tiles";
}

}
