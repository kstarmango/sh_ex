


	$(document).ready(function() {
		//주제도 오버레이 버튼 - 기존
		/*$('.map-layer-btn').click(function() {
            $('.map-layer-btn-group').toggleClass('hidden');
        });*/

		//2020 추가
		$('.map-layer-btn').click(function() {
			if( $('#shape-mini').attr('display') == 'none')
				$('#shape-mini').show();
			else
				$('#shape-mini').hide();
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

	function measureLength(){
		//click정보조회
		clickselect = false; $("#geomap").css('cursor', 'default');

		if(draw != null){
			geoMap.removeInteraction(draw);
		}
		  	addInteraction('LineString');
	}
	function measureArea(){
		//click정보조회
		clickselect = false; $("#geomap").css('cursor', 'default');

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
		html2canvas($("#geomap"), {
//			useCORS: true,
//			proxy: '/etc/proxy_image',
			onrendered: function(canvas) {
				canvas.toBlob(function (blob) {
	        	    saveAs(blob, 'map.png');
			 });
			}
		});
	}


	//포털지도 on & off
	var view_set = true;
	function potalMap(){
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

	//정보조회
	var clickselect = false;
	function ClickSelect(){
		addInteraction('None');
		if(draw != null){
			geoMap.removeInteraction(draw);
		}
		if(clickselect){ clickselect = false; $("#geomap").css('cursor', 'default'); }
		else{ clickselect = true; $("#geomap").css('cursor', 'help'); }
	}
	
	// 더클릭 조회
	function dbClickSelect(){
		addInteraction('None');
		if(draw != null){
			geoMap.removeInteraction(draw);
		}
		if(clickselect){ clickselect = false; $("#geomap").css('cursor', 'default'); }
		else{ clickselect = true; $("#geomap").css('cursor', 'default'); }
	}





	var saveAs=saveAs||function(e){"use strict";if(typeof e==="undefined"||typeof navigator!=="undefined"&&/MSIE [1-9]\./.test(navigator.userAgent)){return}var t=e.document,n=function(){return e.URL||e.webkitURL||e},r=t.createElementNS("http://www.w3.org/1999/xhtml","a"),o="download"in r,a=function(e){var t=new MouseEvent("click");e.dispatchEvent(t)},i=/constructor/i.test(e.HTMLElement)||e.safari,f=/CriOS\/[\d]+/.test(navigator.userAgent),u=function(t){(e.setImmediate||e.setTimeout)(function(){throw t},0)},s="application/octet-stream",d=1e3*40,c=function(e){var t=function(){if(typeof e==="string"){n().revokeObjectURL(e)}else{e.remove()}};setTimeout(t,d)},l=function(e,t,n){t=[].concat(t);var r=t.length;while(r--){var o=e["on"+t[r]];if(typeof o==="function"){try{o.call(e,n||e)}catch(a){u(a)}}}},p=function(e){if(/^\s*(?:text\/\S*|application\/xml|\S*\/\S*\+xml)\s*;.*charset\s*=\s*utf-8/i.test(e.type)){return new Blob([String.fromCharCode(65279),e],{type:e.type})}return e},v=function(t,u,d){if(!d){t=p(t)}var v=this,w=t.type,m=w===s,y,h=function(){l(v,"writestart progress write writeend".split(" "))},S=function(){if((f||m&&i)&&e.FileReader){var r=new FileReader;r.onloadend=function(){var t=f?r.result:r.result.replace(/^data:[^;]*;/,"data:attachment/file;");var n=e.open(t,"_blank");if(!n)e.location.href=t;t=undefined;v.readyState=v.DONE;h()};r.readAsDataURL(t);v.readyState=v.INIT;return}if(!y){y=n().createObjectURL(t)}if(m){e.location.href=y}else{var o=e.open(y,"_blank");if(!o){e.location.href=y}}v.readyState=v.DONE;h();c(y)};v.readyState=v.INIT;if(o){y=n().createObjectURL(t);setTimeout(function(){r.href=y;r.download=u;a(r);h();c(y);v.readyState=v.DONE});return}S()},w=v.prototype,m=function(e,t,n){return new v(e,t||e.name||"download",n)};if(typeof navigator!=="undefined"&&navigator.msSaveOrOpenBlob){return function(e,t,n){t=t||e.name||"download";if(!n){e=p(e)}return navigator.msSaveOrOpenBlob(e,t)}}w.abort=function(){};w.readyState=w.INIT=0;w.WRITING=1;w.DONE=2;w.error=w.onwritestart=w.onprogress=w.onwrite=w.onabort=w.onerror=w.onwriteend=null;return m}(typeof self!=="undefined"&&self||typeof window!=="undefined"&&window||this.content);if(typeof module!=="undefined"&&module.exports){module.exports.saveAs=saveAs}else if(typeof define!=="undefined"&&define!==null&&define.amd!==null){define("FileSaver.js",function(){return saveAs})};



