<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

<script src="<c:url value='/resources/js/admin/statistics/layerStat.js'/>"></script>
<script src="<c:url value='/resources/js/admin/statistics/chartCommon.js'/>"></script>

<script>
    //'use strict';

	var firstGrid = ""; //gridObject
	var grpData = ${grpData}; 
	var statType = 'layer';  //초기값 설정 : 레이어통계 
	
    
    var LayerStatPage = {
        picker1: null,
        select1: null,
        initObject: function() {
        	
            grpData.unshift({ no: null, dept_nm: "전체" }); //부서선택 - '전체'추가

            this.initControls(); //날짜, 부서선택 초기화
            this.setInitialDates(); //닐짜 초기값 설정
            this.updateStatistics(statType); //레이어 통계 표출
            
        },
        initControls: function() {
            this.picker1 = new datePickerClass("datePicker1");
            this.select1 = new selectClass("selectGroupId1", grpData);
            
            this.picker1.initDatepicker(this.pickerTrigger);
            this.select1.initSelect(this.selectTrigger);
        },
        setInitialDates: function() {
            $('#startByDate1').val(ax5.util.date(new Date(), { set: "firstDayOfMonth", return: 'yyyy-MM-dd' }));  //조회 해당 월 1일
            $('#endByDate1').val(ax5.util.date(new Date(), { add: { d: 0 }, return: 'yyyy-MM-dd' })); //오늘날짜
        },
        selectTrigger: function(obj) {
            if (obj.item.name === 'selectGroupId1') {
               LayerStatPage.updateStatistics(statType);
           } 
       },
       pickerTrigger: function(obj, objName) {
           if (obj.state === "close" && objName === 'datePicker1') {
           	LayerStatPage.updateStatistics(statType);
           }
       },
       buttonClick: function(_this) {
           var buttonId = $(_this).attr("id");
           var startNm = $('#startByDate1').val();
  		   var endNm = $('#endByDate1').val();
       	   var excelNm = startNm.replaceAll('-', '')+"-"+endNm.replaceAll('-', '');
           excelNm = $(".step_btn li.thisStep").text() + "_" + excelNm;
       	
           if (buttonId === "excel1") {
               firstGrid.exportExcel("통계 - 레이어 조회( "+excelNm+" ).xls");
           } else {
               _dialog.alert("버튼 id가 지정되지 않았습니다.");
           }
       },
       tabClick:function(_this){
   		$(".step_btn li").removeClass("thisStep");
   		$(".step_btn li:eq(" + $(_this).index() + ")").addClass("thisStep");
   		
   		statType = $(_this).attr("id");
   		LayerStatPage.updateStatistics(statType);
   		},
        updateStatistics: function(statTypeValue) {
        	$(".textNm").text($(".step_btn li.thisStep").text());
        	//statType = layer(레이어 통계), data(데이터 통계), download(다운로드 통계)
        	statType = statTypeValue;
    	    firstGrid = initGridA();
    	    
    	    var param = {
    	    		"STAT_TYPE" : statTypeValue,
                    "DEPT_NM": _select.val($('[data-ax5select="selectGroupId1"]'))[0].dept_nm,
                    "START_DT": $('#startByDate1').val(),
                    "END_DT": $('#endByDate1').val()
                };

    	    gfn_transaction("/mngStatLayerData.do", "POST", param, "select"); 
        	
        }
    };

    function fn_callback(actionType, data){

    	switch (actionType) {
    	
    	  case "select":
    		  
             
	   		  const { grid1Ret, LayerDeptPercent } = data;
	   		  
	   		//그리드
          	firstGrid.setData(grid1Ret);
          	var data = firstGrid.list;
     	   var labels = data.map(item => item.layer_nm);
     	   
	   		 // 막대차트 그리기
	            var datas = {
	            		 labels: labels, //x축 레이블
	                    datasets: [{
	                        label: '횟 수',//데이터셋을 설명
	                        data: data.map(item => item.total),//각 레이블에 해당하는 데이터 값
	                        backgroundColor: "rgba(255, 201, 14, 0.5)",  //막대의 채우기 색상
	                        borderColor: "rgba(255, 201, 14, 1)",  //막대 테두리의 색상
	                        hoverBackgroundColor: 'rgba(255, 124, 0, 0.5)' //막대를 마우스로 가리켰을 때의 배경색
	                    }]
	   			};
	           
	            var options = {
	            		  indexAxis: 'y',
	                      responsive: true,  // 차트가 다양한 화면 크기에 반응
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
	                            max: calculateMaxYValue(grid1Ret.map(item => item.total)), // x축 최대값 설정
	                            
	                        }
	                    },
	                    plugins: {
	                        zoom: {
	                            pan: {
	                                enabled: true,
	                                mode: 'y' // y축 스크롤만 가능
	                            },
	                            zoom: {
	                                wheel: {
	                                    enabled: true // 마우스 휠로 확대/축소 가능
	                                },
	                                pinch: {
	                                    enabled: true
	                                },
	                                mode: 'y', // y축에서만 zoom 가능
	                                onZoom: function({chart}) {
	                                    // 줌이 발생하면 y축의 스케일 값을 확인
	                                    const yScale = chart.scales.y;
	                                    const zoomLevel = yScale.max - yScale.min;

	                                    // 줌 레벨에 따라 datalabels의 표시 여부를 설정
	                                    chart.options.plugins.datalabels.display = zoomLevel < 50; // 예: 50 이하로 줌인된 경우에만 표시
	                                    // 줌인이 발생하면 autoSkip을 false로 변경
	                                    chart.options.scales.y.ticks.autoSkip = false;
	                                    chart.update();
	                                },
	                                onZoomComplete: function({chart}) {
	                                    // 줌이 끝났을 때 autoSkip을 원래 상태로 복구
	                                    chart.options.scales.y.ticks.autoSkip = true;
	                                    chart.update();
	                                }
	                            }
	                        },
	                        tooltip: {  // 도구 설명(차트 요소 위로 마우스를 가져갈 때 나타나는 작은 상자)의 동작과 모양을 구성
	                            enabled: true,
	                            mode: 'nearest',  // 툴팁이 가장 가까운 데이터에만 나타나도록 설정
	                            intersect: true,  // 툴팁이 커서가 요소 위에 있을 때만 나타남
	                            callbacks: {
	                                label: function(context) {
	                                    return context.dataset.label + ': ' + context.raw;
	                                }
	                            }
	                        },
	                        legend: {  // 차트 범례를 구성
	                            display: true,  // 차트에 범례를 표시
	                            position: 'top'  // 범례를 차트의 맨 위에 배치
	                        },
	                        datalabels: {  // 각 막대에 표시되는 레이블을 구성
	                            display: false,
	                            anchor: 'end', // 막대를 기준으로 한 레이블의 위치
	                            align: 'end',  // 막대를 기준으로 레이블을 정렬
	                            color: 'black',
	                            clamp: true,
	                            clip: true, // 라벨이 차트의 경계를 벗어나면 표시 X
	                            formatter: function(value) {
	                            	// 값이 0일 경우 빈 문자열을 반환하여 라벨을 숨김
	                                //return value < 10 ? '' : value;
	                            	return value == 0 ? '' : value;
	                            }
	                        }
	                    },
	                    layout: {
	                        padding: 10 // 차트와 캔버스 가장자리 간의 패딩 추가
	                    },
	                    interaction: {  // 상호작용 설정
	                        mode: 'nearest',  // 마우스 위치에서 가장 가까운 데이터에만 상호작용 발생
	                        intersect: true  // 커서가 요소 바로 위에 있을 때만 상호작용 발생
	                    }
	    	        };
	              
	    	    
	        	drawChart('bar', datas, options, [ChartDataLabels], "barChart"); 

	            
	         // 원형차트 그리기
	         let hoveredIndex = null; // 현재 hover된 데이터 포인트의 인덱스를 저장
			  // 기본 스타일 정의
		     var defaultFontSize = 12;
		    var hoverFontSize = 16; // Hover 시 변경할 폰트 크기
	            var datas_pie = {
	           		 labels: LayerDeptPercent.map(item => item.dept_nm), //x축 레이블
	                 datasets: [{
	                     data: LayerDeptPercent.map(item => item.percentage),
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
	              
	        	drawChart('pie', datas_pie, options_pie, [ChartDataLabels], "pieChart"); 
	            
				//트리맵차트
	            var datas_tree = {

	                    datasets: [{
	                        tree: grid1Ret,
	                        key: 'total',
	                        groups: ['grp_nm', 'layer_nm'],
	                        spacing: 2, // 요소 간의 간격 조정
	                        borderColor: '#FF8F00',
	                        borderWidth: 2, // 기본 테두리 두께
	                        backgroundColor: 'rgba(255,167,38,0.3)',
	                        hoverBackgroundColor: 'rgba(238,238,238,0.5)',
	                        hoverBorderColor: "#0095bd", // 호버 시 테두리 색상00caff
	                        hoverBorderWidth: 3, // 호버 시 테두리 두께
	                        captions: {
	                            align: 'center',
	                            display: true,
	                            color: 'black', // 밝은 글씨 색상으로 대비 향상
	                            font: {
	                                size: 11,
	                                weight: 'bold'
	                            },
	                            hoverFont: {
	                                size: 13,
	                                weight: 'bolder',
	                                color: 'black', // 호버 시 글씨 색상 변경
	                            },
	                            padding: 5,
	                            formatter: (context) => {
	                            	var node = context.dataset.data[context.dataIndex];
	                            	var value = node.v || 0;
	                            	var group = node.g || 'Unknown';
	                                return  [group + "(" + value + ")"];// 대그룹 이름과 값 표시
	                            }
	                        },
	                        labels: {
	                        	display: true,
	                            formatter: (context) => {
	                                var label = context.raw.g || 'Unknown';
	                                var value = context.raw.v || 0;
	                                return value <= 5 ? '' : [label, value];
	                            },
	                            color: 'black', // 레이블 글씨 색상
	                            font: {
	                                size: 11
	                            },
	                            padding: 2 // 패딩 조정
	                          }
	                    }]
	     			};
	             
	              var options_tree = {
	            		  responsive: true, // 차트가 화면 크기에 맞게 조정되도록 설정
	                      maintainAspectRatio: false, // 컨테이너의 크기에 따라 차트가 변형될 수 있도록 설정
	                       plugins: {
	                           legend: {
	                           	display: false // 범례 숨김
	                           },
	                           tooltip: {
	                               callbacks: {
	                                   label: function(context) {
	                                	   var label = context.raw.g || 'Unknown';
	                                       var value = context.raw.v || 0;
	                                       return [label, value];
	                                   }
	                               }
	                           }
	                       },
	                       layout: {
	                           padding: 10 // 차트와 캔버스 가장자리 간의 패딩 추가
	                       }
	      	        };
	                
	            drawChart('treemap', datas_tree, options_tree, null, "treeChart"); 
    		break;

    	  default:
    	    null; 
    	}
    }
    
    $(document.body).ready(function () {
    	LayerStatPage.initObject();
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
	                <li class="thisStep" onclick="LayerStatPage.tabClick(this);" id="layer">레이어 통계</li>
	                <li onclick="LayerStatPage.tabClick(this);" id="data">데이터 통계</li>
	                <li onclick="LayerStatPage.tabClick(this);" id="download">다운로드 통계</li>
	            </ul>
	        </div>
            <div id="tab0">
				<div class="clearfix">
					<div class="clearfix" id="statusOpt">
						<div>
							<div class="form-inline">
								<label>기간 설정</label>
								<div class="input-group" data-ax5picker="datePicker1">
									<input type="text" id="startByDate1" class="form-control" placeholder="yyyy-mm-dd" style="height: 32px;" title="시작일"> 
									<span class="input-group-addon">~</span> 
									<input type="text" id="endByDate1" class="form-control" placeholder="yyyy-mm-dd" style="height: 32px;" title="종료일"> 
									<span class="input-group-addon"><i class="fa fa-calendar-o"></i></span>
								</div>
								<div class="form-group">
									<div data-ax5select="selectGroupId1" data-ax5select-config="{columnKeys:{optionValue: 'no', optionText: 'dept_nm'}}" style="min-width: 180px;"></div>
								</div>
								<div  id="BtnExcel" style="display: contents;">
									<button class="btn stat_btn btn-md" onclick="LayerStatPage.buttonClick(this);" id="excel1">통계표 다운로드</button>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="container_chart_ht" style = "height: 650px;">
					<div class="convertDiv1_ht">
						<label>통계 차트</label>
						<div class="chart-container_ht">
							<canvas id="barChart"></canvas>
						</div>
					</div>
					 <div class="right-container_ht">
				        <div class="convertDiv2_ht">
				            <label><span class="textNm"></span> 이용률</label>
				            <div class="chart-container_ht">
				                <canvas id="pieChart"></canvas>
				            </div>
				        </div>
				        <div class="convertDiv3_ht">
				            <label><span class="textNm"></span> 상세 차트</label>
				            <div class="chart-container_ht">
				            	<canvas id="treeChart"></canvas>
				            </div>
				        </div>
				    </div>
				</div>
				 <div class="hidden-grid">
				<div data-ax5grid="first-grid" data-ax5grid-config='{}'></div>
				</div> 
				<!-- <div class="hidden-grid">
				<div data-ax5grid="first-grid" data-ax5grid-config='{}'></div>
				</div> -->
				<%-- <div class="container_chart">
					<div class="convertDiv1">
						<label>통계 차트</label>
						<div class="chart-container">
							<canvas id="barChart"></canvas>
						</div>
					</div>
					<div class="convertDiv2">
						<label>전체 레이어 이용률</label>
						<div class="chart-container">
							<canvas id="pieChart"></canvas>
						</div>
					</div>
				</div> 
				 <div class="board_table_wrap" style="height: 42vh;">
					<div data-ax5grid="first-grid" data-ax5grid-config='{}' style="height: 100%;"></div>
				</div>--%>
			</div>
        </div>
    </div>
