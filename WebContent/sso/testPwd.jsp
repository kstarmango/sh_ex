<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dreamsecurity.sso.agent.api.UserService"%>
<%@ page import="com.dreamsecurity.sso.lib.jsn.JSONObject"%>
<%@ page import="com.dreamsecurity.sso.agent.util.Util"%>
<%
	out.clear();
	
	String userId = (String) request.getParameter("userId");
	String cpw = (String) request.getParameter("cpw");
	String npw = (String) request.getParameter("npw");
	String npwchk = (String) request.getParameter("npwchk");
	
	
	if(Util.isEmpty(userId) || Util.isEmpty(cpw) || Util.isEmpty(npw) || Util.isEmpty(npwchk)) {
		out.println("error");		
	}
	
	System.out.println("userId " + userId);
	System.out.println("cpw " + cpw);
	System.out.println("npw " + npw);
	System.out.println("npwchk " + npwchk);
	//JSONObject result = UserService.setInitPw("716134", "1");
	//JSONObject result = UserService.pwCheck("716134", "1");
	JSONObject result = UserService.setChangePw(userId, cpw, npw);
	//JSONObject result = UserService.createUser("1013402", "1", "엄종두", "", "", "", "", "");
	//JSONObject result = UserService.updateUser("ssotest", "김길동", "", "", "", "", "010-4321-5678");
	//JSONObject result = UserService.deleteUser("ssotest");
	
	//IDPSSODescriptor idp = MetadataRepository.getInstance().getIDPDescriptor();
	//String idpUrl = idp.getSingleSignOnServices().get(0).getLocation();
	//int idx = idpUrl.indexOf("/sso");
	//idpUrl = idpUrl.substring(0, idx + 4) + "/setUserInfo.jsp";

	out.println(result.toString());
	//out.println(idpUrl.toString());
%>