<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

	<link rel="stylesheet" href="<c:url value='/resources/css/util/bootstrap/bootstrap-treeview.min.css'/>" >
	<script  src="<c:url value='/resources/js/util/bootstrap/bootstrap-treeview.min.js'/>"></script> 
	
    <!-- App css -->
    <link rel="stylesheet" href="<c:url value='/resources/css/util/editor/ap-image-zoom.css'/>" >
    <link rel="stylesheet" href="<c:url value='/resources/css/util/editor/ap-image-fullscreen.css'/>" >
    <link rel="stylesheet" href="<c:url value='/resources/css/util/editor/ap-image-fullscreen-themes.css'/>" >
    <link rel="stylesheet" href="<c:url value='/resources/css/util/jquery/jquery-gallery.css'/>" >
    
    <!-- jQuery Library -->
    <script src="<c:url value='/resources/js/util/editor/ap-image-zoom.js'/>"></script>
    <script src="<c:url value='/resources/js/util/editor/ap-image-fullscreen.js'/>"></script>
    <script src="<c:url value='/resources/js/util/jquery/jquery-gallery.js'/>"></script>
    <script src="<c:url value='/resources/js/util/editor/screenfull.min.js'/>"></script>

	<script>

	// 초기화 및 이벤트 등록
	$(document).ready(function() {

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
		// 서버 관련

        var defaultData4 = [
                          	{
                             	text: '등록된 데이터가 없습니다.',
                             	href: '#'  ,
                             	tags: [ '' ]
                           	}
                          ];

		// 리스트 선택
        function fn_server_node_selected(event, data) {
        	if($('#btnServerEdit').text() == '저장') {
	    		alert('현재 편집 모드 상태입니다. 취소 후 진행 가능 합니다.');
	    		return;
	    	}

        	var desc = data.tags.toString();
        	var arrDesc = desc.split('#');

        	$("#m_server_no").val(      arrDesc[0]);
        	$("#m_server_cd").val(      arrDesc[1]);
        	$("#m_server_nm").val(      arrDesc[2]);
        	$("#server_url").val(       arrDesc[3]);
        	$("#server_desc").val(      arrDesc[4]);
        	$("#server_user_id").val(   arrDesc[5]);
        	$("#server_user_pwd").val(  arrDesc[6]);
        	$("#server_workspace").val( arrDesc[7]);
        	$("#server_ins_user").text( arrDesc[10]);
        	$("#server_ins_dt").text(   arrDesc[11]);
        	$("#server_upd_user").text( arrDesc[12]);
        	$("#server_upd_dt").text(   arrDesc[13]);

	        $('#serverEditForm *').filter(':input').each(function(){
	        	$(this).attr("readonly", true);
	        });
			$("#btnServerEdit").css('visibility', 'visible');
        }

        // 리스트
        function fn_server_reload() {
  			$.ajax({
  				type : "POST",
  				async : false,
  				url : "<%=RequestMappingConstants.WEB_MNG_SERVER_LIST%>",
  				dataType : "json",
  				data : '',
  				error : function(response, status, xhr){
  					if(xhr.status =='403'){
  						alert('서버정보 업데이트를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
  					}
  				},
  				success : function(data) {
					defaultData4 = [];
					var item = {};
					for(i=0; i<data.serverInfo.length;i++)
					{
						item =  {
					             	text: '<font color="#ff9900">[' + data.serverInfo[i].no.toString().padStart(2, '0') + ']</font> <font color="#00AA40">'+ data.serverInfo[i].server_nm + '</font>' ,
					             	href: '#'  ,
		                         	tags: [ data.serverInfo[i].server_no + '#' +
		                         	        data.serverInfo[i].server_cd + '#' +
		                         	        data.serverInfo[i].server_nm + '#' +
		                         	       	data.serverInfo[i].server_url + '#' +
		                         	      	data.serverInfo[i].server_desc + '#' +
		                         	     	data.serverInfo[i].user_id + '#' +
		                         	    	data.serverInfo[i].user_pwd + '#' +
		                         	   		data.serverInfo[i].workspace + '#' +
		                         	  		data.serverInfo[i].server_type + '#' +
		                         	 		data.serverInfo[i].server_type_desc + '#' +
		                         			data.serverInfo[i].ins_user + '#' +
		                         			data.serverInfo[i].ins_dt + '#' +
		                         			data.serverInfo[i].upd_user + '#' +
		                         			data.serverInfo[i].upd_dt ]
					           	};
						defaultData4.push(item);
					}
					$("#serverListCount").text(data.serverInfo.length);

					$('#serverTreeView').empty();
					$('#serverTreeView').treeview({
			            data: defaultData4,
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
					$('#serverTreeView').on('nodeSelected', fn_server_node_selected);
  				}
  			});
        }

        fn_server_reload();

 		// 수정 - 저장
        $('#btnServerEdit').click(function(e) {
        	if($('#btnServerEdit').text() == '수정')
        	{
		        $('#serverEditForm *').filter(':input').each(function(){
		        	$(this).attr("readonly", false);
		        });
				$("#btnServerEditCancel").css('visibility', 'visible');

				$('#btnServerEdit').text('저장');
        	}
        	else
        	{
				// 저장
	  			$.ajax({
	  				type : "POST",
	  				async : false,
	  				url : "<%=RequestMappingConstants.WEB_MNG_SERVER_EDIT%>",
	  				dataType : "json",
	  				data : jQuery("#serverEditForm").serialize(),
	  				error : function(response, status, xhr){
	  					if(xhr.status =='403'){
	  						alert('서버정보 업데이트를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
	  					}
	  				},
	  				success : function(data) {
				        if(data.result == "Y" && data.serverInfo == "1") {
				        	fn_server_reload();
				        	alert('정보 변경이 정상적으로 완료 되었습니다.');
				        }
	  				}
	  			});

				// 초기화
				$('#serverEditForm')[0].reset();
				$('#serverEditForm *').filter(':input').each(function(){
			        	$(this).attr("readonly", true);
			    });
				$("#btnServerEditCancel").css('visibility', 'hidden');
				$("#btnServerEdit").css('visibility', 'hidden');

        		$('#btnServerEdit').text('수정');
        	}
        });

		// 수정 - 취소
		$('#btnServerEditCancel').click(function(e) {
			$('#serverEditForm *').filter(':input').each(function(){
	        	$(this).attr("readonly", true);
		    });
			$("#btnServerEditCancel").css('visibility', 'hidden');

			$('#btnServerEdit').text('수정');
		});

		$('#btnServerEditCancel').trigger("click");

		// 등록
		$('#btnServerAdd').click(function(e) {
			$('#serverAddForm')[0].reset();
			$('#serverAdd').modal('show'); 
			$('#serverAdd').show();
        	$('#serverAdd').center();

		});

		// 등록 - 저장
		$('#btnServerAddSave').click(function(e) {
  			$.ajax({
  				type : "POST",
  				async : false,
  				url : "<%=RequestMappingConstants.WEB_MNG_SERVER_ADD%>",
  				dataType : "json",
  				data : jQuery("#serverAddForm").serialize(),
  				error : function(response, status, xhr){
  					if(xhr.status =='403'){
  						alert('서버정보 신규 등록을  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
  					}
  				},
  				success : function(data) {
			        if(data.result == "Y" && data.serverInfo != "") {
			        	$('#serverAdd').modal('hide'); 
			        	$('#serverAdd').hide();

			        	fn_server_reload();
			        	alert('서버정보가 정상적으로 등록 되었습니다.');
			        }
  				}
  			});
		});

		// 등록 - 취소
		$('#btnServerAddClose').click(function(e) {
			$('#serverAdd').modal('hide'); 
			$('#serverAdd').hide();
		});

		$('#serverOpen').click(function(e) {
			if($('#server_url').val() != '') {
				window.open($('#server_url').val(), '_blank');
			}
		});

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
    });
	</script>

	<div class="contWrap">
        <h1>${sesMenuNavigation.progrm_nm}</h1>
        <div class="whiteCont">
        	<p class="pageNav">
                <a href="<%=RequestMappingConstants.WEB_MAIN%>">HOME</a> &nbsp;&nbsp; |  &nbsp;&nbsp;  <a href="<%=RequestMappingConstants.WEB_MNG_USER%>">${sesMenuNavigation.p_progrm_nm}</a>  &nbsp;&nbsp;  |  &nbsp;&nbsp;  	${sesMenuNavigation.progrm_nm}
            </p>

			<!-- Server Detail Page-Body -->
	        <div class="row hei_100" id="serverEdit">
	        	<div class="col-sm-12 hei_100">
	            	<div class="card-box big-card-box last table-responsive searchResult hei_100" style= "padding-bottom: 0px;">

	                    <div class="sysstat-wrap">

	                        <div class="row">
	                            <div class="col-sm-4">
	                                <div class="card-box">
					                    <h5 class="header-title"><b>서버 목록</b> <span class="small">(전체 <b class="text-orange"><span id='serverListCount'>0</span></b>건)</span></h5>

                           				<div class="table-wrap m-t-30" style='height: 540px; overflow-y: auto' id='serverTreeView'></div>

	                                </div>
	                            </div>
	                            <div class="col-sm-8">
	                                <div class="card-box">
	                                    <h5 class="header-title"><b>서버 상세</b></h5>

								        <!-- Edit Page-Body -->
								        <form class="clearfix" id="serverEditForm" name="serverEditForm">
								        <input class="form-control required" name="m_server_no" id="m_server_no"  type="hidden" title="서버 NO.">
					                    <div class="table-wrap m-t-30">
					                        <table class="table table-custom table-cen table-num text-center table-hover" >
					                        	<caption class="none">서버 상세 테이블</caption>
					                            <colgroup>
					                            	<col style="width:20%">
				                        			<col style="width:30%">
				                        			<col style="width:20%">
				                        			<col style="width:30%">
					                            </colgroup>
					                            <tbody>
													<tr>
				                                       <th scope="row">서버명 <span class="text-danger"></span></th>
				                                       <td>
				                                       		<input class="form-control required" name="m_server_nm" id="m_server_nm"  type="text" maxlength="100" title="서버명" placeholder="">
				                                       </td>
													    <th scope="row">서버유형</th>
													    <td>
															<select name="m_server_cd" id="m_server_cd" class="form-control col-md-3 input-sm" title="서버유형">
																<!-- <option value=""></option> -->
				                                         	<c:forEach var="item1" items="${serverType}">
				                                         		<option value="${fn:trim(item1.code)}">${fn:trim(item1.code_nm)}</option>
				                                         	</c:forEach>
				                                         	</select>
													    </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">서버 URL <span class="text-danger"></span></th>
				                                       <td colspan="2">
				                                       <input class="form-control required" name="server_url" id="server_url"  type="text" maxlength="512" title="서버 URL" placeholder="">
				                                       </td>
				                                       <td id='serverOpen'>
				                                       	서버연결
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">서버설명 <span class="text-danger"></span></th>
				                                       <td colspan="3">
				                                       		<textarea name="server_desc" id="server_desc" rows="2" cols="20" class="form-control" title="서버설명" placeholder=""  style="resize: none;"></textarea>
				                                       </td>
				                                   	</tr>
													<tr>
				                                       <th scope="row">사용자 ID <span class="text-danger"></span></th>
				                                       <td>
				                                       		<input class="form-control required" name="server_user_id" id="server_user_id"  type="text" maxlength="32" title="사용자 ID" placeholder="">
				                                       </td>
				                                       <th scope="row">사용자 암호 <span class="text-danger"></span></th>
				                                       <td>
				                                       		<input class="form-control required" name="server_user_pwd" id="server_user_pwd"  type="text" maxlength="64" title="사용자 암호" placeholder="">
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">작업공간 <span class="text-danger"></span></th>
				                                       <td colspan="3">
				                                       		<input class="form-control required" name="server_workspace" id="server_workspace"  type="text" maxlength="512" title="작업공간" placeholder="">
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">등록자</th>
				                                       <td id="server_ins_user"></td>
				                                       <th scope="row">등록일시</th>
				                                       <td id="server_ins_dt"></td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">수정자</th>
				                                       <td id="server_upd_user"></td>
				                                       <th scope="row">수정일시</th>
				                                       <td id="server_upd_dt"></td>
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
				                            	<button type="button" class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id='btnServerEditCancel' style='visibility: hidden'>취소</button>
				                            </div>
				                            <div class="col-xs-1">
												<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnServerEdit' style='visibility: hidden'>수정</button>
				                            </div>
				                        </div>

	                            	</div>
	                            </div>
	                        </div>

	                        <div class="row text-right">
	                            <div class="col-xs-10">
	                            </div>
	                            <div class="col-xs-1">
									<button type="button" class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id='btnServerAddCancel' style='visibility: hidden'>취소</button>
	                            </div>
	                            <div class="col-xs-1">
									<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnServerAdd'>신규</button>
	                            </div>
	                        </div>

	                    </div>

	                </div>
	            </div>
	        </div>
			<!-- End Server Detail Page-Body -->
			
		</div>
	</div>
	
<!-- Server Add Page-Body -->
<div class="row" id="serverAdd" style='display: none;z-index: 100;'>
	<div class="col-sm-12">
   		<div class="card-box big-card-box last table-responsive searchResult">
        	<h5 class="header-title"><b>서버 신규 등록</b></h5>
		   <!-- Edit Page-Body -->
		   <form class="clearfix" id="serverAddForm" name="serverAddForm">
			<div class="table-wrap m-t-30">
                <table class="table table-custom table-cen table-num text-center table-hover" >
                	<caption class="none">서버 신규 등록 테이블</caption>
                    <colgroup>
                    	<col style="width:20%">
               			<col style="width:30%">
               			<col style="width:20%">
               			<col style="width:30%">
                    </colgroup>
                    <tbody>
						<tr>
	                        <th scope="row">서버명 <span class="text-danger"></span></th>
	                        <td>
	                        		<input class="form-control required" name="new_server_nm" id="new_server_nm"  type="text" maxlength="100" title="서버명" placeholder="">
	                        </td>
						    <th scope="row">서버유형</th>
						    <td>
								<select name="new_server_cd" id="new_server_cd" class="form-control col-md-3 input-sm" title="서버유형">
									<!-- <option value=""></option> -->
                                	<c:forEach var="item1" items="${serverType}">
                                		<option value="${fn:trim(item1.code)}">${fn:trim(item1.code_nm)}</option>
                                	</c:forEach>
                               	</select>
    						</td>
                       	</tr>
                       	<tr>
                           <th scope="row">서버 URL <span class="text-danger"></span></th>
                           <td colspan="3">
                           <input class="form-control required" name="new_server_url" id="new_server_url"  type="text" maxlength="512" title="서버 URL" placeholder="">
                           </td>
                       	</tr>
                       	<tr>
                           <th scope="row">서버설명 <span class="text-danger"></span></th>
                           <td colspan="3">
                           		<textarea name="new_server_desc" id="new_server_desc" rows="2" cols="20" class="form-control" title="서버설명" placeholder=""  style="resize: none;"></textarea>
                           </td>
                       	</tr>
						<tr>
	                        <th scope="row">사용자 ID <span class="text-danger"></span></th>
	                        <td>
	                        		<input class="form-control required" name="new_user_id" id="new_user_id"  type="text" maxlength="32" title="사용자 ID" placeholder="">
	                        </td>
	                        <th scope="row">사용자 암호 <span class="text-danger"></span></th>
	                        <td>
	                        		<input class="form-control required" name="new_user_pwd" id="new_user_pwd"  type="text" maxlength="64" title="사용자 암호" placeholder="">
	                        </td>
                    	</tr>
                       	<tr>
                           <th scope="row">작업공간 <span class="text-danger"></span></th>
                           <td colspan="3">
                           		<input class="form-control required" name="new_workspace" id="new_workspace"  type="text" maxlength="512" title="작업공간" placeholder="" >
                           </td>
                       	</tr>
                   	</tbody>
           		</table>
            </div>
		</form>
		<!-- End Edit Page-Body -->
         <div>
               	<div class="btn-wrap pull-left">
               		<button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id="btnServerAddSave" type="button">저장</button>
              	</div>
               	<div class="btn-wrap pull-right">
                   <button class="btn btn-custom btn-md pull-right searchBtn" id="btnServerAddClose" type="button">닫기</button>
               	</div>
         </div>
	</div>
    </div>
</div>
<!-- End Server Add Page-Body -->
