package egovframework.syesd.map.data.shpUpload.web;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.file.service.FileService;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.syesd.cmmn.util.EgovProperties;
import egovframework.zaol.common.service.CommonService;
import egovframework.zaol.common.web.BaseController;
import egovframework.zaol.gisinfo.service.GisBasicVO;
import egovframework.zaol.gisinfo.service.GisinfoService;
import net.sf.json.JSONArray;

@Controller
public class ShpUploadController extends BaseController{
	private static Logger logger = LogManager.getLogger(ShpUploadController.class);
	private ObjectMapper mapper;
	
	private static final String validUrl   = RequestMappingConstants.WEB_MAIN;
	private static final String invalidUrl = RequestMappingConstants.WEB_LOGIN;
	
	/* service 구하기      */ @Resource(name = "gisinfoService"   ) private   GisinfoService gisinfoService;
    /* 공통 service 구하기 */ @Resource(name = "CommonService"    ) private   CommonService commonservice;
    
	@Resource(name = "fileService")
	private FileService fileService;
	
	@Resource(name = "logsService")
	private LogsService logsService;
	
    @PostConstruct
	public void initIt() throws NullPointerException {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}
    
    @RequestMapping(value="/data/shpUpload.do", method = {RequestMethod.GET, RequestMethod.POST})
    public String dataShpUpload (HttpServletRequest request, HttpServletResponse response, ModelMap model, @ModelAttribute("gisvo") GisBasicVO gisvo) throws SQLException, NullPointerException, IOException{
    	HttpSession session = getSession();
		String userS_id = null;
	   	if(session != null){
	   		userS_id = (String)session.getAttribute("userId");
	   	}
	   	
	   	if( userS_id != null ){
	   		session.setAttribute("progrmNo", request.getParameter("progrm_no"));
	   		
	       	gisvo.setUser_id(userS_id);
	       	
	       	HashMap<String, Object> vo = new HashMap<String, Object>();
	       	vo.put("KEY", RequestMappingConstants.KEY);
	       	
	       	JSONArray jsonArray = new JSONArray();
	    	model.addAttribute("shareUserList", jsonArray.fromObject(commonservice.selectUserShare(vo)));
	    	model.addAttribute("currentProgrm", request.getParameter("progrm_no"));
	    	
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
			catch (SQLException e)
			{
				logger.error("이력 등록 실패");
			}
	       	return "map/data/shpUpload.sub";

	       }else{
	       	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
	       }
	       return null;
	}
    
