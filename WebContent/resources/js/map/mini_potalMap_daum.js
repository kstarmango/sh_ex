

var roadviewContainer = document.getElementById('potalmap_mini'); //로드뷰를 표시할 div
var roadview = new daum.maps.Roadview(roadviewContainer); //로드뷰 객체
var roadviewClient = new daum.maps.RoadviewClient(); //좌표로부터 로드뷰 파노ID를 가져올 로드뷰 helper객체


var geom = center_xy;
var coord = ol.proj.transform(geom, 'EPSG:900913', 'EPSG:4326');//center_xy; //기존소스ol.proj.transform(geom, 'EPSG:900913', 'EPSG:4326');
var coord_x = coord[0];
var coord_y = coord[1];


//지도와 로드뷰 위에 마커로 표시할 특정 장소의 좌표입니다 
var position = new daum.maps.LatLng(coord_y, coord_x);


// 특정 위치의 좌표와 가까운 로드뷰의 panoId를 추출하여 로드뷰를 띄운다.
/*roadviewClient.getNearestPanoId(position, 50, function(panoId) {
	
    roadview.setPanoId(panoId, position); //panoId와 중심좌표를 통해 로드뷰 실행
});
*/
