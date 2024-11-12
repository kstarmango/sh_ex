<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />


    <!-- fontawesome -->
    <script src="https://kit.fontawesome.com/7b4ae744d5.js" crossorigin="anonymous"></script>

    <!-- MaterialDesign-Webfont   -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/MaterialDesign-Webfont/5.6.55/css/materialdesignicons.min.css" integrity="sha512-75gimAGx0NOGihrwAtl3xq9SUgq1a3NtIe9fTBtrHOajqMEHCNLZI/BMVE9oMSG3ms5sVira5A2coilfdmxfjA==" crossorigin="anonymous">

	<!-- <style>
			#container {position:relative;}
			#btnRoadview,  #btnMap {position:absolute;top:30px;left:5px;font-size:14px;z-index:1;cursor:pointer;}
			#btnRoadview:hover,  #btnMap:hover{background-color: #fcfcfc;border: 1px solid #c1c1c1;}
				#container.view_map #roadview {display: none;}
			#container.view_map #btnMap {display: none;}
				#container.view_roadview #roadview {display:block;}
			#container.view_roadview #btnRoadview {display: none;}
			   
			
			.legendCloseBtn {position: absolute;top: 0.5rem;right: 1rem;font-size: 1.5rem;font-weight: bold;cursor: point}
			   .mapLegendWrap {display:none;}
			.mapLegendWrap .mapLegend {position: absolute;z-index: 2;width: 14em;right: 6em;bottom: 3em;padding: 2em; background-color: white; background: rgba(255, 255, 255, 0.85);border-radius: 1rem;display: flex;flex-direction: column;padding: 0.5em;}
			.mapLegendWrap .mapLegend .regionChecked {font-weight: 500;font-size: 1rem;line-height: 2.4rem;color: #0d18}
			.mapLegendWrap .mapLegend .regionChecked label {display: flex;align-items: center;}
			.mapLegendWrap .mapLegend .regionChecked .depth {margin-left: 1.8rem;width: 13rem;line-height: 2.4r}
			.mapLegendWrap .mapLegend .regionChecked .regionTit {margin-left: 0.4rem;}
			.legend-colorbox {display: inline-block;width: 1rem;height: 1rem;margin-right: 0.8rem;}
			.grade_level1 {background-color: #590d22;}
			.grade_level2 {background-color: #800f2f;}
			.grade_level3 {background-color: #a4133c;}
			.grade_level4 {background-color: #ff4d6d;}
			.grade_level5 {background-color: #ff8fa3;}
			.grade_level6 {background-color: #ffccd5;}
		</style> -->

<script>
var userGridList; 			//grid 공유자 목록 표출
var shareUserList = [];		//공유될 사용자 목록
$(document).ready(function(){
	userGridList = JSON.parse('${shareUserList}'); //2024.08.22 마이데이터 공유기능 추가로 인하여 추가
	
	clickEvent(clickType);
	
	fn_layerListInit();//레이어 목록 초기에 그려주기 2024.09.03 새로만듬
	

	$("#toggle_layersLine li>div>a").click(function(){
		$("#toggle_layersLine li").not($(this).parent().parent()).removeClass("active");
		$(this).parent().parent().toggleClass("active");
	});
	// initModal('myMap-mini'); 	//common/modal.js에서 선언

});

function showTooltip(a){
	$("#"+a).toggleClass("hide");
}

</script>

<!-- map-container -->
<div class="mapArea"  id="geomap" style="width:100%; height:100%;"> </div>
<!-- End map-container -->	  
 
<!-- 주소검색 -->
<c:import url="/WEB-INF/jsp/map/addr_search.jsp"></c:import>
<!-- End 주소검색 -->

<!-- 데이터 추출 팝업 영역 -->
<form id="dataExportForm">
<div id="area_sectDiv" class="dataAreaSect" style="display:none;">
	<div class="disFlex" style="float: right; cursor: pointer;">
			<img class="closeBtn" id="areaSect-mini-close" onclick="$('#area_sectDiv').hide(); exportReset();" src="/resources/img/map/icClose24.svg" alt="닫기">
        </div>
	<h2 class="tit">데이터 추출</h2>
	
	<div style ="height: auto;">
		<dl class="fl">
			<dt>추출 유형</dt>
			<dd>
				<ul id="geom_searchType_ul" class="form clear">
					<li id="smLi_intersects" class="ico on" onclick="searchTypeLayout('intersects')">
						<a href="javascript:void(0);"><span class="part">부분포함</span></a>
						<span class="txt">부분포함</span>
					</li>
					<li id="smLi_contains" class="ico" onclick="searchTypeLayout('contains')">
						<a href="javascript:void(0);"><span class="full">완전포함</span></a>
						<span class="txt">완전포함</span>
					</li>
					<li id="smLi_centroid" class="ico" onclick="searchTypeLayout('centroid')">
						<a href="javascript:void(0);"><span class="centroid">중심점 포함</span></a>
						<span class="txt">중심점 포함</span></li>
				</ul>
			</dd>
		</dl>
		
		<dl class="fl" id="area_intersects">
			<dt>포함면적</dt>
			<dd>
				<input type="text" value="50" id="areaPer" name="areaPer" title="포함면적"><span class="txt2">% 이상</span>
			</dd>
		</dl>
		
		<input type ="hidden" id="format" name="format">
		<input type ="hidden" id="layerList" name="layerList">
		<input type ="hidden" id="geom" name="geom">
		<input type ="hidden" id="type" name="type">
		
	</div>
	
	<div>
		<input type="hidden" id = "exportType" name="exportType">
        <button class="primaryLine" onclick="fn_exportArea()" style="width: 271px;">데이터 추출하기</button>
    </div>
</div>
</form>
<!-- END 데이터 추출 팝업 영역-->

<!-- 2분할 지도 -->
<div id="potalmap_div" class="mapArea" style="width:50%; height:100%; float:left; right: 0%;position: absolute;top: 0%;display:none;">
	<div id="container" class="view_map" style="width:100%; height:100%; float:left; ">
		<div id="mapWrapper" style="width:100%;height:100%;position:absolute; bottom:0px; right:0px;">
	    	<div id="dmap" style="width:100%;height:100%;"></div>
	    	<button class="btn btn-teal btn-sm text-left" id="btnRoadview" onclick="toggleMap(false)">로드뷰</button>
	  	</div>
	  	<div id="rvWrapper" style="width:100%;height:100%;position:absolute;">
	      	<div id="roadview" style="height:100%;"></div>
	      	<button class="btn btn-teal btn-sm text-left" id="btnMap" onclick="toggleMap(true)">지도</button>
	  	</div>
	</div>
</div>
<!-- End 2분할 지도 -->

<!-- Map-Component -->
<div class="mapTopBtn">
	<button type="button" class="primaryLine" onClick="area_sect();">
    	<img src="${pageContext.request.contextPath}/resources/img/map/icDataBtn.svg" alt="데이터추출 아이콘"> 데이터 추출
    </button>
    <div class="BtnWrapSM">
         <button type="button" onclick="menuToogle(this);baseMap_change('Base');" class="hover">일반</button>
         <button type="button" onclick="menuToogle(this);baseMap_change('Satellite');">위성</button>
         <button type="button" onclick="menuToogle(this);baseMap_change('gray');">흑백지도</button>
         <button type="button" onclick="menuToogle(this);baseMap_change('cbnd');">지적도</button>
         <button type="button" onclick="menuToogle(this);potalMap();">로드뷰</button>
     </div>

	<button type="button" class="layer" onclick="visibleToggle('default_layer',this);" id='layer_btn'></button> 

	<!-- LayerModal -->
	<c:import url="/WEB-INF/jsp/map/layer.jsp"></c:import>
    <!-- //LayerModal -->
    
    <!-- Content_SH_View_mini.jsp -->
	 <c:import url="/WEB-INF/jsp/map/Content_SH_View_mini.jsp"></c:import>
</div>
<!-- End Map-Component -->

<!-- Map-부가기능 -->
<div class="mapBTBtn">
	<div>
        <button type="button"><img src="${pageContext.request.contextPath}/resources/img/map/btnMapBT01.svg" alt="확대" onclick="ZoomIn();"><span class="tooltip_edit">확대하기</span></button>
        <button type="button"><img src="${pageContext.request.contextPath}/resources/img/map/btnMapBT02.svg" alt="축소" onclick="ZoomOut();"><span class="tooltip_edit">축소하기</span></button>
        <button type="button"><img src="${pageContext.request.contextPath}/resources/img/map/btnMapBT03.svg" alt="새로고침" onclick="Redraw();"><span class="tooltip_edit">새로고침</span></button>
        <button type="button"><img src="${pageContext.request.contextPath}/resources/img/map/btnMapBT04.svg" alt="정보보기" onclick="ClickSelect();"><span class="tooltip_edit">정보보기</span></button>
        <button type="button"><img src="${pageContext.request.contextPath}/resources/img/map/btnMapBT05.svg" alt="전체보기" onclick="FullExtent();"><span class="tooltip_edit">전체보기</span></button>
        <button type="button"><img src="${pageContext.request.contextPath}/resources/img/map/btnMapBT06.svg" alt="거리재기" onclick="measureLength();"><span class="tooltip_edit">거리재기</span></button>
        <button type="button"><img src="${pageContext.request.contextPath}/resources/img/map/btnMapBT07.svg" alt="면적재기" onclick="measureArea();"><span class="tooltip_edit">면적재기</span></button>
        <button type="button"><img src="${pageContext.request.contextPath}/resources/img/map/btnMapBT08.svg" alt="이미지저장" onclick="export_png();"><span class="tooltip_edit">저장하기</span></button>
    </div>
    <div class="txtNotice">
        <p>본 지도서비스는 법적 효력이 없으며, 참고 자료로만 활용 가능합니다.</p>
        <p>도시연구원/황종아/Tel.02-3410-8504/Copyright ⓒ 2018 서울주택공사 All Rights Reserved.</p>
    </div>

</div>
<!-- End Map-부가기능 -->        
        
	<!-- Alert Pop-up -->
	<div class="alert-box-wrap hidden">
		<div class="alert-box land-manager">
	        <div class="alert-box-header tit">
	            <div class="alert-box-title">알림</div>
	        </div>
	        <div class="alert-box-content">
	            <p class="m-b-0 font-600">검색속도를 위해 [시군구]를 반드시 선택하세요.</p>
	        </div>
	        <div class="alert-box-footer">
	            <div class="text-right">
	                <button class="btn btn-custom">확인</button>
	            </div>
	        </div>
	    </div>
    </div>
    <!--// Alert Pop-up -->

	<!-- 마이맵 팝업 UI -->
	<div class="mapPopup" id="myMap-mini" style="display: none; position:absolute;z-index: 2; left:20%;">
	    <!---Title -->
      <div class="head" id='convert_title'>
          <h2>마이맵</h2>
          <div class="disFlex">
              <img class="closeBtn" id="myMap-mini-min" onClick="fn_modal_min('myMap-mini');" src="${pageContext.request.contextPath}/resources/img/map/btnPopHeadMin.svg" alt="숨기기">
              <img class="closeBtn" id="myMap-mini-max" onClick="fn_modal_max('myMap-mini');" src="${pageContext.request.contextPath}/resources/img/map/btnPopHeadMax.svg" alt="크게 보기">
              <img class="closeBtn" id="myMap-mini-close" onClick="fn_modal_onOff('myMap-mini');" src="${pageContext.request.contextPath}/resources/img/map/icClose24.svg" alt="닫기">
          </div>
      </div>
		<!-- End-Title -->
		
		 <!--정보 Panel-Content -->
		<div class="disFlex shareRow" id="modal_content">
			<div class="cont">
				<div class="inputWrap">
                    <form class="fileInput">
                        <label for="map_save_nm">· 제목</label>
                 		<input type="text" id="map_save_nm" name="map_save_nm" title="제목" placeholder="제목을 입력하세요." style="min-width: 51rem;">
                    </form>
                </div>
                
                 <div class="resultWrap" id="myMapResult" style="display:block;">
                 	<div class="tit disFlex">
	                    <h3 class="tit">공유대상 선택</h3>
	                    <button type="button" onClick="visibleToggle('mapShareDiv');fn_initGridShare();">
	                        <img src="${pageContext.request.contextPath}/resources/img/map/btnShare24.svg" alt="공유 대상 선택">
	                    </button>
	                </div>
	                
	                 <div id="mapShareDiv" style="display:none;">
		           		<div id="map_to_share" data-ax5grid="map_to_share_grid" data-ax5grid-config='{}'  style="height: 300px;width:100%;overflow-y:scroll;"></div> 
		            </div>
                 </div>
			</div>
		</div>
	    
	    <div class="foot" id="modal_foot">
            <button type="button" class="gray100Line" id="myMap_reset" onClick="fn_reset();">초기화</button>
            <button type="button" class="primaryBG" id="map_to_save" style="padding: 2rem 2.4rem;width: auto;margin-top: 0;" onClick="fn_map_to_save('init');">저장 및 공유</button>
        </div>
	</div>

<%-- <script type="text/javascript" src="<c:url value='/resources/js/portal/add_search.js'/>"></script>  --%>
<script src="<c:url value='/resources/js/map/geoMap.js'/>"></script>
<script src="<c:url value='/resources/js/map/potalMap_daum.js'/>"></script>
<script src="<c:url value='/resources/js/map/geoMap_menu.js'/>"></script>
<script src="<c:url value='/resources/js/util/jquery/jquery.app.js'/>"></script> 
	<script>
	
	    (function($) {
		
	        $.fn.sizeChanged = function(handleFunction) {

	            var element = this;
	            var lastWidth = element.width();
	            var lastHeight = element.height();

	            setInterval(function() {
	                if (lastWidth === element.width() && lastHeight === element.height())
	                    return;
	                if (typeof(handleFunction) == 'function') {
	                    handleFunction({
	                        width: lastWidth,
	                        height: lastHeight
	                    }, {
	                        width: element.width(),
	                        height: element.height()
	                    });
	                    lastWidth = element.width();
	                    lastHeight = element.height();
	                }
	            }, 100);


	            return element;
	        };

	    }(jQuery));


	    var toggles = true;
	    function main_toggle(){
	    	if(toggles){
	        	$("#search, #main-panel, #main-panel-01, #main-panel-02, #bookmark-pop").hide();
	        	$('#searching_item').toggleClass('hidden');
	        	$('#searching_data').toggleClass('hidden');
	        	$('#searching_space').toggleClass('hidden');
	        	toggles = false;
	        }else{
	        	$("#search, #main-panel, #main-panel-01, #main-panel-02, #bookmark-pop").show();
	        	$('#searching_item').toggleClass('hidden');
	        	$('#searching_data').toggleClass('hidden');
	        	$('#searching_space').toggleClass('hidden');
	        	toggles = true;
	        }
	    }
	    $(document).ready(function() {

	    	//드래그
	        $('.layer-pop, .info-layer-stat, .bookmark-pop').draggable({
	            cursor: 'move',
	            handle: '.tit',
	            containment: 'parent'
	        });

	    	//레이아웃 토글
	    	$('#menu-toggle-btn, #menu-toggle-btn02').click(function() {
	            $('header').toggleClass('hidden');
	            $('.wrapper').toggleClass('menu-hidden');
	            $('.wrapper-content').toggleClass('menu-hidden');
	            $('.sel-map').toggleClass('menu-hidden');
	            $('.map-layer .map-layer-btn').toggleClass('menu-hidden');
	            $('.map-layer .map-layer-btn-group').toggleClass('menu-hidden');
	            $('.map-content').toggleClass('menu-hidden');
	            $('.menu-toggle-btn02').toggleClass('menu-hidden');

	            //지도화면 크기조정
	            var omapSize = geoMap.getSize();
				omapSize[1] = $("#geomap").height();
				geoMap.setSize(omapSize);
	            geoMap.render();
	    		geoMap.renderSync();

	    		$(window).trigger('resize');
	        });


	        $("#search, #main-panel, #main-panel-01, #main-panel-02, #bookmark-pop").show();
	        $('#main-panel-btn').click(function() {
	        	main_toggle();
	        });

	        $('#selectArrowBtn').click(function() {
	        	$('#main-panel').toggleClass('hidden');
	        });


	        $('#main-panel-close').click(function() {
	            $('#main-panel').toggleClass('hidden');
	        });

	    });
	</script>
