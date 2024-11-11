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
            
			$("#dataListForm").append('<input type="hidden" name="pageIndex" id="pageIndex" value="' + pageIndex + '" />');
			$("#dataListForm").append('<input type="hidden" name="pageSort"  id="pageSort"  value="' + pageSort  + '" />');
			$("#dataListForm").append('<input type="hidden" name="pageOrder" id="pageOrder" value="' + pageOrder + '" />');
		    $("#dataListForm").attr("method", "post");
		    $("#dataListForm").attr("action", "<%=RequestMappingConstants.WEB_MNG_TABLE_DATA%>");
		    $("#dataListForm").submit();
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

		// 상세 승인
		$('#btnConfmSave').click(function(){
			if(confirm('승인이 진행 된후 이전 데이터를 사용할 수 없습니다.\n\n데이터 승인을 진행 하시겠습니까?')) {

				var noData = ['OGC_FID','OBJECTID','THE_GEOM'];
				var sendData = [];
				$('#dataEditRow > tbody > tr').each(function(index, tr) {
				    $.each(this.cells, function(){
				    	var col_id = $(this).attr("id") + '';
				    	if(col_id.indexOf('_after') > 0) {
					       	var _nm  = col_id.replace(/_after/g,'');					
							var _val = $('#' + _nm + '_after').text();
							var _type =$('#' + _nm + '_after').attr('data-col-type');
							
							_type = _type.indexOf('character') >= 0 ? '' : _type.substring(0, _type.indexOf('('));
								
							if(_nm != undefined && _nm != '' && _val != undefined && _val != '' && noData.indexOf(_nm.toUpperCase()) < 0)
								sendData.push({col_nm: _nm, col_val: _val, col_type: _type});	
				    	}
				    });							
				}); 
				
				$.ajax({
					type : "POST",
					async : false,
					url : "<%=RequestMappingConstants.WEB_MNG_TABLE_DATA_EDIT%>",
					dataType : "json",
					data : {
						id: $('#req_no').val(),
						nm: $('#table_nm').val(),
						data: JSON.stringify(sendData)
					},	
					error : function(response, status, xhr){
						if(xhr.status =='403'){
							alert('데이터의 승인 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
						}
					},
					success : function(data) {
						if(data.result == "Y") {
							$('#dataDetail').hide();
							alert('정보 변경이 정상적으로 완료 되었습니다.');
						}
					}
				});					
			}
		});

		// 상세 닫기
		$('#btnConfmClose').click(function(){
			$('#dataDetail').hide();
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
		
		$("#dataListForm").append('<input type="hidden" name="pageIndex" id="pageIndex" value="1" />');
		$("#dataListForm").append('<input type="hidden" name="pageSort"  id="pageSort"  value="${pageSort}" />');
		$("#dataListForm").append('<input type="hidden" name="pageOrder" id="pageOrder" value="${pageOrder}" />');
	    $("#dataListForm").attr("method", "post");
	    $("#dataListForm").attr("action", "<%=RequestMappingConstants.WEB_MNG_TABLE_DATA%>");
	    $("#dataListForm").submit();
	}
	
	// 페이지 링크
	function fn_link_list(pageNo) {
		var pageData = {
				"pageIndex" : pageNo
				,"pageSort" : "${pageSort}"
				,"pageOrder" : "${pageOrder}"
				,"tile" : "tile"
		}
		changeContents("<%=RequestMappingConstants.WEB_MNG_TABLE_DATA%>",pageData);
	}
	
	// 컬럼 리스트
	function fn_column_reload(nm) {
		$.ajax({
			type : "POST",
			async : false,
			url : "<%=RequestMappingConstants.WEB_MNG_COLUMN_COMMENT_LIST%>",
			dataType : "json",
			data : {space: nm.split('.')[0], nm: nm.split('.')[1]},	
			error : function(response, status, xhr){
				if(xhr.status =='403'){
					alert('선택하신 테이블의 상세 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
				}
			},
			success : function(data) {
				$('#dataEditRow > tbody > tr').remove();
				if(data.result == "Y" && data.columnInfo.length > 0) {
					for(i=0; i<data.columnInfo.length;i++)
					{
	   			       var row = 	"  	<tr>" +
						            "    	 <td>" + data.columnInfo[i].column_seq + "</td>" +
						            "        <td style='text-align: left;'>" + data.columnInfo[i].column_nm + "</td>" +
						            "        <td style='text-align: left;'>" + data.columnInfo[i].column_comment + "</td>" +							            
						            "    	 <td style='text-align: left;' id='" + data.columnInfo[i].column_nm.toLowerCase() + "_before'></td>" +
						            "    	 <td style='text-align: left;' id='" + data.columnInfo[i].column_nm.toLowerCase() + "_after' data-col-type='" + data.columnInfo[i].column_type + "'></td>" +						            
						            "   </tr>";
						$('#dataEditRow > tbody').append(row);						
					}
				}
			}
		});			
	}
	
	// 상세페이지 이동
	function fn_link_detail(id, nm, fnm, confm) {
		
		fn_column_reload(nm)
		
		$.ajax({
			type : "POST",
			async : false,
			url : "<%= RequestMappingConstants.WEB_MNG_TABLE_DATA_DETAIL %>",
			dataType : "json",
			data : {id: id},	
			error : function(response, status, xhr){
				if(xhr.status =='403'){
					$("#dataDetail").hide();
					alert('수정 요청 상세 데이터 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
				}
			},
			success : function(data) {
		        if(data.result == "Y") {
		        	if($("#req_no").length == 0)
		        		$("#dataDetail").append('<input type="hidden" name="req_no" id="req_no"/>');
		        	$('#req_no').val(id);

		        	if($("#table_nm").length == 0)
		        		$("#dataDetail").append('<input type="hidden" name="table_nm" id="table_nm"/>');
		        	$('#table_nm').val(fnm);
		        	
		        	//console.log( data.dataInfo.req_data.value );
		        	//console.log( data.dataInfo.before_data.value );
		        	
		        	var after = JSON.parse(data.dataInfo.req_data.value);
		        	var before = JSON.parse(data.dataInfo.before_data.value);

		        	//console.log( after.ogc_fid );
		        	//console.log( before.ogc_fid );
		        	
		        	$('#dataEditRow > tbody > tr').each(function() {
					    $.each(this.cells, function(){
					    	var col_id = $(this).attr("id") + '';
					    	if(col_id.indexOf('_before') > 0) {
						       	var col_nm = '';
						       	col_nm = col_id.replace(/_before/g,'');
	
								if(eval('before.' + col_nm) == eval('after.' + col_nm)) {						       
						    		$('#' + col_nm + '_before').text( eval('before.' + col_nm) );
						    	   	$('#' + col_nm + '_after').text( eval('after.' + col_nm) );
								} else {
						    		$('#' + col_nm + '_before').text( eval('before.' + col_nm) );
						    		
						    		$('#' + col_nm + '_after').css({"background-color": "yellow", "color": "blue"});
						    	   	$('#' + col_nm + '_after').text( eval('after.' + col_nm) );
								}
									
					    	}
					    });
					});
		        	
		        	if(confm == 'Y')
		        		$('#btnConfmSave').hide();
		        	else
		        		$('#btnConfmSave').show();
		        	
		        	$('#btnConfmClose').show();
		        	$("#dataDetail").center();
		        	$("#dataDetail").show();
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
	        <div class="row" id='dataList' style='display: block;'>
				<div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
	                							
						<div class="form-group">
                        <form id="dataListForm" name="dataListForm" class="form-horizontal">
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
	                                     <label class="sr-only">검색어</label>
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
	                        	<caption class="none">데이터 목록 테이블</caption>
	                            <colgroup>
	                                <%-- 
	                                <col width="10%" />
	                                <col width="10%" />
	                                <col width="15%" />
	                                <col width="10%" />
	                                <col width="15%" />
	                                <col width="10%" />
	                                <col width="15%" />
	                                <col width="10%" />
	                                --%>
	                                <col style="width:5%">
                        			<col style="width:20%">
                        			<col style="width:9%">
                        			<col style="width:14%">
                        			<col style="width:9%">
                        			<col style="width:14%">
                        			<col style="width:9%">
                        			<col style="width:14%">
                        			<col style="width:6%">
	                            </colgroup>
	                            <thead>
		                            <tr>
	                                	<th data-sort="int"    data-sort-col="" >순번</th>
	                                    <th data-sort="string" data-sort-col="table_nm"   	style="cursor:pointer" title='테이블명으로 정렬'>테이블명</th>
	                                    <th data-sort="string" data-sort-col="ins_user_nm" 	style="cursor:pointer" title='작성자로 정렬'>작성자</th>
	                                    <th data-sort="string" data-sort-col="ins_dt"  		style="cursor:pointer" title='등록일시로 정렬'>등록일시</th>
	                                    <th data-sort="string" data-sort-col="upd_user_nm"  style="cursor:pointer" title='수정자로 정렬'>수정자</th>
	                                    <th data-sort="string" data-sort-col="upd_dt"       style="cursor:pointer" title='수정일시로 정렬'>수정일시</th>	                                    
	                                    <th data-sort="string" data-sort-col="cfm_user_nm" 	style="cursor:pointer" title='적용자로 정렬'>적용자</th>
	                                    <th data-sort="string" data-sort-col="cfm_dt" 		style="cursor:pointer" title='적용일시로 정렬'>적용일시</th>
	                                    <th data-sort="string" data-sort-col="cfm_yn_kor"   style="cursor:pointer" title='적용여부로 정렬'>적용여부</th>
	                                </tr>
	                            </thead>
	                            <tbody>
	                               <c:choose>
										<c:when test="${!empty dataList}">
											<c:forEach items="${dataList}" var="result" varStatus="status">
												<tr onclick="javascript:fn_link_detail('${result.req_no}', '${result.table_nm}', '${result.table_full_nm}', '${result.cfm_yn_eng}'); return false;">
													<td>
													 	<c:out value="${view01Cnt.totalRecordCount - (result.rno - 1)}" escapeXml="false" />
													</td>													
			                                        <td>
			                                        	${result.table_nm}
			                                        </td>
			                                        <td>
			                                        	${result.ins_user_nm}
			                                        </td>
			                                        <td>
			                                        	${result.ins_dt}
			                                        </td>
			                                        <td>
			                                        	${result.upd_user_nm}
			                                        </td>
			                                        <td>
			                                        	${result.upd_dt}
			                                        </td>			                                        
			                                        <td>
			                                        	${result.cfm_user_nm}
			                                        </td>
			                                        <td>
			                                        	${result.cfm_dt}
			                                        </td>
			                                        <td>
			                                        	${result.cfm_yn_kor}
			                                        </td>
			                                    </tr>
											</c:forEach>
										</c:when>
										<c:otherwise>
											<tr><td colspan="9" style="text-align:center">검색결과가 없습니다.</td></tr>
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
		</div>
	</div> 
	
	<!-- Data Detail Page-Body -->
    <div class="row" id='dataDetail' style='position: absolute; display: none; z-index:100'>
        <div class="col-sm-11">
            <div class="card-box big-card-box last table-responsive searchResult">
                <h5 class="header-title"><b>데이터 상세</b></h5>
				<div class="table-wrap m-t-30" style='height:600px;  overflow-y:auto'>
					<table class="table table-custom table-cen table-num text-center table-hover"  id='dataEditRow'>
						<caption class="none">데이터 상세 테이블</caption>
						<colgroup>
							<col style="width:5%">
							<col style="width:20%">
                   			<col style="width:20%">
                   			<col style="width:20%">
                   			<col style="width:35%">
						</colgroup>
						<thead>
							<tr>
								<th>번호</th>
								<th>컬럼명</th>
								<th>코멘트</th>
								<th>이전 데이터</th>
								<th>수정 데이터</th>
							</tr>
						</thead>					                            
						<tbody>
						</tbody>
					</table>
				</div>
				<p></p>
                <div>
	              	<div class="btn-wrap pull-left">
	             		<button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id="btnConfmSave" type="button" style='display: none'>승인</button>
	               	</div>
	               	<div class="btn-wrap pull-right">
	                    <button class="btn btn-custom btn-md pull-right searchBtn" id="btnConfmClose" type="button" style='display: none'>닫기</button>
	               	</div> 
                </div>	                    
            </div>
        </div>
    </div>
	<!-- End Data Detail Page-Body -->
