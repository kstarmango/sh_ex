package egovframework.syesd.admin.user.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.syesd.admin.user.service.AdminUserService;

@Service("adminUserService")
public class AdminUserServiceImpl  extends AbstractServiceImpl implements AdminUserService {

	@Resource(name="adminUserDAO")
	private AdminUserDAO adminUserDAO;

	public List selectUserInfos(HashMap vo) throws SQLException {
		return adminUserDAO.selectUserInfos(vo);
	}

	public int selectUserInfosCount(HashMap vo) throws SQLException {
		return adminUserDAO.selectUserInfosCount(vo);
	}

	public Map selectUserInfoDetail(HashMap vo) throws SQLException {
		return adminUserDAO.selectUserInfoDetail(vo);
	}

	public int updateUserInfoChange(HashMap vo) throws SQLException {
		adminUserDAO.insertUserInfoBackupByUserId(vo);
		return adminUserDAO.updateUserInfoChange(vo);
	}

	public int updateUserPwdChange(HashMap vo) throws SQLException {
		adminUserDAO.insertUserInfoBackupByUserId(vo);
		return adminUserDAO.updateUserPwdChange(vo);
	}

	public List selectUserLoginHistory(HashMap vo) throws SQLException {
		return adminUserDAO.selectUserLoginHistory(vo);
	}
	
	@Override
	public List selectUserLoginHistoryExcel(HashMap vo) throws SQLException {
		return adminUserDAO.selectUserLoginHistoryExcel(vo);
	}

	public int selectUserLoginHistoryCount(HashMap vo) throws SQLException {
		return adminUserDAO.selectUserLoginHistoryCount(vo);
	}

	public List selectUserAuditHistory(HashMap vo) throws SQLException {
		return adminUserDAO.selectUserAuditHistory(vo);
	}

	public int selectUserAuditHistoryCount(HashMap vo) throws SQLException {
		return adminUserDAO.selectUserAuditHistoryCount(vo);
	}

	

}