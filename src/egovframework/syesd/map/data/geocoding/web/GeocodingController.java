package egovframework.syesd.map.data.geocoding.web;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.MappingIterator;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.dataformat.csv.CsvMapper;
import com.fasterxml.jackson.dataformat.csv.CsvParser;
import com.fasterxml.jackson.dataformat.csv.CsvSchema;
import com.fasterxml.jackson.dataformat.csv.CsvSchema.Builder;
import com.fasterxml.jackson.dataformat.csv.CsvSchema.Column;

import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.file.service.FileService;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.syesd.cmmn.util.EgovProperties;
import egovframework.syesd.cmmn.util.ogr2ogr;
import egovframework.syesd.cmmn.util.ogrinfo;
import egovframework.zaol.common.service.CommonService;
import egovframework.zaol.common.web.BaseController;
import egovframework.zaol.gisinfo.service.GisBasicVO;
import egovframework.zaol.gisinfo.service.GisinfoService;



@Controller
public class GeocodingController extends BaseController{
	private static Logger logger = LogManager.getLogger(GeocodingController.class);
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
	
    @RequestMapping(value="/data/geocode.do", method = {RequestMethod.GET, RequestMethod.POST})
    public String dataGeocode (HttpServletRequest request, HttpServletResponse response, ModelMap model, @ModelAttribute("gisvo") GisBasicVO gisvo) throws SQLException, NullPointerException, IOException{
    	HttpSession session = getSession();
		String userS_id = null;
	   	if(session != null){
	   		userS_id = (String)session.getAttribute("userId");
	   	}
	   	
	   	if( userS_id != null ){
	   		session.setAttribute("progrmNo", request.getParameter("progrm_no"));
	       	List SIGList = gisinfoService.sig_list(gisvo);
	       	//List GISCodeList = gisinfoService.gis_code_list(gisvo);
	       	
	       	gisvo.setUser_id(userS_id);
	       	
	       	HashMap<String, Object> vo = new HashMap<String, Object>();
	       	vo.put("KEY", RequestMappingConstants.KEY);
	       	
	       	JSONArray jsonArray = new JSONArray();
	    	//model.addAttribute("shareUserList", jsonArray.fromObject(commonservice.selectUserShare(vo)));
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
	       	
	       	return "map/data/geocode.sub";

	       }else{
	       	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
	       }
	       return null;
	}
    
    @RequestMapping(value="/data/geocode/sel.do", method = {RequestMethod.GET, RequestMethod.POST})
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
    
