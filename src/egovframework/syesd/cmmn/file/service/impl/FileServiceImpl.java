package egovframework.syesd.cmmn.file.service.impl;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.file.service.FileService;
import egovframework.syesd.cmmn.file.web.FileController;
import egovframework.zaol.common.Globals;
import egovframework.zaol.common.service.CommonSessionVO;

@Service("fileService")
public class FileServiceImpl extends AbstractServiceImpl implements FileService {

	private static Logger logger = LogManager.getLogger(FileService.class);

	@Resource(name="fileDAO")
	private FileDAO fileDAO;

	public static final int BUFF_SIZE 					= 8096;
	public static final String FOLDER_PATTERN			= "{0}" + RequestMappingConstants.SEPERATOR + "{1}";
	public static final MessageFormat FOLDER_FORMAT		= new MessageFormat(FOLDER_PATTERN);

	// 파일  - 업로드
	public String upload(final MultipartHttpServletRequest multiRequest) throws SQLException 
	{
		GregorianCalendar today = new GregorianCalendar();
		int year  = today.get (Calendar.YEAR );
		int month = today.get (Calendar.MONTH ) + 1;

		String userId = "";
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	    HttpSession session = request.getSession();
		if(session != null)
		{
			CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
			userId = commonSessionVO.getUser_id();
		}

		int fileCount = 1;
		String groupNo = "";
		String groupPrefixName = "";
		Iterator fileIter = multiRequest.getFileNames();
    	while (fileIter.hasNext())
    	{
        	MultipartFile mFile = multiRequest.getFile((String)fileIter.next());
    	    if (mFile.getSize() > 0)
    	    {
    	    	String fileName = mFile.getOriginalFilename();
    	    	String fileExt  = fileName.substring( fileName.lastIndexOf(".") + 1 );
    	    	String fileGrp  = UUID.randomUUID().toString();
    	    	String saveName = fileGrp + "." + fileExt;
    	    	String savePath = FOLDER_FORMAT.format(new Object[]{String.valueOf(year), String.valueOf(month)}) + File.separator;
    	    	String path = RequestMappingConstants.TOMCAT_PATH + RequestMappingConstants.UPLOAD_FOLDER + savePath;

	    		if(fileCount == 1) {
	    			groupPrefixName = fileGrp;
	    		} else if(fileCount > 1 && Arrays.asList(RequestMappingConstants.REQUEST_SUBFIX_SHP).contains("." + fileExt)) {	// 2번째 파일 중 Shape Ext 에 포함일 경우
    	    		saveName = groupPrefixName + "." + fileExt;
    	    	}

    	    	HashMap<String, Object> map = new HashMap<String, Object>();
    	    	map.put("KEY", 		 RequestMappingConstants.KEY);
    	    	map.put("INS_USER",  userId);

    	    	map.put("FPREFIX",   "FNO");
    	    	map.put("GPREFIX",   "GNO");
    	    	map.put("FILE_IDX",  fileCount);
    	    	map.put("FILE_NAME", fileName);
    	    	map.put("FILE_EXT" , fileExt);
    	    	map.put("SAVE_NAME", saveName);
    	    	map.put("SAVE_PATH", savePath);


    	    	// 리스트추가
    	    	if(fileCount == 1) {
    	    		map.put("FILE_GRP",  "N");
    	    		groupNo = fileDAO.insertFile(map); //기존 주석풀려있었음
    	    		groupNo = groupNo.replace("FNO", "GNO");
    	    	}
    	    	else
    	    	{
    	    		map.put("FILE_GRP",  groupNo);
    	    		fileDAO.insertFile(map); //기존 주석풀려있었음
    	    	}

	        	// 서버저장
    	    	writeToServer(mFile, saveName, path);

	        	// 로그
	        	logger.debug("FILE_IDX  :::::::::::::: " + fileCount);
	        	logger.debug("FILE_NAME :::::::::::::: " + fileName);
	        	logger.debug("FILE_EXT  :::::::::::::: " + fileExt);
	        	logger.debug("SAVE_NAME :::::::::::::: " + saveName);
	        	logger.debug("SAVE_PATH :::::::::::::: " + savePath);

	        	fileCount++;
    	    }
        }

    	return groupNo;
	}

	// 파일 - 다운로드
	public void download(HttpServletRequest request, HttpServletResponse response, String groupNo) throws SQLException, IOException
	{
		List list = fileDAO.selectFileByNo(groupNo);
		if(list.size() == 1)
			writeSingleFile(request, response, (Map)list.get(0));	// 싱글 파일
		else
			writeMultiFile(request, response, list);				// 멀티파일
	}

