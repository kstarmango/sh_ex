<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="utf-8">
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <meta name="description" content="SH서울주택도시공사 | 토지자원관리시스템">

    <link rel="shortcut icon" href="/jsp/SH/img/favicon.ico">

    <!--DatePicker css-->
    <link href="/jsp/SH/css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <!-- DateTimePicker -->
    <link href="/jsp/SH/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />

	<!--Morris Chart CSS -->
    <link href="/jsp/SH/css/morris.css" rel="stylesheet" />

    <!-- App css -->
    <link href="/jsp/SH/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/components.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/icons.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/core.css" rel="stylesheet" type="text/css" />




    <!-- jQuery Library -->
	<script src="/jsp/SH/js/jquery.min.js"></script>
	<script src="/jsp/SH/js/bootstrap.min.js"></script>

	<!-- Table Sort -->
	<script src="/jsp/SH/js/stupidtable.js"></script>

	<!-- App js -->
	<script src="/jsp/SH/js/jquery.app.js"></script>

	<!-- OpenLayers4 -->
	<link href="/jsp/SH/js/openLayers/v4.3.1/ol.css" rel="stylesheet" />
	<script src="/jsp/SH/js/openLayers/v4.3.1/ol.js"></script>
	<script src="/jsp/SH/js/openLayers/v4.3.1/polyfill.min.js"></script>

	<!-- Map Export is PNG  -->
	<script type="text/javascript" src="/jsp/SH/js/mapExport/html2canvas.js"></script>
	<script type="text/javascript" src="/jsp/SH/js/mapExport/FileSaver.js"></script>
	<script type="text/javascript" src="/jsp/SH/js/mapExport/canvas-toBlob.js"></script>

	<!-- potalMap is DaumAPI  -->
	<!-- 로컬개발용 -->
	<!-- <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=dd814c573b22a7079068883df930cc51"></script> -->
	<!-- 외부접근개발용 -->
	<!-- <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=73de49f305c6e0f34db3ca8dc7135a1e"></script> -->
	<!-- 실서버용 -->
 	<!-- <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=6d4240cef136cd89d4d4fcf442331b53"></script> -->
	<!-- 신영ESD서버용 -->
 	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a0d37957532262602e2dca4450170302"></script>

