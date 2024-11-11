package egovframework.zaol.mbersbscrb.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;
import egovframework.zaol.mbersbscrb.service.MbersbscrbService;
import egovframework.zaol.mbersbscrb.service.MbersbscrbVO;

@Controller
public class MbersbscrbController extends BaseController  {
	
	@Resource(name = "mbersbscrbService") private MbersbscrbService mbersbscrbService;
	
    /**
     * 회원가입 페이지
     */
    @RequestMapping(value="/user_regist_form.do")
    public String userRegistForm(@ModelAttribute("mbersbscrbVO"  ) MbersbscrbVO mbersbscrbVO, HttpServletRequest  request ,HttpServletResponse response 
    		                     ,ModelMap model) throws Exception
    {	 
    	 return "SH/user/user_regist_form";
    }
    
    /**
     * 회원 등록
     */
    @RequestMapping(value="/user_regist_start.do")
    public ModelAndView memberregStart(@ModelAttribute("mbersbscrbVO"  ) MbersbscrbVO mbersbscrbVO
                            ,HttpServletRequest  request
                            ,HttpServletResponse response
                            ,ModelMap model
                            ) throws Exception
    {
        
         
    	mbersbscrbService.userInfoInsert(mbersbscrbVO);    	 
    	
    	ModelAndView modelAndView = new ModelAndView();        
        modelAndView.setViewName("jsonView");
        return modelAndView;
    }
    
    /**
     *  아이디 중복체크 
     */
    @RequestMapping(value="/user_dplct_ajax01.do")
    public ModelAndView userDplctAjax01(@ModelAttribute("mbersbscrbVO") MbersbscrbVO mbersbscrbVO, HttpServletRequest  request, HttpServletResponse response,
                        ModelMap model)throws Exception
    {   

    	MbersbscrbVO view01 = mbersbscrbService.userIdDplctAjax01(mbersbscrbVO);
        String rCheck ="false";
        if(view01 != null)
        {
        	rCheck = "true";
        }
     
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("result", rCheck);
        modelAndView.setViewName("jsonView");

        return modelAndView;
    }
    
    /** 
     * 아이디찾기 폼 호출 
     */
    @RequestMapping(value = "/user_find_id.do")
    public String findCctvUserIdView(@ModelAttribute("findUserId") MbersbscrbVO mbersbscrbVO, ModelMap model) throws Exception{
    	
    	mbersbscrbVO.setMode("find");
        return "SH/user/user_find_id";
    }
    
    /**     
     * 아이디찾기    
     */
    @RequestMapping(value = "/find_user_id_ac.do")
    public String findCctvUserId(@ModelAttribute("findUserId") MbersbscrbVO mbersbscrbVO, ModelMap model, HttpServletRequest request) throws Exception{
    	request.setCharacterEncoding("UTF-8"); 
    	
        List userIdList    = mbersbscrbService.selectUserIdList(mbersbscrbVO);
        int intResultCnt = userIdList.size();
        if(intResultCnt > 0)
        {
        	mbersbscrbVO.setMode("succ");
        }
        else
        {
        	mbersbscrbVO.setMode("fail");
        }
        
        model.addAttribute("userIdList", userIdList);
        
        return "SH/user/user_find_id";
    }
    
    /**
     * 로그아웃 액션
     */
    @RequestMapping(value="/actionLogout.do")
    public String actionLogout(HttpServletRequest  request, HttpServletResponse response, @ModelAttribute("mbersbscrbVO") MbersbscrbVO mbersbscrbVO, 
    		                   @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO, ModelMap model) throws Exception
    {
    	
    	
        HttpSession session = getSession();       
        if (session != null) {
        	commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
        	mbersbscrbVO.setUser_id(commonSessionVO.getUser_id());
        	mbersbscrbVO.setUser_name(commonSessionVO.getUser_name());        	
        	mbersbscrbVO.setUser_position(commonSessionVO.getUser_position());
        	mbersbscrbVO.setIn_out("out");
        	
        	mbersbscrbService.selectLoginOutHist(mbersbscrbVO);
            session.invalidate();
        }

        return "redirect:/main_home.do";
    }
}