	// 파일 - 리스트
	public List selectFileByNo(String groupNo) throws SQLException 
	{
		return fileDAO.selectFileByNo(groupNo);
	}

	// 파일 - 등록
	public String insertFile(Map vo) throws SQLException  {
		return fileDAO.insertFile(vo);
	}

	// 파일 - 등록
	public int updateFile(Map vo)  throws SQLException {
		return fileDAO.updateFile(vo);
	}

	private String getFileOrgName(String key) {
		String orgName = null;
		if (key.indexOf("dupl_") != -1) {
			orgName = key.substring(key.indexOf("dupl_") + 5);
		} else {
			orgName = key;
		}

		return orgName;
	}

	////////////////////////////////////////////////////////////////////////////////////////////////
	// 서버저장
	public void writeToServer(MultipartFile file, String fileName, String savePath) 
	{
		InputStream is = null;
		OutputStream os = null;

		try
		{
		    File cFile = new File(savePath);
		    if(!cFile.isDirectory())
		    	cFile.mkdirs();

		    int bytesRead = 0;
		    byte[] buffer = new byte[BUFF_SIZE];

		    is = file.getInputStream();
		    os = new FileOutputStream(savePath + fileName);

		    while ((bytesRead = is.read(buffer, 0, BUFF_SIZE)) != -1)
		    {
		    	os.write(buffer, 0, bytesRead);
		    }
		}
		catch (IOException e)
		{
			logger.info("에러입니다.");
		}
		finally
		{
		    if (os != null) {
				try {
					os.close();
				} catch (IOException ignore) {
					logger.info("ignore");
				}
		    }
		    if (is != null) {
				try {
					is.close();
				} catch (IOException ignore) {
					logger.info("ignore");
				}
		    }
		}
	}
	
	
	//데이터 추출 다운로드 temp 폴더에 생성된 임시 데이터 다운로드
	@Override
	public void dataExportDownload(HttpServletRequest request, HttpServletResponse response, List list) throws IOException  {
		// TODO Auto-generated method stub
		//writeMultiFile(request, response, list);				// 멀티파일
		
		File file = null;
		if( 1< list.size()) {
			// 임시폴더 체크
			String downName = "export.zip";//(String)((HashMap)list.get(0)).get("file_name") + ".zip";
			String tempPath = RequestMappingConstants.TOMCAT_PATH + RequestMappingConstants.TEMPORARY_FOLDER;
			
			// 파일 - 압축
			compress(list, tempPath, downName);
			
			Map<String, Object> mapReceiver = new HashMap<String, Object>();
   			mapReceiver.put("FILE_NAME",downName);
   			mapReceiver.put("SAVE_NAME",tempPath+downName);
   			list.add(mapReceiver);
   			
			// 파일 - 헤더
			file = new File(tempPath + downName);
			response.setContentType("application/x-msdownload; charset=utf-8");
		    response.setContentLength((int)file.length());
		    response.setHeader("Content-Transfer-Encoding", "binary");
		    response.setHeader("Content-Disposition", "attachment;fileName=\"" + downName + "\";");
		}else {
			HashMap<String, String> newData = (HashMap)list.get(0);
			String fileName = (String)newData.get("FILE_NAME"); //원본파일명
			String downName = (String)newData.get("SAVE_NAME");
			// 파일 - 헤더
			file = new File(downName);
			response.setContentType("application/x-msdownload; charset=utf-8");
		    response.setContentLength((int)file.length());
		    response.setHeader("Content-Transfer-Encoding", "binary");
		    response.setHeader("Content-Disposition", "attachment;fileName=\"" + fileName + "\";");
		}
		
		
		// 파일 - 헤더
		/*File file = new File(tempPath + downName);
		response.setContentType("application/x-msdownload; charset=utf-8");
	    response.setContentLength((int)file.length());
	    response.setHeader("Content-Transfer-Encoding", "binary");
	    response.setHeader("Content-Disposition", "attachment;fileName=\"" + downName + "\";");
*/
	    // 파일 - 전송
	    writeToClient(file, response);
	    
	    //파일 삭제
	    for (int i=0 ; i < list.size() ; i++)
        {
			HashMap<String, String> newData = (HashMap)list.get(i);
			
			logger.info("saveName::"+newData.get("SAVE_NAME"));
			logger.info("saveName::"+newData.get("FILE_NAME"));
            File delFile = new File(newData.get("SAVE_NAME"));
            
            if(delFile.delete()){
            	logger.info("파일삭제 성공");
    		}else{
    			logger.info("파일삭제 실패");
    		}
        }
	}

