<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

<!-- favicon -->
<link rel="shortcut icon" href="<c:url value='/resources/img/favicon.ico'/>">

<!--DatePicker css-->
<link rel="stylesheet" href="<c:url value='/resources/css/util/bootstrap/bootstrap-datepicker.min.css'/>">

<!-- DateTimePicker -->
<link rel="stylesheet" href="<c:url value='/resources/css/util/bootstrap/bootstrap-datetimepicker.min.css'/>">

<!--Morris Chart CSS -->
<link rel="stylesheet" href="<c:url value='/resources/css/util/editor/morris.css'/>">

<!-- App css -->
<link rel="stylesheet" href="<c:url value='/resources/css/util/jquery/jquery-ui.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/util/bootstrap/bootstrap.min.css'/>">
<%-- <link rel="stylesheet" href="<c:url value='/resources/css/util/bootstrap/bootstrap-theme.min.css'/>" /> --%>
<link rel="stylesheet" href="<c:url value='/resources/css/util/fontawesome/icons.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/common/components.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/common/core.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/common/map/draw.css'/>">

<!-- jQuery Library -->
<script  src="<c:url value='/resources/js/util/jquery/jquery.min.js'/>"></script>
<script  src="<c:url value='/resources/js/util/jquery/jquery-ui.min.js'/>"></script>
<script  src="<c:url value='/resources/js/util/jquery/jquery.validate.min.js'/>"></script>
<script  src="<c:url value='/resources/js/util/jquery/jquery.validate.extend.js'/>"></script>
<%-- <script  src="<c:url value='/resources/js/util/jquery/jquery.serialize-object.js'/>"></script> --%>
<script  src="<c:url value='/resources/js/util/bootstrap/bootstrap.min.js'/>"></script>

<!-- DatePicker  -->
<script  src="<c:url value='/resources/js/util/editor/moment-with-locales.min.js'/>"></script>
<script  src="<c:url value='/resources/js/util/bootstrap/bootstrap-datepicker.min.js'/>"></script>

<!-- DateTimePicker -->
<script  src="<c:url value='/resources/js/util/bootstrap/bootstrap-datetimepicker.min.js'/>"></script>

<!--Morris Chart-->
<script  src="<c:url value='/resources/js/util/editor/morris.min.js'/>"></script>
<script  src="<c:url value='/resources/js/util/raphael/raphael-min.js'/>"></script>

<!-- Jquery multi-select-->
<script  src="<c:url value='/resources/js/util/editor/chosen.jquery.js'/>"></script>
<link rel="stylesheet" href="<c:url value='/resources/css/util/editor/chosen.css'/>">	

<!-- Table Sort -->
<script  src="<c:url value='/resources/js/util/editor/stupidtable.js'/>"></script>
	
	<!-- ax5grid -->
	<script  src="<c:url value='/resources/js/util/ax5ui/ax5core.js'/>"></script> 
	<script  src="<c:url value='/resources/js/util/ax5ui/grid/ax5grid.js'/>"></script>
	<link rel="stylesheet" href="<c:url value='/resources/css/util/ax5ui/grid/ax5grid.css'/>">
	
	<!-- ax5calendar -->
	<script  src="<c:url value='/resources/js/util/ax5ui/calendar/ax5calendar.js'/>"></script>
	<link rel="stylesheet" href="<c:url value='/resources/css/util/ax5ui/calendar/ax5calendar.css'/>">
	
	<!-- ax5picker -->
	<script  src="<c:url value='/resources/js/util/ax5ui/picker/ax5picker.js'/>"></script>
	<link rel="stylesheet" href="<c:url value='/resources/css/util/ax5ui/picker/ax5picker.css'/>">
	
	<!-- ax5formatter -->
	<script  src="<c:url value='/resources/js/util/ax5ui/formatter/ax5formatter.js'/>"></script>
	
	<!-- ax5select -->
	<script  src="<c:url value='/resources/js/util/ax5ui/select/ax5select.js'/>"></script>
	<link rel="stylesheet" href="<c:url value='/resources/css/util/ax5ui/select/ax5select.css'/>">
	
	<!-- chart -->
	<!-- Chart.js: v3.7.0
	chartjs-plugin-zoom: v1.2.0
	chartjs-plugin-datalabels: v2.2.0
	chartjs-chart-treemap: v2.0.2 -->
	<script  src="<c:url value='/resources/js/util/chart/chart-3.7.0.min.js'/>"></script>
	<script  src="<c:url value='/resources/js/util/chart/hammer.min.js'/>"></script>
	<script  src="<c:url value='/resources/js/util/chart/chartjs-plugin-datalabels.js'/>"></script>
	<script  src="<c:url value='/resources/js/util/chart/chartjs-chart-treemap.min.js'/>"></script>
	<script  src="<c:url value='/resources/js/util/chart/chartjs-plugin-zoom.js'/>"></script>
		
		
    <!-- 게시판 summernote -->
    <!--<link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.8/summernote.css" rel="stylesheet">
	<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.8/summernote.js"></script> -->
	<link rel="stylesheet" href="<c:url value='/resources/css/util/editor/summernote.css'/>">
	<script  src="<c:url value='/resources/js/util/editor/summernote.js'/>"></script> 
	<script  src="<c:url value='/resources/js/util/editor/summernote-ko-KR.js'/>"></script> 
   
   
    <!-- 사용자 추가 js -->
	<script  src='<c:url value='/resources/js/common/grid.js'/>'></script>
    <script  src="<c:url value='/resources/js/common/transaction.js'/>"></script>
    
    <script  src="<c:url value='/resources/js/admin/adminCommon.js'/>"></script>
	<link rel="stylesheet" href="<c:url value='/resources/css/common/admin_chart.css'/>">
	
