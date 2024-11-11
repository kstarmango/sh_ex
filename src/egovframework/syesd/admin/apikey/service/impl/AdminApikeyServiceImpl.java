package egovframework.syesd.admin.apikey.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.syesd.admin.apikey.service.AdminApikeyService;

@Service("adminApikeyService")
public class AdminApikeyServiceImpl extends AbstractServiceImpl implements AdminApikeyService {

	@Resource(name="adminApikeyDAO")
	private AdminApikeyDAO adminApikeyDAO;
	
	public List selectApikeyInfos(HashMap vo) throws SQLException {
		return adminApikeyDAO.selectApikeyInfos(vo);
	}

	public int selectApikeyInfosCount(HashMap vo) throws SQLException {
		return adminApikeyDAO.selectApikeyInfosCount(vo);
	}

	public Map selectApikeyInfoDetail(HashMap vo) throws SQLException {
		return adminApikeyDAO.selectApikeyInfoDetail(vo);
	}

	public int updateApikey(HashMap vo) throws SQLException {
		adminApikeyDAO.insertBackupApikeyById(vo);
		return adminApikeyDAO.updateApikey(vo);
	}

	public int insertUserInfo(HashMap vo) throws SQLException {
		return adminApikeyDAO.insertUserInfo(vo);
	}
	
	public int insertApikey(HashMap vo) throws SQLException {
		return adminApikeyDAO.insertApikey(vo); 
	}

}
