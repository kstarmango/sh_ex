<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="utf-8">
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <meta name="description" content="SH서울주택도시공사 | 토지자원관리시스템">

    <link rel="shortcut icon" href="/jsp/SH/img/favicon.ico">    

    <!-- App css -->
    <link href="/jsp/SH/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/components.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/icons.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/core.css" rel="stylesheet" type="text/css" />

      
    <!-- jQuery Library -->
	<script src="/jsp/SH/js/jquery.min.js"></script>
	<script src="/jsp/SH/js/bootstrap.min.js"></script>
	
	<!-- Validate -->
<!--     <script src="/jsp/SH/js/jquery.validate.min.js"></script> -->
    
    <!-- App js -->
	<script src="/jsp/SH/js/add_manage_board.js"></script>
        
	<!-- HTML5 Shiv and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->
    
	<title>SH | 토지자원관리시스템</title>
	

	
<script type="text/javascript">

	//페이지 링크
	function fn_link_acUser(pageNo) {
		$("#pageIndex").val(pageNo);
		 $("form").attr("method", "post");
		 $("form").attr("action","board_qna_home.do");
		 $("form").submit();
	}
	
	function fnSearchList() {
		var s_serch_gb = $("select[name=s_serch_gb ]").val();
		var s_serch_nm = $("input[name=s_serch_nm ]").val();
		
		$("input[name=s_sjt]").val("");
	    $("input[name=s_ctn]").val("");
		
		if( jQuery.trim( s_serch_nm ) != "" )
	    {
			     if(s_serch_gb == "sjt"){ $("input[name=s_sjt]").val(s_serch_nm); }
	        else if(s_serch_gb == "ctn"){ $("input[name=s_ctn]").val(s_serch_nm); }
	    }
		$("#pageIndex").val("1");
	    $("form").attr("method", "post");
	    $("form").attr("action","board_qna_home.do");
	    $("form").submit();
	}
	
	
</script>	
	
</head>

