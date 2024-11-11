
	var view_mini = new ol.View({
	    center: center_xy, //초기화면 중심
		projection: projection,
		maxZoom: 19,
  		minZoom: 11,
	    zoom: center_zoom	
	});
		
	//벡터 레이어
	var vectorLayer_mini = null;
	var vectorSource_mini = new ol.source.Vector({ /**create empty vector*/ });	
	
	
//-----------------------------지도 표출--------------------------------------	
	//브이월드 - 배경지도(일반)
	// C1314EF3-8396-3600-95A8-AC6FE95A4A91 변경
	//37C45FB4-085E-33DF-BE02-E9E505572E78 230518이전
	var vBase_mini = new ol.layer.Tile({ 
		source: new ol.source.XYZ({
            url: proxy_url+"http://api.vworld.kr/req/wmts/1.0.0/6436A16F-8375-331E-A0C0-FB4157C858C9/Base/{z}/{y}/{x}.png",
            //url: proxy_url+"/req/wmts/1.0.0/C1314EF3-8396-3600-95A8-AC6FE95A4A91/Base/{z}/{y}/{x}.png", //개발
            params: { 'FORMAT': 'image/png', 'TILED': true },
            crossOrigin: null })
    });
	
	//지도
	var geoMap_mini = new ol.Map({
		  layers: [vBase_mini], 
		  controls:  [ scaleLineControl ],
		  interactions: ol.interaction.defaults({ 
		  }),	              
		  target: document.getElementById('geomap_mini'),	  
		  view: view_mini
	});	
	
	
	
			

	
	
	
	