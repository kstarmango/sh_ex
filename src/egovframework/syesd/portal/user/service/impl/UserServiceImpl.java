package egovframework.syesd.portal.user.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.syesd.portal.user.service.UserService;

@Service("userService")
public class UserServiceImpl  extends AbstractServiceImpl implements UserService {
	@Resource(name="userDAO")
	private UserDAO userDAO;

	public String checkExistUserId(HashMap vo) throws SQLException{
		return userDAO.checkExistUserId(vo);
	}

	/* 로그인시 */
	public String checkValidPassword(HashMap vo)throws SQLException{
		return userDAO.checkValidPassword(vo);
	}

	/* 패스워드 변경시 */
	public String checkReusePassword(HashMap vo)throws SQLException{
		return userDAO.checkValidPassword(vo);
	}

	public String checkResetPassword(HashMap vo)throws SQLException{
		return userDAO.checkResetPassword(vo);
	}

	public HashMap selectUserInfo(HashMap vo)throws SQLException{
		return userDAO.selectUserInfo(vo);
	}


	public void insertUserInfo(HashMap vo)throws SQLException{
		userDAO.insertUserInfo(vo);
	}

	public List selectUserIdsById(HashMap vo)throws SQLException{
		return userDAO.selectUserIdsById(vo);
	}


	public String selectUserLoginAttempt(HashMap vo)throws SQLException{
		return userDAO.selectUserLoginAttempt(vo);
	}

	public int updateUserLoginAttempt(HashMap vo)throws SQLException{
		return userDAO.updateUserLoginAttempt(vo);
	}

	public int updateUserLoginLock(HashMap vo)throws SQLException{
		return userDAO.updateUserLoginLock(vo);
	}


	public String checkExistApiKey(HashMap vo)throws SQLException{
		return userDAO.checkExistApiKey(vo);
	}

	public HashMap selectApiKeyInfo(HashMap vo)throws SQLException{
		return userDAO.selectApiKeyInfo(vo);
	}

	@Override
	public int userDeptUpdate(HashMap vo)throws SQLException{
		
		return userDAO.userDeptUpdate(vo);
	}

}