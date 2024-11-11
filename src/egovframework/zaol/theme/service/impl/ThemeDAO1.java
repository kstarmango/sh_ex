package egovframework.zaol.theme.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.zaol.common.OracleDAO;
import egovframework.zaol.home.service.HomeVO;
import egovframework.zaol.theme.service.ThemeVO;

@Repository("themeDAO1")
public class ThemeDAO1 extends OracleDAO {

	
    public List   theme_List 	(ThemeVO vo) throws Exception { return list("themeDAO.theme_List", vo); }
    public List   theme_List_view			 (HashMap param) throws Exception { return list("themeDAO.theme_List_View", param);}
    public int	  theme_post_max_seq		 (ThemeVO vo)	throws Exception {return (Integer)selectByPk("themeDAO.theme_max_seq", vo); }
    public void	  theme_post_input			 (HashMap param) throws Exception { insert("themeDAO.theme_post_input", param);}
    public List   theme_post				 (int nPostSeq) throws Exception { return list("themeDAO.theme_post", nPostSeq);}
    public void	  theme_modify			 (HashMap param) throws Exception { update("themeDAO.theme_post_modify", param);}
    /*주제도 count*/
	public List   theme_List_View_Cnt       (HashMap param) throws Exception {return list("themeDAO.theme_List_View_Cnt", param);}
	public void   themeDeleteUpdateStart(HashMap param) throws Exception { update("themeDAO.themeDeleteUpdateStart", param);}
	
}
