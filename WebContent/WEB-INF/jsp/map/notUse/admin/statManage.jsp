<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

<!DOCTYPE html>
<html lang="ko">
<head>

 	<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/morris.js/0.5.1/morris.css">
 	<!-- <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script> -->
 	<script src="//cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
	<script src="//cdnjs.cloudflare.com/ajax/libs/morris.js/0.5.1/morris.min.js"></script>

	<script type="text/javascript">
	// 초기화 및 이벤트 등록
	$(document).ready(function() {

		// 초기화
		$("select[name=YEAR]").val(
				"<c:out value='${YEAR}'/>"
		);

		$("select[name=MONTH]").val(
				"<c:out value='${MONTH}'/>"
		);

		$("select[name=DAY]").val(
				"<c:out value='${DAY}'/>"
		);

		$.each($("input[name='statKind']"), function() {
			if($(this).val() == '${stat_kind}') {
            	$(this).attr("checked", true);
			}
        });

		<c:if test="${stat_kind eq 'DAY'}">
			<c:forEach items="${userStatList}" var="result" varStatus="status">
	        	$('#hour${result.hour}').text('${result.cnt}')
	        	<c:if test="${result.hour eq null || result.hour eq ''}">
	        		$('#stats_hour_sum').html('&nbsp;&nbsp;&nbsp;<font size="3" color="red" face="돋움">[ 합계 : ${result.cnt} 건 ]</font> ')
	        	</c:if>
			</c:forEach>
	    	$('#stats_day_result').show();
		</c:if>

		<c:if test="${stat_kind eq 'MONTH'}">
			<c:forEach items="${userStatList}" var="result" varStatus="status">
	    		$('#day${result.day}').text('${result.cnt}')
	        	<c:if test="${result.day eq null || result.day eq ''}">
	        		$('#stats_month_sum').html('&nbsp;&nbsp;&nbsp;<font size="3" color="red" face="돋움">[ 합계 : ${result.cnt} 건 ]</font> ')
	        	</c:if>
			</c:forEach>
			$('#stats_month_result').show();
	    </c:if>

		<c:if test="${stat_kind eq 'YEAR'}">
			<c:forEach items="${userStatList}" var="result" varStatus="status">
	    		$('#month${result.month}').text('${result.cnt}')
	        	<c:if test="${result.month eq null || result.month eq ''}">
	        		$('#stats_year_sum').html('&nbsp;&nbsp;&nbsp;<font size="3" color="red" face="돋움">[ 합계 : ${result.cnt} 건 ]</font> ')
	        	</c:if>
			</c:forEach>
			$('#stats_year_result').show();
	    </c:if>

	    // 기간 radio버튼 변경
	    $('select[name=MONTH]').change(function() {
	    	//var value = $('input[name=statKind]:checked').val();
	    	//if(value == 'MONTH') {
	    		$.ajax({
	    			type : "POST",
	    			async : false,
	    			url : '',<%-- "<%= RequestMappingConstants.WEB_STATS_END_OF_MONTH %>", --%>
	    			dataType : "json",
	    			data : {
	    				year: $("#YEAR option:selected").val(),
	    				month: $("#MONTH option:selected").val()
					},
	    			error : function(response, status, xhr){
	    				if(xhr.status =='403'){
	    					alert('데이터 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
	    				}
	    			},
	    			success : function(data) {
	    		        if(data.result == "Y") {
	    		        	$("#DAY").find("option").remove();
	    		        	for(var i=0; i<data.days.length; i++){
	    		        		$("#DAY").append("<option value='" + data.days[i].search_day + "'>" + data.days[i].search_day + "일</option>");
	    	                }
	    		        }
	    			}
	    		});
	    	//}
	    });

	 	// 검색 버튼 클릭
		$('#btnSearch').click(function(){
			$("#userStatsForm").attr("method", "post");
			$("#userStatsForm").attr("action", "${stat_url}");
			$("#userStatsForm").submit();
		});

		// 엑셀저장
	    var tableId = '';
	    var fileName = 'export.xls';

	    function exportTableToExcel(id, file) {
		    var downloadLink;
		    var dataType = 'application/vnd.ms-excel';
		    var tableSelect = document.getElementById(id);

		    // Specify file name
		    file = file?file+'.xls':'excel_data.xls';

		    //if(navigator.msSaveOrOpenBlob)
		    if(window.navigator.msSaveBlob)
		    {
		        //var blob = new Blob(['\ufeff', tableHTML], {
		        //    type: dataType
		        //});
		        //window.navigator.msSaveOrOpenBlob( blob, file);

		        var tableHTML = tableSelect.outerHTML

		        var blob = new Blob([ tableHTML ], {
					type : "application/csv;charset=utf-8;"
				});
		        window.navigator.msSaveBlob( blob, file);
		    }
		    else
		    {
		    	var tableHTML = tableSelect.outerHTML.replace(/ /g, '%20');

		    	// Create download link element
			    downloadLink = document.createElement("a");

			    document.body.appendChild(downloadLink);

		        downloadLink.href = 'data:' + dataType + 'charset=utf-8,%EF%BB%BF' + tableHTML;
		        downloadLink.download = file;
		        downloadLink.click();
		    }
		}

	 	// 엑셀저장 버튼 클릭
		$('#btnExport1, #btnExport2, #btnExport3').click(function(){
			<c:if test="${stat_kind eq 'DAY'}">
			tableName = 'stats_hour_table';
		    </c:if>

			<c:if test="${stat_kind eq 'MONTH'}">
			tableName = 'stats_month_table';
			</c:if>

			<c:if test="${stat_kind eq 'YEAR'}">
			tableName = 'stats_year_table';
			</c:if>

			tableName2 = 'detail_' + tableName;
			tableName3 = 'group_' + tableName;

			// 기본
			$('#' + tableName).attr('border', '1');
			$('#' + tableName + " th").css({"background-color": "yellow"});
			$('#' + tableName + " th").css({"color": "blue"});

			// 상세
			$('#' + tableName2).attr('border', '1');
			$('#' + tableName2 + " th").css({"background-color": "yellow"});
			$('#' + tableName2 + " th").css({"color": "blue"});

			exportTableToExcel(tableName3, '${sesMenuNavigation.progrm_nm}');

			// 기본
			$('#' + tableName + " th").css({"background-color": ""});
			$('#' + tableName + " th").css({"color": ""});
			$('#' + tableName).attr('border', '0');

			// 상세
			$('#' + tableName2 + " th").css({"background-color": ""});
			$('#' + tableName2 + " th").css({"color": ""});
			$('#' + tableName2).attr('border', '0');
		});


		var $main_elem   = 'main_chart';
		var $detail_elem = 'detail_chart';
        var $barData = [
                        /*
                        {y: '2009', a: 100, b: 90, c: 40},
                        {y: '2010', a: 75, b: 65, c: 20},
                        {y: '2011', a: 50, b: 40, c: 50},
                        {y: '2012', a: 75, b: 65, c: 95},
                        {y: '2013', a: 50, b: 40, c: 22},
                        {y: '2014', a: 75, b: 65, c: 56},
                        {y: '2015', a: 100, b: 90, c: 60}
                        */
    	            	<c:if test="${stat_kind eq 'DAY'}">
    	        			<c:forEach items="${userStatList}" var="result" varStatus="status">
    	        	        	<c:if test="${result.hour ne null && result.hour ne ''}">
    	        	        	{y: '${result.hour}시', x: ${result.cnt}},
    	        	        	</c:if>
    	        			</c:forEach>
    	        		</c:if>

    	        		<c:if test="${stat_kind eq 'MONTH'}">
    	        			<c:forEach items="${userStatList}" var="result" varStatus="status">
    	        	        	<c:if test="${result.day ne null && result.day ne ''}">
    	        	        	{y: '${result.day}일', x: ${result.cnt}},
    	        	        	</c:if>
    	        			</c:forEach>
    	        	    </c:if>

    	        	    <c:if test="${stat_kind eq 'YEAR'}">
    	        			<c:forEach items="${userStatList}" var="result" varStatus="status">
    	        	        	<c:if test="${result.month ne null && result.month ne ''}">
    	        	        	{y: '${result.month}월', x: ${result.cnt}},
    	        	        	</c:if>
    	        			</c:forEach>
    	        	    </c:if>
                    ];

        var $barDetailData = [];

		function fn_mouse_click() {
			$('#main_chart_container').hide();
			$('#detail_chart_container').show();
		}

		function fn_mouse_dblclick() {
			$('#main_chart_container').show();
			$('#detail_chart_container').hide();
		}

		function fn_create_chart(data) {
			$('#' + $detail_elem).remove();
			$('#detail_chart_container_inner').append('<div id="' + $detail_elem + '"  style="height: 400px; display: block"></div>');
			$.MorrisCharts.init('BAR', $detail_elem, data);
		}

		function fn_create_chart_data(data, element) {
        	$barDetailData.length = 0;
        	for(i=0; i< data.statInfo.length; i++)
        		if(data.statInfo[i].disp_nm != null && data.statInfo[i].disp_nm != 'null' && data.statInfo[i].disp_nm != '')
        			$barDetailData.push({y: data.statInfo[i].disp_nm, x: data.statInfo[i].cnt});

        	fn_mouse_click();
			fn_create_chart($barDetailData);

			if(element != undefined && element != '')
			{
	        	for(i=0; i< data.statInfo.length; i++)
	        		if(data.statInfo[i].disp_nm != null && data.statInfo[i].disp_nm != 'null' && data.statInfo[i].disp_nm != '')
	        			$('#' + element + ' tbody').append('<tr><td>' + data.statInfo[i].disp_nm + '</td><td>' + data.statInfo[i].cnt + '</td></tr>');
	        		else
	        			$('#' + element + ' tbody').append('<tr><td>합계</td><td>' + data.statInfo[i].cnt + '</td></tr>');

	        	$('#' + element).show();
			}
		}

		function fn_chart_data_hour(hour) {
    		$.ajax({
    			type : "POST",
    			async : false,
    			url : '',<%-- "<%= RequestMappingConstants.WEB_STATS_DETAIL %>", --%>
    			dataType : "json",
    			data : {
    				year: '${YEAR}',
    				month: '${MONTH}',
    				day: '${DAY}',
    				hour: hour,
    				statKind: 'HOUR',
    				statType: '${stat_type}',
    				statTarget: '${stat_target}'
				},
    			error : function(response, status, xhr){
    				if(xhr.status =='403'){
    					alert('데이터 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
    				}
    			},
    			success : function(data) {
    		        if(data.result == "Y") {
    		        	fn_create_chart_data(data);
    		        }
    			}
    		});
		}

		function fn_chart_data_day(day, element) {
    		$.ajax({
    			type : "POST",
    			async : false,
    			url : '',<%-- "<%= RequestMappingConstants.WEB_STATS_DETAIL %>", --%>
    			dataType : "json",
    			data : {
    				year: '${YEAR}',
    				month: '${MONTH}',
    				day: day,
    				hour: '',
    				statKind: 'DAY',
    				statType: '${stat_type}',
    				statTarget: '${stat_target}'
				},
    			error : function(response, status, xhr){
    				if(xhr.status =='403'){
    					alert('데이터 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
    				}
    			},
    			success : function(data) {
    		        if(data.result == "Y") {
    		        	fn_create_chart_data(data, element);
    		        }
    			}
    		});
		}

		function fn_chart_data_month(month, element) {
    		$.ajax({
    			type : "POST",
    			async : false,
    			url : '',<%-- "<%= RequestMappingConstants.WEB_STATS_DETAIL %>", --%>
    			dataType : "json",
    			data : {
    				year: '${YEAR}',
    				month: month,
    				day: '',
    				hour: '',
    				statKind: 'MONTH',
    				statType: '${stat_type}',
    				statTarget: '${stat_target}'
				},
    			error : function(response, status, xhr){
    				if(xhr.status =='403'){
    					alert('데이터 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
    				}
    			},
    			success : function(data) {
    		        if(data.result == "Y") {
    		        	fn_create_chart_data(data, element);
    		        }
    			}
    		});
		}

		function fn_chart_data_year(month, element) {
    		$.ajax({
    			type : "POST",
    			async : false,
    			url : '',<%-- "<%= RequestMappingConstants.WEB_STATS_DETAIL %>", --%>
    			dataType : "json",
    			data : {
    				year: '${YEAR}',
    				month: '',
    				day: '',
    				hour: '',
    				statKind: 'YEAR',
    				statType: '${stat_type}',
    				statTarget: '${stat_target}'
				},
    			error : function(response, status, xhr){
    				if(xhr.status =='403'){
    					alert('데이터 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
    				}
    			},
    			success : function(data) {
    		        if(data.result == "Y") {
    		        	fn_create_chart_data(data, element);
    		        }
    			}
    		});
		}

		// 일단위 상세 차트
		$("#btnDayDetail").click(function() {
			$('#detail_chart_title').html('통계 차트 상세 &nbsp;&nbsp;&nbsp;<font size="2" color="red" face="돋움">[ 일 전체 ]</font> ');

			$('#detail_stats_hour_table > tbody > tr').remove();
			fn_chart_data_day('${DAY}', 'detail_stats_hour_table');
		});

		// 월단위 상세 차트
		$("#btnMonthDetail").click(function() {
			$('#detail_chart_title').html('통계 차트 상세 &nbsp;&nbsp;&nbsp;<font size="2" color="red" face="돋움">[ 월 전체 ]</font> ');

			$('#detail_stats_month_table > tbody > tr').remove();
			fn_chart_data_month('${MONTH}', 'detail_stats_month_table');
		});

		// 년단위 상세 차트
		$("#btnYearDetail").click(function() {
			$('#detail_chart_title').html('통계 차트 상세 &nbsp;&nbsp;&nbsp;<font size="2" color="red" face="돋움">[ 년 전체 ]</font> ');

			$('#detail_stats_year_table > tbody > tr').remove();
			fn_chart_data_year('${YEAR}', 'detail_stats_year_table');
		});

		// 시단위 상세 - 시간 클릭
		$("#stats_hour_table tbody tr td").click(function() {
			$('#detail_chart_title').html('통계 차트 상세 &nbsp;&nbsp;&nbsp;<font size="2" color="red" face="돋움">[ ' + $(this).attr('id').replace('hour', '') + '시 ]</font> ');

			fn_chart_data_hour($(this).attr('id').replace('hour', ''));
		});

		$("#stats_hour_table  tbody tr td").dblclick(fn_mouse_dblclick);

	 	// 일단위 상세 - 일 클릭
		$("#stats_month_table tbody tr td").click(function() {
			$('#detail_chart_title').html('통계 차트 상세 &nbsp;&nbsp;&nbsp;<font size="2" color="red" face="돋움">[ ' + $(this).attr('id').replace('day', '') + '일 ]</font> ');

			fn_chart_data_day($(this).attr('id').replace('day', ''));
		});

	 	$("#stats_month_table tbody tr td").dblclick(fn_mouse_dblclick);

	 	// 월단위 상세 - 월 클릭
		$("#stats_year_table tbody tr td").click(function() {
			$('#detail_chart_title').html('통계 차트 상세 &nbsp;&nbsp;&nbsp;<font size="2" color="red" face="돋움">[ ' + $(this).attr('id').replace('month', '') + '월 ]</font> ');

			fn_chart_data_month($(this).attr('id').replace('month', ''));
		});

		$("#stats_year_table  tbody tr td").dblclick(fn_mouse_dblclick);


		// 차트 변경
		$('#CHART').change(function() {
			$('#' + $main_elem).remove();
			$('#main_chart_container_inner').append('<div id="' + $main_elem + '"  style="height: 400px; display: block"></div>');

			if($(this).val() == 'BAR')
			{
				$.MorrisCharts.init('BAR', $main_elem, $barData);
			}
			else
			{
				$.MorrisCharts.init('LINE', $main_elem, $barData);
			}
		});

	    !function ($) {
	        "use strict";

	        // create object
	        var MorrisCharts = function () {};

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
            MorrisCharts.prototype.createLineChart = function (element, data, xkey, ykeys, labels) {
                Morris.Line({
                    element: element,
                    data: data,
                    xkey: xkey,
                    ykeys: ykeys,
                    labels: labels
                });
            },
            MorrisCharts.prototype.init = function (chart, element, data) {
                if(chart == 'BAR') {
                	this.createBarChart(element, data, 'y', ['x'], ['건수 '], ['#3ac9d6']);

    				var thisX1,thisY1;
    				$('#' +element + ' svg rect').on('mouseover', function() {
    					thisX1 = $(".morris-hover-row-label").html();
    					thisY1 = $(".morris-hover-point").html().split(":")[1].trim();

    					//alert( "thisX1 : " + thisX1 + ",  thisY1 : " + thisY1 );
    					console.log("thisX1 : " + thisX1 + ",  thisY1 : " + thisY1)
    				});
                } else {
                	this.createLineChart(element, data, 'y', ['x'], ['건수 ']);

    				var thisX1,thisY1;
    				$('#' +element + ' svg circle').on('mouseover', function() {
    					thisX1 = $(".morris-hover-row-label").html();
    					thisY1 = $(".morris-hover-point").html().split(":")[1].trim();

    					//alert( "thisX1 : " + thisX1 + ",  thisY1 : " + thisY1 );
    					console.log("thisX1 : " + thisX1 + ",  thisY1 : " + thisY1)
    				});
                }
            },

            //init
            $.MorrisCharts = new MorrisCharts, $.MorrisCharts.Constructor = MorrisCharts
	    }(window.jQuery);

	    $.MorrisCharts.init('BAR', $main_elem, $barData);

	});

	</script>
</head>
<body>
	<div class="contWrap">
        <h1>${sesMenuNavigation.progrm_nm}</h1>
        <div class="whiteCont">
        	<p class="pageNav">
                <a href="<%=RequestMappingConstants.WEB_MAIN%>">HOME</a> &nbsp&nbsp |  &nbsp&nbsp  <a href="<%=RequestMappingConstants.WEB_MNG_USER%>">${sesMenuNavigation.p_progrm_nm}</a>  &nbsp&nbsp  |  &nbsp&nbsp  	${sesMenuNavigation.progrm_nm}
            </p> 
            
            <div class="row">
	            <div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">

	                    <h5 class="header-title"><b>항목설정</b></h5>

	                    <div class="sysstat-wrap m-t-30 m-b-30">
	                    	<form class="clearfix" id="userStatsForm" name="userStatsForm">
	                    	<input type="hidden" name="statType" id="statType" value="${stat_type}">
	                    	<input type="hidden" name="statTarget" id="statTarget" value="${stat_target}">
	                        <div class="row">
	                            <div class="col-sm-12">
	                                <div class="card-box">
	                                    <p class="card-box-title">기간</p>
	                                    <div class="card-box-inner p-30 p-t-0">
	                                        <div class="row">
	                                            <div class="col-xs-3 p-l-r-20">
	                                                <div class="radio p-l-r-20">
	                                                    <input type="radio" name="statKind" id="statKind" value="YEAR"><label for="">월 단위</label>
	                                                </div>
	                                                <select name="YEAR" id="YEAR" class="input-sm form-control" style="width:150px">
	                                                <c:forEach items="${stat_year}" var="result" varStatus="status">
	                                                	<option  value="${result.search_year}">${result.search_year}년</option>
	                                                </c:forEach>
	                                                </select>
	                                            </div>
	                                            <div class="col-xs-3 p-l-r-20">
	                                                <div class="radio p-l-r-20">
	                                                    <input type="radio" name="statKind" id="statKind" value="MONTH"><label for="">일 단위</label>
	                                                </div>
	                                                <select name="MONTH" id="MONTH" class="input-sm form-control" style="width:150px">
	                                                    <option value="01">01월</option>
	                                                    <option value="02">02월</option>
	                                                    <option value="03">03월</option>
	                                                    <option value="04">04월</option>
	                                                    <option value="05">05월</option>
	                                                    <option value="06">06월</option>
	                                                    <option value="07">07월</option>
	                                                    <option value="08">08월</option>
	                                                    <option value="09">09월</option>
	                                                    <option value="10">10월</option>
	                                                    <option value="11">11월</option>
	                                                    <option value="12">12월</option>
	                                                </select>
	                                            </div>
	                                            <div class="col-xs-3 p-l-r-20">
	                                                <div class="radio p-l-r-20">
	                                                    <input type="radio" name="statKind" id="statKind" value="DAY"><label for="">시간 단위</label>
	                                                </div>
	                                                <select name="DAY" id="DAY" class="input-sm form-control" style="width:150px">
		                                                <c:forEach items="${stat_days}" var="result" varStatus="status">
		                                                	<option  value="${result.search_day}">${result.search_day}일</option>
		                                                </c:forEach>
	                                                </select>
	                                            </div>
	                                            <div class="row text-right">
						                            <div class="col-xs-12">
														<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnSearch'>검색</button>
						                            </div>
						                        </div>
	                                        </div>
	                                    </div>
	                                </div>
	                            </div>
	                        </div>
							</form>


	                        <p></p>

	                        <div class="row" id='stats_day_result' style='display: none'>
	                        	<div class="divider divider-lg"></div>
	                            <div class="col-sm-12">
	                                <div class="card-box">

	                                    <!-- <p class="card-box-title">통계 조회 결과 <span id='stats_hour_sum'></span></p> -->

				                        <div class="row text-left">
				                            <div class="col-xs-10">
				                                <p class="card-box-title">통계 조회 결과 <span id='stats_hour_sum'></span></p>
				                            </div>
				                            <div class="col-xs-1">
		  										<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnDayDetail'>상세</button>
				                            </div>
				                            <div class="col-xs-1">
		  										<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnExport1'>저장 </button>
				                            </div>
				                        </div>

										<div class="table-wrap m-t-30">
					                        <table class="" id='group_stats_hour_table' width="100%">
						                            <tr>
						                            	<td>
									                        <table class="table table-custom table-cen table-num text-center table-hover" id='stats_hour_table' width="100%">
									                            <colgroup>
									                                <col width="8.34%" />
									                                <col width="8.34%" />
									                                <col width="8.34%" />
									                                <col width="8.34%" />
									                                <col width="8.34%" />
									                                <col width="8.34%" />
									                                <col width="8.34%" />
									                                <col width="8.34%" />
									                                <col width="8.34%" />
									                                <col width="8.34%" />
									                                <col width="8.34%" />
									                                <col width="8.34%" />
									                            </colgroup>
									                            <thead>
										                            <tr>
																		<th>0</th>
									                                	<th>1</th>
									                                    <th>2</th>
									                                    <th>3</th>
									                                    <th>4</th>
									                                    <th>5</th>
									                                    <th>6</th>
									                                    <th>7</th>
									                                    <th>8</th>
									                                    <th>9</th>
									                                    <th>10</th>
									                                    <th>11</th>
									                                </tr>
									                            </thead>
									                            <tbody>
										                            <tr>
									                                	<td id='hour00'>&nbsp;</td>
									                                	<td id='hour01'></td>
									                                    <td id='hour02'></td>
									                                    <td id='hour03'></td>
									                                    <td id='hour04'></td>
									                                    <td id='hour05'></td>
									                                    <td id='hour06'></td>
									                                    <td id='hour07'></td>
									                                    <td id='hour08'></td>
									                                    <td id='hour09'></td>
									                                    <td id='hour10'></td>
									                                    <td id='hour11'></td>
									                                </tr>
									                            </tbody>
									                            <thead>
										                            <tr>
																		<th>12</th>
									                                	<th>13</th>
									                                    <th>14</th>
									                                    <th>15</th>
									                                    <th>16</th>
									                                    <th>17</th>
									                                    <th>18</th>
									                                    <th>19</th>
									                                    <th>20</th>
									                                    <th>21</th>
									                                    <th>22</th>
									                                    <th>23</th>
									                                </tr>
									                            </thead>
									                            <tbody>
										                            <tr>
									                                	<td id='hour12'>&nbsp;</td>
									                                	<td id='hour13'></td>
									                                    <td id='hour14'></td>
									                                    <td id='hour15'></td>
									                                    <td id='hour16'></td>
									                                    <td id='hour17'></td>
									                                    <td id='hour18'></td>
									                                    <td id='hour19'></td>
									                                    <td id='hour20'></td>
									                                    <td id='hour21'></td>
									                                    <td id='hour22'></td>
									                                    <td id='hour23'></td>
									                                </tr>
									                            </tbody>
									                        </table>
					                        			</td>
					                                </tr>
					                                <tr><td></td></tr>
					                                <tr>
					                                	<td>
									                        <table class="table table-custom table-cen table-num text-center table-hover" id='detail_stats_hour_table' width="100%" style='display:none'>
									                            <colgroup>
									                                <col width="50%" />
									                                <col width="50%" />
									                            </colgroup>
									                            <thead>
										                            <tr>
																		<th>명칭</th>
									                                	<th>건수</th>
									                                </tr>
									                            </thead>
									                            <tbody>
									                            </tbody>
									                    	</table>
					                    				</td>
					                                </tr>
					                    	</table>
										</div>

	                                </div>
	                            </div>
	                        </div>

	                        <div class="row" id='stats_month_result'  style='display: none'>
	                        	<div class="divider divider-lg"></div>
	                            <div class="col-sm-12">
	                                <div class="card-box">

	                                    <!-- <p class="card-box-title">통계 조회 결과 <span id='stats_month_sum'></span></p> -->

				                        <div class="row text-left">
				                            <div class="col-xs-10">
				                                <p class="card-box-title">통계 조회 결과 <span id='stats_month_sum'></span></p>
				                            </div>
				                            <div class="col-xs-1">
		  										<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnMonthDetail'>상세</button>
				                            </div>
				                            <div class="col-xs-1">
		  										<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnExport2'>저장 </button>
				                            </div>
				                        </div>

										<div class="table-wrap m-t-30">
					                        <table class="" id='group_stats_month_table' width="100%">
					                            <tr>
					                            	<td>
								                        <table class="table table-custom table-cen table-num text-center table-hover" id='stats_month_table' width="100%">
								                            <colgroup>
								                                <col width="6.25%" />
								                                <col width="6.25%" />
								                                <col width="6.25%" />
								                                <col width="6.25%" />
								                                <col width="6.25%" />
								                                <col width="6.25%" />
								                                <col width="6.25%" />
								                                <col width="6.25%" />
								                                <col width="6.25%" />
								                                <col width="6.25%" />
								                                <col width="6.25%" />
								                                <col width="6.25%" />
								                                <col width="6.25%" />
								                                <col width="6.25%" />
								                                <col width="6.25%" />
								                                <col width="6.25%" />
								                            </colgroup>
								                            <thead>
									                            <tr>
								                                	<th>1</th>
								                                    <th>2</th>
								                                    <th>3</th>
								                                    <th>4</th>
								                                    <th>5</th>
								                                    <th>6</th>
								                                    <th>7</th>
								                                    <th>8</th>
								                                    <th>9</th>
								                                    <th>10</th>
								                                    <th>11</th>
								                                    <th>12</th>
								                                    <th>13</th>
								                                    <th>14</th>
								                                    <th>15</th>
								                                    <th>16</th>
								                                </tr>
								                            </thead>
								                            <tbody>
									                            <tr>
								                                	<td id='day01'>&nbsp;</td>
								                                    <td id='day02'></td>
								                                    <td id='day03'></td>
								                                    <td id='day04'></td>
								                                    <td id='day05'></td>
								                                    <td id='day06'></td>
								                                    <td id='day07'></td>
								                                    <td id='day08'></td>
								                                    <td id='day09'></td>
								                                    <td id='day10'></td>
								                                    <td id='day11'></td>
								                                    <td id='day12'></td>
								                                    <td id='day13'></td>
								                                    <td id='day14'></td>
								                                    <td id='day15'></td>
								                                    <td id='day16'></td>
								                                </tr>
								                            </tbody>
								                            <thead>
									                            <tr>
								                                	<th>17</th>
								                                    <th>18</th>
								                                    <th>19</th>
								                                    <th>20</th>
								                                    <th>21</th>
								                                    <th>22</th>
								                                    <th>23</th>
								                                    <th>24</th>
								                                    <th>25</th>
								                                    <th>26</th>
								                                    <th>27</th>
								                                    <th>28</th>
								                                    <th>29</th>
								                                    <th>30</th>
								                                    <th>31</th>
								                                    <th></th>
								                                </tr>
								                            </thead>
								                            <tbody>
									                            <tr>
								                                	<td id='day17'>&nbsp;</td>
								                                    <td id='day18'></td>
								                                    <td id='day19'></td>
								                                    <td id='day20'></td>
								                                    <td id='day21'></td>
								                                    <td id='day22'></td>
								                                    <td id='day23'></td>
								                                    <td id='day24'></td>
								                                    <td id='day25'></td>
								                                    <td id='day26'></td>
								                                    <td id='day27'></td>
								                                    <td id='day28'></td>
								                                    <td id='day29'></td>
								                                    <td id='day30'></td>
								                                    <td id='day31'></td>
								                                    <td></td>
								                                </tr>
								                            </tbody>
								                        </table>
					                        		</td>
					                        	</tr>
					                        	<tr><td></td></tr>
					                        	<tr>
					                        		<td>
								                        <table class="table table-custom table-cen table-num text-center table-hover" id='detail_stats_month_table' width="100%" style='display:none'>
								                            <colgroup>
								                                <col width="50%" />
								                                <col width="50%" />
								                            </colgroup>
								                            <thead>
									                            <tr>
																	<th>명칭</th>
								                                	<th>건수</th>
								                                </tr>
								                            </thead>
								                            <tbody>
								                            </tbody>
								                    	</table>
								                    </td>
								        		</tr>
								        	</table>
										</div>

	                                </div>
	                            </div>
	                        </div>

	                        <div class="row" id='stats_year_result' style='display: none'>
	                        	<div class="divider divider-lg"></div>
	                            <div class="col-sm-12">
	                                <div class="card-box">

	                                    <!-- <p class="card-box-title">통계 조회 결과 <span id='stats_year_sum'></span></p> -->

				                        <div class="row text-left">
				                            <div class="col-xs-10">
				                                <p class="card-box-title">통계 조회 결과 <span id='stats_year_sum'></span></p>
				                            </div>
				                            <div class="col-xs-1">
		  										<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnYearDetail'>상세</button>
				                            </div>
				                            <div class="col-xs-1">
		  										<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnExport3'>저장 </button>
				                            </div>
				                        </div>

										<div class="table-wrap m-t-30">
					                        <table class="" id='group_stats_year_table' width="100%">
					                            <tr>
					                            	<td>
								                        <table class="table table-custom table-cen table-num text-center table-hover" id='stats_year_table' width="100%">
								                            <colgroup>
								                                <col width="16.68%" />
								                                <col width="16.68%" />
								                                <col width="16.68%" />
								                                <col width="16.68%" />
								                                <col width="16.68%" />
								                                <col width="16.68%" />
								                            </colgroup>
								                            <thead>
									                            <tr>
								                                	<th>1</th>
								                                    <th>2</th>
								                                    <th>3</th>
								                                    <th>4</th>
								                                    <th>5</th>
								                                    <th>6</th>
								                                </tr>
								                            </thead>
								                            <tbody>
									                            <tr>
								                                	<td id='month01'>&nbsp;</td>
								                                    <td id='month02'></td>
								                                    <td id='month03'></td>
								                                    <td id='month04'></td>
								                                    <td id='month05'></td>
								                                    <td id='month06'></td>
								                                </tr>
								                            </tbody>
								                            <thead>
									                            <tr>
								                                    <th>7</th>
								                                    <th>8</th>
								                                    <th>9</th>
								                                    <th>10</th>
								                                    <th>11</th>
								                                    <th>12</th>
								                                </tr>
								                            </thead>
								                            <tbody>
									                            <tr>
								                                    <td id='month07'>&nbsp;</td>
								                                    <td id='month08'></td>
								                                    <td id='month09'></td>
								                                    <td id='month10'></td>
								                                    <td id='month11'></td>
																	<td id='month12'></td>
								                                </tr>
								                            </tbody>
								                        </table>
					                        		</td>
					                        	</tr>
					                        	<tr><td></td></tr>
					                        	<tr>
					                        		<td>
								                        <table class="table table-custom table-cen table-num text-center table-hover" id='detail_stats_year_table' width="100%" style='display:none'>
								                            <colgroup>
								                                <col width="50%" />
								                                <col width="50%" />
								                            </colgroup>
								                            <thead>
									                            <tr>
																	<th>명칭</th>
								                                	<th>건수</th>
								                                </tr>
								                            </thead>
								                            <tbody>
								                            </tbody>
								                    	</table>
								        			</td>
								        		</tr>
								        	</table>
										</div>

	                                </div>
	                            </div>
	                        </div>

	                        <div class="row" id='main_chart_container' style='display: block'>
	                            <div class="col-sm-12">
	                                <div class="card-box">

	                                    <!-- <p class="card-box-title" id='search-title'>통계 차트</p> -->

				                        <div class="row text-left">
				                            <div class="col-xs-10">
				                                <p class="card-box-title" id='main_chart_title'>통계 차트</p>
				                            </div>
				                            <div class="col-xs-2">
		  										<select name="CHART" id="CHART" class="input-sm form-control" style="width:150px">
			                                    	<option value="BAR">Bar Chart</option>
			                                        <option value="LINE">Line Chart</option>
		                                    	</select>
				                            </div>
				                        </div>

	                                    <div class="card-box-inner p-30 p-t-0" style="height: 400px;">
	                                        <div class="row">
	                                            <div class="col-xs-12">
	                                                <div class="demo-box p-20" id='main_chart_container_inner'>
	                                                    <div id="main_chart"  style="height: 400px; display: block"></div>
	                                                </div>
	                                            </div>
	                                        </div>
	                                    </div>

	                                </div>
	                            </div>
	                        </div>

	                        <div class="row" id='detail_chart_container' style='display: none'>
	                            <div class="col-sm-12">
	                                <div class="card-box">

	                                    <p class="card-box-title" id='detail_chart_title'>통계 차트 상세</p>

	                                    <div class="card-box-inner p-30 p-t-0" style="height: 400px;">
	                                        <div class="row">
	                                            <div class="col-xs-12">
	                                                <div class="demo-box p-20" id='detail_chart_container_inner'>
	                                                    <div id="detail_chart"  style="height: 400px;"></div>
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
</body>
</html>