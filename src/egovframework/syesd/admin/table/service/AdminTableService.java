package egovframework.syesd.admin.table.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

public interface AdminTableService {
	
	public List selectTableCommentList(HashMap vo) throws SQLException;
	public int updateTableComment(HashMap vo) throws SQLException;
	
	public List selectColumnCommentList(HashMap vo) throws SQLException;
	public int updateColumnComment(HashMap vo) throws SQLException;

	public List selectTableSpaceList() throws SQLException;

}
