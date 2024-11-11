$(document).ready(function() {
    // === datetimepicker ===
    $(".datetimepicker").datetimepicker({
        locale: 'ko',
        format: 'YYYY/MM/DD',
        icons: {
            previous: "fa fa-chevron-left",
            next: "fa fa-chevron-right",
            time: "fa fa-clock-o",
            date: "fa fa-calendar",
            up: "fa fa-arrow-up",
            down: "fa fa-arrow-down"
        }
    });

	//숫자만 입력
	$("input[id^='num_']").keyup(function(){
		$(this).val($(this).val().replace(/[^0-9]/gi,""));
	});

	//토지-------------------------------------------
	//토지면적
	$(function() {
		var min = 0;
		var max = 10000000;
	    $("#slider_parea").slider({
	    	range: true, min: min, max: max, values: [min, max],
	    	slide: function( event, ui ){
		    	var type = $(this).prop("id").replace("slider_", "");
		        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
		        $("#num_"+type+"_1").val( ui.values[0] );
			    $("#num_"+type+"_2").val( ui.values[1] );
	    	}
	    });
	    slider_range('parea');
	});
	$("#num_parea_1, #num_parea_2").on("keyup", function(){ slider_range('parea'); });
    //공시지가
	$(function() {
		var min = 0;
		var max = 100000000;
	    $("#slider_pnilp").slider({
	    	range: true, min: min, max: max, values: [min, max],
	    	slide: function( event, ui ){
		    	var type = $(this).prop("id").replace("slider_", "");
		        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
		        $("#num_"+type+"_1").val( ui.values[0] );
			    $("#num_"+type+"_2").val( ui.values[1] );
	    	}
	    });
	    slider_range('pnilp');
	});
	$("#num_pnilp_1, #num_pnilp_2").on("keyup", function(){ slider_range('pnilp'); });

	//건물-------------------------------------------
	//건축면적
	$(function() {
		var min = 0;
		var max = 10000000;
	    $("#slider_bildng_ar").slider({
	    	range: true, min: min, max: max, values: [min, max],
	    	slide: function( event, ui ){
		    	var type = $(this).prop("id").replace("slider_", "");
		        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
		        $("#num_"+type+"_1").val( ui.values[0] );
			    $("#num_"+type+"_2").val( ui.values[1] );
	    	}
	    });
	    slider_range('bildng_ar');
	});
	$("#num_bildng_ar_1, #num_bildng_ar_2").on("keyup", function(){ slider_range('bildng_ar'); });
	//연면적
	$(function() {
		var min = 0;
		var max = 10000000;
	    $("#slider_totar").slider({
	    	range: true, min: min, max: max, values: [min, max],
	    	slide: function( event, ui ){
		    	var type = $(this).prop("id").replace("slider_", "");
		        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
		        $("#num_"+type+"_1").val( ui.values[0] );
			    $("#num_"+type+"_2").val( ui.values[1] );
	    	}
	    });
	    slider_range('totar');
	});
	$("#num_totar_1, #num_totar_2").on("keyup", function(){ slider_range('totar'); });
	//대지면적
	$(function() {
		var min = 0;
		var max = 10000000;
	    $("#slider_plot_ar").slider({
	    	range: true, min: min, max: max, values: [min, max],
	    	slide: function( event, ui ){
		    	var type = $(this).prop("id").replace("slider_", "");
		        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
		        $("#num_"+type+"_1").val( ui.values[0] );
			    $("#num_"+type+"_2").val( ui.values[1] );
	    	}
	    });
	    slider_range('plot_ar');
	});
	$("#num_plot_ar_1, #num_plot_ar_2").on("keyup", function(){ slider_range('plot_ar'); });
	//건폐율
	$(function() {
		var min = 0;
		var max = 100;
	    $("#slider_bdtldr").slider({
	    	range: true, min: min, max: max, values: [min, max],
	    	slide: function( event, ui ){
		    	var type = $(this).prop("id").replace("slider_", "");
		        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
		        $("#num_"+type+"_1").val( ui.values[0] );
			    $("#num_"+type+"_2").val( ui.values[1] );
	    	}
	    });
	    slider_range('bdtldr');
	});
	$("#num_bdtldr_1, #num_bdtldr_2").on("keyup", function(){ slider_range('bdtldr'); });
	//용적률
	$(function() {
		var min = 0;
		var max = 1000;
	    $("#slider_cpcty_rt").slider({
	    	range: true, min: min, max: max, values: [min, max],
	    	slide: function( event, ui ){
		    	var type = $(this).prop("id").replace("slider_", "");
		        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
		        $("#num_"+type+"_1").val( ui.values[0] );
			    $("#num_"+type+"_2").val( ui.values[1] );
	    	}
	    });
	    slider_range('cpcty_rt');
	});
	$("#num_cpcty_rt_1, #num_cpcty_rt_2").on("keyup", function(){ slider_range('cpcty_rt'); });

	//사업지구-------------------------------------------
	//고시면적
	$(function() {
		var min = 0;
		var max = 10000000;
	    $("#slider_solar").slider({
	    	range: true, min: min, max: max, values: [min, max],
	    	slide: function( event, ui ){
		    	var type = $(this).prop("id").replace("slider_", "");
		        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
		        $("#num_"+type+"_1").val( ui.values[0] );
			    $("#num_"+type+"_2").val( ui.values[1] );
	    	}
	    });
	    slider_range('solar');
	});
	$("#num_solar_1, #num_solar_2").on("keyup", function(){ slider_range('solar'); });
	//건폐율
	$(function() {
		var min = 0;
		var max = 100;
	    $("#slider_hbdtldr").slider({
	    	range: true, min: min, max: max, values: [min, max],
	    	slide: function( event, ui ){
		    	var type = $(this).prop("id").replace("slider_", "");
		        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
		        $("#num_"+type+"_1").val( ui.values[0] );
			    $("#num_"+type+"_2").val( ui.values[1] );
	    	}
	    });
	    slider_range('hbdtldr');
	});
	$("#num_hbdtldr_1, #num_hbdtldr_2").on("keyup", function(){ slider_range('hbdtldr'); });
	//용적률
	$(function() {
		var min = 0;
		var max = 1000;
	    $("#slider_hcpcty_rt").slider({
	    	range: true, min: min, max: max, values: [min, max],
	    	slide: function( event, ui ){
		    	var type = $(this).prop("id").replace("slider_", "");
		        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
		        $("#num_"+type+"_1").val( ui.values[0] );
			    $("#num_"+type+"_2").val( ui.values[1] );
	    	}
	    });
	    slider_range('hcpcty_rt');
	});
	$("#num_hcpcty_rt_1, #num_hcpcty_rt_2").on("keyup", function(){ slider_range('hcpcty_rt'); });



    //읍면동리스트 조회
	$("select[id$='_sig']").change(function() {
		var sig = $(this);
		var sigcd = sig.val();
		emd_list(sig, sigcd);
	});


	//멀티셀렉트
	$(".chosen").chosen();


    //열닫 - 하위메뉴
    $('.dropdown-menu').on('click', function(e) {
        e.stopPropagation();
    });


    //클릭 시 정보조회
    geoMap.on('singleclick', function(evt) {
		if( !clickselect ) {
			return;
		} else {
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
				aync: false,
				data: { "coord_x" : coord_x, "coord_y" : coord_y /*, "layer" : layer */},
				dataType: "json",
				success: function( data ) {
					if( data.pnu[0] != null ) {
						$("#layerInfo-mini td[id^=info_mini_]").text("");

						if(data.pnu[0] != null) 		$("#layerInfo-mini #info_mini_pnu").val(data.pnu[0]);
						if(data.address[0] != null) 	$("#layerInfo-mini #info_mini_address").html("<i class=\"fa fa-map-o m-r-5\"></i>"+"<b>주소 : "+data.address[0]+"</b>");

						if(data.pnilp[0] != null) 		$("#layerInfo-mini #info_mini_pnilp").text(data.pnilp[0]);
						if(data.parea[0] != null) 		$("#layerInfo-mini #info_mini_parea").text(data.parea[0]);
						if(data.jimok[0] != null) 		$("#layerInfo-mini #info_mini_jimok").text(data.jimok[0]);
						if(data.spfc1[0] != null) 		$("#layerInfo-mini #info_mini_spfc1").text(data.spfc1[0]);
						if(data.road_side[0] != null) 	$("#layerInfo-mini #info_mini_road_side").text(data.road_side[0]);
						if(data.geo_form[0] != null) 	$("#layerInfo-mini #info_mini_geo_form").text(data.geo_form[0]);
						if(data.geo_hl[0] != null) 		$("#layerInfo-mini #info_mini_geo_hl").text(data.geo_hl[0]);
						if(data.prtown[0] != null) 		$("#layerInfo-mini #info_mini_prtown").text(data.prtown[0]);

						if(data.a13[0] != null) 		$("#layerInfo-mini #info_mini_a13").text(data.a13[0]);
						if(data.a9[0] != null) 			$("#layerInfo-mini #info_mini_a9").text(data.a9[0]);
						if(data.a11[0] != null) 		$("#layerInfo-mini #info_mini_a11").text(data.a11[0]);
						if(data.a12[0] != null) 		$("#layerInfo-mini #info_mini_a12").text(data.a12[0]);
						if(data.a14[0] != null) 		$("#layerInfo-mini #info_mini_a14").text(data.a14[0]);
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

					  	vectorSource.clear();

					  	var strPnu = data.pnu[0];
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

								if((data_layer_table_nm != '' && data_layer_attrb_nm == '') || (data_layer_table_nm != '' && data_layer_attrb_nm != '')) {

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
									if(check_url != '' && download_url != '') {
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
										var minX = now[0] - 2.0;	// left
										var minY = now[1] - 2.0;	// bottom
										var maxX = now[0] + 2.0;	// right
										var maxY = now[1] + 2.0;	// top
								        var start = geoMap.getCoordinateFromPixel([minX, minY]);
								        var end   = geoMap.getCoordinateFromPixel([maxX, maxY]);
								        //var start = [minX, minY];
								        //var end   = [maxX, maxY];
								        geometry = new ol.geom.Polygon([
								            [start, [start[0], end[1]], end, [end[0], start[1]], start]
									    ]);

							        	filter = ol.format.filter.within('the_geom', geometry, 'EPSG:3857')
							        } else {
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
													for(m = 0; m < data.features.length; m++) {
														var porp = data.features[m].properties;

														var col_per_row = 2;
										    			var loop = Math.ceil(kor_head.length / col_per_row);

														strHtml += '<div class="sp-box m-b-20" id="info_mini_'+data_layer_tp_nm+'">';
														strHtml += '	<h4 class="header-title m-t-0" style="color: #3C55A5;">' + data_layer_dp_nm + '</h4>';
														strHtml +=  	(download_yn == 'Y' ? '<a href="' + download_url + strPnu + '" target="_blank"><button type="button" class="btn btn-teal btn-sm">현장조사카드 다운로드</button></a>' : '');
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
				}
			});


		}
	});

    function numberWithCommas(x) { return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","); }


});

//읍면동리스트 조회
function emd_list(sig, sigcd){
	$.ajax({
		type: 'POST',
		url: "/ajaxDB_emd_list.do",
		data: { "sigcd" : sigcd },
		async: false,
		dataType: "json",
		success: function( data ) {
			if( data != null ) {
				var emd_nm = null;
				var emd_cd = null;
				var emd = sig.parent().next('div').children("select");
				emd.children("option").remove();
				emd.append('<option value="0000" selected>전체 선택</option>');
				for (i=0; i<data.emd_cd.length; i++) {
					emd_nm = data.emd_nm[i];
					emd_cd = data.emd_cd[i];
					emd.append('<option value="'+ emd_cd + '">' + emd_nm + '</option>');
				}
				emd.trigger("chosen:updated");
			}
		}
	});
}

//슬라이더바 범위적용
function slider_range(type, reset){
	var mim = $("#slider_"+type).slider("option", "min");
	var max = $("#slider_"+type).slider("option", "max");
	var now_min = document.getElementById('num_'+type+'_1').value;
	var now_max = document.getElementById('num_'+type+'_2').value;
	if( now_min == '' ){ now_min = mim; }
	if( now_max == '' ){ now_max = max; }
	if(reset){
		now_min = mim; now_max = max;
		$("#num_"+type+"_1").val(null);
	    $("#num_"+type+"_2").val(null);
	}
	now_min = parseInt( now_min );
	now_max = parseInt( now_max );
	if(now_max < now_min){ now_max = now_min; }else if(now_min > now_max){ now_min = now_max; }else if(now_min > max){ now_min = max; }
	var now_val = [now_min, now_max];
	$("#slider_"+type).slider( "option", "values", now_val);
	$("#amount_"+type).text(nCommas($("#slider_"+type).slider("values", 0)) + "  ~  " + nCommas($("#slider_"+type).slider("values", 1)) );
}

//초기화
function gis_clear(){
	//기본검색
	$("select[id$='_sig']").val('0000').trigger("chosen:updated");
	$("select[id$='_emd'] option").remove();
	$("select[id$='_emd']").append('<option value="0000" selected>전체 선택</option>');
	$("select[id$='_emd']").val('0000').trigger("chosen:updated");
	$("#tab-01_Form input[type=checkbox], #tab-02_Form input[type=checkbox], #tab-03_Form input[type=checkbox]").attr("checked", false);

	//상세검색
	$("#tab-01_Form_item .chosen, #tab-02_Form_item .chosen, #tab-03_Form_item .chosen").val('').trigger("chosen:updated");
	$("#tab-01_Form_item div[id^='slider_'], #tab-02_Form_item div[id^='slider_'], #tab-03_Form_item div[id^='slider_']").each(function(){
	  var type = $(this).prop("id").replace("slider_", "");
	  slider_range(type, true);
	});
	$("#fn_cp_date_select").val("00");
	$("#num_cp_date_1").val(null);
	$("#num_cp_date_2").val(null);

	//자산검색
	$("#tab-01_Form_data input[type=checkbox], #tab-02_Form_data input[type=checkbox], #tab-03_Form_data input[type=checkbox]").attr("checked", false);

	//공간분석
	space_clear();
}

//화폐 단위(3자리 쉼표)
function nCommas(x) {    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");}

//페이징처리
function drawPage(goTo, type, n, t, kind){
	var pagesize = n;
	var totalCount = t; //전체 건수
    var totalPage = Math.ceil(totalCount/pagesize);//한 페이지에 나오는 행수
    var PageNum;
	var page = goTo;
    var pageGroup = Math.ceil(page/10);    //페이지 수
    var next = pageGroup*10;
    var prev = next - 9;
    var goNext = next+1;
    var goPrev;

    if(prev-1<=0){
        goPrev = 1;
    }else{
        goPrev = prev-1;
    }

    if(next>totalPage){
        goNext = totalPage;
        next = totalPage;
    }else{
        goNext = next+1;
    }

    $("#pageZone").empty();
    var prevStep =	"<li>";
    	prevStep +=		"<a ";
    	if(Number(goTo) == 1){ prevStep += "href=\"#\""; }
    	else{ prevStep += "href=\"javascript:"+type+"("+goPrev+", '"+kind+"');\""; }
    	prevStep +=		"><i class=\"fa fa-angle-left\"></i></a>";
    	prevStep +=	"</li>";
	$("#pageZone").append(prevStep);
	for(var i=prev; i<=next;i++){
    	if(i == goTo){
    		PageNum =	"<li class=\"active\">";
    		PageNum +=		"<a href=\"#\">"+i+"</a>";
    		PageNum +=	"</li>";
    	}else{
    		PageNum =	"<li>";
    		PageNum +=		"<a href=\"javascript:"+type+"("+i+", '"+kind+"');\">"+i+"</a>";
    		PageNum +=	"</li>";
    	}
        $("#pageZone").append(PageNum);
    }
	var nextStep =	"<li>";
		nextStep +=		"<a ";
		if(Number(goTo) == Number(totalPage)){ nextStep += "href=\"#\""; }
		else{ nextStep += "href=\"javascript:"+type+"("+goNext+", '"+kind+"');\""; }
		nextStep +=		"><i class=\"fa fa-angle-right\"></i></a>";
		nextStep +=	"</li>";
	$("#pageZone").append(nextStep);
}

//검색버튼
var tab_name = null;
function gis_sherch(a) {
	$("#tab-01, #tab-02, #tab-03").each(function(){
		var tab = $(this);
		if( tab.css("display") == 'block' ){
			tab_name = tab.prop("id");
			//필수입력사항-1
			if		( tab_name == 'tab-01' ){	if( $("#fs_sig").val() == "0000" ){ alert("검색속도를 위해 [시군구]를 반드시 선택하세요."); $("#fs_sig").focus(); return; } }
			else if	( tab_name == 'tab-02' ){ 	if( $("#fn_sig").val() == "0000" ){ alert("검색속도를 위해 [시군구]를 반드시 선택하세요."); $("#fn_sig").focus(); return; } }
//			else if	( tab_name == 'tab-03' ){ 	if( $("#fg_gb").val() == null ){ alert("기본항목은 필수입력 항목입니다."); return; } }
			//필수입력사항-2
			if		( tab_name == 'tab-01' ){	if( $("input[id^=fs_gb_]:checked, #land-datalist input[id^=fs_]:checked").length == 0 ){ alert("[기본검색] 또는 [자산검색] 항목을 선택해주세요."); return; } }
			else if	( tab_name == 'tab-02' ){ 	if( $("input[id^=fn_gb_]:checked, #buld-datalist input[id^=fn_]:checked").length == 0 ){ alert("[기본검색] 또는 [자산검색] 항목을 선택해주세요."); return; } }
//			else if	( tab_name == 'tab-03' ){ 	if( $("input[id^=fg_gb_]:checked, #dist-datalist input[id^=fg_]:checked").length == 0 ){ alert("[기본검색] 또는 [자산검색] 항목을 선택해주세요."); return; } }
			//필수입력사항-3
			/*도시재생관련사업*/
			if		( $("#sa01-01").val() != "00" 	&& $("#sa01-02").val() == null ){ alert("관련사업 레이어를 선택해주세요.(중분류 까지 선택필요)"); return; }
			/*복합쇠퇴지역*/
			else if	( $("#sa01-04").val() != "00" 	&& $("#sa01-05").val() == null ){ alert("관련사업 레이어를 선택해주세요.(중분류 까지 선택필요)"); return; }
			/*대중교통역세권*/
			else if	( $("#sa01-07").val() != "00" 	&& $("#sa01-08").val() == null ){ alert("관련사업 레이어를 선택해주세요.(중분류 까지 선택필요)"); return; }
			/*사업가능여건*/
			else if	( $("#land01-08").val() != "00" && $("#land01-09").val() == null ){ alert("관련사업 레이어를 선택해주세요.(중분류 까지 선택필요)"); return; }
			/*대중교통역세권*/
			else if	( $("#land01-11").val() != "00" && $("#land01-12").val() == null ){ alert("관련사업 레이어를 선택해주세요.(중분류 까지 선택필요)"); return; }
			/*입지여건*/
			else if	( $("#buld01-04").val() != "00" && $("#buld01-05").val() == null ){ alert("관련사업 레이어를 선택해주세요.(중분류 까지 선택필요)"); return; }
			/*복합쇠퇴지역*/
			else if	( $("#buld01-07").val() != "00" && $("#buld01-08").val() == null ){ alert("관련사업 레이어를 선택해주세요.(중분류 까지 선택필요)"); return; }

			gis_sherch_go(a);
		}
	});
}

var SearchWindow =null;
function gis_sherch_go(a) {
	//검색조건 저장
	save_search();

	//초기화
    Redraw();

    //창 닫기
	if(SearchWindow != null) {
		SearchWindow.close();
	}

    var params = $("#GISinfoForm").serialize();
    SearchWindow = window.open("/searchList_popup.do?"+params, "searchList", "toolbar=no, width=1100, height=720,directories=no,status=no,scrollorbars=yes,resizable=yes");

	geoMap.render();
	geoMap.renderSync();
}


//검색조건 저장
function save_search(){
	$("#GISinfoForm").html(null);
	//검색종류
	var kind = null;
	var tab_name = null;
	$("#tab-01, #tab-02, #tab-03").each(function(){
		var tab = $(this);
		if( tab.css("display") == 'block' ){ tab_name = tab.prop("id"); }
	});
	//검색 구분(토지/건물/사업지구)
	$("#GISinfoForm").append("<input type=\"hidden\" name=\"kind\" value=\""+tab_name+"\">");
	//보기 개수
	$("#GISinfoForm").append("<input type=\"hidden\" name=\"cnt_kind\" value=\""+$("#cnt_kind").val()+"\">");

	if( tab_name == 'tab-01' ){
		kind = "fs";
		//추가항목 - 토지
		for(j=0; j<fs_KindList.length; j++){
			var tagName = $("#"+kind+"_"+fs_KindList[j]+"").prop("tagName");
			if( tagName != "DIV" ){
				var List = $("#"+kind+"_"+fs_KindList[j]+"").val();
				if( List != null ){
					for(i=0; i<List.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\""+fs_KindList[j]+"\" value=\""+List[i]+"\">"); }
				}
			}else{
				var val01 = $("#num_"+fs_KindList[j]+"_1").val();
				if( val01 != null && val01 != "" ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\""+fs_KindList[j]+"_1\" value=\""+$("#num_"+fs_KindList[j]+"_1").val()+"\">"); }
				var val02 = $("#num_"+fs_KindList[j]+"_2").val();
				if( val02 != null && val02 != "" ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\""+fs_KindList[j]+"_2\" value=\""+$("#num_"+fs_KindList[j]+"_2").val()+"\">"); }
			}
		}
		//자산데이터
		for(i=0; i<fs_dataList.length; i++){
			var dataList = $("#"+tab_name+"_Form_data input[id^="+kind+"_"+fs_dataList[i]+"_]:checked");
			if( dataList.length > 0 ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\""+fs_dataList[i]+"\" value=\""+kind+"\">");
				for(j=0; j<dataList.length; j++){
					$("#GISinfoForm").append("<input type=\"hidden\" name=\""+dataList[j].id.replace(kind+"_", "")+"\" value=\""+dataList[j].id.replace(""+kind+"_"+fs_dataList[i]+"_", "")+"\">");
				}
			}
		}
	}else if( tab_name == 'tab-02' ){
		kind = "fn";
		//추가항목 - 건물
		for(j=0; j<fn_KindList.length; j++){
			var tagName = $("#"+kind+"_"+fn_KindList[j]+"").prop("tagName");
			if( tagName != "DIV" ){
				var List = $("#"+kind+"_"+fn_KindList[j]+"").val();
				if( List != null ){
					for(i=0; i<List.length; i++){ $("#GISinfoForm").append("<input type=\"hidden\" name=\""+fn_KindList[j]+"\" value=\""+List[i]+"\">"); }
				}
			}else{
				var val01 = $("#num_"+fn_KindList[j]+"_1").val();
				if( val01 != null && val01 != "" ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\""+fn_KindList[j]+"_1\" value=\""+$("#num_"+fn_KindList[j]+"_1").val()+"\">"); }
				var val02 = $("#num_"+fn_KindList[j]+"_2").val();
				if( val02 != null && val02 != "" ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\""+fn_KindList[j]+"_2\" value=\""+$("#num_"+fn_KindList[j]+"_2").val()+"\">"); }
			}
		}
		//자산데이터
		for(i=0; i<fn_dataList.length; i++){
			var dataList = $("#"+tab_name+"_Form_data input[id^="+kind+"_"+fn_dataList[i]+"_]:checked");
			if( dataList.length > 0 ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\""+fn_dataList[i]+"\" value=\""+kind+"\">");
				for(j=0; j<dataList.length; j++){
					$("#GISinfoForm").append("<input type=\"hidden\" name=\""+dataList[j].id.replace(kind+"_", "")+"\" value=\""+dataList[j].id.replace(""+kind+"_"+fn_dataList[i]+"_", "")+"\">");
				}
			}
		}
	}else if( tab_name == 'tab-03' ){
		kind = "fg";
		//추가항목 - 사업지구
		for(j=0; j<fg_KindList.length; j++){
			var tagName = $("#"+kind+"_"+fg_KindList[j]+"").prop("tagName");
			if( tagName != "DIV" ){
				var List = $("#"+kind+"_"+fg_KindList[j]+"").val();
				if( List != null ){
					for(i=0; i<List.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\""+fg_KindList[j]+"\" value=\""+List[i]+"\">"); }
				}
			}else if( tagName == "INPUT" ){
				var List = $("#"+kind+"_"+fg_KindList[j]+"").val();
				if( List != null ){
					$("#GISinfoForm").append("<input type=\"hidden\" name=\""+fg_KindList[j]+"\" value=\""+List+"\">");
				}
			}else{
				var val01 = $("#num_"+fg_KindList[j]+"_1").val();
				if( val01 != null && val01 != "" ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\""+fg_KindList[j]+"_1\" value=\""+$("#num_"+fg_KindList[j]+"_1").val()+"\">"); }
				var val02 = $("#num_"+fg_KindList[j]+"_2").val();
				if( val02 != null && val02 != "" ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\""+fg_KindList[j]+"_2\" value=\""+$("#num_"+fg_KindList[j]+"_2").val()+"\">"); }
			}
		}
		//자산데이터
		for(i=0; i<fg_dataList.length; i++){
			var dataList = $("#"+tab_name+"_Form_data input[id^="+kind+"_"+fg_dataList[i]+"_]:checked");
			if( dataList.length > 0 ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\""+fg_dataList[i]+"\" value=\""+kind+"\">");
				for(j=0; j<dataList.length; j++){
					$("#GISinfoForm").append("<input type=\"hidden\" name=\""+dataList[j].id.replace(kind+"_", "")+"\" value=\""+dataList[j].id.replace(""+kind+"_"+fg_dataList[i]+"_", "")+"\">");
				}
			}
		}
	}


	//기본항목
	var gbList = $("#"+tab_name+"_Form input[id^="+kind+"_gb_]:checked");
	if( gbList != null ){
		for(i=0; i<gbList.length; i++){ $("#GISinfoForm").append("<input type=\"hidden\" name=\"gb\" value=\""+gbList[i].id.replace(kind+"_gb_", "")+"\">"); }
	}
	if( tab_name == 'tab-02' ){
		if( $("#fn_gbname").val() != null && $("#fn_gbname").val() != "" ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\"gbname\" value=\""+$("#fn_gbname").val()+"\">"); }
	}

	//사업지구는 시군구,읍면동 분류가 없음 (문의필요)
