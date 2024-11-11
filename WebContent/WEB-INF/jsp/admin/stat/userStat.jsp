<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>


<script src="<c:url value='/resources/js/admin/statistics/userStat.js'/>"></script>
<script src="<c:url value='/resources/js/admin/statistics/chartCommon.js'/>"></script>

<script>
    //'use strict';

	var firstGrid = ""; //gridObject
	var grpData = ${grpData}; 
	var Year = ${Year};
	var Month = ${Month};
	var dateVal = 'year';
	
    var UserStatPage = {
        select1: null,
        select_year: null,
        select_month: null,
        initObject: function() {
        	
        	$('#yearfrom').hide(); 
			$('#monthfrom').hide(); 
        	
            grpData.unshift({ no: null, dept_nm: "전체" }); //부서선택 - '전체'추가

            this.initControls(); //부서선택 초기화
 		  	this.datepick(dateVal);
        },
        initControls: function() {
        	
        	//부서 select
        	 this.select1 = new selectClass("selectGroupId1", grpData);
             this.select1.initSelect(this.selectTrigger);
           
           //연도 select
             let select_year = Year.map((item, index) => ({ text: item.toString(), index: index }));
             this.select_year = new selectClass("select_year", select_year);
             this.select_year.initSelect(this.selectTrigger);
             
           //월 select
             let select_month = Month.map((item, index) => ({ text: item.toString(), index: index }));
             this.select_month = new selectClass("select_month", select_month);
             this.select_month.initSelect(this.selectTrigger);
        },
        datepick: function(datepick) {
            dateVal = datepick;

            $(".show_ver li").click(function() {
                $(this).addClass('show').siblings().removeClass('show');
            });
            
      		////////결과 함수 실행////////
            if (datepick === "year") {
                toggleSelectBoxes(false, false);
                firstGrid = setupGrid(Year,150);

            } else if (datepick === "month") {
                toggleSelectBoxes(true, false);
                firstGrid = setupGrid(Month,75);

            } else if (datepick === "day") {
                toggleSelectBoxes(true, true);
            }
            handleTransaction();
            
    		/////////////////////////
            // 연도/월/일 별로 선택박스 표출
            function toggleSelectBoxes(yearVisible, monthVisible) {
                $('#yearfrom').toggle(yearVisible);
                $('#monthfrom').toggle(monthVisible);
            }
            
            //gird - header,footSum 생성
            function setupGrid(dataArray,_width) {
                var columns = dataArray.map(function(item) {
            	//console.log("item",item)
                    return { label: item, key: item, align: "center", width: _width};
                });

                var footSum = [{ label: "합계", align: "center" }];
                dataArray.forEach(function(item) {
                    footSum.push({ key: item, collector: "sum", formatter: "money", align: "center" });
                });
                footSum.push({ key: "total", collector: "sum", formatter: "money", align: "center" });

                return initGridA(columns, footSum);
            }
            
            // 그리드 결과위한 파라미터 전송
            function handleTransaction() {
                var param = {
                    "DATAVAL": dateVal,
                    "DEPT_NM": _select.val($('[data-ax5select="selectGroupId1"]'))[0].dept_nm,
                    "YEAR": _select.val($('[data-ax5select="select_year"]'))[0].text,
                    "MONTH": _select.val($('[data-ax5select="select_month"]'))[0].text
                };

                gfn_transaction("/mngStatUserData.do", "POST", param, dateVal);
            }
            
        },
        selectTrigger: function(obj) {
        	UserStatPage.datepick(dateVal);
        },
        buttonClick: function(_this) {
            const buttonId = $(_this).attr("id");
            var excelNm = "";
            if(dateVal == 'year') excelNm = "연도별";
            else if(dateVal == 'month'){
                var yearNm = _select.val($('[data-ax5select="select_year"]'))[0].text;
            	excelNm = yearNm+"월별";
            }
            else if(dateVal == 'day') {
            	 var yearNm = _select.val($('[data-ax5select="select_year"]'))[0].text;
            	 var monthNm = _select.val($('[data-ax5select="select_month"]'))[0].text;
            	excelNm = yearNm+"_"+monthNm+" 일별";
            }
            
            if (buttonId === "excel1") {
                firstGrid.exportExcel("통계 - 접속자( "+excelNm+" ).xls");
            } else {
                _dialog.alert("버튼 id가 지정되지 않았습니다.");
            }
        }
       
    };

    function fn_callback(actionType, data) {
    	
    	console.log("통계 data",data)

        // 데이터의 gridSet을 변환하여 사용
        var column = data.gridSet;
        var transformedData = column.map(item => JSON.parse(item.result.value));

        if (actionType === "day") {
        	var DayHeader = data.Day;
        	var Day = DayHeader.map(item => item.day);

        	var columns = Day.map(day => ({ label: day, key: day, align: "center" , width: 30}));
        	var footSum = [{ label: "합계", align: "center" }].concat(
                Day.map(day => ({ key: day, collector: "sum", formatter: "money", align: "center" }))
            );
            footSum.push({ key: "total", collector: "sum", formatter: "money", align: "center" });

            firstGrid = initGridA(columns, footSum);
            firstGrid.setData(transformedData);
        } else {
            firstGrid.setData(transformedData);
        }
        
        // 부서 퍼센트 데이터 설정
        var deptPercent = data.UserDeptPercent;
        var labels_arr_pie = [];
        var data_arr_pie = [];

        deptPercent.forEach(item => {
            labels_arr_pie.push(item.dept_nm);
            data_arr_pie.push(item.percentage);
        });

        // 선택한 부서명 가져오기
        var dept_nm = _select.val($('[data-ax5select="selectGroupId1"]'))[0].dept_nm;

        // actionType에 따른 처리
        if (actionType === "year" || actionType === "month" || actionType === "day") {
        	var timePeriod, labels_arr = [], data_arr = [];
            
            // actionType에 따른 시간 범위 설정
            if (actionType === "year") {
                timePeriod = Year;
            } else if (actionType === "month") {
                timePeriod = Month;
            } else if (actionType === "day") {
                timePeriod = data.Day.map(item => item.day);
            }

            // 전체 부서 선택 시 데이터 집계
            if (dept_nm === '전체') {
            	var footerValues = {};
                var data = firstGrid.list;
                 
                timePeriod.forEach(period => {
                    footerValues[period] = data.reduce((sum, row) => {
                    	var value = parseInt(row[period], 10);
                        return isNaN(value) ? sum : sum + value;
                    }, 0);
                });

                // labels_arr과 data_arr에 데이터 추가
                timePeriod.forEach(period => {
                    labels_arr.push(period);
                    data_arr.push(footerValues[period] || 0); // 값이 없으면 0으로 처리
                });

            } else {
                // 선택한 부서의 데이터만 처리
                var selectedDept = transformedData.find(dept => dept.DEPT_NM === dept_nm);
                if (selectedDept) {
                    timePeriod.forEach(period => {
                    	var value = parseInt(selectedDept[period], 10);
                        data_arr.push(isNaN(value) ? 0 : value);
                    });
                    labels_arr = timePeriod; // labels_arr에 timePeriod를 사용
                }

            };
             
            // 막대차트 그리기
            var datas = {
           		 labels: labels_arr, //x축 레이블
                    datasets: [{
                        label: '횟 수',//데이터셋을 설명
                        data: data_arr, //각 레이블에 해당하는 데이터 값
                        backgroundColor: "rgba(255, 201, 14, 0.5)",  //막대의 채우기 색상
                        borderColor: "rgba(255, 201, 14, 1)",  //막대 테두리의 색상
                        hoverBackgroundColor: 'rgba(255, 124, 0, 0.5)' //막대를 마우스로 가리켰을 때의 배경색
                    }]
   			};
           
            var options = {
                	indexAxis: 'x', 
                   responsive: true,  //차트가 다양한 화면 크기에 반응
                   maintainAspectRatio: false,  //초기 가로 세로 비율을 유지하지 않고 차트의 크기를 자유롭게 조정
                   plugins: {
                       tooltip: {  //도구 설명(차트 요소 위로 마우스를 가져갈 때 나타나는 작은 상자)의 동작과 모양을 구성
                       	enabled: true,
                       	  mode: 'nearest',  // 툴팁이 가장 가까운 데이터에만 나타나도록 설정
                             intersect: true,  // 툴팁이 커서가 요소 위에 있을 때만 나타남
                           callbacks: {
                               label: function(context) {
                                   return context.dataset.label + ': ' + context.raw;
                               }
                           }
                       },
                       legend: {  //차트 범례를 구성
                           display: true,  //차트에 범례를 표시
                           position: 'top'  //범례를 차트의 맨 위에 배치
                       },
                       datalabels: {  //각 막대에 표시되는 레이블을 구성
                       	anchor: 'end', //막대를 기준으로 한 레이블의 위치
                       	align: 'center',  //막대를 기준으로 레이블을 정렬
                       	//anchor: 'end',  // 라벨을 차트 끝에 위치시킵니다.
                           //align: 'end',  // 라벨을 막대의 끝과 정렬
                           color: 'black',
                           formatter: function(value) {
                           	// 값이 0일 경우 빈 문자열을 반환하여 라벨을 숨김
                               //return value < 10 ? '' : value;
                           	return value == 0 ? '' : value;
                           }
                           //,offset: 30 // 막대와 레이블 사이의 간격 조정
                       }
                   },
                   interaction: {  // 상호작용 설정
                       mode: 'nearest',  // 마우스 위치에서 가장 가까운 데이터에만 상호작용 발생
                       intersect: true  // 커서가 요소 바로 위에 있을 때만 상호작용 발생
                   },
                   scales: {
                       x: {
                           display: true,  //축을 표시
                           title: {  //축의 제목을 구성
                               display: true
                           },
                           ticks: {  //축의 눈금(레이블)을 구성
                               autoSkip: true,  //중복을 피하기 위해 일부 레이블을 자동으로 건너뜁니다.
                               min: 0  // 축의 최소값을 0으로 설정
                           }
                       },
                       y: {
                           display: true,  //축을 표시
                           title: {
                               display: true
                           },
                           ticks: {
                               autoSkip: true,
                           }
                       }
                   },layout: {
                       padding: 10 // 차트와 캔버스 가장자리 간의 패딩 추가
                   }
    	        };
              
        	drawChart('bar', datas, options,  [ChartDataLabels], "barChart"); 

            
         // 원형차트 그리기
         let hoveredIndex = null; // 현재 hover된 데이터 포인트의 인덱스를 저장
		  // 기본 스타일 정의
	     defaultFontSize = 12;
	    var hoverFontSize = 16; // Hover 시 변경할 폰트 크기
            var datas_pie = {
           		 labels: labels_arr_pie, //x축 레이블
                 datasets: [{
                     data: data_arr_pie,
                     backgroundColor: ["#8CABD9", "#F6A7B8", "#F1EC7A", "#ECC6A2"],
                     borderColor: "#f8fff8", // 기본 테두리 색상
                     borderWidth: 2, // 기본 테두리 두께
                     hoverBorderColor: "#466CA6", // 호버 시 테두리 색상
                     hoverBorderWidth: 3 // 호버 시 테두리 두께
                 }]
   			};
           
            var options_pie = {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        tooltip: {
                        	enabled: true,
                            callbacks: {
                                label: function(context) {
                                    var label = context.label || '';
                                    var value = context.raw;
                                    return [label, value + '%'];
                                }
                            }
                        },
                        legend: {
                            display: true,
                            position: 'top', // 범례의 위치 조정
                            labels: {
                                font: {
                                    size: 12 // 범례의 폰트 크기 조정
                                }
                            }
                        },
                        datalabels: {
                        	 display: true,
                        	   anchor: 'center', // 'center', 'end', 'start'
                               align: 'center',  // 'center', 'end', 'start'
                             formatter(value, context) {
                                 var name = context.chart.data.labels[context.dataIndex];
                                 return [name, value + '%'];
                             },
                             color: 'black',
                             font: function(context) {
                                 // Hover된 데이터 포인트의 폰트 크기를 조정
                                 return {
                                     weight: context.dataIndex === hoveredIndex ? 'bold' : '',
                                     size: context.dataIndex === hoveredIndex ? 14 : 11
                                 };
                             },
                             clip: true, // 텍스트가 차트 영역 밖으로 넘어가지 않도록
                             display: function(context) {
                                 return context.dataset.data[context.dataIndex] > 0; // 값이 0인 경우 레이블 숨기기
                             }
                        }
                    },layout: {
                        padding: 10 // 차트와 캔버스 가장자리 간의 패딩 추가
                    },
                    onHover: function(event, chartElement) {
                        if (chartElement.length > 0) {
                            // Hover된 요소의 인덱스 저장
                            hoveredIndex = chartElement[0].index;
                        } else {
                            // Hover가 제거되었을 때 인덱스 초기화
                            hoveredIndex = null;
                        }
                        this.update(); // 차트 업데이트
                       
                    }
    	        };
              
        	drawChart('pie', datas_pie, options_pie,  [ChartDataLabels], "pieChart"); 
            // 원형차트 그리기
            //drawChart(labels_arr_pie, data_arr_pie, "pieChart", 'pie');
        }

    }
    
    $(function() {
	     //datepick
	     $(".date_btn button").click(function() {
	         $(this).addClass('datepick').siblings().removeClass('datepick');
	     })
	 });   
    
    $(document.body).ready(function () {
    	UserStatPage.initObject();
    });

    </script>

    <div class="contWrap">
        <h1>${sesMenuNavigation.progrm_nm}</h1>
        <div class="whiteCont">
            <p class="pageNav">
                <a href="<%=RequestMappingConstants.WEB_MAIN%>">HOME</a> &nbsp;&nbsp; | &nbsp;&nbsp; 
                <a href="<%=RequestMappingConstants.WEB_MNG_USER%>">${sesMenuNavigation.p_progrm_nm}</a> &nbsp;&nbsp; | &nbsp;&nbsp; 
                ${sesMenuNavigation.progrm_nm}
            </p>
            <div id="tab0">
				<div class="clearfix">
					<div class="clearfix" id="statusOpt">
						<div>
							<div class="form-inline">
								<div class="date_btn">
		                            <button class="datepick" onclick="UserStatPage.datepick('year')">년</button>
		                            <button onclick="UserStatPage.datepick('month')">월</button>
		                            <button onclick="UserStatPage.datepick('day')">일</button>
		                        </div>
		                        <div class="form-group" id="yearfrom">
		                        <label>연도 :</label>
		                            <div data-ax5select="select_year" data-ax5select-config="{columnKeys:{optionValue: 'index', optionText: 'text'}}" style="min-width: 85px;"></div>
		                        </div>
		                        <div class="form-group" id="monthfrom">
		                        <label>월 :</label>
		                            <div data-ax5select="select_month" data-ax5select-config="{columnKeys:{optionValue: 'index', optionText: 'text'}}" style="min-width: 90px;"></div>
		                        </div>
								<div class="form-group">
									<div data-ax5select="selectGroupId1" data-ax5select-config="{columnKeys:{optionValue: 'no', optionText: 'dept_nm'}}" style="min-width: 180px;"></div>
								</div>
								<div id="BtnExcel" style="display: contents;">
									<button class="btn stat_btn btn-md" onclick="UserStatPage.buttonClick(this);" id="excel1">통계표 다운로드</button>
								</div>
							</div>
						</div>
					</div> 
				</div>
				<div class="container_chart">
					<div class="convertDiv1">
						<label>통계 차트</label>
						<div class="chart-container">
							<canvas id="barChart"></canvas>
						</div>
					</div>
					<div class="convertDiv2">
						<label>접속자 접속률</label>
						<div class="chart-container">
							<canvas id="pieChart"></canvas>
						</div>
					</div>
				</div>
				<div class="board_table_wrap" style="height: 42vh;">
					<div data-ax5grid="first-grid" data-ax5grid-config='{}' style="height: 100%;"></div>
				</div>
			</div>
        </div>
    </div>
