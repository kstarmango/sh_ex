<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />

<script type="text/javascript">
$(document).ready(function() {
	$('#sub_content').show();
	
	// 2020 추가 - 택지 검색 조건
	$('#tab-04_Form [name="search_type"]').change(function() {
		//console.log($(this).val())

		$('#tab-04_Form [id^="item4_"]').hide();
		$('#tab-04_Form [id^="item4_"] input[type="text"]').attr('disabled', true);
		$('#tab-04_Form [id^="item4_"] select').attr('disabled', true);

		$('#tab-04_Form #item4_' + $(this).val().toLowerCase() + ' input[type="text"]').attr('disabled', false);
		$('#tab-04_Form #item4_' + $(this).val().toLowerCase() + ' select').attr('disabled', false);
		$('#tab-04_Form #item4_' + $(this).val().toLowerCase()).show();

		var url = '';
		var choice = $(this).val();
		if('SITE' == $(this).val()) {
			url = '${contextPath}<%=RequestMappingConstants.WEB_GIS_DATA_SITE_COND%>';
		} else if('LICENS' == $(this).val()) {
			url = '${contextPath}<%=RequestMappingConstants.WEB_GIS_DATA_LICENS_COND%>';
		}  else if('UNSALE_PAPR' == $(this).val()) {
			url = '${contextPath}<%=RequestMappingConstants.WEB_GIS_DATA_UNSALE_COND%>';
		}  else if('REMNDR_PAPR' == $(this).val()) {
			url = '${contextPath}<%=RequestMappingConstants.WEB_GIS_DATA_REMNDR_COND%>';
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

					if('SITE' == choice) {
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #bsns_nm').val('');
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #lc_lnm').val('');
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #bsns_code').val('');
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #lndpcl_blck').val('');

						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #bsns_nm').empty();
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #bsns_nm').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.prposBsnsNmInfo.length; i++) {
							$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #bsns_nm').append('<option value="' + data.prposBsnsNmInfo[i].bsns_nm + '">' + data.prposBsnsNmInfo[i].bsns_nm + '</option>');
						}

						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #prpos_nm').empty();
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #prpos_nm').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.prposNmInfo.length; i++) {
							$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #prpos_nm').append('<option value="' + data.prposNmInfo[i].prpos_nm + '">' + data.prposNmInfo[i].prpos_nm + '</option>');
						}

						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #sttus').empty();
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #sttus').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.sttusInfo.length; i++) {
							$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #sttus').append('<option value="' + data.sttusInfo[i].sttus + '">' + data.sttusInfo[i].sttus + '</option>');
						}

						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #spfc').empty();
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #spfc').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.spfcInfo.length; i++) {
							$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #spfc').append('<option value="' + data.spfcInfo[i].spfc + '">' + data.spfcInfo[i].spfc + '</option>');
						}

						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #lndcgr').empty();
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #lndcgr').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.lndcgrInfo.length; i++) {
							$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #lndcgr').append('<option value="' + data.lndcgrInfo[i].lndcgr + '">' + data.lndcgrInfo[i].lndcgr + '</option>');
						}
					} else if('LICENS' == choice) {
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #bsns_nm').val('');
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #se').val('');
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #lndpcl').val('');

						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #bsns_nm').empty();
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #bsns_nm').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.prposBsnsNmInfo.length; i++) {
							$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #bsns_nm').append('<option value="' + data.prposBsnsNmInfo[i].bsns_nm + '">' + data.prposBsnsNmInfo[i].bsns_nm + '</option>');
						}

						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #suply_ty').empty();
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #suply_ty').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.suplyTyInfo.length; i++) {
							$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #suply_ty').append('<option value="' + data.suplyTyInfo[i].suply_ty + '">' + data.suplyTyInfo[i].suply_ty + '</option>');
						}

						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #prpos').empty();
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #prpos').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.prposInfo.length; i++) {
							$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #prpos').append('<option value="' + data.prposInfo[i].prpos + '">' + data.prposInfo[i].prpos + '</option>');
						}
					} else if('UNSALE_PAPR' == choice) {
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #lndpcl_nm').val('');
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #lc').val('');


						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #dstrc_nm').empty();
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #dstrc_nm').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.dstrcNmInfo.length; i++) {
							$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #dstrc_nm').append('<option value="' + data.dstrcNmInfo[i].dstrc_nm + '">' + data.dstrcNmInfo[i].dstrc_nm + '</option>');
						}

						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #sle_mth').empty();
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #sle_mth').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.sleMthInfo.length; i++) {
							$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #sle_mth').append('<option value="' + data.sleMthInfo[i].sle_mth + '">' + data.sleMthInfo[i].sle_mth + '</option>');
						}

						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #pc_stdr').empty();
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #pc_stdr').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.pcStdrInfo.length; i++) {
							$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #pc_stdr').append('<option value="' + data.pcStdrInfo[i].pc_stdr + '">' + data.pcStdrInfo[i].pc_stdr + '</option>');
						}

						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #suply_trget_stdr').empty();
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #suply_trget_stdr').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.suplyTrgetStdrInfo.length; i++) {
							$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #suply_trget_stdr').append('<option value="' + data.suplyTrgetStdrInfo[i].suply_trget_stdr + '">' + data.suplyTrgetStdrInfo[i].suply_trget_stdr + '</option>');
						}

						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #spfc').empty();
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #spfc').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.spfcInfo.length; i++) {
							$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #spfc').append('<option value="' + data.spfcInfo[i].spfc + '">' + data.spfcInfo[i].spfc + '</option>');
						}
					} else if('REMNDR_PAPR' == choice) {
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #lnm').val('');

						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #cmptnc_gu').empty();
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #cmptnc_gu').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.cmptncGuInfo.length; i++) {
							$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #cmptnc_gu').append('<option value="' + data.cmptncGuInfo[i].cmptnc_gu + '">' + data.cmptncGuInfo[i].cmptnc_gu + '</option>');
						}

						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #lndcgr').empty();
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #lndcgr').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.lndcgrInfo.length; i++) {
							$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #lndcgr').append('<option value="' + data.lndcgrInfo[i].lndcgr + '">' + data.lndcgrInfo[i].lndcgr + '</option>');
						}

						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #cmptnc_cnter').empty();
						$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #cmptnc_cnter').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.cmptncCnterInfo.length; i++) {
							$('#tab-04_Form #item4_' + choice.toLowerCase() + ' #cmptnc_cnter').append('<option value="' + data.cmptncCnterInfo[i].cmptnc_cnter + '">' + data.cmptncCnterInfo[i].cmptnc_cnter + '</option>');
						}
					}
				} else {
					alert('검색 결과가 없습니다.')
				}
			}
		});
	});
	
	$('#tab-04_Form [name="search_type"]').val('SITE').trigger('change');
});

