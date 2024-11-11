<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="utf-8">
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <meta name="description" content="SH서울주택도시공사 | 토지자원관리시스템">

    <link rel="shortcut icon" href="/jsp/SH/img/favicon.ico">

    <!--DatePicker css-->
    <link href="/jsp/SH/css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <!-- DateTimePicker -->
    <link href="/jsp/SH/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />

	<!--Morris Chart CSS -->
    <link href="/jsp/SH/css/morris.css" rel="stylesheet" />

    <!-- App css -->
    <link href="/jsp/SH/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/components.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/icons.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/core.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="css/bootstrap.min.css">
	<link rel="stylesheet" href="css/bootstrap-theme.min.css">




    <!-- jQuery Library -->
	<script src="/jsp/SH/js/jquery.min.js"></script>
	<script src="/jsp/SH/js/bootstrap.min.js"></script>

	<!-- Validate -->
	<script src="/jsp/SH/js/jquery.validate.min.js"></script>

	<!-- DatePicker  -->
	<script src="/jsp/SH/js/moment-with-locales.min.js"></script>
	<script src="/jsp/SH/js/bootstrap-datepicker.min.js"></script>

	<!-- DateTimePicker -->
	<script src="/jsp/SH/js/bootstrap-datetimepicker.min.js"></script>

	<!--Morris Chart-->
	<script src="/jsp/SH/js/morris.min.js"></script>
	<script src="/jsp/SH/js/raphael-min.js"></script>

	<!-- Jquery UI for Draggable-->
	<script src="/jsp/SH/js/jquery-ui.min.js"></script>

	<!-- Jquery multi-select-->
	<script src="/jsp/SH/js/chosen.jquery.js"></script>
	<link href="/jsp/SH/css/chosen.css" rel="stylesheet" type="text/css" />

	<!-- App css : 슬라이더바 css -->
	<link href="/jsp/SH/css/jquery-ui.css" rel="stylesheet" />

	<!-- Table Sort -->
	<script src="/jsp/SH/js/stupidtable.js"></script>

	<!-- OpenLayers -->
<!-- 	<link href="/jsp/SH/js/openLayers/v4.3.1/ol.css" rel="stylesheet" /> -->
<!-- 	<script src="/jsp/SH/js/openLayers/v4.3.1/ol.js"></script> -->
<!-- 	<script src="/jsp/SH/js/openLayers/v4.3.1/polyfill.min.js"></script> -->
<!--
	<link href="/jsp/SH/js/openLayers/v3.20.2/ol.css" rel="stylesheet" />
	<script src="/jsp/SH/js/openLayers/v3.20.2/ol.js"></script>
 -->

	<!-- <link rel="stylesheet" type="text/css" href="https://openlayers.org/en/v6.1.1/css/ol.css"/>
	<script src="https://openlayers.org/en/v6.1.1/build/ol.js"></script> -->
	<script src="/jsp/SH/js/ol.js"></script>
    <link href="/jsp/SH/css/ol.css" rel="stylesheet" type="text/css" />

	<!-- Map Export is PNG  -->
	<script type="text/javascript" src="/jsp/SH/js/mapExport/html2canvas.js"></script>
	<script type="text/javascript" src="/jsp/SH/js/mapExport/FileSaver.js"></script>
	<script type="text/javascript" src="/jsp/SH/js/mapExport/canvas-toBlob.js"></script>

	<!-- Data Export is shapefile  -->
<!--     <script type="text/javascript" src="/jsp/SH/js/SHPExport/arcgisAPI.js"></script> -->
<!-- 	<script type="text/javascript" src="/jsp/SH/js/SHPExport/FileSaver.js"></script> -->
	<script type="text/javascript" src="/jsp/SH/js/SHPExport/FileSaveTools.js"></script>
	<script type="text/javascript" src="/jsp/SH/js/SHPExport/jDataView_write.js"></script>
	<script type="text/javascript" src="/jsp/SH/js/SHPExport/JS2Shapefile.js"></script>

	<!-- App js -->
	<script src="/jsp/SH/js/add_search.js"></script>

	<!-- proj4js -->
	<script src="/jsp/SH/js/proj4js/proj4js-combined.js"></script>

	<!-- potalMap is DaumAPI  -->
	<!-- 로컬개발용 -->
