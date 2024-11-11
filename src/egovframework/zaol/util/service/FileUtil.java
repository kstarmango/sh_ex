package egovframework.zaol.util.service;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Component;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.zaol.common.Globals;
import egovframework.zaol.factual.service.FactualService;
import egovframework.zaol.factual.service.FactualVO;


@Component("fileUtil")
public class FileUtil {
	
	/**
	 * @uml.property  name="log"
	 * @uml.associationEnd  
	 */
	public Logger log = null;
	
	public static final int BUFF_SIZE = 2048;
	 /* service 구하기      */ @Resource(name = "factualService"   ) private   FactualService factualService;
	/**
     * 첨부로 등록된 파일을 서버에 업로드한다.
     * 기본경로에 지정
     * @param file
     * @return map
     * @throws Exception
     */
    public HashMap<String, String> uploadFile(MultipartFile file) throws Exception {

	HashMap<String, String> map = new HashMap<String, String>();
	//Write File 이후 Move File????
	String newName = "";
	String stordFilePath = Globals.FILE_STORE_PATH;//추후 프로퍼티파일에서 가져오도록 수정
	String dbFilePath = Globals.FILE_DB_PATH;
	
	
	String orginFileName = file.getOriginalFilename();

	int index = orginFileName.lastIndexOf(".");
	//String fileName = orginFileName.substring(0, _index);
	String fileExt = orginFileName.substring(index + 1);
	long size = file.getSize();

	//newName 은 Naming Convention에 의해서 생성
	//newName = EgovStringUtil.getTimeStamp() + "." + fileExt;
	newName = StringUtil.getTimeStamp() + "." + fileExt;
	writeFile(file, newName, stordFilePath);
	//storedFilePath는 지정
	
	map.put(Globals.ORIGIN_FILE_NM, orginFileName);
	map.put(Globals.UPLOAD_FILE_NM, newName);
	map.put(Globals.FILE_EXT, fileExt);
	map.put(Globals.FILE_PATH, stordFilePath);
	map.put(Globals.FILE_SIZE, String.valueOf(size));
	
	return map;
    }

