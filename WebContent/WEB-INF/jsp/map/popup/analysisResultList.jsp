<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />


<!DOCTYPE html>
<html>
<head>
	<title>Insert title here</title>

	<script type="text/javascript" src="<c:url value='/resources/js/map/task/searchView.js'/>"></script>
	<script type="text/javascript">
	
		var resultDataObj = "${resultData}"

		function deepDecode(obj) {
	    if (typeof obj === 'string') {
        try {
          const decoded = decodeURIComponent(obj);
          return JSON.parse(decoded);
        } catch (e) {
          return obj;
        }
	    }
	  
	    if (Array.isArray(obj)) {
	        return obj.map(item => deepDecode(item));
	    }
	    
	    if (typeof obj === 'object' && obj !== null) {
	      const result = {};
	      for (const key in obj) {
	          result[key] = deepDecode(obj[key]);
	      }
	      return result;
	    }
	    
	    return obj;
		}

		var selectedResultMenu = 'land';
		var analysisResultData = deepDecode(JSON.parse('${resultData}'));
		var selectedData = analysisResultData[selectedResultMenu];

		let itemName1 = {
		    apartPrice: [
		        ['고유번호', 'pnu'], 
		        ['공시가격', 'pblntfPc']
		    ],
		    buld: [
		        ['가구 수(가구)', 'fmlyCnt'],
		        ['높이(m)', 'heit'], 
		        ['도로명대지위치', 'newPlatPlc'],
		        ['세대 수(세대)', 'hhldCnt'],
		        ['지상층수', 'grndFlrCnt'],
		        ['지하층수', 'ugrndFlrCnt']
		    ],
		    indvdPrice: [
		        ['고유번호', 'pnu'],
		        ['주택가격', 'housePc']
		    ],
		    land: [
		        ['고유번호', 'pnu'],
		        ['토지면적', 'lndpclAr']
		    ],
		    landPrice: [
		        ['고유번호', 'pnu'],
		        ['공시지가', 'pblntfPclnd']
		    ]
		};
		let itemName2 = {
		    apartPrice: [
	        ['고유번호', 'pnu'],
	        ['공동주택구분명', 'aphusSeCodeNm'],
	        ['공동주택명', 'aphusNm'], 
	        ['공시가격', 'pblntfPc'],
	        ['기준연도', 'stdrYear'],
	        ['기준월', 'stdrMt'],
	        ['데이터기준일자', 'lastUpdtDt'],
	        ['법정동명', 'ldCodeNm'],
	        ['전용면적', 'prvuseAr'],
	        ['지번', 'mnnmSlno'],
	        ['층명', 'floorNm'],
	        ['특수지구분명', 'regstrSeCodeNm'],
	        ['특수지명', 'spclLandNm'],
	        ['호명', 'hoNm']
		    ],
		    buld: [
	        ['가구 수(가구)', 'fmlyCnt'],
	        ['구조코드명', 'strctCdNm'],
	        ['높이(m)', 'heit'],
	        ['대지위치', 'platPlc'],
	        ['도로명대지위치', 'newPlatPlc'],
	        ['사용승인일', 'useAprDay'],
	        ['세대 수(세대)', 'hhldCnt'],
	        ['연면적(㎡)', 'totArea'],
	        ['주용도코드명', 'mainPurpsCdNm'],
	        ['지상층수', 'grndFlrCnt'],
	        ['지하층수', 'ugrndFlrCnt'],
	        ['허가일', 'pmsDay'],
	        ['호수(호)', 'hoCnt']
		    ],
		    indvdPrice: [
	        ['고유번호', 'pnu'],
	        ['건물산정연면적', 'ladRegstrAr'],
	        ['건물전체연면적', 'buldCalcTotAr'],
	        ['건축물대장고유번호', 'bildRegstrEsntlNo'],
	        ['기준연도', 'stdrYear'],
	        ['기준월', 'stdrMt'],
	        ['데이터기준일자', 'lastUpdtDt'],
	        ['동코드', 'dongCode'],
	        ['법정동명', 'ldCodeNm'],
	        ['산정대지면적', 'buldAllTotAr'],
	        ['주택가격', 'housePc'],
	        ['지번', 'mnnmSlno'],
	        ['토지대장면적', 'calcPlotAr'],
	        ['특수지구분명', 'regstrSeCodeNm'],
	        ['표준지여부', 'stdLandAt']
		    ],
		    land: [
	        ['고유번호', 'pnu'],
	        ['공시지가', 'pblntfPclnd'],
	        ['기준연도', 'stdrYear'],
	        ['기준월', 'stdrMt'],
	        ['대장구분명', 'regstrSeCodeNm'],
	        ['데이터기준일자', 'lastUpdtDt'],
	        ['도로접면', 'roadSideCodeNm'],
	        ['법정동명', 'ldCodeNm'],
	        ['용도지역명1', 'prposArea1Nm'],
	        ['용도지역명2', 'prposArea2Nm'],
	        ['지목명', 'lndcgrCodeNm'],
	        ['지번', 'mnnmSlno'],
	        ['지형높이', 'tpgrphHgCodeNm'],
	        ['지형형상', 'tpgrphFrmCodeNm'],
	        ['토지면적', 'lndpclAr'],
	        ['토지이용상황', 'ladUseSittnNm'],
	        ['토지일련번호', 'ladSn']
		    ],
		    landPrice: [
	        ['고유번호', 'pnu'],
	        ['공시일자', 'pblntfDe'],
	        ['공시지가', 'pblntfPclnd'],
	        ['기준연도', 'stdrYear'],
	        ['기준월', 'stdrMt'],
	        ['데이터기준일자', 'lastUpdtDt'],
	        ['법정동명', 'ldCodeNm'],
	        ['지번', 'mnnmSlno'],
	        ['특수지구분명', 'regstrSeCodeNm'],
	        ['표준지여부', 'stdLandAt']
		    ]
		};

		$(document).ready(function() {
			const resultData = deepDecode(resultDataObj);
			debugger;
		});

		function showInfo() {
			try {
				var analysisList = [];
				let getStatisticsData = (title) => analysisResultData.statistics.filter((ele) => ele.gubun === title)[0];
				let getItemArr = (selectedData, i) => (selectedData[i].totalCount === 1 && selectedData[i].items) ? [selectedData[i].items.item] : selectedData[i].items.item;

				switch (selectedResultMenu) {
					case 'buld':
						const statisticsData = getStatisticsData('건축물대장');
            
            for (let i = 0; i < selectedData.length; i++) {
              let itemArr = (selectedData[i].totalCount === 1 && !!selectedData[i].items) ? [selectedData[i].items.item] : selectedData[i].items.item;
              
							itemArr.map((ele) => {
                  ele.pnu = selectedData[i].pnu;
                  return ele;
              });

              analysisList.push(...itemArr);
            }
						break;
					case 'land':
						statisticsData = analysisResultData.statistics.filter((ele) => ele.gubun === '토지대장')[0];

						for (let i = 0; i < selectedData.length; i++) {
              let itemArr = selectedData[i].field;

              analysisList.push(...itemArr);
            }
						break;
					case 'landPrice':
						statisticsData = analysisResultData.statistics.filter((ele) => ele.gubun === '개별공시지가')[0];

						for (let i = 0; i < selectedData.length - 1; i++) {
              let item = selectedData[i].totalCount === 1 ? selectedData[i].field : selectedData[i].field[selectedData[i].totalCount - 1];

              analysisList.push(item);
            }
						break;
					case 'apartPrice':
						statisticsData = analysisResultData.statistics.filter((ele) => ele.gubun === '공동주택가격')[0];
						
						for (let i = 0; i < selectedData.length - 1; i++) {
              let itemArr = selectedData[i].totalCount === 1 ? [selectedData[i].field] : selectedData[i].field;

              analysisList.push(...itemArr);
            }
						break;
					case 'indvdPrice':
						statisticsData = analysisResultData.statistics.filter((ele) => ele.gubun === '개별주택가격')[0];

						for (let i = 0; i < selectedData.length - 1; i++) {
              let itemArr = selectedData[i].totalCount === 1 ? [selectedData[i].field] : selectedData[i].field;

              analysisList.push(...itemArr);
            }
						break;
					default:
						break;
				}

				for (let i = 0; i < selectedData.length; i++) {
          let itemArr = selectedData[i].totalCount === 1 ? [selectedData[i].items.item] : selectedData[i].items.item;
          itemArr.map((ele) => {
            ele.pnu = selectedData[i].pnu;
            return ele;
          });
					analysisList.push(...itemArr);
				}

				let contentHtmlHeader2 = '<tr>';
				contentHtmlHeader2 += '	<th>화면 이동</th>';

				$('#SH_SearchList_gb_header')[0].innerHTML = contentHtmlHeader2;

				let contentHtmlBody2 = '';
					
				analysisList.map((analysisData) => {
					contentHtmlBody2 += '<tr>';
					contentHtmlBody2 += '<td>';
					contentHtmlBody2 += '	<button class="btn btn-xs btn-custom" onclick="moveMap(' + analysisData.geom + ')">';
					contentHtmlBody2 += '		<i class="fa fa-search"></i>';
					contentHtmlBody2 += '	</button>';
					contentHtmlBody2 += '</td>';

					itemName2[selectedResultMenu].map((ele) => {
						contentHtmlBody2 += '<td>' + analysisData[ele[1]] + '</td>';
					});
					contentHtmlBody2 += '</tr>';
				});

				if(analysisList.length == 0) {
					contentHtmlBody2 += '<tr><td colspan="' + itemName2[selectedResultMenu].length + '">선택지역에 대한 데이터가 존재하지 않습니다.</td></tr>';
				}
				$('#SH_SearchList_gb_body')[0].innerHTML = contentHtmlBody2;
				
			} catch (error) {
				debugger;
			}
		}

		function moveMap(geom) {
			// todo : 지도 이동
			geoMap.getView().setCenter(geom);
		}

	</script>
	<style>
	.chart-container {
	  position: relative;
	  max-height: 360px;
	  width: 80%;
	  margin: 20px auto;
	  display: flex;
	  justify-content: center;
	  align-items: center;
	}

	#chartCanvas {
	  max-width: 100%;
	  height: auto;
	}
	</style>