<script type="text/javascript">
$(document).ready(function(){

	//탭 활성화
	$("#dv-data ul li").eq(0).addClass("active");
	$("#dv-data div[id^=dv-]").eq(0).removeClass("fade");
	$("#dv-data div[id^=dv-]").eq(0).addClass("active");
	map_draw_mini($("#dv-land input[id$=_addr_x]").val(), $("#dv-land input[id$=_addr_y]").val(), $("#dv-land input[id$=_geom]").val());

	//탭클릭 - 도형표현
	$("#dv-tablist li, #dv-buld li, #dv-data li").on("click", function(){
    	var type = $(this).find("a").attr("href").replace("#", "");
    	var geom = $("#"+type+" input[id$=_geom]").eq(0).val();
    	var addr_x = $("#"+type+" input[id$=_addr_x]").eq(0).val();
    	var addr_y = $("#"+type+" input[id$=_addr_y]").eq(0).val();

    	if(type == "dv-buld"){
    		if($("#"+type+" input[id$=_geom]").eq(0).val() != ""){
    			geom = $("#"+type+" input[id$=_geom]").eq(0).val();
    	    	addr_x = $("#"+type+" input[id$=_addr_x]").eq(0).val();
    	    	addr_y = $("#"+type+" input[id$=_addr_y]").eq(0).val();

    	    	$("#dv-buld li").removeClass("active");
    	    	$("#dv-buld li").eq(0).addClass("active");
    	    	$("#dv-dboh, #dv-bdfc, #dv-bdhd").removeClass("active in");
    	    	$("#dv-dboh").addClass("active in");
    		}else if($("#"+type+" input[id$=_geom]").eq(2).val() != ""){
    			geom = $("#"+type+" input[id$=_geom]").eq(2).val();
    	    	addr_x = $("#"+type+" input[id$=_addr_x]").eq(2).val();
    	    	addr_y = $("#"+type+" input[id$=_addr_y]").eq(2).val();

    	    	$("#dv-buld li").removeClass("active");
    	    	$("#dv-buld li").eq(2).addClass("active");
    	    	$("#dv-dboh, #dv-bdfc, #dv-bdhd").removeClass("active in");
    	    	$("#dv-bdhd").addClass("active in");
    		}else if($("#"+type+" input[id$=_geom]").eq(1).val() != ""){
    			geom = $("#"+type+" input[id$=_geom]").eq(1).val();
    	    	addr_x = $("#"+type+" input[id$=_addr_x]").eq(1).val();
    	    	addr_y = $("#"+type+" input[id$=_addr_y]").eq(1).val();

    	    	$("#dv-buld li").removeClass("active");
    	    	$("#dv-buld li").eq(1).addClass("active");
    	    	$("#dv-dboh, #dv-bdfc, #dv-bdhd").removeClass("active in");
    	    	$("#dv-bdfc").addClass("active in");
    		}
    	}
    	if( geom != "" ){ map_draw_mini(addr_x, addr_y, geom); }
    	if(type == "dv-data"){ view_mini.setZoom(14); }

    });


	//상세정보 - 건축물정보 n선택
	$("#select_dboh, #select_bdfc, #select_bdhd").change(function() {
        var target = $(this).prop("id").replace("select_", "");
        var gid = $(this).val();
        var pnu = $("#pnu").val();
        $.ajax({
    		type: 'POST',
    		url: "/ajaxDB_Content_Detail.do",
    		data: {gid: gid, pnu: pnu, target: target},
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
    			$("td[id^=detail_buld_"+target+"_]").text("");

    			if(target == "dboh"){
    				if(data[0].plot_lc != null) 		$("#detail_buld_"+target+"_"+"plot_lc").text(data[0].plot_lc);
    				if(data[0].rn_plot_lc != null) 		$("#detail_buld_"+target+"_"+"rn_plot_lc").text(data[0].rn_plot_lc);
    				if(data[0].buld_nm != null) 		$("#detail_buld_"+target+"_"+"buld_nm").text(data[0].buld_nm);
    				if(data[0].spcl_nmfpc != null) 		$("#detail_buld_"+target+"_"+"spcl_nmfpc").text(data[0].spcl_nmfpc);
    				if(data[0].blck != null) 			$("#detail_buld_"+target+"_"+"blck").text(data[0].blck);
    				if(data[0].lot != null) 			$("#detail_buld_"+target+"_"+"lot").text(data[0].lot);
    				if(data[0].else_lot_co != null) 	$("#detail_buld_"+target+"_"+"else_lot_co").text(data[0].else_lot_co);
    				if(data[0].plot_ar != null) 		$("#detail_buld_"+target+"_"+"plot_ar").text(data[0].plot_ar);
    				if(data[0].bildng_ar != null) 		$("#detail_buld_"+target+"_"+"bildng_ar").text(data[0].bildng_ar);
    				if(data[0].bdtldr != null) 			$("#detail_buld_"+target+"_"+"bdtldr").text(data[0].bdtldr);
    				if(data[0].totar != null) 			$("#detail_buld_"+target+"_"+"totar").text(data[0].totar);
    				if(data[0].cpcty_rt != null) 		$("#detail_buld_"+target+"_"+"cpcty_rt").text(data[0].cpcty_rt);
    				if(data[0].cpcty_rt_calc_totar != null)	$("#detail_buld_"+target+"_"+"cpcty_rt_calc_totar").text(data[0].cpcty_rt_calc_totar);
    				if(data[0].main_prpos_code_nm != null) 	$("#detail_buld_"+target+"_"+"main_prpos_code_nm").text(data[0].main_prpos_code_nm);
    				if(data[0].etc_prpos != null) 		$("#detail_buld_"+target+"_"+"etc_prpos").text(data[0].etc_prpos);
    				if(data[0].hshld_co != null) 		$("#detail_buld_"+target+"_"+"hshld_co").text(data[0].hshld_co);
    				if(data[0].funitre_co != null) 		$("#detail_buld_"+target+"_"+"funitre_co").text(data[0].funitre_co);
    				if(data[0].main_bild_co != null) 	$("#detail_buld_"+target+"_"+"main_bild_co").text(data[0].main_bild_co);
    				if(data[0].atach_bild_co != null) 	$("#detail_buld_"+target+"_"+"atach_bild_co").text(data[0].atach_bild_co);
    				if(data[0].atach_bild_ar != null) 		$("#detail_buld_"+target+"_"+"atach_bild_ar").text(data[0].atach_bild_ar);
    				if(data[0].floor_parkng_co != null) 		$("#detail_buld_"+target+"_"+"floor_parkng_co").text(data[0].floor_parkng_co);
    				if(data[0].insdhous_mchne_alge != null) 		$("#detail_buld_"+target+"_"+"insdhous_mchne_alge").text(data[0].insdhous_mchne_alge);
    				if(data[0].insdhous_mchne_ar != null) 		$("#detail_buld_"+target+"_"+"insdhous_mchne_ar").text(data[0].insdhous_mchne_ar);
    				if(data[0].outhous_mchne_alge != null) 		$("#detail_buld_"+target+"_"+"outhous_mchne_alge").text(data[0].outhous_mchne_alge);
    				if(data[0].outhous_mchne_ar != null) 		$("#detail_buld_"+target+"_"+"outhous_mchne_ar").text(data[0].outhous_mchne_ar);
    				if(data[0].insdhous_self_alge != null) 		$("#detail_buld_"+target+"_"+"insdhous_self_alge").text(data[0].insdhous_self_alge);
    				if(data[0].insdhous_self_ar != null) 		$("#detail_buld_"+target+"_"+"insdhous_self_ar").text(data[0].insdhous_self_ar);
    				if(data[0].outhous_self_alge != null) 		$("#detail_buld_"+target+"_"+"outhous_self_alge").text(data[0].outhous_self_alge);
    				if(data[0].outhous_self_ar != null) 		$("#detail_buld_"+target+"_"+"outhous_self_ar").text(data[0].outhous_self_ar);
    				if(data[0].prmisn_de != null) 		$("#detail_buld_"+target+"_"+"prmisn_de").text(data[0].prmisn_de);
    				if(data[0].strwrk_de != null) 		$("#detail_buld_"+target+"_"+"strwrk_de").text(data[0].strwrk_de);
    				if(data[0].use_confm_de != null) 		$("#detail_buld_"+target+"_"+"use_confm_de").text(data[0].use_confm_de);
    				if(data[0].prmisn_no_yy != null) 		$("#detail_buld_"+target+"_"+"prmisn_no_yy").text(data[0].prmisn_no_yy);
    				if(data[0].prmisn_no_instt_code != null) 		$("#detail_buld_"+target+"_"+"prmisn_no_instt_code").text(data[0].prmisn_no_instt_code);
    				if(data[0].prmisn_no_instt_code_nm != null) 		$("#detail_buld_"+target+"_"+"prmisn_no_instt_code_nm").text(data[0].prmisn_no_instt_code_nm);
    				if(data[0].prmisn_no_se_code != null) 		$("#detail_buld_"+target+"_"+"prmisn_no_se_code").text(data[0].prmisn_no_se_code);
    				if(data[0].prmisn_no_se_code_nm != null) 		$("#detail_buld_"+target+"_"+"prmisn_no_se_code_nm").text(data[0].prmisn_no_se_code_nm);
    				if(data[0].ho_co != null) 		$("#detail_buld_"+target+"_"+"ho_co").text(data[0].ho_co);
    				if(data[0].energy_efcny_grad != null) 		$("#detail_buld_"+target+"_"+"energy_efcny_grad").text(data[0].energy_efcny_grad);
    				if(data[0].energy_redcn_rt != null) 		$("#detail_buld_"+target+"_"+"energy_redcn_rt").text(data[0].energy_redcn_rt);
    				if(data[0].energy_episcore != null) 		$("#detail_buld_"+target+"_"+"energy_episcore").text(data[0].energy_episcore);
    				if(data[0].evrfrnd_bild_grad != null) 		$("#detail_buld_"+target+"_"+"evrfrnd_bild_grad").text(data[0].evrfrnd_bild_grad);
    				if(data[0].evrfrnd_bild_crtfc_score != null) 		$("#detail_buld_"+target+"_"+"evrfrnd_bild_crtfc_score").text(data[0].evrfrnd_bild_crtfc_score);
    				if(data[0].intlgnt_bild_evlutn != null) 		$("#detail_buld_"+target+"_"+"intlgnt_bild_evlutn").text(data[0].intlgnt_bild_evlutn);
    				if(data[0].intlgnt_bild_score != null) 		$("#detail_buld_"+target+"_"+"intlgnt_bild_score").text(data[0].intlgnt_bild_score);

    				if(data[0].addr_x != null) 		$("#detail_buld_"+target+"_"+"addr_x").val(data[0].addr_x);
    				if(data[0].addr_y != null) 		$("#detail_buld_"+target+"_"+"addr_y").val(data[0].addr_y);
    				if(data[0].geom != null) 		$("#detail_buld_"+target+"_"+"geom").val(data[0].geom);
    			}else if(target == "bdfc"){
    				if(data[0].plot_lc != null) 		$("#detail_buld_"+target+"_"+"plot_lc").text(data[0].plot_lc);
    				if(data[0].rn_plot_lc != null) 		$("#detail_buld_"+target+"_"+"rn_plot_lc").text(data[0].rn_plot_lc);
    				if(data[0].buld_nm != null) 		$("#detail_buld_"+target+"_"+"buld_nm").text(data[0].buld_nm);
    				if(data[0].spcl_nmfpc != null) 		$("#detail_buld_"+target+"_"+"spcl_nmfpc").text(data[0].spcl_nmfpc);
    				if(data[0].blck != null) 		$("#detail_buld_"+target+"_"+"blck").text(data[0].blck);
    				if(data[0].lot != null) 		$("#detail_buld_"+target+"_"+"lot").text(data[0].lot);
    				if(data[0].dong_nm != null) 		$("#detail_buld_"+target+"_"+"dong_nm").text(data[0].dong_nm);
    				if(data[0].ho_nm != null) 		$("#detail_buld_"+target+"_"+"ho_nm").text(data[0].ho_nm);
    				if(data[0].floor_se_code_nm != null) 		$("#detail_buld_"+target+"_"+"floor_se_code_nm").text(data[0].floor_se_code_nm);
    				if(data[0].floor_no != null) 		$("#detail_buld_"+target+"_"+"floor_no").text(data[0].floor_no);
    			}else if(target == "bdhd"){
    				if(data[0].plot_lc != null) 		$("#detail_buld_"+target+"_"+"plot_lc").text(data[0].plot_lc);
    				if(data[0].rn_plot_lc != null) 		$("#detail_buld_"+target+"_"+"rn_plot_lc").text(data[0].rn_plot_lc);
    				if(data[0].buld_nm != null) 		$("#detail_buld_"+target+"_"+"buld_nm").text(data[0].buld_nm);
    				if(data[0].spcl_nmfpc != null) 		$("#detail_buld_"+target+"_"+"spcl_nmfpc").text(data[0].spcl_nmfpc);
    				if(data[0].blck != null) 		$("#detail_buld_"+target+"_"+"blck").text(data[0].blck);
    				if(data[0].lot != null) 		$("#detail_buld_"+target+"_"+"lot").text(data[0].lot);
    				if(data[0].else_lot_co != null) 		$("#detail_buld_"+target+"_"+"else_lot_co").text(data[0].else_lot_co);
    				if(data[0].plot_ar != null) 		$("#detail_buld_"+target+"_"+"plot_ar").text(data[0].plot_ar);
    				if(data[0].bildng_ar != null) 		$("#detail_buld_"+target+"_"+"bildng_ar").text(data[0].bildng_ar);
    				if(data[0].bdtldr != null) 		$("#detail_buld_"+target+"_"+"bdtldr").text(data[0].bdtldr);
    				if(data[0].totar != null) 		$("#detail_buld_"+target+"_"+"totar").text(data[0].totar);
    				if(data[0].cpcty_rt != null) 		$("#detail_buld_"+target+"_"+"cpcty_rt").text(data[0].cpcty_rt);
    				if(data[0].cpcty_rt_calc_totar != null) 		$("#detail_buld_"+target+"_"+"cpcty_rt_calc_totar").text(data[0].cpcty_rt_calc_totar);
    				if(data[0].strct_code_nm != null) 		$("#detail_buld_"+target+"_"+"strct_code_nm").text(data[0].strct_code_nm);
    				if(data[0].etc_strct != null) 		$("#detail_buld_"+target+"_"+"etc_strct").text(data[0].etc_strct);
    				if(data[0].main_prpos_code_nm != null) 		$("#detail_buld_"+target+"_"+"main_prpos_code_nm").text(data[0].main_prpos_code_nm);
    				if(data[0].etc_prpos != null) 		$("#detail_buld_"+target+"_"+"etc_prpos").text(data[0].etc_prpos);
    				if(data[0].rf_code_nm != null) 		$("#detail_buld_"+target+"_"+"rf_code_nm").text(data[0].rf_code_nm);
    				if(data[0].etc_rf != null) 		$("#detail_buld_"+target+"_"+"etc_rf").text(data[0].etc_rf);
    				if(data[0].hshld_co != null) 		$("#detail_buld_"+target+"_"+"hshld_co").text(data[0].hshld_co);
    				if(data[0].funitre_co != null) 		$("#detail_buld_"+target+"_"+"funitre_co").text(data[0].funitre_co);
    				if(data[0].hg != null) 		$("#detail_buld_"+target+"_"+"hg").text(data[0].hg);
    				if(data[0].ground_floor_co != null) 		$("#detail_buld_"+target+"_"+"ground_floor_co").text(data[0].ground_floor_co);
    				if(data[0].undgrnd_floor_co != null) 		$("#detail_buld_"+target+"_"+"undgrnd_floor_co").text(data[0].undgrnd_floor_co);
    				if(data[0].rdng_elvtr_co != null) 		$("#detail_buld_"+target+"_"+"rdng_elvtr_co").text(data[0].rdng_elvtr_co);
    				if(data[0].emgnc_elvtr_co != null) 		$("#detail_buld_"+target+"_"+"emgnc_elvtr_co").text(data[0].emgnc_elvtr_co);
    				if(data[0].atach_bild_co != null) 		$("#detail_buld_"+target+"_"+"atach_bild_co").text(data[0].atach_bild_co);
    				if(data[0].atach_bild_ar != null) 		$("#detail_buld_"+target+"_"+"atach_bild_ar").text(data[0].atach_bild_ar);
    				if(data[0].floor_dong_totar != null) 		$("#detail_buld_"+target+"_"+"floor_dong_totar").text(data[0].floor_dong_totar);
    				if(data[0].insdhous_mchne_alge != null) 		$("#detail_buld_"+target+"_"+"insdhous_mchne_alge").text(data[0].insdhous_mchne_alge);
    				if(data[0].insdhous_mchne_ar != null) 		$("#detail_buld_"+target+"_"+"insdhous_mchne_ar").text(data[0].insdhous_mchne_ar);
    				if(data[0].outhous_mchne_alge != null) 		$("#detail_buld_"+target+"_"+"outhous_mchne_alge").text(data[0].outhous_mchne_alge);
    				if(data[0].outhous_mchne_ar != null) 		$("#detail_buld_"+target+"_"+"outhous_mchne_ar").text(data[0].outhous_mchne_ar);
    				if(data[0].insdhous_self_alge != null) 		$("#detail_buld_"+target+"_"+"insdhous_self_alge").text(data[0].insdhous_self_alge);
    				if(data[0].insdhous_self_ar != null) 		$("#detail_buld_"+target+"_"+"insdhous_self_ar").text(data[0].insdhous_self_ar);
    				if(data[0].outhous_self_alge != null) 		$("#detail_buld_"+target+"_"+"outhous_self_alge").text(data[0].outhous_self_alge);
    				if(data[0].outhous_self_ar != null) 		$("#detail_buld_"+target+"_"+"outhous_self_ar").text(data[0].outhous_self_ar);
    				if(data[0].prmisn_de != null) 		$("#detail_buld_"+target+"_"+"prmisn_de").text(data[0].prmisn_de);
    				if(data[0].strwrk_de != null) 		$("#detail_buld_"+target+"_"+"strwrk_de").text(data[0].strwrk_de);
    				if(data[0].use_confm_de != null) 		$("#detail_buld_"+target+"_"+"use_confm_de").text(data[0].use_confm_de);
    				if(data[0].prmisn_no_yy != null) 		$("#detail_buld_"+target+"_"+"prmisn_no_yy").text(data[0].prmisn_no_yy);
    				if(data[0].prmisn_no_instt_code != null) 		$("#detail_buld_"+target+"_"+"prmisn_no_instt_code").text(data[0].prmisn_no_instt_code);
    				if(data[0].prmisn_no_instt_code_nm != null) 		$("#detail_buld_"+target+"_"+"prmisn_no_instt_code_nm").text(data[0].prmisn_no_instt_code_nm);
    				if(data[0].prmisn_no_se_code != null) 		$("#detail_buld_"+target+"_"+"prmisn_no_se_code").text(data[0].prmisn_no_se_code);
    				if(data[0].prmisn_no_se_code_nm != null) 		$("#detail_buld_"+target+"_"+"prmisn_no_se_code_nm").text(data[0].prmisn_no_se_code_nm);
    				if(data[0].ho_co != null) 		$("#detail_buld_"+target+"_"+"ho_co").text(data[0].ho_co);
    				if(data[0].energy_efcny_grad != null) 		$("#detail_buld_"+target+"_"+"energy_efcny_grad").text(data[0].energy_efcny_grad);
    				if(data[0].energy_redcn_rt != null) 		$("#detail_buld_"+target+"_"+"energy_redcn_rt").text(data[0].energy_redcn_rt);
    				if(data[0].energy_episcore != null) 		$("#detail_buld_"+target+"_"+"energy_episcore").text(data[0].energy_episcore);
    				if(data[0].evrfrnd_bild_grad != null) 		$("#detail_buld_"+target+"_"+"evrfrnd_bild_grad").text(data[0].evrfrnd_bild_grad);
    				if(data[0].evrfrnd_bild_crtfc_score != null) 		$("#detail_buld_"+target+"_"+"evrfrnd_bild_crtfc_score").text(data[0].evrfrnd_bild_crtfc_score);
    				if(data[0].intlgnt_bild_evlutn != null) 		$("#detail_buld_"+target+"_"+"intlgnt_bild_evlutn").text(data[0].intlgnt_bild_evlutn);
    				if(data[0].intlgnt_bild_score != null) 		$("#detail_buld_"+target+"_"+"intlgnt_bild_score").text(data[0].intlgnt_bild_score);

    				if(data[0].addr_x != null) 		$("#detail_buld_"+target+"_"+"addr_x").val(data[0].addr_x);
    				if(data[0].addr_y != null) 		$("#detail_buld_"+target+"_"+"addr_y").val(data[0].addr_y);
    				if(data[0].geom != null) 		$("#detail_buld_"+target+"_"+"geom").val(data[0].geom);
    			}

    			map_draw_mini($("#detail_buld_"+target+"_addr_x").val(), $("#detail_buld_"+target+"_addr_y").val(), $("#detail_buld_"+target+"_geom").val());
    		},
    		error: function(data, status, er) {
    			alert("데이터 불러오기가 실패하였습니다.");
            }
    	});
    });






	//지도화면 저장
	geoMap_mini.on('postcompose', function(event) {
        var canvas = event.context.canvas;
        $('input[name="imgSrc"]').val(canvas.toDataURL('image/png'));
	});







	//자산등록버튼 클릭
	$('.btnAdd').click(function(){
		fnAddContentSh();
	});

	//자산등록버튼 클릭
	$('.btnDelete').click(function(){
		fnDelContentSh();
	});

	//자산이력버튼 클릭
	$('.btnHist').click(function(){
		fnHistContentSh();
	});

});

