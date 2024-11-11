package egovframework.syesd.admin.apikey.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface AdminApikeyService {

	public List selectApikeyInfos(HashMap vo) throws SQLException; 
	public int  selectApikeyInfosCount(HashMap vo) throws SQLException;
	public Map  selectApikeyInfoDetail(HashMap vo) throws SQLException;
	public int  updateApikey(HashMap vo) throws SQLException;
	public int  insertUserInfo(HashMap vo) throws SQLException;
	public int  insertApikey(HashMap vo) throws SQLException;
	
}