	////////////////////////////////////////////////////////////////////////////////////////////////
	// 싱글 파일
	private void writeSingleFile(HttpServletRequest request, HttpServletResponse response, Map map) throws IOException
	{
		// 파일 체크
	   	HashMap result = (HashMap)map;

    	String fileName = (String)result.get("file_name"); //원본파일명
		String saveName = (String)result.get("save_name"); // 저장파일명
		String savePath = (String)result.get("save_path");
		String downName = RequestMappingConstants.TOMCAT_PATH + RequestMappingConstants.UPLOAD_FOLDER + savePath + saveName; // 파일경로 / 최종경로
		// 파일 - 헤더
		File file = new File(downName);
		response.setContentType("application/x-msdownload; charset=utf-8");
	    response.setContentLength((int)file.length());
	    response.setHeader("Content-Transfer-Encoding", "binary");
	    response.setHeader("Content-Disposition", "attachment;fileName=\"" + fileName + "\";");

	    // 파일 - 전송
	    writeToClient(file, response);
	}

	////////////////////////////////////////////////////////////////////////////////////////////////
	// 멀티 파일
	public void writeMultiFile(HttpServletRequest request, HttpServletResponse response, List list) throws IOException
	{
		// 임시폴더 체크
		String downName = (String)((HashMap)list.get(0)).get("file_name") + ".zip";
		String tempPath = RequestMappingConstants.TOMCAT_PATH + RequestMappingConstants.TEMPORARY_FOLDER;

	    File cFile = new File(tempPath);
	    if(!cFile.isDirectory())
	    	cFile.mkdirs();

	    // 파일  체크
	    List<HashMap<String, String>> newList = new ArrayList<HashMap<String, String>>();
	    Iterator<HashMap<String, String>> iter = list.iterator();
		while (iter.hasNext()) {
			HashMap<String, String> oldData = iter.next();
	    	String fileName = (String)oldData.get("file_name");
			String saveName = (String)oldData.get("save_name");
			String savePath = (String)oldData.get("save_path");
			String fullName = RequestMappingConstants.TOMCAT_PATH + RequestMappingConstants.UPLOAD_FOLDER + savePath + saveName;

			HashMap<String, String> newData = new HashMap<String, String>();
			newData.put("FILE_NAME", fileName);
			newData.put("SAVE_NAME", fullName);

			newList.add(newData);
		}

		// 파일 - 압축
		compress(newList, tempPath, downName);

		// 파일 - 헤더
		File file = new File(tempPath + downName);
		response.setContentType("application/x-msdownload; charset=utf-8");
	    response.setContentLength((int)file.length());
	    response.setHeader("Content-Transfer-Encoding", "binary");
	    response.setHeader("Content-Disposition", "attachment;fileName=\"" + downName + "\";");

	    // 파일 - 전송
	    writeToClient(file, response);
	}

	////////////////////////////////////////////////////////////////////////////////////////////////
	// 파일 - 전송
	public void writeToClient(File file, HttpServletResponse response) throws IOException
	{
		OutputStream out = response.getOutputStream();
		FileInputStream fis = null;
		
		try
		{
			fis = new FileInputStream(file);
			FileCopyUtils.copy(fis, out);
		}
		catch (IOException e)
		{
			logger.error("파일 다운로드 실패");
		}
		finally
		{
			if (fis != null) {
				try {
					fis.close();
					out.close();
				} catch (IOException ignore) {
					logger.info("ignore");
				}
			}
		}
		
		
		/* buffer사용 코드*/
       /* byte[] data = new byte[1024*1024];
        
        BufferedInputStream fis = null;
        BufferedOutputStream fos = null;
        FileInputStream fi = null;
    	try {
    		fi = new FileInputStream(file);
    		fis = new BufferedInputStream(fi);
    		fos =new BufferedOutputStream(response.getOutputStream());
    		int count =0;
	        while((count = fis.read(data)) != -1) {
	        	fos.write(data);
	        }
    	}catch (IOException e) {
    		System.out.println("error가 발생하였습니다.");
	    }catch (Exception e) {
	    	System.out.println("error가 발생하였습니다.");
	    }finally{
	    	if(fi != null) fi.close();
	    	if (fis != null) fis.close();
	    	if (fos != null) fos.close();
	    }*/
	}

