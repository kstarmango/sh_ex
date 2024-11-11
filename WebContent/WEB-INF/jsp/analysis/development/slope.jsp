<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page
	import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<script type="text/javascript">
	var contextPath = '${contextPath}';
	var componentData = [];

	$(document).ready(function() {
		$('#sub_content').show();
		initAnalService();
	
		componentData = [{ type: 'drawTool' }];
		doRenderSearchComp(componentData);
	})
	
	function doAnalysis()	{
		doBeforeAnalysis();
		resetLegend();

		try {
			var wkt = '';
			const wktFormat = new ol.format.WKT();
			const slopeType = 'DEGREE'
			const zFactor = 1.0;
			var width = $('#geomap')[0].clientWidth;
			var height = $('#geomap')[0].clientHeight;
			var imageExtent = null;

			const feature = getTargetVectorSource().getFeatures()[0];
			wkt = wktFormat.writeFeature(feature);
			imageExtent = feature.getGeometry().getExtent();

			resultMap(wkt, zFactor, width, height, imageExtent);
			resultModal(wkt, zFactor);
			
		} catch (error) {
			console.log(error)
			alert('분석에 실패 했습니다.');
			doAfterAnalysis();
		}
	}
	
	function resultModal(wkt, zFactor) {
		if(wkt && wkt !== '' && zFactor) {
			$.ajax({
				type: 'POST',
				async: true,
				url: '<%=RequestMappingConstants.WEB_ANAL_DEV_SLOPE_RESULT%>',
				dataType: 'json',
				data: {
					inputFeature: wkt,
					zFactor
				},
				error: function (response, status, xhr) {
					if (xhr.status == '404') {
						alert('분석에 실패 했습니다.');
					} else alert('분석 결과가 존재하지 않습니다. 조건을 변경해주세요');
					doAfterAnalysis();
				},
				success: function (data) {
					if (!data || !data.result) {
						alert('분석 결과가 존재하지 않습니다. 조건을 변경해주세요');
						doAfterAnalysis();
						return;
					}
	
					modalData = [
						{ type: 'btnCnt' },
						{ type: 'graph' },
						{ type: 'table' },
						{ type: 'list' },
					];
	
					doRenderModal(modalData);
					showModalBtn();
	
					ChartGraph(data.result);
					Table(data.result);
					List(data.result);
	
					resultLegend(data.result);
					doAfterAnalysis();
				}
			});
		} else {
			alert('값을 입력해주세요.');
			doAfterAnalysis();
		}
	}

	function resultLegend(data){
		let legendItem = [
			{ color: 'rgb(50,136,189)', name: '10°' },
			{ color: 'rgb(102,194,165)', name: '20°' },
			{ color: 'rgb(171,221,164)', name: '30°' },
			{ color: 'rgb(230,245,152)', name: '40°' },
			{ color: 'rgb(255,255,191)', name: '50°' },
			{ color: 'rgb(254,224,139)', name: '60°' },
			{ color: 'rgb(253,174,97)', name: '70°' },
			{ color: 'rgb(244,109,67)', name: '80°' },
			{ color: 'rgb(213,62,79)', name: '90°' }
		];  

		showLegend(legendItem);
	}
	
	function resultMap(wkt, zFactor, width, height, imageExtent) {
		try {
			var slopeUrl = '<%=RequestMappingConstants.WEB_ANAL_DEV_SLOPE%>?'
					+ 'inputFeature=' + encodeURIComponent(wkt)  
					+ '&zFactor=' + encodeURIComponent(zFactor)
					+ '&width=' + encodeURIComponent(width) 
					+ '&height=' +  encodeURIComponent(height);

			var slopeLayer = new ol.layer.Image({
				title: 'analysis', //slope_layer,
				source: new ol.source.ImageStatic({
					url: slopeUrl,
					imageExtent, 
					projection: 'EPSG:3857', 
				}),
				serviceNm: '경사도 분석',
				opacity: 0.7
			});
	
			geoMap.addLayer(slopeLayer);
			
			$.ajax({
				type: 'GET',
				url: slopeUrl,
				error: function (response, status, xhr) {
					if (xhr.status == '404') {
						alert('SHP 파일 다운로드에 실패했습니다.');
					}
				},
				success: function (data, status, xhr) {
					var exportKey = xhr.getResponseHeader('export_key');
					analLayer(contextPath, exportKey);
				}
			})

			geoMap.getView().fit(imageExtent, { size: geoMap.getSize() });
	
			const interactions = geoMap.getInteractions().getArray();
			for(let i = interactions.length - 1; i >= 0; i--){
				if(interactions[i] instanceof ol.interaction.Modify || interactions[i] instanceof ol.interaction.Translate){
					geoMap.removeInteraction(interactions[i]);
				}
			};
		} catch(e) {
			doAfterAnalysis();
		}
	}

	let currentGubun;
	const gubunCount = {};

	function ChartGraph(data) {
		const dataList = data.result.histogramItems;		

		// 백분율 변환 함수
		const calculatePercentage = (gubunCount) => {
			const frequencyList = dataList.map(v => v.frequency);
			const total = frequencyList.reduce((sum, count) => sum + count)

			// 백분율 계산하여 배열로 변환
			return frequencyList.map((val) => {
				const percentage = (val / total) * 100;
				return percentage.toFixed();
			});
		};
		
		const colorLabelList = [
			'rgb(50,136,189)',
			'rgb(102,194,165)',
			'rgb(171,221,164)',
			'rgb(230,245,152)',
			'rgb(255,255,191)',
			'rgb(254,224,139)',
			'rgb(253,174,97)',
			'rgb(244,109,67)',
			'rgb(213,62,79)'
		];

		const gubunPercent = calculatePercentage(dataList);
		Graph({
			data: gubunPercent,
			title: '경사도 분포',
			color: colorLabelList,
			labels: dataList.map(v => v.value)
		});
	}

	function Table(data) {
		const theadElement = document.getElementById('dataResultTableHd');
		const tbodyElement = document.getElementById('dataResultTableBd');

		const theadRowElement = document.createElement('tr');
		const gubunHeader = document.createElement('th');
		const countHeader = document.createElement('th');

		gubunHeader.textContent = '구분';
		countHeader.textContent = '경사도';

		theadRowElement.appendChild(gubunHeader);
		theadRowElement.appendChild(countHeader);
		theadElement.appendChild(theadRowElement);

		// 데이터 추가 함수
		const addRow = (gubun, count) => {
			const row = document.createElement('tr');
			const gubunCell = document.createElement('td');
			const countCell = document.createElement('td');

			gubunCell.textContent = gubun;
			countCell.textContent = count;

			row.appendChild(gubunCell);
			row.appendChild(countCell);
			tbodyElement.appendChild(row);
		};

		addRow('최대 경사도', data.max.toFixed(2));
		addRow('최소 경사도', data.min);
	}

	let totalCount;
	
	function List(data) {
		const dataList = data.result.histogramItems;

		const theadElement = document.getElementById('resultThead');
		const tbodyElement = document.getElementById('resultTbody');

		// thead와 tbody 초기화
		theadElement.innerHTML = '';
		tbodyElement.innerHTML = '';

		// totalCount = countObjects(dataList);
		// $("span[name*='search_list_count']").text(totalCount);
		$("span[name*='search_list_count']").parents().eq(1).hide();

		// 헤더 생성
		const headerRow = document.createElement('tr');
		// 모든 항목의 title을 헤더에 추가
		["경사도", "면적 (m²)"].forEach((v) => {
			const th = document.createElement('th');
			th.innerHTML = v;
			headerRow.appendChild(th);
		})
		theadElement.appendChild(headerRow);

		// tbody 생성
		dataList.forEach((item) => {
			const row = document.createElement('tr');

			const td = document.createElement('td');
			td.innerHTML = item['value'] || ''; 
					row.appendChild(td);
			const td_ = document.createElement('td');
			td_.innerHTML = covertLocaleString(item['frequency']) || ''; 
			row.appendChild(td_);

				tbodyElement.appendChild(row);
			});
		}

</script>

<body>
	<div role="tabpanel" class="areaSearch full" id="tab-02"
		style="overflow: auto;">
		<div id="basic">
			<h2 class="tit">경사도 분석</h2>
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
<script type="text/javascript"
	src="<c:url value='/resources/js/map/draw.js'/>"></script>
</html>