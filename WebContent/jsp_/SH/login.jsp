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
	<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
	<meta http-equiv="Expires" content="0">
	<meta http-equiv="Pragma" content="no-cache">
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

	<title>SH | 토지자원관리시스템</title>
	<script type="text/javascript">
		$(document).ready(function() {

		    $( "#user_id" ).keydown(function( event ) {
		    	  if ( event.which == 13 ) {
		    		  fnLoginUser();
		    		  return;
		    	  }
		    });

		    $( "#user_pass" ).keydown(function( event ) {
		    	  if ( event.which == 13 ) {
		    		  fnLoginUser();
		    		  return;
		    	  }
		    });

		    $('#btnLoginUser').click(function() {
		    	fnLoginUser();
		    });

			$('#btnSignupUser').click(function() {
				fnSignupUser();
			});

		    $('#btnFindUserById').click(function() {
		    	fnFindUserById();
			});

		});

		/* 회원가입 페이지 */
		function fnSignupUser()
		{
			var frm = document.loginForm;
			//frm.action = "<c:url value='/user_regist_form.do'/>";
			frm.action = "<%=RequestMappingConstants.WEB_SIGNUP_FORM%>";
		   	frm.submit();
		}

		/* 아이디찾기 페이지 */
		function fnFindUserById()
		{
			var frm = document.loginForm;
			//frm.action = "<c:url value='/user_find_id.do'/>";
			frm.action = "<%=RequestMappingConstants.WEB_FIND_USER_FORM%>";

		   	frm.submit();
		}

		/* 로그인 */
		function fnLoginUser(){
			if ($("#user_id").val() == "") {
		        $('#alert-id-error').modal();
				$("#user_id").focus();
				return false;
			}

			if ($("#user_pass").val() == "") {
		        $('#alert-pw-error').modal();
				$("#user_pass").focus();
				return false;
			}

			//$("form").attr("action", "/homeLogin01.do");
			$("form").attr("action", "<%=RequestMappingConstants.WEB_MEM_LOGIN%>");
			$("form").attr("method", "post");
			$("form").submit();
		}

	</script>
</head>

<body class="map" style="background: url(/jsp/SH/img/background.png) no-repeat center top/100% 100%">

	<!--contents-->
	<div class="wrapper map">
		<!-- HOME -->
        <section>
            <div class="container-alt">
                <div class="row">
                    <div class="col-sm-12">

                        <div class="wrapper-page">

                            <div class="m-t-120 m-b-120 account-pages">
                                <div class="text-center account-logo-box" style="background-color: rgba(14, 59, 78, 0.9);">
                                    <h2 class="text-uppercase">
                                        <a href="<%=RequestMappingConstants.WEB_LOGIN%>" class="text-success" title='SH서울주택도시공사  토지자원관리시스템'>
											<img src="/jsp/SH/img/sh_logo.png" alt="SH서울주택도시공사" height="48" >
											<span class="v-bar"></span>
		                    				<img src="/jsp/SH/img/logo.png" alt="토지자원관리시스템" height="21">
                                        </a>
                                    </h2>
                                </div>
                                <div class="account-content" style="background-color: #ffffff;">
                                    <form class="form-horizontal" id="loginForm" name="loginForm" method="post">

										<input type="hidden" name="_csrf" value="${CSRF_TOKEN}" />

                                        <div class="form-group addon-use">
                                            <div class="input-group col-xs-12">
                                                <span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
                                                <input class="form-control m-b-0" type="text" required="" placeholder="아이디" id="user_id" name="user_id"  title='아이디' value=''>
                                            </div>
                                        </div>

                                        <div class="form-group addon-use">
                                            <div class="input-group col-xs-12">
                                                <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
                                                <input class="form-control m-b-0" type="password" required="" placeholder="비밀번호" id="user_pass" name="user_pass" title='비밀번호' value=''>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <div class="col-xs-12">
                                                <button class="btn btn-lg btn-custom btn-block" type="button" id="btnLoginUser" title='로그인'>로그인</button>
                                            </div>
                                        </div>

                                        <div class="divider divider-lg"></div>

                                        <div class="form-group text-center m-t-10 m-b-0">
                                            <div class="col-sm-12">
                                                <a href="javascript:;" id="btnSignupUser" class="text-dark" title='계정등록'><i class="fa fa-pencil fa-fw"></i>계정등록</a>
                                                <span class="vbar">|</span>
                                                <a href="javascript:;" id="btnFindUserById" class="text-dark" title='아이디 찾기'><i class="fa fa-user fa-fw"></i>아이디 찾기</a>
                                                <!-- <span class="vbar">|</span>
                                                <a href="javascript:;" id="btnResetPasswordUserById" class="text-muted"><i class="fa fa-lock fa-fw"></i>비밀번호 재설정</a> -->
                                            </div>
                                        </div>

                                    </form>

                                    <div class="clearfix"></div>

                                </div>
                            </div>
                            <!-- end card-box-->

                        </div>
                        <!-- end wrapper -->

                    </div>
                </div>
            </div>
          </section>
          <!-- END HOME -->

		<!-- Alert Modals (Login) -->
        <div id="alert-id-error" class="modal" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">
            <div class="modal-dialog modal-sm">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                        <h4 class="modal-title">로그인 오류</h4>
                    </div>
                    <div class="modal-body">
                        <p>아이디를 입력해주세요.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary waves-effect waves-light" data-dismiss="modal">확인</button>
                    </div>
                </div>
            </div>
        </div>

        <div id="alert-pw-error" class="modal" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">
            <div class="modal-dialog modal-sm">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                        <h4 class="modal-title">로그인 오류</h4>
                    </div>
                    <div class="modal-body">
                        <p>비밀번호를 입력해주세요</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary waves-effect waves-light" data-dismiss="modal">확인</button>
                    </div>
                </div>
            </div>
        </div>
		<!--
        <div id="alert-login-error" class="modal" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">
            <div class="modal-dialog modal-sm">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                        <h4 class="modal-title">로그인 오류</h4>
                    </div>
                    <div class="modal-body">
                        <p>아이디 또는 비밀번호가 일치하지 않습니다.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary waves-effect waves-light" data-dismiss="modal">확인</button>
                    </div>
                </div>
            </div>
        </div>
 		 -->
 		<!-- End Alert Modals (Login) -->
	</div>

</body>
</html>