package egovframework.syesd.portal.theme.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.syesd.cmmn.file.service.impl.FileDAO;
import egovframework.syesd.cmmn.menu.service.MenuService;
import egovframework.syesd.portal.dashboard.service.DashboardService;
import egovframework.syesd.portal.theme.service.ThemeService;

@Service("themeService")
public final class ThemeServiceImpl extends AbstractServiceImpl implements ThemeService {

	/* 현재 사용 X
	 * @Resource(name="themeDAO")
	private ThemeDAO themeDAO;

	@Resource(name="fileDAO")
	private FileDAO fileDAO;
	
	@Override
	public List selectThemeList(HashMap vo) throws Exception {
		return themeDAO.selectThemeList(vo);
	}

	@Override
	public int selectThemeListCount(HashMap vo) throws Exception {
		return themeDAO.selectThemeListCount(vo);
	}

	@Override
	public String insertFile(Map vo) throws Exception {
		return fileDAO.insertFile(vo);
	}

	@Override
	public String insertThemeInfo(HashMap vo) throws Exception {
		return themeDAO.insertThemeInfo(vo);
	}

	@Override
	public int insertThemeLayerMapng(HashMap vo) throws Exception {
		return themeDAO.insertThemeLayerMapng(vo);
	}

	@Override
	public Map selectThemeInfoDetail(HashMap vo) throws Exception {
		return themeDAO.selectThemeInfoDetail(vo);
	}

	@Override
	public List selectThemeLayerList(HashMap vo) throws Exception {
		return themeDAO.selectThemeLayerList(vo);
	}

	@Override
	public int updateThemeInfo(HashMap vo) throws Exception {
		return themeDAO.updateThemeInfo(vo);
	}*/
	
}
