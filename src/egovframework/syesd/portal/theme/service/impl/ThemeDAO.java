package egovframework.syesd.portal.theme.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.zaol.common.OracleDAO;

@Repository("themeDAO")
public final class ThemeDAO extends OracleDAO {

	/* 현재 사용 X
	 * public List selectThemeList(HashMap vo) throws Exception { return list("portal.theme.selectThemeList", vo); }
	public int selectThemeListCount(HashMap vo) throws Exception { return (Integer)selectByPk("portal.theme.selectThemeListCount", vo); } 
	
	public String insertThemeInfo(HashMap vo) throws Exception { return (String)insert("portal.theme.insertThemeInfo", vo); }
	public int insertThemeLayerMapng(HashMap vo) throws Exception { return (Integer)update("portal.theme.insertThemeLayerMapng", vo); }

	public Map selectThemeInfoDetail(HashMap vo) throws Exception { return (Map)selectByPk("portal.theme.selectThemeInfoDetail", vo); }
	public List selectThemeLayerList(HashMap vo) throws Exception { return list("portal.theme.selectThemeLayerList", vo); }
	
	public int updateThemeInfo(HashMap vo) throws Exception { return (Integer)update("portal.theme.updateThemeInfo", vo); }*/
	
}
