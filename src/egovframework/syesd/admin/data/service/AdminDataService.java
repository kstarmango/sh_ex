package egovframework.syesd.admin.data.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface AdminDataService {

	public List selectDataList(HashMap vo) throws SQLException;
	public int  selectDataListCount(HashMap vo) throws SQLException;
	
	public Map selectDataDetail(HashMap vo) throws SQLException;
	public int updateDataByReqNo(HashMap vo) throws SQLException;
	
}
