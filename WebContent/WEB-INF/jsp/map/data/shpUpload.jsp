<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />
<%-- <script type="text/javascript" src="<c:url value='/resources/js/util/ax5ui/ax5core.js'/>" /></script> 
<link rel="stylesheet" href="<c:url value='/resources/css/util/ax5ui/grid/ax5grid.css'/>" />
<script type="text/javascript" src="<c:url value='/resources/js/util/ax5ui/grid/ax5grid.js'/>"></script> 
<script type="text/javascript" src="<c:url value='/resources/js/common/grid.js'/>"></script> --%><!-- 그리드 공통사용 js -->

<!-- <script type="text/javascript" src="/resources/js/common/modal.js"></script> --> 		<!-- 마이데이터 모달 공통사용 js -->
<script src="/resources/js/map/task/myData.js"></script> 	<!-- 마이데이터 업무 js -->
<link rel="stylesheet" href="<c:url value='/resources/css/task/myData.css'/>" >
<script>
var modal;
var userGridList; 			//grid 공유자 목록 표출
var shareUserList = [];		//공유될 사용자 목록

$(document).ready(function() {
	$('#sub_content').show();
	shareUserList =[]; //공유리스트 초기화
	userGridList = JSON.parse('${shareUserList}');
	_myData_Status['base']['currentProgrm'] = '${currentProgrm}';
	//shareUserList = '${shareUserList}'
	//그리드 초기화
	$('#shape-mini').draggable({containment:"#NormalLayout"}).css('width','auto'); //shp업로드 팝업 드래그
	
	initModal('shape-mini'); 	//common/modal.js에서 선언

				//task/myData.js에서 선언
	fn_shp_epsg_list_reload(); 	//map/task/myData.js에서 선언
	
	gfn_transaction("/data/shp/sel.do", "POST", {progrmNo:_myData_Status['base']['currentProgrm'],curPage:1, firstIndex:1,lastIndex:10}, "select"); 
	
	Coloris({        
		parent: '.demo',       
		theme: 'default',     //default, large, polaroid, pill        
		themeMode: 'light',   //light , dark 모드       
		margin: 2,            //입력 필드와 색선택시 사이 여백        
		alpha: true,          //불투명도 조절        
		format: 'hex',        //포맷  hex rgb hsl auto mixed       
		formatToggle: false,   //포맷 토글        
		clearButton: false,        
		//clearLabel: 'Clear',   
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
		defaultColor: '#e01d1d',      
	});
});

</script>
<title>마이데이터 - shp업로드</title>
<body>
<div role="tabpanel" class="areaSearch full" id="tab-02" style="overflow:auto;">
	<h2 class="tit" id="submenuTitle">SHP업로드</h2>
	<div class="fn-wrap text-right">
		<button class="btn btn-darkgray btn-sm" onclick="fn_modal_onOff('shape-mini');">SHP업로드하기</button>
	</div>
	
	<form id="shpDownloadForm" method="post">
		    <input type="hidden" name="groupNo" id="groupNo">
	</form>
	<p class="infoTxt">사용자가 임의로 SHP파일을 등록하고 사용할 수 있으며, 다른 사람과 공유할 수 있습니다.</p>
	<div class="stepBox">
		<p class="on"> 나의 데이터 SHP업로드 저장 목록</p>
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

