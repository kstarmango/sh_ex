package egovframework.mango.analysis.quest.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Repository;

import egovframework.zaol.common.OracleDAO;

@Repository("analysisQuestDAO")
public final class AnalysisQuestDAO extends OracleDAO {
	
	public JSONObject selectIndvdlzHousePc(String sggCd) throws SQLException, Exception { return (JSONObject)selectByPk("analysis.quest.selectIndvdlzHousePc", sggCd); }
	public JSONObject selectCopertnHousePc(String sggCd) throws SQLException, Exception { return (JSONObject)selectByPk("analysis.quest.selectCopertnHousePc", sggCd); }
	public JSONObject selectPnilp(String sggCd) throws SQLException, Exception { return (JSONObject)selectByPk("analysis.quest.selectPnilp", sggCd); }
	public JSONObject selectBild(String sggCd) throws SQLException, Exception { return (JSONObject)selectByPk("analysis.quest.selectBild", sggCd); }

	
	
}
