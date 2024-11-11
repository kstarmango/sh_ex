 package egovframework.mango.analysis.portal;
                                                                       
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import egovframework.mango.config.SHResource;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.syesd.map.search.asset.web.AssetController;
import egovframework.zaol.common.web.BaseController;
import egovframework.zaol.gisinfo.service.GisBasicVO;


/**
 *  @purpose 사이드 검색 조건 창 
 */
@Controller
public class PortalBusinessController extends BaseController {
	private static Logger logger = LogManager.getLogger(PortalBusinessController.class);
	@Resource(name = "logsService")
	private LogsService logsService;

	//#region 입지 분석

 	@RequestMapping(value=RequestMappingConstants.WEB_ANAL_DISTANCE_LIFE_CONTENT, method = {RequestMethod.GET, RequestMethod.POST})
 	public String distanceLifeContent (HttpServletRequest request, HttpServletResponse response, ModelMap model, @ModelAttribute("gisvo") GisBasicVO gisvo) throws NullPointerException, Exception {
		
		HttpSession session = getSession();
		String userS_id = null;
		
	  	if(session != null){
	  		userS_id = (String)session.getAttribute("userId");
	  	}
	
	    if(userS_id != null){
	     	gisvo.setUser_id(userS_id);
	     	
	     	/* 이력 */
	    	try 
			{
	        	HashMap<String, Object> query = new HashMap<String, Object>();
	        	query.put("KEY", RequestMappingConstants.KEY);
	        	query.put("PREFIX", "LOG");
	        	query.put("USER_ID", userS_id);
	        	query.put("PROGRM_URL", request.getRequestURI());
	        	
	    		/* 프로그램 사용 이력 등록 */
				logsService.insertUserProgrmLogs(query);
	
			} catch(NullPointerException e) {
				logger.debug(e);
			} 
			catch (Exception e) 
			{
				logger.error("이력 등록 실패");
			}
	
	    	return "analysis/location/distance.sub";
	    } else {
	    	jsHelper.Alert("비정상적인 접근 입니다.");
	    	return  "redirect:/main_home.do";
	    }
	}
	
 	@RequestMapping(value=RequestMappingConstants.WEB_ANAL_NETWORK_LIFE_CONTENT, method = {RequestMethod.GET, RequestMethod.POST})
 	public String networkContent (HttpServletRequest request, HttpServletResponse response, ModelMap model, @ModelAttribute("gisvo") GisBasicVO gisvo) throws NullPointerException, Exception {
		
		HttpSession session = getSession();
		String userS_id = null;
		
  	if(session != null){
  		userS_id = (String)session.getAttribute("userId");
  	}

    if(userS_id != null){
     	gisvo.setUser_id(userS_id);
     	
     	/* 이력 */
    	try 
		{
        	HashMap<String, Object> query = new HashMap<String, Object>();
        	query.put("KEY", RequestMappingConstants.KEY);
        	query.put("PREFIX", "LOG");
        	query.put("USER_ID", userS_id);
        	query.put("PROGRM_URL", request.getRequestURI());
        	
    		/* 프로그램 사용 이력 등록 */
			logsService.insertUserProgrmLogs(query);

		} catch(NullPointerException e) {
			logger.debug(e);
		} 
		catch (Exception e) 
		{
			logger.error("이력 등록 실패");
		}

    	return "analysis/location/network.sub";
    } else {
    	jsHelper.Alert("비정상적인 접근 입니다.");
    	return  "redirect:/main_home.do";
    }
	}

	//#endregion  입지 분석

	//#region 공간 분석
 	@RequestMapping(value=RequestMappingConstants.WEB_ANAL_QUEST_DISTANCE_CONTENT, method = {RequestMethod.GET, RequestMethod.POST})
 	public String spatialDistanceContent (HttpServletRequest request, HttpServletResponse response, ModelMap model, @ModelAttribute("gisvo") GisBasicVO gisvo) throws NullPointerException, Exception {
		
		HttpSession session = getSession();
		String userS_id = null;
		
  	if(session != null){
  		userS_id = (String)session.getAttribute("userId");
  	}

    if(userS_id != null){
     	gisvo.setUser_id(userS_id);
     	
     	/* 이력 */
    	try 
		{
        	HashMap<String, Object> query = new HashMap<String, Object>();
        	query.put("KEY", RequestMappingConstants.KEY);
        	query.put("PREFIX", "LOG");
        	query.put("USER_ID", userS_id);
        	query.put("PROGRM_URL", request.getRequestURI());
        	
    		/* 프로그램 사용 이력 등록 */
			logsService.insertUserProgrmLogs(query);

		} catch(NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) 
		{
			logger.error("이력 등록 실패");
		}

    	return "analysis/spatial/spatialDistance.sub";
    } else {
    	jsHelper.Alert("비정상적인 접근 입니다.");
    	return  "redirect:/main_home.do";
    }
	}


