package egovframework.syesd.portal.dashboard.web;

import java.net.URL;
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
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.syesd.portal.dashboard.service.DashboardService;
import egovframework.zaol.common.OraclePaginationInfo;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;

@Controller
public class DashboardController extends BaseController {

	/* 현재 사용 X
	 * private static Logger logger = LogManager.getLogger(DashboardController.class);

	private ObjectMapper mapper;

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "dashboardService")
	private DashboardService dashboardService;

	@Resource(name = "logsService")
	private LogsService logsService;

	private static final String validUrl   = RequestMappingConstants.WEB_MAIN;
	private static final String invalidUrl = RequestMappingConstants.WEB_LOGIN;

    @PostConstruct
	public void initIt() throws Exception {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}

	@RequestMapping(value=RequestMappingConstants.WEB_DASHBOARD)
    public String dashboardMain(HttpServletRequest request,
								HttpServletResponse response,
								ModelMap model) throws Exception
    {
    	response.setCharacterEncoding("UTF-8");

    	String referer = request.getHeader("referer");
    	if(referer != null && "".equals(referer) == false)
    	{
	    	HttpSession session = getSession();
	    	if(session != null)
	    	{
	    		CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
	            
	            String userAdmYn = commonSessionVO.getUser_admin_yn();

            	 이력 
            	try
    			{
	            	HashMap<String, Object> param = new HashMap<String, Object>();
	            	param.put("KEY", RequestMappingConstants.KEY);
			       	param.put("PREFIX", "LOG");
	            	param.put("USER_ID", userId);
	            	param.put("PROGRM_URL", request.getRequestURI());

            		 프로그램 사용 이력 등록 
    				logsService.insertUserProgrmLogs(param);
    			}
    			catch (Exception e)
    			{
    				logger.error("이력 등록 실패" + e.getMessage());
    			}

            	return "portal/dashboard/contents";
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

    @RequestMapping(value = RequestMappingConstants.WEB_DASHBOARD_LIST,
 			method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView dashboardList(HttpServletRequest request,
										 HttpServletResponse response,
										 ModelMap model) throws Exception
	{
    	response.setCharacterEncoding("UTF-8");
    	request.setCharacterEncoding("UTF-8");

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			URL url = new URL(referer);
			String host = url.getHost();

			HttpSession session = getSession();
			if(session != null)
			{
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
		      
		        String userAdmYn = commonSessionVO.getUser_admin_yn();

				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("dashInfo", dashboardService.selectDashboardList());
				modelAndView.addObject("result", "Y");
				modelAndView.setViewName("jsonView");

				return modelAndView;
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
*/
}