</script>
<body>
<!-- Tab-04 택지지구 -->
<div role="tabpanel" class="areaSearch full" id="tab-04" style="overflow:auto;">
	 <h2 class="tit">택지지구</h2>
	 <form id="tab-04_Form" name="tab-04_Form" onsubmit="return false;">
		 <h3 class="tit">검색항목</h3>
		 <div class="selectWrap">
	        <div class="disFlex">
	            <select id="search_type" name="search_type" title="검색항목">
	                <option value="SITE" selected>용지관리</option>
					<option value="LICENS">인허가</option>
					<option value="UNSALE_PAPR">미매각지</option>
					<option value="REMNDR_PAPR">잔여지</option>
	            </select>
			</div>    
		</div>
		<div id='item4_site' style='display: block;'>
			<h3 class="tit">사업명</h3>
			<div class="selectWrap">
		        <div class="disFlex">
		            <select id="bsns_nm"  name="bsns_nm" title="사업명">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>
			<h3 class="tit">위치</h3>
	        <div>
				<input type="text" name="lc_lnm" id="lc_lnm"
					placeholder="주소를 입력해주세요."
					class="ui-autocomplete-input input_textarea half_input_textarea"
					autocomplete="off" title="위치" onkeypress="if(event.keyCode==13) {gis_sherch(1);fn_gis_sherch_new(1);}">
			</div>
			<h3 class="tit">사업코드</h3>
	        <div>
				<input type="text" name="bsns_code" id="bsns_code"
					placeholder="사업코드를 입력해주세요."
					class="ui-autocomplete-input input_textarea half_input_textarea"
					autocomplete="off" title="사업코드" onkeypress="if(event.keyCode==13) {gis_sherch(1);fn_gis_sherch_new(1);}">
			</div>
			<h3 class="tit">필지(블록)</h3>
			<div>
				<input type="text" name="lndpcl_blck" id="lndpcl_blck"
					placeholder="블록정보를 입력해주세요."
					class="ui-autocomplete-input input_textarea half_input_textarea"
					autocomplete="off" title="필지" onkeypress="if(event.keyCode==13) {gis_sherch(1);fn_gis_sherch_new(1);}">
			</div>
			<h3 class="tit">용도명</h3>
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="prpos_nm" id="prpos_nm" title="용도명">
						<option value="0000" selected="selected">전체선택</option>
					</select>
				</div>    
			</div>
			<h3 class="tit">상태</h3>
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="sttus" id="sttus" title="상태">
						<option value="0000" selected="selected">전체선택</option>
					</select>
				</div>    
			</div>
			<h3 class="tit">지목</h3>
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="lndcgr" id="lndcgr" title="지목">
						<option value="0000" selected="selected">전체선택</option>
					</select>
				</div>    
			</div>
			<h3 class="tit">용도지역</h3>
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="spfc" id="spfc" title="용도지역">
						<option value="0000" selected="selected">전체선택</option>
					</select>
				</div>    
			</div>
		</div>
		
		<div id='item4_licens' style='display: none;'>
			<h3 class="tit">사업명</h3>
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="bsns_nm" id="bsns_nm" title="사업명">
						<option value="0000" selected="selected">전체선택</option>
					</select>
				</div>    
			</div>
			<h3 class="tit">용지구분</h3>
			<div>
				<input type="text" name="se" id="se"
					placeholder="용지구분을 입력해주세요."
					class="ui-autocomplete-input input_textarea half_input_textarea"
					autocomplete="off" title="용지구분" onkeypress="if(event.keyCode==13) {gis_sherch(1);fn_gis_sherch_new(1);}">
			</div>
			<h3 class="tit">필지(블록)</h3>
			<div>
				<input type="text" name="lndpcl" id="lndpcl"
					placeholder="블록정보를 입력해주세요."
					class="ui-autocomplete-input input_textarea half_input_textarea"
					autocomplete="off" title="필지" onkeypress="if(event.keyCode==13) {gis_sherch(1);fn_gis_sherch_new(1);}">
			</div>
			<h3 class="tit">공급유형</h3>
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="suply_ty" id="suply_ty" title="공급유형">
						<option value="0000" selected="selected">전체선택</option>
					</select>
				</div>    
			</div>	
			<h3 class="tit">용도명</h3>
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="prpos" id="prpos" title="용도명">
						<option value="0000" selected="selected">전체선택</option>
					</select>
				</div>    
			</div>				
			<h3 class="tit">면적㎥(총면적)</h3>				
			<div class="disFlex">
                    <input type="text" name="tot_ar1" id="tot_ar1" placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="면적 최소값">
                    ~
                    <input type="text" name="tot_ar2" id="tot_ar2" placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="면적 최대값">
            </div>				
		</div>
		
		<div id='item4_unsale_papr' style='display: none;'>
			<h3 class="tit">지구명</h3>
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="dstrc_nm" id="dstrc_nm" title="지구명">
						<option value="0000" selected="selected">전체선택</option>
					</select>
				</div>    
			</div>	
			<h3 class="tit">위치</h3>
			<div>
				<input type="text" name="lc" id="lc" placeholder="위치를 입력해주세요."
					class="ui-autocomplete-input input_textarea half_input_textarea"
					autocomplete="off" title="위치" onkeypress="if(event.keyCode==13) {gis_sherch(1);fn_gis_sherch_new(1);}">
			</div>				
			<h3 class="tit">판매방법</h3>
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="sle_mth" id="sle_mth" title="판매방법">
						<option value="0000" selected="selected">전체선택</option>
					</select>
				</div>    
			</div>		
			<h3 class="tit">가격기준</h3>
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="pc_stdr" id="pc_stdr" title="가격기준">
						<option value="0000" selected="selected">전체선택</option>
					</select>
				</div>    
			</div>		
			<h3 class="tit">공급대상기준</h3>
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="suply_trget_stdr" id="suply_trget_stdr" title="공급대상기준">
						<option value="0000" selected="selected">전체선택</option>
					</select>
				</div>    
			</div>			
			<h3 class="tit">용도지역</h3>
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="spfc" id="spfc" title="용도지역">
						<option value="0000" selected="selected">전체선택</option>
					</select>
				</div>    
			</div>		
			<h3 class="tit">대상면적(㎥)</h3>			
			<div class="disFlex">
                    <input type="text" name="trget_ar1" id="trget_ar1"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최소 면적">
                    ~
                    <input type="text" name="trget_ar2" id="trget_ar2"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off"  title="최대 면적">
            </div>	
            <h3 class="tit">매각면적(㎥)</h3>			
			<div class="disFlex">
                    <input type="text" name="sale_ar1" id="sale_ar1"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off"  title="최소 면적">
                    ~
                    <input type="text" name="sale_ar2" id="sale_ar2"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off"  title="최대 면적">
            </div>	
		</div>
		
		<div id='item4_remndr_papr' style='display: none;'>
			<h3 class="tit">자치구</h3>
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="cmptnc_gu" id="cmptnc_gu"  title="자치구">
						<option value="0000" selected="selected">전체선택</option>
					</select>
				</div>    
			</div>	
			<h3 class="tit">관할센터</h3>
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="cmptnc_cnter" id="cmptnc_cnter"  title="관할센터">
						<option value="0000" selected="selected">전체선택</option>
					</select>
				</div>    
			</div>
			<h3 class="tit">지목</h3>
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="lndcgr" id="lndcgr"  title="지목">
						<option value="0000" selected="selected">전체선택</option>
					</select>
				</div>    
			</div>		
			<h3 class="tit">위치</h3>
			<div>
				<input type="text" name="lnm" id="lnm"
					placeholder="동과 지번을 입력해주세요."
					class="ui-autocomplete-input input_textarea half_input_textarea"
					autocomplete="off"  title="위치" onkeypress="if(event.keyCode==13) {gis_sherch(1);fn_gis_sherch_new(1);}">
			</div>					
			<h3 class="tit">면적㎥(총면적)</h3>			
			<div class="disFlex">
                    <input type="text" name="trget_ar1" id="trget_ar1"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off"  title="최소 면적">
                    ~
                    <input type="text" name="trget_ar2" id="trget_ar2"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off"  title="최대 면적">
            </div>					
		</div>
	</form>
</div>
<!-- End Tab-04 -->
	<!-- 검색조건 Form -->
	<form id="GISinfoForm" name="GISinfoForm"></form>
	<div class="breakLine"></div>
	<div class="disFlex smBtnWrap" style = "padding: 1.6rem;">  
		<div class="selectWrap">
	        <div class="disFlex">
	            <select id="cnt_kind"  title="보기">
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