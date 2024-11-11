package egovframework.syesd.cmmn.file.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.zaol.common.OracleDAO;

@Repository("fileDAO")
public class FileDAO  extends OracleDAO {

	public List selectFileByNo(String groupNo) throws SQLException { return list("file.selectFileByNo" , groupNo); }
	public String insertFile(Map vo) throws SQLException { return (String)insert("file.insertFile" , vo); }
	public int updateFile(Map vo) throws SQLException { return update("file.updateFile" , vo); }
	
	
	//My데이터 -shp업로드 및 주소변환 전체페이지 조회
	public List selDataListPageCnt(Map vo) throws SQLException { return list("file.selDataListPageCnt" , vo); }
	public List selDataList(Map vo) throws SQLException { return list("file.selDataList" , vo); }
	public String insMyData(Map vo) throws SQLException { return (String) insert("file.insMyData" , vo); }
	public int insShare(Map vo) throws SQLException { return (int) update("file.insShare" , vo); }
	public int delShare(Map vo) throws SQLException { return (int) update("file.delShare" , vo); }
	public int delMyData(Map vo) throws SQLException { return (int) update("file.delMyData" , vo); }	//마이테이터 삭제
	public int delFile(Map vo) throws SQLException { return (int) update("file.delFile" , vo); }		//파일삭제
	
	//MyMap - 전체페이지 조회
	public List selMyMapListPageCnt(Map vo) throws SQLException { return list("file.selMyMapListPageCnt" , vo); }
	//MyMap 조회
	public List selMyMapList(Map vo) throws SQLException { return list("file.selMyMapList" , vo); }
	//MyMap 레이어 정보 조회
	public List selByLayerInfo(Map vo) throws SQLException { return list("file.selByLayerInfo" , vo); }
	//MyMap 등록
	public String insMyMap(HashMap vo) throws SQLException { return (String) insert("file.insMyMap" , vo); }
	//MyMap 매핑 등록
	public int insMyMapMapping(HashMap vo)	throws SQLException { return (Integer)update("file.insMyMapMapping", vo);}
	//MyMap 삭제
	public int delMyMap(HashMap vo) throws SQLException {return (Integer)delete("file.delMyMap", vo);};
	//MyMap 매핑 삭제
	public int delMyMapMapping(HashMap vo)	throws SQLException { return (Integer)update("file.delMyMapMapping", vo);}
}
