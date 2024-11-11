<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<title>기본 입지 분석(중첩) 검색결과</title>

<script type="text/javascript"
	src="<c:url value='/resources/js/map/task/searchView.js'/>"></script>
<script type="text/javascript">
	// 시작 탭 메뉴 - 공통
	var selectedResultMenu = 'land';
	// 응답결과 Obj - 공통
	var resultDataObj = '${resultData}';
	<%
		// 각 파라미터 개별적으로 받기
		String inputLyrIdList = request.getParameter("inputLyrIdList");
	%>

  var analysisParams = {
    inputLyrIdList: '<%=inputLyrIdList%>'
  };

  $(document).ready(function() {

    // 분석 결과 존재 여부 체크 - 공통
    if(resultDataObj.result == 'false') { 
      alert('분석 결과가 존재하지 않습니다. 조건을 변경해주세요.');
      window.close();
      return;
    }
    
  	console.log('분석 파라미터:', analysisParams);
  	// analysisParams.inputLyrIdList 등으로 접근 가능
  	try {
  		const resultData = deepDecode(resultDataObj);
  		switchSelectTab();
  		displayResult(resultData.data);
  	} catch (e) {
  		console.log(e)
  	}
	});
    
	// 응답결과 깊은 복사 - 공통
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
    
	/* 데이터 전달시 예외 처리 - 공통
	window.onload = function() {
      try {
        if (resultData.result) {
          //displayResult(resultData.data);
        } else {
          alert('데이터 처리 중 오류가 발생했습니다.');
          return;
        }
      } catch (error) {
        // todo : 빈창 처리
        console.log(error);
       // doAfterAnalysis();
      }
    } */
    
  /* 지도 시각화, 테이블, 리스트, 차트, 범례 데이터 생성 - 개별 */
  function displayResult(data) {
 		try {
 			//! 초기화!!
 			$('#SH_AnalysisResult_Chart').empty();
      let featuresLg = 0;
      let isNullResult = true;
      const inputLyrIdList = analysisParams.inputLyrIdList.split(',');
      inputLyrIdList.forEach((id) => {
        if (data[id].features.length > 0) isNullResult = false;
      });

      if (isNullResult) {
        alert('분석 결과가 존재하지 않습니다. 조건을 변경해주세요');
        return;
      }

      const vectorSource = new ol.source.Vector();
      var layerList = [];

      if (data) {
        const styleColors = {};

        Object.keys(data).forEach((key, idx) => {
          const parseData = data[key];
          if (parseData.features.length) {
            featuresLg = parseData.features.length;
            const reader = new ol.format.GeoJSON();

            const features = reader.readFeatures(parseData, {
              dataProjection: 'EPSG:4326',
              featureProjection: 'EPSG:3857'
            });

            features.forEach((feature, fIdx) => {
              feature.set("layer_nm_style", key);
            });

            let [fillColor, strokeColor] = randomColor(0.4);
            styleColors[key] = { fill: fillColor, stroke: strokeColor };

            vectorSource.addFeatures(features);
          }
        });

        if (featuresLg === 0) {
          alert('중첩 레이어가 존재하지 않습니다. 다시 선택해주세요.');
        } else {
          var vectorLayer = new ol.layer.Vector({
            title: 'analysis',
            serviceNm: '기본입지분석(중첩)',
            source: vectorSource,
          });

          vectorLayer.setStyle(createBasicLocLayerStyle(vectorLayer, 'layer_nm_style', styleColors));

          opener.geoMap.getView().fit(vectorSource.getExtent(), opener.geoMap.getSize());
          opener.geoMap.addLayer(vectorLayer);
  			
          Table(data, opener.overlayLyrs, styleColors);
          /* analLayer(contextPath, exportKey); */
          /*  resultLegend(styleColors); */
        }
      }

    } catch (e) {
      debugger;
  		console.log(e);
  	}
  }
  
  /* 탭 선택시, 이벤트 - 공통 */
  function switchSelectTab() {
    $("#SH_SearchList_tab li a").on('click', function(e){
  	  selectedUl.removeClass('selected');
	    $(e.target).parent().addClass('selected');
	
  	  const selectedUl = $("#SH_SearchList_tab li").find(".selected");
  	  const type = selectedUl.data('toggle');
	  
      // 각 타입 기본 컨테이너 필요시 전처리 - 개별
      /* if (type == 'table') {	
      	
        } else if (type == 'chart') {
  		
        } else if (type == 'list') {
         	
        }
      }) */
    })
  }
  
  // 테이블 시각화 - 개별
  function Table(data, overlayLyrs, styleColors) {
  	
    let titleJson = {};
    var container = $('#SH_AnalysisResult_Table');
    /* container.css('max-height', '700px'); */

    Object.keys(data).forEach((layerName, layerIndex) => {
      let layerGeoJson = data[layerName];

      const groupDiv = document.createElement("div");
      groupDiv.className = "form-group graph";

      const textDiv = document.createElement("div");
      textDiv.style.maxHeight = "430px";
      textDiv.style.overflowY = "auto";
      groupDiv.append(textDiv);

      const tableElm = document.createElement("table");
      tableElm.className = "table table-custom table-cen table-num text-center";
      tableElm.style.width = "100%";
      textDiv.append(tableElm);

      const headElement = document.createElement('thead');
      const bodyElement = document.createElement('tbody');

      const headRow = document.createElement('tr');
      if (layerGeoJson.features.length > 0) {
        const jsonKeys = Object.keys(layerGeoJson.features[0].properties);
        jsonKeys.forEach((jsonKey, keyI) => {
          let th = document.createElement('th');
          th.innerText = jsonKey;

          headRow.append(th);
        });
        headElement.append(headRow);
        tableElm.append(headElement);

        layerGeoJson.features.forEach((feature, featureI) => {
          let bodyRow = document.createElement('tr');
          jsonKeys.forEach((jsonKey, keyI) => {
            let td = document.createElement('td');
            td.innerText = feature.properties[jsonKey];
            if (td.innerText == null || typeof td.innerText === 'undefined') {
              td.innerText = '-';
            }

            bodyRow.append(td);
          });
          bodyElement.append(bodyRow);
        });
      } else {
        let thA = document.createElement('th');
        thA.innerText = '-';
        headRow.append(thA);
        headElement.append(headRow);
        tableElm.append(headElement);

        let bodyRow = document.createElement('tr');
        let tdA = document.createElement('td');
        tdA.innerText = '중첩되는 레이어가 없습니다.';
        bodyRow.append(tdA);
        bodyElement.append(bodyRow);
      }

      tableElm.append(bodyElement);

      const titleElm = document.createElement('h3');
      titleElm.innerText = titleJson[layerName] + "(" + layerGeoJson.features.length + "건)";
      Object.keys(titleJson).forEach((obj) => {
        if (obj === layerName) {
          titleElm.style.color = styleColors[layerName];
        }
      });

      container.append(titleElm);
      container.append(tableElm);
    });
  }

  function randomColor(opacity) {
    const r = Math.floor(Math.random() * 255);
    const g = Math.floor(Math.random() * 255);
    const b = Math.floor(Math.random() * 255);

    const fillColor = "rgba(" + r + "," + g + "," + b + "," + opacity + ")";
    const strokeColor = "rgb(" + r + "," + g + "," + b + ")";

    return [fillColor, strokeColor];
  }

  function createBasicLocLayerStyle(vectorLayer, field, styleColors) {
    function styleFunction(feature, resolution) {
      const val = feature.get(field);
      let fillColor = styleColors[val].fill;
      let strokeColor = styleColors[val].stroke;

      return [
        new ol.style.Style({
          fill: new ol.style.Fill({ color: fillColor }),
          stroke: new ol.style.Stroke({ color: strokeColor, width: 2 })
        })
      ];
    }

    return styleFunction;
  }

	</script>
