package egovframework.syesd.admin.stats.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.zaol.common.OracleDAO;

@Repository("adminStatsDAO")
public class AdminStatsDAO  extends OracleDAO {

	/*그룹 리스트*/
	public List getmembergrp(HashMap vo) throws SQLException { return list("admin.stats.getmembergrp" , vo); }
	
	/*접속자 통계_header*/
	public List selectSearchThisYear() throws SQLException { return list("admin.stats.selectSearchThisYear" , null); }
	public List selectSearchThisMonth() throws SQLException { return list("admin.stats.selectSearchThisMonth" , null); }
	public List selectSearchThisDay(HashMap vo) throws SQLException { return list("admin.stats.selectSearchThisDay" , vo); }
	
	/*접속자 통계_data*/
	public List selectSearchData(HashMap vo) throws SQLException { return list("admin.stats.selectSearchData" , vo); }
	public List getUserDeptPercent(HashMap vo) throws SQLException { return list("admin.stats.getUserDeptPercent" , vo); }
	/*접속자 누계통계_부서 백분율*/
	public List getSumStatUserPercent(HashMap vo) throws SQLException { return list("admin.stats.getSumStatUserPercent" , vo); }
	
	/*메뉴별 통계*/
	public List selectUsesMenuStatics(HashMap vo) throws SQLException { return list("admin.stats.selectUsesMenuStatics" , vo); }
	public List getMenuDeptPercent(HashMap vo) throws SQLException { return list("admin.stats.getMenuDeptPercent" , vo); }
	
	/*메뉴별 누계통계*/
	public List selectSumUsesMenuStatics(HashMap vo) throws SQLException { return list("admin.stats.selectSumUsesMenuStatics" , vo); }
	public List getSumMenuDeptPercent(HashMap vo) throws SQLException { return list("admin.stats.getSumMenuDeptPercent" , vo); }
	
	/*레이어 통계*/
	public List selectUsesLayerStatics(HashMap vo) throws SQLException { return list("admin.stats.selectUsesLayerStatics" , vo); }
	public List getLayerDeptPercent(HashMap vo) throws SQLException { return list("admin.stats.getLayerDeptPercent" , vo); }
	
	/*레이어 통계*/
	public List selectSumUsesLayerStatics(HashMap vo) throws SQLException { return list("admin.stats.selectSumUsesLayerStatics" , vo); }
	public List getSumLayerDeptPercent(HashMap vo) throws SQLException { return list("admin.stats.getSumLayerDeptPercent" , vo); }

}
