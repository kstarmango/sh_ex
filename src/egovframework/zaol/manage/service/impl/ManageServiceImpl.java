package egovframework.zaol.manage.service.impl;

import java.util.List;
import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.zaol.common.ICencryptUtils;
import egovframework.zaol.factual.service.FactualVO;
import egovframework.zaol.manage.service.ManageService;
import egovframework.zaol.manage.service.ManageVO;

@Service("manageService")
public class ManageServiceImpl extends AbstractServiceImpl implements ManageService {

    @Resource(name="manageDAO")
    private ManageDAO manageDAO;
    
    public List selectUserList (ManageVO vo) throws Exception 
    {
    	return manageDAO.selectUserList (vo); 
    }
    
    public int selectUserListCnt (ManageVO vo) throws Exception 
    { 
    	return manageDAO.selectUserListCnt(vo); 
    }    
    
    public ManageVO selectUserInfo (ManageVO vo) throws Exception 
    { 
    	return manageDAO.selectUserInfo(vo); 
    }
    
    public void resetPass (ManageVO vo) throws Exception 
    {	
    	String password = "SH123456";
    	String encryption = ICencryptUtils.encryption(password);
    	vo.setUser_pass(encryption);
    	manageDAO.resetPass    (vo);
    }
    
    public void memAuthudp01 (ManageVO vo) throws Exception 
    { 
    	manageDAO.memAuthudp01    (vo);
    }
    
    public int  memAccessListCnt (ManageVO vo) throws Exception 
    { 
    	return manageDAO.memAccessListCnt(vo); 
    } 
    
    public List memAccessList (ManageVO vo) throws Exception 
    { 
    	return manageDAO.memAccessList   (vo); 
    } 
    
    public int  noticeListPageCnt  (ManageVO vo) throws Exception 
    { 
    	return manageDAO.noticeListPageCnt(vo); 
    } 
    public List   noticeListPage  (ManageVO vo) throws Exception 
    { 
    	return manageDAO.noticeListPage   (vo); 
    }
    public void noticeInserteStart(ManageVO vo) throws Exception
    {
        manageDAO.noticeInserteStart(vo);
    }
    
    public List  noticeUpdatePage	(ManageVO vo) throws Exception { return manageDAO.noticeUpdatePage(vo); }
    public int   noticeUpdateStart  (ManageVO vo) throws Exception { return manageDAO.noticeUpdateStart(vo); }
    
    
    
    public void qnaInserteStart(ManageVO vo) throws Exception
    {
        manageDAO.qnaInserteStart(vo);
    }
    public void qna_reInserteStart(ManageVO vo) throws Exception
    {
    	manageDAO.qna_reInserteStart(vo);
    }
    
}
