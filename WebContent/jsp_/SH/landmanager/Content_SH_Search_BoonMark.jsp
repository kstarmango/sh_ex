<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
$(document).ready(function(){
	//열닫 - 즐겨찾기
    $('#bookmark-pop-close').click(function() {
		$('#bookmark-pop').toggleClass('hidden');	
    }); 
	
  	//수정 버튼
	$("button[id^='edit_']").click(function() {
		$(this).parent().parent().parent().parent().removeClass("book-mark");
		$(this).parent().parent().parent().parent().addClass("bookmark-edit-mode");
		
		$(this).parent().parent().parent().addClass("bookmark-item");
		
		$(this).parent().parent().parent().children("div").eq(0).children("span").eq(0).hide();
		$(this).parent().parent().parent().children("div").eq(0).children("span").eq(1).show();
		
		$(this).parent().parent().parent().children("div").eq(1).children("div").eq(0).hide();
		$(this).parent().parent().parent().children("div").eq(1).children("div").eq(1).show();
	});
	//수정 취소 버튼
	$("button[id^='cancle_']").click(function() {
		var text = $(this).parent().parent().parent().children("div").eq(0).children("span").eq(0).text();
		$(this).parent().parent().parent().children("div").eq(0).children("span").eq(1).children("input").val();		
		
		$(this).parent().parent().parent().parent().removeClass("bookmark-edit-mode");
		$(this).parent().parent().parent().parent().addClass("book-mark");
		
		$(this).parent().parent().parent().removeClass("bookmark-item");
		
		$(this).parent().parent().parent().children("div").eq(0).children("span").eq(0).show();
		$(this).parent().parent().parent().children("div").eq(0).children("span").eq(1).hide();
		
		$(this).parent().parent().parent().children("div").eq(1).children("div").eq(0).show();
		$(this).parent().parent().parent().children("div").eq(1).children("div").eq(1).hide();
	});
	//수정 확인 버튼
	$("button[id^='save_']").click(function() {
		var thisEl = $(this);
		var gid = $(this).prop("id").replace("save_", "");
		var nm = $(this).parent().parent().parent().children("div").eq(0).children("span").eq(1).children("input").val();
		if( nm == "" ){ alert("즐겨찾기 명칭을 입력하세요."); return; }
		
		if ( !confirm("현재 설정되어 있는 검색조건으로 등록됩니다.\n수정 하시겠습니까?") ){ return; }		
		
		//검색조건 저장
		save_search();
		
		var params = $("#GISinfoForm").serialize();	
		
		$.ajax({
			type: 'POST',
			url: "/ajaxDB_edit_bookmark.do",
			data: params+"&name="+nm+"&gid="+gid,
			dataType: "json",
			success: function( data ) {	
				thisEl.parent().parent().parent().children("div").eq(0).children("span").eq(1).children("input").val(data.nm[0]);
				thisEl.parent().parent().parent().children("div").eq(0).children("span").eq(0).text(data.nm[0]);
				
				thisEl.parent().parent().parent().parent().removeClass("bookmark-edit-mode");
				thisEl.parent().parent().parent().parent().addClass("book-mark");
				
				thisEl.parent().parent().parent().removeClass("bookmark-item");
				
				thisEl.parent().parent().parent().children("div").eq(0).children("span").eq(0).show();
				thisEl.parent().parent().parent().children("div").eq(0).children("span").eq(1).hide();
				
				thisEl.parent().parent().parent().children("div").eq(1).children("div").eq(0).show();
				thisEl.parent().parent().parent().children("div").eq(1).children("div").eq(1).hide();
			},
			error: function(data, status, er) {
				alert("즐겨찾기 수정이 실패하였습니다.");
	        }
		});	
		
	});
	//수정 삭제 버튼
	$("button[id^='del_']").click(function() {
		var thisEl = $(this);
		var gid = $(this).prop("id").replace("del_", "");
		var nm = $(this).parent().parent().parent().children("div").eq(0).children("span").eq(1).children("input").val();		
		if ( !confirm("[ "+nm+" ] 즐겨찾기를 삭제 하시겠습니까?") ){ return; }		
		
		$.ajax({
			type: 'POST',
			url: "/ajaxDB_delete_bookmark.do",
			data: {gid: gid},
			dataType: "json",
			success: function( data ) {	
				thisEl.parent().parent().parent().parent("li").remove();
			},
			error: function(data, status, er) {
				alert("즐겨찾기 수정이 실패하였습니다.");
	        }
		});	
		
	});
	
});

