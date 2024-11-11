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
	<script src="/jsp/SH/js/moment-with-locales.min.js"></script>
    <script src="/jsp/SH/js/bootstrap-datetimepicker.min.js"></script>
	
	<!-- Validate -->
<!--     <script src="/jsp/SH/js/jquery.validate.min.js"></script> -->
    
    <!-- App js -->
	<script src="/jsp/SH/js/add_manage_user.js"></script>
        
	<!-- HTML5 Shiv and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->
    
	<title>SH | 토지자원관리시스템</title>
	
	<script type="text/javascript">


$(document).ready(function(){
	$("select[name=s_serch_gb]").val("<c:out value='${manageVO.s_serch_gb}'/>");
	$("input[ name=s_serch_nm]").val("<c:out value='${manageVO.s_serch_nm}'/>");
	$("input[name=startDate]").val("<c:out value='${manageVO.startDate}'/>");
	
	$('.date').datetimepicker({
		locale: 'ko',
		format: 'YYYY-MM-DD',
	    icons: {
	        previous: "fa fa-chevron-left",
	        next: "fa fa-chevron-right",
	        time: "fa fa-clock-o",
	        date: "fa fa-calendar",
	        up: "fa fa-arrow-up",
	        down: "fa fa-arrow-down"
	    }
	});

	$('.searchBtn').click(function(){
		fnSearchList();
	});
	
	$('.resetBtn').click(function(){
		$("select[name=s_serch_gb]").val("");
		$("input[ name=s_serch_nm]").val("");
		$("input[name=startDate]").val("");
	});
});

//페이지 링크
function fn_link_acUser(pageNo) {
	$("#pageIndex").val(pageNo);
	 $("form").attr("method", "post");
	 $("form").attr("action","manage_user_list.do");
	 $("form").submit();
}

function fnSearchList() {
	var s_serch_gb = $("select[name=s_serch_gb ]").val();
	var s_serch_nm = $("input[name=s_serch_nm ]").val();
	
	$("input[name=s_sjt]").val("");
    $("input[name=s_ctn]").val("");
    $("input[name=s_all]").val("");
	
	if( jQuery.trim( s_serch_nm ) != "" )
    {
		     if(s_serch_gb == "sjt"){ $("input[name=s_sjt]").val(s_serch_nm); }
        else if(s_serch_gb == "ctn"){ $("input[name=s_ctn]").val(s_serch_nm); }
        else if(s_serch_gb == "all"){ $("input[name=s_all]").val(s_serch_nm); }
    }
	$("#pageIndex").val("1");
    $("form").attr("method", "post");
    $("form").attr("action","manage_user_list.do");
    $("form").submit();
}

function select_go(a){
	$("#seq").val(a);
	$("form").attr("action", "/manage_user_detail.do");
	$("form").attr("method", "post");
	$("form").submit();
}

</script>
</head>

