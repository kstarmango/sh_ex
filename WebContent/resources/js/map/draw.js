let drawContext;
let translateContext;
let modifyContext;
let snapToggle = false;
let snapContext = null;
let snapLayer = null;
let circleEventKey = null;

const PROXY_URL = '/api/cmmn/proxy.do?url=';
const GEOSERVER_URL = 'https://shgis.syesd.co.kr/geoserver/ows';


function getWFSLayer(layerName) {
	
	return new ol.layer.Vector({
		title: '지적도 레이어',
		source: new ol.source.Vector({
			loader: function (extent, resolution, projection) {
				const proj = projection.getCode();
				const wfsUrl =
					GEOSERVER_URL +
					'?service=WFS&version=1.1.0&request=GetFeature&typename=' +
					layerName +
					'&outputFormat=application/json&srsname=' +
					proj +
					'&bbox=' +
					geoMap.getView().calculateExtent().join(',') +
					',' +
					proj;
				// fetch(PROXY_URL + wfsUrl)
				fetch(wfsUrl)
					.then((res) => res.json())
					.then((data) => {
						if (data.features.length > 0) {
							const targetVector = geoMap
								.getLayers()
								.getArray()
								.find((layer) => layer.getProperties().title === '지적도 레이어');
							targetVector.getSource().clear();
							targetVector.getSource().addFeatures(new ol.format.GeoJSON().readFeatures(data));
						} else {
							alert('해당 영역에 지적도 피쳐가 존재하지 않습니다.');
						}
					});
			},
			format: new ol.format.GeoJSON(),
			crossOrigin: 'anonymous',
		}),
	});
}

function makeCircle(e) {

	const radius = Number(document.getElementById('draw_cicle_radius').value);
	const source = getTargetVectorSource();
	let point;
	if(e){
		point = e.feature.getGeometry().getCoordinates();
	} else {
		point =  source.getFeatures().filter(f => f.getGeometry().getType() == 'Point')[0].getGeometry().getCoordinates();
		const circle =  source.getFeatures().filter(f => f.getGeometry().getType() == 'Circle')[0];
		source.removeFeature(circle);
	}

	// const circle = new ol.geom.Circle(ol.proj.transform(point, 'EPSG:4326', 'EPSG:3857'), radius).transform(
	// 	'EPSG:3857',
	// 	'EPSG:4326'
	// );

	const circleFeature = new ol.Feature({
		geometry: new ol.geom.Circle(point, radius),
	});

	source.addFeatures([circleFeature]);
	geoMap.removeInteraction(drawContext);
}

function addInteractionByType(type) {

	if(!!translateContext){
		geoMap.removeInteraction(translateContext);
	}
	if(!!modifyContext){
		geoMap.removeInteraction(modifyContext);
	}
	const valueElement = document.getElementById('draw_circle_condition');
	if(valueElement){
		valueElement.style.display = type === 'Circle' ? 'block' : 'none';
	}

	let vector = geoMap
		.getLayers()
		.getArray()
		.find((layer) => layer.getProperties().title === 'draw layer');	

	if(!vector){
		vector = new ol.layer.Vector({
			title: 'draw layer',
			source: new ol.source.Vector({ wrapX: false })
		});
		geoMap.addLayer(vector);
	}

	const source = vector.getSource();
	source.clear();

	let analLyr = geoMap
		.getLayers()
		.getArray()
		.find((layer) => layer.getProperties().title === 'analysis');

	if(analLyr instanceof ol.layer.Image){
		const imageSource = analLyr.getSource();
    if (imageSource instanceof ol.source.ImageStatic) {
      geoMap.removeLayer(analLyr);
    } 
	} else if(analLyr instanceof ol.layer.Group){
		analLyr.getLayers().getArray().forEach( lyr => lyr.getSource().clear());
	}

	translateContext = new ol.interaction.Translate({
		layers: [vector],
	});
	translateContext.title = 'Translate';
	geoMap.addInteraction(translateContext);
	modifyContext = new ol.interaction.Modify({ source });
	modifyContext.title = 'Modify';
	geoMap.addInteraction(modifyContext);
	
	const geometryFunction = type === 'Box' ? ol.interaction.Draw.createBox() : undefined;

	if (type === 'Circle') {
		drawContext = new ol.interaction.Draw({
			source,
			type: 'Point',
		});

		drawContext.on('drawstart', e => {
			const radius = Number(document.getElementById('draw_cicle_radius').value);
			if (!radius || !radius > 0) {
				alert('반지름을 0보다 크게 설정해주세요.');
				source.clear();
				geoMap.removeInteraction(drawContext);
			}
		})

		drawContext.on('drawend', e => makeCircle(e))

	} else if (type !== 'Circle') {
		if(circleEventKey){
			ol.Observable.unByKey(circleEventKey);
		}
		drawContext = new ol.interaction.Draw({
			source,
			type: type === 'Box' ? 'Circle' : type,
			geometryFunction,
		});
		drawContext.title='Draw';
		drawContext.on('drawstart', function () {
			removeLastDrawGeometry();
		});
	
		drawContext.on('drawend', function () {
			geoMap.removeInteraction(drawContext);
		});
	}

	geoMap.addInteraction(drawContext);
}

function getTargetVectorSource() {
	return geoMap
	.getLayers()
	.getArray()
	.find((layer) => layer.getProperties().title === 'draw layer')
	.getSource();
}

function removeLastDrawGeometry() {
	const targetVectorSource = getTargetVectorSource();
	

	targetVectorSource.clear();
}

