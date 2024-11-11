package egovframework.syesd.admin.table.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.zaol.common.OracleDAO;

@Repository("adminTableDAO")
public class AdminTableDAO  extends OracleDAO {

	public List    selectTableCommentList(HashMap vo) 	  throws SQLException { return list("admin.table.selectTableCommentList" , vo); }
	public int     updateTableComment(HashMap vo) 	  throws SQLException { return update("admin.table.updateTableComment" , vo); }
	
	public List    selectColumnCommentList(HashMap vo) 	  throws SQLException { return list("admin.table.selectColumnCommentList" , vo); }
	public int     updateColumnComment(HashMap vo) 	  throws SQLException { return update("admin.table.updateColumnComment" , vo); }

	public List    selectTableSpaceList() 	  throws SQLException { return list("admin.table.selectTableSpaceList" ,  null); }

}
