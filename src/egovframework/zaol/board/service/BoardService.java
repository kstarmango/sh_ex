package egovframework.zaol.board.service;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import egovframework.zaol.home.service.HomeVO;
import egovframework.zaol.manage.service.ManageVO;

public interface BoardService {

    //notice, qna 페이징  cjw
	public int      noticeListPageCnt	   (BoardVO vo) throws Exception;
	
	//notice, qna 리스트 cjw
    public List     noticeListPage         (BoardVO vo) throws Exception;
    public List 	qnaListPage					(BoardVO vo)throws Exception;
    
    //notice, qna 상세보기 cjw
    public List     noticeDetail         (BoardVO vo) throws Exception;
    
    //qna 조회수
    public int     board_cnt_UpdateStart         (BoardVO vo) throws Exception;
    
	
}