//	if( tab_name != 'tab-03' ){
		if( $("#"+kind+"_sig").val() != null ){
			$("#GISinfoForm").append("<input type=\"hidden\" name=\"sig\" value=\""+$("#"+kind+"_sig").val()+"\">");
		}
		if( $("#"+kind+"_emd").val() != null ){
			$("#GISinfoForm").append("<input type=\"hidden\" name=\"emd\" value=\""+$("#"+kind+"_emd").val()+"\">");
		}
//	}

	//공간분석
	if( $("#searching_space").css("display") == 'block' ){
		var sel = $("#sel").val()
		$("#GISinfoForm").append("<input type=\"hidden\" name=\"sel\" value=\""+sel+"\">");
		if(sel == "sa01"){ //관련사업 검색
			if( $("#sa01-01").val() != "00" ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\"space_gb\" value=\""+$("#sa01-01").val()+"\">");	//도시재생관련사업 - 대분류
				var List02 = $("#sa01-02").val(); //도시재생관련사업 - 중분류
				if( List02 != null ){
					for(i=0; i<List02.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"space_gb_cd02\" value=\""+List02[i]+"\">"); }
				}
				var List03 = $("#sa01-03").val(); //도시재생관련사업 - 소분류
				if( List03 != null ){
					for(i=0; i<List03.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"space_gb_cd03\" value=\""+List03[i]+"\">"); }
				}
			}
			if( $("#sa01-04").val() != "00" ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\"sub_p_decline_gb\" value=\""+$("#sa01-04").val()+"\">");	//복합쇠퇴지역 - 대분류
				var List05 = $("#sa01-05").val(); //복합쇠퇴지역 - 중분류
				if( List05 != null ){
					for(i=0; i<List05.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"sub_p_decline_val\" value=\""+List05[i]+"\">"); }
				}
				var List06 = $("#sa01-06").val(); //복합쇠퇴지역 - 소분류
				if( List06 != null ){
					for(i=0; i<List06.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"sub_p_decline\" value=\""+List06[i]+"\">"); }
				}
			}
			if( $("#sa01-07").val() != "00" ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\"public_transport_val\" value=\""+$("#sa01-07").val()+"\">");	//대중교통역세권 - 중분류
				var List08 = $("#sa01-08").val(); //대중교통역세권 - 소분류
				if( List08 != null ){
					for(i=0; i<List08.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"public_transport\" value=\""+List08[i]+"\">"); }
				}
			}
		}else if(sel == "sa02"){ //버퍼분석 검색

		}else if(sel == "sa03"){ //역세권 사업 추진 대상 검토

		}else if(sel == "buld01"){ //낙후(저층)주거지 찾기
			$("#GISinfoForm").append("<input type=\"hidden\" name=\"outher\" value=\"99\">");

			var List1 = $("#buld01-01").val();
			if( List1 != null ){
				for(i=0; i<List1.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"spfc\" value=\""+List1[i]+"\">"); }
			}
			var List2 = $("#buld01-02").val();
			if( List2 != null ){
				for(i=0; i<List2.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"road_side\" value=\""+List2[i]+"\">"); }
			}
			var List3 = $("#buld01-03").val();
			if( List3 != null ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\"buffer\" value=\""+List3+"\">");
			}


			if( $("#buld01-04").val() != "00" ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\"space_gb\" value=\""+$("#buld01-04").val()+"\">");	//입지여건 - 대분류
				var List02 = $("#buld01-05").val(); //입지여건 - 중분류
				if( List02 != null ){
					for(i=0; i<List02.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"space_gb_cd02\" value=\""+List02[i]+"\">"); }
				}
				var List03 = $("#buld01-06").val(); //입지여건 - 소분류
				if( List03 != null ){
					for(i=0; i<List03.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"space_gb_cd03\" value=\""+List03[i]+"\">"); }
				}
			}

			if( $("#buld01-07").val() != "00" ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\"sub_p_decline_gb\" value=\""+$("#buld01-07").val()+"\">");	//복합쇠퇴지역 - 대분류
				var List05 = $("#buld01-08").val(); //복합쇠퇴지역 - 중분류
				if( List05 != null ){
					for(i=0; i<List05.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"sub_p_decline_val\" value=\""+List05[i]+"\">"); }
				}
				var List06 = $("#buld01-09").val(); //복합쇠퇴지역 - 소분류
				if( List06 != null ){
					for(i=0; i<List06.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"sub_p_decline\" value=\""+List06[i]+"\">"); }
				}
			}
		}else if(sel == "land01"){ //국공유지 개발/활용 대상지
			$("#GISinfoForm").append("<input type=\"hidden\" name=\"outher\" value=\"99\">");

			var List1 = $("#land01-02").val();
			if( List1 != null ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\"cp_date_1\" value=\""+List1+"\">"); }
			var List2 = $("#land01-03").val();
			if( List2 != null ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\"cp_date_2\" value=\""+List2+"\">"); }
			var List3 = $("#land01-04").val();
			if( List3 != null ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\"bdtldr_1\" value=\""+List3+"\">"); }
			var List4 = $("#land01-05").val();
			if( List4 != null ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\"bdtldr_2\" value=\""+List4+"\">"); }
			var List5 = $("#land01-06").val();
			if( List5 != null ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\"cpcty_rt_1\" value=\""+List5+"\">"); }
			var List6 = $("#land01-07").val();
			if( List6 != null ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\"cpcty_rt_2\" value=\""+List6+"\">"); }

			if( $("#land01-08").val() != "00" ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\"space_gb\" value=\""+$("#land01-08").val()+"\">");	//사업가능여건 - 대분류
				var List02 = $("#land01-09").val(); //사업가능여건 - 중분류
				if( List02 != null ){
					for(i=0; i<List02.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"space_gb_cd02\" value=\""+List02[i]+"\">"); }
				}
				var List03 = $("#land01-10").val(); //사업가능여건 - 소분류
				if( List03 != null ){
					for(i=0; i<List03.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"space_gb_cd03\" value=\""+List03[i]+"\">"); }
				}
			}

			if( $("#land01-11").val() != "00" ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\"public_transport_val\" value=\""+$("#land01-11").val()+"\">");	//대중교통역세권 - 중분류
				var List08 = $("#land01-12").val(); //대중교통역세권 - 소분류
				if( List08 != null ){
					for(i=0; i<List08.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"public_transport\" value=\""+List08[i]+"\">"); }
				}
			}

		}






	}

}


