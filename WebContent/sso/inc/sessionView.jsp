<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.dreamsecurity.sso.agent.config.*"%>
<%@ include file="../common.jsp"%>
<%
	SSOConfig.setHomeDir(this.getServletConfig().getServletContext(), DEFAULT_SET_PATH);
	SSOInit.initialize();

// 	String PWD = "K8TDnSJM8AsRm+u+nw4zYJ8ITuC2jKNc3GLP1/mKjxU=";
// 	String inputPWD = request.getParameter("ssopw");

// 	if (inputPWD != null) {
// 		java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
// 		md.update("magicsso".getBytes());
// 		byte[] mdResult = md.digest(inputPWD.getBytes());

// 		sun.misc.BASE64Encoder encoder = new sun.misc.BASE64Encoder();
// 		inputPWD = encoder.encode(mdResult);
// 	}

// 	if (inputPWD == null || !inputPWD.equals(PWD)) {
%>
<!-- 		<h4 id="tempTitle" onClick="document.getElementById('divform').style.visibility='visible';">Magic SSO</h4> -->
<!-- 		<div id="divform" style="visibility:hidden"> -->
<!-- 			<form method=post> -->
<!-- 				<input type=password name=ssopw size=25> -->
<!-- 			</form> -->
<!-- 		<div> -->
<%
// 		return;
// 	}
// 	else {
%>
<!-- 		<h4 id="tempTitle" style="visibility:hidden"></h4> -->
<%
// 	}
%>
<!DOCTYPE html>
<html>
<head>
<title>Magic SSO Agent Session</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
#content { width:100%; }
#content table { width:100%; border:1px; }
#content table thead { text-align:center; background:#B3CDEE; }
#content table td { padding:.1em; border-right:1px solid #CCC; border-bottom:1px solid #CCC; }
form table { width:50%; border:1px; }
form table thead { text-align:center; background:#B3CDEE; }
form table td { padding:.1em; border-right:1px solid #CCC; border-bottom:1px solid #CCC; }
</style>
<script type="text/javascript">
	var flag = false;

	function showLayer()
	{
		if (!flag) {
			document.getElementById("sysinfo_lay").style.display = "block";
			document.getElementById("showLayer").value = "환경 정보 감추기";
		}
		else {
			document.getElementById("sysinfo_lay").style.display = "none";
			document.getElementById("showLayer").value = "환경 정보 보기";
		}

		flag = !flag;
	}
</script>
</head>
<body>
	<h1 align="center">Magic SSO Agent - <%=SSOConfig.getInstance().getServerName()%></h1>
	<div id="content">
		<div style="position:absolute; top:73px; right:10px;">
			<input type="button" value="Logout" onclick="location.href='<%=DEFAULT_SSO_PATH%>/Logout.jsp';" style="width:100px;"/>
		</div>
		<div>&nbsp;<%=SSOConfig.getElementVersion()%></div>
		<table>
			<thead>
				<tr>
					<td width="20%">Header Variable</td>
					<td>Header Value</td>
				</tr>
			</thead>
			<tbody>
				<%
					Enumeration eh = request.getHeaderNames();
					while (eh.hasMoreElements()) {
						String skey = (String) eh.nextElement();
						out.println("<tr>");
						out.println("<td>" + skey + "</td>");
						out.println("<td>" + request.getHeader(skey) + "</td>");
						out.println("</tr>");
					}
				%>
			</tbody>
		</table>
		<br>
		<table>
			<thead>
				<tr>
					<td width="20%">Session Variable</td>
					<td>Session Value</td>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>SP_Session</td><td><%=session.getId()%></td>
				</tr>
				<tr>
					<td>SP_Server_IP</td><td><%=Util.getServerIP()%></td>
				</tr>
				<%
					Enumeration em = session.getAttributeNames();
					while (em.hasMoreElements()) {
						String skey = (String) em.nextElement();
						out.println("<tr>");
						out.println("<td>" + skey + "</td>");
						out.println("<td>" + session.getAttribute(skey) + "</td>");
						out.println("</tr>");
					}
				%>
			</tbody>
		</table>
		<br>
		<!-- Sys info-->
		<input type="button" id="showLayer" name="showLayer" value="환경 정보 보기" style="width:150px; margin-left:2px;" onclick="showLayer();return false;"/>
		<div id="sysinfo_lay" style="display: none;">
			<table>
				<thead>
					<tr>
						<td width="20%">Sys pName</td>
						<td>Value</td>
					</tr>
				</thead>
				<tbody>
					<%
						Enumeration es = System.getProperties().propertyNames();
						List keyList = new ArrayList();
						while (es.hasMoreElements()) {
							keyList.add(es.nextElement());
						}
						Collections.sort(keyList);
						for (int i = 0; i < keyList.size(); i++) {
							String skey = (String) keyList.get(i);
							out.println("<tr>");
							out.println("<td>" + skey + "</td>");
							out.println("<td>" + System.getProperty(skey) + "</td>");
							out.println("</tr>");
						}
					%>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>