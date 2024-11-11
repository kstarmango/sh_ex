<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true"%>
<%@ page import="com.dreamsecurity.sso.agent.config.SSOConfig"%>
<%@ include file="/sso/common.jsp"%>
<%
	String spname = SSOConfig.getInstance().getServerName();

	String polling_time = (String) session.getAttribute("POLLING_TIME");

	if (polling_time != null && !"0".equals(polling_time)) {
		polling_time = polling_time + "000";
	}
	else {
		polling_time = "0";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
	<title>Test Agent 2</title>

	<meta http-equiv="Content-Style-Type" content="text/css"/>
	<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>

	<script src="/sso/js/magicsso.js" type="text/javascript"></script>
	<script src="./js/jquery-3.4.1.min.js" type="text/javascript"></script>
	<link href="./css/sso-common.css" rel="stylesheet" type="text/css"/>
	<link href="./css/sso-main2.css" rel="stylesheet" type="text/css"/>

<script type="text/javascript">
	function checkDup()
	{
		if (!MagicSSO.isLogon()) {
			location.href = "<%=XSSCheck(DEFAULT_BASE_URL)%>";
			return;
		}

		var cycle = <%=XSSCheck(polling_time)%>;
		if (cycle > 0)
		{
			document.ssoCheckDupForm.action = "/sso/checkDupLogin.jsp";
			document.ssoCheckDupForm.submit();

			setTimeout("checkDup()", cycle);
		}
	}
</script>
</head>
<body onload="checkDup();">
	<input type="hidden" id="userid" value=""/>

	<table id="body-table">
		<tr>
			<td id="menu">
				<div class="site_logo">
				</div>
				<div>
					<ul class="menu">
						<li class="menu-item">
							<span>
								<img class="menu-icon" src="./images/icon_rept_off.png"/>
								<a href="#">SSO 연계</a>
							</span>
							<ul class="sub-menu">
								<li id="menu-conn1"><img class="menu-icon" src="./images/icon_submenu.png"/>TEST-SP1</li>
							</ul>
						</li>
				    </ul>
				</div>
			</td>
			<td id="menu-margin">
			</td>
			<td id="main">
				<table id="header-table">
					<tr id="header">
						<td id="logo">
							Test Connect Site - <%=XSSCheck(spname)%>
						</td>
						<td id="photo">
							<img width="26" height="26" id="photo_img" alt="" src="./images/photo_default.png"/>
						</td>
						<td id="name">
							<span id="user_name"></span>
						</td>
						<td id="seperate">
						</td>
						<td id="logout">
							<img id="logout_img" alt="" src="./images/logout_n2.png"/>
						</td>
					</tr>
					<tr id="header-bottom">
						<td colspan="5"></td>
					</tr>
					<tr>
						<td colspan="5">
							<iframe class="mainFrm" src="" id="mainFrm" name="mainFrm" width="100%" frameborder="0" scrolling="no"></iframe>
							<iframe name="ssoiframe" width="0" height="0" frameborder="0" scrolling="no" style="visibility:hidden;"></iframe>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

	<form id="menuForm" method="post"></form>
	<form name="ssoCheckDupForm" method="post" action="" target="ssoiframe"></form>

	<script type="text/javascript">
	$(document).ready(function(){
		resize_menu();

		var uid = MagicSSO.getID();
		var uname = MagicSSO.getProperty("NAME");

		$('.sub-menu').css('display', 'none');
		$('ul.menu').on('click', '.menu-item>span', function() {
			if (uid != null && uid != "") {
				$(this).parent().siblings('.on').toggleClass('on');
				$(this).parent().siblings().children('.sub-menu').slideUp('fast');
				$(this).parent().toggleClass('on');
				$(this).parent().children('.sub-menu').stop('true','true').slideToggle('fast');
			}
		});

		if (uid == null || uid == "") {
			$('#photo_img').css('visibility', 'hidden');
			$('#user_name').css('visibility', 'hidden');
			$('#logout_img').css('visibility', 'hidden');
			$('#logout').css('cursor', 'default');

			menuForm.action = "<%=XSSCheck(DEFAULT_BASE_URL)%>";
			menuForm.target = "_self";
			menuForm.submit();
		}
		else {
			$('#photo_img').css('visibility', 'visible');
			$('#user_name').css('visibility', 'visible');
			$('#logout_img').css('visibility', 'visible');
			$('#logout').css('cursor', 'pointer');

			$('#userid').val(uid);
			$('#user_name').text(uname);
		}
	});

	$(window).resize(function(){
		resize_menu();
	});

	$("#logout").click(function() {
		if ($('#userid').val() == null || $('#userid').val() == "") {
			return;
		}

		if (!MagicSSO.isLogon()) {
			location.href = "<%=XSSCheck(DEFAULT_BASE_URL)%>";
		}

		if (!confirm(" 로그아웃 하시겠습니까?")) {
			return;
		}

		location.href = "/sso/Logout.jsp?slo=y";
	});

	$("#menu-conn1").click(function() {
		if (isLogon()) {
			window.open("http://sp1.dev.com:40004/portal/main.jsp", "_self");
		}
		else {
			location.href = "<%=XSSCheck(DEFAULT_BASE_URL)%>";
		}
	});

	function resize_menu() {
		var menu_height = $(window).height();
		$("#body-table").css("height", menu_height);
		$("#mainFrm").css("height", menu_height - 61);
	}

	function goDirectMenu(url)
	{
		menuForm.action = url;
		menuForm.target = "mainFrm";
		menuForm.submit();
	}
	</script>
</body>
</html>
