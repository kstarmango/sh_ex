package egovframework.zaol.mbersbscrb.service.impl;

import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.zaol.common.ICencryptUtils;
import egovframework.zaol.mbersbscrb.service.MbersbscrbService;
import egovframework.zaol.mbersbscrb.service.MbersbscrbVO;

@Service("mbersbscrbService")
public class MbersbscrbServiceImpl extends AbstractServiceImpl implements MbersbscrbService {

    @Resource(name="mbersbscrbDAO")
    private MbersbscrbDAO mbersbscrbDAO;

    public MbersbscrbVO userIdDplctAjax01 (MbersbscrbVO vo) throws Exception 
    { 
    	return mbersbscrbDAO.userIdDplctAjax01   (vo); 
    }   
    
    public void userInfoInsert(MbersbscrbVO vo) throws Exception { 
        
    	String password = vo.getUser_pass();
    	String encryption = ICencryptUtils.encryption(password);    // SHA-256 단방향 암호화
    	vo.setUser_pass(encryption);
    	
    	mbersbscrbDAO.userInfoInsert(vo); 
    	
    }
    
    public List selectUserIdList (MbersbscrbVO vo) throws Exception 
    { 
    	return mbersbscrbDAO.selectUserIdList(vo); 
    }    

    public void   selectLoginOutHist (MbersbscrbVO vo) throws Exception 
    {       
    	mbersbscrbDAO.selectLoginOutHist (vo); 
    } 
}
