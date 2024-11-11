<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="utf-8">
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <meta name="description" content="SH서울주택도시공사 | 토지자원관리시스템">

    <link rel="shortcut icon" href="/jsp/SH/img/favicon.ico">    

    <!--DatePicker css-->
    <link href="/jsp/SH/css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <!-- DateTimePicker -->
    <link href="/jsp/SH/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />

	<!--Morris Chart CSS -->
    <link href="/jsp/SH/css/morris.css" rel="stylesheet" />
    
    <!-- App css -->
    <link href="/jsp/SH/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/components.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/icons.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/core.css" rel="stylesheet" type="text/css" />

    
    
    
    <!-- jQuery Library -->
	<script src="/jsp/SH/js/jquery.min.js"></script>
	<script src="/jsp/SH/js/bootstrap.min.js"></script>
	
	<!-- Table Sort -->
	<script src="/jsp/SH/js/stupidtable.js"></script>
	
	<!-- App js -->
	<script src="/jsp/SH/js/jquery.app.js"></script>
	
	<!-- OpenLayers4 -->
	<link href="/jsp/SH/js/openLayers/v4.3.1/ol.css" rel="stylesheet" />
	<script src="/jsp/SH/js/openLayers/v4.3.1/ol.js"></script>
	<script src="/jsp/SH/js/openLayers/v4.3.1/polyfill.min.js"></script>
	
	<!-- potalMap is DaumAPI  -->
	<!-- 로컬개발용 -->
<!-- 	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=dd814c573b22a7079068883df930cc51"></script> -->
	<!-- 외부접근개발용 -->
<!-- 	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=73de49f305c6e0f34db3ca8dc7135a1e"></script> -->
	<!-- 실서버용 -->
<!-- 	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=6d4240cef136cd89d4d4fcf442331b53"></script> -->
	
	<!-- 신영ESD서버용 -->
 	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a0d37957532262602e2dca4450170302"></script>
	
	
	
<script type="text/javascript">
$(document).ready(function(){
	
	//탭 활성화
	map_draw_mini($("#detail_dist_one_addr_x").val(), $("#detail_dist_one_addr_y").val(), $("#detail_dist_one_geom").val());
        
	
});

//도형 그리기
function map_draw_mini(addr_x, addr_y, geom){
	if(geom == ""){
// 		alert("도형정보가 없습니다.");
	}else{
		//그래픽 초기화
		if(vectorLayer_mini != null || vectorLayer_mini != ''){ 
			vectorSource_mini.clear();
			geoMap_mini.removeLayer(vectorLayer_mini);			
		} 
		
		//create the style
		var iconStyle2 = new ol.style.Style({
// 	    	fill: new ol.style.Fill({
// 	      		color: 'red'
// 	    	}),
	    	stroke: new ol.style.Stroke({
	    		color: 'red',
	      		width: 1.5,
	      		lineDash: [4]
	    	})
	    });
	    vectorLayer_mini = new ol.layer.Vector({
	        source: vectorSource_mini,
	        style: iconStyle2
	    });	
	    
		var coord_v = geom;
		coord_v = coord_v.replace('MULTIPOLYGON', '');
		coord_v = coord_v.replace('(((', '');
		coord_v = coord_v.replace(')))', '');
		var coord_sp = coord_v.split(",");
		var coord_sp_t = new Array();
		
		for(j=0; j<coord_sp.length; j++){
			if(coord_sp[j] != ""){
				var arry1 = coord_sp[j].split(' ');			
				var val = ol.proj.transform([ Number( arry1[0] ), Number( arry1[1] ) ], 'EPSG:4326', 'EPSG:900913');
				coord_sp_t[j] = new Array( val[0], val[1] );
			}
		}																
		
		var iconFeature_mini = new ol.Feature({
	           geometry: new ol.geom.Polygon([ coord_sp_t ])
	    });			
		vectorSource_mini.addFeature(iconFeature_mini);										
	  	
	    geoMap_mini.addLayer(vectorLayer_mini);
	    
	    var spot = ol.proj.transform([Number(addr_x), Number(addr_y)], 'EPSG:4326', 'EPSG:900913');
		view_mini.setCenter(spot);	
		view_mini.setZoom(17);
		
		//지도와 로드뷰 위에 마커로 표시할 특정 장소의 좌표입니다 
		var position = new daum.maps.LatLng(Number(addr_y), Number(addr_x));    		
		roadviewClient.getNearestPanoId(position, 50, function(panoId) {
	        roadview.setPanoId(panoId, position);
	        roadview.relayout();
	    });
		
	}   
	
	geoMap_mini.renderSync();
}



</script>	

	<title>SH | 토지자원관리시스템</title>