//도형 그리기
function map_draw(geom){
	if(geom == null){
		alert("도형정보가 없습니다.");
	}else{
		//그래픽 초기화
		if(vectorLayer != null || vectorLayer != ''){
			vectorSource.clear();
			geoMap.removeLayer(vectorLayer);
		}

		if(geom.indexOf('POINT') >= 0) {
			//create the style
			var iconStyle2 = new ol.style.Style({
				image: new ol.style.Icon({
					anchor: [0.5, 40],
					anchorXUnits: 'fraction',
					anchorYUnits: 'pixels',
					opacity: 1,
					size: [40, 40],
					scale: 0.5,
					src: '/jsp/SH/img/pin04_sil.png'
				})
		    });

		    vectorLayer = new ol.layer.Vector({
		        source: vectorSource,
		        style: iconStyle2
		    });

		    var reader = new ol.format.WKT();
		    var geometry = reader.readGeometry(geom, {
		    	  dataProjection: 'EPSG:4326',
		    	  featureProjection: 'EPSG:3857'
		    	});
			var iconFeature2 = new ol.Feature({
		           geometry: geometry
		    });
			vectorSource.addFeature(iconFeature2);
		} else {
			//create the style
			var iconStyle2 = new ol.style.Style({
	// 	    	fill: new ol.style.Fill({
	// 	      		color: 'red'
	// 	    	}),
		    	stroke: new ol.style.Stroke({
		    		color: 'red',
		      		width: 1.5,
		      		lineDash: [4]
		    	})
		    });
		    vectorLayer = new ol.layer.Vector({
		        source: vectorSource,
		        style: iconStyle2
		    });

			var coord_v = geom;
			coord_v = coord_v.replace('MULTIPOLYGON', '');
			coord_v = coord_v.replace('(((', '');
			coord_v = coord_v.replace('))),', '');
			coord_v = coord_v.replace(')))', '');
			var coord_sp = coord_v.split(",");
			var coord_sp_t = new Array();

			for(j=0; j<coord_sp.length; j++){
				if(coord_sp[j] != ""){
					var arry1 = coord_sp[j].split(' ');
					var val = ol.proj.transform([ Number( arry1[0] ), Number( arry1[1] ) ], 'EPSG:4326', 'EPSG:900913');
					coord_sp_t[j] = new Array( val[0], val[1] );
				}
			}

			var iconFeature2 = new ol.Feature({
		           geometry: new ol.geom.Polygon([ coord_sp_t ])
		    });
			vectorSource.addFeature(iconFeature2);
		}

	    geoMap.addLayer(vectorLayer);
	}
	geoMap.renderSync();
	geoMap.render();
}

