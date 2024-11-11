package egovframework.syesd.cmmn.menu.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface MenuService {

	public List selectTopMenuInfo(HashMap vo) throws SQLException;
	public List selectLeftMenuInfo(HashMap vo) throws SQLException;
	
	public List selectSubMenuInfo(HashMap vo) throws SQLException;
	public String selectFirstMoveMenuInfo(HashMap vo) throws SQLException;
	
	public String checkIsAuthMenu(HashMap vo) throws SQLException;
	public Map selectPortalMenuNm(HashMap vo) throws SQLException;
	public Map selectAdminMenuNm(HashMap vo) throws SQLException;	
	
}