<body>	
	
	<c:import url="/main_header.do"></c:import>
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
	                                <a href="/manage_user_list.do">시스템 관리</a>
	                            </li>
	                            <li class="active">
	                                                            사용자 관리
	                            </li>
	                        </ol>
	                    </div>
	                    <h4 class="page-title">사용자 관리</h4>
	                </div>
	            </div>
	        </div>
	        <!-- End Page-Title -->
	
	        <div class="row">
	            <div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
						<div class="form-group">
                        <form id="accessUserForm" name="accessUserForm" class="form-horizontal">
                        <input type="hidden" name="s_sjt"  value="<c:out value='${manageVO.s_sjt}' escapeXml='false' />" />
						<input type="hidden" name="s_ctn"  value="<c:out value='${manageVO.s_ctn}' escapeXml='false' />" />
						<input type="hidden" name="s_all"  value="<c:out value='${manageVO.s_all}' escapeXml='false' />" />
						<input type="hidden" id="pageIndex" name="pageIndex" value="${num}">
						<input type="hidden" id="seq" name="seq" value="0">
                        <h5 class="header-title m-t-0 m-b-30"><b>검색 조건</b></h5>
					    <div class="row">
                           	<div class="col-md-12">
                                 <div class="form-group">
                                 	<label for="searchStartDate" class="col-md-1 control-label">등록일자</label>
                                     <div class="col-md-3">
                                         <div class="input-group date datetimepickerStart m-b-5">
                                         	<input  class="form-control input-group-addon m-b-0" title ="접속기간 시작일" name="startDate"  placeholder="접속기간을 선택하세요" />
                                             <span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
                                         </div>
                                     </div>
                                 </div>
                             </div> 
                        </div>
						<div class="row">
							<div class="col-md-12">
                                      <div class="form-group">
                                          <label for="searchCondition" class="col-md-1 control-label">검색항목</label>
                                          <div class="col-md-3">
                                              <select class="form-control" name="s_serch_gb" title ="검색항목">
                                              	<option value="">선택</option>
											<option value="sjt">사용자ID</option>
											<option value="ctn">사용자명</option>
											<option value="all">부서</option>
                                              </select>
                                          </div>
                                          <label for="searchKeyword" class="sr-only">검색어</label>
                                          <div class="col-md-8">
                                              <input  class="form-control" title ="검색어" name="s_serch_nm"  onkeypress="if(event.keyCode==13){fnSearchList(); return false;}" placeholder="검색어를 입력하세요" />
                                          </div>
                                      </div>
                                  </div>
						</div>
						<div class="row">
                            <div class="col-md-12">
                                <button type="button" class="btn btn-custom btn-md pull-right searchBtn">
                                    			검색
                                </button>
                                <button type="reset" class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" > 
                                    			 초기화 
                                 </button>
                            </div>
                        </div>
                        </form>
                        </div>
	                    <!-- Table-Content-Wrap -->
	                    <h5 class="header-title"><b>목록</b> <span class="small">(전체 <b class="text-orange"><c:out value="${view01Cnt.totalRecordCount}"/></b>건)</span></h5>
	                    <div class="table-wrap m-t-30">
	                        <table class="table table-custom table-cen table-num text-center table-hover" width="100%">
	                            <colgroup>
	                                <col width="5%" />
	                                <col width="14%" />
	                                <col width="14%" />
	                                <col width="15%" />
	                                <col width="15%" />
	                                <col width="23%" />
	                                <col width="14%" />
	                            </colgroup>
	                            <thead>
	                            <tr>
                                	<th data-sort="int">순번</th>
                                    <th data-sort="string">ID</th>
                                    <th data-sort="string">이름</th>
                                    <th data-sort="string">부서</th>
                                    <th data-sort="string">전화번호</th>
                                    <th data-sort="string">등록일시</th>
                                    <th data-sort="string">회원/탈퇴</th>
                                </tr>
	                            </thead>
	                            <tbody>
	                               <c:choose>
										<c:when test="${!empty userList}">
											<c:forEach items="${userList}" var="result" varStatus="status">
												<tr>
													<td>
													 <c:out value="${view01Cnt.totalRecordCount - (result.rno - 1)}" escapeXml="false" />
													</td>													
			                                        <td>
			                                        <a href="javascript:select_go('<c:out value="${result.user_id}"/>');">
			                                        <c:out value="${result.user_id}"/>
			                                        </a>
			                                        </td>
			                                        <td><c:out value="${result.user_name}"/></td>
			                                        <td><c:out value="${result.user_position}"/></td>
			                                        <td><c:out value="${result.user_phone}"/></td>
			                                        <td><c:out value="${result.reg_date}"/></td>
			                                        <td>
	                                                  <c:choose>
	                                                     <c:when test="${result.del_yn eq 'N'}">
	                                                        		회원
	                                                     </c:when>
	                                                     <c:otherwise>
	                                                        	       삭제 및 탈퇴
	                                                     </c:otherwise>
	                                                  </c:choose>
			                                        </td>
			                                    </tr>
											</c:forEach>
										</c:when>
										<c:otherwise>
											<tr><td colspan="7" style="text-align:center">검색결과가 없습니다.</td></tr>
										</c:otherwise>
									</c:choose>
	                            </tbody>
	                        </table>
	                        <!-- paging - start -->
                            <div class="row">
                                <div class="text-center m-b-20">
	                                <ul class="pagination">
		                               <ui:pagination paginationInfo = "${view01Cnt}" type="user" jsFunction="fn_link_acUser" />
		                            </ul>
	                            </div>
                            </div>
	                    </div>
	                    </div>                                   
	
	                    <!-- Button-Group -->
	                    <div class="modal-footer">
	                        <!--<button type="button" class="btn btn-danger btn-md" id="fc-del-btn" data-toggle="modal" data-target="#alert-delete-detail">-->
	                        <!--<span><i class="fa fa-times-circle m-r-5"></i>취소</span>-->
	                        <!--</button>
	                        <button type="button" class="btn btn-custom btn-md" onclick="register()">
	                            <span><i class="fa fa-check-circle m-r-5"></i>등록</span>
	                        </button>-->
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