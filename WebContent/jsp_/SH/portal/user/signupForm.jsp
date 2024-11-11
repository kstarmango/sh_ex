<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

<!DOCTYPE>
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

	<!-- HTML5 Shiv and Respond.js IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
	<script type="text/javascript" src="<c:url value='/js/html5shiv.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/respond.min.js'/>"></script>
	<![endif]-->

	<script type="text/javascript">
		$(document).ready(function(){
			$('#user_phone').keyup(function(){
				var value = $(this).val();
				$(this).val(fnMaskPhoneNum(value));
			});

			$('#userRegisterForm').validate({
				onsubmit: false,
				rules:{
					user_id: {
						required: true,
						lngEngorNum: true,
						rangelength:[5,15],
						identicalConsecutively: true,
						remote:{
							//url:'<c:url value="/user_dplct_ajax01.do" />',
							url:'<%= RequestMappingConstants.WEB_MNG_USER_PWD_DUP %>',
							type:'POST',
							data:{'user_id':function(){return $('#user_id').val();}},
							dataType:'json',
							dataFilter: function(data) {
								var json = JSON.parse(data);
						        if(json["result"] == new String("Y")) {
						            return false;
						        } else {
						        	return true;
						        }
					        }
						}
					},
					user_name: {
					  required: true,
					  lngEngorKor: true,
					  rangelength: [2,5]
					},
					<%-- <c:if test="${user_id eq null or user_id eq '' }"> --%>
					user_pass: {
					  required: true,
					  identicalConsecutively: true,
					  rangelength: [7,15]
					},
					re_user_pass: {
						required: true,
					  	equalTo: "#user_pass"
					},
					<%-- </c:if> --%>
					user_position:{
						required: true
					},
					user_phone:{
						required: true,
						telephone: true
					}
				},
				messages:{
					user_id: {
						required: "사용자ID를 입력해 주세요.",
						remote: "중복된 사용자ID 또는 사용할 수 없는 사용자ID 입니다.",
						rangelength:"사용자ID는 5~15자로 제한합니다.",
						identicalConsecutively:"동일한 숫자 및 문자를 연속해서 4번이상 사용하실 수 없습니다."
					},

					user_name: {
						required: "사용자명을 입력해 주세요.",
						rangelength: "사용자명은 2~5자 이내입니다."
					},
					<%-- <c:if test="${user_id eq null or user_id eq '' }"> --%>
					user_pass: {
						required: "비밀번호를 입력해 주세요.",
						identicalConsecutively:"동일한 숫자 및 문자를 연속해서 4번이상 사용하실 수 없습니다.",
						rangelength: "비밀번호는 7~15자 이내입니다."
					},
					re_user_pass: {
						required: "비밀번호를 재입력해 주세요.",
						equalTo: "동일한 비밀번호가 아닙니다."
					},
					<%-- </c:if> --%>
					user_position: {
						required: "부서 정보를 입력해 주세요."
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

			$('#btnRegSave').click(function(){
				if($("#userRegisterForm").valid())
				{
					//var url = "<c:url value='/user_regist_start.do'/>";
					var url = "<%= RequestMappingConstants.WEB_SIGNUP_SUBMIT %>";
					var sendData = $('#userRegisterForm').serialize();
					$.ajax({
						type : "POST",
						async : false,
						url : url,
						dataType : "json",
						data : sendData,
						error : function(response, status, xhr){
							if(xhr.status =='403'){
							}
						},
						success : function(data) {
							if(data.result == 'Y') {
								var suc = "회원가입이 완료 되었습니다.";
								$("#userRegisterForm")[0].reset();
								$("#pRegMsg").text(suc);
								$('#alert-reg-msg').modal();
							}
						}
					});
				}
			});

			$('#btnRegCancel').click(function(){
				//window.location.replace('<c:url value="/main_home.do"/>');
				window.location.replace('<%=RequestMappingConstants.WEB_LOGIN%>');

			});

			$('#regModalClose').click(function(){
				//window.location.replace('<c:url value="/main_home.do"/>');
				window.location.replace('<%=RequestMappingConstants.WEB_LOGIN%>');
			});

		});

		//전화번호 mask.....
		function fnMaskPhoneNum(str){
			var RegNotNum  = /[^0-9]/g;
			var RegPhoneNum = "";
			var DataForm   = "";
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
                            <div class="m-t-120 m-b-120 account-pages">
                                <div class="account-content">
                                    <h4 class="header-title m-t-0"><b>계정 등록</b></h4>
                                    <p class="text-muted m-b-30"><span class="text-danger">*</span> 필수입력 값 입니다.</p>
                                    <form class="clearfix" id="userRegisterForm" name="userRegisterForm" onSubmit="return false;">

                                    	<input type="hidden" name="_csrf" value="${CSRF_TOKEN}" />
                                    	<input name="sbscrb_cd" id="sbscrb_cd" type="hidden" value="${sbscrb_cd}" />

                                        <div class="form-group col-md-12">
                                            <label class="col-md-2" for="user_id">사용자 ID <span class="text-danger">*</span></label>
                                            <div class="input-group col-md-10 p-l-r-10">
                                                <input class="form-control required" name="user_id" id="user_id" type="text" maxlength="20" title="사용자ID" placeholder="사용자ID를 입력해주세요." value="${user_id}" ${user_id eq null or user_id eq '' ? '' : 'readonly'} />
                                            </div>
                                        </div>

                                        <div class="form-group col-md-12">
                                            <label class="col-md-2" for="user_name">사용자명 <span class="text-danger">*</span></label>
                                            <div class="col-md-10">
                                                <input class="form-control required" name="user_name" id="user_name" type="text" maxlength="60" title="사용자명" placeholder="사용자명을 입력해주세요." />
                                            </div>
                                        </div>

										<%-- <c:if test="${user_id eq null or user_id eq '' }"> --%>

										<!-- SSO 로그인이 아닌 경우 -->
										<div class="form-group col-md-12">
                                            <label class="col-md-2 control-label" for="user_pass">비밀번호 <span class="text-danger">*</span></label>
                                            <div class="col-md-10">
                                                <input class="form-control required" name="user_pass" id="user_pass"  type="password" maxlength="64" title="비밀번호" placeholder="비밀번호를 입력해주세요." />
                                            </div>
                                        </div>

                                        <div class="form-group col-md-12">
                                            <label class="col-md-2 control-label" for="re_user_pass">비밀번호 확인 <span class="text-danger">*</span></label>
                                            <div class="col-md-10">
                                                <input id="re_user_pass" name="re_user_pass" type="password" id="re_user_pass" title="비밀번호 확인" class="form-control required" placeholder="비밀번호 확인을 입력해주세요.">
                                            </div>
                                        </div>
                                        <!-- SSO 로그인이 아닌 경우 -->

                                        <%-- </c:if> --%>

                                        <div class="form-group col-md-12">
                                            <label class="col-md-2 control-label" for="user_position">부서명 <span class="text-danger">*</span></label>
                                            <div class="col-md-10">
                                                <input class="form-control" name="user_position" id="user_position"  type="text" title="부서명" maxlength="60" placeholder="부서명을 입력해주세요." />
                                            </div>
                                        </div>

                                        <div class="form-group col-md-12">
                                            <label class="col-md-2 control-label" for="user_phone">전화번호 <span class="text-danger">*</span></label>
                                            <div class="col-md-10">
                                                <input class="form-control" name="user_phone" id="user_phone"  type="text" title="전화번호" maxlength="30" placeholder="예) 02-201-0001" />
                                            </div>
                                        </div>

                                        <div class="clearfix"></div>

                                        <div class="divider divider-lg"></div>

                                        <div class="form-group">
                                            <div class="col-xs-12">
                                                <div class="btn-wrap pull-right">
                                                    <button class="btn btn btn-danger" id="btnRegCancel" type="button">취소</button>
                                                 	<button class="btn btn btn-custom" id="btnRegSave" type="button">확인</button>
                                                </div>
                                            </div>
                                        </div>

                                    </form>
                                </div>
                            </div>
                            <!-- end card-box-->

                        </div>
                        <!-- end wrapper -->

            </div>
          </section>
          <!-- END HOME -->

		<!-- Alert Modals (Login) -->
        <div id="alert-reg-msg" class="modal" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">
            <div class="modal-dialog modal-sm">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                        <h4 class="modal-title">계정등록신청 안내</h4>
                    </div>
                    <div class="modal-body">
                        <p id="pRegMsg"></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary waves-effect waves-light" id="regModalClose" data-dismiss="modal">확인</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- /Alert Modals (Login)-->

    </body>
</html>