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
            
			$("#progrmListForm").append('<input type="hidden" name="pageIndex" id="pageIndex" value="' + pageIndex + '" />');
			$("#progrmListForm").append('<input type="hidden" name="pageSort"  id="pageSort"  value="' + pageSort  + '" />');
			$("#progrmListForm").append('<input type="hidden" name="pageOrder" id="pageOrder" value="' + pageOrder + '" />');
		    $("#progrmListForm").attr("method", "post");
		    $("#progrmListForm").attr("action", "<%=RequestMappingConstants.WEB_MNG_PROGRM_AUTH%>");
		    $("#progrmListForm").submit();
        });
				
		// 권한 메뉴 목록 - 팝업
		var p_auth_no = $(this).attr('p-auth-no');
		
		 $("#contents tbody tr td").click(function(e) {
			 
            if($(this).children('input').val() == '' || $(this).children('input').val() == undefined) 
            	return
            
            // 초기화
            p_auth_no = $(this).children('input').val();
            $('#progrmAuthRow > tbody > tr').remove();
            
            // 메뉴 목록 
   			$.ajax({
   				type : "POST",
   				async : false,
   				url : "<%=RequestMappingConstants.WEB_MNG_PROGRM_AUTH_PROGRMS%>",
   				dataType : "json",
   				data : { id: p_auth_no },	
   				error : function(response, status, xhr){
   					if(xhr.status =='403'){
   						alert('선택하신 권한의 메뉴 목록 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
   					}
   				},
   				success : function(data) {
   			        if(data.result == "Y" && data.progrmInfo.length > 0) {
   			         	for (i = 0; i < data.progrmInfo.length; i++) {	
		   			       var row = 	"  	<tr>                                                                     	 " +
							            "    	 <td>" + data.progrmInfo[i].rno + "</td>                                 " +
							            "        <td style='text-align: left;'>" + data.progrmInfo[i].progrm_nm + "</td>                           " +
							            "        <td>" + (data.progrmInfo[i].admin_yn == 'Y' ? '예' : '아니요') + "</td>   " +
							            "        <td>" +
							            "            <div class='content-checkbox'>                                      " +
							            "                <label class='box-checkbox text-none'>                          " +
							            "                    <input type='checkbox' title='권한부여' id='t_progrms' name='t_progrms' value='" + data.progrmInfo[i].progrm_no + "'" + (data.progrmInfo[i].view_yn == 'Y' ? 'checked' : '') + " /> " +
							            "                    <span class='checkmark'></span>                             " +
							            "                </label>                                                        " +
							            "            </div>                                                              " +
							            "        </td>		                                                             " +
						            	"    </tr>		                                                             	 ";   		
							$('#progrmAuthRow > tbody').append(row);
   			         	}
   			         	
	   		           	$('#progrmAuthList').show();
	   		         	$('#progrmAuthList').modal('show');
	   		           	$('#progrmAuthList').center();
   			        }				
   				}
   			});	
   			
            return false;
		}); 
		
		// 권한 - 토글
	    $("#toggle_auth").change(function(){
	    	$('input[name="t_progrms"]').prop('checked', this.checked );
	    });
	    
		// 권한 메뉴 목록 - 저장
		$('#btnAuthRegSave').click(function(e) {
        	if($("#t_p_auth_no").length == 0)
        		$("#progrmAuthListForm").append('<input type="hidden" name="t_p_auth_no" id="t_p_auth_no"/>');
			$("#t_p_auth_no").val(p_auth_no);
			
			$.ajax({
				type : "POST",
				async : false,
				url : "<%= RequestMappingConstants.WEB_MNG_PROGRM_AUTH_PROGRMS_EDIT %>",
				dataType : "json",
				data : jQuery("#progrmAuthListForm").serialize(),	
				error : function(response, status, xhr){
					if(xhr.status =='403'){
						alert('저장 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
					}
				},
				success : function(data) {
			        if(data.result == "Y" && data.progrmInfo != "") {
			        	$('#progrmAuthList').modal('hide');
			        	$('#progrmAuthList').hide();
			        	fn_link_list(1);
			        }				
				}
			});
		});
		
		// 권한 메뉴 목록 - 닫기
		$('#btnAuthRegClose').click(function(e) {
			$("#progrmAuthListForm")[0].reset();
			$('#progrmAuthList').hide();
		});
		
		// 상세 - 변경 상태 저장 - 셀렉트박스 변경시
		$("select[name=use_yn], select[name=admin_yn], select[name=bass_yn]").change( function() {
			var sendUrl;
			var sendData;
			
			sendUrl = "<%= RequestMappingConstants.WEB_MNG_PROGRM_AUTH_EDIT %>";
			
			if($(this).attr('name') == 'use_yn') {
				sendData =  {
					id: $('#p_auth_no').text(),
					use_yn: $(this).val(),
				};
			}
			else if($(this).attr('name') == 'admin_yn') {
				sendData =  {
					id: $('#p_auth_no').text(),
					admin_yn: $(this).val(),
				};
			}
			else if($(this).attr('name') == 'bass_yn') {
				sendData =  {
					id: $('#p_auth_no').text(),
					bass_yn: $(this).val(),
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
			        if(data.result == "Y" && data.progrmInfo == "1") {
			        	$('#progrmDetail').hide();
			        	fn_link_list(1);
			        	alert('정보 변경이 정상적으로 완료 되었습니다.');
			        }				
				}
			});			
			
		});
		
		// 상세 - 닫기
		$('#btnPopClose').click(function(e) {
			$('#progrmDetail').hide();
		});

		
		// 신규발급 - 팝업
		$('#btnAdd').click(function(){
			$('#new_auth_desc').val('');
			$('#new_admin_yn').val('N');
			$('#new_bass_yn').val('N');
			$('#new_use_yn').val('Y');
			
			$("#progrmAdd").show();
			$("#progrmAdd").center();
		});
		
		// 신규발급 - 저장
		$('#btnRegSave').click(function(e) {
			$.ajax({
				type : "POST",
				async : false,
				url : "<%= RequestMappingConstants.WEB_MNG_PROGRM_AUTH_ADD %>",
				dataType : "json",
				data : {
					auth_desc: $('#new_auth_desc').val(),
					admin_yn: $('#new_admin_yn').val(),
					bass_yn: $('#new_bass_yn').val(),
					use_yn: $('#new_use_yn').val()
				},	
				error : function(response, status, xhr){
					if(xhr.status =='403'){
						alert('신규발급 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
					}
				},
				success : function(data) {
			        if(data.result == "Y" && data.progrmInfo == "1") {
			        	$('#progrmAdd').modal('hide');
			        	$("#progrmAdd").hide();
			        	fn_link_list(1);
			        }				
				}
			});
			window.location.reload();
		});
		
		// 신규발급 - 닫기
		$('#btnRegClose').click(function(e) {
			$('#progrmAdd').hide();
		});
	});
	
	// 페이지 링크
	function fn_link_list(pageNo) {
		var pageData = {
				"pageIndex" : pageNo
				,"pageSort" : "${pageSort}"
				,"pageOrder" : "${pageOrder}"
				,"tile" : "tile"
		}
		changeContents("<%= RequestMappingConstants.WEB_MNG_PROGRM_AUTH %>",pageData);
		<%-- $("#progrmListForm").append('<input type="hidden" name="pageIndex" id="pageIndex" value="' + pageNo + '"/>');
		$("#progrmListForm").append('<input type="hidden" name="pageSort"  id="pageSort"  value="${pageSort}" />');
		$("#progrmListForm").append('<input type="hidden" name="pageOrder" id="pageOrder" value="${pageOrder}" />');
		$("#progrmListForm").attr("method", "post");
		$("#progrmListForm").attr("action", "<%= RequestMappingConstants.WEB_MNG_PROGRM_AUTH %>");
		$("#progrmListForm").submit(); --%>
	}
	
	// 상세페이지 이동
	function fn_link_detail(id) {
		$.ajax({
			type : "POST",
			async : false,
			url : "<%= RequestMappingConstants.WEB_MNG_PROGRM_AUTH_DETAIL %>",
			dataType : "json",
			data : {id: id},	
			error : function(response, status, xhr){
				if(xhr.status =='403'){
					$("#progrmDetail").hide();
					alert('상세 데이터 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
				}
			},
			success : function(data) {
		        if(data.result == "Y") {
		        	$('#p_auth_no').text(data.progrmInfo[0].p_auth_no);
		        	$('#auth_desc').text(data.progrmInfo[0].auth_desc);
		        	$('#admin_yn').val(data.progrmInfo[0].admin_yn);
		        	$('#bass_yn').val(data.progrmInfo[0].bass_yn);
		        	$('#use_yn').val(data.progrmInfo[0].use_yn);
		        	$('#ins_user').text(data.progrmInfo[0].ins_user);
		        	$('#ins_dt').text(data.progrmInfo[0].ins_dt);
		        	
		        	$("#progrmDetail").center();
		        	$("#progrmDetail").show();
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
	        <div class="row" id='progrmList' style='display: block;'>
				<div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
		                <form id="progrmListForm" name="progrmListForm" class="form-horizontal">
		                </form>        
	                    <!-- Table-Content-Wrap -->
	                    <h5 class="header-title"><b>목록</b> <span class="small">(전체 <b class="text-orange"><c:out value="${view01Cnt.totalRecordCount}"/></b>건)</span></h5>
	                    <div class="table-wrap m-t-30">
	                        <table class="table table-custom table-cen table-num text-center table-hover" id='contents' >
	                        	<caption class="none">메뉴권한 목록 테이블</caption>
	                            <colgroup>
	                            	<col style="width:5%">
                        			<col style="width:15%">
                        			<col style="width:10%">
                        			<col style="width:10%">
                        			<col style="width:10%">
                        			<col style="width:10%">
                        			<col style="width:10%">
                        			<col style="width:15%">
                        			<col style="width:15%">
	                            </colgroup>
	                            <thead>
		                            <tr>
	                                	<th data-sort="int"    data-sort-col=""       >순번</th>
	                                    <!-- <th data-sort="string" data-sort-col="p_auth_no" style="cursor:pointer" title='아이디로 정렬'>아이디</th> -->
	                                    <th data-sort="string" data-sort-col="auth_desc" style="cursor:pointer" title='권한명으로 정렬'>권한명</th>
	                                    <th data-sort="string" data-sort-col=""    	  >등록인원</th>	                                    
	                                    <th data-sort="string" data-sort-col="admin_yn"  style="cursor:pointer" title='관리자여부로 정렬'>관리자여부</th>
	                                    <th data-sort="string" data-sort-col="bass_yn"   style="cursor:pointer" title='기본여부 정렬'>기본여부</th>
	                                    <th data-sort="string" data-sort-col="use_yn"    style="cursor:pointer" title='사용여부로 정렬'>사용여부</th>
	                                    <th data-sort="string" data-sort-col="ins_user"  style="cursor:pointer" title='등록자로 정렬'>등록자</th>
	                                    <th data-sort="string" data-sort-col="ins_dt"    style="cursor:pointer" title='등록일시로 정렬'>등록일시</th>
	                                    <th data-sort="string" data-sort-col=""    		 style="cursor:pointer" title='등록일시로 정렬'>메뉴</th>
	                                </tr>
	                            </thead>
	                            <tbody>
	                               <c:choose>
										<c:when test="${!empty progrmInfoList}">
											<c:forEach items="${progrmInfoList}" var="result" varStatus="status">
												<tr onclick="javascript:fn_link_detail('${result.p_auth_no}'); return false;" data-toggle="modal"  data-target="#progrmDetail">
													<td>
													 	<c:out value="${view01Cnt.totalRecordCount - (result.rno - 1)}" escapeXml="false" />
													</td>
													<%-- 
			                                        <td>
			                                       		${result.p_auth_no}
			                                        </td>
			                                         --%>
			                                        <td>
			                                       		${result.auth_desc}
			                                        </td>
			                                        <td>
			                                       		${result.auth_users}
			                                        </td>			                                        
			                                        <td>
			                                        	${result.admin_yn eq 'Y' ? '예' : '아니요'}
			                                        </td>
			                                        <td>
			                                        	${result.bass_yn eq 'Y' ? '예' : '아니요'}
			                                        </td>
			                                        <td>
			                                        	${result.use_yn eq 'Y' ? '사용' : '미사용'}
			                                        </td>
			                                        <td>
			                                        	${result.ins_user}
			                                        </td>
			                                        <td>
			                                        	${result.ins_dt}
			                                        </td>
			                                         <td title='메뉴 목록을 확인 할 수 있습니다.'> 
			                                         	<input type='hidden' value='${result.p_auth_no}'>
			                                       		<a href='#progrmAuthList' data-toggle="modal"> + 메뉴목록 </a>
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
		                        <button type="button" class="btn btn-custom btn-md" id="btnAdd" data-toggle="modal"  data-target="#progrmAdd">
		                            <span><i class="fa fa-pencil m-r-5"></i>신규 등록</span>
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
	        <div class="row" id='progrmDetail' style='position: absolute; display: none; z-index:100;' role="dialog">
	            <div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult" >
	                	<h5 class="header-title"><b>권한 상세</b></h5>
	                    <div class="table-wrap m-t-30" >
	                        <table class="table table-custom table-cen table-num text-center table-hover" >
	                        	<caption class="none">메뉴권한 상세 테이블</caption>
	                            <colgroup>
	                                <col style="width:20%">
                        			<col style="width:30%">
                        			<col style="width:20%">
                        			<col style="width:30%">
	                            </colgroup>
	                            <tbody>
									<tr>
									  	<th scope="row">아이디</th>
									  	<td colspan="3" id='p_auth_no'></td>
									</tr>
									<tr>
										<th scope="row">권한명</th>
										<td id='auth_desc'></td>
										<th scope="row">관리자여부</th>
									    <td>
											<select name="admin_yn" id="admin_yn" class="form-control col-md-3 input-sm" title="관리자여부">
												<!-- <option value=""></option> -->
									        	<option value='Y'>예</option>
									        	<option value='N'>아니오</option>
									    	</select>									    
									    </td>
									</tr>
									<tr>
									    <th scope="row">기본여부</th>
									    <td>
											<select name="bass_yn" id="bass_yn" class="form-control col-md-3 input-sm" title="기본여부">
												<!-- <option value=""></option> -->
									        	<option value='Y'>예</option>
									        	<option value='N'>아니오</option>
									    	</select>									    
									    </td>
									    <th scope="row">사용여부</th>
									    <td>
											<select name="use_yn" id="use_yn" class="form-control col-md-3 input-sm" title="사용여부">
												<!-- <option value=""></option> -->
									        	<option value='Y'>사용</option>
									        	<option value='N'>미사용</option>
									    	</select>									    
									    </td>
									</tr>
									<tr>
									    <th scope="row">등록자</th>
									    <td id='ins_user'></td>
									    <th scope="row">등록일시</th>
									    <td id='ins_dt'></td>
									</tr>	                        	
	                        	</tbody>
	                        </table>
	                    </div>
	                    <div class="clearfix"></div>
	                    <!-- <div class="modal-footer"> -->
	                    <div>
	                       <div class="btn-wrap pull-left">
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
	        <div class="row" id="progrmAdd" style='position: absolute; display: none; z-index:100' role="dialog">
	            <div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
	                    <h5 class="header-title"><b>권한 신규 등록</b></h5>
	                    <div class="table-wrap m-t-30">
	                        <table class="table table-custom table-cen table-num text-center table-hover" >
	                       	 <caption class="none">메뉴권한 신규 등록 테이블</caption>
	                            <colgroup>
	                            	<col style="width:20%">
                        			<col style="width:30%">
                        			<%-- <col style="width:20%">
                        			<col style="width:30%"> --%>
	                            </colgroup>
	                            <tbody>
									<tr>
									  	<th scope="row">권한명</th>
									  	<td>
									  		<input class="form-control required" name="new_auth_desc" id="new_auth_desc"  type="text" maxlength="100"  title="권한명">
									  	</td>
									</tr>	                            
									<tr>
										<th scope="row">관리자여부</th>
										<td>
											<select name="new_admin_yn" id="new_admin_yn" class="form-control col-md-3 input-sm" title="관리자여부">
												<!-- <option value=""></option> -->
									        	<option value='Y'>예</option>
									        	<option value='N' selected>아니오</option>
									    	</select>									    
									    </td>
									</tr>
									<tr>
									    <th scope="row">기본여부</th>
									    <td>
											<select name="new_bass_yn" id="new_bass_yn" class="form-control col-md-3 input-sm" title="기본여부">
												<!-- <option value=""></option> -->
									        	<option value='Y'>예</option>
									        	<option value='N' selected>아니오</option>
									    	</select>									    
									    </td>
									</tr>
									<tr>									    
									    <th scope="row">사용여부</th>
									    <td>
											<select name="new_use_yn" id="new_use_yn" class="form-control col-md-3 input-sm" title="사용여부">
												<!-- <option value=""></option> -->
									        	<option value='Y' selected>사용</option>
									        	<option value='N'>미사용</option>
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
	       	
	       	<!-- Auth Program Page-Body -->
	        <div class="row" id="progrmAuthList" style='position: absolute; display: none; z-index:100' role="dialog">
	            <div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
						<form id="progrmAuthListForm" name="progrmListForm" class="form-horizontal">
	                    <h5 class="header-title"><b>메뉴 목록 수정</b></h5>
	                    <div class="table-wrap m-t-30" style='overflow-y:auto; height:400px;'>
	                        <table class="table table-custom table-cen table-num text-center table-hover" id='progrmAuthRow' >
	                        	<caption class="none">메뉴권한 수정 테이블</caption>
	                            <colgroup>
	                                <col style="width:5%">
                        			<col style="width:45%">
                        			<col style="width:25%">
                        			<col style="width:25%">
	                            </colgroup>	                        
		                        <thead>
			                        <tr>
			                            <th>번호</th>
			                            <th>메뉴명</th>
			                            <th>관리자 여부</th>
			                            <th>권한부여 여부 <input name="toggle_auth" id="toggle_auth" type="checkbox" title="권한부여 여부"></th>
			                        </tr>
		                        </thead>
		                        <tbody>
		                        </tbody>
		                    </table>
	                    </div>
	                    </form>
	                    <div>
                           	<div class="btn-wrap pull-left">
                           		<button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id="btnAuthRegSave" type="button">저장</button>
                          	</div>
                           	<div class="btn-wrap pull-right">
                               <button class="btn btn-custom btn-md pull-right searchBtn" id="btnAuthRegClose" type="button" data-dismiss="modal">닫기</button>
                           	</div> 
	                    </div>
	                </div>
	            </div>
	        </div>
			<!-- End Auth Program Page-Body -->
