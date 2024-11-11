<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>
<%@ page import="egovframework.mango.config.SHResource"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />

<!DOCTYPE html>
<html lang="ko">
<script type="text/javascript">
	var contextPath = '${contextPath}';
	var shexPath = "<%=SHResource.getValue("sh.server.schema")%>://<%=SHResource.getValue("sh.server.url")%>";

	var componentData = [];

	$(document).ready(function(){
		$('#sub_content').show();
		initAnalService();
	
		componentData = [{ type: 'drawTool' }];

		doRenderSearchComp(componentData);
		// initDraw();
	})

	function doAnalysis(){
		doBeforeAnalysis();
		$('#content_area').empty();
		geoMap.getLayers().getArray()
    	.filter(lyr => lyr.get('title') === 'analysis').map(ele => geoMap.removeLayer(ele));
		resetLegend();

		const slopeType = 'DEGREE'
		const zFactor = 1.0;
		var width = $('#geomap')[0].clientWidth;
		var height = $('#geomap')[0].clientHeight;
		var imageExtent = null;

		if(!getInputArea()) {
			alert('입력데이터를 기입해주세요.')
			doAfterAnalysis();
			return;
		} 

		$.ajax({
			type : "POST",
			async : true,
			url : "<%=RequestMappingConstants.WEB_ANAL_DEV_AVAIL_RESULT%>",
			dataType : "json",
			data : { userArea: getInputArea() }, 
			error : function(response, status, xhr) {
				if (xhr.status == '404') {
					alert('분석에 실패했습니다.');
				}
			},
			success : function(data, status, xhr){

				try {
					const userArea = getInputArea();
				
					const wktFormat_ = new ol.format.WKT();
					const features = wktFormat_.readFeatures(getInputArea());
					
					var entire = 0;
					features.map(f => f.getGeometry().getArea()).forEach((num) => {
					  entire += num;
					});

					if(!data || data.result === false ){
						alert('분석에 실패했습니다.');
						return;
					}

					const biotopeSource = new ol.source.Vector();
					const biotopeIndivisualsSource = new ol.source.Vector();
					const permitSource = new ol.source.Vector();

					const biotopeTypes_3857 =  new ol.format.GeoJSON().readFeatures(data.result.biotopeTypes);
					const biotopeIndivisuals_3857 =  new ol.format.GeoJSON().readFeatures(data.result.biotopeIndivisuals);
					
					let permit;
					permit =  new ol.format.GeoJSON().readFeatures(data.result.permit);
					if(data.result.permit.crs.properties.name == 'EPSG:4326'){
						permit =  permit.map(f => new ol.Feature(f.getGeometry().transform('EPSG:4326', 'EPSG:3857')));
					}
					
					biotopeSource.addFeatures(biotopeTypes_3857);
					biotopeIndivisualsSource.addFeatures(biotopeIndivisuals_3857);
					permitSource.addFeatures(permit);

					const biotopeTypesLayer = new ol.layer.Vector({ 
						title: "biotopeTypes", 
						source: biotopeSource,
						style : devAnalLayerStyleList.biotopeTypes
					});
					const biotopeIndivisualsLayer = new ol.layer.Vector({ 
						title: "biotopeIndivisuals", 
						source: biotopeIndivisualsSource,
						style : devAnalLayerStyleList.biotopeIndivisuals
					});
					const permitLayer = new ol.layer.Vector({ 
						title: "permit", // similar
						source: permitSource,
						style : devAnalLayerStyleList.permit
					});

					const groupLayer = new ol.layer.Group({
						title: 'analysis',
						serviceNm: '개발행위 가능분석',
						layers: [biotopeTypesLayer, biotopeIndivisualsLayer, permitLayer],
					})

					geoMap.getView().fit(biotopeTypesLayer.getSource().getExtent(), geoMap.getSize());
					geoMap.addLayer(groupLayer);

					var exportKey = xhr.getResponseHeader('export_key');
					analLayer(contextPath, exportKey);
					removeModifyInteraction();

					Table({ ...data.result, entire });
					resultLegend();
					
				} catch (error) {
					console.log(error)
					alert('분석에 실패 했습니다.');
					doAfterAnalysis();
				}
			},
			complete: function(xhr, status) {
				doAfterAnalysis();
			}
		});
	}

	function getInputArea(){
		const wktFormat = new ol.format.WKT();
		var userArea = '';

		if(componentData[0].type == 'search'){ // 사업대상지
			userArea = $('#output_field').find('.selected').attr('value');
		} else {	// 도형 그리기
			const feature = getTargetVectorSource().getFeatures()[0];
			if(feature!==undefined && feature!==null){
				userArea = wktFormat.writeFeature(feature);
			}
		}

		return userArea;
	}

	function Table(data){
		const tableRowData = getTableRowData(data);
		doRenderModal([{ type: 'table' }]);

		$('#content_area #graph').css('display', 'block');
		const headElement = document.getElementById('dataResultTableHd');
		const bodyElement = document.getElementById('dataResultTableBd');

		$('#content_area #graph .text').prepend(`<h2 class="tit">개발행위 가능지역 결과</h2><h3>개발 행위 가능지역 결과</h3>`)

		const headRow = document.createElement('tr');
		const thead = document.createElement('th');
		thead.innerText = '구분';
		thead.innerText = '값';
		headElement.append(headRow);

		tableRowData.staticsData.forEach((tableRow) => {
			const row = document.createElement('tr');
			tableRow.map(ele => {
				const cell = document.createElement('td');
				let staticsUnit = ''; 

				if(ele == '평균 경사'){
					staticsUnit = ' (%)' 
				} else if(ele == '개발 가능지 면적'){
					staticsUnit = ' (m²)' 
				} else if(ele == '평균 표고'){
					staticsUnit = ' (m)' 
				}

				cell.textContent = covertLocaleString(ele) + staticsUnit;
				row.appendChild(cell);
			})
			bodyElement.appendChild(row);
		});

		$('#content_area #graph .text').append(`
			<h3>개별 비오톱평가도 등급별 면적 (m²)</h3>
			<table class="table table-custom table-cen table-num text-center" width="100%" style="table-layout: fixed;">
				<thead id="dataResultTableHd2"></thead>
      	<tbody id="dataResultTableBd2"></tbody>
			</table>

			<h3>비오톱 유형평가도 등급별 면적 (m²)</h3>
			<table class="table table-custom table-cen table-num text-center" width="100%" style="table-layout: fixed;">
				<thead id="dataResultTableHd3"></thead>
      	<tbody id="dataResultTableBd3"></tbody>
			</table>
		`)

		const headElement2 = document.getElementById('dataResultTableHd2');
		const bodyElement2 = document.getElementById('dataResultTableBd2');

		const headElement3 = document.getElementById('dataResultTableHd3');
		const bodyElement3 = document.getElementById('dataResultTableBd3');
		
		tableRowData.biotopeTypesData.forEach((tableRowArr) => {
			const row = document.createElement('tr');
			tableRowArr.map((ele)=> {
				const cell = document.createElement('td');
				cell.textContent = covertLocaleString(ele);
				row.appendChild(cell);
			})
			bodyElement2.appendChild(row);
		});

		tableRowData.biotopeTypesData.forEach((tableRow) => {
			const row = document.createElement('tr');
			tableRow.map(ele=> {
				const cell = document.createElement('td');
				cell.textContent =  covertLocaleString(ele);;
				row.appendChild(cell);
			})
			bodyElement3.appendChild(row);
		});
	}
	
	function getTableRowData(data_){
		const data = { ...data_, disableArea: data_.entire - data_.area };

		const staticsData = [
			// ['분석영역 전체 면적', data.entire], 
			['개발 가능지 면적', data.area], 
			// ['개발 불가능지 면적', data.disableArea],
			['평균 경사', data.meanSlope],
			['평균 표고', data.meanDem]
		];

		const biotopeTypesData = data.BiotopeTypes.map(item => Object.values(item));
		const biotopeIndivisualsData = data.BiotopeIndivisuals.map(item => Object.values(item));

		return { staticsData, biotopeTypesData, biotopeIndivisualsData }
	}

	function resultLegend(){

		const legendItem = [
			{ color: 'rgb(0, 255, 0)', name: '개발행위 가능지역', type: 'permit' },
			{ color: 'rgb(255, 255, 0)', name: '개별 비오톱평가도', type: 'biotopeIndivisuals' },
			{ color: 'rgb(255, 0, 0)', name: '비오톱 유형평가도', type: 'biotopeTypes' }
		];

		showLegend(legendItem, 'analysis');
	}

</script>

<body>
	<div role="tabpanel" class="areaSearch full" id="tab-02" style="overflow: auto;">	
		<div id="basic">
			<h2 class="tit">개발행위 가능분석</h2>
			<h3 class="tit">입력 데이터 영역 그리기</h3>
		</div>
	</div>

	<div class="breakLine"></div>
	<div class="disFlex smBtnWrap" style="padding: 1.6rem">
		<button type="button" class="primaryLine" onclick="initAnalService()">초기화</button>
		<button type="button" class="primarySearch" onclick="doAnalysis()">분석</button>
	</div>

	<form id="GISinfoResultForm" name="GISinfoResultForm">
		<input type="hidden" name="geom[]">
	</form>
</body>
<script type="text/javascript" src="<c:url value='/resources/js/map/draw.js'/>"></script>
</html>