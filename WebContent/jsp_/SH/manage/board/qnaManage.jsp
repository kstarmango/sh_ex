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
    
	<!-- 로컬 -->
	<link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.8/summernote.css" rel="stylesheet">
	<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.8/summernote.js"></script>
	
	<!-- 개발 -->
	<!--<link href="//cdnjs.cloudflare.com/ajax/libs/summernote/0.8.8/summernote.css" rel="stylesheet"> -->
	<!--<script src="//cdnjs.cloudflare.com/ajax/libs/summernote/0.8.8/summernote.js"></script>  -->
	
	<script src="/jsp/SH/js/summernote-ko-KR.js"></script>

	<!-- Validate -->
	<!-- <script src="/jsp/SH/js/jquery.validate.min.js"></script> -->

	<!-- HTML5 Shiv and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->

	<title>SH | 토지자원관리시스템</title>

	<style type="text/css">
		.tooltip {
			display: none;
			width: 200px;
		}
		.note-editable {
		  text-align: left
		}
	</style>

	<script type="text/javascript">

	// 초기화 및 이벤트 등록
	$(document).ready(function() {

		$('#re_article_conts').summernote({
			placeholder: '토지자원관리시스템의 공간정보에 대한 질의•요청 사항을 게시할 수 있습니다.위 내용과 관계없는 질의•요청사항은 관리자에 의해 삭제될 수 있습니다.',
			lang: 'ko-KR',
			height: 200,
			width: 700,
	        toolbar:[
	          ['style', ['style']],
	          ['font', ['bold', 'italic', 'underline', 'clear']],
	          ['fontname', ['fontname']],
	          ['fontsize', ['fontsize']],
	          ['color', ['color']],
	          ['para', ['ul', 'ol', 'paragraph']],
	          ['height', ['height']],
	          ['table', ['table']],
	          ['view', ['codeview']],
	        ]
		});

		$('#qna_contents').summernote({
			placeholder: '토지자원관리시스템의 공간정보에 대한 질의•요청 사항을 게시할 수 있습니다.위 내용과 관계없는 질의•요청사항은 관리자에 의해 삭제될 수 있습니다.',
			lang: 'ko-KR',
			height: 200,
			width: 700,
	        toolbar:[
	          ['style', ['style']],
	          ['font', ['bold', 'italic', 'underline', 'clear']],
	          ['fontname', ['fontname']],
	          ['fontsize', ['fontsize']],
	          ['color', ['color']],
	          ['para', ['ul', 'ol', 'paragraph']],
	          ['height', ['height']],
	          ['table', ['table']],
	          ['view', ['codeview']],
	        ]
		});

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
        var boardType = '${boardType}';

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
			$("select[name=s_serch_gb]").val("");
			$("input[name=s_serch_nm]").val("");
		});

		// 상세 - 수정
		$('#btnEdit').click(function(){
			if($('#article_no').val() == '')
				return;

        	if($("#qna_no").length == 0)
        		$("#boardAdd").append('<input type="hidden" name="qna_no" id="qna_no"/>');

        	$('#curr_head_title').text('수정');

        	$('#qna_no').val($('#article_no').val());
			$('#qna_title').val($('#article_title').text());
			//$('#qna_contents').text($('#article_conts').text());
			$('#qna_contents').summernote('code', $('#article_conts').html());

			$("#boardAdd").show();
			$("#boardAdd").center();

			$("#boardDetail").hide();
		});

		// 상세 - 사용/미사용
		$('#btnDelete').click(function(){
			if($('#article_no').val() == '')
				return;

			$.ajax({
				type : "POST",
				async : false,
				url : "<%= RequestMappingConstants.WEB_MNG_QNA_USEYN %>",
				dataType : "json",
				data : {
					article_no: $('#article_no').val(),
					use_yn: ($('#btnDelete').text() == '사용' ? 'Y' : 'N')
				},
				error : function(response, status, xhr){
					if(xhr.status =='403'){
						alert('질의•요청 삭제 데이터 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
					}
				},
				success : function(data) {
			        if(data.result == "Y") {
			        	$("#boardDetail").hide();
			        	fn_link_list(pageIndex)
			        }
				}
			});
		});

		// 상세 - 답글
		$('#btnReply').click(function(){
			if($('#btnReply').text() == '답글쓰기') {
				$('#btnReply').text('답글저장');
				$("#re_article").show();
			}
			else
			{
	        	if($('#re_article_no').length != 0 && $('#re_article_no').val() != '')
				{
					$.ajax({
						type : "POST",
						async : false,
						url : "<%= RequestMappingConstants.WEB_MNG_QNA_READD %>",
						dataType : "json",
						data : {
							article_cd: boardType,
							article_no: $('#re_article_no').val(),
							article_title: $('#re_article_title').val(),
							//article_contents: $('#re_article_conts').val(),
							article_contents: $('#re_article_conts').summernote('code'),
						},
						error : function(response, status, xhr){
							if(xhr.status =='403'){
								alert('질의•요청 등록 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
							}
						},
						success : function(data) {
					        if(data.result == "Y") {
					        	$("#boardAdd").hide();
					        	fn_link_list(1);
					        }
						}
					});
				}
			}
		});

		// 상세 - 닫기
		$('#btnPopClose').click(function(e) {
			$('#btnReply').text('답글쓰기');
			$("#re_article").hide();
			$('#boardDetail').hide();
			$('#boardAdd').hide();
			$('#boardDetail').modal('hide');
			
		});

		// 글쓰기
		$('#btnAdd').click(function(){
			$('#curr_head_title').text('등록');

        	$('#qna_no').val('');
			$('#qna_title').val('');
			//$('#qna_contents').text('');
			$('#qna_contents').summernote('code', '');

			$("#boardAdd").show();
			$("#boardAdd").center();
		});

		// 글쓰기 - 등록 및 수정
		$('#btnRegSave').click(function(e) {
			if($('#qna_no').length == 0 || $('#qna_no').val() == '')
			{
				$.ajax({
					type : "POST",
					async : false,
					url : "<%= RequestMappingConstants.WEB_MNG_QNA_ADD %>",
					dataType : "json",
					data : {
						article_cd: boardType,
						article_title: $('#qna_title').val(),
						//article_contents: $('#qna_contents').val(),
						article_contents: $('#qna_contents').summernote('code'),
					},
					error : function(response, status, xhr){
						if(xhr.status =='403'){
							alert('질의•요청 등록 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
						}
					},
					success : function(data) {
				        if(data.result == "Y") {
				        	$("#boardAdd").hide();
				        	fn_link_list(1);
				        }
					}
				});
			}
			else
			{
				$.ajax({
					type : "POST",
					async : false,
					url : "<%= RequestMappingConstants.WEB_MNG_QNA_EDIT %>",
					dataType : "json",
					data : {
						article_no: $('#qna_no').val(),
						article_title: $('#qna_title').val(),
						//article_contents: $('#qna_contents').val(),
						article_contents: $('#qna_contents').summernote('code'),
					},
					error : function(response, status, xhr){
						if(xhr.status =='403'){
							alert('질의•요청 수정 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
						}
					},
					success : function(data) {
				        if(data.result == "Y") {
				        	$("#boardAdd").hide();
				        	fn_link_list(pageIndex);
				        }
					}
				});
			}

		});

		// 글쓰기 - 닫기
		$('#btnRegClose').click(function(e) {
			if(confirm('저장을 취소하시겠습니까?') === true){
				$('#boardAdd').hide();
				$('#boardAdd').modal('hide');
				$('#boardDetail').hide();
				$('#boardDetail').modal('hide');
			}
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

		$("#boardListForm").append('<input type="hidden" name="pageIndex" id="pageIndex" value="1" />');
		$("#boardListForm").append('<input type="hidden" name="boardType" id="boardType" value="${boardType}" />');
	    $("#boardListForm").attr("method", "post");
	    $("#boardListForm").attr("action", "<%=RequestMappingConstants.WEB_MNG_QNA%>");
	    $("#boardListForm").submit();
	}

	// 페이지 링크
	function fn_link_list(pageNo) {
		$("#boardListForm").append('<input type="hidden" name="pageIndex" id="pageIndex" value="' + pageNo + '"/>');
		$("#boardListForm").append('<input type="hidden" name="boardType" id="boardType" value="${boardType}" />');
		$("#boardListForm").attr("method", "post");
		$("#boardListForm").attr("action", "<%=RequestMappingConstants.WEB_MNG_QNA%>");
		$("#boardListForm").submit();
	}

	// 상세페이지 이동
	function fn_link_detail(id) {
		$.ajax({
			type : "POST",
			async : false,
			url : "<%= RequestMappingConstants.WEB_MNG_QNA_DETAIL %>",
			dataType : "json",
			data : {notice_no: id},
			error : function(response, status, xhr){
				if(xhr.status =='403'){
					$("#boardDetail").hide();
					alert('질의•요청 상세 데이터 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
				}
			},
			success : function(data) {
		        if(data.result == "Y") {
					// 답변글 영역
		        	if($("#re_article_no").length == 0)
		        		$("#re_article").append('<input type="hidden" name="re_article_no" id="re_article_no"/>');
		        	$('#re_article_no').val(id);
		        	$('#re_article_title').val("re : " + data.boardInfo.article_title);
		        	//$('#re_article_conts').val(data.boardInfo.article_conts + '\n\n' + 're : ');
		        	$('#re_article_conts').summernote('code', data.boardInfo.article_conts + '\r\n' + 're : ')
		        	$("#re_article").hide();

		        	// 상세 영역
		        	$('#user_id').text(data.boardInfo.ins_user_id);
		        	$('#user_nm').text(data.boardInfo.ins_user_nm);
		        	$('#ins_dt').text(data.boardInfo.ins_dt);
		        	$('#upd_dt').text(data.boardInfo.upd_dt);
		        	$('#article_title').text(data.boardInfo.article_title);
		        	//$('#article_conts').text(data.boardInfo.article_conts);
		        	$('#article_conts').html(data.boardInfo.article_conts);

		        	if($("#article_no").length == 0)
		        		$("#boardDetail").append('<input type="hidden" name="article_no" id="article_no"/>');
		        	$('#article_no').val(id);

		        	if(data.boardInfo.use_yn == '사용') {
		        		$('#btnDelete').text('미사용');
		        		$('#btnEdit').show();
		        		$('#btnReply').show();
		        	} else {
		        		$('#btnDelete').text('사용');
		        		$('#btnEdit').hide();
		        		$('#btnReply').hide();
		        	}

		        	$("#boardDetail").center();
		        	$("#boardDetail").show();
		        }
			}
		});
	}

	</script>
</head>
<body>

	<%-- <c:import url="/web/admin_header.do"></c:import> --%>
	<c:import url="<%= RequestMappingConstants.WEB_MAIN_HEADER %>"></c:import>

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
	        <div class="row" id='boardList' style='display: block;'>
				<div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
						<div class="form-group">
                        <form id="boardListForm" name="boardListForm" class="form-horizontal">
	                        <h5 class="header-title m-t-0 m-b-30"><b>검색 조건</b></h5>
							<div class="row">
								<div class="col-md-10">
	                                 <div class="form-group">
	                                     <label for="s_serch_gb" class="col-md-1 control-label">검색항목</label>
	                                     <div class="col-md-2">
	                                         <select class="form-control" name="s_serch_gb" title ="검색항목">
	                                         	<option value="">선택</option>
												<option value="article_title">제목</option>
												<option value="article_conts">내용</option>
	                                         </select>
	                                     </div>
	                                     <label for="s_serch_nm" class="sr-only">검색어</label>
	                                     <div class="col-md-6">
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
	                                <col width="55%" />
	                                <col width="10%" />
	                                <col width="15%" />
	                                <col width="8%" />
	                                <col width="7%" />
	                            </colgroup>
	                            <thead>
		                            <tr>
	                                	<th data-sort="int"   >순번</th>
	                                    <th data-sort="string">제목</th>
	                                    <th data-sort="string">작성자</th>
	                                    <th data-sort="string">등록일시</th>
	                                    <th data-sort="string">사용여부</th>
	                                    <th data-sort="string">조회수</th>
	                                </tr>
	                            </thead>
	                            <tbody>
	                               <c:choose>
										<c:when test="${!empty boardList}">
											<c:forEach items="${boardList}" var="result" varStatus="status">
												<tr onclick="javascript:fn_link_detail('${result.article_no}'); return false;" data-toggle="modal" data-target="#boardDetail">
													<td>
													 	<c:out value="${view01Cnt.totalRecordCount - (result.rno - 1)}" escapeXml="false" />
													</td>
			                                        <td style='text-align: left'>
			                                       		<c:out value="${result.space}" escapeXml="false"/><c:out value="${result.article_title}"/>
			                                        </td>
			                                        <td>
			                                        	${result.ins_user_nm}
			                                        </td>
			                                        <td>
			                                        	${result.ins_dt}
			                                        </td>
			                                        <td>
			                                        	${result.use_yn}
			                                        </td>
			                                        <td>
			                                        	${result.view_cnt}
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

                            <!-- Button-Group -->
		                    <div class="modal-footer">
		                        <!--<button type="button" class="btn btn-danger btn-md" id="fc-del-btn" data-toggle="modal" data-target="#alert-delete-detail">-->
		                        <!--<span><i class="fa fa-times-circle m-r-5"></i>취소</span>
		                        </button>-->
		                        <button type="button" class="btn btn-custom btn-md" id="btnAdd" data-toggle="modal"  data-target="#boardAdd">
		                            <span><i class="fa fa-pencil m-r-5"></i>글쓰기</span>
		                        </button>
		                    </div>
		                    <!--// End Button-Group -->
	                    </div>
	                </div>

	            </div>
	        </div>
	        <!-- End List Page-Body -->

	        <!-- Detail Page-Body -->
	        <div class="row" id='boardDetail' style='position: absolute; width: 900px; display: none; z-index:100' role="dialog">
	            <div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
	                    <h5 class="header-title"><b>질의•요청 상세</b></h5>
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
										<th scope="row">작성자</th>
										<td id='user_nm'></td>
									</tr>
									<tr>
									    <th scope="row">등록일</th>
									    <td id='ins_dt'></td>
									    <th scope="row">수정일</th>
									    <td id='upd_dt'></td>
									</tr>
		                            <tr>
		                                <th scope="row">제목</th>
		                                <td colspan="3" id='article_title'></td>
		                        	</tr>
		                            <tr>
		                                <th scope="row">내용</th>
		                                <td colspan="3" class="td-expand" name="article_conts" id="article_conts">
		                                	<!-- <textarea name="article_conts" id="article_conts" rows="10" cols="70" class="form-control" placeholder="내용을 입력해주세요." title="내용" readonly></textarea> -->
		                                </td>
		                        	</tr>
	                        	</tbody>
	                        </table>
	                    </div>
	                    <div id='re_article' class="table-wrap m-t-30" style='display: none;'>
	                        <table class="table table-custom table-cen table-num text-center table-hover" width="100%">
	                            <colgroup>
	                            	<col width="20%">
	                                <col width="30%">
	                                <col width="20%">
	                                <col width="30%">
	                            </colgroup>
	                            <tbody>
                                	<tr>
                                       <th scope="row">답변 제목<span class="text-danger">*</span></th>
                                       <td colspan="3">
                                       <input class="form-control required" name="re_article_title" id="re_article_title"  type="text" maxlength="20" title="제목" placeholder="말머리에 [질의] or [요청] 을 구분해주세요. " />
                                       </td>
                                   	</tr>
                                   	<tr>
	                                    <th scope="row">답변 내용<span class="text-danger">*</span></th>
	                                    <td colspan="3">
	                                    	<!-- <textarea name="re_article_conts" id="re_article_conts" rows="12" cols="60" class="form-control" placeholder="내용을 입력해주세요." title="내용" ></textarea> -->
	                                    	<div name="re_article_conts" id="re_article_conts"></div>
	                                	</td>
                                  	</tr>
                               	</tbody>
                       		</table>
	                    </div>
	                    <div>
	                       	<div class="btn-wrap pull-left">
	                       		<button class="btn btn-custom btn-md pull-right searchBtn" id="btnReply" type="button">답글쓰기</button>
	                           	<button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id="btnDelete" type="button">미사용</button>
	                           	<button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id="btnEdit" type="button">수정</button>
                           	</div>
                           	<div class="btn-wrap pull-right">
                            	<button class="btn btn-custom btn-md pull-right searchBtn" id="btnPopClose" type="button" data-dismiss="modal">닫기</button>
                           	</div>
	                    </div>
					</div>
	        	</div>
	        </div>
	        <!-- End Detail Page-Body -->

	        <!-- Add Page-Body -->
	        <div class="row" id="boardAdd" style='position: absolute; display: none; z-index:100;' role="dialog">
	            <div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult" style = "width: 1000px; height: 570px;">
	                    <h5 class="header-title"><b>질의•요청 <span id="curr_head_title">등록</span></b></h5>
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
                                       <th scope="row">제목<span class="text-danger">*</span></th>
                                       <td colspan="3">
                                       <input class="form-control required" name="qna_title" id="qna_title"  type="text" maxlength="200" title="제목" placeholder="말머리에 [질의] or [요청] 을 구분해주세요. " />
                                       </td>
                                   	</tr>
                                   	<tr>
	                                    <th scope="row">내용<span class="text-danger">*</span></th>
	                                    <td colspan="3">
	                                    	<!-- <textarea name="qna_contents" id="qna_contents" rows="12" cols="60" class="form-control" placeholder="내용을 입력해주세요." title="내용" ></textarea> -->
	                                    	<div name="qna_contents" id="qna_contents" ></div>
	                                	</td>
                                  	</tr>
                               	</tbody>
                       		</table>
	                    </div>
	                    <div>
                           	<div class="btn-wrap pull-left">
                          	</div>
                           	<div class="btn-wrap pull-right">
                               <button class="btn btn-custom btn-md pull-right searchBtn" id="btnRegClose" type="button">닫기</button>
                               <button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id="btnRegSave" type="button">저장</button>
                           	</div>
	                    </div>
	                </div>
	            </div>
	        </div>
	       	<!-- End Add Page-Body -->

	    </div>
	</div>

	<c:import url="<%= RequestMappingConstants.WEB_MAIN_FOOTER %>"></c:import>

</body>
</html>