<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLDecoder"%>
<%@ include file="./common.jsp"%>
<%
	String code = request.getParameter("ecode") == null ? "" : request.getParameter("ecode");
	String message = request.getParameter("emessage") == null ? "" : request.getParameter("emessage");
	String msg = " " + code + ", " + URLDecoder.decode(message, "UTF-8");
%>
<html>
<head>
<title>Request Error Page</title>
</head>
<script type="text/javascript">
	alert("<%=XSSCheck(code)%>");
	alert("<%=XSSCheck(message)%>");
</script>
</html>