<div id="colorPicker" class="mapStyle" style="display:none;">
	<h3 class="tit">스타일 편집</h3>
	<div class="square" style="padding-top: 10px;">
		<div id="PolygonStyleBox" style="display:none;padding-bottom: 7px;">
			<label>면색</label>
			<div class="clr-field" style="color: rgba(255, 171, 171, 0.298);">
				<button type="button"  onchange="changeSymbol('shpUpload');"></button>
				<input type="text" id="polyFill" value="#ffabab4b" data-coloris onchange="changeSymbol('shpUpload');" title="면색">
			</div>
			
			<div style="padding-top: 9px;">
				<label>선색</label>
				<div class="clr-field" style="color: rgb(224, 29, 29);">
					<button type="button"  onchange="changeSymbol('shpUpload');"></button>
					<input type="text" id="polyStroke" value="#e01d1d" data-coloris onchange="changeSymbol('shpUpload');" title="선색">
				</div>
			</div>
		</div>
		<div id="MultiPolygonStyleBox" style="display:none; padding-bottom: 7px;">
			<label>면색</label>
			<div class="clr-field" style="color: rgba(255, 171, 171, 0.298);">
				<button type="button"  onchange="changeSymbol('shpUpload');"></button>
				<input type="text" id="mployFill" value="#ffabab4b" data-coloris onchange="changeSymbol('shpUpload');" title="면색">
			</div>
			
			<div style="padding-top: 9px;">
				<label>선색</label>
				<div class="clr-field" style="color: rgb(224, 29, 29);">
					<button type="button"  onchange="changeSymbol('shpUpload');"></button>
					<input type="text" id="mployStroke"  value="#e01d1d"  data-coloris onchange="changeSymbol('shpUpload');" title="선색">
				</div>
			</div>
		</div>
		
		<div id="LineStringStyleBox" style="display:none; padding-bottom: 7px;">
			<label>선색</label>
			<div class="clr-field" style="color: rgb(224, 29, 29);">
				<button type="button"  onchange="changeSymbol('shpUpload');"></button>
				<input type="text" id="lineStroke" value="#e01d1d" data-coloris onchange="changeSymbol('shpUpload');" title="선색">
			</div>
			
			<div style="padding-top: 9px;">
				<label>굵기</label>
				<input type="number" id="lineStrokeSize" value="3" onchange="changeSymbol('shpUpload');" title="굵기">			
			</div>
		</div>
		
		<div id="PointStyleBox" style="display:none;padding-bottom: 7px;">
			<label>심볼</label>
			<div class="clr-field">
				<select id="featuresymbol" onchange="changeSymbol('shpUpload');" title="심볼">
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
					<button type="button"  onchange="changeSymbol('shpUpload');"></button>
					<input type="text" id="pointFill" value="#e01d1d" data-coloris onchange="changeSymbol('shpUpload');" title="색상">
				</div>
			</div>
			
			<div style="padding-top: 9px;">
				<label>굵기</label>
				<input type="number" id="pointStrokeSize" value="3" onchange="changeSymbol('shpUpload');" title="굵기">
			</div>
		</div>
	</div>
	
	<!-- <div>
        <button class="primaryLine" onclick="fn_setStyle('shpUpload')">적용하기</button>
    </div> -->
</div>


<div id="rowShareDiv" class="rowShare" style="display:none;">
	<div class="depthWrap">
		<div class="disFlex" style="float: right; cursor: pointer;">
			<img class="closeBtn"  onclick="$('#rowShareDiv').hide();$('.mydataItem').css('border','1px solid rgba(46, 54, 67, 0.2)');" src="/resources/img/map/icClose24.svg" alt="닫기">
        </div>
    	<h2 class="tit">공유 대상</h2>
    	
    	<div id="row_shp_to_share" data-ax5grid="share-grid" data-ax5grid-config='{}'  style="height: 500px;width:100%;margin-top: 20px;"></div>
    </div>   
    <div class="foot">
        <button type="button" class="gray100Line" id="row_shape_reset" onClick="fn_reset();">초기화</button>
        <button type="button" style="margin:0;padding: 2rem 2.4rem;width: auto;" class="primaryBG" id="row_shape_to_save" onClick="fn_shape_to_save('row');">공유하기</button>
    </div>            
