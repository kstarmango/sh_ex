package egovframework.syesd.admin.board.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.syesd.admin.board.service.AdminBoardService;

@Service("adminBoardService")
public class AdminBoardServiceImpl   extends AbstractServiceImpl implements AdminBoardService {

	@Resource(name="adminBoardDAO")
	private AdminBoardDAO adminBoardDAO;

	public List selectNoticeArticleList(HashMap vo) throws SQLException {
		return adminBoardDAO.selectNoticeArticleList(vo);
	}

	public int selectNoticeArticleListCount(HashMap vo) throws SQLException {
		return adminBoardDAO.selectNoticeArticleListCount(vo);
	}

	
	public List selectQnaArticleList(HashMap vo) throws SQLException {
		return adminBoardDAO.selectQnaArticleList(vo);
	}

	public int selectQnaArticleListCount(HashMap vo) throws SQLException {
		return adminBoardDAO.selectQnaArticleListCount(vo);
	}
	

	public Map selectBoardArticleDetail(HashMap vo) throws SQLException {
		return adminBoardDAO.selectBoardArticleDetail(vo);
	}
	
	
	public int insertBoardArticle(HashMap vo) throws SQLException {
		return  adminBoardDAO.insertBoardArticle(vo);
	}
	
	public int insertBoardArticleReply(HashMap vo) throws SQLException {
		return  adminBoardDAO.insertBoardArticleReply(vo);
	}
	
	
	public int updateBoardArticle(HashMap vo) throws SQLException {
		return adminBoardDAO.updateBoardArticle(vo);
	}
	
	public int updateBoardArticleViewCnt(HashMap vo) throws SQLException {
		return adminBoardDAO.updateBoardArticleViewCnt(vo);
	}

	public int updateBoardArticleUse(HashMap vo) throws SQLException {
		return adminBoardDAO.updateBoardArticleUse(vo);
	}

	public String updateBoardArticleViewCntBySeq(HashMap vo) throws SQLException {
		return adminBoardDAO.updateBoardArticleViewCntBySeq(vo);
	}

	public List selectBoardArticleCheckNew() throws SQLException {
		return adminBoardDAO.selectBoardArticleCheckNew();
	}

	@Override
	public int deleteNoticeArticle(HashMap vo) throws SQLException {
		return adminBoardDAO.deleteNoticeArticle(vo);
	}
	
	
	@Override
	public int deleteQnaArticle(HashMap vo) throws SQLException {
		return adminBoardDAO.deleteQnaArticle(vo);
	}

	
	
	

	
	
}
