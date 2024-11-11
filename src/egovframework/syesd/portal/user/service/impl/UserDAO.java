package egovframework.syesd.portal.user.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.zaol.common.OracleDAO;

@Repository("userDAO")
public final class UserDAO  extends OracleDAO {

	public String  checkExistUserId(HashMap vo)       throws SQLException { return (String) selectByPk("portal.user.checkExistUserId", vo); }
	public String  checkValidPassword(HashMap vo)     throws SQLException { return (String) selectByPk("portal.user.checkValidPassword", vo); }
	public String  checkResetPassword(HashMap vo)     throws SQLException { return (String) selectByPk("portal.user.checkResetPassword", vo); }
	public HashMap selectUserInfo(HashMap vo)         throws SQLException { return (HashMap) selectByPk("portal.user.selectUserInfo", vo); }

	public void    insertUserInfo(HashMap vo)		  throws SQLException { insert("portal.user.insertUserInfo", vo);}
	public List    selectUserIdsById(HashMap vo) 	  throws SQLException { return list("portal.user.selectUserIdsById" , vo); }


	public String  selectUserLoginAttempt(HashMap vo) throws SQLException { return (String) selectByPk("portal.user.selectUserLoginAttempt", vo); }
	public int     updateUserLoginAttempt(HashMap vo) throws SQLException { return update("portal.user.updateUserLoginAttempt", vo); }
	public int     updateUserLoginLock(HashMap vo)    throws SQLException { return update("portal.user.updateUserLoginLock", vo); }

	public String  checkExistApiKey(HashMap vo)       throws SQLException { return (String) selectByPk("portal.user.checkExistApiKey", vo); }
	public HashMap selectApiKeyInfo(HashMap vo)       throws SQLException { return (HashMap) selectByPk("portal.user.selectApiKeyInfo", vo); }
	
	// 02.28 sso 부서 업데이트 
	public int  userDeptUpdate(HashMap vo)       throws SQLException { return update("portal.user.userDeptUpdate", vo); }

}
