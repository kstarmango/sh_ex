package egovframework.syesd.admin.stats.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.syesd.admin.stats.service.AdminStatsService;

@Service("adminStatsService")
public class AdminStatsServiceImpl  extends AbstractServiceImpl implements AdminStatsService {

	@Resource(name="adminStatsDAO")
	private AdminStatsDAO adminStatsDAO;

	/*그룹 리스트*/
	public List getmembergrp(HashMap vo) throws SQLException {
		return adminStatsDAO.getmembergrp(vo);
	}
	
	/*접속자 통계_header*/
	public List selectSearchThisYear() throws SQLException {
		return adminStatsDAO.selectSearchThisYear();
	}
	public List selectSearchThisMonth() throws SQLException {
		return adminStatsDAO.selectSearchThisMonth();
	}
	public List selectSearchThisDay(HashMap vo) throws SQLException {
		return adminStatsDAO.selectSearchThisDay(vo);
	}
	
	/*접속자 통계_data*/
	public List selectSearchData(HashMap vo) throws SQLException {
		return adminStatsDAO.selectSearchData(vo);
	}
	public List getUserDeptPercent(HashMap vo) throws SQLException {
		return adminStatsDAO.getUserDeptPercent(vo);
	}
	
	/*접속자 누계통계_부서 백분율*/
	public List getSumStatUserPercent(HashMap vo) throws SQLException {
		return adminStatsDAO.getSumStatUserPercent(vo);
	}
	
	/*메뉴별 통계*/
	public List selectUsesMenuStatics(HashMap vo) throws SQLException {
		return adminStatsDAO.selectUsesMenuStatics(vo);
	}
	public List getMenuDeptPercent(HashMap vo) throws SQLException {
		return adminStatsDAO.getMenuDeptPercent(vo);
	}
	
	/*메뉴별 누계통계*/
	public List selectSumUsesMenuStatics(HashMap vo) throws SQLException {
		return adminStatsDAO.selectSumUsesMenuStatics(vo);
	}
	public List getSumMenuDeptPercent(HashMap vo) throws SQLException {
		return adminStatsDAO.getSumMenuDeptPercent(vo);
	}
	
	/*레이어 통계*/
	public List selectUsesLayerStatics(HashMap vo) throws SQLException {
		return adminStatsDAO.selectUsesLayerStatics(vo);
	}
	public List getLayerDeptPercent(HashMap vo) throws SQLException {
		return adminStatsDAO.getLayerDeptPercent(vo);
	}
	
	/*레이어 누계통계*/
	public List selectSumUsesLayerStatics(HashMap vo) throws SQLException {
		return adminStatsDAO.selectSumUsesLayerStatics(vo);
	}
	public List getSumLayerDeptPercent(HashMap vo) throws SQLException {
		return adminStatsDAO.getSumLayerDeptPercent(vo);
	}
	
}