//도형 그리기
function map_draw_mini(addr_x, addr_y, geom){
	if(geom == ""){
// 		alert("도형정보가 없습니다.");
	}else{
		//그래픽 초기화
		if(vectorLayer_mini != null || vectorLayer_mini != ''){
			vectorSource_mini.clear();
			geoMap_mini.removeLayer(vectorLayer_mini);
		}

		//create the style
		var iconStyle2 = new ol.style.Style({
// 	    	fill: new ol.style.Fill({
// 	      		color: 'red'
// 	    	}),
	    	stroke: new ol.style.Stroke({
	    		color: 'red',
	      		width: 1.5,
	      		lineDash: [4]
	    	})
	    });
	    vectorLayer_mini = new ol.layer.Vector({
	        source: vectorSource_mini,
	        style: iconStyle2
	    });

		var coord_v = geom;
		coord_v = coord_v.replace('MULTIPOLYGON', '');
		coord_v = coord_v.replace('(((', '');
		coord_v = coord_v.replace(')))', '');
		var coord_sp = coord_v.split(",");
		var coord_sp_t = new Array();

		for(j=0; j<coord_sp.length; j++){
			if(coord_sp[j] != ""){
				var arry1 = coord_sp[j].split(' ');
				var val = ol.proj.transform([ Number( arry1[0] ), Number( arry1[1] ) ], 'EPSG:4326', 'EPSG:900913');
				coord_sp_t[j] = new Array( val[0], val[1] );
			}
		}

		var iconFeature_mini = new ol.Feature({
	           geometry: new ol.geom.Polygon([ coord_sp_t ])
	    });
		vectorSource_mini.addFeature(iconFeature_mini);

	    geoMap_mini.addLayer(vectorLayer_mini);

	    var spot = ol.proj.transform([Number(addr_x), Number(addr_y)], 'EPSG:4326', 'EPSG:900913');
		view_mini.setCenter(spot);
		view_mini.setZoom(19);

		//지도와 로드뷰 위에 마커로 표시할 특정 장소의 좌표입니다
		var position = new daum.maps.LatLng(Number(addr_y), Number(addr_x));
		roadviewClient.getNearestPanoId(position, 50, function(panoId) {
	        roadview.setPanoId(panoId, position);
	        roadview.relayout();
	    });

	}

	geoMap_mini.renderSync();
}




//기초현황서 다운
function down_word(){
	var div_nm = '<c:out value="${sh_kind}"/>';
		div_nm = div_nm.replace("data_", "");
	var pnu = '<c:out value="${pnu}"/>';



	if(!confirm("워드파일 다운로드 하시겠습니까?")){return;}

	$("#DocForm #sh_kind").val(div_nm);
	$("#DocForm #pnu").val(pnu);

    $("#DocForm").attr("target","_parent");
    $("#DocForm").attr("method", "post");
    $("#DocForm").attr("action","GIS_Word_Download.do?");
    $("#DocForm").submit();




}

//테스트 - 이미지캡쳐
function down_img(){
// 	html2canvas($("#geomap_mini canvas"), {
	html2canvas($("#potalmap_mini"), {
		useCORS: true,
// 		proxy: 'http://i1.daumcdn.net',
		onrendered: function(canvas) {
			canvas.toBlob(function (blob) {
        	    saveAs(blob, 'map.png');
		 });
		}
	});

}






//자산등록팝업
function fnAddContentSh(){
	var div_nm = '<c:out value="${sh_kind}"/>';
	var pnu = '<c:out value="${pnu}"/>';
	var mode = 'preAdd';
	window.open("/Content_SH_Add_Detail.do?pnu="+pnu+"&sh_kind="+div_nm+"&mode="+ mode
			,"insertContentSh"
			,"toolbar=no, width=867, height=867,directories=no,status=no,scrollorbars=yes,resizable=yes");

}

//자산삭제
function fnDelContentSh(){shViewForm
	var div_nm = '<c:out value="${sh_kind}"/>';
	var gid = $('#select_bdhd_sh').val();
	var url = "<c:url value='/Content_SH_Del.do'/>";


	$.ajax({
		type : "POST",
		url : url,
		dataType : "html",
		data: { "sh_kind" : div_nm,"gid" : gid  },
		error : function(response, status, xhr){
			if(xhr.status =='403'){
				document.location.href = "<c:url value='/exception/pageError403.do'/>";
			}
		},
		success : function(data) {
			alert("삭제되었습니다.");
		},
		complete: function(data) {
			window.close();
		}
	});
}

//자산이력보기
function fnHistContentSh(){
	var div_nm = '<c:out value="${sh_kind}"/>';
	var gid = $('#select_bdhd_sh').val();

	window.open("/Content_SH_Hist_View.do?gid="+gid+"&sh_kind="+div_nm
			,"histContentSh"
			,"toolbar=no, width=1800, height=600,directories=no,status=no,scrollorbars=yes,resizable=yes");

}
//온나라팝업 알림창 구현해야함.
function onnara(idx,pnu){
	if(idx == "1"){
		if(confirm("씨리얼 시스템에서 제공하는 지도화면으로 이동합니다.") == true){
			window.open('https://seereal.lh.or.kr/SeerealMAP/seerealCommon/moveMap.do?center=14130421,4508557&zoom=19&layer=baseMap&pnu='+pnu);
		}
	}else if(idx == "2"){
		if(confirm("씨리얼 시스템에서 제공하는 토지이용계획확인서 열람화면으로 이동합니다.") == true){
			window.open('http://seereal.lh.or.kr/goLinkPage.do?linkMenu=1&q_pnu='+pnu);
		}

	}else{
		if(confirm("씨리얼 시스템에서 제공하는 개별공시지가 열람화면으로 이동합니다.") == true){
			window.open('http://seereal.lh.or.kr/goLinkPage.do?linkMenu=2&q_pnu='+pnu);
		}
	}
}




</script>

	<title>SH | 토지자원관리시스템</title>