	////////////////////////////////////////////////////////////////////////////////////////////////
	// 파일 - 압축
	public void compress(List files, String zipFilePath, String zipFileName) throws IOException
	{
		int read;
        byte[] buffer = new byte[BUFF_SIZE];
        ZipOutputStream zos = null;

        try
        {
        	zos = new ZipOutputStream(new FileOutputStream(zipFilePath + zipFileName), java.nio.charset.Charset.forName("EUC-KR"));

            for (int i=0 ; i < files.size() ; i++)
            {
    			HashMap<String, String> newData = (HashMap)files.get(i);

                FileInputStream in = new FileInputStream(newData.get("SAVE_NAME"));

                Path p = Paths.get(newData.get("FILE_NAME"));
                String fileName = p.getFileName().toString();

                ZipEntry ze = new ZipEntry(fileName);
                zos.putNextEntry(ze);
                try
        	    {
                	while ((read = in.read(buffer)) > 0) {
                    	zos.write(buffer, 0, read);
                    }

        	    }
                catch( IOException e)
        	    {
                	logger.error("오류입니다.");
        	    }
        	    finally {
        	    	 zos.closeEntry();
                     in.close();
        	    }
            }
        } catch (IOException e) {
        	logger.error("파일 압축 실패");
        }
		finally
		{
			if (zos != null) {
				try {
					zos.close();
				} catch (IOException ignore) {
					logger.info("ignore");
				}
			}
		}
	}

	public List decompres(String unZipFileName, String unZipFilePath) throws IOException
	{
		List result = new ArrayList<String>();

	    int len;
		byte[] buffer = new byte[8096];
		File destDir = new File(unZipFilePath);

		ZipInputStream zis = new ZipInputStream(new FileInputStream(unZipFileName),  java.nio.charset.Charset.forName("EUC-KR"));

		ZipEntry zipEntry = zis.getNextEntry();
		try {
			while (zipEntry != null) {
			    File newFile = newFile(destDir, zipEntry);
			    if(newFile != null)
			    	result.add(newFile.getAbsoluteFile().toString());

			    FileOutputStream fos = new FileOutputStream(newFile);
			    try {
			    	while ((len = zis.read(buffer)) > 0) {
				        fos.write(buffer, 0, len);
				    }
			    	zipEntry = zis.getNextEntry();
			    }catch( IOException e)
			    {
		        	logger.error("오류입니다.");
			    }finally{
			    	fos.close();
				}
			}
		}catch( IOException e)
	    {
        	logger.error("오류입니다.");
	    }finally{
			zis.closeEntry();
			zis.close();
		}
		return result;
	}

    private static File newFile(File destinationDir, ZipEntry zipEntry) throws IOException {
        File destFile = new File(destinationDir, zipEntry.getName());

        String destDirPath = destinationDir.getCanonicalPath();
        String destFilePath = destFile.getCanonicalPath();

        if (!destFilePath.startsWith(destDirPath + File.separator)) {
            throw new IOException("Entry is outside of the target dir: " + zipEntry.getName());
        }

        return destFile;
    }

    
    //My데이터 -shp업로드 및 주소변환 전체페이지 조회
    @Override
	public List selDataListPageCnt(Map vo) throws SQLException {
		// TODO Auto-generated method stub
		return fileDAO.selDataListPageCnt(vo);
	}

	@Override
	public List selDataList(Map vo) throws SQLException {
		// TODO Auto-generated method stub
		return fileDAO.selDataList(vo);
	}

	//Mydata 등록
	@Override
	public int insMyData(Map vo) throws SQLException {
		// TODO Auto-generated method stub
		String shareNo = "";
		shareNo = fileDAO.insMyData(vo);
		int result = 1;
		vo.put("trget_no", shareNo);
		String sareList = (String) vo.get("shareList");
		if(!"".equals(sareList)) {
			if(sareList.indexOf(",") == -1) {
				vo.put("shareUser", sareList);
				result = fileDAO.insShare(vo);				//성공 시 1 실패 시 0 반환
				logger.info("result ::"+result);
			}else {
				String[] shareArr = sareList.split(",");
	   			for (int i = 0; i  < shareArr.length; i++) {
	   				vo.put("shareUser", shareArr[i]);
	   				result = fileDAO.insShare(vo);			//성공 시 1 실패 시 0 반환
	   				logger.info("result ::"+result);
	   			}
			}
   		}
		return result;  
	}
	
