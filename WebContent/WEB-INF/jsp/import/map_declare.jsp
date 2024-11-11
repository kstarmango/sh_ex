<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

<!-- declare-->
<!-- 디자인 script, css -->
<meta charset="utf-8">
<meta http-equiv='X-UA-Compatible' content='IE=edge'>
<!-- <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Expires" content="0">
<meta http-equiv="Pragma" content="no-cache"> -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="SH서울주택도시공사 | 토지자원관리시스템">

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
<%-- <link rel="stylesheet" href="<c:url value='/resources/css/util/bootstrap/bootstrap-theme.min.css'/>"> --%>
<link rel="stylesheet" href="<c:url value='/resources/css/util/fontawesome/icons.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/common/components.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/common/core.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/common/map/draw.css'/>">

<!-- jQuery Library -->
<script  src="<c:url value='/resources/js/util/jquery/jquery.min.js'/>"></script>
<script  src="<c:url value='/resources/js/util/jquery/jquery-ui.min.js'/>"></script>
<script  src="<c:url value='/resources/js/util/jquery/jquery.validate.min.js'/>"></script>
<script  src="<c:url value='/resources/js/util/jquery/jquery.validate.extend.js'/>"></script>
<!-- <script  src="<c:url value='/resources/js/util/jquery/jquery.serialize-object.js'/>"></script> -->
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

<!-- 해당 ol레이어스 경로 -->
<script  src="<c:url value='/resources/js/util/openLayers/ol.js'/>"></script>
<link rel="stylesheet" href="<c:url value='/resources/css/util/openLayers/ol.css'/>">

<!-- Map Export is PNG  -->
<script  src="<c:url value='/resources/js/util/mapExport/html2canvas.js'/>"></script>
<script  src="<c:url value='/resources/js/util/mapExport/FileSaver.js'/>"></script>
<script  src="<c:url value='/resources/js/util/mapExport/canvas-toBlob.js'/>"></script>

<!-- Data Export is shapefile  -->
<script  src="<c:url value='/resources/js/util/SHPExport/FileSaveTools.js'/>"></script>
<script  src="<c:url value='/resources/js/util/SHPExport/jDataView_write.js'/>"></script>
<script  src="<c:url value='/resources/js/util/SHPExport/JS2Shapefile.js'/>"></script>

<!-- App js -->
<%-- <script  src="<c:url value='/resources/js/portal/add_search.js'/>"></script> --%>


	<link rel="stylesheet" href="<c:url value='/resources/css/util/editor/summernote.css'/>">
	<script  src="<c:url value='/resources/js/util/editor/summernote.js'/>"></script> 
	<script  src="<c:url value='/resources/js/util/editor/summernote-ko-KR.js'/>"></script> 

<!-- proj4js -->
<script  src="<c:url value='/resources/js/util/proj4js/proj4js-combined.js'/>"></script>

<!-- minicolor js -->
<link rel="stylesheet" href="<c:url value='/resources/css/util/jquery/jquery.minicolors.css'/>">
<script  src="<c:url value='/resources/js/util/jquery/jquery.minicolors.js'/>"></script>
<link rel="stylesheet" href="<c:url value='/resources/css/util/bootstrap/bootstrap-treeview.min.css'/>">
<script  src="<c:url value='/resources/js/util/bootstrap/bootstrap-treeview.min.js'/>"></script>


<link rel="stylesheet" href="<c:url value='/resources/css/util/coloris/coloris.min.css'/>">
<script  src="<c:url value='/resources/js/util/coloris/coloris.js'/>"></script>


<!-- 2024.08.21 추가 자체 spatialUtilCommon -->
<script  src="<c:url value='/resources/js/map/task/spatialSearch.js'/>"></script> <!-- 임시 -->

<script  src="<c:url value='/resources/js/map/spatialUtilCommon.js'/>"></script>

<!-- ax5ui-grid -->
<%-- <script  src="<c:url value='/resources/js/util/ax5ui/ax5core.js'/>"></script>
<link rel="stylesheet" href="<c:url value='/resources/css/util/ax5ui/grid/ax5grid.css'/>">
<script  src="<c:url value='/resources/js/util/ax5ui/grid/ax5grid.js'/>"></script>
 --%>
 
<script  src="<c:url value='/resources/js/util/ax5ui/ax5core.js'/>"></script> 
<link rel="stylesheet" href="<c:url value='/resources/css/util/ax5ui/grid/ax5grid.css'/>">
<script  src="<c:url value='/resources/js/util/ax5ui/grid/ax5grid.js'/>"></script> 
<script  src="<c:url value='/resources/js/common/grid.js'/>"></script>
<!-- 분석 -->
<script  src="<c:url value='/resources/js/analysis/spatialDistance.js'/>"></script>
<script  src="<c:url value='/resources/js/analysis/commonAnalEvent.js'/>"></script>
<script  src="<c:url value='/resources/js/analysis/analLegend.js'/>"></script>
<script  src="<c:url value='/resources/js/analysis/analSideContent.js'/>"></script>
<script  src="<c:url value='/resources/js/analysis/analLayer.js'/>"></script>
<link rel="stylesheet" href="<c:url value='/resources/css/common/components.css'/>">
<!-- 자체 modal -->
<!-- <script  src="<c:url value='/resources/js/common/modal.js'/>"></script> -->
<!-- 자체 transaction -->
<script  src="<c:url value='/resources/js/common/transaction.js'/>"></script>
<!-- 자체 util -->
<script  src="<c:url value='/resources/js/common/util.js'/>"></script>
<!-- 자체 지도 공통 주소검색 기능.js -->
<script  src="<c:url value='/resources/js/map/event/addrSearch.js'/>"></script>
<!-- 자체 지도 공통 레이어관련 기능.js -->
<script  src="<c:url value='/resources/js/map/event/spatialLayerEvent.js'/>"></script>
<!-- 자체 지도 공통 마이맵 이벤트 기능.js -->
<script  src="<c:url value='/resources/js/map/event/layerEvent.js'/>"></script>
<!-- potalMap is DaumAPI  -->   
<!-- 로컬개발용  dd814c573b22a7079068883df930cc51-->
 <script  src="//dapi.kakao.com/v2/maps/sdk.js?appkey=02896a4463e5c9fb162d72820ab4e5af"></script> 
<!-- 외부접근개발용 cjw-->
<!-- <script  src="//dapi.kakao.com/v2/maps/sdk.js?appkey=73de49f305c6e0f34db3ca8dc7135a1e"></script> -->
<!-- 실서버용 -->
<!-- <script  src="//dapi.kakao.com/v2/maps/sdk.js?appkey=6d4240cef136cd89d4d4fcf442331b53"></script> -->
<!-- 신영ESD서버용 -->
<!-- <script  src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a0d37957532262602e2dca4450170302"></script> -->
<!-- 신영ESD서버용 --><!-- 2020 추가 -->
<!-- <script  src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9ff261a4051cb3801aa6d8f90b1fe032"></script> -->


<%-- <script  src="<c:url value='/resources/js/map/geoMap.js'/>"></script>
<script  src="<c:url value='/resources/js/map/potalMap_daum.js'/>"></script>
<script  src="<c:url value='/resources/js/map/geoMap_menu.js'/>"></script>
<script  src="<c:url value='/resources/js/util/jquery/jquery.app.js'/>"></script> --%>