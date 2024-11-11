package egovframework.syesd.cmmn.file.service;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

public interface FileService {

	public String upload(final MultipartHttpServletRequest multiRequest) throws SQLException;
	public void download(HttpServletRequest request, HttpServletResponse response, String groupNo) throws SQLException, IOException;
	public List selectFileByNo(String groupNo) throws SQLException;
	public String insertFile(Map vo)  throws SQLException;
	public int updateFile(Map vo)  throws SQLException;

	public void writeToServer(MultipartFile file, String fileName, String savePath) throws SQLException;
	public void writeToClient(File file, HttpServletResponse response) throws IOException, FileNotFoundException;

	public void compress(List files, String zipFilePath, String zipFileName) throws IOException;
	public List decompres(String unZipFileName, String unZipFilePath) throws IOException;
	
	public void dataExportDownload(HttpServletRequest request, HttpServletResponse response, List list) throws SQLException, IOException;
	
	//My데이터 -shp업로드 및 주소변환 전체페이지 조회
	public List selDataListPageCnt(Map vo) throws SQLException;
	//마이데이터 관련
	public List selDataList(Map vo) throws SQLException;
	public int insMyData(Map vo) throws SQLException;
	public int delMyData(HashMap vo) throws SQLException;	//삭제
	//마이데이터 - 개별 공유하기 
	public int insShare(Map vo) throws SQLException;
	
	//마이맵 관련
	//MyMap - 전체페이지 조회
	public List selMyMapListPageCnt(Map vo) throws SQLException;
	public List selMyMapList(Map vo) throws SQLException;  //조회
	public List selByLayerInfo(Map vo) throws SQLException;  //레이어 정보 조회
	public int insMyMap(HashMap vo) throws SQLException;   //등록
	public int delMyMap(HashMap vo) throws SQLException;	//삭제
}
