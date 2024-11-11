<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />

<!DOCTYPE html>
<html>
<script type="text/javascript">
	const vectorSource = new ol.source.Vector();
	var reader = new ol.format.WKT()
	var inputFeatures;
	var contextPath = "${contextPath}";

	$(document).ready(function() {
		$('#sub_content').show();
		initAnalService();
	})

	function onClickBuffer(e) {
		doBeforeAnalysis();

		const schema = $('#input_features li.selected').attr('table_nm')
		const inputFeatures = $('#input_features li.selected').attr('layer_tp_nm')
		const distance = $('#distance').val();

		initAnalService();

		if(inputFeatures && distance){
			$.ajax({
				type : "POST",
				async : true,
				url : "<%=RequestMappingConstants.WEB_ANAL_CMMN_BUFFER%>",
				dataType : "json",
				data : {
					inputFeatures,
					distance,
					schema,
					// distanceUnit: $('#distanceUnit').val() || 'Meter'
					distanceUnit: 'Meter'
				},
				error : function(response, status, xhr) {
					if (xhr.status == '404') {
						alert('분석에 실패 했습니다.');
					}
				},
				success : function(data, status, xhr) {
					try {
						if(!data){
							alert('분석 결과가 없습니다.')
							return;
						}

						data.forEach((obj) => {
						var feature = new ol.Feature({ geometry: new ol.geom.Geometry() });
						obj.attribute.forEach((item, idx) => {
							if(item.title == 'the_geom') {
								var geom = item.value;
								var add_geometry = reader.readGeometry(geom).transform('EPSG:4326', 'EPSG:3857');
								
								feature.setGeometry(add_geometry);
							} else feature.set(item.title, item.value);
							});
							vectorSource.addFeature(feature);
						});
						
						var vectorLayer = new ol.layer.Vector({ 
							title:"analysis", //buffer 
							serviceNm: "반경거리",
							// serviceNm: $('#input_features li.selected').text(),
							source: vectorSource
						});

						geoMap.getView().fit(vectorLayer.getSource().getExtent(), geoMap.getSize());
	   					geoMap.addLayer(vectorLayer);

						var exportKey = xhr.getResponseHeader('export_key');  // 응답 헤더에서 export_key 값 추출
						analLayer(contextPath, exportKey);

					} catch (error) {
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
		} else {
			alert('값을 입력해주세요.')
			doAfterAnalysis();
		}

	}

</script>
<body>
	<div role="tabpanel" class="areaSearch full" id="tab-01" style="overflow: auto;">
		<!-- TabContent start -->
		<h2 class="tit">반경거리분석</h2>

		<!-- MY data 혹은 주소 검색일시 -->
		<h3 class="tit" id="search">입력 레이어 검색</h3>
		<div class="inputWrap">
			<input type="text" id="input_Lyr" onkeyup="searchLayersNameNew(event, 'field')" placeholder="검색할 데이터를 입력해주세요.">
			<button class="searchBtn" type="button" onclick="searchLayersNameNew(event, 'field')">
				<img src="${contextPath}/resources/img/map/IcSearch.svg" alt="검색">
			</button>
		</div>

		<h3 class="tit" id="result">입력 레이어 검색 결과</h3>
		<div class="inputWrap">
			<ul id="input_features"></ul>
		</div>

		<h3 class="tit" for="distance">쉼표로 구분된 거리값</h3> 
		<input class="half_input_textarea analy_input" 
			type="text" placeholder="쉼표로 구분된 거리값을 입력하세요." id="distance" autocomplete="off" />
			
		<!--
		<h3 class="tit">거리 단위</h3> 
		<div class="selectWrap">
			<div class="disFlex">
				<select class="form-control chosen" id="distanceUnit">
					<option value="" selected>기본값(Default)</option> 
					<option value="Meter" selected>Meter</option>
					<option value="Kilometers">Kilometers</option>
					<option value="Inches">Inches</option>
					<option value="Feet">Feet</option>
					<option value="Yards">Yards</option>
					<option value="Miles">Miles</option>
					<option value="NauticalMiles">NauticalMiles</option>
				</select>
			</div>
		</div> -->

		<!-- <h3 class="tit">바깥쪽만 반경거리</h3>
		<div class="selectWrap">
			<div class="disFlex">
				<select class="form-control chosen" name="bsns_nm" id="bsns_nm">
					<option value="01" selected="selected">예</option>
					<option value="02">아니오</option>
				</select>
			</div>
		</div>

		<h3 class="tit">디졸브 여부</h3>
		<div class="selectWrap">
			<div class="disFlex">
				<select class="form-control chosen" name="bsns_nm" id="bsns_nm">
					<option value="01" selected="selected">예</option>
					<option value="02">아니오</option>
				</select>
			</div>
		</div> -->

	</div> <!-- TabContent end -->
	<!-- End Tab-04 -->
	<!-- 검색조건 Form -->
	<div class="breakLine"></div>
	<div class="disFlex smBtnWrap" style = "padding: 1.6rem;">  
  	<button type="button" class="primaryLine" onclick="initAnalService()">초기화</button>
    <button type="button" class="primarySearch" onclick="onClickBuffer()">분석</button>
			<!-- <div >
				<button onClick="clearAnalyResource('buffer')">초기화</button>
				<button id="bufferBtn" onClick="onClickBuffer()">분석</button>
			</div> -->
	</div>

	<!-- 검색결과 Form -->
	<form id="GISinfoResultForm" name="GISinfoResultForm">
		<input type="hidden" name="geom[]">
	</form>
	
</body>
</html>

