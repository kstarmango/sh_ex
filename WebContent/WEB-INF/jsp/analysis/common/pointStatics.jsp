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

		var contextPath = "${contextPath}";
		let btns = document.querySelectorAll(".faq__question");
		
		const classfy_colors = ['#f2f0f7', '#fecc5c', '#fd8d3c', '#f03b20', '#bd0026'];
		const colors_purples = ['#f2f0f7', '#cbc9e2', '#9e9ac8', '#756bb1', '#54278f']; // purples
		const colors_ylorrd = ['#ffffb2', '#fecc5c', '#fd8d3c', '#f03b20', '#bd0026']; // ylorrd
		const colors_oranges = ['#feedde', '#fdbe85', '#fd8d3c', '#e6550d', '#a63603']; // oranges
		const colors_greens = ['#edf8e9', '#bae4b3', '#74c476', '#31a354', '#006d2c']; // greens
		const colors_greys = ['#f7f7f7', '#cccccc', '#969696', '#636363', '#252525']; // greys
		const colors_blues = ['#eff3ff', '#bdd7e7', '#6baed6', '#3182bd', '#08519c']; // blues

		const default_colors = colors_ylorrd;
		const color_brewers = {
		  ylorrd: colors_ylorrd,
		  purples: colors_purples,
		  oranges: colors_oranges,
		  greens: colors_greens,
		  greys: colors_greys,
		  blues: colors_blues,
		};
		
		$(document).ready(function() {
			$('#sub_content').show()
			initAnalService();

			btns.forEach((btn) => {
			  btn.addEventListener("click", (e) => {
			  				  
				const isEqualBtn = e.target.id == btn.id;  
			    const faqItem = btn.parentNode;
			    const isTargetHide = !faqItem.classList.contains("active") && isEqualBtn;
		        const targetEle = e.target.parentElement;
			    
			    if (isTargetHide) {
		    	  targetEle.lastElementChild.style.padding = '2rem'
	          targetEle.lastElementChild.style.maxHeight = 'fit-content'
			      targetEle.classList.add("active");
			    } else if(isEqualBtn){
			      targetEle.lastElementChild.style.padding = '0';
			      targetEle.lastElementChild.style.maxHeight = '0';
			      targetEle.classList.remove('active')		    	
		    	} 
			  });
			});
			
			$("#overlayLyrs" +  ' li').click(function(event){
				searchFieldName(this.getAttribute('table_nm'), this.getAttribute('layer_tp_nm'));

				//event.preventDefault();
			});
		});
		
		function doAnalysis(e){
			doBeforeAnalysis();
			initAnalService();

			let pointStOpt = {};

			pointStOpt.inputSchema = $('#input_features li.selected').attr('table_nm');
			pointStOpt.overlaySchema = $('#overlayLyrs li.selected').attr('table_nm');
			pointStOpt.polygonFeatures = $('#input_features li.selected').attr('layer_tp_nm');
			pointStOpt.pointFeatures = $('#overlayLyrs li.selected').attr('layer_tp_nm');			
			pointStOpt.statisticsFields = $('#statisticsFields').val() || 'count';
			pointStOpt.countField = $('#statisticsFields2').val();

			// if(!$('#input_features li.selected').text().includes('POLYGON') || !$('#overlayLyrs li.selected').text().includes('POINT')){
			// 	alert('레이어 타입을 확인해주세요.')
			// 	doAfterAnalysis();
			// 	return;
			// }

			if( !pointStOpt['polygonFeatures'] || !pointStOpt['pointFeatures']  ){
				alert('입력조건을 모두 채워주세요.')
				doAfterAnalysis();
				return;
			} 
			
			const tempSource = new ol.source.Vector();
			const classifyMethod = $('#classifyMethod').val();
			// const classifyColor = $('#classifyColor').val();
			const classifyColor = 'ylorrd';

			$.ajax({
				type : "POST",
				async : false,
				url : "<%=RequestMappingConstants.WEB_ANAL_CMMN_POINT%>",
				dataType : "json",
				data : { ...pointStOpt },
				error : function(response, status, xhr){
					alert('분석에 실패했습니다.')
					doAfterAnalysis();
				},
				success : function(data, status, xhr) {
					try {
						const fieldStrArr = { count: 'cnt', first: 'fst', sum: 'sum', mean: 'avg', max: 'max', std: 'std' };
						const fieldStr = fieldStrArr[pointStOpt.statisticsFields] + '_' + pointStOpt.countField;

						data.forEach((fdList) => {
							const feature = new ol.Feature({ geometry: new ol.geom.Geometry() });

							Object.values(fdList.attribute).forEach((fd, idx) => {
								//geometry
								if(fd.title === 'the_geom'){
									const geom_type = fd.type;
									const geom = fd.value;
									
									const reader = new ol.format.WKT();
									const added_geometry = reader.readGeometry(geom, {
										dataProjection: 'EPSG:4326',
										featureProjection: 'EPSG:3857'
									});
									feature.setGeometry(added_geometry);
								} else if(fd.title === fieldStr && fd.value === null) {
									feature.set(fd.title, 0);
								} else {
									feature.set(fd.title, fd.value);
								}
							});

							tempSource.addFeature(feature);
						});
						
						const tempVectorLayer = new ol.layer.Vector({ 
							title: "analysis", // pointStatics
							// serviceNm: $('#overlayLyrs li.selected').text(),
							serviceNm: "포인트집계분석",
							source: tempSource 
						});
						
						let colorArr = color_brewers[classifyColor];
						if (tempSource.getFeatures().length < 5) {
							colorArr = color_brewers[classifyColor].slice(0, tempSource.getFeatures().length);
						}
						const style = createGraduatedColorStyle(classifyMethod, tempVectorLayer, fieldStr, colorArr);
						if(style) tempVectorLayer.setStyle(style);
						
						geoMap.getView().fit(tempVectorLayer.getSource().getExtent(), geoMap.getSize());
						geoMap.addLayer(tempVectorLayer);
						
						var exportKey = xhr.getResponseHeader('export_key');
						analLayer(contextPath, exportKey);
					} catch (error) {
						console.log(error);
					} finally {
						doAfterAnalysis();
					}
				}
			})	
		}
		
	  function createGraduatedColorStyle(method, vectorLayer, field, colors)  {
		  if(!method || !vectorLayer || !field || !colors ) return null;

	      const features = vectorLayer.getSource().getFeatures();
				const featureProp = features[0].getProperties();
				if(!Object.values(featureProp).length) return null;
				
	      const classBreaks = getClassBreaks(method, features, field, colors.length, colors);
	      
	      if (features.length === 0) {
	        return false;
	      }
	      
	      const geometry = features[0].getGeometry();
	      let isLineString = false;
	      
	      if (geometry instanceof ol.geom.LineString || geometry instanceof ol.geom.MultiLineString) {
	        isLineString = true;
      }

      function styleFunction(feature, resolution) {

				const resultColIndex = Object.values(featureProp).length - 1;
        const val = feature.get(Object.keys(featureProp)[resultColIndex]);
        let fillColor = colors[0];

        for (let i = 0; i < classBreaks.length; i += 1) {
          if (val >= classBreaks[i] && val < classBreaks[i + 1]) {
            fillColor = colors[i];
            break;
          }
        }

				let title = "(" + val + ")";
        const strokeColor = isLineString ? fillColor : '#FFFFFF';

        return [new ol.style.Style({
          fill: new ol.style.Fill({
            color: fillColor,
          }),
          stroke: new ol.style.Stroke({
            color: strokeColor,
            width: 1.2,
          }),
          text: new ol.style.Text({
        	 font: 'bold 13px Roboto',
                 text: title,
        	        fill: new ol.style.Fill({color: '#000000'}),
                 stroke: new ol.style.Stroke({color: '#ffffff', width: 3}),
          }),
          image: new ol.style.Circle({
            fill: new ol.style.Fill({
              color: fillColor,
            }),
            stroke: new ol.style.Stroke({
              color: strokeColor,
              width: 1.2,
            }),
            radius: 12,
          })
        })];
      };

      return styleFunction;
		}
		
	function getClassBreaks(method, features, field, bin, colors) {

      let minValue = Number.MAX_VALUE;
      let maxValue = Number.MIN_VALUE;
      const items = [];
      for (let i = 0, { length } = features; i < length; i += 1) {
        const value = features[i].get(field);
        // eslint-disable-next-line no-restricted-globals
        if (isNaN(value)) {
          // eslint-disable-next-line no-continue
          continue;
        }

        items[i] = Number(value).toFixed(7);
        minValue = Math.min(value, minValue);
        maxValue = Math.max(value, maxValue);
      }

      let breaks;
      if (items === null || items === '') {
        return false;
      }
      // eslint-disable-next-line no-undef
      const stat = new geostats(items);
      stat.setPrecision(6);

      if (method.indexOf('Eq') === 0) {
        breaks = stat.getClassEqInterval(bin);
      } else if (method.indexOf('Je') === 0 || method.indexOf('Na') === 0) {
        breaks = stat.getClassJenks(bin);
      } else if (method.indexOf('Qu') === 0) {
        breaks = stat.getClassQuantile(bin);
      } else if (method.indexOf('St') === 0) {
        breaks = stat.getClassStdDeviation(bin);
      } else if (method.indexOf('De') === 0) {
        breaks = [0, 1, 2.5, 5, 10, 100];
      } else { 
				doAfterAnalysis(); 
				return null;
			}

      breaks[0] = minValue - 0.1 < 0 ? 0 : minValue - 0.1;
      breaks[breaks.length - 1] = maxValue + 0.1;
      
      Table(items, breaks, colors);

      return breaks;
  	}
		
		function Table(dataList, gradeList, colors){
		
			modalData = [{ type: 'table' }];
			doRenderModal(modalData);

			$('#content_area #graph').css('display', 'block');

			const bodyElement = document.getElementById('dataResultTableBd');
			const headElement = document.getElementById('dataResultTableHd');
				
			const headRow = document.createElement('tr');
			const thead0 = document.createElement('td');
			const thead1 = document.createElement('td');
			const thead2 = document.createElement('td');
			thead0.innerText = '색상';
			thead1.innerText = '급간';
			thead2.innerText = '갯수';
			headRow.append(thead0);
			headRow.append(thead1);
			headRow.append(thead2);
			headElement.append(headRow);

			var resultColumn = $('#statisticsFields option.selected').attr('value') || '갯수';
			var selectedLyrArr = [];
			const counts = new Array(gradeList.length - 1).fill(0);

			dataList.forEach(data => {
		        for (let i = 0; i < gradeList.length - 1; i++) {
		          if (data >= gradeList[i] && data < gradeList[i + 1]) {
		            counts[i]++;
		            break;
		          }
		      	}
		    });
			
			counts.forEach((count, idx) => {
				const bodyRow = document.createElement('tr');
				const colorValue = document.createElement('td');
				const gradeValue = document.createElement('td');
				const countValue = document.createElement('td');
				const txt = (gradeList[idx] == -0.1 ? 0 : gradeList[idx]) + " - " + gradeList[idx + 1];

				colorValue.style.backgroundColor = colors[idx];
				gradeValue.innerText = txt;
				countValue.innerText = count;
				bodyRow.appendChild(colorValue);
				bodyRow.appendChild(gradeValue);
				bodyRow.appendChild(countValue);
				bodyElement.appendChild(bodyRow);
			});
			
		}

	</script>