<body>	
	
	<c:import url="/main_header.do"></c:import>
	
	<div id="load">
	    <img src="/jsp/SH/img/ajax-loader.gif"><p>LOADING</p>
	</div>
	
	<div class="wrapper">
	    <div class="container">
	        <!-- Page-Title -->
	        <div class="row">
	            <div class="col-sm-12">
	                <div class="page-title-box">
	                    <div class="btn-group pull-right">
	                        <ol class="breadcrumb hide-phone p-0 m-0">
	                            <li>
	                                <a href="/dashboard.do">HOME</a>
	                            </li>
	                            <li>
	                                <a href="/board_notice_home.do">게시판</a>
	                            </li>
	                            <li class="active">
	                                질의•요청
	                            </li>
	                        </ol>
	                    </div>
	                    <h4 class="page-title">질의•요청</h4>
	                </div>
	            </div>
	        </div>
	        <!-- End Page-Title -->
	
	        <div class="row">
	            <div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
	
	                    <!-- Table-Content-Wrap -->
	                    <form id="accessNoticeForm" name="accessNoticeForm" class="form-horizontal">
	                    <h5 class="header-title"><b>목록</b> <span class="small">(전체 <b class="text-orange"><c:out value="${view01Cnt.totalRecordCount}"/></b>건)</span></h5>
	                    <div class="table-wrap m-t-30">
		                        <input type="hidden" name="s_sjt"  value="<c:out value='${manageVO.s_sjt}' escapeXml='false' />" />
								<input type="hidden" name="s_ctn"  value="<c:out value='${manageVO.s_ctn}' escapeXml='false' />" />
								<input type="hidden" id="pageIndex" name="pageIndex" value="${num}">
								<input type="hidden" id="seq" name="seq" value="0">
	                        <table class="table table-custom table-cen table-num text-center table-hover" width="100%">
	                            <colgroup>
	                                <col width="8%" />
	                                <col width="auto" />
	                                <col width="12%" />
	                                <col width="12%" />
	                                <col width="12%" />
	                            </colgroup>
	                            <thead>
	                            <tr>
	                                <th>번호</th>
	                                <th>제목</th>
	                                <th>작성자</th>
	                                <th>작성일</th>
	                                <th>조회수</th>
	                            </tr>
	                            </thead>
	                            <tbody>
	                            <!--<tr>-->
	                            <!--<td colspan="5">검색결과가 없습니다.</td>-->
	                            <!--</tr>-->
	                            <!-- cjw qna리스트 추가 20180618 -->
	                            <c:choose>
										<c:when test="${!empty qnaList}">
												<c:forEach items="${qnaList}" var="result" varStatus="status">
													<c:if test="${result.re_lev eq '1'}">
														<tr>
															<td>
															 <c:out value="${view01Cnt.totalRecordCount - (result.rno-1)}" escapeXml="false" />
															</td>													
					                                        <td style="text-align:left;text-indent: 40px;">
		 			                                        <a href="javascript:detail_qna('<c:out value="${result.seq}"/>');">
					                                        <c:out value="${result.board_sjt}"/>
					                                        <c:if test="${'NEW' eq result.asnew_flg}"><span class="ico_new m-l-5"><img src="<c:url value="/jsp/SH/img/ico_new.png"/>" alt="새글아이콘" title="새글"></span></c:if>
					                                        </a>
					                                        </td>
					                                        <td><c:out value="${result.regest_id}"/></td>
					                                        <td><c:out value="${result.regest_date}"/></td>
					                                        <td><c:out value="${result.board_cnt}"/></td>
					                                    </tr>
				                                    </c:if>
				                                    
				                                    <c:if test="${result.re_lev ne '1'}">
			                                    		<tr onclick="detail_qna('<c:out value="${result.seq}"/>');">
				                                    	<td>
				                                    	<c:out value="${view01Cnt.totalRecordCount - (result.rno-1)}" escapeXml="false" />
				                                    	</td>
						                                <td class="table-title" style="text-align:left;text-indent: 0px;"><c:out value="${result.space}" escapeXml="false"/><i class="mdi mdi-subdirectory-arrow-right text-teal m-r-5">re:</i><c:out value="${result.board_sjt}"/></td>
						                                <td><c:out value="${result.regest_id}"/></td>
						                                <td><c:out value="${result.regest_date}"/></td>
						                                <td><c:out value="${result.board_cnt}"/></td>
					                                	</tr>
				                                    </c:if>
				                                    
				                                    
												</c:forEach>
										</c:when>
										<c:otherwise>
											<tr><td colspan="7" style="text-align:center">검색결과가 없습니다.</td></tr>
										</c:otherwise>
								</c:choose>	
	                            <!-- <tr onclick="detail_qna()">
	                                <td>001</td>
	                                <td class="table-title">질문글 제목입니다.</td>
	                                <td>홍길동</td>
	                                <td>2018.01.01</td>
	                                <td>001</td>
	                            </tr> -->
