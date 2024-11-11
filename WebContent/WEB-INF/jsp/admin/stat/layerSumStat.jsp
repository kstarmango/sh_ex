<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>


<script src="<c:url value='/resources/js/admin/statistics/layerSumStat.js'/>"></script>
<script src="<c:url value='/resources/js/admin/statistics/chartCommon.js'/>"></script>

<script>
    //'use strict';

	var firstGrid = ""; //gridObject
	var secondGrid = ""; //gridObject
	var grpData = ${grpData};
	var Year = ${Year};
	var statType = 'layer';  //초기값 설정 : 레이어통계 
	
    
    var LayerSumStatPage = {
        select1: null,
        initObject: function() {
        	
            grpData.unshift({ no: null, dept_nm: "전체" }); //부서선택 - '전체'추가

            this.initControls(); //날짜, 부서선택 초기화
            this.updateStatistics(statType); //레이어 통계 표출
            
        },
        initControls: function() {
        	//부서 select
            this.select1 = new selectClass("selectGroupId1", grpData);
            this.select1.initSelect(this.selectTrigger);
        },
        selectTrigger: function(obj) {
            if (obj.item.name === 'selectGroupId1') {
               LayerSumStatPage.updateStatistics(statType);
           } 
       },
       buttonClick: function(_this) {
           var buttonId = $(_this).attr("id");
       		var excelNm = $(".step_btn li.thisStep").text();
       	
           if (buttonId === "excel1") {
               firstGrid.exportExcel("누계 - 레이어 조회( "+excelNm+" ).xls");
           } else {
               _dialog.alert("버튼 id가 지정되지 않았습니다.");
           }
       },
       tabClick:function(_this){
   		$(".step_btn li").removeClass("thisStep");
   		$(".step_btn li:eq(" + $(_this).index() + ")").addClass("thisStep");
   		
   		statType = $(_this).attr("id");
   		LayerSumStatPage.updateStatistics(statType);
   		},
        updateStatistics: function(statTypeValue) {
        	$(".textNm").text($(".step_btn li.thisStep").text());
        	
        	//statType = layer(레이어 통계), data(데이터 통계), download(다운로드 통계)
        	statType = statTypeValue;
        	
   			 ////////결과 함수 실행////////
            firstGrid = setupGrid(Year,100);
            secondGrid = initGridB();
            handleTransaction();
    		/////////////////////////
            //gird - header,footSum 생성
            function setupGrid(dataArray,_width) {
    			
                var columns = dataArray.map(function(item) {
                    return { label: item, key: item, align: "center", width: _width};
                });
                
                var groupingSum = [{
				                    label: function () {
				                        return this.groupBy.labels.join(", ") + " 합계";
				                    }, colspan: 3, align: "center"
				                }];
				dataArray.forEach(function(item) {
				groupingSum.push({ key: item, collector: "sum", formatter: "money", align: "center" });
				});
				groupingSum.push({key: "TOTAL", collector:"sum",formatter: "money", align: "center"});

                var footSum = [{label: "합계", colspan: 3, align: "center"}];
                dataArray.forEach(function(item) {
                    footSum.push({ key: item, collector: "sum", formatter: "money", align: "center" });
                });
                footSum.push({ key: "TOTAL", collector: "sum", formatter: "money", align: "center" });

                return initGridA(columns, groupingSum, footSum);
            }
           
            
            // 그리드 결과위한 파라미터 전송
            function handleTransaction() {
            	//param = 선택부서, 조회 시작일자, 조회 종료일자
                var param = {
               		"STAT_TYPE" : statTypeValue,
                    "DEPT_NM": _select.val($('[data-ax5select="selectGroupId1"]'))[0].dept_nm
                };

                gfn_transaction("/mngSumStatLayerData.do", "POST", param, "select"); 
            }
        	
        }
    };

    function fn_callback(actionType, data){

    	switch (actionType) {
    	
    	  case "select":
    		  
	   		var column = data.grid1Ret;
    	    var transformedData = column.map(item => JSON.parse(item.result.value));
            firstGrid.setData(transformedData);
            
    		// 부서 퍼센트 데이터 설정
            var SumLayerDeptPercent = data.SumLayerDeptPercent;
            secondGrid.setData(SumLayerDeptPercent);
            
            var timePeriod, labels_arr = [];
                
                timePeriod = Year;
	   		  
                var footerValues = {};
                var data = firstGrid.list;

                // 각 연도별 데이터와 부서명을 labels와 datasets로 변환
              var labels = data.map(item => item.LAYER_NM);
              timePeriod.forEach(period => {
                  labels_arr.push(period);
              });
              
                var years = labels_arr;
                // 각 연도에 대해 데이터를 추출
                var datasets = years.map(year => {
                    return {
                        label: year,
                        data: data.map(item => item[year]),
                        backgroundColor: getRandomColor(), // 각 데이터셋에 대해 다른 색상을 지정
                        borderColor: '#fff',
                        borderWidth: 1
                    };
                });
				
             // 막대차트 그리기
                // 데이터셋에서 색상을 지정하는 부분 수정
      	    datasets.forEach(function(dataset) {
      	        var year = dataset.label;
      	        var color = colorMapping[year] || getRandomColor(); // 지정된 색상 없으면 랜덤색상
      	        dataset.backgroundColor = color;
      	        dataset.borderColor = '#fff';
      	        dataset.borderWidth = 1;
      	    });
      	       
                var datas = {
              		  	labels: labels,
        	            	datasets: datasets  
                			};
                
                var options = {
      	            indexAxis: 'y', 
      	            responsive: true,
      	            maintainAspectRatio: false,  // 비율 유지를 끔
      	            scales: {
      	                y: {
      	                    stacked: true, 
      	                    ticks: {
      	                    	autoSkip: true, // 초기에는 autoSkip을 true로 설정
      	                         stepSize: 50 // 눈금 간격 조정
      	                    },
      	                    position: 'left', 
      	                },
      	                x: {
      	                	stacked: true,
      	                    min: 0, // x축 최소값 설정
      	                    max: calculateMaxYValue(datasets), // x축 최대값 설정
      	                    
      	                }
      	            },
      	            plugins: {
      	            	 zoom: {
      	                     pan: {
      	                         enabled: true,
      	                         mode: 'y', // y축 스크롤만 가능
      	                     },
      	                     zoom: {
      	                         wheel: {
      	                             enabled: true, // 마우스 휠로 확대/축소 가능
      	                         },
      	                         pinch: {
      	                             enabled: true
      	                           },
      	                         mode: 'y', //  y축에서만 zoom 가능
      	                         onZoom: function({chart}) {
      	                        	  // 줌이 발생하면 y축의 스케일 값을 확인
      	                             const yScale = chart.scales.y;
      	                             const zoomLevel = yScale.max - yScale.min;
      	
      	                             // 줌 레벨에 따라 datalabels의 표시 여부를 설정
      	                             chart.options.plugins.datalabels.display = zoomLevel < 50; // 예: 100 이하로 줌인된 경우에만 표시
      	                             // 줌인이 발생하면 autoSkip을 false로 변경
      	                             chart.options.scales.y.ticks.autoSkip = false;
      	                             chart.update();
      	                         },
      	                         onZoomComplete: function({chart}) {
      	                             // 줌이 끝났을 때 동작이 필요하면 여기에 추가
      	                        	 chart.options.scales.y.ticks.autoSkip = true;
      	                             chart.update();
      	                         } 
      	                     },
      	                 },
      	                tooltip: {
      	                    callbacks: {
      	                        title: function(context) {
      	                            return context[0].label; 
      	                        },
      	                        afterLabel: function(context) {
      	                            var dataIndex = context.dataIndex;
      	                            var tooltipData = context.chart.data.datasets.map(function(dataset) {
      	                                return dataset.data[dataIndex];
      	                            });
      	                            var yearData = '======\n';
      	                            var total = 0;
      	                            for (var i = 0; i < tooltipData.length; i++) {
      	                                var year = context.chart.data.datasets[i].label;
      	                                var value = tooltipData[i];
      	                                yearData += year + ': ' + value + '\n';
      	                                total += value;
      	                            }
      	                            yearData += '======\n';
      	                            yearData += 'Total: ' + total;
      	                            return yearData.trim();
      	                        }
      	                    }
      	                },
      	                legend: {
      	                    display: true,
      	                    position: 'top',
      	                    labels: {
      	                        padding: 20 // 범례와의 간격 추가
      	                    }
      	                },
      	                datalabels: {
      	                	display : false,
      	                    anchor: 'end',
      	                    align: 'end',
      	                    color: 'black',
      	                    clamp: true,
      	                    clip: true, // 라벨이 차트의 경계벗어나면 표시X
      	                    formatter: function(value, context) {
      	                    	const chart = context.chart;
      	                        const dataIndex = context.dataIndex;
      	                        const datasetIndex = context.datasetIndex;
      	                        const datasets = chart.data.datasets;
      	                        
      		                    // 현재 데이터셋이 마지막 데이터셋인지 확인
      					        const isLastDataset = datasetIndex === datasets.length - 1;
      					
      					        // 현재 데이터의 총합 계산
      					        let total = datasets.reduce((sum, dataset) => {
      					            const dataValue = dataset.data[dataIndex];
      					            if (typeof dataValue === 'number' && !isNaN(dataValue)) {
      					                return sum + dataValue;
      					            }
      					            return sum;
      					        }, 0);
      	                        
      	                        // 현재 마지막 막대일 때만 총합 표시
      	                        return isLastDataset ? (total > 0 ? total.toString() : '') : '';
      				                        
      	                    },
      	                    font: {
      	                        weight: 'bold'
      	                    },
      	                    offset: 4, // 라벨과 막대 간격 조정
      	                    color: 'black',
      	                    padding: {
      	                        top: 2
      	                    }
      	                }
      	            },
      	            layout: {
      	            	padding: {
      	                    left: 10,
      	                    right: 30,
      	                    top: 10,
      	                    bottom: 10
      	                }
      	            },
      	        };
                
      	    
           drawChart('bar', datas, options,  [ChartDataLabels], "barChart"); 

             break;

          	  default:
          	    null; 
    	}
    }

    
    $(document.body).ready(function () {
    	LayerSumStatPage.initObject();
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
             <div class="step_wrap">
	            <ul class="step_btn">
	                <li class="thisStep" onclick="LayerSumStatPage.tabClick(this);" id="layer">레이어 통계</li>
	                <li onclick="LayerSumStatPage.tabClick(this);" id="data">데이터 통계</li>
	                <li onclick="LayerSumStatPage.tabClick(this);" id="download">다운로드 통계</li>
	            </ul>
	        </div>
            <div id="tab0">
				<div class="clearfix">
					<div class="clearfix" id="statusOpt">
						<div>
							<div class="form-inline" style="display: flex; align-items: center;">
								<div class="form-group">
									<div data-ax5select="selectGroupId1" data-ax5select-config="{columnKeys:{optionValue: 'no', optionText: 'dept_nm'}}" style="min-width: 180px;"></div>
								</div>
							 <span class="small" style="flex-grow: 1; margin-left: 10px;">※  마우스 <b class="text-orange">휠 확대/축소 및 이동 기능</b>을 통해 세부 정보를 확인하실 수 있습니다.</span>
								<div  id="BtnExcel" style="display: contents;">
									<button class="btn stat_btn btn-md" onclick="LayerSumStatPage.buttonClick(this);" id="excel1">통계표 다운로드</button>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="container_chart">
					<div class="convertDiv1" style="height: 650px;">
						<label>통계 차트</label>
						<div class="chart-container_ht">
							<canvas id="barChart"></canvas>
						</div>
					</div>
					<div class="convertDiv2" style="height: 650px;">
						<label>접속자 접속률</label>
						<div class="board_table_wrap" style="height: 68vh;">
							<div data-ax5grid="second-grid" data-ax5grid-config='{}' style="height: 100%;"></div>
						</div>
					</div>
				</div>
				<!-- <div class="board_table_wrap" style="height: 42vh;">
					<div data-ax5grid="first-grid" data-ax5grid-config='{}' style="height: 100%;"></div>
				</div> -->
				<div class="hidden-grid">
				<div data-ax5grid="first-grid" data-ax5grid-config='{}'></div>
				</div>
			</div>
        </div>
    </div>