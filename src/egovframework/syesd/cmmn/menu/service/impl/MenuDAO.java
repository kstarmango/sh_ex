package egovframework.syesd.cmmn.menu.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.zaol.common.OracleDAO;

@Repository("menuDAO")
public final class MenuDAO extends OracleDAO {

	public List selectTopMenuInfo(HashMap vo) throws SQLException{ return list("menu.selectTopMenuInfo" , vo); }
	public List selectLeftMenuInfo(HashMap vo) throws SQLException{ return list("menu.selectLeftMenuInfo" , vo); }
	
	public List selectSubMenuInfo(HashMap vo) throws SQLException{ return list("menu.selectSubMenuInfo" , vo); }
	public String selectFirstMoveMenuInfo(HashMap vo) throws SQLException{ return (String) selectByPk("menu.selectFirstMoveMenuInfo" , vo); }
	
	public String checkIsAuthMenu(HashMap vo) throws SQLException{ return (String) selectByPk("menu.checkIsAuthMenu", vo); }
	public Map selectPortalMenuNm(HashMap vo) throws SQLException{ return (Map) selectByPk("menu.selectPortalMenuNm", vo); }
	public Map selectAdminMenuNm(HashMap vo) throws SQLException{ return (Map) selectByPk("menu.selectAdminMenuNm", vo); }
	
}
