package egovframework.zaol.factual.web;

import java.io.File;
import java.io.FileNotFoundException;

import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.bind.JAXBElement;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Colour;
import jxl.format.ScriptStyle;
import jxl.format.UnderlineStyle;
import jxl.format.VerticalAlignment;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;


import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.docx4j.XmlUtils;
import org.docx4j.dml.wordprocessingDrawing.Inline;
import org.docx4j.jaxb.Context;
import org.docx4j.model.datastorage.migration.VariablePrepare;
import org.docx4j.openpackaging.io.SaveToZipFile;
import org.docx4j.openpackaging.packages.WordprocessingMLPackage;
import org.docx4j.openpackaging.parts.WordprocessingML.BinaryPartAbstractImage;
import org.docx4j.openpackaging.parts.WordprocessingML.MainDocumentPart;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.docx4j.wml.ContentAccessor;
import org.docx4j.wml.Jc;
import org.docx4j.wml.JcEnumeration;
import org.docx4j.wml.ObjectFactory;
import org.docx4j.wml.P;
import org.docx4j.wml.PPr;
import org.docx4j.wml.Tbl;
import org.docx4j.wml.Tc;
import org.docx4j.wml.Text;
import org.docx4j.wml.Tr;

import word.api.interfaces.IDocument;
import word.w2004.Document2004;
import word.w2004.Document2004.Encoding;
import word.w2004.elements.BreakLine;
import word.w2004.elements.Heading1;
import word.w2004.elements.Image;
import word.w2004.elements.ImageLocation;
import word.w2004.elements.Paragraph;
import word.w2004.elements.ParagraphPiece;
import word.w2004.elements.Table;
import word.w2004.elements.TableV2;
import word.w2004.elements.tableElements.TableCell;
import word.w2004.elements.tableElements.TableRow;


import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.zaol.common.CommonUtil;
import egovframework.zaol.common.Globals;
import egovframework.zaol.common.OraclePaginationInfo;
import egovframework.zaol.common.service.CommonService;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;

import egovframework.zaol.util.service.FileUtil;
import egovframework.zaol.util.service.StringUtil;

import egovframework.zaol.factual.service.FactualService;
import egovframework.zaol.factual.service.FactualVO;
import egovframework.zaol.gisinfo.service.GisinfoPostgreVO;

/**
 * 실태조사 컨트롤러
 *
 */
@Controller
public class FactualController extends BaseController  {

    /* EgovPropertyService */ @Resource(name = "propertiesService") protected EgovPropertyService propertiesService;
    /* service 구하기      */ @Resource(name = "factualService"   ) private   FactualService factualService;
    /* 공통 service 구하기 */ @Resource(name = "CommonService"    ) private   CommonService commonservice;
    /* 공통 file 구하기 */ @Resource(name = "fileUtil"    ) private   FileUtil fileUtil;


    /**
     * 실태조사서 리스트 페이지
     */
    @RequestMapping(value="/factualListPage.do")
    public String factualListPage(HttpServletRequest request
    		                   ,HttpServletResponse response
    		                   ,@ModelAttribute("factualVO") FactualVO factualVO
    		                   ,ModelMap model) throws Exception
    {
    	request.setCharacterEncoding("UTF-8");
    	response.setCharacterEncoding("UTF-8");
      
    	String pageIndex = request.getParameter( "pageIndex" );
    	System.out.println("::::: pageIndex :::: " + pageIndex);
    	if(pageIndex != null){factualVO.setPageIndex(Integer.parseInt(pageIndex));}
    	else{factualVO.setPageIndex(1);}
    	
    	/** 페이징 */		
    	OraclePaginationInfo view01Cnt = new OraclePaginationInfo();
		view01Cnt.setCurrentPageNo     (factualVO.getPageIndex());
		view01Cnt.setRecordCountPerPage(factualVO.getPageUnit() );
		view01Cnt.setPageSize          (factualVO.getPageSize() );

		factualVO.setFirstIndex             (view01Cnt.getFirstRecordIndex()  );
		factualVO.setLastIndex              (view01Cnt.getLastRecordIndex()   );
		factualVO.setRecordCountPerPage     (view01Cnt.getRecordCountPerPage());
      
      	List factualList =  factualService.factualListPage( factualVO );   
        view01Cnt.setTotalRecordCount  (factualService.factualListPageCnt( factualVO )   );
      
	     /** 페이징 */
	     int cpNo  = view01Cnt.getCurrentPageNo(); // 현재 페이지
	     int pSize = view01Cnt.getPageSize();      // 보여줄 페이지 사이즈
     
	     model.addAttribute("factualList"      , factualList     );
	     model.addAttribute("tocnt"      , view01Cnt.getTotalRecordCount()     );
	     model.addAttribute("num" , view01Cnt.getTotalRecordCount()-(cpNo-1)*pSize);
	     model.addAttribute("paginationInfo" , view01Cnt);
    
	     	List sig_list    = factualService.factualsigList(factualVO);
	   		List code_list    = factualService.factualcodeList(factualVO);
	   		model.addAttribute("sig_list", sig_list);
	   		model.addAttribute("code_list", code_list);
  		
	   		model.addAttribute("sig", request.getParameter("sig"));
	   		model.addAttribute("emd", request.getParameter("emd"));
	   		model.addAttribute("li", request.getParameter("li"));
	   		
		return "/SH/factual/factual_list";
  		
    }
      
    /**
     *  실태조사서 상세
     */
    @RequestMapping(value="/factualDetailpage.do")
    public String factualDetailpage(HttpServletRequest request
    		                   ,HttpServletResponse response
    		                   ,@ModelAttribute("factualVO") FactualVO factualVO
    		                   ,ModelMap model) throws Exception
    {
    	request.setCharacterEncoding("UTF-8");
    	response.setCharacterEncoding("UTF-8");
    	
    	
//    	HttpSession session = getSession();
//    	CommonSessionVO commonSessionVO = new CommonSessionVO();
//      commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
//        
//      String board_sno = CommonUtil.NVL(request.getParameter("board_sno"),"");
//      factualVO.setSeq(board_sno);
    	factualVO.setSig(null);
    	List sig_list    = factualService.factualsigList(factualVO);
	   	List code_list    = factualService.factualcodeList(factualVO);
   		model.addAttribute("sig_list", sig_list);
	   	model.addAttribute("code_list", code_list);
	   		
    	FactualVO view01    = factualService.factualselectData(factualVO);
    	model.addAttribute("view01", view01);
    	factualVO.setRow_gid(view01.getGid());
    	factualVO.setGid(null);
    	List data_list = factualService.factualdata(factualVO);
		model.addAttribute("data_list", data_list);
  		
  		
  		factualVO.setEmd(view01.getSig());
    	factualVO.setLi(view01.getEmd());
    	List emd_list    = factualService.factualemdList(factualVO);
    	List li_list    = factualService.factualliList(factualVO);
    	model.addAttribute("emd_list", emd_list);
   		model.addAttribute("li_list", li_list);
   		
   		
  		return "/SH/factual/factual_detail";			
    	
    }
    
    /**
     *  실태조사서 수정 페이지
     */
    @RequestMapping(value="/factualUppage.do")
    public String factualUppage(HttpServletRequest request
    		                   ,HttpServletResponse response
    		                   ,@ModelAttribute("factualVO") FactualVO factualVO
    		                   ,ModelMap model) throws Exception
    {
    	request.setCharacterEncoding("UTF-8");
    	response.setCharacterEncoding("UTF-8");
    	
    	
//    	HttpSession session = getSession();
//    	CommonSessionVO commonSessionVO = new CommonSessionVO();
//      commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); //session가져오기
        
//      String board_sno = CommonUtil.NVL(request.getParameter("tset"),"");
//      factualVO.setSeq(board_sno);
    	factualVO.setSig(null);    	
    	List sig_list    = factualService.factualsigList(factualVO);    	
	   	List code_list    = factualService.factualcodeList(factualVO);
   		model.addAttribute("sig_list", sig_list);
	   	model.addAttribute("code_list", code_list);
	   	
    	factualVO.setGid(request.getParameter("gid"));
    	FactualVO view01    = factualService.factualselectData(factualVO);
    	model.addAttribute("view01", view01);
    	factualVO.setRow_gid(view01.getGid());
    	factualVO.setGid(null);
    	List data_list = factualService.factualdata(factualVO);
		model.addAttribute("data_list", data_list);
		model.addAttribute("fileLength", data_list.size());
  		
  		factualVO.setEmd(view01.getSig());
    	factualVO.setLi(view01.getEmd());
    	List emd_list    = factualService.factualemdList(factualVO);
    	List li_list    = factualService.factualliList(factualVO);
    	model.addAttribute("emd_list", emd_list);
   		model.addAttribute("li_list", li_list);
   		
  		return "/SH/factual/factual_update";			
    	
    }
     
