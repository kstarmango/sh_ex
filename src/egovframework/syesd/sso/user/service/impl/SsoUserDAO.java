package egovframework.syesd.sso.user.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.zaol.common.OracleDAO;
import egovframework.zaol.common.OracleSsoDAO;

@Repository("ssoUserDAO")
public final class SsoUserDAO  extends OracleSsoDAO {

	public Map selectUserInfo(HashMap vo)         throws SQLException { return (Map) selectByPk("sso.user.selectUserInfo", vo); }

}	
