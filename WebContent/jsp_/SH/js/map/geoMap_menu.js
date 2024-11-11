﻿﻿// 리스너 키 
var clickKey;

// 클릭 타입
var clickType = "click";



// 변경이력 : 더블(지도상 클릭), 싱클(정보조회 아이콘 클릭)
function clickEvent(type) {

    clickKey = geoMap.on(click1, function(evt) {
    		var strPnu;

			console.log("clickType : ", clickType );

			if(clickType != "click" ) {
				return;
			}else{
			
	
			var pixel = evt.pixel; 				// 클릭한 지점의 픽셀정보   
		  	var geom  = evt.coordinate;			// 클릭한 지점의 좌표정보
		  	var coord = ol.proj.transform(geom, 'EPSG:900913', 'EPSG:4326');
		  	var coord_x = coord[0];
		  	var coord_y = coord[1];

		  	if(vectorLayer_land != null || vectorLayer_land != ''){
				vectorSource_land.clear();
				geoMap.removeLayer(vectorLayer_land);
			}
			if(vectorLayer_buld != null || vectorLayer_buld != ''){
				vectorSource_buld.clear();
				geoMap.removeLayer(vectorLayer_buld);
			}

		  	$.ajax({
				type: 'POST',
				url: "/ajaxDB_search_coordnate.do",
				async: false,
				data: { "coord_x" : coord_x, "coord_y" : coord_y /*, "layer" : layer */},
				dataType: "json",
				success: function( data ) {
						$("#layerInfo-mini td[id^=info_mini_]").text("");
						
						if(data.pnu[0] != null) 		$("#layerInfo-mini #info_mini_pnu").val(data.pnu[0]);
						if(data.address[0] != null) 	$("#layerInfo-mini #info_mini_address").html("<i class=\"fa fa-map-o m-r-5\"></i>"+"<b>주소 : "+data.address[0]+"</b>");

						if(data.pnilp[0] != null) 		$("#layerInfo-mini #info_mini_pnilp").text(data.pnilp[0]);
						if(data.parea[0] != null){
							data.parea[0] = numberWithCommas(data.parea[0]);
							$("#layerInfo-mini #info_mini_parea").text(data.parea[0]);
						}
						if(data.jimok[0] != null) 		$("#layerInfo-mini #info_mini_jimok").text(data.jimok[0]);
						if(data.spfc1[0] != null) 		$("#layerInfo-mini #info_mini_spfc1").text(data.spfc1[0]);
						if(data.road_side[0] != null) 	$("#layerInfo-mini #info_mini_road_side").text(data.road_side[0]);
						if(data.geo_form[0] != null) 	$("#layerInfo-mini #info_mini_geo_form").text(data.geo_form[0]);
						if(data.geo_hl[0] != null) 		$("#layerInfo-mini #info_mini_geo_hl").text(data.geo_hl[0]);
						if(data.prtown[0] != null) 		$("#layerInfo-mini #info_mini_prtown").text(data.prtown[0]);

						if(data.a13[0] != null) 		$("#layerInfo-mini #info_mini_a13").text(data.a13[0]);
						if(data.a9[0] != null) 			$("#layerInfo-mini #info_mini_a9").text(data.a9[0]);
						if(data.a11[0] != null) 		$("#layerInfo-mini #info_mini_a11").text(data.a11[0]);
						if(data.a12[0] != null){
							data.a12[0] = numberWithCommas(data.a12[0]);
							$("#layerInfo-mini #info_mini_a12").text(data.a12[0]);
						}
						if(data.a14[0] != null){
							data.a14[0] = numberWithCommas(data.a14[0]);
							$("#layerInfo-mini #info_mini_a14").text(data.a14[0]);
						}
						if(data.a16[0] != null) 		$("#layerInfo-mini #info_mini_a16").text(data.a16[0]);
						if(data.a17[0] != null) 		$("#layerInfo-mini #info_mini_a17").text(data.a17[0]);
						if(data.a18[0] != null) 		$("#layerInfo-mini #info_mini_a18").text(data.a18[0]);

						//create the style
					    var iconStyle_land = new ol.style.Style({
					    	stroke: new ol.style.Stroke({ color: 'black', width: 1.2 }),
					    	fill: new ol.style.Fill({ color: '#F16521',  }),
					    });
					    var iconStyle_buld = new ol.style.Style({
					    	stroke: new ol.style.Stroke({ color: '#3C55A5', width: 2.5 })
					    });

					    if( data.geom_land[0] != null ){
							var coord = data.geom_land[0];
							coord = coord.replace('MULTIPOLYGON(((', '');
							coord = coord.replace(')))', '');
							var coord_sp = coord.split(",");
							var coord_sp_t = new Array();

							for(j=0; j<coord_sp.length; j++){
								var arry1 = coord_sp[j].split(' ');
								var val = ol.proj.transform([ Number( arry1[0] ), Number( arry1[1] ) ], 'EPSG:4326', 'EPSG:900913');
								coord_sp_t[j] = new Array( val[0], val[1] );
							}

							var iconFeature = new ol.Feature({ geometry: new ol.geom.Polygon([ coord_sp_t ]) });
							vectorSource_land.addFeature(iconFeature);
						}
					    if( data.geom_buld[0] != null ){
							var coord = data.geom_buld[0];
							coord = coord.replace('MULTIPOLYGON(((', '');
							coord = coord.replace(')))', '');
							var coord_sp = coord.split(",");
							var coord_sp_t = new Array();

							for(j=0; j<coord_sp.length; j++){
								var arry1 = coord_sp[j].split(' ');
								var val = ol.proj.transform([ Number( arry1[0] ), Number( arry1[1] ) ], 'EPSG:4326', 'EPSG:900913');
								coord_sp_t[j] = new Array( val[0], val[1] );
							}

							var iconFeature = new ol.Feature({ geometry: new ol.geom.Polygon([ coord_sp_t ]) });
							vectorSource_buld.addFeature(iconFeature);
						}

					    vectorLayer_land = new ol.layer.Vector({ source: vectorSource_land, style: iconStyle_land });
					    vectorLayer_buld = new ol.layer.Vector({ source: vectorSource_buld, style: iconStyle_buld });
					    geoMap.addLayer(vectorLayer_land);
					    geoMap.addLayer(vectorLayer_buld);
					    vectorLayer_land.setOpacity(parseFloat(0.7));
					    
					    strPnu = data.pnu[0];
					
				}
			});

					  	vectorSource.clear();

					  	var strHtml = '';
					  	var searchLimit = 5;
					  	var searchCount = 2;
					  	var searchFeatures = [];
					  	
					 

					  	$('#info_mini_empty').empty();
					  	$('#map-layerlist input').each(function() {
							if(this.checked && searchCount < searchLimit) {
								var data_layer_no           = $(this).attr('data-layer-no');
								var data_layer_tp_nm 		= $(this).attr('id');
								var data_layer_dp_nm 		= $(this).attr('data-layer-dp-nm');
								var data_layer_table_nm 	= $(this).attr('data-layer-table-nm');
								var data_layer_attrb_nm 	= $(this).attr('data-layer-attrb-nm');
								var data_server_nm  		= $(this).attr('data-server-nm');
								var data_server_url 		= $(this).attr('data-server-url');
								var data_server_workspaces	= $(this).attr('data-server-workspaces');
								var check_url				= $(this).attr('data-check-url');
								var download_url			= $(this).attr('data-download-url');
								var layer_nm                = data_layer_tp_nm;

								var pk;
								var edit_yn;
								var eng_head;
								var kor_head;
								var geom_type;
								var download_yn;

								//console.log(data_layer_tp_nm, data_layer_dp_nm, data_layer_table_nm, data_layer_attrb_nm, data_server_nm, data_server_url)
								//console.log(check_url, download_url);

								if((data_layer_table_nm != '' && data_layer_attrb_nm == '') || (data_layer_table_nm != '' && data_layer_attrb_nm != '')) { // 레이어 on 일 시 

									if(data_layer_tp_nm != '' && data_layer_attrb_nm == '') {
										layer_nm = data_layer_tp_nm;
										console.log('real table')
									} else if(data_layer_table_nm != '' && data_layer_attrb_nm != ''){
										layer_nm = data_layer_attrb_nm;
										console.log('view table')
									}

									// 컬럼 목록 조회
									$.ajax({
										type : "POST",
										async : false,
										url : '/web/cmmn/gisLayerHeadInfo.do',
										data : {
											table_space: data_layer_table_nm.split('.')[0],
											table_nm: data_layer_table_nm.split('.')[1],
											layer_tp_nm: data_layer_tp_nm
										},
									    dataType: 'json',
										error : function(response, status, xhr){
											if(xhr.status =='403'){
												alert('검색 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
											}
										},
										success : function(data) {
											console.log("한굻 : " , data);
											if(data.result == 'Y') {
												pk =  data.tablePkInfo;
												edit_yn = data.tableEditInfo;
												eng_head = data.headEngInfo;
												kor_head = data.headKorInfo;
												geom_type = data.geometryInfo;
												//console.log(pk, edit_yn, eng_head, kor_head)
											}
										}
									});

									// 다운로드 파일 체크
									if(check_url != '' && check_url != 'null' && download_url != '' && download_url != 'null') { 
										$.ajax({
											type : "GET",
											async : false,
											url : check_url + strPnu,
											data : {
											},
										    dataType: 'json',
											error : function(response, status, xhr){
												if(xhr.status =='403'){
													alert('검색 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
												}
											},
											success : function(data) {
												if(data.result == 'Y') {
													download_yn = data.result;
													console.log('download link')
												}
											}
										});
									}

							        var filter;
							        if(geom_type == 'POINT') {
										console.log("들어옴1");
							        	var map = evt.map;
							            var size = map.getSize();
							            var extent = map.getView().calculateExtent(size);
										var view  = map.getView();
										var dpi_x = document.getElementById('testdiv').offsetWidth;
										var dpi_y = document.getElementById('testdiv').offsetHeight;
										var resolution = view.getResolution();
										var scale = (resolution * (dpi_x / 0.0254));

										var now = map.getPixelFromCoordinate(geom);
										
										//var now  = geom;
//										var minX1 = now[0] - 20.0;	// left
//										var minY1 = now[1] - 20.0;	// bottom
//										
//										var maxX1 = now[0] + 20.0;	// right
//										var maxY1 = now[1] + 20.0;	// top
										
										var minX = now[0] - 2.0;	// left
										var minY = now[1] - 2.0;	// bottom

										var maxX = now[0] + 2.0;	// right
										var maxY = now[1] + 2.0;	// top


								        var start = geoMap.getCoordinateFromPixel([minX, minY]);
								        var end   = geoMap.getCoordinateFromPixel([maxX, maxY]);
						
								        geometry = new ol.geom.Polygon([
								            [start, [start[0], end[1]], end, [end[0], start[1]], start]
									    ]);
					

										
					

							        	filter = ol.format.filter.within('the_geom', geometry, 'EPSG:3857')
							        } else {
										console.log("들어옴2 : ", geom);
							        	filter = ol.format.filter.contains('the_geom', new ol.geom.Point(geom), 'EPSG:3857')
							        }

									// 속성 및 도형 검색
									var featureRequest = new ol.format.WFS().writeGetFeature({
										srsName: 'EPSG:3857',
										featurePrefix: data_server_workspaces,
										featureTypes: [ layer_nm ],
										outputFormat: 'application/json',
										filter: filter
									});
									
									console.log("data_server_url :" , data_server_url);
//									console.log("data_server_workspaces :" , data_server_workspaces);
//									console.log("layer_nm :" , layer_nm);
									console.log("filter :" , filter);

									$.ajax({
										type: 'POST',
										url: data_server_url + '/wfs',
										async: true,
										contentType: 'xml',
										data: new XMLSerializer().serializeToString(featureRequest),
										error : function(response, status, xhr){
											if(xhr.status =='403'){
												alert('데이터 검색 요청을  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
											}
										},
										success: function(data) {
											console.log("data : " , data);
											if(data != null) {
												if(data.features != undefined && data.features.length > 0) {
													//console.log("속성데이터>>>>",data);
													//fn_gis_map_draw_geojson(data);

													// 속성 표출
													for(m = 0; m < data.features.length; m++) {
														var porp = data.features[m].properties;

														var col_per_row = 2;
										    			var loop = Math.ceil(kor_head.length / col_per_row);

														strHtml += '<div class="sp-box m-b-20" id="info_mini_'+data_layer_tp_nm+'">';
														strHtml +=  	(download_yn == 'Y' ? '<a href="' + download_url + strPnu + '" target="_blank" style = "float:right;"><button type="button" class="btn btn-teal btn-sm">현장조사카드 다운로드</button></a>' : '');
														strHtml += '	<h4 class="header-title m-t-0" style="color: #3C55A5;">' + data_layer_dp_nm + '</h4>';
														strHtml += '	<table class="table table-custom table-cen table-num text-center" width="100%">';
														strHtml += '		<colgroup>';
														strHtml += '			<col width="20%"/> ';
														strHtml += '			<col width="30%"/> ';
														strHtml += '			<col width="20%"/> ';
														strHtml += '			<col width="30%"/> ';
														strHtml += '		</colgroup>';
														strHtml += '		<tbody>';

														for(k=0; k < loop; k++) {
															strHtml += '<tr>';
															for(i = 0; i < col_per_row; i++) {
																if(k*col_per_row + i < kor_head.length) {
																	var key = eng_head[k*col_per_row + i];
																	var value = eval('porp.' + key);
																	
																	if(kor_head[k*col_per_row + i].includes("면적")||kor_head[k*col_per_row + i].includes("금액")){
																		value = numberWithCommas(value);
																	}

																	strHtml += ('<th>' + (kor_head[k*col_per_row + i] == '' ? eng_head[k*col_per_row + i] : kor_head[k*col_per_row + i])+ '</th>');

																	if(value != undefined && value != 'undefined') {
																		strHtml += ('<td>' + value + '</td>');
																	} else {
																		strHtml += ('<td></td>');
																	}
																} else {
																	strHtml += ('<th></th>');
																	strHtml += ('<td></td>');
																}

															}
															strHtml += '</tr>';
														}

														strHtml += '		</tbody>';
														strHtml += '	</table>';
														strHtml += '</div>';
													}

													$('#info_mini_empty').html(strHtml);

													// 도형표출
													var f = (new ol.format.GeoJSON()).readFeatures(data);
													for(k=0; k<f.length; k++)
														searchFeatures.push(f[k]);

												  	if(searchFeatures.length > 0) {
												  		fn_gis_map_draw_feature(searchFeatures);
												  		vectorLayer.setOpacity(parseFloat(0.7));
												  	}
												}
											}
										}
									});

									searchCount++;
								} else if(data_layer_table_nm == '' && data_layer_attrb_nm == '') {
									if(data_server_nm != 'VWORLD') {
										// 컬럼 목록 조회
										$.ajax({
											type : "POST",
											async : false,
											url : '/web/cmmn/gisLayerCntcHeadInfo.do',
											data : {
												layer_no: data_layer_no
											},
										    dataType: 'json',
											error : function(response, status, xhr){
												if(xhr.status =='403'){
													alert('검색 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
												}
											},
											success : function(data) {
												if(data.result == 'Y') {
													//console.log(data)
													pk =  data.tablePkInfo;
													edit_yn = data.tableEditInfo;
													eng_head = data.headEngInfo;
													kor_head = data.headKorInfo;
												}
											}
										});

										if(data_server_nm == 'GEOSERVER') {
											console.log('빈집')

											// 속성 및 도형 검색
											var featureRequest = new ol.format.WFS().writeGetFeature({
												srsName: 'EPSG:3857',
												featurePrefix: data_server_workspaces,
												featureTypes: [ layer_nm ],
												outputFormat: 'application/json',
												filter: ol.format.filter.contains('THE_GEOM', new ol.geom.Point(geom), 'EPSG:3857')
												/*filter: ol.format.filter.contains('THE_GEOM', new ol.geom.Point(coord), 'EPSG:4326')*/
												/*filter: ol.format.filter.equalTo('VHSEQ', 1878)*/
											});

											$.ajax({
												type: 'POST',
												url: data_server_url + '/wfs',
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
															//fn_gis_map_draw_geojson(data);

															// 속성 표출
															var porp = data.features[0].properties;

															var col_per_row = 2;
											    			var loop = Math.ceil(kor_head.length / col_per_row);

															strHtml += '<div class="sp-box m-b-20" id="info_mini_'+data_layer_tp_nm+'">';
															strHtml += '	<h4 class="header-title m-t-0" style="color: #3C55A5;">' + data_layer_dp_nm + '</h4>';
															strHtml += '	<table class="table table-custom table-cen table-num text-center" style = "width:100%; word-break:break-all;">';
															strHtml += '		<colgroup>';
															strHtml += '			<col width="20%"/> ';
															strHtml += '			<col width="30%"/> ';
															strHtml += '			<col width="20%"/> ';
															strHtml += '			<col width="30%"/> ';
															strHtml += '		</colgroup>';
															strHtml += '		<tbody>';

															for(k=0; k < loop; k++) {
																strHtml += '<tr>';
																for(i = 0; i < col_per_row; i++) {
																	if(k*col_per_row + i < kor_head.length) {
																		var key = eng_head[k*col_per_row + i];
																		var value = eval('porp.' + key.toUpperCase());

																		strHtml += ('<th>' + (kor_head[k*col_per_row + i] == '' ? eng_head[k*col_per_row + i] : kor_head[k*col_per_row + i])+ '</th>');

																		if(value != undefined && value != 'undefined') {
																			strHtml += ('<td>' + value + '</td>');
																		} else {
																			strHtml += ('<td></td>');
																		}
																	} else {
																		strHtml += ('<th></th>');
																		strHtml += ('<td></td>');
																	}

																}
																strHtml += '</tr>';
															}

															strHtml += '		</tbody>';
															strHtml += '	</table>';
															strHtml += '</div>';

															$('#info_mini_empty').html(strHtml);

															// 도형표출
															var f = (new ol.format.GeoJSON()).readFeatures(data);
															for(k=0; k<f.length; k++)
																searchFeatures.push(f[k]);

														  	if(searchFeatures.length > 0) {
														  		fn_gis_map_draw_feature(searchFeatures);
														  		vectorLayer.setOpacity(parseFloat(0.7));
														  	}
														}
													}
												}
											});

											searchCount++;
										} else {
											if(data_layer_tp_nm == 'lh_district') {
												console.log('LH')

												// 속성 및 도형 검색
												geoMap.forEachFeatureAtPixel(pixel, function(feature, layer) {
													//console.log(layer);
													//console.log(feature.get('ZONECODE'));
													//console.log(feature.getGeometry());
													//console.log(feature.getGeometry().getCoordinates());

													// 도형 정보
													var zonecode = feature.get('ZONECODE');
													var geometry = feature.getGeometry();
													var coordinate = geometry.getCoordinates();

													// 속성 정보
													$.ajax({
														type : "GET",
														async : false,
														url : "https://openapi.jigu.go.kr/api/apiService.json?authkey=010238638fb2a70cc377ad26e95a6f8f&serviceno=3&citycd=11&dstrcno=" + zonecode,
														dataType : "json",
														data : {},
														error : function(response, status, xhr){
															if(xhr.status =='403'){
																alert('사업지구경계 속성 목록 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
															}
														},
														success : function(data) {
															if(data.msgCode == 0 && data.result != undefined && data.result.length > 0) {
																for(var i=0; i < data.result.length; i++) {
																	var appnNo = data.result[i].DSTRC_APPN_NO;
																	if(appnNo == zonecode) {
																		//console.log(data.result[i]);

																		// 속성 표출
																		var porp = data.result[i];

																		var col_per_row = 2;
														    			var loop = Math.ceil(kor_head.length / col_per_row);

																		strHtml += '<div class="sp-box m-b-20" id="info_mini_'+data_layer_tp_nm+'">';
																		strHtml += '	<h4 class="header-title m-t-0" style="color: #3C55A5;">' + data_layer_dp_nm + '</h4>';
																		strHtml += '	<table class="table table-custom table-cen table-num text-center" width="100%">';
																		strHtml += '		<colgroup>';
																		strHtml += '			<col width="20%"/> ';
																		strHtml += '			<col width="30%"/> ';
																		strHtml += '			<col width="20%"/> ';
																		strHtml += '			<col width="30%"/> ';
																		strHtml += '		</colgroup>';
																		strHtml += '		<tbody>';

																		for(k=0; k < loop; k++) {
																			strHtml += '<tr>';
																			for(i = 0; i < col_per_row; i++) {
																				if(k*col_per_row + i < kor_head.length) {
																					var key = eng_head[k*col_per_row + i];
																					var value = eval('porp.' + key.toUpperCase());

																					strHtml += ('<th>' + (kor_head[k*col_per_row + i] == '' ? eng_head[k*col_per_row + i] : kor_head[k*col_per_row + i])+ '</th>');

																					if(value != undefined && value != 'undefined') {
																						strHtml += ('<td>' + value + '</td>');
																					} else {
																						strHtml += ('<td></td>');
																					}
																				} else {
																					strHtml += ('<th></th>');
																					strHtml += ('<td></td>');
																				}

																			}
																			strHtml += '</tr>';
																		}

																		strHtml += '		</tbody>';
																		strHtml += '	</table>';
																		strHtml += '</div>';

																		$('#info_mini_empty').html(strHtml);

																		// 도형표출
																		searchFeatures.push(feature);

																	  	if(searchFeatures.length > 0) {
																	  		fn_gis_map_draw_feature(searchFeatures);
																	  		vectorLayer.setOpacity(parseFloat(0.7));
																	  	}

																		break;
																	}
																}
															}
														}
													});
												},
												{
													hitTolerance: 2
												});

												searchCount++;
											}
										}
									}
								}

								dataUseLog(data_layer_no);
							}
						});

				  		$("#layerInfo-mini").show();
		}
		
	}); 
	}

//금액 ,표시
function numberWithCommas(x) {
	if(x==null) return '';
	else if(typeof x == 'string') return x.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	else return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}


	$(document).ready(function() {
		//주제도 오버레이 버튼 - 기존
		/*$('.map-layer-btn').click(function() {
            $('.map-layer-btn-group').toggleClass('hidden');
        });*/

		//2020 추가 - shape 업로드
		$('#shape_upload').click(function() {
			if( $('#shape-mini').css("display") == "none"){
				$('#shape-mini').show();
			} else {
				$('#shape-mini').hide();
			}
	    });

		// 마우스 오버 
//		$('#geomap').hover(function() {
//			$("#geomap").css('cursor', 'help');
//			
//        }, function(){
//                
//        });
		
		$("#geomap").mouseenter(function() {
    
        	$("#geomap").css('cursor', 'help');
        
    	});









	});



	//배경지도 선택
	var cbnd_ckecked = true;
	function baseMap_change(mapkind){
		if(mapkind=="Base"){
			vBase.setVisible(true);
			vSatellite.setVisible(false);
			vHybrid.setVisible(false);
			vgray.setVisible(false);
        }else if(mapkind=="Satellite"){
        	vBase.setVisible(false);
			vSatellite.setVisible(true);
			vHybrid.setVisible(true);
			vgray.setVisible(false);
        }else if(mapkind=="gray"){
        	vBase.setVisible(false);
			vSatellite.setVisible(false);
			vHybrid.setVisible(false);
			vgray.setVisible(true);
        }else if(mapkind=="cbnd"){
        	if(cbnd_ckecked){
        		cbnd.setVisible(true);
    			view.setZoom(17);
    			cbnd_ckecked = false;
        	}else{
        		cbnd.setVisible(false);
        		cbnd_ckecked = true;
        	}

        }
    }

	//줌인 & 줌아웃
	function ZoomIn(){ Pan(); var zoomlevel = view.getZoom() + 1; view.setZoom(zoomlevel);}
	function ZoomOut(){ Pan(); var zoomlevel = view.getZoom() - 1; view.setZoom(zoomlevel);}
	function Pan(){
		//click정보조회
		clickselect = false; $("#geomap").css('cursor', 'default');

//		measureClear();
		if(draw != null){
			geoMap.removeInteraction(draw);
		}
		addInteraction('None');
		geoMap.addInteraction(new ol.interaction.DragPan);
	}

	//초기화면
	function FullExtent(){ Pan(); view.setCenter(center_xy); view.setZoom(center_zoom);}

	//새로고침
	function Redraw(){
		clickType = "click";
		click1 ="dblclick"; // 더블클릭
		ol.Observable.unByKey(clickKey); // 리스너 삭제
		clickEvent(clickType) // 더블클릭 리스너 생성
		Pan();
		if(vectorLayer != null || vectorLayer != ''){
			vectorSource.clear();
			geoMap.removeLayer(vectorLayer);
		}
		if(vectorLayer2 != null || vectorLayer2 != ''){
			vectorSource2.clear();
			geoMap.removeLayer(vectorLayer2);
		}
		if(vectorLayer_land != null || vectorLayer_land != ''){
			vectorSource_land.clear();
			geoMap.removeLayer(vectorLayer_land);
		}
		if(vectorLayer_buld != null || vectorLayer_buld != ''){
			vectorSource_buld.clear();
			geoMap.removeLayer(vectorLayer_buld);
		}

		//2020 추가 - 주소변환 레이어
		if(geocoderLayer != null || geocoderLayer != ''){
			geocoderLayer.getSource().clear();
			geoMap.removeLayer(geocoderLayer);
		}

		if(dr_vector != null || dr_vector != ''){
			dr_source.clear();
			geoMap.removeInteraction(dr_vector);
		}
		measureClear();
		geoMap.removeInteraction(draw);
		$(".pin_select").remove();
	}

	// 거리 & 면적 구하기
	var source_measure = new ol.source.Vector();
	var vector_measure = new ol.layer.Vector({
		source: source_measure,
	  	style: new ol.style.Style({
	    	fill: new ol.style.Fill({
	      		color: 'rgba(255, 255, 255, 0.5)'
	    	}),
	    	stroke: new ol.style.Stroke({
	      		color: '#ffcc33',
	      		width: 2
	    	}),
	    	image: new ol.style.Circle({
	      		radius: 17,
	      		fill: new ol.style.Fill({
	        		color: '#ffcc33'
	      		})
	    	})
	 	})
	});

	var sketch;
	var measureTooltipElement;
	var measureTooltip;

	var pointerMoveHandler = function(evt) {
	  	if (evt.dragging) { return; }
	};

	geoMap.addLayer(vector_measure);
	geoMap.on('pointermove', pointerMoveHandler);

	var draw; // global so we can remove it later
	function addInteraction(mearsureType) {
	  //var type = (typeSelect.value == 'area' ? 'Polygon' : 'LineString');
	  	var type = mearsureType;
	  	if(type !== 'None'){
		  	draw = new ol.interaction.Draw({
				source: source_measure,
			    type: (type),
			    style: new ol.style.Style({
			    	fill: new ol.style.Fill({
			        	color: 'rgba(0, 255, 255, 0.3)'
			      	}),
			      	stroke: new ol.style.Stroke({
			        	color: 'rgba(0, 0, 0, 0.5)',
			        	lineDash: [10, 10],
			        	width: 2
			      	}),
			      	image: new ol.style.Circle({
			        	radius: 5,
			        	stroke: new ol.style.Stroke({
			          		color: 'rgba(0, 0, 0, 0.7)'
		        		}),
			        	fill: new ol.style.Fill({
			          		color: 'rgba(255, 255, 255, 0.2)'
			        	})
			      	})
			    })
			});
		  	geoMap.addInteraction(draw);

			var listener;

			draw.on('drawstart', function(evt) {
				source_measure.clear();
			    if (measureTooltipElement) {
			    	$( ".tooltip").remove();
			  	}
			    createMeasureTooltip();
			    sketch = evt.feature;

			    var tooltipCoord = evt.coordinate;

			    listener = sketch.getGeometry().on('change', function(evt) {
			    	var geom = evt.target;
			        var output;
			        if(geom instanceof ol.geom.Polygon) {
			        	output = formatArea( (geom) );
			            tooltipCoord = geom.getInteriorPoint().getCoordinates();
			        }else if(geom instanceof ol.geom.LineString) {
			            output = formatLength( (geom) );
			            tooltipCoord = geom.getLastCoordinate();
			        }
			        measureTooltipElement.innerHTML = output;
			        measureTooltip.setPosition(tooltipCoord);
		        });
		    }, this);

			draw.on('drawend', function(evt) {
				measureTooltipElement.className = 'tooltip tooltip-static';
			    measureTooltip.setOffset([0, -7]);

			    sketch = null;
			    createMeasureTooltip();
			    ol.Observable.unByKey(listener);
				
		    }, this);
		}
	  	createMeasureTooltip();
	}

	function createMeasureTooltip() {
	  	measureTooltipElement = document.createElement('div');
	  	measureTooltipElement.className = 'tooltip tooltip-measure';
	  	measureTooltip = new ol.Overlay({
	    	element: measureTooltipElement,
	    	offset: [0, -15],
	    	positioning: 'bottom-center'
	  	});
	  	geoMap.addOverlay(measureTooltip);
	   

	}
	
	function ClickSelect(){
		addInteraction('None');
		if(draw != null){
			console.log("들어옴");
			geoMap.removeInteraction(draw);
		}

		if(clickselect) {
			clickselect = false; $("#geomap").css('cursor', 'default');
			ol.Observable.unByKey(clickKey); // 리스너 삭제
			click1 = "dblclick"
			clickEvent(clickType); // 정보조회 함수
		} else {
			clickselect = true; $("#geomap").css('cursor', 'help');
			ol.Observable.unByKey(clickKey); // 리스너 삭제
			click1 = "singleclick"
			clickEvent(clickType); // 정보조회 함수
		}
	}

	

	function measureLength(){
		
		// 정보조회 클릭 한 상태
		if(clickType =="click"){
			clickselect = false;$("#geomap").css('cursor', 'default');
		}
		//click정보조회
		if(clickselect) {
			clickselect = false; $("#geomap").css('cursor', 'default');
			clickType = "click";
		
		} else {
			clickselect = true;
			ol.Observable.unByKey(clickKey); // 리스너 삭제
			clickType = "None";
		}
		
		if(draw != null){
			geoMap.removeInteraction(draw);
		}
		  	addInteraction('LineString');		
	}
	function measureArea(){
		
		// 정보조회 클릭 한 상태
		if(clickType =="click"){
			clickselect = false;$("#geomap").css('cursor', 'default');
		}
		
		//click정보조회
		if(clickselect) {
			clickselect = false; $("#geomap").css('cursor', 'default');
			clickType = "click";
		
		} else {
			ol.Observable.unByKey(clickKey); // 리스너 삭제
			clickselect = true;
			clickType = "None";
		}
		

		if(draw != null){
			geoMap.removeInteraction(draw);
		}
			addInteraction('Polygon');
	}
	function measureClear(){
		//click정보조회
		clickselect = false; $("#geomap").css('cursor', 'default');

		if(draw != null){
			geoMap.removeInteraction(draw);
		}
		source_measure.clear();
	    if(measureTooltipElement) {
	    	$(".tooltip").remove();
	  	}
		addInteraction('None');
	}

	var formatLength = function(line) {
	  	var length = 0;
	  		length = Math.round(line.getLength() * 100) / 100;
	  	var output;
	  	if(length > 1000) {
	    	output = (Math.round(length / 1000 * 100) / 100) + ' ' + 'km';
	  	}else{
	    	output = (Math.round(length * 100) / 100) + ' ' + 'm';
	  	}
	  	return output;
	};
	var formatArea = function(polygon) {
		var area = 0;
	  	area = polygon.getArea();
	  	var output;
	  	if(area > 10000) {
	    	output = (Math.round(area / 1000000 * 100) / 100) + ' ' + 'km<sup>2</sup>';
	  	}else{
	    	output = (Math.round(area * 100) / 100) + ' ' + 'm<sup>2</sup>';
	  	}
	  	return output;
	};


	//화면 이미지 저장
	function export_png(){
		/* 240405 주석 : html2canvas 현재 버전에서는 onrendered 옵션은 더 이상 사용되지 않습니다.
		 * html2canvas($("#geomap"), {
			//useCORS: true,
			//proxy: '/etc/proxy_image',
			onrendered: function(canvas) {
				canvas.toBlob(function (blob) {
	        	    saveAs(blob, 'map.png');
			 });
			}
		});*/
		
		html2canvas($("#geomap")[0]).then(function(canvas) {
			            var el = document.createElement("a")
			            el.href = canvas.toDataURL("image/png")
			            el.download = 'map.png' //다운로드 할 파일명 설정
			            el.click()
			        });
	}


	//포털지도 on & off
	var view_set = true;
	function potalMap(){
		console.log("여기들어옴");
		if(view_set){
			$("#potalmap_div").show();
			var omapSize = geoMap.getSize();
			omapSize[0] = omapSize[0]/2;
			$("#geomap").css("width", "50%");
			$("#potalmap_div").css("width", "50%");
			geoMap.setSize(omapSize);
			$("#container").show();
			dmap.relayout();
			view_set = false;
		}else{
			$("#potalmap_div").hide();
			var omapSize = geoMap.getSize();
			omapSize[0] = omapSize[0]*2;
			$("#geomap").css("width", "100%");
			$("#potalmap_div").css("width", "50%");
			geoMap.setSize(omapSize);
			$("#container").hide();
			dmap.relayout();
			view_set = true;
		}
		geoMap.render();
		geoMap.renderSync();
	}


	//주제도 오버레이
	var now_layers = null;
	var now_layers_nm = null;
	function toggle_layers(layers_nm, style){
		if( now_layers != null ){
			geoMap.removeLayer(now_layers);
		}
		if( now_layers_nm == layers_nm ){
			now_layers_nm = null;
		}else{
			now_layers_nm = layers_nm;
			if(style != null){
				now_layers = get_vWorldMap(now_layers_nm, style);
			}else{
				now_layers = get_WMSlayer(now_layers_nm);
			}
			geoMap.addLayer(now_layers);
			now_layers.setOpacity(parseFloat(0.7));
		}
	}

	var now_layersLine = null;
	var now_layersLine_nm = null;
	function toggle_layersLine(layers_nm, style){
		if( now_layersLine != null ){
			geoMap.removeLayer(now_layersLine);
		}
		if( now_layersLine_nm == layers_nm ){
			now_layersLine_nm = null;
		}else{
			now_layersLine_nm = layers_nm;
			if(style != null){
				now_layersLine = get_vWorldMap(now_layersLine_nm, style);
			}else{
				now_layersLine = get_WMSlayer(now_layersLine_nm);
			}
			geoMap.addLayer(now_layersLine);
			now_layersLine.setOpacity(parseFloat(0.7));
		}

	}

	var now_layersCity = null;
	var now_layersCity_nm = null;
	function toggle_layersCity(layers_nm, style){
		if( now_layersCity != null ){
			geoMap.removeLayer(now_layersCity);
		}
		if( now_layersCity_nm == layers_nm ){
			now_layersCity_nm = null;
		}else{
			now_layersCity_nm = layers_nm;
			if(style != null){
				now_layersCity = get_vWorldMap(now_layersCity_nm, style);
			}else{
				now_layersCity = get_WMSlayer(now_layersCity_nm);
			}
			geoMap.addLayer(now_layersCity);
			now_layersCity.setOpacity(parseFloat(0.5));
		}
	}

	var now_layersCity1 = null;
	var now_layersCity1_nm = null;
	function toggle_layersCity1(layers_nm, style){
		if( now_layersCity1 != null ){
			geoMap.removeLayer(now_layersCity1);
		}
		if( now_layersCity1_nm == layers_nm ){
			now_layersCity1_nm = null;
		}else{
			now_layersCity1_nm = layers_nm;
			if(style != null){
				now_layersCity1 = get_vWorldMap(now_layersCity1_nm, style);
			}else{
				now_layersCity1 = get_WMSlayer(now_layersCity1_nm);
			}
			geoMap.addLayer(now_layersCity1);
//			now_layersCity1.setOpacity(parseFloat(0.5));
		}
	}

	var now_layersCity2 = null;
	var now_layersCity2_nm = null;
	var now_layersCity2_style = null;
	function toggle_layersCity2(layers_nm, style){
		if( now_layersCity2 != null ){
			geoMap.removeLayer(now_layersCity2);
		}
		if( now_layersCity2_nm == layers_nm && now_layersCity2_style == style){
			now_layersCity2_nm = null;
		}else{
			now_layersCity2_nm = layers_nm;
			now_layersCity2_style = style;
			if(style != null){
				now_layersCity2 = get_WMSlayer22(now_layersCity2_nm, style);
			}else{
				now_layersCity2 = get_WMSlayer(now_layersCity2_nm);
			}
			geoMap.addLayer(now_layersCity2);
			now_layersCity2.setOpacity(parseFloat(0.5));
		}
	}

	var now_layersCity3 = null;
	var now_layersCity3_nm = null;
	function toggle_layersCity3(layers_nm, style){
		if( now_layersCity3 != null ){
			geoMap.removeLayer(now_layersCity3);
		}
		if( now_layersCity3_nm == layers_nm ){
			now_layersCity3_nm = null;
		}else{
			now_layersCity3_nm = layers_nm;
			if(style != null){
				now_layersCity3 = get_vWorldMap(now_layersCity3_nm, style);
			}else{
				now_layersCity3 = get_WMSlayer(now_layersCity3_nm);
			}
			geoMap.addLayer(now_layersCity3);
			now_layersCity3.setOpacity(parseFloat(0.5));
		}
	}

	var now_layersCity4 = null;
	var now_layersCity4_nm = null;
	function toggle_layersCity4(layers_nm, style){
		if( now_layersCity4 != null ){
			geoMap.removeLayer(now_layersCity4);
		}
		if( now_layersCity4_nm == layers_nm ){
			now_layersCity4_nm = null;
		}else{
			now_layersCity4_nm = layers_nm;
			if(style != null){
				now_layersCity4 = get_vWorldMap(now_layersCity4_nm, style);
			}else{
				now_layersCity4 = get_WMSlayer(now_layersCity4_nm);
			}
			geoMap.addLayer(now_layersCity4);
			now_layersCity4.setOpacity(parseFloat(0.5));
		}
	}

	//정보조회 더블 클릭 추가
	var clickselect = false;
	var click1 ="dblclick" 
	
	
	//정보조회
	function ClickSelect(){
		addInteraction('None');
		if(draw != null){
			geoMap.removeInteraction(draw);
		}

		if(clickselect) {
			clickselect = false; $("#geomap").css('cursor', 'default');
			ol.Observable.unByKey(clickKey); // 리스너 삭제
			click1 = "dblclick"
			clickEvent(clickType); // 정보조회 함수
		} else {
			clickType = "click";
			clickselect = true; $("#geomap").css('cursor', 'help');
			ol.Observable.unByKey(clickKey); // 리스너 삭제
			click1 = "singleclick"
			clickEvent(clickType); // 정보조회 함수
		}
	}





	var saveAs=saveAs||function(e){"use strict";if(typeof e==="undefined"||typeof navigator!=="undefined"&&/MSIE [1-9]\./.test(navigator.userAgent)){return}var t=e.document,n=function(){return e.URL||e.webkitURL||e},r=t.createElementNS("http://www.w3.org/1999/xhtml","a"),o="download"in r,a=function(e){var t=new MouseEvent("click");e.dispatchEvent(t)},i=/constructor/i.test(e.HTMLElement)||e.safari,f=/CriOS\/[\d]+/.test(navigator.userAgent),u=function(t){(e.setImmediate||e.setTimeout)(function(){throw t},0)},s="application/octet-stream",d=1e3*40,c=function(e){var t=function(){if(typeof e==="string"){n().revokeObjectURL(e)}else{e.remove()}};setTimeout(t,d)},l=function(e,t,n){t=[].concat(t);var r=t.length;while(r--){var o=e["on"+t[r]];if(typeof o==="function"){try{o.call(e,n||e)}catch(a){u(a)}}}},p=function(e){if(/^\s*(?:text\/\S*|application\/xml|\S*\/\S*\+xml)\s*;.*charset\s*=\s*utf-8/i.test(e.type)){return new Blob([String.fromCharCode(65279),e],{type:e.type})}return e},v=function(t,u,d){if(!d){t=p(t)}var v=this,w=t.type,m=w===s,y,h=function(){l(v,"writestart progress write writeend".split(" "))},S=function(){if((f||m&&i)&&e.FileReader){var r=new FileReader;r.onloadend=function(){var t=f?r.result:r.result.replace(/^data:[^;]*;/,"data:attachment/file;");var n=e.open(t,"_blank");if(!n)e.location.href=t;t=undefined;v.readyState=v.DONE;h()};r.readAsDataURL(t);v.readyState=v.INIT;return}if(!y){y=n().createObjectURL(t)}if(m){e.location.href=y}else{var o=e.open(y,"_blank");if(!o){e.location.href=y}}v.readyState=v.DONE;h();c(y)};v.readyState=v.INIT;if(o){y=n().createObjectURL(t);setTimeout(function(){r.href=y;r.download=u;a(r);h();c(y);v.readyState=v.DONE});return}S()},w=v.prototype,m=function(e,t,n){return new v(e,t||e.name||"download",n)};if(typeof navigator!=="undefined"&&navigator.msSaveOrOpenBlob){return function(e,t,n){t=t||e.name||"download";if(!n){e=p(e)}return navigator.msSaveOrOpenBlob(e,t)}}w.abort=function(){};w.readyState=w.INIT=0;w.WRITING=1;w.DONE=2;w.error=w.onwritestart=w.onprogress=w.onwrite=w.onabort=w.onerror=w.onwriteend=null;return m}(typeof self!=="undefined"&&self||typeof window!=="undefined"&&window||this.content);if(typeof module!=="undefined"&&module.exports){module.exports.saveAs=saveAs}else if(typeof define!=="undefined"&&define!==null&&define.amd!==null){define("FileSaver.js",function(){return saveAs})};



