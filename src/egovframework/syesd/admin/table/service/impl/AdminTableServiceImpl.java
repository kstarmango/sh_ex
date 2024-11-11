package egovframework.syesd.admin.table.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.syesd.admin.table.service.AdminTableService;

@Service("adminTableService")
public class AdminTableServiceImpl  extends AbstractServiceImpl implements AdminTableService {

	@Resource(name="adminTableDAO")
	private AdminTableDAO adminTableDAO;

	public List selectTableCommentList(HashMap vo) throws SQLException {
		return adminTableDAO.selectTableCommentList(vo);
	}

	public int updateTableComment(HashMap vo) throws SQLException {
		return adminTableDAO.updateTableComment(vo);
	}
	
	public List selectColumnCommentList(HashMap vo) throws SQLException {
		return adminTableDAO.selectColumnCommentList(vo);
	}

	public int updateColumnComment(HashMap vo) throws SQLException {
		return adminTableDAO.updateColumnComment(vo);
	}

	public List selectTableSpaceList() throws SQLException {
		return adminTableDAO.selectTableSpaceList();
	}
	
}