</head>
<body>

	<div id="load">
	    <img src="/jsp/SH/img/ajax-loader.gif"><p>LOADING</p>
	</div>

    	<!-- 상세보기-Popup -->
        <div class="popover layer-pop detail-view new-pop" id="detail-view">
            <div class="popover-title tit">
                <span class="m-r-5"><b>상세보기</b></span>
            </div>
            <div class="popover-body">


                <div class="popover-content-wrap detail-view">
                <form id="shViewForm" name="shViewForm" class="form-horizontal"  onsubmit="return false;">
                    <div class="popover-content p-20">

                        <div class="row detail-view h100p">
                            <div class="col-xs-8 h100p">
                                <div class="card-box box1 p-0 m-b-0">
                                    <ul class="nav nav-tabs" id="dv-tablist">
                                        <li class="active"><a data-toggle="tab" href="#dv-land">토지정보</a></li>
                                        <li><a data-toggle="tab" href="#dv-buld">건축물정보</a></li>
                                    <c:if test="${!empty sh_list}">
                                    	<li><a data-toggle="tab" href="#dv-sh">자산정보</a></li>
                                    </c:if>
                                    <c:if test="${!empty data_list_1 || !empty data_list_2 || !empty data_list_3 || !empty data_list_4 || !empty data_list_5 || !empty data_list_6}">
                                    	<li><a data-toggle="tab" href="#dv-data">관련사업정보</a></li>
                                    </c:if>
                                    </ul>

                                    <input type="hidden" id="pnu" value="${pnu}"/>

                                    <div class="tab-content detail-view">

                                        <div id="dv-land" class="tab-pane fade in active">
                                        	<div class="table-wrap">

                                                <table class="table table-custom table-cen table-num text-center" width="100%">
                                                    <colgroup>
                                                        <col width="20%"/>
                                                        <col width="30%"/>
                                                        <col width="20%"/>
                                                        <col width="30%"/>
                                                    </colgroup>
                                                    <caption align="top"><b>데이터기준일자 : </b>
                                                    <c:choose>
                                                    	<c:when test="${!empty land_list_1[0].stdmt}"><span id="detail_land_stdmt"><c:out value="${land_list_1[0].stdmt}"/></span></c:when>
                                                    	<c:otherwise><span id="detail_land_stdmt">정보없음</span></c:otherwise>
                                                    </c:choose>
                                                    </caption>
                                                    <tbody>
	                                                    <tr>
	                                                        <th scope="row">소재지</th>
	                                                        <td id="detail_land_addr"><c:out value="${land_list_1[0].a3}"/>&nbsp;<c:out value="${land_list_1[0].a4}"/>
	                                                        	<input type="hidden" id="detail_land_geom" value='<c:out value="${land_list_1[0].geom}"/>'/>
					                                        	<input type="hidden" id="detail_land_addr_x" value='<c:out value="${land_list_1[0].addr_x}"/>'/>
					                                        	<input type="hidden" id="detail_land_addr_y" value='<c:out value="${land_list_1[0].addr_y}"/>'/>
	                                                        </td>
	                                                        <th>토지이용상황</th>
	                                                        <td id="detail_land_land_use"><c:out value="${land_list_1[0].land_use}"/></td>
	                                                    </tr>
	                                                    <tr>
	                                                        <th>지목(공부)</th>
	                                                        <td id="detail_land_jimok"><c:out value="${land_list_1[0].jimok}"/></td>
	                                                        <th scope="row">면적(m&sup2;)</th>
	                                                        <td id="detail_land_parea"><c:out value="${land_list_1[0].parea}"/></td>
	                                                    </tr>
	                                                    <tr>
	                                                    	<th scope="row">개별공시지가(원/m&sup2;)</th>
	                                                        <td id="detail_land_pnilp"><c:out value="${land_list_1[0].pnilp}"/></td>
	                                                        <th scope="row">도로접면</th>
	                                                        <td id="detail_land_road_side"><c:out value="${land_list_1[0].road_side}"/></td>
	                                                    </tr>
	                                                    <tr>
	                                                        <th>지형고저</th>
	                                                        <td id="detail_land_geo_hl"><c:out value="${land_list_1[0].geo_hl}"/></td>
	                                                        <th>지형형상</th>
	                                                        <td id="detail_land_geo_form"><c:out value="${land_list_1[0].geo_form}"/></td>
	                                                    </tr>
	                                                    <tr>
	                                                        <th scope="row">용도지역1</th>
	                                                        <td id="detail_land_spfc1"><c:out value="${land_list_1[0].spfc1}"/></td>
	                                                        <th>용도지역2</th>
	                                                        <td id="detail_land_spfc2"><c:out value="${land_list_1[0].spfc2}"/></td>
	                                                    </tr>
                                                    </tbody>
                                                </table>

                                                <table class="table table-custom table-cen table-num text-center" width="100%">
                                                    <colgroup>
                                                        <col width="20%"/>
                                                        <col width="30%"/>
                                                        <col width="20%"/>
                                                        <col width="30%"/>
                                                    </colgroup>
                                                    <caption align="top"><b>데이터기준일자 : </b>
                                                    <c:choose>
                                                    	<c:when test="${!empty land_list_2[0].a15}"><span id="detail_land_a15_2"><c:out value="${land_list_2[0].a15}"/></span></c:when>
                                                    	<c:otherwise><span id="detail_land_a15_2">정보없음</span></c:otherwise>
                                                    </c:choose>
                                                    </caption>
                                                    <tbody>
                                                    <tr>
                                                        <th scope="row">소유구분명</th>
                                                        <td id="detail_land_a11_2"><c:out value="${land_list_2[0].a11}"/></td>
                                                        <th>소유(공유)인수</th>
                                                        <td id="detail_land_a12_2"><c:out value="${land_list_2[0].a12}"/></td>
                                                    </tr>
                                                    </tbody>
                                                </table>

                                                <table class="table table-custom table-cen table-num text-center" width="100%">
                                                    <colgroup>
                                                        <col width="20%"/>
                                                        <col width="30%"/>
                                                        <col width="20%"/>
                                                        <col width="30%"/>
                                                    </colgroup>
                                                    <caption align="top"><b>데이터기준일자 : </b>
                                                    <c:choose>
                                                    	<c:when test="${!empty land_list_3[0].a39}"><span id="detail_land_a39_3"><c:out value="${land_list_3[0].a39}"/></span></c:when>
                                                    	<c:otherwise><span id="detail_land_a39_3">정보없음</span></c:otherwise>
                                                    </c:choose>
                                                    </caption>
                                                    <tbody>
                                                    <tr>
                                                    	<th>지목(현황)</th>
                                                        <td id="detail_land_a13_3"><c:out value="${land_list_3[0].a13}"/></td>
                                                        <th scope="row">저촉율</th>
                                                        <td id="detail_land_a23_3"><c:out value="${land_list_3[0].a23}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th scope="row">용도지구1</th>
                                                        <td id="detail_land_a20_3"><c:out value="${land_list_3[0].a20}"/></td>
                                                        <th>용도지구2</th>
                                                        <td id="detail_land_a22_3"><c:out value="${land_list_3[0].a22}"/></td>
                                                    </tr>
                                                    </tbody>
                                                </table>

                                            </div>
                                        </div>



                                        <div id="dv-buld" class="tab-pane fade">

                                        	<ul class="nav nav-tabs sub">
		                                        <li class="active"><a data-toggle="tab" href="#dv-dboh">총괄표제부</a></li>
		                                        <li><a data-toggle="tab" href="#dv-bdfc">전유부</a></li>
		                                        <li><a data-toggle="tab" href="#dv-bdhd">표제부</a></li>
		                                    </ul>
		                                    <div class="tab-content detail-view">

		                                        <div id="dv-dboh" class="tab-pane fade in active">
		                                        	<div class="table-wrap">
		                                        		<select id="select_dboh" class="form-control input-ib">
		                                        		<c:choose>
	                                                    	<c:when test="${!empty buld_list_1}">
                                                    		<c:forEach var="result" items="${buld_list_1}" varStatus="status">
                                                    			<option value="${result.manage_bild_regstr}"><c:out value="${result.plot_lc}"/></option>
	                                        				</c:forEach>
		                                        			</c:when>
	                                                    	<c:otherwise>
	                                                    		<option value="0">정보없음</option>
	                                                    	</c:otherwise>
	                                                    </c:choose>
		                                        		</select>

		                                        		<input type="hidden" id="detail_buld_dboh_geom" value='<c:out value="${buld_list_1[0].geom}"/>'/>
			                                        	<input type="hidden" id="detail_buld_dboh_addr_x" value='<c:out value="${buld_list_1[0].addr_x}"/>'/>
	                                        			<input type="hidden" id="detail_buld_dboh_addr_y" value='<c:out value="${buld_list_1[0].addr_y}"/>'/>

		                                                <table class="table table-custom table-cen table-num text-center" width="100%" id="table_dboh}">
		                                                    <colgroup>
		                                                        <col width="20%"/>
		                                                        <col width="30%"/>
		                                                        <col width="20%"/>
		                                                        <col width="30%"/>
		                                                    </colgroup>
		                                                    <caption align="top"><b>데이터기준일자 : </b>
	                                                    	<c:choose>
		                                                    	<c:when test="${!empty buld_list_1[0].creat_de}"><span id="detail_buld_dboh_creat_de"><c:out value="${buld_list_1[0].creat_de}"/></span></c:when>
		                                                    	<c:otherwise><span id="detail_buld_dboh_creat_de">정보없음</span></c:otherwise>
		                                                    </c:choose>
                                                    		</caption>
		                                                    <tbody>
		                                                    <tr>
		                                                        <th scope="row">소재지</th>
		                                                        <td id="detail_buld_dboh_plot_lc"><c:out value="${buld_list_1[0].plot_lc}"/>
		                                                        </td>
		                                                        <th>소재지(도로명)</th>
		                                                        <td id="detail_buld_dboh_rn_plot_lc"><c:out value="${buld_list_1[0].rn_plot_lc}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>건물명</th>
		                                                        <td id="detail_buld_dboh_buld_nm"><c:out value="${buld_list_1[0].buld_nm}"/></td>
		                                                        <th>특수지명</th>
		                                                        <td id="detail_buld_dboh_spcl_nmfpc"><c:out value="${buld_list_1[0].spcl_nmfpc}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>블록</th>
		                                                        <td id="detail_buld_dboh_blck"><c:out value="${buld_list_1[0].blck}"/></td>
		                                                        <th>로트</th>
		                                                        <td id="detail_buld_dboh_lot"><c:out value="${buld_list_1[0].lot}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>외필지 수</th>
		                                                        <td colspan="3" id="detail_buld_dboh_else_lot_co"><c:out value="${buld_list_1[0].else_lot_co}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>대지 면적(m&sup2;)</th>
		                                                        <td id="detail_buld_dboh_plot_ar"><c:out value="${buld_list_1[0].plot_ar}"/></td>
		                                                        <th>건축 면적(m&sup2;)</th>
		                                                        <td id="detail_buld_dboh_bildng_ar"><c:out value="${buld_list_1[0].bildng_ar}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>건폐율(%)</th>
		                                                        <td id="detail_buld_dboh_bdtldr"><c:out value="${buld_list_1[0].bdtldr}"/></td>
		                                                        <th>연면적(m&sup2;)</th>
		                                                        <td id="detail_buld_dboh_totar"><c:out value="${buld_list_1[0].totar}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>용적률(%)</th>
		                                                        <td id="detail_buld_dboh_cpcty_rt"><c:out value="${buld_list_1[0].cpcty_rt}"/></td>
		                                                        <th>용적률 산정 연면적(m&sup2;)</th>
		                                                        <td id="detail_buld_dboh_cpcty_rt_calc_totar"><c:out value="${buld_list_1[0].cpcty_rt_calc_totar}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>주 용도</th>
		                                                        <td id="detail_buld_dboh_main_prpos_code_nm"><c:out value="${buld_list_1[0].main_prpos_code_nm}"/></td>
		                                                        <th>기타 용도</th>
		                                                        <td id="detail_buld_dboh_etc_prpos"><c:out value="${buld_list_1[0].etc_prpos}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>세대 수</th>
		                                                        <td id="detail_buld_dboh_hshld_co"><c:out value="${buld_list_1[0].hshld_co}"/></td>
		                                                        <th>가구_수</th>
		                                                        <td id="detail_buld_dboh_funitre_co"><c:out value="${buld_list_1[0].funitre_co}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>주 건축물 수</th>
		                                                        <td id="detail_buld_dboh_main_bild_co"><c:out value="${buld_list_1[0].main_bild_co}"/></td>
		                                                        <th>부속 건축물 수</th>
		                                                        <td id="detail_buld_dboh_atach_bild_co"><c:out value="${buld_list_1[0].atach_bild_co}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>부속 건축물 면적</th>
		                                                        <td id="detail_buld_dboh_atach_bild_ar"><c:out value="${buld_list_1[0].atach_bild_ar}"/></td>
		                                                        <th>총 주차 수</th>
		                                                        <td id="detail_buld_dboh_floor_parkng_co"><c:out value="${buld_list_1[0].floor_parkng_co}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>옥내 기계식 대수</th>
		                                                        <td id="detail_buld_dboh_insdhous_mchne_alge"><c:out value="${buld_list_1[0].insdhous_mchne_alge}"/></td>
		                                                        <th>옥내 기계식 면적</th>
		                                                        <td id="detail_buld_dboh_insdhous_mchne_ar"><c:out value="${buld_list_1[0].insdhous_mchne_ar}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>옥외 기계식 대수</th>
		                                                        <td id="detail_buld_dboh_outhous_mchne_alge"><c:out value="${buld_list_1[0].outhous_mchne_alge}"/></td>
		                                                        <th>옥외 기계식 면적</th>
		                                                        <td id="detail_buld_dboh_outhous_mchne_ar"><c:out value="${buld_list_1[0].outhous_mchne_ar}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>옥내 자주식 대수</th>
		                                                        <td id="detail_buld_dboh_insdhous_self_alge"><c:out value="${buld_list_1[0].insdhous_self_alge}"/></td>
		                                                        <th>옥내 자주식 면적</th>
		                                                        <td id="detail_buld_dboh_insdhous_self_ar"><c:out value="${buld_list_1[0].insdhous_self_ar}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>옥외 자주식 대수</th>
		                                                        <td id="detail_buld_dboh_outhous_self_alge"><c:out value="${buld_list_1[0].outhous_self_alge}"/></td>
		                                                        <th>옥외 자주식 면적</th>
		                                                        <td id="detail_buld_dboh_outhous_self_ar"><c:out value="${buld_list_1[0].outhous_self_ar}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>허가일</th>
		                                                        <td id="detail_buld_dboh_prmisn_de"><c:out value="${buld_list_1[0].prmisn_de}"/></td>
		                                                        <th>착공일</th>
		                                                        <td id="detail_buld_dboh_strwrk_de"><c:out value="${buld_list_1[0].strwrk_de}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>사용승인일</th>
		                                                        <td id="detail_buld_dboh_use_confm_de"><c:out value="${buld_list_1[0].use_confm_de}"/></td>
		                                                        <th>호 수</th>
		                                                        <td id="detail_buld_dboh_ho_co"><c:out value="${buld_list_1[0].ho_co}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>허가번호 기관</th>
		                                                        <td id="detail_buld_dboh_prmisn_no_instt_code_nm"><c:out value="${buld_list_1[0].prmisn_no_instt_code_nm}"/></td>
		                                                        <th>허가번호 구분</th>
		                                                        <td id="detail_buld_dboh_prmisn_no_se_code_nm"><c:out value="${buld_list_1[0].prmisn_no_se_code_nm}"/></td>
		                                                    </tr>
		                                                    </tbody>
		                                                </table>
		                                            </div>
		                                        </div>

		                                        <div id="dv-bdfc" class="tab-pane fade">
		                                        	<div class="table-wrap">
		                                        		<select id="select_bdfc" class="form-control input-ib">
		                                        		<c:choose>
	                                                    	<c:when test="${!empty buld_list_2}">
	                                                    		<c:forEach var="result" items="${buld_list_2}" varStatus="status">
	                                                    			<option value="${result.manage_bild_regstr}"><c:out value="${result.ho_nm}"/></option>
		                                        				</c:forEach>
		                                        			</c:when>
	                                                    	<c:otherwise>
	                                                    		<option value="0">정보없음</option>
	                                                    	</c:otherwise>
	                                                    </c:choose>
		                                        		</select>

		                                        		<input type="hidden" id="detail_buld_bdfc_geom" value='<c:out value="${buld_list_2[0].geom}"/>'/>
			                                        	<input type="hidden" id="detail_buld_bdfc_addr_x" value='<c:out value="${buld_list_2[0].addr_x}"/>'/>
	                                        			<input type="hidden" id="detail_buld_bdfc_addr_y" value='<c:out value="${buld_list_2[0].addr_y}"/>'/>

		                                                <table class="table table-custom table-cen table-num text-center" width="100%" id="table_bdfc">
		                                                    <colgroup>
		                                                        <col width="20%"/>
		                                                        <col width="30%"/>
		                                                        <col width="20%"/>
		                                                        <col width="30%"/>
		                                                    </colgroup>
		                                                    <caption align="top"><b>데이터기준일자 : </b>
		                                                    <c:choose>
		                                                    	<c:when test="${!empty buld_list_2[0].creat_de}"><span id="detail_buld_bdfc_creat_de"><c:out value="${buld_list_2[0].creat_de}"/></span></c:when>
		                                                    	<c:otherwise><span id="detail_buld_bdfc_creat_de">정보없음</span></c:otherwise>
		                                                    </c:choose>
		                                                    </caption>
		                                                    <tbody>
		                                                    <tr>
		                                                        <th scope="row">소재지</th>
		                                                        <td id="detail_buld_bdfc_plot_lc"><c:out value="${buld_list_2[0].plot_lc}"/>
		                                                        </td>
		                                                        <th>소재지(도로명)</th>
		                                                        <td id="detail_buld_bdfc_rn_plot_lc"><c:out value="${buld_list_2[0].rn_plot_lc}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>건물명</th>
		                                                        <td id="detail_buld_bdfc_buld_nm"><c:out value="${buld_list_2[0].buld_nm}"/></td>
		                                                        <th>특수지명</th>
		                                                        <td id="detail_buld_bdfc_spcl_nmfpc"><c:out value="${buld_list_2[0].spcl_nmfpc}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>블록</th>
		                                                        <td id="detail_buld_bdfc_blck"><c:out value="${buld_list_2[0].blck}"/></td>
		                                                        <th>로트</th>
		                                                        <td id="detail_buld_bdfc_lot"><c:out value="${buld_list_2[0].lot}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>동 명</th>
		                                                        <td id="detail_buld_bdfc_dong_nm"><c:out value="${buld_list_2[0].dong_nm}"/></td>
		                                                        <th>호 명</th>
		                                                        <td id="detail_buld_bdfc_ho_nm"><c:out value="${buld_list_2[0].ho_nm}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>층 구분명</th>
		                                                        <td id="detail_buld_bdfc_floor_se_code_nm"><c:out value="${buld_list_2[0].floor_se_code_nm}"/></td>
		                                                        <th>층 번호</th>
		                                                        <td id="detail_buld_bdfc_floor_no"><c:out value="${buld_list_2[0].floor_no}"/></td>
		                                                    </tr>
		                                                    </tbody>
		                                                </table>
		                                            </div>
		                                        </div>

		                                        <div id="dv-bdhd" class="tab-pane fade">
		                                        	<div class="table-wrap" id="table_bdhd">
		                                        		<select id="select_bdhd" class="form-control input-ib">
		                                        		<c:choose>
	                                                    	<c:when test="${!empty buld_list_3}">
	                                                    		<c:forEach var="result" items="${buld_list_3}" varStatus="status">
	                                                    			<option value="${result.manage_bild_regstr}"><c:out value="${result.plot_lc}"/></option>
		                                        				</c:forEach>
		                                        			</c:when>
	                                                    	<c:otherwise>
	                                                    		<option value="0">정보없음</option>
	                                                    	</c:otherwise>
	                                                    </c:choose>
		                                        		</select>

		                                        		<input type="hidden" id="detail_buld_bdhd_geom" value='<c:out value="${buld_list_3[0].geom}"/>'/>
						                                <input type="hidden" id="detail_buld_bdhd_addr_x" value='<c:out value="${buld_list_3[0].addr_x}"/>'/>
				                                        <input type="hidden" id="detail_buld_bdhd_addr_y" value='<c:out value="${buld_list_3[0].addr_y}"/>'/>

		                                                <table class="table table-custom table-cen table-num text-center" width="100%" id="table_bdhd">
		                                                    <colgroup>
		                                                        <col width="20%"/>
		                                                        <col width="30%"/>
		                                                        <col width="20%"/>
		                                                        <col width="30%"/>
		                                                    </colgroup>
		                                                    <caption align="top"><b>데이터기준일자 : </b>
		                                                    <c:choose>
		                                                    	<c:when test="${!empty buld_list_3[0].creat_de}"><span id="detail_buld_bdhd_creat_de"><c:out value="${buld_list_3[0].creat_de}"/></span></c:when>
		                                                    	<c:otherwise><span id="detail_buld_bdhd_creat_de">정보없음</span></c:otherwise>
		                                                    </c:choose>
		                                                    </caption>
		                                                    <tbody>
		                                                    <tr>
		                                                        <th scope="row">소재지</th>
		                                                        <td id="detail_buld_bdhd_plot_lc"><c:out value="${buld_list_3[0].plot_lc}"/>

		                                                        </td>
		                                                        <th>소재지(도로명)</th>
		                                                        <td id="detail_buld_bdhd_rn_plot_lc"><c:out value="${buld_list_3[0].rn_plot_lc}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>건물명</th>
		                                                        <td id="detail_buld_bdhd_buld_nm"><c:out value="${buld_list_3[0].buld_nm}"/></td>
		                                                        <th>특수지명</th>
		                                                        <td id="detail_buld_bdhd_spcl_nmfpc"><c:out value="${buld_list_3[0].spcl_nmfpc}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>블록</th>
		                                                        <td id="detail_buld_bdhd_blck"><c:out value="${buld_list_3[0].blck}"/></td>
		                                                        <th>로트</th>
		                                                        <td id="detail_buld_bdhd_lot"><c:out value="${buld_list_3[0].lot}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>외필지 수</th>
		                                                        <td colspan="3" id="detail_buld_bdhd_else_lot_co"><c:out value="${buld_list_3[0].else_lot_co}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>대지 면적(m&sup2;)</th>
		                                                        <td id="detail_buld_bdhd_plot_ar"><c:out value="${buld_list_3[0].plot_ar}"/></td>
		                                                        <th>건축 면적(m&sup2;)</th>
		                                                        <td id="detail_buld_bdhd_bildng_ar"><c:out value="${buld_list_3[0].bildng_ar}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>건폐율(%)</th>
		                                                        <td id="detail_buld_bdhd_bdtldr"><c:out value="${buld_list_3[0].bdtldr}"/></td>
		                                                        <th>연면적(m&sup2;)</th>
		                                                        <td id="detail_buld_bdhd_totar"><c:out value="${buld_list_3[0].totar}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>용적률(%)</th>
		                                                        <td id="detail_buld_bdhd_cpcty_rt"><c:out value="${buld_list_3[0].cpcty_rt}"/></td>
		                                                        <th>용적률 산정 연면적(m&sup2;)</th>
		                                                        <td id="detail_buld_bdhd_cpcty_rt_calc_totar"><c:out value="${buld_list_3[0].cpcty_rt_calc_totar}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>구조</th>
		                                                        <td id="detail_buld_bdhd_strct_code_nm"><c:out value="${buld_list_3[0].strct_code_nm}"/></td>
		                                                        <th>기타 구조</th>
		                                                        <td id="detail_buld_bdhd_etc_strct"><c:out value="${buld_list_3[0].etc_strct}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>주 용도</th>
		                                                        <td id="detail_buld_bdhd_main_prpos_code_nm"><c:out value="${buld_list_3[0].main_prpos_code_nm}"/></td>
		                                                        <th>기타 용도</th>
		                                                        <td id="detail_buld_bdhd_etc_prpos"><c:out value="${buld_list_3[0].etc_prpos}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>지붕 코드</th>
		                                                        <td id="detail_buld_bdhd_rf_code_nm"><c:out value="${buld_list_3[0].rf_code_nm}"/></td>
		                                                        <th>기타 지붕</th>
		                                                        <td id="detail_buld_bdhd_etc_rf"><c:out value="${buld_list_3[0].etc_rf}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>세대 수</th>
		                                                        <td id="detail_buld_bdhd_hshld_co"><c:out value="${buld_list_3[0].hshld_co}"/></td>
		                                                        <th>가구 수</th>
		                                                        <td id="detail_buld_bdhd_funitre_co"><c:out value="${buld_list_3[0].funitre_co}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>높이</th>
		                                                        <td id="detail_buld_bdhd_hg"><c:out value="${buld_list_3[0].hg}"/></td>
		                                                        <th>지상 층 수</th>
		                                                        <td id="detail_buld_bdhd_ground_floor_co"><c:out value="${buld_list_3[0].ground_floor_co}"/></td>
		                                                    </tr>
		                                                     <tr>
		                                                        <th>지하 층 수</th>
		                                                        <td id="detail_buld_bdhd_undgrnd_floor_co"><c:out value="${buld_list_3[0].undgrnd_floor_co}"/></td>
		                                                        <th>승용 승강기 수</th>
		                                                        <td id="detail_buld_bdhd_rdng_elvtr_co"><c:out value="${buld_list_3[0].rdng_elvtr_co}"/></td>
		                                                    </tr>
		                                                     <tr>
		                                                        <th>비상용 승강기 수</th>
		                                                        <td id="detail_buld_bdhd_emgnc_elvtr_co"><c:out value="${buld_list_3[0].emgnc_elvtr_co}"/></td>
		                                                        <th>부속 건축물 수</th>
		                                                        <td id="detail_buld_bdhd_atach_bild_co"><c:out value="${buld_list_3[0].atach_bild_co}"/></td>
		                                                    </tr>
		                                                     <tr>
		                                                        <th>부속 건축물 면적</th>
		                                                        <td id="detail_buld_bdhd_atach_bild_ar"><c:out value="${buld_list_3[0].atach_bild_ar}"/></td>
		                                                        <th>총 동 연면적</th>
		                                                        <td id="detail_buld_bdhd_floor_dong_totar"><c:out value="${buld_list_3[0].floor_dong_totar}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>옥내 기계식 대수</th>
		                                                        <td id="detail_buld_bdhd_insdhous_mchne_alge"><c:out value="${buld_list_3[0].insdhous_mchne_alge}"/></td>
		                                                        <th>옥내 기계식 면적</th>
		                                                        <td id="detail_buld_bdhd_insdhous_mchne_ar"><c:out value="${buld_list_3[0].insdhous_mchne_ar}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>옥외 기계식 대수</th>
		                                                        <td id="detail_buld_bdhd_outhous_mchne_alge"><c:out value="${buld_list_3[0].outhous_mchne_alge}"/></td>
		                                                        <th>옥외 기계식 면적</th>
		                                                        <td id="detail_buld_bdhd_outhous_mchne_ar"><c:out value="${buld_list_3[0].outhous_mchne_ar}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>옥내 자주식 대수</th>
		                                                        <td id="detail_buld_bdhd_insdhous_self_alge"><c:out value="${buld_list_3[0].insdhous_self_alge}"/></td>
		                                                        <th>옥내 자주식 면적</th>
		                                                        <td id="detail_buld_bdhd_insdhous_self_ar"><c:out value="${buld_list_3[0].insdhous_self_ar}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>옥외 자주식 대수</th>
		                                                        <td id="detail_buld_bdhd_outhous_self_alge"><c:out value="${buld_list_3[0].outhous_self_alge}"/></td>
		                                                        <th>옥외 자주식 면적</th>
		                                                        <td id="detail_buld_bdhd_outhous_self_ar"><c:out value="${buld_list_3[0].outhous_self_ar}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>허가일</th>
		                                                        <td id="detail_buld_bdhd_prmisn_de"><c:out value="${buld_list_3[0].prmisn_de}"/></td>
		                                                        <th>착공일</th>
		                                                        <td id="detail_buld_bdhd_strwrk_de"><c:out value="${buld_list_3[0].strwrk_de}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>사용승인일</th>
		                                                        <td id="detail_buld_bdhd_use_confm_de"><c:out value="${buld_list_3[0].use_confm_de}"/></td>
		                                                        <th>호 수</th>
		                                                        <td id="detail_buld_bdhd_ho_co"><c:out value="${buld_list_3[0].ho_co}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>허가번호 기관</th>
		                                                        <td id="detail_buld_bdhd_prmisn_no_instt_code_nm"><c:out value="${buld_list_3[0].prmisn_no_instt_code_nm}"/></td>
		                                                        <th>허가번호 구분</th>
		                                                        <td id="detail_buld_bdhd_prmisn_no_se_code_nm"><c:out value="${buld_list_3[0].prmisn_no_se_code_nm}"/></td>
		                                                    </tr>
		                                                    </tbody>
		                                                </table>
		                                            </div>
		                                        </div>
		                                    </div>

                                        </div>



                                        <div id="dv-sh" class="tab-pane fade">
		                                    <div class="tab-content detail-view">
		                                        <div class="table-wrap" id="table_sh">
		                                        	<input type="hidden" id="detail_sh_geom" value='<c:out value="${sh_list[0].geom_as}"/>'/>
		                                        	<input type="hidden" id="detail_sh_addr_x" value='<c:out value="${sh_list[0].addr_x}"/>'/>
                                        			<input type="hidden" id="detail_sh_addr_y" value='<c:out value="${sh_list[0].addr_y}"/>'/>



                                        			<div class="col-xs-4">
	                                        		</div>
	                                        		<div class="col-xs-8">
									                    <div class="btn-wrap text-right">
