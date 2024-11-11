<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
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

    <!-- App css -->
    <link href="/jsp/SH/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/components.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/icons.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/core.css" rel="stylesheet" type="text/css" />

    <!--Morris Chart CSS -->
    <link href="/jsp/SH/css/morris.css" rel="stylesheet" />
    
    
    <!-- jQuery Library -->
	<script src="/jsp/SH/js/jquery.min.js"></script>
	<script src="/jsp/SH/js/bootstrap.min.js"></script>
	
	<!-- Validate -->
<!--     <script src="/jsp/SH/js/jquery.validate.min.js"></script> -->
        
	<!--Morris Chart-->
	<script src="/jsp/SH/js/morris.min.js"></script>
	<script src="/jsp/SH/js/raphael-min.js"></script>
	
	<!-- OpenLayers4 -->
	<link href="/jsp/SH/js/openLayers/v4.3.1/ol.css" rel="stylesheet" />
	<script src="/jsp/SH/js/openLayers/v4.3.1/ol.js"></script>
	<script src="/jsp/SH/js/openLayers/v4.3.1/polyfill.min.js"></script>
	
	<!-- ol chart style -->
	<script src="/jsp/SH/js/openLayers/v4.3.1/chartstyle.js"></script>
	<script src="/jsp/SH/js/openLayers/v4.3.1/ol.ordering.js"></script>

	<title>SH | 토지자원관리시스템</title>
	
<script language="javascript">

$(document).ready(function(){
	// 레이어 차트 테스트
	<c:forEach var="result" items="${SIGList}" varStatus="status">
		//2번째 통계
		nb=0; data=[]; 
		<c:forEach var="result2" items="${data2}" varStatus="status2">
			<c:if test="${result.sig_cd eq result2.section}" > 
				cnt1 = Number("${result2.category_1}");
				cnt2 = Number("${result2.category_2}");
				cnt3 = Number("${result2.category_3}");
				cnt4 = Number("${result2.category_4}");
				nb = cnt1 + cnt2 + cnt3 + cnt4;
				data.push( cnt1, cnt2, cnt3, cnt4 );
				$stckedData2.push( {y:"${result.name}",	a:cnt1,	b:cnt2, c:cnt3, d:cnt4} );
			</c:if>
		</c:forEach>
		
		/**
		 *  대시보드 클릭시 이동 : id 추가
		 */
		 
		var coord = ol.proj.transform([Number("${result.addr_x}"), Number("${result.addr_y}")], 'EPSG:4326', 'EPSG:900913');
		features2[Number("${status.index}")] = new ol.Feature(
			{	geometry: new ol.geom.Point([coord[0], coord[1]]),
				data: data,
				sum: nb,
				id: "${result.sig_cd}"
			});
		
		//3번째 통계
		nb=0; data=[]; 
		<c:forEach var="result2" items="${data3}" varStatus="status2">
			<c:if test="${result.sig_cd eq result2.section}" > 
				cnt1 = Number("${result2.category_1}");
				cnt2 = Number("${result2.category_2}");
				cnt3 = Number("${result2.category_3}");
				cnt4 = Number("${result2.category_4}");
				nb = cnt1 + cnt2 + cnt3 + cnt4;
				data.push( cnt1, cnt2, cnt3, cnt4 );
				$stckedData3.push( {y:"${result.name}",	a:cnt1,	b:cnt2, c:cnt3, d:cnt4} );
			</c:if>
		</c:forEach>
		
		/**
		 *  대시보드 클릭시 이동 : id 추가
		 */
		 
		var coord = ol.proj.transform([Number("${result.addr_x}"), Number("${result.addr_y}")], 'EPSG:4326', 'EPSG:900913');
		features3[Number("${status.index}")] = new ol.Feature(
			{	geometry: new ol.geom.Point([coord[0], coord[1]]),
				data: data,
				sum: nb,
				id: "${result.sig_cd}"
			});
	</c:forEach>

	
	
	
	chartvector = new ol.layer.Vector(
	{	name: 'Vecteur',
		source: new ol.source.Vector({ features: features2 }),
		// y ordering
		renderOrder: ol.ordering.yOrdering(),
		style: function(f) { return getFeatureStyle(f); }
	});

	geoMap.addLayer(chartvector);

	// Control Select 
	var select = new ol.interaction.Select({
            style: function(f) { return getFeatureStyle(f, true); }
          });
	geoMap.addInteraction(select);
});

