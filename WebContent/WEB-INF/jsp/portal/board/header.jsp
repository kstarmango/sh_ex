<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.Property"%> 
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%> 
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />

<link rel="stylesheet" href="<c:url value='/resources/css/common/map/common.css'/>">
<script src="<c:url value='/resources/js/portal/init.js'/>"></script>

<script>
var global_props = { 
		vworldKey : '<%=Property.vworldKey %>',
		wmsProxyUrl : '${contextPath}<%=Property.wmsProxyUrl %>',
		geoserverDomain : '<%=Property.geoserverDomain %>',
		domain : '${contextPath}'
	}
</script>

<a href="${pageContext.request.contextPath}/web/main.do"><img class="logo" src="${pageContext.request.contextPath}/resources/img/map/logo.svg" alt="SH서울주택도시공사 로고"></a>
    <nav>
        <ul>
            <li onClick="location.href='${pageContext.request.contextPath}/web/main.do'" style="padding:0">
                <img src="${pageContext.request.contextPath}/resources/img/map/icNav01.svg" alt="지도 아이콘">
                <span style="font-size: medium;">지도</span>
            </li>
            <li class="hover" onClick="location.href='${pageContext.request.contextPath}/web/portal/notice.do?boardType=CD00000002&NotiYn=NOTI_NEW_YN'">
                <img src="${pageContext.request.contextPath}/resources/img/map/icNav02.svg" alt="게시판 아이콘">
                <span style="font-size: medium;">게시판</span>
            </li>
            <c:if test="${sesUserAdminYn eq 'Y'}" var="nameHong" scope="session">
            	<li  style="padding:0" onClick="location.href='${pageContext.request.contextPath}/web/admin/mngUser.do'">
	                <img src="${pageContext.request.contextPath}/resources/img/map/icNav03.svg" alt="관리자 아이콘">
	                <span style="font-size: medium;">관리자</span>
	            </li>
            </c:if>
            <li style="cursor: default;padding:0;">
                <img src="${pageContext.request.contextPath}/resources/img/map/icNav04.svg" alt="user아이콘">
                <%-- <span style="font-size: medium;"> ${sesUserId}</span> --%>
                <span style="font-size: medium;"> ${sesUserPosition}/${sesUserName}</span>
            </li>
        </ul>
    </nav>