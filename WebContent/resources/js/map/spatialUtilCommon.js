/**
 * 
 */

// 현재 화면의 중심 좌표를 얻는 함수
function getMapCenter(_geoObj) {
  // 뷰 객체에서 중심 좌표 가져오기
  var center = _geoObj.getView().getCenter();
  return center;
}

//현재 화면의 줌 레벨을 얻는 함수
function getZoomLevel(_geoObj) {
  var zoom = _geoObj.getView().getZoom();
  return zoom;
}

//geometry type 반환
function getGeometryType(geojson){
	if(geojson.type != undefined && geojson.type == "FeatureCollection"){
		return geojson['features'][0]['geometry']['type'];
	}else{
		return geojson[0]['geometry']['type'];
	} 
	
}

var styles = {};
var white = [255, 255, 255, 1];
var blue = [0, 153, 255, 1];
var width = 3;

var currentLayer;

//style 지정
function fn_setStyle(){
	styles['Polygon'] = [
		   new ol.style.Style({
		     fill: new ol.style.Fill({
		       color: $('#polyFill').val(),//[255, 255, 255, 0.5],
		     }),
		     stroke: new ol.style.Stroke({
			       color: $('#polyStroke').val(),
			       width: 1.5,
			       lineDash: [4]
			  })
		   }),
		 ];
	styles['MultiPolygon'] =
	  styles['Polygon'];

	styles['LineString'] = [
		   new ol.style.Style({
		     stroke: new ol.style.Stroke({
		       color: $('#lineStroke').val(),//white,
		       width: $('#lineStrokeSize').val(),
		       lineDash: [4]
		     }),
		   })
		 ];
	styles['Point'] = [
		   new ol.style.Style({
		     image: new ol.style.Circle({
		       radius: $('#pointStrokeSize').val() * 2
		       /*,fill: new ol.style.Fill({
		         color: $('#pointStroke').val(),
		       })*/
		       ,stroke: new ol.style.Stroke({  
		         color: $('#pointStroke').val(),
		         width: $('#pointStrokeSize').val() / 2,
		       }),
		     })
		   }),
		 ];
	
	//var layer = fn_getLayerByName(geoMap,_myData_Status[type]['layer']['name']);
	//layer.setStyle(styles[_myData_Status[type]['layer']['type']]);
	

}

function changeSymbol(type){
	
	console.log("change!!!")
	
	if(_myData_Status[type]['layer']['type'] == "Point"){
		var symbolStyle = $("#featuresymbol option:selected").val();
		
		var stroke = new ol.style.Stroke({color: 'rgba(0, 0, 0, 1)', width: 2});
		var fill = new ol.style.Fill({color: $('#pointFill').val()});
		var radius = $('#pointStrokeSize').val();
		
		var symbol = {
				  'square': [new ol.style.Style({
					image: new ol.style.RegularShape({
					  fill: fill,
					  stroke: stroke,
					  points: 4,
					  radius: parseInt($('#pointStrokeSize').val()),
					  angle: Math.PI / 4
					})
				  })],
				  'triangle': [new ol.style.Style({
					image: new ol.style.RegularShape({
					  fill: fill,
					  stroke: stroke,
					  points: 3,
					  radius: parseInt($('#pointStrokeSize').val()),
					  rotation: Math.PI / 4,
					  angle: 0
					})
				  })],
				  'star': [new ol.style.Style({
					image: new ol.style.RegularShape({
					  fill: fill,
					  stroke: stroke,
					  points: 5,
					  radius: parseInt($('#pointStrokeSize').val()),
					  radius2: 4,
					  angle: 0
					})
				  })],
				  'cross': [new ol.style.Style({
					image: new ol.style.RegularShape({
					  fill: fill,
					  stroke: stroke,
					  points: 4,
					  radius: parseInt($('#pointStrokeSize').val()),
					  radius2: 0,
					  angle: 0
					})
				  })],
				  'x': [new ol.style.Style({
					image: new ol.style.RegularShape({
					  fill: fill,
					  stroke: stroke,
					  points: 4,
					  radius: parseInt($('#pointStrokeSize').val()),
					  radius2: 0,
					  angle: Math.PI / 4
					})
				  })]
				}
		
		styles['Point'] = symbol[symbolStyle];
		var layer = fn_getLayerByName(geoMap,_myData_Status[type]['layer']['name']);
		//layer.setStyle(styles[style]);
		layer.setStyle(styles[_myData_Status[type]['layer']['type']]);
	}else{
		changeStyle();
		var layer = fn_getLayerByName(geoMap,_myData_Status[type]['layer']['name']);
		layer.setStyle(styles[_myData_Status[type]['layer']['type']]);
	}
	
}

