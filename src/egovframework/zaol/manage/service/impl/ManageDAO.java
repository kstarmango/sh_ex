package egovframework.zaol.manage.service.impl;

import java.util.List;
import org.springframework.stereotype.Repository;
import egovframework.zaol.common.OracleDAO;
import egovframework.zaol.factual.service.FactualVO;
import egovframework.zaol.manage.service.ManageVO;

@Repository("manageDAO")
public class ManageDAO extends OracleDAO {

	
    public List selectUserList (ManageVO vo) throws Exception 
    { 
    	return list("manageDAO.selectUserList", vo); 
    }
    
    public int selectUserListCnt (ManageVO vo) throws Exception 
    {
    	return (Integer)selectByPk("manageDAO.selectUserListCnt" , vo); 
    }
    
    public ManageVO selectUserInfo (ManageVO vo) throws Exception
    { 
    	return (ManageVO) selectByPk( "manageDAO.selectUserInfo", vo); 
    }
    
    public void  resetPass (ManageVO vo) throws Exception 
    {        
    	update ("manageDAO.resetPass", vo); 
    }
    
    public void  memAuthudp01 (ManageVO vo) throws Exception 
    {
    	update ("manageDAO.memAuthudp01"    , vo); 
    }
    
    public int memAccessListCnt (ManageVO vo) throws Exception 
    {
    	return    (Integer)selectByPk("manageDAO.memAccessListCnt" , vo); 
    }
    
    public List memAccessList (ManageVO vo) throws Exception 
    { 
    	return list("manageDAO.memAccessList"  , vo); 
    }
    
    public int  noticeListPageCnt  (ManageVO vo) throws Exception 
    {
    	return    (Integer)selectByPk("manageDAO.noticeListPageCnt"  , vo); 
    } 
    
    public List   noticeListPage (ManageVO vo) throws Exception 
    { 
    	return list("manageDAO.noticeListPage" , vo); 
    }
    public void noticeInserteStart(ManageVO vo) throws Exception
    {
    	insert("manageDAO.noticeInserteStart", vo);
    }
    
    public List  noticeUpdatePage 	(ManageVO vo) throws Exception { return list("manageDAO.noticeUpdatePage" , vo); }
    public int   noticeUpdateStart  (ManageVO vo) throws Exception { return update("manageDAO.noticeUpdateStart", vo); }
    

	public void qnaInserteStart(ManageVO vo) throws Exception
    {
    	insert("manageDAO.qnaInserteStart", vo);
        
    }
	public void qna_reInserteStart(ManageVO vo) throws Exception
	{
		insert("manageDAO.qna_reInserteStart", vo);
		
	}
    
    
}
