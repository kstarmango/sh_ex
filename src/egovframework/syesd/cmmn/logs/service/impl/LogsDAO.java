package egovframework.syesd.cmmn.logs.service.impl;

import java.sql.SQLException;
import java.util.HashMap;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;

import egovframework.zaol.common.OracleDAO;

@Repository("logsDAO")
public final class LogsDAO  extends OracleDAO {

	public String insertUserProgrmLogs(HashMap vo)  	  	throws SQLException { return (String)insert("logs.insertUserProgrmLogs" , vo); }
	public String insertUserLayerLogs(HashMap vo)   	  	throws SQLException { return (String)insert("logs.insertUserLayerLogs" , vo); }
	public String insertUserDataLogs(HashMap vo)   	  		throws SQLException { return (String)insert("logs.insertUserDataLogs" , vo); }
	public String insertUserDownloadLogs(HashMap vo)   	  	throws SQLException { return (String)insert("logs.insertUserDownloadLogs" , vo); }
	public String insertUserCommentLogs(HashMap vo)  		throws SQLException { return (String)insert("logs.insertUserCommentLogs" , vo); }
	public String insertBackupTableCommentLogs(HashMap vo)  throws SQLException { return (String)insert("logs.insertBackupTableCommentLogs" , vo); }
	public String insertBackupColumnCommentLogs(HashMap vo) throws SQLException { return (String)insert("logs.insertBackupColumnCommentLogs" , vo); }
	public String insertUserAuditLogs(HashMap vo)       	throws SQLException { return (String)insert("logs.insertUserAuditLogs" , vo); }

	public String insertUserLoginAttemptLogs(HashMap vo)  	throws SQLException { return (String)insert("logs.insertUserLoginAttemptLogs" , vo); }
	public String insertApiKeyLoginAttemptLogs(HashMap vo) 	throws SQLException { return (String)insert("logs.insertApiKeyLoginAttemptLogs" , vo); }

}
