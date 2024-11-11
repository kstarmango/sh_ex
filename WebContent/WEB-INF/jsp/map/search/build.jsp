<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>
<script>
var firstGrid = '';

function fn_getSubCode(_this){
	
	console.log("subcoed!!",$(_this).val())
	gfn_transaction("/cmmn/code.do", "POST", {code:"PRPOSC",sCode:$(_this).val()}, "buildSel"); //url, type, param, actionType
}

function fn_callback(actionType, data){
	console.log("속성검색 콜백",data);
	switch (actionType){
	case "buildSel":
		if(data.result == 'Y') {
			$('#tab-02 #fs_subPrpos').empty();
			//$('#tab-02_Form #fs_subPrpos').append('<option value="" selected="selected">전체선택</option>');
			for (i=0; i<data.codeInfo.length; i++) {
				$('#tab-02 #fs_subPrpos').append('<option value="' + data.codeInfo[i].scode + '">' + data.codeInfo[i].slabel + '</option>');
			}
		}
		$('#fs_subPrpos').trigger("chosen:updated");
	}
}

$(document.body).ready(function () {
	$('#sub_content').show();
	
	$('.hasDatepicker').datepicker({
		dateFormat: 'yy-mm-dd'
	});
	initSlider("parea"); //건뮬 대지면적 슬라이드 초기화
	initSlider("barea"); //건뮬 건축면적 슬라이드 초기화
	initSlider("far");   //용적률 슬라이드 초기화
	initSlider("bcr");   //건폐율 슬라이드 초기화
	
	$("select[id$='_sido']").trigger('change');
	$("select[id$='_sig']").trigger('change');
});
</script>
<title>건축물 검색</title>
<body>
<!-- Tab-02 건축물 검색 -->
<div role="tabpanel" class="areaSearch full" id="tab-02" style="overflow:auto;">
	<h2 class="tit">건축물검색</h2>
	<form id="GISinfoForm" name="GISinfoForm"  onsubmit="return false;" >

		<h3 class="tit">행정구역</h3>
		<div class="selectWrap">
      <div class="disFlex">
      	<label for="fs_sido">· 시도</label>
        <select class="form-control chosen" id="fs_sido" name="sido_cd" title="시도">
       		<c:forEach var="result" items="${SIDOList}" varStatus="sido_cd">
						<option value='<c:out value="${result.sido_cd}"/>'><c:out value="${result.sido_kor_nm}"/></option>
					</c:forEach>
				</select>
			</div>  
			<div class="disFlex">
	        	<label for="fs_sig">· 시군구</label>
	        	<select class="form-control chosen" id="fs_sig" name="sig" title="시군구">
                	 <option value="0000" selected="selected">전체선택</option>
                    <c:forEach var="result" items="${SIGList}" varStatus="status">
						<option value='<c:out value="${result.sig_cd}"/>'><c:out value="${result.sig_kor_nm}"/></option>
					</c:forEach>
				</select>
			</div>  
			<div class="disFlex">
	        	<label for="fs_emd">· 읍면동</label>
	        	<select class="form-control chosen" id="fs_emd" name="emd" title="읍면동">
                    <option value="0000" selected="selected">전체선택</option>
                </select>
			</div>    
		</div>
		
		<h3 class="tit">집합건물 구분</h3>
		<div class="selectWrap">
      <div class="disFlex">
      	<select class="form-control chosen" id="fs_setBuldSe" name="fs_setBuldSe" title="집합건물 구분">
        	<c:forEach var="result" items="${setBuldSeList}" varStatus="status">
						<option value='<c:out value="${result.pcode}"/>'>
						<c:out value="${result.plabel}"/></option>
					</c:forEach>
				</select>
			</div>    
		</div>
		<h3 class="tit">주용도명</h3>
		<div class="selectWrap">
	        <div class="disFlex">
            	<select class="form-control chosen" id="fs_mainPrpos"  name="fs_mainPrpos" onChange="fn_getSubCode(this)" title="주용도명">
                	<c:forEach var="result" items="${mainPrposList}" varStatus="status">
						<option value='<c:out value="${result.pcode}"/>'><c:out value="${result.plabel}"/></option>
					</c:forEach>
				</select>
			</div>    
		</div>
		<h3 class="tit">세부용도명</h3>
		<div class="selectWrap">
	        <div class="disFlex"> 
            	<select class="form-control chosen" multiple name="fs_subPrpos"  id="fs_subPrpos" title="세부용도명">
					 	<c:forEach var="result" items="${subPrposList}" varStatus="status">
					 	<c:if test="${result.scode != '' }">
							<option value='<c:out value="${result.scode}"/>'><c:out value="${result.slabel}"/></option>
					 	</c:if>
					</c:forEach>
				</select>
			</div>    
		</div>
		<h3 class="tit">사용승인일</h3>
		<div>
			<div class="input-group date datetimepickerStart ">
				<input class="form-control input-group-addon m-b-0 hasDatepicker" title="사용승인일" name="compet_de" id="compet_de" placeholder="사용승인일을 선택하세요" style="padding: 0; height: 30px;"> 
				<span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
			</div>
		</div>	
		<h3 class="tit">건물 대지면적</h3>
		<div id="fs_parea">
       		<p class="range-label"><b>범위(㎡) :</b><span id="amount_parea"></span></p>
			<div id="slider_parea" class="slider-margin"></div>
			<div class="disFlex">
				<input type="text" id="num_parea_1" name="num_parea_1" size="10" title="최소 건물 대지면적" class="form-control input-ib" onKeyup="slider_range('parea')"> ~ <input type="text" id="num_parea_2" name="num_parea_2" size="10" title="최대 건물 대지면적" class="form-control input-ib" onKeyup="slider_range('parea')">
			</div>
       	</div> 
		<h3 class="tit">건물 건축면적</h3>
		<div id="fs_barea">
         	<p class="range-label"><b>범위(㎡) :</b><span id="amount_barea"></span></p>
			<div id="slider_barea" class="slider-margin"></div>
			<div class="disFlex">
				<input type="text" id="num_barea_1" name="num_barea_1" size="10" title="최소 건물 건축면적" class="form-control input-ib" onKeyup="slider_range('barea')"> ~ <input type="text" id="num_barea_2" name="num_barea_2" size="10" title="최대 건물 건축면적" class="form-control input-ib" onKeyup="slider_range('barea')">
       		</div>
   	</div>
   	<h3 class="tit">용적률</h3>
		<div id="fs_far">
         	<p class="range-label"><b>범위(%) :</b><span id="amount_far"></span></p>
			<div id="slider_far" class="slider-margin"></div>
			<div class="disFlex">
				<input type="text" id="num_far_1" name="num_far_1" size="10" title="최소 용적률" class="form-control input-ib" onKeyup="slider_range('far')"> ~ <input type="text" id="num_far_2" name="num_far_2" size="10" title="최대 용적률" class="form-control input-ib" onKeyup="slider_range('far')">
       		</div>
       	</div> 
		<h3 class="tit">건폐율</h3>
		<div id="fs_bcr">
         	<p class="range-label"><b>범위(%) :</b><span id="amount_bcr"></span></p>
			<div id="slider_bcr" class="slider-margin"></div>
			<div class="disFlex">
				<input type="text" id="num_bcr_1" name="num_bcr_1" size="10" title="최소 건폐율" class="form-control input-ib" onKeyup="slider_range('bcr')"> ~ <input type="text" id="num_bcr_2" name="num_bcr_2" size="10" title="최소 건폐율" class="form-control input-ib" onKeyup="slider_range('bcr')">
       		</div>
       	</div> 
	</form>
</div>
<!-- End Tab-02 -->

<!-- 검색조건 Form -->
<!-- <form id="GISinfoForm" name="GISinfoForm" ></form> -->
<div class="breakLine"></div>
<div class="disFlex smBtnWrap" style = "padding: 1.6rem;">  
	<div class="selectWrap">
        <div class="disFlex">
            <select id="cnt_kind" title="보기">
				<option value="10">10개씩 보기</option>
				<option value="15">15개씩 보기</option>
				<option value="20">20개씩 보기</option>
				<option value="30">30개씩 보기</option>
				<option value="40">40개씩 보기</option>
				<option value="50">50개씩 보기</option>
			</select>   
        </div>
    </div>
   	<button type="button" class="primaryLine" onclick="gis_clear();fn_gis_clear_new()">초기화</button>
    <button type="button" class="primarySearch" onclick="gis_sherch('build');">검색</button>
</div>

<!-- 검색결과 Form -->
<form id="GISinfoResultForm" name="GISinfoResultForm">
	<input type="hidden" name="geom[]">
</form>
</body>