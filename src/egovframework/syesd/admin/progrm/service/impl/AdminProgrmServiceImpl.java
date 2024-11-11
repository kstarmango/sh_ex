package egovframework.syesd.admin.progrm.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.syesd.admin.progrm.service.AdminProgrmService;

@Service("adminProgrmService")
public class AdminProgrmServiceImpl extends AbstractServiceImpl implements AdminProgrmService {

	@Resource(name="adminProgrmDAO")
	private AdminProgrmDAO adminProgrmDAO;

	public List selectProgrmAuthList(HashMap vo) throws SQLException {
		return adminProgrmDAO.selectProgrmAuthList(vo);
	}

	public List selectProgrmAuthPagingList(HashMap vo) throws SQLException {
		return adminProgrmDAO.selectProgrmAuthPagingList(vo);
	}

	public int selectProgrmAuthPagingListCount(HashMap vo) throws SQLException {
		return adminProgrmDAO.selectProgrmAuthPagingListCount(vo);
	}
	
	public int updateProgrmAuth(HashMap vo) throws SQLException {
		return adminProgrmDAO.updateProgrmAuth(vo);
	}

	public String insertProgrmAuth(HashMap vo) throws SQLException {
		return adminProgrmDAO.insertProgrmAuth(vo);
	}

	
	public List selectProgrmListByAuthNo(HashMap vo) throws SQLException {
		return adminProgrmDAO.selectProgrmListByAuthNo(vo);
	}

	public int insertProgrmListByAuthNo(HashMap vo) throws SQLException {
		adminProgrmDAO.insertProgrmListBackupByAuthNo(vo);
		adminProgrmDAO.deleteProgrmListByAuthNo(vo);
		return adminProgrmDAO.insertProgrmListByAuthNo(vo);
	}

	public List selectProgrmList(HashMap vo) throws SQLException {
		return adminProgrmDAO.selectProgrmList(vo);
	}

	public int selectProgrmNumById(HashMap vo) throws SQLException {
		return adminProgrmDAO.selectProgrmNumById(vo);
	}
	
	
	
}
