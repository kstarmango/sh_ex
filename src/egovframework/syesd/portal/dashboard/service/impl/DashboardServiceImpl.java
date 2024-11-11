package egovframework.syesd.portal.dashboard.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.syesd.cmmn.menu.service.MenuService;
import egovframework.syesd.portal.dashboard.service.DashboardService;

@Service("dashboardService")
public final class DashboardServiceImpl extends AbstractServiceImpl implements DashboardService {

	/* 현재 사용 X
	 * @Resource(name="dashboardDAO")
	private DashboardDAO dashboardDAO;

	@Override
	public List selectDashboardList() throws Exception {
		return dashboardDAO.selectDashboardList();
	}*/
	
}
