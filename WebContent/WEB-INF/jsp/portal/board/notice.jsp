<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

	<!-- <style type="text/css">
		.tooltip {
			display: none;
			width: 200px;
		}
		.note-editable {
		  text-align: left
		}
	</style> -->

	<script>

	// 초기화 및 이벤트 등록
	$(document).ready(function() {

		$('#notice_contents').summernote({
			lang: 'ko-KR',
			placeholder: '내용을 입력하세요',
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

		$("input[name=s_serch_start_dt]").val(
				"<c:out value='${s_serch_start_dt}'/>"
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
        var boardType = '${boardType}';

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

		// 검색 - 정렬 (제목, 등록자, 등록일시, 조회수)
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

			$("#boardListForm").append('<input type="hidden" name="pageIndex" id="pageIndex" value="' + pageIndex + '" />');
			$("#boardListForm").append('<input type="hidden" name="pageSort"  id="pageSort"  value="' + pageSort  + '" />');
			$("#boardListForm").append('<input type="hidden" name="pageOrder" id="pageOrder" value="' + pageOrder + '" />');
			$("#boardListForm").append('<input type="hidden" name="boardType" id="boardType" value="' + '${boardType}' + '" />');
		    $("#boardListForm").attr("method", "post");
		    //$("#boardListForm").attr("action","manage_user_list.do");
		    $("#boardListForm").attr("action", "<%=RequestMappingConstants.WEB_NOTICE%>");
		    $("#boardListForm").submit();
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
			$("select[name=s_serch_gb]").val("");
			$("input[name=s_serch_nm]").val("");
		});

		// 상세 - 수정
		$('#btnEdit').click(function(){
			if($('#article_no').val() == '')
				return;

        	if($("#notice_no").length == 0)
        		$("#boardAdd").append('<input type="hidden" name="notice_no" id="notice_no"/>');

        	$('#curr_head_title').text('수정');

        	$('#notice_no').val($('#article_no').val());
			$('#notice_title').val($('#article_title').text());
			//$('#notice_contents').text($('#article_conts').text());
			$('#notice_contents').summernote('code', $('#articleScroll').html());
			$('#notice_pop_start_dt').val($('#pop_start_dt').text().substring(0, 10).replace(/\//gi, '-'));
			$('#notice_pop_end_dt').val($('#pop_end_dt').text().substr(0, 10).replace(/\//gi, '-'));

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
				url : "<%= RequestMappingConstants.WEB_MNG_NOTICE_USEYN %>",
				dataType : "json",
				data : {
					article_no: $('#article_no').val(),
					use_yn: ($('#btnDelete').text() == '사용' ? 'Y' : 'N')
				},
				error : function(response, status, xhr){
					if(xhr.status =='403'){
						alert('공지사항 삭제 데이터 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
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
		
		// 2022-10-17  상세 - 삭제 
			$('#articleDelete').click(function(){
				  if (confirm("정말 삭제하시겠습니까?")){
					  $.ajax({
							type : "POST",
							async : false,
							url : "<%= RequestMappingConstants.WEB_MNG_NOTICE_DELETE %>",
							dataType : "json",
							data : {
								article_no: $('#article_no').val(),
							},
							error : function(response, status, xhr){
								if(xhr.status =='403'){
									alert('공지사항 삭제 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
								}
							},
							success : function(data) {
								$("#boardDetail").hide();
								fn_link_list(pageIndex);
							}
						});
					 }
		});
		
		// 상세 - 닫기
		$('#btnPopClose').click(function(e) {
			$("#boardDetail").hide();
		});

		// 글쓰기
		$('#btnAdd').click(function(){
			$('#curr_head_title').text('등록');

			$('#notice_no').val('');
			$('#notice_title').val('');
			//$('#notice_contents').text('');
			$('#notice_contents').summernote('code', '');
			$('#notice_pop_start_dt').val('');
			$('#notice_pop_end_dt').val('');

			$("#boardAdd").show();
			$("#boardAdd").center();
		});

		// 글쓰기 - 등록 및 수정
		$('#btnRegSave').click(function(e) {
			if($('#notice_no').length == 0 || $('#notice_no').val() == '')
			{
				$.ajax({
					type : "POST",
					async : false,
					url : "<%= RequestMappingConstants.WEB_MNG_NOTICE_ADD %>",
					dataType : "json",
					data : {
						article_cd: boardType,
						article_title: $('#notice_title').val(),
						//article_contents: $('#notice_contents').val(),
						article_contents: $('#notice_contents').summernote('code'),
						article_pop_start_dt: $('#notice_pop_start_dt').val(),
						article_pop_end_dt: $('#notice_pop_end_dt').val()
					},
					error : function(response, status, xhr){
						if(xhr.status =='403'){
							alert('공지사항 등록 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
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
					url : "<%= RequestMappingConstants.WEB_MNG_NOTICE_EDIT %>",
					dataType : "json",
					data : {
						article_no: $('#notice_no').val(),
						article_title: $('#notice_title').val(),
						//article_contents: $('#notice_contents').val(),
						article_contents: $('#notice_contents').summernote('code'),
						article_pop_start_dt: $('#notice_pop_start_dt').val(),
						article_pop_end_dt: $('#notice_pop_end_dt').val()
					},
					error : function(response, status, xhr){
						if(xhr.status =='403'){
							alert('공지사항 수정 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
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
		$("#boardListForm").append('<input type="hidden" name="pageSort"  id="pageSort"  value="${pageSort}" />');
		$("#boardListForm").append('<input type="hidden" name="pageOrder" id="pageOrder" value="${pageOrder}" />');
		$("#boardListForm").append('<input type="hidden" name="boardType" id="boardType" value="${boardType}" />');
	    $("#boardListForm").attr("method", "post");
	    $("#boardListForm").attr("action", "<%=RequestMappingConstants.WEB_NOTICE%>");
	    $("#boardListForm").submit();
	}

	// 페이지 링크
	function fn_link_list(pageNo) {
		$("#boardListForm").append('<input type="hidden" name="pageIndex" id="pageIndex" value="' + pageNo + '"/>');
		$("#boardListForm").append('<input type="hidden" name="pageSort"  id="pageSort"  value="${pageSort}" />');
		$("#boardListForm").append('<input type="hidden" name="pageOrder" id="pageOrder" value="${pageOrder}" />');
		$("#boardListForm").append('<input type="hidden" name="boardType" id="boardType" value="${boardType}" />');
		$("#boardListForm").attr("method", "post");
		$("#boardListForm").attr("action", "<%=RequestMappingConstants.WEB_NOTICE%>");
		$("#boardListForm").submit();
	}

	// 상세페이지 이동
	function fn_link_detail(id) {
		$.ajax({
			type : "POST",
			async : false,
			url : "<%= RequestMappingConstants.WEB_MNG_NOTICE_DETAIL %>",
			dataType : "json",
			data : {notice_no: id},
			error : function(response, status, xhr){
				if(xhr.status =='403'){
					$("#boardDetail").hide();
					alert('공지사항 상세 데이터 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
				}
			},
			success : function(data) {
		        if(data.result == "Y") {
		        	$('#user_id').text(data.boardInfo.ins_user_id);
		        	$('#user_nm').text(data.boardInfo.ins_user_nm);
		        	$('#ins_dt').text(data.boardInfo.ins_dt);
		        	$('#upd_dt').text(data.boardInfo.upd_dt);
		        	$('#article_title').text(data.boardInfo.article_title);
		        	//$('#article_conts').text(data.boardInfo.article_conts);
		        	$('#articleScroll').html(data.boardInfo.article_conts);
		        	$('#pop_start_dt').text(data.boardInfo.pop_start_dt);
		        	$('#pop_end_dt').text(data.boardInfo.pop_end_dt);

		        	if($("#article_no").length == 0)
		        		$("#boardDetail").append('<input type="hidden" name="article_no" id="article_no"/>');
		        	$('#article_no').val(id);

		        	if(data.boardInfo.use_yn == '사용')
		        		$('#btnDelete').text('미사용');
		        	else
		        		$('#btnDelete').text('사용');

		        	$("#boardDetail").center();
		        	$("#boardDetail").show();

					$.ajax({
						type : "POST",
						async : false,
						url : "<%= RequestMappingConstants.WEB_MNG_NOTICE_VIEW_CNT %>",
						dataType : "json",
						data : {
							article_no: $('#article_no').val()
						},
						error : function(response, status, xhr){
							if(xhr.status =='403'){
							}
						},
						success : function(data) {
					        if(data.result == "Y") {
					        	//alert(data.views)
					        	$('#views_' + id).text(data.views);
					        }
						}
					});
		        }
			}
		});
	}

	</script>

	<!-- <div class="wrapper"> -->
	<div class="contWrap">
		<h1>${sesMenuNavigation.progrm_nm}</h1>
		<div class="whiteCont" style="height: calc( 100% - 22px);">
        	<p class="pageNav">
                <a href="<%=RequestMappingConstants.WEB_MAIN%>">HOME</a> &nbsp;&nbsp; |  &nbsp;&nbsp;  <a href="<%=RequestMappingConstants.WEB_MNG_USER%>">게시판<%-- ${sesMenuNavigation.p_progrm_nm} --%></a>  &nbsp;&nbsp;  |  &nbsp;&nbsp;  	${sesMenuNavigation.progrm_nm}
            </p> 
		
	    <%-- <div class="container">
			
	        <!-- Page-Title -->
	        <div class="row">
	            <div class="col-sm-12">
	                <div class="page-title-box">
	                    <div class="btn-group pull-right">
	                        <ol class="breadcrumb hide-phone p-0 m-0">
	                            <li>
	                                <a href="<%=RequestMappingConstants.WEB_MAIN%>">HOME</a>
	                            </li>
	                            <li class="active">
	                              	${sesMenuNavigation.progrm_nm}
	                            </li>
	                        </ol>
	                    </div>
	                    <h4 class="page-title">${sesMenuNavigation.progrm_nm}</h4>
	                </div>
	            </div>
	        </div>  --%>
	        <!-- End Page-Title -->

			<!-- List Page-Body -->
	        <div class="row" id='boardList' style='display: block;'>
				<div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult" style="background-color: transparent;border: transparent;">
						<div class="form-group">
                        <form id="boardListForm" name="boardListForm" class="form-horizontal">
	                        <h5 class="header-title m-t-0 m-b-30"><b>검색 조건</b></h5>
							<div class="row">
								<div class="col-md-10">
	                                 <div class="form-group">
	                                 	<label class="col-md-1 control-label" style="font-size: medium;">등록일자</label>
	                                     <div class="col-md-2">
	                                         <div class="input-group date datetimepickerStart m-b-5">
	                                         	<input  class="form-control input-group-addon m-b-0" style='font-size: 11px;' name="s_serch_start_dt"  title ="등록일자"  placeholder="등록일 선택">
	                                             <span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
	                                         </div>
	                                     </div>
	                                     <label class="col-md-1 control-label" style="font-size: medium;">검색항목</label>
	                                     <div class="col-md-2">
	                                         <select class="form-control" name="s_serch_gb" title ="검색항목">
	                                         	<option value="">선택</option>
												<option value="article_title">제목</option>
												<option value="article_conts">내용</option>
												<option value="ins_user_nm">작성자</option>
	                                         </select>
	                                     </div>
	                                     <label for="s_serch_nm" class="sr-only">검색어</label>
	                                     <div class="col-md-6">
	                                         <input  class="form-control" title ="검색어" id="s_serch_nm" name="s_serch_nm" placeholder="검색어를 입력하세요">
	                                     </div>
	                                 </div>
	                             </div>
	                            <div class="col-md-2">
	                                <button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnSearch' style="height: 38px;">검색</button>
	                                <button type="reset" class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id='btnReset' style = "width: 64px; height: 38px; padding-left: 8px; padding-right: 8px;">초기화</button>
	                            </div>
							</div>
                        </form>
                        </div>

	                    <!-- Table-Content-Wrap -->
	                    <h5 class="header-title"><b>목록</b> <span class="small">(전체 <b class="text-orange"><c:out value="${view01Cnt.totalRecordCount}"/></b>건)</span></h5>
	                    <div class="table-wrap">
	                        <table class="table table-custom table-cen table-num text-center table-hover" id='contents'>
	                        	<caption class="none">공지사항 목록 테이블</caption>
	                            <colgroup>
	                            	<c:if test="${sesUserAdminYn eq 'N' }">
	                            	<col style="width:5%">
	                                <col style="width:50%">
	                                <col style="width:18%">
	                                <col style="width:15%">
	                                <col style="width:12%">
	                            	</c:if>
	                            	<c:if test="${sesUserAdminYn eq 'Y' }">
	                            	<col style="width:5%">
	                                <col style="width:25%">
	                                <col style="width:10%">
	                                <col style="width:15%">
	                                <col style="width:15%">
	                                <col style="width:15%">
	                                <col style="width:8%">
	                                <col style="width:7%">
	                                </c:if>
	                            </colgroup>
	                            <thead>
		                            <tr>
		                            	<c:if test="${sesUserAdminYn eq 'N' }">
		                            	<th data-sort="int"    data-sort-col="" >순번</th>
	                                    <th data-sort="string" data-sort-col="article_title"   	style="cursor:pointer" title='제목으로 정렬'>제목</th>
	                                    <th data-sort="string" data-sort-col="ins_user_nm" 		style="cursor:pointer" title='작성자로 정렬'>작성자</th>
	                                    <th data-sort="string" data-sort-col="ins_dt"  			style="cursor:pointer" title='등록일시로 정렬'>등록일시</th>
	                                    <th data-sort="string" data-sort-col="article_view_cnt" style="cursor:pointer" title='조회수로 정렬'>조회수</th>
		                            	</c:if>
		                            	<c:if test="${sesUserAdminYn eq 'Y' }">
	                                	<th data-sort="int"    data-sort-col="" >순번</th>
	                                    <th data-sort="string" data-sort-col="article_title"   	style="cursor:pointer" title='제목으로 정렬'>제목</th>
	                                    <th data-sort="string" data-sort-col="ins_user_nm" 		style="cursor:pointer" title='작성자로 정렬'>작성자</th>
	                                    <th data-sort="string" data-sort-col="ins_dt"  			style="cursor:pointer" title='등록일시로 정렬'>등록일시</th>
	                                    <th data-sort="string" data-sort-col="pop_start_dt"     style="cursor:pointer" title='오픈시작일로 정렬'>오픈시작일</th>
	                                    <th data-sort="string" data-sort-col="pop_end_dt"       style="cursor:pointer" title='오픈종료일로 정렬'>오픈종료일</th>
	                                    <th data-sort="string" data-sort-col="use_yn"           style="cursor:pointer" title='사용여부로 정렬'>사용여부</th>
	                                    <th data-sort="string" data-sort-col="article_view_cnt" style="cursor:pointer" title='조회수로 정렬'>조회수</th>
	                                    </c:if>
	                                </tr>
	                            </thead>
	                            <tbody>
	                               <c:choose>
										<c:when test="${!empty boardList}">
											<c:forEach items="${boardList}" var="result" varStatus="status">
												<c:if test="${sesUserAdminYn eq 'N' }">
												<tr onclick="javascript:fn_link_detail('${result.article_no}'); return false;" data-toggle="modal" data-target="#boardDetail">
													<td>
													 	<c:out value="${view01Cnt.totalRecordCount - (result.rno - 1)}" escapeXml="false" />
													</td>
			                                        <td style='text-align: left'>
			                                        	<c:if test="${'Y' eq result.new_yn}"><span class="ico_new m-l-5"><img src="<c:url value="/resources/img/ico_new.png"/>" alt="새글아이콘" title="새글"></span></c:if>
			                                       		${result.article_title}
			                                        </td>
			                                        <td>
			                                        	${result.ins_user_nm}
			                                        </td>
			                                        <td>
			                                        	${result.ins_dt}
			                                        </td>
			                                        <td id='views_${result.article_no}'>
			                                        	${result.view_cnt}
			                                        </td>
			                                    </tr>
	                            				</c:if>
	                            				<c:if test="${sesUserAdminYn eq 'Y' }">
												<tr onclick="javascript:fn_link_detail('${result.article_no}'); return false;" data-toggle="modal" data-target="#boardDetail">
													<td>
													 	<c:out value="${view01Cnt.totalRecordCount - (result.rno - 1)}" escapeXml="false" />
													</td>
			                                        <td style='text-align: left'>
			                                        	<c:if test="${'Y' eq result.new_yn}"><span class="ico_new m-l-5"><img src="<c:url value="/resources/img/ico_new.png"/>" alt="새글아이콘" title="새글"></span></c:if>
			                                       		${result.article_title}
			                                        </td>
			                                        <td>
			                                        	${result.ins_user_nm}
			                                        </td>
			                                        <td>
			                                        	${result.ins_dt}
			                                        </td>
			                                        <td>
			                                        	${result.pop_start_dt}
			                                        </td>
			                                        <td>
			                                        	${result.pop_end_dt}
			                                        </td>
			                                        <td>
			                                        	${result.use_yn}
			                                        </td>
			                                        <td id='views_${result.article_no}'>
			                                        	${result.view_cnt}
			                                        </td>
			                                    </tr>
			                                    </c:if>
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
                                <div class="text-center">
	                                <ul class="pagination m-t-0 m-b-0">
		                               <ui:pagination paginationInfo = "${view01Cnt}" type="user" jsFunction="fn_link_list" />
		                            </ul>
	                            </div>
                            </div>

							<c:if test="${sesUserAdminYn eq 'Y' }">
                            <!-- Button-Group -->
		                    <div class="" style="border-top: transparent;float:right;">
		                        <!--<button type="button" class="btn btn-danger btn-md" id="fc-del-btn" data-toggle="modal" data-target="#alert-delete-detail">-->
		                        <!--<span><i class="fa fa-times-circle m-r-5"></i>취소</span>
		                        </button>-->
		                        <button type="button" class="btn btn-custom btn-md" id="btnAdd" data-toggle="modal"  data-target="#boardAdd">
		                            <span><i class="fa fa-pencil m-r-5"></i>글쓰기</span>
		                        </button>
		                    </div>
		                    <!--// End Button-Group -->
		                    </c:if>

	                    </div>
	                </div>

	            </div>
	        </div>
	        <!-- End List Page-Body -->
	    </div>
	</div>
	
	<!-- Detail Page-Body -->
    <div class="row" id='boardDetail' style='position: absolute; width: 900px; display: none; z-index:100; margin-top: 50px;' role="dialog">
        <div class="col-sm-12">
            <div class="card-box big-card-box last table-responsive searchResult">
                <h5 class="header-title"><b>공지사항 상세</b></h5>
                <div class="table-wrap m-t-30">
                    <table class="table table-custom table-cen table-num text-center table-hover">
                    	<caption class="none">공지사항 상세 테이블</caption>
                        <colgroup>
                            <col style="width:20%">
                        	<col style="width:30%">
                        	<col style="width:20%">
                        	<col style="width:30%"> 
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
							    <th scope="row">오픈 시작일</th>
							    <td id='pop_start_dt'></td>
							    <th scope="row">오픈 종료일</th>
							    <td id='pop_end_dt'></td>
							</tr>
                         	<tr>
                             	<th scope="row">제목</th>
                             	<td colspan="3" id='article_title'></td>
                     		</tr>
                         	<tr>
	                             <th scope="row">내용</th>
	                             <td colspan="3" class="td-expand" id="article_conts" >
	                             	<div style="overflow-y: scroll; height: 300px; text-align: left; " id="articleScroll">
	                             	</div>
	                             </td>
                   			</tr>
                    	</tbody>
                    </table>
                </div>
                <div>
                	<c:if test="${sesUserAdminYn eq 'Y' }">
                   	<div class="btn-wrap pull-left">
                   		<button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id="articleDelete" type="button" >삭제</button>
                       	<button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id="btnDelete" type="button">미사용</button>
                       	<button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id="btnEdit" type="button">수정</button>
                      	</div>
                      	</c:if>
                      	<div class="btn-wrap pull-right">
                       	<button class="btn btn-custom btn-md pull-right searchBtn" id="btnPopClose" type="button" data-dismiss="modal">닫기</button>
                      	</div>
                </div>
</div>
    	</div>
    </div>
    <!-- End Detail Page-Body -->
	        

	<!-- Add Page-Body -->
    <div class="row" id="boardAdd" style='position: absolute; display: none; z-index:100' role="dialog">
        <div class="col-sm-12">
            <div class="card-box big-card-box last table-responsive searchResult">
                <h5 class="header-title"><b>공지사항 <span id="curr_head_title">등록</span></b></h5>
                <div class="table-wrap m-t-30">
                    <table class="table table-custom table-cen table-num text-center table-hover">
                    	<caption class="none">공지사항 등록 테이블</caption>
                        <colgroup>
                        	<col style="width:20%">
                        	<col style="width:30%">
                            <col style="width:20%">
                        	<col style="width:30%">
                        </colgroup>
                        <tbody>
                           	<tr>
                                  <th scope="row">제목<span class="text-danger">*</span></th>
                                  <td colspan ="3">
                                  <input class="form-control required" name="notice_title" id="notice_title"  type="text" maxlength="200" title="제목" placeholder="제목을 입력해주세요.">
                                  </td>
                              	</tr>
                              	<tr>
                             <th scope="row">
                                 <label for="notice_pop_start_dt" style="font-size: medium;">알림 시작일<span class="text-danger">*</span></label>
                             </th>
                             <td>
                                 <div class="input-group date datetimepickerStart m-b-5">
                                       	<input class="form-control input-group-addon m-b-0" name="notice_pop_start_dt"  id="notice_pop_start_dt" title ="알림  시작일"  placeholder="알림  시작일 선택하세요">
                                       	<span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
                                    </div>
                             </td>
                             <th scope="row">
                                 <label for="notice_pop_end_dt" style="font-size: medium;">알림  종료일<span class="text-danger">*</span></label>
                             </th>
                             <td>
                                 <div class="input-group date datetimepickerEnd m-b-5">
                                       	<input class="form-control input-group-addon m-b-0" name="notice_pop_end_dt" id="notice_pop_end_dt" title ="알림  종료일 "  placeholder="알림  종료일 선택하세요">
                                    	<span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
                                	</div>
                             </td>
                        	</tr>
                              	<tr>
                                <th scope="row">내용<span class="text-danger">*</span></th>
                                <td colspan ="3">
                                	<!-- <textarea name="notice_contents" id="notice_contents" rows="12" cols="60" class="form-control" placeholder="내용을 입력해주세요." title="내용" ></textarea> -->
                                	<div id="notice_contents"></div>
                            	</td>
                             	</tr>
                          	</tbody>
                  		</table>
                </div>
                <div>
                	<c:if test="${sesUserAdminYn eq 'Y' }">
                      	<div class="btn-wrap pull-left">
                     	</div>
                     	</c:if>
                      	<div class="btn-wrap pull-right">
                      		<button class="btn btn-custom btn-md pull-right searchBtn" id="btnRegClose" type="button">닫기</button>
                      		<button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id="btnRegSave" type="button">저장</button>
                      	</div>
                </div>
            </div>
        </div>
    </div>
   	<!-- End Add Page-Body -->