    /**
     * 파일을 실제 물리적인 경로에 생성한다.
     * 저장할 경로 지정
     * @param file
     * @param newName 저장할 파일 이름
     * @param stordFilePath 저장할 파일 경로
     * @throws Exception
     */
    protected static void writeFile(MultipartFile file, String newName, String stordFilePath) throws Exception {
	InputStream stream = null;
	OutputStream bos = null;
	
	try {
	    stream = file.getInputStream();
	    File cFile = new File( stordFilePath );

	    if ( !cFile.isDirectory() )
		cFile.mkdir();

	    bos = new FileOutputStream( stordFilePath + File.separator + newName );

	    int bytesRead = 0;
	    byte[] buffer = new byte[BUFF_SIZE];

	    while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
		bos.write(buffer, 0, bytesRead);
	    }
	} catch (FileNotFoundException fnfe) {
	    fnfe.printStackTrace();
	} catch (IOException ioe) {
	    ioe.printStackTrace();
	} catch (Exception e) {
	    e.printStackTrace();
	} finally {
	    if (bos != null) {
		try {
		    bos.close();
		} catch (Exception ignore) {
		    //로그
		}
	    }
	    if (stream != null) {
		try {
		    stream.close();
		} catch (Exception ignore) {
		    //로그
		}
	    }
	}
    }
    /**
     * 사용자 파일 업로드.
     * @param file
     * @param stordFilePath
     * @return
     * @throws Exception
     */
    public HashMap< String, String > uploadFilesForCyberPR( MultipartFile file, String stordFilePath ) throws Exception {
    	
    	HashMap<String, String> map = new HashMap<String, String>();
    	String newName = "";
    	
    	String orginFileName = file.getOriginalFilename();
    	int index = orginFileName.lastIndexOf(".");
    	String fileExt = orginFileName.substring( index + 1 );
    	
    	//newName 은 Naming Convention에 의해서 생성
    	newName = StringUtil.getTimeStamp() + "." + fileExt;
    	writeFile( file, orginFileName, stordFilePath );
    	
    	map.put( "newName", orginFileName );
  	
    	return map;
    	
    }
    /**
     * 사용자 파일 업로드.
     * @param file
     * @param stordFilePath
     * @return
     * @throws Exception
     */
    public HashMap< String, String > uploadFilesForCyberPR( HashMap<String, String> map , MultipartFile file, int count, String stordFilePath ) throws Exception {
    	
    	String newName = "";
    	
    	String orginFileName = file.getOriginalFilename();
    	int index = orginFileName.lastIndexOf(".");
    	String fileExt = orginFileName.substring( index + 1 );
    	
    	//newName 은 Naming Convention에 의해서 생성
    	newName = StringUtil.getTimeStamp() + "." + fileExt;
    	writeFile( file, orginFileName, stordFilePath );
    	map.put( "newName"+count, orginFileName );
  	
    	return map;
    	
    }
   
    
    /**
     * 사용자 파일 업로드.
     * @param file
     * @param stordFilePath
     * @return
     * @throws Exception
     */
    public HashMap< String, String > uploadFilesForKor( MultipartFile file, String stordFilePath ) throws Exception {
    
    	HashMap<String, String> map = new HashMap<String, String>();
    	String newName = "";
    	
    	String orginFileName = file.getOriginalFilename();
    	int index = orginFileName.lastIndexOf(".");
    	String fileExt = orginFileName.substring( index + 1 );
    	long size = file.getSize();
    	
    	//newName 은 Naming Convention에 의해서 생성
    	//newName = EgovStringUtil.getTimeStamp() + "." + fileExt;
    	newName = StringUtil.getTimeStamp() + "." + fileExt;
    	writeFile( file, newName, stordFilePath );
    	
    	map.put( "orginFileName", orginFileName );
    	map.put( "newName", newName );
    	map.put( "fileExt", fileExt );
    	map.put( "stordFilePath", stordFilePath );
    	map.put( "size", String.valueOf(size) );
    	
    	return map;
    	
    }
        
    public HashMap< String, String > uploadEduMovFilesForKor( MultipartFile file, String stordFilePath ) throws Exception { 
    	
    	HashMap<String, String> map = new HashMap<String, String>();
    	
    	String orginFileName = file.getOriginalFilename();
   
    	writeFile( file, orginFileName, stordFilePath );
    	
    	map.put( "orginFileName", orginFileName );
    	
    	return map;
    }
    
    /**
     * 파일업로드 Globals 문자열 사용
     * @param file
     * @param stordFilePath
     * @return
     * @throws Exception
     */
    public HashMap< String, String > uploadFiles( MultipartFile file, String stordFilePath,int seq) throws Exception {
    	
    	HashMap<String, String> map = new HashMap<String, String>();
    	String newName = "";
    	
    	String orginFileName = file.getOriginalFilename();
    	int index = orginFileName.lastIndexOf(".");
    	String fileExt = orginFileName.substring( index + 1 );
    	long size = file.getSize();
    	
    	//newName 은 Naming Convention에 의해서 생성
    	//newName = EgovStringUtil.getTimeStamp() + "." + fileExt;
    	newName = StringUtil.getTimeStamp()+ seq + "." + fileExt;
    	writeFile( file, newName, stordFilePath );
    	
    	//log.info(orginFileName);
    	//log.info(newName);
    	
    	map.put(Globals.ORIGIN_FILE_NM, orginFileName);
    	map.put(Globals.UPLOAD_FILE_NM, newName);
    	map.put(Globals.FILE_EXT, fileExt);
    	map.put(Globals.FILE_PATH, stordFilePath);
    	map.put(Globals.FILE_SIZE, String.valueOf(size));
    	
    	return map;
    	
    }
    
    
    
    
    
    
    /**
     * 서버의 파일을 다운로드한다.
     * 
     * @param request
     * @param response
     * @throws Exception
     */
    public static void downFile(HttpServletRequest request, HttpServletResponse response) throws Exception {

	String downFileName = "";
	String orgFileName = "";

	if ((String)request.getAttribute("downFile") == null) {
	    downFileName = "";
	} else {
	    downFileName = (String)request.getAttribute("downFile");
	}

	if ((String)request.getAttribute("orgFileName") == null) {
	    orgFileName = "";
	} else {
	    orgFileName = (String)request.getAttribute("orginFile");
	}

	File file = new File(downFileName);

	if (!file.exists()) {
	    throw new FileNotFoundException(downFileName);
	}

	if (!file.isFile()) {
	    throw new FileNotFoundException(downFileName);
	}

	byte[] b = new byte[BUFF_SIZE]; //buffer size 2K.

	response.setContentType("application/x-msdownload");
	response.setHeader("Content-Disposition:", "attachment; filename=" + new String(orgFileName.getBytes(), "UTF-8"));
	response.setHeader("Content-Transfer-Encoding", "binary");
	response.setHeader("Pragma", "no-cache");
	response.setHeader("Expires", "0");

	BufferedInputStream fin = new BufferedInputStream(new FileInputStream(file));
	BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
	int read = 0;

	while ((read = fin.read(b)) != -1) {
	    outs.write(b, 0, read);
	}

	outs.close();
	fin.close();
    }
    
    
    /**
     * 서버 파일에 대하여 다운로드를 처리한다.
     * 
     * @param response
     * @param streFileNm
     *            : 파일저장 경로가 포함된 형태
     * @param orignFileNm
     * @throws Exception
     */
    public void downFile2(HttpServletRequest request, HttpServletResponse response, String gid) throws Exception {
    	
    	FactualVO factualVO = new FactualVO();
    	factualVO.setGid(gid);
    	List list = factualService.factualdata(factualVO);
    	HashMap result = ( HashMap )list.get(0);
    	String files_sav_name = (String)result.get("files_sav_name");
    	String files_org_name = (String)result.get("files_org_name");
    	String files_path = (String)result.get("files_path");
		String downFileName = files_path + Globals.CONTEXT_MARK + files_sav_name;
		String orgFileName = files_org_name;
	
		File file = new File(downFileName);
		response.setContentType("application/x-msdownload; charset=utf-8");
	    response.setContentLength((int)file.length());
	    response.setHeader("Content-Transfer-Encoding", "binary");
	    response.setHeader("Content-Disposition", "attachment;fileName=\""+orgFileName+"\";");
		    
		OutputStream out = response.getOutputStream();
		FileInputStream fis = null;
		
		try {
			fis = new FileInputStream(file);
			FileCopyUtils.copy(fis, out);
			System.out.println("fis : "+fis);
		} catch (java.io.IOException ioe) {
			ioe.printStackTrace();
		} finally {
			if (fis != null)
				fis.close();
		}
    }
    
    public void downFile3(HttpServletResponse response, String streFileNm, String orignFileNm) throws Exception {
		String downFileName = streFileNm;
		String orgFileName = orignFileNm;
		
		File file = new File(downFileName);
		response.setContentType("application/x-msdownload; charset=utf-8");
	    response.setContentLength((int)file.length());
	    response.setHeader("Content-Transfer-Encoding", "binary");
	    response.setHeader("Content-Disposition", "attachment;fileName=\""+orgFileName+"\";");
	    
		OutputStream out = response.getOutputStream();
		FileInputStream fis = null;
		try {
			fis = new FileInputStream(file);
			FileCopyUtils.copy(fis, out);
		} catch (java.io.IOException ioe) {
			ioe.printStackTrace();
		} finally {
			if (fis != null)
				fis.close();
		}
    }
    
    /**
     * 첨파일의 사이즈 적정 여부를 검사한다.
     * 
     * @param multiRequest
     * @param size
     * @return boolean          
     * @throws Exception
     */
    public static boolean fileSize(MultipartHttpServletRequest multiRequest, long size) throws Exception{
    	
    	Iterator fileIter = multiRequest.getFileNames();
    	while (fileIter.hasNext()) {
    		MultipartFile mFile = multiRequest.getFile((String)fileIter.next());
    		if(mFile.getSize() > size){
    			return false;
    		}
    	}
    	return true;
    }
    /**
	 * 브라우저 구분 얻기.
	 * 
	 * @param request
	 * @return
	 */
	public String getBrowser(HttpServletRequest request) {
		String header = request.getHeader("User-Agent");
		if (header.indexOf("MSIE") > -1) {
			return "MSIE";
		} else if (header.indexOf("Chrome") > -1) {
			return "Chrome";
		} else if (header.indexOf("Opera") > -1) {
			return "Opera";
		}
		return "Firefox";
	}

	/**
	 * Disposition 지정하기.
	 * 
	 * @param filename
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	public void setDisposition(String filename, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String browser = getBrowser(request);

		String dispositionPrefix = "attachment; filename=";
		String encodedFilename = null;

		if (browser.equals("MSIE")) {
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll(
					"\\+", "%20");
		} else if (browser.equals("Firefox")) {
			encodedFilename = "\""
					+ new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Opera")) {
			encodedFilename = "\""
					+ new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Chrome")) {
			StringBuffer sb = new StringBuffer();
			for (int i = 0; i < filename.length(); i++) {
				char c = filename.charAt(i);
				if (c > '~') {
					sb.append(URLEncoder.encode("" + c, "UTF-8"));
				} else {
					sb.append(c);
				}
			}
			encodedFilename = sb.toString();
		} else {
			// throw new RuntimeException("Not supported browser");
			throw new IOException("Not supported browser");
		}

		response.setHeader("Content-Disposition", dispositionPrefix
				+ encodedFilename);

		if ("Opera".equals(browser)) {
			response.setContentType("application/octet-stream;charset=UTF-8");
		}
	}
	
	 /**
     * 리스트에 파일 저장
     * @param files
     * @param mFile 
     * @param name 
     * @throws Exception
     */
	public void writeFileList(Iterator files, MultipartFile mFile,String name) throws Exception {
//		String name = mFile.getOriginalFilename();
		  String stordFilePath = Globals.KNOW_EDU_VIDEO_PATH;
		  
			InputStream stream = null;
			OutputStream bos = null;
			
			try {
			    stream = mFile.getInputStream();
			    File cFile = new File( stordFilePath );

			    if ( !cFile.isDirectory() )
				cFile.mkdir();

			    bos = new FileOutputStream( stordFilePath + File.separator + name );

			    int bytesRead = 0;
			    byte[] buffer = new byte[BUFF_SIZE];

			    while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
				bos.write(buffer, 0, bytesRead);
			    }
			} catch (FileNotFoundException fnfe) {
			    fnfe.printStackTrace();
			} catch (IOException ioe) {
			    ioe.printStackTrace();
			} catch (Exception e) {
			    e.printStackTrace();
			} finally {
			    if (bos != null) {
				try {
				    bos.close();
				} catch (Exception ignore) {
				    //로그
				}
			    }
			    if (stream != null) {
				try {
				    stream.close();
				} catch (Exception ignore) {
				    //로그
				}
			    }
			}
	}

	
	
	
	
	
	
}
