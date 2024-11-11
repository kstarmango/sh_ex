﻿﻿
	//레이어 기본설정
	//var proxy_url = "/mapInclude/getProxy.do?url=";
// 운영 ssl	
/*	var proxy_url = "/vworldapi";
	var xworld_url = "/xworldapi";
	var vworld_url = "/2dvworldapi";*/

//	var layer_url = 'http://connect.miraens.com:59900/geoserver/SH_LM/'; //개발서버
//	var layer_url = 'http://192.168.110.154:8080/geoserver/SH_LM/'; //실서버
	var layer_url = 'http://dev.syesd.co.kr:12101/geoserver/SH_LM/'; //외부서버

	//var layer_url = ' localhost:38080/geoserver'; //외부서버
	function get_WMSlayer(layername){

		console.log("wms",layer_url)
        return new ol.layer.Image({
        	name: layername,
            source: new ol.source.ImageWMS({
                //url: proxy_url+layer_url+'wms ',
            	url: global_props['wmsProxyUrl'],
            	serverType:'geoserver',
                params:{ 'LAYERS':layername, 'TILED':true, 'url':layer_url+'wms'}
               ,crossOrigin: 'anonymous'
            	   
            })
        //,opacity: 0
     		});
    }  

	function get_WMSlayer22(layername, style){
        return new ol.layer.Image({
        	name: layername,
            source: new ol.source.ImageWMS({
            	url: layer_url+'wms',
                serverType:'geoserver',
                params:{ 'LAYERS':layername, 'TILED':true, 'STYLES':style },
                crossOrigin: 'anonymous' })
     		});
    }

    function get_TiledWMSlayer(layername){
        return new ol.layer.Tile({
            visible: true,
            name: layername,
            source: new ol.source.TileWMS({
                url: layer_url+'wms',
                params:{ 'FORMAT':'image/png', 'VERSION':'1.1.1', 'LAYERS':layername },
                crossOrigin: 'null' })
        });
    }

	function get_WFSlayer(layername){
	    return new ol.layer.Vector({
	    	name: layername,
			source: new ol.source.Vector({
				format: new ol.format.GeoJSON(),
				url: function(extent, resolution, projection) {
					return layer_url+"wfs?REQUEST=GetFeature&SERVICE=wfs&VERSION=1.1.0&TYPENAME=" + layername + "&" + ",EPSG:3857&OUTPUTFORMAT=application/json";
				},
				crossOrigin: 'anonymous'
			}),
			style: new ol.style.Style({
			    stroke: new ol.style.Stroke({
			      color: 'rgba(255, 153, 0, 1)',
			      width: 2
			    }),
			    fill: new ol.style.Fill({
		      		color: 'rgba(255, 255, 255, 0.2)'
		    	})
			 })
		});
	}

	function get_XYZlayer(){
        return new ol.layer.Tile({
        	name: layername,
            source: new ol.source.XYZ({
                url: layer_url,
                crossOrigin: 'anonymous' })
        });
    }


	//http://2d.vworld.kr:8895/2DCache/gis/map/WMS2?apiKey=BFFB2C1C-DD2D-3D74-83D9-EB15D4F041C8&domain=localhost:8091
	//http://2d.vworld.kr:8895/2DCache/gis/map/WMS2?apiKey=C1314EF3-8396-3600-95A8-AC6FE95A4A91&domain=192.168.110.154:8091
	//var layer_url2 = 'http://2d.vworld.kr:8895/2DCache/gis/map/WMS2?apiKey=BFFB2C1C-DD2D-3D74-83D9-EB15D4F041C8&domain=localhost:8091'; //브이월드
	
	
	//C1314EF3-8396-3600-95A8-AC6FE95A4A91
	// 37C45FB4-085E-33DF-BE02-E9E505572E78
	//6436A16F-8375-331E-A0C0-FB4157C858C9 -> 230518
	var layer_url2 = 'http://2d.vworld.kr:8895/2DCache/gis/map/WMS2'; //브이월드
	
	
