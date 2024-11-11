/**
 * 속성검색 관련 함수
 */
//Content_SH_Search.jsp 함수 이동
//2020 추가 - shpae 업로드 표출시, 빈집 외부 연계시

var stroke = new ol.style.Stroke({color: 'rgba(0, 0, 0, 1)', width: 2});
var fill = new ol.style.Fill({color: 'rgba(255, 0, 0, 1)'});
function fn_gis_map_draw_geojson(data,idx,layer_nm) {
	console.log("geoJsonDATA!!",data)
	
	//그래픽 초기화
	if(vectorLayer != null || vectorLayer != ''){
		vectorSource.clear();
		geoMap.removeLayer(vectorLayer);
	}
	
	//create the style
	var iconStyle2;
	
	if(idx != null || idx != undefined ){
		var type = getGeometryType(data);
		iconStyle2 = jsonToStyle(myDataInfo[idx].style,type);
	}else{
		iconStyle2 = new ol.style.Style({
	    	/* fill: new ol.style.Fill({
	      		color: 'red'
	    	}), */
	    	stroke: new ol.style.Stroke({
	    		color: 'red',
	      		width: 1.5,
	      		lineDash: [4]
	    	}),
	    	image: new ol.style.RegularShape({
	  		  fill: fill,
	  		  stroke: stroke,
	  		  points: 4,
	  		  radius: parseInt(7),
	  		  angle: Math.PI / 4
	  		})
			/*image: new ol.style.Icon({
				anchor: [0.5, 40],
				anchorXUnits: 'fraction',
				anchorYUnits: 'pixels',
				opacity: 1,
				size: [40, 40],
				scale: 0.5,
				src: '/resources/img/pin04_sil.png'
			})*/
	    });
	}

	 var reader = new ol.format.GeoJSON();
	var features = reader.readFeatures(data, {
        featureProjection: 'EPSG:900913' //기본값 4326
    }); 
    vectorSource.addFeatures(features);
    console.log("vectorSource",vectorSource)
	vectorLayer = new ol.layer.Vector({
        source: vectorSource,
        name : layer_nm, //data.name,
        style: iconStyle2
    });
    console.log("vectorLayer",vectorLayer)
   
	//기존vectorSource.addFeatures(reader.readFeatures(data));

    
    
   /* geoMap.addLayer(vectorLayer);
    geoMap.getView().fit(vectorLayer.getSource().getExtent(), geoMap.getSize());
    geoMap.getView().animate({
    	  zoom: geoMap.getView().getZoom() - 3,
    	  duration: 500
    });
	geoMap.renderSync();
	geoMap.render();*/
    
    geoMap.addLayer(vectorLayer);

    geoMap.getView().fit(vectorLayer.getSource().getExtent(), {
        size: geoMap.getSize(),
        maxZoom: 18 
    });
    geoMap.getView().animate({
        zoom: geoMap.getView().getZoom() - 3,
        duration: 500
    });
}


//Content_SH_Search.jsp 함수 이동
//2020 추가 - 크릭시
function fn_gis_map_draw_feature(data) {
	//그래픽 초기화
	if(vectorLayer != null || vectorLayer != ''){
		vectorSource.clear();
		geoMap.removeLayer(vectorLayer);
	}

	//create the style
	var iconStyle2 = new ol.style.Style({
    	/* fill: new ol.style.Fill({
      		color: 'red'
    	}), */
    	stroke: new ol.style.Stroke({
    		color: 'red',
      		width: 2.5,
      		lineDash: [8]
    	}),
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
        source: vectorSource ,
        style: iconStyle2
    });

	vectorSource.addFeatures(data);

    geoMap.addLayer(vectorLayer);
    /* geoMap.getView().fit(vectorLayer.getSource().getExtent(), geoMap.getSize());
    geoMap.getView().animate({
    	  zoom: geoMap.getView().getZoom() - 1,
    	  duration: 500
    }); */
	geoMap.renderSync();
	geoMap.render();
}