//열닫 - 즐겨찾기
function bookmark() {		
	$('#bookmark-pop').toggleClass('hidden');
}

//등록버튼
function bookmark_save() {
	//필수입력사항
	var nm = $("#bookmark_nm").val();
	if( nm == "" ){ alert("즐겨찾기 명칭을 입력하세요."); return; }
	
	if ( !confirm("현재 설정되어 있는 검색조건으로 등록됩니다.\n등록 하시겠습니까?") ){ return; }
	
	//검색조건 저장
	save_search();
	
	var params = $("#GISinfoForm").serialize();	
	
	$.ajax({
		type: 'POST',
		url: "/ajaxDB_save_bookmark.do",
		data: params+"&name="+nm,
		dataType: "json",
	    beforeSend: function() {
	        //마우스 커서를 로딩 중 커서로 변경
	        $('html').css("cursor", "wait");
	    },
	    complete: function() {
	        //마우스 커서를 원래대로 돌린다
	        $('html').css("cursor", "auto");
	    },
		success: function( data ) {			 
			var add = 	"<li class=\"list-group-item book-mark\">";
				add +=	"	<div class=\"row bookmark-item\">";
				add +=	"		<div class=\"col-xs-8\">";
				add +=	"			<span class=\"bookmark-item-text\" onclick=\"javascript:agrBookmark('"+data.gid[0]+"');\">"+data.nm[0]+"</span>";
				add +=	"			<span class=\"bookmark-item-text\" style=\"display:none;\">";
				add +=	"				<input type=\"text\" class=\"form-control input-sm\" placeholder=\"즐겨찾기 명칭 입력\" value=\""+data.nm[0]+"\">";
				add +=	"			</span>";
				add +=	"		</div>";
				add +=	"		<div class=\"col-xs-4 text-right\">";
				add +=	"			<div class=\"btn-group bookmark-control-btn\">";
				add +=	"				<button class=\"btn btn-default btn-sm\" title=\"수정\" id=\"edit_"+data.gid[0]+"\"><i class=\"fa fa-edit text-teal\"></i></button>";
				add +=	"				<button class=\"btn btn-default btn-sm\" title=\"삭제\" id=\"del_"+data.gid[0]+"\"><i class=\"fa fa-trash text-danger\"></i></button>";
				add +=	"			</div>";
				add +=	"			<div class=\"btn-group bookmark-control-btn\" style=\"display:none;\">";
				add +=	"				<button class=\"btn btn-default btn-sm\" title=\"확인\" id=\"save_"+data.gid[0]+"\"><i class=\"fa fa-check text-custom\"></i></button>";
				add +=	"				<button class=\"btn btn-default btn-sm\" title=\"취소\" id=\"cancle_"+data.gid[0]+"\"><i class=\"fa fa-undo text-inverse\"></i></button>";
				add +=	"			</div>";
				add +=	"		</div>";
				add +=	"	</div>";
				add +=	"</li>";
		                
		    $("#bookmark_list").append(add);
		},
		error: function(data, status, er) {
			alert("즐겨찾기 등록이 실패하였습니다.");
        }
	});	
}