     /**
      * 실태조사서 수정 실행
      */
     @RequestMapping(value="/factualUppageStart.do")
     public String factualUppageStart(@ModelAttribute("factualVO") FactualVO factualVO
                            ,HttpServletRequest  request
                            ,HttpServletResponse response
                            ,ModelMap model
                            ,MultipartHttpServletRequest multiRequest
                            ) throws Exception
     {
    	    	 
//        HttpSession     session         = request.getSession(false);            
//        CommonSessionVO commonSessionVO = null;

//        if (session != null){ commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); }
        
//        if(commonSessionVO != null){ factualVO.setUser_id( StringUtil.nullConvert(commonSessionVO.getUser_id() ) ); /* 사용자ID */ }//end if
//        int boadsnp = Integer.parseInt(CommonUtil.NVL(request.getParameter("tset"),""));
//        factualVO.setSeq_int(boadsnp);      

    	 	
    	 	
    	 	String area = request.getParameter( "area" );
	  		if( area == "" || area == null ){  }else{ factualVO.setArea(area); }
	  		String jiga = request.getParameter( "jiga" );
	  		if( jiga == "" || jiga == null ){  }else{ jiga = jiga.replace(",", ""); factualVO.setJiga(jiga); }
	  		String prsmppc = request.getParameter( "prsmppc" );
	  		if( prsmppc == "" || prsmppc == null ){  }else{ prsmppc = prsmppc.replace(",", ""); factualVO.setPrsmppc(prsmppc); }
	  		String area_1 = request.getParameter( "area_1" );
	  		if( area_1 == "" || area_1 == null ){ }else{ factualVO.setArea_1(area_1); }
	  		String area_2 = request.getParameter( "area_2" );
	  		if( area_2 == "" || area_2 == null ){ }else{ factualVO.setArea_2(area_2); }
	  		String loan_area = request.getParameter( "loan_area" );
	  		if( loan_area == "" || loan_area == null ){ }else{ loan_area = loan_area.replace(" ㎡", ""); factualVO.setLoan_area(loan_area); }
	  		String loan_a_r = request.getParameter( "loan_a_r" );
	  		if( loan_a_r == "" || loan_a_r == null ){  }else{ loan_a_r = loan_a_r.replace(" %", ""); factualVO.setLoan_a_r(loan_a_r); }
	  		String loanmn = request.getParameter( "loanmn" );
	  		if( loanmn == "" || loanmn == null ){  }else{ loanmn = loanmn.replace(",", ""); factualVO.setLoanmn(loanmn); }
	  		String loan_totar = request.getParameter( "loan_totar" );
	  		if( loan_totar == "" || loan_totar == null ){  }else{ loan_totar = loan_totar.replace(" ㎡", ""); factualVO.setLoan_totar(loan_totar); }
	  		String loan_t_r = request.getParameter( "loan_t_r" );
	  		if( loan_t_r == "" || loan_t_r == null ){  }else{ loan_t_r = loan_t_r.replace(" %", ""); factualVO.setLoan_t_r(loan_t_r); }
	  		String occp_area = request.getParameter( "occp_area" );
	  		if( occp_area == "" || occp_area == null ){  }else{ occp_area = occp_area.replace(" ㎡", ""); factualVO.setOccp_area(occp_area); }
	  		String occp_a_r = request.getParameter( "occp_a_r" );
	  		if( occp_a_r == "" || occp_a_r == null ){  }else{ occp_a_r = occp_a_r.replace(" %", ""); factualVO.setOccp_a_r(occp_a_r); }
	  		String own_area = request.getParameter( "own_area" );
	  		if( own_area == "" || own_area == null ){ }else{ factualVO.setOwn_area(own_area); }
	  		String own_totar = request.getParameter( "own_totar" );
	  		if( own_totar == "" || own_totar == null ){  }else{ factualVO.setOwn_totar(own_totar); }
	  		String own_gr = request.getParameter( "own_gr" );
	  		if( own_gr == "" || own_gr == null ){  }else{ own_gr = own_gr.replace(" 층", ""); factualVO.setOwn_gr(own_gr); }
	  		String own_ugr = request.getParameter( "own_ugr" );
	  		if( own_ugr == "" || own_ugr == null ){  }else{ own_ugr = own_ugr.replace(" 층", ""); factualVO.setOwn_ugr(own_ugr); }
	  		
	  		String ic_area = request.getParameter( "ic_area" );
	  		if( ic_area == "" || ic_area == null ){  }else{ factualVO.setIc_area(ic_area); }
	  	  	String ic_prsmppc = request.getParameter( "ic_prsmppc" );
	  		if( ic_prsmppc == "" || ic_prsmppc == null ){  }else{ ic_prsmppc = ic_prsmppc.replace(",", ""); factualVO.setIc_prsmppc(ic_prsmppc); }
	  		String ic_per = request.getParameter( "ic_per" );
	  		if( ic_per == "" || ic_per == null ){  }else{ ic_per = ic_per.replace(" %", ""); factualVO.setIc_per(ic_per); }
	  		String loan_area_1 = request.getParameter( "loan_area_1" );
	  		if( loan_area_1 == "" || loan_area_1 == null ){ }else{ loan_area_1 = loan_area_1.replace(" ㎡", ""); factualVO.setLoan_area_1(loan_area_1); }
	  		String loan_a_r_1 = request.getParameter( "loan_a_r_1" );
	  		if( loan_a_r_1 == "" || loan_a_r_1 == null ){  }else{ loan_a_r_1 = loan_a_r_1.replace(" %", ""); factualVO.setLoan_a_r_1(loan_a_r_1); }
	  		String loanmn_1 = request.getParameter( "loanmn_1" );
	  		if( loanmn_1 == "" || loanmn_1 == null ){  }else{ loanmn_1 = loanmn_1.replace(",", ""); factualVO.setLoanmn_1(loanmn_1); }
	  		String loan_totar_1 = request.getParameter( "loan_totar_1" );
	  		if( loan_totar_1 == "" || loan_totar_1 == null ){  }else{ loan_totar_1 = loan_totar_1.replace(" ㎡", ""); factualVO.setLoan_totar_1(loan_totar_1); }
	  		String loan_t_r_1 = request.getParameter( "loan_t_r_1" );
	  		if( loan_t_r_1 == "" || loan_t_r_1 == null ){  }else{ loan_t_r_1 = loan_t_r_1.replace(" %", ""); factualVO.setLoan_t_r_1(loan_t_r_1); }
	  		String occp_area_1 = request.getParameter( "occp_area_1" );
	  		if( occp_area_1 == "" || occp_area_1 == null ){  }else{ occp_area_1 = occp_area_1.replace(" ㎡", ""); factualVO.setOccp_area_1(occp_area_1); }
	  		String occp_a_r_1 = request.getParameter( "occp_a_r_1" );
	  		if( occp_a_r_1 == "" || occp_a_r_1 == null ){  }else{ occp_a_r_1 = occp_a_r_1.replace(" %", ""); factualVO.setOccp_a_r_1(occp_a_r_1); }
	  		String own_area_1 = request.getParameter( "own_area_1" );
	  		if( own_area_1 == "" || own_area_1 == null ){ }else{ factualVO.setOwn_area_1(own_area_1); }
	  		String own_totar_1 = request.getParameter( "own_totar_1" );
	  		if( own_totar_1 == "" || own_totar_1 == null ){  }else{ factualVO.setOwn_totar_1(own_totar_1); }
	  		String own_gr_1 = request.getParameter( "own_gr_1" );
	  		if( own_gr_1 == "" || own_gr_1 == null ){  }else{ own_gr_1 = own_gr_1.replace(" 층", ""); factualVO.setOwn_gr_1(own_gr_1); }
	  		String own_ugr_1 = request.getParameter( "own_ugr_1" );
	  		if( own_ugr_1 == "" || own_ugr_1 == null ){  }else{ own_ugr_1 = own_ugr_1.replace(" 층", ""); factualVO.setOwn_ugr_1(own_ugr_1); }
	  		String loan_area_2 = request.getParameter( "loan_area_2" );
	  		if( loan_area_2 == "" || loan_area_2 == null ){ }else{ loan_area_2 = loan_area_2.replace(" ㎡", ""); factualVO.setLoan_area_2(loan_area_2); }
	  		String loan_a_r_2 = request.getParameter( "loan_a_r_2" );
	  		if( loan_a_r_2 == "" || loan_a_r_2 == null ){  }else{ loan_a_r_2 = loan_a_r_2.replace(" %", ""); factualVO.setLoan_a_r_2(loan_a_r_2); }
	  		String loanmn_2 = request.getParameter( "loanmn_2" );
	  		if( loanmn_2 == "" || loanmn_2 == null ){  }else{ loanmn_2 = loanmn_2.replace(",", ""); factualVO.setLoanmn_2(loanmn_2); }
	  		String loan_totar_2 = request.getParameter( "loan_totar_2" );
	  		if( loan_totar_2 == "" || loan_totar_2 == null ){  }else{ loan_totar_2 = loan_totar_2.replace(" ㎡", ""); factualVO.setLoan_totar_2(loan_totar_2); }
	  		String loan_t_r_2 = request.getParameter( "loan_t_r_2" );
	  		if( loan_t_r_2 == "" || loan_t_r_2 == null ){  }else{ loan_t_r_2 = loan_t_r_2.replace(" %", ""); factualVO.setLoan_t_r_2(loan_t_r_2); }
	  		String occp_area_2 = request.getParameter( "occp_area_2" );
	  		if( occp_area_2 == "" || occp_area_2 == null ){  }else{ occp_area_2 = occp_area_2.replace(" ㎡", ""); factualVO.setOccp_area_2(occp_area_2); }
	  		String occp_a_r_2 = request.getParameter( "occp_a_r_2" );
	  		if( occp_a_r_2 == "" || occp_a_r_2 == null ){  }else{ occp_a_r_2 = occp_a_r_2.replace(" %", ""); factualVO.setOccp_a_r_2(occp_a_r_2); }
	  		String own_area_2 = request.getParameter( "own_area_2" );
	  		if( own_area_2 == "" || own_area_2 == null ){ }else{ factualVO.setOwn_area_2(own_area_2); }
	  		String own_totar_2 = request.getParameter( "own_totar_2" );
	  		if( own_totar_2 == "" || own_totar_2 == null ){  }else{ factualVO.setOwn_totar_2(own_totar_2); }
	  		String own_gr_2 = request.getParameter( "own_gr_2" );
	  		if( own_gr_2 == "" || own_gr_2 == null ){  }else{ own_gr_2 = own_gr_2.replace(" 층", ""); factualVO.setOwn_gr_2(own_gr_2); }
	  		String own_ugr_2 = request.getParameter( "own_ugr_2" );
	  		if( own_ugr_2 == "" || own_ugr_2 == null ){  }else{ own_ugr_2 = own_ugr_2.replace(" 층", ""); factualVO.setOwn_ugr_2(own_ugr_2); }
	  		String loan_area_3 = request.getParameter( "loan_area_3" );
	  		if( loan_area_3 == "" || loan_area_3 == null ){ }else{ loan_area_3 = loan_area_3.replace(" ㎡", ""); factualVO.setLoan_area_3(loan_area_3); }
	  		String loan_a_r_3 = request.getParameter( "loan_a_r_3" );
	  		if( loan_a_r_3 == "" || loan_a_r_3 == null ){  }else{ loan_a_r_3 = loan_a_r_3.replace(" %", ""); factualVO.setLoan_a_r_3(loan_a_r_3); }
	  		String loanmn_3 = request.getParameter( "loanmn_3" );
	  		if( loanmn_3 == "" || loanmn_3 == null ){  }else{ loanmn_3 = loanmn_3.replace(",", ""); factualVO.setLoanmn_3(loanmn_3); }
	  		String loan_totar_3 = request.getParameter( "loan_totar_3" );
	  		if( loan_totar_3 == "" || loan_totar_3 == null ){  }else{ loan_totar_3 = loan_totar_3.replace(" ㎡", ""); factualVO.setLoan_totar_3(loan_totar_3); }
	  		String loan_t_r_3 = request.getParameter( "loan_t_r_3" );
	  		if( loan_t_r_3 == "" || loan_t_r_3 == null ){  }else{ loan_t_r_3 = loan_t_r_3.replace(" %", ""); factualVO.setLoan_t_r_3(loan_t_r_3); }
	  		String occp_area_3 = request.getParameter( "occp_area_3" );
	  		if( occp_area_3 == "" || occp_area_3 == null ){  }else{ occp_area_3 = occp_area_3.replace(" ㎡", ""); factualVO.setOccp_area_3(occp_area_3); }
	  		String occp_a_r_3 = request.getParameter( "occp_a_r_3" );
	  		if( occp_a_r_3 == "" || occp_a_r_3 == null ){  }else{ occp_a_r_3 = occp_a_r_3.replace(" %", ""); factualVO.setOccp_a_r_3(occp_a_r_3); }
	  		String own_area_3 = request.getParameter( "own_area_3" );
	  		if( own_area_3 == "" || own_area_3 == null ){ }else{ factualVO.setOwn_area_3(own_area_3); }
	  		String own_totar_3 = request.getParameter( "own_totar_3" );
	  		if( own_totar_3 == "" || own_totar_3 == null ){  }else{ factualVO.setOwn_totar_3(own_totar_3); }
	  		String own_gr_3 = request.getParameter( "own_gr_3" );
	  		if( own_gr_3 == "" || own_gr_3 == null ){  }else{ own_gr_3 = own_gr_3.replace(" 층", ""); factualVO.setOwn_gr_3(own_gr_3); }
	  		String own_ugr_3 = request.getParameter( "own_ugr_3" );
	  		if( own_ugr_3 == "" || own_ugr_3 == null ){  }else{ own_ugr_3 = own_ugr_3.replace(" 층", ""); factualVO.setOwn_ugr_3(own_ugr_3); }
	  		String loan_area_4 = request.getParameter( "loan_area_4" );
	  		if( loan_area_4 == "" || loan_area_4 == null ){ }else{ loan_area_4 = loan_area_4.replace(" ㎡", ""); factualVO.setLoan_area_4(loan_area_4); }
	  		String loan_a_r_4 = request.getParameter( "loan_a_r_4" );
	  		if( loan_a_r_4 == "" || loan_a_r_4 == null ){  }else{ loan_a_r_4 = loan_a_r_4.replace(" %", ""); factualVO.setLoan_a_r_4(loan_a_r_4); }
	  		String loanmn_4 = request.getParameter( "loanmn_4" );
	  		if( loanmn_4 == "" || loanmn_4 == null ){  }else{ loanmn_4 = loanmn_4.replace(",", ""); factualVO.setLoanmn_4(loanmn_4); }
	  		String loan_totar_4 = request.getParameter( "loan_totar_4" );
	  		if( loan_totar_4 == "" || loan_totar_4 == null ){  }else{ loan_totar_4 = loan_totar_4.replace(" ㎡", ""); factualVO.setLoan_totar_4(loan_totar_4); }
	  		String loan_t_r_4 = request.getParameter( "loan_t_r_4" );
	  		if( loan_t_r_4 == "" || loan_t_r_4 == null ){  }else{ loan_t_r_4 = loan_t_r_4.replace(" %", ""); factualVO.setLoan_t_r_4(loan_t_r_4); }
	  		String occp_area_4 = request.getParameter( "occp_area_4" );
	  		if( occp_area_4 == "" || occp_area_4 == null ){  }else{ occp_area_4 = occp_area_4.replace(" ㎡", ""); factualVO.setOccp_area_4(occp_area_4); }
	  		String occp_a_r_4 = request.getParameter( "occp_a_r_4" );
	  		if( occp_a_r_4 == "" || occp_a_r_4 == null ){  }else{ occp_a_r_4 = occp_a_r_4.replace(" %", ""); factualVO.setOccp_a_r_4(occp_a_r_4); }
	  		String own_area_4 = request.getParameter( "own_area_4" );
	  		if( own_area_4 == "" || own_area_4 == null ){ }else{ factualVO.setOwn_area_4(own_area_4); }
	  		String own_totar_4 = request.getParameter( "own_totar_4" );
	  		if( own_totar_4 == "" || own_totar_4 == null ){  }else{ factualVO.setOwn_totar_4(own_totar_4); }
	  		String own_gr_4 = request.getParameter( "own_gr_4" );
	  		if( own_gr_4 == "" || own_gr_4 == null ){  }else{ own_gr_4 = own_gr_4.replace(" 층", ""); factualVO.setOwn_gr_4(own_gr_4); }
	  		String own_ugr_4 = request.getParameter( "own_ugr_4" );
	  		if( own_ugr_4 == "" || own_ugr_4 == null ){  }else{ own_ugr_4 = own_ugr_4.replace(" 층", ""); factualVO.setOwn_ugr_4(own_ugr_4); }
	  		
	  		factualVO.setUpdt_id("admin");
 	 	
 	 		String pnu = null;
			if( !request.getParameter( "li" ).equals("00") ){ pnu = request.getParameter( "li" ) + request.getParameter( "mt" ); }
			else{ pnu = request.getParameter( "emd" ) + request.getParameter( "li" ) + request.getParameter( "mt" ); }
			String bon = request.getParameter( "bon" );
			String bu = request.getParameter( "bu" );
			System.out.println("bon::::::"+ bon);
			if( bon.length() == 1 ){ bon = "000" + bon; }
			else if( bon.length() == 2 ){ bon = "00" + bon; }
			else if( bon.length() == 3 ){ bon = "0" + bon; }
			if( bu.length() == 1 ){ bu = "000" + bu; }
			else if( bu.length() == 2 ){ bu = "00" + bu; }
			else if( bu.length() == 3 ){ bu = "0" + bu; }
			else if( bu.length() == 4 ){ bu = "" + bu; }
			else{ bu = "0000"; }
			pnu = pnu + bon + bu;
			System.out.println("::: pnu :::: " + pnu);
			if( request.getParameter( "factual_file" ).equals("Y") ){ factualVO.setSttus_ph("Y"); }else{ factualVO.setSttus_ph("N"); }
//        if("admin".equals(commonSessionVO.getUser_id()))
//        {
            
			factualVO.setPnu(pnu);
			factualVO.setDelfile(request.getParameter( "delFile" ));
  	  		factualService.factualupdate(factualVO, multiRequest);
  	  		
  	  		//파일 저장
  	  		String gid = request.getParameter("gid");
  	  		factualVO.setGid(gid);
    		commonservice.saveFile(String.valueOf(gid), "factual", multiRequest );
  	  		jsHelper.Alert("입력이 완료 되었습니다.");
//  	  		jsHelper.AlertAndUrlGo("입력이 완료 되었습니다.", "/factualListPage.do");
  	  		return "redirect:/factualListPage.do";
  	  		
//        	factualService.updatefactualupt(factualVO);            
//           jsHelper.AlertAndUrlGo("수정이 완료 되었습니다.", "/factualListPage.do");
        	      
//        }else{
//      	  
//      	 jsHelper.AlertAndUrlGo("권한이 불충분 합니다.", "/factualListPage.do");
//        	
//        }     
     } 
     