// 운영 ssl	
/*	function get_vWorldMap(layername, styles){
		return new ol.layer.Tile({
			name: layername,
            source: new ol.source.TileWMS({
                url: vworld_url+'/2DCache/gis/map/WMS2',
                params:{
                	'apiKey': '37C45FB4-085E-33DF-BE02-E9E505572E78', 'domain': '192.168.110.154:8091',
                	'FORMAT':'image/png', 'LAYERS':layername, 'STYLES': styles, 'TILED': true},
                crossOrigin: null
            })
        });
    }
	

	//브이월드 - 배경지도(일반)
	var vBase = new ol.layer.Tile({
		source: new ol.source.XYZ({
            url: proxy_url+"/req/wmts/1.0.0/37C45FB4-085E-33DF-BE02-E9E505572E78/Base/{z}/{y}/{x}.png",
            params: { 'FORMAT': 'image/png', 'TILED': true },
            crossOrigin: 'anonymous'
		})
    });

	//브이월드 - 배경지도(위성)
	var vSatellite = new ol.layer.Tile({
		source: new ol.source.XYZ({
            url: xworld_url+"/2d/Satellite/201612/{z}/{x}/{y}.jpeg",
            params: { 'FORMAT': 'image/png', 'TILED': true },
            crossOrigin: 'anonymous'
		})
    });

	//브이월드 - 배경지도(하이브리드)
	var vHybrid = new ol.layer.Tile({
		source: new ol.source.XYZ({
            url: proxy_url+"/req/wmts/1.0.0/37C45FB4-085E-33DF-BE02-E9E505572E78/Hybrid/{z}/{y}/{x}.png",
            params: { 'FORMAT': 'image/png', 'TILED': true },
            crossOrigin: 'anonymous'
		})
    });

	//브이월드 - 배경지도(흑백지도)
	var vgray = new ol.layer.Tile({
		source: new ol.source.XYZ({
            url: proxy_url+"/req/wmts/1.0.0/37C45FB4-085E-33DF-BE02-E9E505572E78/gray/{z}/{y}/{x}.png",
            params: { 'FORMAT': 'image/png', 'TILED': true },
            crossOrigin: 'anonymous'
		})
    });*/
	
	
	

	function get_vWorldMap(layername, styles){
		return new ol.layer.Tile({
			name: layername,
            source: new ol.source.TileWMS({
                url: global_props['wmsProxyUrl']+"?url="+layer_url2,
                params:{
                	'apiKey': global_props['vworldKey'], 'domain': '192.168.110.154:8091',  //6436A16F-8375-331E-A0C0-FB4157C858C9
                	'FORMAT':'image/png', 'LAYERS':layername, 'STYLES': styles, 'TILED': true},
                crossOrigin: null
            })
        });
    }

	//var proxy_url = "/mapInclude/getProxy.do?url=";
	//브이월드 - 배경지도(일반)
	var vBase = new ol.layer.Tile({
		source: new ol.source.XYZ({
			//url: "http://api.vworld.kr/req/wmts/1.0.0/"+global_props['vworldKey']+"/Base/{z}/{y}/{x}.png",
			url: global_props['wmsProxyUrl']+"?url=http://api.vworld.kr/req/wmts/1.0.0/"+global_props['vworldKey']+"/Base/{z}/{y}/{x}.png",
			//url: global_props['wmsProxyUrl']+"?url=https://cdn.vworld.kr/2d/Base/service/{z}/{x}/{y}.png", //브이월드 api오류로 인해 임시 사용
            params: { 'FORMAT': 'image/png', 'TILED': true },
            crossOrigin: 'anonymous'
		})
    });

	//브이월드 - 배경지도(위성)
	var vSatellite = new ol.layer.Tile({
		source: new ol.source.XYZ({
            //url: proxy_url+"http://xdworld.vworld.kr:8080/2d/Satellite/201612/{z}/{x}/{y}.jpeg",
			url: global_props['wmsProxyUrl']+"?url=http://xdworld.vworld.kr:8080/2d/Satellite/201612/{z}/{x}/{y}.jpeg",
            params: { 'FORMAT': 'image/png', 'TILED': true },
            crossOrigin: 'anonymous'
		})
    });

	
	//브이월드 - 배경지도(하이브리드)
	var vHybrid = new ol.layer.Tile({
		source: new ol.source.XYZ({
            //url: proxy_url+"http://api.vworld.kr/req/wmts/1.0.0/"+global_props['vworldKey']+"/Hybrid/{z}/{y}/{x}.png",
			url: global_props['wmsProxyUrl']+"?url=http://api.vworld.kr/req/wmts/1.0.0/"+global_props['vworldKey']+"/Hybrid/{z}/{y}/{x}.png",
			params: { 'FORMAT': 'image/png', 'TILED': true },
            crossOrigin: 'anonymous'
		})
    });

	//브이월드 - 배경지도(흑백지도)
	var vgray = new ol.layer.Tile({
		source: new ol.source.XYZ({
            //url: proxy_url+"http://api.vworld.kr/req/wmts/1.0.0/"+global_props['vworldKey']+"/white/{z}/{y}/{x}.png",
			url: global_props['wmsProxyUrl']+"?url=http://api.vworld.kr/req/wmts/1.0.0/"+global_props['vworldKey']+"/white/{z}/{y}/{x}.png",
			params: { 'FORMAT': 'image/png', 'TILED': true },
            crossOrigin: 'anonymous'
		})
    });

	//브이월드 - 지적도
	var cbnd = get_vWorldMap("LP_PA_CBND_BUBUN,LP_PA_CBND_BONBUN", "LP_PA_CBND_BUBUN,LP_PA_CBND_BONBUN");

	//BaseMap 설정
	var layers = [ vBase, vSatellite, vHybrid, vgray, cbnd ];

	var intval = "0.7"; //투영도

