<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
%><%
	String remoteUser = "";
	//String remoteUser = (String)session.getAttribute("SSO_ID");
	
	System.out.println("sso : " +remoteUser);
	
	// 개발
	//remoteUser = request.getParameter("user_id");
	//response.sendRedirect("http://127.0.0.1:38091/web/cmmn/ssoLogin.do?user_id="+remoteUser);

	// 실서버
	remoteUser = request.getRemoteUser();
	response.sendRedirect("http://192.168.110.154:38091/web/cmmn/ssoLogin.do?user_id="+remoteUser);
%>