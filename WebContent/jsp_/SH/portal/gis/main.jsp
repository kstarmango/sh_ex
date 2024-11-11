<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>


<%@ page session="true"%>
<%
	String polling_time = (String) session.getAttribute("POLLING_TIME");

	if (polling_time != null && !"0".equals(polling_time)) {
		polling_time = polling_time + "000";
	}
	else {
		polling_time = "0";
	}
	
	String ssoId = session.getAttribute("SSO_ID") == null ? "" : (String) session.getAttribute("SSO_ID");
%>



<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <meta name="description" content="SH서울주택도시공사 | 토지자원관리시스템">

	<title>SH | 토지자원관리시스템</title>

    <link rel="shortcut icon" href="/jsp/SH/img/favicon.ico">

    <!-- App css -->
    <link href="/jsp/SH/css/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/components.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/icons.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/core.css" rel="stylesheet" type="text/css" />

    <!-- jQuery Library -->
	<script src="/jsp/SH/js/jquery.min.js"></script>
	<script src="/jsp/SH/js/jquery-ui.min.js"></script>
	<script src="/jsp/SH/js/jquery.validate.min.js"></script>
	<script src="/jsp/SH/js/jquery.validate.extend.js"></script>
	<script src="/jsp/SH/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="css/bootstrap.min.css">
	<link rel="stylesheet" href="css/bootstrap-theme.min.css">

</head>
<body class="map" onload="checkDup();">

	<div id="load" style='display: none'>
	    <img src="/jsp/SH/img/ajax-loader.gif"><p>LOADING</p>
	</div>

	<c:import url="<%= RequestMappingConstants.WEB_MAIN_HEADER %>"></c:import>

	<c:import url="/gisinfo_home.do"></c:import>

	<c:import url="<%= RequestMappingConstants.WEB_MAIN_FOOTER %>"></c:import>
	
	<div>
		<iframe name="ssoiframe" width="0" height="0" frameborder="0" scrolling="no" style="visibility:hidden;"></iframe>
	</div>

	<form name="ssoCheckDupForm" method="post" action="" target="ssoiframe"></form>
	
	
	
	<script type="text/javascript">
	function checkDup()
	{
		var ssoId = '<%=ssoId%>';
		//if ( ssoId == null || ssoId == "" ) {
			//location.href = "/";
			//location.href = "/jsp/SH/login.jsp"
			//return;
		//}

		
		var cycle = '<%=polling_time%>';
		if (cycle > 0)
		{
			/*
				업무 개발자 수정 필요
				Context Path에 맞춰서 checkDupLogin.jsp 설정 필요
				ex) SSO 호출 URL : https://업무URL/login/sso/RequestConnect.jsp
				    -> 설정값 : /login/sso/checkDupLogin.jsp
			*/
			document.ssoCheckDupForm.action = "/sso/checkDupLogin.jsp"; // sh에 가서 소스 한번더 확인해보기
			document.ssoCheckDupForm.submit();

			setTimeout("checkDup()", cycle);
		}
	}
	</script>
	
	
</body>
</html>