</head>
<style>
  .popover-content-wrap {
    height: calc(100% - 150px); /* 상단 헤더와 하단 푸터 높이를 제외한 나머지 */
    overflow: auto;
  }
  
  .tab-content {
    height: 100%;
  }
  
  .tab-pane {
    height: 100%;
    overflow: auto;
  }
  
  #SH_AnalysisResult_Table {
    padding: 15px;
    height: 100%;
    overflow: auto;
  }
  
  /* 테이블 내부 스크롤을 위한 스타일 */
  .form-group.graph {
    margin-bottom: 20px;
  }
  
  .form-group.graph > div {
    border: 1px solid #ddd;
    border-radius: 4px;
  }
</style>
<body>
	<div class="popover layer-pop new-pop" id="asset-search-list"
		style="width: 100%; height: 100%; top: auto; display: block;">
		<div class="popover-title tit">
			<span class="m-r-5"> <b>기본입지분석 (통계) 검색결과</b>
			</span> <span class="small">(전체 <strong class="text-orange"
				id="total_cnt"></strong> 건)
			</span>
		</div>

		<div class="popover-body">

			<div class="row btn-wrap-group">
				<div class="col-xs-12">
					<div class="btn-wrap text-right">
						<button type="button" class="btn btn-xs btn-info" onClick="">검색결과 지도 표출</button>
						<button type="button" class="btn btn-xs btn-default">엑셀 다운로드</button>
					</div>
				</div>
			</div>

			<ul class="nav nav-tabs" id="SH_SearchList_tab">
				<li><a data-toggle="tab-01" onClick="switchSelectTab()">(분석서비스 명칭) 차트</a></li>
				<li class="active"><a data-toggle="tab-02" onClick="switchSelectTab()">표</a></li>
				<li><a data-toggle="tab-03" onClick="switchSelectTab()">리스트</a></li>
				<!-- <li><a data-toggle="tab-04" href="#SH_SearchList_gb"></a></li>    -->
			</ul>


			<div class="popover-content-wrap asset-srl">
				<div class="popover-content tab-content">
					<div class="tab-pane" id="SH_AnalysisResult_Chart"></div>
					<div class="tab-pane active" id="SH_AnalysisResult_Table"></div>
					<div class="tab-pane" id="SH_AnalysisResult_List"></div>
				</div>
			</div>

		</div>

		<!-- <div class="popover-footer">
			<div class="srl-pagination text-center">
				<ul class="pagination m-b-5 m-t-10 pagination-sm" id="pageZone"></ul>
			</div>
		</div> -->
	</div>
</body>
</html>