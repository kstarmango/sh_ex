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
		
		 $("#logoutYn").click(function() {
			 if($('#logoutYn').is(":checked") == true){
				$('#initLogoutYn').val("Y");
			}else{
				$('#initLogoutYn').val("N");
			} 
		}); 
		
		$("#btnExcel").click(function() {
			tableName = 'excelTable';

		 	// 기본
			$('#' + tableName).attr('border', '1');

			exportTableToExcel(tableName, '사용자 접속 현황');

		 	// 기본
			$('#' + tableName).attr('border', '0');

		}); 
		
				
		$("input[name=s_serch_start_dt]").val(
				"<c:out value='${s_serch_start_dt}'/>"
		);

		$("input[name=s_serch_end_dt]").val(
				"<c:out value='${s_serch_end_dt}'/>"
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
            
			$("#userLoginListForm").append('<input type="hidden" name="pageIndex" id="pageIndex" value="' + pageIndex + '" />');
			$("#userLoginListForm").append('<input type="hidden" name="pageSort"  id="pageSort"  value="' + pageSort  + '" />');
			$("#userLoginListForm").append('<input type="hidden" name="pageOrder" id="pageOrder" value="' + pageOrder + '" />');
		    $("#userLoginListForm").attr("method", "post");
		    $("#userLoginListForm").attr("action", "<%=RequestMappingConstants.WEB_MNG_USER_LOGIN_HISTORY%>");
		    $("#userLoginListForm").submit();
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
			$("input[name=s_serch_end_dt]").val("");
			$("select[name=s_serch_gb]").val("");
			$("input[name=s_serch_nm]").val("");
			$.each($("input[name='s_serch_member']"), function(){
               $(this).attr("checked", false);
            });
		});
		
	});
	
	// 검색
	function fn_search_list() {
		var s_serch_gb = $("select[name=s_serch_gb]").val();
		var s_serch_nm = $("input[name=s_serch_nm]").val();
	    
	    var pageData = {
				"pageIndex" : 1
				,"pageSort" : "${pageSort}"
				,"pageOrder" : "${pageOrder}"
				,"s_serch_gb" : s_serch_gb
				,"s_serch_nm" : s_serch_nm
				,"tile" : "tile"
		}
		changeContents("<%=RequestMappingConstants.WEB_MNG_USER_LOGIN_HISTORY%>",pageData);
	}
	
	// 페이지 링크
	function fn_link_list(pageNo) {
		var pageData = {
				"pageIndex" : pageNo
				,"pageSort" : "${pageSort}"
				,"pageOrder" : "${pageOrder}"
				,"tile" : "tile"
		}
		changeContents("<%=RequestMappingConstants.WEB_MNG_USER_LOGIN_HISTORY%>",pageData);
	}
	
	function exportTableToExcel(id, file) {
	    var downloadLink;
	    var dataType = 'application/vnd.ms-excel';
	    var tableSelect = document.getElementById(id);

	    // Specify file name
	    file = file?file+'.xls':'excel_data.xls';

	    if(window.navigator.msSaveBlob)
	    {

	        var tableHTML = tableSelect.outerHTML

	        var blob = new Blob([ tableHTML ], {
				type : "application/csv;charset=utf-8;"
			});
	        window.navigator.msSaveBlob( blob, file);
	    }
	    else
	    {
	    	var tableHTML = tableSelect.outerHTML.replace(/ /g, '%20');

	    	// Create download link element
		    downloadLink = document.createElement("a");

		    document.body.appendChild(downloadLink);

	        downloadLink.href = 'data:' + dataType + 'charset=utf-8,%EF%BB%BF' + tableHTML;
	        downloadLink.download = file;
	        downloadLink.click();
	    }
	}
	
	
	</script>
	<div class="contWrap">
        <h1>${sesMenuNavigation.progrm_nm}</h1>
        <div class="whiteCont">
        	<p class="pageNav">
                <a href="<%=RequestMappingConstants.WEB_MAIN%>">HOME</a> &nbsp;&nbsp; |  &nbsp;&nbsp;  <a href="<%=RequestMappingConstants.WEB_MNG_USER%>">${sesMenuNavigation.p_progrm_nm}</a>  &nbsp;&nbsp;  |  &nbsp;&nbsp;  	${sesMenuNavigation.progrm_nm}
            </p>
            
            <!-- List Page-Body -->
	        <div class="row hei_100" id='userLoginList' style='display: block;'>
				<div class="col-sm-12 hei_100">
	                <div class="card-box big-card-box last table-responsive searchResult hei_100">
	                
						<div class="form-group">
                        <form id="userLoginListForm" name="userLoginListForm" class="form-horizontal">
	                        <h5 class="header-title m-t-0 m-b-20"><b>검색 조건</b></h5>
						    <div class="row">
	                           	<div class="col-md-11">
	                                 <div class="form-group">
	                                 	 <label class="col-md-1 control-label">검색기간</label>
	                                     <div class="col-md-2">
	                                         <div class="input-group date datetimepickerStart m-b-5">
	                                         	<input  class="form-control input-group-addon m-b-0" style='font-size: 11px;' name="s_serch_start_dt"  title ="시작일자"  placeholder="시작일 선택">
	                                             <span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
	                                         </div>
	                                     </div>
	                                     <div class="col-md-2">
	                                         <div class="input-group date datetimepickerStart m-b-5">
	                                         	<input  class="form-control input-group-addon m-b-0" style='font-size: 11px;' name="s_serch_end_dt"  title ="종료일자"  placeholder="종료일 선택">
	                                         	<span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
	                                         </div>
	                                     </div>
   	                                     <label class="col-md-1 control-label">가입유형</label>
	                                     <div class="col-md-6" style='padding-top:10px'>
                                         	<c:forEach var="item1" items="${userMemberType}">
                                         	<input  name="s_serch_member" type="checkbox" title ="${fn:trim(item1.code_nm)}" value='${fn:trim(item1.code)}' ${fn:indexOf(s_serch_member, fn:trim(item1.code)) >= 0 ? 'checked' : ''} >&nbsp;&nbsp;${fn:trim(item1.code_nm)}&nbsp;&nbsp;&nbsp;
                                         	</c:forEach>
                                         	<input id = "logoutYn" name="logoutYn" type="checkbox" title ="로그아웃 제외" value='Y' ${logoutYn == 'Y' ? 'checked' : ''}>&nbsp;&nbsp;로그아웃 제외&nbsp;&nbsp;&nbsp;
                                         	<input type = "hidden" name = "initLogoutYn" id = "initLogoutYn" value = "">
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
												<option value="user_id">사용자ID</option>
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
	                    <h5 class="header-title" style = "position: relative;">
	                    	<b>목록</b> 
	                    	<span class="small">(전체 <b class="text-orange"><c:out value="${view01Cnt.totalRecordCount}"/></b>건)</span>
	                    	
	                    <button type="button" class="btn btn-custom-green btn-md pull-right searchBtn" id="btnExcel" style="position: absolute; top: -5px; right: 0;">저장</button>
	                    </h5>
	                    <div class="table-wrap">
	                        <table class="table table-custom table-cen table-num text-center table-hover" id='contents' >
	                        	<caption class="none">사용자 접속 현황 목록 테이블</caption>
	                            <colgroup>
	                                <col style="width:10%">
                        			<col style="width:15%">
                        			<col style="width:15%">
                        			<col style="width:15%">
                        			<col style="width:15%">
                        			<col style="width:20%">
	                            </colgroup>
	                            <thead>
		                            <tr>
	                                	<th data-sort="int"    data-sort-col=""       >순번</th>
	                                    <th data-sort="string" data-sort-col="user_id" style="cursor:pointer" title='사용자 ID로 정렬'>ID</th>
	                                    <th data-sort="string" data-sort-col="user_nm" style="cursor:pointer" title='사용자 이름으로 정렬'>이름</th>
	                                    <th data-sort="string" data-sort-col="dept_nm" style="cursor:pointer" title='사용자 부서명 정렬'>부서명</th>
	                                    <th data-sort="string" data-sort-col="ins_dt"  style="cursor:pointer" title='사용자 등록일시로 정렬'>접속일시</th>
	                                    <th data-sort="string" data-sort-col=""  	  >로그인/아웃</th>
	                                </tr>
	                            </thead>
	                            <tbody>
	                               <c:choose>
										<c:when test="${!empty userHistList}">
											<c:forEach items="${userHistList}" var="result" varStatus="status">
												<tr>
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
			                                        	${result.ins_dt}
			                                        </td>
			                                        <td>
			                                        	${result.stat}
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
	                        <!-- excel table -->
	                        <table class="table table-custom table-cen table-num text-center table-hover" id='excelTable'  style = "display:none;">
	                        	<caption class="none">사용자 접속 현황 상세 테이블</caption>
	                            <colgroup>
	                                <col style="width:10%">
                        			<col style="width:15%">
                        			<col style="width:15%">
                        			<col style="width:15%">
                        			<col style="width:15%">
                        			<col style="width:20%">
	                            </colgroup>
	                            <thead>
		                            <tr>
	                                	<th data-sort="int"    data-sort-col=""       >순번</th>
	                                    <th data-sort="string" data-sort-col="user_id" style="cursor:pointer" title='사용자 ID로 정렬'>ID</th>
	                                    <th data-sort="string" data-sort-col="user_nm" style="cursor:pointer" title='사용자 이름으로 정렬'>이름</th>
	                                    <th data-sort="string" data-sort-col="dept_nm" style="cursor:pointer" title='사용자 부서명 정렬'>부서명</th>
	                                    <th data-sort="string" data-sort-col="ins_dt"  style="cursor:pointer" title='사용자 등록일시로 정렬'>접속일시</th>
	                                    <th data-sort="string" data-sort-col=""  	  >로그인/아웃</th>
	                                </tr>
	                            </thead>
	                            <tbody>
	                               <c:choose>
										<c:when test="${!empty userHistListExcel}">
											<c:forEach items="${userHistListExcel}" var="result" varStatus="status">
												<tr>
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
			                                        	${result.ins_dt}
			                                        </td>
			                                        <td>
			                                        	${result.stat}
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
                                <div class="text-center">
	                                <ul class="pagination m-b-0 m-t-0">
		                               <ui:pagination paginationInfo = "${view01Cnt}" type="user" jsFunction="fn_link_list" />
		                            </ul>
	                            </div>
                            </div>
	                    </div>
	                </div>                                   
	
	            </div>
	        </div>
	        <!-- End List Page-Body --> 
        </div>
    </div>
