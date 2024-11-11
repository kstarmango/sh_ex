package egovframework.zaol.common.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.zaol.common.OraclePaginationInfo;
import egovframework.zaol.common.service.ZipCodeService;
import egovframework.zaol.common.service.ZipCodeVO;

@Controller
public class ZipCodeController extends BaseController {

	@Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

	@Resource( name="zipCodeService" )
	protected ZipCodeService zipCodeService;

	@RequestMapping( "/searchZipCode.do" )
	public String searchZipCode( HttpServletRequest request, HttpServletResponse response, Model model,
			@ModelAttribute("zipCodeVO") ZipCodeVO zipCodeVO ) throws Exception {

		// 검색조건
		String name = "";
		String gubun ="";
		name = request.getParameter( "name" )==null?"":request.getParameter( "name" );
		gubun = request.getParameter( "gubun" )==null?"1":request.getParameter( "gubun" );
//		name = new String( name.getBytes("8859_1"), "UTF-8" );

		if( name != null && !name.equals( "" ) ) {

			// BoardMDefaultVO 상속받아서 작성
	    	// 페이징 갯수(기본:10)
			zipCodeVO.setPageUnit( 5 );

	    	// 한 페이지에 몇개씩 보여줄 것인지(기본:10)
			zipCodeVO.setPageSize( 5 );

	    	/** paging setting */
			zipCodeVO.setLastIndex( 5 );
	    	OraclePaginationInfo paginationInfo = new OraclePaginationInfo();
			paginationInfo.setCurrentPageNo(zipCodeVO.getPageIndex());
			paginationInfo.setRecordCountPerPage(zipCodeVO.getPageUnit());
			paginationInfo.setPageSize(zipCodeVO.getPageSize());

			zipCodeVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
			zipCodeVO.setLastIndex(paginationInfo.getLastRecordIndex());
			zipCodeVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

			List< ZipCodeVO > list = zipCodeService.selectZipCode( name );
			model.addAttribute( "list" , list );
			model.addAttribute( "name" , name );

			int totCnt = zipCodeService.selectZipCodeCnt( name );
			paginationInfo.setTotalRecordCount(totCnt);
	        model.addAttribute("paginationInfo", paginationInfo);
		}
		model.addAttribute("gubun",gubun);

		return "/cmmn/zipcodePop";

	}

	@RequestMapping( "/searchAreapop.do" )
	public String searchArea( HttpServletRequest request, HttpServletResponse response, Model model,
			@ModelAttribute("zipCodeVO") ZipCodeVO zipCodeVO ) throws Exception {

		// 검색조건
		String dong = "";
		dong = request.getParameter( "dong" )==null?"":request.getParameter( "dong" ).trim();
		List< ZipCodeVO > list = null;

		if(!dong.equals("")){
			list = zipCodeService.selectArea( dong );
		}
		model.addAttribute( "addrList" , list );
		model.addAttribute( "dong" , dong );

		return "/cmmn/dongPop";

	}
}
