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
	<script type="text/javascript">
		var contextPath = '${contextPath}';
		var componentData = [];
		var resultLyrColKorInfo = [];

		$(document).ready(function () {
			$('#sub_content').show();
			initAnalService();

			componentData = [
				{
					type: 'search',
					inputType: 'input_Lyr',
					title: '사업대상지',
					input: 'field',
					features: 'input_features',
				},
				{ type: 'searchOverlap' },
			];

			doRenderSearchComp(componentData);
		});

		function doAnalysis() {
			doBeforeAnalysis();
			initAnalService();

			const inputLyr = $('#input_features').find('.selected').attr('table_nm') + '.' +
				$('#input_features').find('.selected').attr('layer_tp_nm');
			// 분석 영역
			// const analyArea = $('#analyType').val();
			const overlayLyrs = $('#output_select li')
				.map(function () {
					return $(this).attr('value');
				})
				.get()
				.join(',');

			if (inputLyr && overlayLyrs) {
				$.ajax({
					type: 'POST',
					async: true,
					url: '<%=RequestMappingConstants.WEB_ANAL_RELATED_BIZ%>',
					dataType: 'json',
					data: {
						inputLyr, // string
						// analyArea, // string
						overlayLyrs, // string
					},
					error: function (response, status, xhr) {
						if (xhr.status == '404') {
							alert('분석에 실패 했습니다.');
						}
					},
					success: function (data, status, xhr) {
						try {
							initAnalService();

							let isNullResult = true;
							const lyrIdList = $('#output_select li').map(function () {
								return $(this).attr('value').split('.')[1];
							}).get();
							
							lyrIdList.forEach((id) => {
								if(data.data[id]) isNullResult = false;
							})
							
							if(data.result === false || isNullResult){
								alert('분석 결과가 존재하지 않습니다. 조건을 변경해주세요');
								return;
							}

							// 전체 피쳐 데이터와 그렇지 않은 중첩레이어의 데이터 수
							const { entire: totalDataNum, matched: featureData } = splitObjectByKey(data.data, 'totalDataNum');
							resultModal(featureData, totalDataNum);

							const wkt = new ol.format.WKT();
							const relationGroupLyr = new ol.layer.Group({ title: 'analysis', serviceNm: '관련사업 입지분석' });
							
							Object.entries(featureData).forEach(([layerNm, featureData], idx) => {
								if (!featureData) return;
								
								const source = new ol.source.Vector();
								const features_4326 = new ol.format.GeoJSON().readFeatures(featureData);
								const feature_3857 = features_4326.map(f => new ol.Feature(
										f.getGeometry().transform('EPSG:4326', 'EPSG:3857')))

								source.addFeatures(feature_3857);

								const vectorLayer = new ol.layer.Vector({ title: getLayerKorNmItem().lyrNmArr[idx], source });
								relationGroupLyr.getLayers().push(vectorLayer);
							});

							geoMap.addLayer(relationGroupLyr);
							resultLegend(relationGroupLyr);

							var exportKey = xhr.getResponseHeader('export_key');
							analLayer(contextPath, exportKey)

							const featureCoord = relationGroupLyr.getLayers().getArray()[0]
								.getSource().getFeatures()[0].getGeometry().getFirstCoordinate();

							geoMap.getView().setCenter(featureCoord);
							
						} catch (error) {
							debugger;
							console.log(error);
							doAfterAnalysis();
						}
					},
					complete: function (xhr, status) {
						doAfterAnalysis();
					},
				});
			} else {
				alert('값을 입력해주세요.');
				doAfterAnalysis();
			}
		}

		function splitObjectByKey(obj, searchString) {
			const entire = {};
			const matched = {};

			Object.keys(obj).forEach((key) => {
				if (key.includes(searchString)) {
					entire[key] = obj[key];
				} else {
					matched[key] = obj[key];
				}
			});

			return { entire, matched };
		}

		function ChartGraph(featureData, dataNum) {
			let graphChart = [];
			$('#pieChart').append('<select style="padding-right: 30px;"></select>');

			Object.entries(featureData).forEach(([lyrNm, dataStr], idx) => {
				if (dataStr) {
					const reader = new ol.format.GeoJSON();
					const featureData = JSON.parse(dataStr).features;

					const calculatePercentage = (gubunCount, total) => {
					  const percentage = (gubunCount / total) * 100;
					  return percentage.toFixed(2); // 소수점 2자리까지 반환
					};

					const totalSum = dataNum[lyrNm + '_totalDataNum'];

					const gubunPercentage = calculatePercentage(featureData.length, totalSum); // 퍼센티지 계산
					const gubunList = [gubunPercentage, 100 - gubunPercentage];

					const graphData = {
					  data: gubunList, // 퍼센티지 데이터 배열
					  title: getLayerKorNmItem().lyrNmArr[idx], // 레이어 이름
					  color: [ '#d1e5f0','#d6604d' ], // 색상 배열
					  labels: [ getLayerKorNmItem().lyrNmArr[idx] + ' 중첩 지역', getLayerKorNmItem().lyrNmArr[idx] + ' 예외 지역' ] // dataNum의 key 값들을 라벨로 사용
					};

					$('#pieChart select').append(
						'<option value=' + lyrNm + '>' + getLayerKorNmItem().lyrNmArr[idx] + '</option>'
					);

					graphChart.push(graphData);
				}
			});

			Graph(graphChart[0]);
			$('#pieChart select').on('change', function (e) {
				Graph(graphChart[getLayerKorNmItem().lyrIdArr.indexOf(e.currentTarget.value)]);
			});
		}

		function Table(data) {
			const theadElement = document.getElementById('dataResultTableHd');
			const tbodyElement = document.getElementById('dataResultTableBd');

			// Thead 생성
			const theadRowElement = document.createElement('tr');
			const gubunHeader = document.createElement('th');
			const countHeader = document.createElement('th');

			gubunHeader.textContent = '구분';
			countHeader.textContent = '시설 수';

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

			// 데이터 추가
			Object.entries(data).forEach(([lyrNm, data], idx) => {
				if (data) addRow(getLayerKorNmItem().lyrNmArr[idx], JSON.parse(data).features.length);
			});
		}

		let totalCount;
		function List(data) {
			// Multi 테이블
			const tableContElement = document.getElementById('analListTableCont');
			$('#analListTableCont').empty();

			// TODO: lyrNm 테이블 이름으로 추가
			// 전체 테이브 건수 기입
			const totalCount = Object.values(data)
				.map((v) => (v ? JSON.parse(v).features.length : null))
				.reduce((a, c) => a + c, 0);


			$("span[name*='search_list_count']").text(totalCount);

			Object.entries(data).forEach(([lyrNm, featureDataStr], idx) => {
				const str =`
					<div style="height: 30px;">
						<span>` + getLayerKorNmItem().lyrNmArr[idx] + ` 레이어</span>
					</div>
					<table class="table table-custom table-cen table-num text-center" width="100%">
						<thead id="resultThead` + idx + `"></thead>
						<tbody id="resultTbody` + idx + `"></tbody>
					</table>
				`;

				$('#analListTableCont').append(str);

				const theadElement = document.getElementById('resultThead' + idx);
				const tbodyElement = document.getElementById('resultTbody' + idx);
				const headerRow = document.createElement('tr');

				if (
					!featureDataStr ||
					!JSON.parse(featureDataStr)['features'].map((f) => f.properties)[0]
				) {
					const th = document.createElement('th');
					th.innerHTML = '데이터가 존재하지 않습니다.';
					headerRow.appendChild(th);
					theadElement.appendChild(headerRow);
					return;
				}

				const featureData = JSON.parse(featureDataStr)['features'];
				const featureProp = featureData.map((f) => f.properties);

				Object.keys(featureProp[0]).forEach((key) => {
					if (
						key !== 'the_geom' &&
						key !== 'sub_features' &&
						key !== 'shortestPath' &&
						!headerRow.innerHTML.includes(key)
					) {
						const th = document.createElement('th');
						th.innerHTML = key;
						headerRow.appendChild(th);
					}
				});
				theadElement.appendChild(headerRow);

				// tbody 생성
				featureProp.forEach((item) => {
					const row = document.createElement('tr');
					headerRow.querySelectorAll('th').forEach((th) => {
						const title = th.innerHTML;
						const td = document.createElement('td');
						td.innerHTML = item[title] || ''; // 해당 값이 없으면 빈 문자열
						row.appendChild(td);
					});

					tbodyElement.appendChild(row);
				});
				// 모든 항목의 title을 헤더에 추가
			});
		}

		function resultModal(featureData, dataNum) {
			modalData = [
				{ type: 'btnCnt' },
				{ type: 'graph' },
				{ type: 'table' },
				{ type: 'list' },
			];
			doRenderModal(modalData);
			showModalBtn();

			ChartGraph(featureData, dataNum);
			Table(featureData);
			List(featureData);
		}

		function switchSelectOption(e, type) {
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
					{ type: 'searchOverlap' },
				];
			}
			// else if (type == '주소검색') {
			// 	componentData = [
			// 		{ type: 'addr' },
			// 		{ type: 'searchOverlap' },
			// 	];
			// }
			doRenderSearchComp(componentData);
		}

		function resultLegend(groupLyr) {
			const overLyrList = getLayerKorNmItem().lyrNmArr

			const legendItemList = overLyrList
				.map((v) => ({ color: getRandomColor(), name: v }))
				.map((item) => {
					const dataLyr = groupLyr.getLayers().getArray()
						.filter((lyr) => lyr.get('title') === item.name)[0];

					if (dataLyr) {
						const style = new ol.style.Style({
							fill: new ol.style.Fill({ color: item.color }),
							stroke: new ol.style.Stroke({
								color: item.color,
								width: 1
							}),
							image: new ol.style.Circle({
					        	fill: new ol.style.Fill({ color: item.color }),
					            stroke: new ol.style.Stroke({ 
					            	color: item.color, 
					            	width: 1
					             }),
				           		radius: 8,
				            })
						});
						dataLyr.setStyle(style);
					}
				
					return item;
				});


			showLegend(legendItemList);
		}

		function getRandomColor() {
			var r = Math.floor(Math.random() * 256);
			var g = Math.floor(Math.random() * 256);
			var b = Math.floor(Math.random() * 256);

			return 'rgb(' + r + ', ' + g + ', ' + b + ')';
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
				<h2 class="tit">관련사업 입지분석</h2>
				<h3 class="tit">입력 데이터 유형</h3>
				<div class="selectWrap">
					<div class="disFlex">
						<button
							type="button"
							id="business"
							size="10"
							class="form-control input-ib network selected"
							onclick="switchSelectOption(event, '사업대상지')"
						>
							사업대상지
						</button>
						
					</div>
				</div>
			</div>
		</div>

		<div class="breakLine"></div>
		<div class="disFlex smBtnWrap" style="padding: 1.6rem">
			<button type="button" class="primaryLine" onclick="initAnalService()">
				초기화
			</button>
			<button type="button" class="primarySearch" onclick="doAnalysis()">
				분석
			</button>
		</div>

		<form id="GISinfoResultForm" name="GISinfoResultForm">
			<input type="hidden" name="geom[]" />
		</form>
	</body>
</html>
