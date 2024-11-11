package egovframework.syesd.admin.user.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface AdminUserService {

	public List selectUserInfos(HashMap vo) throws SQLException; 
	public int  selectUserInfosCount(HashMap vo) throws SQLException;
	public Map  selectUserInfoDetail(HashMap vo) throws SQLException;
	
	public int  updateUserInfoChange(HashMap vo) throws SQLException;
	public int  updateUserPwdChange(HashMap vo) throws SQLException;

	public List selectUserLoginHistory(HashMap vo) throws SQLException;
	public List selectUserLoginHistoryExcel(HashMap vo) throws SQLException;
	public int  selectUserLoginHistoryCount(HashMap vo) throws SQLException;

	public List selectUserAuditHistory(HashMap vo) throws SQLException;
	public int  selectUserAuditHistoryCount(HashMap vo) throws SQLException;
	
}
