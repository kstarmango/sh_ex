<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.Property"%> 
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%> 

<div class="header">
    <div class="logo">
    	<a href="${pageContext.request.contextPath}/web/main.do" class="logo" title='SH 전사자원관리시스템 통합 공간정보 시스템!!'> 
        	<img src="${pageContext.request.contextPath}/resources/img/SH_logo.svg" alt="logo">
        </a>
        <span>|</span>
        <h1>전사자원관리시스템 통합 공간정보 시스템</h1>
    </div>

    <div class="nav">
        <a href="${pageContext.request.contextPath}/web/main.do">
            <img src="${pageContext.request.contextPath}/resources/img/icons/Icon_NavMap.svg" alt="map">지도
        </a>
        <a href="${pageContext.request.contextPath}/web/portal/notice.do?boardType=CD00000002&NotiYn=NOTI_NEW_YN">
            <img src="${pageContext.request.contextPath}/resources/img/icons/Icon_NavBoard.svg" alt="board">게시판
        </a>
       <%-- <a href="${pageContext.request.contextPath}/web/admin/mngUser.do" class="active">
        	<img src="${pageContext.request.contextPath}/resources/img/icons/Icon_NavManager.svg" alt="Manager"> 관리자
        </a> --%>
        <c:if test="${sesUserAdminYn eq 'Y'}" var="nameHong" scope="session">
         	<a href="${pageContext.request.contextPath}/web/admin/mngUser.do" class="active">
        		<img src="${pageContext.request.contextPath}/resources/img/icons/Icon_NavManager.svg" alt="Manager"> 관리자
        	</a>
         </c:if>
    </div>

    <div class="user" onclick="">
        <img src="${pageContext.request.contextPath}/resources/img/icons/Icon_User.svg"  alt="user"> 
        ${sesUserPosition}/${sesUserName}
        <!-- user_admin -->
    </div>
</div>