     /**
      *  실태조사서 입력 페이지
      */
     @RequestMapping(value="/factualInsert.do")
     public String factualInsert(HttpServletRequest request
     		                   ,HttpServletResponse response
     		                  ,@ModelAttribute("factualVO") FactualVO factualVO
     		                   ,ModelMap model) throws Exception
     {
     		request.setCharacterEncoding("UTF-8");
  	   	response.setCharacterEncoding("UTF-8");
  	   	
  	   	
//  	   	HttpSession session = getSession();
//  	   	CommonSessionVO commonSessionVO = new CommonSessionVO();
//  	    commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); 
  	       
//  	    String user_ids = CommonUtil.NVL(commonSessionVO.getUser_id(),"");
//  	    if("admin".equals(user_ids)){
  	    	
  	   	
  	   		List sig_list    = factualService.factualsigList(factualVO);
  	   		List code_list    = factualService.factualcodeList(factualVO);
	   		model.addAttribute("sig_list", sig_list);
  	   		model.addAttribute("code_list", code_list);
  	   		
  	     	return "/SH/factual/factual_reg";		
  	    	
//  	    }else{
//  	    	
//  	       jsHelper.Alert("권한이 불충분 합니다.");
//  	       return "/SH/factual/factual_list";
//  	    }	
  	   	
     }
     
     /**
      * postsql 읍면동 조회
      */
     @RequestMapping(value="/ajaxDB_factual_emd.do")
     public void ajaxDB_factual_emd(HttpServletRequest request,HttpServletResponse response, FactualVO factualVO) throws Exception
     {
     	response.setCharacterEncoding("UTF-8");
 		
 		String sig = request.getParameter( "sigcd" ); 		
 		factualVO.setSig(sig);
 		
 		List this_list = factualService.factualemdList(factualVO);
 				
 		JSONArray emd_cd = new JSONArray();
 		JSONArray emd_kor_nm = new JSONArray();
 		JSONObject obj = new JSONObject();
 		
 		if( this_list != null && this_list.size() > 0 ) {
 			for( int i=0; i<this_list.size(); i++ ) {
 				HashMap result = ( HashMap )this_list.get(i);
 				emd_cd.add(result.get("emd_cd"));
 				emd_kor_nm.add(result.get("emd_kor_nm"));
 			}
 		}
 		obj.put("emd_cd", emd_cd);
 		obj.put("emd_kor_nm", emd_kor_nm);
 		PrintWriter out = response.getWriter();
 		System.out.println(obj.toString());
 		out.println(obj.toString());
     }
     
     /**
      * postsql 리 조회
      */
     @RequestMapping(value="/ajaxDB_factual_li.do")
     public void ajaxDB_factual_li(HttpServletRequest request,HttpServletResponse response, FactualVO factualVO) throws Exception
     {
     	response.setCharacterEncoding("UTF-8");
 		
 		String emd = request.getParameter( "emdcd" ); 		
 		factualVO.setEmd(emd);
 		
 		List this_list = factualService.factualliList(factualVO);
 				
 		JSONArray li_cd = new JSONArray();
 		JSONArray li_kor_nm = new JSONArray();
 		JSONObject obj = new JSONObject();
 		
 		if( this_list != null && this_list.size() > 0 ) {
 			for( int i=0; i<this_list.size(); i++ ) {
 				HashMap result = ( HashMap )this_list.get(i);
 				li_cd.add(result.get("li_cd"));
 				li_kor_nm.add(result.get("li_kor_nm"));
 			}
 		}
 		obj.put("li_cd", li_cd);
 		obj.put("li_kor_nm", li_kor_nm);
 		PrintWriter out = response.getWriter();
 		System.out.println(obj.toString());
 		out.println(obj.toString());
     }
     
