package egovframework.mango.analysis.quest.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;

import egovframework.mango.analysis.quest.service.AnalysisQuestServiceData;
import egovframework.rte.fdl.cmmn.AbstractServiceImpl;

@Service("analysisQuestServiceImpl")
public class AnalysisQuestServiceImpl extends AbstractServiceImpl implements AnalysisQuestServiceData {
	
	@Resource(name="analysisQuestDAO")
	private AnalysisQuestDAO analysisQuestDAO;

	@Override
	public JSONObject selectIndvdlzHousePc(String sggCd) throws SQLException, Exception {
		return analysisQuestDAO.selectIndvdlzHousePc(sggCd);
	}

	@Override
	public JSONObject selectCopertnHousePc(String sggCd) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return analysisQuestDAO.selectCopertnHousePc(sggCd);
	}
	
	@Override
	public JSONObject selectPnilp(String sggCd) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return analysisQuestDAO.selectPnilp(sggCd);
	}
	
	@Override
	public JSONObject selectBild(String sggCd) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return analysisQuestDAO.selectBild(sggCd);
	}
}
