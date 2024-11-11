package egovframework.mango.analysis.quest.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

public interface AnalysisQuestServiceData {
	
	public JSONObject selectIndvdlzHousePc(String sggCd) throws SQLException, Exception;
	public JSONObject selectCopertnHousePc(String sggCd) throws SQLException, Exception;
	public JSONObject selectPnilp(String sggCd) throws SQLException, Exception;
	public JSONObject selectBild(String sggCd) throws SQLException, Exception;

}
