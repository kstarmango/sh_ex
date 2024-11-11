<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>
<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests"> 

<script type="text/javascript">

var dstrcBndryAllAttr  = [];
var ladUsePlanAllAttr  = [];

$(document).ready(function(){

	Array.prototype.contains = function (v) {
	    return this.indexOf(v) > -1;
	}

	$.urlParam = function(name){
	    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
	    return results[1] || 0;
	}

	$("#map-search-tab_Landlist input").click(function(){
		toggle_layersLand("SH_LM:"+$(this).prop("id"));
		$("#map-search-tab_Landlist input[id!="+$(this).prop("id")+"]").prop("checked", false);
	});
	$("#map-search-tab_Buldlist input").click(function(){
		toggle_layersBuld("SH_LM:"+$(this).prop("id"));
		$("#map-search-tab_Buldlist input[id!="+$(this).prop("id")+"]").prop("checked", false);
	});
	$("#map-search-tab_Distlist input").click(function(){
		toggle_layersDist("SH_LM:"+$(this).prop("id"));
		$("#map-search-tab_Distlist input[id!="+$(this).prop("id")+"]").prop("checked", false);
	});
	$("#map-search-tab_SHlist input").click(function(){
		toggle_layersSH("SH_LM:"+$(this).prop("id"));
		$("#map-search-tab_SHlist input[id!="+$(this).prop("id")+"]").prop("checked", false);
	});


	// WMS 추가 레이어 - 사업지구경계, 토지이용계획
	var crossOrigin 	= 'anonymous';
	var wmsVersion 		= '1.3.0';
	var wfsVersion 		= '1.1.0';
	var wfsOutputEpsg   = 'EPSG:3857';
	var wfsOutputFormat = 'application/json';
	var iLayerMinIndex  = 1000;

	function getWMSlayer2(dispName, layerNm, typeName, visible, style, min, max, zIndex) {
		if(typeName === 'undefined' || typeName === '')
			return;

		var _visible = typeof visible !== 'undefined' ? visible : false;
		var _minZoom = typeof min     !== 'undefined' ? min     : min_zoom;
		var _maxZoom = typeof max     !== 'undefined' ? max     : max_zoom;

		return new ol.layer.Tile({
					//id: ++iLayerMinIndex,
					name: layerNm,
					dispName: dispName,
					visible: _visible,
					type: 'wms',
					source: new ol.source.TileWMS({
						url: 'https://openapi.jigu.go.kr/api/layer.wms',
						params: {
							'FORMAT': 'image/png',
							'VERSION': wmsVersion,
							'LAYERS': typeName,
							'CRS': wfsOutputEpsg,
							'STYLES': style,
							'authkey': '010238638fb2a70cc377ad26e95a6f8f'
						},
						projection: wfsOutputEpsg,
						opacity: 1,
						brightness: 1,
						crossOrigin: crossOrigin
					}),
					minZoom: _minZoom - 1,
					maxZoom: _maxZoom,
					zIndex: zIndex
				});
	}

	//var dstrcBndry = getWMSlayer2('사업지구경계', 'lh_district', 'lh.dstrcBndry', true, 'dstrcLayer',  min_zoom, max_zoom, 9995);
	var dstrcBndry = getWMSlayer2('사업지구경계', 'dstrcLayer', 'dstrcLayer', true, 'dstrcLayer',  min_zoom, max_zoom, ++iLayerMinIndex);
	//dstrcBndry.setZIndex(9995);

	//var ladUsePlan = getWMSlayer2('토지이용계획', 'lh_useplan', 'lh.ladUsePlan', true, 'usePlan',  min_zoom + 2, max_zoom, 9996);
	var ladUsePlan = getWMSlayer2('토지이용계획', 'usePlan', 'usePlan', true, 'usePlan',  min_zoom + 2, max_zoom, ++iLayerMinIndex);
	//ladUsePlan.setZIndex(9996);


	// WFS 추가 레이어 - 사업지구경계, 토지이용계획
	var featureStyle = new ol.style.Style({
	  	stroke: new ol.style.Stroke({
	   		color: 'rgba(255, 255, 255, 0)',
	    	width: 0,
	  	}),
		fill: new ol.style.Fill({
	   		color: 'rgba(255, 255, 255, 0)',
	  	}),
	  	text: new ol.style.Text({
	    	font: '12px Calibri,sans-serif',
	    	stroke: new ol.style.Stroke({
	      		color: 'rgba(255, 255, 255, 0)',
	     		width: 0,
	   		}),
	    	fill: new ol.style.Fill({
	      		color: 'rgba(255, 255, 255, 0)',
	    	}),
	  	}),
	});

	var featureHighlightStyle = new ol.style.Style({
		stroke: new ol.style.Stroke({
		  	color: 'rgba(255,0,0,1)',
		  	width: 2,
		}),
		fill: new ol.style.Fill({
		  	color: 'rgba(255,0,0,0.1)',
		}),
		text: new ol.style.Text({
		  	font: '14px Calibri,sans-serif',
		  	stroke: new ol.style.Stroke({
		    	color: 'rgba(255,255,255,1)',
		    	width: 2,
		  	}),
		  	fill: new ol.style.Fill({
		    	color: 'rgba(0,0,255,1)',
		  	}),
		}),
	});

	var featureBndryLayer = new ol.layer.Vector({
	  	source: new ol.source.Vector({
	    	format: new ol.format.GeoJSON()
	  	}),
	  	style: function (feature) {
	  		featureStyle.getText().setText(feature.get('ZONENAME'));
	    	return featureStyle;
	  	},
	});
	//featureBndryLayer.setZIndex(9000);

	var featurePlanLayer = new ol.layer.Vector({
	  	source: new ol.source.Vector({
	    	format: new ol.format.GeoJSON()
	  	}),
	  	style: function (feature) {
	  		featureStyle.getText().setText(feature.get('BLOCKNAME'));
	    	return featureStyle;
	  	},
	});
	//featurePlanLayer.setZIndex(9001);

	var featureHighlightLayer = new ol.layer.Vector({
		source: new ol.source.Vector(),
	  	style: function (feature) {
	  		if(feature.get('BLOCKNAME') != undefined)
	  			featureHighlightStyle.getText().setText(feature.get('BLOCKNAME'));
	  		else if(feature.get('ZONENAME') != undefined)
	  			featureHighlightStyle.getText().setText(feature.get('ZONENAME'));

	    	return featureHighlightStyle;
	  	},
	});
	//featureHighlightLayer.setZIndex(9002);

	var highlight;
	var displayFeatureInfo = function (pixel) {
		var feature = geoMap.forEachFeatureAtPixel(pixel, function (feature) {
		  	return feature;
		});

		if (feature !== highlight) {
			if (highlight) {
				featureHighlightLayer.getSource().removeFeature(highlight);
			}
			if (feature) {
				featureHighlightLayer.getSource().addFeature(feature);

				var reader = new ol.format.GeoJSON();
				var values = feature.getProperties();
				var zoneNo = values['ZONECODE']

				if(zoneNo != undefined && ladUsePlanAllAttr.contains(zoneNo) == false) {
					$.ajax({
						type : "GET",
						async : true,
						url : 'https://openapi.jigu.go.kr/api/layer.wfs?authkey=010238638fb2a70cc377ad26e95a6f8f&format=json&layers=usePlan&crs=EPSG:3857&zonecode=' + zoneNo,
						dataType : "json",
						data : {
						},
						error : function(response, status, xhr){
							if(xhr.status =='403'){
								alert('토지이용계획 WFS 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
							}
						},
						success : function(geom) {
							if(geom.features != undefined && geom.features.length > 0) {
								//featurePlanLayer.getSource().clear();
								featurePlanLayer.getSource().addFeatures(reader.readFeatures(geom));

								ladUsePlanAllAttr.push(zoneNo);
							}
						}
					});
				}
			}
			highlight = feature;
		}
	};

	function featurePointMoveHandler(evt) {
		if (evt.dragging) {
		  	return;
		}

		var pixel = geoMap.getEventPixel(evt.originalEvent);
		var hit = geoMap.hasFeatureAtPixel(pixel);
		geoMap.getTarget().style.cursor = hit ? 'pointer' : '';

		displayFeatureInfo(pixel);

		geoMap.renderSync();
	}

	function featureClickHandler(evt) {
        geoMap.forEachFeatureAtPixel(
        	evt.pixel,
            function (feature, layer) {
                let values = feature.getProperties();
                //console.log(values);
            },
            {
                hitTolerance: 2,
                layerFilter: function(layer) {
                    return true;
                }
            }
        )
	}

	/* 그리기 이벤트와 충돌 */
	//geoMap.addLayer(featureHighlightLayer);
	//geoMap.on('pointermove', featurePointMoveHandler);
	//geoMap.un('pointermove', featurePointMoveHandler);
	//geoMap.on('click', featureClickHandler);
	//geoMap.un('click', featureClickHandler);


	// 사업지구경계 속성 로딩
	$.ajax({
		type : "GET",
		async : true,
		url : "https://openapi.jigu.go.kr/api/apiService.json?authkey=010238638fb2a70cc377ad26e95a6f8f&serviceno=3&citycd=11&dstrcno=",
		dataType : "json",
		data : {},
		error : function(response, status, xhr){
			if(xhr.status =='403'){
				alert('사업지구경계 속성 목록 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
			}
		},
		success : function(data) {
			if(data.msgCode == 0 && data.result.length > 0) {
				dstrcBndryAllAttr.push(data.result);

				for(var i=0; i < data.result.length; i++) {
					var appnNo = data.result[i].DSTRC_APPN_NO;
					var reader = new ol.format.GeoJSON();

					$.ajax({
						type : "GET",
						async : true,
						url : 'https://openapi.jigu.go.kr/api/layer.wfs?authkey=010238638fb2a70cc377ad26e95a6f8f&format=json&layers=dstrcLayer&crs=EPSG:3857&zonecode=' + appnNo,
						dataType : "json",
						data : {
						},
						error : function(response, status, xhr){
							if(xhr.status =='403'){
								alert('사업지구경계 WFS 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
							}
						},
						success : function(geom) {
							if(geom.features != undefined && geom.features.length > 0)
								featureBndryLayer.getSource().addFeatures(reader.readFeatures(geom));
						}
					});
				}
			}
		}
	});

	// 토지이용계획 속성 로딩
	/* $.ajax({
		type : "POST",
		async : false,
		url : "https://openapi.jigu.go.kr/api/apiService.json?authkey=010238638fb2a70cc377ad26e95a6f8f&serviceno=11&citycd=11&dstrcno=",
		dataType : "json",
		data : {},
		error : function(response, status, xhr){
			if(xhr.status =='403'){
				alert('토지이용계획 속성 목록 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
			}
		},
		success : function(data) {
			if(data.msgCode == 0 && data.result.length > 0) {
				ladUsePlanAllAttr.push(data.result);

				var reader = new ol.format.GeoJSON();
				for(var i=0; i < data.result.length; i++) {
					var appnNo = data.result[i].DSTRC_APPN_NO;

					$.ajax({
						type : "GET",
						async : true,
						url : 'https://openapi.jigu.go.kr/api/layer.wfs?authkey=010238638fb2a70cc377ad26e95a6f8f&format=json&layers=lh.ladUsePlan&crs=EPSG:3857&zonecode=' + appnNo,
						dataType : "json",
						data : {
						},
						error : function(response, status, xhr){
							if(xhr.status =='403'){
								alert('토지이용계획 WFS 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
							}
						},
						success : function(geom) {
							if(geom.features != undefined && geom.features.length > 0)
								featurePlanLayer.getSource().addFeatures(reader.readFeatures(geom));
						}
					});
				}
			}
		}
	}); */

	function fn_lh_district_layer() {
		if($("#lh_district").prop("checked") == true) {
			console.log("들어옴");
			geoMap.addLayer(dstrcBndry);
			geoMap.addLayer(featureBndryLayer);

			var layer_no = $(this).attr('data-layer-no');
			//console.log(layer_no);

			layerUseLog(layer_no);
		} else {
			geoMap.removeLayer(dstrcBndry);
			geoMap.removeLayer(featureBndryLayer);
		}
	}

	function fn_lh_useplan_layer(){
		if($("#lh_useplan").prop("checked") == true) {
			geoMap.addLayer(ladUsePlan);
			geoMap.addLayer(featurePlanLayer);

			var layer_no = $(this).attr('data-layer-no');
			//console.log(layer_no);

			layerUseLog(layer_no);
		} else {
			geoMap.removeLayer(ladUsePlan);
			geoMap.removeLayer(featurePlanLayer);
		}
	}

	// 레이어 정보
	$.ajax({
	    type : "POST",
	    url : "<%= RequestMappingConstants.WEB_GIS_LAYER_BY_AUTH %>",
	    processData: false,
	    contentType: false,
		error : function(response, status, xhr){
			if(xhr.status =='403'){
				alert('레이어 목록 요청을  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
			}
		},
		success: function(data) {
			if(data.result == 'Y' && data.layerInfo != '') {
				
			
				var prevGrpnNm = '';
				var strHtml = '';

				$('#map-layerlist').empty();
				for(i=0; i<data.layerInfo.length; i++) {
					var group_level = data.layerInfo[i].level;
					var group_nm    = data.layerInfo[i].grp_nm;
					var group_no    = data.layerInfo[i].grp_no;
					var p_group_no  = data.layerInfo[i].p_grp_no;
					var layer_no         = data.layerInfo[i].layer_no;
					var layer_cntc_yn    = data.layerInfo[i].cntc_yn;
					var layer_down_yn    = data.layerInfo[i].down_yn;
					var layer_dp_nm      =  data.layerInfo[i].layer_dp_nm;
					var layer_tp_nm      = data.layerInfo[i].layer_tp_nm;
					var layer_style_nm   = data.layerInfo[i].layer_style_nm;
					var layer_table_nm   = data.layerInfo[i].table_nm;
					var layer_attrb_nm   = data.layerInfo[i].layer_attrb_nm;
					var server_nm        = data.layerInfo[i].server_nm;
					var server_url       = data.layerInfo[i].server_url;
					var server_workspace = data.layerInfo[i].workspace;
					var check_url        = data.layerInfo[i].check_url;
					var download_url     = data.layerInfo[i].download_url;
					
					var ins_dt = data.layerInfo[i].ins_dt;
					var upd_dt = data.layerInfo[i].upd_dt;
					
					
					
					

					//타임스탬프 사이트 변환(https://www.epochconverter.com/)
					// 1680402492000 23.04.03일 업데이트
					//  1682829050000 23년4월30일 기준 2차데이터 -> 표시 다르게 하기
					//  1698796800000 23년11월01일 기준 23년도 상반기 데이터 업데이트
					/* console.log("intdt :" + ins_dt.time);
					console.log("up_dt :" + upd_dt.time); */

					if(group_level == '0') {
					

						if(prevGrpnNm != group_nm)
							strHtml += '<h3 class="title-legend">' + group_nm + '</h3>';

							if(layer_no != '') {
								strHtml += '	<div class="row-white" data-group-no="' + group_no + '" data-parent-group-no="' + p_group_no + '" data-layer-no="' + layer_no + '">';
								
								if(ins_dt.time >= 1698796800000){
									strHtml += '<span style="position: absolute; left: 1px; font-size: 12px; color:red ">new</span>'
									}
									else if(upd_dt.time >= 1698796800000 && ins_dt.time<1698796800000){
									strHtml += '<span style="position: absolute; left: 1px; font-size: 12px; color:blue ">update</span>'
									}
								
							/* //new 표출
							if(ins_dt.time >= 1680402492000 && ins_dt.time < 1682829050000){  
								strHtml += '<span style="position: absolute; left: 1px; font-size: 12px; color:red ">new</span>'
							}else if(ins_dt.time >= 1682829050000){ //22하반기분 2차작업_임시(23년4월30일 이후)
								strHtml += '<span style="position: absolute; left: 1px; font-size: 12px; color:darkred ">new</span>'
							}
							//update표출
							if(upd_dt.time >= 1680402492000 && ins_dt.time<1680402492000 && upd_dt.time < 1682829050000){
								strHtml += '<span style="position: absolute; left: 1px; font-size: 12px; color:blue ">update</span>'
							}else if(upd_dt.time >= 1682829050000 && ins_dt.time<1680402492000){ //22하반기분 2차작업_임시(23년4월30일 이후)
								strHtml += '<span style="position: absolute; left: 1px; font-size: 12px; color:#808080">update</span>'
							} */
						
						   
						  
							if(layer_cntc_yn == 'Y' || (layer_table_nm != null && layer_table_nm != '' && layer_cntc_yn == 'N')) {
							strHtml += '		<span style="float:left; display: inline-block; width: ' + (group_level * 20 + 20)+ 'px; height:20px;"></span>';
							} else {
							strHtml += '		<span style="float:left; display: inline-block; width: ' + (group_level * 20 + 20 + 20)+ 'px; height:20px;"></span>';
							}

							strHtml += '		<span style="float:left;">';

							if((layer_table_nm == null || layer_table_nm == '') && layer_cntc_yn == 'Y') {
							strHtml += '			<i class="fa fa-cloud-download i_style" aria-hidden="true" style="color:#0e3b4e; vertical-align:bottom; float:left;"></i>';
							}

							if(layer_table_nm != null && layer_table_nm != '' && layer_cntc_yn == 'N') {
							strHtml += '			<i class="fa fa-table i_style" aria-hidden="true" style="color:#0e3b4e; vertical-align:bottom; float:left;"></i>';
							}
							
							strHtml += '			<p>' + layer_dp_nm + '</p>';
							strHtml += '		</span>';
							strHtml += '		<div class="function-legend">';
							strHtml += '			<span class="i_btn_wrap">';

							if(layer_down_yn == 'Y' && layer_cntc_yn == 'N') {
							//strHtml += "				<i class='fa fa-download i_btn_wrap btn_download' aria-hidden='true' onclick=\"fn_shape_download('" +  server_url + "', '" + server_workspace + ":" + layer_tp_nm + "', 'shape-zip', 'EPSG:5174');\"></i>";
							strHtml += "				<i class='fa fa-download i_btn_wrap btn_download' aria-hidden='true'  data-layer-no='" + layer_no + "' data-server-url='" +  server_url + "' data-layer-tp-nm='" + server_workspace + ":" + layer_tp_nm + "' data-output-format='shape-zip' data-output-epsg='EPSG:4326'></i>";
							} else if(layer_down_yn == 'N' && layer_cntc_yn == 'N') {
								strHtml += "				<i class='fa fa-download i_btn_wrap btn_download' aria-hidden='true'></i>";
							}

							//strHtml += "				<i class='fa fa-question i_btn_wrap btn_question' aria-hidden='true' onclick=\"fn_layer_desc_show('" +  layer_dp_nm + "', '" + layer_no + "');\"></i>";
							strHtml += "				<i class='fa fa-question i_btn_wrap btn_question' aria-hidden='true' data-layer-dp-nm='" +  layer_dp_nm + "' data-layer-no='" + layer_no + "'></i>";
							strHtml += '			</span>';
							strHtml += '			<div class="add-on">';
							strHtml += '				<div class="material-switch pull-right">';
							strHtml += '					<input type="checkbox" id="' + layer_tp_nm + '" name="' + layer_tp_nm + '" data-group-no="' + group_no + '" data-layer-dp-nm="' +  layer_dp_nm + '" data-layer-no="' + layer_no + '" data-layer-cntc="' + layer_cntc_yn + '" data-layer-table-nm="' + layer_table_nm + '" data-layer-attrb-nm="' + layer_attrb_nm + '" data-server-nm="' + server_nm + '" data-server-url="' + server_url + '" data-server-workspaces="' + server_workspace + '" data-check-url="' + check_url + '" data-download-url="' + download_url + '">';
							strHtml += '					<label for="' + layer_tp_nm + '" class="label-primary"></label>';
							strHtml += '				</div>';
							strHtml += '			</div>';
							strHtml += '			<div class="line-remove" style="display: none"><span></span></div>';
							strHtml += '			<div class="icon-plus"><span></span><span></span></div>';
							strHtml += '		</div>';
							strHtml += '		<div class="clear"></div>';
							strHtml += '	</div>';

							strHtml += '	<div class="list-answer" style="display: none;" data-group-no="' + group_no + '" data-parent-group-no="' + p_group_no + '" data-layer-no="' + layer_no + '">';
							strHtml +=      layer_style_nm;
							strHtml += '	</div>';
						}

					} else {

						if(prevGrpnNm != group_nm) {
							strHtml += '	<div class="row-white" data-group-no="' + group_no + '" data-parent-group-no="' + p_group_no + '" data-layer-no="">';
							strHtml += '		<span style="float:left; display: inline-block; width: ' + ((group_level - 1) * 20 + 20)+ 'px; height:20px;"></span>';
							strHtml += '		<span style="float:left;">';
							strHtml += '			<b>' + group_nm + '</b>';
							strHtml += '		</span>';
							strHtml += '		<div class="function-legend">';
							strHtml += '			<div class="line-remove" style="display: none"><span></span></div>';
							strHtml += '			<div class="icon-plus"><span></span><span></span></div>';
							strHtml += '		</div>';
							strHtml += '		<div class="clear"></div>';
							strHtml += '	</div>';
						}

						if(layer_no != '') {
							strHtml += '	<div class="row-white" data-group-no="' + group_no + '" data-parent-group-no="' + p_group_no + '" data-layer-no="' + layer_no + '">';

							if(layer_cntc_yn == 'Y' || (layer_table_nm != null && layer_table_nm != '' && layer_cntc_yn == 'N')) {
							strHtml += '		<span style="float:left; display: inline-block; width: ' + (group_level * 20 + 20)+ 'px; height:20px;"></span>';
							} else {
							strHtml += '		<span style="float:left; display: inline-block; width: ' + (group_level * 20 + 20 + 20)+ 'px; height:20px;"></span>';
							}

							strHtml += '		<span style="float:left;">';

							if((layer_table_nm == null || layer_table_nm == '') && layer_cntc_yn == 'Y') {
							strHtml += '			<i class="fa fa-cloud-download i_style" aria-hidden="true" style="color:#0e3b4e; vertical-align:bottom; float:left;"></i>';
							}

							if(layer_table_nm != null && layer_table_nm != '' && layer_cntc_yn == 'N') {
							strHtml += '			<i class="fa fa-table i_style" aria-hidden="true" style="color:#0e3b4e; vertical-align:bottom; float:left;"></i>';
							}

							strHtml += '			<p>' + layer_dp_nm + '</p>';
							strHtml += '		</span>';
							strHtml += '		<div class="function-legend">';
							strHtml += '			<span class="i_btn_wrap">';

							if(layer_down_yn == 'Y' && layer_cntc_yn == 'N') {
							//strHtml += "				<i class='fa fa-download i_btn_wrap btn_download' aria-hidden='true' onclick=\"fn_shape_download('" +  server_url + "', '" + server_workspace + ":" + layer_tp_nm + "', 'shape-zip', 'EPSG:5174');\"></i>";
							strHtml += "				<i class='fa fa-download i_btn_wrap btn_download' aria-hidden='true' data-layer-no='" + layer_no + "' data-server-url='" +  server_url + "' data-layer-tp-nm='" + server_workspace + ":" + layer_tp_nm + "' data-output-format='shape-zip' data-output-epsg='EPSG:4326'></i>";
							} else if(layer_down_yn == 'N' && layer_cntc_yn == 'N') {
							strHtml += "				<i class='fa fa-download i_btn_wrap btn_download' aria-hidden='true'></i>";
							}

							//strHtml += "				<i class='fa fa-question i_btn_wrap btn_question' aria-hidden='true' onclick=\"fn_layer_desc_show('" +  layer_dp_nm + "', '" + layer_no + "');\"></i>";
							strHtml += "				<i class='fa fa-question i_btn_wrap btn_question' aria-hidden='true' data-layer-dp-nm='" +  layer_dp_nm + "' data-layer-no='" + layer_no + "'></i>";
							strHtml += '			</span>';
							strHtml += '			<div class="add-on">';
							strHtml += '				<div class="material-switch pull-right">';
							strHtml += '					<input type="checkbox" id="' + layer_tp_nm + '" name="' + layer_tp_nm + '" data-group-no="' + group_no + '" data-layer-dp-nm="' +  layer_dp_nm + '" data-layer-no="' + layer_no + '" data-layer-cntc="' + layer_cntc_yn + '" data-layer-table-nm="' + layer_table_nm + '" data-layer-attrb-nm="' + layer_attrb_nm + '" data-server-nm="' + server_nm + '" data-server-url="' + server_url + '" data-server-workspaces="' + server_workspace + '" data-check-url="' + check_url + '" data-download-url="' + download_url + '">';
							strHtml += '					<label for="' + layer_tp_nm + '" class="label-primary"></label>';
							strHtml += '				</div>';
							strHtml += '			</div>';
							strHtml += '			<div class="line-remove" style="display: none"><span></span></div>';
							strHtml += '			<div class="icon-plus"><span></span><span></span></div>';
							strHtml += '		</div>';
							strHtml += '		<div class="clear"></div>';
							strHtml += '	</div>';

							strHtml += '	<div class="list-answer" style="display: none;" data-group-no="' + group_no + '" data-parent-group-no="' + p_group_no + '" data-layer-no="' + layer_no + '">';
							strHtml +=      layer_style_nm;
							strHtml += '	</div>';
						}
					}

					prevGrpnNm = group_nm;
				}

				// 전체 레이어 화면 표출
				$('#map-layerlist').append(strHtml);

				// 레이어  ON/OFF
				$('#map-layerlist input').click(fn_layer_onoff);

				// 레이어 다운로드
				$('.btn_download').click(fn_shape_download);

				// 레이어 설명 팝업
				$('.btn_question').click(fn_layer_desc_show);

				// 레이어 레전드 ON/OFF
				$('.row-white').slideDown();
				$('.icon-plus, .line-remove').click(fn_layer_legend_onoff);

				// 택지지구경계 레이어
				$("#lh_district").click(fn_lh_district_layer);

				// 토지이용계획 레이어
				$("#lh_useplan").click(fn_lh_useplan_layer);

				// 빈집 외부 연계시
				var apiParam = new URLSearchParams('${apiParam}');
				if(apiParam != '' && apiParam.get('apiKey') != '') {
					// 자동 ON 레이어 목록
					$.ajax({
					    type : "POST",
					    url : "<%= RequestMappingConstants.WEB_GIS_LAYER_BY_APIKEY %>",
						async : true,
						dataType : "json",
						data : {},
						error : function(response, status, xhr){
							if(xhr.status =='403'){
								alert('레이어 목록 요청을  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
							}
						},
						success: function(data) {
							if(data.result == 'Y' && data.layerInfo != '') {
								console.log("레이어정보!!")
								//console.log(data.layerInfo);
								for(i=0; i<data.layerInfo.length; i++) {
									$("#" + data.layerInfo[i].layer_tp_nm).trigger('click');

									if(data.layerInfo[i].bass_yn == 'Y' && apiParam.get(data.layerInfo[i].paramtr) != '') {
										// 자동 ZOOM 객체 검색 및 이동
										var featureRequest = new ol.format.WFS().writeGetFeature({
											srsName: 'EPSG:3857',
											featurePrefix: 'LANDSYS',
											featureTypes: [ data.layerInfo[i].layer_tp_nm ],
											outputFormat: 'application/json',
											filter: ol.format.filter.equalTo(data.layerInfo[i].paramtr, apiParam.get(data.layerInfo[i].paramtr))
										});

										$.ajax({
											type: 'POST',
											url: data.layerInfo[i].server_url + '/wfs',
											async: true,
											contentType: 'xml',
											data: new XMLSerializer().serializeToString(featureRequest),
											error : function(response, status, xhr){
												if(xhr.status =='403'){
													alert('데이터 검색 요청을  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
												}
											},
											success: function(data) {
												if(data != null) {
													if(data.features != undefined && data.features.length > 0) {
														//console.log(data);

														fn_gis_map_draw_geojson(data);
													}
												}
											}
										});
									}
								}
							}
						}
					});
				}
			}
		}
	});

	// 레이어 설명편집
	$('#layer_desc_info_edit').click(function() {
		//.replaceAll("'", "&#39;").replaceAll("\"", "&#34;") -> 따옴표 치환
		$('#layer_desc_data_nm').html('<input type="hidden" value="' + $('#layer_desc_data_nm').text().replaceAll("'", "&#39;").replaceAll("\"", "&#34;") + '" name="edit_desc_data_nm">');
		$('#layer_desc_data_desc').html('<input type="hidden" value="' + $('#layer_desc_data_desc').text().replaceAll("'", "&#39;").replaceAll("\"", "&#34;") + '" name="edit_desc_data_desc">');
		$('#layer_desc_data_origin').html('<input type="hidden" value="' + $('#layer_desc_data_origin').text().replaceAll("'", "&#39;").replaceAll("\"", "&#34;") + '" name="edit_desc_data_origin">');
		$('#layer_desc_data_stdde').html('<input type="hidden" value="' + $('#layer_desc_data_stdde').text().replaceAll("'", "&#39;").replaceAll("\"", "&#34;") + '" name="edit_desc_data_stdde">');
		$('#layer_desc_data_upd_cycle').html('<input type="hidden" value="' + $('#layer_desc_data_upd_cycle').text().replaceAll("'", "&#39;").replaceAll("\"", "&#34;") + '" name="edit_desc_data_upd_cycle">');
		$('#layer_desc_data_rm').html('<input type="hidden" value="' + $('#layer_desc_data_rm').text().replaceAll("'", "&#39;").replaceAll("\"", "&#34;") + '" name="edit_desc_data_rm">');

		$('input[name*="edit_desc_data"]').prop('type', 'text');

		$('#layer_desc_info_edit').hide();  //속성편집 버튼 hide
		$('#layer_desc_info_save').show();
		$('#layer_desc_info_cancel').show();
	});

	$('#layer_desc_info_save').click(function() {
		var desc_no = $('#edit_desc_no').val();
    	var req_url = (desc_no == '' ? "<%=RequestMappingConstants.WEB_GIS_LAYER_DESC_ADD%>" : "<%=RequestMappingConstants.WEB_GIS_LAYER_DESC_EDIT%>");
		
		$.ajax({
		    type : "POST",
			async : false,
		    url : req_url,
			dataType : "json",
		    data : jQuery("#layerDescEditForm").serialize(),
			error : function(response, status, xhr){
				if(xhr.status =='403'){
					alert('레이어 설명 업데이틀  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
				}
			},
			success: function(data) {
				if(data.result == 'Y') {
					$('#layer_desc_info').hide();
					alert('정보 변경이 정상적으로 완료 되었습니다.');
				}
			}
		})
	});

	$('#layer_desc_info_close, #layer_desc_info_cancel').click(function() {
		$('input[name*="edit_desc_data"]').remove();
		$('#layer_desc_info').hide();
	});
});

//2020 추가 - 레이어  ON/OFF
function fn_layer_onoff() {
	//console.log($(this));
	

	
	var layer_nm = $(this).attr('id');
	var layer_no = $(this).attr('data-layer-no');
	var layer_cntc = $(this).attr('data-layer-cntc');
	var server_nm  = $(this).attr('data-server-nm');
	var server_url = $(this).attr('data-server-url');
	var workspaces = $(this).attr('data-server-workspaces');
	
	if(layer_nm != 'lh_district' && layer_nm != 'lh_useplan') {
		if($(this).is(":checked") == true) {
			if(server_nm != '' && server_nm == 'VWORLD') {
				geoMap.addLayer( get_vWorldMap(layer_nm, layer_nm) );
			} else {
				layer_url = server_url + '/';
				console.log("layer_nm : ", layer_nm);
				var addLayer = get_WMSlayer(layer_nm);
				addLayer.setZIndex(9900);
				
				
				geoMap.addLayer( addLayer );
				
				// 추가 레이어 ON
				$.ajax({
					type : "POST",
					async : true,
					url : "<%=RequestMappingConstants.WEB_GIS_LAYER_ADDITIONAL%>",
					dataType : "json",
					data : {
						layer_no: layer_no
					},
					error : function(response, status, xhr){
						if(xhr.status =='403'){
							alert('레이어 조회 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
						}
					},
					success : function(data) {
						if(data.layerInfo != undefined && data.layerInfo.length > 0) {
							for(i=0; i<data.layerInfo.length; i++) {
							
								var newLayer = get_WMSlayer(data.layerInfo[i].layer_tp_nm);
								newLayer.setZIndex(9900);

								geoMap.addLayer( newLayer );
							}
						}
					}
				});

				if(layer_cntc == 'N') {
					fn_layer_legend(layer_no, server_url, workspaces, layer_nm);
				}
			}

			layerUseLog(layer_no);
		} else {
			// 추가 레이어 OFF
			$.ajax({
				type : "POST",
				async : true,
				url : "<%=RequestMappingConstants.WEB_GIS_LAYER_ADDITIONAL%>",
				dataType : "json",
				data : {
					layer_no: layer_no
				},
				error : function(response, status, xhr){
					if(xhr.status =='403'){
						alert('레이어 조회 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
					}
				},
				success : function(data) {
					if(data.layerInfo != undefined && data.layerInfo.length > 0) {
						for(i=0; i<data.layerInfo.length; i++) {
							geoMap.getLayers().forEach(function (v) {
								if (v.get('name') == data.layerInfo[i].layer_tp_nm){
									geoMap.removeLayer(v)
								}
							});
						}
					}
				}
			});

			geoMap.getLayers().forEach(function (v) {
				if (v.get('name') == layer_nm){
					geoMap.removeLayer(v)
				}
			});
		}
	}
}

//2020 추가 - 레이어 다운로드
function fn_shape_download() {
	var url    = $(this).attr('data-server-url');
	var name   = $(this).attr('data-layer-tp-nm');
	var format = $(this).attr('data-output-format');
	var epsg   = $(this).attr('data-output-epsg');
	var url    = url + '/wfs?request=GetFeature&version=1.1.0&typeName=' + name + '&outputFormat=' + format + '&srsName=' + epsg + '&format_options=CHARSET:EUC-KR';

	if(name == undefined || name == '') {
		alert('다운로드 권한이 없습니다.\n\n관리자에게 문의하시길 바랍니다.')
		return;
	} else {
		window.open(url, '_blank');

		var layer_no    = $(this).attr('data-layer-no');
		downUseLog(layer_no);
	}
}

//2020 추가 - 레이어 설명 팝업
function fn_layer_desc_show() {
	var nm = $(this).attr('data-layer-dp-nm');
	var no = $(this).attr('data-layer-no');

	$.ajax({
		type : "POST",
		async : false,
		url : "<%=RequestMappingConstants.WEB_GIS_LAYER_DESC%>",
		dataType : "json",
		data : {
			layerNo: no
		},
		error : function(response, status, xhr){
			if(xhr.status =='403'){
				alert('레이어 설명 조회 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
			}
		},
		success : function(data) {
			if(data.result == 'Y' && data.descInfo != undefined) {
				//console.log(data);

				$('#edit_desc_no').val(data.descInfo.desc_no);
				$('#edit_desc_layer_no').val(no);
				$('#layer_desc_layer_nm').html(nm);
				$('#layer_desc_data_nm').html(data.descInfo.data_nm);
				$('#layer_desc_data_desc').html(data.descInfo.data_desc);
				$('#layer_desc_data_origin').html(data.descInfo.data_origin);
				$('#layer_desc_data_stdde').html(data.descInfo.data_stdde);
				$('#layer_desc_data_upd_cycle').html(data.descInfo.data_upd_cycle);
				$('#layer_desc_data_rm').html(data.descInfo.data_rm);

				if(data.descEditEable == 'Y') {
					$('#layer_desc_info_edit').show()
				}
				$('#layer_desc_info_save').hide();
				$('#layer_desc_info_cancel').hide();

				$('#layer_desc_info').show();
			} else {
				$('#edit_desc_no').val('');
				$('#edit_desc_layer_no').val(no);
				$('#layer_desc_layer_nm').text(nm);
				$('#layer_desc_data_nm').text('');
				$('#layer_desc_data_desc').text('');
				$('#layer_desc_data_origin').text('');
				$('#layer_desc_data_stdde').text('');
				$('#layer_desc_data_upd_cycle').text('');
				$('#layer_desc_data_rm').text('');

				if(data.descEditEable == 'Y') {
					$('#layer_desc_info_edit').show();
				}

				$('#layer_desc_info_save').hide();
				$('#layer_desc_info_cancel').hide();

				$('#layer_desc_info').show();

				alert('검색 결과가 없습니다.')
			}
		}
	});
}

//2020 추가 - 레이어 레전드
function fn_layer_legend(layer_no, server_url, workspaces, layer_nm) {
	
	$.ajax({
	    typ: 'GET',
	    url: '<%= RequestMappingConstants.WEB_GIS_LAYER_STYLE %>',
	    data: {
	    	workspaces: workspaces,
	    	style: layer_nm
	    },
	    dataType: 'json',
	    success: function(data) {
			//console.log(data.styleInfo);
			
	    	$("#map-layerlist .list-answer").each(function() {
				if($(this).attr('data-layer-no') == layer_no) {
					strHtml = '';

					$(this).html(strHtml);
					strHtml += '<ul class="row-grey" style="margin-top:5px; margin-left:65px;">';
					//이름동일하면 한번만 출력 240415
					var seenNames = {};
					for(i=0; i<data.styleInfo.length;i++) {
						 var currentItem = data.styleInfo[i];
						 if (!seenNames[currentItem]) {
						        seenNames[currentItem] = true;   // 이름이 처음 보이는 경우에만 처리
						        // 이미지 및 레이블 추가
						        strHtml += '  <li><img src="' + server_url + '/wms?service=WMS&version=1.1.0&request=GetLegendGraphic&layer=' + workspaces + ':' + layer_nm +  '&format=image/png&width=30&height=18&legend_options=bgColor:0xf5f5f5&forcelabels:off&rule=' + currentItem + '">&nbsp;<label style="margin-bottom: 0px;">' + currentItem + '</label></li>';
						    }
						//strHtml += '  <li><img src="' + server_url + '/wms?service=WMS&version=1.1.0&request=GetLegendGraphic&layer=' + workspaces + ':' + layer_nm +  '&format=image/png&width=30&height=18&legend_options=bgColor:0xf5f5f5&forcelabels:off&rule=' + data.styleInfo[i] + '">&nbsp;<label style="margin-bottom: 0px;">' + data.styleInfo[i] + '</label></li>';
					}
					strHtml += '</ul>';
					$(this).html(strHtml);
				}
			});
	    }
	});
}

//2020 추가 - 레이어 레전드 ON/OFF
function fn_layer_legend_onoff() {
	var grp_no   = $(this).parent().parent().attr('data-group-no');
	var p_grp_no = $(this).parent().parent().attr('data-parent-group-no');
	var layer_no = $(this).parent().parent().attr('data-layer-no');

	if(layer_no != '') {
		console.log("여기임");
		// 레전드 이미지
		var $layer   = $("#map-layerlist input[data-layer-no="+layer_no+"]");
		var layer_nm = $layer.attr('id');
		var layer_cntc = $layer.attr('data-layer-cntc');
		var server_url = $layer.attr('data-server-url');
		var workspaces = $layer.attr('data-server-workspaces');

		if(layer_cntc == 'N') {   
		  //console.log(layer_cntc, layer_no, server_url, workspaces, layer_nm)

			fn_layer_legend(layer_no, server_url, workspaces, layer_nm)
		}

		// -,+ 토글
		if($(this).parent().parent().next().css('display') == 'none') {
			$(this).parent().parent().find('.line-remove').css('display', 'inline-block');
			$(this).parent().parent().find('.icon-plus').css('display', 'none');

		} else {
			$(this).parent().parent().find('.line-remove').css('display', 'none');
			$(this).parent().parent().find('.icon-plus').css('display', 'inline-block');
		}

		// 레전드 토글
		$(this).parent().parent().next().slideToggle();
	} else if(p_grp_no != '') {
		// 레전드 이미지
		var $layers   = $("#map-layerlist input[data-group-no="+grp_no+"]");
		for(i=0; i<$layers.length; i++) {
			var layer_nm = $($layers[i]).attr('id');
			var layer_cntc = $($layers[i]).attr('data-layer-cntc');
			var server_url = $($layers[i]).attr('data-server-url');
			var workspaces = $($layers[i]).attr('data-server-workspaces');

			if(layer_cntc == 'N') {
				//console.log(layer_cntc, layer_no, layer_nm, server_url, workspaces)

				fn_layer_legend($($layers[i]).attr('data-layer-no'), server_url, workspaces, layer_nm)
			}
		}

		// -,+ 토글
		if($(this).hasClass('line-remove')) {
			$(this).parent().parent().find('.line-remove').css('display', 'none');
			$(this).parent().parent().find('.icon-plus').css('display', 'inline-block');
		} else {
			$(this).parent().parent().find('.line-remove').css('display', 'inline-block');
			$(this).parent().parent().find('.icon-plus').css('display', 'none');
		}

		$("[data-group-no="+grp_no+"]").each(function() {
			if($(this).hasClass('list-answer')) {
				// -,+ 토글
				if($(this).css('display') == 'block') {
					$(this).prev().find('.line-remove').css('display', 'none');
					$(this).prev().find('.icon-plus').css('display', 'inline-block');
				} else {
					$(this).prev().find('.line-remove').css('display', 'inline-block');
					$(this).prev().find('.icon-plus').css('display', 'none');
				}

				// 레전드 토글
				$(this).slideToggle();
			}
		})
	}
}

//2020 추가
function searchLayersNameNew() {
	var nm = $('#Layers_nm').val();
	if( nm != ""){
		$("#map-search-tab_keyword").text("\""+nm+"\"");
	}else{
		$("#map-search-tab_keyword").text("");
	}

	$.ajax({
		type : "POST",
		async : false,
		url : "<%=RequestMappingConstants.WEB_GIS_LAYER_LIST%>",
		dataType : "json",
		data : {
			layerNm: nm
		},
		error : function(response, status, xhr){
			if(xhr.status =='403'){
				alert('검색 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
			}
		},
		success : function(data) {
			if(data.result == 'Y' && data.layerInfo.length > 0) {
				//console.log(data.headEngInfo, data.headKorInfo)
				//console.log(data.layerInfo);

				fn_search_layer_list_mini_show('레이어', 'layer_no', data.headEngInfo, data.headKorInfo, data.layerInfo);
			} else {
				alert('검색 결과가 없습니다.')
			}
		}
	});
}


//검색 버튼
function searchLayersName() {
	var nm = $('#Layers_nm').val();
	if( nm != ""){
		$("#map-search-tab_keyword").text("\""+nm+"\"");
	}else{
		$("#map-search-tab_keyword").text("전체리스트");
	}

	$("#map-search-tab_Landlist input, #map-search-tab_Buldlist input, #map-search-tab_Distlist input, #map-search-tab_SHlist input").parent().parent("div").hide();
	$("#map-search-tab_Landlist label:contains('"+nm+"')").parent().parent("div").show();
	$("#map-search-tab_Buldlist label:contains('"+nm+"')").parent().parent("div").show();
	$("#map-search-tab_Distlist label:contains('"+nm+"')").parent().parent("div").show();
	$("#map-search-tab_SHlist label:contains('"+nm+"')").parent().parent("div").show();
}

//주제도 오버레이
var now_layersLand = null;
var now_layersLand_nm = null;
function toggle_layersLand(layers_nm, style){
	if( now_layersLand != null ){
		geoMap.removeLayer(now_layersLand);
	}
	if( now_layersLand_nm == layers_nm ){
		now_layersLand_nm = null;
	}else{
		now_layersLand_nm = layers_nm;
		if(style != null){
			now_layersLand = get_vWorldMap(now_layersLand_nm, style);
		}else{
			now_layersLand = get_WMSlayer(now_layersLand_nm);
		}
		geoMap.addLayer(now_layersLand);
// 		now_layersLand.setOpacity(parseFloat(0.7));
	}
}
var now_layersBuld = null;
var now_layersBuld_nm = null;
function toggle_layersBuld(layers_nm, style){
	if( now_layersBuld != null ){
		geoMap.removeLayer(now_layersBuld);
	}
	if( now_layersBuld_nm == layers_nm ){
		now_layersBuld_nm = null;
	}else{
		now_layersBuld_nm = layers_nm;
		if(style != null){
			now_layersBuld = get_vWorldMap(now_layersBuld_nm, style);
		}else{
			now_layersBuld = get_WMSlayer(now_layersBuld_nm);
		}
		geoMap.addLayer(now_layersBuld);
// 		now_layersBuld.setOpacity(parseFloat(0.7));
	}
}
var now_layersDist = null;
var now_layersDist_nm = null;
function toggle_layersDist(layers_nm, style){
	if( now_layersDist != null ){
		geoMap.removeLayer(now_layersDist);
	}
	if( now_layersDist_nm == layers_nm ){
		now_layersDist_nm = null;
	}else{
		now_layersDist_nm = layers_nm;
		if(style != null){
			now_layersDist = get_vWorldMap(now_layersDist_nm, style);
		}else{
			now_layersDist = get_WMSlayer(now_layersDist_nm);
		}
		geoMap.addLayer(now_layersDist);
// 		now_layersDist.setOpacity(parseFloat(0.7));
	}
}
var now_layersSH = null;
var now_layersSH_nm = null;
function toggle_layersSH(layers_nm, style){
	if( now_layersSH != null ){
		geoMap.removeLayer(now_layersSH);
	}
	if( now_layersSH_nm == layers_nm ){
		now_layersSH_nm = null;
	}else{
		now_layersSH_nm = layers_nm;
		if(style != null){
			now_layersSH = get_vWorldMap(now_layersSH_nm, style);
		}else{
			now_layersSH = get_WMSlayer(now_layersSH_nm);
		}
		geoMap.addLayer(now_layersSH);
		now_layersSH.setOpacity(parseFloat(0.7));
	}
}

</script>

		<div class="tab-pane fade toptab active in" role="tabpanel" id="map-search-tab">
            <div class="pane-content map">
				<div class="tab-content map tabintab" style='top: 0px;'>
                    <div role="tabpanel" class="tab-pane active search-result-list" style='top:0px;'>
                        <div class="list-group-wrap in-asset">
			            	<div id="legend" class="legend open sma-legend">
								<div class="legend-content">
									<div class="sma-it-legend" id='map-layerlist'>
									</div>
								</div>
							</div>
                        </div>
                    </div>
				</div>
            </div>

            <!-- <div class="icon_info">
				<span>
					<i class="fa fa-table i_style" aria-hidden="true" style="color:#0e3b4e; vertical-align:bottom; float:left;"></i>속성존재
				</span>
				<span>
					<i class="fa fa-cloud-download i_style" aria-hidden="true" style="color:#0e3b4e; vertical-align:bottom; float:left;"></i>
				API연계
				</span>
			</div> -->

			<div class="btn-wrap tab text-right">
            	<div class="input-group input-group-sm">
                    <input type="text" class="form-control" placeholder="레이어명 입력" id="Layers_nm" onkeypress="if(event.keyCode==13) {searchLayersName();}">
                    <span class="input-group-btn">
                        <!-- <button class="btn btn-teal btn-sm" onclick="searchLayersName()">검색</button> -->
                        <button class="btn btn-teal btn-sm" onclick="searchLayersNameNew()">검색</button>
                    </span>
                </div>
            </div>

        </div>

		<!-- 레이어설명 Side-Panel -->
		<div class="open-info" id="layer_desc_info" style="display:none; position:absolute; width: 410px; top: 0px">
		    <div class="title" style="overflow: hidden;background: #eff6fa; padding:4px 0;">
		        <h3><span id='layer_desc_layer_nm'></span></h3>
		        <button style="margin-right: 32px;float: right; display: none;" class="btn btn-teal btn-sm" id='layer_desc_info_edit'>속성편집</button>
		        <a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" style="cursor: pointer" id='layer_desc_info_close'></a>
		    </div>
		    <form class="clearfix" id="layerDescEditForm" name="layerDescEditForm">
		    <input type='hidden' id='edit_desc_no' name='edit_desc_no'>
		    <input type='hidden' id='edit_desc_layer_no' name='edit_desc_layer_no'>
		    <div class="text">
		        <table class="table table-custom table-cen table-num text-center" width="100%">
		            <colgroup>
		                <col width="30%">
		                <col width="70%">
		            </colgroup>
		            <tbody>
		                <tr>
		                    <th scope="row">데이터명</th>
		                    <td style="vertical-align:center;" id='layer_desc_data_nm'></td>
		                </tr>
		                <tr>
		                    <th scope="row">설명</th>
		                    <td style="vertical-align:center;" id='layer_desc_data_desc'></td>
		                </tr>
		                <tr>
		                    <th scope="row">출처</th>
		                    <td style="vertical-align:center;" id='layer_desc_data_origin'></td>
		                </tr>
		                <tr>
		                    <th scope="row">데이터 기준일</th>
		                    <td style="vertical-align:center;" id='layer_desc_data_stdde'></td>
		                </tr>
		                <!-- <tr>
		                    <th scope="row">원데이터 갱신주기</th>
		                    <td style="vertical-align:center;" id=''> 비정기(수시,자료변경시)</td>
		                </tr> -->
		                <tr>
		                    <th scope="row">시스템 갱신주기</th>
		                    <td style="vertical-align:center;" id='layer_desc_data_upd_cycle'></td>
		                </tr>
		                <tr>
		                    <th scope="row">비고</th>
		                    <td style="vertical-align:center;" id='layer_desc_data_rm'></td>
		                </tr>
		            </tbody>
		        </table>
		    </div>
		    </form>
		    <div class="mini_pop_bottom" id='edit_sh_district_svc'>
		        <div style="text-align: right;right: 24px;">
		            <button class="btn btn-teal btn-sm" id='layer_desc_info_save' style='display: none'>저장</button>
		            <button class="btn btn-gray btn-sm" id='layer_desc_info_cancel' style='display: none'>취소</button>
		        </div>
		    </div>
		</div>
		<!-- End 레이어설명 Side-Panel -->
