package egovframework.syesd.sso.user.service.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.tomato.com.logging.Logger;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.syesd.sso.user.service.SsoUserService;

@Service("ssoUserService")
public class SsoUserServiceImpl  extends AbstractServiceImpl implements SsoUserService {

	@Resource(name="ssoUserDAO")
	private SsoUserDAO ssoUserDAO;

	public Map selectUserInfo(HashMap vo) {
		Map<String, Object> returnData = new HashMap<String, Object>();
		try {
			returnData =  ssoUserDAO.selectUserInfo(vo);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			Logger.error("에러가 발생하였습니다.");
		}
		return returnData;
	}
}