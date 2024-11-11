<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />
<script>
$(document).ready(function() {
	$('#sub_content').show();
	
	// 2023 변경 - 자산 검색 조건_기타 추가
	$('#tab-06_Form [name="search_type"]').change(function() {
		//console.log($(this).val())

		var url = '';
		var url2 = '';
		if('ASSET_APT' == $(this).val()) {
			url = '${contextPath}<%=RequestMappingConstants.WEB_GIS_DATA_ASSET_APT_COND%>';
			url2 = '${contextPath}<%=RequestMappingConstants.WEB_GIS_DATA_ASSET_APT_PRD%>';
		} else if('ASSET_MLTDWL' == $(this).val()) {
			url = '${contextPath}<%=RequestMappingConstants.WEB_GIS_DATA_ASSET_MLT_COND%>';
			url2 = '<%=RequestMappingConstants.WEB_GIS_DATA_ASSET_MLT_PRD%>';
		}else if('ASSET_ETC' == $(this).val()) {
			url = '${contextPath}<%=RequestMappingConstants.WEB_GIS_DATA_ASSET_ETC_COND%>';
			url2 = '${contextPath}<%=RequestMappingConstants.WEB_GIS_DATA_ASSET_ETC_PRD%>';
		}

		$.ajax({
			type : "POST",
			async : false,
			url : url,
			dataType : "json",
			data : {},
			error : function(response, status, xhr){
				if(xhr.status =='403'){
					alert('조회 조건 항목 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
				}
			},
			success : function(data) {
				if(data.result == 'Y') {
					//console.log(data);

					$('#tab-06_Form #assets_nm').val('');

					$('#tab-06_Form #assets_cl').empty();
					$('#tab-06_Form #assets_cl').append('<option value="" selected="selected">전체선택</option>');
					for (i=0; i<data.assetsClassInfo.length; i++) {
						$('#tab-06_Form #assets_cl').append('<option value="' + data.assetsClassInfo[i].lclas_code + '">' + data.assetsClassInfo[i].lclas + '</option>');
					}

					$('#tab-06_Form #assets_cl').off('change');
					$('#tab-06_Form #assets_cl').on('change', function() {
						$.ajax({
							type : "POST",
							async : false,
							url : url2,
							dataType : "json",
							data : {
								assets_cl: $(this).val()
							},
							error : function(response, status, xhr){
								if(xhr.status =='403'){
									alert('조회 조건 항목 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
								}
							},
							success : function(data) {
								if(data.result == 'Y') {
									$('#tab-06_Form #prdlst_cl').empty();
									$('#tab-06_Form #prdlst_cl').append('<option value="" selected="selected">전체선택</option>');
									for (i=0; i<data.prdlstClassInfo.length; i++) {
										$('#tab-06_Form #prdlst_cl').append('<option value="' + data.prdlstClassInfo[i].mlsfc_code + '">' + data.prdlstClassInfo[i].mlsfc + '</option>');
									}
								}
							}
						});
					});

					$('#tab-06_Form #prdlst_cl').empty();
					$('#tab-06_Form #prdlst_cl').append('<option value="" selected="selected">전체선택</option>');
					for (i=0; i<data.prdlstClassInfo.length; i++) {
						$('#tab-06_Form #prdlst_cl').append('<option value="' + data.prdlstClassInfo[i].mlsfc_code + '">' + data.prdlstClassInfo[i].mlsfc + '</option>');
					}

					$('#tab-06_Form #bsns_code').empty();
					$('#tab-06_Form #bsns_code').append('<option value="" selected="selected">전체선택</option>');
					for (i=0; i<data.bsnsCodeInfo.length; i++) {
						$('#tab-06_Form #bsns_code').append('<option value="' + data.bsnsCodeInfo[i].bsns_code + '">' + data.bsnsCodeInfo[i].bsns_code + '</option>');
					}

					//자산대장 ->기타일때 규격 없애기
					if('ASSET_ETC' == $("#tab-06_Form #search_type").val()){
						$('#tab-06_Form #stndrd').closest('.col-xs-6').hide();
					}else{
						$('#tab-06_Form #stndrd').closest('.col-xs-6').show();
						$('#tab-06_Form #stndrd').empty();
						$('#tab-06_Form #stndrd').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.stndrdInfo.length; i++) {
							$('#tab-06_Form #stndrd').append('<option value="' + data.stndrdInfo[i].stndrd + '">' + data.stndrdInfo[i].stndrd + '</option>');
						}
					}

					$('#tab-06_Form #assets_change').empty();
					$('#tab-06_Form #assets_change').append('<option value="" selected="selected">전체선택</option>');
					for (i=0; i<data.assetsChangeInfo.length; i++) {
						$('#tab-06_Form #assets_change').append('<option value="' + data.assetsChangeInfo[i].assets_change + '">' + data.assetsChangeInfo[i].assets_change + '</option>');
					}

					$('#tab-06_Form #change_dcsn').empty();
					$('#tab-06_Form #change_dcsn').append('<option value="" selected="selected">전체선택</option>');
					for (i=0; i<data.changeDcsnInfo.length; i++) {
						$('#tab-06_Form #change_dcsn').append('<option value="' + data.changeDcsnInfo[i].year + '">' + data.changeDcsnInfo[i].year + '</option>');
					}

					$('#tab-06_Form #acqs_de').empty();
					$('#tab-06_Form #acqs_de').append('<option value="" selected="selected">전체선택</option>');
					for (i=0; i<data.acqsDeInfo.length; i++) {
						$('#tab-06_Form #acqs_de').append('<option value="' + data.acqsDeInfo[i].year + '">' + data.acqsDeInfo[i].year + '</option>');
					}
				} else {
					alert('검색 결과가 없습니다.')
				}
			}
		});
	});
	$('#tab-06_Form [name="search_type"]').val('ASSET_APT').trigger('change');
});
</script>
<body>
<!-- Tab-06 자산대장-->
<div role="tabpanel" class="areaSearch full" id="tab-06" style="overflow:auto;">
	<h2 class="tit">자산대장</h2>
	<form id="tab-06_Form" name="tab-06_Form" onsubmit="return false;">
		<h3 class="tit">검색항목</h3>
		<div class="selectWrap">
	    	<div class="disFlex">
	            <select id="search_type" name="search_type" title="검색항목">
	                <option value="ASSET_APT">자산대장 아파트</option>
					<option value="ASSET_MLTDWL">자산대장 다가구</option>
					<option value="ASSET_ETC">자산대장 기타</option>
	            </select>
			</div>    
		</div>
		<h3 class="tit">자산명</h3>
        <div>
			<input type="text" name="assets_nm" id="assets_nm"
				placeholder="자산명을 입력해주세요." class="ui-autocomplete-input input_textarea half_input_textarea"
				autocomplete="off" title="자산명" onkeypress="if(event.keyCode==13) {gis_sherch(1);fn_gis_sherch_new(1);}">
		</div>
		<h3 class="tit">자산분류</h3>
		<div class="selectWrap">
	        <div class="disFlex">
	            <select name="assets_cl" id="assets_cl" title="자산분류">
	                <option value="0000" selected="selected">전체선택</option>
	            </select>
			</div>    
		</div>
		<h3 class="tit">품목분류</h3>
		<div class="selectWrap">
	        <div class="disFlex">
	            <select name="prdlst_cl" id="prdlst_cl" title="품목분류">
	                <option value="0000" selected="selected">전체선택</option>
	            </select>
			</div>    
		</div>
		<h3 class="tit">사업코드</h3>
		<div class="selectWrap">
	        <div class="disFlex">
	            <select name="bsns_code" id="bsns_code" title="사업코드">
	                <option value="0000" selected="selected">전체선택</option>
	            </select>
			</div>    
		</div>
		<h3 class="tit">규격</h3>
		<div class="selectWrap">
	        <div class="disFlex">
	            <select name="stndrd" id="stndrd" title="규격">
	                <option value="0000" selected="selected">전체선택</option>
	            </select>
			</div>    
		</div>
		<h3 class="tit">자산변동구분</h3>
		<div class="selectWrap">
	        <div class="disFlex">
	            <select name="assets_change" id="assets_change" title="자산변동구분">
	                <option value="0000" selected="selected">전체선택</option>
	            </select>
			</div>    
		</div>
		<h3 class="tit">변동확정일자(년도)</h3>
		<div class="selectWrap">
	        <div class="disFlex">
	            <select name="change_dcsn" id="change_dcsn" title="변동확정일자(년도)">
	                <option value="0000" selected="selected">전체선택</option>
	            </select>
			</div>    
		</div>
		<h3 class="tit">취득일자(년도)</h3>
		<div class="selectWrap">
	        <div class="disFlex">
	            <select name="acqs_de" id="acqs_de" title="취득일자(년도)">
	                <option value="0000" selected="selected">전체선택</option>
	            </select>
			</div>    
		</div>
	</form>
</div>
<!-- End Tab-06 -->
	<!-- 검색조건 Form -->
	<form id="GISinfoForm" name="GISinfoForm"></form>
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
        <button type="button" class="primarySearch" onclick="gis_sherch(1);fn_gis_sherch_new(1);">검색</button>
    </div>

	<!-- 검색결과 Form -->
	<form id="GISinfoResultForm" name="GISinfoResultForm">
		<input type="hidden" name="geom[]">
	</form>
</body>