<!-- 									                      <button type="button" class="btn btn-sm btn-teal w-xs btnAdd">등록</button> -->
<!-- 									                      <button type="button" class="btn btn-sm btn-teal w-xs btnUpdate">수정</button> -->
<!-- 									                      <button type="button" class="btn btn-sm btn-danger w-xs btnDelete">삭제</button> -->
<!-- 									                      <button type="button" class="btn btn-sm btn-md w-xs btnHist">이력조회</button>     -->
									                    </div>
								                    </div>

	                                        		<c:if test="${sh_kind eq 'data_guk_land'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_guk_land.jsp"></c:import>
	                                        		</c:if>
	                                        		<c:if test="${sh_kind eq 'data_tmseq_land'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_tmseq_land.jsp"></c:import>
	                                        		</c:if>
	                                        		<c:if test="${sh_kind eq 'data_region_land'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_region_land.jsp"></c:import>
	                                        		</c:if>
	                                        		<c:if test="${sh_kind eq 'data_owned_city'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_owned_city.jsp"></c:import>
	                                        		</c:if>
	                                        		<c:if test="${sh_kind eq 'data_owned_guyu'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_owned_guyu.jsp"></c:import>
	                                        		</c:if>
	                                        		<c:if test="${sh_kind eq 'data_residual_land'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_residual_land.jsp"></c:import>
	                                        		</c:if>
	                                        		<c:if test="${sh_kind eq 'data_unsold_land'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_unsold_land.jsp"></c:import>
	                                        		</c:if>
	                                        		<c:if test="${sh_kind eq 'data_invest'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_invest.jsp"></c:import>
	                                        		</c:if>
	                                        		<c:if test="${sh_kind eq 'data_public_site'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_public_site.jsp"></c:import>
	                                        		</c:if>
	                                        		<c:if test="${sh_kind eq 'data_public_parking'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_public_parking.jsp"></c:import>
	                                        		</c:if>
	                                        		<c:if test="${sh_kind eq 'data_generations'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_generations.jsp"></c:import>
	                                        		</c:if>
	                                        		<c:if test="${sh_kind eq 'data_council_land'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_council_land.jsp"></c:import>
	                                        		</c:if>
	                                        		<c:if test="${sh_kind eq 'data_minuse'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_minuse.jsp"></c:import>
	                                        		</c:if>
	                                        		<c:if test="${sh_kind eq 'data_industry'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_industry.jsp"></c:import>
	                                        		</c:if>
	                                        		<c:if test="${sh_kind eq 'data_priority'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_priority.jsp"></c:import>
	                                        		</c:if>


	                                        		<c:if test="${sh_kind eq 'data_guk_buld'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_guk_land.jsp"></c:import>
	                                        		</c:if>
	                                        		<c:if test="${sh_kind eq 'data_tmseq_buld'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_tmseq_land.jsp"></c:import>
	                                        		</c:if>
	                                        		<c:if test="${sh_kind eq 'data_region_buld'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_region_land.jsp"></c:import>
	                                        		</c:if>
	                                        		<c:if test="${sh_kind eq 'data_owned_region'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_owned_city.jsp"></c:import>
	                                        		</c:if>
	                                        		<c:if test="${sh_kind eq 'data_owned_seoul'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_owned_city.jsp"></c:import>
	                                        		</c:if>
	                                        		<c:if test="${sh_kind eq 'data_cynlst'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_cynlst.jsp"></c:import>
	                                        		</c:if>