<!-- 	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=dd814c573b22a7079068883df930cc51"></script> -->
	<!-- 외부접근개발용 cjw-->
	<!-- 도메인 d0394d7f6c8fc30c4691961f46dda74b -->
	<!-- 개발서버 df18173693aa3948700c2fb9097f03a4 -->
	<!-- 로컬 73de49f305c6e0f34db3ca8dc7135a1e -->
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=73de49f305c6e0f34db3ca8dc7135a1e"></script>
	<!-- 실서버용 -->
<!-- 	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=6d4240cef136cd89d4d4fcf442331b53"></script> -->

	<!-- 신영ESD서버용 -->
<!-- <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a0d37957532262602e2dca4450170302"></script> -->


	<!-- vworldMap API -->
<!--  <script type="text/javascript" src="http://map.vworld.kr/js/vworldMapInit.js.do?apiKey=BFFB2C1C-DD2D-3D74-83D9-EB15D4F041C8"></script>  -->
<!-- <script type="text/javascript" src="http://map.vworld.kr/js/vworldMapInit.js.do?apiKey=61646DCA-58DC-385D-B53F-A34F0E7A2E53"></script> -->
<!-- <script type="text/javascript" src="http://map.vworld.kr/js/vworldMapInit.js.do?apiKey=C1314EF3-8396-3600-95A8-AC6FE95A4A91"></script>   -->

	<!-- SGIS통계 API - 실서버 -->
	<!-- 서비스ID:eff289594dc24220b504 // 보안Key:ef44c972fb204d328279 // AccessToken:d1f435dd-5d53-4cd9-940c-a651988d3e95 -->
<!-- 	<script type="text/javascript" src="https://sgisapi.kostat.go.kr/OpenAPI3/auth/javascriptAuth?consumer_key=eff289594dc24220b504"></script> -->

	<!-- SGIS통계 API - 신영ESD -->
	<!-- 서비스ID:901fa1a441694b2689a4 // 보안Key:06af0c831c284955a99f  -->
	<!-- <script type="text/javascript" src="https://sgisapi.kostat.go.kr/OpenAPI3/auth/javascriptAuth?consumer_key=901fa1a441694b2689a4"></script> -->

<!--
//가구원수별 가구 - 읍면동
http://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=MjI0MDc2ODFmYTQ4ZWVkY2Y5YzNmZWQwNzJmOTI1MDM=&format=json&jsonVD=Y&userStatsId=luckinees/101/DT_1JC1502/2/1/20171205201438&prdSe=Y&newEstPrdCnt=1

서울주택도시공사 내부업무 시스템 개발용(TEST)
국공유지에 대한 통계정보를 확인하여 사용자의 의사결정지원에 도움이 되도록 활용하는 목적
-->

	<title>SH | 토지자원관리시스템</title>



</head>
<body>

	<c:import url="/jsp/SH/landmanager/Content_Header.jsp"></c:import>

	<!-- Alert Pop-up -->
	<div class="alert-box-wrap hidden">
		<div class="alert-box land-manager">
	        <div class="alert-box-header tit">
	            <div class="alert-box-title">알림</div>
	        </div>
	        <div class="alert-box-content">
	            <p class="m-b-0 font-600">검색속도를 위해 [시군구]를 반드시 선택하세요.</p>
	        </div>
	        <div class="alert-box-footer">
	            <div class="text-right">
	                <button class="btn btn-custom">확인</button>
	            </div>
	        </div>
	    </div>
    </div>
    <!--// Alert Pop-up -->

	<div id="load">
	    <img src="/jsp/SH/img/ajax-loader.gif"><p>LOADING</p>
	</div>

	<c:import url="/landmanager_Content.do"></c:import>







    <script type="text/javascript" src='/jsp/SH/js/map/geoMap.js'></script>
     
   <!--  <script type="text/javascript" src='/jsp/SH/js/map/potalMap_daum.js'></script> -->
    <script type="text/javascript" src='/jsp/SH/js/map/geoMap_menu.js'></script>

	<script type="text/javascript" src="/jsp/SH/js/jquery.app.js"></script>

