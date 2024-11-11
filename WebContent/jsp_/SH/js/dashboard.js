
	//레이어 기본설정
	var proxy_url = "/mapInclude/getProxy.do?url=";
	
//	var layer_url = 'http://localhost:9900/geoserver/SH_LM/wms?'; //내부망
//	var layer_url = 'http://connect.miraens.com:59900/geoserver/SH_LM/wms?'; //내부망
	var layer_url = 'http://dev.syesd.co.kr:12101/geoserver/SH_LM/wms?'; //실서버
	
	function get_WMSlayer(layername, style){
        return new ol.layer.Image({
            source: new ol.source.ImageWMS({
                url: layer_url,
                serverType:'geoserver',
                params:{ 'LAYERS':layername, 'TILED':true, 'STYLES':style },
                crossOrigin: null })
     		});
    }
	
	var tl_scco_ctprvn	         = get_WMSlayer("SH_LM:tl_scco_ctprvn", "SH_LM:tl_scco_ctprvn2");	        
	var tl_scco_sig	             = get_WMSlayer("SH_LM:tl_scco_sig", "SH_LM:tl_scco_sig2");	
	
	//BaseMap 설정
	var layers = [ tl_scco_ctprvn, tl_scco_sig ];	
	
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
	//좌표계
	var projection = ol.proj.get('EPSG:900913');	
	//화면설정
	var center_xy = [14137716.31460, 4518077.77967];
	var center_zoom = 11;
	var max_zoom = 19; //네이버 기준 Level 19
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
	
	
//-----------------------------지도 표출--------------------------------------	
	
	//지도
	var geoMapDiv = document.getElementById('geomap');
	var geoMap = new ol.Map({
		  layers: layers, 
		  controls:  [ scaleLineControl ],
		  interactions: ol.interaction.defaults({ 
//			  shiftDragZoom : false,
//			  altShiftDragRotate : false
		  }),	              
		  target: geoMapDiv,	  
		  view: view
	});	
	
	/**
	 *  대시보드 클릭시 이동
	 */
	geoMap.on("click", function(evt) {
        var coordinate = evt.coordinate 	// 클릭한 지점의 좌표정보
        var pixel = evt.pixel 				// 클릭한 지점의 픽셀정보 
        
        //선택한 픽셀정보로  feature 체크 
        geoMap.forEachFeatureAtPixel(pixel, function(feature, layer) {
        	window.location.href = '/gisinfo_home.do?sig_cd=' + feature.get("id");
        });
    })
	
	
	
			

	
	
	
	