package egovframework.syesd.admin.code.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.syesd.admin.code.service.AdminCodeService;

@Service("adminCodeService")
public class AdminCodeServiceImpl  extends AbstractServiceImpl implements AdminCodeService {

	@Resource(name="adminCodeDAO")
	private AdminCodeDAO adminCodeDAO;

	public List selectCodeGroupList(HashMap vo) throws SQLException {
		return adminCodeDAO.selectCodeGroupList(vo);
	}

	public List selectCodeListByGroupId(String vo) throws SQLException {
		return adminCodeDAO.selectCodeListByGroupId(vo);
	}

	@Override
	public void updateCode(HashMap vo) throws SQLException {
		adminCodeDAO.updateCode(vo);
		
	}

	@Override
	public String topcodesearch() throws SQLException {
		return adminCodeDAO.topcodesearch();
	}

	@Override
	public int ordersearch(HashMap vo) throws SQLException {
		return adminCodeDAO.ordersearch(vo);
	}

	@Override
	public List p_code_search(HashMap vo) throws SQLException {
		return adminCodeDAO.p_code_search(vo);
	}

	@Override
	public void orderAdd(HashMap vo) throws SQLException {
		adminCodeDAO.orderAdd(vo);
	}

	@Override
	public List editcodeorder(HashMap vo) throws SQLException {
		return adminCodeDAO.editcodeorder(vo);
	}

	@Override
	public int maxorder(HashMap vo) throws SQLException {
		return adminCodeDAO.maxorder(vo);
	}

	@Override
	public void codeorderedit(HashMap vo) throws SQLException {
		adminCodeDAO.codeorderedit(vo);
	}

	@Override
	public void codeDelete(HashMap vo) throws SQLException {
		adminCodeDAO.codeDelete(vo);
		
	}


}