<body>
	<!-- TabContent start -->
	<div role="tabpanel" class="areaSearch full" id="tab-02"
		style="overflow: auto;">

		<h2 class="tit">포인트 집계 분석</h2>

		<h3 class="tit" id="search">입력레이어(폴리곤)</h3>
		<div class="inputWrap">
			<input type="text" id="input_Lyr"
				onkeyup="searchLayersNameNew(event, 'none_field')"
				placeholder="검색할 데이터를 입력해주세요.">
			<button class="searchBtn" type="button"
				onclick="searchLayersNameNew(event, 'none_field')">
				<img src="${contextPath}/resources/img/map/IcSearch.svg" alt="검색">
			</button>
		</div>

		<h3 class="tit" id="result">입력레이어(폴리곤) 검색 결과</h3>
		<div class="inputWrap">
			<ul id=input_features></ul>
		</div>

		<h3 class="tit">중첩레이어(포인트)</h3>
		<div class="inputWrap">
			<input type="text" id="input_overlap"
				onkeyup="searchLayersNameNew(event, 'overlap_field')"
				placeholder="검색할 데이터를 입력해주세요.">
			<button class="searchBtn" type="button"
				onclick="searchLayersNameNew(event, 'overlap_field')">
				<img src="${contextPath}/resources/img/map/IcSearch.svg" alt="검색">
			</button>
		</div>

		<h3 class="tit" id="result">중첩레이어(포인트) 검색 결과</h3>
		<div class="inputWrap">
			<ul id="overlayLyrs"></ul>
		</div>

		<h3 class="tit">속성값을 이용한 집계기준</h3>
		<div class="selectWrap">
			<div class="disFlex">
				<select id="statisticsFields" class="form-control chosen">
					<option value="count" selected>Count</option>
					<option value="first">First</option>
					<option value="sum">Sum</option>
					<option value="mean">Mean</option>
					<option value="max">Max</option>
					<option value="std">Std</option>
				</select>
			</div>

			<div class="disFlex" id="optionContainer">
				<select class="form-control chosen" id="statisticsFields2">
					<option value="" selected="selected">필드선택(옵션)</option>
				</select>
			</div>
		</div>

		<h3 class="tit">급간분류방법</h3>
		<div class="selectWrap">
			<div class="disFlex">
				<select id="classifyMethod" class="form-control chosen">
					<option selected="selected">Jenk Natural Breaks</option>
					<option>Quantile</option>
					<option>Equal Interval</option>
					<option>Standared Deviation</option>
				</select>
			</div>
		</div>

		<!-- <h3 class="tit">색상램프</h3> 
		<div class="selectWrap">
			<div class="disFlex">
				<select id="classifyColor" class="form-control chosen">
					<option value="ylorrd">ylorrd</option>
                  	<option value="purples">purples</option>
                  	<option value="oranges">oranges</option>
                  	<option value="greens">greens</option>
                  	<option value="greys">greys</option>
                  	<option value="blues">blues</option>
				</select>
			</div>
		</div> -->


	</div>

	<!-- 검색조건 Form -->
	<div class="breakLine"></div>
	<div class="disFlex smBtnWrap" style="padding: 1.6rem;">
		<button type="button" class="primaryLine" onclick="initAnalService()">초기화</button>
		<button type="button" class="primarySearch" onclick="doAnalysis()">분석</button>
	</div>

	<!-- 검색결과 Form -->
	<form id="GISinfoResultForm" name="GISinfoResultForm">
		<input type="hidden" name="geom[]">
	</form>
	<!-- End Tab-01 -->
	<script type="text/javascript"
		src="<c:url value='/resources/js/analysis/geostats.js'/>"></script>
</body>
</html>