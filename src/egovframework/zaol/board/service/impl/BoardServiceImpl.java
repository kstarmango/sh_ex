package egovframework.zaol.board.service.impl;

import java.util.List;
import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.zaol.board.service.BoardService;
import egovframework.zaol.board.service.BoardVO;
import egovframework.zaol.dash.service.DashVO;
import egovframework.zaol.home.service.HomeService;
import egovframework.zaol.home.service.HomeVO;
import egovframework.zaol.manage.service.ManageVO;
import egovframework.zaol.theme.service.ThemeVO;

import org.apache.commons.codec.binary.Base64;

@Service("boardService")
public class BoardServiceImpl extends AbstractServiceImpl implements BoardService {

    @Resource(name="boardDAO")
    private BoardDAO boardDAO;
    
    
    
    public int  	noticeListPageCnt  	(BoardVO vo) throws Exception { return boardDAO.noticeListPageCnt(vo); } 
    public List   	noticeListPage  	(BoardVO vo) throws Exception { return boardDAO.noticeListPage(vo); }
    public List   	qnaListPage  	(BoardVO vo) throws Exception { return boardDAO.qnaListPage(vo); }
    
    public List   	noticeDetail  	(BoardVO vo) throws Exception { return boardDAO.noticeDetail(vo); }
    
    //qna 조회수
    public int  	board_cnt_UpdateStart  	(BoardVO vo) throws Exception { return boardDAO.board_cnt_UpdateStart(vo); } 
}
