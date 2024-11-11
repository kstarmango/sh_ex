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
				var shexPath = "<%=SHResource.getValue("sh.server.schema")%>://<%=SHResource.getValue("sh.server.url")%>";
				var componentData = [];
				var modalData = [];

				var reader = new ol.format.WKT();

				const uniqueColumnSet = new Set();

				const targetList = {
						target: [
							{
								schema: 'landsys_gis',
								layer: 'univ',
								gubun: '대학교',
								name: 'schul_nm',
							},
							{
								schema: 'landsys_gis',
								layer: 'lbrry',
								gubun: '도서관',
								name: 'lbrry_nm',
							},
							{
								schema: 'landsys_gis',
								layer: 'park',
								gubun: '공원',
								name: 'park_nm',
							},
		 					{
								schema: 'landsys_gis',
								layer: 'sigu_wrdofc_inhbtnt_cnter',
								gubun: '시청/구청/주민센터',
								name: 'lwprt_instt',
							},
							{
								schema: 'landsys_gis',
								layer: 'kndrgr',
								gubun: '유치원',
								name: 'kndrgr_won',
							},
							{
								schema: 'landsys_gis',
								layer: 'public_alsfc',
								gubun: '공공체육시설',
								name: 'fclty_nm',
							},
							{
								schema: 'landsys_gis',
								layer: 'su_lgz_str',
								gubun: '대형마트',
								name: 'bplc_nm',
							},
							{
								schema: 'landsys_gis',
								layer: 'su_drts_cnfm_prmisn_info',
								gubun: '백화점',
								name: 'bplc_nm',
							},
							{
								schema: 'landsys_gis',
								layer: 'hsptl_asemby',
								gubun: '병의원',
								name: 'instt_nm',
							},
							{
								schema: 'landsys_gis',
								layer: 'mdlc_gnrlz_hsptl',
								gubun: '종합병원',
								name: 'instt_nm',
							},
							{
								schema: 'landsys_gis',
								layer: 'hsfhg',
								gubun: '경로당',
								name: 'hsfhg_nm',
							},
							{
								schema: 'landsys_gis',
								layer: 'hsfhg_clssrm',
								gubun: '노인교실',
								name: 'odsn_clssrm_nm',
							},
							{
								schema: 'landsys_gis',
								layer: 'su_ssrft_list',
								gubun: '사회복지관',
								name: 'fclty_nm',
							},
							/*{
								schema: 'landsys_gis',
								layer: 'pblmng_prkplce',
								gubun: '공영주차장',
								name: 'prkplce_nm',
							},*/
							{
								schema: 'landsys_gis',
								layer: 'schul',
								gubun: '학교(중고교)',
								name: 'schul_nm',
							},
						],
				};

				$(document).ready(function () {
					$('#sub_content').show();
					initAnalService();

					componentData = [
						{
							type: 'search',
							title: '사업대상지',
							input: 'field',
							inputType: 'input_Lyr',
							features: 'input_features',
						},
						{ type: 'field' },
						{
							type: 'distanceInput',
							title: '쉼표로 구분된 거리값(m)',
							inputType: 'text',
							id: 'walkSpeed',
						},
					];

					doRenderSearchComp(componentData);
				});

				function switchSelectOption(e, type) {
					$(e.target).parent().find('.selected').removeClass('selected');
					$(e.target).addClass('selected');

					if (type == '사업대상지') {
						componentData = [
							{
								type: 'search',
								title: '사업대상지',
								input: 'field',
								inputType: 'input_Lyr',
								features: 'input_features',
							},
							{ type: 'field' },
							{
								type: 'distanceInput',
								title: '쉼표로 구분된 거리값(m)',
								inputType: 'text',
								id: 'walkSpeed',
							},
						];
					} else if (type == '주소검색') {
						componentData = [
							{ type: 'addr' },
							{
								type: 'distanceInput',
								title: '쉼표로 구분된 거리값(m)',
								inputType: 'text',
								id: 'walkSpeed',
							},
						];
					}

					doRenderSearchComp(componentData);
				}

				function returnGraphTable(data) {
					let curVal = '';
					const tableJson = {};
					let curTitle = '';

					Object.values(data).forEach((arr) => {

						arr[0].attribute.forEach((attribute) => {
							if (attribute.title === 'gubun') {
								const gubunValue = createGraphCategory(attribute.value);
								curVal = createGraphCategory(attribute.value);
								curTitle = attribute.value;

								if (!tableJson[curVal]) {
									tableJson[curVal] = [];
								}

								tableJson[curVal].push({title: attribute.value});

							} else if (attribute.title === 'count') {
								if (curVal) {
									if (tableJson[curVal]) {
										let temp = tableJson[curVal].filter((ttt) => ttt.title === curTitle);
										if (temp.length > 0) {
											temp[0].count = attribute.value;
										}
									}
								}
							}
						});
					});

					//const tableElement = document.getElementById('chartTable');
					const theadElement = document.getElementById('chartThead');

					const headers = ['분류', '시설', '시설 수'];
					const headerRow = document.createElement('tr');
					headers.map((header) => {
						const th = document.createElement('th');
						th.textContent = header;
						headerRow.appendChild(th);
					});
					theadElement.appendChild(headerRow);
					//tableElement.appendChild(theadElement);


					const tbodyElement = document.getElementById('chartTbody');

					Object.keys(tableJson).map((gubun, i) => {

						tableJson[gubun].map((fac, j) => {
							const tr = document.createElement('tr');

							if (j===0) {
								let td = document.createElement('td');
								td.textContent = gubun;
								td.rowSpan = tableJson[gubun].length;

								tr.appendChild(td);
							}


							let td2 = document.createElement('td');
							td2.textContent = fac.title;
							tr.appendChild(td2);

							let td3 = document.createElement('td');
							td3.textContent = fac.count;
							tr.appendChild(td3);

							tbodyElement.appendChild(tr);
						});

					});

				}

				let currentGubun;
				const gubunCount = {};

				function createGraphCategory(gubun) {
					let category = '기타';

					if (gubun === '공영주차장') {
						category = '교통';
					} else if (gubun === '유치원' || gubun === '어린이집'
							|| gubun === '대학교'|| gubun === '학교(중고교)'
							|| gubun === '초등학교') {
						category = '교육';
					} else if (gubun === '시청/구청/주민센터') {
						category = '행정';
					} else if (gubun === '공원' || gubun === '공공체육시설') {
						category = '휴식';
					} else if (gubun === '대형마트' || gubun === '백화점') {
						category = '편의';
					} else if (gubun === '병의원' || gubun === '종합병원') {
						category = '의료';
					} else if (gubun === '경로당' || gubun === '노인교실' || gubun === '사회복지관') {
						category = '복지';
					} else if (gubun === '도서관') {
						category = '문화';
					}

					return category;
				}

				function ChartGraph(data) {
					// 데이터 안의 각 배열을 순회
					Object.values(data).forEach((arr) => {
						arr[0].attribute.forEach((attribute) => {
							if (attribute.title === 'gubun') {
								const gubunValue = createGraphCategory(attribute.value);
								currentGubun = createGraphCategory(attribute.value);
							} else if (attribute.title === 'count') {
								if (currentGubun) {
									// gubun이 이미 존재하면 count 값 추가
									if (!gubunCount[currentGubun]) {
										gubunCount[currentGubun] = 0;
									}
									gubunCount[currentGubun] += attribute.value; // count 값 누적
								}
							}
						});

					});

					// 백분율 변환 함수
					const calculatePercentage = (gubunCount) => {
						const total = Object.values(gubunCount).reduce(
							(sum, count) => sum + count,
							0
						);

						// 백분율 계산하여 배열로 변환
						return Object.keys(gubunCount).map((key) => {
							const percentage = (gubunCount[key] / total) * 100;
							return percentage.toFixed();
						});
					};

					const gubunValuesCount = gubunCount;
					const gubunPercent = calculatePercentage(gubunValuesCount);

					Graph({
						data: gubunPercent,
						title: '시설 분류별 분포',
						color: ['#b2182b', '#d6604d', '#f4a582', '#9FC93C', '#d1e5f0', '#92c5de', '#4393c3', '#2166ac'],
						labels: Object.keys(gubunCount)
					});

					returnGraphTable(data);
				}

				function Table(data) {
					const theadElement = document.getElementById('dataResultTableHd');
					const tbodyElement = document.getElementById('dataResultTableBd');

					const createHeader = (distances) => {
						const headerRow1 = document.createElement('tr');
						const headers = [
							{ text: '시설', rowSpan: 2 },
							{ text: '최단거리 시설명', rowSpan: 2 },
							{ text: '직선 최단거리(m)', rowSpan: 2 },
							{ text: '시설 수', colSpan: distances.length },
						];

						headers.forEach(({ text, rowSpan, colSpan }) => {
							const th = document.createElement('th');
							th.textContent = text;
							if (rowSpan) th.rowSpan = rowSpan;
							if (colSpan) th.colSpan = colSpan;
							headerRow1.appendChild(th);
						});
						theadElement.appendChild(headerRow1);

						const headerRow2 = document.createElement('tr');
						distances.forEach((distance) => {
							const th = document.createElement('th');
							th.textContent = distance;
							headerRow2.appendChild(th);
						});

						theadElement.appendChild(headerRow2);
					};

					const createRow = (cells) => {
						const row = document.createElement('tr');
						cells.forEach((cell) => row.appendChild(createCell(cell)));
						return row;
					};

					const createCell = (value) => {
						const cell = document.createElement('td');
						cell.textContent = value;
						return cell;
					};

					const groupData = () => {
						return Object.values(data)
							.reduce((acc, arr) => acc.concat(arr), [])
							.reduce((acc, obj) => {
								const attributes = obj.attribute.reduce((acc, attr) => {
									acc[attr.title] = attr.value;
									return acc;
								}, {});

								const { gubun, count, distance, d_distance, nearest_nm = 'N/A' } = attributes;

								let nearestDis = d_distance;
								if (nearestDis) {
									nearestDis = (d_distance*1).toFixed(2);
								} else {
									nearestDis = '-';
								}

								acc[gubun] = acc[gubun] || { nearestNm: nearest_nm || '-', distances: {}, nearestDis: nearestDis };
								acc[gubun].distances[distance] =
									(acc[gubun].distances[distance] || 0) + count;
								return acc;
							}, {});
					};

					const populateTable = (groupedData) => {
						const distances = new Set();
						Object.entries(groupedData).forEach(
							([gubun, { nearestNm, nearestDis,  distances: distancesObj }]) => {
								const row = createRow([gubun, nearestNm, nearestDis]);

								let totalCount = 0;
								for (const [distance, count] of Object.entries(distancesObj)) {
									distances.add(distance);
									row.appendChild(createCell(count));
									totalCount += count;
								}
								tbodyElement.appendChild(row);
							}
						);
						return Array.from(distances);
					};

					const groupedData = groupData();
					const distances = populateTable(groupedData);
					createHeader(distances);
				}

				let totalCount;
				function List(data) {
					const theadElement = document.getElementById('resultThead');
					const tbodyElement = document.getElementById('resultTbody');

					// thead와 tbody 초기화
					theadElement.innerHTML = '';
					tbodyElement.innerHTML = '';

					// 헤더 생성
					const headerRow = document.createElement('tr');

					const facHeader = ['시설구분', '시설명'];
					facHeader.forEach((k, i) => {
						const th = document.createElement('th');
						th.innerHTML = k;
						headerRow.appendChild(th);
					});

					theadElement.appendChild(headerRow);

					let totalCount = 0;

					targetList.target.forEach((fac, i) => {

						//sub_features : 첫번째 거리기준
						let curGubun = '';
						//data[fac.layer][data[fac.layer].length-1].attribute[6].value.forEach((val, j) => {
						data[fac.layer][0].attribute[6].value.forEach((val, j) => {

							const row = document.createElement('tr');
							if (fac.gubun !== curGubun) {
								const tdGubun = document.createElement('td');
								tdGubun.innerHTML = fac.gubun + '(' + data[fac.layer][0].attribute[6].value.length + ')';
								tdGubun.rowSpan = data[fac.layer][0].attribute[6].value.length;
								row.appendChild(tdGubun);

								curGubun = fac.gubun;
							}


							val.attribute.forEach((valKey, n) => {
								const td = document.createElement('td');
								if (valKey.title === fac.name) {
									td.innerHTML = valKey.value || '-'; // 해당 값이 없으면 빈 문자열
									row.appendChild(td);
									totalCount++;
								}
							});

							tbodyElement.appendChild(row);
						});

					});


					$("span[name='search_list_count']").text(totalCount);

				}

				function resultModal(data) {

					modalData = [
						{ type: 'btnCnt' },
						{ type: 'graph' },
						{ type: 'table' },
						{ type: 'list' },
					];
					doRenderModal(modalData);

					showModalBtn();

					ChartGraph(data);
					Table(data);
					List(data);
				}

				function resultMap(data, key) {
					//제일 큰 버퍼 가져오기
					const result = Object.values(data.result).map((obj) => obj[0].attribute);

					//버퍼추가
					const bufferArr = [];
					const distances = $('.inputWrap').find('#walkSpeed').val();
					const distanceArr = distances.replaceAll(" ","").split(",");

					distanceArr.forEach((dis, i) => {
						let temp = Object.values(data.result).map((obj) => obj[i].attribute)[0];
						bufferArr.push({geom: temp[0].value, distance: temp[1].value});
					});

					const pointSource = new ol.source.Vector();
					
					result.forEach((item, itemIndex) => {
						Object.values(item).forEach((obj, idx) => {
							if (obj.title === 'sub_features' && obj.value.length !== 0) {
								obj.value.forEach((locItem, locIndex) => {
									var feature = new ol.Feature();
									locItem.attribute.forEach((att, attI) => {
										if (att.title === 'the_geom' && att.value) {
											var geom = att.value;
											var add_geometry = reader.readGeometry(geom, {
												dataProjection: 'EPSG:4326',
												featureProjection: 'EPSG:3857'
											});
											if (add_geometry) {
												feature.setGeometry(add_geometry);
											}
										} else {
											feature.set(att.title, att.value);
										}
									});
									feature.set('title', locItem.title);
									feature.set('category', createPointCategory(locItem.title));
									pointSource.addFeature(feature);
								});
							}
						});
					});

					initAnalService();

					const bufferLayer = createBufferLayer(bufferArr);

					const pointLayer = new ol.layer.Vector({
						title: 'distancePoint',
						source: pointSource,
					});
					
					pointLayer.setStyle(createPointLayerStyle(pointLayer, 'category'));

					const groupLayer = new ol.layer.Group({
						title: 'analysis',
						serviceNm: '기본입지분석(거리)',
						layers: [bufferLayer, pointLayer]
					})
					
					geoMap.addLayer(groupLayer);
					analLayer(contextPath, key);
					resultLegend(pointLayer);
					geoMap.getView().fit(bufferLayer.getSource().getExtent());
				}
				
				function resultLegend(vectorLayer) {
					const totalFeatureCategoryList = vectorLayer.getSource().getFeatures().map(f => f.getProperties().category);
					const uniqueCategoryList = [...new Set(totalFeatureCategoryList)];
					const legendItemList = uniqueCategoryList.map((category) => {
						return { color: getColor(category), name: category }	
					});

					const order = ['문화', '편의', '휴식', '교육', '의료', '복지', '행정'];
					legendItemList.sort((a, b) => {
						return order.indexOf(a.name) - order.indexOf(b.name);
					})

					showLegend(legendItemList)
				}

				function createBufferStyle() {
					function styleFunction(feature, resolution) {
						const font = 'bold 13px Roboto';
			            let title = '';

			            if (Number(feature.get('distance')) >= 1000) {
			                title = Number(feature.get('distance'))/1000 + 'km';
			            } else {
			                title = feature.get('distance') + 'm';
			            }

						return [new ol.style.Style({
							stroke: new ol.style.Stroke({
								color: [227, 26, 28, 0.3],
								width: 2,
							}),
							text: new ol.style.Text({
			                  	font: font,
			                  	text: title,
			                  	fill: new ol.style.Fill({color: '#000000'}),
			                  	stroke: new ol.style.Stroke({color: '#ffffff', width: 3}),
			                  	placement: 'line',
			                  	// offsetX: Number(feature.get('distance'))/100,
			              	}),
						})];
					}

					return styleFunction;
				}

				function createBufferLayer(bufferArr) {
					const bufferSource = new ol.source.Vector();
					const bufferLayer = new ol.layer.Vector({
						title: 'distanceBuffer',
						source: bufferSource,
					});
					bufferLayer.setStyle(createBufferStyle());
					
					const wkt = new ol.format.WKT();
					bufferArr.forEach((dis, i) => {
						var bufferFeature = new ol.Feature({
							geometry: wkt.readGeometry(dis.geom, {
								dataProjection: 'EPSG:4326',
								featureProjection: 'EPSG:3857'
							}),
                			distance: dis.distance,
						});
						bufferSource.addFeature(bufferFeature);
					});

					return bufferLayer;
				}

				function createPointCategory(title) {
					let category = '';

					if (title === 'pblmng_prkplce') {
						category = '교통';
					} else if (title === 'e_elesch' || title === 'kndrgr'
							|| title === 'child_house'|| title === 'univ'
							|| title === 'schul') {
						category = '교육';
					} else if (title === 'sigu_wrdofc_inhbtnt_cnter') {
						category = '행정';
					} else if (title === 'park' || title === 'public_alsfc') {
						category = '휴식';
					} else if (title === 'su_lgz_str' || title === 'su_drts_cnfm_prmisn_info') {
						category = '편의';
					} else if (title === 'hsptl_asemby' || title === 'mdlc_gnrlz_hsptl') {
						category = '의료';
					} else if (title === 'hsfhg' || title === 'hsfhg_clssrm' || title === 'su_ssrft_list') {
						category = '복지';
					} else if (title === 'lbrry') {
						category = '문화';
					}

					return category;
				}
				
				function getColor(category){
					const colors = ['#b2182b', '#d6604d', '#f4a582', '#9FC93C', '#d1e5f0', '#92c5de', '#4393c3', '#2166ac'];
					let fillColor = colors[0];
					
					if (category === '교통') {
		                // fillColor = colors[0];
		            } else if (category === '문화') {
		                fillColor = colors[0];
		            } else if (category === '편의') {
		                fillColor = colors[1];
		            } else if (category === '휴식') {
		                fillColor = colors[2];
		            } else if (category === '교육') {
		                fillColor = colors[3];
		            } else if (category === '의료') {
		                fillColor = colors[4];
		            } else if (category === '복지') {
		                fillColor = colors[5];
		            } else if (category === '행정') {
		                fillColor = colors[6];
		            }
					
					return fillColor;
				}

				function createPointLayerStyle(vectorLayer, field) {
					
				function styleFunction(feature, resolution) {
          const val = feature.get(field);
          let fillColor = getColor(val);

          const index = feature.get('index');
          const selected = feature.get('selected');

          const type = feature.getGeometry().getType();

          if (type.search('Point') >= 0) {
              if (selected) {
	                  return [new ol.style.Style({
	                      image: new ol.style.Circle({
	                          fill: new ol.style.Fill({
	                              color: '#ffd700'
	                          }),
	                          stroke: new ol.style.Stroke({
	                              color: '#00000',
	                              width: 1.2
	                          }),
	                          radius: 7,
	                      }),
	                  })];
	              }

	              return [new ol.style.Style({
	                  image: new ol.style.Circle({
	                      fill: new ol.style.Fill({
	                          color: fillColor,
	                      }),
	                      stroke: new ol.style.Stroke({
	                          color: '#00000',
	                          width: 1.2,
	                      }),
	                      radius: 5,
	                  }),
	              })];

	          } else {
	              if (selected) {
	                  return [new ol.style.Style({
	                      fill: new ol.style.Fill({
	                          color: '#ffd700'
	                      }),
	                      stroke: new ol.style.Stroke({
	                          color: '#00000',
	                          width: 1.2
	                      }),
	                  })];
	              }

	              return [new ol.style.Style({
	                  fill: new ol.style.Fill({
	                      color: fillColor,
	                  }),
	                  stroke: new ol.style.Stroke({
	                      color: '#00000',
	                      width: 1.2,
	                  }),
	              })];
	          }

					};

					return styleFunction;
				}

				function onClickDistance(e) {
					doBeforeAnalysis();

					document.getElementById('loading_area').style.display = 'block';
					document.getElementById('content_area').style.display = 'none';

					const inputWKT = $('#output_field').find('.selected').attr('value') || $('#input_features').find('.selected').attr('data-addrWKT') ;
					const walkSpeed = $('.inputWrap').find('#walkSpeed').val();
					const targetListStr = JSON.stringify(targetList);

					if (inputWKT && walkSpeed && targetListStr) {
						if(walkSpeed.split(',').length > 3) {
							alert('현재 거리 구분값은 3개까지 지원합니다.');
							doAfterAnalysis();
							return;
						};
						
						const walkSpeedArr =  walkSpeed.split(',');
						const num = isNaN(Number(walkSpeed));
						const nums =  walkSpeedArr.some(item => isNaN(Number(item)));
						const blank =  walkSpeedArr.some(item => item === "");
						if(num && nums) {
							alert('거리 구분값은 숫자로 입력해주세요.');
							doAfterAnalysis();
							return;
						};
						
						if(blank) {
							alert('거리를 다시 입력해주세요.');
							doAfterAnalysis();
							return;
						};

						$.ajax({
							type: 'POST',
							//async: true,
							url: '<%=RequestMappingConstants.WEB_ANAL_DISTANCE_LIFE%>',
							dataType: 'text',
							data: {
								inputWKT: inputWKT,
								distance: walkSpeed,
								targetListStr: targetListStr,
							},
							error: function (response, status, xhr) {
								//console.log(status);
								if (xhr.status == '404') {
									alert('분석에 실패 했습니다.');
								}
							},
							success: function (res, status, xhr) {
								try {
									let data = JSON.parse(res);
									const isNullResult = !data.result || !Object.values(data.result).flat().map(item => item.attribute[5].value).filter(v => v !== 0).length;
									
									if(isNullResult){
										alert('분석 결과가 존재하지 않습니다. 조건을 변경해주세요');
										return;
									}
									
									var exportKey = xhr.getResponseHeader('export_key');

									resultMap(data, exportKey);
									resultModal(data.result);
								} catch (error){
									console.log(error);
									alert('분석에 실패 했습니다.');
									doAfterAnalysis();
								}
							},
							complete: function(xhr, status) {
								doAfterAnalysis();
							}
						});
					} else {
						alert('값을 입력해주세요.');
						doAfterAnalysis();
					}
				}
	</script>

<body>
	<div role="tabpanel" class="areaSearch full" id="tab-02"
		style="overflow: auto">
		<div id="basic">
			<h2 class="tit">기본 입지 분석(거리)</h2>
			<h3 class="tit">입력 데이터 유형</h3>
			<div class="selectWrap">
				<div class="disFlex">
					<button type="button" id="business" size="10"
						class="form-control input-ib network selected"
						onclick="switchSelectOption(event, '사업대상지')">
						사업대상지</button>
					<button type="button" id="address" size="10"
						class="form-control input-ib network"
						onclick="switchSelectOption(event, '주소검색')">주소검색
					</button>
				</div>
			</div>
		</div>
	</div>

	<div class="breakLine"></div>
	<div class="disFlex smBtnWrap" style="padding: 1.6rem">
		<button type="button" class="primaryLine" onclick="initAnalService()">
			초기화</button>
		<button type="button" class="primarySearch"
			onclick="onClickDistance()">분석</button>
	</div>

	<form id="GISinfoResultForm" name="GISinfoResultForm">
		<input type="hidden" name="geom[]" />
	</form>
</body>
</html>
