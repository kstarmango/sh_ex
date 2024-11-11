package egovframework.zaol.theme.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import egovframework.zaol.home.service.HomeVO;

public interface ThemeService1 {

    
    public List   theme_List                 (ThemeVO vo) throws Exception;
    public List   theme_List_view			 (HashMap param) throws Exception;
    public int	  theme_post_max_seq		(ThemeVO vo) throws Exception;
    public void	  theme_post_input			 (HashMap param) throws Exception;
    public List   theme_post				 (int nPostSeq) throws Exception;
    public void	  theme_post_modify			 (HashMap param) throws Exception;
    /*주제도 count*/
    public List	  theme_List_View_Cnt			 (HashMap param) throws Exception;
    /*주제도 삭제*/
	public void themeDeleteUpdateStart		(HashMap param) throws Exception;
}
