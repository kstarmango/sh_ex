package egovframework.syesd.cmmn.logs.service.impl;

import java.sql.SQLException;
import java.util.HashMap;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.syesd.cmmn.logs.service.LogsService;

@Service("logsService")
public class LogsServiceImpl extends AbstractServiceImpl implements LogsService {

	@Resource(name="logsDAO")
	private LogsDAO logsDAO;

	public String insertUserProgrmLogs(HashMap vo) throws SQLException {
		return logsDAO.insertUserProgrmLogs(vo);
	}

	public String insertUserLayerLogs(HashMap vo) throws SQLException {
		return logsDAO.insertUserLayerLogs(vo);
	}

	public String insertUserDataLogs(HashMap vo) throws SQLException {
		return logsDAO.insertUserDataLogs(vo);
	}

	public String insertUserDownloadLogs(HashMap vo)throws SQLException {
		return logsDAO.insertUserDownloadLogs(vo);
	}

	public String insertUserCommentLogs(HashMap vo) throws SQLException {
		return logsDAO.insertUserCommentLogs(vo);
	}

	public String insertBackupTableCommentLogs(HashMap vo) throws SQLException {
		return logsDAO.insertBackupTableCommentLogs(vo);
	}

	public String insertBackupColumnCommentLogs(HashMap vo) throws SQLException {
		return logsDAO.insertBackupColumnCommentLogs(vo);
	}

	public String insertUserAuditLogs(HashMap vo) throws SQLException {
		return logsDAO.insertUserAuditLogs(vo);
	}


	public String insertUserLoginAttemptLogs(HashMap vo) throws SQLException {
		return logsDAO.insertUserLoginAttemptLogs(vo);
	}

	public String insertApiKeyLoginAttemptLogs(HashMap vo) throws SQLException {
		return logsDAO.insertApiKeyLoginAttemptLogs(vo);
	}

}