//creating Stacked chart
var n, nb=0, data=[];
var $stckedData1 = [];
var $stckedData2 = [];
var $stckedData3 = [];
var $stckedData4 = [];
var features1=[];
var features2=[];
var features3=[];
var features4=[];

var styleCache={};

var listenerKey;

	var animation=false;
	
	var chartvector;

	function getFeatureStyle (feature, sel)
	{	var k = "pie"+"-"+"SH"+"-"+(sel?"1-":"")+feature.get("data");
		var style = styleCache[k];
		if (!style) 
		{	var radius = 30;
			// area proportional to data size: s=PI*r^2
// 			radius = 8* Math.sqrt (feature.get("sum") / Math.PI);
			var data = feature.get("data");
			radius *= (sel?1.2:1);
		
			// Create chart style
			style = [ new ol.style.Style(
				{	image: new ol.style.Chart(
					{	type: "pie", 
						radius: radius, 
						data: data, 
						rotateWithView: true,
						stroke: new ol.style.Stroke(
						{	color: "#fff",
							width: 2
						}),
					})
				})];

			
			
			// Show values on select
			if (sel)
			{	
				var sum = feature.get("sum");
      
				var s = 0;
				for (var i=0; i<data.length; i++)
				{	var d = data[i];
      				var a = (2*s+d)/sum * Math.PI - Math.PI/2; 
					var v = Math.round(d/sum*1000);
					if (v>0)
      				{	style.push(new ol.style.Style(
						{	text: new ol.style.Text(
							{	text: (v/10)+"%", /* d.toString() */
          						offsetX: Math.cos(a)*(radius+10),
          						offsetY: Math.sin(a)*(radius+10),
								textAlign: (a < Math.PI/2 ? "left":"right"),
								textBaseline: "middle",
								stroke: new ol.style.Stroke({ color:"#fff", width:2.5 }),
								fill: new ol.style.Fill({color:"#333"}),
								scale: 2
							})
						}));
					}
					s += d;
				}
			}
		}
		styleCache[k] = style;
		return style;
	}
	
	
	

</script>
</head>

<body class="map">	
	
	<c:import url="/web/main_header.do"></c:import>
	<c:import url="/dashboard_Content.do"></c:import>
	<c:import url="/web/main_footer.do"></c:import>
	<div id="load">
	    <img src="/jsp/SH/img/ajax-loader.gif"><p>LOADING</p>
	</div>
		
<script src="/jsp/SH/js/dashboard.js"></script>

	<script src="/jsp/SH/js/jquery.app.js"></script>
	
<script type="text/javascript">

        $(function() {

                !function ($) {
                    "use strict";

                    var MorrisCharts = function () {
                    };

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

                            
                            this.createStackedChart('morris-bar-stacked2', $stckedData2, 'y', ['a', 'b', 'c', 'd'], 
                            		["대부대상", "매각대상", "매각제한재산", "사용중인재산"], ['#7E3F98', '#213F99', "#00A14B", "#F16521"]);
                            this.createStackedChart('morris-bar-stacked3', $stckedData3, 'y', ['a', 'b', 'c', 'd'], 
                            		["도시재생활성화", "주거환경관리", "희망지", "해제지역"], ['#7E3F98', '#213F99', "#00A14B", "#F16521"]);

                            //creating donut chart
                            var $donutData = [
                                {label: "토지", value: 12},
                                {label: "건물", value: 30},
                                {label: "사업지구", value: 20}
                            ];
                            this.createDonutChart('morris-donut-example', $donutData, ['#3ac9d6', '#ff9800', "#f5707a"]);
                            
                        },
                        //init
                        $.MorrisCharts = new MorrisCharts, $.MorrisCharts.Constructor = MorrisCharts;                       
                }(window.jQuery);

                $.MorrisCharts.init();
                


        });


</script>


</body>

</html>