 	@RequestMapping(value=RequestMappingConstants.WEB_ANAL_SIMILAR_BIZ_CONTENT, method = {RequestMethod.GET, RequestMethod.POST})
 	public String similarBizContent (HttpServletRequest request, HttpServletResponse response, ModelMap model, @ModelAttribute("gisvo") GisBasicVO gisvo) throws NullPointerException, Exception {
		
		HttpSession session = getSession();
		String userS_id = null;
		
  	if(session != null){
  		userS_id = (String)session.getAttribute("userId");
  	}

    if(userS_id != null){
     	gisvo.setUser_id(userS_id);
     	
     	/* 이력 */
    	try 
		{
        	HashMap<String, Object> query = new HashMap<String, Object>();
        	query.put("KEY", RequestMappingConstants.KEY);
        	query.put("PREFIX", "LOG");
        	query.put("USER_ID", userS_id);
        	query.put("PROGRM_URL", request.getRequestURI());
        	
    		/* 프로그램 사용 이력 등록 */
			logsService.insertUserProgrmLogs(query);

		} catch(NullPointerException e) {
			logger.debug(e);
		} 
		catch (Exception e) 
		{
			logger.error("이력 등록 실패");
		}

    	return "analysis/spatial/similar.sub";
    } else {
    	jsHelper.Alert("비정상적인 접근 입니다.");
    	return  "redirect:/main_home.do";
    }
	}

 	@RequestMapping(value=RequestMappingConstants.WEB_ANAL_RELATED_BIZ_CONTENT, method = {RequestMethod.GET, RequestMethod.POST})
 	public String relatedBizContent (HttpServletRequest request, HttpServletResponse response, ModelMap model, @ModelAttribute("gisvo") GisBasicVO gisvo) throws NullPointerException, Exception {
		
		HttpSession session = getSession();
		String userS_id = null;
		
  	if(session != null){
  		userS_id = (String)session.getAttribute("userId");
  	}

    if(userS_id != null){
     	gisvo.setUser_id(userS_id);
     	/* 이력 */
    	try 
		{
        	HashMap<String, Object> query = new HashMap<String, Object>();
        	query.put("KEY", RequestMappingConstants.KEY);
        	query.put("PREFIX", "LOG");
        	query.put("USER_ID", userS_id);
        	query.put("PROGRM_URL", request.getRequestURI());
        	
    		/* 프로그램 사용 이력 등록 */
			logsService.insertUserProgrmLogs(query);

		} catch(NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) 
		{
			logger.error("이력 등록 실패");
		}

    	return "analysis/spatial/relation.sub";
    } else {
    	jsHelper.Alert("비정상적인 접근 입니다.");
    	return  "redirect:/main_home.do";
    }
	}
	
	@RequestMapping(value=RequestMappingConstants.WEB_ANAL_BIZ_BASIC_LOCATION_CONTENT, method = {RequestMethod.GET, RequestMethod.POST})
 	public String basicLocOverlapContent (HttpServletRequest request, HttpServletResponse response, ModelMap model, @ModelAttribute("gisvo") GisBasicVO gisvo) throws NullPointerException, Exception {
		
		HttpSession session = getSession();
		String userS_id = null;
		
  	if(session != null){
  		userS_id = (String)session.getAttribute("userId");
  	}

    if(userS_id != null){
     	gisvo.setUser_id(userS_id);
     	
     	/* 이력 */
    	try 
		{
        	HashMap<String, Object> query = new HashMap<String, Object>();
        	query.put("KEY", RequestMappingConstants.KEY);
        	query.put("PREFIX", "LOG");
        	query.put("USER_ID", userS_id);
        	query.put("PROGRM_URL", request.getRequestURI());
        	
    		/* 프로그램 사용 이력 등록 */
			logsService.insertUserProgrmLogs(query);

		} catch(NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) 
		{
			logger.error("이력 등록 실패");
		}
    	return "analysis/location/basicLocOverlap.sub";
    } else {
    	jsHelper.Alert("비정상적인 접근 입니다.");
    	return  "redirect:/main_home.do";
    }
	}

	
	// 네트워크 중첩 분석 
	@RequestMapping(value=RequestMappingConstants.WEB_ANAL_NETWORK_BIZ_CONTENT, method = {RequestMethod.GET, RequestMethod.POST})
 	public String networkOverlapContent (HttpServletRequest request, HttpServletResponse response) throws NullPointerException, Exception {
		
		HttpSession session = getSession();
		String userS_id = null;
		
	  	if(session != null){
	  		userS_id = (String)session.getAttribute("userId");
	  	}
	
	    if(userS_id != null){
	    	
	    	/* 이력 */
	    	try 
			{
	        	HashMap<String, Object> query = new HashMap<String, Object>();
	        	query.put("KEY", RequestMappingConstants.KEY);
	        	query.put("PREFIX", "LOG");
	        	query.put("USER_ID", userS_id);
	        	query.put("PROGRM_URL", request.getRequestURI());
	        	
	    		/* 프로그램 사용 이력 등록 */
				logsService.insertUserProgrmLogs(query);

			} catch(NullPointerException e) {
				logger.debug(e);
			} 
			catch (Exception e) 
			{
				logger.error("이력 등록 실패");
			}
	    	return "analysis/spatial/networkOverlap.sub";
	    } else {
	    	jsHelper.Alert("비정상적인 접근 입니다.");
	    	return  "redirect:/main_home.do";
	    }
	}