</div>

	<!-- <div class="mapPopup" id="shape-mini" style="display: none; z-index:2" onmousedown="start_drag(event,this);" onmousemove="on_drag(event,this);" onmouseup="stop_drag(this);" onmouseleave ="stop_drag(this);"> -->
    <div class="mapPopup" id="shape-mini" style="display: none; z-index:2">
            <!---Title -->
            <div class="head" id='convert_title'>
                <h2>ESRI Shape 업로드</h2>
                <div class="disFlex">
                    <img class="closeBtn" id="shape-mini-min" onClick="fn_modal_min('shape-mini');" src="${pageContext.request.contextPath}/resources/img/map/btnPopHeadMin.svg" alt="숨기기">
                    <img class="closeBtn" id="shape-mini-max" onClick="fn_modal_max('shape-mini');" src="${pageContext.request.contextPath}/resources/img/map/btnPopHeadMax.svg" alt="크게 보기">
                    <img class="closeBtn" id="shape-mini-close" onClick="fn_modal_onOff('shape-mini'); $('#colorPicker').hide();Redraw();" src="${pageContext.request.contextPath}/resources/img/map/icClose24.svg" alt="닫기">
                </div>
            </div>
			<!-- End-Title -->
			
            <div class="disFlex shareRow" id="modal_content">
                <div class="cont">
                    <h3 class="tit">조건선택</h3>

                    <div class="inputWrap">
                        <form class="fileInput">
                            <label style="float: left;">· 변환파일(50MB)</label>
                            <input type="file" title="파일" id='shape_load_file_nm' name="shape_load_file_nm" onchange="addShapeFiles(this);" data-maxsize="51200" data-maxfile="51200" accept=".shp, .shx, .dbf, .prj, .zip" multiple  style="width: 53.5rem;">
                        </form>
                    </div>
                    
                   <!--  <input type="hidden" id="shape_group_no" />
								<input id='shape_load_file_nm' name="shape_load_file_nm" type="file" onchange="addShapeFiles(this);" style='display: none;' maxlength="1" data-maxsize="51200" data-maxfile="51200" accept=".shp, .shx, .dbf, .prj, .zip" multiple />
                                   <label class="col-md-1 control-label">변환파일<br>(50MB)</label> -->
								
                    <div class="blockLine">
                        <div class="disFlex">
                            <label for="s_srs">· 원본좌표</label>
                            <select id="s_srs" name="s_srs" title ="원본좌표">
                                <option value="">선택</option>
                            </select>
                        </div>
                        <div class="disFlex">
                            <label for="t_srs">· 변환좌표</label>
                            <select id="t_srs" name="t_srs" title ="변환좌표">
                                <option value="">선택</option>
                            </select>
                        </div>
                    </div>

                    <div class="blockLine">
                        <button type="button" class="primaryBG" onClick="fn_shp_to_upload();">SHP업로드하기</button>
                    </div>


                    <div class="resultWrap" id="myMapResult" style="display:none;">
                        <div class="tit disFlex">
                            <h3 class="tit">SHP업로드 결과</h3>
                            <button type="button" onClick="visibleToggle('shareDiv');fn_initGrid();$('#shape-mini').css('width','auto')">
                                <img src="${pageContext.request.contextPath}/resources/img/map/btnShare24.svg" alt="공유 대상 선택">
                            </button>
                        </div>

                        
                        <div class="resultTit disFlex" style="margin-top: 12px;">
                            <label for="shpUpload_save_file_nm">· 제목</label>
                            <input type="text" id="shpUpload_save_file_nm" name="shpUpload_save_file_nm" title="제목" placeholder="제목을 입력하세요.">
                        </div>


                        <div class="tableTop disFlex">
                            <h3 class="tit">결과목록</h3><h4 class="dataNum">(총 <span class="text-orange" id='shpaeRecordListCount'>178,934</span>건)</h4>
                        </div>
                        
                        <div class="myMapResult">
	                        <table class="TablethGray" id='shpaeRecordContents'>
	                            <caption>결과 목록</caption>
	                            <%-- <colgroup>
	                                <col width="10%">
	                                <col width="45%">
	                                <col width="45%">
	                            </colgroup> --%>
	                            <thead id='shpaeRecordContentsHead'>
	                               <tr>
	                                    <th scope="col">선택</th>
	                                    <th scope="col">순서</th>
	                                    <th scope="col">...</th>
	                                </tr> 
	                            </thead>
	                            <tbody id='shapeRecordContentsBody'>
	                                <!-- <tr>
	                                    <td class="center">
	                                        <form class="listBtn">
	                                            <label>
	                                                <input role="listBtn" type="checkbox" id="listBtn">
	                                            </label>
	                                        </form>
	                                    </td>
	                                    <td>-</td>
	                                    <td>-</td>
	                                </tr> -->
	                            </tbody>
	                        </table>
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
                    <div class="depthWrap" style="height: 580px;">
                        <h2 class="tit" style="margin-bottom: 30px;">공유 대상</h2>
                        <div id="shp_to_share" data-ax5grid="first-grid" data-ax5grid-config='{}'  style="height: 100%;width:100%;"></div> 
                    </div>
                </div>
            </div>
            <!-- ///disFlex -->

            
            <div class="foot" id="modal_foot">
                <button type="button" class="gray100Line" id="shape_reset" onClick="fn_reset();">초기화</button>
                <button type="button" class="primaryBG" id="shape_to_save" style="display:none; padding: 2rem 2.4rem;width: auto;margin-top: 0;" onClick="fn_shape_to_save('init');">저장 및 공유</button>
            </div>
    </div>
	<!-- End  Shape Upload Side-Panel -->
</body>