</head>
<body>
	<div class="popover layer-pop new-pop" id="asset-search-list" style="width:100%; height:100%; top:auto; display:block;">
		<div class="popover-title tit">
		    <span class="m-r-5">
		        <b>대상지 탐색(통계) 검색결과</b>
		    </span>
		    <span class="small">(전체 <strong class="text-orange" id="total_cnt"></strong> 건)</span>
		</div>
		
		<div class="popover-body">

			<div class="row btn-wrap-group">
				<div class="col-xs-12">
						<div class="btn-wrap text-right">
							 <button type="button" class="btn btn-xs btn-info" onClick="">검색결과 지도 표출</button>
							<button type="button" class="btn btn-xs btn-default" onClick="">엑셀 다운로드</button>
						</div>
				</div>
			</div>

			<ul class="nav nav-tabs" id="SH_SearchList_tab">
				<li class="active"><a data-toggle="tab-01" href="#SH_SearchList_gb">(분석서비스 명칭) 기본검색</a></li>   
				<li><a data-toggle="tab-02" href="#SH_SearchList_gb">기본검색</a></li>   
				<li><a data-toggle="tab-03" href="#SH_SearchList_gb">기본검색</a></li>   
				<li><a data-toggle="tab-04" href="#SH_SearchList_gb">기본검색</a></li>   
			</ul>

			<div class="popover-content-wrap asset-srl">  
				<div class="popover-content tab-content">
					<div class="tab-pane active" id="SH_SearchList_gb"> 
						<table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
							<thead id="SH_SearchList_gb_header"></thead>
							<tbody id="SH_SearchList_gb_body"></tbody>
						</table>
					</div>
				</div>
			</div>

			<!-- 
				<td>
					<button class="btn btn-xs btn-custom" onclick=";">
						<i class="fa fa-search"></i>
					</button>
				</td> 
			-->

		</div>
		
		<div class="popover-footer">
			<div class="srl-pagination text-center">
				<ul class="pagination m-b-5 m-t-10 pagination-sm" id="pageZone"></ul>
			</div>
	  </div>                           	                           	
	</div>
</body>
</html>