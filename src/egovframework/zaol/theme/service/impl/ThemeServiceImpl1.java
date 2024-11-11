package egovframework.zaol.theme.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.zaol.dash.service.DashVO;
import egovframework.zaol.home.service.HomeService;
import egovframework.zaol.home.service.HomeVO;
import egovframework.zaol.theme.service.ThemeService1;
import egovframework.zaol.theme.service.ThemeVO;

import org.apache.commons.codec.binary.Base64;

@Service("themeService1")
public class ThemeServiceImpl1 extends AbstractServiceImpl implements ThemeService1 {

    @Resource(name="themeDAO1")
    private ThemeDAO1 themeDAO;
    
    public List     theme_List (ThemeVO vo) throws Exception { return themeDAO.theme_List (vo); }
    public List   theme_List_view (HashMap param) throws Exception { return themeDAO.theme_List_view(param);}
    public int	  theme_post_max_seq(ThemeVO vo) throws Exception { return themeDAO.theme_post_max_seq(vo); }
    public void	  theme_post_input			 (HashMap param) throws Exception { themeDAO.theme_post_input(param);}
    public List   theme_post				 (int nPostSeq) throws Exception { return themeDAO.theme_post(nPostSeq);}
    public void	  theme_post_modify			 (HashMap param) throws Exception { themeDAO.theme_modify(param);}
    /*주제도 count*/
    public List	  theme_List_View_Cnt (HashMap param)  throws Exception { return themeDAO.theme_List_View_Cnt(param);}
    /*주제도 삭제*/    
    public void	  themeDeleteUpdateStart			 (HashMap param) throws Exception {themeDAO.themeDeleteUpdateStart(param);}
    
}
