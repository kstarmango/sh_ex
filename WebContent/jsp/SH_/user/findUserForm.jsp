<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <meta name="description" content="SH서울주택도시공사 | 토지자원관리시스템">
	<link rel="shortcut icon" href="<c:url value='/img/favicon.ico'/>" />
	<title>토지자원관리시스템</title>
	
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
	
	<script type="text/javascript">
	$(document).ready(function(){
		
		$('#user_phone').keyup(function(){
			var value = $(this).val();
			$(this).val(fnMaskPhoneNum(value));
		});
		
		$('#findUserIdForm').validate({
			onsubmit: false,
			rules:{				
				user_name: {
				  required: true,
				  lngEngorKor: true,
				  rangelength: [2,5]
				},				
				user_phone:{
					required: true,
					telephone: true
				}
			},
			messages:{				
				user_name: {
					required: "사용자명을 입력해 주세요.",
					rangelength: "사용자명은 2~5자 이내입니다.",
					lngEngorKor: "한글만 가능합니다."
				},
				user_phone:{
					required: "전화번호를 입력해주세요."
				}
			},
			invalidHandler: function(form, validator) {
				if (validator.numberOfInvalids()) {
					validator.errorList[0].element.focus();
				}
			},
			errorElement: 'em',
			errorPlacement: function(error, element) {
				if(!element.parent('div').hasClass('form-animate-error')){
					$(element.parent("div").addClass("form-animate-error"));
					
				}
				error.appendTo(element.parent("div"));
			},
			success: function(label) {
				if(label.parent('div').hasClass('form-animate-error')){
					$(label.parent("div").removeClass("form-animate-error"));
				}
			},
			highlight: function(element, errorClass, validClass) {
				if(!$(element).parent('div').hasClass('form-animate-error')){
					$(element).parent("div").addClass("form-animate-error");
					
				}
			},
			unhighlight: function(element, errorClass, validClass) {
			}
		});
		
		$('#btnFindUserIdSearch').click(function(e){
			if($("#findUserIdForm").valid())
			{
			 findId();
			}
		});
		
		$('#btnLoginForm').click(function(){
			window.location.replace('<c:url value="/main_home.do"/>');
		});
		
		$('#btnFindUserIdCancel').click(function(){
			$('#user_name').val('');
			$('#user_phone').val('');
		});
		
	});
	
	//전화번호 mask.....
	function fnMaskPhoneNum(str){ 
		var RegNotNum  = /[^0-9]/g; 
		var RegPhoneNum = new String(""); 
		var DataForm   = new String(""); 
		if( str == new String("") || str == null ) return ""; 
		str = str.replace(RegNotNum,''); 
		if( str.length < 3 ) return str; 
		if( str.length > 2 && str.length < 7 ) {
			if(str.substring(0,2) == new String("02")){
				DataForm = "$1-$2"; 
				RegPhoneNum = /([0-9]{2})([0-9]+)/;
		    }else{
				DataForm = "$1-$2"; 
				RegPhoneNum = /([0-9]{3})([0-9]+)/;
		    }
		} else if(str.length > 6 && str.length < 9) {
			if(str.substring(0,2) == new String("02")){
				DataForm = "$1-$2-$3"; 
				RegPhoneNum = /([0-9]{2})([0-9]{3})([0-9]+)/; 
		    }else{
				DataForm = "$1-$2-$3"; 
				RegPhoneNum = /([0-9]{3})([0-9]{3})([0-9]+)/;
		    }
		} else if(str.length == 9 ) {
			if(str.substring(0,2) == new String("02")){
				DataForm = "$1-$2-$3"; 
				RegPhoneNum = /([0-9]{2})([0-9]{3})([0-9]+)/; 
		    }else{
				DataForm = "$1-$2-$3"; 
				RegPhoneNum = /([0-9]{3})([0-9]{3})([0-9]+)/;
		    }
		} else if(str.length == 10){ 
			if(str.substring(0,2) == new String("02")){
				DataForm = "$1-$2-$3"; 
				RegPhoneNum = /([0-9]{2})([0-9]{4})([0-9]{4})/; 
		    }else{
				DataForm = "$1-$2-$3"; 
				RegPhoneNum = /([0-9]{3})([0-9]{3})([0-9]{4})/;
		    }
		} else if(str.length > 10){ 
			if(str.substring(0,2) == new String("02")){
				DataForm = "$1-$2-$3"; 
				RegPhoneNum = /([0-9]{2})([0-9]{4})([0-9]{4})/; 
				str = str.substring(0,10);
		    }else{
		    	if(str.substring(0,2) == new String("01")){
		    		DataForm = "$1-$2-$3"; 
					RegPhoneNum = /([0-9]{3})([0-9]{4})([0-9]{4})/;
					str = str.substring(0,11);
		    	}else{
		    		DataForm = "$1-$2-$3"; 
					RegPhoneNum = /([0-9]{3})([0-9]{3})([0-9]{4})/; 
					str = str.substring(0,10);
		    	}
		    }
		} 
		
		if(RegPhoneNum != ''){
			while( RegPhoneNum.test(str) ) {  
				str = str.replace(RegPhoneNum, DataForm);  
			}
		}
		return str; 
	}
	
	function findId(){
		$("form").attr("action", "/find_user_id_ac.do");
		$("form").attr("method", "post");
		$("form").submit();
	}
	
	</script>
    </head>


    <body class="bg-gray" oncontextmenu="return false" ondragstart="return false">
    
       <!-- Header -->
       <header id="topnav" class="map">
            <div class="topbar-main">
                <div class="container">
                    <div class="logo login-logo">
		                <!-- Image Logo -->
		                    <img src="/jsp/SH/img/sh_logo.png" alt="SH서울주택도시공사" height="48" >
		                    <span class="v-bar"></span>
		                    <img src="/jsp/SH/img/logo.png" alt="토지자원관리시스템" height="19">
		            </div>
                </div>
            </div>
        </header>
        <!-- End Header ->


        <!-- HOME -->
        <section>
            <div class="container-alt">               
                   <div class="wrapper-page register">

                       <div class="m-b-120 m-t-120 account-pages">                              
                           <div class="account-content">
                               <h4 class="header-title m-t-0"><b>아이디 찾기</b></h4>
                               <p class="text-muted m-b-30"><span class="text-danger">*</span> 필수입력 값 입니다.</p>
                               <c:if test="${findUserId.mode ne 'succ' }">
							   <form  class="clearfix" id="findUserIdForm" name="findUserIdForm" >
                                   <div class="form-group col-md-12">
                                       <label class="col-md-2" for="user_name">사용자명 <span class="text-danger">*</span></label>
                                       <div class="col-md-10">
                                           <input class="form-control required" name="user_name" id="user_name" type="text" maxlength="60" title="사용자명" placeholder="사용자명을 입력해주세요." />
                                       </div>
                                   </div>
                                   <div class="form-group col-md-12">
                                       <label class="col-md-2" for="user_phone">전화번호<span class="text-danger">*</span></label>
                                       <div class="col-md-10">
                                           <input class="form-control required" id="user_phone" name="user_phone" maxlength='30' title ="전화번호" placeholder="예) 02-201-0001" />
                                       </div>
                                   </div>
                                   

                                   <div class="clearfix"></div>

                                   <div class="form-group">
                                       <div class="col-xs-12">
                                           <div class="btn-wrap text-center m-b-20 m-t-20">
                                               <button class="btn btn btn-danger w-sm btn-md m-r-5" id="btnFindUserIdCancel" type="button">초기화</button>
                                               <button class="btn btn btn-custom w-sm btn-md" id="btnFindUserIdSearch" type="button">확인</button>
                                           </div>
                                       </div>
                                   </div>
                               </form>
								</c:if>
								<!-- 아이디 찾기 영역 -->
                               <div class="find-id-wrap text-center">                                        
                                   <div class="divUserIdInfo">
                                   <div class="find-id">
                                       <c:if test="${findUserId.mode eq 'succ'}">
                                       <c:forEach var="resultId" items="${userIdList}" varStatus="status">
                                       <p class="m-t-20">찾으시는 ID는 <span class="text-danger text-bold"><c:out value="${resultId.user_id}"/></span> 입니다.</p>
                                       </c:forEach>
                                       </c:if>
                                       <c:if test="${findUserId.mode eq 'fail'}">
                                       <div class="divider divider-lg"></div>
                                       <p class="m-t-40"><span class="text-danger text-bold">일치하는 사용자 정보가 없습니다.</span></p>
                                       </c:if>
                                   </div>
                                   
                                   </div>
								<div class="clearfix"></div>
			                                   <div class="divider divider-lg"></div>
			                                   <div class="btn-wrap text-center m-t-30">
			                                       <button class="btn btn btn-custom w-sm btn-lg" id="btnLoginForm" type="button">로그인 화면</button>
			                                   </div>
			                               </div>
			                               <!--//End 아이디 찾기 영역 -->	
			                           </div>
			                       </div>
			                       <!-- end card-box-->
			
			                   </div>
                      		  <!-- end wrapper -->
	            </div>
	          </section>
	          <!-- END HOME -->
		
       <!-- Footer -->
        <c:import url="/main_footer.do"></c:import>
        <!-- End Footer -->
    </body>
</html>