<script type="text/javascript">
    (function($) {

        $.fn.sizeChanged = function(handleFunction) {

            var element = this;
            var lastWidth = element.width();
            var lastHeight = element.height();

            setInterval(function() {
                if (lastWidth === element.width() && lastHeight === element.height())
                    return;
                if (typeof(handleFunction) == 'function') {
                    handleFunction({
                        width: lastWidth,
                        height: lastHeight
                    }, {
                        width: element.width(),
                        height: element.height()
                    });
                    lastWidth = element.width();
                    lastHeight = element.height();
                }
            }, 100);


            return element;
        };

    }(jQuery));


    var toggles = true;
    function main_toggle(){
    	if(toggles){
        	$("#search, #main-panel, #main-panel-01, #main-panel-02, #bookmark-pop").hide();
        	$('#searching_item').toggleClass('hidden');
        	$('#searching_data').toggleClass('hidden');
        	$('#searching_space').toggleClass('hidden');
        	toggles = false;
        }else{
        	$("#search, #main-panel, #main-panel-01, #main-panel-02, #bookmark-pop").show();
        	$('#searching_item').toggleClass('hidden');
        	$('#searching_data').toggleClass('hidden');
        	$('#searching_space').toggleClass('hidden');
        	toggles = true;
        }
    }
    $(document).ready(function() {

    	//드래그
        $('.layer-pop, .info-layer-stat, .bookmark-pop').draggable({
            cursor: 'move',
            handle: '.tit',
            containment: 'parent'
        });

    	//레이아웃 토글
    	$('#menu-toggle-btn, #menu-toggle-btn02').click(function() {
            $('header').toggleClass('hidden');
            $('.wrapper').toggleClass('menu-hidden');
            $('.wrapper-content').toggleClass('menu-hidden');
            $('.sel-map').toggleClass('menu-hidden');
            $('.map-layer .map-layer-btn').toggleClass('menu-hidden');
            $('.map-layer .map-layer-btn-group').toggleClass('menu-hidden');
            $('.map-content').toggleClass('menu-hidden');
            $('.menu-toggle-btn02').toggleClass('menu-hidden');

            //지도화면 크기조정
            var omapSize = geoMap.getSize();
			omapSize[1] = $("#geomap").height();
			geoMap.setSize(omapSize);
            geoMap.render();
    		geoMap.renderSync();

    		$(window).trigger('resize');
        });


        $("#search, #main-panel, #main-panel-01, #main-panel-02, #bookmark-pop").show();
        $('#main-panel-btn').click(function() {
        	main_toggle();
        });

        $('#selectArrowBtn').click(function() {
        	$('#main-panel').toggleClass('hidden');
        });


        $('#main-panel-close').click(function() {
            $('#main-panel').toggleClass('hidden');
        });









//         $('.popover-content-wrap.detail-view').css({height: ($(window).height() -200-114) +"px", maxHeight: 'none'});

//         $(window).resize(function() {
//             $('.popover-content-wrap.detail-view').css({height: ($(window).height() -200-114) +"px", maxHeight: 'none'});
//         });

//         var popoverDeWrapHeight = $('.popover-content-wrap.detail-view').outerHeight(true);

//         $('.popover-content-wrap.detail-view .card-box.box1').css('height', popoverDeWrapHeight-105);
//         $('.popover-content-wrap.detail-view .card-box.box2').css('height', (popoverDeWrapHeight/2) -62.5);
//         $('.popover-content-wrap.detail-view .card-box.box3').css('height', (popoverDeWrapHeight/2) -62.5);
//         $('.tab-content.detail-view').css('height', popoverDeWrapHeight-118-45);

//         $(window).resize(function() {
//             var popoverDeWrapHeight = $('.popover-content-wrap.detail-view').outerHeight(true);
//             $('.popover-content-wrap.detail-view .card-box.box1').css('height', popoverDeWrapHeight-105);
//             $('.popover-content-wrap.detail-view .card-box.box2').css('height', (popoverDeWrapHeight/2) -62.5);
//             $('.popover-content-wrap.detail-view .card-box.box3').css('height', (popoverDeWrapHeight/2) -62.5);
//             $('.tab-content.detail-view').css('height', popoverDeWrapHeight-118-45);
//         });






        // 탭 영역 활성화 시 Morris Chart 한 번 만 실행

        var a=0;

        $('#chart-tab .layer-info-wrap').sizeChanged(function() {
            if(a == 0) {
                a = 1;
                !function ($) {
                    "use strict";

                    var MorrisCharts = function () {
                    };

                    //creates line chart
                    MorrisCharts.prototype.createLineChart = function (element, data, xkey, ykeys, labels, opacity, Pfillcolor, Pstockcolor, lineColors) {
                        Morris.Line({
                            element: element,
                            data: data,
                            xkey: xkey,
                            ykeys: ykeys,
                            labels: labels,
                            fillOpacity: opacity,
                            pointFillColors: Pfillcolor,
                            pointStrokeColors: Pstockcolor,
                            behaveLikeLine: true,
                            gridLineColor: '#eef0f2',
                            hideHover: 'auto',
                            lineWidth: '3px',
                            pointSize: 0,
                            preUnits: '$',
                            resize: true, //defaulted to true
                            lineColors: lineColors
                        });
                    },
                        //creates area chart
                        MorrisCharts.prototype.createAreaChart = function (element, pointSize, lineWidth, data, xkey, ykeys, labels, lineColors) {
                            Morris.Area({
                                element: element,
                                pointSize: 0,
                                lineWidth: 0,
                                data: data,
                                xkey: xkey,
                                ykeys: ykeys,
                                labels: labels,
                                hideHover: 'auto',
                                resize: true,
                                gridLineColor: '#eef0f2',
                                lineColors: lineColors
                            });
                        },
                        //creates area chart with dotted
                        MorrisCharts.prototype.createAreaChartDotted = function (element, pointSize, lineWidth, data, xkey, ykeys, labels, Pfillcolor, Pstockcolor, lineColors) {
                            Morris.Area({
                                element: element,
                                pointSize: 3,
                                lineWidth: 1,
                                data: data,
                                xkey: xkey,
                                ykeys: ykeys,
                                labels: labels,
                                hideHover: 'auto',
                                pointFillColors: Pfillcolor,
                                pointStrokeColors: Pstockcolor,
                                resize: true,
                                smooth: false,
                                gridLineColor: '#eef0f2',
                                lineColors: lineColors
                            });
                        },
                        //creates Bar chart
                        MorrisCharts.prototype.createBarChart = function (element, data, xkey, ykeys, labels, lineColors) {
                            Morris.Bar({
                                element: element,
                                data: data,
                                xkey: xkey,
                                ykeys: ykeys,
                                labels: labels,
                                hideHover: 'auto',
                                resize: true, //defaulted to true
                                gridLineColor: '#eeeeee',
                                barSizeRatio: 0.4,
                                xLabelAngle: 35,
                                barColors: lineColors
                            });
                        },
                        //creates Stacked chart
                        MorrisCharts.prototype.createStackedChart = function (element, data, xkey, ykeys, labels, lineColors) {
                            Morris.Bar({
                                element: element,
                                data: data,
                                xkey: xkey,
                                ykeys: ykeys,
                                stacked: true,
                                labels: labels,
                                hideHover: 'auto',
                                resize: true, //defaulted to true
                                gridLineColor: '#eeeeee',
                                barColors: lineColors
                            });
                        },
                        //creates Donut chart
                        MorrisCharts.prototype.createDonutChart = function (element, data, colors) {
                            Morris.Donut({
                                element: element,
                                data: data,
                                resize: true, //defaulted to true
                                colors: colors
                            });
                        },
                        MorrisCharts.prototype.init = function () {

                            //create line chart
                            var $data = [
                                {y: '2008', a: 50, b: 0},
                                {y: '2009', a: 75, b: 50},
                                {y: '2010', a: 30, b: 80},
                                {y: '2011', a: 50, b: 50},
                                {y: '2012', a: 75, b: 10},
                                {y: '2013', a: 50, b: 40},
                                {y: '2014', a: 75, b: 50},
                                {y: '2015', a: 100, b: 70}
                            ];
                            this.createLineChart('morris-line-example', $data, 'y', ['a', 'b'], ['Series A', 'Series B'], ['0.1'], ['#ffffff'], ['#999999'], ['#188ae2', '#4bd396']);

                            //creating area chart
                            var $areaData = [
                                {y: '2009', a: 10, b: 20},
                                {y: '2010', a: 75, b: 65},
                                {y: '2011', a: 50, b: 40},
                                {y: '2012', a: 75, b: 65},
                                {y: '2013', a: 50, b: 40},
                                {y: '2014', a: 75, b: 65},
                                {y: '2015', a: 90, b: 60}
                            ];
                            this.createAreaChart('morris-area-example', 0, 0, $areaData, 'y', ['a', 'b'], ['Series A', 'Series B'], ['#8d6e63', "#bdbdbd"]);

                            //creating area chart with dotted
                            var $areaDotData = [
                                {y: '2009', a: 10, b: 20},
                                {y: '2010', a: 75, b: 65},
                                {y: '2011', a: 50, b: 40},
                                {y: '2012', a: 75, b: 65},
                                {y: '2013', a: 50, b: 40},
                                {y: '2014', a: 75, b: 65},
                                {y: '2015', a: 90, b: 60}
                            ];
                            this.createAreaChartDotted('morris-area-with-dotted', 0, 0, $areaDotData, 'y', ['a', 'b'], ['Series A', 'Series B'], ['#ffffff'], ['#999999'], ['#6b5fb5', "#bdbdbd"]);

                            //creating bar chart
                            var $barData = [
                                {y: '2009', a: 100, b: 90, c: 40},
                                {y: '2010', a: 75, b: 65, c: 20},
                                {y: '2011', a: 50, b: 40, c: 50},
                                {y: '2012', a: 75, b: 65, c: 95},
                                {y: '2013', a: 50, b: 40, c: 22},
                                {y: '2014', a: 75, b: 65, c: 56},
                                {y: '2015', a: 100, b: 90, c: 60}
                            ];
                            this.createBarChart('morris-bar-example', $barData, 'y', ['a', 'b', 'c'], ['Series A', 'Series B', 'Series C'], ['#3ac9d6', '#ff9800', "#f5707a"]);

                            //creating Stacked chart
                            var $stckedData = [
                                {y: '2005', a: 45, b: 180},
                                {y: '2006', a: 75, b: 65},
                                {y: '2007', a: 100, b: 90},
                                {y: '2008', a: 75, b: 65},
                                {y: '2009', a: 100, b: 90},
                                {y: '2010', a: 75, b: 65},
                                {y: '2011', a: 50, b: 40},
                                {y: '2012', a: 75, b: 65},
                                {y: '2013', a: 50, b: 40},
                                {y: '2014', a: 75, b: 65},
                                {y: '2015', a: 100, b: 90}
                            ];
                            this.createStackedChart('morris-bar-stacked', $stckedData, 'y', ['a', 'b'], ['Series A', 'Series B'], ['#26a69a', '#ebeff2']);

                            //creating donut chart
                            var $donutData = [
                                {label: "Electricity", value: 12},
                                {label: "Financial", value: 30},
                                {label: "Markets", value: 20}
                            ];
                            this.createDonutChart('morris-donut-example', $donutData, ['#4bd396', '#ebeff2', "#3ac9d6"]);
                        },
                        //init
                        $.MorrisCharts = new MorrisCharts, $.MorrisCharts.Constructor = MorrisCharts;
                }(window.jQuery);

                $.MorrisCharts.init();
            }
        });





    });
	</script>


</body>