//-----------------------------지도 설정--------------------------------------
	//좌표값
	var mousePositionControl = new ol.control.MousePosition({
	    className: 'custom-mouse-position',
	    target: document.getElementById('location'),
	    coordinateFormat: ol.coordinate.createStringXY(5),
	    undefinedHTML: '&nbsp;'
	  });
	//스케일 바
	var scaleLineControl = new ol.control.ScaleLine();
	//줌 바
	var zoomslider = new ol.control.ZoomSlider();
	//방위각 표시
	var rotateControl = new ol.control.Rotate();
	//전체화면
	var fullscreen = new ol.control.FullScreen();
	//좌표계
	var projection = ol.proj.get('EPSG:900913');
	//var projection = ol.proj.get('EPSG:4326');
	//화면설정 
	var center_xy = [14137716.31460, 4518077.77967];
	//var center_xy =[126.99461944535379, 37.564658490418736]
	var center_zoom = 12;
	var max_zoom = 22; //네이버 기준 Level 19
	var min_zoom = 11;
	var view = new ol.View({
	    center: center_xy, //초기화면 중심
		projection: projection,
		maxZoom: max_zoom,
  		minZoom: min_zoom,
	    zoom: center_zoom
	})

	//벡터 레이어
	var vectorLayer = null;
	var vectorSource = new ol.source.Vector({ /**create empty vector*/ });

	var vectorLayer2 = null;
	var vectorSource2 = new ol.source.Vector({ /**create empty vector*/ });

	var vectorLayer_land = null;
	var vectorSource_land = new ol.source.Vector({ /**create empty vector*/ });

	var vectorLayer_buld = null;
	var vectorSource_buld = new ol.source.Vector({ /**create empty vector*/ });

	//2020 추가 - 주소변환 레이어
    var geocoderSuccStyle = new ol.style.Style({
		image: new ol.style.Icon({
			anchor: [0.5, 40],
			anchorXUnits: 'fraction',
			anchorYUnits: 'pixels',
			opacity: 1,
			size: [40, 40],
			scale: 0.5,
			src: '/jsp/SH/img/pin04_sil.png'
		}),
        zIndex: 1
	});
	var geocoderFailStyle = new ol.style.Style({
		image: new ol.style.Icon({
			anchor: [0.5, 40],
			anchorXUnits: 'fraction',
			anchorYUnits: 'pixels',
			opacity: 1,
			size: [40, 40],
			scale: 0.5,
			src: '/jsp/SH/img/pin04_sil_hover.png'
		}),
        zIndex: 2
	});

	function styleFunction(feature, resolution) {
		var status = feature.get('status');
		if(status == 'OK')
			return [geocoderSuccStyle];
		return [geocoderFailStyle];
	}

   	var geocoderLayer = new ol.layer.Vector({
        source: new ol.source.Vector(),
        style: styleFunction
    });

//-----------------------------지도 표출--------------------------------------

	//지도
	var geoMapDiv = document.getElementById('geomap');
	var geoMap = new ol.Map({
		  layers: layers,
//		  layers: [ new ol.layer.Tile({ source: new ol.source.OSM() }) ], //테스트배경지도
		  controls:  [ scaleLineControl /*, zoomslider , rotateControl , fullscreen,  mousePositionControl */ ],
		  interactions: ol.interaction.defaults({
//			  shiftDragZoom : false,
//			  altShiftDragRotate : false,
			  doubleClickZoom :false
		  }),
		  target: geoMapDiv,
		  view: view
	});

	//초기화면 레이어 추가 및 비활성화
	vHybrid.setVisible(false);
	vSatellite.setVisible(false);
	vgray.setVisible(false);
	cbnd.setVisible(false);


	//테스트
//	var testSHP = get_WMSlayer("tl_scco_sig");
//	var testSHP = get_WFSlayer("tl_scco_sig");
//	geoMap.addLayer(testSHP);

//	var sh_district = get_WMSlayer("sh_district");
//	geoMap.addLayer(sh_district);
//	sh_district.setOpacity(parseFloat(0.7));