//도형 그리기 - 테스트
function map_drawss(geom){
	if(geom == null){
		alert("도형정보가 없습니다.");
	}else{
		//그래픽 초기화
		if(vectorLayer != null || vectorLayer != ''){
			vectorSource.clear();
			geoMap.removeLayer(vectorLayer);
		}

		//create the style
		var iconStyle2 = new ol.style.Style({
// 	    	fill: new ol.style.Fill({
// 	      		color: 'red'
// 	    	}),
	    	stroke: new ol.style.Stroke({
	    		color: 'red',
	      		width: 1.5,
	      		lineDash: [4]
	    	})
	    });
	    vectorLayer = new ol.layer.Vector({
	        source: vectorSource,
	        style: iconStyle2
	    });

		var coord_v = geom;
		coord_v = coord_v.replace('MULTIPOLYGON', '');
		coord_v = coord_v.replace('(((', '');
		coord_v = coord_v.replace('))),', '');
		coord_v = coord_v.replace(')))', '');
		var coord_sp = coord_v.split(",");
		var coord_sp_t = new Array();

		for(j=0; j<coord_sp.length; j++){
			if(coord_sp[j] != ""){
				var arry1 = coord_sp[j].split(' ');
				var val = ol.proj.transform([ Number( arry1[0] ), Number( arry1[1] ) ], 'EPSG:5181', 'EPSG:900913');
				coord_sp_t[j] = new Array( val[0], val[1] );
			}
		}

		var iconFeature2 = new ol.Feature({
	           geometry: new ol.geom.Polygon([ coord_sp_t ])
	    });
		vectorSource.addFeature(iconFeature2);

	    geoMap.addLayer(vectorLayer);
	}
	geoMap.renderSync();
	geoMap.render();
}

