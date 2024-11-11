package egovframework.zaol.manage.service;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.zaol.factual.service.FactualVO;
import egovframework.zaol.home.service.HomeVO;

public interface ManageService {

    
    public List     selectUserList         (ManageVO vo) throws Exception;
    public int      selectUserListCnt	   (ManageVO vo) throws Exception;
    public ManageVO selectUserInfo         (ManageVO vo) throws Exception;    
    
    public void     resetPass              (ManageVO vo) throws Exception;
    
    public void     memAuthudp01           (ManageVO vo) throws Exception;
    public int      memAccessListCnt	   (ManageVO vo) throws Exception; 
    public List     memAccessList          (ManageVO vo) throws Exception;
    
    public int      noticeListPageCnt	   (ManageVO vo) throws Exception;
    public List     noticeListPage         (ManageVO vo) throws Exception;
    public void     noticeInserteStart      (ManageVO vo) throws Exception;
    public List   	noticeUpdatePage		(ManageVO vo) throws Exception;
    public int   	noticeUpdateStart		(ManageVO vo) throws Exception;
    
    public void     qnaInserteStart      (ManageVO vo) throws Exception;
    public void     qna_reInserteStart      (ManageVO vo) throws Exception;
    
    
    
}
