<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />


<script src="/resources/js/map/task/myData.js"></script> 	<!-- 마이데이터 업무 js -->
<script  src="/resources/js/map/task/geocode.js"></script> 	<!-- 주소변환 업무 js -->
<link rel="stylesheet" type='text/css' href="<c:url value='/resources/css/task/myData.css'/>" >

<script>
var geocode_grid;
var userGridList; 			//grid 공유자 목록 표출

var geocodeMap_mini;
$(document).ready(function() {
	$('#sub_content').show();
	shareUserList =[]; //공유리스트 초기화
	//userGridList = JSON.parse('${shareUserList}');
	_myData_Status['base']['currentProgrm'] = '${currentProgrm}';
	
	$('#geocode-mini').draggable({containment:"#NormalLayout"}); //주소변환 팝업 드래그
	initModal('geocode-mini');	//common/modal.js에서 선언
	
	gfn_transaction("/data/geocode/sel.do", "POST", {progrmNo:_myData_Status['base']['currentProgrm'],curPage:1, firstIndex:1,lastIndex:10}, "select"); 
	geocode_grid = create_grid();
	
	var columns = '[{"label":"결과","key":"result","treeControl":false,"align":"center","width":50},{"label":"이동","key":"move","treeControl":false,"align":"center"},{"label":"명칭","key":"명칭","treeControl":false,"align":"center", "editor": {"type": "text"}},{"label":"주소","key":"주소","treeControl":false,"align":"center", "editor": {"type": "text"}},{"label":"newX","key":"newX","treeControl":false,"align":"center", "editor": {"type": "text"}},{"label":"newY","key":"newY","treeControl":false,"align":"center", "editor": {"type": "text"}},{"label":"newAddr","key":"newAddr","treeControl":false,"align":"center"}]';
	
	var gridData ='[{"명칭":"경희샘한의원","주소":"서울특별시 마포구 성산동 200-51","newX":126.90796883757847,"newY":37.56788973695638,"newAddr":"","__original_index":0,"__index":0,"__modified__":true,"result":true},{"명칭":"뚜레쥬르","주소":"서울특별시 마포구 성산2동 999","newX":"","newY":"","newAddr":"","__original_index":1,"__index":1,"result":false},{"명칭":"중원약국","주소":"서울특별시 마포구 성산동 200-1","newX":126.90790690815297,"newY":37.56839404268157,"newAddr":"","__original_index":2,"__index":2,"__modified__":true,"result":true},{"명칭":"명성화로","주소":"서울특별시 마포구 성산2동 200-38","newX":126.90927425930029,"newY":37.567347064225814,"newAddr":"","__original_index":3,"__index":3,"__modified__":true,"result":true},{"명칭":"올리브영","주소":"서울특별시 마포구 동교동 163-9","newX":126.92268990618908,"newY":37.55501117914051,"newAddr":"","__original_index":4,"__index":4,"__modified__":true,"result":true},{"명칭":"상암동주민센터","주소":"서울특별시 마포구 상암동 1616","newX":126.89467724894307,"newY":37.57826830240965,"newAddr":"","__original_index":5,"__index":5,"__modified__":true,"result":true},{"명칭":"엑시빗코리아","주소":"서울특별시 마포구 합정동 426-12","newX":126.91164849902388,"newY":37.55188315977984,"newAddr":"","__original_index":6,"__index":6,"__modified__":true,"result":true},{"명칭":"새마을식당","주소":"서울특별시 마포구 망원동 376-6","newX":126.90918016332395,"newY":37.55590404399487,"newAddr":"","__original_index":7,"__index":7,"__modified__":true,"result":true},{"명칭":"명가한의원","주소":"서울특별시 마포구 망원동 412-52","newX":126.9065713048956,"newY":37.55533323144586,"newAddr":"","__original_index":8,"__index":8,"__modified__":true,"result":true},{"명칭":"효성약국","주소":"서울특별시 마포구 성산동 624-19","newX":126.9175881879525,"newY":37.561276547652284,"newAddr":"","__original_index":9,"__index":9,"__modified__":true,"result":true},{"명칭":"서강고기촌","주소":"서울특별시 마포구 노고산동 31-84","newX":126.9375819592376,"newY":37.55404832185486,"newAddr":"","__original_index":10,"__index":10,"__modified__":true,"result":true}]';
	
	//geocode_grid.setData(JSON.parse(gridData)); //그리드 값 세팅
	fn_geo_epsg_list_reload(); //임시
	
	Coloris({        
		parent: '.demo',       
		theme: 'default',     //default, large, polaroid, pill        
		themeMode: 'light',   //light , dark 모드       
		margin: 2,            //입력 필드와 색선택시 사이 여백        
		alpha: true,          //불투명도 조절        
		format: 'hex',        //포맷  hex rgb hsl auto mixed       
		formatToggle: false,   //포맷 토글        
		clearButton: true,        
		clearLabel: 'Clear',   
		swatches: [          
			'#264653',         
			'#2a9d8f',          
			'#e9c46a',          
			'rgb(244,162,97)',          
			'#e76f51',          
			'#d62828',          
			'navy',          
			'#07b',          
			'#0096c7',          
			'#00b4d880',         
			'rgba(0,119,182,0.8)'       
			],        
		inline: false,        
		defaultColor: '#000000',      
	});
	
});


