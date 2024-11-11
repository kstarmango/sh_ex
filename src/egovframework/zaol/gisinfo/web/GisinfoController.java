package egovframework.zaol.gisinfo.web;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;

import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.UUID;

import javax.annotation.Resource;
import javax.imageio.ImageIO;

import javax.servlet.ServletInputStream;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.bind.DatatypeConverter;
import javax.xml.bind.JAXBElement;


import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.io.IOUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.core.Logger;
import org.docx4j.XmlUtils;
import org.docx4j.dml.wordprocessingDrawing.Inline;
import org.docx4j.jaxb.Context;
import org.docx4j.model.datastorage.migration.VariablePrepare;
import org.docx4j.openpackaging.io.SaveToZipFile;
import org.docx4j.openpackaging.packages.WordprocessingMLPackage;
import org.docx4j.openpackaging.parts.WordprocessingML.BinaryPartAbstractImage;
import org.docx4j.openpackaging.parts.WordprocessingML.MainDocumentPart;
import org.docx4j.org.apache.xml.security.utils.Base64;
import org.docx4j.wml.ContentAccessor;
import org.docx4j.wml.Jc;
import org.docx4j.wml.JcEnumeration;
import org.docx4j.wml.ObjectFactory;
import org.docx4j.wml.P;
import org.docx4j.wml.PPr;
import org.docx4j.wml.Tbl;
import org.docx4j.wml.Tc;
import org.docx4j.wml.Text;
import org.docx4j.wml.Tr;
import org.gdal.gdal.gdal;
import org.gdal.ogr.ogr;
import org.json.XML;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.file.service.FileService;
import egovframework.syesd.cmmn.menu.service.MenuService;
import egovframework.syesd.cmmn.proxy.web.ProxyController;
import egovframework.syesd.cmmn.util.EgovProperties;
import egovframework.syesd.cmmn.util.ogr2ogr;
import egovframework.syesd.portal.user.web.UserController;
import egovframework.zaol.common.CommonUtil;
import egovframework.zaol.common.EgovWebUtil;
import egovframework.zaol.common.Globals;
import egovframework.zaol.common.OraclePaginationInfo;
import egovframework.zaol.common.service.CommonService;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;
import egovframework.zaol.factual.service.FactualVO;
import egovframework.zaol.gisinfo.service.GisBasicVO;
import egovframework.zaol.gisinfo.service.GisinfoService;

import jxl.Workbook;
import jxl.biff.FontRecord;
import jxl.format.Alignment;
import jxl.format.Colour;
import jxl.format.ScriptStyle;
import jxl.format.UnderlineStyle;
import jxl.format.VerticalAlignment;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

import egovframework.zaol.util.service.FileUtil;
import egovframework.zaol.util.service.StringUtil;

import egovframework.zaol.gisinfo.service.GisinfoPostgreVO;

/**
 * GIS정보조회 컨트롤러
 * @author wongaside
 *
 */
@Controller
public class GisinfoController extends BaseController  {
	private static Logger logger = (Logger) LogManager.getLogger(GisinfoController.class);
	
    /* EgovPropertyService */ @Resource(name = "propertiesService") protected EgovPropertyService propertiesService;
    /* service 구하기      */ @Resource(name = "gisinfoService"   ) private   GisinfoService gisinfoService;
    /* 공통 service 구하기 */ @Resource(name = "CommonService"    ) private   CommonService commonservice;

    private static final String validUrl   = RequestMappingConstants.WEB_MAIN;
	private static final String invalidUrl = RequestMappingConstants.WEB_LOGIN;
	
    @Resource(name = "fileService")
    private FileService fileService;

    @Resource(name = "menuService")
	private MenuService menuService;
    
    @RequestMapping(value=RequestMappingConstants.WEB_MAIN)
    public String gisinfo_home(HttpServletRequest request, HttpServletResponse response,
    		ModelMap model, @ModelAttribute("gisvo") GisBasicVO gisvo) throws SQLException, NullPointerException, IOException 
    {
    	//logger.info(" Request 프로퍼티 동적 테스트!!!!!! \t:  " + EgovProperties.getProperty("g.Type")); //.getProperty("g.Type")
    	logger.info("gis main 페이지~~");
    	HttpSession session = getSession();
    	if(session == null ){
    		session = request.getSession(); // 세션 없으면 세션 생성
    	}
    	
    	String userS_id = null;
    	if(session != null){
    		userS_id = (String)session.getAttribute("userId");
    	}

        if( userS_id != null ){

        	session.setAttribute("CSRF_TOKEN",UUID.randomUUID().toString());
        	
        	HashMap<String, Object> param = new HashMap<String, Object>();
        	param.put("lcode", 39);
        	model.addAttribute("menu",menuService.selectLeftMenuInfo(param));
        	
        	List SIGList = gisinfoService.sig_list(gisvo);
        	//List GISCodeList = gisinfoService.gis_code_list(gisvo);

        	model.addAttribute("SIGList", SIGList);
        	//model.addAttribute("GISCodeList", GISCodeList); 사용X


        	gisvo.setUser_id(userS_id);
        	List GISBookMark = null;//gisinfoService.gis_search_bookmark(gisvo);

        	model.addAttribute("GISBookMark", GISBookMark);

        	//2024.08.22 마이데이터 공유기능 추가로 인해 추가
        	HashMap<String, Object> vo = new HashMap<String, Object>();
	       	vo.put("KEY", RequestMappingConstants.KEY);
        	JSONArray jsonArray = new JSONArray();
        	model.addAttribute("shareUserList", jsonArray.fromObject(commonservice.selectUserShare(vo)));
        	//        	model.addAttribute("geoserverURL", "http://connect.miraens.com:59900/geoserver/SH_LM/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20");
//        	model.addAttribute("geoserverURL", "http://128.134.95.129:8080/geoserver/SH_LM/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20");

        	model.addAttribute("geoserverURL", "http://dev.syesd.co.kr:12101/geoserver/SH_LM/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20");
            return "portal/content.jsp";

        }else{
        	jsHelper.Alert("비정상적인 접근 입니다.");
        	return  "redirect:/main_home.do";
        }

    }


    @RequestMapping(value="/landmanager_Content.do")
    public String landmanager_Content(HttpServletRequest request, HttpServletResponse response,
    		ModelMap model, @ModelAttribute("gisVO") GisBasicVO gisVO) 
    {

        return "/SH_/landmanager/Content";
    }

    /**
     *
     * 크로스도메인 회피를 위해 프록시설정
     * @param request
     * @param response
     * @throws Exception
     */
    /* 정상작동시 삭제요망
    @RequestMapping(value = "/mapInclude/getProxy.do")
    public void proxy(HttpServletRequest request,HttpServletResponse response) throws Exception
    {
        String urlParam = EgovWebUtil.decodeXML(request.getParameter("url"));

        if (urlParam == null || urlParam.trim().length() == 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        String filtered_urlParam = urlParam.replaceAll("\r", "").replaceAll("\n", "");

        boolean doPost = request.getMethod().equalsIgnoreCase("POST");
        URL url = new URL(filtered_urlParam);
        HttpURLConnection http = (HttpURLConnection) url.openConnection();
        @SuppressWarnings("rawtypes")
        Enumeration headerNames = request.getHeaderNames();
        while (headerNames.hasMoreElements()) {
            String key = (String) headerNames.nextElement();

            if (!key.equalsIgnoreCase("Host")) {
                http.setRequestProperty(key, request.getHeader(key));
            }
        }

        http.setDoInput(true);
        http.setDoOutput(doPost);
        http.setRequestProperty("Content-type", "text/xml");
        http.setRequestProperty("Accept", "text/xml, application/xml");
        byte[] buffer = new byte[90000];
        int read = -1;

        if (doPost) {
            OutputStream os = http.getOutputStream();
            ServletInputStream sis = request.getInputStream();
            while ((read = sis.read(buffer)) != -1) {
                os.write(buffer, 0, read);
            }
            os.close();
        }

        InputStream is = http.getInputStream();
        response.setStatus(http.getResponseCode());

        response.setContentType("charset=utf-8");
        response.setCharacterEncoding("utf-8");

        Map<?, ?> headerKeys = http.getHeaderFields();
        Set<?> keySet = headerKeys.keySet();
        Iterator<?> iter = keySet.iterator();
        while (iter.hasNext()) {
            String key = (String) iter.next();
            String value = http.getHeaderField(key);
            if (key != null && value != null) {
                response.setHeader(key, value);
            }
        }

        ServletOutputStream sos = response.getOutputStream();
        response.resetBuffer();
        while ((read = is.read(buffer)) != -1) {
            sos.write(buffer, 0, read);
        }
        response.flushBuffer();
        sos.close();
    }*/

    @RequestMapping(value = "/mapInclude/getProxy.do")
    public void proxy(HttpServletRequest request,HttpServletResponse reponse) throws NullPointerException
    {
    	String reqURL = request.getParameter("url");
    	
    	HttpURLConnection httpURLConnection = null;
		InputStream is = null;
		
		try {
			
			Enumeration<String> e = request.getParameterNames();
			
			StringBuffer param = new StringBuffer();
		
			while (e.hasMoreElements()) {
				String paramKey = (String) e.nextElement();
				if(!"url".equals(paramKey)) {
					String[] values = request.getParameterValues(paramKey);
					for (String value:values) {
						param.append(paramKey+"="+value+"&");
					}
				}
			}//while
			
			String query = param.toString();
			
			if(!"".equals(query) && query != null) {
				query = query.substring(0,query.lastIndexOf("&"));
				reqURL = reqURL+"?"+query;
			}
			logger.info("reqURL:"+reqURL);
			//실제 geoserevr 연결
			URL realUrl = new URL(reqURL);
			httpURLConnection = (HttpURLConnection) realUrl.openConnection();
			
			
			//header 정보 가져오기
			//header 정보 셋팅
			Enumeration<String> headerKey = request.getHeaderNames();
			while (headerKey.hasMoreElements()) {
				String key = (String) headerKey.nextElement();
				String value = request.getHeader(key);
				httpURLConnection.addRequestProperty(key, value);
			}
			
			httpURLConnection.setRequestMethod(request.getMethod().toUpperCase());
			
			reponse.setContentType(httpURLConnection.getContentType());
			logger.info("결과!!!!!!"+reponse.getOutputStream().toString());
			if(httpURLConnection.getResponseCode() == 200) {
				IOUtils.copy(httpURLConnection.getInputStream(), reponse.getOutputStream());
			}else {
				IOUtils.copy(httpURLConnection.getErrorStream(), reponse.getOutputStream());
			}
			
		}catch (IOException e) {
			logger.info("error가 발생하였습니다.");
		}
		/*catch (Exception e) {
			if(logger.isErrorEnabled()) {
				logger.error("Proxy Error: "+ reqURL);
			}
		} finally {
			try {
				if(is != null) {is.close();}
			} catch (IOException e) {
				if(logger.isErrorEnabled()) {
					logger.error("exception",e);
				}
			}
			
			if(httpURLConnection != null) {httpURLConnection.disconnect();}
			
		}*/
    }

    
    @RequestMapping(value = "/search/getProxy.do")
    public ModelAndView searchProxy(HttpServletRequest request,HttpServletResponse reponse, ModelMap model) throws NullPointerException, IOException 
    {
    	ModelAndView modelAndView = new ModelAndView();
    	String keyword = request.getParameter("keyword");
    	String type = request.getParameter("type");
    	String page = request.getParameter("page");
    	
    	HttpURLConnection conn = null;
		InputStream is = null;
		
		HttpSession session = getSession();
		String userS_id = null;
    	if(session != null){
    		userS_id = (String)session.getAttribute("userId");
    	}

        if( userS_id != null ){
			try {
				
		        HashMap<String, Object> map = new HashMap<String, Object>();
		        
		        if("summary".equals(type)) {
		        	searchRoadProxy(keyword,page,map);
			        searchJibunProxy(keyword,page,map);
			        searchPinoProxy(keyword,map);
		        }else if("road".equals(type)) {
		        	searchRoadProxy(keyword,page,map); 
		        }else if("jibun".equals(type)) {
		        	 searchJibunProxy(keyword,page,map);
		        }else if("pino".equals(type)) {
		        	 searchPinoProxy(keyword,map);
		        }
		        logger.info("map!!!!!!!!"+map.toString());
		        modelAndView.addObject("search", map);
		        modelAndView.setViewName("jsonView");
		        return modelAndView; 
		    	
			}catch (IOException e) {
				logger.info("error가 발생하였습니다.");
			}
        }else {
        	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
        }
    		return null;
    }
    
