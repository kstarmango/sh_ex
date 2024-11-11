<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

	<script>

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
            
			$("#apikeyListForm").append('<input type="hidden" name="pageIndex" id="pageIndex" value="' + pageIndex + '" />');
			$("#apikeyListForm").append('<input type="hidden" name="pageSort"  id="pageSort"  value="' + pageSort  + '" />');
			$("#apikeyListForm").append('<input type="hidden" name="pageOrder" id="pageOrder" value="' + pageOrder + '" />');
		    $("#apikeyListForm").attr("method", "post");
		    $("#apikeyListForm").attr("action", "<%=RequestMappingConstants.WEB_MNG_APIKEY%>");
		    $("#apikeyListForm").submit();
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
		
		// APIKEY 상세 - 초기화
    	$('#confm_yn').val('');
    	$('#use_yn').val('');
    	$('#lock_yn').val('');
    	
		// APIKEY 상세 - 변경 상태 저장 - 셀렉트박스 변경시
		$("select[name=confm_yn], select[name=use_yn], select[name=lock_yn], select[name=p_auth_no], select[name=l_auth_no]").change( function() {
			var sendUrl;
			var sendData;
			
			if($(this).attr('name') == 'confm_yn') {
				sendUrl = "<%= RequestMappingConstants.WEB_MNG_USER_CONFM %>";
				sendData =  {
					id: $('#user_id').val(),
					confm_yn: $(this).val()
				};
			} else if($(this).attr('name') == 'use_yn') {
				sendUrl = "<%= RequestMappingConstants.WEB_MNG_USER_USE %>";
				sendData =  {
					id: $('#user_id').val(),
					use_yn: $(this).val()
				};
			} else if($(this).attr('name') == 'lock_yn') {
				sendUrl = "<%= RequestMappingConstants.WEB_MNG_USER_LOCK %>";
				sendData =  {
					id: $('#user_id').val(),
					lock_yn: $(this).val()
				};
			} else if($(this).attr('name') == 'p_auth_no') {
				sendUrl = "<%= RequestMappingConstants.WEB_MNG_USER_PAUTH %>";
				sendData =  {
					id: $('#user_id').val(),
					p_auth_no: $(this).val()
				};
			} else if($(this).attr('name') == 'l_auth_no') {
				sendUrl = "<%= RequestMappingConstants.WEB_MNG_USER_LAUTH %>";
				sendData =  {
					id: $('#user_id').val(),
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
						alert('정보 변경 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
					}
				},
				success : function(data) {
			        if(data.result == "Y" && data.userInfo == "1") {
			        	fn_link_list(pageIndex);
			        	$('#apikeyDetail').hide();
			        	alert('정보 변경이 정상적으로 완료 되었습니다.');
			        }				
				}
			});			
			
		});

		// APIKEY 변경
		var editMode = false;
		$('#btnPopSave').click(function(e) {
			if(editMode == false) { 
        		$('#sys_nm').attr('disabled', false);
        		$('#site_url').attr('disabled', false);
        		$('#sys_desc').attr('disabled', false);
        		$('#use_purps').attr('disabled', false);
        		$('#devlop_server1').attr('disabled', false);
        		$('#use_last_dt1').attr('disabled', false);
        		$('#devlop_server2').attr('disabled', false);
        		$('#use_last_dt2').attr('disabled', false);
        		
        		$('#btnPopSave').text('적용');
        		editMode = true;
        		
        		return;
			}
			else
			{
        		$.ajax({
					type : "POST",
					async : false,
					url : "<%= RequestMappingConstants.WEB_MNG_APIKEY_EDIT %>",
					dataType : "json",
					data : {
						id: $('#user_id').val(),
						sys_nm: $('#sys_nm').val(),
						site_url: $('#site_url').val(),
						sys_desc: $('#sys_desc').val(),
						use_purps: $('#use_purps').val(),
						devlop_server1: $('#devlop_server1').val(),
						use_last_dt1: $('#use_last_dt1').val(),
						devlop_server2: $('#devlop_server2').val(),
						use_last_dt2: $('#use_last_dt2').val()
					},	
					error : function(response, status, xhr){
						if(xhr.status =='403'){
							alert('정보 변경 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
						}
					},
					success : function(data) {
				        if(data.result == "Y" && data.apikeyInfo == "1") {
				        	$('#btnPopClose').trigger("click");	
				        	alert('정보 변경이 정상적으로 완료 되었습니다.');
				        }				
					}
				});	
			}
			
		});
		
		// APIKEY 상세 - 닫기
		$('#btnPopClose').click(function(e) {
			$('#sys_nm').attr('disabled', true);
    		$('#site_url').attr('disabled', true);
    		$('#sys_desc').attr('disabled', true);
    		$('#use_purps').attr('disabled', true);
    		$('#devlop_server1').attr('disabled', true);
    		$('#use_last_dt1').attr('disabled', true);
    		$('#devlop_server2').attr('disabled', true);
    		$('#use_last_dt2').attr('disabled', true);
    		
    		$('#btnPopSave').text('변경');
    		editMode = false;
    		
    		$("#apikeyChangeForm")[0].reset();
    		
			$('#apikeyDetail').hide();
		});
				
		// 신규발급 - 팝업
		$('#btnAdd').click(function(){
			$("#apikeyAdd").show();
			$("#apikeyAdd").center();
		});
		
		// 신규발급 - 저장
		$('#btnRegSave').click(function(e) {
			$.ajax({
				type : "POST",
				async : false,
				url : "<%= RequestMappingConstants.WEB_MNG_APIKEY_ADD %>",
				dataType : "json",
				data : {
					dept_nm: $('#new_dept_nm').val(),
					user_nm: $('#new_user_nm').val(),
					telno: $('#new_telno').val(),
					email: $('#new_email').val(),
					sys_nm: $('#new_sys_nm').val(),
					site_url: $('#new_site_url').val(),
					sys_desc: $('#new_sys_desc').val(),
					use_purps: $('#new_use_purps').val(),
					devlop_server1: $('#new_devlop_server1').val(),
					use_last_dt1: $('#new_use_last_dt1').val(),
					devlop_server2: $('#new_devlop_server2').val(),
					use_last_dt2: $('#new_use_last_dt2').val(),
					p_auth_no:$('#new_p_auth_no').val(),
					l_auth_no:$('#new_l_auth_no').val()
				},	
				error : function(response, status, xhr){
					if(xhr.status =='403'){
						alert('신규발급 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
					}
				},
				success : function(data) {
			        if(data.result == "Y") {
			        	$('#apikeyAdd').modal('hide'); 
			        	$("#apikeyAdd").hide();
			        	fn_link_list(1);
			        }				
				}
			});
			
		});
		
		// 신규발급 - 닫기
		$('#btnRegClose').click(function(e) {
			$('#apikeyAdd').hide();
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
		var pageData = {
				"pageIndex" : 1
				,"pageSort" : "${pageSort}"
				,"pageOrder" : "${pageOrder}"
				,"tile" : "tile"
		}
		<%-- changeContents("<%=RequestMappingConstants.WEB_MNG_APIKEY%>",pageData); --%>
		$("#apikeyListForm").append('<input type="hidden" name="pageIndex" id="pageIndex" value="1" />');
		$("#apikeyListForm").append('<input type="hidden" name="pageSort"  id="pageSort"  value="${pageSort}" />');
		$("#apikeyListForm").append('<input type="hidden" name="pageOrder" id="pageOrder" value="${pageOrder}" />');
	    $("#apikeyListForm").attr("method", "post");
	    $("#apikeyListForm").attr("action", "<%=RequestMappingConstants.WEB_MNG_APIKEY%>");
	    $("#apikeyListForm").submit();
	}
	
	// 페이지 링크
	function fn_link_list(pageNo) {
		var pageData = {
				"pageIndex" : pageNo
				,"pageSort" : "${pageSort}"
				,"pageOrder" : "${pageOrder}"
				,"tile" : "tile"
		}
		changeContents("<%=RequestMappingConstants.WEB_MNG_APIKEY%>",pageData);
	}
	
	// 상세페이지 이동
	function fn_link_detail(id) {
		// 기본정보
		$.ajax({
			type : "POST",
			async : false,
			url : "<%= RequestMappingConstants.WEB_MNG_USER_DETAIL %>",
			dataType : "json",
			data : {id: id},	
			error : function(response, status, xhr){
				if(xhr.status =='403'){
					$("#apikeyDetail").hide();
					alert('사용자 상세 데이터 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
				}
			},
			success : function(data) {
		        if(data.result == "Y") {
		        	$('#user_id').val(data.userInfo.user_id);
		        	$('#user_nm').text(data.userInfo.user_nm);
		        	$('#dept_nm').text(data.userInfo.dept_nm);
		        	$('#telno').text(data.userInfo.telno);
		        	$('#email').text(data.userInfo.email);
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
		        }				
			}
		});
		
		// 상세정보
		$.ajax({
			type : "POST",
			async : false,
			url : "<%= RequestMappingConstants.WEB_MNG_APIKEY_DETAIL %>",
			dataType : "json",
			data : {id: id},	
			error : function(response, status, xhr){
				if(xhr.status =='403'){
					$("#apikeyDetail").hide();
					alert('ApiKey 상세 데이터 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
				}
			},
			success : function(data) {
		        if(data.result == "Y") {
		        	$('#confm_key').text(data.apikeyInfo.confm_key);		        	
		        	$('#sys_nm').val(data.apikeyInfo.sys_nm);
		        	$('#site_url').val(data.apikeyInfo.site_url);
		        	$('#sys_desc').val(data.apikeyInfo.sys_desc);
		        	$('#use_purps').val(data.apikeyInfo.use_purps);
		        	$('#devlop_server1').val(data.apikeyInfo.devlop_server1);
		        	$('#use_last_dt1').val(data.apikeyInfo.use_last_dt1);
		        	$('#devlop_server2').val(data.apikeyInfo.devlop_server2);
		        	$('#use_last_dt2').val(data.apikeyInfo.use_last_dt2);
		        	$('#api_ins_dt').text(data.apikeyInfo.ins_dt);
		        	$('#api_upd_dt').text(data.apikeyInfo.upd_dt);
		        	
		        	$("#apikeyDetail").center();
		        	$("#apikeyDetail").show();
		        }				
			}
		});		
	}

	</script>
	<div class="contWrap">
        <h1>${sesMenuNavigation.progrm_nm}</h1>
        <div class="whiteCont">
        	<p class="pageNav">
                <a href="<%=RequestMappingConstants.WEB_MAIN%>">HOME</a> &nbsp;&nbsp; |  &nbsp;&nbsp;  <a href="<%=RequestMappingConstants.WEB_MNG_USER%>">${sesMenuNavigation.p_progrm_nm}</a>  &nbsp;&nbsp;  |  &nbsp;&nbsp;  	${sesMenuNavigation.progrm_nm}
            </p> 
            <!-- List Page-Body -->
	        <div class="row" id='apikeyList' style='display: block;'>
				<div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
						<div class="form-group">
                        <form id="apikeyListForm" name="apikeyListForm" class="form-horizontal">
	                        <h5 class="header-title m-t-0 m-b-30"><b>검색 조건</b></h5>
						    <div class="row">
	                           	<div class="col-md-10">
	                                 <div class="form-group">
	                                 	<label class="col-md-1 control-label">등록일자</label>
	                                     <div class="col-md-2">
	                                         <div class="input-group date datetimepickerStart m-b-5">
	                                         	<input  class="form-control input-group-addon m-b-0" style='font-size: 11px;' name="s_serch_start_dt"  title ="등록일자"  placeholder="등록일 선택">
	                                             <span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
	                                         </div>
	                                     </div>
	                                     <label class="col-md-1 control-label">승인여부</label>
	                                     <div class="col-md-2">
	                                         <select class="form-control" name="s_serch_confm_yn" title ="승인여부">
	                                         	<option value="">전체</option>
												<option value="Y">승인</option>
												<option value="N">미승인</option>
	                                         </select>
	                                     </div>
	                                     <label class="col-md-1 control-label">사용유무</label>
	                                     <div class="col-md-2">
	                                         <select class="form-control" name="s_serch_use_yn" title ="사용유무">
	                                         	<option value="">전체</option>
												<option value="Y">사용</option>
												<option value="N">미사용</option>
	                                         </select>
	                                     </div>		                                     
	                                     <label class="col-md-1 control-label">잠김여부</label>
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
	                                     <label class="col-md-1 control-label">검색항목</label>
	                                     <div class="col-md-2">
	                                         <select class="form-control" name="s_serch_gb" title ="검색항목">
	                                         	<option value="">선택</option>
												<option value="user_nm">사용자명</option>
												<option value="dept_nm">부서</option>
	                                         </select>
	                                     </div>
	                                     <label for="s_serch_nm" class="sr-only">검색어</label>
	                                     <div class="col-md-9">
	                                         <input  class="form-control" title ="검색어" id="s_serch_nm" name="s_serch_nm" placeholder="검색어를 입력하세요">
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
	                        <table class="table table-custom table-cen table-num text-center table-hover" id='contents' >
	                        	<caption class="none">API KEY 목록 테이블</caption>
	                            <colgroup>
	                                <col style="width:5%">
                        			<col style="width:15%">
                        			<col style="width:15%">
                        			<col style="width:15%">
                  			        <col style="width:15%">
                        			<col style="width:15%">
                        			<col style="width:20%">
	                            </colgroup>
	                            <thead>
		                            <tr>
	                                	<th data-sort="int"    data-sort-col=""       >순번</th>
	                                    <th data-sort="string" data-sort-col="sys_nm"  style="cursor:pointer" title='시스템명로 정렬'>시스템명</th>
	                                    <th data-sort="string" data-sort-col="dept_nm" style="cursor:pointer" title='사용자 부서명 정렬'>부서명</th>
	                                    <th data-sort="string" data-sort-col="user_nm" style="cursor:pointer" title='사용자 이름으로 정렬'>이름</th>
	                                    <th data-sort="string" data-sort-col="telno"   style="cursor:pointer" title='사용자 전화번호로 정렬'>전화번호</th>
	                                    <th data-sort="string" data-sort-col="ins_dt"  style="cursor:pointer" title='사용자 등록일시로 정렬'>등록일시</th>
	                                    <th data-sort="string" data-sort-col=""  	  >회원상태</th>
	                                </tr>
	                            </thead>
	                            <tbody>
	                               <c:choose>
										<c:when test="${!empty apiKeyList}">
											<c:forEach items="${apiKeyList}" var="result" varStatus="status">
												<tr onclick="javascript:fn_link_detail('${result.user_id}'); return false;" data-toggle="modal"  data-target="#apikeyDetail">
													<td>
													 	${view01Cnt.totalRecordCount - (result.rno - 1)}
													</td>													
			                                        <td>
			                                       		${result.mask_sys_nm}
			                                        </td>
			                                        <td>
			                                        	${result.mask_dept_nm}
			                                        </td>
			                                        <td>
			                                        	${result.mask_user_nm}
			                                        </td>
			                                        <td>
			                                        	${result.mask_telno}
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
                            
                            <!-- Button-Group -->
		                    <div class="modal-footer">
		                        <!--<button type="button" class="btn btn-danger btn-md" id="fc-del-btn" data-toggle="modal" data-target="#alert-delete-detail">-->
		                        <!--<span><i class="fa fa-times-circle m-r-5"></i>취소</span>
		                        </button>-->
		                        <button type="button" class="btn btn-custom btn-md" id="btnAdd" data-toggle="modal"  data-target="#apikeyAdd">
		                            <span><i class="fa fa-pencil m-r-5"></i>신규 발급</span>
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
    <div class="row" id='apikeyDetail' style='position: absolute; display: none; z-index:100' role="dialog">
	    <div class="col-sm-12">
	        <div class="card-box big-card-box last table-responsive searchResult">
	        	<h5 class="header-title"><b>APIKEY 발급 상세</b></h5>
                <div class="table-wrap m-t-30">
               		<input type='hidden' id='user_id' name='user_id'>
	                	<table class="table table-custom table-cen table-num text-center table-hover" >
	                		<caption class="none">API KEY 발급 상세 테이블</caption>
                       		<colgroup>
                           		<col style="width:20%">
                       			<col style="width:30%">
                       			<col style="width:20%">
                       			<col style="width:30%">
                       		</colgroup>
                           	<tbody>
								<tr>
									<th scope="row">이름</th>
									<td id='user_nm'></td>
									<th scope="row">부서명</th>
								    <td id='dept_nm'></td>
								</tr>
								<tr>
								    <th scope="row">전화번호</th>
								    <td id='telno'></td>
								    <th scope="row">이메일</th>
								    <td id='email'></td>									    
								</tr>
								<tr>
								    <th scope="row">등록일</th>
								    <td id='ins_dt'></td>
								    <th scope="row">수정일</th>
								    <td id='upd_dt'></td>
								</tr>
								<tr>
								  	<th scope="row">승인여부</th>
								  	<td colspan="3">
								      	<select name="confm_yn" id="confm_yn" class="form-control col-md-3 input-sm" title="승인여부">
								      		<!-- <option value=""></option> --> 
								        	<option value='Y'>승인</option>
								        	<option value='N'>미승인</option>
								    	</select>									  	
								 	</td>
							 	</tr>
							 	<tr>	
								  	<th scope="row">탈퇴여부</th>
								  	<td>
										<select name="use_yn" id="use_yn" class="form-control col-md-3 input-sm" title="탈퇴여부">
											<!-- <option value=""></option> -->
								        	<option value='Y'>사용</option>
								        	<option value='N'>미사용</option>
								    	</select>		
								    </td>
									<th scope="row">잠김여부</th>
									<td>									    								  	
								      	<select name="lock_yn" id="lock_yn" class="form-control col-md-3 input-sm" title="잠김여부">
								      		<!-- <option value=""></option> -->
											<option value='Y'>잠김</option>
											<option value='N'>접속가능</option>
								    	</select>
								 	</td>		 
								</tr>
	                            <tr>
	                                <th scope="row">프로그램 권한</th>	
	                                <td>
										<select name="p_auth_no" id="p_auth_no" class="form-control col-md-3 input-sm" title="프로그램 권한">
											<!-- <option value=""></option> -->
											<c:forEach var="item1" items="${progrmAuthList}">
											<option value="${item1.p_auth_no}">${item1.auth_desc}</option>
											</c:forEach>
								    	</select>		                                
	                                
	                                </td>
	                                <th scope="row">지도레이어 권한</th>	
	                                <td>
										<select name="l_auth_no" id="l_auth_no" class="form-control col-md-3 input-sm" title="지도레이어 권한">
											<!-- <option value=""></option> -->
											<c:forEach var="item2" items="${layerAuthList}">
											<option value="${item2.l_auth_no}">${item2.auth_desc}</option>
											</c:forEach>
								    	</select>		                                
	                                </td>
	                        	</tr>		                        	
                        	</tbody>
                        </table>
                      	<form class="clearfix" id="apikeyChangeForm" name="MyPwdChangeForm" onSubmit="return false;">
	                        <table class="table table-custom table-cen table-num text-center table-hover" >
	                        	<caption class="none">API KEY 발급 상세 테이블</caption>
	                            <colgroup>
	                                <col style="width:20%">
                        			<col style="width:30%">
                        			<col style="width:20%">
                        			<col style="width:30%">
	                            </colgroup>
	                            <tbody>
									<tr>
									  	<th scope="row">승인키</th>
									  	<td colspan="3" id='confm_key' style='text-align:left; height:55px;'></td>
									</tr>	                            
									<tr>
									  	<th scope="row">시스템명</th>
									  	<td colspan="3">
									  		<input class="form-control required" name="sys_nm" id="sys_nm"  type="text" maxlength="64" title="시스템명" placeholder="시스템명 입력" disabled>
									 	</td>
									</tr>
									<tr>
									  	<th scope="row">사이트주소</th>
									  	<td colspan="3">
									  		<input class="form-control required" name="site_url" id="site_url"  type="text" maxlength="256" title="사이트주소" placeholder="사이트주소 입력" disabled>
									 	</td>
									</tr>
									<tr>
									  	<th scope="row">시스템설명</th>
									  	<td colspan="3">
									  		<textarea name="sys_desc" id='sys_desc' cols="100" rows="3" style="resize: none;" disabled title="시스템설명"></textarea>
									 	</td>
									</tr>
									<tr>
									  	<th scope="row">사용목적</th>
									  	<td colspan="3" >
									  		<textarea name="use_purps" id='use_purps' cols="100" rows="3" style="resize: none;" disabled title="사용목적"></textarea>
									 	</td>
									</tr>					
									<tr>
									    <th scope="row">개발서버1</th>
									    <td>
									    	<input class="form-control required" name="devlop_server1" id="devlop_server1"  type="text" maxlength="64" title="개발서버1" placeholder="개발서버1 주소를 입력" disabled>
									    </td>
									    <th scope="row">종료일</th>
									    <td>
	                                        <div class="input-group date datetimepickerStart m-b-5">
	                                        	<input  class="form-control input-group-addon m-b-0" style='font-size: 14px;' name="use_last_dt1" id="use_last_dt1" title ="종료일"  placeholder="종료일 선택">
	                                            <span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
	                                        </div>									    	
									    </td>
									</tr>		
									<tr>
									    <th scope="row">개발서버2</th>
									    <td>
									    	<input class="form-control required" name="devlop_server2" id="devlop_server2"  type="text" maxlength="64" title="개발서버2" placeholder="개발서버2 주소를 입력" disabled>
									    </td>
									    <th scope="row">종료일</th>
									    <td>
	                                        <div class="input-group date datetimepickerStart m-b-5">
	                                        	<input  class="form-control input-group-addon m-b-0" style='font-size: 14px;' name="use_last_dt2" id="use_last_dt2" title ="종료일"  placeholder="종료일 선택">
	                                            <span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
	                                        </div>										    	
									    </td>
									</tr>	
									<tr>
									    <th scope="row">등록일시</th>
									    <td id='api_ins_dt'  style='height:55px;'></td>
									    <th scope="row">수정일시</th>
									    <td id='api_upd_dt'  style='height:55px;'></td>
									</tr>
								</tbody>
							</table>
							</form>
										                        
	                    </div>
	                    <div class="clearfix"></div>
	                    <!-- <div class="modal-footer"> -->
	                    <div>
	                       <div class="btn-wrap pull-left">
	                       		<button class="btn btn btn-info"  id="btnPopSave"  type="button">변경</button>
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
	        <div class="row" id="apikeyAdd" style='position: absolute; display: none; z-index:100' role="dialog">
	            <div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
	                    <h5 class="header-title"><b>APIKEY 신규 발급</b></h5>
	                    <div class="table-wrap m-t-30">
	                        <table class="table table-custom table-cen table-num text-center table-hover" >
	                        	<caption class="none">API KEY 신규 발급 테이블</caption>
	                            <colgroup>
	                            	<col style="width:20%">
                        			<col style="width:30%">
                        			<col style="width:20%">
                        			<col style="width:30%">
	                            </colgroup>
	                            <tbody>
									<tr>
									  	<th scope="row">부서명<span class="text-danger">*</span></th>
									  	<td>
									  		<input class="form-control required" name="new_dept_nm" id="new_dept_nm"  type="text" maxlength="100" title="부서명" placeholder="부서명 입력">
									 	</td>
									  	<th scope="row">담당자<span class="text-danger">*</span></th>
									  	<td>
									  		<input class="form-control required" name="new_user_nm" id="new_user_nm"  type="text" maxlength="64" title="이름" placeholder="이름 입력">
									 	</td>									
									</tr>
									<tr>
									  	<th scope="row">전화번호</th>
									  	<td>
									  		<input class="form-control required" name="new_telno" id="new_telno"  type="text" maxlength="50" title="전화번호" placeholder="전화번호 입력">
									 	</td>									
									  	<th scope="row">이메일</th>
									  	<td>
									  		<input class="form-control required" name="new_email" id="new_email"  type="text" maxlength="128" title="이메일" placeholder="이메일 입력">
									 	</td>
									</tr>									
                                	<tr>
                                       <th scope="row">시스템명<span class="text-danger">*</span></th>
                                       <td colspan="3">
                                       <input class="form-control required" name="new_sys_nm" id="new_sys_nm"  type="text" maxlength="100" title="시스템명" placeholder="시스템명을 입력해주세요.">                                            
                                       </td>
                                   	</tr>
                                	<tr>
                                       <th scope="row">사이트주소<span class="text-danger">*</span></th>
                                       <td colspan="3">
                                       <input class="form-control required" name="new_site_url" id="new_site_url"  type="text" maxlength="512" title="사이트주소" placeholder="사이트주소를 입력해주세요.">                                            
                                       </td>
                                   	</tr>                                     	                                       
                                   	<tr>
	                                    <th scope="row">시스템 설명</th>
	                                    <td colspan="3">                 
	                                    	<textarea name="new_sys_desc" id="new_sys_desc" rows="3" cols="50" class="form-control" style="resize: none;" title="시스템 설명" placeholder="시스템 설명을 입력해주세요."></textarea>
	                                	</td>
                                  	</tr>
                                   	<tr>
	                                    <th scope="row">사용 목적</th>
	                                    <td colspan="3">                 
	                                    	<textarea name="new_use_purps" id="new_use_purps" rows="3" cols="50" class="form-control"  style="resize: none;" title="사용 목적" placeholder="사용 목적을 입력해주세요." ></textarea>
	                                	</td>
                                  	</tr>
									<tr>
									    <th scope="row">개발서버1<span class="text-danger">*</span></th>
									    <td>
									    	<input class="form-control required" name="new_devlop_server1" id="new_devlop_server1"  type="text" maxlength="64" title="개발서버1" placeholder="개발서버1 주소를 입력">
									    </td>
									    <th scope="row">종료일<span class="text-danger">*</span></th>
									    <td>
	                                        <div class="input-group date datetimepickerStart m-b-5">
	                                        	<input  class="form-control input-group-addon m-b-0" style='font-size: 14px;' name="new_use_last_dt1" id="new_use_last_dt1" title ="종료일"  placeholder="종료일 선택">
	                                            <span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
	                                        </div>									    	
									    </td>
									</tr>		
									<tr>
									    <th scope="row">개발서버2</th>
									    <td>
									    	<input class="form-control required" name="new_devlop_server2" id="new_devlop_server2"  type="text" maxlength="64" title="개발서버2" placeholder="개발서버2 주소를 입력">
									    </td>
									    <th scope="row">종료일</th>
									    <td>
	                                        <div class="input-group date datetimepickerStart m-b-5">
	                                        	<input  class="form-control input-group-addon m-b-0" style='font-size: 14px;' name="new_use_last_dt2" id="new_use_last_dt2" title ="종료일"  placeholder="종료일 선택">
	                                            <span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
	                                        </div>										    	
									    </td>
									</tr>
		                            <tr>
		                                <th scope="row">프로그램 권한</th>	
		                                <td>
											<select name="new_p_auth_no" id="new_p_auth_no" class="form-control col-md-3 input-sm" title ="프로그램 권한">
												<!-- <option value=""></option> -->
												<c:forEach var="item1" items="${progrmAuthList}">
												<option value="${item1.p_auth_no}" ${item1.bass_yn eq 'Y' ? 'selected' : ''}>${item1.auth_desc}</option>
												</c:forEach>
									    	</select>		                                
		                                
		                                </td>
		                                <th scope="row">지도레이어 권한</th>	
		                                <td>
											<select name="new_l_auth_no" id="new_l_auth_no" class="form-control col-md-3 input-sm" title ="지도레이어 권한">
												<!-- <option value=""></option> -->
												<c:forEach var="item2" items="${layerAuthList}">
												<option value="${item2.l_auth_no}" ${item2.bass_yn eq 'Y' ? 'selected' : ''}>${item2.auth_desc}</option>
												</c:forEach>
									    	</select>		                                
		                                </td>
		                        	</tr>										
                               	</tbody>
                       		</table>
	                    </div>
	                    <div>
                           	<div class="btn-wrap pull-left">
                           		<button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id="btnRegSave" type="button">저장</button>
                          	</div>
                           	<div class="btn-wrap pull-right">
                               <button class="btn btn-custom btn-md pull-right searchBtn" id="btnRegClose" type="button" data-dismiss="modal">닫기</button>
                           	</div> 
	                    </div>
	                </div>
	            </div>
	        </div>
	       	<!-- End Add Page-Body -->	  