//화면이동
function map_move(addr_x, addr_y, geom){
	//화면 클리어
	if(toggles){
		main_toggle();
	}


	if(geom != null && geom != ""){
		map_draw(geom);
	}else{
		alert("도형정보가 없습니다.");
		return;
	}
	var spot = ol.proj.transform([Number(addr_x), Number(addr_y)], 'EPSG:4326', 'EPSG:900913');
	view.setCenter(spot);
	view.setZoom(18);
	geoMap.renderSync();
	geoMap.render();
}





//지도화면에 도형 그리기 - 검색결과 전체
function GISSearchList_Draw(){
	var geomList = $("input[name='geom[]']").val();
	geomList = geomList.replace(",MULTIPOLYGON", "MULTIPOLYGON");
	geomList = geomList.split("MULTIPOLYGON");

	//검색결과 draw reset
	if(vectorLayer2 != null || vectorLayer2 != ''){
		vectorSource2.clear();
		geoMap.removeLayer(vectorLayer2);
		$( ".tooltip").remove();
	}
	//화면 클리어
	if(toggles){
		main_toggle();
	}


	//create the style
    var iconStyle2 = new ol.style.Style({
    	stroke: new ol.style.Stroke({
    		color: 'blue',
      		width: 1.2
//      		,lineDash: [4]
    	})
    });
    vectorLayer2 = new ol.layer.Vector({
        source: vectorSource2,
        style: iconStyle2
    });

	for (i=1; i<geomList.length; i++) {
		coord = geomList[i];

		//검색결과 draw
		if( coord != null ){
			var coord_v = coord;
			coord_v = coord_v.replace('(((', '');
			coord_v = coord_v.replace('))),', '');
			coord_v = coord_v.replace(')))', '');
			var coord_sp = coord_v.split(",");
			var coord_sp_t = new Array();

			for(j=0; j<coord_sp.length; j++){
				var arry1 = coord_sp[j].split(' ');
				var val = ol.proj.transform([ Number( arry1[0] ), Number( arry1[1] ) ], 'EPSG:4326', 'EPSG:900913');
				coord_sp_t[j] = new Array( val[0], val[1] );
			}

			var iconFeature2 = new ol.Feature({
		           geometry: new ol.geom.Polygon([ coord_sp_t ])
		    });
			vectorSource2.addFeature(iconFeature2);

		}
	}
	geoMap.addLayer(vectorLayer2);
	geoMap.renderSync();
	geoMap.render();

}





