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
 	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9ff261a4051cb3801aa6d8f90b1fe032"></script>



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
<!--                         <div class="row"> -->
<!--                             <div class="col-xs-8"> -->
<!--                                 <h5 class="m-0"><b>상세 정보 조회</b></h5> -->
<!--                             </div> -->
<!--                             <div class="col-xs-4"> -->
<!--                                 <form action="" class="form-horizontal"> -->
<!--                                     <div class="row"> -->
<!--                                         <div class="col-xs-12"> -->
<!--                                             <div class="form-group"> -->
<!--                                                 <label for="sel" class="control-label col-xs-3">수정일자</label> -->
<!--                                                 <div class="col-xs-9"> -->
<!--                                                     <select name="" id="sel" class="form-control input-sm"> -->
<!--                                                         <option value="">2017.08.01</option> -->
<!--                                                         <option value="">2017.08.30</option> -->
<!--                                                         <option value="">2017.08.31</option> -->
<!--                                                     </select> -->
<!--                                                 </div> -->
<!--                                             </div> -->
<!--                                         </div> -->
<!--                                     </div> -->
<!--                                 </form> -->
<!--                             </div> -->
<!--                         </div> -->

                        <div class="row detail-view h100p">
                            <div class="col-xs-8 h100p">
                                <div class="card-box box1 p-0 m-b-0">

                                    <ul class="nav nav-tabs">
                                        <li class="active"><a data-toggle="tab" href="#dv-dist-one">택지현황</a></li>
                                        <li><a data-toggle="tab" href="#dv-dist-all">총괄매각현황</a></li>
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
                                                        <th scope="row">필지번호</th>
                                                        <td id="detail_dist_a8"><c:out value="${dist_list[0].a8}"/></td>
                                                        <th>판매구분</th>
                                                        <td id="detail_dist_a2"><c:out value="${dist_list[0].a2}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>지구</th>
                                                        <td id="detail_dist_a3"><c:out value="${dist_list[0].a3}"/></td>
                                                        <th>용도지역</th>
                                                        <td id="detail_dist_a4"><c:out value="${dist_list[0].a4}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>단지구분</th>
                                                        <td id="detail_dist_a5"><c:out value="${dist_list[0].a5}"/></td>
                                                        <th>용도</th>
                                                        <td id="detail_dist_a6"><c:out value="${dist_list[0].a6}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>세부용도</th>
                                                        <td id="detail_dist_a7"><c:out value="${dist_list[0].a7}"/></td>
                                                        <th>고시면적(㎡)(2014.05.08)</th>
                                                        <td id="detail_dist_a9"><c:out value="${dist_list[0].a9}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>고시면적(㎡)(2015.05.28)</th>
                                                        <td id="detail_dist_a10"><c:out value="${dist_list[0].a10}"/></td>
                                                        <th>고시면적(㎡)(2017.05.04)(2017.07.27)</th>
                                                        <td id="detail_dist_a11"><c:out value="${dist_list[0].a11}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>용적률</th>
                                                        <td id="detail_dist_a12"><c:out value="${dist_list[0].a12}"/></td>
                                                        <th>건폐율</th>
                                                        <td id="detail_dist_a13"><c:out value="${dist_list[0].a13}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>높이제한</th>
                                                        <td id="detail_dist_a14"><c:out value="${dist_list[0].a14}"/></td>
                                                        <th>지정용도</th>
                                                        <td id="detail_dist_a15"><c:out value="${dist_list[0].a15}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>가격시점</th>
                                                        <td id="detail_dist_a16"><c:out value="${dist_list[0].a16}"/></td>
                                                        <th>평가금액(조성원가)</th>
                                                        <td id="detail_dist_a17"><c:out value="${dist_list[0].a17}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>평당 가격</th>
                                                        <td id="detail_dist_a18"><c:out value="${dist_list[0].a18}"/></td>
                                                        <th>판매방법</th>
                                                        <td id="detail_dist_a19"><c:out value="${dist_list[0].a19}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>판매여부</th>
                                                        <td id="detail_dist_a20"><c:out value="${dist_list[0].a20}"/></td>
                                                        <th>계약일자</th>
                                                        <td id="detail_dist_a21"><c:out value="${dist_list[0].a21}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>계약면적(㎡)</th>
                                                        <td id="detail_dist_a22"><c:out value="${dist_list[0].a22}"/></td>
                                                        <th>계약금액</th>
                                                        <td id="detail_dist_a23"><c:out value="${dist_list[0].a23}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>낙찰율</th>
                                                        <td id="detail_dist_a24"><c:out value="${dist_list[0].a24}"/></td>
                                                        <th>계약자</th>
                                                        <td id="detail_dist_a25"><c:out value="${dist_list[0].a25}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>연락처</th>
                                                        <td id="detail_dist_a26"><c:out value="${dist_list[0].a26}"/></td>
                                                        <th>기업구분</th>
                                                        <td id="detail_dist_a27"><c:out value="${dist_list[0].a27}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>잔금완납일</th>
                                                        <td id="detail_dist_a28"><c:out value="${dist_list[0].a28}"/></td>
                                                        <th>착공 토지사용승낙일</th>
                                                        <td id="detail_dist_a29"><c:out value="${dist_list[0].a29}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>미판매사유</th>
                                                        <td id="detail_dist_a30"><c:out value="${dist_list[0].a30}"/></td>
                                                        <th>담당자</th>
                                                        <td id="detail_dist_a31"><c:out value="${dist_list[0].a31}"/></td>
                                                    </tr>

                                                    </tbody>
                                                </table>
                                        	</div>
                                        </div>

                                        <div id="dv-dist-all" class="tab-pane fade">
                                        	<input type="hidden" id="detail_dist_all_geom"/>
                                        	<input type="hidden" id="detail_dist_all_addr_x"/>
                                        	<input type="hidden" id="detail_dist_all_addr_y"/>
                                        	<div class="table-wrap" id="table_dist_all">
                                        		<table class="table table-custom table-cen table-num text-center" width="100%">
                                        			<caption align="top"><span  id="detail_dist_a0">(단위:㎡,억원)</span></caption>
                                        			<tbody>
                                        				<tr>
                                        					<th rowspan="2" colspan="2">구분</th>
                                        					<th rowspan="2">용도</th>
                                        					<th colspan="3">총매각대상</th>
                                        					<th colspan="4">기매각</th>
                                        					<th colspan="4">미매각</th>
                                        				</tr>
                                        				<tr>
                                        					<th>필지</th><th>면적</th><th>금액</th>
                                        					<th>필지</th><th>면적</th><th>비율(%)</th><th>금액</th>
                                        					<th>필지</th><th>면적</th><th>비율(%)</th><th>금액</th>
                                        				</tr>
                                        				<tr>
                                        					<th colspan="3">계</th>
                                        					<td>496</td><td>1545609</td><td>64219</td>
                                        					<td>312</td><td>990788</td><td>64</td><td>46898</td>
                                        					<td>184</td><td>554821</td><td>36</td><td>17321</td>
                                        				</tr>
                                        				<tr>
                                        					<th rowspan="6" colspan="2">산업단지</th>
                                        					<th>소계</th>
                                        					<td>278</td>	<td>822877</td>	<td>27404</td>
                                        					<td>150</td>	<td>539851</td>	<td>0.65</td>	<td>18509</td>
                                        					<td>128</td>	<td>283026</td>	<td>0.34</td>	<td>8895</td>

                                        				</tr>
                                        				<tr>
                                        					<th>산업시설</th>
                                        					<td>207</td>	<td>729785</td>	<td>23200</td>	<td>127</td>	<td>502201</td>	<td>0.68</td>	<td>15881</td>	<td>80</td>	<td>227584</td>	<td>0.31</td>	<td>7319</td>
                                        				</tr>
                                        				<tr>
                                        					<th>지원시설</th>
                                        					<td>62</td>	<td>81326</td>	<td>3655</td>	<td>15</td>	<td>27047</td>	<td>0.33</td>	<td>2113</td>	<td>47</td>	<td>54279</td>	<td>0.66</td>	<td>1542</td>

                                        				</tr>
                                        				<tr>
                                        					<th>주차장(기반)</th>
                                        					<td>4</td>	<td>6776</td>	<td>330</td>	<td>3</td>	<td>5613</td>	<td>0.82</td>	<td>296</td>	<td>1</td>	<td>1163</td>	<td>0.17</td>	<td>34</td>
														</tr>
														<tr>
                                        					<th>가스충전소(기타)</th>
                                        					<td>2</td>	<td>4000</td>	<td>185</td>	<td>2</td>	<td>4000</td>	<td>1</td>	<td>185</td>	<td>0</td>	<td>0</td>	<td>-</td>	<td>0</td>
														</tr>
														<tr>
                                        					<th>보육시설(기반)</th>
                                        					<td>3</td>	<td>990</td>	<td>34</td>	<td>3</td>	<td>990</td>	<td>1</td>	<td>34</td>	<td>0</td>	<td>0</td>	<td>-</td>	<td>0</td>
														</tr>
														<tr>
                                        					<th rowspan="17">비산업단지</th>
                                        					<th rowspan="3">주거용지</th>
                                        					<th>소계</th>
                                        					<td>16</td>	<td>63077</td>	<td>2490</td>	<td>16</td>	<td>63077</td>	<td>1</td>	<td>2490</td>	<td>0</td>	<td>0</td>	<td>-</td>	<td>0</td>
														</tr>
														<tr>
                                        					<th>단독주택</th>
                                        					<td>15</td>	<td>4250</td>	<td>79</td>	<td>15</td>	<td>4250</td>	<td>1</td>	<td>79</td>	<td>0</td>	<td>0</td>	<td>-</td>	<td>0</td>
														</tr>
														<tr>
                                        					<th>공동주택(A13)</th>
                                        					<td>1</td>	<td>58827</td>	<td>2411</td>	<td>1</td>	<td>58827</td>	<td>1</td>	<td>2411</td>	<td>0</td>	<td>0</td>	<td>-</td>	<td>0</td>
														</tr>
														<tr>
                                        					<th colspan="2">상업용지</th>
                                        					<td>29</td>	<td>82814</td>	<td>6075</td>	<td>29</td>	<td>82814</td>	<td>1</td>	<td>6075</td>	<td>0</td>	<td>0</td>	<td>-</td>	<td>0</td>
														</tr>
														<tr>
                                        					<th colspan="2">업무용지</th>
                                        					<td>116</td>	<td>305328</td>	<td>19496</td>	<td>93</td>	<td>199694</td>	<td>0.65</td>	<td>15389</td>	<td>23</td>	<td>105634</td>	<td>0.34</td>	<td>4107</td>
														</tr>
														<tr>
                                        					<th rowspan="7">기반시설용지</th>
                                        					<th>소계</th>
                                        					<td>29</td>	<td>206864</td>	<td>5609</td>	<td>17</td>	<td>99273</td>	<td>0.47</td>	<td>4050</td>	<td>12</td>	<td>107591</td>	<td>0.52</td>	<td>1559</td>
														</tr>
														<tr>
                                        					<th>종합의료시설</th>
                                        					<td>1</td>	<td>33360</td>	<td>1628</td>	<td>1</td>	<td>33360</td>	<td>1</td>	<td>1628</td>	<td>-</td>	<td>-</td>	<td>-</td>	<td>-</td>
														</tr>
														<tr>
                                        					<th>공공청사</th>
                                        					<td>12</td>	<td>46490</td>	<td>1744</td>	<td>4</td>	<td>19345</td>	<td>0.41</td>	<td>623</td>	<td>8</td>	<td>27145</td>	<td>0.58</td>	<td>1121</td>
														</tr>
														<tr>
                                        					<th>학교</th>
                                        					<td>8</td>	<td>82330</td>	<td>829</td>	<td>5</td>	<td>18224</td>	<td>0.22</td>	<td>739</td>	<td>3</td>	<td>64106</td>	<td>0.77</td>	<td>90</td>
														</tr>
														<tr>
                                        					<th>사회복지시설</th>
                                        					<td>1</td>	<td>1700</td>	<td>55</td>	<td>0</td>	<td>0</td>	<td>-</td>	<td>0</td>	<td>1</td>	<td>1700</td>	<td>1</td>	<td>55</td>
														</tr>
														<tr>
                                        					<th>주차장</th>
                                        					<td>6</td>	<td>18844</td>	<td>775</td>	<td>6</td>	<td>18844</td>	<td>1</td>	<td>775</td>	<td>0</td>	<td>0</td>	<td>0</td>	<td>0</td>
														</tr>
														<tr>
                                        					<th>열공급설비</th>
                                        					<td>1</td>	<td>24140</td>	<td>578</td>	<td>1</td>	<td>9500</td>	<td>0.39</td>	<td>285</td>	<td>0</td>	<td>14640</td>	<td>0.60</td>	<td>293</td>
														</tr>
														<tr>
                                        					<th rowspan="5">기타시설용지</th>
                                        					<th>소계</th>
                                        					<td>28</td>	<td>64649</td>	<td>3145</td>	<td>7</td>	<td>6079</td>	<td>0.04</td>	<td>385</td>	<td>21</td>	<td>58570</td>	<td>0.96</td>	<td>2760</td>
														</tr>
														<tr>
                                        					<th>주유소</th>
                                        					<td>4</td>	<td>3200</td>	<td>230</td>	<td>2</td>	<td>1600</td>	<td>0.5</td>	<td>122</td>	<td>2</td>	<td>1600</td>	<td>0.5</td>	<td>108</td>
														</tr>
														<tr>
                                        					<th>종교</th>
                                        					<td>4</td>	<td>2947</td>	<td>100</td>	<td>4</td>	<td>2947</td>	<td>1</td>	<td>100</td>	<td>0</td>	<td>0</td>	<td>0</td>	<td>0</td>
														</tr>
														<tr>
                                        					<th>편익시설</th>
                                        					<td>13</td>	<td>48497</td>	<td>2518</td>	<td>1</td>	<td>1532</td>	<td>0.031</td>	<td>163</td>	<td>12</td>	<td>46965</td>	<td>0.96</td>	<td>2355</td>
														</tr>
														<tr>
                                        					<th>택시차고지</th>
                                        					<td>7</td>	<td>10005</td>	<td>297</td>	<td>0</td>	<td>0</td>	<td>-</td>	<td>0</td>	<td>7</td>	<td>10005</td>	<td>1</td>	<td>297</td>
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