</head>
<body>	
	
	<div id="load">
	    <img src="/jsp/SH/img/ajax-loader.gif"><p>LOADING</p>
	</div>
	
    	<!-- 상세보기-Popup -->
        <div class="popover layer-pop detail-view new-pop" id="detail-view">
            <div class="popover-title tit">
                <span class="m-r-5"><b>상세보기</b></span>
            </div>
            <div class="popover-body">


                <div class="popover-content-wrap detail-view">
                    <div class="popover-content p-20">
						  
                        <div class="row detail-view h100p">
                            <div class="col-xs-8 h100p">
                                <div class="card-box box1 p-0 m-b-0">
                                
                                    <ul class="nav nav-tabs">
                                        <li class="active"><a data-toggle="tab" href="#dv-dist-one">택지현황</a></li>
                                   	<c:if test="${!empty dist_list_add}">
                                   		<li><a data-toggle="tab" href="#dv-dist-all">추가정보</a></li>
                                   	</c:if>
                                    </ul>
                                    
                                    <div class="tab-content detail-view">                                    
                                    	<div id="dv-dist-one" class="tab-pane fade in active">
                                    	
                                        	<input type="hidden" id="detail_dist_one_geom" value='<c:out value="${dist_list[0].geom_as}"/>'/>
                                        	<input type="hidden" id="detail_dist_one_addr_x" value='<c:out value="${dist_list[0].addr_x}"/>'/>
                                      		<input type="hidden" id="detail_dist_one_addr_y" value='<c:out value="${dist_list[0].addr_y}"/>'/>
                                      		
                                        	<div class="table-wrap" id="table_dist_one">
                                        		<table class="table table-custom table-cen table-num text-center" width="100%">
                                                    <colgroup>
                                                        <col width="20%"/>
                                                        <col width="30%"/>
                                                        <col width="20%"/>
                                                        <col width="30%"/>
                                                    </colgroup>
                                                    <caption align="top"><b>데이터기준일자 : </b><span  id="detail_dist_a0">2017</span></caption>
                                                    <tbody>
                                                    <tr>
                                                        <th scope="row">사업지구</th>				
                                                        <td id="detail_dist_a1"><c:out value="${dist_list[0].a1}"/></td>
                                                        <th>획지구분</th>						
                                                        <td id="detail_dist_a2"><c:out value="${dist_list[0].a2}"/></td>	
                                                    </tr>
                                                    <tr>
                                                        <th>가구번호</th>
                                                        <td id="detail_dist_a3"><c:out value="${dist_list[0].a3}"/></td>
                                                        <th>용지</th>		
                                                        <td id="detail_dist_a4"><c:out value="${dist_list[0].a4}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>시설</th>
                                                        <td id="detail_dist_a5"><c:out value="${dist_list[0].a5}"/></td>
                                                        <th>획지위치</th>		
                                                        <td id="detail_dist_a6"><c:out value="${dist_list[0].a6}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>획지면적</th>
                                                        <td id="detail_dist_a7"><c:out value="${dist_list[0].a7}"/></td>
                                                        <th>가구면적</th>		
                                                        <td id="detail_dist_a8"><c:out value="${dist_list[0].a8}"/></td>
                                                    </tr>
                                                    <tr>
                                                    	<th>용도지역</th>
                                                        <td id="detail_dist_a9"><c:out value="${dist_list[0].a9}"/></td>
                                                        <th>용도구역</th>
                                                        <td id="detail_dist_a10"><c:out value="${dist_list[0].a10}"/></td>
                                                    </tr>
                                                    <tr>
                                                    	<th>계획구역</th>		
                                                        <td id="detail_dist_a11"><c:out value="${dist_list[0].a11}"/></td>
                                                        <th>기반시설</th>
                                                        <td id="detail_dist_a12"><c:out value="${dist_list[0].a12}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>건폐율</th>		
                                                        <td id="detail_dist_a13"><c:out value="${dist_list[0].a13}"/></td>
                                                        <th>용적률</th>		
                                                        <td id="detail_dist_a15"><c:out value="${dist_list[0].a15}"/></td>
                                                    </tr>
                                                    <tr>
														<th>높이</th>		
                                                        <td id="detail_dist_a17"><c:out value="${dist_list[0].a17}"/></td>
                                                        <th>건축선</th>		
                                                        <td id="detail_dist_a19"><c:out value="${dist_list[0].a19}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>세대수</th>
                                                        <td id="detail_dist_a20"><c:out value="${dist_list[0].a20}"/></td>
                                                        <th>인구수</th>		
                                                        <td id="detail_dist_a21"><c:out value="${dist_list[0].a21}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>허용용도</th>
                                                        <td id="detail_dist_a22"><c:out value="${dist_list[0].a22}"/></td>
                                                        <th>지정용도</th>		
                                                        <td id="detail_dist_a23"><c:out value="${dist_list[0].a23}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>권장용도</th>
                                                        <td id="detail_dist_a24"><c:out value="${dist_list[0].a24}"/></td>
                                                        <th>완화용도</th>		
                                                        <td id="detail_dist_a25"><c:out value="${dist_list[0].a25}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>불허용도</th>
                                                        <td id="detail_dist_a26"><c:out value="${dist_list[0].a26}"/></td>
                                                        <th>배치</th>		
                                                        <td id="detail_dist_a27"><c:out value="${dist_list[0].a27}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>형태</th>
                                                        <td id="detail_dist_a28"><c:out value="${dist_list[0].a28}"/></td>
                                                        <th>색채</th>		
                                                        <td id="detail_dist_a29"><c:out value="${dist_list[0].a29}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>차량관련</th>
                                                        <td id="detail_dist_a30"><c:out value="${dist_list[0].a30}"/></td>
                                                        <th>공개공지등</th>		
                                                        <td id="detail_dist_a31"><c:out value="${dist_list[0].a31}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>비고</th>
                                                        <td id="detail_dist_a32"><c:out value="${dist_list[0].a32}"/></td>
                                                        <th></th>
                                                        <td></td>
                                                    </tr>
                                                    
                                                    </tbody>
                                                </table>
                                        	</div>
                                        </div>
                                        
                                        <div id="dv-dist-all" class="tab-pane fade">
                                        	<div class="table-wrap" id="table_dist_all">
                                        		<table class="table table-custom table-cen table-num text-center" width="100%">
                                        			<tbody>
                                        				<colgroup>
                                                        <col width="20%"/>
                                                        <col width="30%"/>
                                                        <col width="20%"/>
                                                        <col width="30%"/>
                                                    </colgroup>
                                                    <caption align="top"><b>데이터기준일자 : </b><span  id="detail_dist_a0">2017</span></caption>
                                                    <tbody>
	                                                    <tr>
	                                                        <th scope="row">획지구분</th>				
	                                                        <td id="detail_dist_a1"><c:out value="${dist_list_add[0].a1}"/></td>
	                                                        <th>가구번호</th>						
	                                                        <td id="detail_dist_a2"><c:out value="${dist_list_add[0].a2}"/></td>	
	                                                    </tr>
	                                                    <tr>
	                                                        <th>지구</th>
	                                                        <td id="detail_dist_a3"><c:out value="${dist_list_add[0].a3}"/></td>
	                                                        <th>용도</th>		
	                                                        <td id="detail_dist_a4"><c:out value="${dist_list_add[0].a4}"/></td>
	                                                    </tr>
	                                                    <tr>
	                                                        <th>면적(㎡)</th>
	                                                        <td id="detail_dist_a5"><c:out value="${dist_list_add[0].a5}"/></td>
	                                                        <th>추정가격(원)</th>		
	                                                        <td id="detail_dist_a6"><c:out value="${dist_list_add[0].a6}"/></td>
	                                                    </tr>
	                                                    <tr>
	                                                        <th>비고(공급대상)</th>
	                                                        <td id="detail_dist_a7"><c:out value="${dist_list_add[0].a7}"/></td>
	                                                        <th></th>		
	                                                        <td></td>
	                                                    </tr>                                        			
                                        					                                        			
                                        			</tbody>		                                        		
                                        		</table>
                                        	</div>
                                        </div>
                                        
                                    </div> 
                                </div>
                            </div>
							  

                            <div class="col-xs-4 h100p"> 
                                <div class="row h50p">
                                    <div class="col-xs-12 h100p">
                                        <div class="card-box box2 h100p" id="geomap_mini">

                                        </div>
                                    </div>
                                </div>

                                <div class="row box3-wrap">
                                    <div class="col-xs-12 h100p">
                                        <div class="card-box box3 m-b-0 h100p" id="potalmap_mini"></div>	  
                                    </div>
                                </div>

                            </div>

                        </div>
                    </div>
                </div>
            </div>
			  
            <div class="popover-footer detail-view">
                <div class="col-xs-12">
                    <div class="btn-wrap text-left">
