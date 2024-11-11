<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style>
	#container {position:relative;}
	#btnRoadview,  #btnMap {position:absolute;top:30px;left:5px;font-size:14px;z-index:1;cursor:pointer;}
	#btnRoadview:hover,  #btnMap:hover{background-color: #fcfcfc;border: 1px solid #c1c1c1;}
 	#container.view_map #roadview {display: none;}
	#container.view_map #btnMap {display: none;}
 	#container.view_roadview #roadview {display:block;}
	#container.view_roadview #btnRoadview {display: none;}

	.MapWalker {position:absolute;margin:-26px 0 0 -51px}
    .MapWalker .figure {position:absolute;width:25px;left:38px;top:-2px; height:39px;background:url(http://i1.daumcdn.net/localimg/localimages/07/2012/roadview/roadview_minimap_wk.png) -298px -114px no-repeat}
    .MapWalker .angleBack {width:102px;height:52px;background: url(http://i1.daumcdn.net/localimg/localimages/07/2012/roadview/roadview_minimap_wk.png) -834px -2px no-repeat;}
    .MapWalker.m0 .figure {background-position: -298px -114px;}
    .MapWalker.m1 .figure {background-position: -335px -114px;}
    .MapWalker.m2 .figure {background-position: -372px -114px;}
    .MapWalker.m3 .figure {background-position: -409px -114px;}
    .MapWalker.m4 .figure {background-position: -446px -114px;}
    .MapWalker.m5 .figure {background-position: -483px -114px;}
    .MapWalker.m6 .figure {background-position: -520px -114px;}
    .MapWalker.m7 .figure {background-position: -557px -114px;}
    .MapWalker.m8 .figure {background-position: -2px -114px;}
    .MapWalker.m9 .figure {background-position: -39px -114px;}
    .MapWalker.m10 .figure {background-position: -76px -114px;}
    .MapWalker.m11 .figure {background-position: -113px -114px;}
    .MapWalker.m12 .figure {background-position: -150px -114px;}
    .MapWalker.m13 .figure {background-position: -187px -114px;}
    .MapWalker.m14 .figure {background-position: -224px -114px;}
    .MapWalker.m15 .figure {background-position: -261px -114px;}
    .MapWalker.m0 .angleBack {background-position: -834px -2px;}
    .MapWalker.m1 .angleBack {background-position: -938px -2px;}
    .MapWalker.m2 .angleBack {background-position: -1042px -2px;}
    .MapWalker.m3 .angleBack {background-position: -1146px -2px;}
    .MapWalker.m4 .angleBack {background-position: -1250px -2px;}
    .MapWalker.m5 .angleBack {background-position: -1354px -2px;}
    .MapWalker.m6 .angleBack {background-position: -1458px -2px;}
    .MapWalker.m7 .angleBack {background-position: -1562px -2px;}
    .MapWalker.m8 .angleBack {background-position: -2px -2px;}
    .MapWalker.m9 .angleBack {background-position: -106px -2px;}
    .MapWalker.m10 .angleBack {background-position: -210px -2px;}
    .MapWalker.m11 .angleBack {background-position: -314px -2px;}
    .MapWalker.m12 .angleBack {background-position: -418px -2px;}
    .MapWalker.m13 .angleBack {background-position: -522px -2px;}
    .MapWalker.m14 .angleBack {background-position: -626px -2px;}
    .MapWalker.m15 .angleBack {background-position: -730px -2px;}
</style>

<script type="text/javascript">
$(document).ready(function(){

	$("#toggle_layersLine li>div>a").click(function(){
		$("#toggle_layersLine li").not($(this).parent().parent()).removeClass("active");
		$(this).parent().parent().toggleClass("active");
	});

	$("#toggle_layers li>div>a").click(function(){
		$("#toggle_layers li").not($(this).parent().parent()).removeClass("active");
		$(this).parent().parent().toggleClass("active");
	});

	$("#toggle_layersCity li>div>a").click(function(){
		$("#toggle_layersCity li").not($(this).parent().parent()).removeClass("active");
		$(this).parent().parent().toggleClass("active");
	});

	$("#toggle_layersCity1 li>div>a").click(function(){
		$("#toggle_layersCity1 li").not($(this).parent().parent()).removeClass("active");
		$(this).parent().parent().toggleClass("active");
	});

	$("#toggle_layersCity2 li>div>a").click(function(){
		$("#toggle_layersCity2 li").not($(this).parent().parent()).removeClass("active");
		$(this).parent().parent().toggleClass("active");
	});

	$("#toggle_layersCity3 li>div>a").click(function(){
		$("#toggle_layersCity3 li").not($(this).parent().parent()).removeClass("active");
		$(this).parent().parent().toggleClass("active");
	});

	$("#toggle_layersCity4 li>div>a").click(function(){
		$("#toggle_layersCity4 li").not($(this).parent().parent()).removeClass("active");
		$(this).parent().parent().toggleClass("active");
	});

});

function showTooltip(a){
	$("#"+a).toggleClass("hide");
}

</script>

<!-- map-container -->
<div class="container-fluid map">

    	<!-- Map-Content -->
        <div class="map-content">

        	<div id="geomap" style="width:100%; height:100%; float:left;" ></div>

			<div id="potalmap_div" style="width:50%; height:100%; float:left; display:none;">
				<div id="container" class="view_map" style="width:100%; height:100%; float:left; ">
				    <div id="mapWrapper" style="width:100%;height:100%;position:absolute; bottom:0px; right:0px;">
				        <div id="dmap" style="width:100%;height:100%;"></div>
				        <button class="btn btn-teal btn-sm text-left" id="btnRoadview" onclick="toggleMap(false)">로드뷰</button>
				    </div>
				    <div id="rvWrapper" style="width:100%;height:100%;position:absolute;">
				        <div id="roadview" style="height:100%;"></div>
				        <button class="btn btn-teal btn-sm text-left" id="btnMap" onclick="toggleMap(true)">지도</button>
				    </div>
			    </div>
		    </div>

			<!-- 상단 대메뉴 토글 버튼 02 -->
            <div class="menu-toggle-btn02">
                <button class="btn btn-darkgreen btn-sm" id="menu-toggle-btn02"><i class="fa fa-bars text-info"></i></button>
            </div>
            <!--// End 상단 대메뉴 토글 버튼 02 -->

            <div class="btn-group sel-map">
                <button type="button" class="btn btn-sm btn-darkgray" onclick="baseMap_change('Base');">일반</button>
                <button type="button" class="btn btn-sm btn-darkgray" onclick="baseMap_change('Satellite');">위성</button>
                <button type="button" class="btn btn-sm btn-darkgray" onclick="baseMap_change('gray');">흑백지도</button>
                <button type="button" class="btn btn-sm btn-darkgray" onclick="baseMap_change('cbnd');">지적도</button>
                <button type="button" class="btn btn-sm btn-darkgray" onclick="potalMap();">로드뷰</button>
            </div>

            <div class="map-controls">
                <div class="btn-group-vertical map-toolbar">
                    <button type="button" class="btn btn-sm btn-teal m01" data-toggle="tooltip" data-placement="left" title="전체" onclick="FullExtent()">전체</button>
                    <button type="button" class="btn btn-sm btn-teal m06" data-toggle="tooltip" data-placement="left" title="확대" onclick="ZoomIn()">확대</button>
                    <button type="button" class="btn btn-sm btn-teal m07" data-toggle="tooltip" data-placement="left" title="축소" onclick="ZoomOut()">축소</button>
                    <button type="button" class="btn btn-sm btn-teal m02" data-toggle="tooltip" data-placement="left" title="거리재기" onclick="measureLength()">거리</button>
                    <button type="button" class="btn btn-sm btn-teal m03" data-toggle="tooltip" data-placement="left" title="면적재기" onclick="measureArea()">면적</button>
                    <!-- <button type="button" class="btn btn-sm btn-teal m04" data-toggle="tooltip" data-placement="left" title="정보조회" onclick="ClickSelect();">정보조회</button> -->
                    <button type="button" style='background-color: #FFCA9B !important;' class="btn btn-sm btn-teal m04" data-toggle="tooltip" data-placement="left" title="정보조회" onclick="ClickSelect();">정보조회</button>
                    <!-- 2020 추가 -->
                    <!-- <button type="button" class="btn btn-sm btn-teal m04-2" data-toggle="tooltip" data-placement="left" title="정보조회" onclick="ClickSelect();">정보조회</button> -->
                    <button type="button" class="btn btn-sm btn-teal m05" data-toggle="tooltip" data-placement="left" title="새로고침" onclick="Redraw()">지우기</button>
                    <button type="button" class="btn btn-sm btn-teal m08" data-toggle="tooltip" data-placement="left" title="이미지저장" onclick="export_png()">이미지저장</button>
                </div>
            </div>

			<!-- 2020 추가 -->
			<%--
			<div class="map-layer">
                <button type="button" class="btn btn-sm btn-darkgray map-layer-btn"><i class="mdi mdi-layers m-r-5"></i>주제도</button>
                <div class="map-layer-btn-group btn-group-vertical btn-group-sm hidden">
				    <c:import url="/jsp/SH_/landmanager/Content_Map_led.jsp"></c:import>
                </div>
			</div>
			 --%>

			<!-- 2020 추가 -->
            <div class="map-layer">
                <button type="button" class="btn btn-sm btn-darkgray map-layer-btn" id='shape_upload' name='shape_upload'><i class="mdi mdi-layers m-r-5"></i>ESRI Shape 업로드</button>
			</div>

        </div>
        <!-- End Map-Content -->

</div>
<!--// End map-container -->








