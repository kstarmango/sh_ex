<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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
	<%-- <%@ include file="/WEB-INF/jsp/import/map_declare.jsp"%> --%> 
	<title>SH | 토지자원관리시스템</title>
</script>
</head>
<body class="map" onload="checkDup();">

	<div id="load" style='display: none'>
	    <!-- <img src="/jsp/SH/img/ajax-loader.gif"><p>LOADING</p> -->
	</div>


	<!-- 좌측메뉴 -->
	<%-- <c:import url="<%= RequestMappingConstants.WEB_MAIN_LEFT %>"></c:import> --%>
	
	<!-- 본문영역 -->
	<c:import url="/gisinfo_home.do"></c:import> 

	<!-- 푸터 -->
	<%-- <c:import url="<%= RequestMappingConstants.WEB_MAIN_FOOTER %>"></c:import> --%>
	
	<%-- <div>
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
	</script> --%>
	
	
</body>
</html>