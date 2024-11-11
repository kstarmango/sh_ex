package egovframework.zaol.theme.web;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.font.FontRenderContext;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.bind.DatatypeConverter;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.zaol.gisinfo.service.GisBasicVO;
import egovframework.zaol.gisinfo.service.GisinfoService;
import egovframework.zaol.home.service.HomeVO;
import egovframework.zaol.manage.service.ManageVO;
import egovframework.zaol.theme.service.ThemeService1;
import egovframework.zaol.theme.service.ThemeVO;
import egovframework.zaol.common.Globals;
import egovframework.zaol.common.OraclePaginationInfo;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;
import egovframework.zaol.dash.service.DashVO;

@Controller
public class ThemeController1 extends BaseController  {
	@Resource(name="themeService1")
	ThemeService1 themeService;
	
	@Resource(name = "gisinfoService"   ) private   GisinfoService gisinfoService;
	
	@Resource(name = "propertiesService") 
	protected EgovPropertyService propertiesService;
//고도화 시작-----------------------------------------------------------------------------------------------------------------------------------
    
	//주제도면 리스트 페이지
    @RequestMapping(value="/theme_home.do")
    public String theme_home(@ModelAttribute("themeVO") ThemeVO vo, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
                            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {    	 
    	
    	HttpSession session = getSession();
    	String userS_id = null;
    	String urlRediect = null;
    	if(session != null){ 
    		userS_id = (String)session.getAttribute("userId");
    		
    	}
    	
        if( userS_id != null ){
        	return "/SH/theme/list";
	      
	      //urlRediect = "/SH/theme/list";
        	
        }else{
        	jsHelper.Alert("비정상적인 접근 입니다.");        	
        	return  "redirect:/main_home.do";
        }
        
        //return urlRediect;
    	   	
    }  
    
    //주제도면 상세보기
    @RequestMapping(value="/theme_Content.do")
    public String theme_Content(@ModelAttribute("themeVO") ThemeVO vo, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
                            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {    	 
    	HttpSession session = getSession();
    	String userS_id = null;
    	String userS_nm = null;
    	if(session != null){ 
    		userS_id = (String)session.getAttribute("userId");
    		userS_nm = (String)session.getAttribute("userNm");
    	}
    	     
        if( userS_id != null ){
        	
        	int nPostSeq;
        	String post_seq = request.getParameter("post_seq");
        	String imgName = "";
        	
        	if(post_seq == null) {
        		System.out.println("post_seq is null, read IO Stream");
        		InputStream inputStream = request.getInputStream();
        		post_seq = URLDecoder.decode(IOUtils.toString(inputStream).split("=")[1], "utf-8");
        	}
        	
        	System.out.println("포스트 번호 : " + post_seq);
        	nPostSeq = Integer.parseInt(post_seq);
        	
        	List<HashMap<String, Object>> posts = themeService.theme_post(nPostSeq);
        	HashMap<String, Object> post = (HashMap<String, Object>)posts.get(0); 
        	model.addAttribute("post_seq", post_seq);
        	model.addAttribute("imgNM", post.get("layname").toString());
        	model.addAttribute("ownname", post.get("ownname").toString());
        	model.addAttribute("userid", userS_id);
        	model.addAttribute("usernm", userS_nm);
        	
        	model.addAttribute("subject", posts.get(0).get("subject"));
        	model.addAttribute("title", posts.get(0).get("title"));
        	model.addAttribute("sub1", posts.get(0).get("sub1"));
        	model.addAttribute("sub2", posts.get(0).get("sub2"));
        	
        	
       		return "/SH/theme/detail";    

        	
        }else{
        	jsHelper.Alert("비정상적인 접근 입니다.");        	
        	return  "redirect:/main_home.do";
        }
        
    		
    } 
    
    
    //주제도면 등록 - 1단계
    @RequestMapping(value="/theme_regit_01.do")
    public String theme_regit_01(@ModelAttribute("themeVO") ThemeVO vo, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
                            ,HttpServletRequest request, HttpServletResponse response, ModelMap model, GisBasicVO bookmarkvo) throws Exception
    {    	 
    	
    	HttpSession session = getSession();
    	String userS_id = null;
    	if(session != null){ 
    		userS_id = (String)session.getAttribute("userId");
    	}
    	
        if( userS_id != null ){
        	

        	bookmarkvo.setUser_id("admin");
        	List GISBookMark = gisinfoService.gis_search_bookmark(bookmarkvo);
        	
        	model.addAttribute("GISBookMark", GISBookMark);
        	
//        	model.addAttribute("geoserverURL", "http://connect.miraens.com:59900/geoserver/SH_LM/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20");
        	model.addAttribute("geoserverURL", "http://128.134.95.129:8080/geoserver/SH_LM/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20");

//        	model.addAttribute("geoserverURL", "http://dev.syesd.co.kr:12101/geoserver/SH_LM/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20");
        	
        	
        	return "/SH/theme/Register_map";    
        	
        }else{
        	jsHelper.Alert("비정상적인 접근 입니다.");        	
        	return  "redirect:/main_home.do";
        }
        	
    }
    //주제도면 등록 - 2단계
    @RequestMapping(value="/theme_regit_02.do")
    public String theme_regit_02(@ModelAttribute("themeVO") ThemeVO vo, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
                            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {
    	HttpSession session = getSession();
    	String userS_id = null;
    	if(session != null){ 
    		userS_id = (String)session.getAttribute("userId");
    	}
    	
        if( userS_id != null ){
        	
        	String imgSrc = request.getParameter("imgSrcs");
        	//System.out.println("이미지 : " + imgSrc);
        	
        	/*
        	 * IE에서 전송시 데이터 못받을 경우 처리
        	 * 직접 Stream에서 읽어온다.
        	 * */
        	if(imgSrc == null) {
        		System.out.println("imgSrcs is null, read IO Stream");
        		InputStream inputStream = request.getInputStream();
        		imgSrc = URLDecoder.decode(IOUtils.toString(inputStream).split("=")[1], "utf-8");
                //System.out.println("reqData : " + imgSrc);
        	}
        	
        	// 경로
        	String strDir = Globals.MOTIF_FILE_PATH;
        	String imgName = UUID.randomUUID().toString() + ".png";
        	
        	// 디렉터리 생성
        	System.out.println("strDir : " + strDir);
        	File dir = new File(strDir);
        	
        	if(!dir.exists()) {
        		dir.mkdirs();
        	}
        	
        	byte[] imagedata = DatatypeConverter.parseBase64Binary(imgSrc.substring(imgSrc.indexOf(",") + 1));
        	BufferedImage bufferedImage = ImageIO.read(new ByteArrayInputStream(imagedata));
        	ImageIO.write(bufferedImage, "png", new File(strDir + "\\" + imgName));
        	// 이미지 생성
        	
        	
        	// 이미지 이름 넘겨주기    	
        	model.addAttribute("imgName", imgName);
        	
        	return "/SH/theme/Register_itemset";   
        	
        }else{
        	jsHelper.Alert("비정상적인 접근 입니다.");        	
        	return  "redirect:/main_home.do";
        }
        
    	 	
    }
    //주제도면 등록 - 3단계
    @RequestMapping(value="/theme_regit_03.do")
    public String theme_regit_03(@ModelAttribute("themeVO") ThemeVO vo, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
                            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {   
    	HttpSession session = getSession();
    	String userS_id = null;
    	if(session != null){ 
    		userS_id = (String)session.getAttribute("userId");
    	}
    	
        if( userS_id != null ){
        	

        	String subject = request.getParameter("subject");
        	String title = request.getParameter("title");
        	String sub1 = request.getParameter("sub1");
        	String sub2 = request.getParameter("sub2");
        	String use_at = request.getParameter("use_at");
        	String mapImg = request.getParameter("imgName");
        	//String layoutImg = createImage(request);
        	
        	model.addAttribute("subject", subject);
        	model.addAttribute("title", title);
        	model.addAttribute("sub1", sub1);
        	model.addAttribute("sub2", sub2);
        	model.addAttribute("use_at", use_at);
        	model.addAttribute("imgNM", mapImg);
        	//model.addAttribute("layNM", layoutImg);
        	model.addAttribute("layNM", mapImg);
        	return "/SH/theme/Register_preview";    
        	
        }else{
        	jsHelper.Alert("비정상적인 접근 입니다.");        	
        	return  "redirect:/main_home.do";
        }
        	
    }
    
    @RequestMapping(value="/theme_regit_post.do")
    public String theme_regit_post(@ModelAttribute("themeVO") ThemeVO vo, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
                            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {
    	
    	//cjw 등록시 user_nm입력 
    	HttpSession session = getSession();
    	String userS_id = null;
    	String user_nm = null;
    	if(session != null){ 
    		userS_id = (String)session.getAttribute("userId");
    		user_nm = (String)session.getAttribute("userNm");
    		
    	}
    	
    	
    	// 등록하고
    	String subject = request.getParameter("subject");
    	String title = request.getParameter("title");
    	String sub1 = request.getParameter("sub1");
    	String sub2 = request.getParameter("sub2");
    	String use_at = request.getParameter("use_at");
    	String imgName = request.getParameter("imgName");
    	String layname = request.getParameter("layName");
    	Integer maxseq = themeService.theme_post_max_seq(vo) + 1;
    	
    	HashMap<String, Object> param = new HashMap<String, Object>();
    	param.put("NUMB", maxseq);
    	param.put("SUBJECT", subject);
    	param.put("TITLE", title);
    	param.put("SUB1", sub1);
    	param.put("SUB2", sub2);
    	param.put("PUBLIC", use_at); //cjw 공개여부
    	param.put("OWNER", user_nm);  //cjw 등록시 user_nm입력
    	param.put("MAPNM", imgName);
    	param.put("LAYNM", layname);
    	
    	themeService.theme_post_input(param);
    	
    	//String rootDir = request.getSession().getServletContext().getRealPath("/") + "file";
    	// 리스트로
    	return "redirect:/theme_home.do";
    }
    
    // 주제도면 수정
    @RequestMapping(value="/theme_modif_01.do")
    public String theme_modif_01(@ModelAttribute("themeVO") ThemeVO vo, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	
    	HttpSession session = getSession();
    	String userS_id = null;
    	if(session != null){ 
    		userS_id = (String)session.getAttribute("userId");
    	}
    	
        if( userS_id != null ){
        	
        	int nPostSeq;
        	String post_seq = request.getParameter("post_seq");
        	String imgName = "";
        	
        	if(post_seq == null) {
        		System.out.println("post_seq is null, read IO Stream");
        		InputStream inputStream = request.getInputStream();
        		post_seq = URLDecoder.decode(IOUtils.toString(inputStream).split("=")[1], "utf-8");
        	}
        	
        	
        	
        	// 기존포스트 불러오기
        	nPostSeq = Integer.parseInt(post_seq);
        	
        	List<HashMap<String, Object>> posts = themeService.theme_post(nPostSeq); 
        	
        	
        	
        	model.addAttribute("post_seq", nPostSeq);
        	model.addAttribute("imgName", posts.get(0).get("mapname"));
        	model.addAttribute("subject", posts.get(0).get("subject"));
        	model.addAttribute("title", posts.get(0).get("title"));
        	model.addAttribute("sub1", posts.get(0).get("sub1"));
        	model.addAttribute("sub2", posts.get(0).get("sub2"));
        	model.addAttribute("use_at", posts.get(0).get("public"));
        	return "/SH/theme/modify_itemset";
        	
        }else{
        	jsHelper.Alert("비정상적인 접근 입니다.");        	
        	return  "redirect:/main_home.do";
        }
        
    	
    }
    
    @RequestMapping(value="/theme_modif_02.do")
    public String theme_modif_02(@ModelAttribute("themeVO") ThemeVO vo, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	
    	HttpSession session = getSession();
    	String userS_id = null;
    	if(session != null){ 
    		userS_id = (String)session.getAttribute("userId");
    	}
    	
        if( userS_id != null ){
        	
        	String post_seq = request.getParameter("post_seq");
        	String subject = request.getParameter("subject");
        	String title = request.getParameter("title");
        	String sub1 = request.getParameter("sub1");
        	String sub2 = request.getParameter("sub2");
        	String use_at = request.getParameter("use_at");
        	String mapImg = request.getParameter("imgName");
        	//String layoutImg = createImage(request);
        	
        	model.addAttribute("post_seq", post_seq);
        	model.addAttribute("subject", subject);
        	model.addAttribute("title", title);
        	model.addAttribute("sub1", sub1);
        	model.addAttribute("sub2", sub2);
        	model.addAttribute("use_at", use_at);
        	model.addAttribute("imgNM", mapImg);
        	//model.addAttribute("layNM", layoutImg);
        	model.addAttribute("layNM", mapImg);
        	
        	return "/SH/theme/Register_mpreview";  
        	
        }else{
        	jsHelper.Alert("비정상적인 접근 입니다.");        	
        	return  "redirect:/main_home.do";
        }
        
    	
    }
    
    @RequestMapping(value="/theme_modif_post.do")
    public String theme_modif_post(@ModelAttribute("themeVO") ThemeVO vo, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {
    	
    	HttpSession session = getSession();
    	String userS_id = null;
    	if(session != null){ 
    		userS_id = (String)session.getAttribute("userId");
    	}
    	
    	
    	
    	// 등록하고
    	String post_seq = request.getParameter("post_seq");
    	String subject = request.getParameter("subject");
    	String title = request.getParameter("title");
    	String sub1 = request.getParameter("sub1");
    	String sub2 = request.getParameter("sub2");
    	String use_at = request.getParameter("use_at");
    	String imgName = request.getParameter("imgName");
    	String layname = request.getParameter("layName");
    	
    	HashMap<String, Object> param = new HashMap<String, Object>();
    	param.put("NUMB", Integer.parseInt(post_seq));
    	param.put("SUBJECT", subject);
    	param.put("TITLE", title);
    	param.put("SUB1", sub1);
    	param.put("SUB2", sub2);
    	param.put("PUBLIC", use_at);
    	param.put("OWNER", userS_id);
    	param.put("MAPNM", imgName);
    	param.put("LAYNM", layname);
    	
    	// 기존 포스트 불러와서
    	int nPostSeq = Integer.parseInt(post_seq);    	
    	List<HashMap<String, Object>> posts = themeService.theme_post(nPostSeq);
    	
    	// 기존 파일 삭제
    	String prevfile = Globals.MOTIF_FILE_PATH + Globals.CONTEXT_MARK + posts.get(0).get("layName");
    	
    	(new File(prevfile)).delete();
    	
    	themeService.theme_post_modify(param);
    	
    	//String rootDir = request.getSession().getServletContext().getRealPath("/") + "file";
    	// 리스트로
    	return "redirect:/theme_Content.do?post_seq=" + post_seq;
    }
    
    /**
     * 주제도 삭제 실행
     */
    @RequestMapping(value="/themeDeleteStart.do")
    public void qnaDeleteStart(@ModelAttribute("themeVO") ThemeVO vo, @ModelAttribute("commonSessionVO") CommonSessionVO commonSessionVO
            ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception
    {
		String users_id = null;
		String urlRediect = null;
		HttpSession session = getSession();
		if(session != null)
		{
			users_id = (String)session.getAttribute("userId");
		}
		
		if(users_id != null)
		{
			HashMap<String, Object> param = new HashMap<String, Object>();
			String post_seq = request.getParameter("post_seq");
			int npost_seq = Integer.parseInt(post_seq);   
			param.put("post_seq", npost_seq);
			themeService.themeDeleteUpdateStart(param);
			jsHelper.AlertAndUrlGo("삭제가 완료 되었습니다.", "/theme_home.do");
			
			
		}else{
			jsHelper.Alert("세션이 만료 되었습니다.");
			jsHelper.RedirectUrl("/main_home.do");
		}   
		
  		  
    } 
    
    
    
    // 주제도면 목록 콜
    @RequestMapping(value="/theme_list_call.do")
    public void theme_call_list(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	response.setCharacterEncoding("UTF-8"); 
    	PrintWriter out = response.getWriter();
    	
    	//cjw user체크 후 주제도면 조회를 위함
    	HttpSession session = getSession();
    	String userS_id = null;
    	String userS_nm = null;

    	if(session != null){ 
    		userS_id = (String)session.getAttribute("userId");
    		userS_nm = (String)session.getAttribute("userNm");
    	}
    	
    	
    	HashMap<String,Object> param = new HashMap<String, Object>();
        
        String strPageIndex = (String)request.getParameter("pageNo");
        String strPageRow = (String)request.getParameter("listCnt");
        String strSearch = (String)request.getParameter("s");
        
        int nPageIndex = 0;
        int nPageRow = 10;
         
        System.out.println(strPageIndex);
        System.out.println(strPageRow);
        
        if(StringUtils.isEmpty(strPageIndex) == false){
            nPageIndex = Integer.parseInt(strPageIndex)-1;
        }
        if(StringUtils.isEmpty(strPageRow) == false){
            nPageRow = Integer.parseInt(strPageRow);
        }
        
        param.put("START", (nPageIndex * nPageRow) + 1);
        param.put("END", (nPageIndex * nPageRow) + nPageRow);
        param.put("SEARCH", strSearch);
        param.put("USERS_ID", userS_id); //cjw user체크 후 주제도면 조회를 위함
        param.put("USERS_NM", userS_nm); //cjw user체크 후 주제도면 조회를 위함

    	JSONObject obj = new JSONObject();
    	List<?> list = themeService.theme_List_view(param);
    	List<?> list_Cnt = themeService.theme_List_View_Cnt(param);
    	
    	if(list.size() == 0) {
    		obj.put("TOTAL_COUNT", 0);
    	}
    	else {
    		obj.put("TOTAL_COUNT", ((HashMap)list_Cnt.get(0)).get("total_count"));
    	}
    	
    	
    	obj.put("list", JSONArray.fromObject(list));
    	
    	out.println(obj.toString());
    }
    
    // 이미지 생성
    String createImage(HttpServletRequest request) throws Exception {
    	BufferedImage img = null;
    	String strDir = Globals.MOTIF_FILE_PATH;
    	String imgName = UUID.randomUUID().toString() + ".png";
    	String mapName = request.getParameter("imgName");

    	String mainTitle = request.getParameter("subject");
    	String subTitle = request.getParameter("title");
    	String itemText1 = request.getParameter("sub1");
    	String itemText2 = request.getParameter("sub2");
    	
    	//System.out.println("map : " + mapName);
    	
    	// 디렉터리 생성
    	File dir = new File(strDir);
    	
    	if(!dir.exists()) {
    		dir.mkdirs();
    	}
    	
    	// 전체 큰 이미지 생성
    	img = new BufferedImage(3506, 2481, BufferedImage.TYPE_INT_RGB);
    	
    	// 기본 텍스트 폰트 지정
    	Font titleFont = new Font("맑은 고딕", Font.BOLD, 64);
    	Font subjectFont = new Font("맑은 고딕", Font.BOLD, 56);
    	Font regTitleFont = new Font("맑은 고딕", Font.BOLD, 48);
    	Font regitemFont = new Font("맑은 고딕", Font.BOLD, 38);
    	
    	// Graphic 생성
    	Graphics2D g = img.createGraphics();

    	// 입력하는 문자의 가용 넓이
    	int textWide = 720; // 상자의 2배넓이 - 앞뒤 10픽셀씩
    	
    	// 전체 흰색으로 칠하기 및 외곽선
    	BasicStroke bs1 = new BasicStroke(5,0,BasicStroke.JOIN_ROUND);
    	g.setStroke(bs1);
    	g.setColor(Color.WHITE);
    	g.fillRect(0, 0, 3506, 2481);    	
    	g.setColor(Color.BLACK);
    	g.drawRect(50, 50, 3406, 2381);
    	
    	// 템플릿 1 시작
    	// 맵 위치
    	g.drawRect(90, 80, 2590, 2320);
    	
    	// 텍스트 상자1
    	g.drawRect(2710, 80, 720, 450);
    	g.setColor(new Color(225, 225, 225));
    	g.fillRect(2715, 85, 710, 440);
    	
    	g.setColor(Color.BLACK);
    	// 텍스트 범례상자1
    	g.drawRect(2710, 570, 720, 150);

    	g.setColor(Color.BLACK);
    	g.setFont(subjectFont);
    	g.drawString("용도지구ㆍ구역등", 2710 + getPaddingLeft(subjectFont, textWide, "용도지구ㆍ구역등"), 665);
    	
    	// 범례상자
    	g.drawRect(2710, 720, 720, 1680);
    	
    	
    	// 맵 이미지 불러오기
    	String mapDir = Globals.MOTIF_FILE_PATH;
    	BufferedImage mapImg = ImageIO.read(new File(mapDir, mapName));
    	
    	g.drawImage(resize(mapImg, 2310, 2580), 95, 85, null);
    	    	
    	// 타이틀용 폰트로 정의한 후
    	g.setFont(titleFont);
    	
    	// 주제목 위치지정
    	// 가운데 정렬을 위한 지정
    	g.drawString(mainTitle, 2710 + getPaddingLeft(titleFont, textWide, mainTitle), 180);
    	g.drawString(subTitle, 2710 + getPaddingLeft(titleFont, textWide, subTitle), 280);
    	g.drawString(itemText1, 2710 + getPaddingLeft(titleFont, textWide, itemText1), 380);
    	g.drawString(itemText2, 2710 + getPaddingLeft(titleFont, textWide, itemText2), 480);
    	
    	// 범례텍스트
    	g.setFont(regTitleFont);
    	g.drawString("범례", 2730, 790);
    	
    	g.dispose();
    	ImageIO.write(img, "png", new File(strDir + "\\" + imgName));
    	    	
    	return imgName;
    }
    
    private int getPaddingLeft(Font font, int textWide, String text) {
    	FontRenderContext frc = new FontRenderContext(null, true, true);
    	Rectangle2D r2 = font.getStringBounds(text, frc);
    	int textWidth = (int) r2.getWidth();
    	int rX = (int) Math.round(r2.getX());
    	int paddingleft = (textWide / 2) - (textWidth / 2) - rX;
    	
    	return paddingleft;
    }
    
    private static BufferedImage resize(BufferedImage img, int height, int width) {
        Image tmp = img.getScaledInstance(width, height, Image.SCALE_SMOOTH);
        BufferedImage resized = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
        Graphics2D g2d = resized.createGraphics();
        g2d.drawImage(tmp, 0, 0, null);
        g2d.dispose();
        return resized;
    }
    
}