     /**
      * 실태조사서 입력 실행
      */
     @RequestMapping(value="/factualInserteStart.do")
     public String factualInserteStart(@ModelAttribute("factualVO") FactualVO factualVO
                            ,HttpServletRequest  request
                            ,HttpServletResponse response
                            ,ModelMap model
                            ,MultipartHttpServletRequest multiRequest
                            ) throws Exception
     {
    	    	 
//        HttpSession     session         = request.getSession(false);            
//        CommonSessionVO commonSessionVO = null;

//        if (session != null){ commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); }
        
//        if(commonSessionVO != null){ factualVO.setUser_id( StringUtil.nullConvert(commonSessionVO.getUser_id() ) ); /* 사용자ID */ }//end if
//        factualVO.setBoard_gubun("factual");
//        factualVO.setUser_name("관리자");      

  	  		String area = request.getParameter( "area" );
  	  		if( area == "" || area == null ){  }else{ factualVO.setArea(area); }
  	  		String jiga = request.getParameter( "jiga" );
	  		if( jiga == "" || jiga == null ){  }else{ jiga = jiga.replace(",", ""); factualVO.setJiga(jiga); }
	  		String prsmppc = request.getParameter( "prsmppc" );
	  		if( prsmppc == "" || prsmppc == null ){  }else{ prsmppc = prsmppc.replace(",", ""); factualVO.setPrsmppc(prsmppc); }
	  		String area_1 = request.getParameter( "area_1" );
  	  		if( area_1 == "" || area_1 == null ){ }else{ factualVO.setArea_1(area_1); }
  	  		String area_2 = request.getParameter( "area_2" );
	  		if( area_2 == "" || area_2 == null ){ }else{ factualVO.setArea_2(area_2); }
	  		String loan_area = request.getParameter( "loan_area" );
	  		if( loan_area == "" || loan_area == null ){ }else{ loan_area = loan_area.replace(" ㎡", ""); factualVO.setLoan_area(loan_area); }
	  		String loan_a_r = request.getParameter( "loan_a_r" );
	  		if( loan_a_r == "" || loan_a_r == null ){  }else{ loan_a_r = loan_a_r.replace(" %", ""); factualVO.setLoan_a_r(loan_a_r); }
	  		String loanmn = request.getParameter( "loanmn" );
	  		if( loanmn == "" || loanmn == null ){  }else{ loanmn = loanmn.replace(",", ""); factualVO.setLoanmn(loanmn); }
	  		String loan_totar = request.getParameter( "loan_totar" );
	  		if( loan_totar == "" || loan_totar == null ){  }else{ loan_totar = loan_totar.replace(" ㎡", ""); factualVO.setLoan_totar(loan_totar); }
	  		String loan_t_r = request.getParameter( "loan_t_r" );
	  		if( loan_t_r == "" || loan_t_r == null ){  }else{ loan_t_r = loan_t_r.replace(" %", ""); factualVO.setLoan_t_r(loan_t_r); }
	  		String occp_area = request.getParameter( "occp_area" );
	  		if( occp_area == "" || occp_area == null ){  }else{ occp_area = occp_area.replace(" ㎡", ""); factualVO.setOccp_area(occp_area); }
	  		String occp_a_r = request.getParameter( "occp_a_r" );
	  		if( occp_a_r == "" || occp_a_r == null ){  }else{ occp_a_r = occp_a_r.replace(" %", ""); factualVO.setOccp_a_r(occp_a_r); }
	  		String own_area = request.getParameter( "own_area" );
  	  		if( own_area == "" || own_area == null ){ }else{ factualVO.setOwn_area(own_area); }
  	  		String own_totar = request.getParameter( "own_totar" );
	  		if( own_totar == "" || own_totar == null ){  }else{ factualVO.setOwn_totar(own_totar); }
	  		String own_gr = request.getParameter( "own_gr" );
	  		if( own_gr == "" || own_gr == null ){  }else{ own_gr = own_gr.replace(" 층", ""); factualVO.setOwn_gr(own_gr); }
	  		String own_ugr = request.getParameter( "own_ugr" );
	  		if( own_ugr == "" || own_ugr == null ){  }else{ own_ugr = own_ugr.replace(" 층", ""); factualVO.setOwn_ugr(own_ugr); }
	  		
	  		String ic_area = request.getParameter( "ic_area" );
  	  		if( ic_area == "" || ic_area == null ){  }else{ factualVO.setIc_area(ic_area); }
	  	  	String ic_prsmppc = request.getParameter( "ic_prsmppc" );
	  		if( ic_prsmppc == "" || ic_prsmppc == null ){  }else{ ic_prsmppc = ic_prsmppc.replace(",", ""); factualVO.setIc_prsmppc(ic_prsmppc); }
	  		String ic_per = request.getParameter( "ic_per" );
	  		if( ic_per == "" || ic_per == null ){  }else{ ic_per = ic_per.replace(" %", ""); factualVO.setIc_per(ic_per); }
	  		String loan_area_1 = request.getParameter( "loan_area_1" );
	  		if( loan_area_1 == "" || loan_area_1 == null ){ }else{ loan_area_1 = loan_area_1.replace(" ㎡", ""); factualVO.setLoan_area_1(loan_area_1); }
	  		String loan_a_r_1 = request.getParameter( "loan_a_r_1" );
	  		if( loan_a_r_1 == "" || loan_a_r_1 == null ){  }else{ loan_a_r_1 = loan_a_r_1.replace(" %", ""); factualVO.setLoan_a_r_1(loan_a_r_1); }
	  		String loanmn_1 = request.getParameter( "loanmn_1" );
	  		if( loanmn_1 == "" || loanmn_1 == null ){  }else{ loanmn_1 = loanmn_1.replace(",", ""); factualVO.setLoanmn_1(loanmn_1); }
	  		String loan_totar_1 = request.getParameter( "loan_totar_1" );
	  		if( loan_totar_1 == "" || loan_totar_1 == null ){  }else{ loan_totar_1 = loan_totar_1.replace(" ㎡", ""); factualVO.setLoan_totar_1(loan_totar_1); }
	  		String loan_t_r_1 = request.getParameter( "loan_t_r_1" );
	  		if( loan_t_r_1 == "" || loan_t_r_1 == null ){  }else{ loan_t_r_1 = loan_t_r_1.replace(" %", ""); factualVO.setLoan_t_r_1(loan_t_r_1); }
	  		String occp_area_1 = request.getParameter( "occp_area_1" );
	  		if( occp_area_1 == "" || occp_area_1 == null ){  }else{ occp_area_1 = occp_area_1.replace(" ㎡", ""); factualVO.setOccp_area_1(occp_area_1); }
	  		String occp_a_r_1 = request.getParameter( "occp_a_r_1" );
	  		if( occp_a_r_1 == "" || occp_a_r_1 == null ){  }else{ occp_a_r_1 = occp_a_r_1.replace(" %", ""); factualVO.setOccp_a_r_1(occp_a_r_1); }
	  		String own_area_1 = request.getParameter( "own_area_1" );
  	  		if( own_area_1 == "" || own_area_1 == null ){ }else{ factualVO.setOwn_area_1(own_area_1); }
  	  		String own_totar_1 = request.getParameter( "own_totar_1" );
	  		if( own_totar_1 == "" || own_totar_1 == null ){  }else{ factualVO.setOwn_totar_1(own_totar_1); }
	  		String own_gr_1 = request.getParameter( "own_gr_1" );
	  		if( own_gr_1 == "" || own_gr_1 == null ){  }else{ own_gr_1 = own_gr_1.replace(" 층", ""); factualVO.setOwn_gr_1(own_gr_1); }
	  		String own_ugr_1 = request.getParameter( "own_ugr_1" );
	  		if( own_ugr_1 == "" || own_ugr_1 == null ){  }else{ own_ugr_1 = own_ugr_1.replace(" 층", ""); factualVO.setOwn_ugr_1(own_ugr_1); }
	  		String loan_area_2 = request.getParameter( "loan_area_2" );
	  		if( loan_area_2 == "" || loan_area_2 == null ){ }else{ loan_area_2 = loan_area_2.replace(" ㎡", ""); factualVO.setLoan_area_2(loan_area_2); }
	  		String loan_a_r_2 = request.getParameter( "loan_a_r_2" );
	  		if( loan_a_r_2 == "" || loan_a_r_2 == null ){  }else{ loan_a_r_2 = loan_a_r_2.replace(" %", ""); factualVO.setLoan_a_r_2(loan_a_r_2); }
	  		String loanmn_2 = request.getParameter( "loanmn_2" );
	  		if( loanmn_2 == "" || loanmn_2 == null ){  }else{ loanmn_2 = loanmn_2.replace(",", ""); factualVO.setLoanmn_2(loanmn_2); }
	  		String loan_totar_2 = request.getParameter( "loan_totar_2" );
	  		if( loan_totar_2 == "" || loan_totar_2 == null ){  }else{ loan_totar_2 = loan_totar_2.replace(" ㎡", ""); factualVO.setLoan_totar_2(loan_totar_2); }
	  		String loan_t_r_2 = request.getParameter( "loan_t_r_2" );
	  		if( loan_t_r_2 == "" || loan_t_r_2 == null ){  }else{ loan_t_r_2 = loan_t_r_2.replace(" %", ""); factualVO.setLoan_t_r_2(loan_t_r_2); }
	  		String occp_area_2 = request.getParameter( "occp_area_2" );
	  		if( occp_area_2 == "" || occp_area_2 == null ){  }else{ occp_area_2 = occp_area_2.replace(" ㎡", ""); factualVO.setOccp_area_2(occp_area_2); }
	  		String occp_a_r_2 = request.getParameter( "occp_a_r_2" );
	  		if( occp_a_r_2 == "" || occp_a_r_2 == null ){  }else{ occp_a_r_2 = occp_a_r_2.replace(" %", ""); factualVO.setOccp_a_r_2(occp_a_r_2); }
	  		String own_area_2 = request.getParameter( "own_area_2" );
  	  		if( own_area_2 == "" || own_area_2 == null ){ }else{ factualVO.setOwn_area_2(own_area_2); }
  	  		String own_totar_2 = request.getParameter( "own_totar_2" );
	  		if( own_totar_2 == "" || own_totar_2 == null ){  }else{ factualVO.setOwn_totar_2(own_totar_2); }
	  		String own_gr_2 = request.getParameter( "own_gr_2" );
	  		if( own_gr_2 == "" || own_gr_2 == null ){  }else{ own_gr_2 = own_gr_2.replace(" 층", ""); factualVO.setOwn_gr_2(own_gr_2); }
	  		String own_ugr_2 = request.getParameter( "own_ugr_2" );
	  		if( own_ugr_2 == "" || own_ugr_2 == null ){  }else{ own_ugr_2 = own_ugr_2.replace(" 층", ""); factualVO.setOwn_ugr_2(own_ugr_2); }
	  		String loan_area_3 = request.getParameter( "loan_area_3" );
	  		if( loan_area_3 == "" || loan_area_3 == null ){ }else{ loan_area_3 = loan_area_3.replace(" ㎡", ""); factualVO.setLoan_area_3(loan_area_3); }
	  		String loan_a_r_3 = request.getParameter( "loan_a_r_3" );
	  		if( loan_a_r_3 == "" || loan_a_r_3 == null ){  }else{ loan_a_r_3 = loan_a_r_3.replace(" %", ""); factualVO.setLoan_a_r_3(loan_a_r_3); }
	  		String loanmn_3 = request.getParameter( "loanmn_3" );
	  		if( loanmn_3 == "" || loanmn_3 == null ){  }else{ loanmn_3 = loanmn_3.replace(",", ""); factualVO.setLoanmn_3(loanmn_3); }
	  		String loan_totar_3 = request.getParameter( "loan_totar_3" );
	  		if( loan_totar_3 == "" || loan_totar_3 == null ){  }else{ loan_totar_3 = loan_totar_3.replace(" ㎡", ""); factualVO.setLoan_totar_3(loan_totar_3); }
	  		String loan_t_r_3 = request.getParameter( "loan_t_r_3" );
	  		if( loan_t_r_3 == "" || loan_t_r_3 == null ){  }else{ loan_t_r_3 = loan_t_r_3.replace(" %", ""); factualVO.setLoan_t_r_3(loan_t_r_3); }
	  		String occp_area_3 = request.getParameter( "occp_area_3" );
	  		if( occp_area_3 == "" || occp_area_3 == null ){  }else{ occp_area_3 = occp_area_3.replace(" ㎡", ""); factualVO.setOccp_area_3(occp_area_3); }
	  		String occp_a_r_3 = request.getParameter( "occp_a_r_3" );
	  		if( occp_a_r_3 == "" || occp_a_r_3 == null ){  }else{ occp_a_r_3 = occp_a_r_3.replace(" %", ""); factualVO.setOccp_a_r_3(occp_a_r_3); }
	  		String own_area_3 = request.getParameter( "own_area_3" );
  	  		if( own_area_3 == "" || own_area_3 == null ){ }else{ factualVO.setOwn_area_3(own_area_3); }
  	  		String own_totar_3 = request.getParameter( "own_totar_3" );
	  		if( own_totar_3 == "" || own_totar_3 == null ){  }else{ factualVO.setOwn_totar_3(own_totar_3); }
	  		String own_gr_3 = request.getParameter( "own_gr_3" );
	  		if( own_gr_3 == "" || own_gr_3 == null ){  }else{ own_gr_3 = own_gr_3.replace(" 층", ""); factualVO.setOwn_gr_3(own_gr_3); }
	  		String own_ugr_3 = request.getParameter( "own_ugr_3" );
	  		if( own_ugr_3 == "" || own_ugr_3 == null ){  }else{ own_ugr_3 = own_ugr_3.replace(" 층", ""); factualVO.setOwn_ugr_3(own_ugr_3); }
	  		String loan_area_4 = request.getParameter( "loan_area_4" );
	  		if( loan_area_4 == "" || loan_area_4 == null ){ }else{ loan_area_4 = loan_area_4.replace(" ㎡", ""); factualVO.setLoan_area_4(loan_area_4); }
	  		String loan_a_r_4 = request.getParameter( "loan_a_r_4" );
	  		if( loan_a_r_4 == "" || loan_a_r_4 == null ){  }else{ loan_a_r_4 = loan_a_r_4.replace(" %", ""); factualVO.setLoan_a_r_4(loan_a_r_4); }
	  		String loanmn_4 = request.getParameter( "loanmn_4" );
	  		if( loanmn_4 == "" || loanmn_4 == null ){  }else{ loanmn_4 = loanmn_4.replace(",", ""); factualVO.setLoanmn_4(loanmn_4); }
	  		String loan_totar_4 = request.getParameter( "loan_totar_4" );
	  		if( loan_totar_4 == "" || loan_totar_4 == null ){  }else{ loan_totar_4 = loan_totar_4.replace(" ㎡", ""); factualVO.setLoan_totar_4(loan_totar_4); }
	  		String loan_t_r_4 = request.getParameter( "loan_t_r_4" );
	  		if( loan_t_r_4 == "" || loan_t_r_4 == null ){  }else{ loan_t_r_4 = loan_t_r_4.replace(" %", ""); factualVO.setLoan_t_r_4(loan_t_r_4); }
	  		String occp_area_4 = request.getParameter( "occp_area_4" );
	  		if( occp_area_4 == "" || occp_area_4 == null ){  }else{ occp_area_4 = occp_area_4.replace(" ㎡", ""); factualVO.setOccp_area_4(occp_area_4); }
	  		String occp_a_r_4 = request.getParameter( "occp_a_r_4" );
	  		if( occp_a_r_4 == "" || occp_a_r_4 == null ){  }else{ occp_a_r_4 = occp_a_r_4.replace(" %", ""); factualVO.setOccp_a_r_4(occp_a_r_4); }
	  		String own_area_4 = request.getParameter( "own_area_4" );
  	  		if( own_area_4 == "" || own_area_4 == null ){ }else{ factualVO.setOwn_area_4(own_area_4); }
  	  		String own_totar_4 = request.getParameter( "own_totar_4" );
	  		if( own_totar_4 == "" || own_totar_4 == null ){  }else{ factualVO.setOwn_totar_4(own_totar_4); }
	  		String own_gr_4 = request.getParameter( "own_gr_4" );
	  		if( own_gr_4 == "" || own_gr_4 == null ){  }else{ own_gr_4 = own_gr_4.replace(" 층", ""); factualVO.setOwn_gr_4(own_gr_4); }
	  		String own_ugr_4 = request.getParameter( "own_ugr_4" );
	  		if( own_ugr_4 == "" || own_ugr_4 == null ){  }else{ own_ugr_4 = own_ugr_4.replace(" 층", ""); factualVO.setOwn_ugr_4(own_ugr_4); }
	  		
    	 	factualVO.setRegest_id("admin");
    	 	factualVO.setUse_at("Y");
    	 	
    	 	String pnu = null;
			if( !request.getParameter( "li" ).equals("00") ){ pnu = request.getParameter( "li" ) + request.getParameter( "mt" ); }
			else{ pnu = request.getParameter( "emd" ) + request.getParameter( "li" ) + request.getParameter( "mt" ); }
			String bon = request.getParameter( "bon" );
			String bu = request.getParameter( "bu" );
			System.out.println("bon::::::"+ bon);
			if( bon.length() == 1 ){ bon = "000" + bon; }
			else if( bon.length() == 2 ){ bon = "00" + bon; }
			else if( bon.length() == 3 ){ bon = "0" + bon; }
			if( bu.length() == 1 ){ bu = "000" + bu; }
			else if( bu.length() == 2 ){ bu = "00" + bu; }
			else if( bu.length() == 3 ){ bu = "0" + bu; }
			else if( bu.length() == 4 ){ bu = "" + bu; }
			else{ bu = "0000"; }
			pnu = pnu + bon + bu;
			System.out.println("::: pnu :::: " + pnu);
			if( request.getParameter( "factual_file" ).equals("Y") ){ factualVO.setSttus_ph("Y"); }else{ factualVO.setSttus_ph("N"); }
		
//        if("admin".equals(commonSessionVO.getUser_id()))
//        {  	 
			factualVO.setPnu(pnu);
  	  		factualService.factualInserteStart(factualVO);
  	  		int max_gid = factualService.MaxFileGID(factualVO);
  	  		
  	  		//파일 저장    
    		commonservice.saveFile(String.valueOf(max_gid), "factual", multiRequest );
  	  		jsHelper.Alert("입력이 완료 되었습니다.");
//  	  		jsHelper.AlertAndUrlGo("입력이 완료 되었습니다.", "/factualListPage.do");
 
  	  		return "redirect:/factualListPage.do";
        	      
//        }else{
//      	  
//      	 jsHelper.AlertAndUrlGo("권한이 불충분 합니다..", "/factualListPage.do");
//        	
//        }     
  	  		
     } 
     
