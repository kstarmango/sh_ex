<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib uri="http://tiles.apache.org/tags-tiles"
prefix="tiles" %> <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%> <%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%> <%@ taglib
prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <%@ taglib
prefix="spring" uri="http://www.springframework.org/tags"%> <%@ page
import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%@ page session="true"%> <% String polling_time = (String)
session.getAttribute("POLLING_TIME"); if (polling_time != null &&
!"0".equals(polling_time)) { polling_time = polling_time + "000"; } else {
polling_time = "0"; } String ssoId = session.getAttribute("SSO_ID") == null ? ""
: (String) session.getAttribute("SSO_ID"); %>

<!DOCTYPE html>
<html lang="ko">
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<%@ include file="/WEB-INF/jsp/import/map_declare.jsp"%>
		<link rel="stylesheet" href="<c:url value='/resources/css/common/map/reset.css'/>">
		<link rel="stylesheet" href="<c:url value='/resources/css/common/map/common.css'/>">
		<title>SH | 전사자원관리 통합 공간정보 시스템</title>
	</head>
	<body class="map" onload="checkDup();">
		<div id="load" style="display: none">
			<img src="${pageContext.request.contextPath}/resources/img/ajax-loader.gif" alt="로딩바">
			<p>LOADING</p>
		</div>
		<!-- 헤더 -->
		<header id="header">
			<tiles:insertAttribute name="header" />
		</header>
		<div class="mainWrap">
			<!-- 왼쪽영역 -->
			<aside class="left">
				<tiles:insertAttribute name="aside" />
				<div id="sub_content" class="leftPanner" style="display: none; max-height: calc(100vh - 49px)"></div>
			</aside>

			<!-- 본문영역 -->
			<main id="NormalLayout">
				<tiles:insertAttribute name="NormalLayout" />

				<div class="addrSearch">
					<div class="mapModal" style="display: none; max-width: 28rem">
						<div class="head disFlex">
							<h2>
								<span class="text-orange" id="addr_keyword">""</span> 관련사업 분석결과
							</h2>
							<img
								class="closeBtn"
								src="${pageContext.request.contextPath}/resources/img/map/icClose24.svg"
								alt="닫기"
							>
						</div>
					</div>
				</div>

				<jsp:include page="/WEB-INF/jsp/map/contents_anal_result.jsp" />
			</main>

			<!-- 오른쪽영역 -->
			<aside class="right"></aside>
		</div>
		<div>
			<!-- <iframe
				name="ssoiframe"
				width="0"
				height="0"
				frameborder="0"
				scrolling="no"
				style="visibility: hidden"
				title="sso"
			></iframe> -->
			<iframe
				name="ssoiframe"
				width="0"
				height="0"
				style="visibility: hidden"
				title="sso"
			></iframe>
		</div>

		<form
			name="ssoCheckDupForm"
			method="post"
			target="ssoiframe"
		></form>

		<script>
			function checkDup() {
				var ssoId = '<%=ssoId%>';
				//if ( ssoId == null || ssoId == "" ) {
				//location.href = "/";
				//location.href = "/jsp/SH/login.jsp"
				//return;
				//}

				var cycle = '<%=polling_time%>';
				if (cycle > 0) {
					/*
				업무 개발자 수정 필요
				Context Path에 맞춰서 checkDupLogin.jsp 설정 필요
				ex) SSO 호출 URL : https://업무URL/login/sso/RequestConnect.jsp
				    -> 설정값 : /login/sso/checkDupLogin.jsp
			*/
					document.ssoCheckDupForm.action = '/sso/checkDupLogin.jsp'; // sh에 가서 소스 한번더 확인해보기
					document.ssoCheckDupForm.submit();

					setTimeout('checkDup()', cycle);
				}
			}
		</script>
		<script src="<c:url value='/resources/js/common/modal.js'/>"></script>
	</body>
</html>