function removeModifyInteraction(){
	const interactions = geoMap.getInteractions().getArray();
	for(let i = interactions.length - 1; i >= 0; i--){
		if(interactions[i] instanceof ol.interaction.Modify || interactions[i] instanceof ol.interaction.Translate){
			geoMap.removeInteraction(interactions[i]);
		}
	};
}

function onClickSnapToggle(targetLayerTitle) {
	
	if(snapToggle){
		removeSnapTargetLayer(); 
		
	}
	else{
		getSnapTargetLayer();
	}

	const currentZoom = geoMap.getView().getZoom();
	
	if (currentZoom >= 18) {
		const targetLayer = geoMap
		.getLayers()
		.getArray()
		.find((layer) => layer.getProperties().title === targetLayerTitle);
		
		// if (targetLayer) {
			
			
			const drawSnap = document.getElementById('draw_snap');
			drawSnap.style.filter = snapToggle ? '' : 'brightness(0.5)';

			if (snapToggle && snapContext) {
				geoMap.removeInteraction(snapContext);
				snapContext = null;
			} else {
				const targetVectorSource = targetLayer.getSource();
				const snap = new ol.interaction.Snap({ source: targetVectorSource, pixelTolerance: 20 });
				snap.title='Snap';
				snapContext = snap;
				geoMap.addInteraction(snap);
				
			}

			snapToggle = !snapToggle;
		// } else {
		// 	alert(`Snap을 활성화하기 위한 레이어(${targetLayerTitle})가 없습니다.`);
		// }
	}
}

const getSnapTargetLayer = () => {
	const currentZoom = geoMap.getView().getZoom();
	if (currentZoom < 18) {
		alert('지도를 더 확대해야 불러올 수 있습니다.');
		return;
	}

	const ctnu_lgstr_su = getWFSLayer('	LANDSYS:ctnu_lgstr_su');
	geoMap.addLayer(ctnu_lgstr_su);
	snapLayer = true;
	
};

const removeSnapTargetLayer = () => {
	const targetVector = geoMap
		.getLayers()
		.getArray()
		.find((layer) => layer.getProperties().title === '지적도 레이어');
	geoMap.removeLayer(targetVector);
	snapLayer = false;
};

function initDraw(type) {

	if(geoMap.getLayers().getArray().filter(ele=>ele.get('title') === 'draw layer').length !== 0 ){
		geoMap.removeLayer(geoMap.getLayers().getArray().filter(ele=>ele.get('title') === 'draw layer')[0]);
	}
	const source = new ol.source.Vector({ wrapX: false });

	const vector = new ol.layer.Vector({
		title: 'draw layer',
		source,
	});

	geoMap.addLayer(vector);

	geoMap.on('movestart', function (e, resolution) {
		const currentZoom = geoMap.getView().getZoom();
		if (snapLayer) {
			alert('지도를 축소시키기 위해서는 지적도 레이어를 제거해야합니다.');
			geoMap.getView().setZoom(currentZoom);
		}
	});

	const drawPoint = document.getElementById('draw_point');
	const drawLine = document.getElementById('draw_line');
	const drawPolygon = document.getElementById('draw_polygon');
	const drawCircle = document.getElementById('draw_circle');
	const drawSquare = document.getElementById('draw_square');
	const drawSnap = document.getElementById('draw_snap');
	const drawRemove = document.getElementById('draw_remove');

	if(drawPoint){
		drawPoint.addEventListener('click', () => {
			if (draw) geoMap.removeInteraction(draw);
			if (drawContext) geoMap.removeInteraction(drawContext);
			addInteractionByType('Point');
		});
	}
	if(drawLine){
		drawLine.addEventListener('click', () => {
			if (draw) geoMap.removeInteraction(draw);
			if (drawContext) geoMap.removeInteraction(drawContext);
			addInteractionByType('LineString');
		});
	}
	if(drawPolygon){
		drawPolygon.addEventListener('click', () => {
			if (draw) geoMap.removeInteraction(draw);
			if (drawContext) geoMap.removeInteraction(drawContext);
			addInteractionByType('Polygon');
		});
	}
	if(drawCircle){
		drawCircle.addEventListener('click', () => {
			if (draw) geoMap.removeInteraction(draw);
			if (drawContext) geoMap.removeInteraction(drawContext);
			addInteractionByType('Circle');
		});
	}
	if(drawSquare){
		drawSquare.addEventListener('click', () => {
			if (draw) geoMap.removeInteraction(draw);
			if (drawContext) geoMap.removeInteraction(drawContext);
			addInteractionByType('Box');
		});
	}
	if(drawSnap){
		drawSnap.addEventListener('click', () => {
			// if (draw) geoMap.removeInteraction(draw);
			// if (drawContext) geoMap.removeInteraction(drawContext);
			onClickSnapToggle('지적도 레이어');
		});
	}
	if(drawRemove){
		drawRemove.addEventListener('click', () => {
			removeLastDrawGeometry();
		});
	}

	if(type == 'destination'){
		document.getElementById('getSnapLayerBtn').addEventListener('click', getSnapTargetLayer);
		document.getElementById('removeSnapLayerBtn').addEventListener('click', removeSnapTargetLayer);
	}
}

$(document).ready(function () {
	// if(!!document.getElementById('getSnapLayerBtn') && !!document.getElementById('removeSnapLayerBtn')){
	// 	initDraw('destination');	
	// }else{
		initDraw();
	// }
});