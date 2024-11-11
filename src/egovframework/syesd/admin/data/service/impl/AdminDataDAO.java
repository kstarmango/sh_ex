package egovframework.syesd.admin.data.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.zaol.common.OracleDAO;

@Repository("adminDataDAO")
public class AdminDataDAO  extends OracleDAO {

	public List  selectDataList(HashMap vo)				throws SQLException { return list("admin.data.selectDataList" , vo); }
	public int   selectDataListCount(HashMap vo) 		throws SQLException { return (Integer)selectByPk("admin.data.selectDataListCount" , vo); }
	
	public Map   selectDataDetail(HashMap vo) 			throws SQLException { return (Map)selectByPk("admin.data.selectDataDetail" , vo); }

	public int   updateDataToOriginalTable(HashMap vo) 	throws SQLException { return (Integer)update("admin.data.updateDataToOriginalTable" , vo); }
	public int   updateDataByReqNo(HashMap vo) 			throws SQLException { return (Integer)update("admin.data.updateDataByReqNo" , vo); }
	
}