<!-- 	                            
	                            <tr onclick="detail_qna()">
	                                <td>-</td>
	                                <td class="table-title"><i class="mdi mdi-subdirectory-arrow-right text-teal m-r-5">re:</i>질문글 답변입니다.</td>
	                                <td>홍길동</td>
	                                <td>2018.01.01</td>
	                                <td>001</td>
	                            </tr>
 -->	                            
	<!-- 
	
	                            <tr onclick="detail_qna()">
	                                <td>001</td>
	                                <td class="table-title">질문글 제목입니다.</td>
	                                <td>홍길동</td>
	                                <td>2018.01.01</td>
	                                <td>001</td>
	                            </tr>
	                            <tr onclick="detail_qna()">
	                                <td>-</td>
	                                <td class="table-title"><i class="mdi mdi-subdirectory-arrow-right text-teal m-r-5">re:</i>질문글 답변입니다.</td>
	                                <td>홍길동</td>
	                                <td>2018.01.01</td>
	                                <td>001</td>
	                            </tr>
	                            <tr onclick="detail_qna()">
	                                <td>001</td>
	                                <td class="table-title">질문글 제목입니다.</td>
	                                <td>홍길동</td>
	                                <td>2018.01.01</td>
	                                <td>001</td>
	                            </tr>
	                            <tr onclick="detail_qna()">
	                                <td>-</td>
	                                <td class="table-title"><i class="mdi mdi-subdirectory-arrow-right text-teal m-r-5">re:</i>질문글 답변입니다.</td>
	                                <td>홍길동</td>
	                                <td>2018.01.01</td>
	                                <td>001</td>
	                            </tr>
	                            <tr onclick="detail_qna()">
	                                <td>001</td>
	                                <td class="table-title">질문글 제목입니다.</td>
	                                <td>홍길동</td>
	                                <td>2018.01.01</td>
	                                <td>001</td>
	                            </tr>
	                            <tr onclick="detail_qna()">
	                                <td>-</td>
	                                <td class="table-title"><i class="mdi mdi-subdirectory-arrow-right text-teal m-r-5">re:</i>질문글 답변입니다.</td>
	                                <td>홍길동</td>
	                                <td>2018.01.01</td>
	                                <td>001</td>
	                            </tr>
	 -->
	                            </tbody>
	                        </table>
	                    </div>
						</form>
	
	                    <div class="text-center m-b-20">
	                        <ul class="pagination">
<!-- 	                        
	                            <li class="disabled">
	                                <a href="#"><i class="fa fa-angle-left"></i></a>
	                            </li> -->
	                            
	                            <!-- cjw 페이징 추가 20180618 -->
                            	<ui:pagination paginationInfo = "${view01Cnt}" type="user" jsFunction="fn_link_acUser" />
	                            <!-- 
	                            <li class="active">
	                                <a href="#">1</a>
	                            </li>
	                            <li>
	                                <a href="#">2</a>
	                            </li>
	                            <li>
	                                <a href="#">3</a>
	                            </li>
	                            <li>
	                                <a href="#">4</a>
	                            </li>
	                            <li>
	                                <a href="#">5</a>
	                            </li>
	                            <li>
	                                <a href="#"><i class="fa fa-angle-right"></i></a>
	                            </li>
	                             -->
	                        </ul>
	                    </div>
	
	                    <div class="row m-b-40">
	                        <div class="col-sm-6 col-sm-offset-3">
	                            <div class="col-xs-3">
	                                <select class="form-control input-sm" name="s_serch_gb" title ="검색항목">
	                                    <option value="sjt">제목</option>
	                                    <option value="ctn">내용</option>
	                                </select>
	                            </div>
	                            <div class="col-xs-9">
	                                <div class="input-group">
	                                    <input type="search" class="form-control input-sm" name="s_serch_nm"  onkeypress="if(event.keyCode==13){fnSearchList(); return false;}" placeholder="검색어를 입력하세요" /> 
	                                    <span class="input-group-btn"><button class="btn btn-teal btn-sm searchBtn" onclick="fnSearchList();"><i class="fa fa-search"></i></button></span>
	                                </div>
	                            </div>
	                            <label for="searchKeyword" class="sr-only">검색어</label>
	                        </div>
	                    </div>
						
	                    <!-- Button-Group -->
	                    <div class="modal-footer">
	                        <!--<button type="button" class="btn btn-danger btn-md" id="fc-del-btn" data-toggle="modal" data-target="#alert-delete-detail">-->
	                        <!--<span><i class="fa fa-times-circle m-r-5"></i>취소</span>-->
	                        <!--</button>-->
	                        <button type="button" class="btn btn-custom btn-md" onclick="register_qna()">
	                            <span><i class="fa fa-pencil m-r-5"></i>글쓰기</span>
	                        </button>
	                    </div>
	                    <!--// End Button-Group -->
	                    
	                </div>
	            </div>
	        </div>
	
	    </div>
	</div>
	
	<c:import url="/main_footer.do"></c:import>	
		
	<script src="/jsp/SH/js/jquery.app.js"></script>
	
<script type="text/javascript">

</script>


</body>

</html>