<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>통합 공간정보시스템</title>
</head>
<script src="<c:url value='/resources/js/portal/add_search.js'/>"></script> 
<script src="<c:url value='/resources/js/map/task/spatialSearch.js'/>"></script>
	<!-- 본문영역 -->
	<tiles:insertAttribute name="sub_content"/>
</html>
