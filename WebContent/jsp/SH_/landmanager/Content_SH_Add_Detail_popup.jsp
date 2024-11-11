	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
	<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
	    <meta charset="utf-8">
	    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
	    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
	    <meta name="description" content="SH서울주택도시공사 | 토지자원관리시스템">

	    <link rel="shortcut icon" href="/jsp/SH/img/favicon.ico">    

	    <!--DatePicker css-->
	    <link href="/jsp/SH/css/bootstrap-datepicker.min.css" rel="stylesheet" />
	    <!-- DateTimePicker -->
	    <link href="/jsp/SH/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />

		<!--Morris Chart CSS -->
	    <link href="/jsp/SH/css/morris.css" rel="stylesheet" />
	    
	    <!-- App css -->
	    <link href="/jsp/SH/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
	    <link href="/jsp/SH/css/components.css" rel="stylesheet" type="text/css" />
	    <link href="/jsp/SH/css/icons.css" rel="stylesheet" type="text/css" />
	    <link href="/jsp/SH/css/core.css" rel="stylesheet" type="text/css" />
	     
	    <!-- jQuery Library -->
		<script src="/jsp/SH/js/jquery.min.js"></script>
		<script src="/jsp/SH/js/bootstrap.min.js"></script>
		
		<!-- Table Sort -->
		<script src="/jsp/SH/js/stupidtable.js"></script>
		
		<!-- App js -->
		<script src="/jsp/SH/js/jquery.app.js"></script>
		<script type="text/javascript" src="<c:url value='/jsp/SH/js/jquery.validate.min.js'/>"></script>
		<!-- OpenLayers4 -->
		<link href="/jsp/SH/js/openLayers/v4.3.1/ol.css" rel="stylesheet" />
		<script src="/jsp/SH/js/openLayers/v4.3.1/ol.js"></script>
		<script src="/jsp/SH/js/openLayers/v4.3.1/polyfill.min.js"></script>
		
	<script type="text/javascript">
	$(document).ready(function(){
		
		//읍면동리스트 조회
		$("select[id$='_sig']").change(function() {	
			var sig = $(this);
			var sigcd = sig.val();				
			$.ajax({
				type: 'POST',
				url: "/ajaxDB_emd_list.do",
				data: { "sigcd" : sigcd },
				dataType: "json",
				success: function( data ) {
					if( data != null ) {	
						var emd_nm = null; 
						var emd_cd = null;
						$('#fs_emd').find('option').each(function(){
							 $(this).remove();			 
						 });
						for (i=0; i<data.emd_cd.length; i++) {		
							emd_nm = data.emd_nm[i];
							emd_cd = data.emd_cd[i];
							$('#fs_emd').append('<option value="'+ emd_cd + '">' + emd_nm + '</option>');
						}	
						$('#fs_emd').trigger("chosen:updated");
					}	
				}
			});		
		});
		$('#registerForm').validate({
			onsubmit: false,
			rules:{
				 fs_sig:{
					required: true
				 }, 
				 fs_emd:{
					required: true
				 }, 
				 bon:{
					required: true,
					rangelength:[4,4]
				 }, 
				 bu: {
					 required: true,
					 rangelength:[4,4],
					 remote:{
							url:'<c:url value="/confirmPnu.do" />',
							type:'POST',
							data:{'emd':function(){return $('#fs_emd').val();},'bobn':function(){return $('#bon').val();},'bubn':function(){return $('#bu').val();}},
							dataType:'json',
							dataFilter: function(data) {
								var json = JSON.parse(data);
						        if(json["result"] == new String("true")) {
						            return true;
						        } else {
						            return false;
						        }

					        }
							
						}
				}
			},
			messages:{
				fs_sig: {
					required: "필수값입니다."							
				},
				fs_emd: {
					required: "필수값입니다."				
				},
				bon: {
					required: "필수값입니다.",
					rangelength:"4자리입니다."							
				},
				bu: {
					required: "필수값입니다.",
					rangelength:"4자리입니다.",
					remote: "pnu값 없음"				
				}
			},
			invalidHandler: function(form, validator) {
				if (validator.numberOfInvalids()) {
					validator.errorList[0].element.focus();
				}
			},
			errorElement: 'em',
			errorPlacement: function(error, element) {
				if(!element.parent('td').hasClass('form-animate-error')){
					$(element.parent("td").addClass("form-animate-error"));
					
				}
				error.appendTo(element.parent("td"));
			},
			success: function(label) {
				if(label.parent('td').hasClass('form-animate-error')){
					$(label.parent("td").removeClass("form-animate-error"));
				}
			},
			highlight: function(element, errorClass, validClass) {
				if(!$(element).parent('td').hasClass('form-animate-error')){
					$(element).parent("td").addClass("form-animate-error");
					
				}
			},
			unhighlight: function(element, errorClass, validClass) {
			}
		});
		
		// 상세에서 저장버튼 클릭
		$('.fnSave').click(function(){
			
			fnContentSave();
				
		});
		
		//리스트에서 저장버튼 클릭
		$('.fnInsert').click(function(){
			if($("#registerForm").valid())
			{
			   fnContentInsert();
			}	
		});
		
		
	});
	function fnContentSave(){
		var url = "<c:url value='/Content_SH_Add.do'/>";	
		var form = $('#registerForm')[0];
		var data_form = new FormData(form);
		
			
		$.ajax({
			type : "POST",
			async : false,
			processData: false,
			contentType:false,
			url : url,
			dataType : "html",
			data : data_form,	
			error : function(response, status, xhr){
				if(xhr.status =='403'){
					document.location.href = "<c:url value='/exception/pageError403.do'/>";
				}
			},
			success : function(data) {
				alert("저장되었습니다.");
			},
			complete: function(data) {
				window.close();
			}
		}); 
	}

	function fnContentInsert(){
		var url = "<c:url value='/Content_SH_Add.do'/>";	
		var form = $('#registerForm')[0];
		var data_form = new FormData(form);
		
			
		$.ajax({
			type : "POST",
			async : false,
			processData: false,
			contentType:false,
			url : url,
			dataType : "html",
			data : data_form,	
			error : function(response, status, xhr){
				if(xhr.status =='403'){
					document.location.href = "<c:url value='/exception/pageError403.do'/>";
				}
			},
			success : function(data) {
				alert("저장되었습니다.");
			},
			complete: function(data) {
				window.close();
			}
		}); 
	}
	</script>	

		<title>SH | 토지자원관리시스템</title>

	</head>
	<body>	
		
		<div id="load">
		    <img src="/jsp/SH/img/ajax-loader.gif"><p>LOADING</p>
		</div>
		
	    	<!-- 상세보기-Popup -->
	        
	            <div class="popover-title tit">
	                <span class="m-r-5"><b>자산 등록</b></span>
	            </div>
	                            
	                    <div class="popover-content p-30">                    
	                        <form id="registerForm" name="registerForm" class="form-horizontal"  onsubmit="return false;">
	                        <input type="hidden" name="pnu" value='<c:out value="${pnu}"/>'/>
	                        <input type="hidden" name="sh_kind" value='<c:out value="${sh_kind}"/>'/>
	                        <div class="row">
	                            <div class="col-xs-8">
	                                <h5 class="m-0"><b>자산 등록 항목</b></h5>
	                            </div>
	                            <div class="col-xs-4">
	                                
	                                    <div class="row">
	                                        <div class="col-xs-12">
	                                            <div class="form-group">
	<!--                                                 <label for="sel" class="control-label col-xs-3">수정일자</label> -->
	<!--                                                 <div class="col-xs-9"> -->
	<!--                                                     <select name="" id="sel" class="form-control input-sm"> -->
	<!--                                                         <option value="">2017.08.01</option> -->
	<!--                                                         <option value="">2017.08.30</option> -->
	<!--                                                         <option value="">2017.08.31</option> -->
	<!--                                                     </select> -->
	<!--                                                 </div> -->
	                                            </div>
	                                        </div>
	                                    </div>
	                            </div>
	                        </div>
							  
	                        <div class="row detail-view">
	                            <div class="col-xs-15">
	                                <div class="card-box box1 p-0 m-b-0">
	                                    <ul class="nav nav-tabs" id="dv-tablist">
	                                        <li class="active"><a data-toggle="tab" href="#dv-sh">자산정보</a></li>
	                                    </ul>
	                                    <div class="tab-content detail-view">
	                                        <div id="dv-sh" class="tab-pane fade in active">
			                                    <div class="tab-content detail-view">
			                                        <div class="table-wrap" id="table_dist_one">
		                                        		<table class="table table-custom table-cen table-num text-center" width="100%" height="100%" id="table_sh">
		                                                    <colgroup>
		                                                        <col width="25%"/>
		                                                        <col width="25%"/>
		                                                        <col width="25%"/>
		                                                        <col width="25%"/>
		                                                    </colgroup>
		                                                    <tbody>
		                                                    <c:if test="${mode ne 'preAdd'}">
		                                                    <tr>
		                                                    <th scope="row">시군구</th>
		                                                    <td>
	                                           	             <select class="form-control chosen" id="fs_sig" name="fs_sig">
	                                           	               <option value="" selected="selected">선택하세요</option>
		                                                       <c:forEach var="result" items="${sigData}" varStatus="status">
	                                                    			<option value='<c:out value="${result.sig_cd}"/>'><c:out value="${result.sig_kor_nm}"/></option>
		                                        				</c:forEach>
		                                                    </select>
		                                                    </td>
		                                                    <th scope="row">읍면동</th>
		                                                    <td>
	                                                            <select class="form-control chosen" id="fs_emd" name="fs_emd">
	                                                         <option value="" selected="selected">선택하세요</option>
	                                                       </select>
	                                                    </td>
	                                                    </tr>
	                                                    <tr>
	                                                    <th scope="row">본번</th>
	                                                    <td>
	                                                      <input type="text" class="form-control input-sm" id="bon" name="bon" placeholder = "본번"/>
	                                                    </td>
	                                                    <th scope="row">부번</th>
	                                                    <td>
	                                                      <input type="text" class="form-control input-sm" id="bu" name="bu" placeholder="부번"/>                                                      
	                                                    </td>
	                                                    </tr>
	                                                    </c:if>
	                                                    <c:forEach var="result" items="${sh_list_comment}" varStatus="status"> 
	                                                    <tr>
	                                                         <th scope="row"><c:out value="${result.column_comment}"/></th>
	                                                         <td colspan="3">
	                                                           <input type="text" class="form-control input-sm" id="<c:out value="${result.column_name}"/>" name="<c:out value="${result.column_name}"/>"/>
	                                                         </td>
	                                                    </tr>
	                                                    </c:forEach>
	                                                    </tbody>
	                                                </table>
		                                    	</div>
		                                    </div>   
                                        </div>
                                        
                                    </div>  
                                </div>
                            </div>

                        </div>
                        </form>
                    </div>
            
			  
            <div class="popover-footer detail-view">
                <div class="col-xs-6">
                    <div class="btn-wrap text-left p-10">
                       <c:choose>
                        <c:when test="${mode ne 'preAdd'}">
						  <button type="button" class="btn btn-sm btn-teal w-xs fnSave">저장</button>
						</c:when>
						<c:otherwise>
						  <button type="button" class="btn btn-sm btn-teal w-xs fnInsert">저장</button>
						</c:otherwise>
						</c:choose>
						<button type="button" class="btn btn-sm btn-custom w-xs" id="detail-view-close2">닫기</button>
                    </div>
                </div>
            </div>
        
        <!--// End 상세보기-Popup -->
    
</body>    
    