    public void searchRoadProxy(String keyword, String page, HashMap<String, Object> map) throws IOException 
    {
    	ModelAndView modelAndView = new ModelAndView();
    	HttpSession session = getSession();
		String userS_id = null;
    	if(session != null){
    		userS_id = (String)session.getAttribute("userId");
    	}

        if( userS_id != null ){
        	
        	StringBuilder urlBuilder;
    		URL url;
    		HttpURLConnection conn;
    		BufferedReader rd;
    		
    		String keyUrl = EgovProperties.getProperty("g.roadUrlKey"); //"U01TX0FVVEgyMDE3MTIwNjExMjQ1NTEwNzUzMzE="; //프로퍼티파일로 이동 예정
    		
    		 urlBuilder = new StringBuilder(EgovProperties.getProperty("g.roadUrl")); /*URL 프로퍼티파일로 이동 예정*/
    		 urlBuilder.append("?" + URLEncoder.encode("confmKey","UTF-8") + "="+keyUrl); /*Service Key*/
             urlBuilder.append("&" + URLEncoder.encode("keyword","UTF-8") + "=" + URLEncoder.encode(keyword, "UTF-8")); /*YYYYMMDD*/
             urlBuilder.append("&" + URLEncoder.encode("resultType","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); /*YYYYMMDD*/
             urlBuilder.append("&" + URLEncoder.encode("currentPage","UTF-8") + "=" + URLEncoder.encode(page, "UTF-8")); /*페이지번호*/
             urlBuilder.append("&" + URLEncoder.encode("countPerPage","UTF-8") + "=" + URLEncoder.encode("10", "UTF-8")); /*페이지당 목록 수*/
             
             url = new URL(urlBuilder.toString());
             conn = (HttpURLConnection) url.openConnection();
             conn.setRequestMethod("GET");
             conn.setRequestProperty("Content-type", "application/json");
             
             if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
                 rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
             } else {
                 rd = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
             }
             StringBuilder sb = new StringBuilder();
             String line;
             while ((line = rd.readLine()) != null) {
                 sb.append(line);
             }
             rd.close();
             conn.disconnect();
    		
             ObjectMapper mapper = new ObjectMapper();
             Map<String, Object> map3 = mapper.readValue(sb.toString(), Map.class);
             map3 = (Map<String, Object>) map3.get("results"); 
            
             Map<String, Object> common = (Map<String, Object>) map3.get("common");
             map.put("RoadCount",Integer.parseInt(common.get("totalCount").toString()));
            
             //map3 = (Map<String, Object>) map3.get("juso");
             ArrayList<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
             list =  (ArrayList<Map<String, Object>>)map3.get("juso");
             
             map.put("Road",list);
             
			//return modelAndView;
        }else {
        	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
        }
    		//return null;
    }
    
    public void searchJibunProxy(String keyword, String page, HashMap<String, Object> map) throws IOException 
    {
    	ModelAndView modelAndView = new ModelAndView();
    	HttpSession session = getSession();
		String userS_id = null;
    	if(session != null){
    		userS_id = (String)session.getAttribute("userId");
    	}

        if( userS_id != null ){
        	StringBuilder urlBuilder;
    		URL url;
    		HttpURLConnection conn;
    		BufferedReader rd;
    		
    		String keyUrl = EgovProperties.getProperty("g.vworldKey");//"A38B3266-0366-32E8-9A69-4D73B5947B5C"; //프로퍼티파일로 이동 예정
    		
    		 urlBuilder = new StringBuilder(EgovProperties.getProperty("g.vworldAddrUrl")); /*URL 프로퍼티파일로 이동 예정*/
    		 urlBuilder.append("?" + URLEncoder.encode("key","UTF-8") + "="+keyUrl); /*Service Key*/
             urlBuilder.append("&" + URLEncoder.encode("query","UTF-8") + "=" + URLEncoder.encode(keyword, "UTF-8")); 
             urlBuilder.append("&" + URLEncoder.encode("request","UTF-8") + "=" + URLEncoder.encode("search", "UTF-8")); 
             urlBuilder.append("&" + URLEncoder.encode("category","UTF-8") + "=" + URLEncoder.encode("PARCEL", "UTF-8")); 
             urlBuilder.append("&" + URLEncoder.encode("type","UTF-8") + "=" + URLEncoder.encode("ADDRESS", "UTF-8")); 
             urlBuilder.append("&" + URLEncoder.encode("format","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); 
             urlBuilder.append("&" + URLEncoder.encode("page","UTF-8") + "=" + URLEncoder.encode(page, "UTF-8")); /*페이지번호*/
             urlBuilder.append("&" + URLEncoder.encode("size","UTF-8") + "=" + URLEncoder.encode("10", "UTF-8")); /*페이지당 목록 수*/
             
             url = new URL(urlBuilder.toString());
             conn = (HttpURLConnection) url.openConnection();
             conn.setRequestMethod("GET");
             conn.setRequestProperty("Content-type", "application/json");
             
             if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
                 rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
             } else {
                 rd = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
             }
             StringBuilder sb = new StringBuilder();
             String line;
             sb = new StringBuilder();
             while ((line = rd.readLine()) != null) {
                 sb.append(line);
             }
             rd.close();
             conn.disconnect();
             
             ObjectMapper mapper = new ObjectMapper();
             Map<String, Object> map3 = mapper.readValue(sb.toString(), Map.class);
             map3 = (Map<String, Object>) map3.get("response");
            
             Map<String, Object> record = (Map<String, Object>) map3.get("record");
             map.put("JibunCount",Integer.parseInt(record.get("total").toString()));
             ArrayList<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
             if(!"0".equals(record.get("total"))) {
            	 map3 = (Map<String, Object>) map3.get("result");
                 list =  (ArrayList<Map<String, Object>>) map3.get("items"); 
             }
             
             map.put("Jibun",list);
			//return modelAndView;
        }else {
        	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
        }
    		//return null;
    }
    
    public void searchPinoProxy(String keyword, HashMap<String, Object> map) throws IOException
    {
    	ModelAndView modelAndView = new ModelAndView();
    	HttpSession session = getSession();
		String userS_id = null;
    	if(session != null){
    		userS_id = (String)session.getAttribute("userId");
    	}

        if( userS_id != null ){
        	
        	StringBuilder urlBuilder;
    		URL url;
    		HttpURLConnection conn;
    		BufferedReader rd;
    		
    		 urlBuilder = new StringBuilder(EgovProperties.getProperty("g.pinogeoUrl")+"/api/geocode/get"); /*URL 프로퍼티파일로 이동 예정*/
    		 urlBuilder.append("?" + URLEncoder.encode("addr","UTF-8") + "="+  URLEncoder.encode(keyword, "UTF-8")); /*Service Key*/
             urlBuilder.append("&" + URLEncoder.encode("srid","UTF-8") + "=" + URLEncoder.encode("4326", "UTF-8")); 
            
             
             url = new URL(urlBuilder.toString());
             conn = (HttpURLConnection) url.openConnection();
             conn.setRequestMethod("GET");
             conn.setRequestProperty("Content-type", "application/json");
             logger.info("Response code: " + conn.getResponseCode());
             if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
                 rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
             } else {
                 rd = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
             }
             StringBuilder sb = new StringBuilder();
             String line;
             sb = new StringBuilder();
             while ((line = rd.readLine()) != null) {
                 sb.append(line);
             }
             rd.close();
             conn.disconnect();
             
             ObjectMapper mapper = new ObjectMapper();
             Map<String, Object> map3 = mapper.readValue(sb.toString(), Map.class);
            
             ArrayList<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
             list =  (ArrayList<Map<String, Object>>) map3.get("DATA");
             map.put("Pino",list);
             
             map.put("PinoCount",list.size());
             
             
			//return modelAndView;
        }else {
        	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
        }
    		//return null;
    }
    
    
    
    /** 시도별 시군구 조회     
     * @throws SQLException 
     * @throws IOException */
    @RequestMapping(value="/ajaxDB_sig_list.do")
    public void ajaxDB_sig_list(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO) throws SQLException, IOException 
    { 
    	response.setCharacterEncoding("UTF-8");
		String sidocd = request.getParameter("sidocd");
		gisVO.setSido_cd(sidocd);
		List SigList = gisinfoService.sig_list(gisVO);

		JSONArray sig_nm = new JSONArray();
		JSONArray sig_cd = new JSONArray();
		JSONArray addr_x = new JSONArray();
		JSONArray addr_y = new JSONArray();
		JSONObject obj = new JSONObject();

		if( SigList != null && SigList.size() > 0 ) {
			for( int i=0; i<SigList.size(); i++ ) {
				HashMap result = ( HashMap )SigList.get(i);
				sig_nm.add(result.get("sig_kor_nm"));
				sig_cd.add(result.get("sig_cd"));
				addr_x.add(result.get("addr_x"));
				addr_y.add(result.get("addr_y"));
			}
		}
		obj.put("sig_nm", sig_nm);
		obj.put("sig_cd", sig_cd);
		obj.put("addr_x", addr_x);
		obj.put("addr_y", addr_y);
		PrintWriter out = response.getWriter();
		out.println(obj.toString());
    }


    /** 시군구별 읍면동 조회     
     * @throws SQLException 
     * @throws IOException */
    @RequestMapping(value="/ajaxDB_emd_list.do")
    public void ajaxDB_emd_list(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO) throws SQLException, IOException 
    { 
    	response.setCharacterEncoding("UTF-8");
		String sigcd = request.getParameter("sigcd");

		gisVO.setEmd(sigcd);
		List EMDList = gisinfoService.emd_list(gisVO);

		JSONArray emd_nm = new JSONArray();
		JSONArray emd_cd = new JSONArray();
		JSONArray addr_x = new JSONArray();
		JSONArray addr_y = new JSONArray();
		JSONObject obj = new JSONObject();

		if( EMDList != null && EMDList.size() > 0 ) {
			for( int i=0; i<EMDList.size(); i++ ) {
				HashMap result = ( HashMap )EMDList.get(i);
				emd_nm.add(result.get("emd_kor_nm"));
				emd_cd.add(result.get("emd_cd"));
				addr_x.add(result.get("addr_x"));
				addr_y.add(result.get("addr_y"));
			}
		}
		obj.put("emd_nm", emd_nm);
		obj.put("emd_cd", emd_cd);
		obj.put("addr_x", addr_x);
		obj.put("addr_y", addr_y);
		PrintWriter out = response.getWriter();
		out.println(obj.toString());
    }

    /** 지번 조회     
     * @throws SQLException 
     * @throws IOException */
    @RequestMapping(value="/ajaxDB_jibun_list.do")
    public void ajaxDB_jibun_list(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO) throws SQLException, IOException
    {
    	response.setCharacterEncoding("UTF-8");

    	HashMap param = new HashMap();
    	/*
    	param.put("si", request.getParameter("si"));
    	param.put("gu", request.getParameter("gu"));
    	param.put("emd", request.getParameter("emd"));
    	param.put("li", request.getParameter("li"));
    	*/
    	param.put("sgg", request.getParameter("sgg"));
    	param.put("jibun", request.getParameter("jibun"));
    	//param.put("san", request.getParameter("san")); 240401 san 주석처리

		List JibunList = gisinfoService.jibun_list(param);

		JSONArray addr = new JSONArray();  //jibun_like_search_test
		JSONArray jibun2 = new JSONArray(); //jibun_like_search_test
		JSONArray addr_x = new JSONArray();
		JSONArray addr_y = new JSONArray();
		JSONArray geom = new JSONArray();
		JSONObject obj = new JSONObject();

		if( JibunList != null && JibunList.size() > 0 ) {
			for( int i=0; i<JibunList.size(); i++ ) {
				HashMap result = ( HashMap )JibunList.get(i);
				addr.add(result.get("addr")); //jibun_like_search_test
				jibun2.add(result.get("jibun2")); //jibun_like_search_test
				addr_x.add(result.get("addr_x"));
				addr_y.add(result.get("addr_y"));
				geom.add(result.get("geom"));
			}
		}
		obj.put("addr", addr); //jibun_like_search_test
		obj.put("jibun2", jibun2); //jibun_like_search_test
		obj.put("addr_x", addr_x);
		obj.put("addr_y", addr_y);
		obj.put("geom", geom);
		PrintWriter out = response.getWriter();
		out.println(obj.toString());
    }

    /** 레이어 대상 중분류 조회     
     * @throws SQLException 
     * @throws IOException */
    @RequestMapping(value="/ajaxDB_gb02_list.do")
    public void ajaxDB_gb02_list(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO) throws SQLException, IOException 
    {
    	response.setCharacterEncoding("UTF-8");
    	String gb = request.getParameter("gb");
		String gb_cd = request.getParameter("gb_cd");

		//레이어 구분
		if(		"sa01-01".equals(gb) || "buld01-04".equals(gb) || "land01-08".equals(gb) ){	gb = "01"; 	}
		else if("sa01-04".equals(gb) || "buld01-07".equals(gb) ){	gb = "02";	}

		gisVO.setSh_kind(gb);
		gisVO.setKind(gb_cd);
		List gb02_list = gisinfoService.gb02_list(gisVO);

		JSONArray nm = new JSONArray();
		JSONArray no = new JSONArray();
		JSONObject obj = new JSONObject();

		if( gb02_list != null && gb02_list.size() > 0 ) {
			for( int i=0; i<gb02_list.size(); i++ ) {
				HashMap result = ( HashMap )gb02_list.get(i);
				nm.add(result.get("nm"));
				no.add(result.get("no"));
			}
		}
		obj.put("nm", nm);
		obj.put("no", no);
		PrintWriter out = response.getWriter();
		out.println(obj.toString());
    }
    /** 레이어 대상 소분류 조회     
     * @throws SQLException 
     * @throws IOException */
    @RequestMapping(value="/ajaxDB_gb03_list.do")
    public void ajaxDB_gb03_list(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO) throws SQLException, IOException 
    {
    	response.setCharacterEncoding("UTF-8");
    	String gb = request.getParameter("gb");
		String gb_cd = request.getParameter("gb_cd");
		String gb_val = request.getParameter("gb_val");

		//레이어 구분
		if(		"sa01-02".equals(gb) || "buld01-05".equals(gb) || "land01-09".equals(gb) ){	gb = "01"; 	}
		else if("sa01-05".equals(gb) || "buld01-08".equals(gb) ){	gb = "02";	}
		else if("sa01-07".equals(gb) || "land01-11".equals(gb) ){	gb = "03";	}

		gisVO.setSh_kind(gb);
		gisVO.setKind(gb_cd);
		gisVO.setPk(gb_val);
		List gb03_list = gisinfoService.gb03_list(gisVO);

		JSONArray nm = new JSONArray();
		JSONArray no = new JSONArray();
		JSONObject obj = new JSONObject();

		if( gb03_list != null && gb03_list.size() > 0 ) {
			for( int i=0; i<gb03_list.size(); i++ ) {
				HashMap result = ( HashMap )gb03_list.get(i);
				nm.add(result.get("nm"));
				no.add(result.get("no"));
			}
		}
		obj.put("nm", nm);
		obj.put("no", no);
		PrintWriter out = response.getWriter();
		out.println(obj.toString());
    }
    
    /** 데이터추출 SHP     
     * @throws IOException 
     * @throws FileNotFoundException */
    @RequestMapping(value="/ajaxDB_data_list.do")
    public void ajaxDB_data_list(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO) throws FileNotFoundException, IOException 
    {
    	response.setCharacterEncoding("UTF-8");
		String pk = request.getParameter("pk");
		String kind = request.getParameter("kind");

		JSONObject obj = new JSONObject();

		String savePath = RequestMappingConstants.TOMCAT_PATH + RequestMappingConstants.TEMPORARY_FOLDER;

		Date nowDate = new Date();
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd");
		String strToday = simpleDateFormat.format(nowDate);

		//기존String strConn = "PG:dbname='SH_LM' host='localhost' port='15432' user='postgres' password='1234'";

		String strConn = "PG:dbname='SH_LM' host='dev.syesd.co.kr' port='5466' user='postgres' password='postgres'";
		
		if("land".equalsIgnoreCase(kind) == true) { //지적추출일때
			String filePath = "D:/export_tiger.bat land landsys_gis ctnu_lgstr_su 4326 \""+pk+"\" 4326 intersects";
			
			logger.info("@@@@@@@>>>>"+filePath);
			 try {
				 Process p = Runtime.getRuntime().exec(filePath);
				 BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream()));
				 String line = null;
				 logger.info("br.readLine():::"+br.readLine());
				 while ((line = br.readLine()) != null) {
					// logger.info(line);
				 }
			 } catch (IOException e) {
				logger.error("오류입니다.");
			 }
			
			
			/*String[] fileList = { savePath + "LAND_EXPORT_4326_" + strToday + ".shp",
								  savePath + "LAND_EXPORT_4326_" + strToday + ".shx",
								  savePath + "LAND_EXPORT_4326_" + strToday + ".dbf",
								  savePath + "LAND_EXPORT_4326_" + strToday + ".prj",
								};

	    	String[] cmd1 = {"-f", "ESRI Shapefile", fileList[0], strConn, "-sql", "SELECT A.PNU AS PNU, A.THE_GEOM AS GEOM, B.PAREA, B.PNILP, B.JIMOK, B.SPFC1 AS SPFC, B.LAND_USE, B.GEO_HL, B.GEO_FORM, B.ROAD_SIDE, C.A10 AS PRTOWN FROM LANDSYS_GIS.CTNU_LGSTR_SU A, SN_APMM_NV_LAND_11 B, SN_LAND_KIND_11 C WHERE ST_INTERSECTS(ST_TRANSFORM(A.THE_GEOM, 5179) , ST_TRANSFORM(ST_SETSRID(ST_GEOMFROMTEXT('" + pk + "'), 4326), 5179)) AND ST_AREA(ST_INTERSECTION(A.THE_GEOM, ST_SETSRID(ST_GEOMFROMTEXT('" + pk + "'), 4326))) >= ST_AREA(A.THE_GEOM)/2 AND A.PNU = B.PNU AND A.PNU = C.A1"};
	    	ogr2ogr.main(cmd1);

	    	String downName = "LAND_EXPORT_4326_" + strToday + ".zip";

	    	List<HashMap<String, String>> newList = new ArrayList<HashMap<String, String>>();

	    	HashMap<String, String> file1 = new HashMap<String, String>();
	    	file1.put("SAVE_NAME", fileList[0]);
	    	file1.put("FILE_NAME", "LAND_EXPORT_4326_" + strToday + ".shp");

	    	newList.add(file1);

	    	HashMap<String, String> file2 = new HashMap<String, String>();
	    	file2.put("SAVE_NAME", fileList[1]);
	    	file2.put("FILE_NAME", "LAND_EXPORT_4326_" + strToday + ".shx");

	    	newList.add(file2);

	    	HashMap<String, String> file3 = new HashMap<String, String>();
	    	file3.put("SAVE_NAME", fileList[2]);
	    	file3.put("FILE_NAME", "LAND_EXPORT_4326_" + strToday + ".dbf");

	    	newList.add(file3);

	    	HashMap<String, String> file4 = new HashMap<String, String>();
	    	file4.put("SAVE_NAME", fileList[3]);
	    	file4.put("FILE_NAME", "LAND_EXPORT_4326_" + strToday + ".prj");

	    	newList.add(file4);

	    	fileService.compress(newList, savePath, downName);
*/
			 savePath = "D:\\sh_local\\dnload"+File.separator;
			 String downName = "land.zip";
			// 파일 - 헤더
			File file = new File(savePath + downName);
			response.setContentType("application/x-msdownload; charset=utf-8");
		    response.setContentLength((int)file.length());
		    response.setHeader("Content-Transfer-Encoding", "binary");
		    response.setHeader("Content-Disposition", "attachment;fileName=\"" + downName + "\";");

		    // 파일 - 전송
		    fileService.writeToClient(file, response);
		} else {
			String[] fileList = { savePath + "BUILD_EXPORT_4326_" + strToday + ".shp",
								  savePath + "BUILD_EXPORT_4326_" + strToday + ".shx",
								  savePath + "BUILD_EXPORT_4326_" + strToday + ".dbf",
								  savePath + "BUILD_EXPORT_4326_" + strToday + ".prj",
								};

	    	String[] cmd1 = {"-f", "ESRI Shapefile", fileList[0], strConn, "-sql", "SELECT A.PNU AS PNU, A.THE_GEOM AS GEOM, A.BILD_STRCT_CODE, A.BILD_AR, A.TOTAR FROM LANDSYS_GIS.GIS_BULD_UNITY_INFO_SU A WHERE ST_INTERSECTS(ST_TRANSFORM(A.THE_GEOM, 5179) , ST_TRANSFORM(ST_SETSRID(ST_GEOMFROMTEXT('" + pk + "'), 4326), 5179)) AND ST_AREA(ST_INTERSECTION(A.THE_GEOM, ST_SETSRID(ST_GEOMFROMTEXT('" + pk + "'), 4326))) >= ST_AREA(A.THE_GEOM)/2"};
	    	ogr2ogr.main(cmd1);

	    	String downName = "BUILD_EXPORT_4326_" + strToday + ".zip";

	    	List<HashMap<String, String>> newList = new ArrayList<HashMap<String, String>>();

	    	HashMap<String, String> file1 = new HashMap<String, String>();
	    	file1.put("SAVE_NAME", fileList[0]);
	    	file1.put("FILE_NAME", "BUILD_EXPORT_4326_" + strToday + ".shp");

	    	newList.add(file1);

	    	HashMap<String, String> file2 = new HashMap<String, String>();
	    	file2.put("SAVE_NAME", fileList[1]);
	    	file2.put("FILE_NAME", "BUILD_EXPORT_4326_" + strToday + ".shx");

	    	newList.add(file2);

	    	HashMap<String, String> file3 = new HashMap<String, String>();
	    	file3.put("SAVE_NAME", fileList[2]);
	    	file3.put("FILE_NAME", "BUILD_EXPORT_4326_" + strToday + ".dbf");

	    	newList.add(file3);

	    	HashMap<String, String> file4 = new HashMap<String, String>();
	    	file4.put("SAVE_NAME", fileList[3]);
	    	file4.put("FILE_NAME", "BUILD_EXPORT_4326_" + strToday + ".prj");

	    	newList.add(file4);

	    	fileService.compress(newList, savePath, downName);

			// 파일 - 헤더
			File file = new File(savePath + downName);
			response.setContentType("application/x-msdownload; charset=utf-8");
		    response.setContentLength((int)file.length());
		    response.setHeader("Content-Transfer-Encoding", "binary");
		    response.setHeader("Content-Disposition", "attachment;fileName=\"" + downName + "\";");

		    // 파일 - 전송
		    fileService.writeToClient(file, response);
		}

