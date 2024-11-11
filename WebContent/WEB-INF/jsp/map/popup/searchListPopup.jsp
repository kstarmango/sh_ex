<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="<c:url value='/resources/js/util/ax5ui/ax5core.js'/>" /></script> 
<link rel="stylesheet" href="<c:url value='/resources/css/util/ax5ui/grid/ax5grid.css'/>" />
<script type="text/javascript" src="<c:url value='/resources/js/util/ax5ui/grid/ax5grid.js'/>"></script> 

<script type="text/javascript" src="<c:url value='/resources/js/common/grid.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/map/task/spatialSearch.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/map/task/searchView.js'/>"></script>
<script type="text/javascript">
$(document).ready(function() {
	//그리드 초기화
	fn_initGrid();

});

ax5.ui.grid.tmpl.page_status = function(){
    return '<span>{{{progress}}} {{fromRowIndex}} - {{toRowIndex}} of {{dataRowCount}} {{#dataRealRowCount}}  현재페이지 {{.}}{{/dataRealRowCount}} {{#totalElements}}  전체갯수 {{.}}{{/totalElements}}</span>';
};

</script>

</head>
<body>
<div class="popover layer-pop new-pop"  style="width:100%; height:100%; top:auto; display:block;">
	<div class="popover-title tit">
	    <span class="m-r-5">
	        <b>검색결과</b>
	    </span>
	    <span class="small">(전체 <strong class="text-orange" id="total_cnt"></strong> 건)</span>
	</div>
	<div class="popover-body">
		<div class="row btn-wrap-group">
	        <div class="col-xs-12">
	            <div class="btn-wrap text-right">
	                <!-- //ycb 검색결과 전체표출 추가 20180626 onclick="opener.GISSearchList_downExcel()"--> 
	                <button type="button" class="btn btn-xs btn-info" onclick="GISSearchList_DrawAll()">검색결과 지도 표출</button>
	                <button type="button" class="btn btn-xs btn-default" data-grid-control="excel-export" onClick="fn_clickEvnt('excel',grid)" id="search_list_downloade" >엑셀 다운로드</button>
	            </div>
	        </div>
        </div>
        <ul class="nav nav-tabs" id="SH_SearchList_tab">
			<li class="active"><a data-toggle="tab" href="#"  id="c_title">기본검색</a></li>
        </ul>
        <div class="popover-content-wrap asset-srl">
        	<div id="grid" data-ax5grid="first-grid" data-ax5grid-config='{}'  style="height: 500px;cursor: pointer;"></div>
        </div>
	</div>
</div>

</body>
</html>