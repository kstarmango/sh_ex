package egovframework.syesd.cmmn.file.web;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.gdal.ogr.DataSource;
import org.gdal.ogr.Driver;
import org.gdal.ogr.Layer;
import org.gdal.ogr.ogr;
import org.gdal.osr.SpatialReference;
import org.geojson.GeoJsonObject;
import org.geotools.data.shapefile.dbf.DbaseFileHeader;
import org.geotools.data.shapefile.dbf.DbaseFileReader;
import org.geotools.data.shapefile.files.ShpFiles;
import org.mozilla.universalchardet.UniversalDetector;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.MappingIterator;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.dataformat.csv.CsvMapper;
import com.fasterxml.jackson.dataformat.csv.CsvParser;
import com.fasterxml.jackson.dataformat.csv.CsvSchema;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.file.service.FileService;
import egovframework.syesd.cmmn.file.service.impl.FileServiceImpl;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.syesd.cmmn.util.EgovProperties;
import egovframework.syesd.cmmn.util.ogr2ogr;
import egovframework.syesd.cmmn.util.ogrinfo;
import egovframework.syesd.portal.gis.service.GisService;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;

@Controller
public class FileController  extends BaseController  {

	private static Logger logger = LogManager.getLogger(FileController.class);

	private ObjectMapper mapper;

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "fileService")
	private FileService fileService;

	@Resource(name = "gisService")
	private GisService gisService;

	@Resource(name = "logsService")
	private LogsService logsService;

	private static final String validUrl   = RequestMappingConstants.WEB_MAIN;
	private static final String invalidUrl = RequestMappingConstants.WEB_LOGIN;

    @PostConstruct
	public void initIt() throws SQLException {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		mapper.configure(DeserializationFeature.ACCEPT_SINGLE_VALUE_AS_ARRAY, true);
	}

    /* 첨부파일  업로드  */
    @RequestMapping(value = RequestMappingConstants.API_UPLOAD,
 			method = {RequestMethod.POST})
	public ModelAndView fileUpload(HttpServletRequest request,
								   HttpServletResponse response,
								   MultipartHttpServletRequest multiRequest,
								   ModelMap model) throws SQLException, IOException
	{
    	response.setCharacterEncoding("UTF-8");
    	request.setCharacterEncoding("UTF-8");

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.addObject("groupInfo", fileService.upload(multiRequest));
			modelAndView.addObject("result", "Y");
			modelAndView.setViewName("jsonView");

			return modelAndView;
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			jsHelper.RedirectUrl(invalidUrl);
		}

		return null;
    }

    public static String findFileEncoding(File file) throws IOException {
        FileInputStream fis = new FileInputStream(file);
        UniversalDetector detector = new UniversalDetector(null);

        int nread;
        byte[] buf = new byte[4096];
        String encoding = "";
        try
	    {
        	while ((nread = fis.read(buf)) > 0 && !detector.isDone()) {
                detector.handleData(buf, 0, nread);
              }
        	detector.dataEnd();

            encoding = detector.getDetectedCharset();
            logger.info("encoding"+encoding);
            if (encoding != null) {
              logger.info("Detected encoding = " + encoding);
            } else {
              logger.info("No encoding detected.");
            }
	    }
        catch( IOException e)
	    {
        	logger.error("오류입니다.");
	    }
	    finally {
	    	// 수정 
	    	detector.reset();
	        fis.close();
	    }
   
        return encoding;
    }

    /* CSV 업로드 - 지오코딩용 */
    @RequestMapping(value = RequestMappingConstants.API_UPLOAD_CSV,
 			method = {RequestMethod.POST})
	public ModelAndView fileUploadCsv(HttpServletRequest request,
									   HttpServletResponse response,
									   MultipartHttpServletRequest multiRequest,
									   ModelMap model) throws SQLException, IOException
	{
    	response.setCharacterEncoding("UTF-8");
    	request.setCharacterEncoding("UTF-8");

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			// 구분문자
			String ColumnSeparator = multiRequest.getParameter("separator") == null ? "," : multiRequest.getParameter("separator");
			if(ColumnSeparator == null || "".equals(ColumnSeparator) == true )
        	{
	    		jsHelper.Alert("입력된 정보가 옳바르지 않습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
	    		jsHelper.RedirectUrl(invalidUrl);

	    		return null;
        	}

			// 파일 저장
			String groupNo = fileService.upload(multiRequest);

			// 파일 확인
			List fileList = fileService.selectFileByNo(groupNo);
			Map fileInfo = (Map) fileList.get(0);

			String upFolder  = RequestMappingConstants.TOMCAT_PATH + RequestMappingConstants.UPLOAD_FOLDER;
	    	String saveName  = (String)fileInfo.get("save_name");
	    	String savePath  = (String)fileInfo.get("save_path");
	    	String fullPath  = upFolder + savePath + saveName;
	    	String fileNoExt = saveName.substring( 0, saveName.lastIndexOf(".") );
	    	String saveJson  = upFolder + savePath + fileNoExt+"_" + RequestMappingConstants.REQUEST_SUBFIX_B;
	    	logger.info("!!!"+fullPath);
	    	// 파일 인코딩 확인
	    	File readFile = new File(fullPath);
	    	String encodeValue = findFileEncoding(readFile);
	    	logger.info("encodeValue!!"+encodeValue);
	    	if("UTF-8".equalsIgnoreCase(encodeValue) == false) {
	    		
	    		//파일 입력
	    		FileInputStream fileInputStream = new FileInputStream(readFile);
	    		//InputStreamReader inputStreamReader = new InputStreamReader(fileInputStream, "CSV");
	    		InputStreamReader inputStreamReader = new InputStreamReader(fileInputStream, encodeValue);
	    		BufferedReader bufferedReader = new BufferedReader(inputStreamReader);

	    		//파일 출력
	    		File writeFile = new File(fullPath + "UTF_8");
	    		FileOutputStream fileOutputStream = new FileOutputStream(writeFile);
	    		OutputStreamWriter outputStreamWriter = new OutputStreamWriter(fileOutputStream, "UTF-8");
	    		BufferedWriter bufferedWriter = new BufferedWriter(outputStreamWriter);

	    		String s = null;
	    		
	    		try
			    {
	    			while((s = bufferedReader.readLine()) != null){
		    			bufferedWriter.write(s);
		    			bufferedWriter.newLine();
					}
			    }
		        catch( IOException e)
			    {
		        	logger.error("오류입니다.");
			    }
			    finally {
			    	bufferedWriter.close();
		    		bufferedReader.close();
		    		
		    		inputStreamReader.close();
			    	fileInputStream.close();
			    	fileOutputStream.close();
			    	outputStreamWriter.close();
			    }
	
	    		//파일 복사
	    		Files.copy(writeFile.toPath(), readFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
	    		Files.delete(writeFile.toPath());
	    	}

			// 컬럼 추가
			String[] cmd1 = {fullPath, "-sql", "alter table " + fileNoExt + " rename column newX to newX_"};
	    	String[] cmd2 = {fullPath, "-sql", "alter table " + fileNoExt + " add column newX double"     };
	    	String[] cmd3 = {fullPath, "-sql", "alter table " + fileNoExt + " rename column newY to newY_"};
	    	String[] cmd4 = {fullPath, "-sql", "alter table " + fileNoExt + " add column newY double"     };
	    	String[] cmd5 = {fullPath, "-sql", "alter table " + fileNoExt + " rename column newAddr to newAddr_"};
	    	String[] cmd6 = {fullPath, "-sql", "alter table " + fileNoExt + " add column newAddr vharchar(200)" };
	    	ogrinfo.main(cmd1);
	    	ogrinfo.main(cmd2);
	    	ogrinfo.main(cmd3);
	    	ogrinfo.main(cmd4);
	    	ogrinfo.main(cmd5);
	    	ogrinfo.main(cmd6);

	    	// 파일 변환
	    	/*String[] cmd7 = {"-f",     "GeoJSON",
							 		   saveJson,
							 		   fullPath,
							 "-lco",   "ENCODING=UTF-8"};*/

	    	String[] cmd7 = {"-f",     "GeoJSON",
							 		   saveJson,
							 		   fullPath};
			ogr2ogr.main(cmd7);


	    	// 파일 로딩
	    	CsvMapper csvMapper = new CsvMapper();
			csvMapper.enable(CsvParser.Feature.TRIM_SPACES);
			csvMapper.enable(CsvParser.Feature.ALLOW_TRAILING_COMMA);
			csvMapper.enable(CsvParser.Feature.INSERT_NULLS_FOR_MISSING_COLUMNS);
			csvMapper.enable(CsvParser.Feature.SKIP_EMPTY_LINES);
			csvMapper.disable(MapperFeature.SORT_PROPERTIES_ALPHABETICALLY);

	    	File input = new File(fullPath);
			CsvSchema csvSchema = csvMapper.typedSchemaFor(Map.class).withHeader();

	    	// 파일 헤더
	    	MappingIterator<Map<String, String>> it = csvMapper.readerFor(Map.class)
												    	        .with(csvSchema.withColumnSeparator(ColumnSeparator.charAt(0)))
												    	        .readValues(input);
	    	Set<String> colnums = it.next().keySet();

	    	// 전체 데이터 - 헤더를 읽은 경우 다음 줄을 헤더로 판단하여 3번째가 첫번째 데이터로 출력된다.
	    	/*File input2 = new File(fullPath);
	    	CsvSchema csvSchema2 = csvMapper.typedSchemaFor(Map.class).withHeader();

	    	List<Object> readAll = csvMapper.readerFor(Map.class)
							    	        .with(csvSchema2.withColumnSeparator(ColumnSeparator.charAt(0)))
							    	        .readValues(input2).readAll();*/

	    	// 웹 직접 접근 경로
	        String dataUrl = RequestMappingConstants.UPLOAD_FOLDER_FOR_WEB + savePath + fileNoExt+"_" + RequestMappingConstants.REQUEST_SUBFIX_B;
	        String escapeStr = "\\\\";
	        dataUrl = dataUrl.replaceAll(escapeStr, "/");


			ModelAndView modelAndView = new ModelAndView();
			
			modelAndView.addObject("groupInfo", groupNo);
			modelAndView.addObject("groupSourceInfo", groupNo);
			modelAndView.addObject("columnCount", colnums.size());
			modelAndView.addObject("columnInfo", colnums);
			modelAndView.addObject("savePath", savePath); 
			modelAndView.addObject("saveName", saveName);
			modelAndView.addObject("dataUrl", dataUrl);
			modelAndView.addObject("result", "Y");
			modelAndView.setViewName("jsonView");

			return modelAndView;
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			jsHelper.RedirectUrl(invalidUrl);
		}

		return null;
    }

    /* PRJ 업로드 - 사용자 개별 레이어 */
    @RequestMapping(value = RequestMappingConstants.API_UPLOAD_PRJ,
 					method = {RequestMethod.POST})
	public ModelAndView fileUploadPrj(HttpServletRequest request,
									   HttpServletResponse response,
									   MultipartHttpServletRequest multiRequest,
									   ModelMap model) throws SQLException, IOException
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
	            String userId = commonSessionVO.getUser_id();
	            String userAdmYn = commonSessionVO.getUser_admin_yn();

	            String line = "";
	            StringBuilder sb = new StringBuilder();
	    		Iterator fileIter = multiRequest.getFileNames();
	        	while (fileIter.hasNext())
	        	{
	            	MultipartFile mFile = multiRequest.getFile((String)fileIter.next());
	        	    if (mFile.getSize() > 0)
	        	    {
	        	    	GregorianCalendar today = new GregorianCalendar();
	        			int year  = today.get (Calendar.YEAR );
	        			int month = today.get (Calendar.MONTH ) + 1;

	        	    	String fileName = mFile.getOriginalFilename();
	        	    	String filePath = FileServiceImpl.FOLDER_FORMAT.format(new Object[]{String.valueOf(year), String.valueOf(month)}) + File.separator;
	        	    	String savePath = RequestMappingConstants.TOMCAT_PATH + RequestMappingConstants.TEMPORARY_FOLDER + filePath;

	        		    File cFile = new File(savePath);
	        		    if(!cFile.isDirectory())
	        		    	cFile.mkdirs();

	        	    	fileService.writeToServer(mFile, fileName, savePath);

	        	    	String[] command = new String[] { "gdalsrsinfo", savePath + fileName, "-o",  "epsg"};
	        		    Process process = Runtime.getRuntime().exec(String.join(" ", command));
	        		    InputStream stdout = process.getInputStream();
	        		    BufferedReader reader = null;
	        	    	try
	        	    	{

	        	    		reader = new BufferedReader(new InputStreamReader(stdout));
	        	    		while ((line = reader.readLine()) != null) {
	        	    			if(line != null) {
	        	    				sb.append(line);
	        	    			}
	        	    		}

	        	    		process.destroy();
	        	    	} catch (IOException e) {
	        	    		logger.error("fileUploadPrj error");
	        	    	} finally {
	        	    		if(process != null)
	        	    			process.destroy();
	        	    		reader.close();
	        	    	}
	        	    }
	        	}

		        // 결과 반환
				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("epsgInfo", sb.toString());
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

    /* SHP 업로드 - 사용자 개별 레이어 */
    @RequestMapping(value = RequestMappingConstants.API_UPLOAD_SHP,
 					method = {RequestMethod.POST})
	public ModelAndView fileUploadShp(HttpServletRequest request,
									   HttpServletResponse response,
									   MultipartHttpServletRequest multiRequest,
									   ModelMap model) throws SQLException, IOException
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
	            String userId = commonSessionVO.getUser_id();
	            String userAdmYn = commonSessionVO.getUser_admin_yn();

	            // 출력 포맷
	            String format = (multiRequest.getParameter("format") == null ? "" : multiRequest.getParameter("format"));
				if("".equals(format)  == true)
	        	{
		    		jsHelper.Alert("출력 포맷 정보가 옳바르지 않습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
		    		jsHelper.RedirectUrl(invalidUrl);

		    		return null;
	        	}

				// 좌표 변환
				String s_srs = (multiRequest.getParameter("s_srs") == null ? "" : multiRequest.getParameter("s_srs"));
				String t_srs = (multiRequest.getParameter("t_srs") == null ? "" : multiRequest.getParameter("t_srs"));
				if(("".equals(s_srs)  == true && "".equals(t_srs) == false) || ("".equals(s_srs)  == false && "".equals(t_srs) == true))
	        	{
		    		jsHelper.Alert("좌표 변환 정보가 옳바르지 않습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
		    		jsHelper.RedirectUrl(invalidUrl);

		    		return null;
	        	}

				// 파일 저장
				String groupNo = fileService.upload(multiRequest);

				// 파일 확인 - 확장자 .shp 파일 찾기
				List fileList = fileService.selectFileByNo(groupNo);
				Map fileInfo = null;
				Iterator it = fileList.iterator();
				while(it.hasNext()) {
				    fileInfo = (Map)it.next();
				    logger.info("fileInfo::"+fileInfo);
				    if(fileInfo != null) {
				    	String saveName = (String)fileInfo.get("save_name");
				    	String fileExt  = saveName.substring( saveName.lastIndexOf(".") );
				    	if(fileExt != null && RequestMappingConstants.REQUEST_SUBFIX_E.equalsIgnoreCase(fileExt) == true) {
				    		break;
				    	}
				    }
				}

				String upFolder   = RequestMappingConstants.TOMCAT_PATH + RequestMappingConstants.UPLOAD_FOLDER;
		    	String saveName   = (String)fileInfo.get("save_name");
		    	String savePath   = (String)fileInfo.get("save_path");
		    	String fullPath   = upFolder + savePath + saveName;
		    	String fileNoExt  = saveName.substring( 0, saveName.lastIndexOf(".") );
		    	String saveOutput = upFolder + savePath + fileNoExt + "_" + (format.equals("GeoJSON") ? RequestMappingConstants.REQUEST_SUBFIX_B : RequestMappingConstants.REQUEST_SUBFIX_E);
		    	boolean isShpZip  = (saveName.toLowerCase().contains(RequestMappingConstants.REQUEST_SUBFIX_J) == true);

		    	// 파일 확인 - ZIP 업로드 일경우(임시 폴더에 압축 해제후 변환, 압축해제된 SHP파을은 ZIP파일명과 다를수 있음)
		    	if(isShpZip) {
		    		String tmpFolder = RequestMappingConstants.TOMCAT_PATH + RequestMappingConstants.TEMPORARY_FOLDER;

		    		List fileListInZip = fileService.decompres(fullPath, tmpFolder);
					Iterator it1 = fileListInZip.iterator();
					while(it1.hasNext()) {
						String tempFilePath = (String)it1.next();
						if(tempFilePath.substring(tempFilePath.lastIndexOf(".")).contains(RequestMappingConstants.REQUEST_SUBFIX_E) == true) {
							fullPath = tempFilePath;
							String temp = Paths.get(fullPath).getFileName().toString();
							fileNoExt = temp.substring( 0, temp.lastIndexOf(".") );
						}
					}
		    	}
				
		    	// 파일 변환
		    	if(s_srs.equalsIgnoreCase(t_srs) == true)
		    	{
		    		String[] cmd7 = {"-f",     format,
											   saveOutput,
									 		   fullPath};
					ogr2ogr.main(cmd7);
		    	} else {
		    		HashMap<String, Object> query = new HashMap<String, Object>();
		    		
			        query.put("EPSG", s_srs);
		    		String s_proj4 = gisService.selectGeocoingEpsgToProj4(query);

			        query.put("EPSG", "EPSG:4326");
		    		String b_proj4 = gisService.selectGeocoingEpsgToProj4(query);

			        query.put("EPSG", t_srs);
		    		String t_proj4 = gisService.selectGeocoingEpsgToProj4(query);

		    		if(s_proj4.indexOf("bessel") > 0) {
		    			String tempShp = fullPath.substring( 0, fullPath.lastIndexOf(".")) + "_4326.shp";

		    			// 중간 변환
				    	String[] cmd7
				    	= {"-s_srs", s_proj4,
										 "-t_srs", b_proj4,
										 "-f",     "ESRI Shapefile",
										 		   tempShp,
										 		   fullPath};
				    	ogr2ogr.main(cmd7);

				    	// 최종 변환
				    	String[] cmd8 = {"-s_srs", b_proj4,
										 "-t_srs", t_proj4,
										 "-f",     format,
										 		   saveOutput,
										 		   tempShp};
			    		ogr2ogr.main(cmd8);
		    		} else {
				    	String[] cmd8 = {"-s_srs", s_proj4,
										 "-t_srs", t_proj4,
										 "-f",     format,
										 		   saveOutput,
										 		   fullPath};
			    		ogr2ogr.main(cmd8);
		    		}
		    	}

		        // 파일 헤더
	        	String dbfFilePath =  upFolder + savePath + fileNoExt + RequestMappingConstants.REQUEST_SUBFIX_G;
	        	if(isShpZip) {
	        		dbfFilePath =  fullPath.replaceAll(RequestMappingConstants.REQUEST_SUBFIX_E, RequestMappingConstants.REQUEST_SUBFIX_G);
	        	}

		    	Set<String> colnums = new HashSet<String>();
		    	 FileInputStream fis = null;
		        try {
		            fis = new FileInputStream(dbfFilePath);
		            DbaseFileReader dbfReader =  new DbaseFileReader(fis.getChannel(),false, Charset.defaultCharset());
		            DbaseFileHeader dbfHeader = dbfReader.getHeader();

		            int numFields = dbfHeader.getNumFields();
		            for(int iField=0; iField < numFields; ++iField) {
		                String fieldName = dbfHeader.getFieldName(iField);
		                colnums.add(fieldName);
		            }

		            //dbfReader.close();
		        } catch (MalformedURLException e) {
		            logger.error("fileUploadShp MalformedURLException error");
		        } catch (IOException e) {
		            logger.error("fileUploadShp IOException error");
		        }finally {
		        	fis.close();
		        }

		        // 웹 직접 접근 경로
		        String dataUrl = RequestMappingConstants.UPLOAD_FOLDER_FOR_WEB + savePath + fileNoExt + "_" + (format.equals("GeoJSON") ? RequestMappingConstants.REQUEST_SUBFIX_B : RequestMappingConstants.REQUEST_SUBFIX_E);
		        String escapeStr = "\\\\";

		        // 웹 직접 접근 경로 - ZIP 업로드 일경우(ZIP저장 원본 폴더에 변환된 데이터 존재)
		        if(isShpZip) {
		        	dataUrl = RequestMappingConstants.UPLOAD_FOLDER_FOR_WEB + savePath + saveName.substring( 0, saveName.lastIndexOf("."))  + "_" + (format.equals("GeoJSON") ? RequestMappingConstants.REQUEST_SUBFIX_B : RequestMappingConstants.REQUEST_SUBFIX_E);
		        }
		        dataUrl = dataUrl.replaceAll(escapeStr, "/");

		        // 결과 반환
				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("groupSourceInfo", groupNo);
				modelAndView.addObject("groupConvertInfo", "");
				modelAndView.addObject("columnCount", colnums.size());
				modelAndView.addObject("columnInfo", colnums);
				modelAndView.addObject("savePath", savePath); 
				modelAndView.addObject("saveName", saveName);
				modelAndView.addObject("dataUrl", dataUrl);
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

    /* 첨부파일  다운로드  */
    @RequestMapping(value = RequestMappingConstants.API_DOWNLOAD,
 			method = {RequestMethod.GET,RequestMethod.POST})
	public void fileDownload(HttpServletRequest request,
							 HttpServletResponse response,
							 @RequestParam(value="groupNo",  required=false) String groupNo,
							 ModelMap model) throws SQLException, IOException
	{
    	response.setCharacterEncoding("UTF-8");
    	request.setCharacterEncoding("UTF-8");

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			fileService.download(request, response, groupNo);
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			jsHelper.RedirectUrl(invalidUrl);
		}
    }

    /* 첨부파일  리스트  */
    @RequestMapping(value = RequestMappingConstants.API_VIEWLIST,
 			method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView fileViewList(HttpServletRequest request,
									 HttpServletResponse response,
									 @RequestParam(value="id",  required=false) String groupNo,
									 ModelMap model) throws SQLException, IOException
	{
    	response.setCharacterEncoding("UTF-8");
    	request.setCharacterEncoding("UTF-8");

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.addObject("fileInfo", fileService.selectFileByNo(groupNo));
			modelAndView.addObject("result", "Y");
			modelAndView.setViewName("jsonView");

			return modelAndView;
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			jsHelper.RedirectUrl(invalidUrl);
		}

		return null;
    }

    /* 첨부파일  삭제  */
    @RequestMapping(value = RequestMappingConstants.API_UPDATELIST,
 			method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView fileDelete(HttpServletRequest request,
									 HttpServletResponse response,
									 @RequestParam(value="groupNo",  required=false) String groupNo,
									 ModelMap model) throws SQLException, IOException
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
	            String userId = commonSessionVO.getUser_id();
	            String userAdmYn = commonSessionVO.getUser_admin_yn();

		    	HashMap<String, Object> query = new HashMap<String, Object>();
		    	query.put("KEY", RequestMappingConstants.KEY);
		    	query.put("UPD_USER", userId);
		    	query.put("FILE_GRP", groupNo);

				ModelAndView modelAndView = new ModelAndView();
				modelAndView.addObject("fileInfo", fileService.updateFile(query));
				modelAndView.addObject("result", "Y");
				modelAndView.setViewName("jsonView");

			   	/* 이력 */
			   	try
				{
			       	HashMap<String, Object> param = new HashMap<String, Object>();
			       	param.put("KEY", RequestMappingConstants.KEY);
			       	param.put("PREFIX", "LOG");
			       	param.put("USER_ID", userId);
			       	param.put("PROGRM_URL", request.getRequestURI());

		   			/* 프로그램 사용 이력 등록 */
					logsService.insertUserProgrmLogs(param);
				}
				catch (SQLException e)
				{
					logger.error("이력 등록 실패");
				}

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
    
    @RequestMapping(value = RequestMappingConstants.API_ONETIMEDOWN, method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView convert(HttpServletRequest request,HttpServletResponse response,
			 @RequestParam(value="geojson",  required=true) String geojson,
			 @RequestParam(value="fileNm",  required=true) String fileNm,
			 ModelMap model) throws IOException{
    	//String fileNm = "analsys";  
    	//String geojson = "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[102,0.5]},\"properties\":{\"prop0\":\"value0\"}}]}";
    	
    	String tempPath = EgovProperties.getProperty("g.tomcatPath").replaceAll("|", "").replaceAll(";", "").replaceAll("&", "").replaceAll(":", "").replaceAll(">", "");
    	String tempDirPath = tempPath + File.separator + "temp" ; //"D:\\sh_local\\temp\\";
    	File customTempDirectory = new File(tempDirPath);
    	File tempGeoJsonFile = null;
        try {
            tempGeoJsonFile = File.createTempFile("tempGeoJson", ".json",customTempDirectory);
            try (FileWriter writer = new FileWriter(tempGeoJsonFile)) {
                writer.write(geojson);
            }
        } catch (IOException e) {
            logger.error("RequestMappingConstants convert error");
        }
        String jsonFileName = tempGeoJsonFile.getName();  //tempGeoJson3651890612010336050.json 
        
        // Shapefile 출력 파일 경로
        String shapefilePath = tempDirPath + fileNm+".shp";
       
        String[] cmd7 = {
			"-f"
			, "ESRI Shapefile"
			, shapefilePath
			, tempDirPath+jsonFileName
		};
    	ogr2ogr.main(cmd7); 
    	
    	String strArray[] = {".shp", ".prj", ".dbf", ".shx"};
    	List list = new ArrayList<>();
    	
    	for(int i=0; i < strArray.length;i++) {
    		
    		Map<String, Object> mapReceiver = new HashMap<String, Object>();
    		mapReceiver.put("FILE_NAME",fileNm+strArray[i]);
    		mapReceiver.put("SAVE_NAME", tempDirPath+fileNm+strArray[i]);
    		list.add(mapReceiver);
    		
    	}
    	// 파일 - 헤더
    	String header = request.getHeader("User-Agent");
    	
    	//인코딩
    	if(header.contains("MSIE") || header.contains("Trident")) {			//엣지
    		fileNm = URLEncoder.encode(fileNm,"UTF-8").replaceAll("\\+", "%20");
    				
    	}else if(header.contains("Chrome")) {								//크롬
    		fileNm = new String(fileNm.getBytes("UTF-8"), "ISO-8859-1");
    		
    	}
    	String zipFileName = fileNm+".zip"; 
    	// 파일 - 압축
    	fileService.compress(list, tempDirPath, zipFileName); 
    	
    	File file  = new File(tempDirPath + zipFileName);
    	response.setContentType("application/octet-stream");
    	response.setContentLength((int)file.length()); 
	    response.setHeader("Content-Disposition", "attachment;fileName=\"" + zipFileName + "\";"); 
	    
	    // 파일 - 전송
	    fileService.writeToClient(file, response);
	    
	    
	    Map<String, Object> mapReceiverZip = new HashMap<String, Object>();
	    mapReceiverZip.put("SAVE_NAME", tempDirPath + zipFileName);		//파일 삭제를 위한 생성된 zip파일 
		list.add(mapReceiverZip);
		
		Map<String, Object> mapReceiverJson = new HashMap<String, Object>();
		mapReceiverJson.put("SAVE_NAME", tempDirPath + jsonFileName);	//파일 삭제를 위한 생성된 json파일
		list.add(mapReceiverJson);
		
	    //파일 삭제
	    for (int i=0 ; i < list.size() ; i++)
        {
			HashMap<String, String> newData = (HashMap)list.get(i);
			
            File delFile = new File(newData.get("SAVE_NAME"));
            
            if(delFile.delete()){
    			logger.info("파일삭제 성공");
    		}else{
    			logger.info("파일삭제 실패");
    		}
        }

	    // 결과 반환
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.addObject("msg", "레이어 다운로드가 완료되었습니다.");
		modelAndView.setViewName("jsonView");
		return modelAndView;
    }
}
