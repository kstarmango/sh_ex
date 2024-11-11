<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
%><%
	// 개발
	//String remoteUser = request.getParameter("user_id");

	// 실서버
	String remoteUser = request.getRemoteUser();


	if(remoteUser == null)
	{
		//인증서버로 로그인 확인 요청
		//response.sendError(com.tomato.sso.sp.cont.SPServerConstants.SC_SAML_AUTH_NOT_CREATE);
		response.sendError(com.tomato.sso.sp.cont.SPServerConstants.SC_SAML_AUTH);
		return;
	}
	else
	{
		// 개발
		//response.sendRedirect("http://127.0.0.1:38091/jsp/SH/login_success.jsp?user_id="+remoteUser);

		// 실서버
		response.sendRedirect("http://192.168.110.154:38091/jsp/SH/login_success.jsp?user_id="+remoteUser);
	}
%>