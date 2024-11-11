package egovframework.syesd.admin.board.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface AdminBoardService {

	public List selectNoticeArticleList(HashMap vo) throws SQLException; 
	public int  selectNoticeArticleListCount(HashMap vo) throws SQLException;
	
	public List selectQnaArticleList(HashMap vo) throws SQLException; 
	public int  selectQnaArticleListCount(HashMap vo) throws SQLException;

	public Map  selectBoardArticleDetail(HashMap vo) throws SQLException;
	
	public int  insertBoardArticle(HashMap vo) throws SQLException;
	public int  insertBoardArticleReply(HashMap vo) throws SQLException;
	
	public int  updateBoardArticle(HashMap vo) throws SQLException;
	public int  updateBoardArticleViewCnt(HashMap vo) throws SQLException;
	public int  updateBoardArticleUse(HashMap vo) throws SQLException;
	
	public String updateBoardArticleViewCntBySeq(HashMap vo) throws SQLException;
	
	// 2022.10.17 삭제
	public int deleteNoticeArticle(HashMap vo) throws SQLException;
	
	public int deleteQnaArticle(HashMap query) throws SQLException;
	
	public List selectBoardArticleCheckNew() throws SQLException;
	
	
	
	
}