	//Mydata 삭제
	@Override
	public int delMyData(HashMap vo) throws SQLException {
		
		String groupNo = vo.get("fileGrp").toString();
		
		List list = fileDAO.selectFileByNo(groupNo);
		
		// 임시폴더 체크
		String downName = (String)((HashMap)list.get(0)).get("file_name") + ".zip";
		
		String jsonFileNm = RequestMappingConstants.TOMCAT_PATH + RequestMappingConstants.UPLOAD_FOLDER + vo.get("path").toString();
		
		File delJsonFile = new File(jsonFileNm);
		if(delJsonFile.delete()){
			logger.info("파일삭제 성공");
		}else{
			logger.info("파일삭제 실패");
		}
		
		
		// 파일  체크  
	    List<HashMap<String, String>> newList = new ArrayList<HashMap<String, String>>();
		Iterator<HashMap<String, String>> iter = list.iterator();
		while (iter.hasNext()) {
			HashMap<String, String> rowData = iter.next();
	    	//String fileName = (String)rowData.get("file_name");
			String saveName = (String)rowData.get("save_name");
			String savePath = (String)rowData.get("save_path");
			String fullName = RequestMappingConstants.TOMCAT_PATH + RequestMappingConstants.UPLOAD_FOLDER + savePath + saveName;
			
			File delFile = new File(fullName);
			if(delFile.delete()){
				logger.info("파일삭제 성공");
			}else{
				logger.info("파일삭제 실패");
			}
			
		}
		int result = fileDAO.delFile(vo);
		
		if(result != 0 ) {
			result = fileDAO.delShare(vo);
			result = fileDAO.delMyData(vo);
		} 
		return result;
	}

	//마이데이터 - 개별 공유하기 
	@Override
	public int insShare(Map vo) throws SQLException {
		// TODO Auto-generated method stub
		int result = 1;
		String sareList = (String) vo.get("shareList");
		if(!"".equals(sareList)) {
			if(sareList.indexOf(",") == -1) {
				vo.put("shareUser", sareList);
				result = fileDAO.insShare(vo);				//성공 시 1 실패 시 0 반환
				logger.info("result ::"+result);
			}else {
				String[] shareArr = sareList.split(",");
	   			for (int i = 0; i  < shareArr.length; i++) {
	   				vo.put("shareUser", shareArr[i]);
	   				result = fileDAO.insShare(vo);			//성공 시 1 실패 시 0 반환
	   				logger.info("result ::"+result);
	   			}
			}
   		}
		return result;
	}
	
	//MyMap - 전체페이지 조회
	@Override
	public List selMyMapListPageCnt(Map vo) throws SQLException {
		return fileDAO.selMyMapListPageCnt(vo);
	}

	//MyMap 조회
	@Override
	public List selMyMapList(Map vo) throws SQLException {
		// TODO Auto-generated method stub
		return fileDAO.selMyMapList(vo);
	}
	
	//MyMap 레이어 정보 조회
	@Override
	public List selByLayerInfo(Map vo) throws SQLException {
		// TODO Auto-generated method stub
		return fileDAO.selByLayerInfo(vo);
	}

	//MyMap 등록
	@Override
	public int insMyMap(HashMap vo) throws SQLException {
		// TODO Auto-generated method stub
		int result = 1;
		String mapNo = "";
		mapNo = fileDAO.insMyMap(vo);
		vo.put("trget_no", mapNo);
		
		String layerList = (String) vo.get("layerList");
		String sareList = (String) vo.get("shareList");
		
		if(layerList.indexOf(",") == -1) {
			vo.put("layerNo", layerList);
			result = fileDAO.insMyMapMapping(vo);
		}else {
			String[] layerArr = layerList.split(",");
   			for (int i = 0; i  < layerArr.length; i++) {
   				vo.put("layerNo", layerArr[i]);
   				result = fileDAO.insMyMapMapping(vo);
   			}
		}
		
		if(result == 1 && !"".equals(sareList)) {   //성공 시 1 실패 시 0 반환
			if(sareList.indexOf(",") == -1) {
				vo.put("shareUser", sareList);
				result = fileDAO.insShare(vo);
				logger.info("result ::"+result);
			}else {
				String[] shareArr = sareList.split(",");
	   			for (int i = 0; i  < shareArr.length; i++) {
	   				vo.put("shareUser", shareArr[i]);
	   				result = fileDAO.insShare(vo);
	   				logger.info("result ::"+result);
	   			}
			}
		}
		
		return result;
	}

	//MyMap 삭제
	@Override
	public int delMyMap(HashMap vo) throws SQLException {
		int result = fileDAO.delMyMapMapping(vo);
		
		if(result != 0 ) {
			result = fileDAO.delShare(vo);
			result = fileDAO.delMyMap(vo);
		} 
		return result;
	}
	
    

}
