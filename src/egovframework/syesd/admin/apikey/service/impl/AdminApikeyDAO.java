package egovframework.syesd.admin.apikey.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.zaol.common.OracleDAO;

@Repository("adminApikeyDAO")
public class AdminApikeyDAO extends OracleDAO {
	
	public List selectApikeyInfos(HashMap vo) throws SQLException { return list("admin.apikey.selectApikeyInfos" , vo); }
	public int  selectApikeyInfosCount(HashMap vo) throws SQLException { return (Integer)selectByPk("admin.apikey.selectApikeyInfosCount" , vo); }
	public Map  selectApikeyInfoDetail(HashMap vo) throws SQLException { return (Map)selectByPk("admin.apikey.selectApikeyInfoDetail" , vo); }
	public int  updateApikey(HashMap vo) throws SQLException { return (Integer)update("admin.apikey.updateApikey" , vo); }
	public int  insertUserInfo(HashMap vo) throws SQLException { return (Integer)update("admin.apikey.insertUserInfo" , vo); }
	public int  insertApikey(HashMap vo) throws SQLException { return (Integer)update("admin.apikey.insertApikey" , vo); }
	
	public String insertBackupApikeyById(HashMap vo) throws SQLException { return (String)insert("admin.apikey.insertBackupApikeyById" , vo); }
	
}
