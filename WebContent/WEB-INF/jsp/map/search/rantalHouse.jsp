<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />
<!DOCTYPE html>
<script type="text/javascript">
$(document).ready(function() {
	
	$('#sub_content').show();
	
	// 임대 - 아파트
	$('.hasDatepicker').datepicker({
		dateFormat: 'yy-mm-dd'
	});
	
	// 임대 - 다가구
/* 	$('#compet_de2').datePicker({
		dateFormat: 'yy-mm-dd'
	}); */
	
	// 임대 - 도시형
	/* $('#compet_de3').datePicker({
		dateFormat: 'yy-mm-dd'
	}); 
	$('#puchas_de3').datepicker({
		dateFormat: 'yy-mm-dd'
	});*/
	
	// 임대 - 전세임대
	$('#cntrct_de4').datepicker({
		dateFormat: 'yy-mm-dd'
	});
	$('#mvn_de4').datepicker({
		dateFormat: 'yy-mm-dd'
	});
	
	// 임대 - 장기안심
	$('#cntrct_de5').datepicker({
		dateFormat: 'yy-mm-dd'
	});
	$('#mvn_de5').datepicker({
		dateFormat: 'yy-mm-dd'
	});
	
	/* var type = $(this).find("a").attr("href").replace("#", "");
	$("div[id$='-itemlist'], 	div[id$='-datalist']").removeClass("active");
	$("#"+type+"-itemlist, 		#"+type+"-datalist").addClass("active");
 */
 	
	// 2020 추가 - 임대 검색 조건
	$('#tab-05_Form [name="search_type"]').change(function() {
		//console.log($(this).val())

		$('#tab-05_Form [id^="item5_"]').hide();
		$('#tab-05_Form [id^="item5_"] input[type="text"]').attr('disabled', true);
		$('#tab-05_Form [id^="item5_"] select').attr('disabled', true);
		//231204 추가
		$('#tab-05_Form [id^="item5_"] input[type="text"]').val('');  
		$('#tab-05_Form .hasDatepicker').val('')

		$('#tab-05_Form #item5_' + $(this).val().toLowerCase() + ' input[type="text"]').attr('disabled', false);
		$('#tab-05_Form #item5_' + $(this).val().toLowerCase() + ' select').attr('disabled', false);
		$('#tab-05_Form #item5_' + $(this).val().toLowerCase()).show();

		var url = '';
		var choice = $(this).val();
		if('APT' == $(this).val()) {
			url = '${contextPath}<%=RequestMappingConstants.WEB_GIS_DATA_APT_COND%>';
		} else if('MLTDWL' == $(this).val()) {
			url = '${contextPath}<%=RequestMappingConstants.WEB_GIS_DATA_MLTDWL_COND%>';
		}  else if('CTY_LVLH' == $(this).val()) {
			url = '${contextPath}<%=RequestMappingConstants.WEB_GIS_DATA_CTY_COND%>';
		}  else if('LFSTS_RENT' == $(this).val()) {
			url = '${contextPath}<%=RequestMappingConstants.WEB_GIS_DATA_LFSTS_COND%>';
		}  else if('LNGTR_SAFETY' == $(this).val()) {
			url = '${contextPath}<%=RequestMappingConstants.WEB_GIS_DATA_LNGTR_COND%>';
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

					if('APT' == choice) {
						//$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #hsmp_nm').val('');

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #hsmp_nm_opt').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #hsmp_nm_opt').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.rentHsmpInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #hsmp_nm_opt').append('<option value="' + data.rentHsmpInfo[i].hsmp_nm + '">' + data.rentHsmpInfo[i].hsmp_nm + '</option>');
						}

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #rent_se').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #rent_se').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.rentSeInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #rent_se').append('<option value="' + data.rentSeInfo[i].lclas_code + '">' + data.rentSeInfo[i].lclas + '</option>');
						}

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #rent_se').off('change');
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #rent_se').on('change', function() {
							$.ajax({
								type : "POST",
								async : false,
								url : '${contextPath}<%=RequestMappingConstants.WEB_GIS_DATA_APT_RENTTY%>',
								dataType : "json",
								data : {
									rent_se: $(this).val()
								},
								error : function(response, status, xhr){
									if(xhr.status =='403'){
										alert('조회 조건 항목 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
									}
								},
								success : function(data) {
									if(data.result == 'Y') {
										$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #rent_ty').empty();
										$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #rent_ty').append('<option value="" selected="selected">전체선택</option>');
										for (i=0; i<data.rentTyInfo.length; i++) {
											$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #rent_ty').append('<option value="' + data.rentTyInfo[i].mlsfc_code + '">' + data.rentTyInfo[i].mlsfc + '</option>');
										}
									}
								}
							});
						});

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #rent_ty').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #rent_ty').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.rentTyInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #rent_ty').append('<option value="' + data.rentTyInfo[i].mlsfc_code + '">' + data.rentTyInfo[i].mlsfc + '</option>');
						}

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #se').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #se').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.seInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #se').append('<option value="' + data.seInfo[i].se + '">' + data.seInfo[i].se + '</option>');
						}

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #atdrc').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #atdrc').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.atdrcInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #atdrc').append('<option value="' + data.atdrcInfo[i].atdrc + '">' + data.atdrcInfo[i].atdrc + '</option>');
						}

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #cnter').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #cnter').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.cnterInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #cnter').append('<option value="' + data.cnterInfo[i].cnter + '">' + data.cnterInfo[i].cnter + '</option>');
						}
					} else if('MLTDWL' == choice) {
						//$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_nm').val('');

						/* $('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_nm_opt').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_nm_opt').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.bsnsNmInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_nm_opt').append('<option value="' + data.bsnsNmInfo[i].bsns_nm + '">' + data.bsnsNmInfo[i].bsns_nm + '</option>');
						} */

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_code').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_code').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.bsnsCodeInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_code').append('<option value="' + data.bsnsCodeInfo[i].bsns_code + '">' + data.bsnsCodeInfo[i].bsns_code + '</option>');
						}

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #dong').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #dong').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.dongInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #dong').append('<option value="' + data.dongInfo[i].dong + '">' + data.dongInfo[i].dong + '</option>');
						}

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #atdrc').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #atdrc').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.atdrcInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #atdrc').append('<option value="' + data.atdrcInfo[i].atdrc + '">' + data.atdrcInfo[i].atdrc + '</option>');
						}

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #cnter').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #cnter').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.cnterInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #cnter').append('<option value="' + data.cnterInfo[i].cnter + '">' + data.cnterInfo[i].cnter + '</option>');
						}

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #buld_strct').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #buld_strct').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.buldStrctInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #buld_strct').append('<option value="' + data.buldStrctInfo[i].buld_strct + '">' + data.buldStrctInfo[i].buld_strct + '</option>');
						}
					} else if('CTY_LVLH' == choice) {
						//$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_nm').val('');

						/* $('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_nm_opt').empty();
						for (i=0; i<data.bsnsNmInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_nm_opt').append('<option value="' + data.bsnsNmInfo[i].bsns_nm + '">' + data.bsnsNmInfo[i].bsns_nm + '</option>');
						} */

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_code').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_code').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.bsnsCodeInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_code').append('<option value="' + data.bsnsCodeInfo[i].bsns_code + '">' + data.bsnsCodeInfo[i].bsns_code + '</option>');
						}

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #dong').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #dong').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.dongInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #dong').append('<option value="' + data.dongInfo[i].dong + '">' + data.dongInfo[i].dong + '</option>');
						}

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #atdrc').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #atdrc').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.atdrcInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #atdrc').append('<option value="' + data.atdrcInfo[i].atdrc + '">' + data.atdrcInfo[i].atdrc + '</option>');
						}

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #cnter').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #cnter').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.cnterInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #cnter').append('<option value="' + data.cnterInfo[i].cnter + '">' + data.cnterInfo[i].cnter + '</option>');
						}

					} else if('LFSTS_RENT' == choice) {
						//$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_nm').val('');
						//$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #adres').val('');

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_code').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_code').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.bsnsCodeInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_code').append('<option value="' + data.bsnsCodeInfo[i].bsns_code + '">' + data.bsnsCodeInfo[i].bsns_code + '</option>');
						}

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #dong').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #dong').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.dongInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #dong').append('<option value="' + data.dongInfo[i].dong + '">' + data.dongInfo[i].dong + '</option>');
						}

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #atdrc').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #atdrc').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.atdrcInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #atdrc').append('<option value="' + data.atdrcInfo[i].atdrc + '">' + data.atdrcInfo[i].atdrc + '</option>');
						}

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #cnter').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #cnter').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.cnterInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #cnter').append('<option value="' + data.cnterInfo[i].cnter + '">' + data.cnterInfo[i].cnter + '</option>');
						}

					} else if('LNGTR_SAFETY' == choice) {
						//$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_nm').val('');
						//$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #adres').val('');

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_code').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_code').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.bsnsCodeInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #bsns_code').append('<option value="' + data.bsnsCodeInfo[i].bsns_code + '">' + data.bsnsCodeInfo[i].bsns_code + '</option>');
						}

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #dong').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #dong').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.dongInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #dong').append('<option value="' + data.dongInfo[i].dong + '">' + data.dongInfo[i].dong + '</option>');
						}

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #atdrc').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #atdrc').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.atdrcInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #atdrc').append('<option value="' + data.atdrcInfo[i].atdrc + '">' + data.atdrcInfo[i].atdrc + '</option>');
						}

						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #cnter').empty();
						$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #cnter').append('<option value="" selected="selected">전체선택</option>');
						for (i=0; i<data.cnterInfo.length; i++) {
							$('#tab-05_Form #item5_' + choice.toLowerCase() + ' #cnter').append('<option value="' + data.cnterInfo[i].cnter + '">' + data.cnterInfo[i].cnter + '</option>');
						}
					}
				} else {
					alert('검색 결과가 없습니다.')
				}
			}
		});
	});
 
	$('#tab-05_Form [name="search_type"]').val("APT").trigger("change");
});
</script>
<body>
<!-- Tab-05 임대주택-->
<div role="tabpanel" class="areaSearch full" id="tab-05" style="overflow:auto;">
	<h2 class="tit">임대주택</h2>
	<form id="tab-05_Form" name="tab-05_Form" onsubmit="return false;">
		<h3 class="tit">검색항목</h3>
		 <div class="selectWrap">
	        <div class="disFlex">
	            <select id="search_type" name="search_type"  title="검색항목">
	                <option value="APT" selected>아파트 단지</option>
					<option value="MLTDWL">다가구</option>
					<option value="CTY_LVLH">도시형생활주택</option>
					<option value="LFSTS_RENT">전세임대</option>
					<option value="LNGTR_SAFETY">장기안심</option>
	            </select>
			</div>    
		</div>
		
		<div id='item5_apt' style='display: block;'>
			<h3 class="tit">단지명</h3>
			<div>
				<input type="text" name="hsmp_nm" id="hsmp_nm"
					placeholder="단지명을 입력해주세요." class="ui-autocomplete-input input_textarea half_input_textarea"
					autocomplete="off" title="단지명" onkeypress="if(event.keyCode==13) {gis_sherch(1);fn_gis_sherch_new(1);}">
			</div>
			<h3 class="tit">단지명 선택</h3>
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="hsmp_nm_opt" id="hsmp_nm_opt" title="단지명 선택">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>				
			<h3 class="tit">임대구분</h3>			
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="rent_se" id="rent_se" title="임대구분">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>		
			<h3 class="tit">임대유형</h3>			
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="rent_ty" id="rent_ty" title="임대유형">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>	
			<h3 class="tit">구분</h3>			
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="se" id="se" title="구분">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>	
			<h3 class="tit">자치구</h3>			
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="atdrc" id="atdrc" title="자치구">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>
			<h3 class="tit">센터</h3>			
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="cnter" id="cnter" title="센터">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>
			<h3 class="tit">공급일</h3>			
			<div>
				<div class="input-group date datetimepickerStart " >
					<input class="form-control input-group-addon m-b-0 hasDatepicker" title="공급일" name="suply_de1" id="suply_de1" placeholder="공급일을 선택하세요" style="padding: 0; height: 30px;">
					<span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
				</div>
			</div>		
			<h3 class="tit">총동수</h3>				
			<div class="disFlex">
                    <input type="text" name="aptcmpl_sm1" title="최소 동수" id="aptcmpl_sm1" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
                    ~
                    <input type="text" name="aptcmpl_sm2" title="최대 동수" id="aptcmpl_sm2" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea"autocomplete="off">
            </div>					
			<h3 class="tit">임대세대수</h3>				
			<div class="disFlex">
                    <input type="text" name="rent_hshld_co1" id="rent_hshld_co1"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최소 임대세대수"> 
                    ~
                    <input type="text" name="rent_hshld_co2" id="rent_hshld_co2"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최대 임대세대수">
            </div>
		</div>
		
		<div id='item5_mltdwl' style='display: none;'>
			<h3 class="tit">주소</h3>
			<div>
				<input type="text" name="adres" id="adres"
					placeholder="주소를 입력해주세요." class="ui-autocomplete-input input_textarea half_input_textarea"
					autocomplete="off" title="주소" onkeypress="if(event.keyCode==13) {gis_sherch(1);fn_gis_sherch_new(1);}">
				<p class="info"> ※ ‘자치구’부터 기입하여 주세요.</p>
			</div>
			<h3 class="tit">사업코드</h3>			
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="bsns_code" id="bsns_code" title="사업코드">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>
			<h3 class="tit">동</h3>			
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="dong" id="dong" title="동">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>
			<h3 class="tit">자치구</h3>			
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="atdrc" id="atdrc" title="자치구">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>
			<h3 class="tit">센터</h3>			
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="cnter" id="cnter" title="센터">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>
			<h3 class="tit">건물구조</h3>			
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="buld_strct" id="buld_strct" title="건물구조">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>				
			<h3 class="tit">연면적</h3>				
			<div class="disFlex">
                    <input type="text" name="bildng_totar1" id="bildng_totar1"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최소 연면적">
                    ~
                    <input type="text" name="bildng_totar2" id="bildng_totar2"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최대 연면적">
            </div>	
            <h3 class="tit">전용면적</h3>				
			<div class="disFlex">
                    <input type="text" name="prvuse_ar1" id="prvuse_ar1"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최소 전용면적"> 
                    ~
                    <input type="text" name="prvuse_ar2" id="prvuse_ar2"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최대 전용면적">
            </div>	
            <h3 class="tit">대지면적</h3>				
			<div class="disFlex">
                    <input type="text" name="plot_ar1" id="plot_ar1"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최소 대지면적">
                    ~
                    <input type="text" name="plot_ar2" id="plot_ar2"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최대 대지면적">
            </div>	
            <h3 class="tit">전체세대수</h3>				
			<div class="disFlex">
                    <input type="text" name="hshld_co1" id="hshld_co1"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최소 전체세대수">
                    ~
                    <input type="text" name="hshld_co2" id="hshld_co2"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최대 전체세대수">
            </div>			
			<h3 class="tit">준공일자</h3>					
			<div>
				<div class="input-group date datetimepickerStart ">
					<input class="form-control input-group-addon m-b-0 hasDatepicker"
						name="compet_de2" id="compet_de2" placeholder="준공일을 선택하세요"
						style="padding: 0; height: 30px;" title="준공일자"> <span
						class="input-group-addon bg-info b-0"><i
						class="fa fa-calendar text-white"></i></span>
				</div>
			</div>				
		</div>
		
		<div id='item5_cty_lvlh' style='display: none;'>
			<h3 class="tit">주소</h3>
			<div>
				<input type="text" name="adres" id="adres"
					placeholder="주소를 입력해주세요." class="ui-autocomplete-input input_textarea half_input_textarea"
					autocomplete="off" title="주소" onkeypress="if(event.keyCode==13) {gis_sherch(1);fn_gis_sherch_new(1);}">
				<p class="info"> ※ ‘자치구’부터 기입하여 주세요.</p>
			</div>
			<h3 class="tit">사업코드</h3>			
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="bsns_code" id="bsns_code" title="사업코드">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>		
			<h3 class="tit">동</h3>			
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="dong" id="dong" title="동">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>	
			<h3 class="tit">자치구</h3>			
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="atdrc" id="atdrc" title="자치구">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>	
			<h3 class="tit">센터</h3>			
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="cnter" id="cnter" title="센터">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>	
			<h3 class="tit">전체세대수</h3>			
			<div class="disFlex">
                    <input type="text" name="tot_hshld_co1" id="tot_hshld_co1"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최소 전체세대수">
                    ~
                    <input type="text" name="tot_hshld_co2" id="tot_hshld_co2"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최대 전체세대수">
            </div>	
            <h3 class="tit">전체동수</h3>			
			<div class="disFlex">
                    <input type="text" name="TOT_APTCMPL_CO1" id="TOT_APTCMPL_CO1"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최소 전체동수">
                    ~
                    <input type="text" name="TOT_APTCMPL_CO2" id="TOT_APTCMPL_CO2"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최대 전체동수">
            </div>		
			<h3 class="tit">준공일자</h3>					
			<div>
				<div class="input-group date datetimepickerStart ">
					<input class="form-control input-group-addon m-b-0 hasDatepicker" 
						name="compet_de3" id="compet_de3" placeholder="준공일을 선택하세요"
						style="padding: 0; height: 30px;" title="준공일자"> <span
						class="input-group-addon bg-info b-0"><i
						class="fa fa-calendar text-white"></i></span>
				</div>
			</div>				
			<h3 class="tit">매입일자</h3>					
			<div>
				<div class="input-group date datetimepickerStart ">
					<input class="form-control input-group-addon m-b-0 hasDatepicker" 
						name="puchas_de3" id="puchas_de3" placeholder="매입일을 선택하세요"
						style="padding: 0; height: 30px;" title="매입일자"> <span
						class="input-group-addon bg-info b-0"><i
						class="fa fa-calendar text-white"></i></span>
				</div>
			</div>					
		</div>
		
		<div id='item5_lfsts_rent' style='display: none;'>
			<h3 class="tit">주소</h3>
			<div>
				<input type="text" name="adres" id="adres"
					placeholder="주소를 입력해주세요." class="ui-autocomplete-input input_textarea half_input_textarea"
					autocomplete="off" title="주소" onkeypress="if(event.keyCode==13) {gis_sherch(1);fn_gis_sherch_new(1);}">
					<p class="info"> ※ ‘자치구’부터 기입하여 주세요.</p>
			</div>
			<h3 class="tit">자치구</h3>			
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="atdrc" id="atdrc" title="자치구">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>	
			<h3 class="tit">센터</h3>			
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="cnter" id="cnter" title="센터">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>					
			<h3 class="tit">면적</h3>		
			<div class="disFlex">
                    <input type="text" name="ar1" id="ar1" placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최소 면적">
                    ~
                    <input type="text" name="ar2" id="ar2" placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최대 면적">
            </div>
            <h3 class="tit">세대수</h3>		
			<div class="disFlex">
                    <input type="text" name="hshld_co1" id="hshld_co1"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최소 세대수">
                    ~
                    <input type="text" name="hshld_co2" id="hshld_co2"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최대 세대수">
            </div>
            <h3 class="tit">계약일</h3>					
			<div>
				<div class="input-group date datetimepickerStart ">
					<input class="form-control input-group-addon m-b-0" 
						name="cntrct_de4" id="cntrct_de4" placeholder="계약일을 선택하세요"
						style="padding: 0; height: 30px;" title="계약일"> 
					<span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
				</div>
			</div>	
			<h3 class="tit">입주일</h3>					
			<div>
				<div class="input-group date datetimepickerStart "">
					<input class="form-control input-group-addon m-b-0" 
										name="mvn_de4" id="mvn_de4" placeholder="입주일을 선택하세요"
										style="padding: 0; height: 30px;" title="입주일"> 
					<span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
				</div>
			</div>				
		</div>
		
		<div id='item5_lngtr_safety' style='display: none;'>
			<h3 class="tit">주소</h3>
			<div>
				<input type="text" name="adres" id="adres" title="주소" placeholder="주소를 입력해주세요." class="ui-autocomplete-input input_textarea half_input_textarea" autocomplete="off"
				onkeypress="if(event.keyCode==13) {gis_sherch(1);fn_gis_sherch_new(1);}">
				<p class="info"> ※ ‘자치구’부터 기입하여 주세요.</p>
			</div>
			<h3 class="tit">사업코드</h3>			
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="bsns_code" id="bsns_code" title="사업코드">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>		
			<h3 class="tit">동</h3>			
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="dong" id="dong" title="동">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>	
			<h3 class="tit">자치구</h3>			
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="atdrc" id="atdrc" title="자치구">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>	
			<h3 class="tit">센터</h3>			
			<div class="selectWrap">
		        <div class="disFlex">
		            <select name="cnter" id="cnter" title="센터">
		                <option value="0000" selected="selected">전체선택</option>
		            </select>
				</div>    
			</div>	
			<h3 class="tit">면적</h3>		
			<div class="disFlex">
                    <input type="text" name="ar1" id="ar1" placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최소 면적">
                    ~
                    <input type="text" name="ar2" id="ar2" placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최대 면적">
            </div>
            <h3 class="tit">세대수</h3>		
			<div class="disFlex">
                    <input type="text" name="hshld_co1" id="hshld_co1"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최소 세대수">
                    ~
                    <input type="text" name="hshld_co2" id="hshld_co2"
						placeholder="0"
						class="ui-autocomplete-input input_textarea half2_input_textarea"
						autocomplete="off" title="최대 세대수">
            </div>
            <h3 class="tit">계약일</h3>					
			<div>
				<div class="input-group date datetimepickerStart ">
					<input class="form-control input-group-addon m-b-0" 
						name="cntrct_de5" id="cntrct_de5" placeholder="계약일을 선택하세요"
						style="padding: 0; height: 30px;" title="계약일"> 
					<span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
				</div>
			</div>	
			<h3 class="tit">입주일</h3>					
			<div>
				<div class="input-group date datetimepickerStart ">
					<input class="form-control input-group-addon m-b-0"
										name="mvn_de5" id="mvn_de5" placeholder="입주일을 선택하세요"
										style="padding: 0; height: 30px;" title="입주일"> 
					<span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
				</div>
			</div>	
		</div>
	</form>
</div>
<!-- End Tab-05 -->
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