<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	if (session.getAttribute("SSO_ID") != null && !session.getAttribute("SSO_ID").equals("")) {
		response.sendRedirect("/portal/main.jsp");  // edit
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery-1.10.2.js"></script>
<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery-ui.min.js"></script>
<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery.blockUI.js"></script>
<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/json2.js"></script>
<!-- ML4WEB JS -->
<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/ML_Config.js"></script>
<title>SSO 로그인 샘플 페이지</title>
<style type="text/css">
.blue_btn {text-align:center; margin:0;}
.blue_btn button {width:100px; height:66px; padding:1px; border-radius:5px; border:0; background:#175deb;
	-webkit-appearance:none; box-shadow:1px 1px 0 #D9D9D9; -webkit-box-shadow:1px 1px 0 #D9D9D9; cursor:pointer;}
.blue_btn button span {font-size:16px; font-weight:bold; color:#FEFEFE; text-shadow:1px 1px 0 rgba(0,0,0,.2);
	-webkit-text-shadow:1px 1px 0 rgba(0,0,0,.2)}
.login-input {height:26px; width:175px; font-size:14px; padding-left:7px;}
</style>
<script type="text/javascript">
	document.onkeypress = getKey;

	function getKey(keyStroke)
	{
		if (window.event.keyCode == 13)
			loginStart();
	}

	function loginStart()
	{
		var frm = document.getElementById("loginForm");

		if (frm.loginId.value == "" || frm.loginPw.value == "") {
			alert("아이디 또는 비밀번호를 입력해 주세요.");
			return;
		}

		frm.action = "/sso/RequestAuth.jsp";
		frm.submit();
	}

	function mlCallBack(code, message)
	{
		if (code == 0)
		{
			// 정상메시지
			var data = encodeURIComponent(message.encMsg);

			document.loginForm.signedData.value = data;

			//alert(data);
			//alert(message.vidRandom);
		
			if (message.vidRandom != null){
				document.loginForm.vidRandom.value = encodeURIComponent(message.vidRandom);
			}

			document.loginForm.action = "/sso/RequestAuthCert.jsp";
			document.loginForm.submit();
		}
		else {
			alert("결과값 수신에 실패하였습니다.");
			return;
		}
	}

</script>
</head>
<body bgcolor="#E6E6E6">
	<div id="mainPage">
		<form name="loginForm" id="loginForm" method="post">
		<input type="hidden" id="RelayState" name="RelayState" value=""/>
		<input type="hidden" id="signData" name="signData"  value="Login"/>
		<input type="hidden" id="signedData" name="signedData"/>
		<input type="hidden" id="vidRandom" name="vidRandom"/>
		<input type="hidden" id="vidType" name="vidType" value="client"/>

		<table width="100%" bgcolor="#E6E6E6" border="0" cellpadding="0" cellspacing="0">
			<tr height="30">
				<td></td>
			</tr>
			<tr>
				<td>
					<table width="530" border="1" bordercolor="#E1E1E1" style="border-collapse:collapse" cellpadding="0" cellspacing="0" align="center">
						<tr>
							<td>
								<div style="width:530px; height:270px; background-image:url('/portal/images/login_main_img.jpg'); background-repeat:no-repeat; background-size:auto;">
								</div>
							</td>
						</tr>
						<tr height="100" bgcolor="#FFFFFF">
							<td>
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr height="40">
										<td width="3%"></td>
										<td width="15%" align="right"><b>아이디&nbsp;&nbsp;</b></td>
										<td width="36%">
											<input class="login-input" type="text" name="loginId" id="loginId" tabindex=1 maxlength="20">
										</td>
										<td width="22%" rowspan="2" align="center">
											<p class="blue_btn">
												<button type="button" name="btIdPw" id="btIdPw" tabindex=3 onclick="loginStart(); return false;">
													<span>로그인</span>
												</button>
											</p>
										</td>
										<td width="22%" rowspan="2" align="center">
											<p class="blue_btn">
												<button type="button" name="btCert" id="btCert" onclick="javascript:magicline.uiapi.MakeSignData(document.loginForm, null, mlCallBack);">
													<span>인증서<br/>로그인</span>
												</button>
											</p>
										</td>
										<td width="2%"></td>
									</tr>
									<tr height="40">
										<td></td>
										<td align="right"><b>비밀번호&nbsp;&nbsp;</b></td>
										<td>
											<input class="login-input" type="password" name="loginPw" id="loginPw" tabindex=2 maxlength="20">
										</td>
										<td></td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr height="35">
				<td align="center">Copyright 2010 DreamSecurity. All rights reserved.</td>
			</tr>
		</table>
		</form>
	</div>

	<div id="dscertContainer">
		<iframe id="dscert" name="dscert" src="" width="100%" height="100%" frameborder="0" allowTransparency="true" style="position:fixed;z-index:100010;top:0px;left:0px;width:100%;height:100%;"></iframe>
	</div>
</body>
</html>