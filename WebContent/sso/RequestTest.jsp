<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.dreamsecurity.sso.lib.jsn.JSONObject"%>
<%@ page import="com.dreamsecurity.sso.lib.dss.s2.core.AuthnRequest"%>
<%@ page import="com.dreamsecurity.sso.agent.common.MStatus"%>
<%@ page import="com.dreamsecurity.sso.agent.config.*"%>
<%@ page import="com.dreamsecurity.sso.agent.exception.SSOException"%>
<%@ page import="com.dreamsecurity.sso.agent.provider.ServiceProvider"%>
<%@ page import="com.dreamsecurity.sso.agent.util.Util"%>
<%@ page import="com.dreamsecurity.sso.agent.util.SAMLUtil"%>
<%@ include file="./common.jsp"%>
<%
	SSOConfig.setHomeDir(this.getServletConfig().getServletContext(), DEFAULT_SET_PATH);
	SSOInit.initialize();
	
	String loginId = request.getParameter(PARAM_LOGIN_ID);
	String empNo = request.getParameter("empNo");
	
	session.setAttribute("EMP_NO", empNo);
	session.setAttribute("SSO_ID", loginId);
	
	String relayState = request.getParameter(PARAM_RELAYSTATE);

 	Util.sendURL(response, relayState);
%>