	//#endregion 공간분석

	//#region 필드 분석

	// 버퍼분석
	@RequestMapping(value=RequestMappingConstants.WEB_ANAL_CMMN_BUFFER_CONTENT, method = {RequestMethod.GET, RequestMethod.POST})
 	public String commonBufferContent (HttpServletRequest request, HttpServletResponse response, ModelMap model, @ModelAttribute("gisvo") GisBasicVO gisvo) throws NullPointerException, Exception {
		
		HttpSession session = getSession();
		String userS_id = null;
		
  	if(session != null){
  		userS_id = (String)session.getAttribute("userId");
  	}

    if(userS_id != null){
     	gisvo.setUser_id(userS_id);
     	
     	/* 이력 */
    	try 
		{
        	HashMap<String, Object> query = new HashMap<String, Object>();
        	query.put("KEY", RequestMappingConstants.KEY);
        	query.put("PREFIX", "LOG");
        	query.put("USER_ID", userS_id);
        	query.put("PROGRM_URL", request.getRequestURI());
        	
    		/* 프로그램 사용 이력 등록 */
			logsService.insertUserProgrmLogs(query);

		} catch(NullPointerException e) {
			logger.debug(e);
		} 
		catch (Exception e) 
		{
			logger.error("이력 등록 실패");
		}
    	return "analysis/common/buffer.sub";
    } else {
    	jsHelper.Alert("비정상적인 접근 입니다.");
    	return  "redirect:/main_home.do";
    }
	}

	// 밀도분석
	@RequestMapping(value=RequestMappingConstants.WEB_ANAL_CMMN_DENSITY_CONTENT, method = {RequestMethod.GET, RequestMethod.POST})
 	public String densityContent (HttpServletRequest request, HttpServletResponse response) throws NullPointerException, Exception {
		
		HttpSession session = getSession();
		String userS_id = null;
		
  	if(session != null){
  		userS_id = (String)session.getAttribute("userId");
  	}

    if(userS_id != null){
    	
    	/* 이력 */
    	try 
		{
        	HashMap<String, Object> query = new HashMap<String, Object>();
        	query.put("KEY", RequestMappingConstants.KEY);
        	query.put("PREFIX", "LOG");
        	query.put("USER_ID", userS_id);
        	query.put("PROGRM_URL", request.getRequestURI());
        	
    		/* 프로그램 사용 이력 등록 */
			logsService.insertUserProgrmLogs(query);

		} catch(NullPointerException e) {
			logger.debug(e);
		} 
		catch (Exception e) 
		{
			logger.error("이력 등록 실패");
		}
    	return "analysis/common/density.sub";
    } else {
    	jsHelper.Alert("비정상적인 접근 입니다.");
    	return  "redirect:/main_home.do";
    }
	}

	// 포인트 집계
	@RequestMapping(value=RequestMappingConstants.WEB_ANAL_CMMN_POINT_CONTENT, method = {RequestMethod.GET, RequestMethod.POST})
 	public String pointStaticsContent (HttpServletRequest request, HttpServletResponse response) throws NullPointerException, Exception {
		
		HttpSession session = getSession();
		String userS_id = null;
		
	  	if(session != null){
	  		userS_id = (String)session.getAttribute("userId");
	  	}
	
	    if(userS_id != null){
	    	/* 이력 */
	    	try 
			{
	        	HashMap<String, Object> query = new HashMap<String, Object>();
	        	query.put("KEY", RequestMappingConstants.KEY);
	        	query.put("PREFIX", "LOG");
	        	query.put("USER_ID", userS_id);
	        	query.put("PROGRM_URL", request.getRequestURI());
	        	
	    		/* 프로그램 사용 이력 등록 */
				logsService.insertUserProgrmLogs(query);

			} catch(NullPointerException e) {
				logger.debug(e);
			} 
			catch (Exception e) 
			{
				logger.error("이력 등록 실패");
			}
	    	return "analysis/common/pointStatics.sub";
	    } else {
	    	jsHelper.Alert("비정상적인 접근 입니다.");
	    	return  "redirect:/main_home.do";
	    }
	}

