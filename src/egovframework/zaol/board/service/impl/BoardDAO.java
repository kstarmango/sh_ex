package egovframework.zaol.board.service.impl;

import java.util.List;
import org.springframework.stereotype.Repository;

import egovframework.zaol.board.service.BoardVO;
import egovframework.zaol.common.OracleDAO;
import egovframework.zaol.home.service.HomeVO;
import egovframework.zaol.manage.service.ManageVO;

@Repository("boardDAO")
public class BoardDAO extends OracleDAO {

	
    public int  	noticeListPageCnt  	(BoardVO vo) throws Exception { return (Integer)selectByPk("boardDAO.noticeListPageCnt"  , vo); }     
    public List   	noticeListPage 		(BoardVO vo) throws Exception { return list("boardDAO.noticeListPage" , vo); }
    public List   	qnaListPage 		(BoardVO vo) throws Exception { return list("boardDAO.qnaListPage" , vo); }
    
    public List   	noticeDetail 		(BoardVO vo) throws Exception { return list("boardDAO.noticeDetail" , vo); }
    
	//qna 조회수 증가
    public int  	board_cnt_UpdateStart  	(BoardVO vo) throws Exception { return update("boardDAO.board_cnt_UpdateStart"  , vo); }     
}
