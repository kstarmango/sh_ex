<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />

<!DOCTYPE html>
<html lang="ko">
<script type="text/javascript">	

	let inputFeatures;
	let tableNm;
	
	const vectorSource = new ol.source.Vector();
	let reader = new ol.format.WKT();
	var contextPath = "${contextPath}";
	
	let drawLayer;
	let duplicateLayer;

	$(document).ready(function() {
		$('#sub_content').show();
		initAnalService();
	})

	function drawPolygon () {
		duplicateLayer = geoMap.getLayers().getArray().filter(layer => layer.get('title') === 'draw layer');
		if(duplicateLayer.length === 0){		
			drawLayer = new ol.layer.Vector({
				source: new ol.source.Vector(),
				title: 'draw layer' 
			})
			geoMap.addLayer(drawLayer);
		}else{
			drawLayer = duplicateLayer[0];
			drawLayer.getSource().clear();
		}
		
		for(let interaction of geoMap.getInteractions().getArray()){
			if(interaction instanceof ol.interaction.Draw){
				geoMap.removeInteraction(interaction);
			}
		}
		
		let draw = new ol.interaction.Draw({
			source : drawLayer.getSource(),
			type: 'Circle',
			geometryFunction: ol.interaction.Draw.createBox()
		})

		draw.on('drawstart', function(e) {
			clearAnalResource()
		})
		
		draw.on('drawend', function(e) {
			geoMap.removeInteraction(this);
		})
		
		geoMap.addInteraction(draw);
	};
	
	function onClickDensity() {
		doBeforeAnalysis();
		initAnalService();

		tableNm = $('#input_features li.selected').attr('table_nm');
		inputFeatures = $('#input_features li.selected').attr('layer_tp_nm');
		let wkt;
		let add_geometry;
		if(!inputFeatures){
			alert('입력레이어를 선택해주세요.');
			doAfterAnalysis();
			return;
		} else if (!drawLayer || drawLayer.getSource().getFeatures().length === 0){
			alert('영역을 그려주세요.');
			/* boundaryFeature  = ol.geom.Polygon.fromExtent([126.766, 37.413, 127.183, 37.701]);
			wkt = reader.writeGeometry(boundaryFeature) */
			doAfterAnalysis();
			return;
		} else {
			wkt = reader.writeGeometry(drawLayer.getSource().getFeatures()[0].getGeometry());
		}

		try {

			add_geometry = reader.readGeometry(wkt, { dataProjection: 'EPSG:3857' , featureProjection: 'EPSG:4326' })
		
			let width = $('#geomap')[0].clientWidth;
			let height = $('#geomap')[0].clientHeight;
			
			let mapExtent = geoMap.getView().calculateExtent();
			let mapWidth = new ol.geom.LineString([
				[mapExtent[0], mapExtent[1]],
				[mapExtent[2], mapExtent[1]]
				]).getLength();
			let mapHeight = new ol.geom.LineString([
				[mapExtent[0], mapExtent[1]],
				[mapExtent[0], mapExtent[3]]
			]).getLength();
			let lyrExtent;
			
			if(!drawLayer || drawLayer.getSource().getFeatures().length === 0){
				lyrExtent = boundaryFeature.getExtent();
			} else {
				lyrExtent = drawLayer.getSource().getFeatures()[0].getGeometry().getExtent();
			}

			let lyrWidth = new ol.geom.LineString([
				[lyrExtent[0], lyrExtent[1]],
				[lyrExtent[2], lyrExtent[1]]
			]).getLength();
			let lyrHeight = new ol.geom.LineString([
				[lyrExtent[0], lyrExtent[1]],
				[lyrExtent[0], lyrExtent[3]]
			]).getLength();
			
			width = (width * lyrWidth) / mapWidth;
			height = (height * lyrHeight) / mapHeight;
			
			let extent = lyrExtent 
			
			let minX = extent[0].toFixed(6);
			let minY = extent[1].toFixed(6);
			let maxX = extent[2].toFixed(6);
			let maxY = extent[3].toFixed(6);
			
			let featureLayer = geoMap.getLayers().getArray().filter(item => item.get('title') === 'analysis');
			
			let densityFeatures;
			let kernelType = $("#kernelType option:selected").val();
			let geometry = add_geometry;
			const url = '/web/analysis/cmmn/density.do'
					+ '?inputFeatures=' + inputFeatures 
					+ '&schema=' + tableNm
					+ ( kernelType ? '&kernelType=' + kernelType : '&kernelType=Quadratic')
					+ "&width=" + Math.round(width) * 10
					+ '&height=' + Math.round(height) * 10
					+ '&minX=' + minX + '&minY=' + minY + '&maxX=' + maxX + '&maxY=' + maxY;
			
			let source = new ol.source.ImageStatic({
				imageExtent: lyrExtent,
				projection: 'EPSG:3857', 
				url
			});

			source.on('imageloadend',()=> { 
				doAfterAnalysis();

				$.ajax({
					type: 'GET', 
					url,
					error : function(response, status, xhr){
						alert('파일 다운로드 요청이 실패했습니다.\n\n관리자에게 문의하시길 바랍니다.')
					},
					success: function(response, status, xhr) {
						var exportKey = xhr.getResponseHeader('export_key');
						analLayer(contextPath, exportKey);
					}
				});
			});

			function opacityRatio(image) {
		    const canvas = document.createElement("canvas");
		    const context = canvas.getContext("2d");
		    canvas.width = image.width;
		    canvas.height = image.height;
		    context.drawImage(image, 0, 0);
		    const data = context.getImageData(0, 0, canvas.width, canvas.height).data;
		    let opacity = 0;
		    for (let i = 0; i < data.length; i += 4) {
		        opacity += data[i + 3];
		    }
		    return (opacity / 255) / (data.length / 4);
			}

			if(!source) doAfterAnalysis();

			if(featureLayer.length === 0) {
				densityFeatures = new ol.layer.Image({
					title: 'analysis',
					// serviceNm: $('#input_features li.selected').text(),
					serviceNm: "밀도",
					source: source,
					opacity: 0.7
				});
				
				geoMap.addLayer(densityFeatures);
				analLayer(contextPath); // 래스터

			} else { 
				densityFeatures = featureLayer[0];
				densityFeatures.setSource(source);
				drawLayer.getSource().clear();
			};
			
		} catch (error) {
			console.log(error)
			alert('분석에 실패 했습니다.');
			doAfterAnalysis();
		}
	
	};

	function clearAnalResource(){
		const resultLayers = geoMap.getLayers().getArray()
	    .filter((lyr) => lyr.get('title') === 'draw layer');
	  resultLayers.forEach((layer) => layer.getSource().clear());
	}
	
