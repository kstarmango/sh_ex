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
    <link href="/jsp/SH/css/bootstrap-treeview.min.css" rel="stylesheet" type="text/css" />

    <!-- jQuery Library -->
	<script src="/jsp/SH/js/jquery.min.js"></script>
	<script src="/jsp/SH/js/bootstrap.min.js"></script>
	<script src="/jsp/SH/js/jquery.validate.min.js"></script>
	<script src="/jsp/SH/js/jquery.validate.extend.js"></script>
	<script src="/jsp/SH/js/moment-with-locales.min.js"></script>
    <script src="/jsp/SH/js/bootstrap-datetimepicker.min.js"></script>
	<script src="/jsp/SH/js/bootstrap-treeview.min.js"></script>

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

		jQuery.fn.center = function () {
			this.css("position","absolute");
			this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()) + "px");
			this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()) + "px");
			return this;
		};

    	if (!String.prototype.padStart) {
    	    String.prototype.padStart = function padStart(targetLength,padString) {
    	        targetLength = targetLength>>0;
    	        padString = String((typeof padString !== 'undefined' ? padString : ' '));
    	        if (this.length > targetLength) {
    	            return String(this);
    	        } else {
    	            targetLength = targetLength-this.length;
    	            if (targetLength > padString.length) {
    	                padString += padString.repeat(targetLength/padString.length);
    	            }
    	            return padString.slice(0,targetLength) + String(this);
    	        }
    	    };
    	}


        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        var defaultData = [
                          	{
                             	text: '등록된 데이터가 없습니다.',
                             	href: '#'  ,
                             	tags: ['']
                           	}
                          ];

		<c:choose>
		<c:when test="${!empty progrmList}">

			defaultData = [];
			var item = {};

			<c:forEach items="${progrmList}" var="result" varStatus="status">

				item =  {
			             	text: '${result.space} <font color="#ff9900">[' + '${result.progrm_order}'.toString().padStart(2, '0') + ']</font> <font color="#00AA40">${result.progrm_nm}</font>' ,
			             	href: '#'  ,
			             	tags: ['${result.progrm_no}#' +
			             	       '${result.p_progrm_no}#' +
			             	       '${result.progrm_order}#' +
			             	       '${result.progrm_nm}#' +
			             	       '${result.progrm_url}#' +
			             	       '${result.progrm_param}#' +
			             	       '${result.progrm_class}#' +
			             	       '${result.progrm_desc}#' +
			             	       '${result.menu_yn}#' +
			             	       '${result.admin_yn}#' +
			             	       '${result.stats_yn}#' +
			             	       '${result.use_yn}#' +
			             	       '${result.ins_user}#' +
			             	       '${result.ins_dt}#' +
			             	       '${result.upd_user}#' +
			             	       '${result.upd_dt}']
			           	};
				defaultData.push(item);

			</c:forEach>
		</c:when>
		</c:choose>

        $('#progrmTreeview').treeview({
            data: defaultData,
            enableLinks:false,
            color: undefined,					// '#000000',
            backColor: undefined,				// '#FFFFFF',
            borderColor: undefined,				// '#dddddd',
            onhoverColor:'#F5F5F5',
            selectedColor:'#000000',
            selectedBackColor:'#dddddd',
            searchResultColor:'#D9534F',
            searchResultBackColor: undefined,	//'#FFFFFF',
            showBorder:true,
            showIcon:true,
            showCheckbox:false,
            showTags:false,
            highlightSelected:true,
            highlightSearchResults:true,
            multiSelect:false
    	});

        $('#progrmTreeview').on('nodeExpanded',function(event, data) {
        });

        $('#progrmTreeview').on('nodeCollapsed',function(event, data) {
        });

        $('#progrmTreeview').on('nodeDisabled',function(event, data) {
        });

        $('#progrmTreeview').on('nodeEnabled',function(event, data) {
        });

        $('#progrmTreeview').on('nodeSelected',function(event, data) {
        	if($('#btnEdit').text() == '저장') {
	    		alert('현재 편집 모드 상태입니다. 취소 후 진행 가능 합니다.');
	    		return;
	    	}

        	var desc = data.tags.toString();
        	var arrDesc = desc.split('#');

        	var progrm_no = arrDesc[0];
        	var p_progrm_no = arrDesc[1];
        	var progrm_order = arrDesc[2];
        	var progrm_nm = arrDesc[3];
        	var progrm_url = arrDesc[4];
        	var progrm_param = arrDesc[5];
        	var progrm_class = arrDesc[6];
        	var progrm_desc = arrDesc[7];
        	var menu_yn = arrDesc[8];
        	var admin_yn = arrDesc[9];
        	var stats_yn = arrDesc[10];
        	var use_yn = arrDesc[11];
        	var ins_user = arrDesc[12];
        	var ins_dt = arrDesc[13];
        	var upd_user = arrDesc[14];
        	var upd_dt = arrDesc[15];

			$("#progrm_no").val(progrm_no);
        	$("#p_progrm_no").val(p_progrm_no);
			$("#progrm_order").val(progrm_order);
        	$("#re_p_progrm_no").val(p_progrm_no);
        	$("#re_progrm_order").append("<option value=" + progrm_order + ">" + progrm_order + "</option>");
			$("#re_progrm_order").val(progrm_order);
			$("#progrm_nm").val(progrm_nm);
			$("#progrm_url").val(progrm_url);
			$("#progrm_param").val(progrm_param);
			$("#progrm_class").val(progrm_class);
			$("#progrm_desc").val(progrm_desc);
			$("#menu_yn").val(menu_yn);
			$("#admin_yn").val(admin_yn);
			$("#stats_yn").val(stats_yn);
			$("#use_yn").val(use_yn);
			$("#ins_user").text(ins_user);
			$("#ins_dt").text(ins_dt);
			$("#upd_user").text(upd_user);
			$("#upd_dt").text(upd_dt);

	        $('#progrmForm *').filter(':input').each(function(){
	        	$(this).attr("readonly", true);
	        });
	        $("#use_yn").prop('disabled',true);
	        $("#menu_yn").prop('disabled',true);
	        $("#admin_yn").prop('disabled',true);
			$("#stats_yn").prop('disabled',true);
			$("#p_progrm_no").prop('disabled',true);
			$("#progrm_order").prop('disabled',true);
			$("#re_p_progrm_no").prop('disabled',true);
			$("#re_progrm_order").prop('disabled',true);

			$("#btnEdit").css('visibility', 'visible');
        });

        $('#progrmTreeview').on('nodeUnselected',function(event, data) {
        });

        $('#progrmTreeview').on('nodeChecked',function(event, data) {
        });

        $('#progrmTreeview').on('nodeUnchecked',function(event, data) {
        });

        $('#progrmTreeview').on('searchComplete',function(event, data) {
        });

        $('#progrmTreeview').on('searchCleared',function(event, data) {
        });

        // 등록 - 팝업
        $('#btnAdd').click(function(e) {
        	
			if($('#p_progrm_no').val() === ''){
				$("#progrmAddForm")[0].reset();
	        	$('#progrmAdd').show();
	        	$('#progrmAdd').center();
	        	$("#new_p_progrm_no").val($('#progrm_no').val()).attr("selected",'selected');
			}else{
				alert('상위 메뉴를 선택해주세요')
			}
        	
        });

        $('#btnAddCancel').click(function(e) {
        	$('#progrmAdd').hide();
        });


		// 수정
        $('#btnEdit').click(function(e) {
        	//alert('기능 지원 예정 입니다.');
        	//return;

        	if($('#btnEdit').text() == '수정')
        	{
		        $('#progrmEditForm *').filter(':input').each(function(){
		        	$(this).attr("readonly", false);
		        });
		        $("#use_yn").prop('disabled',false);
		        $("#menu_yn").prop('disabled',false);
		        $("#admin_yn").prop('disabled',false);
				$("#stats_yn").prop('disabled',true);
				$("#p_progrm_no").prop('disabled',true);
				$("#progrm_order").prop('disabled',true);
				$("#re_p_progrm_no").prop('disabled',false);
				$("#re_progrm_order").prop('disabled',false);
				//$('#btnEditCancel').show();
				$("#btnEditCancel").css('visibility', 'visible');

				$('#btnEdit').text('저장');
        	}
        	else
        	{
				// 저장
				{
					$.ajax({
		  				type : "POST",
		  				async : false,
		  				url : "<%=RequestMappingConstants.WEB_MNG_PROGRM_EDIT%>",
		  				dataType : "json",
		  				data : jQuery("#progrmEditForm").serialize(),
		  				error : function(response, status, xhr){
		  					//if(xhr.status =='403'){
		  						alert('메뉴 정보 업데이트를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
		  					//}
		  				},
		  				success : function(data) {
		  					
		  					window.location.reload();
		  					
		  					//if(data.result == 'Y') {
		  						//window.location.reload();
		  						alert('메뉴 정보가  정상적으로 수정되었습니다.');
		  					//}
		  				}
		  			});
				}

				// 초기화
				$('#progrmEditForm *').filter(':input').each(function(){
			        	$(this).attr("readonly", true);
			    });
		        $("#use_yn").prop('disabled',true);
		        $("#menu_yn").prop('disabled',true);
		        $("#admin_yn").prop('disabled',true);
				$("#stats_yn").prop('disabled',true);
				$("#p_progrm_no").prop('disabled',true);
				$("#progrm_order").prop('disabled',true);
				$("#re_p_progrm_no").prop('disabled',true);
				$("#re_progrm_order").prop('disabled',true);
				$("#progrmEditForm")[0].reset();
				//$('#btnEditCancel').hide();
				$("#btnEditCancel").css('visibility', 'hidden');

        		$('#btnEdit').text('수정');
        	}
        });

		// 수정 - 취소
		$('#btnEditCancel').click(function(e) {
	        $('#progrmEditForm *').filter(':input').each(function(){
	        	$(this).attr("readonly", true);
	        });
	        $("#use_yn").prop('disabled',true);
	        $("#menu_yn").prop('disabled',true);
	        $("#admin_yn").prop('disabled',true);
			$("#stats_yn").prop('disabled',true);
			$("#p_progrm_no").prop('disabled',true);
			$("#progrm_order").prop('disabled',true);
			$("#re_p_progrm_no").prop('disabled',true);
			$("#re_progrm_order").prop('disabled',true);
			//$('#btnEditCancel').hide();
			$("#btnEditCancel").css('visibility', 'hidden');

			$('#btnEdit').text('수정');
		});

		$('#btnEditCancel').trigger("click");
    });
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

			<!-- Detail Page-Body -->
	        <div class="row" id="progrmEdit">
	        	<div class="col-sm-12">
	            	<div class="card-box big-card-box last table-responsive searchResult">

	                    <div class="sysstat-wrap m-t-30 m-b-30">


	                        <div class="row">
	                            <div class="col-sm-4">
	                                <div class="card-box">
					                    <h5 class="header-title"><b>메뉴 목록</b> <span class="small">(전체 <b class="text-orange"><c:out value="${view01Cnt.totalRecordCount}"/></b>건)</span></h5>

                           				<div class="table-wrap m-t-30" style='height: 760px; overflow-y:scroll' id='progrmTreeview'></div>

	                                </div>
	                            </div>
	                            <div class="col-sm-8">
	                                <div class="card-box">
	                                    <h5 class="header-title"><b>메뉴 상세</b></h5>

								        <!-- Edit Page-Body -->
								        <form class="clearfix" id="progrmEditForm" name="progrmEditForm">
								        <input name="progrm_no" id="progrm_no"  type="hidden" />
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
				                                       <th scope="row">상위 메뉴 <span class="text-danger"></span></th>
				                                       <td colspan="1">
															<select name="p_progrm_no" id="p_progrm_no" class="form-control col-md-3 input-sm">
																<option value=''>최 상위 메뉴</option>
															<c:choose>
															<c:when test="${!empty progrmList}">
																<c:forEach items="${progrmList}" var="result" varStatus="status">
																	<option value='${result.progrm_no}'>${result.progrm_nm}</option>
																</c:forEach>
															</c:when>
															</c:choose>
													    	</select>
				                                       </td>
				                                       <th scope="row">변경 상위 메뉴 <span class="text-danger">*</span></th>
				                                       <td colspan="1">
															<select name="re_p_progrm_no" id="re_p_progrm_no" class="form-control col-md-3 input-sm">
																<option value=''>최 상위 메뉴</option>
															<c:choose>
															<c:when test="${!empty progrmList}">
																<c:forEach items="${progrmList}" var="result" varStatus="status">
																	<option value='${result.progrm_no}'>${result.progrm_nm}</option>
																</c:forEach>
															</c:when>
															</c:choose>
													    	</select>
				                                       </td>
				                                   	</tr>
				                                	<tr>
				                                       	<th scope="row">표출 순서 <span class="text-danger"></span></th>
				                                       	<td>
				                                       		<input class="form-control required" name="progrm_order" id="progrm_order"  type="text" maxlength="100" title="순서" placeholder="" />
				                                       	</td>
				                                       	<th scope="row">변경 표출 순서 <span class="text-danger">*</span></th>
				                                       	<td>
				                                       		<select name="re_progrm_order" id="re_progrm_order" class="form-control col-md-3 input-sm" style='width: 50px'>
				                                       		</select>
				                                       		다음으로 순서 변경
				                                       	</td>
				                                    </tr>
				                                	<tr>
				                                       <th scope="row">메뉴명 <span class="text-danger">*</span></th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="progrm_nm" id="progrm_nm"  type="text" maxlength="100" title="메뉴명" placeholder="" />
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">메뉴 연결 URL <span class="text-danger">*</span></th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="progrm_url" id="progrm_url"  type="text" maxlength="512" title="URL" placeholder="" />
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">파라메터</th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="progrm_param" id="progrm_param"  type="text" maxlength="1024" title="파라메터" placeholder="" />
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">CSS Style</th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="progrm_class" id="progrm_class"  type="text" maxlength="1024" title="CSS Style" placeholder="" />
				                                       </td>
				                                   	</tr>
													<tr>
														<th scope="row">메뉴 여부 <span class="text-danger">*</span></th>
														<td>
															<select name="menu_yn" id="menu_yn" class="form-control col-md-3 input-sm" title="메뉴 여부" >
													        	<option value='Y' selected>예</option>
													        	<option value='N'>아니오</option>
													    	</select>
														</td>
														<th scope="row">관리자 여부 <span class="text-danger">*</span></th>
													    <td>
															<select name="admin_yn" id="admin_yn" class="form-control col-md-3 input-sm" title="관리자 여부" >
													        	<option value='Y'>예</option>
													        	<option value='N' selected>아니오</option>
													    	</select>
													    </td>
													</tr>
													<tr>
														<th scope="row">통계 여부 <span class="text-danger">*</span></th>
														<td>
															<select name="stats_yn" id="stats_yn" class="form-control col-md-3 input-sm" disabled title="통계 여부" >
													        	<option value='Y'>예</option>
													        	<option value='N' selected>아니오</option>
													    	</select>
														</td>
														<th scope="row">사용 여부 <span class="text-danger">*</span></th>
													    <td>
															<select name="use_yn" id="use_yn" class="form-control col-md-3 input-sm" title="사용 여부" >
																<option value=""></option>
													        	<option value='Y' selected>예</option>
													        	<option value='N'>아니오</option>
													    	</select>
													    </td>
													</tr>
				                                   	<tr>
				                                       <th scope="row">등록자</th>
				                                       <td id="ins_user"></td>
				                                       <th scope="row">등록일시</th>
				                                       <td id="ins_dt"></td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">수정자</th>
				                                       <td id="upd_user"></td>
				                                       <th scope="row">수정일시</th>
				                                       <td id="upd_dt"></td>
				                                   	</tr>
				                                   	<tr>
					                                    <th scope="row">설명</th>
					                                    <td colspan="3">
					                                    	<textarea name="progrm_desc" id="progrm_desc" rows="6" cols="60" class="form-control" title="설명" placeholder=""  style="resize: none;"></textarea>
					                                	</td>
				                                  	</tr>
				                               	</tbody>
				                       		</table>
					                    </div>
					                    </form>
								       	<!-- End Edit Page-Body -->

				                        <div class="row text-right">
				                            <div class="col-xs-10">
				                            </div>
				                            <div class="col-xs-1">
				                            	<button type="button" class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id='btnEditCancel' style='visibility: hidden'>취소</button>
				                            </div>
				                            <div class="col-xs-1">
												<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnEdit' style='visibility: hidden'>수정</button>
				                            </div>
				                        </div>

	                            	</div>
	                            </div>
	                        </div>

	                        <div class="row text-right">
	                            <div class="col-xs-11">
	                            </div>
	                            <div class="col-xs-1">
									<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnAdd'>신규</button>
	                            </div>
	                        </div>

	                    </div>

	                </div>
	            </div>
	        </div>
			<!-- End Detail Page-Body -->

			<!-- Add Page-Body -->
	        <div class="row"  id="progrmAdd" style='position: absolute; display: none; z-index:100'>
	        	<div class="col-sm-10">
	            	<div class="card-box big-card-box last table-responsive searchResult">

                            <h5 class="header-title"><b>메뉴 신규 등록</b></h5>

					        <form class="clearfix" id="progrmAddForm" name="progrmAddForm">
					        <input name="new_progrm_no" id="new_progrm_no"  type="hidden" />
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
	                                       <th scope="row">상위 메뉴명 <span class="text-danger">*</span></th>
	                                       <td colspan="3">
												<select name="new_p_progrm_no" id="new_p_progrm_no" class="form-control col-md-3 input-sm">
													<option value=''>최 상위 메뉴</option>
												<c:choose>
												<c:when test="${!empty progrmList}">
													<c:forEach items="${progrmList}" var="result" varStatus="status">
														<option value='${result.progrm_no}'>${result.view_progrm_nm}</option>
													</c:forEach>
												</c:when>
												</c:choose>
										    	</select>
	                                       </td>
	                                   	</tr>
	                                	<tr>
	                                       <th scope="row">표출 순서 <span class="text-danger">*</span></th>
	                                       <td colspan="3">
	                                       		<select name="new_progrm_order" id="new_progrm_order" class="form-control col-md-3 input-sm" title="메뉴 여부" >
										    	</select>
	                                       </td>
	                                   	</tr>
	                                	<tr>
	                                       <th scope="row">메뉴명 <span class="text-danger">*</span></th>
	                                       <td colspan="3">
	                                       <input class="form-control required" name="new_progrm_nm" id="new_progrm_nm"  type="text" maxlength="100" title="메뉴명" placeholder="" />
	                                       </td>
	                                   	</tr>
	                                   	<tr>
	                                       <th scope="row">메뉴 연결 URL <span class="text-danger">*</span></th>
	                                       <td colspan="3">
	                                       <input class="form-control required" name="new_progrm_url" id="new_progrm_url"  type="text" maxlength="512" title="URL" placeholder="" />
	                                       </td>
	                                   	</tr>
	                                   	<tr>
	                                       <th scope="row">파라메터</th>
	                                       <td colspan="3">
	                                       <input class="form-control required" name="new_progrm_param" id="new_progrm_param"  type="text" maxlength="1024" title="파라메터" placeholder="" />
	                                       </td>
	                                   	</tr>
	                                   	<tr>
	                                       <th scope="row">CSS Style</th>
	                                       <td colspan="3">
	                                       <input class="form-control required" name="new_progrm_class" id="new_progrm_class"  type="text" maxlength="1024" title="CSS Style" placeholder="" />
	                                       </td>
	                                   	</tr>
										<tr>
											<th scope="row">메뉴 여부 <span class="text-danger">*</span></th>
											<td>
												<select name="new_menu_yn" id="new_menu_yn" class="form-control col-md-3 input-sm" title="메뉴 여부" >
										        	<option value='Y' selected>예</option>
										        	<option value='N'>아니오</option>
										    	</select>
											</td>
											<th scope="row">관리자 여부 <span class="text-danger">*</span></th>
										    <td>
												<select name="new_admin_yn" id="new_admin_yn" class="form-control col-md-3 input-sm" title="관리자 여부" >
										        	<option value='Y'>예</option>
										        	<option value='N' selected>아니오</option>
										    	</select>
										    </td>
										</tr>
										<tr>
											<th scope="row">통계 여부 <span class="text-danger">*</span></th>
											<td>
												<select name="new_stats_yn" id="new_stats_yn" class="form-control col-md-3 input-sm" disabled title="통계 여부" >
										        	<option value='Y'>예</option>
										        	<option value='N' selected>아니오</option>
										    	</select>
											</td>
											<th scope="row">사용 여부 <span class="text-danger">*</span></th>
										    <td>
												<select name="new_use_yn" id="new_use_yn" class="form-control col-md-3 input-sm" title="사용 여부" >
													<option value=""></option>
										        	<option value='Y' selected>예</option>
										        	<option value='N'>아니오</option>
										    	</select>
										    </td>
										</tr>
	                                   	<tr>
		                                    <th scope="row">설명</th>
		                                    <td colspan="3">
		                                    	<textarea name="new_progrm_desc" id="new_progrm_desc" rows="6" cols="60" class="form-control" title="설명" placeholder="" style="resize: none;"></textarea>
		                                	</td>
	                                  	</tr>
	                               	</tbody>
	                       		</table>
		                    </div>
		                    </form>

		                    <div>
	                           	<div class="btn-wrap pull-left">
	                           		<button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id="btnAddSave" type="button">저장</button>
	                          	</div>
	                           	<div class="btn-wrap pull-right">
	                               <button class="btn btn-custom btn-md pull-right searchBtn" id="btnAddCancel" type="button">닫기</button>
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