//Content_SH_Search.jsp 함수 이동
//결과 목록 클릭 시 지도 이동 함수
function fn_gis_map_move(data) {
	if(data != null && data.length > 0 && data[0].x != null && data[0].x != "" && data[0].x != undefined && data[0].y != null && data[0].y != "" && data[0].y != undefined) {
		if(toggles){
			main_toggle();
		}

		if(data[0].geom != null && data[0].geom != "") {
			fn_gis_map_draw_wkt(data);
		}

		var spot = [Number(data[0].x), Number(data[0].y)];
		view.setCenter(spot);
		view.setZoom(18);
		geoMap.renderSync();
		geoMap.render();
	} else {
		alert("도형정보가 없습니다.");
		return;
	}
}

//Content_SH_Search.jsp 함수 이동
//2020 추가 - 택지, 임대, 자산 검색결과 이동시
function fn_gis_map_draw_wkt(data) {
	//그래픽 초기화
	if(vectorLayer != null || vectorLayer != ''){
		vectorSource.clear();
		geoMap.removeLayer(vectorLayer);
	}

	//create the style
	var iconStyle2 =[ 
		new ol.style.Style({
    	stroke: new ol.style.Stroke({
    		color: 'white',
      		width: 3
    	}),
		image: new ol.style.Icon({
			anchor: [0.5, 40],
			anchorXUnits: 'fraction',
			anchorYUnits: 'pixels',
			opacity: 1,
			size: [40, 40],
			scale: 0.5,
			src: '/resources/img/pin04_sil.png'
			})
    	}),
    	new ol.style.Style({
        	stroke: new ol.style.Stroke({
        		color: 'red',
          		width: 2,
          		lineDash: [4]
        	}),
    		image: new ol.style.Icon({
    			anchor: [0.5, 40],
    			anchorXUnits: 'fraction',
    			anchorYUnits: 'pixels',
    			opacity: 1,
    			size: [40, 40],
    			scale: 0.5,
    			src: '/jsp/SH/img/pin04_sil.png'
    		})
        })
	];

    vectorLayer = new ol.layer.Vector({
        source: vectorSource,
        style: iconStyle2
    });

    var reader = new ol.format.WKT();
    for(i=0; i<data.length; i++) {
	    var geometry = reader.readGeometry(data[i].geom);
		var iconFeature2 = new ol.Feature({
	           geometry: geometry
	    });
		vectorSource.addFeature(iconFeature2);
    }

    //레이어 제일위에 표출하기
    vectorLayer.setZIndex(parseInt(10000));

    geoMap.addLayer(vectorLayer);
    geoMap.getView().fit(vectorLayer.getSource().getExtent(), geoMap.getSize());
    geoMap.getView().animate({
    	  zoom: geoMap.getView().getZoom() - 2,
    	  duration: 500
    });
	geoMap.renderSync();
	geoMap.render();
}


//Content_SH_Search.jsp 함수 이동
//속성검색 검색버튼 클릭 시 작동
var SearchWindow =null;
var c_url,c_sendData,c_title,c_search_type = null;
function fn_gis_sherch_new(a) {
	$("#tab-04, #tab-05, #tab-06").each(function(){
		
		var tab = $(this);
		
		if( tab.css("display") == 'block' ){
			tab_name = tab.prop("id");
			console.log("토지검색!!!", tab_name)
			var url;
			var sendData;
			var title;
			var search_type;
			var comprehensive = 'N';

			if( tab_name == 'tab-04' ){
				url = global_props.domain+'/web/cmmn/gisDataBuildLandList.do';
				sendData = $("#tab-04_Form").serialize();
				title = $("#tab-04").children().find("#search_type option:checked").text();
				search_type = $("#tab-04").children().find("#search_type option:checked").val();
				
				c_url = global_props.domain+'/web/cmmn/gisDataBuildLandList.do';
				c_sendData = '#tab-04_Form'
				c_title = $("#tab-04").children().find("#search_type option:checked").text();
				c_search_type = $("#tab-04").children().find("#search_type option:checked").val();
			} else if( tab_name == 'tab-05' ){
				url = global_props.domain+'/web/cmmn/gisDataRentalList.do';
				sendData = $("#tab-05_Form").serialize();
				title = $("#tab-05").children().find("#search_type option:checked").text();
				search_type = $("#tab-05").children().find("#search_type option:checked").val();
				comprehensive = 'Y';
				
				c_url = global_props.domain+'/web/cmmn/gisDataRentalList.do';
				c_sendData = '#tab-05_Form'
				c_title = $("#tab-05").children().find("#search_type option:checked").text();
				c_search_type = $("#tab-05").children().find("#search_type option:checked").val();
				
				
			} else if( tab_name == 'tab-06' ){
				
				 var params = $("#tab-06_Form").serialize();
				console.log("params : ", params);
			   
			    //SearchWindow = window.open("about:blank","_blank","toolbar=no, width=1100, height=720,directories=no,status=no,scrollorbars=yes,resizable=yes");
				
			    url = global_props.domain+'/web/cmmn/gisDataAssetList.do';
				sendData = $("#tab-06_Form").serialize();
				title = $("#tab-06").children().find("#search_type option:checked").text();
				search_type = $("#tab-06").children().find("#search_type option:checked").val();
				
				
				c_url = global_props.domain+'/web/cmmn/gisDataAssetList.do';
				c_sendData = '#tab-06_Form'
				c_title = $("#tab-06").children().find("#search_type option:checked").text();
				c_search_type = $("#tab-06").children().find("#search_type option:checked").val();
					 
			}
			
			
			SearchWindow = window.open(global_props.domain+"/searchListPopup.do?"+params, "searchList", "toolbar=no, width=1100, height=720,directories=no,status=no,scrollorbars=yes,resizable=yes");

			console.log(sendData);
		}
	});
}

	// 엑셀저장
