<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>



	<link rel="stylesheet" href="<c:url value='/resources/css/util/bootstrap/bootstrap-treeview.min.css'/>">
	<script src="<c:url value='/resources/js/util/bootstrap/bootstrap-treeview.min.js'/>"></script> 
	

	<script>
		var defaultorder;
		var defaultpcode;
	// 초기화 및 이벤트 등록
	$(document).ready(function() {
		
		$('#codeEditForm *').filter(':input').each(function(){
        	$(this).attr("readonly", true);
        });

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
		// 레이어 관련
        var defaultData2 = [
                          	{
                             	text: '등록된 데이터가 없습니다.',
                             	href: '#'  ,
                             	tags: [ '' ]
                           	}
                          ];

		<c:choose>
		<c:when test="${!empty codeList}">

			defaultData2 = [];
			var item = {};

			<c:forEach items="${codeList}" var="result" varStatus="status">

				item =  {
			             	text: '${result.space} <font color="#ff9900">[' + '${result.code_order}'.toString().padStart(2, '0') + ']</font> <font color="#00AA40">${result.code_nm}</font>' ,
			             	href: '#'  ,
                         	tags: [ '${result.code}#' +
									'${result.p_code}#' +
									'${result.code_nm}#' +
									'${result.code_desc}#' +
									'${result.code_order}#' +
									'${result.use_yn}#' +
				             	    '${result.ins_user}#' +
				             	    '${result.ins_dt}#' +
				             	    '${result.upd_user}#' +
				             	    '${result.upd_dt}']
			           	};
				defaultData2.push(item);

			</c:forEach>
		</c:when>
		</c:choose>

        $('#codeTreeView').treeview({
            data: defaultData2,
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

        $('#codeTreeView').on('nodeExpanded',function(event, data) {
        });

        $('#codeTreeView').on('nodeCollapsed',function(event, data) {
        });

        $('#codeTreeView').on('nodeDisabled',function(event, data) {
        });

        $('#codeTreeView').on('nodeEnabled',function(event, data) {
        });

        $('#codeTreeView').on('nodeSelected',function(event, data) {
        	$('#code_order').empty();
        	$('#p_code').empty();
        	if($('#btnCodeEdit').text() == '저장') {
	    		alert('현재 편집 모드 상태입니다. 취소 후 진행 가능 합니다.');
	    		return;
	    	}

        	var desc = data.tags.toString();
        	var arrDesc = desc.split('#');

        	$("#code").val(arrDesc[0]);
        	
        	$.ajax({
  				type : "POST",
  				async : false,
  				url : "<%=RequestMappingConstants.WEB_MNG_P_CODE_SET%>",
  				dataType : "json",
  				data : jQuery("#codeEditForm").serialize(),
  				error : function(response, status, xhr){
  					//if(xhr.status =='403'){
  						//alert('코드 정보 업데이트를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
  					//}
  				},
  				success : function(data) {
  					console.log(data);
  					var pcodelist = data.pcodelist;
  					
  					$('#p_code').empty();
  					
  					$("#p_code").append('<option value="">상위 코드</option>');
  					$.each(pcodelist, function(key, value){
  						$("#p_code").append('<option value=' + value.code + '>' + value.code + '</option>');
  						console.log(value.code);
  	                });
  					if(arrDesc[1] != null){
  						$("#p_code").val(arrDesc[1]).attr("selected",'selected');
  					}else{
  						
  					}
  				}
  			});
        	defaultpcode = arrDesc[1];
        	console.log("default_pcode"+defaultpcode);
        	//$("#p_code").val(      arrDesc[1]);
        	$("#code_nm").val(     arrDesc[2]);
        	$("#code_desc").val(   arrDesc[3]);
        	
        	$.ajax({
  				type : "POST",
  				async : false,
  				url : "<%=RequestMappingConstants.WEB_MNG_CODE_ORDER_SET%>",
  				dataType : "json",
  				data : jQuery("#codeEditForm").serialize(),
  				error : function(response, status, xhr){
  					//if(xhr.status =='403'){
  						//alert('코드 정보 업데이트를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
  					//}
  				},
  				success : function(data) {
  					var codeorder = data.orderlist;
  					var maxorder = data.maxorder;
  					
  					console.log("codeorder : "+codeorder);
  					console.log("maxorder : "+maxorder);
  					
  					$("#code_order").append('<option value='+arrDesc[4]+' selected>'+ arrDesc[4]+'</option>');
  					
  					if(codeorder !== undefined){
  						$('#code_order').empty();
  						for(i=1; codeorder-1 >= i; i++){
  							$("#code_order").append('<option value='+i+' selected>'+i+'</option>');
  						}
  					}else{
  						$('#code_order').empty();
  						for(i=1; maxorder-1 >= i; i++){
  							$("#code_order").append('<option value='+i+' selected>'+i+'</option>');
  						}
  					}
  					
  					if(arrDesc[1] != null){
  						$("#code_order").val(arrDesc[4]).attr("selected",'selected');
  					}else{
  						
  					}
  				}
  			});
        	
        	defaultorder = arrDesc[4];
        	//$("#code_order").append('<option value=' + arrDesc[4] + ' selected>' + arrDesc[4] + '</option>');
        	//$("#code_order").val(  arrDesc[4]);
        	$("#use_yn").val(      arrDesc[5]);
        	$("#ins_user").text(   arrDesc[6]);
        	$("#ins_dt").text(     arrDesc[7]);
        	$("#upd_user").text(   arrDesc[8]);
        	$("#upd_dt").text(     arrDesc[9]);
        	
        	$('#p_code').change(function(e) {
            	console.log(jQuery("#p_code option:selected").val());
            	$.ajax({
      				type : "POST",
      				async : false,
      				url : "<%=RequestMappingConstants.WEB_MNG_CODE_ORDER_SET%>",
      				dataType : "json",
      				data : {"p_code":jQuery("#p_code option:selected").val()},
      				success : function(data) {
      					console.log(data);
      					var codeorder = data.orderlist;
      					var maxorder = data.maxorder;
      					
      					$('#p_code').val();
      					
      					if($('#p_code').val() !== ''){
      						$('#code_order').empty();
      						for(i=1; codeorder-1 >= i; i++){
      							$("#code_order").append('<option value='+i+' selected>'+i+'</option>');
      						}
      					}else{
      						$('#code_order').empty();
      						for(i=1; maxorder-1 >= i; i++){
      							$("#code_order").append('<option value='+i+' selected>'+i+'</option>');
      						}
      						
      						
      					}
      					
      					
      				}
      			});
    		})
        	
	        $('#codeEditForm *').filter(':input').each(function(){
	        	$(this).attr("readonly", true);
	        });
			$("#btnCodeEdit").css('visibility', 'visible');
			$("#btnCodeDelete").show();
        });

        // 등록 - 팝업
        $('#btnCodeAdd').click(function(e) {
        	//alert('기능 지원 예정 입니다.');
        	//return;
        	$('#new_code').attr("readonly", true);
        	
        	var p_code = $('#code').val();
        	
			if($('#p_code').val() == '' || $('#p_code').val() == undefined){
				$("#codeAddForm")[0].reset();
				$('#codeAdd').modal('show'); 
	        	$('#codeAdd').show();
	        	$('#codeAdd').center();
	        	
	        	$.ajax({
	  				type : "POST",
	  				async : false,
	  				url : "<%=RequestMappingConstants.WEB_MNG_CODE_ADD_SETTING%>",
	  				dataType : "json",
	  				data : jQuery("#codeEditForm").serialize(),
	  				error : function(response, status, xhr){
	  					//if(xhr.status =='403'){
	  						//alert('코드 정보 업데이트를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
	  					//}
	  				},
	  				success : function(data) {
	  					var codeorder = data.orderlist;
	  					var pcodelist = data.pcodelist;
	  					var maxorder = data.maxorder;
	  					console.log(data);
	  					
	  					$('#new_p_code').empty();
	  					$('#new_code_order').empty();
	  					$('#new_code').val(data.topcode);
	  					
	  					
	  					
	  					if($('#new_p_code').val() == null){
	  						console.log('들어오나요');
      						console.log(maxorder);
      						$('#new_code_order').empty();
      						for(i=1; maxorder >= i; i++){
      							$("#new_code_order").append('<option value='+i+' selected>'+i+'</option>');
      						}
	  					}
	  					
	  					if(codeorder !== undefined){
	  						$('#new_code_order').empty();
	  						console.log('codeorder : '+codeorder);
	  						for(i=1; codeorder >= i; i++){
	  							console.log('i 확인 : '+i)
      							$("#new_code_order").append('<option value='+i+' selected>'+i+'</option>');
      						}
	  					}else{
	  						
	  					}
	  					
	  					
	  					$("#new_p_code").append('<option value="">상위코드로 등록</option>');
	  					$.each(pcodelist, function(key, value){
	  						$("#new_p_code").append('<option value=' + value.code + '>' + value.code + '</option>');
	  						console.log(value.code);
	  	                });
	  					if($('#code').val() != null){
	  						$("#new_p_code").val($('#code').val()).attr("selected",'selected');
	  					}else{
	  						
	  					}
	  				}
	  			});
	        	
	        	$('#new_p_code').val(p_code);
	        	
			}else{
				alert('상위 메뉴를 선택해주세요');
			}
        	
        });
        
        $('#new_p_code').change(function(e) {
        	console.log(jQuery("#new_p_code option:selected").val());
        	$.ajax({
  				type : "POST",
  				async : false,
  				url : "<%=RequestMappingConstants.WEB_MNG_CODE_ORDER_CHANGE%>",
  				dataType : "json",
  				data : {"new_p_code":jQuery("#new_p_code option:selected").val()},
  				success : function(data) {
  					console.log(data);
  					var codeorder = data.orderlist;
  					var maxorder = data.maxorder;
  					$('#new_p_code').val();
  					
  					
  					$('#new_code_order').empty();
  					if($('#new_p_code').val() !== ''){
  						for(i=1; codeorder >= i; i++){
  							$("#new_code_order").append('<option value='+i+' selected>'+i+'</option>');
  						}
  					}else{
  						console.log('들어오나요');
  						console.log(maxorder);
  						$('#new_code_order').empty();
  						for(i=1; maxorder >= i; i++){
  							$("#new_code_order").append('<option value='+i+' selected>'+i+'</option>');
  						}
  					}
  				}
  			});
		})
		
		
		 $('#btnAddSave').click(function(e) {
			 $.ajax({
	  				type : "POST",
	  				async : false,
	  				url : "<%=RequestMappingConstants.WEB_MNG_CODE_ADD%>",
	  				dataType : "json",
	  				data : jQuery("#codeAddForm").serialize(),
	  				success : function(data) {
	  					console.log(data);
	  					$('#codeAdd').modal('hide'); 
	  					$('#codeAdd').hide();
	  					alert('코드가 정상적으로 추가되었습니다.');
						window.location.reload();
						
	  				}
	  			});
        });
		
		

        $('#btnCodeAddCancel').click(function(e) {
        	$('#codeAdd').hide();
        });

 		// 수정
        $('#btnCodeEdit').click(function(e) {
        	$("#btnCodeDelete").hide();
        	/* alert('기능 지원 예정 입니다.');
        	return; */
        	

        	if($('#btnCodeEdit').text() == '수정')
        	{
        		
		        $('#codeEditForm *').filter(':input').each(function(){
		        	$(this).attr("readonly", false);
		        });
		        $('#code').attr("readonly", true);
				$("#btnCodeEditCancel").css('visibility', 'visible');

				$('#btnCodeEdit').text('저장');
        	}
        	else
        	{
				// 저장
				{
					$.ajax({
		  				type : "POST",
		  				async : false,
		  				url : "<%=RequestMappingConstants.WEB_MNG_CODE_EDIT%>",
		  				dataType : "json",
		  				data : jQuery("#codeEditForm").serialize()+"&defaultorder="+defaultorder+"&defaultpcode="+defaultpcode,
		  				error : function(response, status, xhr){
		  					//if(xhr.status =='403'){
		  						alert('코드 정보 업데이트를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
		  					//}
		  				},
		  				success : function(data) {
		  					console.log(jQuery("#codeEditForm").serialize());
		  					console.log("defaultpcode : "+defaultpcode);
		  					window.location.reload();
		  					
		  					//if(data.result == 'Y') {
		  						//window.location.reload();
		  						alert('코드 정보가  정상적으로 수정되었습니다.');
		  					//}
		  				}
		  			});
				}

				// 초기화
				$('#codeEditForm *').filter(':input').each(function(){
			        	$(this).attr("readonly", true);
			    });
				$("#btnCodeEditCancel").css('visibility', 'hidden');

        		$('#btnCodeEdit').text('수정');
        	}
        });

		// 수정 - 취소
		$('#btnCodeEditCancel').click(function(e) {
			$("#btnCodeDelete").show();
			$('#codeEditForm *').filter(':input').each(function(){
	        	$(this).attr("readonly", true);
		    });
			$("#btnCodeEditCancel").css('visibility', 'hidden');
			$('#btnCodeEdit').text('수정');
			
			
		});
		
		$('#btnCodeDelete').click(function(e) {
			$.ajax({
  				type : "POST",
  				async : false,
  				url : "<%=RequestMappingConstants.WEB_MNG_CODE_DELETE%>",
  				dataType : "json",
  				data : jQuery("#codeEditForm").serialize(),
  				error : function(response, status, xhr){
  					alert('코드 정보 업데이트를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
  				},
  				success : function(data) {
  					window.location.reload();
  					alert('코드 정보가  정상적으로 삭제되었습니다.');
  				}
  			});
		});
		
		 $('#btnAddCancel').click(function(e) {
			 	$('#codeAdd').modal('hide'); 
	        	$('#codeAdd').hide();
	        });

		//$('#btnCodeEditCancel').trigger("click");
		
    });
	</script>

	<div class="contWrap">
        <h1>${sesMenuNavigation.progrm_nm}</h1>
        <div class="whiteCont">
        	<p class="pageNav">
                <a href="<%=RequestMappingConstants.WEB_MAIN%>">HOME</a> &nbsp;&nbsp; |  &nbsp;&nbsp;  <a href="<%=RequestMappingConstants.WEB_MNG_USER%>">${sesMenuNavigation.p_progrm_nm}</a>  &nbsp;&nbsp;  |  &nbsp;&nbsp;  	${sesMenuNavigation.progrm_nm}
            </p> 
            
            <!-- Code Detail Page-Body -->
	        <div class="row hei_100" id="codeEdit" style='display: block;'>
	        	<div class="col-sm-12 hei_100">
	            	<div class="card-box big-card-box last table-responsive searchResult hei_100" style="padding-bottom: 0px;">

	                    <div class="sysstat-wrap">

	                        <div class="row">
	                            <div class="col-sm-4">
	                                <div class="card-box">
					                    <h5 class="header-title"><b>코드 목록</b> <span class="small">(전체 <b class="text-orange"><c:out value="${view01Cnt.totalRecordCount}"/></b>건)</span></h5>

                           				<div class="table-wrap m-t-30" style='height: 590px; overflow-y:auto' id='codeTreeView'></div>

	                                </div>
	                            </div>
	                            <div class="col-sm-8">
	                                <div class="card-box">
	                                    <h5 class="header-title"><b>코드 상세</b></h5>

								        <!-- Edit Page-Body -->
								        <form class="clearfix" id="codeEditForm" name="codeEditForm">
					                    <div class="table-wrap m-t-30">
					                        <table class="table table-custom table-cen table-num text-center table-hover" >
					                        	<caption class="none">코드 상세 테이블</caption>
					                            <colgroup>
					                            	<col style="width:20%">
				                        			<col style="width:30%">
				                        			<col style="width:20%">
				                        			<col style="width:30%">
					                            </colgroup>
					                            <tbody>
				                                	<tr>
				                                       <th scope="row">코드 NO. <span class="text-danger">*</span></th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="code" id="code"  type="text" maxlength="20" title="그룹 NO." placeholder="">
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">상위 코드 NO. <span class="text-danger">*</span></th>
				                                       <td>
				                                       	<select name="p_code" id="p_code" class="form-control col-md-3 input-sm" title="상위코드 NO.">
													    </select>
				                                      <!--  <input class="form-control required" name="p_code" id="p_code"  type="text" maxlength="20" title="상위 그룹 NO." placeholder="" /> -->
				                                       </td>
				                                       <th scope="row">표출 순서</th>
				                                       <td>
				                                       		<select name="code_order" id="code_order" class="form-control col-md-3 input-sm" title="표출순서">
													    	</select>
				                                       <!-- <input class="form-control required" name="code_order" id="code_order"  type="text" maxlength="3" title="표출 순서" placeholder="" /> -->
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">코드명</th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="code_nm" id="code_nm"  type="text" maxlength="100" title="그룹명" placeholder="">
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">사용여부</th>
				                                       <td colspan="3">
															<select name="use_yn" id="use_yn" class="form-control col-md-3 input-sm" title="사용여부">
																<!-- <option value=""></option> -->
													        	<option value='Y'>사용</option>
													        	<option value='N'>미사용</option>
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
					                                    	<textarea name="code_desc" id="code_desc" rows="4" cols="60" class="form-control" title="설명" placeholder=""  style="resize: none;"></textarea>
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
				                            	<button type="button" class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id='btnCodeDelete' style='display: none;'>삭제</button>
				                            	<button type="button" class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id='btnCodeEditCancel' style='visibility: hidden'>취소</button>
				                            </div>
				                            <div class="col-xs-1">
				                            	
												<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnCodeEdit' style='visibility: hidden'>수정</button>
				                            </div>
				                        </div>
	                            	</div>
	                            	<div class="row text-right">
			                            <div class="col-xs-11">
			                            </div>
			                            <div class="col-xs-1">
											<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnCodeAdd'>신규</button>
			                            </div>
			                        </div>
	                            </div>
	                        </div>
	                    </div>

	                </div>
	            </div>
	        </div>
		</div>
	</div>
	
	<!-- Add Page-Body -->
    <div class="row"  id="codeAdd" style='position: absolute; display: none; z-index:100'>
   		<div class="col-sm-10">
        	<div class="card-box big-card-box last table-responsive searchResult">
            	<h5 class="header-title"><b>코드 신규 등록</b></h5>
		        <form class="clearfix" id="codeAddForm" name="codeAddForm">
		        	<input name="new_progrm_no" id="new_progrm_no"  type="hidden">
              		<div class="table-wrap m-t-30">
                  		<table class="table table-custom table-cen table-num text-center table-hover" >
                  			<caption class="none">코드 신규 등록 테이블</caption>
                      		<colgroup>
                      			<col style="width:25%">
                        		<col style="width:25%">
                        		<col style="width:20%">
                        		<col style="width:30%">	
                      		</colgroup>
                      		<tbody>
	                         	<tr>
	                                <th scope="row">코드 NO <span class="text-danger">*</span></th>
	                                <td colspan="3">
	                                <input class="form-control required" name="new_code" id="new_code"  type="text" maxlength="100" title="순서" placeholder="">
	                                </td>
                            	</tr>
                         		<tr>
	                                <th scope="row">상위코드 NO <span class="text-danger">*</span></th>
	                                <td colspan="3">
                                		<select name="new_p_code" id="new_p_code" class="form-control col-md-3 input-sm" title="메뉴 여부" >
		   						 		</select>
                                	</td>
                            	</tr>
                            	<tr>
	                                <th scope="row">코드명</th>
	                                <td colspan="3">
	                                <input class="form-control required" name="new_code_nm" id="new_code_nm"  type="text" maxlength="1024" title="CSS Style" placeholder="">
	                                </td>
                            	</tr>
								<tr>
									<th scope="row">사용여부</th>
									<td>
										<select name="new_use_yn" id="new_use_yn" class="form-control col-md-3 input-sm" title="메뉴 여부" >
								        	<option value='Y' selected>예</option>
								        	<option value='N'>아니오</option>
								    	</select>
									</td>
									<th scope="row">표출순서</th>
								    <td>
										<select name="new_code_order" id="new_code_order" class="form-control col-md-3 input-sm" title="관리자 여부" >
								        	<option value='1'>1</option>
								    	</select>
								    </td>
								</tr>
                            	<tr>
                              		<th scope="row">설명</th>
		                            <td colspan="3">
		                            	<textarea name="new_code_desc" id="new_code_desc" rows="6" cols="60" class="form-control" title="설명" placeholder="" style="resize: none;"></textarea>
	                          		</td>
	                           	</tr>
                        	</tbody>
                		</table>
           			</div>
                 </form>
                 <div>
               	 	<div class="btn-wrap pull-left"></div>
                   	<div class="btn-wrap pull-right">
                   		<button class="btn btn-custom btn-md pull-right searchBtn" id="btnAddCancel" type="button">닫기</button>
						<button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id="btnAddSave" type="button">저장</button>
                   	</div>
                 </div>
            </div>
        </div>
    </div>
<!-- End code Detail Page-Body -->
