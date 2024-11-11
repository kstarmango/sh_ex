package egovframework.syesd.admin.progrm.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface AdminProgrmService {

	public List selectProgrmAuthList(HashMap vo) throws SQLException;
	public List selectProgrmAuthPagingList(HashMap vo) throws SQLException;
	public int selectProgrmAuthPagingListCount(HashMap vo) throws SQLException;
	public int updateProgrmAuth(HashMap vo) throws SQLException;
	public String insertProgrmAuth(HashMap vo) throws SQLException;
	
	public List selectProgrmListByAuthNo(HashMap vo) throws SQLException;
	public int insertProgrmListByAuthNo(HashMap vo) throws SQLException;
	
	public List selectProgrmList(HashMap vo) throws SQLException;
	public int selectProgrmNumById(HashMap vo) throws SQLException;
	
}
