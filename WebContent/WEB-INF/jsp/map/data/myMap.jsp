<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />

<script src="/resources/js/map/event/layerEvent.js"></script> 	<!-- 마이데이터 마이맵 js -->
<link rel="stylesheet" href="<c:url value='/resources/css/task/myData.css'/>" >
<script>

$(document).ready(function() {
	$('#sub_content').show();
	shareUserList=[]; //공유리스트 초기화
	
	$('#myMap-mini').draggable({containment:"#NormalLayout"}).css('width','auto'); //shp업로드 팝업 드래그
	
	initModal('myMap-mini'); 	//common/modal.js에서 선언
	gfn_transaction("/data/map/sel.do", "POST", {curPage:1, firstIndex:1,lastIndex:10}, "map_select"); 
});
</script>
<title>마이데이터 - 마이맵</title>
<body>
<div id="rowShareDiv" class="rowShare" style="display:none;">
	<div class="depthWrap">
		<div class="disFlex" style="float: right; cursor: pointer;">
			<img class="closeBtn" id="shape-mini-close" onclick="$('#rowShareDiv').hide();$('.mydataItem').css('border','1px solid rgba(46, 54, 67, 0.2)');" src="/resources/img/map/icClose24.svg" alt="닫기">
        </div>
    	<h2 class="tit">공유 대상</h2>
    	
    	<div id="row_shp_to_share" data-ax5grid="share-grid" data-ax5grid-config='{}'  style="height: 500px;width:100%;overflow:scroll;margin-top: 20px;"></div>
    </div>   
    <div class="foot">
        <button type="button" class="gray100Line" id="row_shape_reset" onClick="fn_reset();">초기화</button> 
        <button type="button" style="margin:0;padding: 2rem 2.4rem;width: auto;" class="primaryBG" id="row_shape_to_save" onClick="fn_map_to_save('row');">공유하기</button>
    </div>            
</div>

<div role="tabpanel" class="areaSearch full" id="tab-03" style="overflow:auto;">
	<h2 class="tit" id="submenuTitle">마이맵</h2>
	<div class="fn-wrap text-right">
		<button class="btn btn-darkgray btn-sm" onclick="gfn_validation('myMap',this);">즐겨찾기 등록</button>
	</div>
	
	<div class="stepBox">
		<p class="on"> 나의 데이터 마이맵 저장 목록</p>
		<ul id="shareDataLoadList" class="mydataList">
			<!-- <li>	
				<a href="javascript:$mydataDataBoard.ui.updateMyData('1a34f43ff8b662fa2483b398d02199bb_20160722104335681','전국도서관', 'location', '2');">		
					<div class="mydata_title" style="float: left;">전국도서관</div>		
				</a>
				<div class="mydata_info">
					<button>공유</button>
					<button>다운로드</button>
				</div>
			</li> -->
		</ul>
	</div>
</div>
<div class="breakLine"></div>
<div class="disFlex smBtnWrap" style="justify-content: center;">  
	<div class="text-center" style="height: 4rem;display: block;" id="mydata_page_wrap">
	    <ul class="pagination m-b-5 m-t-10 pagination-sm " id="mydata_page">
	        <li class="disabled">
	            <a href="#"><i class="fa fa-angle-left" aria-hidden="true"></i></a>
	        </li>
	        <li class="active">
	            <a href="#">1</a>
	        </li>
	        <li class="disabled">
	            <a href="#"><i class="fa fa-angle-right" aria-hidden="true"></i></a>
	        </li>
	    </ul>
	</div>
</div>
</body>
