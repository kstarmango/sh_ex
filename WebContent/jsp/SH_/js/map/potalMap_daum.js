﻿
	

var dmap;
var roadview;
var rvClient;
var placePosition;
var mapMarker;
var mapWalker;
var check;



var map_now_center;
var coord;
var nowPoint;
var map_now_zoom;
var nowzoom;


$(document).ready(function() {		
	var rvContainer = document.getElementById('roadview'); // 로드뷰를 표시할 div 입니다
	var mapContainer = document.getElementById('dmap'); // 지도를 표시할 div 입니다
	var btnMap = document.getElementById('btnMap'); // 지도를 표시할 버튼 입니다
	
	var geom = center_xy;
  	var coord = ol.proj.transform(geom, 'EPSG:900913', 'EPSG:4326');
  	var coord_x = coord[0];
  	var coord_y = coord[1];
  	//지도와 로드뷰 위에 마커로 표시할 특정 장소의 좌표입니다 
  	placePosition = new daum.maps.LatLng(coord_y, coord_x);
  	
  	//지도 옵션입니다 
  	var mapOption = {
  	    center: placePosition, // 지도의 중심좌표 
  	    level: 8 // 지도의 확대 레벨
  	};  	

	// 지도를 표시할 div와 지도 옵션으로 지도를 생성합니다
	dmap = new daum.maps.Map(mapContainer, mapOption);

	// 지도 타입 변경 컨트롤을 생성한다
	var mapTypeControl = new daum.maps.MapTypeControl();

	// 지도의 상단 우측에 지도 타입 변경 컨트롤을 추가한다
	dmap.addControl(mapTypeControl, daum.maps.ControlPosition.TOPLEFT);	

	// 로드뷰 객체를 생성합니다 
	roadview = new daum.maps.Roadview(rvContainer);
	rvClient = new daum.maps.RoadviewClient(); //좌표로부터 로드뷰 파노ID를 가져올 로드뷰 helper객체

	// 특정 장소가 잘보이도록 로드뷰의 적절한 시점(ViewPoint)을 설정합니다 
	// Wizard를 사용하면 적절한 로드뷰 시점(ViewPoint)값을 쉽게 확인할 수 있습니다
	roadview.setViewpoint({
	    pan: 321,
	    tilt: 0,
	    zoom: 0
	});
	
	// 마커 이미지를 생성합니다.
	var markImage = new daum.maps.MarkerImage(
	        'http://i1.daumcdn.net/localimg/localimages/07/mapapidoc/roadview_wk.png',
	        new daum.maps.Size(35,39),
	        {
	            //마커의 좌표에 해당하는 이미지의 위치를 설정합니다.
	            //이미지의 모양에 따라 값은 다를 수 있으나, 보통 width/2, height를 주면 좌표에 이미지의 하단 중앙이 올라가게 됩니다.
	            offset: new daum.maps.Point(14, 39)
	        }
	);

	// 지도 중심을 표시할 마커를 생성하고 특정 장소 위에 표시합니다 
	var nowPoint = dmap.getCenter();
	mapMarker = new daum.maps.Marker({
		image : markImage,
		draggable: true,
	    position: nowPoint
	});
    // map walker를 생성한다. 생성시 지도의 중심좌표를 넘긴다.
    mapWalker = new MapWalker(nowPoint);
    	
	//마커에 dragend 이벤트를 할당합니다
	daum.maps.event.addListener(mapMarker, 'dragend', function(mouseEvent) {
	    var position = mapMarker.getPosition(); //현재 마커가 놓인 자리의 좌표
	    if( check ){
	    	toggleRoadview(position); //로드뷰를 토글합니다
	    }
	});
	
	//지도에 클릭 이벤트를 할당합니다
	daum.maps.event.addListener(dmap, 'click', function(mouseEvent){
	    // 현재 클릭한 부분의 좌표를 리턴 
	    var position = mouseEvent.latLng; 	    
	    if( check ){
	    	mapMarker.setPosition(position);
	    	toggleRoadview(position); //로드뷰를 토글합니다
	    }
	    
	});
		
	//포털지도 이동

	
	geoMap.on('moveend', function(e) {
        map_now_center = geoMap.getView().getCenter();
        coord = ol.proj.transform(map_now_center, 'EPSG:900913', 'EPSG:4326');           
		nowPoint = new daum.maps.LatLng(coord[1], coord[0]);		
		dmap.setCenter(nowPoint);    

		map_now_zoom = geoMap.getView().getZoom();
      	nowzoom = Math.floor(map_now_zoom);      	
      	dmap.setLevel(20 - nowzoom);   
    });	
			
	
	daum.maps.event.addListener(dmap, 'dragend', function() {		
		map_now_center = [dmap.getCenter().getLng(), dmap.getCenter().getLat()]
		coord = ol.proj.transform(map_now_center, 'EPSG:4326', 'EPSG:3857');    			
		view.setCenter([coord[0], coord[1]]);			
	});
	

	daum.maps.event.addListener(dmap, 'zoom_changed', function() {									
		var level = Math.floor(dmap.getLevel());
		level = 10 - (level - 10);    
		view.setZoom(level)		
	});
	
	
	
	
	
	
	
	$("#container").hide();
	
	//로드뷰의 pan(좌우 각도)값에 따라 map walker의 백그라운드 이미지를 변경 시키는 함수
	//background로 사용할 sprite 이미지에 따라 계산 식은 달라 질 수 있음
	MapWalker.prototype.setAngle = function(angle){

	    var threshold = 22.5; //이미지가 변화되어야 되는(각도가 변해야되는) 임계 값
	    for(var i=0; i<16; i++){ //각도에 따라 변화되는 앵글 이미지의 수가 16개
	        if(angle > (threshold * i) && angle < (threshold * (i + 1))){
	            //각도(pan)에 따라 아이콘의 class명을 변경
	            var className = 'm' + i;
	            this.content.className = this.content.className.split(' ')[0];
	            this.content.className += (' ' + className);
	            break;
	        }
	    }
	};

	//map walker의 위치를 변경시키는 함수
	MapWalker.prototype.setPosition = function(position){
	    this.walker.setPosition(position);
	};

	//map walker를 지도위에 올리는 함수
	MapWalker.prototype.setMap = function(map){
	    this.walker.setMap(map);
	};

	// 로드뷰의 초기화 되었을때 map walker를 생성한다.
	daum.maps.event.addListener(roadview, 'init', function() {

	    // 로드뷰가 초기화 된 후, 추가 이벤트를 등록한다.
	    // 로드뷰를 상,하,좌,우,줌인,줌아웃을 할 경우 발생한다.
	    // 로드뷰를 조작할때 발생하는 값을 받아 map walker의 상태를 변경해 준다.
	    daum.maps.event.addListener(roadview, 'viewpoint_changed', function(){

	        // 이벤트가 발생할 때마다 로드뷰의 viewpoint값을 읽어, map walker에 반영
	        var viewpoint = roadview.getViewpoint();
	        mapWalker.setAngle(viewpoint.pan);

	    });

	    // 로드뷰내의 화살표나 점프를 하였을 경우 발생한다.
	    // position값이 바뀔 때마다 map walker의 상태를 변경해 준다.
	    daum.maps.event.addListener(roadview, 'position_changed', function(){

	        // 이벤트가 발생할 때마다 로드뷰의 position값을 읽어, map walker에 반영 
	        var position = roadview.getPosition();
	        mapWalker.setPosition(position);
	        dmap.setCenter(position);

	    });
	});

});

