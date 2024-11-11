<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/jsp/import/map_declare.jsp"%>
	<title>SH | 토지자원관리시스템</title>
</head>
<body>
	
	<!-- 본문영역 -->
	<div id="content">
		<tiles:insertAttribute name="content"/>
	</div>
	
</body> 
</html>