function fn_updateRow(){
	
	geocode_grid.updateColumn({
        key: "name", label: "name" , editor: {type: "text"}}, 0);
}
</script>
<title>마이데이터 - 주소변환</title>
<body>
<div role="tabpanel" class="areaSearch full" id="tab-01" style="overflow:auto;">
	<h2 class="tit" id="submenuTitle">주소변환</h2>
	
	<div class="fn-wrap text-right">
		<button class="btn btn-darkgray btn-sm" onclick="fn_modal_onOff('geocode-mini');">주소변환하기</button>
	</div>
	
	<form id="shpDownloadForm" method="post">
		    <input type="hidden" name="groupNo" id="groupNo">
	</form>
	<p class="infoTxt">사용자가 임의로 주소변환 데이터를 등록하고 사용할 수 있으며, 다른 사람과 공유할 수 있습니다.</p>
	<div class="stepBox">
		<p class="on"> 나의 데이터 주소변환 저장 목록</p>
		<ul id="geocodeDataLoadList" class="mydataList">
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
             <!-- <li class="disabled">
                 <a href="#"><i class="fa fa-angle-left" aria-hidden="true"></i></a>
             </li>
             <li class="active">
                 <a href="#">1</a>
             </li>
             <li class="disabled">
                 <a href="#"><i class="fa fa-angle-right" aria-hidden="true"></i></a>
             </li> -->
         </ul>
	</div>
</div>

<div id="colorPicker" class="mapStyle" style="display:none;">
	<h3 class="tit">스타일 편집</h3>
	<div class="square" style="padding-top: 10px;">
		<div id="PolygonStyleBox" style="display:none;padding-bottom: 7px;">
			<label>면색</label>
			<div class="clr-field">
				<button type="button"></button>
				<input type="text" id="polyFill" data-coloris title="면색">
			</div>
			
			<div style="padding-top: 9px;">
				<label>선색</label>
				<div class="clr-field">
					<button type="button"></button>
					<input type="text" id="polyStroke" data-coloris title="선색">
				</div>
			</div>
		</div>
		<div id="MultiPolygonStyleBox" style="display:none;padding-bottom: 7px;">
			<label>면색</label>
			<div class="clr-field">
				<button type="button"></button>
				<input type="text" id="mployFill" data-coloris title="면색">
			</div>
			
			<div style="padding-top: 9px;">
				<label>선색</label>
				<div class="clr-field">
					<button type="button"></button>
					<input type="text" id="mployStroke" data-coloris title="선색">
				</div>
			</div>
		</div>
		
		<div id="LineStringStyleBox" style="display:none;padding-bottom: 7px;">
			<label>선색</label>
			<div class="clr-field">
				<button type="button"></button>
				<input type="text" id="lineStroke" data-coloris title="선색">
			</div>
			
			<div style="padding-top: 9px;">
				<label>굵기</label>
				<input type="number" id="lineStrokeSize" value="3" title="굵기">
			</div>
		</div>
		
		<div id="PointStyleBox" style="display:none;padding-bottom: 7px;">
			<label>심볼</label>
			<div class="clr-field">
				<select id="featuresymbol" onchange="changeSymbol('geocode');" title="심볼">
					<option value="x">x</option>
					<option value="cross">cross</option>
					<option value="star">star</option>
					<option value="triangle">triangle</option>
					<option value="square" selected="selected">square</option>		  
				</select>
			</div>
			
			<div style="padding-top: 9px;">
				<label>색상</label>
				<div class="clr-field" style="color: rgb(224, 29, 29);">
					<button type="button" onchange="changeSymbol('geocode');"></button>
					<input type="text" id="pointFill" value="#e01d1d" data-coloris onchange="changeSymbol('geocode');" title="색상">
				</div>
			</div>
			
			<div style="padding-top: 9px;">
				<label>굵기</label>
				<input type="number" id="pointStrokeSize" value="5" onchange="changeSymbol('geocode');" title="굵기">
			</div>
		</div>
		</div>
