package egovframework.syesd.admin.main.web;

import java.sql.SQLException;
import java.util.HashMap;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.syesd.cmmn.menu.service.MenuService;
import egovframework.zaol.common.web.BaseController;

@Controller
public class AdminMainController extends BaseController  {

	private static Logger logger = LogManager.getLogger(AdminMainController.class);
	
	private ObjectMapper mapper;
	
	@Resource(name = "propertiesService") 
	private EgovPropertyService propertiesService;
	
	@Resource(name = "logsService") 
	private LogsService logsService;
	
	@Resource(name = "menuService")
	private MenuService menuService;
		
    @PostConstruct
	public void initIt() throws SQLException {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}

    /**
     * header 페이지
     **/
    @RequestMapping(value = RequestMappingConstants.WEB_ADMIN_HEADER, 
    				method = RequestMethod.GET)
    public String admin_header(HttpServletRequest request, 
    						  HttpServletResponse response, ModelMap model) throws SQLException
    {    	 
    	return "admin/header";    	
    }
    
    /**
     * left 페이지
     **/
    @RequestMapping(value = RequestMappingConstants.WEB_ADMIN_LEFT, 
    				method = RequestMethod.GET)
    public String admin_left(HttpServletRequest request, 
    						  HttpServletResponse response, ModelMap model) throws SQLException
    {    	 
    	HashMap<String, Object> param = new HashMap<String, Object>();
    	param.put("lcode", 6);
    	model.addAttribute("menu",menuService.selectLeftMenuInfo(param));
    	return "/portal/board/leftMenu"; 	
    }
    
    
    /**
     * footer 페이지
     **/
    @RequestMapping(value = RequestMappingConstants.WEB_ADMIN_FOOTER, 
    				method = RequestMethod.GET)
    public String admin_footer(HttpServletRequest request, 
    				 		  HttpServletResponse response, ModelMap model) throws SQLException
    {    	 
    	return "admin/footer";    	
    }
    
}
