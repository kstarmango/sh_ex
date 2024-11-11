package egovframework.mango.link.hous.web;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.geotools.coverage.grid.GridCoverage2D;
import org.geotools.filter.text.ecql.ECQL;
import org.geotools.geometry.jts.ReferencedEnvelope;
import org.geotools.map.MapContent;
import org.geotools.process.spatialstatistics.core.MapToImageParam;
import org.geotools.process.spatialstatistics.enumeration.DistanceUnit;
import org.geotools.process.spatialstatistics.styler.SSStyleBuilder;
import org.geotools.renderer.lite.StreamingRenderer;
import org.geotools.styling.Style;
import org.json.simple.JSONArray;
import org.locationtech.jts.geom.Envelope;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.io.WKTReader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import egovframework.mango.link.hous.service.LinkHousService;
import egovframework.mango.util.SHImageHelper;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.zaol.common.web.BaseController;
import egovframework.zaol.gisinfo.service.GisBasicVO;

@Controller
public class LinkHousController extends BaseController {

	private static Logger logger = LogManager.getLogger(LinkHousController.class);

	private ObjectMapper mapper;

	@Autowired
	private LinkHousService linkHousService;
	
	@Resource(name = "logsService")
	private LogsService logsService;

	@PostConstruct
	public void initIt() throws NullPointerException, Exception {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}

	@RequestMapping(value="/link/hous.do",
			method = {RequestMethod.GET, RequestMethod.POST})
	 public String linkHous (HttpServletRequest request, HttpServletResponse response,
	    		ModelMap model, @ModelAttribute("gisvo") GisBasicVO gisvo) throws NullPointerException, Exception
	{
		
		HttpSession session = getSession();
		String userS_id = null;
    	if(session != null){
    		userS_id = (String)session.getAttribute("userId");
    	}

        if( userS_id != null ){


//        	model.addAttribute("geoserverURL", "http://connect.miraens.com:59900/geoserver/SH_LM/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20");
//        	model.addAttribute("geoserverURL", "http://128.134.95.129:8080/geoserver/SH_LM/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20");

        	model.addAttribute("geoserverURL", "http://dev.syesd.co.kr:12101/geoserver/SH_LM/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20");

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

    		} 
        	catch (NullPointerException e) 
    		{
    			logger.error("이력 등록 실패");
    		} catch (Exception e) 
    		{
    			logger.error("이력 등록 실패");
    		}
        	
        	return "map/link/hous/hous.sub";

        }else{
        	jsHelper.Alert("비정상적인 접근 입니다.");
        	return  "redirect:/main_home.do";
        }
	}
	@RequestMapping(value = "/hous/get",
			  method = {RequestMethod.GET})
	  public String getBizUrl(HttpServletRequest request) throws NullPointerException, Exception {

//		String baseUrl = request.getContextPath()+"/shex/hous/";
		String baseUrl = "https://shgis.syesd.co.kr/shex/hous/";
		StringBuilder urlBuilder = new StringBuilder(baseUrl);
		Map<String, String[]> paramMap = request.getParameterMap();
		if (!paramMap.isEmpty()) {
			urlBuilder.append("get?");
			for(Map.Entry<String, String[]> entry : paramMap.entrySet()) {
				String key = entry.getKey();
				String[] values = entry.getValue();  
				if(key.equals("pnu")) {
					for(int i=0; i<values.length; i++) {
						urlBuilder.append(key).append("=").append(values[i]).append("&");
						if (i < values.length - 1) {
							urlBuilder.append("&");
						}
					}
				}
			}
			// 마지막 '&' 제거
			urlBuilder.setLength(urlBuilder.length() - 1);  
		}
		String resUrl = urlBuilder.toString();
		return  "redirect:"+resUrl;
	  }
	

}
