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

			$("#layerListForm").append('<input type="hidden" name="pageIndex" id="pageIndex" value="' + pageIndex + '" />');
			$("#layerListForm").append('<input type="hidden" name="pageSort"  id="pageSort"  value="' + pageSort  + '" />');
			$("#layerListForm").append('<input type="hidden" name="pageOrder" id="pageOrder" value="' + pageOrder + '" />');
		    $("#layerListForm").attr("method", "post");
		    $("#layerListForm").attr("action", "<%=RequestMappingConstants.WEB_MNG_LAYER_AUTH%>");
		    $("#layerListForm").submit();
        });

		// 권한 레이어 목록 - 팝업
		var l_auth_no = $(this).attr('l-auth-no');

		$("#contents tbody tr td").click(function(e) {
            if($(this).attr('l-auth-no') == '' || $(this).attr('l-auth-no') == undefined)
            	return

               // 초기화
               l_auth_no = $(this).attr('l-auth-no');
               $('#layerAuthRow > tbody > tr').remove();

               // 레이어 목록
      			$.ajax({
      				type : "POST",
      				async : false,
      				url : "<%=RequestMappingConstants.WEB_MNG_LAYER_AUTH_LAYERS%>",
      				dataType : "json",
      				data : { id: l_auth_no },
      				error : function(response, status, xhr){
      					if(xhr.status =='403'){
      						alert('선택하신 권한의 레이어 목록 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
      					}
      				},
      				success : function(data) {
      					var row = '';
      			        if(data.result == "Y" && data.layerInfo.length > 0) {
      			         	for (i = 0; i < data.layerInfo.length; i++) {
      			         		var editable = data.layerInfo[i].edit_enable_yn == 'Y' ? '' : 'disabled';
      			         		if(data.layerInfo[i].mapng_no != '')
      			         		{
	   		   			        	 row = 	"  	<tr data-row-id='" + data.layerInfo[i].mapng_no + "' >                      	 " +
	   							            "    	 <td>" + data.layerInfo[i].rno + "</td>                                  " +
	   							            "        <td style='text-align: left;'>" + data.layerInfo[i].grp_nm + "</td>     " +
	   							            "        <td style='text-align: left;'>" + data.layerInfo[i].layer_nm + "</td>   " +
	   							            "        <td>                   												 " +
	   							            "            <div class='content-checkbox'>                                      " +
	   							            "                <label class='box-checkbox text-none'>                          " +
	   							            "                    <input type='checkbox' id='t_view_yn' name='t_view_yn' value='"
	   							            							+ data.layerInfo[i].mapng_no + "'" + (data.layerInfo[i].view_yn == 'Y' ? 'checked' : '') + " /> " +
	   							            "                    <span class='checkmark'></span>                             " +
	   							            "                </label>                                                        " +
	   							            "            </div>                                                              " +
	   							            "        </td>		                                                             " +
	   							            "        <td>																	 " +
	   							            "            <div class='content-checkbox'>                                      " +
	   							            "                <label class='box-checkbox text-none'>                          " +
	   							            "                    <input type='checkbox' id='t_edit_yn' name='t_edit_yn' value='"
	   							            							+ data.layerInfo[i].mapng_no + "'" + (data.layerInfo[i].attr_edit_yn == 'Y' && data.layerInfo[i].edit_enable_yn == 'Y' ? 'checked' : '') + " " + editable + "  /> " +
	   							            "                    <span class='checkmark'></span>                             " +
	   							            "                </label>                                                        " +
	   							            "            </div>                                                              " +
	   							            "        </td>		                                                             " +
	   							            "        <td>																	 " +
	   							            "            <div class='content-checkbox'>                                      " +
	   							            "                <label class='box-checkbox text-none'>                          " +
	   							            "                    <input type='checkbox' id='t_down_yn' name='t_down_yn' value='"
	   							            							+ data.layerInfo[i].mapng_no + "'" + (data.layerInfo[i].shp_dn_yn == 'Y' && data.layerInfo[i].edit_enable_yn == 'Y' ? 'checked' : '') + " " + editable + "  /> " +
	   							            "                    <span class='checkmark'></span>                             " +
	   							            "                </label>                                                        " +
	   							            "            </div>                                                              " +
	   							            "        </td>		                                                             " +
	   							         	"    </tr>		                                                             	 ";
      			         		} else {
	   		   			        	 row = 	"  	<tr>                                                                     	 " +
								            "    	 <td>" + data.layerInfo[i].rno + "</td>                                  " +
								            "        <td style='text-align: left;'>" + data.layerInfo[i].grp_nm + "</td>     " +
								            "        <td></td>	                                                             " +
								            "        <td></td>	                                                             " +
								            "        <td></td>	                                                             " +
								            "        <td></td>	                                                             " +
								         	"    </tr>		                                                             	 ";
      			         		}

   								$('#layerAuthRow > tbody').append(row);
      			         	}

	   	   		           	$('#layerAuthList').show();
	   	   		      	    $('#layerAuthList').modal('show');
	   	   		           	$('#layerAuthList').center();
      			        }
      				}
      			});

               return false;
		});

		// 권한 - VIEW 토글
	    $("#toggle_view").change(function(){
	    	$('input[name="t_view_yn"]').prop('checked', this.checked );
	    });

	 	// 권한 - EDIT 토글
	    $("#toggle_edit").change(function(){
	    	$('input[name="t_edit_yn"]:checkbox:not(:disabled)').prop('checked', this.checked );
	    });

	 	// 권한 - DOWN 토글
	    $("#toggle_down").change(function(){
	    	$('input[name="t_down_yn"]:checkbox:not(:disabled)').prop('checked', this.checked );
	    });

		// 권한 레이어 목록 - 저장
		$('#btnAuthRegSave').click(function(e) {
        	if($("#t_l_auth_no").length == 0)
        		$("#layerAuthListForm").append('<input type="hidden" name="t_l_auth_no" id="t_l_auth_no"/>');
			$("#t_l_auth_no").val(l_auth_no);

			var sendData = [];
			$('#layerAuthRow > tbody > tr').each(function(index, tr) {
				var _no   = $(tr).attr('data-row-id');
				var _view = $(tr).children().find('input[name="t_view_yn"]').is(':checked') == true ? 'Y' : 'N';
				var _edit = $(tr).children().find('input[name="t_edit_yn"]').is(':checked') == true ? 'Y' : 'N';
				var _down = $(tr).children().find('input[name="t_down_yn"]').is(':checked') == true ? 'Y' : 'N';

				if(_no != undefined)
					sendData.push({no: _no, view: _view, edit: _edit, down: _down});
			});

			$.ajax({
				type : "POST",
				async : false,
				url : "<%= RequestMappingConstants.WEB_MNG_LAYER_AUTH_LAYERS_EDIT %>",
				dataType : "json",
				data : {
					l_auth_no: l_auth_no,
					l_auth_data: JSON.stringify(sendData)
				},
				error : function(response, status, xhr){
					if(xhr.status =='403'){
						alert('저장 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
					}
				},
				success : function(data) {
			        if(data.result == "Y" && data.progrmInfo != "") {
			        	$('#layerAuthList').hide();
			        	fn_link_list(1);
			        }
				}
			});
		});

		// 권한 레이어 목록 - 닫기
		$('#btnAuthRegClose').click(function(e) {
			$("#layerAuthListForm")[0].reset();
			$('#layerAuthList').hide();
		});

		// 상세 - 변경 상태 저장 - 셀렉트박스 변경시
		$("select[name=use_yn], select[name=bass_yn]").change( function() {
			var sendUrl;
			var sendData;

			sendUrl = "<%= RequestMappingConstants.WEB_MNG_LAYER_AUTH_EDIT %>";

			if($(this).attr('name') == 'use_yn') {
				sendData =  {
					id: $('#l_auth_no').text(),
					use_yn: $(this).val(),
				};
			}
			else if($(this).attr('name') == 'bass_yn') {
				sendData =  {
					id: $('#l_auth_no').text(),
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
			        if(data.result == "Y" && data.layerInfo == "1") {
			        	$('#layerDetail').hide();
			        	fn_link_list(1);
			        	alert('정보 변경이 정상적으로 완료 되었습니다.');
			        }
				}
			});

		});

		// 상세 - 닫기
		$('#btnPopClose').click(function(e) {
			$('#layerDetail').hide();
		});


		// 신규발급 - 팝업
		$('#btnAdd').click(function(){
			$('#new_auth_desc').val('');
			$('#new_bass_yn').val('N');
			$('#new_use_yn').val('Y');

			$("#layerAdd").show();
			$("#layerAdd").center();
		});

		// 신규발급 - 저장
		$('#btnRegSave').click(function(e) {
			$.ajax({
				type : "POST",
				async : false,
				url : "<%= RequestMappingConstants.WEB_MNG_LAYER_AUTH_ADD %>",
				dataType : "json",
				data : {
					auth_desc: $('#new_auth_desc').val(),
					bass_yn: $('#new_bass_yn').val(),
					use_yn: $('#new_use_yn').val()
				},
				error : function(response, status, xhr){
					if(xhr.status =='403'){
						alert('신규발급 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
					}
				},
				success : function(data) {
			        if(data.result == "Y") {
			        	$("#layerAdd").hide();
			        	fn_link_list(1);
			        }
				}
			});

		});

		// 신규발급 - 닫기
		$('#btnRegClose').click(function(e) {
			$('#layerAdd').hide();
		});
	});

	// 페이지 링크
	function fn_link_list(pageNo) {
		$("#layerListForm").append('<input type="hidden" name="pageIndex" id="pageIndex" value="' + pageNo + '"/>');
		$("#layerListForm").append('<input type="hidden" name="pageSort"  id="pageSort"  value="${pageSort}" />');
		$("#layerListForm").append('<input type="hidden" name="pageOrder" id="pageOrder" value="${pageOrder}" />');
		$("#layerListForm").attr("method", "post");
		$("#layerListForm").attr("action", "<%= RequestMappingConstants.WEB_MNG_LAYER_AUTH %>");
		$("#layerListForm").submit();
	}

	// 상세페이지 이동
	function fn_link_detail(id) {
		$.ajax({
			type : "POST",
			async : false,
			url : "<%= RequestMappingConstants.WEB_MNG_LAYER_AUTH_DETAIL %>",
			dataType : "json",
			data : {id: id},
			error : function(response, status, xhr){
				if(xhr.status =='403'){
					$("#layerDetail").hide();
					alert('상세 데이터 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
				}
			},
			success : function(data) {
		        if(data.result == "Y") {
		        	$('#l_auth_no').text(data.layerInfo[0].l_auth_no);
		        	$('#auth_desc').text(data.layerInfo[0].auth_desc);
		        	$('#bass_yn').val(data.layerInfo[0].bass_yn);
		        	$('#use_yn').val(data.layerInfo[0].use_yn);
		        	$('#ins_user').text(data.layerInfo[0].ins_user);
		        	$('#ins_dt').text(data.layerInfo[0].ins_dt);

		        	$("#layerDetail").center();
		        	$("#layerDetail").show();
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
	        <div class="row" id='layerList' style='display: block;'>
				<div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
		                <form id="layerListForm" name="layerListForm" class="form-horizontal">
		                </form>
	                    <!-- Table-Content-Wrap -->
	                    <h5 class="header-title"><b>목록</b> <span class="small">(전체 <b class="text-orange"><c:out value="${view01Cnt.totalRecordCount}"/></b>건)</span></h5>
	                    <div class="table-wrap m-t-30">
	                        <table class="table table-custom table-cen table-num text-center table-hover" id='contents' width="100%">
	                            <colgroup>
	                                <col width="5%" />
	                                <col width="25%" />
	                                <col width="10%" />
	                                <col width="10%" />
	                                <col width="10%" />
	                                <col width="10%" />
	                                <col width="15%" />
	                                <col width="15%" />
	                            </colgroup>
	                            <thead>
		                            <tr>
	                                	<th data-sort="int"    data-sort-col=""       >순번</th>
	                                    <!-- <th data-sort="string" data-sort-col="l_auth_no" style="cursor:pointer" title='아이디로 정렬'>아이디</th> -->
	                                    <th data-sort="string" data-sort-col="auth_desc" style="cursor:pointer" title='권한명으로 정렬'>권한명</th>
	                                    <th data-sort="string" data-sort-col=""    	  >등록인원</th>
	                                    <th data-sort="string" data-sort-col="bass_yn"   style="cursor:pointer" title='기본여부 정렬'>기본여부</th>
	                                    <th data-sort="string" data-sort-col="use_yn"    style="cursor:pointer" title='사용여부로 정렬'>사용여부</th>
	                                    <th data-sort="string" data-sort-col="ins_user"  style="cursor:pointer" title='등록자로 정렬'>등록자</th>
	                                    <th data-sort="string" data-sort-col="ins_dt"    style="cursor:pointer" title='등록일시로 정렬'>등록일시</th>
	                                    <th data-sort="string" data-sort-col=""    		 style="cursor:pointer" title='등록일시로 정렬'>프로그램</th>
	                                </tr>
	                            </thead>
	                            <tbody>
	                               <c:choose>
										<c:when test="${!empty layerInfoList}">
											<c:forEach items="${layerInfoList}" var="result" varStatus="status">
												<tr onclick="javascript:fn_link_detail('${result.l_auth_no}'); return false;" data-toggle="modal"  data-target="#layerDetail">
													<td>
													 	<c:out value="${view01Cnt.totalRecordCount - (result.rno - 1)}" escapeXml="false" />
													</td>
													<%--
			                                        <td>
			                                       		${result.l_auth_no}
			                                        </td>
			                                         --%>
			                                        <td>
			                                       		${result.auth_desc}
			                                        </td>
			                                        <td>
			                                       		${result.auth_users}
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
			                                        <td l-auth-no='${result.l_auth_no}' title='레이어 목록을 확인 할 수 있습니다.'>
			                                       		<a href='#' data-toggle="modal"  data-target="#layerAuthList"> + 레이어 목록 </a>
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
		                        <button type="button" class="btn btn-custom btn-md" id="btnAdd" data-toggle="modal"  data-target="#layerAdd">
		                            <span><i class="fa fa-pencil m-r-5"></i>신규 등록</span>
		                        </button>
		                    </div>
		                    <!--// End Button-Group -->
	                    </div>
	                </div>

	            </div>
	        </div>
	        <!-- End List Page-Body -->

	        <!-- Detail Page-Body -->
	        <div class="row" id='layerDetail' style='position: absolute; display: none; z-index:100' role="dialog">
	            <div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
	                	<h5 class="header-title"><b>권한 상세</b></h5>
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
									  	<td colspan="3" id='l_auth_no'></td>
									</tr>
									<tr>
										<th scope="row">권한명</th>
										<td id='auth_desc' colspan='3'></td>
									</tr>
									<tr>
									    <th scope="row">기본여부</th>
									    <td>
											<select name="bass_yn" id="bass_yn" class="form-control col-md-3 input-sm">
												<option value=""></option>
									        	<option value='Y'>예</option>
									        	<option value='N'>아니오</option>
									    	</select>
									    </td>
									    <th scope="row">사용여부</th>
									    <td>
											<select name="use_yn" id="use_yn" class="form-control col-md-3 input-sm">
												<option value=""></option>
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
	        <div class="row" id="layerAdd" style='position: absolute; display: none; z-index:100' role="dialog">
	            <div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
	                    <h5 class="header-title"><b>권한 신규 등록</b></h5>
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
									  	<th scope="row">권한명</th>
									  	<td colspan="3">
									  		<input class="form-control required" name="new_auth_desc" id="new_auth_desc"  type="text" maxlength="100" />
									  	</td>
									</tr>
									<tr>
									    <th scope="row">기본여부</th>
									    <td colspan="3">
											<select name="new_bass_yn" id="new_bass_yn" class="form-control col-md-3 input-sm">
												<option value=""></option>
									        	<option value='Y'>예</option>
									        	<option value='N' selected>아니오</option>
									    	</select>
									    </td>
									</tr>
									<tr>
									    <th scope="row">사용여부</th>
									    <td colspan="3">
											<select name="new_use_yn" id="new_use_yn" class="form-control col-md-3 input-sm">
												<option value=""></option>
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
	        <div class="row" id="layerAuthList" style='position: absolute; display: none; z-index:100' role="dialog">
	            <div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
						<form id="layerAuthListForm" name="layerAuthListForm" class="form-horizontal">
	                    <h5 class="header-title"><b>프로그램 목록 수정</b></h5>
	                    <div class="table-wrap m-t-30" style='overflow-y:auto; height:400px;'>
	                        <table class="table table-custom table-cen table-num text-center table-hover" id='layerAuthRow' width="100%">
	                            <colgroup>
	                                <col width="5%">
	                                <col width="30%">
	                                <col width="20%">
	                                <col width="15%">
	                                <col width="15%">
	                                <col width="15%">
	                            </colgroup>
		                        <thead>
			                        <tr>
			                            <th>번호</th>
			                            <th>그룹명</th>
			                            <th>레이어명</th>
			                            <th>보기 <input name="toggle_view" id="toggle_view" type="checkbox" /></th>
			                            <th>수정 <input name="toggle_edit" id="toggle_edit" type="checkbox" /></th>
			                            <th>다운로드 <input name="toggle_down" id="toggle_down" type="checkbox" /></th>
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

	    </div>
	</div>

	<c:import url="<%= RequestMappingConstants.WEB_MAIN_FOOTER %>"></c:import>

</body>
</html>