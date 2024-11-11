package egovframework.syesd.cmmn.proxy.web;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.ServletInputStream;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.syesd.cmmn.util.EgovProperties;
import egovframework.zaol.common.web.BaseController;

@Controller
public class ProxyController extends BaseController {

	private static Logger logger = LogManager.getLogger(ProxyController.class);

	private ObjectMapper mapper;

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "logsService")
	private LogsService logsService;

	@PostConstruct
	public void initIt() throws SQLException {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}

	public static String decodeXML(String value) {
		if (value == null || value.trim().equals("")) {
			return "";
		}

		String returnValue = value;

		returnValue = returnValue.replaceAll("&amp;", "&");
		returnValue = returnValue.replaceAll("&quot;", "\"");
		returnValue = returnValue.replaceAll("&lt;", "<");
		returnValue = returnValue.replaceAll("&gt;", ">");
		returnValue = returnValue.replaceAll("&#34;", "\"");
		returnValue = returnValue.replaceAll("&#39;", "\'");
		returnValue = returnValue.replaceAll("&apos;", "\'");
		returnValue = returnValue.replaceAll("&#46;", ".");
		returnValue = returnValue.replaceAll("&#46;", "%2E");
		returnValue = returnValue.replaceAll("&#47;", "%2F");

		return returnValue;
	}

	@RequestMapping(value = RequestMappingConstants.API_PROXY, method = { RequestMethod.GET, RequestMethod.POST })
	public void proxy(HttpServletRequest request, HttpServletResponse response) throws SQLException, NullPointerException, IOException {
		String urlParam = decodeXML(request.getQueryString()); // request.getParameter("url"));
		if (urlParam == null || urlParam.trim().length() == 0) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}
		String filtered_urlParam = urlParam.replace("url=", "").replace("wms&", "wms?").replace("WMS2&", "WMS2?")
				.replaceAll("\r", "").replaceAll("\n", "");

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

		int read = -1;
		byte[] buffer = new byte[8192];

		http.setDoInput(true);
		http.setDoOutput(doPost);
		// http.setRequestProperty("Content-type", "text/xml");
		// http.setRequestProperty("Accept", "text/xml, application/xml");
		if (doPost) {
			/*
			 * OutputStream os = http.getOutputStream(); ServletInputStream sis =
			 * request.getInputStream(); while ((read = sis.read(buffer)) != -1) {
			 * os.write(buffer, 0, read); } os.flush(); os.close();
			 */
			DataOutputStream wr = null;
			try {
				wr = new DataOutputStream(http.getOutputStream());
				ServletInputStream sis = request.getInputStream();
				while ((read = sis.read(buffer)) != -1) {
					wr.write(buffer, 0, read);
					wr.flush();
				}
			} catch (IOException exception) {
				throw exception;
			}

			if (wr != null) {
				wr.close();
			}
		}

		response.setStatus(http.getResponseCode());
		response.setContentType("text/html; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");

		InputStream is = http.getInputStream();
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
	}

	@RequestMapping(value = "/getProxy.do", method = RequestMethod.GET)
	public void getWMS(HttpServletRequest request, HttpServletResponse reponse) throws SQLException, NullPointerException, IOException {
		// String reqURL = "http://shgis.syesd.co.kr/geoserver/wms";
		String reqURL = request.getParameter("url");

		HttpURLConnection httpURLConnection = null;
		InputStream is = null;

		try {
			Enumeration<String> e = request.getParameterNames();

			StringBuffer param = new StringBuffer();

			while (e.hasMoreElements()) {
				String paramKey = (String) e.nextElement();
				if (!"url".equals(paramKey)) {
					String[] values = request.getParameterValues(paramKey);
					for (String value : values) {
						param.append(paramKey + "=" + value + "&");
					}
				}

			} // while

			String query = param.toString();

			if (!"".equals(query) && query != null) {
				query = query.substring(0, query.lastIndexOf("&"));
				reqURL = reqURL + "?" + query;
			}

			// 실제 geoserevr 연결
			URL realUrl = new URL(reqURL);
			httpURLConnection = (HttpURLConnection) realUrl.openConnection();

			// header 정보 가져오기
			// header 정보 셋팅
			Enumeration<String> headerKey = request.getHeaderNames();
			while (headerKey.hasMoreElements()) {
				String key = (String) headerKey.nextElement();
				String value = request.getHeader(key);
				httpURLConnection.addRequestProperty(key, value);
			}

			httpURLConnection.setRequestMethod(request.getMethod().toUpperCase());

			reponse.setContentType(httpURLConnection.getContentType());

			if (httpURLConnection.getResponseCode() == 200) {
				IOUtils.copy(httpURLConnection.getInputStream(), reponse.getOutputStream());
			} else {
				IOUtils.copy(httpURLConnection.getErrorStream(), reponse.getOutputStream());
			}

		} catch (IOException e) {
			logger.error("error가 발생하였습니다.");
		} catch (Exception e) {
			if (logger.isErrorEnabled()) {
				logger.error("Proxy Error: " + reqURL);
			}
		} finally {
			try {
				if (is != null) {
					is.close();
				}
			} catch (IOException e) {
				if (logger.isErrorEnabled()) {
					logger.error("에러입니다.");
				}
			} catch (NullPointerException e) {
				logger.error("Null point 에러입니다.");
			}

			if (httpURLConnection != null) {
				httpURLConnection.disconnect();
			}

		}
	};

	@RequestMapping(value = "/getProxy/wfs.do", method = RequestMethod.GET)
	public void getWFS(HttpServletRequest request, HttpServletResponse reponse) throws SQLException, NullPointerException, IOException {
		//String reqURL = "http://192.168.110.154:8080/geoserver";
		//String reqURL = "http://shgis.syesd.co.kr/geoserver";
		// http://shgis.syesd.co.kr/geoserver

		HttpURLConnection httpURLConnection = null;
		
		//예제 String requestBody ="<GetFeature xmlns=\"http://www.opengis.net/wfs\" service=\"WFS\" version=\"1.1.0\" outputFormat=\"application/json\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.opengis.net/wfs http://schemas.opengis.net/wfs/1.1.0/wfs.xsd\"><Query typeName=\"LANDSYS:eclgy_sttus_btp_ty_evl\" srsName=\"EPSG:4326\"><Filter xmlns=\"http://www.opengis.net/ogc\"><Contains><PropertyName>the_geom</PropertyName><Point xmlns=\"http://www.opengis.net/gml\" srsName=\"EPSG:4326\"><pos srsDimension=\"2\">126.9974564317801 37.5456376180919</pos></Point></Contains></Filter></Query></GetFeature>";
		String requestBody = request.getParameter("data");
		try {

			Enumeration<String> e = request.getParameterNames();
			StringBuffer param = new StringBuffer();

			// 실제 geoserevr 연결
			String reqURL = EgovProperties.getProperty("g.geoserverURL") + "/wfs"; //"http://shgis.syesd.co.kr/geoserver/wfs";
			//String reqURL = "localhost:38080/geoserver/wfs"; 
			URL realUrl = new URL(reqURL);
			httpURLConnection = (HttpURLConnection) realUrl.openConnection();

			//요청설정
			httpURLConnection.setRequestMethod("POST");
			httpURLConnection.setRequestProperty("Content-Type", "text/xml");
			httpURLConnection.setDoOutput(true);

			// 요청 본문 전송
			try (OutputStream os = httpURLConnection.getOutputStream()) {
				byte[] input = requestBody.getBytes("utf-8");
				os.write(input, 0, input.length);
			}
			
			 // 응답 코드 확인
            int responseCode = httpURLConnection.getResponseCode();
            logger.info("Response Code: " + responseCode);
            
            // 응답 처리
            if (responseCode == 200) {
                // 응답을 JSON으로 설정
                reponse.setContentType("application/json");
                reponse.setCharacterEncoding("UTF-8");

                // 응답 스트림을 클라이언트로 전송
                IOUtils.copy(httpURLConnection.getInputStream(), reponse.getOutputStream());
            } else {
                // 오류가 발생한 경우, 오류 스트림을 클라이언트로 전송
                reponse.setContentType("application/json");
                reponse.setCharacterEncoding("UTF-8");
                IOUtils.copy(httpURLConnection.getErrorStream(), reponse.getOutputStream());
            }

		} catch (IOException e) {
			logger.error("error가 발생하였습니다.");
		} catch (Exception e) {
			if (logger.isErrorEnabled()) {
				//logger.error("Proxy Error: " + reqURL);
			}
		} finally {
			/*try {
				if (br != null) {
					br.close();
				}
			} catch (IOException e) {
				if (logger.isErrorEnabled()) {
					logger.error("exception", e);
				}
			}

			if (httpURLConnection != null) {
				httpURLConnection.disconnect();
			}*/

		}
	};

}