var tableId = '';
var fileName = 'export.xls';

function exportTableToExcel(id, file) {
    var downloadLink;
    var dataType = 'application/vnd.ms-excel';
    var tableSelect = document.getElementById(id);

    // Specify file name
    file = file?file+'.xls':'excel_data.xls';

    //if(navigator.msSaveOrOpenBlob)
    if(window.navigator.msSaveBlob)
    {
        //var blob = new Blob(['\ufeff', tableHTML], {
        //    type: dataType
        //});
        //window.navigator.msSaveOrOpenBlob( blob, file);

        var tableHTML = tableSelect.outerHTML

        var blob = new Blob([ tableHTML ], {
			type : "application/csv;charset=utf-8;"
		});
        window.navigator.msSaveBlob( blob, file);
    }
    else
    {
    	var tableHTML = tableSelect.outerHTML.replace(/ /g, '%20');

    	// Create download link element
	    downloadLink = document.createElement("a");

	    document.body.appendChild(downloadLink);
	
	        downloadLink.href = 'data:' + dataType + 'charset=utf-8,%EF%BB%BF' + tableHTML;
        downloadLink.download = file;
        downloadLink.click();
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
			var iconStyle2 =[ 
				new ol.style.Style({
		    	stroke: new ol.style.Stroke({
		    		color: 'white',
		      		width: 3
		    	})
		    	}),
		    	new ol.style.Style({
		        	stroke: new ol.style.Stroke({
		        		color: 'red',
		          		width: 2,
		          		lineDash: [4]
		        	})
		        })
			];
			
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
					//var val  =[ Number( arry1[0] ), Number( arry1[1] ) ];
					var val = ol.proj.transform([ Number( arry1[0] ), Number( arry1[1] ) ], 'EPSG:4326', 'EPSG:900913');
					coord_sp_t[j] = new Array( val[0], val[1] );
				}
			}

			var iconFeature2 = new ol.Feature({
		           geometry: new ol.geom.Polygon([ coord_sp_t ])
		    });
			vectorSource.addFeature(iconFeature2);
		}
		//레이어 제일위에 표출하기
	    vectorLayer.setZIndex(parseInt(10000));
	    
	    geoMap.addLayer(vectorLayer);
	}
	geoMap.renderSync();
	geoMap.render();
}

//속성검색 초기화 버튼 클릭 시 작동
function fn_gis_clear_new() {
	$("#tab-04, #tab-05, #tab-06").each(function(){
		var tab = $(this);
		if( tab.css("display") == 'block' ){
			tab_name = tab.prop("id");

			if( tab_name == 'tab-04' )
	   			$('#tab-04_Form [name="search_type"]').val('SITE').trigger('change');
			else if( tab_name == 'tab-05' )
				$('#tab-05_Form [name="search_type"]').val('APT').trigger('change');
			else if( tab_name == 'tab-06' )
				$('#tab-06_Form [name="search_type"]').val('ASSET_APT').trigger('change');
		}
	});
}


