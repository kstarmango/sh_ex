<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>


	<!-- <style>
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

		$('#re_article_conts').summernote({
			lang: 'ko-KR',
			placeholder: '토지자원관리시스템의 공간정보에 대한 질의•요청 사항을 게시할 수 있습니다.위 내용과 관계없는 질의•요청사항은 관리자에 의해 삭제될 수 있습니다.',
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
			lang: 'ko-KR',
			placeholder: '토지자원관리시스템의 공간정보에 대한 질의•요청 사항을 게시할 수 있습니다.위 내용과 관계없는 질의•요청사항은 관리자에 의해 삭제될 수 있습니다.',
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
				$("#tbQnaDiv").hide();
				var boxStyle = document.getElementById('boardBox');
				boxStyle.style.position = 'relative';
				boxStyle.style.bottom = '70px';
				boxStyle.style.paddingTop = '0px';
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
			$("#boardDetail").hide();
			var boxStyle = document.getElementById('boardBox');
			boxStyle.style.position = 'none';
			boxStyle.style.bottom = '0px';
			boxStyle.style.paddingTop = '0px';
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
	// 2022-10-17  질의·응답 - 삭제 
	   function btnQnaDelete(no) {

			var row =  $('#contents >tbody tr').length;
		
			var qnaGrpNo = [];
			var artilcleNo = [];
		
			var grpNoResult=[];
			var articleResult=[];
	
			var artiNo;
			
			for(var i=0; i<row; i++){
				qnaGrpNo.push(document.getElementsByClassName("grpClass")[i].value); // grpNo 값
				artilcleNo.push(document.getElementsByClassName("articleNoClass")[i].value); // no 값
			}
			
			for(var i=0; i<row; i++){
					if(no == qnaGrpNo[i]){
						grpNoResult.push(qnaGrpNo[i]);
						articleResult.push(artilcleNo[i]);
			

						if(i>=1){
							for(var j=0; j<=row; j++){ // 하위 댓글 로직 추가
								if(articleResult[i] != null){
								if(articleResult[i] == qnaGrpNo[j]){
									articleResult.push(artilcleNo[j]); 
									}
								}
							}
						}
						
					
					}
			}
			
			articleResult.push(no);

			var result = [...new Set(articleResult)]; // 중복제거
	
			
			 console.log("result : ", result);
			
			  if (confirm("정말 삭제하시겠습니까?")){
				  $.ajax({
						type : "POST",
						async : false,
						url : "<%= RequestMappingConstants.WEB_MNG_QNA_DELETE %>",
						traditional: true,
						dataType : "json",
						data : {
							article_no: result,
						},
						error : function(response, status, xhr){
							if(xhr.status =='403'){
								alert('공지사항 삭제 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
							}
						},
						success : function(data) {
							$("#boardDetail").hide();
							fn_link_list(1);
						}
					});
				 }
			
			
			
			
			 
			 
			
		
				
		
		  }  

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
	    $("#boardListForm").attr("action", "<%=RequestMappingConstants.WEB_QNA%>");
	    $("#boardListForm").submit();
	}

	// 페이지 링크
	function fn_link_list(pageNo) {
		$("#boardListForm").append('<input type="hidden" name="pageIndex" id="pageIndex" value="' + pageNo + '"/>');
		$("#boardListForm").append('<input type="hidden" name="boardType" id="boardType" value="${boardType}" />');
		$("#boardListForm").attr("method", "post");
		$("#boardListForm").attr("action", "<%=RequestMappingConstants.WEB_QNA%>");
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
		        	$("#tbQnaDiv").show();
		        	$("#re_article").hide();

		        	// 상세 영역
		        	$('#user_id').text(data.boardInfo.ins_user_id);
		        	$('#user_nm').text(data.boardInfo.ins_user_nm);
		        	$('#ins_dt').text(data.boardInfo.ins_dt);
		        	$('#upd_dt').text(data.boardInfo.upd_dt);
		        	$('#article_title').text(data.boardInfo.article_title);
		        	//$('#article_conts').text(data.boardInfo.article_conts);
		        	$('#article_conts').html(data.boardInfo.article_conts);
		        	$('#qnaDelete').val(id);

		        	if($("#article_no").length == 0)
		        		$("#boardDetail").append('<input type="hidden" name="article_no" id="article_no"/>');
		        	$('#article_no').val(id);

		        	if(data.boardInfo.use_yn == '사용') {
		        		//$('#btnDelete').text('미사용');
		        		//$('#btnEdit').show();
		        		//$('#btnReply').show();

						$('#btnDelete').text('미사용');
						if('${sesUserAdminYn}' == 'Y' || "${sesUserId}" == data.boardInfo.ins_user_id)
							$('#btnEdit').show();
						else
							$('#btnEdit').hide();
		        		$('#btnReply').show();
		        	} else {
		        		$('#btnDelete').text('사용');
		        		$('#btnEdit').hide();
		        		$('#btnReply').hide();
		        	}

		        	$("#boardDetail").center();
		        	$("#boardDetail").show();

					$.ajax({
						type : "POST",
						async : false,
						url : "<%= RequestMappingConstants.WEB_MNG_QNA_VIEW_CNT %>",
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

	<%-- <c:import url="<%= RequestMappingConstants.WEB_MAIN_HEADER %>"></c:import> --%>
	<!-- 좌측메뉴 -->
	<%-- <c:import url="<%= RequestMappingConstants.WEB_BOARD_LEFT %>"></c:import> --%>

	<!-- <div class="wrapper"> -->
	<div class="contWrap">
		<h1>${sesMenuNavigation.progrm_nm}</h1>
		<div class="whiteCont" style="height: calc( 100% - 22px);">
        	<p class="pageNav">
                <a href="<%=RequestMappingConstants.WEB_MAIN%>">HOME</a> &nbsp;&nbsp; |  &nbsp;&nbsp;  <a href="<%=RequestMappingConstants.WEB_MNG_USER%>">게시판<%-- ${sesMenuNavigation.p_progrm_nm} --%></a>  &nbsp;&nbsp;  |  &nbsp;&nbsp;  	${sesMenuNavigation.progrm_nm}
            </p>

	        <!-- Page-Title -->
	        <%-- <div class="row">
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
	        </div> --%>
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
	                                     <label class="col-md-1 control-label" style="font-size: medium;">검색항목</label>
	                                     <div class="col-md-2">
	                                         <select class="form-control" name="s_serch_gb" title ="검색항목">
	                                         	<option value="">선택</option>
												<option value="article_title">제목</option>
												<option value="article_conts">내용</option>
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
	                        	<caption class="none">질의요청 목록 테이블</caption>
	                            <colgroup>
	                            	<c:if test="${sesUserAdminYn eq 'N' }">
	                                <col style="width:5%">
	                                <col style="width:55%">
	                                <col style="width:18%">
	                                <col style="width:15%">
	                                <col style="width:7%">
	                            	</c:if>
	                            	<c:if test="${sesUserAdminYn eq 'Y' }">
	                            	<col style="width:5%">
	                                <col style="width:55%">
	                                <col style="width:10%">
	                                <col style="width:15%">
	                                <col style="width:8%">
	                                <col style="width:7%">
	                                </c:if>
	                            </colgroup>
	                            <thead>
		                            <tr>
		                            	<c:if test="${sesUserAdminYn eq 'N' }">
	                                	<th data-sort="int"   >순번</th>
	                                    <th data-sort="string">제목</th>
	                                    <th data-sort="string">작성자</th>
	                                    <th data-sort="string">등록일시</th>
	                                    <th data-sort="string">조회수</th>
		                            	</c:if>
		                            	<c:if test="${sesUserAdminYn eq 'Y' }">
	                                	<th data-sort="int"   >순번</th>
	                                    <th data-sort="string">제목</th>
	                                    <th data-sort="string">작성자</th>
	                                    <th data-sort="string">등록일시</th>
	                                    <th data-sort="string">사용여부</th>
	                                    <th data-sort="string">조회수</th>
	                                    </c:if>
	                                </tr>
	                            </thead>
	                            <tbody>
	                               <c:choose>
										<c:when test="${!empty boardList}">
											<c:forEach items="${boardList}" var="result" varStatus="status">
												<c:if test="${sesUserAdminYn eq 'N' }">
												<tr onclick="javascript:fn_link_detail('${result.article_no}'); return false;" data-toggle="modal"  data-target="#boardDetail">
													<td>
													 	<c:out value="${view01Cnt.totalRecordCount - (result.rno - 1)}" escapeXml="false" />
													 	<input type="hidden" class="articleNoClass" name="articleNo${result.article_no}" value="${result.article_no}">
														<input type="hidden" class="grpClass" id="answerGrp${result.article_no}" name="answerGrp${result.article_no}" value="${result.answer_grp}">
														<input type="hidden" class="levClass" id="answerLev${result.article_no}" name="answerLev${result.article_no}" value="${result.answer_lev}">
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
			                                        <td id='views_${result.article_no}'>
			                                        	${result.view_cnt}
			                                        </td>
			                                    </tr>
			                                    </c:if>
			                                    <c:if test="${sesUserAdminYn eq 'Y' }">
												<tr onclick="javascript:fn_link_detail('${result.article_no}'); return false;" data-toggle="modal"  data-target="#boardDetail">
													<td>
														<input type="hidden" class="articleNoClass"  name="articleNo${result.article_no}" value="${result.article_no}">
														<input type="hidden" class="grpClass" id="answerGrp${result.article_no}" name="answerGrp${result.article_no}" value="${result.answer_grp}">
														<input type="hidden"  class="levClass" id="answerLev${result.article_no}" name="answerLev${result.article_no}" value="${result.answer_lev}">
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
	                                <ul class="pagination">
		                               <ui:pagination paginationInfo = "${view01Cnt}" type="user" jsFunction="fn_link_list" />
		                            </ul>
	                            </div>
                            </div>

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
	                    </div>
	                </div>

	            </div>
	        </div> 
	        <!-- End List Page-Body -->
	    </div>
	</div>
	
	<!-- Detail Page-Body --> 
    <div class="row" id='boardDetail' style='position: absolute; width: 900px; display: none; z-index:100; ' role="dialog">
        <div class="col-sm-12" id='boardBox'>
            <div class="card-box big-card-box last table-responsive searchResult">
                <h5 class="header-title"><b>질의•요청 상세</b></h5>
                <div class="table-wrap m-t-30" id="tbQnaDiv">
                    <table class="table table-custom table-cen table-num text-center table-hover">
                    	<caption class="none">질의요청 상세 테이블</caption>
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
	                             <th scope="row">제목</th>
	                             <td colspan="3" id='article_title'></td>
	                     	</tr>
	                         <tr>
	                             <th scope="row">내용</th>
	                             <td colspan="3" class="td-expand"  id="article_conts" style="text-align: left;">
	                             	<!-- <textarea name="article_conts" id="article_conts" rows="10" cols="70" class="form-control" placeholder="내용을 입력해주세요." title="내용" readonly></textarea> -->
	                             </td>
	                     	</tr>
                    	</tbody>
                    </table>
                </div>
                <div id='re_article' class="table-wrap m-t-30" style='display: none;' role="dialog">
                    <table class="table table-custom table-cen table-num text-center table-hover">
                    	<caption class="none">질의요청 답변 테이블</caption>
                        <colgroup>
                        	<col style="width:20%">
                        	<col style="width:30%">
                        	<%-- <col style="width:20%">
                        	<col style="width:30%"> --%>
                        </colgroup>
                        <tbody>
                           	<tr>
                                  <th scope="row">답변 제목<span class="text-danger">*</span></th>
                                  <td>
                                  <input class="form-control required" name="re_article_title" id="re_article_title"  type="text" maxlength="20" title="제목" placeholder="말머리에 [질의] or [요청] 을 구분해주세요. ">
                                  </td>
                           	</tr>
                           	<tr>
                                <th scope="row">답변 내용<span class="text-danger">*</span></th>
                                <td>
                                	<!-- <textarea name="re_article_conts" id="re_article_conts" rows="12" cols="60" class="form-control" placeholder="내용을 입력해주세요." title="내용" ></textarea> -->
                                	<div id="re_article_conts"></div>
                            	</td>
                           	</tr>
                       	</tbody>
               		</table>
                </div>
                <div>
                   	<div class="btn-wrap pull-left">
                   		
                   		<button class="btn btn-custom btn-md pull-right searchBtn" id="btnReply" type="button">답글쓰기</button>
                   		<c:if test="${sesUserAdminYn eq 'Y' }">
                   		<button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" value=""  onclick="btnQnaDelete(this.value);" id="qnaDelete" type="button">삭제</button>
                       	<button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id="btnDelete" type="button">미사용</button>
                       	</c:if>
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
    <div class="row" id="boardAdd" style='position: absolute; display: none; z-index:100' role="dialog">
        <div class="col-sm-12">
            <div class="card-box big-card-box last table-responsive searchResult" style = "width: 1000px; height: 570px;">
                <h5 class="header-title"><b>질의•요청 <span id="curr_head_title">등록</span></b></h5>
                <div class="table-wrap m-t-30">
                    <table class="table table-custom table-cen table-num text-center table-hover">
                    	<caption class="none">질의요청 등록 테이블</caption>
                        <colgroup>
                        	<col style="width:20%">
                        	<col style="width:30%">
                        	<%-- <col style="width:20%">
                        	<col style="width:30%"> --%>
                        </colgroup>
                        <tbody>
                           	<tr>
                                  <th scope="row">제목<span class="text-danger">*</span></th>
                                  <td>
                                  <input class="form-control required" name="qna_title" id="qna_title"  type="text" maxlength="200" title="제목" placeholder="말머리에 [질의] or [요청]을 구분해주세요. ">
                                  </td>
                              	</tr>
                              	<tr>
                                <th scope="row">내용<span class="text-danger">*</span></th>
                                <td>
                                	<!-- <textarea name="qna_contents" id="qna_contents" rows="12" cols="60" class="form-control" placeholder="내용을 입력해주세요." title="내용" ></textarea> -->
                                	<div id="qna_contents"></div>
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

	<%-- <c:import url="<%= RequestMappingConstants.WEB_MAIN_FOOTER %>"></c:import> --%>