</div>


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
        <button type="button" style="margin:0;padding: 2rem 2.4rem;width: auto;" class="primaryBG" id="row_shape_to_save" onClick="fn_geocode_to_save('row');">공유하기</button>
    </div>            
</div>

<!--GeoCode Popup-Panel -->
<div class="mapPopup" id="geocode-mini" style="display: none; z-index:2">
	<!---Title -->
	<div class="head" id='convert_title'>
	    <h2>주소변환</h2>
	    <div class="disFlex">
	        <img class="closeBtn" id="geocode-mini-min" onClick="fn_modal_min('geocode-mini');" src="${pageContext.request.contextPath}/resources/img/map/btnPopHeadMin.svg" alt="숨기기">
	        <img class="closeBtn" id="geocode-mini-max" onClick="fn_modal_max('geocode-mini');" src="${pageContext.request.contextPath}/resources/img/map/btnPopHeadMax.svg" alt="크게 보기">
	        <img class="closeBtn" id="geocode-mini-close" onClick="fn_modal_onOff('geocode-mini'); $('#colorPicker').hide();Redraw();" src="${pageContext.request.contextPath}/resources/img/map/icClose24.svg" alt="닫기">
	    </div>
	</div>
	<!-- End-Title -->
		
    <div class="disFlex shareRow" id="modal_content">
        <div class="cont">
            <h3 class="tit">조건선택</h3>

            <div class="inputWrap">
                <form class="fileInput">
                    <label  style="float: left;">· 변환파일(50MB)</label>
                    <input type="file" title="파일" id='geocoding_load_file_nm' name="geocoding_load_file_nm" onchange="addGeocodingFiles(this);" data-maxsize="51200" data-maxfile="51200" accept=".csv, .xlsx, .txt, .xls" multiple  style="width: 53.5rem;">
                </form>
            </div>
			
			
			<div class="blockLine">
	            <div class="disFlex">
	                <label for="geocoding_convert_type">· 변환유형</label>
	                <select name="geocoding_convert_type" id="geocoding_convert_type" title="변환유형" onChange="fn_convertType();"> 
	                    <option value="CONVER_TYPE_A">주소->좌표</option>
						<option value="CONVER_TYPE_B">좌표->주소</option>
	                </select>
	            </div>
	             <!-- <div class="disFlex">
	               <label for="geocoding_convert_addr">· 주소유형</label>
	                <select name="geocoding_convert_addr" id="geocoding_convert_addr" title="주소유형">
	                    <option value="">선택</option>
						<option value="road">새주소</option>
						<option value="parcel">구주소</option>
	                </select>
	            </div> -->
	            <div class="disFlex">
                     <label title='클릭하시면 간락한 좌표계 정보를 확인 할 수 있습니다.'>· 좌표계</label>
                     <select name="geocoding_convert_epsg" id="geocoding_convert_epsg"  title="좌표계">
                         <option value="">선택</option>
                     </select>
                 </div>
	        </div>
                    
            <div class="blockLine">
                <div class="disFlex">
                    <label for="geocoding_convert_column1">· 주소필드 <br> <span class="depth">(경도)</span></label>
                    <select name="geocoding_convert_column1" id="geocoding_convert_column1" title="주소필드">
                        <option value="">선택</option>
                    </select>
                </div>
                <div class="disFlex">
                    <label for="geocoding_convert_column2">· 주소필드 <br> <span class="depth">(위도)</span></label>
                    <select name="geocoding_convert_column2" id="geocoding_convert_column2" title="주소필드" disabled>
                        <option value="">선택</option>
                    </select>
                </div>
            </div>       
            <div class="blockLine">
                 <!-- <div class="disFlex">
                     <label for="geocoding_epsg_desc" title='클릭하시면 간락한 좌표계 정보를 확인 할 수 있습니다.'>· 좌표계</label>
                     <select name="geocoding_convert_epsg" id="geocoding_convert_epsg"  title="좌표계">
                         <option value="">선택</option>
                     </select>
                 </div> -->
                 <button type="button" class="primaryBG" onClick="fn_geocode_start();">주소변환</button>
             </div>
 
        

            <div class="resultWrap" id="myMapResult" style="display:none;">
                <div class="tit disFlex">
                    <h3 class="tit">주소변환 결과</h3>
                    <button type="button" onClick="visibleToggle('shareDiv');fn_initGrid();$('#geocode-mini').css('width','auto')">
                        <img src="${pageContext.request.contextPath}/resources/img/map/btnShare24.svg" alt="공유 대상 선택">
                    </button>
                </div>

                
                <div class="resultTit disFlex" style="margin-top: 12px;">
                    <label for="geocode_save_file_nm">· 제목</label>
                    <input type="text" id="geocode_save_file_nm" name="geocode_save_file_nm"  title="제목" placeholder="제목을 입력하세요.">
                </div>


                <div class="tableTop disFlex">
                    <h3 class="tit">결과목록</h3><h4 class="dataNum">(총 <span class="text-orange" id='geocodingListCount'>178,934</span>건)</h4>
                	<div class="disFlex">
                        <button type="button" class="primaryLine" onClick ="gfn_rowAdd(geocode_grid)">행 추가</button>
                        <button type="button" class="gray100Line" onClick ="fn_rowRemove()">행 삭제</button>
                    </div>
                </div>
                
                <div class="myMapResult">
                	<div id="geocode_result_grid" data-ax5grid="result-grid" data-ax5grid-config='{}'  style="height: 300px;width:100%;"></div>
	                 <%-- 퍼블<table class="TablethGray" id='geocodingContents'>
	                     <caption>결과 목록</caption>
	                     <thead id='geocodingContentsHead'>
	                     </thead>
	                     <tbody id='geocodingContentsBody'>
	                         <tr>
	                             <td class="center">
	                                 <form class="listBtn">
	                                     <label>
	                                         <input role="listBtn" type="checkbox" id="listBtn" />
	                                     </label>
	                                 </form>
	                             </td>
	                             <td>-</td>
	                             <td>-</td>
	                         </tr>
	                     </tbody>
	                 </table> --%>
                </div>
                <%-- <h3 class="tit mgTB">컬럼 매칭 목록</h3>
                <table class="TablethGray">
                    <caption>컬럼 매칭 목록</caption>
                    <colgroup>
                        <col width="10%">
                        <col width="45%">
                        <col width="45%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">순서</th>
                            <th scope="col">한글명</th>
                            <th scope="col">영문명</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="center">1</td>
                            <td>주소</td>
                            <td>-</td>
                        </tr>
                    </tbody>
                </table> --%>
            </div>
        </div>
        <!-- ///cont -->

        <div class="depth2Panner" style="display: none;" id="shareDiv">
            <div class="HideBtn">
                <img src="${pageContext.request.contextPath}/resources/img/map/btnSelectArrow.svg" alt="접기">
                <!-- <img class="open" src="../resources/img/map/btnSelectArrow.svg" alt="열기" /> -->
            </div>
            <div class="depthWrap">
                <h2 class="tit">공유 대상</h2>
                <!-- <h3 class="tit">공유 대상 선택</h3> -->

                <div id="shp_to_share" data-ax5grid="first-grid" data-ax5grid-config='{}'  style="height: 500px;width:100%;overflow:scroll;"></div> 
            </div>
        </div>
    </div>
    <!-- ///disFlex -->
           
	<div class="foot" id="modal_foot">
	    <button type="button" class="gray100Line" id="geocode_reset" onClick="fn_reset();">초기화</button>
	    <button type="button" class="primaryBG" id="geocode_to_save" style="display:none; padding: 2rem 2.4rem;width: auto;margin-top: 0;" onClick="fn_geocode_to_save('init');">저장 및 공유</button>
	</div>
</div>
<!-- End  GeoCode Popup-Panel -->

<div class="popupScreen" id= "directDiv">
	<div class= "miniPopup">
		<h2 class="tit" style="margin-left: 21px;margin-top: 12px;margin-bottom: 5px;">좌표 직접등록</h2>
		<div class="card-box box2" id="geocodeMap_mini" style="height: 429px;padding-bottom: 40px;margin-bottom: 0;"></div>
		<button type="button" class="gray100Line" onclick="$('#directDiv').css('display','none')" style="margin-top: 9px;float: right;margin-right: 34px;">닫기</button>
		<button type="button" class="primaryLine" id="geocodeDirect" onclick="fn_geocodeDirect(this);" style="margin-top: 9px;float: right;margin-right: 15px;">확인</button>
	</div>
</div>

</body>