<%--                         <button type="button" class="btn btn-sm btn-gray" onclick="javascript:window.open('http://seereal.lh.or.kr/goLinkPage.do?linkMenu=1&q_pnu=${pnu}');">토지이용계획확인서(온나라지도)</button> --%>
<%--                         <button type="button" class="btn btn-sm btn-gray" onclick="javascript:window.open('http://seereal.lh.or.kr/goLinkPage.do?linkMenu=2&q_pnu=${pnu}');">개별공시지가(온나라지도)</button> --%>
                    </div>
                </div>
				  
<!--                 <div class="col-xs-6"> -->
<!--                     <div class="btn-wrap text-right p-10"> -->
<!--                         <button type="button" class="btn btn-sm btn-danger w-xs">삭제</button> -->
<!--                         <button type="button" class="btn btn-sm btn-teal w-xs">수정</button> -->
<!--                         <button type="button" class="btn btn-sm btn-custom w-xs" id="detail-view-close2">확인</button> -->
<!--                     </div> -->
<!--                 </div> -->
            </div>
        </div>
        <!--// End 상세보기-Popup -->
    
    
    
    <script type="text/javascript" src='/jsp/SH/js/map/geoMap.js'></script>
    <script type="text/javascript" src='/jsp/SH/js/map/mini_geoMap.js'></script>
    <script type="text/javascript" src='/jsp/SH/js/map/mini_potalMap_daum.js'></script>
    
</body>    
    