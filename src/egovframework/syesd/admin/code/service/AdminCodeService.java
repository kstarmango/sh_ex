package egovframework.syesd.admin.code.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

public interface AdminCodeService {

	public List selectCodeGroupList(HashMap vo) throws SQLException; 
	public List selectCodeListByGroupId(String vo) throws SQLException;
	public void updateCode(HashMap vo) throws SQLException;
	public String topcodesearch() throws SQLException;
	public int ordersearch(HashMap vo) throws SQLException;
	public List p_code_search(HashMap vo) throws SQLException;
	public void orderAdd(HashMap vo) throws SQLException;
	public List editcodeorder(HashMap vo) throws SQLException;
	public int maxorder(HashMap vo) throws SQLException;
	public void codeorderedit(HashMap vo) throws SQLException;
	public void codeDelete(HashMap vo) throws SQLException;
	
	
	
	
	
	
	
	
}