//즐겨찾기 적용
function agrBookmark(gid){
	gis_clear();	
	$.ajax({
		type: 'POST',
		url: "/ajaxDB_load_bookmark.do",
		data: {gid: gid},
		async: false,
		dataType: "json",
	    beforeSend: function() {
	        //마우스 커서를 로딩 중 커서로 변경
	        $('html').css("cursor", "wait");
	    },
	    complete: function() {
	        //마우스 커서를 원래대로 돌린다
	        $('html').css("cursor", "auto");
	    },
		success: function( data ) {		
			$("#cnt_kind").val(data[0].cnt_kind);
			
			//상세검색전환
			if( $("#searching_item").css("display") == 'none' ){ $("#searching_item").toggle("slide"); }				
			$("div[id$='-itemlist']").removeClass("active");
	    	$("#"+data[0].kind+"-itemlist").addClass("active");
	    	
			//자산검색전환
			if( $("#searching_data").css("display") == 'none' ){ $("#searching_data").toggle("slide"); }
			$("div[id$='-datalist']").removeClass("active");
	    	$("#"+data[0].kind+"-datalist").addClass("active");
	    	
			if( data[0].kind == 'tab-01' ){ 
				//탭전환
				$("#SH_Search_tab li").removeClass("active");
				$("#SH_Search_tab li").eq(0).addClass("active");
				$("#tab-01, #tab-02, #tab-03").removeClass("active");
				$("#tab-01").addClass("active");				
					
				if(data[0].gb != null){ 
					var val = data[0].gb.replace("(", "").replace(")", "").split(",");
					$("input[id^=fs_gb_]").each(function(){
						var inp = $(this).prop("id").replace("fs_gb_", "");
						for(i=0; i<val.length; i++){ if( inp == val[i] ){ $(this).prop("checked", true); } }
					}); }
				if(data[0].sig != null){ 			
					$('#fs_sig').val(data[0].sig).trigger("chosen:updated"); 		
					emd_list($('#fs_sig'), $('#fs_sig').val()); }
				if(data[0].emd != null){ $('#fs_emd').val(data[0].emd).trigger("chosen:updated"); }
				
				
				if(data[0].pnilp_1 != null){ $('#num_pnilp_1').val( Number(data[0].pnilp_1) ); slider_range("pnilp", false); }
				if(data[0].pnilp_2 != null){ $('#num_pnilp_2').val( Number(data[0].pnilp_2) ); slider_range("pnilp", false); }
				if(data[0].jimok != null){ 		
					var val = data[0].jimok.replace("(", "").replace(")", "").split(",");
					$('#fs_jimok').val(val).trigger("chosen:updated");	}
				if(data[0].parea_1 != null){ $('#num_parea_1').val( Number(data[0].parea_1) ); slider_range("parea", false); }
				if(data[0].parea_2 != null){ $('#num_parea_2').val( Number(data[0].parea_2) ); slider_range("parea", false); }				
				if(data[0].spfc != null){ 	
					var val = data[0].spfc.replace("(", "").replace(")", "").split(",");
					$('#fs_spfc').val(val).trigger("chosen:updated");	}				
				if(data[0].land_use != null){ 		
					var val = data[0].land_use.replace("(", "").replace(")", "").split(",");
					$('#fs_land_use').val(val).trigger("chosen:updated");	}
				if(data[0].geo_hl != null){ 
					var val = data[0].geo_hl.replace("(", "").replace(")", "").split(",");
					$('#fs_geo_hl').val(val).trigger("chosen:updated");	}
				if(data[0].geo_form != null){
					var val = data[0].geo_form.replace("(", "").replace(")", "").split(",");
					$('#fs_geo_form').val(val).trigger("chosen:updated");	}				
				if(data[0].road_side != null){ 		
					var val = data[0].road_side.replace("(", "").replace(")", "").split(",");
					$('#fs_road_side').val(val).trigger("chosen:updated"); 	}
				
				
				if(data[0].guk_land_01 != null){ $('#fs_guk_land_01').prop("checked", true); }
				if(data[0].guk_land_02 != null){ $('#fs_guk_land_02').prop("checked", true); }
				if(data[0].guk_land_03 != null){ $('#fs_guk_land_03').prop("checked", true); }
				if(data[0].guk_land_04 != null){ $('#fs_guk_land_04').prop("checked", true); }
				if($("input[id^=fs_guk_land_][id!=fs_guk_land_00]:checked").length == $("input[id^=fs_guk_land_][id!=fs_guk_land_00]").length){ $('#fs_guk_land_00').prop("checked", true); }
				if(data[0].tmseq_land_01 != null){ $('#fs_tmseq_land_01').prop("checked", true); }
				if(data[0].tmseq_land_02 != null){ $('#fs_tmseq_land_02').prop("checked", true); }
				if($("input[id^=fs_tmseq_land_][id!=fs_tmseq_land_00]:checked").length == $("input[id^=fs_tmseq_land_][id!=fs_tmseq_land_00]").length){ $('#fs_tmseq_land_00').prop("checked", true); }
				if(data[0].region_land != null){ $('#fs_region_land_00').prop("checked", true); }
				if(data[0].owned_city_01 != null){ $('#fs_owned_city_01').prop("checked", true); }
				if(data[0].owned_city_02 != null){ $('#fs_owned_city_02').prop("checked", true); }
				if($("input[id^=fs_owned_city_][id!=fs_owned_city_00]:checked").length == $("input[id^=fs_owned_city_][id!=fs_owned_city_00]").length){ $('#fs_owned_city_00').prop("checked", true); }
				if(data[0].owned_guyu_01 != null){ $('#fs_owned_guyu_01').prop("checked", true); }
				if(data[0].owned_guyu_02 != null){ $('#fs_owned_guyu_02').prop("checked", true); }
				if($("input[id^=fs_owned_guyu_][id!=fs_owned_guyu_00]:checked").length == $("input[id^=fs_owned_guyu_][id!=fs_owned_guyu_00]").length){ $('#fs_owned_guyu_00').prop("checked", true); }
				if(data[0].residual_land != null){ $('#fs_residual_land_00').prop("checked", true); }
				if(data[0].unsold_land != null){ $('#fs_unsold_land_00').prop("checked", true); }
				if(data[0].invest != null){ $('#fs_invest_00').prop("checked", true); }
				if(data[0].public_site != null){ $('#fs_public_site_00').prop("checked", true); }
				if(data[0].public_parking != null){ $('#fs_public_parking_00').prop("checked", true); }
				if(data[0].generations != null){ $('#fs_generations_00').prop("checked", true); }
				if(data[0].council_land != null){ $('#fs_council_land_00').prop("checked", true); }
				if(data[0].minuse != null){ $('#fs_minuse_00').prop("checked", true); }
				if(data[0].industry != null){ $('#fs_industry_00').prop("checked", true); }
				if(data[0].priority != null){ $('#fs_priority_00').prop("checked", true); }
				
			}else if( data[0].kind == 'tab-02' ){ 
				//탭전환
				$("#SH_Search_tab li").removeClass("active");
				$("#SH_Search_tab li").eq(1).addClass("active");
				$("#tab-01, #tab-02, #tab-03").removeClass("active");
				$("#tab-02").addClass("active");
				
				if(data[0].gb != null){ 
					var val = data[0].gb.replace("(", "").replace(")", "").split(",");
					$("input[id^=fn_gb_]").each(function(){
						var inp = $(this).prop("id").replace("fn_gb_", "");
						for(i=0; i<val.length; i++){ if( inp == val[i] ){ $(this).prop("checked", true); } }
					}); }
				if(data[0].sig != null){
					$('#fn_sig').val(data[0].sig).trigger("chosen:updated"); 		
					emd_list($('#fn_sig'), $('#fn_sig').val()); }
				if(data[0].emd != null){ $('#fn_emd').val(data[0].emd).trigger("chosen:updated"); }

				
				if(data[0].cp_date_1 != null){ $('#num_cp_date_1').val( data[0].cp_date_1 ); }
				if(data[0].cp_date_2 != null){ $('#num_cp_date_2').val( data[0].cp_date_2 ); }
				if(data[0].bildng_ar_1 != null){ $('#num_bildng_ar_1').val( Number(data[0].bildng_ar_1) ); slider_range("bildng_ar", false); }
				if(data[0].bildng_ar_2 != null){ $('#num_bildng_ar_2').val( Number(data[0].bildng_ar_2) ); slider_range("bildng_ar", false); }
				if(data[0].totar_1 != null){ $('#num_totar_1').val( Number(data[0].totar_1) ); slider_range("totar", false); }
				if(data[0].totar_2 != null){ $('#num_totar_2').val( Number(data[0].totar_2) ); slider_range("totar", false); }
				if(data[0].plot_ar_1 != null){ $('#num_plot_ar_1').val( Number(data[0].plot_ar_1) ); slider_range("plot_ar", false); }
				if(data[0].plot_ar_2 != null){ $('#num_plot_ar_2').val( Number(data[0].plot_ar_2) ); slider_range("plot_ar", false); }
				if(data[0].bdtldr_1 != null){ $('#num_bdtldr_1').val( Number(data[0].bdtldr_1) ); slider_range("bdtldr", false); }
				if(data[0].bdtldr_2 != null){ $('#num_bdtldr_2').val( Number(data[0].bdtldr_2) ); slider_range("bdtldr", false); }
				if(data[0].cpcty_rt_1 != null){ $('#num_cpcty_rt_1').val( Number(data[0].cpcty_rt_1) ); slider_range("cpcty_rt", false); }
				if(data[0].cpcty_rt_2 != null){ $('#num_cpcty_rt_2').val( Number(data[0].cpcty_rt_2) ); slider_range("cpcty_rt", false); }
					
				
				if(data[0].guk_buld_01 != null){ $('#fn_guk_buld_01').prop("checked", true); }
				if(data[0].guk_buld_02 != null){ $('#fn_guk_buld_02').prop("checked", true); }
				if(data[0].guk_buld_03 != null){ $('#fn_guk_buld_03').prop("checked", true); }
				if(data[0].guk_buld_04 != null){ $('#fn_guk_buld_04').prop("checked", true); }
				if($("input[id^=fn_guk_buld_][id!=fn_guk_buld_00]:checked").length == $("input[id^=fn_guk_buld_][id!=fn_guk_buld_00]").length){ $('#fn_guk_buld_00').prop("checked", true); }
				if(data[0].tmseq_buld_01 != null){ $('#fn_tmseq_buld_01').prop("checked", true); }
				if(data[0].tmseq_buld_02 != null){ $('#fn_tmseq_buld_02').prop("checked", true); }
				if($("input[id^=fn_tmseq_buld_][id!=fn_tmseq_buld_00]:checked").length == $("input[id^=fn_tmseq_buld_][id!=fn_tmseq_buld_00]").length){ $('#fn_tmseq_buld_00').prop("checked", true); }
				if(data[0].region_buld != null){ $('#fn_region_buld_00').prop("checked", true); }
				if(data[0].owned_region_01 != null){ $('#fn_owned_region_01').prop("checked", true); }
				if(data[0].owned_region_02 != null){ $('#fn_owned_region_02').prop("checked", true); }
				if($("input[id^=fn_owned_region_][id!=fn_owned_region_00]:checked").length == $("input[id^=fn_owned_region_][id!=fn_owned_region_00]").length){ $('#fn_owned_region_00').prop("checked", true); }
				if(data[0].cynlst_01 != null){ $('#fn_cynlst_01').prop("checked", true); }
				if(data[0].cynlst_02 != null){ $('#fn_cynlst_02').prop("checked", true); }
				if($("input[id^=fn_cynlst_][id!=fn_cynlst_00]:checked").length == $("input[id^=fn_cynlst_][id!=fn_cynlst_00]").length){ $('#fn_cynlst_00').prop("checked", true); }
				if(data[0].public_buld_a != null){ $('#fn_public_buld_a_00').prop("checked", true); }
				if(data[0].public_buld_b != null){ $('#fn_public_buld_b_00').prop("checked", true); }
				if(data[0].public_buld_c != null){ $('#fn_public_buld_c_00').prop("checked", true); }
				if(data[0].public_asbu != null){ $('#fn_public_asbu_00').prop("checked", true); }
				if(data[0].purchase != null){ $('#fn_purchase_00').prop("checked", true); }
				if(data[0].declining != null){ $('#fn_declining_00').prop("checked", true); }
				
			}else if( data[0].kind == 'tab-03' ){ 
				//탭전환
				$("#SH_Search_tab li").removeClass("active");
				$("#SH_Search_tab li").eq(2).addClass("active");
				$("#tab-01, #tab-02, #tab-03").removeClass("active");
				$("#tab-03").addClass("active");
				
				if(data[0].gb != null){ 
					var val = data[0].gb.replace("(", "").replace(")", "").split(",");
					$("input[id^=fg_gb_]").each(function(){
						var inp = $(this).prop("id").replace("fg_gb_", "");
						for(i=0; i<val.length; i++){ if( inp == val[i] ){ $(this).prop("checked", true); } }
					}); }
// 				if(data[0].sig != null){ 			
// 					$('#fg_sig').val(data[0].sig).trigger("chosen:updated"); 		
// 					emd_list($('#fg_sig'), $('#fg_sig').val()); }
// 				if(data[0].emd != null){ $('#fg_emd').val(data[0].emd).trigger("chosen:updated"); }
				
				
				if(data[0].soldout != null){ 		
					var val = data[0].soldout.replace("(", "").replace(")", "").split(",");
					$('#fg_soldout').val(val).trigger("chosen:updated"); 	}
				if(data[0].sector != null){ 		
					var val = data[0].sector.replace("(", "").replace(")", "").split(",");
					$('#fg_sector').val(val).trigger("chosen:updated"); 	}
				if(data[0].spkfc != null){ 		
					var val = data[0].spkfc.replace("(", "").replace(")", "").split(",");
					$('#fg_spkfc').val(val).trigger("chosen:updated"); 	}
				if(data[0].fill_gb != null){ 		
					var val = data[0].fill_gb.replace("(", "").replace(")", "").split(",");
					$('#fg_fill_gb').val(val).trigger("chosen:updated"); 	}
				if(data[0].useu != null){ 		
					var val = data[0].useu.replace("(", "").replace(")", "").split(",");
					$('#fg_useu').val(val).trigger("chosen:updated"); 	}
				if(data[0].uses != null){ 		
					var val = data[0].uses.replace("(", "").replace(")", "").split(",");
					$('#fg_uses').val(val).trigger("chosen:updated"); 	}
				if(data[0].sector_nm != null){ $('#fg_sector_nm').val(data[0].sector_nm); }
				if(data[0].solar_1 != null){ $('#num_solar_1').val( Number(data[0].solar_1) ); slider_range("solar", false); }
				if(data[0].solar_2 != null){ $('#num_solar_2').val( Number(data[0].solar_2) ); slider_range("solar", false); }
				if(data[0].hbdtldr_1 != null){ $('#num_hbdtldr_1').val( Number(data[0].hbdtldr_1) ); slider_range("hbdtldr", false); }
				if(data[0].hbdtldr_2 != null){ $('#num_hbdtldr_2').val( Number(data[0].hbdtldr_2) ); slider_range("hbdtldr", false); }
				if(data[0].hcpcty_rt_1 != null){ $('#num_hcpcty_rt_1').val( Number(data[0].hcpcty_rt_1) ); slider_range("hcpcty_rt", false); }
				if(data[0].hcpcty_rt_2 != null){ $('#num_hcpcty_rt_2').val( Number(data[0].hcpcty_rt_2) ); slider_range("hcpcty_rt", false); }
				if(data[0].hg_limit != null){ $('#fg_hg_limit').val(data[0].hg_limit); }
				if(data[0].taruse != null){ $('#fg_taruse').val(data[0].taruse); }
				if(data[0].soldkind != null){ $('#fg_soldkind').val(data[0].soldkind); }
				if(data[0].soldgb != null){ 		
					var val = data[0].soldgb.replace("(", "").replace(")", "").split(",");
					$('#fg_soldgb').val(val).trigger("chosen:updated"); 	}
				
				
				if(data[0].residual != null){ $('#fn_residual_00').prop("checked", true); }
				if(data[0].unsold != null){ $('#fn_unsold_00').prop("checked", true); }
				
			}
			
			
			//관련사업전환
			if(data[0].kind == "tab-01"){
				$("#sel option").remove();
				$("#sel").append('<option value="sa01">관련사업 검색</option>');
	    		$("#sel").append('<option value="land01">국공유지 개발/활용 대상지</option>');
	    	}else if(data[0].kind == "tab-02"){
	    		$("#sel option").remove();
	    		$("#sel").append('<option value="sa01">관련사업 검색</option>');
	    		$("#sel").append('<option value="buld01">낙후(저층)주거지 찾기</option>');
	    	}else if(data[0].kind == "tab-03"){
	    		$("#sel option").remove();
	    		$("#sel").append('<option value="sa01">관련사업 검색</option>');
	    	}				
			if( $("#searching_space").css("display") == 'none' && data[0].sel != null){
				$("#searching_space").toggle("slide");
			}
			
			if(data[0].sel != null){ 
				var sel = data[0].sel;
				$('#sel').val(sel); 				
				$("#sa01, #sa02, #sa03, #buld01, #land01").hide();					
				$("#"+sel+"").show();
				sa_view(sel);
				
				if(sel == "sa01"){
					if(data[0].space_gb != null){ 
						$('#sa01-01').val(data[0].space_gb).trigger("chosen:updated"); 
						sel_gb2($("#sa01-01"), "sa01-01", $("#sa01-01").val()); }					
					if(data[0].space_gb_cd02 != null){ 	
						var val = data[0].space_gb_cd02.replace("(", "").replace(")", "").split(",");
						$('#sa01-02').val(val).trigger("chosen:updated");
						if(val.length == 1) { sel_gb3($("#sa01-02").parent().next("div").children("select"), "sa01-02", 
								$("#sa01-02").parent().prev("div").children("select").val(), val[0]); } }
					if(data[0].space_gb_cd03 != null && val.length == 1){
						var val = data[0].space_gb_cd03.replace("(", "").replace(")", "").split(",");
						$('#sa01-03').val(val).trigger("chosen:updated");	}
					
					if(data[0].sub_p_decline_gb != null){ 
						$('#sa01-04').val(data[0].sub_p_decline_gb).trigger("chosen:updated"); 
						sel_gb2($("#sa01-04"), "sa01-04", $("#sa01-04").val()); }
					if(data[0].sub_p_decline_val != null){ 	
						var val = data[0].sub_p_decline_val.replace("(", "").replace(")", "").split(",");
						$('#sa01-05').val(val).trigger("chosen:updated");	
						if(val.length == 1) { sel_gb3($("#sa01-05").parent().next("div").children("select"), "sa01-05", 
								$("#sa01-05").parent().prev("div").children("select").val(), val[0]); } }					
					if(data[0].sub_p_decline != null && val.length == 1){ 								
						var val = data[0].sub_p_decline.replace("(", "").replace(")", "").split(",");
						$('#sa01-06').val(val).trigger("chosen:updated");	}		
					
					if(data[0].public_transport_val != null){ 
						$('#sa01-07').val(data[0].public_transport_val).trigger("chosen:updated"); 
						sel_gb4($('#sa01-07').parent().next("div").children("select"), 'sa01-07', $('#sa01-07').val()); }
					if(data[0].public_transport != null){	
						var val = data[0].public_transport.replace("(", "").replace(")", "").split(",");
						$('#sa01-08').val(val).trigger("chosen:updated");	}
				}else if(sel == "sa02"){
					
				}else if(sel == "sa03"){
					
				}else if(sel == "buld01"){
					if(data[0].spfc != null){ 	
						var val = data[0].spfc.replace("(", "").replace(")", "").split(",");
						$('#buld01-01').val(val).trigger("chosen:updated");	}
					if(data[0].road_side != null){ 	
						var val = data[0].road_side.replace("(", "").replace(")", "").split(",");
						$('#buld01-02').val(val).trigger("chosen:updated");	}	
					
					if(data[0].space_gb != null){ 
						$('#buld01-04').val(data[0].space_gb).trigger("chosen:updated"); 
						sel_gb2($("#buld01-04"), "buld01-04", $("#buld01-04").val()); }
					if(data[0].space_gb_cd02 != null){ 							
						var val = data[0].space_gb_cd02.replace("(", "").replace(")", "").split(",");
						$('#buld01-05').val(val).trigger("chosen:updated");	
						if(val.length == 1) { sel_gb3($("#buld01-05").parent().next("div").children("select"), "buld01-05", 
								$("#buld01-05").parent().prev("div").children("select").val(), val[0]); } }
					if(data[0].space_gb_cd03 != null && val.length == 1){ 	
						var val = data[0].space_gb_cd03.replace("(", "").replace(")", "").split(",");
						$('#buld01-06').val(val).trigger("chosen:updated");	}
					
					if(data[0].sub_p_decline_gb != null){ 
						$('#buld01-07').val(data[0].sub_p_decline_gb).trigger("chosen:updated"); 
						sel_gb2($("#buld01-07"), "buld01-07", $("#buld01-07").val()); }
					if(data[0].sub_p_decline_val != null){ 	
						var val = data[0].sub_p_decline_val.replace("(", "").replace(")", "").split(",");
						$('#buld01-08').val(val).trigger("chosen:updated");	
						if(val.length == 1) { sel_gb3($("#buld01-08").parent().next("div").children("select"), "buld01-08", 
								$("#buld01-08").parent().prev("div").children("select").val(), val[0]); } }
					if(data[0].sub_p_decline != null){ 	
						var val = data[0].sub_p_decline.replace("(", "").replace(")", "").split(",");
						$('#buld01-09').val(val).trigger("chosen:updated");	}	
				}else if(sel == "land01"){
					if(data[0].cp_date_1 != null){ $('#land01-02').val(data[0].cp_date_1); }
					if(data[0].cp_date_2 != null){ $('#land01-03').val(data[0].cp_date_2); }
					if(data[0].bdtldr_1 != null){ $('#land01-04').val(data[0].bdtldr_1); }
					if(data[0].bdtldr_2 != null){ $('#land01-05').val(data[0].bdtldr_2); }
					if(data[0].cpcty_rt_1 != null){ $('#land01-06').val(data[0].cpcty_rt_1); }
					if(data[0].cpcty_rt_2 != null){ $('#land01-07').val(data[0].cpcty_rt_2); }
					
					if(data[0].space_gb != null){ 
						$('#land01-08').val(data[0].space_gb).trigger("chosen:updated"); 
						sel_gb2($("#land01-08"), "land01-08", $("#land01-08").val()); }					
					if(data[0].space_gb_cd02 != null){ 							
						var val = data[0].space_gb_cd02.replace("(", "").replace(")", "").split(",");
						$('#land01-09').val(val).trigger("chosen:updated");	
						if(val.length == 1){ sel_gb3($("#land01-09").parent().next("div").children("select"), "land01-09", 
								$("#land01-09").parent().prev("div").children("select").val(), val[0]); } }					
					if(data[0].space_gb_cd03 != null){ 	
						var val = data[0].space_gb_cd03.replace("(", "").replace(")", "").split(",");
						$('#land01-10').val(val).trigger("chosen:updated");	}
					
					if(data[0].public_transport_val != null){ 
						$('#land01-11').val(data[0].public_transport_val).trigger("chosen:updated"); 
						sel_gb4($('#land01-11').parent().next("div").children("select"), 'land01-11', $('#land01-11').val()); }
					if(data[0].public_transport != null){ 	
						var val = data[0].public_transport.replace("(", "").replace(")", "").split(",");
						$('#land01-12').val(val).trigger("chosen:updated");	}
				}
			}
			
		},
		error: function(data, status, er) {
			alert("즐겨찾기 불러오기가 실패하였습니다.");
        }
	});	
}