     /* 첨부파일  다운로드  */
     @RequestMapping(value="/Filedownload_object.do")
 	public void Filedownload_object(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception 
 	{    	
     	response.setCharacterEncoding("UTF-8");
     	request.setCharacterEncoding("UTF-8");
     	
     	System.out.println(" ::::::::::::::::::::::::::::::: 접속 성공  :::::::::::::::::::::::::::::::");

    	String gid = request.getParameter("gid");
    	
 		fileUtil.downFile2(request, response, gid);
 				
     }
     
     /**
      * 실태조사서 삭제
      */
     @RequestMapping(value="/factualDelStart.do")
     public String nDelStart(@ModelAttribute("factualVO") FactualVO factualVO
                            ,HttpServletRequest  request
                            ,HttpServletResponse response
                            ,ModelMap model
                            ) throws Exception
     {
    	    	 
//        HttpSession     session         = request.getSession(false);            
//        CommonSessionVO commonSessionVO = null;

//        if (session != null){ commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO"); }
        
//        if(commonSessionVO != null){ factualVO.setUser_id( StringUtil.nullConvert(commonSessionVO.getUser_id() ) ); /* 사용자ID */ }//end if
//        int boadsnp = Integer.parseInt(CommonUtil.NVL(request.getParameter("tset"),""));
//        String idss = CommonUtil.NVL(request.getParameter("ids"),"");
//        factualVO.setSeq_int(boadsnp);
        
//        if("admin".equals(commonSessionVO.getUser_id()))
//        {
            
//        	factualService.qDelStar(factualVO);            
//           jsHelper.AlertAndUrlGo("삭제가 완료 되었습니다.", "/factualListPage.do");
        	      
//        }else{      	  
//      	 jsHelper.AlertAndUrlGo("권한이 불충분 합니다.", "/factualListPage.do");        	
//        }   
    	 factualVO.setGid(request.getParameter("gid"));
    	 factualService.deletefactualData(factualVO);
		 model.addAttribute("gid", factualVO.getGid());
    	 return "redirect:/factualListPage.do";
     } 
     
    
     /**
      *  실태조사서 검색      */
     @RequestMapping(value="/search_factual.do")
     public void search_factual(HttpServletRequest request
     		                   ,HttpServletResponse response
     		                  ,@ModelAttribute("factualVO") FactualVO factualVO
     		                   ,ModelMap model) throws Exception
     {
     		request.setCharacterEncoding("UTF-8");
  	   		response.setCharacterEncoding("UTF-8");
  	   	  	
  	   		String sig = request.getParameter( "sig" );
	  	   	String emd = request.getParameter( "emd" );
	  	   	String li = request.getParameter( "li" );
	  	   	String mt = request.getParameter( "mt" );
	  	   	String bon = request.getParameter( "bon" );
	  	   	String bu = request.getParameter( "bu" );
	 		factualVO.setSig(sig);
	 		factualVO.setEmd(emd);
	 		factualVO.setLi(li);
	 		factualVO.setMt(mt);
	 		factualVO.setBon(bon);
	 		factualVO.setBu(bu);
	 		
	 		List this_list = factualService.factualliList(factualVO);
	 				
	 		JSONArray li_cd = new JSONArray();
	 		JSONArray li_kor_nm = new JSONArray();
	 		JSONObject obj = new JSONObject();
	 		
	 		if( this_list != null && this_list.size() > 0 ) {
	 			for( int i=0; i<this_list.size(); i++ ) {
	 				HashMap result = ( HashMap )this_list.get(i);
	 				li_cd.add(result.get("li_cd"));
	 				li_kor_nm.add(result.get("li_kor_nm"));
	 			}
	 		}
	 		obj.put("li_cd", li_cd);
	 		obj.put("li_kor_nm", li_kor_nm);
	 		PrintWriter out = response.getWriter();
	 		System.out.println(obj.toString());
	 		out.println(obj.toString());
  	   	
     }
     
   //실태조사서 엑셀 다운로드
     @RequestMapping(value="/factual_Excel_Download.do")
     public void factual_Excel_Download(HttpServletRequest request,HttpServletResponse response, ModelMap model, @ModelAttribute("factualVO") FactualVO factualVO) throws Exception
     {
     	request.setCharacterEncoding("UTF-8");
     	response.setCharacterEncoding("UTF-8");
     	
     	factualVO.setSig(request.getParameter("sig"));
     	factualVO.setEmd(request.getParameter("emd"));
     	factualVO.setLi(request.getParameter("li"));
     	List dataList =  factualService.factualSearchList( factualVO );   
 				
 		if( dataList != null && dataList.size() > 0 ) {
 			
 			SimpleDateFormat formatter = new SimpleDateFormat ( "yyyyMMddHHmmss", Locale.KOREA );
 			Date currentTime = new Date();
 			String dTime = formatter.format ( currentTime );
 			
 			String fileName = dTime+"_"+"down.xls";
 			String fullPathName = Globals.FILE_STORE_PATH + "\\" + fileName;
 			
 			// 엑셀파일 생성
 			File file = new File( fullPathName );
 			WritableWorkbook workbook = Workbook.createWorkbook(file);
 			
 			// 셀 포맷 정의
 			WritableCellFormat h_format = new WritableCellFormat();
 			h_format.setAlignment( Alignment.CENTRE );
 			h_format.setVerticalAlignment( VerticalAlignment.CENTRE ); 
 			h_format.setFont( new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE, Colour.BLACK, ScriptStyle.NORMAL_SCRIPT ) );
 			
 			WritableCellFormat c_format = new WritableCellFormat();
 			c_format.setAlignment( Alignment.CENTRE );
 			c_format.setVerticalAlignment( VerticalAlignment.CENTRE ); 
 			c_format.setFont( new WritableFont(WritableFont.ARIAL, 10, WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE, Colour.BLACK, ScriptStyle.NORMAL_SCRIPT ) );
 			
 			/* ---------------------------------------------------------------------------------- */
 			WritableSheet sheet1 = workbook.createSheet( "검색결과", 0 );
 			
 			// 제목셀 정의
 			sheet1.mergeCells(0,0, 0,2);
 			sheet1.addCell( new Label(0,0, "연번", h_format) );
 			
 			String[] kind_col = {"법적분류", "중분류", "소분류"};
 			sheet1.mergeCells(1,0, 1+kind_col.length-1,1);
 			sheet1.addCell( new Label(1,0, "재산의 1차(이용현황) 분류", h_format) );
 			for( int i=0; i<kind_col.length; i++ ) {
 				sheet1.addCell( new Label(1+i,2, kind_col[i], h_format) );
 			}
 			
 			int basic = kind_col.length + 1;
 			String[] basic_col = {"소재지", "PNU", "시도", "시군구", "읍면동", "리", "산여부", "본번", "부번", "재산관리관", "공부지목", 
 					"소유권 및 지분", "취득원인", "현황지목", "취득일자", "이용현황", "면적(㎡)", "개별공시지가(원/㎡)", "지분률(%)", "재산면적", 
 					"추정가격(원)", "장부가격(기준가액)", "용도지역·지구·구역", "기타이용제한사항", "도시계획시설"};
 			sheet1.mergeCells(basic,0, basic+basic_col.length-1,1);
 			sheet1.addCell( new Label(basic,0, "재산의 표시", h_format) );
 			for( int i=0; i<basic_col.length; i++ ) {
 				sheet1.addCell( new Label(basic+i,2, basic_col[i], h_format) );
 			}
 			
 			
 			int land = basic + basic_col.length;
 			String[] land_col = {"형상(모양)", "지세(고저)", "도로접합현황"};
 			String[] land_col_de = {"소재지", "지목", "면적(㎡)", "건물점유 여부"};
 			sheet1.mergeCells(land,0, land+land_col.length+(land_col_de.length*5)-1,0);
 			sheet1.addCell( new Label(land,0, "토지주요현황", h_format) );
 			for( int i=0; i<land_col.length; i++ ) {
 				sheet1.mergeCells(land+i,1, land+i,2);
 				sheet1.addCell( new Label(land+i,1, land_col[i], h_format) );
 			}
 			land = land + land_col.length;
 			for( int j=0; j<5; j++ ) {
 				sheet1.mergeCells(land,1, land+land_col_de.length-1,1);
 				sheet1.addCell( new Label(land,1, "일단의 토지 현황 "+(j+1), h_format) );
	 			for( int i=0; i<land_col_de.length; i++ ) {	 				
	 				sheet1.addCell( new Label(land+i,2, land_col_de[i], h_format) );
	 			}
	 			land = land+land_col_de.length;
 			} 			
 			
 			int loan = land;
 			String[] loan_col = {"대부(사용)자", "연락처", "대부(사용)면적(㎡)", "대부(사용)면적(%)", "대부(사용)기간", "대부(사용)료(원)", "실 대부(사용)면적(㎡)", "실 대부(사용)면적(%)", 
 					"이용현황", "매수의사", "매수의사(기타)", "특이사항"};
 			sheet1.mergeCells(loan,0, loan+(loan_col.length*5)-1,0);
 			sheet1.addCell( new Label(loan,0, "대부(사용허가)현황", h_format) );
 			for( int j=0; j<5; j++ ) {
 				sheet1.mergeCells(loan,1, loan+loan_col.length-1,1);
 				sheet1.addCell( new Label(loan,1, "대부(사용허가)현황 - "+(j+1)+"번", h_format) );
	 			for( int i=0; i<loan_col.length; i++ ) {
	 				sheet1.addCell( new Label(loan+i,2, loan_col[i], h_format) );
	 			}
	 			loan = loan+loan_col.length;
 			}
 			
 			int occp = loan;
 			String[] occp_col = {"점유자", "연락처", "점유면적(㎡)", "점유면적(%)", "이용현황", "매수의사", "매수의사(기타)", "점유시작일", "대부의사", "대부의사(기타)", 
 					"변상금 납부내역", "특이사항"};
 			sheet1.mergeCells(occp,0, occp+(occp_col.length*5)-1,0);
 			sheet1.addCell( new Label(occp,0, "무단점유(사용)현황", h_format) );
 			for( int j=0; j<5; j++ ) {
 				sheet1.mergeCells(occp,1, occp+occp_col.length-1,1);
 				sheet1.addCell( new Label(occp,1, "무단점유(사용)현황 - "+(j+1)+"번", h_format) );
	 			for( int i=0; i<occp_col.length; i++ ) {
	 				sheet1.addCell( new Label(occp+i,2, occp_col[i], h_format) );
	 			}
	 			occp = occp+occp_col.length;
 			}
 			
 			int own = occp;
 			String[] own_col = {"소유자명", "등기유무", "건축연도", "바닥면적(㎡)", "연면적(㎡)", "규모(지상)", "규모(지하)", "공부상 용도", "지붕형태", "건물구조", "실제사용용도", 
 					"재해위험도"};
 			sheet1.mergeCells(own,0, own+(own_col.length*5)-1,0);
 			sheet1.addCell( new Label(own,0, "건축물 등 현황", h_format) );
 			for( int j=0; j<5; j++ ) {
 				sheet1.mergeCells(own,1, own+own_col.length-1,1);
 				sheet1.addCell( new Label(own,1, "건축물 등 현황 - "+(j+1)+"번", h_format) );
	 			for( int i=0; i<own_col.length; i++ ) {
	 				sheet1.addCell( new Label(own+i,2, own_col[i], h_format) );
	 			}
	 			own = own+own_col.length;
 			}
 			
 			sheet1.mergeCells(own,1, own,2);
			sheet1.addCell( new Label(own,1, "장래활용방안", h_format) );
			sheet1.mergeCells(own+1,1, own+1,2);
			sheet1.addCell( new Label(own+1,1, "장래활용방안(비고)", h_format) );
 			
 			// 셀너비 지정
 			sheet1.setColumnView( 0, 8 );
 			sheet1.setColumnView( 1, 15 );
 			sheet1.setColumnView( 2, 15 );
 			sheet1.setColumnView( 3, 15 );
 			sheet1.setColumnView( 4, 30 );
 			sheet1.setColumnView( 5, 15 );
 			sheet1.setColumnView( 6, 15 );
 			sheet1.setColumnView( 7, 15 );
 			sheet1.setColumnView( 8, 10 );
 			sheet1.setColumnView( 9, 10 );
 			for( int i=10; i<own; i++ ) {
 				sheet1.setColumnView( i, 15 );
 			}
 			sheet1.setColumnView( own, 18 );
 			sheet1.setColumnView( own+1, 30 );
 			/* (+) n번째 작게 */
 			for( int i=36; i<52; i++ ) { sheet1.setColumnView( i, 5 ); }
 			for( int i=64; i<112; i++ ) { sheet1.setColumnView( i, 5 ); }
 			for( int i=124; i<172; i++ ) { sheet1.setColumnView( i, 5 ); }
 			for( int i=184; i<232; i++ ) { sheet1.setColumnView( i, 5 ); }
 			
 			// 내용 정의
 			for( int i=0; i<dataList.size(); i++ ) {
 				HashMap result = ( HashMap )dataList.get(i);
 								
 				String[] rowss = {"no", "lclas", "mlsfc", "sclas", 
 						"gid", "pnu", "ctp", "sig", "emd", "li", "mt", "bon", "bu", "prprty_mg", "jimok", "qota", "acqs", "n_jimok", "acqdt", "use", "area", "jiga", "ic_per", "ic_area", "prsmppc", "ic_prsmppc", "prpos", "lmtt", "ubplfc", 
 						"frm", "gfe", "ro_side", 
 						"sig_1", "jimok_1", "area_1", "buld_yn_1",
 						"sig_2", "jimok_2", "area_2", "buld_yn_2", 
 						"sig_3", "jimok_3", "area_3", "buld_yn_3", 
 						"sig_4", "jimok_4", "area_4", "buld_yn_4", 
 						"sig_5", "jimok_5", "area_5", "buld_yn_5", 
 						"loan_nm", "loan_cttpc", "loan_area", "loan_a_r", "loan_pd", "loanmn", "loan_totar", "loan_t_r", "loan_use", "loan_pr", "loan_pr_t", "loan_etc",
 						"loan_nm_1", "loan_cttpc_1", "loan_area_1", "loan_a_r_1", "loan_pd_1", "loanmn_1", "loan_totar_1", "loan_t_r_1", "loan_use_1", "loan_pr_1", "loan_pr_t_1", "loan_etc_1",
 						"loan_nm_2", "loan_cttpc_2", "loan_area_2", "loan_a_r_2", "loan_pd_2", "loanmn_2", "loan_totar_2", "loan_t_r_2", "loan_use_2", "loan_pr_2", "loan_pr_t_2", "loan_etc_2",
 						"loan_nm_3", "loan_cttpc_3", "loan_area_3", "loan_a_r_3", "loan_pd_3", "loanmn_3", "loan_totar_3", "loan_t_r_3", "loan_use_3", "loan_pr_3", "loan_pr_t_3", "loan_etc_3",
 						"loan_nm_4", "loan_cttpc_4", "loan_area_4", "loan_a_r_4", "loan_pd_4", "loanmn_4", "loan_totar_4", "loan_t_r_4", "loan_use_4", "loan_pr_4", "loan_pr_t_4", "loan_etc_4",
 						"occp_nm", "occp_cttpc", "occp_area", "occp_a_r", "occp_use", "occp_pr", "occp_pr_t", "occp_pd", "occp_lo", "occp_lo_t", "occp_cmp", "occp_etc",
 						"occp_nm_1", "occp_cttpc_1", "occp_area_1", "occp_a_r_1", "occp_use_1", "occp_pr_1", "occp_pr_t_1", "occp_pd_1", "occp_lo_1", "occp_lo_t_1", "occp_cmp_1", "occp_etc_1",
 						"occp_nm_2", "occp_cttpc_2", "occp_area_2", "occp_a_r_2", "occp_use_2", "occp_pr_2", "occp_pr_t_2", "occp_pd_2", "occp_lo_2", "occp_lo_t_2", "occp_cmp_2", "occp_etc_2",
 						"occp_nm_3", "occp_cttpc_3", "occp_area_3", "occp_a_r_3", "occp_use_3", "occp_pr_3", "occp_pr_t_3", "occp_pd_3", "occp_lo_3", "occp_lo_t_3", "occp_cmp_3", "occp_etc_3",
 						"occp_nm_4", "occp_cttpc_4", "occp_area_4", "occp_a_r_4", "occp_use_4", "occp_pr_4", "occp_pr_t_4", "occp_pd_4", "occp_lo_4", "occp_lo_t_4", "occp_cmp_4", "occp_etc_4",
 						"own_nm", "own_rgist", "own_bild", "own_area", "own_totar", "own_gr", "own_ugr", "own_use", "own_rf", "own_str", "own_t_use", "own_dsstr",
 						"own_nm_1", "own_rgist_1", "own_bild_1", "own_area_1", "own_totar_1", "own_gr_1", "own_ugr_1", "own_use_1", "own_rf_1", "own_str_1", "own_t_use_1", "own_dsstr_1",
 						"own_nm_2", "own_rgist_2", "own_bild_2", "own_area_2", "own_totar_2", "own_gr_2", "own_ugr_2", "own_use_2", "own_rf_2", "own_str_2", "own_t_use_2", "own_dsstr_2",
 						"own_nm_3", "own_rgist_3", "own_bild_3", "own_area_3", "own_totar_3", "own_gr_3", "own_ugr_3", "own_use_3", "own_rf_3", "own_str_3", "own_t_use_3", "own_dsstr_3",
 						"own_nm_4", "own_rgist_4", "own_bild_4", "own_area_4", "own_totar_4", "own_gr_4", "own_ugr_4", "own_use_4", "own_rf_4", "own_str_4", "own_t_use_4", "own_dsstr_4",
 						"futu", "futu_con"};
 				
 				for( int r=0; r<rowss.length; r++ ){
 					String colnm = rowss[r];
 					if(result.get(colnm) != null){
 						if(colnm.equals("gid")){
 							String addr = result.get("ctp")+" "+result.get("sig")+" "+result.get("emd");
 							if(result.get("li") != null){ addr = addr + " " + result.get("li"); }
 							if( result.get("bu") != null){ addr = addr + " " + result.get("bon")+"-"+result.get("bu"); }
 	 						else{ addr = addr + " " + result.get("bon"); }
 							sheet1.addCell( new Label(r, 3+i, addr, c_format) );
 	 					}else if(colnm.equals("sig_1")){
 	 						String addr = result.get("ctp_1")+" "+result.get("sig_1")+" "+result.get("emd_1");
 							if(result.get("li_1") != null){ addr = addr + " " + result.get("li_1"); }
 							if( result.get("bu_1") != null){ addr = addr + " " + result.get("bon_1")+"-"+result.get("bu_1"); }
 	 						else{ addr = addr + " " + result.get("bon_1"); }
 							sheet1.addCell( new Label(r, 3+i, addr, c_format) );
 	 					}else if(colnm.equals("sig_2")){
 	 						String addr = result.get("ctp_2")+" "+result.get("sig_2")+" "+result.get("emd_2");
 							if(result.get("li_2") != null){ addr = addr + " " + result.get("li_2"); }
 							if( result.get("bu_2") != null){ addr = addr + " " + result.get("bon_2")+"-"+result.get("bu_2"); }
 	 						else{ addr = addr + " " + result.get("bon_2"); }
 							sheet1.addCell( new Label(r, 3+i, addr, c_format) );
 	 					}else if(colnm.equals("addr_3")){
 	 						String addr = result.get("ctp_3")+" "+result.get("sig_3")+" "+result.get("emd_3");
 							if(result.get("li_3") != null){ addr = addr + " " + result.get("li_3"); }
 							if( result.get("bu_3") != null){ addr = addr + " " + result.get("bon_3")+"-"+result.get("bu_3"); }
 	 						else{ addr = addr + " " + result.get("bon_3"); }
 							sheet1.addCell( new Label(r, 3+i, addr, c_format) );
 	 					}else if(colnm.equals("addr_4")){
 	 						String addr = result.get("ctp_4")+" "+result.get("sig_4")+" "+result.get("emd_4");
 							if(result.get("li_4") != null){ addr = addr + " " + result.get("li_4"); }
 							if( result.get("bu_4") != null){ addr = addr + " " + result.get("bon_4")+"-"+result.get("bu_4"); }
 	 						else{ addr = addr + " " + result.get("bon_4"); }
 							sheet1.addCell( new Label(r, 3+i, addr, c_format) );
 	 					}else if(colnm.equals("addr_5")){
 	 						String addr = result.get("ctp_5")+" "+result.get("sig_5")+" "+result.get("emd_5");
 							if(result.get("li_5") != null){ addr = addr + " " + result.get("li_5"); }
 							if( result.get("bu_5") != null){ addr = addr + " " + result.get("bon_5")+"-"+result.get("bu_5"); }
 	 						else{ addr = addr + " " + result.get("bon_5"); }
 							sheet1.addCell( new Label(r, 3+i, addr, c_format) );
 	 					}else if(colnm.equals("ro_side")){
 	 						String ro_side = ""+result.get("ro_side");
 	 						if( !ro_side.endsWith("00") ){
 	 							ro_side = ro_side.replace("01", "대로(25m이상)");
 	 							ro_side = ro_side.replace("02", "중로(12~25m미만)");
 	 							ro_side = ro_side.replace("03", "소로(8~12m미만)");
 	 							ro_side = ro_side.replace("04", "세로(8m미만)");
 	 							ro_side = ro_side.replace("05", "맹지"); 						
	 	 						sheet1.addCell( new Label(r, 3+i, ro_side, c_format) );
 	 						}
 	 					}else if(colnm.equals("futu")){
 	 						String futu = ""+result.get("futu");
 	 						if( !futu.endsWith("00")){
 	 							futu = futu.replace("01", "매각");
 	 							futu = futu.replace("02", "보존");
 	 							futu = futu.replace("03", "개발");
 	 							futu = futu.replace("04", "용도폐지");
 	 							futu = futu.replace("05", "용도변경");
 	 							sheet1.addCell( new Label(r, 3+i, futu, c_format) );
 	 						}
 	 					}else{
 	 						sheet1.addCell( new Label(r, 3+i, ""+result.get(colnm), c_format) );
 	 					}
 					}
 				}
 				
 				
 			}
 			
 			workbook.write();
 			workbook.close();
 			
			FileUtil futil = new FileUtil();
 			futil.downFile3(response, fullPathName, fileName);	
 			boolean r = file.delete();
 			System.out.println("::::::::::: r :::::: " +  r);		
 		}
     }
    
