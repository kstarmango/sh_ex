package egovframework.syesd.admin.stats.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

public interface AdminStatsService {

	/*그룹*/
	public List getmembergrp(HashMap vo) throws SQLException;
	
	/*접속자 통계_header*/
	public List selectSearchThisYear() throws SQLException;
	public List selectSearchThisMonth() throws SQLException;
	public List selectSearchThisDay(HashMap vo) throws SQLException;
	/*접속자 통계_data*/
	public List selectSearchData(HashMap vo) throws SQLException;
	public List getUserDeptPercent(HashMap vo) throws SQLException;
	/*접속자 누계통계_부서 백분율*/
	public List getSumStatUserPercent(HashMap vo) throws SQLException;
	
	/*메뉴별 통계*/
	public List selectUsesMenuStatics(HashMap vo) throws SQLException;
	public List getMenuDeptPercent(HashMap vo) throws SQLException;
	
	/*메뉴별 누계통계*/
	public List selectSumUsesMenuStatics(HashMap vo) throws SQLException;
	public List getSumMenuDeptPercent(HashMap vo) throws SQLException;
	
	/*레이어 통계*/
	public List selectUsesLayerStatics(HashMap vo) throws SQLException;
	public List getLayerDeptPercent(HashMap vo) throws SQLException;
	
	/*레이어 누계통계*/
	public List selectSumUsesLayerStatics(HashMap vo) throws SQLException;
	public List getSumLayerDeptPercent(HashMap vo) throws SQLException;
	
}
