package egovframework.zaol.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.zaol.common.AddressZipcodeVO;
import egovframework.zaol.common.DefaultSearchVO;
import egovframework.zaol.common.Globals;
import egovframework.zaol.common.service.CommonService;
import egovframework.zaol.factual.service.FactualVO;
import egovframework.zaol.factual.service.impl.FactualDAO;
import egovframework.zaol.util.service.FileUtil;

@Service("CommonService")
public class CommonServiceImpl extends AbstractServiceImpl implements CommonService {

	@Resource(name="CommonDAO")
    private CommonDAO commonDAO;
    @Resource(name = "fileUtil"    ) 
    private   FileUtil fileUtil;
    @Resource(name="factualDAO")
    private FactualDAO factualDAO;
    
    public void saveFile(String pnu, String type, final MultipartHttpServletRequest multiRequest) throws Exception {
		
		Iterator fileIter = multiRequest.getFileNames();
		System.out.println("fileIter :::::::::::::: " + fileIter);
		int i= 0;//다중 첨부파일일 경우 같은 이름으로 저장될 수 있음. 기존 파일을 지우고 새로 파일 작성됨
		
		FactualVO factualVO = null; 
    	
    	System.out.println("::: fileIter.hasNext() :::" + fileIter.hashCode() );
        while (fileIter.hasNext()) {
        	
        	MultipartFile mFile = multiRequest.getFile((String)fileIter.next());
        	System.out.println("mFile.getOriginalFilename() :::::::::::::: " + mFile.getOriginalFilename());
    	    System.out.println("mFile.getSize() :::::::::::::: " + mFile.getSize());
    	    if (mFile.getSize() > 0) {
	    	    	HashMap<String, String> map = null;
	    	    	map = fileUtil.uploadFiles(mFile,Globals.FACTUAL_FILE_PATH,i);	    	    		
		    	    ++i;

		    	    map.put("TABLE_TYPE", type);
		    	    map.put("order", String.valueOf(i));
		        	map.put("TABLE_ROW_GID", pnu);
		        	
		        	factualDAO.insert_File(map);
    	    }
        }
	}

	@Override
	public List selectUserShare(HashMap vo) throws SQLException {
		// TODO Auto-generated method stub
		return commonDAO.selectUserShare(vo);
	}
    
}