		/*PrintWriter out = response.getWriter();
		out.println(obj.toString());*/
    }



    /** 데이터추출 SHP_기존     
     * @throws UnsupportedEncodingException 
     * @throws SQLException */
   /* @RequestMapping(value="/ajaxDB_data_list_bak.do")
    public void ajaxDB_data_list_bak(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO) throws Exception
    {
    	response.setCharacterEncoding("UTF-8");
		String pk = request.getParameter("pk");
		String kind = request.getParameter("kind");

		JSONObject obj = new JSONObject();

		String savePath = RequestMappingConstants.TOMCAT_PATH + RequestMappingConstants.TEMPORARY_FOLDER;

		Date nowDate = new Date();
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd");
		String strToday = simpleDateFormat.format(nowDate);


		String strConn = "PG:dbname='SH_LM' host='dev.syesd.co.kr' port='5466' user='postgres' password='postgres'";
		
		if("land".equalsIgnoreCase(kind) == true) {
			
			String[] fileList = { savePath + "LAND_EXPORT_4326_" + strToday + ".shp",
								  savePath + "LAND_EXPORT_4326_" + strToday + ".shx",
								  savePath + "LAND_EXPORT_4326_" + strToday + ".dbf",
								  savePath + "LAND_EXPORT_4326_" + strToday + ".prj",
								};

	    	String[] cmd1 = {"-f", "ESRI Shapefile", fileList[0], strConn, "-sql", "SELECT A.PNU AS PNU, A.THE_GEOM AS GEOM, B.PAREA, B.PNILP, B.JIMOK, B.SPFC1 AS SPFC, B.LAND_USE, B.GEO_HL, B.GEO_FORM, B.ROAD_SIDE, C.A10 AS PRTOWN FROM LANDSYS_GIS.CTNU_LGSTR_SU A, SN_APMM_NV_LAND_11 B, SN_LAND_KIND_11 C WHERE ST_INTERSECTS(ST_TRANSFORM(A.THE_GEOM, 5179) , ST_TRANSFORM(ST_SETSRID(ST_GEOMFROMTEXT('" + pk + "'), 4326), 5179)) AND ST_AREA(ST_INTERSECTION(A.THE_GEOM, ST_SETSRID(ST_GEOMFROMTEXT('" + pk + "'), 4326))) >= ST_AREA(A.THE_GEOM)/2 AND A.PNU = B.PNU AND A.PNU = C.A1"};
	    	ogr2ogr.main(cmd1);

	    	String downName = "LAND_EXPORT_4326_" + strToday + ".zip";

	    	List<HashMap<String, String>> newList = new ArrayList<HashMap<String, String>>();

	    	HashMap<String, String> file1 = new HashMap<String, String>();
	    	file1.put("SAVE_NAME", fileList[0]);
	    	file1.put("FILE_NAME", "LAND_EXPORT_4326_" + strToday + ".shp");

	    	newList.add(file1);

	    	HashMap<String, String> file2 = new HashMap<String, String>();
	    	file2.put("SAVE_NAME", fileList[1]);
	    	file2.put("FILE_NAME", "LAND_EXPORT_4326_" + strToday + ".shx");

	    	newList.add(file2);

	    	HashMap<String, String> file3 = new HashMap<String, String>();
	    	file3.put("SAVE_NAME", fileList[2]);
	    	file3.put("FILE_NAME", "LAND_EXPORT_4326_" + strToday + ".dbf");

	    	newList.add(file3);

	    	HashMap<String, String> file4 = new HashMap<String, String>();
	    	file4.put("SAVE_NAME", fileList[3]);
	    	file4.put("FILE_NAME", "LAND_EXPORT_4326_" + strToday + ".prj");

	    	newList.add(file4);

	    	fileService.compress(newList, savePath, downName);

			// 파일 - 헤더
			File file = new File(savePath + downName);
			response.setContentType("application/x-msdownload; charset=utf-8");
		    response.setContentLength((int)file.length());
		    response.setHeader("Content-Transfer-Encoding", "binary");
		    response.setHeader("Content-Disposition", "attachment;fileName=\"" + downName + "\";");

		    // 파일 - 전송
		    fileService.writeToClient(file, response);
		} else {
		
			String[] fileList = { savePath + "BUILD_EXPORT_4326_" + strToday + ".shp",
								  savePath + "BUILD_EXPORT_4326_" + strToday + ".shx",
								  savePath + "BUILD_EXPORT_4326_" + strToday + ".dbf",
								  savePath + "BUILD_EXPORT_4326_" + strToday + ".prj",
								};

	    	String[] cmd1 = {"-f", "ESRI Shapefile", fileList[0], strConn, "-sql", "SELECT A.PNU AS PNU, A.THE_GEOM AS GEOM, A.BILD_STRCT_CODE, A.BILD_AR, A.TOTAR FROM LANDSYS_GIS.GIS_BULD_UNITY_INFO_SU A WHERE ST_INTERSECTS(ST_TRANSFORM(A.THE_GEOM, 5179) , ST_TRANSFORM(ST_SETSRID(ST_GEOMFROMTEXT('" + pk + "'), 4326), 5179)) AND ST_AREA(ST_INTERSECTION(A.THE_GEOM, ST_SETSRID(ST_GEOMFROMTEXT('" + pk + "'), 4326))) >= ST_AREA(A.THE_GEOM)/2"};
	    	ogr2ogr.main(cmd1);

	    	String downName = "BUILD_EXPORT_4326_" + strToday + ".zip";

	    	List<HashMap<String, String>> newList = new ArrayList<HashMap<String, String>>();

	    	HashMap<String, String> file1 = new HashMap<String, String>();
	    	file1.put("SAVE_NAME", fileList[0]);
	    	file1.put("FILE_NAME", "BUILD_EXPORT_4326_" + strToday + ".shp");

	    	newList.add(file1);

	    	HashMap<String, String> file2 = new HashMap<String, String>();
	    	file2.put("SAVE_NAME", fileList[1]);
	    	file2.put("FILE_NAME", "BUILD_EXPORT_4326_" + strToday + ".shx");

	    	newList.add(file2);

	    	HashMap<String, String> file3 = new HashMap<String, String>();
	    	file3.put("SAVE_NAME", fileList[2]);
	    	file3.put("FILE_NAME", "BUILD_EXPORT_4326_" + strToday + ".dbf");

	    	newList.add(file3);

	    	HashMap<String, String> file4 = new HashMap<String, String>();
	    	file4.put("SAVE_NAME", fileList[3]);
	    	file4.put("FILE_NAME", "BUILD_EXPORT_4326_" + strToday + ".prj");

	    	newList.add(file4);

	    	fileService.compress(newList, savePath, downName);

			// 파일 - 헤더
			File file = new File(savePath + downName);
			response.setContentType("application/x-msdownload; charset=utf-8");
		    response.setContentLength((int)file.length());
		    response.setHeader("Content-Transfer-Encoding", "binary");
		    response.setHeader("Content-Disposition", "attachment;fileName=\"" + downName + "\";");

		    // 파일 - 전송
		    fileService.writeToClient(file, response);
		}	
    }*/

    /* 자산검색 상세정보 - 팝업창(사업지구)  */
    @RequestMapping(value="/Content_SH_View_Detail_sh.do")
    public String Content_SH_View_Detail_sh(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO, ModelMap model) throws UnsupportedEncodingException, SQLException 
    {
    	response.setCharacterEncoding("UTF-8");
    	request.setCharacterEncoding("UTF-8");

    	String gid = request.getParameter("gid");
    	String kind = request.getParameter("kind");
    	String sh_kind = request.getParameter("sh_kind");

    	logger.info("gid::::::::::"+gid);
    	gisVO.setPk(gid);
    	model.addAttribute("gid", gid);

    	List dist_list = null;


		if("22".equals(kind)){
			dist_list = gisinfoService.gis_dist_detail_1(gisVO); //'마곡'지구
			model.addAttribute("dist_list", dist_list);
			return "/SH_/landmanager/Content_SH_View_Detail_sh_popup1";
		}else{
			dist_list = gisinfoService.gis_dist_detail_2(gisVO); //그 외 사업지구
			model.addAttribute("dist_list", dist_list);


			if(	"unsold".equals(sh_kind) ){
				List dist_list_add = gisinfoService.gis_dist_detail_2(gisVO); //그 외 사업지구 - 추가정보
				model.addAttribute("dist_list_add", dist_list_add);
			}

			return "/SH_/landmanager/Content_SH_View_Detail_sh_popup2";
		}

    }
    /* 자산검색 상세정보 - 정보교체  */
    @RequestMapping(value="/ajaxDB_Content_Detail.do")
    public void ajaxDB_Content_Detail(HttpServletRequest request,HttpServletResponse response, GisBasicVO bookmarkVO) throws SQLException, IOException
    {
    	response.setCharacterEncoding("UTF-8");

    	String gid = request.getParameter("gid");
    	String pnu = request.getParameter("pnu");
    	String target = request.getParameter("target");
    	bookmarkVO.setPk(gid);
    	bookmarkVO.setPnu(pnu);

    	List list = null;
    	if(target.equals("dboh")){ //총괄표제부
    		list = gisinfoService.gis_buld_detail_1(bookmarkVO);
    	}else if(target.equals("bdfc")){ //전유부
    		list = gisinfoService.gis_buld_detail_2(bookmarkVO);
    	}else if(target.equals("bdhd")){ //표제부
    		list = gisinfoService.gis_buld_detail_3(bookmarkVO);
    	}

    	JSONArray jArray = new JSONArray();
		if( list != null && list.size() > 0 ) {
			HashMap vo = ( HashMap )list.get(list.size()-1);
				JSONObject jObj = new JSONObject();

				String[] dboh_val = {
						"manage_bild_regstr", "plot_lc", "rn_plot_lc", "buld_nm", "spcl_nmfpc", "blck", "lot", "else_lot_co", "plot_ar", "bildng_ar",
						"bdtldr", "totar", "cpcty_rt", "cpcty_rt_calc_totar", "main_prpos_code_nm", "etc_prpos", "hshld_co", "funitre_co", "main_bild_co",
						"atach_bild_co", "atach_bild_ar", "floor_parkng_co", "insdhous_mchne_alge", "insdhous_mchne_ar", "outhous_mchne_alge",
						"outhous_mchne_ar", "insdhous_self_alge", "insdhous_self_ar", "outhous_self_alge", "outhous_self_ar", "prmisn_de", "strwrk_de",
						"use_confm_de", "prmisn_no_yy", "prmisn_no_instt_code", "prmisn_no_instt_code_nm", "prmisn_no_se_code", "prmisn_no_se_code_nm",
						"ho_co", "energy_efcny_grad", "energy_redcn_rt", "energy_episcore", "evrfrnd_bild_grad", "evrfrnd_bild_crtfc_score",
						"intlgnt_bild_evlutn", "intlgnt_bild_score", "creat_de", "addr_x", "addr_y", "geom" };
				String[] bdfc_val = {
	    				"manage_bild_regstr", "plot_lc", "rn_plot_lc", "buld_nm", "spcl_nmfpc", "blck", "lot", "dong_nm", "ho_nm", "floor_se_code_nm",
			            "floor_no", "creat_de" };
				String[] bdhd_val = {
	    				"manage_bild_regstr", "plot_lc", "rn_plot_lc", "buld_nm", "spcl_nmfpc", "blck", "lot", "else_lot_co", "plot_ar", "bildng_ar",
						"bdtldr", "totar", "cpcty_rt", "cpcty_rt_calc_totar", "strct_code_nm", "etc_strct", "main_prpos_code_nm", "etc_prpos",
						"rf_code_nm", "etc_rf", "hshld_co", "funitre_co", "hg", "ground_floor_co", "undgrnd_floor_co", "rdng_elvtr_co", "emgnc_elvtr_co",
						"atach_bild_co", "atach_bild_ar", "floor_dong_totar", "insdhous_mchne_alge", "insdhous_mchne_ar", "outhous_mchne_alge",
						"outhous_mchne_ar", "insdhous_self_alge", "insdhous_self_ar", "outhous_self_alge", "outhous_self_ar", "prmisn_de", "strwrk_de",
						"use_confm_de", "prmisn_no_yy", "prmisn_no_instt_code", "prmisn_no_instt_code_nm", "prmisn_no_se_code", "prmisn_no_se_code_nm",
						"ho_co", "energy_efcny_grad", "energy_redcn_rt", "energy_episcore", "evrfrnd_bild_grad", "evrfrnd_bild_crtfc_score",
						"intlgnt_bild_evlutn", "intlgnt_bild_score", "creat_de", "addr_x", "addr_y", "geom" };

				if(target.equals("dboh")){ //총괄표제부
					for( int i=0; i<dboh_val.length; i++ ){
						jObj.put( dboh_val[i], vo.get(dboh_val[i]) );
					}
		    	}else if(target.equals("bdfc")){ //전유부
		    		for( int i=0; i<bdfc_val.length; i++ ){
						jObj.put( bdfc_val[i], vo.get(bdfc_val[i]) );
					}
		    	}else if(target.equals("bdhd")){ //표제부
		    		for( int i=0; i<bdhd_val.length; i++ ){
						jObj.put( bdhd_val[i], vo.get(bdhd_val[i]) );
					}
		    	}

				jArray.add( jObj );
		}
		logger.info( jArray.toString() );
		PrintWriter out = response.getWriter();
		out.println(jArray.toString());
    }

    /** 즐겨찾기 등록     */
    /*@RequestMapping(value="/ajaxDB_save_bookmark.do")
    public void ajaxDB_save_bookmark(HttpServletRequest request,HttpServletResponse response, GisBasicVO bookmarkVO) throws UnsupportedEncodingException, SQLException
    {
    	response.setCharacterEncoding("UTF-8");

     	HttpSession session = getSession();
    	String userS_id = null;
    	if(session != null){
    		userS_id = (String)session.getAttribute("userId");
    	}

		if( userS_id != null ){

			String name = request.getParameter("name");
			bookmarkVO.setBookmark_nm(name);

			bookmarkVO.setUser_id(userS_id);
			gisinfoService.gis_insert_bookmark(bookmarkVO);

			List addlist = gisinfoService.gis_search_bookmark(bookmarkVO);

			JSONArray nm = new JSONArray();
			JSONArray gid = new JSONArray();
			JSONObject obj = new JSONObject();

			HashMap result = ( HashMap )addlist.get(addlist.size()-1);
			nm.add(result.get("bookmark_nm"));
			gid.add(result.get("gid"));
			obj.put("nm", nm);
			obj.put("gid", gid);
			PrintWriter out = response.getWriter();
			out.println(obj.toString());
        }
    }*/

    /** 즐겨찾기 불러오기     */
    /*@RequestMapping(value="/ajaxDB_load_bookmark.do")
    public void ajaxDB_load_bookmark(HttpServletRequest request,HttpServletResponse response, GisBasicVO bookmarkVO) throws UnsupportedEncodingException, SQLException
    {
    	response.setCharacterEncoding("UTF-8");

     	HttpSession session = getSession();
    	String userS_id = null;
    	if(session != null){
    		userS_id = (String)session.getAttribute("userId");
    	}

		if( userS_id != null ){

	    	String gid = request.getParameter("gid");
	    	bookmarkVO.setGid(gid);
	    	bookmarkVO.setUser_id(userS_id);

	    	List list = gisinfoService.gis_search_bookmark(bookmarkVO);

	    	JSONArray jArray = new JSONArray();
			if( list != null && list.size() > 0 ) {
				HashMap vo = ( HashMap )list.get(list.size()-1);
					JSONObject jObj = new JSONObject();
					String[] vo_val = { "kind", "cnt_kind",

							"pnilp_1", "pnilp_2", "jimok", "parea_1", "parea_2", "spfc", "land_use", "geo_hl", "geo_form", "road_side", "prtown", "spcfc", "cnflc_1", "cnflc_2",

							"guk_land", "guk_land_01", "guk_land_02", "guk_land_03", "guk_land_04", "tmseq_land", "tmseq_land_01", "tmseq_land_02", "region_land", "owned_city",
							"owned_city_01", "owned_city_02", "owned_guyu", "owned_guyu_01", "owned_guyu_02", "residual_land", "unsold_land", "invest", "public_site", "public_parking",
							"generations", "council_land", "minuse", "industry", "priority",


							"cp_date_1", "cp_date_2", "bildng_ar_1", "bildng_ar_2", "totar_1", "totar_2", "plot_ar_1", "plot_ar_2", "bdtldr_1", "bdtldr_2", "cpcty_rt_1", "cpcty_rt_2",

							"guk_buld",	"guk_buld_01", "guk_buld_02", "guk_buld_03", "guk_buld_04", "tmseq_buld", "tmseq_buld_01", "tmseq_buld_02", "region_buld", "owned_region",
							"owned_region_01", "owned_region_02", "cynlst", "cynlst_01", "cynlst_02", "public_buld_a", "public_buld_b", "public_buld_c", "public_asbu", "purchase", "declining",


							"soldout", "sector", "spkfc", "fill_gb", "useu", "uses", "sector_nm", "solar_1", "solar_2", "hbdtldr_1", "hbdtldr_2", "hcpcty_rt_1", "hcpcty_rt_2", "hg_limit", "taruse", "soldkind", "soldgb",

							"residual",	"unsold",


							"gb", "gbname", "sig", "emd",


							"sel",
							"space_gb", "space_gb_cd02", "space_gb_cd03",
							"sub_p_decline_gb", "sub_p_decline_val", "sub_p_decline", "public_transport_val", "public_transport",
						};
					for( int i=0; i<vo_val.length; i++ ){
						jObj.put( vo_val[i], vo.get(vo_val[i]) );
					}

					jArray.add( jObj );
			}
			logger.info( jArray.toString() );
			PrintWriter out = response.getWriter();
			out.println(jArray.toString());
		}
    }*/





    /** 즐겨찾기 수정     */
    /*@RequestMapping(value="/ajaxDB_edit_bookmark.do")
    public void ajaxDB_edit_bookmark(HttpServletRequest request,HttpServletResponse response, GisBasicVO bookmarkVO) throws UnsupportedEncodingException, SQLException
    {
    	response.setCharacterEncoding("UTF-8");

        HttpSession session = getSession();
    	String userS_id = null;
    	if(session != null){
    		userS_id = (String)session.getAttribute("userId");
    	}

		if( userS_id != null ){

			String name = request.getParameter("name");
			String bookmark = request.getParameter("gid");
			bookmarkVO.setBookmark_nm(name);
			bookmarkVO.setGid(bookmark);

			bookmarkVO.setUser_id(userS_id);
			gisinfoService.gis_update_bookmark(bookmarkVO);

			List addlist = gisinfoService.gis_search_bookmark(bookmarkVO);

			JSONArray nm = new JSONArray();
			JSONArray gid = new JSONArray();
			JSONObject obj = new JSONObject();

			HashMap result = ( HashMap )addlist.get(addlist.size()-1);
			nm.add(result.get("bookmark_nm"));
			gid.add(result.get("gid"));
			obj.put("nm", nm);
			obj.put("gid", gid);
			PrintWriter out = response.getWriter();
			out.println(obj.toString());
		}
    }*/



    /** 즐겨찾기 삭제     
     * @throws IOException */
    /*@RequestMapping(value="/ajaxDB_delete_bookmark.do")
    public void ajaxDB_delete_bookmark(HttpServletRequest request,HttpServletResponse response, GisBasicVO bookmarkVO) throws UnsupportedEncodingException, SQLException
    {
    	response.setCharacterEncoding("UTF-8");

        HttpSession session = getSession();
    	String userS_id = null;
    	if(session != null){
    		userS_id = (String)session.getAttribute("userId");
    	}

		if( userS_id != null ){

			String bookmark = request.getParameter("gid");
			bookmarkVO.setGid(bookmark);

			bookmarkVO.setUser_id(userS_id);
			gisinfoService.gis_delete_bookmark(bookmarkVO);

			JSONArray suc = new JSONArray();
			JSONObject obj = new JSONObject();
			suc.add("삭제되었습니다.");
			obj.put("emd_cd", suc);
			PrintWriter out = response.getWriter();
			out.println(obj.toString());
		}
    }*/


    @RequestMapping(value="/getGeom.do")
    public void getGeom(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO) throws SQLException, IOException
    {
    	response.setCharacterEncoding("UTF-8");
    	String pnu = request.getParameter("pnu");
    	
    	gisVO.setPnu(pnu);
    	String geom = gisinfoService.search_coordnate(gisVO);
    	
    	JSONObject obj = new JSONObject();
    	obj.put("geom", geom);
    	
    	PrintWriter out = response.getWriter();
		out.println(obj.toString());
    }

    
    /** click정보조회 
     * @throws IOException */
    @RequestMapping(value="/ajaxDB_search_coordnate.do")
    public void postsql_attr(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO) throws SQLException, IOException
    {
    	response.setCharacterEncoding("UTF-8");

		String coord_x = request.getParameter( "coord_x" );
		String coord_y = request.getParameter( "coord_y" );
		String kind = request.getParameter( "layer" );

		gisVO.setCoord_x(coord_x);
		gisVO.setCoord_y(coord_y);

		List land = gisinfoService.search_coordnate_land(gisVO);
		List buld = gisinfoService.search_coordnate_buld(gisVO);

		JSONArray pnu = new JSONArray();
		JSONArray address = new JSONArray();
		JSONArray pnilp = new JSONArray();
		JSONArray parea = new JSONArray();
		JSONArray jimok = new JSONArray();
		JSONArray spfc1 = new JSONArray();
		JSONArray land_use = new JSONArray();
		JSONArray road_side = new JSONArray();
		JSONArray geo_form = new JSONArray();
		JSONArray geo_hl = new JSONArray();
		JSONArray prtown = new JSONArray();
		JSONArray a13 = new JSONArray();
		JSONArray a9 = new JSONArray();
		JSONArray a11 = new JSONArray();
		JSONArray a12 = new JSONArray();
		JSONArray a14 = new JSONArray();
		JSONArray a16 = new JSONArray();
		JSONArray a17 = new JSONArray();
		JSONArray a18 = new JSONArray();
		JSONArray geom_land = new JSONArray();
		JSONArray geom_buld = new JSONArray();

		JSONObject obj = new JSONObject();

		if( land != null && land.size() > 0 ) {
			HashMap result = ( HashMap )land.get(0);
			pnu.add(result.get("pnu"));
			address.add(result.get("adres"));
			pnilp.add(result.get("pnilp"));
			parea.add(result.get("parea"));
			jimok.add(result.get("jimok"));
			spfc1.add(result.get("spfc1"));
			land_use.add(result.get("land_use"));
			road_side.add(result.get("road_side"));
			geo_form.add(result.get("geo_form"));
			geo_hl.add(result.get("geo_hl"));
			prtown.add(result.get("prtown"));
			geom_land.add(result.get("geom"));
		}
		if( buld != null && buld.size() > 0 ) {
			HashMap result = ( HashMap )buld.get(0);
			a13.add(result.get("a13"));
			a9.add(result.get("a9"));
			a11.add(result.get("a11"));
			a12.add(result.get("a12"));
			a14.add(result.get("a14"));
			a16.add(result.get("a16"));
			a17.add(result.get("a17"));
			a18.add(result.get("a18"));
			geom_buld.add(result.get("geom"));
		}

		obj.put("pnu", pnu);
		obj.put("address", address);
		obj.put("pnilp", pnilp);
		obj.put("parea", parea);
		obj.put("jimok", jimok);
		obj.put("spfc1", spfc1);
		obj.put("land_use", land_use);
		obj.put("road_side", road_side);
		obj.put("geo_form", geo_form);
		obj.put("geo_hl", geo_hl);
		obj.put("prtown", prtown);
		obj.put("a13", a13);
		obj.put("a9", a9);
		obj.put("a11", a11);
		obj.put("a12", a12);
		obj.put("a14", a14);
		obj.put("a16", a16);
		obj.put("a17", a17);
		obj.put("a18", a18);
		obj.put("geom_land", geom_land);
		obj.put("geom_buld", geom_buld);

		PrintWriter out = response.getWriter();
		logger.info(obj.toString());
		out.println(obj.toString());
    }



    /** 검색결과 엑셀 다운로드 */
    @RequestMapping(value="/GISSearchList_Excel_Download.do")
    public void GISSearchList_Excel_Download(HttpServletRequest request,HttpServletResponse response, ModelMap model, @ModelAttribute("gisVO") GisBasicVO gisVO) throws Exception
    {
    	request.setCharacterEncoding("UTF-8");
    	response.setCharacterEncoding("UTF-8");

    	String target = request.getParameter("target");
    	String target_nm = "검색결과_";
    	List searchList = null;

    	String sig = request.getParameter("sig");
    	String emd = request.getParameter("emd");
    	if( "0000".equals(sig) ){ gisVO.setSig(null); }
    	if( "0000".equals(emd) ){ gisVO.setEmd(null); }

    	String[] gbRequestList = request.getParameterValues("gb");
    	String kind = request.getParameter("kind");
    	String cnt_kind = request.getParameter("cnt_kind");
    	model.addAttribute("kind", kind);
    	model.addAttribute("cnt_kind", cnt_kind);

    	//공간분석
    	String space_gb = request.getParameter("space_gb");
    	String[] space_gb_cd02 = request.getParameterValues("space_gb_cd02");
    	String[] space_gb_cd03 = request.getParameterValues("space_gb_cd03");
    	if(space_gb != null){
    		ArrayList<String> gbArrayList02 = new ArrayList<String>();
    		if(space_gb.equals("01")){
    			for(int i=0; i<space_gb_cd02.length; i++){
        			String gbKind = space_gb_cd02[i];
        			if(		gbKind.equals("1")){ gbArrayList02.add("근린재생 일반형"); }
        			else if(gbKind.equals("2")){ gbArrayList02.add("근린재생 중심시가지형"); }
        			else if(gbKind.equals("3")){ gbArrayList02.add("도시경제기반형"); }
        	    }
    			String[] array = gbArrayList02.toArray(new String[gbArrayList02.size()]);
    			gisVO.setCity_activation_val(array);
    			gisVO.setCity_activation(space_gb_cd03);
    			model.addAttribute("city_activation_02", space_gb_cd02);
    			model.addAttribute("city_activation_03", space_gb_cd03);
    		}else if(space_gb.equals("02")){
    			for(int i=0; i<space_gb_cd02.length; i++){
        			String gbKind = space_gb_cd02[i];
        			if(		gbKind.equals("1")){ gbArrayList02.add("계획수립"); }
        			else if(gbKind.equals("2")){ gbArrayList02.add("설계/공사"); }
        			else if(gbKind.equals("3")){ gbArrayList02.add("완료"); }
        			else if(gbKind.equals("4")){ gbArrayList02.add("후보지"); }
        	    }
    			String[] array = gbArrayList02.toArray(new String[gbArrayList02.size()]);
    			gisVO.setHouse_envment_val(array);
    			gisVO.setHouse_envment(space_gb_cd03);
    			model.addAttribute("house_envment_02", space_gb_cd02);
    			model.addAttribute("house_envment_03", space_gb_cd03);
    		}else if(space_gb.equals("03")){
    			for(int i=0; i<space_gb_cd02.length; i++){
        			String gbKind = space_gb_cd02[i];
        			if(		gbKind.equals("1")){ gbArrayList02.add("도시재생활성화사업"); }
        			else if(gbKind.equals("2")){ gbArrayList02.add("주거환경관리사업"); }
        	    }
    			String[] array = gbArrayList02.toArray(new String[gbArrayList02.size()]);
    			gisVO.setHope_land_val(array);
    			gisVO.setHope_land(space_gb_cd03);
    			model.addAttribute("hope_land_02", space_gb_cd02);
    			model.addAttribute("hope_land_03", space_gb_cd03);
    		}else if(space_gb.equals("04")){
    			for(int i=0; i<space_gb_cd02.length; i++){
        			String gbKind = space_gb_cd02[i];
        			if(		gbKind.equals("1")){ gbArrayList02.add("도시환경(뉴타운)"); }
        			else if(gbKind.equals("2")){ gbArrayList02.add("재개발"); }
        			else if(gbKind.equals("3")){ gbArrayList02.add("재개발(뉴타운)"); }
        			else if(gbKind.equals("4")){ gbArrayList02.add("재건축"); }
        			else if(gbKind.equals("5")){ gbArrayList02.add("재건축(공동)"); }
        			else if(gbKind.equals("6")){ gbArrayList02.add("재건축(뉴타운)"); }
        	    }
    			String[] array = gbArrayList02.toArray(new String[gbArrayList02.size()]);
    			gisVO.setRelease_area_val(array);
    			gisVO.setRelease_area(space_gb_cd03);
    			model.addAttribute("release_area_02", space_gb_cd02);
    			model.addAttribute("release_area_03", space_gb_cd03);
    		}
    	}
    	String sub_p_decline_gb = request.getParameter("sub_p_decline_gb");
    	String[] sub_p_decline_val = request.getParameterValues("sub_p_decline_val");
    	String[] sub_p_decline = request.getParameterValues("sub_p_decline");
    	if(sub_p_decline_gb != null){
			gisVO.setSub_p_decline_val(sub_p_decline_val);
			gisVO.setSub_p_decline(sub_p_decline);
			model.addAttribute("sub_p_decline_02", sub_p_decline_val);
    		model.addAttribute("sub_p_decline_03", sub_p_decline);
    	}
    	String public_transport_val = request.getParameter("public_transport_val");
    	String[] public_transport = request.getParameterValues("public_transport");
    	if(public_transport_val != null){
    		if(		public_transport_val.equals("01")){ gisVO.setPublic_transport_val("1호선"); }
			else if(public_transport_val.equals("02")){ gisVO.setPublic_transport_val("2호선"); }
			else if(public_transport_val.equals("03")){ gisVO.setPublic_transport_val("3호선"); }
			else if(public_transport_val.equals("04")){ gisVO.setPublic_transport_val("4호선"); }
			else if(public_transport_val.equals("05")){ gisVO.setPublic_transport_val("5호선"); }
			else if(public_transport_val.equals("06")){ gisVO.setPublic_transport_val("6호선"); }
			else if(public_transport_val.equals("07")){ gisVO.setPublic_transport_val("7호선"); }
			else if(public_transport_val.equals("08")){ gisVO.setPublic_transport_val("8호선"); }
			else if(public_transport_val.equals("09")){ gisVO.setPublic_transport_val("9호선"); }
			else if(public_transport_val.equals("10")){ gisVO.setPublic_transport_val("경의중앙선"); }
			else if(public_transport_val.equals("11")){ gisVO.setPublic_transport_val("분당선"); }
			else if(public_transport_val.equals("12")){ gisVO.setPublic_transport_val("신분당선"); }
    		gisVO.setPublic_transport(public_transport);
    		model.addAttribute("public_transport_02", public_transport_val);
    		model.addAttribute("public_transport_03", public_transport);
    	}



    	if(kind.equals("tab-01")){
    		//기본검색
    		if( gbRequestList != null ){
    			ArrayList<String> prtown = new ArrayList<String>();
    			for(int i=0; i<gbRequestList.length; i++){
        			String gbKind = gbRequestList[i];
        			if(		gbKind.equals("00")){ prtown.add("00"); }
        			else if(gbKind.equals("01")){ prtown.add("01"); }
        			else if(gbKind.equals("02")){ prtown.add("02"); }
        			else if(gbKind.equals("03")){ prtown.add("03"); }
        			else if(gbKind.equals("04")){ prtown.add("04"); }
        			else if(gbKind.equals("05")){ prtown.add("05"); }
        			else if(gbKind.equals("06")){ prtown.add("06"); }
        			else if(gbKind.equals("07")){ prtown.add("07"); }
        			else if(gbKind.equals("08")){ prtown.add("08"); }
        			else if(gbKind.equals("09")){ prtown.add("09"); }
        	    }
    			String[] array = prtown.toArray(new String[prtown.size()]);
        		gisVO.setGb(array);

        		if(target.equals("gb")){
        			searchList = gisinfoService.gis_search_land_list(gisVO);
        			target_nm = target_nm + "기본검색";
        		}

    		}


    		//자산검색
    		if( request.getParameter("guk_land") != null ){				//국유지일반재산(캠코)토지
    			ArrayList<String> guk_land = new ArrayList<String>();
    			if( request.getParameter("guk_land_01") != null ){ guk_land.add("대부대상"); }
    			if( request.getParameter("guk_land_02") != null ){ guk_land.add("매각대상"); }
    			if( request.getParameter("guk_land_03") != null ){ guk_land.add("매각제한재산"); }
    			if( request.getParameter("guk_land_04") != null ){ guk_land.add("사용중인재산"); }
    			String[] guk_land_array = guk_land.toArray(new String[guk_land.size()]);
        		gisVO.setGuk_land_value(guk_land_array);

        		if(target.equals("guk_land")){
        			searchList = gisinfoService.gis_search_land_list_guk_land(gisVO);
        			target_nm = target_nm + "국유지일반재산(캠코)토지";
        		}
    		}
    		if( request.getParameter("tmseq_land") != null ){			//위탁관리 시유지
    			ArrayList<String> tmseq_land = new ArrayList<String>();
    			if( request.getParameter("tmseq_land_01") != null ){ tmseq_land.add("관리대상"); }
    			if( request.getParameter("tmseq_land_02") != null ){ tmseq_land.add("관리제외"); }
    			String[] tmseq_land_array = tmseq_land.toArray(new String[tmseq_land.size()]);
        		gisVO.setTmseq_land_value(tmseq_land_array);

        		if(target.equals("tmseq_land")){
        			searchList = gisinfoService.gis_search_land_list_tmseq_land(gisVO);
        			target_nm = target_nm + "위탁관리시유지";
        		}
    		}
    		if( request.getParameter("region_land") != null ){			//자치구위임관리 시유지

        		if(target.equals("region_land")){
        			searchList = gisinfoService.gis_search_land_list_region_land(gisVO);
        			target_nm = target_nm + "자치구위임관리시유지";
        		}
    		}
    		if( request.getParameter("owned_city") != null ){			//자치구 보유관리토지(시유지)
    			ArrayList<String> owned_city = new ArrayList<String>();
    			if( request.getParameter("owned_city_01") != null ){ owned_city.add("일반재산"); }
    			if( request.getParameter("owned_city_02") != null ){ owned_city.add("행정재산"); }
    			String[] owned_city_array = owned_city.toArray(new String[owned_city.size()]);
        		gisVO.setOwned_city_value(owned_city_array);

        		if(target.equals("owned_city")){
        			searchList = gisinfoService.gis_search_land_list_owned_city(gisVO);
        			target_nm = target_nm + "자치구보유관리토지(시유지)";
        		}
    		}
    		if( request.getParameter("owned_guyu") != null ){			//자치구 보유관리토지(구유지)
    			ArrayList<String> owned_guyu = new ArrayList<String>();
    			if( request.getParameter("owned_guyu_01") != null ){ owned_guyu.add("일반재산"); }
    			if( request.getParameter("owned_guyu_02") != null ){ owned_guyu.add("행정재산"); }
    			String[] owned_guyu_array = owned_guyu.toArray(new String[owned_guyu.size()]);
        		gisVO.setOwned_guyu_value(owned_guyu_array);

        		if(target.equals("owned_guyu")){
        			searchList = gisinfoService.gis_search_land_list_owned_guyu(gisVO);
        			target_nm = target_nm + "자치구보유관리토지(구유지)";
        		}
    		}
    		if( request.getParameter("residual_land") != null ){			//SH잔여지

        		if(target.equals("residual_land")){
        			searchList = gisinfoService.gis_search_land_list_residual_land(gisVO);
        			target_nm = target_nm + "SH잔여지";
        		}
    		}
			if( request.getParameter("unsold_land") != null ){			//SH미매각지

        		if(target.equals("unsold_land")){
        			searchList = gisinfoService.gis_search_land_list_unsold_land(gisVO);
        			target_nm = target_nm + "SH미매각지";
        		}
			}
			if( request.getParameter("invest") != null ){			//SH현물출자

        		if(target.equals("invest")){
        			searchList = gisinfoService.gis_search_land_list_invest(gisVO);
        			target_nm = target_nm + "SH현물출자";
        		}
			}
			if( request.getParameter("public_site") != null ){			//공공기관 이전부지

        		if(target.equals("public_site")){
        			searchList = gisinfoService.gis_search_land_list_public_site(gisVO);
        			target_nm = target_nm + "공공기관이전부지";
        		}
			}
			if( request.getParameter("public_parking") != null ){			//공영주차장

        		if(target.equals("public_parking")){
        			searchList = gisinfoService.gis_search_land_list_public_parking(gisVO);
        			target_nm = target_nm + "공영주차장";
        		}
			}
			if( request.getParameter("generations") != null ){			//역세권사업 후보지
				ArrayList<String> generations = new ArrayList<String>();
    			if( request.getParameter("generations_01") != null ){ generations.add("완료"); }
    			if( request.getParameter("generations_02") != null ){ generations.add("진행"); }
    			if( request.getParameter("generations_03") != null ){ generations.add("준비"); }
    			String[] generations_array = generations.toArray(new String[generations.size()]);
        		gisVO.setGenerations_value(generations_array);

        		if(target.equals("generations")){
        			searchList = gisinfoService.gis_search_land_list_generations(gisVO);
        			target_nm = target_nm + "역세권사업후보지";
        		}
			}
			if( request.getParameter("council_land") != null ){			//임대주택 단지

        		if(target.equals("council_land")){
        			searchList = gisinfoService.gis_search_land_list_council_land(gisVO);
        			target_nm = target_nm + "임대주택단지";
        		}
			}
			if( request.getParameter("minuse") != null ){			//저이용공공시설

        		if(target.equals("minuse")){
        			searchList = gisinfoService.gis_search_land_list_minuse(gisVO);
        			target_nm = target_nm + "저이용공공시설";
        		}
			}
			if( request.getParameter("industry") != null ){			//공공부지 혼재지역

        		if(target.equals("industry")){
        			searchList = gisinfoService.gis_search_land_list_industry(gisVO);
        			target_nm = target_nm + "공공부지혼재지역";
        		}
			}
			if( request.getParameter("priority") != null ){			//중점활용 시유지

        		if(target.equals("priority")){
        			searchList = gisinfoService.gis_search_land_list_priority(gisVO);
        			target_nm = target_nm + "중점활용시유지";
        		}
			}

    	}else if(kind.equals("tab-02")){
    		//기본검색
    		if( gbRequestList != null ){
    			ArrayList<String> prpos= new ArrayList<String>();
        		for(int i=0; i<gbRequestList.length; i++){
        			String gbKind = gbRequestList[i];
        			if(		gbKind.equals("01000")){ prpos.add("01000"); } //단독주택
        			else if(gbKind.equals("02000")){ prpos.add("02000"); } //공동주택
        			else if(gbKind.equals("03000")){ prpos.add("03000"); } //제1종근린생활시설
        			else if(gbKind.equals("04000")){ prpos.add("04000"); } //제2종근린생활시설
        			else if(gbKind.equals("05000")){ prpos.add("05000"); } //문화및집회시설
        			else if(gbKind.equals("06000")){ prpos.add("06000"); } //종교시설
        			else if(gbKind.equals("07000")){ prpos.add("07000"); } //판매시설
        			else if(gbKind.equals("08000")){ prpos.add("08000"); } //운수시설
        			else if(gbKind.equals("09000")){ prpos.add("09000"); } //의료시설
        			else if(gbKind.equals("10000")){ prpos.add("10000"); } //교육연구시설
        			else if(gbKind.equals("11000")){ prpos.add("11000"); } //노유자시설
        			else if(gbKind.equals("12000")){ prpos.add("12000"); } //수련시설
        			else if(gbKind.equals("13000")){ prpos.add("13000"); } //운동시설
        			else if(gbKind.equals("14000")){ prpos.add("14000"); } //업무시설
        			else if(gbKind.equals("15000")){ prpos.add("15000"); } //숙박시설
        			else if(gbKind.equals("16000")){ prpos.add("16000"); } //위락시설
        			else if(gbKind.equals("17000")){ prpos.add("17000"); } //공장
        			else if(gbKind.equals("18000")){ prpos.add("18000"); } //창고시설
        			else if(gbKind.equals("19000")){ prpos.add("19000"); } //위험물저장및처리시설
        			else if(gbKind.equals("20000")){ prpos.add("20000"); } //자동차관련시설
        			else if(gbKind.equals("21000")){ prpos.add("21000"); } //동.식물관련시설
        			else if(gbKind.equals("22000")){ prpos.add("22000"); } //분뇨.쓰레기처리시설
        			else if(gbKind.equals("23000")){ prpos.add("23000"); } //교정및군사시설
        			else if(gbKind.equals("24000")){ prpos.add("24000"); } //방송통신시설
        			else if(gbKind.equals("25000")){ prpos.add("25000"); } //발전시설
        			else if(gbKind.equals("26000")){ prpos.add("26000"); } //묘지관련시설
        			else if(gbKind.equals("27000")){ prpos.add("27000"); } //관광휴게시설
        			else if(gbKind.equals("29000")){ prpos.add("29000"); } //장례시설
        			else if(gbKind.equals("30000")){ prpos.add("30000"); } //자원순환관련시설
        			else if(gbKind.equals("Z0000")){ prpos.add("Z3000"); prpos.add("Z5000"); prpos.add("Z6000"); prpos.add("Z8000"); prpos.add("Z9000"); } //기타
        	    }
        		String[] array = prpos.toArray(new String[prpos.size()]);
        		gisVO.setGb(array);
        		String gbnm = request.getParameter("gbname");
        		logger.info(gbnm);
        		gisVO.setGbname(gbnm);

        		if(target.equals("gb")){
        			searchList = gisinfoService.gis_search_buld_list(gisVO);
        			target_nm = target_nm + "기본검색";
        		}
    		}



    		//자산검색
    		if( request.getParameter("guk_buld") != null ){				//국유지일반재산(캠코)건물
    			ArrayList<String> guk_buld = new ArrayList<String>();
    			if( request.getParameter("guk_buld_01") != null ){ guk_buld.add("대부대상"); }
    			if( request.getParameter("guk_buld_02") != null ){ guk_buld.add("매각대상"); }
    			if( request.getParameter("guk_buld_03") != null ){ guk_buld.add("매각제한재산"); }
    			if( request.getParameter("guk_buld_04") != null ){ guk_buld.add("사용중인재산"); }
    			String[] guk_buld_array = guk_buld.toArray(new String[guk_buld.size()]);
        		gisVO.setGuk_buld_value(guk_buld_array);

        		if(target.equals("guk_buld")){
        			searchList = gisinfoService.gis_search_buld_list_guk_buld(gisVO);
        			target_nm = target_nm + "국유지일반재산(캠코)건물";
        		}
    		}
    		if( request.getParameter("tmseq_buld") != null ){			//위탁관리 건물

        		if(target.equals("tmseq_buld")){
        			searchList = gisinfoService.gis_search_buld_list_tmseq_buld(gisVO);
        			target_nm = target_nm + "위탁관리건물";
        		}
    		}
    		if( request.getParameter("region_buld") != null ){			//자치구위임관리 건물

        		if(target.equals("region_buld")){
        			searchList = gisinfoService.gis_search_buld_list_region_buld(gisVO);
        			target_nm = target_nm + "자치구위임관리건물";
        		}
    		}
    		if( request.getParameter("owned_region") != null ){			//자치구 보유관리건물(자치구)
    			ArrayList<String> owned_region = new ArrayList<String>();
    			if( request.getParameter("owned_region_01") != null ){ owned_region.add("일반재산"); }
    			if( request.getParameter("owned_region_02") != null ){ owned_region.add("행정재산"); }
    			String[] owned_region_array = owned_region.toArray(new String[owned_region.size()]);
        		gisVO.setOwned_region_value(owned_region_array);

        		if(target.equals("owned_region")){
        			searchList = gisinfoService.gis_search_buld_list_owned_region(gisVO);
        			target_nm = target_nm + "자치구보유관리건물(자치구)";
        		}
    		}
    		if( request.getParameter("owned_seoul") != null ){			//자치구 보유관리건물(서울시)

        		if(target.equals("owned_seoul")){
        			searchList = gisinfoService.gis_search_buld_list_owned_seoul(gisVO);
        			target_nm = target_nm + "자치구보유관리건물(서울시)";
        		}
    		}
    		if( request.getParameter("cynlst") != null ){			//재난위험시설
    			ArrayList<String> cynlst = new ArrayList<String>();
    			if( request.getParameter("cynlst_01") != null ){ cynlst.add("D"); }
    			if( request.getParameter("cynlst_02") != null ){ cynlst.add("E"); }
    			String[] cynlst_array = cynlst.toArray(new String[cynlst.size()]);
        		gisVO.setCynlst_value(cynlst_array);

        		if(target.equals("cynlst")){
        			searchList = gisinfoService.gis_search_buld_list_cynlst(gisVO);
        			target_nm = target_nm + "재난위험시설";
        		}
    		}
			if( request.getParameter("public_buld_a") != null ){			//공공건축물(국공립)

        		if(target.equals("public_buld_a")){
        			searchList = gisinfoService.gis_search_buld_list_public_buld_a(gisVO);
        			target_nm = target_nm + "공공건축물(국공립)";
        		}
			}
			if( request.getParameter("public_buld_b") != null ){			//공공건축물(서울시)

        		if(target.equals("public_buld_b")){
        			searchList = gisinfoService.gis_search_buld_list_public_buld_b(gisVO);
        			target_nm = target_nm + "공공건축물(서울시)";
        		}
			}
			if( request.getParameter("public_buld_c") != null ){			//공공건축물(자치구)

        		if(target.equals("public_buld_c")){
        			searchList = gisinfoService.gis_search_buld_list_public_buld_c(gisVO);
        			target_nm = target_nm + "공공건축물(자치구)";
        		}
			}
			if( request.getParameter("public_asbu") != null ){			//공공기관 이전건물

        		if(target.equals("public_asbu")){
        			searchList = gisinfoService.gis_search_buld_list_public_asbu(gisVO);
        			target_nm = target_nm + "공공기관이전건물";
        		}
			}
			if( request.getParameter("purchase") != null ){			//매입임대

        		if(target.equals("purchase")){
        			searchList = gisinfoService.gis_search_buld_list_purchase(gisVO);
        			target_nm = target_nm + "매입임대";
        		}
			}
			if( request.getParameter("declining") != null ){			//노후매입임대

        		if(target.equals("declining")){
        			searchList = gisinfoService.gis_search_buld_list_declining(gisVO);
        			target_nm = target_nm + "노후매입임대";
        		}
			}

    	}else if(kind.equals("tab-03")){
    		gisVO.setKind(null);
    		//기본검색
    		if( gbRequestList != null ){
    			ArrayList<String> district = new ArrayList<String>();
    			for(int i=0; i<gbRequestList.length; i++){
        			String gbKind = gbRequestList[i];
        			if(		gbKind.equals("01")){ district.add("우면2"); }
        			else if(gbKind.equals("02")){ district.add("발산"); }
        			else if(gbKind.equals("03")){ district.add("신정3"); }
        			else if(gbKind.equals("04")){ district.add("장지"); }
        			else if(gbKind.equals("05")){ district.add("강일2"); }
        			else if(gbKind.equals("06")){ district.add("강일"); }
        			else if(gbKind.equals("07")){ district.add("문정"); }
        			else if(gbKind.equals("08")){ district.add("상계 장암"); }
        			else if(gbKind.equals("09")){ district.add("내곡"); }
        			else if(gbKind.equals("10")){ district.add("마천"); }
        			else if(gbKind.equals("11")){ district.add("세곡"); }
        			else if(gbKind.equals("12")){ district.add("세곡2"); }
        			else if(gbKind.equals("13")){ district.add("신내2"); }
        			else if(gbKind.equals("14")){ district.add("신내3"); }
        			else if(gbKind.equals("15")){ district.add("신정4"); }
        			else if(gbKind.equals("16")){ district.add("천왕2"); }
        			else if(gbKind.equals("17")){ district.add("항동"); }
        			else if(gbKind.equals("18")){ district.add("위례"); }
        			else if(gbKind.equals("19")){ district.add("은평"); }
        			else if(gbKind.equals("20")){ district.add("천왕"); }
        			else if(gbKind.equals("21")){ district.add("상암2"); }
        			else if(gbKind.equals("22")){ district.add("마곡"); gisVO.setKind("99"); }
        			else if(gbKind.equals("23")){ district.add("오금"); }
        			else if(gbKind.equals("24")){ district.add("개포 구룡마을"); }
        			else if(gbKind.equals("25")){ district.add("고덕강일"); }
        			else if(gbKind.equals("26")){ district.add("장월"); }
        	    }
    			String[] array = district.toArray(new String[district.size()]);
    			gisVO.setGb(array);


    			//Table에 한글값 적용부분
    			//판매구분
        		String[] soldoutList = request.getParameterValues("soldout");
        		if(soldoutList!=null){
        			ArrayList<String> soldout = new ArrayList<String>();
            		for(int i=0; i<soldoutList.length; i++){
            			String soldoutKind = soldoutList[i];
            			if(		soldoutKind.equals("01")){ soldout.add("판매대상"); }
            			else if(soldoutKind.equals("02")){ soldout.add("자체사용"); }
            			else if(soldoutKind.equals("03")){ soldout.add("무상공급"); }
            	    }
            		String[] array_soldout = soldout.toArray(new String[soldout.size()]);
            		gisVO.setSoldout(array_soldout);
        		}
        		//지구
        		String[] sectorList = request.getParameterValues("sector");
        		if(sectorList!=null){
        			ArrayList<String> sector = new ArrayList<String>();
            		for(int i=0; i<sectorList.length; i++){
            			String sectorKind = sectorList[i];
            			if(		sectorKind.equals("01")){ sector.add("1지구"); sector.add("2지구"); sector.add("3지구"); }
            			else if(sectorKind.equals("02")){ sector.add("1지구"); }
            			else if(sectorKind.equals("03")){ sector.add("2지구"); }
            			else if(sectorKind.equals("03")){ sector.add("3지구"); }
            	    }
            		String[] array_sector = sector.toArray(new String[sector.size()]);
            		gisVO.setSector(array_sector);
        		}
        		//용도지역
        		String[] spkfcList = request.getParameterValues("spkfc");
        		if(spkfcList!=null){
        			ArrayList<String> spkfc = new ArrayList<String>();
            		for(int i=0; i<spkfcList.length; i++){
            			String spkfcKind = spkfcList[i];
            			if(		spkfcKind.equals("01")){ spkfc.add("제1종일반주거지역"); }
            			else if(spkfcKind.equals("02")){ spkfc.add("제3종일반주거지역"); }
            			else if(spkfcKind.equals("03")){ spkfc.add("준주거지역"); }
            			else if(spkfcKind.equals("04")){ spkfc.add("준공업지역"); }
            			else if(spkfcKind.equals("05")){ spkfc.add("일반상업지역"); }
            			else if(spkfcKind.equals("06")){ spkfc.add("제2종일반주거지역"); }
            			else if(spkfcKind.equals("07")){ spkfc.add("자연녹지지역"); }
            	    }
            		String[] array_spkfc = spkfc.toArray(new String[spkfc.size()]);
            		gisVO.setSpkfc(array_spkfc);
        		}
        		//단지구분
        		String[] fill_gbList = request.getParameterValues("fill_gb");
        		if(fill_gbList!=null){
        			ArrayList<String> fill_gb = new ArrayList<String>();
            		for(int i=0; i<fill_gbList.length; i++){
            			String fill_gbKind = fill_gbList[i];
            			if(		fill_gbKind.equals("01")){ fill_gb.add("비산업단지"); }
            			else if(fill_gbKind.equals("02")){ fill_gb.add("산업단지"); }
            	    }
            		String[] array_fill_gb = fill_gb.toArray(new String[fill_gb.size()]);
            		gisVO.setFill_gb(array_fill_gb);
        		}
        		//용도
        		String[] useuList = request.getParameterValues("useu");
        		if(useuList!=null){
        			ArrayList<String> useu = new ArrayList<String>();
            		for(int i=0; i<useuList.length; i++){
            			String useuKind = useuList[i];
            			if(		useuKind.equals("01")){ useu.add("주거시설용지"); }
            			else if(useuKind.equals("02")){ useu.add("산업시설용지"); }
            			else if(useuKind.equals("03")){ useu.add("지원시설용지"); }
            			else if(useuKind.equals("04")){ useu.add("상업용지"); }
            			else if(useuKind.equals("05")){ useu.add("업무용지"); }
            			else if(useuKind.equals("06")){ useu.add("기반시설용지"); }
            			else if(useuKind.equals("07")){ useu.add("기타시설용지"); }
            	    }
            		String[] array_useu = useu.toArray(new String[useu.size()]);
            		gisVO.setUseu(array_useu);
        		}
        		//세부용도
        		String[] usesList = request.getParameterValues("uses");
        		if(usesList!=null){
        			ArrayList<String> uses = new ArrayList<String>();
            		for(int i=0; i<usesList.length; i++){
            			String usesKind = usesList[i];
            			if(		usesKind.equals("01")){ uses.add("단독주택용지"); }
            			else if(usesKind.equals("02")){ uses.add("공동주택용지"); }
            			else if(usesKind.equals("03")){ uses.add("산업시설용지"); }
            			else if(usesKind.equals("04")){ uses.add("지원시설용지"); }
            			else if(usesKind.equals("05")){ uses.add("상업용지"); }
            			else if(usesKind.equals("06")){ uses.add("업무용지"); }
            			else if(usesKind.equals("07")){ uses.add("종합의료시설용지"); }
            			else if(usesKind.equals("08")){ uses.add("공공청사용지"); }
            			else if(usesKind.equals("09")){ uses.add("학교용지"); }
            			else if(usesKind.equals("10")){ uses.add("사회복지시설"); }
            			else if(usesKind.equals("11")){ uses.add("주차장용지"); }
            			else if(usesKind.equals("12")){ uses.add("열공급설비"); }
            			else if(usesKind.equals("13")){ uses.add("전기공급설비"); }
            			else if(usesKind.equals("14")){ uses.add("보육시설용지"); }
            			else if(usesKind.equals("15")){ uses.add("방수설비용지"); }
            			else if(usesKind.equals("16")){ uses.add("도로"); }
            			else if(usesKind.equals("17")){ uses.add("보행자도로"); }
            			else if(usesKind.equals("18")){ uses.add("철도용지"); }
            			else if(usesKind.equals("19")){ uses.add("광장"); }
            			else if(usesKind.equals("20")){ uses.add("근린공원"); }
            			else if(usesKind.equals("21")){ uses.add("어린이공원"); }
            			else if(usesKind.equals("22")){ uses.add("문화공원"); }
            			else if(usesKind.equals("23")){ uses.add("경관녹지"); }
            			else if(usesKind.equals("24")){ uses.add("연결녹지"); }
            			else if(usesKind.equals("25")){ uses.add("유수지"); }
            			else if(usesKind.equals("26")){ uses.add("종교용지"); }
            			else if(usesKind.equals("27")){ uses.add("주유소용지"); }
            			else if(usesKind.equals("28")){ uses.add("가스충전소용지"); }
            			else if(usesKind.equals("29")){ uses.add("편익시설용지"); }
            			else if(usesKind.equals("30")){ uses.add("택시차고지"); }
            	    }
            		String[] array_uses = uses.toArray(new String[uses.size()]);
            		gisVO.setUses(array_uses);
        		}
        		//판매여부
        		String[] soldgbList = request.getParameterValues("soldgb");
        		if(soldgbList!=null){
        			ArrayList<String> soldgb = new ArrayList<String>();
            		for(int i=0; i<soldgbList.length; i++){
            			String soldgbKind = soldgbList[i];
            			if(		soldgbKind.equals("01")){ soldgb.add("미"); }
            			else if(soldgbKind.equals("02")){ soldgb.add("판매"); }
            	    }
            		String[] array_soldgb = soldgb.toArray(new String[soldgb.size()]);
            		gisVO.setSoldgb(array_soldgb);
        		}


        		if(target.equals("gb")){
        			searchList = gisinfoService.gis_search_dist_list(gisVO);
        			target_nm = target_nm + "기본검색";
        		}
    		}


    		//자산검색
    		if( request.getParameter("residual") != null ){				//잔여지

        		if(target.equals("residual")){
        			searchList = gisinfoService.gis_search_dist_list_residual(gisVO);
        			target_nm = target_nm + "잔여지";
        		}
    		}
    		if( request.getParameter("unsold") != null ){			//미매각지

        		if(target.equals("unsold")){
        			searchList = gisinfoService.gis_search_dist_list_unsold(gisVO);
        			target_nm = target_nm + "미매각지";
        		}
    		}


    	}




		if( searchList != null && searchList.size() > 0 ) {

			SimpleDateFormat formatter = new SimpleDateFormat ( "yyyyMMddHHmmss", Locale.KOREA );
			Date currentTime = new Date();
			String dTime = formatter.format ( currentTime );

			String fileName = dTime+"_"+"down.xls";
			String fullPathName = Globals.FILE_STORE_PATH + "\\" + fileName;

			// 엑셀파일 생성
			File file = new File( fullPathName );
			WritableWorkbook workbook = Workbook.createWorkbook(file);

			// 셀 포맷 정의
			WritableCellFormat h_format = new WritableCellFormat();
			h_format.setAlignment( Alignment.CENTRE );
			h_format.setVerticalAlignment( VerticalAlignment.CENTRE );
			h_format.setFont( new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE, Colour.BLACK, ScriptStyle.NORMAL_SCRIPT ) );

			WritableCellFormat c_format = new WritableCellFormat();
			c_format.setAlignment( Alignment.CENTRE );
			c_format.setVerticalAlignment( VerticalAlignment.CENTRE );
			c_format.setFont( new WritableFont(WritableFont.ARIAL, 10, WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE, Colour.BLACK, ScriptStyle.NORMAL_SCRIPT ) );

			/* ---------------------------------------------------------------------------------- */
			WritableSheet sheet1 = workbook.createSheet( "검색결과", 0 );

			// 제목셀 정의
			sheet1.addCell( new Label(0,0, "연번", h_format) );

			String[] land_col = {"소재지", "자산구분", "지목", "대지면적(㎡)", "개별공시지가(원)", "용도지역", "토지이용상황", "지형고저", "지형형상", "도로접면", "소유구분"};
			String[] buld_col = {"소재지", "자산구분", "건물명", "건축면적(㎡)", "연면적(㎡)", "대지면적(㎡)", "건폐율(%)", "용적률(%)", "건축년도"};
			String[] dist_col = {"판매구분", "지구", "용도지역", "단지구분", "용도", "세부용도", "필지번호", "고시면적", "건폐율", "용적률", "높이제한", "지정용도", "판매방법", "판매여부"};
			if(kind.equals("tab-01")){
				for( int i=0; i<land_col.length; i++ ) {
					sheet1.addCell( new Label(1+i,0, land_col[i], h_format) );
				}
			}else if(kind.equals("tab-02")){
				for( int i=0; i<buld_col.length; i++ ) {
					sheet1.addCell( new Label(1+i,0, buld_col[i], h_format) );
				}
			}else if(kind.equals("tab-03")){
				for( int i=0; i<dist_col.length; i++ ) {
					sheet1.addCell( new Label(1+i,0, dist_col[i], h_format) );
				}
			}


			// 셀너비 지정
			for( int i=0; i<20; i++ ) {
				sheet1.setColumnView( i, 15 );
			}

			// 내용 정의
			for( int i=0; i<searchList.size(); i++ ) {
				HashMap result = ( HashMap )searchList.get(i);

				String[] land_rowss = {"addr1", "gb", "jimok", "parea", "pnilp", "spfc1", "land_use", "geo_hl", "geo_form", "road_side", "prtown"};
				String[] buld_rowss = {"addr1", "gb", "buld_nm", "bildng_ar", "totar", "plot_ar", "bdtldr", "cpcty_rt", "use_confm"};
				String[] dist_rowss = {"a2", "a3", "a4", "a5", "a6", "a7", "a8", "a11", "a13", "a12", "a14", "a15", "a19", "a20"};

				sheet1.addCell( new Label(0, 1+i, (1+i)+"", c_format) );
				if(kind.equals("tab-01")){
					for( int r=0; r<land_rowss.length; r++ ){
						String colnm = land_rowss[r];
						if(result.get(colnm) != null){
							if(colnm.equals("addr1")){ sheet1.addCell( new Label(1+r, 1+i, result.get(colnm)+" "+result.get("addr2"), c_format) ); }
							else{ sheet1.addCell( new Label(1+r, 1+i, result.get(colnm)+"", c_format) ); }
						}
					}
				}else if(kind.equals("tab-02")){
					for( int r=0; r<buld_rowss.length; r++ ){
						String colnm = buld_rowss[r];
						if(result.get(colnm) != null){
							if(colnm.equals("addr1")){ sheet1.addCell( new Label(1+r, 1+i, result.get(colnm)+" "+result.get("addr2"), c_format) ); }
							else{ sheet1.addCell( new Label(1+r, 1+i, result.get(colnm)+"", c_format) ); }
						}
					}
				}else if(kind.equals("tab-03")){
					for( int r=0; r<dist_rowss.length; r++ ){
						String colnm = dist_rowss[r];
						if(result.get(colnm) != null){
							sheet1.addCell( new Label(1+r, 1+i, result.get(colnm)+"", c_format) );
						}
					}
				}



			}

			workbook.write();
			workbook.close();

			FileUtil futil = new FileUtil();
			futil.downFile3(response, fullPathName, fileName);
			boolean r = file.delete();
			logger.info("::::::::::: r :::::: " +  r);
		}
    }













    /**
	 * 파일 다운로드
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("/ajax_factual_fileDownload.do")
	public void ajax_factual_fileDownload(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		String year = request.getParameter("year");
		String pnu = request.getParameter("pnu");
		String ty = request.getParameter("ty");

		String fileName = null;
  		String outputfilepath = null;
		if( "tmseq_land".equals(ty) ){
			fileName = "SH위탁관리"+year+"_"+pnu+".hwp";
	  		outputfilepath = Globals.TMSEQ_LAND_FILE_PATH + "\\" + year;
		}else if( "declining".equals(ty) ){
			fileName = "SH노후매입임대"+"_"+pnu+".hwp";
	  		outputfilepath = Globals.DECLINING_FILE_PATH + "\\" + year;
		}

  		logger.info("fileName ::: " + fileName);
  		logger.info("outputfilepath ::: " + outputfilepath);

  		File uFile = new File(outputfilepath,fileName);
		int fSize = (int)uFile.length();

		if (fSize > 0) {
			outputfilepath = outputfilepath + "\\" + fileName;
			fileName = java.net.URLEncoder.encode(fileName, "UTF-8");
			FileUtil futil = new FileUtil();
			futil.downFile3(response, outputfilepath, fileName);
		}else{
			response.setContentType("text/html; charset=utf-8");

			PrintWriter printwriter = response.getWriter();
			printwriter.println("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">");
			printwriter.println("<html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"ko\" xml:lang=\"ko\">");
			printwriter.println("<title>첨부파일없습니다.</title>");
			printwriter.println("<head>");
			printwriter.println("	<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />");
			printwriter.println("<script type=\"text/javascript\">");
			printwriter.println("alert('첨부파일이 없습니다.');");
			printwriter.println("history.back(-1);");
			printwriter.println("</script>");
			printwriter.println("</head>");
			printwriter.println("</html>");
			printwriter.flush();
			printwriter.close();
		}

	}


	// 노후 체크
    @RequestMapping(value="/GIS_Hwp_Check.do")
    public ModelAndView GIS_Hwp_Check(HttpServletRequest request,HttpServletResponse response, @ModelAttribute("gisVO") GisBasicVO gisVO, ModelMap model) throws Exception
    {
    	ModelAndView modelAndView = new ModelAndView();
    	modelAndView.setViewName("jsonView");

    	String pnu = request.getParameter("pnu");

		// 현장조사카드 여부 확인
		String inputFileName = "SH노후매입임대_" + pnu + ".hwp";
		String inputFilePath = Globals.HWP_FILE_PATH + Globals.CONTEXT_MARK + inputFileName;	//버에 템플릿 파일경로 입력
		File f = new File(inputFilePath);
		if(f.exists()) {
	    	modelAndView.addObject("result", "Y");
			return modelAndView.addObject("cardName", inputFileName);
		} else {
			modelAndView.addObject("result", "N");
			modelAndView.addObject("cardName", "");
		}

		return modelAndView;
    }

	// 노후 다운로드
    @RequestMapping(value="/GIS_Hwp_Download.do")
    public void GIS_Hwp_Download(HttpServletRequest request,HttpServletResponse response, @ModelAttribute("gisVO") GisBasicVO gisVO) throws Exception
    {
    	response.setCharacterEncoding("UTF-8");
    	request.setCharacterEncoding("UTF-8");

    	String pnu = request.getParameter("pnu");
    	logger.info("pnu::::::::::"+pnu);

    	String inputFileName = "SH노후매입임대_" + pnu + ".hwp";
    	//inputFileName = new String(inputFileName.getBytes("UTF-8"), "8859_1");
    	//inputFileName = java.net.URLEncoder.encode(inputFileName, "UTF-8");
    	String inputFilePath = Globals.HWP_FILE_PATH + Globals.CONTEXT_MARK + inputFileName;	//버에 템플릿 파일경로 입력
    	File f = new File(inputFilePath);
    	if(f.exists()) {
    		FileUtil futil = new FileUtil();
    		inputFileName = URLEncoder.encode(inputFileName,"UTF-8");
			futil.downFile3(response, inputFilePath, inputFileName);
    	} else {

    	}
    }

	// 동북4구 체크
    @RequestMapping(value="/GIS_Pdf_Check.do")
    public ModelAndView GIS_Pdf_Check(HttpServletRequest request,HttpServletResponse response, @ModelAttribute("gisVO") GisBasicVO gisVO, ModelMap model) throws Exception
    {
    	ModelAndView modelAndView = new ModelAndView();
    	modelAndView.setViewName("jsonView");

    	String pnu = request.getParameter("pnu");

		// 현장조사카드 여부 확인
    	String inputFileName = pnu + ".pdf";
		String inputFilePath = Globals.PDF_FILE_PATH + Globals.CONTEXT_MARK + inputFileName;	//버에 템플릿 파일경로 입력
		File f = new File(inputFilePath);
		if(f.exists()) {
	    	modelAndView.addObject("result", "Y");
			return modelAndView.addObject("cardName", inputFileName);
		} else {
			modelAndView.addObject("result", "N");
			modelAndView.addObject("cardName", "");
		}

		return modelAndView;
    }

	// 동북4구 다운로드
    @RequestMapping(value="/GIS_Pdf_Download.do")
    public void GIS_Pdf_Download(HttpServletRequest request,HttpServletResponse response, @ModelAttribute("gisVO") GisBasicVO gisVO) throws Exception
    {
    	response.setCharacterEncoding("UTF-8");
    	request.setCharacterEncoding("UTF-8");

    	String pnu = request.getParameter("pnu");
    	logger.info("pnu::::::::::"+pnu);

    	String inputFileName = pnu + ".pdf";
    	//inputFileName = new String(inputFileName.getBytes("UTF-8"), "8859_1");
    	//inputFileName = java.net.URLEncoder.encode(inputFileName, "UTF-8");
    	String inputFilePath = Globals.PDF_FILE_PATH + Globals.CONTEXT_MARK + inputFileName;	//버에 템플릿 파일경로 입력
    	File f = new File(inputFilePath);
    	if(f.exists()) {
    		FileUtil futil = new FileUtil();
    		inputFileName = URLEncoder.encode(inputFileName,"UTF-8");
			futil.downFile3(response, inputFilePath, inputFileName);
    	} else {

    	}
    }

    // 워드 다운로드
    @RequestMapping(value="/GIS_Word_Download.do")
    public void GIS_Word_Download(HttpServletRequest request,HttpServletResponse response, @ModelAttribute("gisVO") GisBasicVO gisVO) throws Exception
    {
    	response.setCharacterEncoding("UTF-8");
    	request.setCharacterEncoding("UTF-8");

    	String pnu = request.getParameter("pnu");
    	logger.info("pnu::::::::::"+pnu);
    	gisVO.setPnu(pnu);


    	//토지정보
    	List land_list = land_list = gisinfoService.gis_data_word1(gisVO);

		//건물정보
		List buld_list_1 = gisinfoService.gis_buld_detail_1(gisVO);	//sn_dboh - 총괄표제부
		List buld_list_3 = gisinfoService.gis_buld_detail_3(gisVO);	//sn_bdhd - 표제부

		//자산정보
		String sh_kind = request.getParameter("sh_kind");
		logger.info("sh_kind::::::::::"+sh_kind);
    	gisVO.setKind(sh_kind);

    	String sh_name = "";	//자산정보
		if(		"guk_land".equals(sh_kind)			){ sh_name = "국유지일반재산(캠코)토지";  }
		else if("tmseq_land".equals(sh_kind)		){ sh_name = "위탁관리시유지";  }
		else if("region_land".equals(sh_kind)		){ sh_name = "자치구위임관리시유지";  }
		else if("owned_city".equals(sh_kind)		){ sh_name = "자치구보유관리토지(시유지)"; }
		else if("owned_guyu".equals(sh_kind)		){ sh_name = "자치구보유관리토지(구유지)";  }
		else if("residual_land".equals(sh_kind)		){ sh_name = "SH잔여지";  }
		else if("unsold_land".equals(sh_kind)		){ sh_name = "SH미매각지"; }
		else if("invest".equals(sh_kind)			){ sh_name = "SH현물출자";  }
		else if("public_site".equals(sh_kind)		){ sh_name = "공공기관이전부지";  }
		else if("public_parking".equals(sh_kind)	){ sh_name = "공영주차장"; }
		else if("generations".equals(sh_kind)		){ sh_name = "역세권사업후보지";  }
		else if("council_land".equals(sh_kind)		){ sh_name = "임대주택단지"; }
		else if("minuse".equals(sh_kind)			){ sh_name = "저이용공공시설";  }
		else if("industry".equals(sh_kind)			){ sh_name = "공공부지혼재지역"; }
		else if("priority".equals(sh_kind)			){ sh_name = "중점활용시유지";  }

		else if("guk_buld".equals(sh_kind)			){ sh_name = "국유지일반재산(캠코)건물";  }
		else if("tmseq_buld".equals(sh_kind)		){ sh_name = "위탁관리건물"; }
		else if("region_buld".equals(sh_kind)		){ sh_name = "자치구위임관리건물"; }
		else if("owned_region".equals(sh_kind)		){ sh_name = "자치구보유관리건물(자치구)";  }
		else if("owned_seoul".equals(sh_kind)		){ sh_name = "자치구보유관리건물(서울시)";  }
		else if("cynlst".equals(sh_kind)			){ sh_name = "재난위험시설"; }
		else if("public_buld_a".equals(sh_kind)		){ sh_name = "공공건축물(국공립)";  }
		else if("public_buld_b".equals(sh_kind)		){ sh_name = "공공건축물(서울시)"; }
		else if("public_buld_c".equals(sh_kind)		){ sh_name = "공공건축물(자치구)";  }
		else if("public_asbu".equals(sh_kind)		){ sh_name = "공공기관이전건물";  }
		else if("purchase".equals(sh_kind)			){ sh_name = "매입임대";  }
		else if("declining".equals(sh_kind)			){ sh_name = "노후매입임대"; }

		//관련사업정보




		SimpleDateFormat formatter = new SimpleDateFormat ( "yyyyMMddHHmmss", Locale.KOREA );
		Date currentTime = new Date();
		String dTime = formatter.format ( currentTime );

   		ObjectFactory foo = Context.getWmlObjectFactory();
   		HashMap<String, String> mappings = null;
   		boolean save = true;

   		if( land_list != null ) {
   			HashMap result1 = ( HashMap )land_list.get(0);

	   		String inputfilepath = Globals.FACTUAL_FILE_PATH + Globals.CONTEXT_MARK + "basic.docx";	//버에 템플릿 파일경로 입력

	   		String fileName = result1.get("a3")+" "+result1.get("a4")+".docx";
	   		fileName = fileName.replaceAll(" ", "_");
	   		fileName = java.net.URLEncoder.encode(fileName, "UTF-8");
	  		String outputfilepath = Globals.FILE_STORE_PATH + "\\" + fileName;	//서버에 생성할 파일경로 입력

			File pFile = new File(inputfilepath);
			WordprocessingMLPackage wordMLPackage = WordprocessingMLPackage.load(pFile);
			MainDocumentPart documentPart = wordMLPackage.getMainDocumentPart();

			VariablePrepare.prepare(wordMLPackage);

			// 템플릿에 입력되어 있는 KEY와 실제값을 매핑
			// ${KEY}
			//템플릿에 입력할 실제 데이터 조회하여 mappings에 VALUE 입력
			mappings = getMappings();


			mappings.put("now", dTime.substring(0,8)+"");
			logger.info("result.get(pnu):::::::::::::"+result1.get("pnu"));

			if(result1.get("pnu") != null) mappings.put("pnu", result1.get("pnu")+"");
			if(result1.get("a3") != null) mappings.put("addr_jibun", result1.get("a3")+" "+result1.get("a4"));
			if(result1.get("stdmt") != null) mappings.put("land_now", result1.get("stdmt")+"");

			if(result1.get("jimok") != null) mappings.put("land_01", result1.get("jimok")+"");
			if(result1.get("parea") != null) mappings.put("land_02", result1.get("parea")+" m²");
			if(result1.get("land_use") != null) mappings.put("land_04", result1.get("land_use")+"");
			if(result1.get("pnilp") != null) mappings.put("land_05", result1.get("pnilp")+"");
			if(result1.get("road_side") != null) mappings.put("land_12", result1.get("road_side")+"");
			if(result1.get("geo_hl") != null) mappings.put("land_06", result1.get("geo_hl")+"");
			if(result1.get("geo_form") != null) mappings.put("land_08", result1.get("geo_form")+"");
			if(result1.get("spfc1") != null) mappings.put("land_07", result1.get("spfc1")+"");
			if(result1.get("spfc2") != null) mappings.put("land_09", result1.get("spfc2")+"");
			if(result1.get("stdmt") != null) mappings.put("land_14", result1.get("stdmt")+"");

			if(result1.get("a11") != null) mappings.put("land_03", result1.get("a11")+"");
//			if(result.get("land_10") != null) mappings.put("land_10", result.get("prprty_mg")+"");
//			if(result.get("land_13") != null) mappings.put("land_13", result.get("prprty_mg")+"");

			if(result1.get("a20") != null) mappings.put("land_11", result1.get("a20")+"");


	       if( buld_list_1.size() > 0 ) {
	    	   HashMap result2 = ( HashMap )buld_list_1.get(0);
	    	   if(result2.get("rn_plot_lc") != null) mappings.put("addr_road", result2.get("rn_plot_lc")+"");
	    	   if(result2.get("creat_de") != null) mappings.put("buld_now", result2.get("creat_de")+"");

	    	   if(result2.get("buld_nm") != null) mappings.put("buld_01", result2.get("buld_nm")+"");
	    	   if(result2.get("plot_ar") != null) mappings.put("buld_08", result2.get("plot_ar")+" m²");
	    	   if(result2.get("bildng_ar") != null) mappings.put("buld_04", result2.get("bildng_ar")+" m²");
	    	   if(result2.get("bdtldr") != null) mappings.put("buld_10", result2.get("bdtldr")+" %");
	    	   if(result2.get("totar") != null) mappings.put("buld_06", result2.get("totar")+" m²");
	    	   if(result2.get("cpcty_rt") != null) mappings.put("buld_12", result2.get("cpcty_rt")+" %");
	    	   if(result2.get("cpcty_rt_calc_totar") != null) mappings.put("buld_14", result2.get("cpcty_rt_calc_totar")+" m²");
	    	   if(result2.get("main_prpos_code_nm") != null) mappings.put("buld_03", result2.get("main_prpos_code_nm")+"");
	    	   if(result2.get("hshld_co") != null) mappings.put("buld_15", result2.get("hshld_co")+"");
	    	   if(result2.get("funitre_co") != null) mappings.put("buld_13", result2.get("funitre_co")+"");

	    	   if(result2.get("use_confm_de") != null) mappings.put("buld_16", result2.get("use_confm_de")+"");
	    	   if(result2.get("ho_co") != null) mappings.put("buld_11", result2.get("ho_co")+"");
	       }else if( buld_list_3.size() > 0 ){
	    	   HashMap result2 = ( HashMap )buld_list_3.get(0);
	    	   if(result2.get("rn_plot_lc") != null) mappings.put("addr_road", result2.get("rn_plot_lc")+"");
	    	   if(result2.get("creat_de") != null) mappings.put("buld_now", result2.get("creat_de")+"");

	    	   if(result2.get("buld_nm") != null) mappings.put("buld_01", result2.get("buld_nm")+"");
	    	   if(result2.get("plot_ar") != null) mappings.put("buld_08", result2.get("plot_ar")+" m²");
	    	   if(result2.get("bildng_ar") != null) mappings.put("buld_04", result2.get("bildng_ar")+" m²");
	    	   if(result2.get("bdtldr") != null) mappings.put("buld_10", result2.get("bdtldr")+" %");
	    	   if(result2.get("totar") != null) mappings.put("buld_06", result2.get("totar")+"");
	    	   if(result2.get("cpcty_rt") != null) mappings.put("buld_12", result2.get("cpcty_rt")+" %");
	    	   if(result2.get("cpcty_rt_calc_totar") != null) mappings.put("buld_14", result2.get("cpcty_rt_calc_totar")+" m²");
	    	   if(result2.get("main_prpos_code_nm") != null) mappings.put("buld_03", result2.get("main_prpos_code_nm")+"");
	    	   if(result2.get("hshld_co") != null) mappings.put("buld_15", result2.get("hshld_co")+"");
	    	   if(result2.get("funitre_co") != null) mappings.put("buld_13", result2.get("funitre_co")+"");
	    	   if(result2.get("hg") != null) mappings.put("buld_09", result2.get("hg")+"");
	    	   if(result2.get("ground_floor_co") != null) mappings.put("buld_05", result2.get("ground_floor_co")+"");
	    	   if(result2.get("undgrnd_floor_co") != null) mappings.put("buld_07", result2.get("undgrnd_floor_co")+"");
	    	   if(result2.get("use_confm_de") != null) mappings.put("buld_16", result2.get("use_confm_de")+"");
	    	   if(result2.get("ho_co") != null) mappings.put("buld_11", result2.get("ho_co")+"");
	       }

	       if(sh_name != ""){
	    	   mappings.put("dist_now", "2017");
	    	   mappings.put("datalist", sh_name+"");
	       }



			long start = System.currentTimeMillis();

			// 이미지 넣기 - mappings 내용보다 먼저 입력되어야함
			// 해당하는 KEY 위치에 이미지 넣기
			//실제 이미지 경로 입력하기
			String image_01 = request.getParameter("imgSrc");

			if(image_01 == null) {
        		logger.info("imgSrcs is null, read IO Stream");
        		InputStream inputStream = request.getInputStream();
        		image_01 = URLDecoder.decode(IOUtils.toString(inputStream).split("=")[1], "utf-8");
                //logger.info("reqData : " + imgSrc);
        	}

        	// 경로
        	String strDir = Globals.FACTUAL_FILE_PATH;
        	String imgName01 = "img01.png";

        	//이미지 생성
        	byte[] imagedata = DatatypeConverter.parseBase64Binary(image_01.substring(image_01.indexOf(",") + 1));
        	BufferedImage bufferedImage = ImageIO.read(new ByteArrayInputStream(imagedata));
        	ImageIO.write(bufferedImage, "png", new File(strDir + "\\" + imgName01));

        	//불러오기
        	image_01 = strDir + Globals.CONTEXT_MARK + imgName01;




		   insertImage(wordMLPackage, documentPart, "v_map", image_01);
//		   insertImage(wordMLPackage, documentPart, "img2", image_02);


			// 매핑 내용 입력하기
			documentPart.variableReplace(mappings);
			// documentPart.addParagraphOfText("성공적인 테스트3");

			long end = System.currentTimeMillis();
			long total = end - start;
			logger.info("Time: " + total);

			// Save it
			if (save) {
			    SaveToZipFile saver = new SaveToZipFile(wordMLPackage);
			    saver.save(outputfilepath);
			} else {
			    logger.info(XmlUtils.marshaltoString(documentPart.getJaxbElement(), true,
			            true));
			}

			FileUtil futil = new FileUtil();
			futil.downFile3(response, outputfilepath, fileName);
//			(new File(Globals.FILE_STORE_PATH,fileName)).delete();
   		}

    }
    public HashMap<String, String> getMappings(){
   	 HashMap<String, String> mappings = new HashMap<String, String>(); // 초기화

	        mappings.put("pnu", " ");
	        mappings.put("now", " ");
	        mappings.put("addr_jibun", " ");
	        mappings.put("addr_road", " ");

	        mappings.put("land_now", " ");
	        mappings.put("land_01", " ");
	        mappings.put("land_02", " ");
	        mappings.put("land_03", " ");
	        mappings.put("land_04", " ");
	        mappings.put("land_05", " ");
	        mappings.put("land_06", " ");
	        mappings.put("land_07", " ");
	        mappings.put("land_08", " ");
	        mappings.put("land_09", " ");
	        mappings.put("land_10", " ");
	        mappings.put("land_11", " ");
	        mappings.put("land_12", " ");
	        mappings.put("land_13", " ");
	        mappings.put("land_14", " ");

	        mappings.put("buld_now", " ");
	        mappings.put("buld_01", " ");
	        mappings.put("buld_02", " ");
	        mappings.put("buld_03", " ");
	        mappings.put("buld_04", " ");
	        mappings.put("buld_05", " ");
	        mappings.put("buld_06", " ");
	        mappings.put("buld_07", " ");
	        mappings.put("buld_08", " ");
	        mappings.put("buld_09", " ");
	        mappings.put("buld_10", " ");
	        mappings.put("buld_11", " ");
	        mappings.put("buld_12", " ");
	        mappings.put("buld_13", " ");
	        mappings.put("buld_14", " ");
	        mappings.put("buld_15", " ");
	        mappings.put("buld_16", " ");

	        mappings.put("dist_now", " ");
	        mappings.put("datalist", " ");
	        mappings.put("spacelist", " ");

	        mappings.put("v_map", " ");
	        mappings.put("d_map", " ");

	        return mappings;
    }
    public void insertImage(WordprocessingMLPackage wordMLPackage, MainDocumentPart docPart, String place, String img_path){
   		try{
   			org.docx4j.wml.ObjectFactory foo = Context.getWmlObjectFactory();

   			java.io.File pFile_img1 = new java.io.File(img_path);
   	        java.io.InputStream is = new java.io.FileInputStream(pFile_img1);

   	        long length = pFile_img1.length();
   	        // You cannot create an array using a long type.
   	        // It needs to be an int type.
   	        if (length > Integer.MAX_VALUE) {
   	        	logger.info("File too large!!");
   	        }
   	        byte[] bytes = new byte[(int)length];
   	        int offset = 0;
   	        int numRead = 0;
   	        while (offset < bytes.length
   	               && (numRead=is.read(bytes, offset, bytes.length-offset)) >= 0) {
   	            offset += numRead;
   	        }
   	        // Ensure all the bytes have been read in
   	        if (offset < bytes.length) {
   	        	logger.info("Could not completely read file "+pFile_img1.getName());
   	        }
   	        is.close();

   	        String filenameHint = null;
   	        String altText = null;
   	        int id1 = 0;
   	        int id2 = 1;
   	        int width = 5000;
   	        boolean searched = false;

   	        // 위치찾기
   	        List elemetns = getAllElementFromObject(wordMLPackage.getMainDocumentPart(), Tbl.class);
   	        for(Object obj : elemetns){
   	        	   if(obj instanceof Tbl){
   	        	      Tbl table = (Tbl) obj;
   	        	         List rows = getAllElementFromObject(table, Tr.class);
   	        	            for(Object trObj : rows){
   	        	         Tr tr = (Tr) trObj;
   	        	         List cols = getAllElementFromObject(tr, Tc.class);
   	        	         for(Object tcObj : cols){
   	        	            Tc tc = (Tc) tcObj;
   	        	            List texts = getAllElementFromObject(tc, Text.class);
   	        	            for(Object textObj : texts){
   	        	              Text text = (Text) textObj;
   	        	                     if(text.getValue().equalsIgnoreCase("${" + place + "}")){
   	        	                        tc.getContent().clear();

   	        	        				width = tc.getTcPr().getTcW().getW().intValue(); // 셀 가로 사이즈
   	        	        				width = width - 100;

   	        	        			     // Image 1: no width specified
   	        	        		        org.docx4j.wml.P p = newImage( wordMLPackage, bytes,
   	        	        		        		filenameHint, altText,
   	        	        		    			id1, id2, width );

   	        	        		        setHorizontalAlignment(p, JcEnumeration.CENTER);

   	        	                        tc.getContent().add(p);

   	        	                        searched = true;
   	        	                        logger.info(place + " here");
   	        	              }
   	        	                  }
   	        	           // logger.info("here");
   	        	         }
   	        	           }
   	        	        // logger.info("here");
   	        	    }
   	        	}
   	        if(!searched){
   	        	logger.info(place + " is not here");
   	        }

   		}catch(Exception ex){
   			logger.info("insertImage Exception: "+ex.getMessage());
   		}
   	}
   	private void setHorizontalAlignment(P paragraph, JcEnumeration hAlign){
   		if(hAlign != null){
   			PPr pprop = new PPr();
   			Jc align = new Jc();
   			align.setVal(hAlign);
   			pprop.setJc(align);
   	        paragraph.setPPr(pprop);
   		}
   	}
   	private static List getAllElementFromObject(Object obj, Class toSearch) {
   		   List result = new ArrayList();
   		   if (obj instanceof JAXBElement)
   		       obj = ((JAXBElement) obj).getValue();

   		   if (obj.getClass().equals(toSearch)){
   		         result.add(obj);
   		   }
   		   else if (obj instanceof ContentAccessor) {
   		         List children = ((ContentAccessor) obj).getContent();
   		         for (Object child : children) {
   		         result.addAll(getAllElementFromObject(child, toSearch));
   		         }

   		   }
   		   return result;
   		}
   	/**
   	 * Create image, without specifying width
   	 */
   	public static org.docx4j.wml.P newImage( WordprocessingMLPackage wordMLPackage,
   			byte[] bytes,
   			String filenameHint, String altText,
   			int id1, int id2) throws Exception {

           BinaryPartAbstractImage imagePart = BinaryPartAbstractImage.createImagePart(wordMLPackage, bytes);

           Inline inline = imagePart.createImageInline( filenameHint, altText,
       			id1, id2, false);

           // Now add the inline in w:p/w:r/w:drawing
   		org.docx4j.wml.ObjectFactory factory = Context.getWmlObjectFactory();
   		org.docx4j.wml.P  p = factory.createP();
   		org.docx4j.wml.R  run = factory.createR();
   		p.getContent().add(run);
   		org.docx4j.wml.Drawing drawing = factory.createDrawing();
   		run.getContent().add(drawing);
   		drawing.getAnchorOrInline().add(inline);

   		return p;

   	}
   	/**
   	 * Create image, specifying width in twips
   	 */
   	public static org.docx4j.wml.P newImage( WordprocessingMLPackage wordMLPackage,
   			byte[] bytes,
   			String filenameHint, String altText,
   			int id1, int id2, long cx) throws Exception {

           BinaryPartAbstractImage imagePart = BinaryPartAbstractImage.createImagePart(wordMLPackage, bytes);

           Inline inline = imagePart.createImageInline( filenameHint, altText,
       			id1, id2, cx, false);

           // Now add the inline in w:p/w:r/w:drawing
   		org.docx4j.wml.ObjectFactory factory = Context.getWmlObjectFactory();
   		org.docx4j.wml.P  p = factory.createP();
   		org.docx4j.wml.R  run = factory.createR();
   		p.getContent().add(run);
   		org.docx4j.wml.Drawing drawing = factory.createDrawing();
   		run.getContent().add(drawing);
   		drawing.getAnchorOrInline().add(inline);

   		return p;

   	}

































    /* 자산정보 등록 - 팝업창  */
    @RequestMapping(value="/Content_SH_Add_Detail.do")
    public String Content_SH_Add_Detail(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO, ModelMap model) throws Exception
    {
    	response.setCharacterEncoding("UTF-8");
    	request.setCharacterEncoding("UTF-8");
    	String mode = request.getParameter("mode");
    	model.addAttribute("mode", mode);
    	String pnu = request.getParameter("pnu");
    	model.addAttribute("pnu", pnu);

		String sh_kind = request.getParameter("sh_kind");
		model.addAttribute("sh_kind", sh_kind);
		String sh_replace = sh_kind.replace("data_", "");
		gisVO.setKind(sh_replace);

//    	List sh_list_comment = gisinfoService.gis_sh_detail_comment(gisVO);	//자산정보 컬럼리스트
//		model.addAttribute("sh_list_comment", sh_list_comment);
		if(!"preAdd".equals(mode)){
			List sigData = gisinfoService.sig_list(gisVO);
			model.addAttribute("sigData", sigData);
		}

    	return "/SH_/landmanager/Content_SH_Add_Detail_popup";
    }

    /* 자산정보 등록*/
    @RequestMapping(value="/Content_SH_Add.do")
    public String Content_SH_Add(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO, ModelMap model) throws Exception
    {
    	String kind = gisVO.getSh_kind();
    	gisVO.setDmlcn("insert");
    	if("data_guk_land".equals(kind)) // 국유 일반재산(캠코)
    	{
    		gisinfoService.gis_insert_guk_land(gisVO);
    		gisinfoService.gis_insert_guk_land_hist(gisVO);
    	}else if("data_city_activation".equals(kind))    // 도시재생활정화지역
    	{
    		gisinfoService.gis_city_activation(gisVO);
    		gisinfoService.gis_city_activation_hist(gisVO);
		}else if("data_council_land".equals(kind))       // 임대주택일반관리현황
		{
			gisinfoService.gis_council_land(gisVO);
			gisinfoService.gis_council_land_hist(gisVO);
		}else if("data_cynlst".equals(kind))             // 재난위험건축물
		{
			gisinfoService.gis_insert_cynlst(gisVO);
			gisinfoService.gis_insert_cynlst_hist(gisVO);
		}else if("data_declining".equals(kind))			 // 노후매입임대
		{
			gisinfoService.gis_insert_declining(gisVO);
			gisinfoService.gis_insert_declining_hist(gisVO);
		}else if("data_generations".equals(kind))        // 역세권사업 후보지
		{
			gisinfoService.gis_insert_generations(gisVO);
			gisinfoService.gis_insert_generations_hist(gisVO);
		}else if("data_hope_land".equals(kind))          // 희망지
		{
			gisinfoService.gis_insert_hope_land(gisVO);
			gisinfoService.gis_insert_hope_land_hist(gisVO);
		}else if("data_house_envment".equals(kind))      // 주거환경관리사업
		{
			gisinfoService.gis_insert_house_envment(gisVO);
			gisinfoService.gis_insert_house_envment_hist(gisVO);
		}else if("data_industry".equals(kind))           // 공공부지 혼재지역
		{
			gisinfoService.gis_insert_industry(gisVO);
			gisinfoService.gis_insert_industry_hist(gisVO);
		}else if("data_minuse".equals(kind))             // 저이용 공공시설
		{
			gisinfoService.gis_insert_minuse(gisVO);
			gisinfoService.gis_insert_minuse_hist(gisVO);
		}else if("data_owned_city".equals(kind))         // 자치구 보유관리토지(시유지)
		{
			gisinfoService.gis_insert_owned_city(gisVO);
			gisinfoService.gis_insert_owned_city_hist(gisVO);
		}else if("data_owned_consult".equals(kind))      // 자치구 홈페이지 (현황참고)
		{
			gisinfoService.gis_insert_owned_consult(gisVO);
			gisinfoService.gis_insert_owned_consult_hist(gisVO);
		}else if("data_owned_guyu".equals(kind))         // 자치구 구유지
		{
			gisinfoService.gis_insert_owned_guyu(gisVO);
			gisinfoService.gis_insert_owned_guyu_hist(gisVO);
		}else if("data_priority".equals(kind))           // 중점활용 시유지
		{
			gisinfoService.gis_insert_priority(gisVO);
			gisinfoService.gis_insert_priority_hist(gisVO);
		}else if("data_public_buld_c".equals(kind))      // 공공건축물
		{
			gisinfoService.gis_insert_buld_c(gisVO);
			gisinfoService.gis_insert_buld_c_hist(gisVO);
		}else if("data_public_parking".equals(kind))     // 공영주차장전체
		{
			gisinfoService.gis_insert_parking(gisVO);
			gisinfoService.gis_insert_parking_hist(gisVO);
		}else if("data_public_site".equals(kind))        // 공공기관 이전부지
		{
			gisinfoService.gis_insert_public_site(gisVO);
			gisinfoService.gis_insert_public_site_hist(gisVO);
		}else if("data_public_transport".equals(kind))   // 대중교통역세권
		{
			gisinfoService.gis_insert_transport(gisVO);
			gisinfoService.gis_insert_transport_hist(gisVO);
		}else if("data_purchase".equals(kind))           // 매입임대
		{
			gisinfoService.gis_insert_purchase(gisVO);
			gisinfoService.gis_insert_purchase_hist(gisVO);
		}else if("data_region_land".equals(kind)) 		 // 자치구위임관리 시유지
		{
			gisinfoService.gis_insert_region_land(gisVO);
			gisinfoService.gis_insert_region_land_hist(gisVO);
		}else if("data_release_area".equals(kind))       // 해제구역
		{
			gisinfoService.gis_insert_release_area(gisVO);
			gisinfoService.gis_insert_release_area_hist(gisVO);
		}else if("data_tmseq_land".equals(kind))         // 위탁관리 시유지
		{
			gisinfoService.gis_insert_tmseq_land(gisVO);
			gisinfoService.gis_insert_tmseq_land_hist(gisVO);
		}


    	return "/SH_/landmanager/Content_SH_Add_Detail_popup";
    }

    /* 자산정보 삭제*/
    @RequestMapping(value="/Content_SH_Del.do")
    public String Content_SH_Del(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO, ModelMap model) throws Exception
    {
    	String kind = gisVO.getSh_kind();

    	GisBasicVO delHistVO = null;

    	if("data_guk_land".equals(kind))
    	{
    		delHistVO = gisinfoService.selectShData(gisVO);
    		gisinfoService.gis_delete_guk_land(gisVO);
    		delHistVO.setDmlcn("delete");
    		gisinfoService.gis_insert_guk_land_hist(delHistVO);
    	}

    	return "/SH_/landmanager/Content_SH_View_Detail";
    }

    /* 자산정보 이력보기*/
    @RequestMapping(value = "/Content_SH_Hist_View.do")
    public String getCctvFcltsHistory(HttpServletRequest request,HttpServletResponse response, GisBasicVO gisVO, ModelMap model) throws Exception
    {
    	String gid = request.getParameter("gid");
    	String sh_kind = request.getParameter("sh_kind");
    	String kindHistPage = "";

    	gisVO.setGid(gid);
    	gisVO.setSh_kind(sh_kind);
    	model.addAttribute("sh_kind", sh_kind);

        List histShData =  gisinfoService.selectSHhist(gisVO);
        model.addAttribute("histShData", histShData);

        if("data_guk_land".equals(sh_kind)) // 국유 일반재산(캠코)
    	{
        	kindHistPage = "/SH/landhist/Content_Guk_Land_Hist";
    	}else if("data_city_activation".equals(sh_kind))    // 도시재생활정화지역
    	{
    		kindHistPage = "/SH/landhist/Content_City_Activation_Hist";
		}else if("data_council_land".equals(sh_kind))       // 임대주택일반관리현황
		{
			kindHistPage = "/SH/landhist/Content_Council_Land_Hist";
		}else if("data_cynlst".equals(sh_kind))             // 재난위험건축물
		{
			kindHistPage = "/SH/landhist/Content_Cynlst_Hist";
		}else if("data_declining".equals(sh_kind))			 // 노후매입임대
		{
			kindHistPage = "/SH/landhist/Content_Declining_Hist";
		}else if("data_generations".equals(sh_kind))        // 역세권사업 후보지
		{
			kindHistPage = "/SH/landhist/Content_Generations_Hist";
		}else if("data_hope_land".equals(sh_kind))          // 희망지
		{
			kindHistPage = "/SH/landhist/Content_Hope_Land_Hist";
		}else if("data_house_envment".equals(sh_kind))      // 주거환경관리사업
		{
			kindHistPage = "/SH/landhist/Content_House_Envment_Hist";
		}else if("data_industry".equals(sh_kind))           // 공공부지 혼재지역
		{
			kindHistPage = "/SH/landhist/Content_Industry_Hist";
		}else if("data_minuse".equals(sh_kind))             // 저이용 공공시설
		{
			kindHistPage = "/SH/landhist/Content_Minuse_Hist";
		}else if("data_owned_city".equals(sh_kind))         // 자치구 보유관리토지(시유지)
		{
			kindHistPage = "/SH/landhist/Content_Owned_City_Hist";
		}else if("data_owned_consult".equals(sh_kind))      // 자치구 홈페이지 (현황참고)
		{
			kindHistPage = "/SH/landhist/Content_Owned_Consult_Hist";
		}else if("data_owned_guyu".equals(sh_kind))         // 자치구 구유지
		{
			kindHistPage = "/SH/landhist/Content_Owned_Guyu_Hist";
		}else if("data_priority".equals(sh_kind))           // 중점활용 시유지
		{
			kindHistPage = "/SH/landhist/Content_Priority_Hist";
		}else if("data_public_buld_c".equals(sh_kind))      // 공공건축물
		{
			kindHistPage = "/SH/landhist/Content_Public_Buld_C_Hist";
		}else if("data_public_parking".equals(sh_kind))     // 공영주차장전체
		{
			kindHistPage = "/SH/landhist/Content_Public_Parking_Hist";
		}else if("data_public_site".equals(sh_kind))        // 공공기관 이전부지
		{
			kindHistPage = "/SH/landhist/Content_Public_Site_Hist";
		}else if("data_public_transport".equals(sh_kind))   // 대중교통역세권
		{
			kindHistPage = "/SH/landhist/Content_Public_Transport_Hist";
		}else if("data_purchase".equals(sh_kind))           // 매입임대
		{
			kindHistPage = "/SH/landhist/Content_Purchase_Hist";
		}else if("data_region_land".equals(sh_kind))		// 자치구위임관리 시유지
		{
			kindHistPage = "/SH/landhist/Content_Region_Land_Hist";
		}else if("data_release_area".equals(sh_kind))       // 해제구역
		{
			kindHistPage = "/SH/landhist/Content_Release_Area_Hist";
		}else if("data_tmseq_land".equals(sh_kind))         // 위탁관리 시유지
		{
			kindHistPage = "/SH/landhist/Content_Tmseq_Land_Hist";
		}

        return kindHistPage;
    }

    /**
     *
     * pnu체크
     * @param vo
     * @return
     */
    @RequestMapping(value = "/confirmPnu.do")
    public ModelAndView selectUserId(GisBasicVO gisVO)
    {

        String rCheck ="false";
        /*if(checkId == 0){
            rCheck = "true";
        }*/
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("result", rCheck);
        modelAndView.setViewName("jsonView");
        return modelAndView;
    }






}