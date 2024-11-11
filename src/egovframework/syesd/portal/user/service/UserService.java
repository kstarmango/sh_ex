package egovframework.syesd.portal.user.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

public interface UserService {

	public String checkExistUserId(HashMap vo) throws SQLException;
	public String checkValidPassword(HashMap vo) throws SQLException;
	public String checkReusePassword(HashMap vo) throws SQLException;
	public String checkResetPassword(HashMap vo) throws SQLException;
	public HashMap selectUserInfo(HashMap vo) throws SQLException;

	public void insertUserInfo(HashMap vo) throws SQLException;
	public List selectUserIdsById(HashMap vo) throws SQLException;

	public String selectUserLoginAttempt(HashMap vo) throws SQLException;
	public int updateUserLoginAttempt(HashMap vo) throws SQLException;
	public int updateUserLoginLock(HashMap vo) throws SQLException;

	public String checkExistApiKey(HashMap vo) throws SQLException;
	public HashMap selectApiKeyInfo(HashMap vo) throws SQLException;
	
	public int userDeptUpdate(HashMap vo) throws SQLException;

}
