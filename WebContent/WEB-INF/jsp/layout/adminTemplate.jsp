<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%> 
<!DOCTYPE html>
<html lang="ko">
<head>
	<%-- <%@ include file="/WEB-INF/jsp/import/map_declare.jsp"%> --%>
	<%@ include file="/WEB-INF/jsp/import/admin/adminCommon.jsp"%>
	<link rel="stylesheet" href="<c:url value='/resources/css/common/admin_style.css'/>">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	<title>SH | 토지자원관리시스템</title>
	
	<script>
	// 초기화 및 이벤트 등록
	$(document).ready(function() {
		jQuery.fn.center = function () {
			this.css("position","absolute");
			this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()) + "px");
			this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()) + "px");
			return this;
		};
	});
	</script>
</head>
<body>
	<header id="header">
		<tiles:insertAttribute name="header"/>
	</header>
 	<div id="aside">
		<tiles:insertAttribute name="aside"/>
	</div> 
	
	<div id="content">
		<tiles:insertAttribute name="content"/>
	</div>
 
	<%-- <footer id="siteBottom">
		<tiles:insertAttribute name="siteBottom"/>
	</footer> --%>
</body>
</html>