function toggleMap(active) {	
	var nowPosition = dmap.getCenter();
	var mapWrapper = document.getElementById('mapWrapper'); // 지도를 감싸고 있는 div 입니다
	var container = document.getElementById('container'); // 지도와 로드뷰를 감싸고 있는 div 입니다
	var rePosition = dmap.getCenter(); 
    if (active) {
    	mapWrapper.style.width = '100%';
        mapWrapper.style.height = '100%';                
        // 지도가 보이도록 지도와 로드뷰를 감싸고 있는 div의 class를 변경합니다
        container.className = "view_map";        
        dmap.relayout();
        dmap.setCenter(nowPosition);
        dmap.removeOverlayMapTypeId(daum.maps.MapTypeId.ROADVIEW);
        mapMarker.setMap(null);
        mapWalker.setMap(null);
        check = false;
    } else {
        container.className = "view_roadview"; 	
        dmap.relayout();
    	dmap.addOverlayMapTypeId(daum.maps.MapTypeId.ROADVIEW); //지도 위에 로드뷰 도로 올리기
    	mapMarker.setMap(dmap);
    	check = true;
    }
}

//로드뷰 toggle함수
function toggleRoadview(position){
	$("#roadview").show();
	mapMarker.setMap(null);
	mapWalker.setMap(dmap);
	var mapWrapper = document.getElementById('mapWrapper'); // 지도를 감싸고 있는 div 입니다
	var rePosition = mapMarker.getPosition(); //현재 마커가 놓인 자리의 좌표
	var container = document.getElementById('container'); // 지도와 로드뷰를 감싸고 있는 div 입니다
    //전달받은 좌표(position)에 가까운 로드뷰의 panoId를 추출하여 로드뷰를 띄웁니다
    rvClient.getNearestPanoId(position, 50, function(panoId) {
        if (panoId === null) {
            mapWrapper.style.width = '100%';
            mapWrapper.style.height = '100%';
            $("#roadview").hide();
//            container.className = "view_map";            
            dmap.relayout();
            dmap.setCenter(rePosition);
             
            mapMarker.setMap(dmap);
        	mapWalker.setMap(null);
        } else {
        	mapWrapper.style.height = '30%';
            mapWrapper.style.width = '30%';
            container.className = "view_roadview"; 	
            dmap.relayout(); //지도를 감싸고 있는 영역이 변경됨에 따라, 지도를 재배열합니다
            dmap.setCenter(rePosition);
            roadview.setPanoId(panoId, position); //panoId를 통한 로드뷰 실행
            roadview.relayout(); //로드뷰를 감싸고 있는 영역이 변경됨에 따라, 로드뷰를 재배열합니다
            
            mapMarker.setMap(null);
        	mapWalker.setMap(dmap);
        	
        }
    });
}

//지도위에 현재 로드뷰의 위치와, 각도를 표시하기 위한 map walker 아이콘 생성 클래스
function MapWalker(position){

    //커스텀 오버레이에 사용할 map walker 엘리먼트
    var content = document.createElement('div');
    var figure = document.createElement('div');
    var angleBack = document.createElement('div');

    //map walker를 구성하는 각 노드들의 class명을 지정 - style셋팅을 위해 필요
    content.className = 'MapWalker';
    figure.className = 'figure';
    angleBack.className = 'angleBack';

    content.appendChild(angleBack);
    content.appendChild(figure);

    //커스텀 오버레이 객체를 사용하여, map walker 아이콘을 생성
    var walker = new daum.maps.CustomOverlay({
        position: position,
        content: content,
        yAnchor: 1
    });

    this.walker = walker;
    this.content = content;
}
