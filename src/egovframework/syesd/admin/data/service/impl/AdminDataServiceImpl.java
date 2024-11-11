package egovframework.syesd.admin.data.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.syesd.admin.data.service.AdminDataService;

@Service("adminDataService")
public class AdminDataServiceImpl extends AbstractServiceImpl implements AdminDataService {

	@Resource(name="adminDataDAO")
	private AdminDataDAO adminDataDAO;

	public List selectDataList(HashMap vo) throws SQLException {
		return adminDataDAO.selectDataList(vo);
	}

	public int selectDataListCount(HashMap vo) throws SQLException {
		return adminDataDAO.selectDataListCount(vo);
	}

	public Map selectDataDetail(HashMap vo) throws SQLException {
		return adminDataDAO.selectDataDetail(vo);
	}

	public int updateDataByReqNo(HashMap vo) throws SQLException {
		adminDataDAO.updateDataToOriginalTable(vo);
		return adminDataDAO.updateDataByReqNo(vo);
	}

}
