<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

<style>
.ui-datepicker{ font-size: 12px; width: 200px; }

</style>

<script type="text/javascript">
$(document).ready(function() {
	
	//탭기능 - 추가
	$("#SH_Search_tab li").on("click", function(){
    	var type = $(this).find("a").attr("href").replace("#", "");
    	$("div[id$='-itemlist'], 	div[id$='-datalist']").removeClass("active");
    	$("#"+type+"-itemlist, 		#"+type+"-datalist").addClass("active");

    	//관련사업(공간분석)
    	$("#sel").val("sa01");
   		$("#sa01, #sa02, #sa03, #buld01, #land01").hide();
   		space_clear();
   		$("#sa01").show();
    	if(type == "tab-01"){
    		$("#sel option").remove();
    		$("#sel").append('<option value="sa01">관련사업 검색</option>');
    		$("#sel").append('<option value="land01">국공유지 개발/활용 대상지</option>');
    	}else if(type == "tab-02"){
    		$("#sel option").remove();
    		$("#sel").append('<option value="sa01">관련사업 검색</option>');
    		$("#sel").append('<option value="buld01">낙후(저층)주거지 찾기</option>');
    	}else if(type == "tab-03"){
    		$("#sel option").remove();
    		$("#sel").append('<option value="sa01">관련사업 검색</option>');
    	}

    	//분석기법 선택시 강조
    	sa_view(null);

    });

	//탭-건물 상세검색 자동완성기능
	$("#fn_gbname").autocomplete({
		source: [ "연립주택", "다가구", "다가구주택", "다세대", "다세대주택", "아파트", "도시형생활주택", "근린생활시설", "다가구용단독주택", "단지형다세대주택",
		          "상가", "연립주택", "창고", "부대시설", "생활편익시설", "점포", "의료시설" ]
	});


	// 2020 추가

	// 임대 - 아파트
	$('#suply_de1').datepicker({
		dateFormat: 'yy-mm-dd'
	});

	// 임대 - 다가구
	/* $('#suply_de2').datepicker({
		dateFormat: 'yy-mm-dd'
	}); */
	$('#compet_de2').datepicker({
		dateFormat: 'yy-mm-dd'
	});

	// 임대 - 도시형
	$('#compet_de3').datepicker({
		dateFormat: 'yy-mm-dd'
	});
	$('#puchas_de3').datepicker({
		dateFormat: 'yy-mm-dd'
	});
	$('#suply_de3').datepicker({
		dateFormat: 'yy-mm-dd'
	});

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
			url = '<%=RequestMappingConstants.WEB_GIS_DATA_SITE_COND%>';
		} else if('LICENS' == $(this).val()) {
			url = '<%=RequestMappingConstants.WEB_GIS_DATA_LICENS_COND%>';
		}  else if('UNSALE_PAPR' == $(this).val()) {
			url = '<%=RequestMappingConstants.WEB_GIS_DATA_UNSALE_COND%>';
		}  else if('REMNDR_PAPR' == $(this).val()) {
			url = '<%=RequestMappingConstants.WEB_GIS_DATA_REMNDR_COND%>';
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
			url = '<%=RequestMappingConstants.WEB_GIS_DATA_APT_COND%>';
		} else if('MLTDWL' == $(this).val()) {
			url = '<%=RequestMappingConstants.WEB_GIS_DATA_MLTDWL_COND%>';
		}  else if('CTY_LVLH' == $(this).val()) {
			url = '<%=RequestMappingConstants.WEB_GIS_DATA_CTY_COND%>';
		}  else if('LFSTS_RENT' == $(this).val()) {
			url = '<%=RequestMappingConstants.WEB_GIS_DATA_LFSTS_COND%>';
		}  else if('LNGTR_SAFETY' == $(this).val()) {
			url = '<%=RequestMappingConstants.WEB_GIS_DATA_LNGTR_COND%>';
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
								url : '<%=RequestMappingConstants.WEB_GIS_DATA_APT_RENTTY%>',
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

	// 2023 변경 - 자산 검색 조건_기타 추가
	$('#tab-06_Form [name="search_type"]').change(function() {
		//console.log($(this).val())

		var url = '';
		var url2 = '';
		if('ASSET_APT' == $(this).val()) {
			url = '<%=RequestMappingConstants.WEB_GIS_DATA_ASSET_APT_COND%>';
			url2 = '<%=RequestMappingConstants.WEB_GIS_DATA_ASSET_APT_PRD%>';
		} else if('ASSET_MLTDWL' == $(this).val()) {
			url = '<%=RequestMappingConstants.WEB_GIS_DATA_ASSET_MLT_COND%>';
			url2 = '<%=RequestMappingConstants.WEB_GIS_DATA_ASSET_MLT_PRD%>';
		}else if('ASSET_ETC' == $(this).val()) {
			url = '<%=RequestMappingConstants.WEB_GIS_DATA_ASSET_ETC_COND%>';
			url2 = '<%=RequestMappingConstants.WEB_GIS_DATA_ASSET_ETC_PRD%>';
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

	function fn_sherch_rent_stats() {
		if($("#rental_stats_mini").css('display') == 'block')
			return;

		$.ajax({
			type : "POST",
			async : false,
			url : '<%= RequestMappingConstants.WEB_GIS_DATA_RENTAL_STATS %>',
			dataType : "json",
			data : {},
			error : function(response, status, xhr){
				if(xhr.status =='403'){
					alert('임대주택 현황 조회 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
				}
			},
			success : function(data) {
				if(data.result == 'Y' && data != '') {
					//console.log(data)

					$('#search_list_mini_close').trigger('click');
					fn_rental_stats_show(data);
				} else {
					alert('검색 결과가 없습니다.')
				}
			}
		});
	}

    $('#tab_04_build_land').click(function() {
    	$('#tab-04_Form [name="search_type"]').val('SITE').trigger('change');
    });

	$('#tab_05_rent_stats').click(function() {
		$('#tab-05_Form [name="search_type"]').val('APT').trigger('change');

		fn_sherch_rent_stats();
	});

	$('#tab_06_assets').click(function() {
    	$('#tab-06_Form [name="search_type"]').val('ASSET_APT').trigger('change');
    });
});

var basic_KindList 	= ["gb", "sig", "emd"];
var fs_KindList 	= ["jimok", "parea", "pnilp", "spfc", "land_use", "geo_hl", "geo_form", "road_side"];
var fn_KindList 	= ["cp_date", "bildng_ar", "totar", "plot_ar", "bdtldr", "cpcty_rt" /*, "use_confm", "strct", "ground", "undgrnd", "hg" */];
var fg_KindList 	= ["soldout", "sector", "spkfc", "fill_gb",  "useu", "uses", "sector_nm", "solar", "hbdtldr", "hcpcty_rt", "hg_limit", "taruse", "soldkind", "soldgb"];

var fs_dataList 	= ["guk_land", "tmseq_land", "region_land", "owned_city", "owned_guyu", "residual_land", "unsold_land", "invest", "public_site", "public_parking", "generations", "council_land", "minuse", "industry", "priority"];
var fs_dataList_kr 	= ["국유지일반재산(캠코)", "위탁관리 시유지", "자치구위임관리 시유지", "자치구 보유관리토지(시유지)", "자치구 보유관리토지(구유지)", "SH잔여지", "SH미매각지", "SH현물출자", "공공기관 이전부지", "공영주차장", "역세권사업 후보지", "임대주택 단지", "저이용공공시설", "공공부지 혼재지역", "중점활용 시유지"];
var fn_dataList 	= ["guk_buld", "tmseq_buld", "region_buld", "owned_region", "owned_seoul", "cynlst", "public_buld_a", "public_buld_b", "public_buld_c", "public_asbu", "purchase", "declining"];
var fn_dataList_kr 	= ["국유지일반재산(캠코)", "위탁관리 건물", "자치구위임관리 건물", "자치구 보유관리건물(자치구)", "자치구 보유관리건물(서울시)", "재난위험시설", "공공건축물(국공립)", "공공건축물(서울시)", "공공건축물(자치구)", "공공기관이전건물", "매입임대", "노후매입임대"];
var fg_dataList 	= ["residual", "unsold"];
var fg_dataList_kr 	= ["잔여지", "미매각지"];

//상세검색 창 열닫
function gis_item(){
	$("#searching_item").toggle("slide");
	if( $("#searching_data").css("display") == 'block' ){
		$("#searching_data").toggle("slide");
	}
	if( $("#searching_space").css("display") == 'block' ){
		$("#searching_space").toggle("slide");
		//분석기법 선택시 강조
    	sa_view(null);
	}
}

//자산검색창 열닫
function gis_item_data(){
	$("#searching_data").toggle("slide");
}

//공간검색창 열닫
function gis_item_space(){
	$("#searching_space").toggle("slide");

	//분석기법
	$("#sel").val("sa01");
	$("#sa01, #sa02, #sa03, #buld01, #land01").hide();
	space_clear();
	$("#sa01").show();
	sa_view(null);
}

//2020 추가 - 택지, 임대, 자산 검색결과 이동시
function fn_gis_map_draw_wkt(data) {
	//그래픽 초기화
	if(vectorLayer != null || vectorLayer != ''){
		vectorSource.clear();
		geoMap.removeLayer(vectorLayer);
	}

	//create the style
	var iconStyle2 =[ 
		new ol.style.Style({
    	stroke: new ol.style.Stroke({
    		color: 'white',
      		width: 3
    	}),
		image: new ol.style.Icon({
			anchor: [0.5, 40],
			anchorXUnits: 'fraction',
			anchorYUnits: 'pixels',
			opacity: 1,
			size: [40, 40],
			scale: 0.5,
			src: '/jsp/SH/img/pin04_sil.png'
			})
    	}),
    	new ol.style.Style({
        	stroke: new ol.style.Stroke({
        		color: 'red',
          		width: 2,
          		lineDash: [4]
        	}),
    		image: new ol.style.Icon({
    			anchor: [0.5, 40],
    			anchorXUnits: 'fraction',
    			anchorYUnits: 'pixels',
    			opacity: 1,
    			size: [40, 40],
    			scale: 0.5,
    			src: '/jsp/SH/img/pin04_sil.png'
    		})
        })
	];

    vectorLayer = new ol.layer.Vector({
        source: vectorSource,
        style: iconStyle2
    });

    var reader = new ol.format.WKT();
    for(i=0; i<data.length; i++) {
	    var geometry = reader.readGeometry(data[i].geom);
		var iconFeature2 = new ol.Feature({
	           geometry: geometry
	    });
		vectorSource.addFeature(iconFeature2);
    }

    //레이어 제일위에 표출하기
    vectorLayer.setZIndex(parseInt(10000));

    geoMap.addLayer(vectorLayer);
    geoMap.getView().fit(vectorLayer.getSource().getExtent(), geoMap.getSize());
    geoMap.getView().animate({
    	  zoom: geoMap.getView().getZoom() - 2,
    	  duration: 500
    });
	geoMap.renderSync();
	geoMap.render();
}

//2020 추가 - shpae 업로드 표출시, 빈집 외부 연계시
function fn_gis_map_draw_geojson(data) {
	//그래픽 초기화
	if(vectorLayer != null || vectorLayer != ''){
		vectorSource.clear();
		geoMap.removeLayer(vectorLayer);
	}

	//create the style
	var iconStyle2 = new ol.style.Style({
    	/* fill: new ol.style.Fill({
      		color: 'red'
    	}), */
    	stroke: new ol.style.Stroke({
    		color: 'red',
      		width: 1.5,
      		lineDash: [4]
    	}),
		image: new ol.style.Icon({
			anchor: [0.5, 40],
			anchorXUnits: 'fraction',
			anchorYUnits: 'pixels',
			opacity: 1,
			size: [40, 40],
			scale: 0.5,
			src: '/jsp/SH/img/pin04_sil.png'
		})
    });

    vectorLayer = new ol.layer.Vector({
        source: vectorSource,
        style: iconStyle2
    });

    var reader = new ol.format.GeoJSON();
	vectorSource.addFeatures(reader.readFeatures(data));

    geoMap.addLayer(vectorLayer);
    geoMap.getView().fit(vectorLayer.getSource().getExtent(), geoMap.getSize());
    geoMap.getView().animate({
    	  zoom: geoMap.getView().getZoom() - 3,
    	  duration: 500
    });
	geoMap.renderSync();
	geoMap.render();
}

//2020 추가 - 크릭시
function fn_gis_map_draw_feature(data) {
	//그래픽 초기화
	if(vectorLayer != null || vectorLayer != ''){
		vectorSource.clear();
		geoMap.removeLayer(vectorLayer);
	}

	//create the style
	var iconStyle2 = new ol.style.Style({
    	/* fill: new ol.style.Fill({
      		color: 'red'
    	}), */
    	stroke: new ol.style.Stroke({
    		color: 'red',
      		width: 2.5,
      		lineDash: [8]
    	}),
		image: new ol.style.Icon({
			anchor: [0.5, 40],
			anchorXUnits: 'fraction',
			anchorYUnits: 'pixels',
			opacity: 1,
			size: [40, 40],
			scale: 0.5,
			src: '/jsp/SH/img/pin04_sil.png'
		})
    });

    vectorLayer = new ol.layer.Vector({
        source: vectorSource ,
        style: iconStyle2
    });

	vectorSource.addFeatures(data);

    geoMap.addLayer(vectorLayer);
    /* geoMap.getView().fit(vectorLayer.getSource().getExtent(), geoMap.getSize());
    geoMap.getView().animate({
    	  zoom: geoMap.getView().getZoom() - 1,
    	  duration: 500
    }); */
	geoMap.renderSync();
	geoMap.render();
}

function fn_gis_map_move(data) {
	if(data != null && data.length > 0 && data[0].x != null && data[0].x != "" && data[0].x != undefined && data[0].y != null && data[0].y != "" && data[0].y != undefined) {
		if(toggles){
			main_toggle();
		}

		if(data[0].geom != null && data[0].geom != "") {
			fn_gis_map_draw_wkt(data);
		}

		var spot = [Number(data[0].x), Number(data[0].y)];
		view.setCenter(spot);
		view.setZoom(18);
		geoMap.renderSync();
		geoMap.render();
	} else {
		alert("도형정보가 없습니다.");
		return;
	}
}

function fn_gis_clear_new() {
	$("#tab-04, #tab-05, #tab-06").each(function(){
		var tab = $(this);
		if( tab.css("display") == 'block' ){
			tab_name = tab.prop("id");

			if( tab_name == 'tab-04' )
	   			$('#tab-04_Form [name="search_type"]').val('SITE').trigger('change');
			else if( tab_name == 'tab-05' )
				$('#tab-05_Form [name="search_type"]').val('APT').trigger('change');
			else if( tab_name == 'tab-06' )
				$('#tab-06_Form [name="search_type"]').val('ASSET_APT').trigger('change');
		}
	});
}

function fn_gis_sherch_new(a) {
	$("#tab-04, #tab-05, #tab-06").each(function(){
		
		var tab = $(this);
		
		if( tab.css("display") == 'block' ){
			tab_name = tab.prop("id");
			console.log("토지검색!!!", tab_name)
			var url;
			var sendData;
			var title;
			var search_type;
			var comprehensive = 'N';

			if( tab_name == 'tab-04' ){
				url = '<%=RequestMappingConstants.WEB_GIS_DATA_BUILD_LAND%>';
				sendData = $("#tab-04_Form").serialize();
				title = $("#tab-04").children().find("#search_type option:checked").text();
				search_type = $("#tab-04").children().find("#search_type option:checked").val();
			} else if( tab_name == 'tab-05' ){
				url = '<%=RequestMappingConstants.WEB_GIS_DATA_RENTAL%>';
				sendData = $("#tab-05_Form").serialize();
				title = $("#tab-05").children().find("#search_type option:checked").text();
				search_type = $("#tab-05").children().find("#search_type option:checked").val();
				comprehensive = 'Y';
			} else if( tab_name == 'tab-06' ){
				url = '<%=RequestMappingConstants.WEB_GIS_DATA_ASSET%>';
				sendData = $("#tab-06_Form").serialize();
				title = $("#tab-06").children().find("#search_type option:checked").text();
				search_type = $("#tab-06").children().find("#search_type option:checked").val();
			}

			console.log(sendData);

			if(url != '' && sendData != '') {
				$.ajax({
					type : "POST",
					async : false,
					url : url,
					data : sendData,
			       	beforeSend: function() { $('html').css("cursor", "wait"); },
			       	complete: function() { $('html').css("cursor", "auto"); },
					error : function(response, status, xhr){
						if(xhr.status =='403'){
							alert('검색 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
						}
					},
					success : function(data) {
						console.log("data : ", data.dataInfo);
						if(data.result == 'Y' && data.dataInfo.length > 0) {
							$('#rental-stats-mini-close').trigger('click');
							fn_search_list_mini_show(title, search_type, data.tableSpace , data.tableNm , data.tablePkInfo, data.tableEditInfo, data.headEngInfo, data.headKorInfo, data.dataInfo, comprehensive, data.geometryInfo);
						} else {
							alert('검색 결과가 없습니다.')
						}
					}
				});
			}
		}
	});
}

</script>
<div class="side-pane main-panel" id="land_search" style="display:none; height: 100%; left: 75px;top: 0;">
	<!-- Page-Title -->
	<div class="row page-title-box-wrap tit">
		<div class="close-btn tab">
        	<button type="button" class="close tab" id="main-panel-close">×</button>
		</div>
    </div>
    <div class="tab-content map">
    	<!-- 자산검색 Side-Panel -->
		<div class="tab-pane fade toptab active in" role="tabpanel" id="asset-search-tab">
            <div class="pane-content map">

                <!-- Tab-Buttons -->
                <ul class="nav nav-tabs" role="tablist" id="SH_Search_tab">
                    <li role="presentation" class="active">
                    	<a href="#tab-01" role="tab" data-toggle="tab" class="map-tab01">토지</a>
                    </li>
                    <!-- 건물 변경으로 인한 주석 -->
                   <!--  <li role="presentation">
                    	<a href="#tab-02" role="tab" data-toggle="tab" class="map-tab02">건물</a>
                    </li> -->
                    <!-- 2020 변경 -->
                    <!-- <li role="presentation">
                    	<a href="#tab-03" role="tab" data-toggle="tab" class="map-tab03">사업지구</a>
                    </li> -->
                    <!-- 2020 추가 -->
                    <li role="presentation">
                    	<a href="#tab-04" role="tab" data-toggle="tab" class="map-tab04" id='tab_04_build_land'>택지지구</a>
                    </li>
                    <li role="presentation">
                    	<a href="#tab-05" role="tab" data-toggle="tab" class="map-tab05" id='tab_05_rent_stats'>임대주택</a>
                    </li>
                    <li role="presentation">
                    	<!-- <a href="#tab-06" role="tab" data-toggle="tab" class="map-tab06" id='tab_06_assets'>기타자산</a> -->
                    	<a href="#tab-06" role="tab" data-toggle="tab" class="map-tab06" id='tab_06_assets'>자산대장</a>

                    </li>
                </ul>
                <!-- End Tab-Buttons -->

                <!-- Tab-Content -->
                <div class="tab-content map tabintab">

                    <div class="search-condition" style='display: none'>
                        <div class="btn-wrap">
                            <button class="btn btn-orange btn-sm" onclick="bookmark()">즐겨찾기</button>
                            <button class="btn btn-inverse btn-sm">주제도면 제작</button>
                            <button class="btn btn-inverse btn-sm">등록</button>
                        </div>
                    </div>

                    <!-- Tab-01 -->
                    <div role="tabpanel" class="tab-pane active search-result-list" id="tab-01">
                        <div class="list-group-wrap in-asset">
	                        <form id="tab-01_Form" name="tab-01_Form"  onsubmit="return false;" >
	                            <div id="land-basiclist">
	                                <div class="list-group">
										<div class="form-group row">
											<div class="col-xs-6">
	                                           	<label for="fs_sig">시군구</label>
	                                           	<select class="form-control chosen" id="fs_sig">
	                                                <option value="0000" selected="selected">전체선택</option>
	                                                <c:forEach var="result" items="${SIGList}" varStatus="status">
														<option value='<c:out value="${result.sig_cd}"/>'><c:out value="${result.sig_kor_nm}"/></option>
													</c:forEach>
	                                            </select>
	                                        </div>
	                                        <div class="col-xs-6">
	                                           	<label for="fs_emd">읍면동</label>
	                                            <select class="form-control chosen" id="fs_emd">
	                                                <option value="0000" selected="selected">전체선택</option>
	                                            </select>
	                                        </div>
										</div>
										<div class="divider divider-sm in"></div>
	                                	<div class="form-group row">
	                                        <div class="col-xs-6">
	                                            <label>[국공유재산]</label>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fs_gb_02"/>&nbsp;<label for="fs_gb_02">국유지</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fs_gb_04"/>&nbsp;<label for="fs_gb_04">시유지</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fs_gb_05"/>&nbsp;<label for="fs_gb_05">구유지</label></div></div>
	                                        </div>
	                                        <div class="col-xs-6">
	                                            <label>[기타]</label>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fs_gb_00"/>&nbsp;<label for="fs_gb_00">일본인&amp;창씨명등</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fs_gb_01"/>&nbsp;<label for="fs_gb_01">개인</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fs_gb_03"/>&nbsp;<label for="fs_gb_03">외국인&amp;외국공공기관</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fs_gb_06"/>&nbsp;<label for="fs_gb_06">법인</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fs_gb_07"/>&nbsp;<label for="fs_gb_07">종중</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fs_gb_08"/>&nbsp;<label for="fs_gb_08">종교단체</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fs_gb_09"/>&nbsp;<label for="fs_gb_09">기타단체</label></div></div>
	                                       </div>
										</div>

	                                </div>
	                            </div>

							</form>
                        </div>
                    </div>
                    <!-- End Tab-01 -->

                    <!-- Tab-02 건물 변경으로 인한 주석 -->
                    <%-- <div role="tabpanel" class="tab-pane search-result-list" id="tab-02">
                        <div class="list-group-wrap in-asset">
	                        <form id="tab-02_Form" name="tab-02_Form"  onsubmit="return false;" >
	                            <div id="buld-basiclist">
	                                <div class="list-group">
	                                    <div class="form-group row">
											<div class="col-xs-6">
	                                           	<label for="fn_sig">시군구</label>
	                                            <select class="form-control chosen" id="fn_sig">
	                                            	<option value="0000" selected="selected">전체선택</option>
	                                                <c:forEach var="result" items="${SIGList}" varStatus="status">
														<option value='<c:out value="${result.sig_cd}"/>'><c:out value="${result.sig_kor_nm}"/></option>
													</c:forEach>
	                                            </select>
	                                        </div>
	                                        <div class="col-xs-6">
	                                           	<label for="fn_emd">읍면동</label>
	                                            <select class="form-control chosen" id="fn_emd">
	                                                <option value="0000" selected="selected">전체선택</option>
	                                            </select>
	                                        </div>
										</div>
										<div class="divider divider-sm in"></div>
	                                	<div class="form-group row">
	                                		<div class="col-xs-6">
	                                            <label>[주거]</label>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_01000"/>&nbsp;<label for="fn_gb_01000">단독주택</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_02000"/>&nbsp;<label for="fn_gb_02000">공동주택</label></div></div>
	                                            <label>[상세 입력]</label>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="text" id="fn_gbname"/></div></div>
	                                        </div>
	                                        <div class="col-xs-6">
	                                            <label>[비주거]</label>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_03000"/>&nbsp;<label for="fn_gb_03000">제1종근린생활시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_04000"/>&nbsp;<label for="fn_gb_04000">제2종근린생활시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_05000"/>&nbsp;<label for="fn_gb_05000">문화 및 집회시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_06000"/>&nbsp;<label for="fn_gb_06000">종교시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_07000"/>&nbsp;<label for="fn_gb_07000">판매시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_08000"/>&nbsp;<label for="fn_gb_08000">운수시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_09000"/>&nbsp;<label for="fn_gb_09000">의료시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_10000"/>&nbsp;<label for="fn_gb_10000">교육연구시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_11000"/>&nbsp;<label for="fn_gb_11000">노유자시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_12000"/>&nbsp;<label for="fn_gb_12000">수련시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_13000"/>&nbsp;<label for="fn_gb_13000">운동시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_14000"/>&nbsp;<label for="fn_gb_14000">업무시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_15000"/>&nbsp;<label for="fn_gb_15000">숙박시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_16000"/>&nbsp;<label for="fn_gb_16000">위락시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_17000"/>&nbsp;<label for="fn_gb_17000">공장</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_18000"/>&nbsp;<label for="fn_gb_18000">창고시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_19000"/>&nbsp;<label for="fn_gb_19000">위험물저장및처리시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_20000"/>&nbsp;<label for="fn_gb_20000">자동차관련시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_21000"/>&nbsp;<label for="fn_gb_21000">동.식물관련시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_22000"/>&nbsp;<label for="fn_gb_22000">분뇨.쓰레기처리시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_23000"/>&nbsp;<label for="fn_gb_23000">교정및군사시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_24000"/>&nbsp;<label for="fn_gb_24000">방송통신시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_25000"/>&nbsp;<label for="fn_gb_25000">발전시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_26000"/>&nbsp;<label for="fn_gb_26000">묘지관련시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_27000"/>&nbsp;<label for="fn_gb_27000">관광휴게시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_28000"/>&nbsp;<label for="fn_gb_28000">가설건축물</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_29000"/>&nbsp;<label for="fn_gb_29000">장례시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_30000"/>&nbsp;<label for="fn_gb_30000">자원순환관련시설</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fn_gb_Z0000"/>&nbsp;<label for="fn_gb_Z0000">기타</label></div></div>
	                                       </div>
										</div>
	                                </div>
	                            </div>
							</form>
                        </div>
                    </div> --%>
                    <!-- End Tab-02 -->

                    <!-- Old Tab-03 -->
                    <div role="tabpanel" class="tab-pane search-result-list" id="tab-03">
                        <div class="list-group-wrap in-asset">
	                        <form id="tab-03_Form" name="tab-03_Form"  onsubmit="return false;" >
	                            <div id="dist-basiclist">
	                                <div class="list-group">
	                                	<div class="form-group row" style="display: none;">
											<div class="col-xs-6">
	                                           	<label for="fg_sig">시군구</label>
	                                            <select class="form-control input-sm" id="fg_sig">
	                                            	<option value="0000" selected="selected">전체선택</option>
	                                                <c:forEach var="result" items="${SIGList}" varStatus="status">
														<option value='<c:out value="${result.sig_cd}"/>'><c:out value="${result.sig_kor_nm}"/></option>
													</c:forEach>
	                                            </select>
	                                        </div>
	                                        <div class="col-xs-6">
	                                           	<label for="fg_emd">읍면동</label>
	                                            <select class="form-control chosen" id="fg_emd">
	                                                <option value="0000" selected="selected">전체선택</option>
	                                            </select>
	                                        </div>
										</div>
										<div class="divider divider-sm in" style="display: none;"></div>
	                                	<div class="form-group row">
	                                       	<div class="col-xs-6">
	                                       		<label>[사업지구]</label>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_01"/>&nbsp;<label for="fg_gb_01">우면2(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_02"/>&nbsp;<label for="fg_gb_02">발산(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_03"/>&nbsp;<label for="fg_gb_03">신정3(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_04"/>&nbsp;<label for="fg_gb_04">장지(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_05"/>&nbsp;<label for="fg_gb_05">강일2(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_06"/>&nbsp;<label for="fg_gb_06">강일(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_07"/>&nbsp;<label for="fg_gb_07">문정(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_08"/>&nbsp;<label for="fg_gb_08">상계 장암(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_09"/>&nbsp;<label for="fg_gb_09">내곡(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_10"/>&nbsp;<label for="fg_gb_10">마천(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_11"/>&nbsp;<label for="fg_gb_11">세곡(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_12"/>&nbsp;<label for="fg_gb_12">세곡2(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_13"/>&nbsp;<label for="fg_gb_13">신내2(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_14"/>&nbsp;<label for="fg_gb_14">신내3(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_15"/>&nbsp;<label for="fg_gb_15">신정4(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_16"/>&nbsp;<label for="fg_gb_16">천왕2(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_19"/>&nbsp;<label for="fg_gb_19">은평(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_20"/>&nbsp;<label for="fg_gb_20">천왕(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_21"/>&nbsp;<label for="fg_gb_21">상암2(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_23"/>&nbsp;<label for="fg_gb_23">오금(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_24"/>&nbsp;<label for="fg_gb_24">개포 구룡마을(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_25"/>&nbsp;<label for="fg_gb_25">고덕강일(데이터 준비중)</label></div></div>
	                                            <div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_26"/>&nbsp;<label for="fg_gb_26">장월(데이터 준비중)</label></div></div>
									        </div>
									        <div class="col-xs-6">
	                                       		<label>&nbsp;&nbsp;</label>
	                                       		<div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_22"/>&nbsp;<label for="fg_gb_22">마곡</label></div></div>
	                                       		<div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_18"/>&nbsp;<label for="fg_gb_18">위례(데이터 준비중)</label></div></div>
	                                       		<div class="form-group row"><div class="col-xs-12"><input type="checkbox" id="fg_gb_17"/>&nbsp;<label for="fg_gb_17">항동(데이터 준비중)</label></div></div>
	                                       	</div>
										</div>
	                                </div>
	                            </div>
							</form>
                        </div>
                    </div>
                    <!-- End Old Tab-03 -->

					<!-- 2020 추가 -->
                    <!-- Tab-04 -->
                    <div role="tabpanel" class="tab-pane search-result-list" id="tab-04">
                        <div class="list-group-wrap in-asset">
                        	<!-- <div class="menu_sub_tit">검색 조건</div> -->
	                        <form id="tab-04_Form" name="tab-04_Form"  onsubmit="return false;" >
	                        	<div id="dist-basiclist">
	                            	<div class="list-group">
	                                	<div class="form-group row">
											<div class="col-xs-6">
	                                           	<label for="search_type">검색항목</label>
					                         	<select class="form-control input-sm" id="search_type" name="search_type">
					                            	<option value="SITE">용지관리</option>
					                                <option value="LICENS">인허가</option>
					                                <option value="UNSALE_PAPR">미매각지</option>
					                                <option value="REMNDR_PAPR" selected>잔여지</option>
					                            </select>
            								</div>
										</div>
										<div id='item4_site' style='display: block;'>
		                                	<!-- <div class="form-group">
			                                	<label>사업명</label>
												<div class="input_textarea"><input type="text" name="bsns_nm" id="bsns_nm" placeholder="사업명을 입력해주세요." class="ui-autocomplete-input" autocomplete="off"></div>
											</div>
											<div class="form-group">
												<label>위치</label>
												<div class="input_textarea"><input type="text" name="lc_lnm" id="lc_lnm" placeholder="주소를 입력해주세요." class="ui-autocomplete-input" autocomplete="off"></div>
		                                	</div> -->
											<div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
		                                           	<label for="">사업명</label>
		                                            <select class="form-control input-sm" name="bsns_nm" id="bsns_nm">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
											     <div class="float_textarea_wrap float_right_wrap">
													<label>위치</label>
													<div><input type="text" name="lc_lnm" id="lc_lnm" placeholder="주소를 입력해주세요." class="ui-autocomplete-input input_textarea half_input_textarea" autocomplete="off"></div>
												</div>
											</div>
											<div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
													<label>사업코드</label>
													<div><input type="text" name="bsns_code" id="bsns_code" placeholder="사업코드를 입력해주세요." class="ui-autocomplete-input input_textarea half_input_textarea" autocomplete="off"></div>
												</div>
											    <div class="float_textarea_wrap float_right_wrap">
													<label>필지(블록)</label>
													<div><input type="text" name="lndpcl_blck" id="lndpcl_blck" placeholder="블록정보를 입력해주세요." class="ui-autocomplete-input input_textarea half_input_textarea" autocomplete="off"></div>
												</div>
		                                	</div>
		                                	<div class="form-group row">
												<div class="col-xs-6">
		                                           	<label for="">용도명</label>
		                                            <select class="form-control input-sm" name="prpos_nm" id="prpos_nm">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
		                                        <div class="col-xs-6">
		                                           	<label for="">상태</label>
		                                            <select class="form-control input-sm" name="sttus" id="sttus">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
											</div>
											<div class="form-group row">
												<div class="col-xs-6">
		                                           	<label for="">지목</label>
		                                            <select class="form-control input-sm" name="lndcgr" id="lndcgr">
		                                            	<option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
		                                        <div class="col-xs-6">
		                                           	<label for="">용도지역</label>
		                                            <select class="form-control input-sm" name="spfc" id="spfc">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
											</div>
										</div>
										<div id='item4_licens' style='display: none;'>
		                                	<!-- <div class="form-group">
			                                	<label>사업명</label>
												<div class="input_textarea"><input type="text" name="bsns_nm" id="bsns_nm" placeholder="사업명을 입력해주세요." class="ui-autocomplete-input" autocomplete="off"></div>
											</div> -->
											<div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
		                                           	<label for="">사업명</label>
		                                            <select class="form-control input-sm" name="bsns_nm" id="bsns_nm">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
												<div class="float_textarea_wrap float_right_wrap">
													<label>용지구분</label>
													<div><input type="text" name="se" id="se" placeholder="용지구분을 입력해주세요." class="ui-autocomplete-input input_textarea half_input_textarea" autocomplete="off"></div>
												</div>
											</div>
											<div class="form-group clearfix">
											    <div class="float_textarea_wrap float_left_wrap">
													<label>필지(블록)</label>
													<div><input type="text" name="lndpcl" id="lndpcl" placeholder="블록정보를 입력해주세요." class="ui-autocomplete-input input_textarea half_input_textarea" autocomplete="off"></div>
												</div>
												<div class="float_textarea_wrap float_right_wrap">
													<label>공급유형</label>
		                                            <select class="form-control input-sm" name="suply_ty" id="suply_ty">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
												</div>
		                                	</div>
											<div class="form-group clearfix">
											    <div class="float_textarea_wrap float_left_wrap">
													<label>용도명</label>
		                                            <select class="form-control input-sm" name="prpos" id="prpos">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
												</div>
												<div class="float_textarea_wrap float_right_wrap">
													<label>면적㎥(총면적)</label>
													<div>
														<input type="text" name="tot_ar1" id="tot_ar1" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
														<span style="display:block; margin:0 1rem; float:left; line-height:30px;">~</span>
														<input type="text" name="tot_ar2" id="tot_ar2" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													</div>
												</div>
		                                	</div>
										</div>
										<div id='item4_unsale_papr' style='display: none;'>
		                                	<!-- <div class="form-group">
			                                	<label>사업명</label>
												<div class="input_textarea"><input type="text" name="bsns_nm" id="bsns_nm" placeholder="사업명을 입력해주세요." class="ui-autocomplete-input" autocomplete="off"></div>
											</div> -->
											<div class="form-group clearfix">
												<!-- <div class="float_textarea_wrap float_left_wrap">
													<label>필지명</label>
													<div><input type="text" name="lndpcl_nm" id="lndpcl_nm" placeholder="팔지명을 입력해주세요." class="ui-autocomplete-input input_textarea half_input_textarea" autocomplete="off"></div>
												</div> -->
												<div class="float_textarea_wrap float_left_wrap">
													<label>지구명</label>
		                                            <select class="form-control input-sm" name="dstrc_nm" id="dstrc_nm">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
												</div>
											    <div class="float_textarea_wrap float_right_wrap">
													<label>위치</label>
													<div><input type="text" name="lc" id="lc" placeholder="위치를 입력해주세요." class="ui-autocomplete-input input_textarea half_input_textarea" autocomplete="off"></div>
												</div>
		                                	</div>
											<div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
		                                           	<label for="">판매방법</label>
		                                            <select class="form-control input-sm" name="sle_mth" id="sle_mth">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
												<div class="float_textarea_wrap float_right_wrap">
		                                           	<label for="">가격기준</label>
		                                            <select class="form-control input-sm" name="pc_stdr" id="pc_stdr">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
		                                    </div>
											<div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
		                                           	<label for="">공급대상기준</label>
		                                            <select class="form-control input-sm" name="suply_trget_stdr" id="suply_trget_stdr">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>

		                                        </div>
												<div class="float_textarea_wrap float_right_wrap">
		                                           	<label for="">용도지역</label>
		                                            <select class="form-control input-sm" name="spfc" id="spfc">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
		                                    </div>
											<div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
													<label>대상면적(㎥)</label>
													<div>
														<input type="text" name="trget_ar1" id="trget_ar1" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
														<span style="display:block; margin:0 1rem; float:left; line-height:30px;">~</span>
														<input type="text" name="trget_ar2" id="trget_ar2" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													</div>
		                                        </div>
												<div class="float_textarea_wrap float_right_wrap">
													<label>매각면적(㎥)</label>
													<div>
														<input type="text" name="sale_ar1" id="sale_ar1" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
														<span style="display:block; margin:0 1rem; float:left; line-height:30px;">~</span>
														<input type="text" name="sale_ar2" id="sale_ar2" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													</div>
												</div>
											</div>
										</div>
										<div id='item4_remndr_papr' style='display: none;'>
											<div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
		                                           	<label for="">자치구</label>
		                                            <select class="form-control input-sm" name="cmptnc_gu" id="cmptnc_gu">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
												<div class="float_textarea_wrap float_right_wrap">
		                                           	<label for="">관할센터</label>
		                                            <select class="form-control input-sm" name="cmptnc_cnter" id="cmptnc_cnter">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
		                                	</div>
											<div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
		                                           	<label for="">지목</label>
		                                            <select class="form-control input-sm" name="lndcgr" id="lndcgr">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
											    <div class="float_textarea_wrap float_right_wrap">
													<label>위치</label>
													<div><input type="text" name="lnm" id="lnm" placeholder="동과 지번을 입력해주세요." class="ui-autocomplete-input input_textarea half_input_textarea" autocomplete="off"></div>
												</div>
		                                    </div>
											<div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
													<label>면적㎥(총면적)</label>
													<div>
													<input type="text" name="trget_ar1" id="trget_ar1" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													<span style="display:block; margin:0 1rem; float:left; line-height:30px;">~</span>
													<input type="text" name="trget_ar2" id="trget_ar2" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													</div>
												</div>
	                                        </div>
										</div>
	                                </div>
	                        	</div>
							</form>
                        </div>
                    </div>
                    <!-- End Tab-04 -->

                   <!-- Tab-05 -->
                    <div role="tabpanel" class="tab-pane search-result-list" id="tab-05">
                        <div class="list-group-wrap in-asset">
							<!-- <div class="menu_sub_tit">검색 조건</div> -->
							<form id="tab-05_Form" name="tab-05_Form" onsubmit="return false;">
		                        <div id="dist-basiclist">
			                         <div class="list-group">
	                                	<div class="form-group row">
											<div class="col-xs-6">
	                                           	<label for="search_type">검색항목</label>
					                         	<select class="form-control input-sm" id="search_type" name="search_type">
	                                            	<option value="APT">아파트 단지</option>
	                                            	<option value="MLTDWL">다가구</option>
	                                            	<option value="CTY_LVLH">도시형생활주택</option>
	                                            	<option value="LFSTS_RENT">전세임대</option>
	                                            	<option value="LNGTR_SAFETY" selected>장기안심</option>
					                            </select>
            								</div>
										</div>
										<div id='item5_apt' style='display: block;'>
											<div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
			                                		<label>단지명</label>
													<div class="input_textarea"><input type="text" name="hsmp_nm" id="hsmp_nm" placeholder="단지명을 입력해주세요." class="ui-autocomplete-input" autocomplete="off"></div>
												</div>
												<div class="float_textarea_wrap float_right_wrap">
		                                           	<label for="bsns_code">단지명 선택</label>
		                                            <select class="form-control input-sm" name="hsmp_nm_opt" id="hsmp_nm_opt">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
												</div>
											</div>
											<div class="form-group row">
		                                        <div class="col-xs-6">
		                                           	<label for="rent_se">임대구분</label>
		                                            <select class="form-control input-sm" name="rent_se" id="rent_se">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
												<div class="col-xs-6">
		                                           	<label for="rent_ty">임대유형</label>
		                                            <select class="form-control input-sm" name="rent_ty" id="rent_ty">
														<option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
											</div>
											<div class="form-group row">
												<div class="col-xs-6">
		                                           	<label for="se">구분</label>
		                                            <select class="form-control input-sm" name="se" id="se">
		                                            	<option value="0000" selected="selected">전체선택</option>

		                                            </select>
		                                        </div>
		                                        <div class="col-xs-6">
		                                           	<label for="atdrc">자치구</label>
		                                            <select class="form-control input-sm" name="atdrc" id="atdrc">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
											</div>
											<div class="form-group row">
												<div class="col-xs-6">
		                                           	<label for="cnter">센터</label>
		                                            <select class="form-control input-sm" name="cnter" id="cnter">
		                                            	<option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
		                                        <div class="float_textarea_wrap float_right_wrap">
													<label>공급일</label>
													<div class="input-group date datetimepickerStart " style="max-width:200px;">
	                                         			<input class="form-control input-group-addon m-b-0" title="공급일" name="suply_de1" id="suply_de1" placeholder="공급일을 선택하세요" style="padding: 0; height:30px;">
	                                             		<span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
	                                         		</div>
												</div>
											</div>
											<div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
													<label>총동수</label>
													<div>
													<input type="text" name="aptcmpl_sm1" id="aptcmpl_sm1" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													<span style="display:block; margin:0 1rem; float:left; line-height:30px;">~</span>
													<input type="text" name="aptcmpl_sm2" id="aptcmpl_sm2" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													</div>
												</div>
												<div class="float_textarea_wrap float_right_wrap">
													<label>임대세대수</label>
													<div>
													<input type="text" name="rent_hshld_co1" id="rent_hshld_co1" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													<span style="display:block; margin:0 1rem; float:left; line-height:30px;">~</span>
													<input type="text" name="rent_hshld_co2" id="rent_hshld_co2" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													</div>
												</div>
											</div>
										</div>
										<div id='item5_mltdwl' style='display: none;'>
											<div class="form-group row">
												<div class="col-xs-6">
													<label>주소</label>
													<div class="input_textarea"><input type="text" name="adres" id="adres" placeholder="주소를 입력해주세요." class="ui-autocomplete-input" autocomplete="off"></div>
												</div>
												<div class="col-xs-6">
													<label> </label>
													<div class="input_textarea">‘자치구부터 기입’</div>
												</div>
		                                	</div>
											<!-- <div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
				                                	<label>사업명</label>
													<div class="input_textarea"><input type="text" name="bsns_nm" id="bsns_nm" placeholder="사업명을 입력해주세요." class="ui-autocomplete-input" autocomplete="off"></div>
												</div>
												<div class="float_textarea_wrap float_right_wrap">
		                                           	<label for="bsns_code">사업명 선택</label>
		                                            <select class="form-control input-sm" name="bsns_nm_opt" id="bsns_nm_opt">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
												</div>
											</div> -->
											<div class="form-group clearfix">
												<!-- <div class="float_textarea_wrap float_left_wrap">
													<label>사업코드</label>
													<div><input type="text" name="bsns_code" id="bsns_code" placeholder="사업코드를 입력해주세요." class="ui-autocomplete-input input_textarea half_input_textarea" autocomplete="off"></div>
												</div> -->
		                                        <div class="float_textarea_wrap float_left_wrap">
		                                           	<label for="bsns_code">사업코드</label>
		                                            <select class="form-control input-sm" name="bsns_code" id="bsns_code">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
											    <div class="float_textarea_wrap float_right_wrap">
													<label>동</label>
		                                            <select class="form-control input-sm" name="dong" id="dong">
		                                            	<option value="0000" selected="selected">전체선택</option>
		                                            </select>
												</div>
		                                	</div>
											<div class="form-group row">
		                                        <div class="col-xs-6">
		                                           	<label for="atdrc">자치구</label>
		                                            <select class="form-control input-sm" name="atdrc" id="atdrc">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
												<div class="col-xs-6">
		                                           	<label for="cnter">센터</label>
		                                            <select class="form-control input-sm" name="cnter" id="cnter">
		                                            	<option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
		                                	</div>
											<div class="form-group clearfix">
		                                        <div class="float_textarea_wrap float_left_wrap">
		                                           	<label for="buld_strct">건물구조</label>
		                                            <select class="form-control input-sm" name="buld_strct" id="buld_strct">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
												<div class="float_textarea_wrap float_right_wrap">
													<label>연면적</label>
													<div>
													<input type="text" name="bildng_totar1" id="bildng_totar1" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													<span style="display:block; margin:0 1rem; float:left; line-height:30px;">~</span>
													<input type="text" name="bildng_totar2" id="bildng_totar2" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													</div>
												</div>
		                                	</div>
											<div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
													<label>전용면적</label>
													<div>
													<input type="text" name="prvuse_ar1" id="prvuse_ar1" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													<span style="display:block; margin:0 1rem; float:left; line-height:30px;">~</span>
													<input type="text" name="prvuse_ar2" id="prvuse_ar2" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													</div>
												</div>
												<div class="float_textarea_wrap float_right_wrap">
													<label>대지면적</label>
													<div>
													<input type="text" name="plot_ar1" id="plot_ar1" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													<span style="display:block; margin:0 1rem; float:left; line-height:30px;">~</span>
													<input type="text" name="plot_ar2" id="plot_ar2" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													</div>
												</div>
		                                	</div>
											<div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
													<label>전체세대수</label>
													<div>
													<input type="text" name="hshld_co1" id="hshld_co1" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													<span style="display:block; margin:0 1rem; float:left; line-height:30px;">~</span>
													<input type="text" name="hshld_co2" id="hshld_co2" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													</div>
												</div>
		                                        <div class="float_textarea_wrap float_right_wrap">
													<label>준공일자</label>
													<div class="input-group date datetimepickerStart " style="max-width:200px;">
	                                         			<input class="form-control input-group-addon m-b-0" title="" name="compet_de2" id="compet_de2" placeholder="준공일을 선택하세요" style="padding: 0; height:30px;">
	                                             		<span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
	                                         		</div>
												</div>
											</div>
										</div>
										<div id='item5_cty_lvlh' style='display: none;'>
											<div class="form-group row">
												<div class="col-xs-6">
													<label>주소</label>
													<div class="input_textarea"><input type="text" name="adres" id="adres" placeholder="주소를 입력해주세요." class="ui-autocomplete-input" autocomplete="off"></div>
												</div>
												<div class="col-xs-6">
													<label> </label>
													<div class="input_textarea">‘자치구부터 기입’</div>
												</div>
		                                	</div>
											<!-- <div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
				                                	<label>사업명</label>
													<div class="input_textarea"><input type="text" name="bsns_nm" id="bsns_nm" placeholder="사업명을 입력해주세요." class="ui-autocomplete-input" autocomplete="off"></div>
												</div>
												<div class="float_textarea_wrap float_right_wrap">
		                                           	<label for="bsns_code">사업명 선택</label>
		                                            <select class="form-control input-sm" name="bsns_nm_opt" id="bsns_nm_opt">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
												</div>
											</div> -->
											<div class="form-group clearfix">
												<!-- <div class="float_textarea_wrap float_left_wrap">
													<label>사업코드</label>
													<div><input type="text" name="bsns_code" id="bsns_code" placeholder="사업코드를 입력해주세요." class="ui-autocomplete-input input_textarea half_input_textarea" autocomplete="off"></div>
												</div> -->
		                                        <div class="float_textarea_wrap float_left_wrap">
		                                           	<label for="bsns_code">사업코드</label>
		                                            <select class="form-control input-sm" name="bsns_code" id="bsns_code">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
											    <div class="float_textarea_wrap float_right_wrap">
													<label>동</label>
		                                            <select class="form-control input-sm" name="dong" id="dong">
		                                            	<option value="0000" selected="selected">전체선택</option>
		                                            </select>
												</div>
		                                	</div>
											<div class="form-group row">
		                                        <div class="col-xs-6">
		                                           	<label for="atdrc">자치구</label>
		                                            <select class="form-control input-sm" name="atdrc" id="atdrc">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
												<div class="col-xs-6">
		                                           	<label for="cnter">센터</label>
		                                            <select class="form-control input-sm" name="cnter" id="cnter">
		                                            	<option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
		                                	</div>
											<div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
													<label>전체세대수</label>
													<div>
													<input type="text" name="tot_hshld_co1" id="tot_hshld_co1" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													<span style="display:block; margin:0 1rem; float:left; line-height:30px;">~</span>
													<input type="text" name="tot_hshld_co2" id="tot_hshld_co2" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													</div>
												</div>
												<div class="float_textarea_wrap float_right_wrap">
													<label>전체동수</label>
													<div>
													<input type="text" name="TOT_APTCMPL_CO1" id="TOT_APTCMPL_CO1" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													<span style="display:block; margin:0 1rem; float:left; line-height:30px;">~</span>
													<input type="text" name="TOT_APTCMPL_CO2" id="TOT_APTCMPL_CO2" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													</div>
												</div>
											</div>
											<div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
													<label>준공일자</label>
													<div class="input-group date datetimepickerStart " style="max-width:200px;">
	                                         			<input class="form-control input-group-addon m-b-0" title="" name="compet_de3" id="compet_de3" placeholder="준공일을 선택하세요" style="padding: 0; height:30px;">
	                                             		<span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
	                                         		</div>
												</div>
		                                        <div class="float_textarea_wrap float_right_wrap">
													<label>매입일자</label>
													<div class="input-group date datetimepickerStart " style="max-width:200px;">
	                                         			<input class="form-control input-group-addon m-b-0" title="" name="puchas_de3" id="puchas_de3" placeholder="매입일을 선택하세요" style="padding: 0; height:30px;">
	                                             		<span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
	                                         		</div>
												</div>
											</div>
											<!-- <div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
													<label>공급일자</label>
													<div class="input-group date datetimepickerStart " style="max-width:200px;">
	                                         			<input class="form-control input-group-addon m-b-0" title="" name="suply_de3" id="suply_de3" placeholder="공급일을 선택하세요" style="padding: 0; height:30px;">
	                                             		<span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
	                                         		</div>
												</div>
											</div> -->
										</div>
										<div id='item5_lfsts_rent' style='display: none;'>
		                                	<!-- <div class="form-group">
			                                	<label>사업명</label>
												<div class="input_textarea"><input type="text" name="bsns_nm" id="bsns_nm" placeholder="사업명을 입력해주세요." class="ui-autocomplete-input" autocomplete="off"></div>
											</div> -->
											<div class="form-group">
												<label>주소</label>
												<div class="input_textarea"><input type="text" name="adres" id="adres" placeholder="주소를 입력해주세요." class="ui-autocomplete-input" autocomplete="off"></div>
		                                	</div>
											<!-- <div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
													<label>사업코드</label>
													<div><input type="text" name="bsns_code" id="bsns_code" placeholder="사업코드를 입력해주세요." class="ui-autocomplete-input input_textarea half_input_textarea" autocomplete="off"></div>
												</div>
											    <div class="float_textarea_wrap float_right_wrap">
													<label>동</label>
		                                            <select class="form-control input-sm" name="dong" id="dong">
		                                            	<option value="0000" selected="selected">전체선택</option>
		                                            </select>
												</div>
		                                	</div> -->
											<div class="form-group row">
		                                        <div class="col-xs-6">
		                                           	<label for="atdrc">자치구</label>
		                                            <select class="form-control input-sm" name="atdrc" id="atdrc">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
												<div class="col-xs-6">
		                                           	<label for="cnter">센터</label>
		                                            <select class="form-control input-sm" name="cnter" id="cnter">
		                                            	<option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
		                                	</div>
											<div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
													<label>면적</label>
													<div>
													<input type="text" name="ar1" id="ar1" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													<span style="display:block; margin:0 1rem; float:left; line-height:30px;">~</span>
													<input type="text" name="ar2" id="ar2" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													</div>
												</div>
												<div class="float_textarea_wrap float_right_wrap">
													<label>세대수</label>
													<div>
													<input type="text" name="hshld_co1" id="hshld_co1" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													<span style="display:block; margin:0 1rem; float:left; line-height:30px;">~</span>
													<input type="text" name="hshld_co2" id="hshld_co2" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													</div>
												</div>
											</div>
											<div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
													<label>계약일</label>
													<div class="input-group date datetimepickerStart " style="max-width:200px;">
	                                         			<input class="form-control input-group-addon m-b-0" title="" name="cntrct_de4" id="cntrct_de4" placeholder="계약일을 선택하세요" style="padding: 0; height:30px;">
	                                             		<span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
	                                         		</div>
												</div>
		                                        <div class="float_textarea_wrap float_right_wrap">
													<label>입주일</label>
													<div class="input-group date datetimepickerStart " style="max-width:200px;">
	                                         			<input class="form-control input-group-addon m-b-0" title="" name="mvn_de4" id="mvn_de4" placeholder="입주일을 선택하세요" style="padding: 0; height:30px;">
	                                             		<span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
	                                         		</div>
												</div>
											</div>
										</div>
										<div id='item5_lngtr_safety' style='display: none;'>
		                                	<!-- <div class="form-group">
			                                	<label>사업명</label>
												<div class="input_textarea"><input type="text" name="bsns_nm" id="bsns_nm" placeholder="사업명을 입력해주세요." class="ui-autocomplete-input" autocomplete="off"></div>
											</div> -->
											<div class="form-group">
												<label>주소</label>
												<div class="input_textarea"><input type="text" name="adres" id="adres" placeholder="주소를 입력해주세요." class="ui-autocomplete-input" autocomplete="off"></div>
		                                	</div>
											<div class="form-group clearfix">
												<!-- <div class="float_textarea_wrap float_left_wrap">
													<label>사업코드</label>
													<div><input type="text" name="bsns_code" id="bsns_code" placeholder="사업코드를 입력해주세요." class="ui-autocomplete-input input_textarea half_input_textarea" autocomplete="off"></div>
												</div> -->
		                                        <div class="float_textarea_wrap float_left_wrap">
		                                           	<label for="bsns_code">사업코드</label>
		                                            <select class="form-control input-sm" name="bsns_code" id="bsns_code">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
											    <div class="float_textarea_wrap float_right_wrap">
													<label>동</label>
		                                            <select class="form-control input-sm" name="dong" id="dong">
		                                            	<option value="0000" selected="selected">전체선택</option>
		                                            </select>
												</div>
		                                	</div>
											<div class="form-group row">
		                                        <div class="col-xs-6">
		                                           	<label for="atdrc">자치구</label>
		                                            <select class="form-control input-sm" name="atdrc" id="atdrc">
		                                                <option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
												<div class="col-xs-6">
		                                           	<label for="cnter">센터</label>
		                                            <select class="form-control input-sm" name="cnter" id="cnter">
		                                            	<option value="0000" selected="selected">전체선택</option>
		                                            </select>
		                                        </div>
		                                	</div>
											<div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
													<label>면적</label>
													<div>
													<input type="text" name="ar1" id="ar1" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													<span style="display:block; margin:0 1rem; float:left; line-height:30px;">~</span>
													<input type="text" name="ar2" id="ar2" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													</div>
												</div>
												<div class="float_textarea_wrap float_right_wrap">
													<label>세대수</label>
													<div>
													<input type="text" name="hshld_co1" id="hshld_co1" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													<span style="display:block; margin:0 1rem; float:left; line-height:30px;">~</span>
													<input type="text" name="hshld_co2" id="hshld_co2" placeholder="0" class="ui-autocomplete-input input_textarea half2_input_textarea" autocomplete="off">
													</div>
												</div>
											</div>
											<div class="form-group clearfix">
												<div class="float_textarea_wrap float_left_wrap">
													<label>계약일</label>
													<div class="input-group date datetimepickerStart " style="max-width:200px;">
	                                         			<input class="form-control input-group-addon m-b-0" title="" name="cntrct_de5" id="cntrct_de5" placeholder="계약일을 선택하세요" style="padding: 0; height:30px;">
	                                             		<span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
	                                         		</div>
												</div>
		                                        <div class="float_textarea_wrap float_right_wrap">
													<label>입주일</label>
													<div class="input-group date datetimepickerStart " style="max-width:200px;">
	                                         			<input class="form-control input-group-addon m-b-0" title="" name="mvn_de5" id="mvn_de5" placeholder="입주일을 선택하세요" style="padding: 0; height:30px;">
	                                             		<span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
	                                         		</div>
												</div>
											</div>
										</div>
									</div>
			                    </div>
                        	</form>
                    	</div>
                    </div>
                     <!-- End Tab-05 -->

                    <!-- Tab-06 -->
                    <div role="tabpanel" class="tab-pane search-result-list" id="tab-06">
                        <div class="list-group-wrap in-asset">
	                        <!-- <div class="menu_sub_tit">검색 조건</div> -->
							<form id="tab-06_Form" name="tab-06_Form" onsubmit="return false;">
		                        <div id="dist-basiclist">
			                    	<div class="list-group">
	                                	<div class="form-group row">
											<div class="col-xs-6">
	                                           	<label for="search_type">검색항목</label>
					                         	<select class="form-control input-sm" id="search_type" name="search_type">
	                                            	<option value="ASSET_APT">자산대장 아파트</option>
	                                            	<option value="ASSET_MLTDWL">자산대장 다가구</option>
	                                            	<option value="ASSET_ETC">자산대장 기타</option>
					                            </select>
            								</div>
										</div>
	                                	<div class="form-group">
	                                		<label>자산명</label>
											<div class="input_textarea"><input type="text" name="assets_nm" id="assets_nm" placeholder="자산명을 입력해주세요." class="ui-autocomplete-input" autocomplete="off"></div>
										</div>
										<div class="form-group row">
											<div class="col-xs-6">
	                                           	<label for="assets_cl">자산분류</label>
	                                            <select class="form-control input-sm" name="assets_cl" id="assets_cl">
	                                            	<option value="" selected="selected">전체선택</option>
	                                            </select>
	                                        </div>
	                                        <div class="col-xs-6">
	                                           	<label for="prdlst_cl">품목분류</label>
	                                            <select class="form-control input-sm" name="prdlst_cl" id="prdlst_cl">
	                                                <option value="" selected="selected">전체선택</option>
	                                            </select>
	                                        </div>
										</div>
										<div class="form-group row">
											<div class="col-xs-6">
	                                           	<label for="bsns_code">사업코드</label>
	                                            <select class="form-control input-sm" name="bsns_code" id="bsns_code">
	                                            	<option value="" selected="selected">전체선택</option>

	                                            </select>
	                                        </div>
	                                        <div class="col-xs-6">
	                                           	<label for="stndrd">규격</label>
	                                            <select class="form-control input-sm" name="stndrd" id="stndrd">
	                                                <option value="" selected="selected">전체선택</option>
	                                            </select>
	                                        </div>
										</div>
										<div class="form-group row">
											<div class="col-xs-6">
	                                           	<label for="assets_change">자산변동구분</label>
	                                            <select class="form-control input-sm" name="assets_change" id="assets_change">
	                                            	<option value="" selected="selected">전체선택</option>
	                                            </select>
	                                        </div>
	                                        <div class="col-xs-6">
	                                           	<label for="change_dcsn">변동확정일자(년도)</label>
	                                            <select class="form-control input-sm" name="change_dcsn" id="change_dcsn">
	                                                <option value="" selected="selected">전체선택</option>
	                                            </select>
	                                        </div>
										</div>
										<div class="form-group row">
											<div class="col-xs-6">
	                                           	<label for="acqs_de">취득일자(년도)</label>
	                                            <select class="form-control input-sm" name="acqs_de" id="acqs_de">
	                                            	<option value="" selected="selected">전체선택</option>
	                                            </select>
	                                        </div>
	                                        <!-- <div class="col-xs-6">
	                                           	<label for="">관리부서</label>
	                                            <select class="form-control input-sm" name="" id="">
	                                                <option value="0000" selected="selected">전체선택</option>
	                                            </select>
	                                        </div> -->
										</div>
										<!-- <div class="form-group">
											<div class="clearfix">
												<label>총동수</label>
												<div>
													<input type="text" name="" id="" placeholder="0" class="ui-autocomplete-input input_textarea half1_input_textarea" autocomplete="off">
													<span style="display:block; margin:0 1rem; float:left; line-height:30px;">~</span>
													<input type="text" name="" id="" placeholder="0" class="ui-autocomplete-input input_textarea half1_input_textarea" autocomplete="off">
												</div>
											</div>
										</div> -->
									</div>
		                        </div>
		                	</form>
						</div>
					</div>
                    <!-- End Tab-06 -->


                    <!-- 검색조건 Form -->
                    <form id="GISinfoForm" name="GISinfoForm" ></form>

					<div class="btn-wrap tab text-right">
						<button class="btn btn-custom btn-sm text-left" onclick="gis_item()">상세검색</button>
						<select id="cnt_kind" class="btn btn-sm">
							<option value="10">10개씩 보기</option>
							<option value="15">15개씩 보기</option>
							<option value="20">20개씩 보기</option>
							<option value="30">30개씩 보기</option>
							<option value="40">40개씩 보기</option>
							<option value="50">50개씩 보기</option>
						</select>
                        <button class="btn btn-gray btn-sm" onclick="gis_clear();fn_gis_clear_new()">초기화</button>
                        <!-- 기존 -->
                        <!-- <button class="btn btn-teal btn-sm" onclick="gis_sherch(1);">검색</button> -->

                        <!-- 2020 변경 -->
                        <button class="btn btn-teal btn-sm" onclick="gis_sherch(1);fn_gis_sherch_new(1);">검색</button>
                    </div>

					<!-- 검색결과 Form -->
                    <form id="GISinfoResultForm" name="GISinfoResultForm" >
                    	<input type="hidden" name="geom[]">
                    </form>

                </div>
                <!-- End Tab-Content -->

            </div>
        </div>
	</div>
        <!-- End 자산검색 Side-Panel -->