function changeStyle() {
	styles = {};
	styles = {
	 'Polygon' : [new ol.style.Style({
		     fill: new ol.style.Fill({
		       color: $('#polyFill').val(),//[255, 255, 255, 0.5],
		     }),
		     stroke: new ol.style.Stroke({
			       color: $('#polyStroke').val(),
			       width: 1.5,
			       lineDash: [4]
			  })
	 })],
	'LineString' : [new ol.style.Style({
		     stroke: new ol.style.Stroke({
		       color: $('#lineStroke').val(),//white,
		       width: $('#lineStrokeSize').val(),
		       lineDash: [4]
		     })
		})]
	};	
	
	styles['MultiPolygon'] = styles['Polygon'];
}	


//geometry style Json 직렬화
function styleToJson(style, type) {
    var image = style.getImage();
    console.log("image",image)
    var fill = style.getFill();
    var stroke = style.getStroke();
    
    var _json ={};
    if(type == 'Polygon' || type == 'MultiPolygon'){
    	_json = {
    	        image: {
    	            fill: {
    	                color: fill.getColor()
    	            },
    	            stroke: {
    	                color: stroke.getColor(),
    	                width: stroke.getWidth()
    	            }
    	        }
    	    }
    }else if(type == 'LineString'){
    	_json = {
    	        image: {
    	            stroke: {
    	                color: stroke.getColor(),
    	                width: stroke.getWidth()
    	            }
    	        }
    	    }
    }else if(type == 'Point'){
    	_json = {
    			image: {
    	            radius: image.getRadius(),
					angle : image.angle_,
					points : image.points_,
					radius2 : image.radius2_,
					rotation : image.rotation_,
    	            fill: {
    	                color: image.getFill().getColor()
    	            }
    	            ,stroke: {
    	                color: image.getStroke().getColor(),
    	                width: image.getStroke().getWidth()
    	            }
    	        }
    	    }
    }
    return _json;
}

//Json geometry style객체 변환
function jsonToStyle(styleJson ,type) {
	var styleJson  = JSON.parse(styleJson);
	
	console.log("styleJSON",styleJson)
    // 이미지 스타일 정보 가져오기
    var image = styleJson.image;
    var fill = image.fill;
    var stroke = image.stroke;
    
    var obj;
    if(type == 'Polygon' || type == 'MultiPolygon'){
    	obj = new ol.style.Style({
    		fill: new ol.style.Fill({
		       color: fill.color
		     }),
		     stroke: new ol.style.Stroke({
		    	  color: stroke.color,
		    	  width: stroke.width
			  })
		   })
    }else if(type == 'LineString'){
    	obj = new ol.style.Style({
            stroke: new ol.style.Stroke({
                color: stroke.color,
                width: stroke.width
            })
        });
    }else if(type == 'Point'){
    	obj =new ol.style.Style({
    		 image: new ol.style.RegularShape({
    			 fill: new ol.style.Fill({
    			       color: fill.color
			     }),
			     stroke: new ol.style.Stroke({
			    	  color: stroke.color,
			    	  width: stroke.width
				  }),
				  points: image.points,
				  radius: image.radius,
				  radius2: image.radius2,
				  angle: image.angle,
				  rotation: image.rotation
				})
    			 /*new ol.style.Circle({
  		       radius: image.radius
  		       ,stroke: new ol.style.Stroke({  
  		         color: image.stroke.color,
	                width: image.stroke.width
  		       })
  		     })*/
    	});
   }
    
    // ol.style.Style 객체로 변환
    return obj;
}

//이름(속성)으로 레이어 가져오기
function fn_getLayerByName(map, name){
	var layers = map.getLayers();
	var layer;
	layers.forEach(function (v) {
		if (v.get('name') == name){		
			layer = v;
		}
	});
	  return layer; 
}