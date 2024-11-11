package egovframework.zaol.common.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * 컨트롤러 base 클래스
 *
 * @author wongaside
 *
 */
public class BaseController {

	public		Logger 				log 		= null;		// 로그
	public		JavaScriptHelper 	jsHelper 	= null;		// javascript Helper 클래스

	private 	String 				menu_id		= null;		// 메뉴 ID
	HttpSession						session 	= null;		// 세션 객체
	public SimpleDateFormat resultSdf = new SimpleDateFormat("yyyyMMdd");

	static {
		System.setProperty("org.geotools.referencing.forceXY", "true");
	}
	public BaseController ()
	{
		log = LogManager.getLogger(this.getClass());
		jsHelper = new JavaScriptHelper();
	}

	public HttpSession getSession() {
		return session;
	}

	public void setSession(HttpSession session) {
		this.session = session;
	}

	public String getMenu_id() {
		return menu_id;
	}

	public void setMenu_id(String menu_id) {
		this.menu_id = menu_id;
	}

	public Map getParameterMap(HttpServletRequest request) {
		Map parameterMap = new HashMap();
		Enumeration enums = request.getParameterNames();
	
		while(enums.hasMoreElements()){
			String paramName = (String)enums.nextElement();
			String[] parameters = request.getParameterValues(paramName);
	
			if(parameters.length > 1){
				parameterMap.put(paramName.toUpperCase(), parameters);
			}else{
				parameterMap.put(paramName.toUpperCase(), parameters[0]);
			}
		}
	
		return parameterMap;
	}
	
	public HashMap<String, Object> convertMap(HttpServletRequest request) {
		 
	    HashMap<String, Object> hmap = new HashMap<String, Object>();
	    String key;
	 
	    Enumeration<?> enum1 = request.getParameterNames();
	 
	    while (enum1.hasMoreElements()) {
	        key = (String) enum1.nextElement();
	        if (request.getParameterValues(key).length > 1) {
	            hmap.put(key.toUpperCase(), request.getParameterValues(key));
	        } else {
	            hmap.put(key.toUpperCase(), request.getParameter(key));
	        }
	 
	    }
	 
	    return hmap;
	}

	public String getResultExportId() {
		String dateStr = resultSdf.format(new Date());
		String exportId = dateStr + "-" + UUID.randomUUID().toString();
		return exportId;
	}

}