//엑셀 다운로드
function GISSearchList_downExcel(type){
	if(!confirm("엑셀파일 다운로드 하시겠습니까?")){return;}

	$("#GISinfoForm").attr("target","_parent");
    $("#GISinfoForm").attr("method", "post");
    $("#GISinfoForm").attr("action","/GISSearchList_Excel_Download.do?target="+type);
    $("#GISinfoForm").submit();
}

//SHP 다운로드
function GISSearchList_downSHP(){
	alert("준비중입니다.");
}


//유창범 검색결과 전체표출 추가 20180626
function GISSearchList_DrawAll(geomList){
	//검색결과 draw reset
	if(vectorLayer2 != null || vectorLayer2 != ''){
		vectorSource2.clear();
		geoMap.removeLayer(vectorLayer2);
		$( ".tooltip").remove();
	}
	//화면 클리어
	if(toggles){
		main_toggle();
	}

	vectorSource2 = new ol.source.Vector({
        features: (new ol.format.GeoJSON()).readFeatures(geomList)
      });

	//create the style
    var iconStyle2 = new ol.style.Style({
    	stroke: new ol.style.Stroke({
    		color: 'blue',
      		width: 1.2
//      		,lineDash: [4]
    	})
    });
    vectorLayer2 = new ol.layer.Vector({
        source: vectorSource2,
        style: iconStyle2
    });

	geoMap.addLayer(vectorLayer2);
	geoMap.renderSync();
	geoMap.render();
}














