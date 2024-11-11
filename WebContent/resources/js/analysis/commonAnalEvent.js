/** @parameter option 대상지 탐색과 그렇지 않은 분석 모달창 초기화 분기 */
function initAnalService(option) {
  resetLegend();
  
  if(option !== 'destination'){
    $('#analysisResult').remove();
    $('#analysisResultMenu').remove();
  }
  
  const resultLayers = geoMap.getLayers().getArray()
    .filter((lyr) => lyr.get('title') === 'analysis' || lyr.get('title') === 'draw layer' );

  resultLayers.forEach((layer) => geoMap.removeLayer(layer));
  $('#content_area').empty();

  document.getElementById('loading_area') ? document.getElementById('loading_area').style.display = 'block' : null;
	document.getElementById('content_area') ? document.getElementById('content_area').style.display = 'none' : null;

  const interactions = geoMap.getInteractions().getArray();
  for(let i = interactions.length - 1; i >= 0; i--){
    if(interactions[i] instanceof ol.interaction.Modify || interactions[i] instanceof ol.interaction.Translate || interactions[i] instanceof ol.interaction.Draw){
      geoMap.removeInteraction(interactions[i]);
    }
  };

  $('#search_list_mini').css('display', 'none');
}

function doBeforeAnalysis() {
  geoMap.getLayers().getArray()
    .filter(lyr => lyr.get('title') === 'analInputLayer').map(ele => geoMap.removeLayer(ele));

  $('#load').show();
}

function doAfterAnalysis() {
  $('#load').hide();
}

/* 입력 분석 조건에 들어가는 주소, 사업대상지 검색결과 피쳐 vector layer  
주소검색시에 표출되는 벡터 레이어 타이틀을 analInputLayer로 통일, 중복해서 생성되지 않게 초기화후 추가
관리하는데 있어서 다른 입력 데이터 레이어와 같이 초기화하기 위해 */
function addAnalInputLayer (vectorSource) {
  const vectorLayer = new ol.layer.Vector({ 
    title:"analInputLayer", 
    source: vectorSource,
  	style: new ol.style.Style({
    	fill: new ol.style.Fill({
      		color: 'rgba(0, 100, 255, 0.5)'
    	}),
    	stroke: new ol.style.Stroke({
      		color: 'rgba(0, 100, 255, 0.5)',
      		width: 1.2,
    	}),
    	image: new ol.style.Circle({
    		radius: 13,
    		fill: new ol.style.Fill({
      		color: 'rgba(0, 100, 255, 0.5)'
    		}),
        stroke: new ol.style.Stroke({
          color: 'rgba(0, 100, 255, 0.5)',
          width: 1.2,
        }),
    	})
    })
  });
  
  geoMap.addLayer(vectorLayer);
  geoMap.getView().setCenter(vectorSource.getFeatures()[0].getGeometry().getFirstCoordinate());
}