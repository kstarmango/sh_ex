/**
 * 공통 - 지도 레이어 On/Off 및 레이어 검색기능을 위한js
 */

var dstrcBndryAllAttr  = [];
var ladUsePlanAllAttr  = [];

var shareLayerList = []; 	//선택한 레이어 목록 담김
var exportLayerList = []; 	//데이터 추출 레이어 목록 담김

function themeInfoClose( obj ) {
	
	console.log($(obj).children('img').hasClass('off'))
	if($(obj).children('img').hasClass('off')){
		$(obj).children('img').removeClass('off');
		$(obj).next().slideDown()
	}else{
		$(obj).children('img').addClass('off');
		$(obj).next().slideUp()
	}
}

//초기 레이어 목록 정보
function fn_layerListInit(){
	$.ajax({
	    type : "POST",
	    url : "/web/cmmn/gisLayerByAuth.do",
	    processData: false,
	    contentType: false,
		error : function(response, status, xhr){
			if(xhr.status =='403'){
				alert('레이어 목록 요청을  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
			}
		},
		success: function(data) {
			$('#map-layerlist').empty();
			if(data.result == 'Y' && data.layerInfo != '') {
				var strHtml = '';
				strHtml = fn_layerList(data.layerInfo);
				
				$('#map-layerlist').append(strHtml);
				/*

				// 빈집 외부 연계시
				/*var apiParam = new URLSearchParams('${apiParam}');
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
				}*/
			}
		}
	});
}

//레이어 목록 표출
function fn_layerList(data){
	var prevGrpnNm = '';
	var strHtml = "";
	for(i=0; i<data.length; i++) {
		var group_level = data[i].level;
		var group_nm    = data[i].grp_nm;
		var group_no    = data[i].grp_no;
		var p_group_no  = data[i].p_grp_no;
		var layer_no         = data[i].layer_no;
		var layer_cntc_yn    = data[i].cntc_yn;
		var layer_down_yn    = data[i].down_yn;
		var layer_dp_nm      =  data[i].layer_dp_nm;
		var layer_tp_nm      = data[i].layer_tp_nm;
		var layer_style_nm   = data[i].layer_style_nm;
		var layer_table_nm   = data[i].table_nm;
		var layer_attrb_nm   = data[i].layer_attrb_nm;
		var server_nm        = data[i].server_nm;
		var server_url       = data[i].server_url;
		var server_workspace = data[i].workspace;
		var check_url        = data[i].check_url;
		var download_url     = data[i].download_url;
		
		var ins_dt = data[i].ins_dt;
		var upd_dt = data[i].upd_dt;
		
		//타임스탬프 사이트 변환(https://www.epochconverter.com/)
		// 1680402492000 23.04.03일 업데이트
		//  1682829050000 23년4월30일 기준 2차데이터 -> 표시 다르게 하기
		//  1698796800000 23년11월01일 기준 23년도 상반기 데이터 업데이트
		/* console.log("intdt :" + ins_dt.time);
		console.log("up_dt :" + upd_dt.time); */

		if(group_level == '0') {

			if(prevGrpnNm != group_nm){ //부모
				if(i != 0) strHtml += '	</ul>';
				strHtml += '<li class="tit" onclick="themeInfoClose(this);">' + group_nm + '<img class="arrowBtn off" src="/resources/img/map/btnSelectArrow.svg" alt="접기"> </li>';
				strHtml += '	<ul class="listWrap" style="display: none;">';
			}
			strHtml += '	<li class="listCursor" data-group-no="' + group_no + '" data-parent-group-no="' + p_group_no + '" data-layer-no="' + layer_no + '" onClick="fn_layer_legend_onoff(this);">';
			strHtml += '		 · '+layer_dp_nm;
			if(ins_dt.time >= 1698796800000){
				strHtml += '	<span style="font-size: 12px; color:red ">new</span>'
			} else if(upd_dt.time >= 1698796800000 && ins_dt.time<1698796800000){
				strHtml += '	<span style=" font-size: 12px; color:blue ">update</span>'
			}
			
			strHtml += '		<button type="button" onClick="fn_layer_desc_show(this);" class="downloadBtn" data-layer-dp-nm="' +  layer_dp_nm + '" data-layer-no="' + layer_no + '">';
			strHtml += '			<img src="/resources/img/map/icInfo16.svg" alt="정보보기">';
			strHtml += '		</button>';
			
			if(layer_down_yn == 'Y' && layer_cntc_yn == 'N') {
				strHtml += '	<button type="button" onClick="fn_shape_download(this);" data-layer-no="' + layer_no + '" data-server-url="' +  server_url + '" data-layer-tp-nm="' + server_workspace + ':' + layer_tp_nm + '" data-output-format="shape-zip" data-output-epsg="EPSG:4326">';
				strHtml += '			<img src="/resources/img/map/icDownload16.svg" alt="다운로드">';
				strHtml += '		</button>';
			}
			
			strHtml += '		<form class="swichBtn">';
			strHtml += '			<label>';
			strHtml += '				<input role="switch" type="checkbox" onClick="fn_layer_onoff(this);"  id="' + layer_tp_nm + '" name="' + layer_tp_nm + '" data-group-no="' + group_no + '" data-layer-dp-nm="' +  layer_dp_nm + '" data-layer-no="' + layer_no + '" data-layer-cntc="' + layer_cntc_yn + '" data-layer-table-nm="' + layer_table_nm + '" data-layer-attrb-nm="' + layer_attrb_nm + '" data-server-nm="' + server_nm + '" data-server-url="' + server_url + '" data-server-workspaces="' + server_workspace + '" data-check-url="' + check_url + '" data-download-url="' + download_url + '">';
			strHtml += '			</label>';
			strHtml += '		</form>';
			strHtml += '	</li>';
		} 
		prevGrpnNm = group_nm;
	}
	return strHtml;
}

//레이어 목록 표출
function fn_searchLayerList(data, type){
	const { layerInfo, headKorInfo, headEnInfo}= data;

	var strHtml = "";
	for(i=0; i<layerInfo.length; i++) {
		var layer_dp_nm = layerInfo[i].layer_dp_nm;
		var layer_tp_nm = layerInfo[i].layer_tp_nm;
		var table_nm = layerInfo[i].table_nm.split('.')[0] || "";
		
		var geom_type = layerInfo[i].geom_typ;
		
		if(!geom_type){
			geom_type = '알 수 없음';
		}else if(geom_type.indexOf('MULTI') !== -1){
			geom_type = geom_type.replace('MULTI', '');
		}
		
		if(type === 'overlap') {
			var overlayClickEvt = "";
			overlayClickEvt += `" onclick="selectEvt('overlayLyrs', this, 'overlay')"`;

			let headKorInfoStr = JSON.stringify(headKorInfo).replace(/['"]/g, '');
			let headEnInfoStr = JSON.stringify(headEnInfo).replace(/['"]/g, '');

			strHtml += '<li value="' + layerInfo[i].table_nm + '" ' + 'headkorinfo="' + headKorInfoStr + '" ' + 'headeninfo="' + headEnInfoStr + '" ' + overlayClickEvt + '>';
			strHtml += layer_dp_nm + "(" + geom_type + ")";
			strHtml += "</li>";
		} else if(type ==='search') {
			if (table_nm == "") {
				table_nm = "landsys_gis"
			}
			
			strHtml += '<li table_nm=' + table_nm  + ' layer_tp_nm=' + layer_tp_nm + '>' + layer_dp_nm + "(" + geom_type + ')</li>'
		} else{
			var layerClickEvt = "";
			// layerClickEvt += ` onclick='fn_layer_anal_onoff(`+JSON.stringify(data[i])+`)'`;
			strHtml += '<li table_nm=' + table_nm  + ' layer_tp_nm=' + layer_tp_nm + layerClickEvt + '>' + layer_dp_nm + "(" + geom_type + ')</li>'
		}
	}
	return strHtml;		
}

// 분석서비스 입력 레이어 On 
// function fn_layer_anal_onoff(data) {
	
// 	if(geoMap.getLayers().getArray().filter(lyr => lyr.get('title') === 'analInputLayer').length !== 0){
// 		geoMap.getLayers().getArray().filter(lyr => lyr.get('title') === 'analInputLayer').map(ele=>{
// 			geoMap.removeLayer(ele);
// 		})
// 	}
	
// 	if(geoMap.getLayers().getArray().filter(lyr => lyr.get('name') === data.layer_tp_nm).length === 0){

		// exportLayerList.push(data.table_Nm); //데이터 추출 레이어 목록
		// layer_url = data.server_url + '/';
		// var addLayer = get_WMSlayer(data.layer_tp_nm);
		// addLayer.setZIndex(9900);
		//console.log("addLayer!!",addLayer)
		//addLayer.setOpacity(0.5);
		// addLayer.values_.title='analInputLayer';
		// geoMap.addLayer( addLayer );
		// let layer_no = data.layer_no;
		// $.ajax({
		// 	type : "POST",
		// 	async : true,
		// 	url : "/web/cmmn/gisLayerAdditionalByNo.do",
		// 	dataType : "json",
		// 	data : {
		// 		layer_no
		// 	},
		// 	error : function(response, status, xhr){
		// 		if(xhr.status =='403'){
		// 			alert('레이어 조회 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
		// 		}
		// 	},
		// 	success : function(res) {
		// 		if(res.layerInfo != undefined && res.layerInfo.length > 0) {
		// 			for(i=0; i<res.layerInfo.length; i++) {
					
		// 				var newLayer = get_WMSlayer(res.layerInfo[i].layer_tp_nm);
		// 				newLayer.setZIndex(9900);
		// 				geoMap.addLayer( newLayer );
						
		// 			}
		// 		}
		// 	}
		// });
// 	}else{

// 	}
	
// }

//WMS 추가 레이어 - 사업지구경계, 토지이용계획
var crossOrigin 	= 'anonymous';
var wmsVersion 		= '1.3.0';
var wfsVersion 		= '1.1.0';
var wfsOutputEpsg   = 'EPSG:3857';
var wfsOutputFormat = 'application/json';
var iLayerMinIndex  = 1000;
var min_zoom = 5;
var max_zoom = 14;
var dstrcBndry = getWMSlayer2('사업지구경계', 'dstrcLayer', 'dstrcLayer', true, 'dstrcLayer',  min_zoom, max_zoom, ++iLayerMinIndex);
var ladUsePlan = getWMSlayer2('토지이용계획', 'usePlan', 'usePlan', true, 'usePlan',  min_zoom + 2, max_zoom, ++iLayerMinIndex);
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
						//'VERSION': wmsVersion,
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

var featureBndryLayer = new ol.layer.Vector({
  	source: new ol.source.Vector({
    	format: new ol.format.GeoJSON()
  	}),
  	style: function (feature) {
  		featureStyle.getText().setText(feature.get('ZONENAME'));
    	return featureStyle;
  	},
});

var featurePlanLayer = new ol.layer.Vector({
  	source: new ol.source.Vector({
    	format: new ol.format.GeoJSON()
  	}),
  	style: function (feature) {
  		featureStyle.getText().setText(feature.get('BLOCKNAME'));
    	return featureStyle;
  	},
});

function fn_lh_district_layer() {
	var layer_no = $("#lh_district").attr('data-layer-no');
	if($("#lh_district").prop("checked") == true) {
		console.log("들어옴");
		geoMap.addLayer(dstrcBndry);
		geoMap.addLayer(featureBndryLayer);

		//console.log(layer_no);
		shareLayerList.push(layer_no); //on된 레이어 담는 배열
		layerUseLog(layer_no);
	} else {
		shareLayerList = shareLayerList.filter((e) => e !== layer_no); //off된 레이어 배열 제거
		geoMap.removeLayer(dstrcBndry);
		geoMap.removeLayer(featureBndryLayer);
	}
}

function fn_lh_useplan_layer(){
	var layer_no = $("#lh_useplan").attr('data-layer-no');
	if($("#lh_useplan").prop("checked") == true) {
		geoMap.addLayer(ladUsePlan);
		geoMap.addLayer(featurePlanLayer);

		shareLayerList.push(layer_no); //on된 레이어 담는 배열
		//console.log(layer_no);
		layerUseLog(layer_no);
	} else {
		shareLayerList = shareLayerList.filter((e) => e !== layer_no); //off된 레이어 배열 제거
		geoMap.removeLayer(ladUsePlan);
		geoMap.removeLayer(featurePlanLayer);
	}
}

//2020 추가 - 레이어  ON/OFF
function fn_layer_onoff(_this) {
	var layer_nm = $(_this).attr('id');
	var layer_no = $(_this).attr('data-layer-no');
	var layer_cntc = $(_this).attr('data-layer-cntc');
	var server_nm  = $(_this).attr('data-server-nm');
	var server_url = $(_this).attr('data-server-url');
	var workspaces = $(_this).attr('data-server-workspaces');
	var tableNm = $(_this).attr('data-layer-table-nm');
	
	if(layer_nm != 'lh_district' && layer_nm != 'lh_useplan') {
		
		if($(_this).is(":checked") == true) {
			console.log("chp!!!")
			shareLayerList.push(layer_no);
			
			if(server_nm != '' && server_nm == 'VWORLD') {
				geoMap.addLayer( get_vWorldMap(layer_nm, layer_nm) );
			} else {
				
				exportLayerList.push(tableNm); //데이터 추출 레이어 목록
				
				layer_url = server_url + '/';
				console.log("layer_nm : ", layer_nm);
				var addLayer = get_WMSlayer(layer_nm);
				addLayer.setZIndex(9900);
				//console.log("addLayer!!",addLayer)
				//addLayer.setOpacity(0.5);
				
				geoMap.addLayer( addLayer );
				
				// 추가 레이어 ON
				$.ajax({
					type : "POST",
					async : true,
					url : "/web/cmmn/gisLayerAdditionalByNo.do",
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
			}

			layerUseLog(layer_no);
		} else {
			// 추가 레이어 OFF
			shareLayerList = shareLayerList.filter((e) => e !== layer_no);
			
			exportLayerList = exportLayerList.filter((e) => e !== tableNm);
			$.ajax({
				type : "POST",
				async : true,
				url : "/web/cmmn/gisLayerAdditionalByNo.do",
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
	}else if(layer_nm == "lh_district"){// 택지지구경계 레이어
		fn_lh_district_layer();
	}else if(layer_nm == "lh_useplan"){// 토지이용계획 레이어
		fn_lh_useplan_layer();
	}
}

//2020 추가 - 레이어 레전드 ON/OFF toggle
function fn_layer_legend_onoff(_this) {
	/*var grp_no   = $(_this).parent().parent().attr('data-group-no');
	var p_grp_no = $(_this).parent().parent().attr('data-parent-group-no');
	var layer_no = $(_this).parent().parent().attr('data-layer-no');*/
	
	var grp_no   = $(_this).attr('data-group-no');
	var p_grp_no = $(_this).attr('data-parent-group-no');
	var layer_no = $(_this).attr('data-layer-no');

	if(layer_no != '') {
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
		/*if($(_this).parent().parent().next().css('display') == 'none') {
			$(_this).parent().parent().find('.line-remove').css('display', 'inline-block');
			$(_this).parent().parent().find('.icon-plus').css('display', 'none');

		} else {
			$(_this).parent().parent().find('.line-remove').css('display', 'none');
			$(_this).parent().parent().find('.icon-plus').css('display', 'inline-block');
		}*/
		console.log($(_this))
		if($(_this).parent().parent().next().css('display') == 'none') {
			$(_this).parent().parent().find('.line-remove').css('display', 'inline-block');
			$(_this).parent().parent().find('.icon-plus').css('display', 'none');

		} else {
			$(_this).parent().parent().find('.line-remove').css('display', 'none');
			$(_this).parent().parent().find('.icon-plus').css('display', 'inline-block');
		}

		// 레전드 토글
		if($(_this).next("ul").length != 0){
			$(_this).next().slideToggle();
		}
		
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
		if($(_this).hasClass('line-remove')) {
			$(_this).parent().parent().find('.line-remove').css('display', 'none');
			$(_this).parent().parent().find('.icon-plus').css('display', 'inline-block');
		} else {
			$(_this).parent().parent().find('.line-remove').css('display', 'inline-block');
			$(_this).parent().parent().find('.icon-plus').css('display', 'none');
		}

		$("[data-group-no="+grp_no+"]").each(function() {
			if($(_this).hasClass('list-answer')) {
				// -,+ 토글
				if($(_this).css('display') == 'block') {
					$(_this).prev().find('.line-remove').css('display', 'none');
					$(_this).prev().find('.icon-plus').css('display', 'inline-block');
				} else {
					$(_this).prev().find('.line-remove').css('display', 'inline-block');
					$(_this).prev().find('.icon-plus').css('display', 'none');
				}

				// 레전드 토글
				$(_this).slideToggle();
			}
		})
	}
}

//2020 추가 - 레이어 범례표출
function fn_layer_legend(layer_no, server_url, workspaces, layer_nm) {
	console.log("범례표출 layer_no!!",layer_no)
	console.log("범례표출 server_url!!",server_url)
	console.log("범례표출 workspaces!!",workspaces)
	console.log("범례표출 layer_nm!!",layer_nm)
	
	//범례 이미지 가져오기
	//https://shgis.syesd.co.kr/geoserver/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&layer=LANDSYS:eclgy_sttus_indvdlz_btp_evl 
	$.ajax({
	    type: 'GET',
	     url: '/web/cmmn/gisLayerStyle.do',
	     data: {
		    	workspaces: workspaces,
		    	style: "AD_"+layer_nm
		    },
	    dataType: 'json',
	    success: function(data) {
	    	console.log(data);
			
	    	$(".hideList li").each(function() {
	    		if($(this).attr('data-layer-no') == layer_no) {
	    			
	    			if($(this).next("ul").length == 0){
	    				strHtml = '';  
						strHtml += '<ul class="legendDiv">';
						//이름동일하면 한번만 출력 240415
						var seenNames = {};
						for(i=0; i<data.styleInfo.length;i++) {
							 var currentItem = data.styleInfo[i];
							 if (!seenNames[currentItem]) {
							        seenNames[currentItem] = true;   // 이름이 처음 보이는 경우에만 처리
							        // 이미지 및 레이블 추가
							        strHtml += '  <li class="legendLi" style="border-bottom: #ff000000;font-size: 1.0rem;"><img src="' + server_url + '/wms?service=WMS&version=1.1.0&request=GetLegendGraphic&layer=' + workspaces + ':' + layer_nm +  '&format=image/png&width=30&height=18&legend_options=bgColor:0xf5f5f5&forcelabels:off&rule=' + data.styleInfo[i]  + '">&nbsp;<label style="margin-bottom: 0px;">' + data.styleInfo[i]  + '</label></li>';
							    }
							//strHtml += '  <li><img src="' + server_url + '/wms?service=WMS&version=1.1.0&request=GetLegendGraphic&layer=' + workspaces + ':' + layer_nm +  '&format=image/png&width=30&height=18&legend_options=bgColor:0xf5f5f5&forcelabels:off&rule=' + data.styleInfo[i] + '">&nbsp;<label style="margin-bottom: 0px;">' + data.styleInfo[i] + '</label></li>';
						}
						strHtml += '</ul>';
						
						console.log(strHtml)
						$(this).after(strHtml);
	    			}else{
	    				console.log("범례 이미 존재")
	    			}
					
				}
			});
	    }
	    ,error:function(error){
	    	console.log("에러!!!",error)
	    }
	});
}

//분석서비스 사업대상지 레이어 검색
//인 자 : type(search : 레이어 공통검색) 
function searchLayersNameNew(e, type) {
		
	var debounceTimer;
	var nm = '';
	var optionId = '';
	if(type == 'search'){ 	//레이어 공통검색 시
		nm = $('#Layers_nm').val();
	} else if(type === 'overlap' || type === 'overlap_field'){   //공간분석 레이어 검색 시
		nm = $('#input_overlap').val();
		optionId = '#overlayLyrs';
	} else {
		nm = $('#input_Lyr').val();
		optionId = '#input_features';
	}

	clearTimeout(debounceTimer);

	if((e.keyCode === 13 && nm.length > 0) || e.type === 'click' || type=='search'){
		debounceTimer = setTimeout(function() {
			$.ajax({
				type : "POST",
				async : false,
				url : "/web/cmmn/gisLayerList.do",
				dataType : "json",
				data : { layerNm: nm },
				error : function(response, status, xhr){
					if(xhr.status =='403'){
						alert('검색 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
					}
				},
				success : function(data) {

					if(data.result == 'Y' && data.layerInfo.length > 0) {
						if(type == 'search'){ 	//레이어 공통검색 시
							$('#layer_tot_cnt').html(data.layerInfo.length); // 전체 데이터 건수
							var strHtml = '';
							strHtml = fn_layerList(data.layerInfo);
							
							$('#map-layerlistSearch').html(strHtml);
							
						} else if(type === 'field' || type === 'overlap' || type === 'overlap_field' || type === 'none_field') { // 공간분석 레이어 검색 시
							var strHtml = '';
		
							// 검색시, 레이어 정보 옵션 넘기는 부분 option 
							strHtml = fn_searchLayerList(data, type);

							if(type == 'overlap'){
								$(optionId).children().slice(3).remove(); // 첫 3개만 유지
								$(optionId).append(strHtml);
							} else if (type == 'overlap_field') {
								$(optionId).children().remove();
								$(optionId).append(strHtml);
								
								$(optionId +  ' li').click(function(event){
									$('#overlayLyrs .selected').removeClass('selected');
									this.className = 'selected';
									const info = this.getAttribute('table_nm') + '.' + this.getAttribute('layer_tp_nm')
									gisLayerColumnInfo(info);

									event.preventDefault();
								});
								
							} else {
								$(optionId).html(strHtml);
								$(optionId +  ' li').click(function(event){
									$('#input_features .selected').removeClass('selected');
									this.className = 'selected';
									
									if(type === 'field'){	// 옵션 클릭하여 필드 검색 추가 진행시
										searchFieldName(this.getAttribute('table_nm'), this.getAttribute('layer_tp_nm'));
									} else if(type === 'overlap') { // 옵션 클릭하여 선택레이어 목록 담기

										$('#output_select').append(this.cloneNode(true));
									}
									
									event.preventDefault();
								});
							}
						}
					}
					if(!(data.result == 'Y' && data.layerInfo.length > 0)) {
						alert('검색 결과가 없습니다.');
					}
				}
			});
		}, 500);  
	} else if((e.keyCode === 13 && nm.length === 0) || e.type === 'click') {
		alert('검색어를 입력하세요.');
	}
}

// 분석서비스 입력 영역 필드 선택
function searchFieldName(table_space, table_nm, defaultOption){
	$.ajax({
		type: "POST",
		async: false,
		url: '/web/cmmn/gisLayerColumnInfo.do',
		data: { table_space, table_nm },
		dataType: 'json',
		success: function(data) {
			if (data.result === 'Y') {
				eng_head = data.headEngInfo;
				kor_head = data.headKorInfo;

				var selectContainer = $('#optionContainer');
				var selectElement = selectContainer.find('select');
				
				selectElement.each(function() {
			    // var defaultOption = $(this).find('option:first').clone(); 
			    $(this).empty();
			    // $(this).append(defaultOption); 
				    if (defaultOption) {
						$(this).append('<option value="" selected="selected">필드선택(옵션)</option>');
					}

					// 데이터 삽입하는 부분
					if (Array.isArray(kor_head) && Array.isArray(eng_head) && kor_head.length === eng_head.length) {
						for (let i = 0; i < eng_head.length; i++) {
							const content = kor_head[i] ? kor_head[i] : eng_head[i];
							$(this).append('<option value="' + eng_head[i] + '">' + content  + '</option>');
						}
						// 업데이트 chosen plugin select tag 
						selectElement.trigger("chosen:updated");
					} else {
						console.error('Data arrays are not of the same length or not arrays.');
					}
				});
			}
		},
		error: function(response, status, xhr) {
			if (xhr.status == '403') {
				alert('검색 요청이 실패했습니다.\n\n관리자에게 문의하시길 바랍니다.');
			}
		}
	});
}

// 필드 내 데이터 검색
function searchFieldData(e, isSlope){
	const searchTxt = $('#input_field').val();
	
	const selectedLyrInput = $('#input_features').find('.selected');
	var layerNm = '';
	if(selectedLyrInput.attr('table_nm')){
		layerNm = selectedLyrInput.attr('table_nm') + '.' + selectedLyrInput.attr('layer_tp_nm');
	} else { 
		layerNm = 'landsys_usr' + '.' + selectedLyrInput.attr('layer_tp_nm');
	}
	var fieldNm = $('#optionContainer').find('select').val();

	var debounceTimer;
	var outStr = '';

	clearTimeout(debounceTimer);
	if(e.keyCode === 13 || e.type === 'click'){
		debounceTimer = setTimeout(function() {
			$.ajax({
				type : "GET",
				async : false,
				url : "/web/cmmn/gisLayerSearchFeatures.do",
				dataType : "json",
				data : { layerNm, fieldNm, searchTxt },
				error : function(response, status, xhr){
					if(xhr.status =='403'){
						alert('검색 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
					}
				},
				success : function(data) {
					if(searchTxt !== '') {
						if (JSON.parse(data.result).features && JSON.parse(data.result).features.length > 0) {
							const el = $('#output_field');
							el.empty();
					
							const features = new ol.format.GeoJSON().readFeatures(JSON.parse(data.result));
	
							features.forEach((feature) => {
								const wkt = new ol.format.WKT();
								const wktStr = wkt.writeFeature(feature);
								const fieldID = $('#optionContainer').find('select').val();
								const fieldValue = feature.get(fieldID);
								
								const appendOutputField = () => {
									outStr += `<li value="${wktStr}" onclick="selectEvt('output_field', $(this))">${fieldValue}</li>`;
									el.append(outStr);
								}
								if (isSlope) {
									if (feature.getGeometry().getType().indexOf('Polygon') !== -1) {
										appendOutputField()
									} else {
										alert('폴리곤 타입의 데이터가 없습니다.')
									}
								} else {
									appendOutputField()
								}
							});
						} 
					} else if(searchTxt === ''){
						alert('검색어를 입력하세요.');
					}
				}
			});
		}, 500);  
	} 
}

//분석서비스 주소 검색
function searchAddrName(e){
	var debounceTimer;
	var addr = $('#input_addr').val();

	clearTimeout(debounceTimer);

	debounceTimer = setTimeout(function(){
		if(e.keyCode === 13 && addr !== "" || e.type === 'click'){
			$.ajax({
				type : "POST",
				async : false,
				// url : "https://shgis.syesd.co.kr/shex/api/geocode/get.do",
				url : shexPath + "/shex/api/geocode/get.do",
				dataType : "json",
				data : { addr },
				timeout: 5000,
				error : function(response, status, xhr){
					if(xhr.status =='403'){
						alert('검색 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
					}
				},
				success : function(data) {
					if(data.RESULT) {
						
						if (data.DATA.length>0) {
							
							var addrOptionContainer = $('#addrOptionContainer');
							var ulElement = addrOptionContainer.find('ul');
							
							ulElement.empty();
							
							var analLayer = geoMap
							.getLayers()
							.getArray()
							.find((layer) => layer.getProperties().title === 'analysis');

							if(!analLayer){
								analLayer = new ol.layer.Vector({ source: new ol.source.Vector(), title: 'analysis'})
								geoMap.addLayer(analLayer);
							}

							data.DATA.forEach(function(item, i){
								let itemAddr = '';
								if (item.search_type === 'road') {
									itemAddr = item.road_addr;
								} else {
									itemAddr = item.parcel_addr;
								}
								
								var coord = ol.proj.transform( [ item.x4326, item.y4326 ], 'EPSG:4326', "EPSG:3857")
								ulElement.append('<li value="' + item.ppnu + '" data-coord="' + JSON.stringify(coord) + '" onclick="showLgFeature(this);">' + itemAddr + '</li>');
							});
					}
				}
				}
			});
		} else if(e.keyCode === 13 && addr === "" || e.type === 'click') {
			alert('검색어를 입력하세요.');
		}
	})
}

/* 분석서비스 주소검색 결과 좌표의 지적 필지 정보 불러와 intersect한 결과물 지도에 표출, ajax 요청이 있기에 selectEvt과 분리*/
function showLgFeature(ele){
	$(ele).siblings().removeClass('selected');
  $(ele).addClass('selected');

	const coord = JSON.parse($(ele).attr('data-coord'));
	const reader = new ol.format.WKT();
	const point = new ol.geom.Point(ol.proj.transform(coord, 'EPSG:3857', 'EPSG:4326'));
	const inputWKT = reader.writeGeometry(point);

	$.ajax({
		type : "GET",
		async : false,
		url : '/web/analysis/getLgStr.do',
		dataType : "json",
		data : { inputWKT },
		error : function(response, status, xhr){
			if(xhr.status =='403'){
				alert('검색 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
			}
		},
		success : function(data) {
			if(data.result['DATA'] && data.result.DATA['features'] && data.result.DATA['features'].length){
				data.result.DATA
			} else alert('해당 주소의 지적정보를 불러오는데 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');

			if(geoMap.getLayers().getArray().filter(lyr => lyr.get('title') === 'analInputLayer').length !== 0){
				geoMap.getLayers().getArray().filter(lyr => lyr.get('title') === 'analInputLayer').map(ele=>{
					geoMap.removeLayer(ele);
				})
			}

			const featuresData = new ol.format.GeoJSON().readFeatures(data.result.DATA)[0];
			const feature_4326 = new ol.Feature(featuresData.getGeometry());
			if(!feature_4326) return ;
			
			const wkt = new ol.format.WKT();
			$(ele).attr("data-addrWKT", wkt.writeFeature(feature_4326));
			
			const vectorSource = new ol.source.Vector();
			const feature_3857 = new ol.Feature(feature_4326.getGeometry().transform('EPSG:4326', 'EPSG:3857'));
			vectorSource.addFeature(feature_3857);

			addAnalInputLayer(vectorSource);
		}
	});
} 

//분석서비스 My Data 검색
function searchMyDataName(e){
	var debounceTimer;
	var mainTitle = $('#input_MyData').val();

	clearTimeout(debounceTimer);

	if(e.keyCode === 13 && mainTitle.length > 0 || e.type === 'click'){
		debounceTimer = setTimeout(function(){
			$.ajax({
				type : "GET",
				async : false,
				url : "/web/cmmn/gisLayerSearchMyData.do",
				dataType : "json",
				data : { mainTitle },
				error : function(response, status, xhr){
					if(xhr.status =='403'){
						alert('검색 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
					}
				},
				success : function(data) {
					if(data.result !== 'Y' || !data.layerInfo) {
						alert('검색 결과가 존재하지 않습니다.')
						return 
					} 

					var ulElement = $('#input_features');
					data.layerInfo.forEach((item) => {
						const str = `<li table_nm="" layer_tp_nm="${item.table_nm}">${item.main_title}</li>`;
						ulElement.append(str);
					})

					$('#input_features li').click(function(event){
						$('#input_features .selected').removeClass('selected');
						this.className = 'selected';
						searchMyDataField(event, this.getAttribute('layer_tp_nm'));

						event.preventDefault();
					})
				
				}
			});
		}, 500)
	} else if(e.keyCode === 13 && mainTitle.length === 0 || e.type === 'click') {
		alert('검색어를 입력하세요.');
	}
} 

//분석서비스 My Data 필드 검색
function searchMyDataField(e, tableName){
	var debounceTimer;
	clearTimeout(debounceTimer);

	$.ajax({
		type : "GET",
		async : false,
		url : "/web/cmmn/gisLayerSearchMyDataColumnInfo.do",
		dataType : "json",
		data : { tableName },
		error : function(response, status, xhr){
			if(xhr.status =='403'){
				alert('검색 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
			}
		},
		success : function(data) {
			if(data.result !== 'Y' || !data.columnListInfo) {
				alert('검색 결과가 존재하지 않습니다.')
				return 
			} 
			const filterColumnList = data.columnListInfo
				.filter(v => v.column_name !== 'the_geom' && v.column_name !== 'ogc_fid');

			const selectContainer = $('#optionContainer');
			const selectElement = selectContainer.find('select');
			
			selectElement.each(function() {
				$(this).empty();
				for (let i = 0; i < filterColumnList.length; i++) {
					const colNm = filterColumnList[i].column_name;
					$(this).append('<option value="' + colNm + '">' + colNm + '</option>');
				}
				// 업데이트 chosen plugin select tag 
				selectElement.trigger("chosen:updated");
			});
		}
	});
}

//레이어 컬럼 추출
//인 자 : info(layerInfo.table_nm 데이터 값이 파라미터로 넘어옴) ex)landsys_gis.eclgy_sttus_indvdlz_btp_evl
function gisLayerColumnInfo(info){
	// 컬럼 목록 조회
	$.ajax({
		type : "POST",
		async : false,
		url : '/web/cmmn/gisLayerColumnInfo.do',
		data : {
			table_space: info.split('.')[0],
			table_nm: info.split('.')[1]
			//table_space: 'landsys_gis', 	//레이어 스키마명 예시
			//table_nm: 'abslt_prsrv_area' 	//레이어 테이블명 예시
		},
    dataType: 'json',
		error : function(response, status, xhr){
			if(xhr.status =='403'){
				alert('검색 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
			}
		},
		success : function(data) {
			if(data.result == 'Y' && data.allInfo.length) {

				var selectContainer = $('#optionContainer');
				var selectElement = selectContainer.find('select');
				
				selectElement.each(function() {
			    $(this).empty();

					data.allInfo.forEach((item) => {
						$(this).append('<option value="' + item.column_nm + '">' + item.column_comment + '(' + item.column_type + ')' + '</option>');
					})

					selectElement.trigger("chosen:updated");
				});
			}
		}
	});
}

//2020 추가 - 레이어 다운로드
function fn_shape_download(_this) {
	var url    = $(_this).attr('data-server-url');
	var name   = $(_this).attr('data-layer-tp-nm');
	var format = $(_this).attr('data-output-format');
	var epsg   = $(_this).attr('data-output-epsg');
	var url    = url + '/wfs?request=GetFeature&version=1.1.0&typeName=' + name + '&outputFormat=' + format + '&srsName=' + epsg + '&format_options=CHARSET:EUC-KR';

	if(name == undefined || name == '') {
		alert('다운로드 권한이 없습니다.\n\n관리자에게 문의하시길 바랍니다.')
		return;
	} else {
		window.open(url, '_blank');

		var layer_no    = $(_this).attr('data-layer-no');
		downUseLog(layer_no);
	}
}

//-----------------------------------레이어 설명창 관련-----------------------------------------//
//레이어 설명 조회
function fn_layer_desc_show(_this) {
	var nm = $(_this).attr('data-layer-dp-nm');
	var no = $(_this).attr('data-layer-no');

	$.ajax({
		type : "POST",
		async : false,
		url : "/web/cmmn/gisLayerDesc.do",
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

//레이어 설명 편집창 활성화
function layer_desc_info_edit(){
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
}

//레이어 설명 편집 저장
function layer_desc_info_save(){
	var desc_no = $('#edit_desc_no').val();
	var req_url = (desc_no == '' ? "/web/cmmn/gisLayerDescAdd.do" : "/web/cmmn/gisLayerDescEdit.do");
	
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
}

//레이어 설명 Div 닫기 및 초기화
function layer_desc_reset(){
	$('input[name*="edit_desc_data"]').remove();
	$('#layer_desc_info').hide();
}