    @RequestMapping(value="/data/geocode/insback.do", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView dataGeocodeInsbak (HttpServletRequest request, HttpServletResponse response, ModelMap model
    		,@RequestParam(value="title",  required=true) String title		
    		,@RequestParam(value="share",  required=true) String share
    		,@RequestParam(value="grp",  required=true) String grp
    		,@RequestParam(value="savePath",  required=true) String savePath
    		,@RequestParam(value="fileNm",  required=true) String fileNm
    		,@RequestParam(value="style",  required=true) String style
    		,@RequestParam(value="geomStr",  required=true) String geomStr
    		, @ModelAttribute("gisvo") GisBasicVO gisvo) throws SQLException, NullPointerException, IOException, InterruptedException, ParseException{
    	HttpSession session = getSession();
		String userS_id = null;
	   	if(session != null){
	   		userS_id = (String)session.getAttribute("userId");
	   	}
	   	
	   	if( userS_id != null ){
	   		HashMap<String, Object> map = new HashMap<String, Object>();
	   		logger.info("title :: "+title);
	   		logger.info("share :: "+share.toString());
	   		//{"cmd.exe", "/c", "D:\\sh_local\\load_tiger.bat", "TEST_LAND_EXPORT_4326_.zip" , "landsys_usr", "test8", "0" , "4326", "2024\8\"}
	   		//String [] commands = {"cmd.exe", "/c", "D:\\sh_local\\load_tiger.bat", fileNm , "landsys_usr", grp+'_'+userS_id, "0" , "4326", savePath}; 
	   		
	   		//운영서버
	   		//String [] commands = {"cmd.exe", "/c", "C:\\SH2024\\Tomcat8_8.5.57\\sh_local\\load_tiger.bat", fileNm , "landsys_usr", grp+'_'+userS_id, "0" , "4326", savePath};
   			//String bathFile = EgovProperties.getProperty("g.upload.bat");
		    //bathFile = bathFile.replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
		    
	   		try {
	   			
	   			String bathFile = "";
	   			if("local".equals(EgovProperties.active)) {
	   				bathFile = "D:\\sh_local\\load_tiger.bat";
	   			}else if("dev".equals(EgovProperties.active)) {
	   				bathFile = "D:\\sh_local\\load_tiger.bat";
	   			}else if("prod".equals(EgovProperties.active)) {
	   				bathFile = "C:\\SH2024\\Tomcat9_9.0.96\\sh_local\\load_tiger.bat";
	   			}
	   			
	   			fileNm = fileNm.replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
			    savePath = savePath.replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
			    grp = grp.replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
			     
		   		String [] commands = {"cmd.exe", "/c", bathFile, fileNm , "landsys_usr", grp, "0" , "4326", savePath};
			     
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
			    
			    String fileNoExt = fileNm.substring( 0, fileNm.lastIndexOf(".") );
			    //로컬
			   // FileReader reader = new FileReader("D:\\apache-tomcat-8.5.81\\upload\\"+savePath+fileNoExt+"_.json"); 
			    
				//String tomcatPath = EgovProperties.getProperty("g.tomcatPath").replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
				
				//String tomcatPath = EgovProperties.getProperty("g.tomcatPath");
				String tomcatPath = EgovProperties.getProperty("g.tomcatPath");
	        	if (tomcatPath != null && !"".equals(tomcatPath))
		        {
	        		// 수정 : 외부 입력값 필터링
	        		tomcatPath = tomcatPath.replaceAll("/","").replaceAll(";","").replaceAll("&","");	
			    
	        		System.out.println("tomcatPath!!"+tomcatPath);
					//tomcatPath = tomcatPath.replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
				    String saveJson = tomcatPath+"\\upload\\"+savePath+fileNoExt+"_.json"; 
				    saveJson = saveJson.replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
				    String fullPath = tomcatPath+"\\upload\\"+savePath+fileNoExt+".csv";
				    fullPath = fullPath.replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
				    
				    System.out.println("fullPath!!"+fullPath);
				    File customTempDirectory = new File(tomcatPath+File.separator+"temp");
			    	File tempGeoJsonFile = null;
			    	FileWriter writer = null;
			    	File copyFile = new File(saveJson);
			    	
			    	   System.out.println("saveJson!!"+saveJson);
			        try {  
			        	
			        	/*if(copyFile.delete()){
			    			logger.info("파일삭제 성공");
			    		}else{
			    			logger.info("파일삭제 실패");
			    		}*/
			        	System.out.println("customTempDirectory!!"+customTempDirectory);
			            tempGeoJsonFile = File.createTempFile("tempGeoJson", ".json",customTempDirectory);
			            writer = new FileWriter(tempGeoJsonFile);
			            writer.write(geomStr);
			            writer.close();
			            System.out.println("막히는거네");
			          //파일 복사
			    		Files.copy(tempGeoJsonFile.toPath(), copyFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
			    		//Files.delete(tempGeoJsonFile.toPath());
			        } catch (Exception e) {
			            logger.error("이력 등록 실패");
			            //return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
			        }finally{
		            	// writer.close();
		            }
		        
			        
			        System.out.println("여기안도지않아???");
			        String jsonFileName = tempGeoJsonFile.getName();  //tempGeoJson3651890612010336050.json 
			        logger.info("힝 한번더 get Name!!!!!!!"+tempGeoJsonFile.getName());
		        
		        
			        // 파일 로딩
			    	CsvMapper csvMapper = new CsvMapper();
					csvMapper.enable(CsvParser.Feature.TRIM_SPACES);
					csvMapper.enable(CsvParser.Feature.ALLOW_TRAILING_COMMA);
					csvMapper.enable(CsvParser.Feature.INSERT_NULLS_FOR_MISSING_COLUMNS);
					csvMapper.enable(CsvParser.Feature.SKIP_EMPTY_LINES);
					csvMapper.disable(MapperFeature.SORT_PROPERTIES_ALPHABETICALLY); 
					
			        File input = new File(fullPath);
					//CsvSchema csvSchema = csvMapper.typedSchemaFor(Map.class).withHeader();
				   
					//JsonNode jsonTree = new ObjectMapper().readTree(new File("D:\\sh_local\\temp\\"+jsonFileName));
					Builder csvSchemaBuilder = CsvSchema.builder();
					//JsonNode firstObject = jsonTree.elements().next();
					
				
				
				
					JSONParser parser = new JSONParser();
			        JSONObject geocodedData =  (JSONObject) parser.parse(geomStr);
			        //logger.info("!!!!!!"+geocodedData.get("features").toString());
					JSONArray dataArray = (JSONArray) geocodedData.get("features");
					
					JSONArray arr = new JSONArray();
				
					for(int i = 0; i < dataArray.size(); i++) {
						JSONObject item = (JSONObject) dataArray.get(i);
						JSONObject property = (JSONObject) item.get("properties");
						arr.add(property);
					} 
					
					 JSONObject firstObject = (JSONObject) arr.get(0);
					 Iterator<?> fieldNames = firstObject.keySet().iterator();
	
					 while (fieldNames.hasNext()) {
				            String fieldName = (String) fieldNames.next();
				            csvSchemaBuilder.addColumn(fieldName);
				        }
					 
					/*csvSchemaBuilder.addColumn("명칭");
					csvSchemaBuilder.addColumn("주소");
					csvSchemaBuilder.addColumn("newX");
					csvSchemaBuilder.addColumn("newY");
					csvSchemaBuilder.addColumn("newAddr");
					csvSchemaBuilder.addColumn("__index");
					csvSchemaBuilder.addColumn("__modified__");
					csvSchemaBuilder.addColumn("__original_index");*/
					/*Iterator<String> fieldNames = arr.
					
					while (fieldNames.hasNext()) {
					    String fieldName = fieldNames.next();
					    logger.info("fieldName"+fieldName);
					    csvSchemaBuilder.addColumn(fieldName);
					}*/
					
					CsvSchema csvSchema = csvSchemaBuilder.build().withHeader();
					
					csvMapper.writerFor(JSONArray.class)
					  .with(csvSchema)
					  .writeValue(new File(fullPath), arr);
					
					// 파일 인코딩 확인
			    	File readFile = new File(fullPath);
			    	String encodeValue_convert = "UTF-8"; 
			    	logger.info("!!마지막!!encodeValue_convert!!"+encodeValue_convert);
			    	if("UTF-8".equalsIgnoreCase(encodeValue_convert) == true) {
			    		//파일 입력
			    		FileInputStream fileInputStream = new FileInputStream(readFile);
			    		//InputStreamReader inputStreamReader = new InputStreamReader(fileInputStream, "CSV");
			    		InputStreamReader inputStreamReader = new InputStreamReader(fileInputStream, encodeValue_convert);
			    		BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
	
			    		//파일 출력
			    		File writeFile = new File(fullPath + "EUC-KR");
			    		FileOutputStream fileOutputStream = new FileOutputStream(writeFile);
			    		OutputStreamWriter outputStreamWriter = new OutputStreamWriter(fileOutputStream, "EUC-KR");
			    		BufferedWriter bufferedWriter = new BufferedWriter(outputStreamWriter);
	
			    		String s = null;
			    		
			    		try
					    {
			    			while((s = bufferedReader.readLine()) != null){
				    			bufferedWriter.write(s);
				    			bufferedWriter.newLine();
							}
			    			
			    			 System.out.println("여기까진?ㄴㄴ");
					    }
				        catch( IOException e)
					    {
				        	logger.error("오류입니다.");
					    }
					    finally {
					    	
					    	bufferedWriter.close();
				    		bufferedReader.close(); 
				    		
					    	fileInputStream.close();
					    	fileOutputStream.close();
					    	outputStreamWriter.close();
					    }
	
			    		//파일 복사
			    		Files.copy(writeFile.toPath(), readFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
			    		Files.delete(writeFile.toPath());
			    	}
		        }  
			    // 결과 반환
				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("result", result);
				modelAndView.addObject("msg", "주소변환 및 공유하기가 등록되었습니다.");
				modelAndView.setViewName("jsonView");
				return modelAndView;
			} catch (SQLException e) {
			    logger.error("이력 등록 실패");
			}
       }else{
	       	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
	       }
	   	
	   	return null;
	}
    
    @RequestMapping(value="/data/geocode/ins.do", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView dataGeocodeIns (HttpServletRequest request, HttpServletResponse response, ModelMap model
    		,@RequestParam(value="title",  required=true) String title		
    		,@RequestParam(value="share",  required=true) String share
    		,@RequestParam(value="grp",  required=true) String grp
    		,@RequestParam(value="savePath",  required=true) String savePath
    		,@RequestParam(value="fileNm",  required=true) String fileNm
    		,@RequestParam(value="style",  required=true) String style
    		,@RequestParam(value="geomStr",  required=true) String geomStr
    		, @ModelAttribute("gisvo") GisBasicVO gisvo) throws Exception{
    	HttpSession session = getSession();
		String userS_id = null;
	   	if(session != null){
	   		userS_id = (String)session.getAttribute("userId");
	   	}
	   	
	   	if( userS_id != null ){
	   		HashMap<String, Object> map = new HashMap<String, Object>();
	   		System.out.println("title :: "+title);
	   		System.out.println("share :: "+share.toString());
	   		//{"cmd.exe", "/c", "D:\\sh_local\\load_tiger.bat", "TEST_LAND_EXPORT_4326_.zip" , "landsys_usr", "test8", "0" , "4326", "2024\8\"}
	   		//String [] commands = {"cmd.exe", "/c", "D:\\sh_local\\load_tiger.bat", fileNm , "landsys_usr", grp+'_'+userS_id, "0" , "4326", savePath}; 
	   		
	   		//운영서버
	   		//String [] commands = {"cmd.exe", "/c", "C:\\SH2024\\Tomcat8_8.5.57\\sh_local\\load_tiger.bat", fileNm , "landsys_usr", grp+'_'+userS_id, "0" , "4326", savePath};
	   		
	   		String [] commands = {"cmd.exe", "/c", EgovProperties.getProperty("g.upload.bat"), fileNm , "landsys_usr", grp+'_'+userS_id, "0" , "4326", savePath};
	   		try {
			     
	   			Process p = Runtime.getRuntime().exec(commands);
			    p.waitFor();
			    
			    InputStream in = p.getInputStream();
			    ByteArrayOutputStream baos = new ByteArrayOutputStream();
			     
			    int c = -1;
			    while((c = in.read()) != -1)
			    {
			        baos.write(c);
			    }
			     
			    String responseBat = new String(baos.toByteArray());
			    System.out.println("Response From Exe : "+responseBat);
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
			    
			    String fileNoExt = fileNm.substring( 0, fileNm.lastIndexOf(".") );
			    //로컬
			   // FileReader reader = new FileReader("D:\\apache-tomcat-8.5.81\\upload\\"+savePath+fileNoExt+"_.json"); 
			    
				    
			    String saveJson = EgovProperties.getProperty("g.tomcatPath")+"\\upload\\"+savePath+fileNoExt+"_.json"; 
			    String fullPath = EgovProperties.getProperty("g.tomcatPath")+"\\upload\\"+savePath+fileNoExt+".csv";
			    
			    
			    File customTempDirectory = new File(EgovProperties.getProperty("g.tomcatPath")+"\\temp");
		    	File tempGeoJsonFile = null;
		    	
		    	File copyFile = new File(saveJson);
		        try {  
		        	
		        	/*if(copyFile.delete()){
		    			System.out.println("파일삭제 성공");
		    		}else{
		    			System.out.println("파일삭제 실패");
		    		}*/
		            tempGeoJsonFile = File.createTempFile("tempGeoJson", ".json",customTempDirectory);
		            try (FileWriter writer = new FileWriter(tempGeoJsonFile)) {
		                writer.write(geomStr);
		                writer.close();
		            }
		            
		          //파일 복사
		    		Files.copy(tempGeoJsonFile.toPath(), copyFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
		    		//Files.delete(tempGeoJsonFile.toPath());
		        } catch (IOException e) {
		            e.printStackTrace();
		            //return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		        }
		        
		        String jsonFileName = tempGeoJsonFile.getName();  //tempGeoJson3651890612010336050.json 
		        System.out.println("힝 한번더 get Name!!!!!!!"+tempGeoJsonFile.getName());
		        
		        
		        // 파일 로딩
		    	CsvMapper csvMapper = new CsvMapper();
				csvMapper.enable(CsvParser.Feature.TRIM_SPACES);
				csvMapper.enable(CsvParser.Feature.ALLOW_TRAILING_COMMA);
				csvMapper.enable(CsvParser.Feature.INSERT_NULLS_FOR_MISSING_COLUMNS);
				csvMapper.enable(CsvParser.Feature.SKIP_EMPTY_LINES);
				csvMapper.disable(MapperFeature.SORT_PROPERTIES_ALPHABETICALLY); 
				
		        File input = new File(fullPath);
				//CsvSchema csvSchema = csvMapper.typedSchemaFor(Map.class).withHeader();
			   
				//JsonNode jsonTree = new ObjectMapper().readTree(new File("D:\\sh_local\\temp\\"+jsonFileName));
				Builder csvSchemaBuilder = CsvSchema.builder();
				//JsonNode firstObject = jsonTree.elements().next();
				
				
				
				
				JSONParser parser = new JSONParser();
		        JSONObject geocodedData =  (JSONObject) parser.parse(geomStr);
		        //System.out.println("!!!!!!"+geocodedData.get("features").toString());
				JSONArray dataArray = (JSONArray) geocodedData.get("features");
				
				JSONArray arr = new JSONArray();
			
				for(int i = 0; i < dataArray.size(); i++) {
					JSONObject item = (JSONObject) dataArray.get(i);
					JSONObject property = (JSONObject) item.get("properties");
					arr.add(property);
				} 
				
				 JSONObject firstObject = (JSONObject) arr.get(0);
				 Iterator<?> fieldNames = firstObject.keySet().iterator();

				 while (fieldNames.hasNext()) {
			            String fieldName = (String) fieldNames.next();
			            csvSchemaBuilder.addColumn(fieldName);
			        }
				 
				/*csvSchemaBuilder.addColumn("명칭");
				csvSchemaBuilder.addColumn("주소");
				csvSchemaBuilder.addColumn("newX");
				csvSchemaBuilder.addColumn("newY");
				csvSchemaBuilder.addColumn("newAddr");
				csvSchemaBuilder.addColumn("__index");
				csvSchemaBuilder.addColumn("__modified__");
				csvSchemaBuilder.addColumn("__original_index");*/
				/*Iterator<String> fieldNames = arr.
				
				while (fieldNames.hasNext()) {
				    String fieldName = fieldNames.next();
				    System.out.println("fieldName"+fieldName);
				    csvSchemaBuilder.addColumn(fieldName);
				}*/
				
				CsvSchema csvSchema = csvSchemaBuilder.build().withHeader();
				
				csvMapper.writerFor(JSONArray.class)
				  .with(csvSchema)
				  .writeValue(new File(fullPath), arr);
				
				// 파일 인코딩 확인
		    	File readFile = new File(fullPath);
		    	String encodeValue_convert = "UTF-8"; 
		    	System.out.println("!!마지막!!encodeValue_convert!!"+encodeValue_convert);
		    	if("UTF-8".equalsIgnoreCase(encodeValue_convert) == true) {
		    		//파일 입력
		    		FileInputStream fileInputStream = new FileInputStream(readFile);
		    		//InputStreamReader inputStreamReader = new InputStreamReader(fileInputStream, "CSV");
		    		InputStreamReader inputStreamReader = new InputStreamReader(fileInputStream, encodeValue_convert);
		    		BufferedReader bufferedReader = new BufferedReader(inputStreamReader);

		    		//파일 출력
		    		File writeFile = new File(fullPath + "EUC-KR");
		    		FileOutputStream fileOutputStream = new FileOutputStream(writeFile);
		    		OutputStreamWriter outputStreamWriter = new OutputStreamWriter(fileOutputStream, "EUC-KR");
		    		BufferedWriter bufferedWriter = new BufferedWriter(outputStreamWriter);

		    		String s = null;
		    		while((s = bufferedReader.readLine()) != null){
		    			bufferedWriter.write(s);
		    			bufferedWriter.newLine();
					}
	
		    		bufferedWriter.close();
		    		bufferedReader.close(); 

		    		//파일 복사
		    		Files.copy(writeFile.toPath(), readFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
		    		Files.delete(writeFile.toPath());
		    	}
			     
			    // 결과 반환
				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("result", result);
				modelAndView.addObject("msg", "주소변환 및 공유하기가 등록되었습니다.");
				modelAndView.setViewName("jsonView");
				return modelAndView;
			} catch (Exception e) {
			    e.printStackTrace();
			}
       }else{
	       	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
	       }
	   	
	   	return null;
	}

    
    @RequestMapping(value="/data/geocode/del.do", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView dataGeocodeDel (HttpServletRequest request, HttpServletResponse response, ModelMap model
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
			modelAndView.addObject("msg", "선택한 주소변환 파일이 삭제되었습니다."); 
			modelAndView.setViewName("jsonView");
			return modelAndView;
	   	}else{
	       	jsHelper.Alert("비정상적인 접근 입니다.");
	       	jsHelper.RedirectUrl(invalidUrl);
	       }
	   	
	   	return null;
    }
    
}
