<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>


<script src="<c:url value='/resources/js/admin/statistics/menuStat.js'/>"></script>
<script src="<c:url value='/resources/js/admin/statistics/chartCommon.js'/>"></script>

<script>
    //'use strict';

	var firstGrid = ""; //gridObject
	var grpData = ${grpData}; 
	
    var MenuStatPage = {
        picker1: null,
        select1: null,
        initObject: function() {
        	
            grpData.unshift({ no: null, dept_nm: "전체" }); //부서선택 - '전체'추가
            
            this.initControls(); //날짜, 부서선택 초기화
            this.setInitialDates(); //닐짜 초기값 설정
            this.getGridDataAjax();//레이어 통계 표출
            
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
            	MenuStatPage.getGridDataAjax();
            }
        },
        pickerTrigger: function(obj, objName) {
            if (obj.state === "close" && objName === 'datePicker1') {
            	MenuStatPage.getGridDataAjax();
            }
        },
        buttonClick: function(_this) {
        	if ($(_this).attr("id") === "excel1") {
        		 var startNm = $('#startByDate1').val();
        		 var endNm = $('#endByDate1').val();
             	 var excelNm = startNm.replaceAll('-', '')+"-"+endNm.replaceAll('-', '');
                firstGrid.exportExcel("통계 - 메뉴별 조회( "+excelNm+" ).xls");
            } else {
                _dialog.alert("버튼 id가 지정되지 않았습니다.");
            }
        },
        getGridDataAjax: function() {
            
            firstGrid = initGridA();
            
       		//param = 선택부서, 조회 시작일자, 조회 종료일자
            var param = {
                "DEPT_NM": _select.val($('[data-ax5select="selectGroupId1"]'))[0].dept_nm,
                "START_DT": $('#startByDate1').val(),
                "END_DT": $('#endByDate1').val()
            };
        	
            gfn_transaction("/mngStatMenuData.do", "POST", param, "select"); 
            
        }
    };
        
    
    function fn_callback(actionType, data){

    	switch (actionType) {
    	
    	  case "select":
    		  
    		var { grid1Ret, getMenuDeptPercent } = data;
    		
    		 //그리드
        	  firstGrid.setData(grid1Ret);
        	   var data = firstGrid.list;
        	   var labels = data.map(item => item.progrm_nm);

        	   // 막대차트 그리기
            var datas = {
            		 labels: labels, //x축 레이블
                    datasets: [{
                        label: '횟 수',//데이터셋을 설명
                        data: data.map(item => item.total), //각 레이블에 해당하는 데이터 값
                        backgroundColor: "rgba(255, 201, 14, 0.5)",  //막대의 채우기 색상
                        borderColor: "rgba(255, 201, 14, 1)",  //막대 테두리의 색상
                        hoverBackgroundColor: 'rgba(255, 124, 0, 0.5)' //막대를 마우스로 가리켰을 때의 배경색
                    }]
   			};
           
            var options = {
                	indexAxis: 'y', 
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
	     var defaultFontSize = 12;
	    var hoverFontSize = 16; // Hover 시 변경할 폰트 크기
            var datas_pie = {
           		 labels: getMenuDeptPercent.map(item => item.dept_nm), //x축 레이블
                 datasets: [{
                     data: getMenuDeptPercent.map(item => item.percentage),
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
            
			//트리맵차트
            var datas_tree = {

                    datasets: [{
                        tree: grid1Ret,
                        key: 'total',
                        groups: ['p_progrm_nm', 'progrm_nm'],
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
    };
    
    
    $(document.body).ready(function () {
    	MenuStatPage.initObject();
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
								<div id="BtnExcel" style="display: contents;">
									<button class="btn stat_btn btn-md" onclick="MenuStatPage.buttonClick(this);" id="excel1">통계표 다운로드</button>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="container_chart_ht">
					<div class="convertDiv1_ht">
						<label>통계 차트</label>
						<div class="chart-container_ht">
							<canvas id="barChart"></canvas>
						</div>
					</div>
					 <div class="right-container_ht">
				        <div class="convertDiv2_ht">
				            <label>전체 메뉴 이용률</label>
				            <div class="chart-container_ht">
				                <canvas id="pieChart"></canvas>
				            </div>
				        </div>
				        <div class="convertDiv3_ht">
				            <label>메뉴별 상세 차트</label>
				            <div class="chart-container_ht">
				            	<canvas id="treeChart"></canvas>
				            </div>
				        </div>
				    </div>
				</div>
				<div class="hidden-grid">
				<div data-ax5grid="first-grid" data-ax5grid-config='{}'></div>
				</div>
				<!-- <div class="board_table_wrap" style="height: 42vh;">
					<div data-ax5grid="first-grid" data-ax5grid-config='{}' style="height: 100%;"></div>
				</div> -->
			</div>
        </div>
    </div>