	//#endregion 

	//#region 개발행위제한

	// 경사도 분석
	@RequestMapping(value=RequestMappingConstants.WEB_ANAL_DEV_SLOPE_CONTENT, method = {RequestMethod.GET, RequestMethod.POST})
 	public String slopeContent (HttpServletRequest request, HttpServletResponse response) throws NullPointerException, Exception {
		
		HttpSession session = getSession();
		String userS_id = null;
		
  	if(session != null){
  		userS_id = (String)session.getAttribute("userId");
  	}

    if(userS_id != null){
    	/* 이력 */
    	try 
		{
        	HashMap<String, Object> query = new HashMap<String, Object>();
        	query.put("KEY", RequestMappingConstants.KEY);
        	query.put("PREFIX", "LOG");
        	query.put("USER_ID", userS_id);
        	query.put("PROGRM_URL", request.getRequestURI());
        	
    		/* 프로그램 사용 이력 등록 */
			logsService.insertUserProgrmLogs(query);

		} catch(NullPointerException e) {
			logger.debug(e);
		} 
		catch (Exception e) 
		{
			logger.error("이력 등록 실패");
		}
    	return "analysis/development/slope.sub";
    } else {
    	return  "redirect:/main_home.do";
    }
	}

	// 개발행위 가능 분석
	@RequestMapping(value=RequestMappingConstants.WEB_ANAL_DEV_ANAL_CONTENT, method = {RequestMethod.GET, RequestMethod.POST})
 	public String analysisDevelopment (HttpServletRequest request, HttpServletResponse response,
			ModelMap model, @ModelAttribute("gisvo") GisBasicVO gisvo) throws NullPointerException, Exception
	{
		HttpSession session = getSession();
		String userS_id = null;
		if(session != null){
			userS_id = (String)session.getAttribute("userId");
		}

	  if( userS_id != null ){
			// model.addAttribute("geoserverURL", "http://connect.miraens.com:59900/geoserver/SH_LM/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20");
			// model.addAttribute("geoserverURL", "http://128.134.95.129:8080/geoserver/SH_LM/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20");

			model.addAttribute("geoserverURL", SHResource.getValue("geoserver.url") + "/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20");
			
			/* 이력 */
	    	try 
			{
      	HashMap<String, Object> query = new HashMap<String, Object>();
      	query.put("KEY", RequestMappingConstants.KEY);
      	query.put("PREFIX", "LOG");
      	query.put("USER_ID", userS_id);
      	query.put("PROGRM_URL", request.getRequestURI());
	        	
	    		/* 프로그램 사용 이력 등록 */
				logsService.insertUserProgrmLogs(query);

			} catch(NullPointerException e) {
				logger.debug(e);
			} 
			catch (Exception e) 
			{
				logger.error("이력 등록 실패");
			}
			return "analysis/development/analysis.sub";

	  } else {
	  	jsHelper.Alert("비정상적인 접근 입니다.");
	  	return  "redirect:/main_home.do";
	  }
	}

	//#endregion 
	
	// 대상지 탐색
	@RequestMapping(value=RequestMappingConstants.WEB_ANAL_DESTINATION_CONTENT, method = {RequestMethod.GET, RequestMethod.POST})
	public String destinationContent (HttpServletRequest request, HttpServletResponse response) throws NullPointerException, Exception {
		
		HttpSession session = getSession();
		String userS_id = null;
		
	 	if(session != null){
	 		userS_id = (String)session.getAttribute("userId");
	 	}

   if(userS_id != null){
	   /* 이력 */
   	try 
		{
       	HashMap<String, Object> query = new HashMap<String, Object>();
       	query.put("KEY", RequestMappingConstants.KEY);
       	query.put("PREFIX", "LOG");
       	query.put("USER_ID", userS_id);
       	query.put("PROGRM_URL", request.getRequestURI());
       	
   		/* 프로그램 사용 이력 등록 */
			logsService.insertUserProgrmLogs(query);

		} catch(NullPointerException e) {
			logger.debug(e);
		} 
		catch (Exception e) 
		{
			logger.error("이력 등록 실패");
		}
   	return "analysis/destination/destination.sub";
   } else {
   	jsHelper.Alert("비정상적인 접근 입니다.");
   	return  "redirect:/main_home.do";
   }
	}

}