    @RequestMapping(value="/data/shp/sel.do", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView dataShpSel (HttpServletRequest request, HttpServletResponse response, ModelMap model
    		,@RequestParam(value="progrmNo",  required=true) String progrmNo
    		,@RequestParam(value="curPage",  required=true) int curPage
    		,@RequestParam(value="firstIndex",  required=true) int firstIndex
    		,@RequestParam(value="lastIndex",  required=true) int lastIndex) throws SQLException, NullPointerException, IOException{
    	
    	HttpSession session = getSession();
		String userS_id = null;
	   	if(session != null){
	   		userS_id = (String)session.getAttribute("userId");
	   	}
		if( userS_id != null ){
			
			HashMap<String, Object> vo = new HashMap<String, Object>();
		    vo.put("KEY", 		 RequestMappingConstants.KEY);
		    vo.put("INS_USER", userS_id);
		    vo.put("progrmNo", progrmNo);
		    vo.put("firstIndex", firstIndex);
		    vo.put("lastIndex", lastIndex);
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.addObject("myDataInfo", fileService.selDataList(vo));
			modelAndView.addObject("myDataCnt", fileService.selDataListPageCnt(vo));
			modelAndView.addObject("curPage", curPage);
			modelAndView.addObject("result", "Y");
			modelAndView.setViewName("jsonView");

			return modelAndView;
		}else{
	       	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
	     }
	   	
    	return null;
    }
    @RequestMapping(value="/data/shp/ins.do", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView dataShpIns (HttpServletRequest request, HttpServletResponse response, ModelMap model
    		,@RequestParam(value="title",  required=true) String title		
    		,@RequestParam(value="share",  required=true) String share
    		,@RequestParam(value="grp",  required=true) String grp
    		,@RequestParam(value="savePath",  required=true) String savePath
    		,@RequestParam(value="fileNm",  required=true) String fileNm
    		,@RequestParam(value="style",  required=true) String style
    		, @ModelAttribute("gisvo") GisBasicVO gisvo) throws SQLException, NullPointerException, IOException, InterruptedException{
    	HttpSession session = getSession();
		String userS_id = null;
	   	if(session != null){
	   		userS_id = (String)session.getAttribute("userId");
	   	}
	   	
	   	if( userS_id != null ){
	   		HashMap<String, Object> map = new HashMap<String, Object>();
	   		logger.info("title :: "+title);
	   		logger.info("share :: "+share.toString());
	   		//String [] commands = {"cmd.exe", "/c", "D:\\sh_local\\load_tiger.bat", fileNm , "landsys_usr", grp+'_'+userS_id, "0" , "4326", savePath}; local
	   		//운영서버 String [] commands = {"cmd.exe", "/c", "C:\\SH2024\\Tomcat8_8.5.57\\sh_local\\load_tiger.bat", fileNm , "landsys_usr", grp+'_'+userS_id, "0" , "4326", savePath};
	   		
	   		
	   		try {
	   			String bathFile = "";
	   			if("local".equals(EgovProperties.active)) {
	   				bathFile = "D:\\sh_local\\load_tiger.bat";
	   			}else if("dev".equals(EgovProperties.active)) {
	   				bathFile = "D:\\sh_local\\load_tiger.bat";
	   			}else if("prod".equals(EgovProperties.active)) {
	   				bathFile = "C:\\SH2024\\Tomcat9_9.0.96\\sh_local\\load_tiger.bat";
	   			}
			     //String bathFile = EgovProperties.getProperty("g.upload.bat");
			     //bathFile = bathFile.replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
			     fileNm = fileNm.replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
			     savePath = savePath.replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
			     grp = grp.replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
			     
   				String [] commands = {"cmd.exe", "/c", bathFile, fileNm , "landsys_usr", grp, "0" , "4326", savePath};
		   		
		   		
			    //String [] commands = {"cmd.exe", "/c", bathFile};
	   			Process p = Runtime.getRuntime().exec(commands);
			    p.waitFor();
			    
			    InputStream in = p.getInputStream();
			    ByteArrayOutputStream baos = new ByteArrayOutputStream();
			    int c = -1;
			    try
			    {
			    	while((c = in.read()) != -1)
				    {
				        baos.write(c);
				    }
			    	
			    	//String responseBat = new String(baos.toByteArray());
				    //logger.info("Response From Exe : "+responseBat);
			    }
		        catch( IOException e)
			    {
		        	logger.error("오류입니다.");
			    }
			    finally {
			    	// 수정 
			    	baos.close();
			    }
			     
			    HashMap<String, Object> vo = new HashMap<String, Object>();
			    vo.put("KEY", 		 RequestMappingConstants.KEY);
			    vo.put("FPREFIX",   "DATA");
			    vo.put("INS_USER",  userS_id);
			    vo.put("fileGrp",  grp);
			    vo.put("mainTitle", title);
			    vo.put("progrmNo", session.getAttribute("progrmNo"));
			    vo.put("style", style);
   				vo.put("tableNm", grp+'_'+userS_id); 
   				vo.put("othbc_yn", "Y");
   				vo.put("use_yn", "Y");
   				vo.put("shareList", share);
			    int result = fileService.insMyData(vo);
			    // 결과 반환
				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("result", result);
				modelAndView.addObject("msg", "SHP업로드 및 공유하기가 등록되었습니다.");
				modelAndView.setViewName("jsonView");
				return modelAndView;
			} catch (IOException e){
				logger.error("오류입니다.");
			}
       }else{
	       	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
	       }
	   	
	   	return null;
	}
    
    @RequestMapping(value="/data/shp/shareIns.do", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView dataShpShareInss (HttpServletRequest request, HttpServletResponse response, ModelMap model
    		,@RequestParam(value="shapeId",  required=true) String shapeId		
    		,@RequestParam(value="share",  required=true) String share
    		) throws SQLException, NullPointerException, IOException{
    	HttpSession session = getSession();
		String userS_id = null;
	   	if(session != null){
	   		userS_id = (String)session.getAttribute("userId");
	   	}
	   	
	   	if( userS_id != null ){
	   		HashMap<String, Object> map = new HashMap<String, Object>();
	   		logger.info("shapeId :: "+shapeId);
	   		logger.info("share :: "+share.toString());
	   		
		    HashMap<String, Object> vo = new HashMap<String, Object>();
		    vo.put("KEY", 		 RequestMappingConstants.KEY);
		    vo.put("FPREFIX",   "DATA");
		    vo.put("INS_USER",  userS_id);
		    vo.put("trget_no", shapeId);
			vo.put("shareList", share);
		    int result = fileService.insShare(vo);
		    // 결과 반환
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.addObject("result", result);
			modelAndView.addObject("msg", "공유가 완료되었습니다.");
			modelAndView.setViewName("jsonView");
			return modelAndView;
		
       }else{
	       	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
	       }
	   	
	   	return null;
	}
    
    @RequestMapping(value="/data/shp/del.do", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView dataShpDel (HttpServletRequest request, HttpServletResponse response, ModelMap model
    		,@RequestParam(value="targetNo",  required=true) String targetNo
    		,@RequestParam(value="fileGrp",  required=true) String fileGrp
    		,@RequestParam(value="path",  required=true) String path) throws SQLException, NullPointerException, IOException{
    	HttpSession session = getSession();
		String userS_id = null;
	   	if(session != null){
	   		userS_id = (String)session.getAttribute("userId");
	   	}
	   	
	   	if( userS_id != null ){
	   		HashMap<String, Object> vo = new HashMap<String, Object>();
	   		vo.put("INS_USER",  userS_id);
	   		vo.put("mapNo", targetNo);
	   		vo.put("fileGrp", fileGrp);
	   		vo.put("path", path);
	   		
	   		 
	   		int result = fileService.delMyData(vo);
	   		// 결과 반환
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.addObject("result", result);
			modelAndView.addObject("msg", "선택한 SHP파일이 삭제되었습니다.");
			modelAndView.setViewName("jsonView");
			return modelAndView;
	   	}else{
	       	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
	       }
	   	
	   	return null;
    }
    
    /*@RequestMapping(value="/data/shp/down.do", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView dataShpDown (HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
    	
    	HttpSession session = getSession();
		String userS_id = null;
	   	if(session != null){
	   		userS_id = (String)session.getAttribute("userId");
	   	}
		if( userS_id != null ){
			
			  URL url = new URL(fileURL);
		        HttpURLConnection httpConn = (HttpURLConnection) url.openConnection();
		        int responseCode = httpConn.getResponseCode();

		        // 서버 응답이 200 (HTTP OK)일 때만 파일 다운로드 진행
		        if (responseCode == HttpURLConnection.HTTP_OK) {
		            String fileName = "";
		            String disposition = httpConn.getHeaderField("Content-Disposition");

		            if (disposition != null && disposition.contains("filename=")) {
		                // Content-Disposition에 있는 파일 이름 추출
		                fileName = disposition.substring(disposition.indexOf("filename=") + 10, disposition.length() - 1);
		            } else {
		                // URL에서 파일 이름 추출
		                fileName = fileURL.substring(fileURL.lastIndexOf("/") + 1);
		            }

		            // InputStream을 사용해 파일을 다운로드
		            InputStream inputStream = httpConn.getInputStream();
		            String saveFilePath = saveDir + java.io.File.separator + fileName;
		            
		            // 파일을 로컬에 저장
		            FileOutputStream outputStream = new FileOutputStream(saveFilePath);
		            BufferedInputStream bufferedInputStream = new BufferedInputStream(inputStream);
		            
		            byte[] buffer = new byte[4096];
		            int bytesRead;
		            while ((bytesRead = bufferedInputStream.read(buffer)) != -1) {
		                outputStream.write(buffer, 0, bytesRead);
		            }

		            outputStream.close();
		            bufferedInputStream.close();
		            httpConn.disconnect();

		            logger.info("File downloaded to: " + saveFilePath);
		        } else {
		            logger.info("No file to download. Server replied with: " + responseCode);
		        }
		    

		    
			
			
			
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.addObject("result", "Y");
			modelAndView.setViewName("jsonView");

			return modelAndView;
		}else{
	       	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
	     }
	   	
    	return null;
    }*/
    	
    

}
