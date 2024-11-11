package egovframework.syesd.admin.board.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.zaol.common.OracleDAO;

@Repository("adminBoardDAO")
public class AdminBoardDAO extends OracleDAO {

	public List selectNoticeArticleList(HashMap vo) throws SQLException { return list("admin.board.selectNoticeArticleList" , vo); }
	public int  selectNoticeArticleListCount(HashMap vo) throws SQLException { return (Integer)selectByPk("admin.board.selectNoticeArticleListCount" , vo); }
	
	public List selectQnaArticleList(HashMap vo) throws SQLException { return list("admin.board.selectQnaArticleList" , vo); }
	public int  selectQnaArticleListCount(HashMap vo) throws SQLException { return (Integer)selectByPk("admin.board.selectQnaArticleListCount" , vo); }

	public Map  selectBoardArticleDetail(HashMap vo) throws SQLException { return (Map)selectByPk("admin.board.selectBoardArticleDetail" , vo); }
	
	public int  insertBoardArticle(HashMap vo) throws SQLException { return (Integer)update("admin.board.insertBoardArticle" , vo); }
	public int  insertBoardArticleReply(HashMap vo) throws SQLException { return (Integer)update("admin.board.insertBoardArticleReply" , vo); }
	
	public int  updateBoardArticle(HashMap vo) throws SQLException { return (Integer)update("admin.board.updateBoardArticle" , vo); }
	public int  updateBoardArticleViewCnt(HashMap vo) throws SQLException { return (Integer)update("admin.board.updateBoardArticleViewCnt" , vo); }
	public int  updateBoardArticleUse(HashMap vo) throws SQLException { return (Integer)update("admin.board.updateBoardArticleUse" , vo); }
	
	public String updateBoardArticleViewCntBySeq(HashMap vo) throws SQLException { return (String)insert("admin.board.updateBoardArticleViewCntBySeq" , vo); }
	
	public List  selectBoardArticleCheckNew() throws SQLException { return list("admin.board.selectBoardArticleCheckNew" , null); }
	
	// 2022.10.17 게시물 삭제
	public int  deleteNoticeArticle(HashMap vo) throws SQLException { return (Integer)delete("admin.board.deleteNoticeArticle" , vo); }
	
	public int  deleteQnaArticle(HashMap vo) throws SQLException { return (Integer)delete("admin.board.deleteQnaArticle" , vo); }
	
}
