<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dreamsecurity.sso.agent.api.*"%>
<%@ page import="com.dreamsecurity.sso.lib.jsn.JSONObject"%>
<%@ page import="com.dreamsecurity.sso.agent.util.Util"%>
<%
	out.clear();
	
	
	/* if(Util.isEmpty(userId) || Util.isEmpty(cpw) || Util.isEmpty(npw) || Util.isEmpty(npwchk)) {
		out.println("error");		
	} */
	
	JSONObject result = UserService.setInitPw("symoon", "qwer1234!!"); //0
	//JSONObject result = UserService.checkFirstLogin("symoon"); // 0
	//JSONObject result = UserService.setChangePw("asdf2", "qwer1234!!", "qwer1234!");
	//JSONObject result = UserService.createUser("asdf3", "qwer1234!!", "00760", "{\"page\":1,\"total\":1,\"records\":1,\"rows\":[{\"resultstatus\":1,\"resultdata\":\"\"}]}", ""); //0
	//JSONObject result = UserService.getUserData("symoon"); // 0
	//JSONObject result = UrpyService.getUrpyInfo(); //0
	//JSONObject result = UrpyService.setUrpyInfo("URPY0001", 5, 5, 90);//0 
	
	//JSONObject result = UserService.updateUser("asdf3", "123123123123", "123123123123123"); //0
	JSONObject result = UserService.updateUserStatus("asdf2", "C"); // 0
	
	//IDPSSODescriptor idp = MetadataRepository.getInstance().getIDPDescriptor();
	//String idpUrl = idp.getSingleSignOnServices().get(0).getLocation();
	//int idx = idpUrl.indexOf("/sso");
	//idpUrl = idpUrl.substring(0, idx + 4) + "/setUserInfo.jsp";

	out.println(result.toString());
	//out.println(idpUrl.toString());
%>