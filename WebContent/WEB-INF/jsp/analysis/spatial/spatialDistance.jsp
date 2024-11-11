<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core"%> <%@ taglib prefix="sf"
uri="http://www.springframework.org/tags/form"%> <%@ taglib prefix="ui"
uri="http://egovframework.gov/ctl/ui"%> <%@ taglib prefix="fn"
uri="http://java.sun.com/jsp/jstl/functions"%> <%@ taglib prefix="spring"
uri="http://www.springframework.org/tags"%> <%@ page
import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
	<style>
		#analListTableCont .table-custom > tbody > tr > td:last-child {
			border-right: 1px solid #ddd !important;
		}
	</style>

	<script type="text/javascript">
		var contextPath = '${contextPath}';
		let btns = document.querySelectorAll('.faq__question');
		var componentData = [];

		$(document).ready(function () {
			$('#sub_content').show();

			componentData = [
				{
					type: 'search',
					inputType: 'input_Lyr',
					title: '사업대상지',
					input: 'field',
					features: 'input_features',
					fieldSelect: true,
				},
				{
					type: 'fieldSelect',
					title: '시설명 필드선택',
					id: 'optionContainer',
				},
				{ type: 'sggSelect', title: '자치구 선택', id: 'sggSelect' },
				{
					type: 'overlapLayer',
					title: '반경거리',
					id: 'touchBoundaryDistance',
					display: true,
				},
			];

			doRenderSearchComp(componentData);
		});

		function switchSelectOption(type) {
			$(e.target).parent().find('.selected').removeClass('selected');
			$(e.target).addClass('selected');

			if (type == '사업대상지') {
				componentData = [
					{
						type: 'search',
						inputType: 'input_Lyr',
						title: '사업대상지',
						input: 'field',
						features: 'input_features',
					},
					{ type: 'sggSelect', title: '자치구 선택', id: 'sggSelect' },
					{ type: 'sggSelect', title: '분석방법 선택', id: 'sggSelect' },
					{
						type: 'overlapLayer',
						title: '반경거리',
						id: 'touchBoundaryDistance',
						display: true,
					},
				];
			} else if (type == '주소검색') {
				componentData = [
					{ type: 'addr' },
					{
						type: 'overlapLayer',
						title: '반경거리',
						id: 'touchBoundaryDistance',
						display: true,
					},
				];
			}

			doRenderSearchComp(componentData);
		}

		function createIntersectTableData(data) {
			const nameField = $('#optionContainer').find('select').val();

			const outputNameArr = Object.keys(data[0]).map(
				(k) => data[0][k].properties[nameField]
			);

			const totalNum = data[2].total
			const totalUniv = data[2].univ;
			const totalSubway = data[2].subway_statn

			return {
				outputNameArr,
				totalNum,
				totalUniv,
				totalSubway,
			};
		}

		function createIntersectList(data) {
			// 역이름, 선택한 시설 목록, 선택한 시설 분석결과가 몇개인지, 분석결과의 필드를 가지고 데이터를 뿌려야함
			const totalSubwayCount = Object.keys(data[0]).length;
			const searchListCount = document.getElementById('search_list_count');
			searchListCount.innerHTML = totalSubwayCount;

			const theadElement = document.getElementById('resultThead');
			const tBodyElement = document.getElementById('resultTbody');
			const theadRowElement = document.createElement('tr');

			const theadColumnElement1 = document.createElement('th');
			theadColumnElement1.innerHTML = '사업대상지';
			theadRowElement.append(theadColumnElement1);
			const theadColumnElement2 = document.createElement('th');
			theadColumnElement2.innerHTML = '시설명';
			theadRowElement.append(theadColumnElement2);
			const theadColumnElement3 = document.createElement('th');
			theadColumnElement3.innerHTML = '시설정보';
			theadRowElement.append(theadColumnElement3);

			const analysisResult = data[1];
			let columnCount = 0;

			const nameField = $('#optionContainer').find('select').val();

			Object.keys(analysisResult).forEach((key, index) => {
				const outputName = data[0][key].properties[nameField];
				const outputNameColumn = document.createElement('td'); // 가지고 있는 시설 총 개수 구해야함
				outputNameColumn.innerHTML = outputName;

				let totalCount;
				totalCount = Object.keys(analysisResult[key]).reduce((acc, cur) => {
					return acc + analysisResult[key][cur].length;
				}, 0);
				outputNameColumn.setAttribute(
					'rowspan',
					totalCount + Object.keys(analysisResult[key]).length
				);

				Object.keys(analysisResult[key]).forEach((k, index) => {
					// univ subway

					const proper = analysisResult[key][k].map((v) => v.properties);

					let cCount = 0;
					if (proper.length > 0) {
						cCount = Object.keys(proper[0]).length;
					}

					if (cCount > columnCount) {
						columnCount = cCount;
					}

					const target = analysisResult[key][k];

					const layerNameColumn = document.createElement('td'); // 가지고 있는 시설별 개수 구해야함
					layerNameColumn.innerHTML = layerNameMatch[k];
					layerNameColumn.setAttribute('rowspan', target.length + 1);

					const headerRowElement = document.createElement('tr');
					if (index === 0) {
						headerRowElement.append(outputNameColumn);
					}
					headerRowElement.append(layerNameColumn);
					Object.keys(target[0].properties).forEach((p) => {
						const temp = document.createElement('td');
						temp.innerHTML = p;
						headerRowElement.append(temp);
					});
					tBodyElement.append(headerRowElement);

					target.forEach((row, idx) => {
						const rowElement = document.createElement('tr');

						Object.keys(row.properties).forEach((pKey) => {
							const temp = document.createElement('td');
							temp.innerHTML = row.properties[pKey];
							rowElement.append(temp);
						});
						tBodyElement.append(rowElement);
					});
				});
			});

			theadColumnElement3.setAttribute('colspan', columnCount);
			theadRowElement.append(theadColumnElement3);
			theadElement.append(theadRowElement);
		}

		function createIntersectTable(targetText, data) {
			// data
			const {
				outputNameArr,
				totalNum,
				totalUniv,
				totalSubway
			} = data;

			const theadElement = document.getElementById('dataResultTableHd');
			const tbodyElement = document.getElementById('dataResultTableBd');
			const theadRowElement = document.createElement('tr');
			const theadColumnElement1 = document.createElement('th');

			const tbodyTotalRowElement = document.createElement('tr');
			const tBodyTotalColumnElement1 = document.createElement('td');
			tBodyTotalColumnElement1.innerHTML = '총계';
			tbodyTotalRowElement.append(tBodyTotalColumnElement1);

			// 선택한 시설에 따른 매칭 객체 생성
			const match = {
				'대학 캠퍼스': totalUniv,
				'지하철': totalSubway,
			};

			// 해당 문자열이 targetText에 내포되있는지
			['대학 캠퍼스', '지하철'].forEach((str) => {
				if (targetText.includes(str)) {
					// 선택됐다는 의미, 값을 매칭시켜서 td생성
					const temp = document.createElement('td');
					temp.innerHTML = match[str];
					tbodyTotalRowElement.append(temp);
				}
			});

			tbodyElement.append(tbodyTotalRowElement);

			// 총 합계
			const totalCountColumn = document.createElement('td');
			totalCountColumn.innerHTML = totalNum;
			tbodyTotalRowElement.append(totalCountColumn);

			theadRowElement.append(theadColumnElement1);
			if (targetText.find((v) => v === '대학 캠퍼스')) {
				const theadColumnElement2 = document.createElement('th');
				theadColumnElement2.innerHTML = `<b>대학 캠퍼스</b>`;
				theadRowElement.append(theadColumnElement2);
			}
			if (targetText.find((v) => v === '지하철')) {
				const theadColumnElement4 = document.createElement('th');
				theadColumnElement4.innerHTML = `<b>지하철</b>`;
				theadRowElement.append(theadColumnElement4);
			}

			const theadColumnElement5 = document.createElement('th');
			theadColumnElement5.innerHTML = '사업대상지 (계)';
			theadRowElement.append(theadColumnElement5);

			theadElement.append(theadRowElement);
		}

		function resultLegend(labels, colors) {
			let legend = [];
			let colorMatch;
			let legendName;
			labels.forEach((obj, idx) => {
				colorMatch = colors[idx];
				legendName = obj;

				if (colorMatch && legendName) {
					let legendItem = { color: colorMatch, name: legendName };
					legend.push(legendItem);
				}
			});

			if (legend.length > 0) {
				showLegend(legend);
			}
		}

		const postData = {};
		function getData(
			path,
			inputSchema,
			inputFeatures,
			landsysGis,
			sggCd,
			intersectTargetText
		) {
			const targetList = {
				target: [],
			};
			const univCheckbox = document.getElementById('univCheckbox');
			const subwayCheckbox = document.getElementById('subwayCheckbox');
			const univInput = document.getElementById(
				'univInput_touchBoundaryDistance'
			);
			const subwayInput = document.getElementById(
				'subwayInput_touchBoundaryDistance'
			);

			let blank;
			if (univCheckbox.checked) {
				const obj1 = {
					schema: landsysGis,
					layer: 'univ',
					distance: Number(univInput.value),
				};
				blank = univInput.value === '';
				if (blank) {
					alert('거리를 입력해주세요.');
					doAfterAnalysis();
					return;
				}
				if (Number(univInput.value) === 0) {
					alert('거리값은 0보다 큰값을 입력해주세요.');
					return;
				}

				targetList.target.push(obj1);

				intersectTargetText.push(targetTextMatch.univ);
			}

			if (subwayCheckbox.checked) {
				const obj3 = {
					schema: landsysGis,
					layer: 'subway_statn',
					distance: Number(subwayInput.value),
				};
				if (Number(subwayInput.value) === 0) {
					alert('거리값은 0보다 큰값을 입력해주세요.');
					return;
				}
				blank = subwayInput.value === '';
				if (blank) {
					alert('거리를 입력해주세요.');
					doAfterAnalysis();
					return;
				}

				targetList.target.push(obj3);

				intersectTargetText.push(targetTextMatch.subway_statn);
			}

			postData.type = 'intersect';
			postData.inputSchema = inputSchema; // 스키마 이름
			postData.inputFeatures = inputFeatures; // 레이어 이름
			postData.targetListStr = JSON.stringify(targetList);
			postData.sggCd = sggCd;
		}

		function ChartGraph(feature, labels, colors, percents) {
			let graphChart = [];
			let selectElement = $('<select style="padding-right: 30px;"></select>');
			$('#pieChart').append(selectElement);

			const totalNum = feature.total;
			const univNum = feature.univ;
			const subwayNum = feature.subway_statn;

			const chartLabelList = [];
			if(univNum) chartLabelList.push(univNum);
			if(subwayNum) chartLabelList.push(subwayNum);

			// labels와 colors의 인덱스를 맞춰서 사용
			chartLabelList.forEach((num, idx) => {

					const calculatePercentage = (gubunCount, total) => {
							const percentage = (gubunCount / total) * 100;
							return percentage.toFixed(2); // 소수점 2자리까지 반환
					};

					const gubunPercentage = calculatePercentage(num, totalNum); // 퍼센티지 계산
					const gubunList = [gubunPercentage, 100 - gubunPercentage];

					const tit = labels[idx]; // labels에서 타이틀 가져오기
					const color = colors[idx]; // labels의 순서에 맞는 색상 가져오기

					const graphData = {
						data: gubunList, // 퍼센티지 데이터 배열
						title: tit,
						color: [color, '#E0E0E0'], // labels에 맞는 색상 배열
						labels: [tit + ' 중첩 지역', tit + ' 예외 지역'] // dataNum의 key 값들을 라벨로 사용
					};

					$('#pieChart select').append(
							'<option value=' + tit + '>' + tit + '</option>'
					);

					graphChart.push(graphData);
			});

			// 초기 그래프 그리기
			Graph(graphChart[0]);

			// 선택 요소 변경 시 그래프 업데이트
			$('#pieChart select').on('change', function (e) {
					const selectedLabel = this.value;
					const index = labels.indexOf(selectedLabel); // labels와 색상을 맞춰 인덱스를 가져옴
					
					if (index !== -1) {
							Graph(graphChart[index]); // 선택한 인덱스에 맞는 그래프 표시
					}
			});
		}

		function onClickAnalysis() {
			doBeforeAnalysis();
			initAnalService();

			const path = '<%=RequestMappingConstants.WEB_ANAL_BUFFER_BIZ%>';
			const inputFeatures = $('#input_features')
				.find('.selected')
				.attr('layer_tp_nm');
			const inputSchema = $('#input_features')
				.find('.selected')
				.attr('table_nm');
			const landsysGis = 'landsys_gis';
			const sggCd = $('#sggSelect').val();

			const selectTargetFeatures = $('#bufferSpace .selected');
			let intersectTargetText = [];

			getData(
				path,
				inputSchema,
				inputFeatures,
				landsysGis,
				sggCd,
				intersectTargetText
			);

			$.ajax({
				url: path,
				type: 'POST',
				contentType: 'application/x-www-form-urlencoded', // 데이터 형식
				data: postData,
				success: function (res, status, xhr) {
					try {
						const colors = ['#0066ff', '#ff0066', '#6600ff'];
						const labels = [];
						let percents = [];

						const dataCheck = res.result[2]['univ'] || res.result[2]['subway_statn'];
						if ($.isEmptyObject(res.result[0]) || !dataCheck) {
							alert('분석 결과가 존재하지 않습니다. 조건을 변경해주세요');
							return;
						}

						const intersectLayer = geoMap
							.getLayers()
							.getArray()
							.find((layer) => layer.values_.title === 'analysis');
						if (intersectLayer) {
							geoMap.removeLayer(intersectLayer);
						}

						document.getElementById('loading_area').style.display = 'none';
						document.getElementById('content_area').style.display = 'block';

						const bufferSource = new ol.source.Vector();
						const resultSource = new ol.source.Vector();

						const responseData = res.result;
						responseData.forEach((data) => {
							const totalData = [];

							Object.keys(data).forEach((key) => {
								if (data[key].hasOwnProperty('geometry')) {
									const geojson = data[key];
									bufferSource.addFeature(
										new ol.format.GeoJSON().readFeature(geojson, {
											dataProjection: 'EPSG:4326',
											featureProjection: 'EPSG:3857',
										})
									);
								} else {
									Object.keys(data[key]).forEach((k) => {
										// 차트 라벨 생성
										if (labels.length < Object.keys(data[key]).length) {
											labels.push(layerNameMatch[k]);
										}

										data[key][k].forEach((geojson) => {
											bufferSource.addFeature(
												new ol.format.GeoJSON().readFeature(geojson, {
													dataProjection: 'EPSG:4326',
													featureProjection: 'EPSG:3857',
												})
											);
										});
									});
								}
							});
						});

						const bufferLayer = new ol.layer.Vector({
							title: 'analysis', // ds_intersect
							source: bufferSource,
							serviceNm: '반경거리중첩분석',
							style: function (feature, resolution) {
								let style;
								if (feature.values_.hasOwnProperty('buf_dist')) {
									// 반경거리
									style = [
										new ol.style.Style({
											fill: new ol.style.Fill({
												color: 'rgba(255, 255, 255, 0)',
											}),
											stroke: new ol.style.Stroke({
												color: '#E6ADAD',
												width: 2,
											}),
										}),
									];
								} else {
									// 대상
									style = [
										new ol.style.Style({
											fill: new ol.style.Fill({ color: 'rgba(1,44,44,0.6)' }),
											stroke: new ol.style.Stroke({
												color: '#0066ff',
												width: 2,
											}),
											image: new ol.style.Circle({
												fill: new ol.style.Fill({
													color: 'rgb(1,44,44)',
												}),
												stroke: new ol.style.Stroke({
													color: '#00000',
													width: 1.2,
												}),
												radius: 5,
											}),
										}),
									];
								}

								return style;
							},
						});

						geoMap.getView().setCenter(bufferLayer.getSource().getExtent());
						var exportKey = xhr.getResponseHeader('export_key');
						geoMap.addLayer(bufferLayer);
						analLayer(contextPath, exportKey);

						const modalData = [
							{ type: 'btnCnt' },
							{ type: 'list' },
							{ type: 'graph' },
							{ type: 'table' },
						];
						doRenderModal(modalData);
						showModalBtn();

						const targetText = intersectTargetText;
						let resultDistance = [];
						const _res = res.result;

						const intersectTableData = createIntersectTableData(_res);
						createIntersectTable(targetText, intersectTableData);
						createIntersectList(_res);
						ChartGraph(res.result[2], labels, colors, percents);

						resultLegend(labels, colors);
					} catch (error) {
						console.log(error);
						alert('분석에 실패 했습니다.');
						doAfterAnalysis();
					}
				},
				error: function (error) {
					console.log('Error:', error);
				},
				complete: function (xhr, status) {
					doAfterAnalysis();
				},
			});
		}
	</script>

	<body>
		<div
			role="tabpanel"
			class="areaSearch full"
			id="tab-02"
			style="overflow: auto"
		>
			<div id="basic">
				<h2 class="tit">반경거리 중첩 분석</h2>
			</div>

			<div class="selectWrap">
				<div class="disFlex" id="optionContainer">
					<select class="form-control chosen">
						<option value="" onclick=""></option>
					</select>
				</div>
			</div>
		</div>

		<div class="breakLine"></div>
		<div class="disFlex smBtnWrap" style="padding: 1.6rem">
			<button type="button" class="primaryLine" onclick="initAnalService()">
				초기화
			</button>
			<button type="button" class="primarySearch" onclick="onClickAnalysis()">
				분석
			</button>
		</div>

		<form id="GISinfoResultForm" name="GISinfoResultForm">
			<input type="hidden" name="geom[]" />
		</form>
	</body>
</html>
