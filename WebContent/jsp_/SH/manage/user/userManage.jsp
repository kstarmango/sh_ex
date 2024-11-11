<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

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
	<script src="/jsp/SH/js/jquery.validate.min.js"></script>
	<script src="/jsp/SH/js/jquery.validate.extend.js"></script>
	<script src="/jsp/SH/js/moment-with-locales.min.js"></script>
    <script src="/jsp/SH/js/bootstrap-datetimepicker.min.js"></script>


	<!-- Validate -->
	<!-- <script src="/jsp/SH/js/jquery.validate.min.js"></script> -->

	<!-- HTML5 Shiv and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->
	
	<title>SH | 토지자원관리시스템</title>

	<script type="text/javascript">

	// 초기화 및 이벤트 등록
	$(document).ready(function() {

		$("input[name=s_serch_start_dt]").val(
				"<c:out value='${s_serch_start_dt}'/>"
		);

		$("select[name=s_serch_confm_yn]").val(
				"<c:out value='${s_serch_confm_yn}'/>"
		);

		$("select[name=s_serch_lock_yn]").val(
				"<c:out value='${s_serch_lock_yn}'/>"
		);

		$("select[name=s_serch_use_yn]").val(
				"<c:out value='${s_serch_use_yn}'/>"
		);

		$("select[name=s_serch_gb]").val(
				"<c:out value='${s_serch_gb}'/>"
		);

		$("input[name=s_serch_nm]").val(
				"<c:out value='${s_serch_nm}'/>"
		);

		$('.date').datetimepicker({
			locale: 'ko',
			format: 'YYYY-MM-DD',
		    icons: {
		        previous: "fa fa-chevron-left",
		        next:     "fa fa-chevron-right",
		        time:     "fa fa-clock-o",
		        date:     "fa fa-calendar",
		        up:       "fa fa-arrow-up",
		        down:     "fa fa-arrow-down"
		    }
		});

        var pageIndex = '${pageIndex}';
        var curSort   = '${pageSort}';
        var curOrder  = '${pageOrder}';

        // 검색 - 정렬 초기화
		$("#contents thead tr th").each(function( index ) {
			if($(this).attr('data-sort-col') == curSort.toLowerCase())
			{
            	if(curOrder == 'ASC')
            	{
            		$(this).text($(this).text() + ' ▲ ');
            	}
            	else
            	{
            		$(this).text($(this).text() + ' ▼ ');
           		}
			}
		});

		//  검색 - 정렬 (ID, 이름, 부서명, 전화번호, 등록일시)
		$("#contents thead tr th").click(function() {
            if($(this).attr('data-sort-col') == '')
            	return;

            if(curSort != $(this).attr('data-sort-col'))
            {
            	pageSort  = $(this).attr('data-sort-col');
            	pageOrder = "ASC";
            }
            else
           	{
            	pageSort = curSort;
            	if(curOrder == 'ASC')
            		pageOrder = 'DESC';
            	else
            		pageOrder = 'ASC';
           	}

			$("#userListForm").append('<input type="hidden" name="pageIndex" id="pageIndex" value="' + pageIndex + '" />');
			$("#userListForm").append('<input type="hidden" name="pageSort"  id="pageSort"  value="' + pageSort  + '" />');
			$("#userListForm").append('<input type="hidden" name="pageOrder" id="pageOrder" value="' + pageOrder + '" />');
		    $("#userListForm").attr("method", "post");
		    $("#userListForm").attr("action", "<%=RequestMappingConstants.WEB_MNG_USER%>");
		    $("#userListForm").submit();
        });

		// 검색어 엔터 이벤트
	    $("#s_serch_nm").keydown(function( event ) {
			if ( event.which == 13 ) {
				fn_search_list();
			 	return;
			}
	    });

	    // 검색 버튼 클릭
		$('#btnSearch').click(function(){
			fn_search_list();
		});

		// 검색 초기화 버튼 클릭
		$('#btnReset').click(function(){
			$("input[name=s_serch_start_dt]").val("");
			$("select[name=s_serch_confm_yn]").val("");
			$("select[name=s_serch_lock_yn]").val("");
			$("select[name=s_serch_use_yn]").val("");
			$("select[name=s_serch_gb]").val("");
			$("input[name=s_serch_nm]").val("");
		});


		// 사용자 상세 - 초기화
    	$('#confm_yn').val('');
    	$('#use_yn').val('');
    	$('#lock_yn').val('');

		// 사용자 상세 - 변경 상태 저장 - 셀렉트박스 변경시
		$("select[name=confm_yn], select[name=use_yn], select[name=lock_yn], select[name=p_auth_no], select[name=l_auth_no]").change( function() {
			var sendUrl;
			var sendData;

			if($(this).attr('name') == 'confm_yn') {
				sendUrl = "<%= RequestMappingConstants.WEB_MNG_USER_CONFM %>";
				sendData =  {
					id: $('#user_id').text(),
					confm_yn: $(this).val()
				};
			} else if($(this).attr('name') == 'use_yn') {
				sendUrl = "<%= RequestMappingConstants.WEB_MNG_USER_USE %>";
				sendData =  {
					id: $('#user_id').text(),
					use_yn: $(this).val()
				};
			} else if($(this).attr('name') == 'lock_yn') {
				sendUrl = "<%= RequestMappingConstants.WEB_MNG_USER_LOCK %>";
				sendData =  {
					id: $('#user_id').text(),
					lock_yn: $(this).val()
				};
			} else if($(this).attr('name') == 'p_auth_no') {
				sendUrl = "<%= RequestMappingConstants.WEB_MNG_USER_PAUTH %>";
				sendData =  {
					id: $('#user_id').text(),
					p_auth_no: $(this).val()
				};
			} else if($(this).attr('name') == 'l_auth_no') {
				sendUrl = "<%= RequestMappingConstants.WEB_MNG_USER_LAUTH %>";
				sendData =  {
					id: $('#user_id').text(),
					l_auth_no: $(this).val()
				};
			}

			$.ajax({
				type : "POST",
				async : false,
				url : sendUrl,
				dataType : "json",
				data : sendData,
				error : function(response, status, xhr){
					if(xhr.status =='403'){
						alert('사용자 정보 변경 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
					}
				},
				success : function(data) {
			        if(data.result == "Y" && data.userInfo == "1") {
			        	$('#userDetail').hide();
			        	fn_link_list(pageIndex);
			        	alert('사용자 정보 변경이 정상적으로 완료 되었습니다.');
			        }
				}
			});

		});

		// 사용자 상세 - 변경 상태 저장 - 버튼 클릭시(미사용-개별 셀렉트 박스 이벤트 사용)
		$('#btnUserSave').click(function(e) {
			$.ajax({
				type : "POST",
				async : false,
				url : "<%= RequestMappingConstants.WEB_MNG_USER_USE %>",
				dataType : "json",
				data : {
					id: $('#user_id').text(),
					confm_yn: $("select[name=confm_yn]").val(),
					use_yn: $("select[name=use_yn]").val(),
					lock_yn: $("select[name=lock_yn]").val()
				},
				error : function(response, status, xhr){
					if(xhr.status =='403'){
						alert('사용자 정보 변경 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
					}
				},
				success : function(data) {
			        if(data.result == "Y" && data.userInfo == "1") {
			        	$('#userDetail').hide();
			        	alert('사용자 정보 변경이 정상적으로 완료 되었습니다.');
			        }
				}
			});
		});

		// 사용자 상세 - 암호 초기화
		$('#btnPwdReset').click(function(e) {
			$.ajax({
				type : "POST",
				async : false,
				url : "<%= RequestMappingConstants.WEB_MNG_USER_PWD %>",
				dataType : "json",
				data : {
					id: $('#user_id').text(),
					pwd: 'NOPASSWORD',
					length: 7
				},
				error : function(response, status, xhr){
					if(xhr.status =='403'){
						alert('암호 초기화 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
					}
				},
				success : function(data) {
			        if(data.result == "Y" && data.userInfo == "1" && data.newPwd != "") {
			        	$('#userDetail').hide();
			        	alert('임시 생성 된 패스워드는 [' + data.newPwd + '] 입니다.\n\n임시 생성된 패스워드 이므로 반드시 <%=RequestMappingConstants.WEB_MNG_USER_PWD_NUM%><%=RequestMappingConstants.WEB_MNG_USER_PWD_UNIT_KOR%> 내에 변경 하셔야 합니다.');
			        }
				}
			});
		});

		// 사용자 상세 - 닫기
		$('#btnPopClose').click(function(e) {
			$('#userDetail').hide();
		});

	});

	// 검색
	function fn_search_list() {
		var s_serch_gb = $("select[name=s_serch_gb]").val();
		var s_serch_nm = $("input[name=s_serch_nm]").val();

		/*
		if( jQuery.trim( s_serch_nm ) != "" && s_serch_gb == '')
	    {
			alert('검색항목을 선택하세요');
			return;
	    }
		*/

		$("#userListForm").append('<input type="hidden" name="pageIndex" id="pageIndex" value="1" />');
		$("#userListForm").append('<input type="hidden" name="pageSort"  id="pageSort"  value="${pageSort}" />');
		$("#userListForm").append('<input type="hidden" name="pageOrder" id="pageOrder" value="${pageOrder}" />');
	    $("#userListForm").attr("method", "post");
	    $("#userListForm").attr("action", "<%=RequestMappingConstants.WEB_MNG_USER%>");
	    $("#userListForm").submit();
	}

	// 페이지 링크
	function fn_link_list(pageNo) {
		$("#userListForm").append('<input type="hidden" name="pageIndex" id="pageIndex" value="' + pageNo + '"/>');
		$("#userListForm").append('<input type="hidden" name="pageSort"  id="pageSort"  value="${pageSort}" />');
		$("#userListForm").append('<input type="hidden" name="pageOrder" id="pageOrder" value="${pageOrder}" />');
		$("#userListForm").attr("method", "post");
		$("#userListForm").attr("action", "<%=RequestMappingConstants.WEB_MNG_USER%>");
		$("#userListForm").submit();
	}

	// 상세페이지 이동
	function fn_link_detail(id) {
		$.ajax({
			type : "POST",
			async : false,
			url : "<%= RequestMappingConstants.WEB_MNG_USER_DETAIL %>",
			dataType : "json",
			data : {id: id},
			error : function(response, status, xhr){
				if(xhr.status =='403'){
					$("#userDetail").hide();
					alert('사용자 상세 데이터 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
				}
			},
			success : function(data) {
		        if(data.result == "Y") {
		        	$('#user_id').text(data.userInfo.user_id);
		        	$('#user_nm').text(data.userInfo.user_nm);
		        	$('#dept_nm').text(data.userInfo.dept_nm);
		        	$('#telno').text(data.userInfo.telno);
		        	$('#ins_dt').text(data.userInfo.ins_dt);
		        	$('#upd_dt').text(data.userInfo.upd_dt);
		        	$('#confm_yn').val(data.userInfo.confm_yn);
		        	$('#use_yn').val(data.userInfo.use_yn);
		        	$('#lock_yn').val(data.userInfo.lock_yn);
		        	$('#p_auth_no').val(data.userInfo.p_auth_no);
		        	$('#l_auth_no').val(data.userInfo.l_auth_no);

		        	if(data.userInfo.confm_yn == 'Y') {				// 승인 - Y
		        		$('#confm_yn').attr('disabled', true);
		        		if(data.userInfo.use_yn == 'N') {			// 사용 - N
		        			$('#lock_yn').attr('disabled', true);
		        		}
		        	} else {
		        		$('#confm_yn').attr('disabled', false);		// 승인 - N
		        		$('#use_yn').attr('disabled', true);		// 사용 - N
		        		$('#lock_yn').attr('disabled', true);   	// 잠김 - Y
		        	}

		        	$("#userDetail").center();
		        	$("#userDetail").show();
		        }
			}
		});
	}

	</script>
</head>
<body>

	<%-- <c:import url="/web/admin_header.do"></c:import> --%>
	<c:import url="/web/header.do"></c:import>

	<div class="wrapper">
	    <div class="container">

	        <!-- Page-Title -->
	        <div class="row">
	            <div class="col-sm-12">
	                <div class="page-title-box">
	                    <div class="btn-group pull-right">
	                        <ol class="breadcrumb hide-phone p-0 m-0">
	                            <li>
	                                <a href="<%=RequestMappingConstants.WEB_MAIN%>">HOME</a>
	                            </li>
	                            <li>
	                                <a href="<%=RequestMappingConstants.WEB_MNG_USER%>">${sesMenuNavigation.p_progrm_nm}</a>
	                            </li>
	                            <li class="active">
	                              	${sesMenuNavigation.progrm_nm}
	                            </li>
	                        </ol>
	                    </div>
	                    <h4 class="page-title">${sesMenuNavigation.progrm_nm}</h4>
	                </div>
	            </div>
	        </div>
	        <!-- End Page-Title -->

			<!-- List Page-Body -->
	        <div class="row" id='userList' style='display: block;'>
				<div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">

						<div class="form-group">
                        <form id="userListForm" name="userListForm" class="form-horizontal">
	                        <h5 class="header-title m-t-0 m-b-30"><b>검색 조건</b></h5>
						    <div class="row">
	                           	<div class="col-md-10">
	                                 <div class="form-group">
	                                 	<label for="s_serch_start_dt" class="col-md-1 control-label">등록일자</label>
	                                     <div class="col-md-2">
	                                         <div class="input-group date datetimepickerStart m-b-5">
	                                         	<input  class="form-control input-group-addon m-b-0" style='font-size: 11px;' name="s_serch_start_dt"  title ="등록일자"  placeholder="등록일 선택" />
	                                             <span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
	                                         </div>
	                                     </div>
	                                     <label for="s_serch_confm_yn" class="col-md-1 control-label">승인여부</label>
	                                     <div class="col-md-2">
	                                         <select class="form-control" name="s_serch_confm_yn" title ="승인여부">
	                                         	<option value="">전체</option>
												<option value="Y">승인</option>
												<option value="N">미승인</option>
	                                         </select>
	                                     </div>
	                                     <label for="s_serch_use_yn" class="col-md-1 control-label">사용유무</label>
	                                     <div class="col-md-2">
	                                         <select class="form-control" name="s_serch_use_yn" title ="사용유무">
	                                         	<option value="">전체</option>
												<option value="Y">사용</option>
												<option value="N">미사용</option>
	                                         </select>
	                                     </div>
	                                     <label for="s_serch_lock_yn" class="col-md-1 control-label">잠김여부</label>
	                                     <div class="col-md-2">
	                                         <select class="form-control" name="s_serch_lock_yn" title ="잠김여부">
	                                         	<option value="">전체</option>
												<option value="Y">잠김</option>
												<option value="N">접속가능</option>
	                                         </select>
	                                     </div>
	                                 </div>
	                             </div>
	                        </div>
							<div class="row">
								<div class="col-md-10">
	                                 <div class="form-group">
	                                     <label for="s_serch_gb" class="col-md-1 control-label">검색항목</label>
	                                     <div class="col-md-2">
	                                         <select class="form-control" name="s_serch_gb" title ="검색항목">
	                                         	<option value="">선택</option>
												<option value="user_id">사용자ID</option>
												<option value="user_nm">사용자명</option>
												<option value="dept_nm">부서</option>
	                                         </select>
	                                     </div>
	                                     <label for="s_serch_nm" class="sr-only">검색어</label>
	                                     <div class="col-md-9">
	                                         <input  class="form-control" title ="검색어" id="s_serch_nm" name="s_serch_nm" placeholder="검색어를 입력하세요" />
	                                     </div>
	                                 </div>
	                             </div>
	                            <div class="col-md-2">
	                                <button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnSearch'>검색</button>
	                                <button type="reset" class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id='btnReset' style = "width: 64px; height: 38px; padding-left: 8px; padding-right: 8px;">초기화</button>
	                            </div>
							</div>
                        </form>
                        </div>

	                    <!-- Table-Content-Wrap -->
	                    <h5 class="header-title"><b>목록</b> <span class="small">(전체 <b class="text-orange"><c:out value="${view01Cnt.totalRecordCount}"/></b>건)</span></h5>
	                    <div class="table-wrap m-t-30">
	                        <table class="table table-custom table-cen table-num text-center table-hover" id='contents' width="100%">
	                            <colgroup>
	                                <col width="5%" />
	                                <col width="15%" />
	                                <col width="15%" />
	                                <col width="15%" />
	                                <col width="15%" />
	                                <col width="15%" />
	                                <col width="20%" />
	                            </colgroup>
	                            <thead>
		                            <tr>
	                                	<th data-sort="int"    data-sort-col=""       >순번</th>
	                                    <th data-sort="string" data-sort-col="user_id" style="cursor:pointer" title='사용자 ID로 정렬'>ID</th>
	                                    <th data-sort="string" data-sort-col="user_nm" style="cursor:pointer" title='사용자 이름으로 정렬'>이름</th>
	                                    <th data-sort="string" data-sort-col="dept_nm" style="cursor:pointer" title='사용자 부서명 정렬'>부서명</th>
	                                    <th data-sort="string" data-sort-col="telno"   style="cursor:pointer" title='사용자 전화번호로 정렬'>전화번호</th>
	                                    <th data-sort="string" data-sort-col="ins_dt"  style="cursor:pointer" title='사용자 등록일시로 정렬'>등록일시</th>
	                                    <th data-sort="string" data-sort-col=""  	  >회원상태</th>
	                                </tr>
	                            </thead>
	                            <tbody>
	                               <c:choose>
										<c:when test="${!empty userList}">
											<c:forEach items="${userList}" var="result" varStatus="status">
												<tr onclick="javascript:fn_link_detail('${result.user_id}'); return false;" data-toggle="modal"  data-target="#userDetail">
													<td>
													 	<c:out value="${view01Cnt.totalRecordCount - (result.rno - 1)}" escapeXml="false" />
													</td>
			                                        <td>
			                                       		${result.user_id}
			                                        </td>
			                                        <td>
			                                        	${result.user_nm}
			                                        </td>
			                                        <td>
			                                        	${result.dept_nm}
			                                        </td>
			                                        <td>
			                                        	${result.telno}
			                                        </td>
			                                        <td>
			                                        	${result.ins_dt}
			                                        </td>
			                                        <td>
			                                        	${result.stat_confm} / ${result.stat_lock} / ${result.stat_use}
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
		                               <ui:pagination paginationInfo = "${view01Cnt}" type="user" jsFunction="fn_link_list" />
		                            </ul>
	                            </div>
                            </div>
	                    </div>
	                </div>

	            </div>
	        </div>
	        <!-- End List Page-Body -->

	        <!-- Detail Page-Body -->
	        <div class="row" id='userDetail' style='position: absolute; display: none; z-index:100' role="dialog">
	            <div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
	                	<h5 class="header-title"><b>사용자 상세</b></h5>
	                    <div class="table-wrap m-t-30">
	                        <table class="table table-custom table-cen table-num text-center table-hover" width="100%">
	                            <colgroup>
	                                <col width="20%">
	                                <col width="30%">
	                                <col width="20%">
	                                <col width="30%">
	                            </colgroup>
	                            <tbody>
									<tr>
									    <th scope="row">아이디</th>
									    <td id='user_id'></td>
										<th scope="row">이름</th>
										<td id='user_nm'></td>
									</tr>
									<tr>
										<th scope="row">부서명</th>
									    <td id='dept_nm'></td>
									    <th scope="row">전화번호</th>
									    <td id='telno'></td>
									</tr>
									<tr>
									    <th scope="row">등록일</th>
									    <td id='ins_dt'></td>
									    <th scope="row">마지막수정일</th>
									    <td id='upd_dt'></td>
									</tr>
									<tr>
									  	<th scope="row">승인여부</th>
									  	<td colspan="3">
									      	<select name="confm_yn" id="confm_yn" class="form-control col-md-3 input-sm">
									      		<option value=""></option>
									        	<option value='Y'>승인</option>
									        	<option value='N'>미승인</option>
									    	</select>
									 	</td>
									 </tr>
									 <tr>
									  	<th scope="row">탈퇴여부</th>
									  	<td >
											<select name="use_yn" id="use_yn" class="form-control col-md-3 input-sm">
												<option value=""></option>
									        	<option value='Y'>사용</option>
									        	<option value='N'>미사용</option>
									    	</select>
									    </td>
										<th scope="row">잠김여부</th>
										<td>
									      	<select name="lock_yn" id="lock_yn" class="form-control col-md-3 input-sm">
									      		<option value=""></option>
												<option value='Y'>잠김</option>
												<option value='N'>접속가능</option>
									    	</select>
									 	</td>
									</tr>
		                            <tr>
		                                <th scope="row">프로그램 권한</th>
		                                <td>
											<select name="p_auth_no" id="p_auth_no" class="form-control col-md-3 input-sm">
												<option value=""></option>
												<c:forEach var="item1" items="${progrmAuthList}">
												<option value="${item1.p_auth_no}" ${item1.bass_yn eq 'Y' ? 'selected' : ''}>${item1.auth_desc}</option>
												</c:forEach>
									    	</select>

		                                </td>
		                                <th scope="row">지도레이어 권한</th>
		                                <td>
											<select name="l_auth_no" id="l_auth_no" class="form-control col-md-3 input-sm">
												<option value=""></option>
												<c:forEach var="item2" items="${layerAuthList}">
												<option value="${item2.l_auth_no}" ${item2.bass_yn eq 'Y' ? 'selected' : ''}>${item2.auth_desc}</option>
												</c:forEach>
									    	</select>
		                                </td>
		                        	</tr>
	                        	</tbody>
	                        </table>
	                    </div>
	                    <div class="clearfix"></div>
	                    <!-- <div class="modal-footer"> -->
	                    <div>
	                       <div class="btn-wrap pull-left">
                            	<!-- <button class="btn btn btn-info"  id="btnPwdReset"  type="button">비밀번호 초기화</button> -->
                           		<button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn"  id="btnPwdReset"  type="button" data-dismiss="modal">비밀번호 초기화</button>
                           </div>
                           <div class="btn-wrap pull-right">
                               	<!-- <button class="btn btn btn-custom" id="btnUserSave"   type="button">저장</button> -->
                               	<!-- <button class="btn btn btn-danger" id="btnPopClose" type="button">닫기</button> -->
                               	<button class="btn btn-custom btn-md pull-right searchBtn" id="btnPopClose" type="button" data-dismiss="modal">닫기</button>
                           </div>
	                    </div>
					</div>
	        	</div>
	        </div>
	        <!-- End Detail Page-Body -->

	    </div>
	</div>

	<c:import url="<%= RequestMappingConstants.WEB_MAIN_FOOTER %>"></c:import>

</body>
</html>