   // 이은수 추가 2017-08-24
   // 워드 다운로드 
     @RequestMapping(value="/factual_Word_Download.do")
     public void factual_Word_Download(HttpServletRequest request,HttpServletResponse response, @ModelAttribute("factualVO") FactualVO factualVO) throws Exception
     {
    	request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        	
        List view01    = factualService.factualSearchList_doc(factualVO);
        HashMap result = ( HashMap )view01.get(0);
    	factualVO.setRow_gid(result.get("gid")+"");
    	factualVO.setGid(null);
    	List data_list = factualService.factualdata(factualVO);
    	
    	
        if( view01 != null ) {
        	
        	SimpleDateFormat formatter = new SimpleDateFormat ( "yyyyMMddHHmmss", Locale.KOREA );
			Date currentTime = new Date();
			String dTime = formatter.format ( currentTime );
			
	   		ObjectFactory foo = Context.getWmlObjectFactory();
	   		HashMap<String, String> mappings = null;
	   		
	   		String inputfilepath = Globals.DOC_FILE_PATH + Globals.CONTEXT_MARK + "test.docx";	//버에 템플릿 파일경로 입력
	   		boolean save = true;
	   		String fileName = dTime+"_"+"out.docx";
	  		String outputfilepath = Globals.FILE_STORE_PATH + "\\" + fileName;	//서버에 생성할 파일경로 입력
	   		
			File pFile = new File(inputfilepath);
			WordprocessingMLPackage wordMLPackage = WordprocessingMLPackage.load(pFile);
			MainDocumentPart documentPart = wordMLPackage.getMainDocumentPart();
			
			VariablePrepare.prepare(wordMLPackage);
			
			// 템플릿에 입력되어 있는 KEY와 실제값을 매핑
			// ${KEY}
			//템플릿에 입력할 실제 데이터 조회하여 mappings에 VALUE 입력
			mappings = getMappings();
			
			
			mappings.put("a_sub", ""); 
			String lclas = result.get("lclas")+"";
			if( lclas.equals("01") ) mappings.put("a1_1", "■");
			else if( lclas.equals("02") ) mappings.put("a1_2", "■"); 
			
			String mlsfc = result.get("mlsfc")+"";
			if( mlsfc.equals("01") ) mappings.put("a2_1", "■");
			else if( mlsfc.equals("02") ) mappings.put("a2_2", "■");
			else if( mlsfc.equals("03") ) mappings.put("a2_3", "■");
			
			String sclas = result.get("sclas")+"";
			if( sclas.equals("01") ) mappings.put("a3_1", "■");
			else if( sclas.equals("02") ) mappings.put("a4_1", "■");
			else if( sclas.equals("03") ) mappings.put("a4_2", "■");
			else if( sclas.equals("04") ) mappings.put("a5_1", "■");
			else if( sclas.equals("05") ) mappings.put("a5_2", "■");

			String addr = result.get("ctp")+" "+result.get("sig")+" "+result.get("emd");
			if(result.get("li") != null){ addr = addr + " " + result.get("li"); }
			if( result.get("bu") != null){ addr = addr + " " + result.get("bon")+"-"+result.get("bu"); }
			else{ addr = addr + " " + result.get("bon"); }
			addr = addr + " (" + result.get("mt") + ")";	
			mappings.put("b_sub", "");
			mappings.put("b1", addr);
			if(result.get("prprty_mg") != null) mappings.put("b2", result.get("prprty_mg")+""); 
			if(result.get("jimok") != null) mappings.put("b3", result.get("jimok")+"");
			if(result.get("qota") != null) mappings.put("b4", result.get("qota")+"");
			if(result.get("acqs") != null) mappings.put("b5", result.get("acqs")+"");
			if(result.get("n_jimok") != null) mappings.put("b6", result.get("n_jimok")+"");
			if(result.get("acqdt") != null) mappings.put("b7", result.get("acqdt")+"");
			if(result.get("use") != null) mappings.put("b_usestate", result.get("use")+"");
			if(result.get("ic_area") != null) mappings.put("ic_area", result.get("ic_area")+"");
			if(result.get("area") != null) mappings.put("b_area", result.get("area")+"");
			if(result.get("jiga") != null) mappings.put("b8", result.get("jiga")+"");
			if(result.get("prsmppc") != null) mappings.put("b9", result.get("prsmppc")+"");
			if(result.get("prpos") != null) mappings.put("b10", result.get("prpos")+"");
			if(result.get("lmtt") != null) mappings.put("b11", result.get("lmtt")+"");
			if(result.get("ubplfc") != null) mappings.put("b12", result.get("ubplfc")+"");
			
			mappings.put("c_sub", "");
			String c1 = result.get("frm")+"";
			if( c1.equals("01") )      mappings.put("c1_1", "■");
			else if( c1.equals("02") ) mappings.put("c1_2", "■");
			else if( c1.equals("03") ) mappings.put("c1_3", "■");
			else if( c1.equals("04") ) mappings.put("c2_1", "■");
			else if( c1.equals("05") ) mappings.put("c2_2", "■");
			else if( c1.equals("06") ) mappings.put("c2_3", "■");
			else if( c1.equals("07") ) mappings.put("c3_1", "■");
			else if( c1.equals("08") ) mappings.put("c3_2", "■");
			else if( c1.equals("09") ) mappings.put("c3_3", "■");
			
			String c2 = result.get("gfe")+"";
			if( c2.equals("01") )      mappings.put("c4_1", "■");
			else if( c2.equals("02") ) mappings.put("c4_2", "■");
			else if( c2.equals("03") ) mappings.put("c4_3", "■");
			else if( c2.equals("04") ) mappings.put("c4_4", "■");
			else if( c2.equals("05") ) mappings.put("c5_1", "■");
			
			String c6 = result.get("ro_side")+"";
			if( c6.contains("01") )      mappings.put("c6_1", "■");
			if( c6.contains("02") ) mappings.put("c6_2", "■");
			if( c6.contains("03") ) mappings.put("c6_3", "■");
			if( c6.contains("04") ) mappings.put("c6_4", "■");
			if( c6.contains("05") ) mappings.put("c6_5", "■");
			
			if(result.get("sig_1") != null){
				String addr_1 = result.get("ctp_1")+" "+result.get("sig_1")+" "+result.get("emd_1");
				if(result.get("li_1") != null){ addr_1 = addr_1 + " " + result.get("li_1"); }
				if( result.get("bu_1") != null){ addr_1 = addr_1 + " " + result.get("bon_1")+"-"+result.get("bu_1"); }
				else{ addr_1 = addr_1 + " " + result.get("bon_1"); }
				addr_1 = addr_1 + " (" + result.get("mt_1") + ")";
				mappings.put("c7_juso", addr_1);
				if(result.get("jimok_1") != null) mappings.put("c7_jimok", result.get("jimok_1")+"");
				if(result.get("area_1") != null) mappings.put("c7_area", result.get("area_1")+"");
				String c7 = result.get("buld_yn_1")+"";
				if( c7.equals("01") )      mappings.put("c7_1", "■");
				else if( c7.equals("02") ) mappings.put("c7_2", "■");
			}
			if(result.get("sig_2") != null){
				String addr_2 = result.get("ctp_2")+" "+result.get("sig_2")+" "+result.get("emd_2");
				if(result.get("li_2") != null){ addr_2 = addr_2 + " " + result.get("li_2"); }
				if( result.get("bu_2") != null){ addr_2 = addr_2 + " " + result.get("bon_2")+"-"+result.get("bu_2"); }
				else{ addr_2 = addr_2 + " " + result.get("bon_2"); }
				addr_2 = addr_2 + " (" + result.get("mt_2") + ")";
				mappings.put("c8_juso", addr_2);
				if(result.get("jimok_2") != null) mappings.put("c8_jimok", result.get("jimok_2")+"");
				if(result.get("area_2") != null) mappings.put("c8_area", result.get("area_2")+"");			
				String c8 = result.get("buld_yn_2")+"";
				if( c8.equals("01") )      mappings.put("c8_1", "■");
				else if( c8.equals("02") ) mappings.put("c8_2", "■");
			}
			
			String loan_nm = result.get("loan_nm")+"";
			if( loan_nm.equals(null) )     mappings.put("d_sub", ": 해당없음");
			else mappings.put("d_sub", "");
			mappings.put("d_name", loan_nm);
			if(result.get("loan_cttpc") != null) mappings.put("d_tel", result.get("loan_cttpc")+"");
			if(result.get("loan_area") != null) mappings.put("d1_1", result.get("loan_area")+"");
			if(result.get("loan_a_r") != null) mappings.put("d1_2", result.get("loan_a_r")+"");
			if(result.get("loan_pd") != null) mappings.put("d_date", result.get("loan_pd")+"");
			if(result.get("loanmn") != null) mappings.put("d_money", result.get("loanmn")+"");
			if(result.get("loan_totar") != null) mappings.put("d2_1", result.get("loan_totar")+"");
			if(result.get("loan_t_r") != null) mappings.put("d2_2", result.get("loan_t_r")+"");
			if(result.get("loan_use") != null) mappings.put("d_usestate", result.get("loan_use")+"");
			String d3_1 = result.get("loan_pr")+"";
			if( d3_1.equals("01") )      mappings.put("d3_1", "■");
			else if( d3_1.equals("02") ) mappings.put("d3_2", "■");
			if(result.get("loan_pr_t") != null) mappings.put("d3_3", result.get("loan_pr_t")+"");
			if(result.get("loan_etc") != null) mappings.put("d_etc", result.get("loan_etc")+"");
			
			String occp_nm = result.get("occp_nm")+"";
			if( occp_nm.equals(null) )     mappings.put("e_sub", ": 해당없음");
			else mappings.put("e_sub", "");
			mappings.put("e_name", occp_nm);
			if(result.get("occp_cttpc") != null) mappings.put("e_tel", result.get("occp_cttpc")+"");
			if(result.get("occp_area") != null) mappings.put("e1_1", result.get("occp_area")+"");
			if(result.get("occp_a_r") != null) mappings.put("e1_2", result.get("occp_a_r")+"");
			if(result.get("occp_use") != null) mappings.put("e_usestate", result.get("occp_use")+"");
			String occp_pr = result.get("occp_pr")+"";
			if( occp_pr.equals("01") )      mappings.put("e2_1", "■");
			else if( occp_pr.equals("02") ) mappings.put("e2_2", "■");
			if(result.get("occp_pr_t") != null) mappings.put("e2_3", result.get("occp_pr_t")+"");
			if(result.get("occp_pd") != null) mappings.put("e_date", result.get("occp_pd")+"");
			String occp_lo = result.get("occp_lo")+"";
			if( occp_lo.equals("01") )      mappings.put("e3_1", "■");
			else if( occp_lo.equals("02") ) mappings.put("e3_2", "■");
			if(result.get("occp_lo_t") != null) mappings.put("e3_3", result.get("occp_lo_t")+"");
			if(result.get("occp_cmp") != null) mappings.put("e4", result.get("occp_cmp")+"");
			if(result.get("occp_etc") != null) mappings.put("e_etc", result.get("occp_etc")+"");
			
			String own_nm = result.get("own_nm")+"";
			if( own_nm.equals(null) )     mappings.put("f_sub", ": 해당없음");
			else mappings.put("f_sub", "");
			mappings.put("f_name", own_nm);
			String own_rgist = result.get("own_rgist")+"";
			if( own_rgist.equals("01") )      mappings.put("f1_1", "■");
			else if( own_rgist.equals("02") ) mappings.put("f1_2", "■");
			if(result.get("own_bild") != null) mappings.put("f_year", result.get("own_bild")+"");
			if(result.get("own_area") != null) mappings.put("f_barea", result.get("own_area")+"");
			if(result.get("own_totar") != null) mappings.put("f_area", result.get("own_totar")+"");
			if(result.get("own_gr") != null) mappings.put("f2_1", result.get("own_gr")+"");
			if(result.get("own_ugr") != null) mappings.put("f2_2", result.get("own_ugr")+"");
			if(result.get("own_use") != null) mappings.put("f3", result.get("own_use")+"");
			if(result.get("own_rf") != null) mappings.put("f4", result.get("own_rf")+"");
			if(result.get("own_str") != null) mappings.put("f5", result.get("own_str")+"");
			if(result.get("own_t_use") != null) mappings.put("f6", result.get("own_t_use")+"");
			String own_dsstr = result.get("own_dsstr")+"";
			if( own_dsstr.contains("01") )      mappings.put("f7_1", "■");
			else if( own_dsstr.contains("02") ) mappings.put("f7_2", "■");
			else if( own_dsstr.contains("03") ) mappings.put("f7_3", "■");
			
			String futu = result.get("futu")+"";
			if( futu.equals(null) )     mappings.put("g_sub", ": 해당없음");
			else mappings.put("g_sub", "");
			if( futu.contains("01") )      mappings.put("g1_1", "■");
			else if( futu.contains("02") ) mappings.put("g1_2", "■");
			else if( futu.contains("03") ) mappings.put("g1_3", "■");
			else if( futu.contains("04") ) mappings.put("g1_4", "■");
			else if( futu.contains("05") ) mappings.put("g1_5", "■");
			if(result.get("futu_con") != null) mappings.put("g_detail", result.get("futu_con")+"");
			
			
			long start = System.currentTimeMillis();
			
			// 이미지 넣기 - mappings 내용보다 먼저 입력되어야함
			// 해당하는 KEY 위치에 이미지 넣기
			//실제 이미지 경로 입력하기
			String image_01 = null;
		   String image_02 = null;
		   String image_03 = null;
		   String image_04 = null;
			for(int d=0; d<data_list.size(); d++){
				HashMap result_data = ( HashMap )data_list.get(d);
				if(d == 0){ image_01 = result_data.get("files_path") + Globals.CONTEXT_MARK + result_data.get("files_sav_name"); }
				else if(d == 1){ image_02 = result_data.get("files_path") + Globals.CONTEXT_MARK + result_data.get("files_sav_name"); }
				else if(d == 2){ image_03 = result_data.get("files_path") + Globals.CONTEXT_MARK + result_data.get("files_sav_name"); }
				else if(d == 3){ image_04 =result_data.get("files_path") + Globals.CONTEXT_MARK + result_data.get("files_sav_name"); }
				
			}
			
		   
		   insertImage(wordMLPackage, documentPart, "img1", image_01); 
		   insertImage(wordMLPackage, documentPart, "img2", image_02);
			
			// 매핑 내용 입력하기
			documentPart.variableReplace(mappings); 
			// documentPart.addParagraphOfText("성공적인 테스트3");
			
			long end = System.currentTimeMillis();
			long total = end - start;
			System.out.println("Time: " + total);
			
			// Save it
			if (save) {
			    SaveToZipFile saver = new SaveToZipFile(wordMLPackage);
			    saver.save(outputfilepath);
			} else {
			    System.out.println(XmlUtils.marshaltoString(documentPart.getJaxbElement(), true,
			            true));
			}
			
			FileUtil futil = new FileUtil();
			futil.downFile3(response, outputfilepath, fileName);	
//			boolean r = futil.delete();
        }
     }
     
