package egovframework.syesd.cmmn.menu.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.syesd.cmmn.menu.service.MenuService;

@Service("menuService")
public final class MeusServiceImpl extends AbstractServiceImpl implements MenuService {

	@Resource(name="menuDAO")
	private MenuDAO menuDAO;
	
	public List selectTopMenuInfo(HashMap vo) throws SQLException {
		return menuDAO.selectTopMenuInfo(vo);
	}
	
	public List selectLeftMenuInfo(HashMap vo) throws SQLException {
		return menuDAO.selectLeftMenuInfo(vo);
	}

	public List selectSubMenuInfo(HashMap vo) throws SQLException {
		return menuDAO.selectSubMenuInfo(vo);
	}

	public String selectFirstMoveMenuInfo(HashMap vo) throws SQLException {
		return menuDAO.selectFirstMoveMenuInfo(vo);
	}
	
	public String checkIsAuthMenu(HashMap vo) throws SQLException {
		return menuDAO.checkIsAuthMenu(vo);
	}

	public Map selectPortalMenuNm(HashMap vo) throws SQLException {
		return menuDAO.selectPortalMenuNm(vo);
	}

	public Map selectAdminMenuNm(HashMap vo) throws SQLException {
		return menuDAO.selectAdminMenuNm(vo);
	}


	
}
