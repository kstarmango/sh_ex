package egovframework.syesd.cmmn.logs.service;

import java.sql.SQLException;
import java.util.HashMap;

public interface LogsService {

	public String insertUserProgrmLogs(HashMap vo) throws SQLException;
	public String insertUserLayerLogs(HashMap vo) throws SQLException;
	public String insertUserDataLogs(HashMap vo) throws SQLException;
	public String insertUserDownloadLogs(HashMap vo) throws SQLException;
	public String insertUserCommentLogs(HashMap vo) throws SQLException;
	public String insertBackupTableCommentLogs(HashMap vo) throws SQLException;
	public String insertBackupColumnCommentLogs(HashMap vo) throws SQLException;
	public String insertUserAuditLogs(HashMap vo) throws SQLException;

	public String insertUserLoginAttemptLogs(HashMap vo) throws SQLException;
	public String insertApiKeyLoginAttemptLogs(HashMap vo) throws SQLException;

}