</script>
<body>
	<!-- TabContent start -->
	<div role="tabpanel" class="areaSearch full" id="tab-02" style="overflow: auto;">

		<h2 class="tit">밀도분석</h2>

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

			<h3 class="tit" id="search">입력 영역 필드 선택</h3>
			<div class="selectWrap">
				<div class="disFlex" id="optionContainer">
					<select class="form-control chosen">
						<option value="" onclick=""></option>
					</select>
				</div>
			</div>
			<div style="display:block">
				<h3	 class="tit">분석 범위</h3>
				<div class="disFlex smBtnWrap"> 
					<button class="primaryLine" onClick="clearAnalResource()" >영역 초기화</button>
					<button class="primarySearch" onClick="drawPolygon()" >그리기</button>						
				</div>
			</div>
			<div style="display:none">
				<h3 class="tit" >커널 함수</h3> 
				<div class="selectWrap">
					<div class="disFlex">
						<select class="form-control chosen" id="kernelType">
							<option value="" selected>Quadratic(기본값)</option>
							<option value="Binary">Binary</option>
							<option value="Cosine">Cosine</option>
							<option value="Distance">Distance</option>
							<option value="Epanechnikov">Epanechnikov</option>
							<option value="Gaussian">Gaussian</option>
							<option value="InverseDistance">InverseDistance</option>
							<option value="Quartic">Quartic</option>
							<option value="Triangular">Triangular</option>
							<option value="Triweight">Triweight</option>
							<option value="Tricube">Tricube</option>
						</select>
					</div>
				</div>
			</div>
			<!-- TabContent end -->
	</div>

  <!-- 검색조건 Form -->
	<form id="GISinfoForm" name="GISinfoForm"></form>
	<div class="breakLine"></div>
	<div class="disFlex smBtnWrap" style = "padding: 1.6rem;">  
		<button type="button" class="primaryLine" onclick="initAnalService()">초기화</button>
		<button type="button" class="primarySearch" onclick="onClickDensity()">분석</button>
	</div>

	<!-- 검색결과 Form -->
	<form id="GISinfoResultForm" name="GISinfoResultForm">
		<input type="hidden" name="geom[]">
	</form>
</body>
</html>