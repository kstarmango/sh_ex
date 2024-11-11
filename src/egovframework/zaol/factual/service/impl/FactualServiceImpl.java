package egovframework.zaol.factual.service.impl;

import java.util.List;
import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.zaol.factual.service.FactualService;
import egovframework.zaol.factual.service.FactualVO;
import egovframework.zaol.home.service.HomeVO;


@Service("factualService")
public class FactualServiceImpl extends AbstractServiceImpl implements FactualService {

	@Resource(name="factualDAO")
    private FactualDAO factualDAO;
	
	public List	factualListPage               	(FactualVO vo) throws Exception { return factualDAO.factualListPage   (vo); }
	public int	factualListPageCnt				(FactualVO vo) throws Exception { return factualDAO.factualListPageCnt(vo); }
	
	public List	factualcodeList               	(FactualVO vo) throws Exception { return factualDAO.factualcodeList   (vo); }
	
	public List	factualsigList               	(FactualVO vo) throws Exception { return factualDAO.factualsigList   (vo); }
	public List	factualemdList               	(FactualVO vo) throws Exception { return factualDAO.factualemdList   (vo); }
	public List	factualliList               	(FactualVO vo) throws Exception { return factualDAO.factualliList   (vo); }
	
	public int  MaxFileGID						(FactualVO vo) throws Exception { return factualDAO.MaxFileGID(vo); }	
	
	
	public void factualInserteStart     		(FactualVO vo) throws Exception { factualDAO.factualInserteStart     (vo); }
	public FactualVO factualselectData			(FactualVO vo) throws Exception { 
    	vo.setGid(vo.getGid());
    	return factualDAO.factualselectData(vo); 
    }
	public List	factualdata               	(FactualVO vo) throws Exception { return factualDAO.factualdata   (vo); }
	public int   factualupdate     		(FactualVO vo, final MultipartHttpServletRequest multiRequest) throws Exception {
		if(!vo.getDelfile().equals("")){
			String delFile = vo.getDelfile().substring(1);
			String delFiles[] = delFile.split(":");
			factualDAO.deleteFile(delFiles);
		}
		return factualDAO.factualupdate(vo);
	}
	public int deletefactualData(FactualVO vo) throws Exception {
		return factualDAO.deletefactualData(vo);
	}
	
	public List	factualSearchList               	(FactualVO vo) throws Exception { return factualDAO.factualSearchList   (vo); }
	public List	factualSearchList_doc               	(FactualVO vo) throws Exception { return factualDAO.factualSearchList_doc   (vo); }
	
    
    
}