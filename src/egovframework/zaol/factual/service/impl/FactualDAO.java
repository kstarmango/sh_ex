package egovframework.zaol.factual.service.impl;

import java.util.HashMap;
import java.util.List;
import org.springframework.stereotype.Repository;
import egovframework.zaol.common.OracleDAO;
import egovframework.zaol.factual.service.FactualVO;
import egovframework.zaol.home.service.HomeVO;

@Repository("factualDAO")
public class FactualDAO extends OracleDAO {

	
	public List	factualListPage 			(FactualVO factualVO) throws Exception { return list("factualDAO.factualListPage", factualVO); }
	public int	factualListPageCnt			(FactualVO factualVO) throws Exception { return (Integer)selectByPk("factualDAO.factualListPageCnt", factualVO); }
	
	public List	factualcodeList				(FactualVO factualVO) throws Exception { return list("factualDAO.factualcodeList", factualVO); }
	
	public List	factualsigList 				(FactualVO factualVO) throws Exception { return list("factualDAO.factualsigList", factualVO); }
	public List	factualemdList 				(FactualVO factualVO) throws Exception { return list("factualDAO.factualemdList", factualVO); }
	public List	factualliList 				(FactualVO factualVO) throws Exception { return list("factualDAO.factualliList", factualVO); }
	
	public void insert_File		(HashMap<String, String> map) throws Exception { insert( "factualDAO.insert_File" , map); }
    public void delete_File		(String[] gid) throws Exception { delete( "factualDAO.delete_File" , gid); }
    
    public int  MaxFileGID      (FactualVO factualVO) throws Exception{ return (Integer)selectByPk("factualDAO.MaxFileGID", factualVO); }
    
    public void factualInserteStart         (FactualVO factualVO) throws Exception { insert("factualDAO.factualInserteStart", factualVO); }
    public FactualVO factualselectData 		(FactualVO factualVO) throws Exception{ return (FactualVO) selectByPk( "factualDAO.factualselectData", factualVO); }
    public List	factualdata 				(FactualVO factualVO) throws Exception { return list("factualDAO.factualdata", factualVO); }
    public int   factualupdate    		    (FactualVO factualVO) throws Exception { return update("factualDAO.factualupdate", factualVO); }
    public int deleteFile(String[] fileIds){
		
		return delete("factualDAO.deleteFile", fileIds);
	}
    public int deletefactualData			(FactualVO factualVO) throws Exception { return update("factualDAO.deletefactualData",factualVO); }
    
    public List	factualSearchList 			(FactualVO factualVO) throws Exception { return list("factualDAO.factualSearchList", factualVO); }
    public List	factualSearchList_doc 			(FactualVO factualVO) throws Exception { return list("factualDAO.factualSearchList_doc", factualVO); }
    
    
    
}