     public HashMap<String, String> getMappings(){
    	 HashMap<String, String> mappings = new HashMap<String, String>(); // 초기화
	        
	        mappings.put("a_sub", ""); 
	        mappings.put("a1_1", "□");
	        mappings.put("a1_2", "□");
	        mappings.put("a2_1", "□");
	        mappings.put("a2_2", "□");
	        mappings.put("a2_3", "□");
	        mappings.put("a3_1", "□");
	        mappings.put("a4_1", "□");
	        mappings.put("a4_2", "□");
	        mappings.put("a5_1", "□");
	        mappings.put("a5_2", "□");

	        mappings.put("b_sub", "");
	        mappings.put("b1", "");
	        mappings.put("b2", "");
	        mappings.put("b3", "");
	        mappings.put("b4", "");
	        mappings.put("b5", "");
	        mappings.put("b6", "");
	        mappings.put("b7", "");
	        mappings.put("b_usestate", "");
	        mappings.put("ic_area", "");
	        mappings.put("b_area", "");
	        mappings.put("b8", "");
	        mappings.put("b9", "");
	        mappings.put("b10", "");
	        mappings.put("b11", "");
	        mappings.put("b12", "");
	        
	        mappings.put("c_sub", "");
	        mappings.put("c1_1", "□");
	        mappings.put("c1_2", "□");
	        mappings.put("c1_3", "□");
	        mappings.put("c2_1", "□");
	        mappings.put("c2_2", "□");
	        mappings.put("c2_3", "□");
	        mappings.put("c3_1", "□");
	        mappings.put("c3_2", "□");
	        mappings.put("c3_3", "□");
	        mappings.put("c4_1", "□");
	        mappings.put("c4_2", "□");
	        mappings.put("c4_3", "□");
	        mappings.put("c4_4", "□");
	        mappings.put("c5_1", "□");
	        mappings.put("c6_1", "□");
	        mappings.put("c6_2", "□");
	        mappings.put("c6_3", "□");
	        mappings.put("c6_4", "□");
	        mappings.put("c6_5", "□");
	        mappings.put("c7_juso", "");
	        mappings.put("c7_jimok", "");
	        mappings.put("c7_area", "");
	        mappings.put("c7_1", "□");
	        mappings.put("c7_2", "□");
	        mappings.put("c8_juso", "-");
	        mappings.put("c8_jimok", "");
	        mappings.put("c8_area", "");
	        mappings.put("c8_1", "□");
	        mappings.put("c8_2", "□");
	        
	        mappings.put("d_sub", "");
	        mappings.put("d_name", "");
	        mappings.put("d_tel", "");
	        mappings.put("d1_1", "");
	        mappings.put("d1_2", "   ");
	        mappings.put("d_date", "");
	        mappings.put("d_money", "");
	        mappings.put("d2_1", "");
	        mappings.put("d2_2", "   ");
	        mappings.put("d_usestate", "");
	        mappings.put("d3_1", "□");
	        mappings.put("d3_2", "□");
	        mappings.put("d3_3", "        ");
	        mappings.put("d_etc", "");
	        
	        mappings.put("e_sub", "");
	        mappings.put("e_name", "");
	        mappings.put("e_tel", "");
	        mappings.put("e1_1", "");
	        mappings.put("e1_2", "   ");
	        mappings.put("e_usestate", "");
	        mappings.put("e2_1", "□");
	        mappings.put("e2_2", "□");
	        mappings.put("e2_3", "        ");
	        mappings.put("e_date", "");
	        mappings.put("e3_1", "□");
	        mappings.put("e3_2", "□");
	        mappings.put("e3_3", "        ");
	        mappings.put("e4", "");
	        mappings.put("e_etc", "");
	        
	        mappings.put("f_sub", "");
	        mappings.put("f_name", "");
	        mappings.put("f1_1", "□");
	        mappings.put("f1_2", "□");
	        mappings.put("f_year", "");
	        mappings.put("f_barea", "");
	        mappings.put("f_area", "");
	        mappings.put("f2_1", " ");
	        mappings.put("f2_2", " ");
	        mappings.put("f3", "");
	        mappings.put("f4", "");
	        mappings.put("f5", "");
	        mappings.put("f6", "");
	        mappings.put("f7_1", "□");
	        mappings.put("f7_2", "□");
	        mappings.put("f7_3", "□");
	        
	        mappings.put("g_sub", "");
	        mappings.put("g1_1", "□");
	        mappings.put("g1_2", "□");
	        mappings.put("g1_3", "□");
	        mappings.put("g1_4", "□");
	        mappings.put("g1_5", "□");
	        mappings.put("g_detail", "");
	        
	        mappings.put("img1", "");
	        mappings.put("img2", "");
	        mappings.put("img3", "");
	        mappings.put("img4", "");
	        
	        return mappings;
     }
     
