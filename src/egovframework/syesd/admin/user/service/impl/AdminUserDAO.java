package egovframework.syesd.admin.user.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.zaol.common.OracleDAO;

@Repository("adminUserDAO")
public class AdminUserDAO  extends OracleDAO {

	public List selectUserInfos(HashMap vo) throws SQLException { return list("admin.user.selectUserInfos" , vo); }
	public int  selectUserInfosCount(HashMap vo) throws SQLException { return (Integer)selectByPk("admin.user.selectUserInfosCount" , vo); }
	public Map  selectUserInfoDetail(HashMap vo) throws SQLException { return (Map)selectByPk("admin.user.selectUserInfoDetail" , vo); }
	
	public int  updateUserInfoChange(HashMap vo) throws SQLException { return (Integer)update("admin.user.updateUserInfoChange" , vo); }
	public int  updateUserPwdChange(HashMap vo) throws SQLException { return (Integer)update("admin.user.updateUserPwdChange" , vo); }
	
	public List selectUserLoginHistory(HashMap vo) throws SQLException { return list("admin.user.selectUserLoginHistory" , vo); }
	public List selectUserLoginHistoryExcel(HashMap vo) throws SQLException { return list("admin.user.selectUserLoginHistoryExcel" , vo); }
	
	public int  selectUserLoginHistoryCount(HashMap vo) throws SQLException { return (Integer)selectByPk("admin.user.selectUserLoginHistoryCount" , vo); }

	public List selectUserAuditHistory(HashMap vo) throws SQLException { return list("admin.user.selectUserAuditHistory" , vo); }
	public int  selectUserAuditHistoryCount(HashMap vo) throws SQLException { return (Integer)selectByPk("admin.user.selectUserAuditHistoryCount" , vo); }
	
	public String insertUserInfoBackupByUserId(HashMap vo) throws SQLException { return (String)insert("admin.user.insertUserInfoBackupByUserId" , vo); }
	
}
