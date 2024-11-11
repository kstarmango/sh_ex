<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page
	import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>
<%@ page import="egovframework.mango.config.SHResource"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<script type="text/javascript">
		var contextPath = '${contextPath}';
		var shexPath = "<%=SHResource.getValue("sh.server.schema")%>" + "://" + "<%=SHResource.getValue("sh.server.url")%>";
		let btns = document.querySelectorAll('.faq__question');
		var componentData = [];

		const search = {
			type: 'search',
			title: '사업대상지',
			input: 'field',
			inputType: 'input_Lyr',
			features: 'input_features',
			fieldSelect: true
		};

		const network = {
			type: 'button',
			title: '네트워크 기준',
			arr: [
				{ id: 'distanceBtn', name: '거리', className: 'selected' },
				{ id: 'timeBtn', name: '시간' },
			],
		};

		const distanceInput = {
			type: 'distanceInput',
			title: '거리(m)',
			inputType: 'text',
			id: 'walkSpeed',
		};

		const overlapLayer = {
			type: 'overlapLayer',
			title: '네트워크',
		};

		let intersectTargetText = [];
		let intersectFeatureCountList = [];
		let intersectFeatureCount = 0;

		let univInput;
		let roadInput;
		let subwayInput;

		let univCheckbox;
		let subwayCheckbox;

		$(document).ready(function () {
			$('#sub_content').show();

			componentData = [
				search,
				{ type: 'fieldSelect', title: '시설명 필드선택', id: 'optionContainer'},
				{ type: 'sggSelect', title: '자치구 선택', id: 'sggSelect'},
				network,
				{ type: 'overlapLayer', title: '반경거리', id: 'touchBoundaryDistance', display: true },
				{ type: 'overlapLayer', title: '시간', id: 'touchBoundaryWalkMin', display: false },
			];

			doRenderSearchComp(componentData);
		});

		function switchSelectOption(type) {
			if (type == '사업대상지') {
				componentData = [
					search,
					{ type: 'choose', title: '사업대상지' },
					research,
					network,
					distanceInput,
					overlapLayer,
				];
			} else if (type == '주소검색') {
				componentData = [
					addr,
					{ type: 'choose', title: '주소검색' },
					research,
					network,
					distanceInput,
					overlapLayer,
				];
			}
			doRenderSearchComp(componentData);
		};

		function getTargetParams(params) {

			const landsysGis = "landsys_gis";
			const match = {
				"distance": {
					univInput: "univInput_touchBoundaryDistance",
					roadInput: "roadInput_touchBoundaryDistance",
					subwayInput: "subwayInput_touchBoundaryDistance",
					univCheckbox: "univCheckbox",
					subwayCheckbox: "subwayCheckbox"
				},
				"time": {
					univInput: "univInput_touchBoundaryWalkMin",
					roadInput: "roadInput_touchBoundaryWalkMin",
					subwayInput: "subwayInput_touchBoundaryWalkMin",
					univCheckbox: "univTimeCheckbox",
					subwayCheckbox: "subwayTimeCheckbox"
				}
			};
			const paramType = $(".input-ib.selected")[0].value === "distanceBtn" ? "distance" : "time";

			univInput = document.getElementById(match[paramType].univInput);
			roadInput = document.getElementById(match[paramType].roadInput);
			subwayInput = document.getElementById(match[paramType].subwayInput);

			univCheckbox = document.getElementById(match[paramType].univCheckbox);
			subwayCheckbox = document.getElementById(match[paramType].subwayCheckbox);

			const targetList = {
				target: []
			};

			const value = {
				"distance": {
					label: "거리값",
					unit: "m",
					min: 0,
					max: <%=SHResource.getValue("network.distance.max", "2000")%>
				},
				"time": {
					label: "시간",
					unit: "분",
					min: 0,
					max: <%=SHResource.getValue("network.time.max", "30")%>
				}
			};

			const minAlertText = value[paramType].label + "은 " + value[paramType].min + value[paramType].unit + "보다 큰값을 입력해주세요.";
			const maxAlertText = value[paramType].label + "은 " + value[paramType].max + value[paramType].unit + "보다 작은값을 입력해주세요.";

			if(univCheckbox.checked) {
				const obj1 = {
					schema: landsysGis,
					layer: "univ",
					value: Number(univInput.value),
					paramType
				};
				if(Number(univInput.value) === value[paramType].min) {
					alert(minAlertText);
					doAfterAnalysis();
					return;
				} else if(Number(univInput.value) >= value[paramType].max) {
					alert(maxAlertText);
					doAfterAnalysis();
					return;
				};
				targetList.target.push(obj1);

				intersectTargetText.push(targetTextMatch.univ);
			};

			if(subwayCheckbox.checked) {
				const obj3 = {
					schema: landsysGis,
					layer: "subway_statn",
					value: Number(subwayInput.value),
					paramType
				};
				if(Number(subwayInput.value) === value[paramType].min) {
					alert(minAlertText);
					doAfterAnalysis();
					return;
				} else if(Number(subwayInput.value) >= value[paramType].max) {
					alert(maxAlertText);
					doAfterAnalysis();
					return;
				};
				targetList.target.push(obj3);

				intersectTargetText.push(targetTextMatch.subway_statn);
			};

			params.targetListStr = JSON.stringify(targetList);

			if(!univCheckbox.checked && !subwayCheckbox.checked){
				alert('한개 이상의 중첩레이어를 선택해주세요.');
				doAfterAnalysis();
				return;
			};
		};

		function onClickNetwork(e) {
			let labels = [];
			let outputJson = {};

			doBeforeAnalysis();

			const path = "<%=RequestMappingConstants.WEB_ANAL_BUFFER_BIZ%>"
			const inputFeatures = $('#input_features').find('.selected').attr('layer_tp_nm');
			const inputSchema = $('#input_features').find('.selected').attr('table_nm');
	/* 		const isGeometry = $('#input_features').find('.selected').text().split('(').indexOf('GEOMETRY)')

			if(isGeometry !== -1){
				alert('사업대상지 타입이 지오메트리가 아닌지 확인해주십시오.');
				doAfterAnalysis();
			} */

			const sggCd = $('#sggSelect').val();

			const params = {
				type: 'intersect',
				sggCd: sggCd,
				inputSchema: inputSchema,
				inputFeatures: inputFeatures
			};

			getTargetParams(params);
			if(!params.targetListStr) return;
				
			$.ajax({
						type: 'POST',
						async: true,
						url: '<%=RequestMappingConstants.WEB_ANAL_NETWORK_BIZ%>',
						dataType: 'json',
						data: params,
						error: function (response, status, xhr) {
							if (xhr.status == '404') {
								alert('분석에 실패 했습니다.');
							}
						},
						success: function (data, status, xhr) {
							try{
								if (!data.result || (!data.result[3].univ && !data.result[3].subway_statn)) {
									alert('분석 결과가 존재하지 않습니다. 조건을 변경해주세요');
									return;
								}
								
								resetLegend();
								
								const result = data.result;
								resultMap(result, labels, outputJson, xhr);
								resultModal(result, labels, outputJson);

							} catch (error){
								console.log(error)
								alert('분석에 실패 했습니다.');
							} finally {
								doAfterAnalysis();								
							}
						},
						complete: function(xhr, status) {
							doAfterAnalysis();
						}
					});
		}

		function resultModal(result, labels, outputJson) {

			const colors = ['#0066ff', '#ff0066', '#6600ff'];
			const modalData = [{ type: 'btnCnt' }, { type: 'list' }, { type: 'graph' }, { type: 'table' }];
			doRenderModal(modalData);
			showModalBtn();

			createResultGraph(result, labels, colors);
			const intersectTableData = createNetworkTableData(result);
			createNetworkTable(intersectTargetText, intersectTableData);
			createIntersectList(result, 'intersect');

			resultLegend(labels, colors);
		}

		function resultMap(result, labels, outputJson, xhr) {
			const intersectLayer = geoMap.getLayers().getArray().find(layer => layer.values_.title === 'analysis');
			if(intersectLayer) {
				geoMap.removeLayer(intersectLayer);
			}

			const networkSource = new ol.source.Vector();
			const resultSource = new ol.source.Vector();

			for(let rfi of Object.keys(result[0])){
				const df = result[0][rfi];

				const feature = new ol.format.GeoJSON().readFeature(df.geometry, {
					dataProjection: 'EPSG:4326',
					featureProjection: 'EPSG:3857'
				});

				feature.setProperties(df.properties);

				resultSource.addFeature(feature);
			}

			for(let rfi of Object.keys(result[1])){
				const df = result[1][rfi];

				for(let tfi of Object.keys(df)){
					const tf = df[tfi];

					if(labels.indexOf(layerNameMatch[tfi]) === -1){
						labels.push(layerNameMatch[tfi]);
					}
					if (typeof outputJson[tfi] == 'undefined') {
						outputJson[tfi] = 0;
					}
					outputJson[tfi] += tf.length;

					for(let i = 0; i < tf.length; i++){
						const feature = new ol.format.GeoJSON().readFeature(result[2][rfi][tfi][i].geometry, {
							dataProjection: 'EPSG:4326',
							featureProjection: 'EPSG:3857'
						});

						feature.setProperties(tf[i].properties);

						networkSource.addFeature(feature);
					}
				}
			}

			const resultLayer = new ol.layer.Vector({
				title: 'analyNetworkResult',
				serviceNm: '네트워크 중첩분석',
				source: resultSource,
				style: new ol.style.Style({
					fill: new ol.style.Fill({ color : 'rgba(1,44,44,0.6)' }),
					stroke: new ol.style.Stroke({ color: '#0066ff', width: 2 }),
					image: new ol.style.Circle({
						fill: new ol.style.Fill({
							color: 'rgb(1,44,44)'
						}),
						stroke: new ol.style.Stroke({
							color: '#00000',
							width: 1.2
						}),
						radius: 5,
					})
				})
			});
			const networkLayer = new ol.layer.Vector({
				title: 'analyNetwork',
				source: networkSource,
				style: new ol.style.Style({
					fill: new ol.style.Fill({ color : 'rgba(255, 255, 255, 0)' }),
					stroke: new ol.style.Stroke({ color: '#E6ADAD', width: 2 })
				})
			});

			var groupLayer = new ol.layer.Group({
				title: 'analysis',
				serviceNm: '네트워크 중첩분석',
				layers: [resultLayer, networkLayer]
			});

			var exportKey = xhr.getResponseHeader('export_key');
			geoMap.addLayer(groupLayer);
			analLayer(contextPath, exportKey);
			if(networkLayer.length > 0) {
				geoMap.getView().fit(networkLayer.getSource().getExtent(), geoMap.getSize());
			}
		}

		function createResultGraph(result, labels, colors){
			let graphChart = [];
			$('#pieChart').append('<select style="padding-right: 30px;"></select>');

			const totalNum = result[3].total;
			const univNum = result[3].univ;
			const subwayNum = result[3].subway_statn;

			labels.forEach((tit, idx) => {
				const calculatePercentage = (gubunCount, total) => {
				  const percentage = (gubunCount / total) * 100;
				  return percentage.toFixed(2); // 소수점 2자리까지 반환
				};
				
				let num = 0;
				if( tit == '대학캠퍼스' ){
					num = univNum;
				} else {
					num = subwayNum;
				}

				const gubunPercentage = calculatePercentage(num, totalNum); // 퍼센티지 계산
				const gubunList = [gubunPercentage, 100 - gubunPercentage];

				const graphData = {
				  data: gubunList, // 퍼센티지 데이터 배열
				  title: tit, 
				  color: [ '#d1e5f0','#d6604d' ], // 색상 배열
				  labels: [ tit + ' 중첩 지역', tit + ' 예외 지역' ] // dataNum의 key 값들을 라벨로 사용
				};

				$('#pieChart select').append(
					'<option value=' + tit + '>' + tit + '</option>'
				);

				graphChart.push(graphData);
			})

			Graph(graphChart[0]);

			$('#pieChart select').on('change', function (e) {
				const index = labels.indexOf(this.value);
				if(index !== -1){
					Graph(graphChart[index]);
				}
			});
		}
		
		function resultLegend(labels, colors){
			let legend = [];

	    labels.forEach((type, idx) => {
        let colorMatch = colors[idx];
        let legendName = labels[idx];

        if (colorMatch && legendName) {
           let legendItem = { color: colorMatch, name: legendName };
           legend.push(legendItem);
        }
	    });
			if (legend.length > 0) {
        showLegend(legend);
	    }
		};

		function createNetworkTableData (result) {

			const nameField = $('#optionContainer').find('select').val();

			const totalNum = result[3].total
			const totalUniv = result[3].univ
			const totalSubway = result[3].subway_statn

			return { totalNum, totalUniv, totalSubway };
		}

		function createNetworkTable(targetText, data) { // data
				const { totalNum, totalUniv, totalSubway } = data;

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
					'지하철': totalSubway
				};

				// 해당 문자열이 targetText에 내포되있는지
				['대학 캠퍼스', '지하철'].forEach(str => {
					if(targetText.includes(str)) {
						// 선택됐다는 의미, 값을 매칭시켜서 td생성
						const temp = document.createElement('td');
						temp.innerHTML = match[str] || '-';
						tbodyTotalRowElement.append(temp);
					}
				});

				tbodyElement.append(tbodyTotalRowElement);

				// 총 합계
				const totalCountColumn = document.createElement('td');
				totalCountColumn.innerHTML = totalNum;
				tbodyTotalRowElement.append(totalCountColumn);

				theadRowElement.append(theadColumnElement1);
				if(targetText.find(v => v==='대학 캠퍼스')) {
					const theadColumnElement2 = document.createElement('th');
					theadColumnElement2.innerHTML = `<b>대학 캠퍼스</b>`;
					theadRowElement.append(theadColumnElement2);
				}
				if(targetText.find(v => v==='지하철')) {
					const theadColumnElement4 = document.createElement('th');
					theadColumnElement4.innerHTML = `<b>지하철</b>`;
					theadRowElement.append(theadColumnElement4);
				}

				const theadColumnElement5 = document.createElement('th');
				theadColumnElement5.innerHTML = '사업대상지 (계)'
				theadRowElement.append(theadColumnElement5);

				theadElement.append(theadRowElement);
		};

		function createIntersectList (data, type) {
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
         if(type === 'multiring') {
            totalCount = analysisResult[key].length;
            outputNameColumn.setAttribute('rowspan', totalCount + 1);
         } else if(type === 'intersect') {
            totalCount = Object.keys(analysisResult[key]).reduce((acc, cur) => {
               return acc + analysisResult[key][cur].length;
            }, 0);
            outputNameColumn.setAttribute('rowspan', totalCount + Object.keys(analysisResult[key]).length);
         }


         if(type === 'multiring') {

            const proper = analysisResult[key].map(v => v.properties);

            let cCount = 0;
            if (proper.length > 0) {
               cCount = Object.keys(proper[0]).length;
            }

            if(cCount > columnCount) {
               columnCount = cCount;
            }

            const target = analysisResult[key];
            const targetId = target[0].id;
            let targetLayer = '';
            if (targetId.includes('univ')) {
               targetLayer = '대학 캠퍼스'
            } else if (targetId.includes('z_upis_c_uq151')) {
               targetLayer = '간선도로'
            } else if (targetId.includes('subway_statn')) {
               targetLayer = '지하철'
            }

            const layerNameColumn = document.createElement('td'); // 가지고 있는 시설별 개수 구해야함
            layerNameColumn.innerHTML = targetLayer;
            layerNameColumn.setAttribute('rowspan', target.length + 1);

            const headerRowElement = document.createElement('tr');

               headerRowElement.append(outputNameColumn);

               headerRowElement.append(layerNameColumn);
               Object.keys(target[0].properties).forEach(p => {
               const temp = document.createElement('td');
               temp.innerHTML = p;
               headerRowElement.append(temp);
            });
            tBodyElement.append(headerRowElement);

            target.forEach((row, idx) => {
               const rowElement = document.createElement('tr');

               Object.keys(row.properties).forEach(pKey => {
                  const temp = document.createElement('td');
                  temp.innerHTML = row.properties[pKey];
                  rowElement.append(temp);
               });
               tBodyElement.append(rowElement);

            });
         } else if(type === 'intersect') {
            Object.keys(analysisResult[key]).forEach((k, index) => { // univ road subway

               const proper = analysisResult[key][k].map(v => v.properties);

               let cCount = 0;
               if (proper.length > 0) {
                  cCount = Object.keys(proper[0]).length;
               }

               if(cCount > columnCount) {
                  columnCount = cCount;
               }

               const target = analysisResult[key][k];

               const layerNameColumn = document.createElement('td'); // 가지고 있는 시설별 개수 구해야함
               layerNameColumn.innerHTML = layerNameMatch[k];
               layerNameColumn.setAttribute('rowspan', target.length + 1);

               const headerRowElement = document.createElement('tr');
               if(index === 0) {
                  headerRowElement.append(outputNameColumn);
               }
               headerRowElement.append(layerNameColumn);
               Object.keys(target[0].properties).forEach(p => {
                  const temp = document.createElement('td');
                  temp.innerHTML = p;
                  headerRowElement.append(temp);
               });
               tBodyElement.append(headerRowElement);

               target.forEach((row, idx) => {
                  const rowElement = document.createElement('tr');

                  Object.keys(row.properties).forEach(pKey => {
                     const temp = document.createElement('td');
                     temp.innerHTML = row.properties[pKey];
                     rowElement.append(temp);
                  });
                  tBodyElement.append(rowElement);
               });
            })

         }
      })

      theadColumnElement3.setAttribute('colspan', columnCount);
      theadRowElement.append(theadColumnElement3);
      theadElement.append(theadRowElement);
   }
   
	</script>
	<body>
		<div role="tabpanel" class="areaSearch full" id="tab-02"
			style="overflow: auto">
			<div id="basic">
				<h2 class="tit">네트워크 중첩 분석</h2>
			</div>
		</div>

		<div class="breakLine"></div>
		<div class="disFlex smBtnWrap" style="padding: 1.6rem">
			<button type="button" class="primaryLine" onclick="initAnalService()">
				초기화</button>
			<button type="button" class="primarySearch" onclick="onClickNetwork()">
				분석</button>
		</div>

		<form id="GISinfoResultForm" name="GISinfoResultForm">
			<input type="hidden" name="geom[]" />
		</form>
	</body>
</html>