     public void insertImage(WordprocessingMLPackage wordMLPackage, MainDocumentPart docPart, String place, String img_path){
   		try{
   			org.docx4j.wml.ObjectFactory foo = Context.getWmlObjectFactory();
   			
   			java.io.File pFile_img1 = new java.io.File(img_path);
   	        java.io.InputStream is = new java.io.FileInputStream(pFile_img1);
   	        
   	        long length = pFile_img1.length();    
   	        // You cannot create an array using a long type.
   	        // It needs to be an int type.
   	        if (length > Integer.MAX_VALUE) {
   	        	System.out.println("File too large!!");
   	        }
   	        byte[] bytes = new byte[(int)length];
   	        int offset = 0;
   	        int numRead = 0;
   	        while (offset < bytes.length
   	               && (numRead=is.read(bytes, offset, bytes.length-offset)) >= 0) {
   	            offset += numRead;
   	        }
   	        // Ensure all the bytes have been read in
   	        if (offset < bytes.length) {
   	            System.out.println("Could not completely read file "+pFile_img1.getName());
   	        }
   	        is.close();
   	        
   	        String filenameHint = null;
   	        String altText = null;
   	        int id1 = 0;
   	        int id2 = 1;
   	        int width = 5000;
   	        boolean searched = false;

   	        // 위치찾기
   	        List elemetns = getAllElementFromObject(wordMLPackage.getMainDocumentPart(), Tbl.class);
   	        for(Object obj : elemetns){
   	        	   if(obj instanceof Tbl){
   	        	      Tbl table = (Tbl) obj;
   	        	         List rows = getAllElementFromObject(table, Tr.class);
   	        	            for(Object trObj : rows){
   	        	         Tr tr = (Tr) trObj;
   	        	         List cols = getAllElementFromObject(tr, Tc.class);
   	        	         for(Object tcObj : cols){
   	        	            Tc tc = (Tc) tcObj;
   	        	            List texts = getAllElementFromObject(tc, Text.class);
   	        	            for(Object textObj : texts){
   	        	              Text text = (Text) textObj;
   	        	                     if(text.getValue().equalsIgnoreCase("${" + place + "}")){
   	        	                        tc.getContent().clear();

   	        	        				width = tc.getTcPr().getTcW().getW().intValue(); // 셀 가로 사이즈
   	        	        				width = width - 200;
   	        	        				
   	        	        			     // Image 1: no width specified
   	        	        		        org.docx4j.wml.P p = newImage( wordMLPackage, bytes, 
   	        	        		        		filenameHint, altText, 
   	        	        		    			id1, id2, width );
   	        	        		        
   	        	        		        setHorizontalAlignment(p, JcEnumeration.CENTER);
   	        	        		        
   	        	                        tc.getContent().add(p);

   	        	                        searched = true;
   	        	                        System.out.println(place + " here");
   	        	              }
   	        	                  }
   	        	           // System.out.println("here");
   	        	         }
   	        	           }
   	        	        // System.out.println("here");
   	        	    }
   	        	}
   	        if(!searched){
   	        	System.out.println(place + " is not here");
   	        }
   	        
   		}catch(Exception ex){
   			System.out.println("insertImage Exception: "+ex.getMessage());
   		}
   	}
   	
   	private void setHorizontalAlignment(P paragraph, JcEnumeration hAlign){
   		if(hAlign != null){
   			PPr pprop = new PPr();
   			Jc align = new Jc();
   			align.setVal(hAlign);
   			pprop.setJc(align);
   	        paragraph.setPPr(pprop);
   		}
   	}
   	
   	private static List getAllElementFromObject(Object obj, Class toSearch) {
   		   List result = new ArrayList();
   		   if (obj instanceof JAXBElement) 
   		       obj = ((JAXBElement) obj).getValue();
   		      
   		   if (obj.getClass().equals(toSearch)){
   		         result.add(obj);
   		   }
   		   else if (obj instanceof ContentAccessor) {
   		         List children = ((ContentAccessor) obj).getContent();
   		         for (Object child : children) {
   		         result.addAll(getAllElementFromObject(child, toSearch));
   		         }
   		      
   		   }
   		   return result;
   		}
   	
   	/**
   	 * Create image, without specifying width
   	 */
   	public static org.docx4j.wml.P newImage( WordprocessingMLPackage wordMLPackage,
   			byte[] bytes,
   			String filenameHint, String altText, 
   			int id1, int id2) throws Exception {
   		
           BinaryPartAbstractImage imagePart = BinaryPartAbstractImage.createImagePart(wordMLPackage, bytes);
   		
           Inline inline = imagePart.createImageInline( filenameHint, altText, 
       			id1, id2, false);
           
           // Now add the inline in w:p/w:r/w:drawing
   		org.docx4j.wml.ObjectFactory factory = Context.getWmlObjectFactory();
   		org.docx4j.wml.P  p = factory.createP();
   		org.docx4j.wml.R  run = factory.createR();		
   		p.getContent().add(run);        
   		org.docx4j.wml.Drawing drawing = factory.createDrawing();		
   		run.getContent().add(drawing);		
   		drawing.getAnchorOrInline().add(inline);
   		
   		return p;
   		
   	}	
   	
   	/**
   	 * Create image, specifying width in twips
   	 */
   	public static org.docx4j.wml.P newImage( WordprocessingMLPackage wordMLPackage,
   			byte[] bytes,
   			String filenameHint, String altText, 
   			int id1, int id2, long cx) throws Exception {
   		
           BinaryPartAbstractImage imagePart = BinaryPartAbstractImage.createImagePart(wordMLPackage, bytes);
   		
           Inline inline = imagePart.createImageInline( filenameHint, altText, 
       			id1, id2, cx, false);
           
           // Now add the inline in w:p/w:r/w:drawing
   		org.docx4j.wml.ObjectFactory factory = Context.getWmlObjectFactory();
   		org.docx4j.wml.P  p = factory.createP();
   		org.docx4j.wml.R  run = factory.createR();		
   		p.getContent().add(run);        
   		org.docx4j.wml.Drawing drawing = factory.createDrawing();		
   		run.getContent().add(drawing);		
   		drawing.getAnchorOrInline().add(inline);
   		
   		return p;
   		
   	}	
    
     
}