<%-- 	                                        		<c:if test="${sh_kind eq 'data_public_buld_a'}"> --%>
<%-- 	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_public_buld_a.jsp"></c:import> --%>
<%-- 	                                        		</c:if> --%>
<%-- 	                                        		<c:if test="${sh_kind eq 'data_public_buld_b'}"> --%>
<%-- 	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_public_buld_b.jsp"></c:import> --%>
<%-- 	                                        		</c:if> --%>
	                                        		<c:if test="${sh_kind eq 'data_public_buld_c'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_public_buld_c.jsp"></c:import>
	                                        		</c:if>
<%-- 	                                        		<c:if test="${sh_kind eq 'data_public_asbu'}"> --%>
<%-- 	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_public_asbu.jsp"></c:import> --%>
<%-- 	                                        		</c:if> --%>
													<c:if test="${sh_kind eq 'data_purchase'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_purchase.jsp"></c:import>
	                                        		</c:if>
	                                        		<c:if test="${sh_kind eq 'data_declining'}">
	                                        			<c:import url="/jsp/SH/landhist/detail/Detail_declining.jsp"></c:import>
	                                        		</c:if>

		                                    	</div>
		                                    </div>
                                        </div>




                                        <div id="dv-data" class="tab-pane fade">
                                        	<ul class="nav nav-tabs sub">
                                               	<c:if test="${!empty data_list_1}"><li><a data-toggle="tab" href="#dv-city_activation">도시재생활성화지역</a></li></c:if>
                                   				<c:if test="${!empty data_list_2}"><li><a data-toggle="tab" href="#dv-house_envment">주거환경관리사업</a></li></c:if>
                                   				<c:if test="${!empty data_list_3}"><li><a data-toggle="tab" href="#dv-hope_land">희망지</a></li></c:if>
                                   				<c:if test="${!empty data_list_4}"><li><a data-toggle="tab" href="#dv-release_area">해제구역</a></li></c:if>
                                   				<c:if test="${!empty data_list_5}"><li><a data-toggle="tab" href="#dv-sub_p_decline">도시재생쇠퇴지역</a></li></c:if>
                                   				<c:if test="${!empty data_list_6}"><li><a data-toggle="tab" href="#dv-public_transport">대중교통역세권</a></li></c:if>
                                               	<c:if test="${empty data_list_1 && empty data_list_2 && empty data_list_3 && empty data_list_4 && empty data_list_5 && empty data_list_6}">
                                               		<li><a data-toggle="tab" href="#dv-data-ex">정보없음</a></li>
                                               	</c:if>
		                                    </ul>
		                                    <div class="tab-content detail-view">

                                               	<c:if test="${!empty data_list_1}">
												<div id="dv-city_activation" class="tab-pane fade">
		                                        	<div class="table-wrap">
		                                        		<table class="table table-custom table-cen table-num text-center" width="100%">
		                                                    <colgroup>
		                                                        <col width="20%"/>
		                                                        <col width="30%"/>
		                                                        <col width="20%"/>
		                                                        <col width="30%"/>
		                                                    </colgroup>
		                                                    <caption align="top"><b>데이터기준일자 : </b>
	                                                    	<c:choose>
		                                                    	<c:when test="${!empty data_list_1}"><span id="detail_city_activation_date">2017</span></c:when>
		                                                    	<c:otherwise><span id="detail_city_activation_date">정보없음</span></c:otherwise>
		                                                    </c:choose>
                                                    		</caption>
		                                                    <tbody>
		                                                    <tr>
		                                                        <th scope="row">ID</th>
		                                                        <td id="detail_city_activation_id"><c:out value="${data_list_1[0].id}"/>
		                                                        	<input type="hidden" id="detail_city_activation_geom" value='<c:out value="${data_list_1[0].geom_as}"/>'/>
						                                        	<input type="hidden" id="detail_city_activation_addr_x" value='<c:out value="${data_list_1[0].addr_x}"/>'/>
				                                        			<input type="hidden" id="detail_city_activation_addr_y" value='<c:out value="${data_list_1[0].addr_y}"/>'/>
		                                                        </td>
		                                                        <th>구분</th>
		                                                        <td id="detail_city_activation_gubun"><c:out value="${data_list_1[0].gubun}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>구역명</th>
		                                                        <td id="detail_city_activation_area_name"><c:out value="${data_list_1[0].area_name}"/></td>
		                                                        <th>사업유형</th>
		                                                        <td id="detail_city_activation_business_type"><c:out value="${data_list_1[0].business_type}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>서울시유형</th>
		                                                        <td id="detail_city_activation_seoul_type"><c:out value="${data_list_1[0].seoul_type}"/></td>
		                                                        <th>자치구</th>
		                                                        <td id="detail_city_activation_jache_gu"><c:out value="${data_list_1[0].jache_gu}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>위치</th>
		                                                        <td id="detail_city_activation_location"><c:out value="${data_list_1[0].location}"/></td>
		                                                        <th>면적(m&sup2;)</th>
		                                                        <td id="detail_city_activation_area_space"><c:out value="${data_list_1[0].area_space}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>선정방식</th>
		                                                        <td id="detail_city_activation_choice_howto"><c:out value="${data_list_1[0].choice_howto}"/></td>
		                                                        <th>총 사업비</th>
		                                                        <td id="detail_city_activation_total_money"><c:out value="${data_list_1[0].total_money}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>사업기간</th>
		                                                        <td id="detail_city_activation_business_date"><c:out value="${data_list_1[0].business_date}"/></td>
		                                                        <th>추진단계</th>
		                                                        <td id="detail_city_activation_execution_phase"><c:out value="${data_list_1[0].execution_phase}"/></td>
		                                                    </tr>
		                                                    </tbody>
		                                                </table>
		                                            </div>
		                                        </div>
												</c:if>
                                   				<c:if test="${!empty data_list_2}">
                                   				<div id="dv-house_envment" class="tab-pane fade">
		                                        	<div class="table-wrap">
		                                        		<table class="table table-custom table-cen table-num text-center" width="100%">
		                                                    <colgroup>
		                                                        <col width="20%"/>
		                                                        <col width="30%"/>
		                                                        <col width="20%"/>
		                                                        <col width="30%"/>
		                                                    </colgroup>
		                                                    <caption align="top"><b>데이터기준일자 : </b>
	                                                    	<c:choose>
		                                                    	<c:when test="${!empty data_list_2}"><span id="detail_house_envment_date">2017</span></c:when>
		                                                    	<c:otherwise><span id="detail_house_envment_date">정보없음</span></c:otherwise>
		                                                    </c:choose>
	                                                   		</caption>
		                                                    <tbody>
		                                                    <tr>
		                                                        <th scope="row">ID</th>
		                                                        <td id="detail_house_envment_id"><c:out value="${data_list_2[0].id}"/>
		                                                        	<input type="hidden" id="detail_house_envment_geom" value='<c:out value="${data_list_2[0].geom_as}"/>'/>
						                                        	<input type="hidden" id="detail_house_envment_addr_x" value='<c:out value="${data_list_2[0].addr_x}"/>'/>
				                                        			<input type="hidden" id="detail_house_envment_addr_y" value='<c:out value="${data_list_2[0].addr_y}"/>'/>
		                                                        </td>
		                                                        <th>구분</th>
		                                                        <td id="detail_house_envment_gubun"><c:out value="${data_list_2[0].gubun}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>구역명</th>
		                                                        <td id="detail_house_envment_area_name"><c:out value="${data_list_2[0].area_name}"/></td>
		                                                        <th>자치구</th>
		                                                        <td id="detail_house_envment_jache_gu"><c:out value="${data_list_2[0].jache_gu}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>위치</th>
		                                                        <td id="detail_house_envment_location"><c:out value="${data_list_2[0].location}"/></td>
		                                                        <th>면적(m&sup2;)</th>
		                                                        <td id="detail_house_envment_area_space"><c:out value="${data_list_2[0].area_space}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>지역지구</th>
		                                                        <td id="detail_house_envment_area_earth"><c:out value="${data_list_2[0].area_earth}"/></td>
		                                                        <th>선정</th>
		                                                        <td id="detail_house_envment_choice"><c:out value="${data_list_2[0].choice}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>추진단계</th>
		                                                        <td id="detail_house_envment_execution_phase"><c:out value="${data_list_2[0].execution_phase}"/></td>
		                                                        <th>추진일</th>
		                                                        <td id="detail_house_envment_execution_date"><c:out value="${data_list_2[0].execution_date}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>주민조직</th>
		                                                        <td id="detail_house_envment_human_group"><c:out value="${data_list_2[0].human_group}"/></td>
		                                                        <th>특성</th>
		                                                        <td id="detail_house_envment_charact"><c:out value="${data_list_2[0].charact}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>해제일</th>
		                                                        <td id="detail_house_envment_release_date"><c:out value="${data_list_2[0].release_date}"/></td>
		                                                        <th>비고</th>
		                                                        <td id="detail_house_envment_etc"><c:out value="${data_list_2[0].etc}"/></td>
		                                                    </tr>
		                                                    </tbody>
		                                                </table>
		                                            </div>
		                                        </div>
												</c:if>
                                   				<c:if test="${!empty data_list_3}">
                                   				<div id="dv-hope_land" class="tab-pane fade">
		                                        	<div class="table-wrap">
		                                        		<table class="table table-custom table-cen table-num text-center" width="100%">
		                                                    <colgroup>
		                                                        <col width="20%"/>
		                                                        <col width="30%"/>
		                                                        <col width="20%"/>
		                                                        <col width="30%"/>
		                                                    </colgroup>
		                                                    <caption align="top"><b>데이터기준일자 : </b>
	                                                    	<c:choose>
		                                                    	<c:when test="${!empty data_list_3}"><span id="detail_hope_land_date">2017</span></c:when>
		                                                    	<c:otherwise><span id="detail_hope_land_date">정보없음</span></c:otherwise>
		                                                    </c:choose>
	                                                   		</caption>
		                                                    <tbody>
		                                                    <tr>
		                                                        <th scope="row">ID</th>
		                                                        <td id="detail_hope_land_id"><c:out value="${data_list_3[0].id}"/>
		                                                        	<input type="hidden" id="detail_hope_land_geom" value='<c:out value="${data_list_3[0].geom_as}"/>'/>
						                                        	<input type="hidden" id="detail_hope_land_addr_x" value='<c:out value="${data_list_3[0].addr_x}"/>'/>
				                                        			<input type="hidden" id="detail_hope_land_addr_y" value='<c:out value="${data_list_3[0].addr_y}"/>'/>
		                                                        </td>
		                                                        <th>구분</th>
		                                                        <td id="detail_hope_land_gubun"><c:out value="${data_list_3[0].gubun}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>구역명</th>
		                                                        <td id="detail_hope_land_area_name"><c:out value="${data_list_3[0].area_name}"/></td>
		                                                        <th>사업유형</th>
		                                                        <td id="detail_hope_land_business_type"><c:out value="${data_list_3[0].business_type}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>자치구</th>
		                                                        <td id="detail_hope_land_jache_gu"><c:out value="${data_list_3[0].jache_gu}"/></td>
		                                                        <th>위치</th>
		                                                        <td id="detail_hope_land_location"><c:out value="${data_list_3[0].location}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>면적(m&sup2;)</th>
		                                                        <td id="detail_hope_land_area_space"><c:out value="${data_list_3[0].area_space}"/></td>
		                                                        <th>뉴타운해제</th>
		                                                        <td id="detail_hope_land_newtown"><c:out value="${data_list_3[0].newtown}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>해제사항</th>
		                                                        <td id="detail_hope_land_relrease_cause"><c:out value="${data_list_3[0].relrease_cause}"/></td>
		                                                        <th>해제연도</th>
		                                                        <td id="detail_hope_land_relrease_year"><c:out value="${data_list_3[0].relrease_year}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>쇠퇴지수</th>
		                                                        <td id="detail_hope_land_decline_index"><c:out value="${data_list_3[0].decline_index}"/></td>
		                                                        <th>특성1</th>
		                                                        <td id="detail_hope_land_charact"><c:out value="${data_list_3[0].charact}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>특성2</th>
		                                                        <td id="detail_hope_land_charact2"><c:out value="${data_list_3[0].charact2}"/></td>
		                                                        <th>특성3 지역</th>
		                                                        <td id="detail_hope_land_charact3_area"><c:out value="${data_list_3[0].charact3_area}"/></td>
		                                                    </tr>
		                                                    </tbody>
		                                                </table>
		                                            </div>
		                                        </div>
                                   				</c:if>
                                   				<c:if test="${!empty data_list_4}">
                                   				<div id="dv-release_area" class="tab-pane fade">
		                                        	<div class="table-wrap">
		                                        		<table class="table table-custom table-cen table-num text-center" width="100%">
		                                                    <colgroup>
		                                                        <col width="20%"/>
		                                                        <col width="30%"/>
		                                                        <col width="20%"/>
		                                                        <col width="30%"/>
		                                                    </colgroup>
		                                                    <caption align="top"><b>데이터기준일자 : </b>
	                                                    	<c:choose>
		                                                    	<c:when test="${!empty data_list_4}"><span id="detail_release_area_date">2017</span></c:when>
		                                                    	<c:otherwise><span id="detail_release_area_date">정보없음</span></c:otherwise>
		                                                    </c:choose>
	                                                   		</caption>
		                                                    <tbody>
		                                                    <tr>
		                                                        <th scope="row">ID</th>
		                                                        <td id="detail_release_area_id"><c:out value="${data_list_4[0].id}"/>
		                                                        	<input type="hidden" id="detail_release_area_geom" value='<c:out value="${data_list_4[0].geom_as}"/>'/>
						                                        	<input type="hidden" id="detail_release_area_addr_x" value='<c:out value="${data_list_4[0].addr_x}"/>'/>
				                                        			<input type="hidden" id="detail_release_area_addr_y" value='<c:out value="${data_list_4[0].addr_y}"/>'/>
		                                                        </td>
		                                                        <th>구분</th>
		                                                        <td id="detail_release_area_gubun"><c:out value="${data_list_4[0].gubun}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>구역명</th>
		                                                        <td id="detail_release_area_area_name"><c:out value="${data_list_4[0].area_name}"/></td>
		                                                        <th>사업유형</th>
		                                                        <td id="detail_release_area_business_type"><c:out value="${data_list_4[0].business_type}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>자치구</th>
		                                                        <td id="detail_release_area_jache_gu"><c:out value="${data_list_4[0].jache_gu}"/></td>
		                                                        <th>위치</th>
		                                                        <td id="detail_release_area_location"><c:out value="${data_list_4[0].location}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>면적(m&sup2;)</th>
		                                                        <td id="detail_release_area_area_space"><c:out value="${data_list_4[0].area_space}"/></td>
		                                                        <th>해제일자</th>
		                                                        <td id="detail_release_area_release_date"><c:out value="${data_list_4[0].release_date}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>비고 해제</th>
		                                                        <td id="detail_release_area_bigo_release"><c:out value="${data_list_4[0].bigo_release}"/></td>
		                                                        <th>고시번호</th>
		                                                        <td id="detail_release_area_gosi_num"><c:out value="${data_list_4[0].gosi_num}"/></td>
		                                                    </tr>
		                                                    </tbody>
		                                                </table>
		                                            </div>
		                                        </div>
	                                    		</c:if>
                                   				<c:if test="${!empty data_list_5}">
                                   				<div id="dv-sub_p_decline" class="tab-pane fade">
		                                        	<div class="table-wrap">
		                                        		<table class="table table-custom table-cen table-num text-center" width="100%">
		                                                    <colgroup>
		                                                        <col width="20%"/>
		                                                        <col width="30%"/>
		                                                        <col width="20%"/>
		                                                        <col width="30%"/>
		                                                    </colgroup>
		                                                    <caption align="top"><b>데이터기준일자 : </b>
	                                                    	<c:choose>
		                                                    	<c:when test="${!empty data_list_5}"><span id="detail_sub_p_decline_date">2017</span></c:when>
		                                                    	<c:otherwise><span id="detail_sub_p_decline_date">정보없음</span></c:otherwise>
		                                                    </c:choose>
	                                                   		</caption>
		                                                    <tbody>
		                                                    <tr>
		                                                        <th scope="row">행정동 코드</th>
		                                                        <td id="detail_sub_p_decline_adm_dr_cd"><c:out value="${data_list_5[0].adm_dr_cd}"/>
		                                                        	<input type="hidden" id="detail_sub_p_decline_geom" value='<c:out value="${data_list_5[0].geom_as}"/>'/>
						                                        	<input type="hidden" id="detail_sub_p_decline_addr_x" value='<c:out value="${data_list_5[0].addr_x}"/>'/>
				                                        			<input type="hidden" id="detail_sub_p_decline_addr_y" value='<c:out value="${data_list_5[0].addr_y}"/>'/>
		                                                        </td>
		                                                        <th>행정동 명칭</th>
		                                                        <td id="detail_sub_p_decline_adm_dr_nm"><c:out value="${data_list_5[0].adm_dr_nm}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>근린</th>
		                                                        <td id="detail_sub_p_decline_recycle"><c:out value="${data_list_5[0].recycle}"/></td>
		                                                        <th>경제</th>
		                                                        <td id="detail_sub_p_decline_economy"><c:out value="${data_list_5[0].economy}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>인구</th>
		                                                        <td id="detail_sub_p_decline_population"><c:out value="${data_list_5[0].population}"/></td>
		                                                        <th>산업</th>
		                                                        <td id="detail_sub_p_decline_industry"><c:out value="${data_list_5[0].industry}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>건강</th>
		                                                        <td id="detail_sub_p_decline_physical"><c:out value="${data_list_5[0].physical}"/></td>
		                                                        <th>구역</th>
		                                                        <td id="detail_sub_p_decline_sector"><c:out value="${data_list_5[0].sector}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>복합</th>
		                                                        <td id="detail_sub_p_decline_multiple"><c:out value="${data_list_5[0].multiple}"/></td>
		                                                    </tr>
		                                                    </tbody>
		                                                </table>
		                                            </div>
		                                        </div>
	                                    		</c:if>
                                   				<c:if test="${!empty data_list_6}">
                                    			<div id="dv-public_transport" class="tab-pane fade">
		                                        	<div class="table-wrap">
		                                        		<table class="table table-custom table-cen table-num text-center" width="100%">
		                                                    <colgroup>
		                                                        <col width="20%"/>
		                                                        <col width="30%"/>
		                                                        <col width="20%"/>
		                                                        <col width="30%"/>
		                                                    </colgroup>
		                                                    <caption align="top"><b>데이터기준일자 : </b>
	                                                    	<c:choose>
		                                                    	<c:when test="${!empty data_list_6}"><span id="detail_public_transport_date">2017</span></c:when>
		                                                    	<c:otherwise><span id="detail_public_transport_date">정보없음</span></c:otherwise>
		                                                    </c:choose>
                                                    		</caption>
		                                                    <tbody>
		                                                    <tr>
		                                                        <th scope="row">대표번</th>
		                                                        <td id="detail_public_transport_represen_num"><c:out value="${data_list_6[0].represen_num}"/>
		                                                        	<input type="hidden" id="detail_public_transport_geom" value='<c:out value="${data_list_6[0].geom_as}"/>'/>
						                                        	<input type="hidden" id="detail_public_transport_addr_x" value='<c:out value="${data_list_6[0].addr_x}"/>'/>
				                                        			<input type="hidden" id="detail_public_transport_addr_y" value='<c:out value="${data_list_6[0].addr_y}"/>'/>
		                                                        </td>
		                                                        <th>지하철</th>
		                                                        <td id="detail_public_transport_subway"><c:out value="${data_list_6[0].subway}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>권역</th>
		                                                        <td id="detail_public_transport_area_circle"><c:out value="${data_list_6[0].area_circle}"/></td>
		                                                        <th>대표노</th>
		                                                        <td id="detail_public_transport_represen_route"><c:out value="${data_list_6[0].represen_route}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>자치구</th>
		                                                        <td id="detail_public_transport_jache_gu"><c:out value="${data_list_6[0].jache_gu}"/></td>
		                                                        <th>대중교</th>
		                                                        <td id="detail_public_transport_public_transport"><c:out value="${data_list_6[0].public_transport}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>역사도</th>
		                                                        <td id="detail_public_transport_history"><c:out value="${data_list_6[0].history}"/></td>
		                                                        <th>교차역</th>
		                                                        <td id="detail_public_transport_intersection"><c:out value="${data_list_6[0].intersection}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>교차노</th>
		                                                        <td id="detail_public_transport_intersection_route"><c:out value="${data_list_6[0].intersection_route}"/></td>
		                                                        <th>버스전</th>
		                                                        <td id="detail_public_transport_bus_jun"><c:out value="${data_list_6[0].bus_jun}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>인접도</th>
		                                                        <td id="detail_public_transport_near_load"><c:out value="${data_list_6[0].near_load}"/></td>
		                                                        <th>upis</th>
		                                                        <td id="detail_public_transport_upis"><c:out value="${data_list_6[0].upis}"/></td>
		                                                    </tr>
		                                                    <tr>
		                                                        <th>도로폭</th>
		                                                        <td id="detail_public_transport_load_size"><c:out value="${data_list_6[0].load_size}"/></td>
		                                                    </tr>
		                                                    </tbody>
		                                                </table>
		                                            </div>
		                                        </div>
		                                    	</c:if>
                                               	<c:if test="${empty data_list_1 && empty data_list_2 && empty data_list_3 && empty data_list_4 && empty data_list_5 && empty data_list_6}">
                                              	<div id="dv-data-ex" class="tab-pane fade">
		                                        	<div class="table-wrap">
		                                        		<span>정보없음</span>
		                                            </div>
		                                        </div>
                                               	</c:if>
		                                    </div>
                                        </div>





                                    </div>
                                </div>
                            </div>


                            <div class="col-xs-4 h100p">

                                <div class="row h50p">
                                    <div class="col-xs-12 h100p">
                                        <div class="card-box box2 h100p" id="geomap_mini"></div>
                                    </div>
                                </div>

                                <div class="row box3-wrap">
                                    <div class="col-xs-12 h100p">
                                        <div class="card-box box3 m-b-0 h100p" id="potalmap_mini"></div>
                                    </div>
                                </div>

                            </div>

                        </div>
                    </div>
                    </form>
                </div>
            </div>

            <div class="popover-footer detail-view">
                <div class="col-xs-12">
                    <div class="btn-wrap text-left">
                        <!--<button type="button" class="btn btn-sm btn-gray" onclick="javascript:window.open('http://seereal.lh.or.kr/OnnaraServiceMA/onnaraCommon/moveMap.do?center=14130421.73729845,4508557.037713998&zoom=19&layer=baseMap,TL_CTNU_LGSTR,OFFER_HEATMAP,aptTrde,aptRent,mohouTrde,mohouRent,OFFER_HEATMAP&pnu=${pnu}');">온나라지도</button>-->
						<button type="button" class="btn btn-sm btn-gray" onclick="javascript:onnara('1',${pnu});">온나라지도</button>
						<!--<button type="button" class="btn btn-sm btn-gray" onclick="javascript:onnaramap_pop();">온나라지도</button>-->
                        <!--<button type="button" class="btn btn-sm btn-gray" onclick="javascript:window.open('http://seereal.lh.or.kr/goLinkPage.do?linkMenu=1&q_pnu=${pnu}');">토지이용계획확인서(온나라지도)</button>-->
						<button type="button" class="btn btn-sm btn-gray" onclick="javascript:onnara('2',${pnu});">토지이용계획확인서(온나라지도)</button>

                        <!--<button type="button" class="btn btn-sm btn-gray" onclick="javascript:window.open('http://seereal.lh.or.kr/goLinkPage.do?linkMenu=2&q_pnu=${pnu}');">개별공시지가(온나라지도)</button> -->
						<button type="button" class="btn btn-sm btn-gray" onclick="javascript:onnara('3',${pnu});">개별공시지가(온나라지도)</button>
                        <button type="button" class="btn btn-teal btn-sm" onclick="javascript:down_word();">기초현황정보 다운로드</button>
<!--                         <button type="button" class="btn btn-teal btn-sm" onclick="javascript:down_img();">이미지캡쳐</button> -->
                        <form id="DocForm" name="DocForm" >
                        	<input type="hidden" id="pnu" name="pnu"/>
                        	<input type="hidden" id="sh_kind" name="sh_kind"/>
                        	<input type="hidden" id="imgSrc" name="imgSrc" value="null11"/>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <!--// End 상세보기-Popup -->



    <script type="text/javascript" src='/jsp/SH/js/map/geoMap.js'></script>
    <script type="text/javascript" src='/jsp/SH/js/map/mini_geoMap.js'></script>
    <script type="text/javascript" src='/jsp/SH/js/map/mini_potalMap_daum.js'></script>

</body>
