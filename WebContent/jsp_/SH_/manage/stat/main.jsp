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

      
    <!-- jQuery Library -->
	<script src="/jsp/SH/js/jquery.min.js"></script>
	<script src="/jsp/SH/js/bootstrap.min.js"></script>
	
	<!-- Validate -->
<!--     <script src="/jsp/SH/js/jquery.validate.min.js"></script> -->
    
    <!-- Morris Chart -->
    <script src="/jsp/SH/js/morris.min.js"></script>
        
	<!-- TUI Chart -->
    <script src="/jsp/SH/js/tui-code-snippet.min.js"></script>
    <script src="/jsp/SH/js/raphael.min.js"></script>
    <script src="/jsp/SH/js/tui-chart.min.js"></script>
        
    <!-- Jquery filer js -->
<!--     <script src="/jsp/SH/js/jquery.filer.min.js"></script> -->
                
    <!-- App js -->
	<script src="/jsp/SH/js/add_manage_stat.js"></script>
        
	<!-- HTML5 Shiv and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->
    
	<title>SH | 토지자원관리시스템</title>
</head>

<body>	
	
	<c:import url="/main_header.do"></c:import>
	
	<div id="load">
	    <img src="/jsp/SH/img/ajax-loader.gif"><p>LOADING</p>
	</div>
	
	<div class="wrapper">
	    <div class="container">
	        <!-- Page-Title -->
	        <div class="row">
	            <div class="col-sm-12">
	                <div class="page-title-box">
	                    <div class="btn-group pull-right">
	                        <ol class="breadcrumb hide-phone p-0 m-0">
	                            <li>
	                                <a href="/dashboard.do">HOME</a>
	                            </li>
	                            <li>
	                                <a href="/manage_user_list.do">시스템 관리</a>
	                            </li>
	                            <li class="active">
	                                시스템 현황
	                            </li>
	                        </ol>
	                    </div>
	                    <h4 class="page-title">시스템 현황</h4>
	                </div>
	            </div>
	        </div>
	        <!-- End Page-Title -->
	
	        <div class="row">
	            <div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
	
	                    <h5 class="header-title"><b>항목설정</b></h5>
	                    <!-- Table-Content-Wrap -->
	                    <div class="sysstat-wrap m-t-30 m-b-30">
	                        <div class="row">
	                            <div class="col-sm-6">
	                                <div class="card-box">
	                                    <p class="card-box-title">항목</p>
	                                    <div class="card-box-inner p-30 p-t-0 p-b-0">
	                                        <div class="row">
	                                            <div class="col-xs-12">
	                                                <div class="form-group m-b-0">
	                                                    <div class="radio">
	                                                        <input type="radio" name="radio" value="" id="rd01" checked><label for="rd01">접속량</label>
	                                                    </div>
	                                                    <div class="radio">
	                                                        <input type="radio" name="radio" value="" id="rd02"><label for="rd02">기능 사용</label>
	                                                    </div>
	                                                    <div class="radio">
	                                                        <input type="radio" name="radio" value="" id="rd03"><label for="rd03">데이터 현황</label>
	                                                    </div>
	                                                </div>
	                                            </div>
	                                        </div>
	                                    </div>
	                                </div>
	                            </div>
	                            <div class="col-sm-6">
	                                <div class="card-box">
	                                    <p class="card-box-title">기간</p>
	                                    <div class="card-box-inner p-30 p-t-0">
	                                        <div class="row">
	                                            <div class="col-xs-6 p-l-r-20">
	                                                <div class="radio p-l-r-20">
	                                                    <input type="radio" name="radio" value="" id="rd01" checked><label for="rd01">년도 단위</label>
	                                                </div>
	                                                <select name="" id="" class="input-sm form-control">
	                                                    <option value="">2018년</option>
	                                                </select>
	                                            </div>
	                                            <div class="col-xs-6 p-l-r-20">
	                                                <div class="radio p-l-r-20">
	                                                    <input type="radio" name="radio" value="" id="rd02"><label for="rd02">월 단위</label>
	                                                </div>
	                                                <select name="" id="" class="input-sm form-control">
	                                                    <option value="">전체</option>
	                                                </select>
	                                            </div>
	                                        </div>
	
	                                    </div>
	                                </div>
	                            </div>
	                        </div>
	
	
	
	                        <div class="row text-right">
	                            <div class="col-xs-12">
	                                <button class="btn btn-custom">확인</button>
	                            </div>
	                        </div>
	                        <div class="divider divider-lg"></div>
	
	
	                        <div class="row">
	                            <div class="col-sm-12">
	                                <div class="card-box">
	                                    <p class="card-box-title">2017년 전체</p>
	                                    <div class="card-box-inner p-30 p-t-0" style="height: 500px;">
	                                        <div class="row">
	                                            <div class="col-xs-12">
	                                                <div class="demo-box p-20">
	                                                    <div class="text-center">
	                                                        <ul class="list-inline chart-detail-list">
	                                                            <li class="list-inline-item">
	                                                                <h5 class="text-info"><i class="mdi mdi-crop-square m-r-5"></i>Series A</h5>
	                                                            </li>
	                                                            <li class="list-inline-item">
	                                                                <h5 class="text-orange"><i class="mdi mdi-details m-r-5"></i>Series B</h5>
	                                                            </li>
	                                                            <li class="list-inline-item">
	                                                                <h5 class="text-danger"><i class="mdi mdi-checkbox-blank-circle-outline m-r-5"></i>Series C</h5>
	                                                            </li>
	                                                        </ul>
	                                                    </div>
	                                                    <div id="morris-bar-example" style="height: 400px;"></div>
	                                                </div>
	                                            </div>
	                                        </div>
	                                    </div>
	                                </div>
	                            </div>
	
	                        </div>
	
	                    </div>
	
	                </div>
	            </div>
	        </div>
	
	    </div>
	</div>
	
	<c:import url="/main_footer.do"></c:import>	
		
	
	<script src="/jsp/SH/js/jquery.app.js"></script>
	
<script type="text/javascript">
$(function() {

    !function ($) {
        "use strict";

        var MorrisCharts = function () {
        };

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

            },
            //init
            $.MorrisCharts = new MorrisCharts, $.MorrisCharts.Constructor = MorrisCharts
    }(window.jQuery);

    $.MorrisCharts.init();

});
</script>


</body>

</html>