//검색 버튼
function searchBookmark() {		
	var nm = $('#searchBookmark_nm').val();
	$("button[id^='del_']").parent().parent().parent().parent("li").hide();
	$("#bookmark_list span:contains('"+nm+"')").parent().parent().parent("li").show();	
}
</script>	



    <!-- 자산검색-즐겨찾기-Popup -->
    <div class="popover bookmark-pop hidden" id="bookmark-pop" style="width: 350px; left: 520px; top: auto; bottom: 20px; display: none;">
        <div class="popover-title tit">
            <span class="m-r-5">
                <b>즐겨찾기</b>
            </span>
            <button type="button" class="close" id="bookmark-pop-close">×</button>
        </div>
        <div class="popover-body">
            <div class="popover-content pop-top-area p-20">
                <div class="row">
                    <div class="col-xs-12">
                        <div class="input-group input-group-sm">
                            <input type="search" class="form-control" placeholder="즐겨찾기 검색어 입력" id="searchBookmark_nm">
                            <span class="input-group-btn">
                                <button class="btn btn-teal" onclick="searchBookmark()"><i class="fa fa-search"></i></button>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="popover-content-wrap bookmark-pop">
                <div class="popover-content p-20">
                    <div class="row">
                        <div class="col-xs-12">
                            <ul class="list-group m-b-0" id="bookmark_list">
                                <c:forEach var="result" items="${GISBookMark}" varStatus="status">									
									<li class="list-group-item book-mark">
	                                    <div class="row bookmark-item">
	                                        <div class="col-xs-8">
	                                        	<span class="bookmark-item-text" onclick="javascript:agrBookmark('<c:out value="${result.gid}"/>');"><c:out value="${result.bookmark_nm}"/></span>
	                                        	<span class="bookmark-item-text" style="display:none;">
	                                                <input type="text" class="form-control input-sm" placeholder="즐겨찾기 명칭 입력" value="<c:out value="${result.bookmark_nm}"/>">
	                                            </span>
	                                        </div>
	                                        <div class="col-xs-4 text-right">
	                                            <div class="btn-group bookmark-control-btn">
	                                                <button class="btn btn-default btn-sm" title="수정" id="edit_<c:out value="${result.gid}"/>"><i class="fa fa-edit text-teal"></i></button>
	                                                <button class="btn btn-default btn-sm" title="삭제" id="del_<c:out value="${result.gid}"/>"><i class="fa fa-trash text-danger"></i></button>
	                                            </div>
	                                            <div class="btn-group bookmark-control-btn" style="display:none;">
	                                                <button class="btn btn-default btn-sm" title="확인" id="save_<c:out value="${result.gid}"/>"><i class="fa fa-check text-custom"></i></button>
	                                                <button class="btn btn-default btn-sm" title="취소" id="cancle_<c:out value="${result.gid}"/>"><i class="fa fa-undo text-inverse"></i></button>
	                                            </div>
	                                        </div>
	                                    </div>
	                                </li>
								</c:forEach>

                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="popover-footer detail-view p-10">
            <div class="row">
                <div class="col-xs-12">
                    <div class="input-group input-group-sm">
                        <input type="text" class="form-control" placeholder="즐겨찾기 명칭 입력" id="bookmark_nm">
                        <span class="input-group-btn">
                            <button class="btn btn-custom" onclick="bookmark_save()"><i class="fa fa-plus m-r-5"></i>추가</button>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--// End 자산검색-즐겨찾기-Popup -->
    
    
    
    
    