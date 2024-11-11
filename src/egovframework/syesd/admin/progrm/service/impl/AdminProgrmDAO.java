package egovframework.syesd.admin.progrm.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.zaol.common.OracleDAO;

@Repository("adminProgrmDAO")
public class AdminProgrmDAO extends OracleDAO {

	public List selectProgrmAuthList(HashMap vo) throws SQLException { return list("admin.progrm.selectProgrmAuthList" , vo); }
	public List selectProgrmAuthPagingList(HashMap vo) throws SQLException { return list("admin.progrm.selectProgrmAuthPagingList" , vo); }
	public int selectProgrmAuthPagingListCount(HashMap vo) throws SQLException { return (Integer)selectByPk("admin.progrm.selectProgrmAuthPagingListCount" , vo); }
	public int updateProgrmAuth(HashMap vo) throws SQLException { return (Integer)update("admin.progrm.updateProgrmAuth" , vo); }
	public String insertProgrmAuth(HashMap vo) throws SQLException { return (String)insert("admin.progrm.insertProgrmAuth" , vo); }
	
	public List selectProgrmListByAuthNo(HashMap vo) throws SQLException { return list("admin.progrm.selectProgrmListByAuthNo" , vo); }
	public int insertProgrmListByAuthNo(HashMap vo) throws SQLException { return (Integer)update("admin.progrm.insertProgrmListByAuthNo" , vo); }
	public int deleteProgrmListByAuthNo(HashMap vo) throws SQLException { return (Integer)delete("admin.progrm.deleteProgrmListByAuthNo" , vo); }
	public String insertProgrmListBackupByAuthNo(HashMap vo) throws SQLException { return (String)insert("admin.progrm.insertProgrmListBackupByAuthNo" , vo); }
	
	public List selectProgrmList(HashMap vo) throws SQLException { return list("admin.progrm.selectProgrmList" , vo); }
	public int selectProgrmNumById(HashMap vo) throws SQLException { return (Integer)selectByPk("admin.progrm.selectProgrmNumById" , vo); }
	
}
