$(document).ready(function() {
    // === datetimepicker ===
    $(".datetimepicker").datetimepicker({
        locale: 'ko',
        format: 'YYYY/MM/DD',
        icons: {
            previous: "fa fa-chevron-left",
            next: "fa fa-chevron-right",
            time: "fa fa-clock-o",
            date: "fa fa-calendar",
            up: "fa fa-arrow-up",
            down: "fa fa-arrow-down"
        }
    });

	//숫자만 입력
	$("input[id^='num_']").keyup(function(){
		$(this).val($(this).val().replace(/[^0-9]/gi,""));
	});

	//토지-------------------------------------------
	//토지면적
	$(function() {
		var min = 0;
		var max = 10000000;
	    $("#slider_parea").slider({
	    	range: true, min: min, max: max, values: [min, max],
	    	slide: function( event, ui ){
		    	var type = $(this).prop("id").replace("slider_", "");
		        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
		        $("#num_"+type+"_1").val( ui.values[0] );
			    $("#num_"+type+"_2").val( ui.values[1] );
	    	}
	    });
	    slider_range('parea');
	});
	$("#num_parea_1, #num_parea_2").on("keyup", function(){ slider_range('parea'); });
    //공시지가
	$(function() {
		var min = 0;
		var max = 100000000;
	    $("#slider_pnilp").slider({
	    	range: true, min: min, max: max, values: [min, max],
	    	slide: function( event, ui ){
		    	var type = $(this).prop("id").replace("slider_", "");
		        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
		        $("#num_"+type+"_1").val( ui.values[0] );
			    $("#num_"+type+"_2").val( ui.values[1] );
	    	}
	    });
	    slider_range('pnilp');
	});
	$("#num_pnilp_1, #num_pnilp_2").on("keyup", function(){ slider_range('pnilp'); });

	//건물-------------------------------------------
	//건축면적
	$(function() {
		var min = 0;
		var max = 10000000;
	    $("#slider_bildng_ar").slider({
	    	range: true, min: min, max: max, values: [min, max],
	    	slide: function( event, ui ){
		    	var type = $(this).prop("id").replace("slider_", "");
		        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
		        $("#num_"+type+"_1").val( ui.values[0] );
			    $("#num_"+type+"_2").val( ui.values[1] );
	    	}
	    });
	    slider_range('bildng_ar');
	});
	$("#num_bildng_ar_1, #num_bildng_ar_2").on("keyup", function(){ slider_range('bildng_ar'); });
	//연면적
	$(function() {
		var min = 0;
		var max = 10000000;
	    $("#slider_totar").slider({
	    	range: true, min: min, max: max, values: [min, max],
	    	slide: function( event, ui ){
		    	var type = $(this).prop("id").replace("slider_", "");
		        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
		        $("#num_"+type+"_1").val( ui.values[0] );
			    $("#num_"+type+"_2").val( ui.values[1] );
	    	}
	    });
	    slider_range('totar');
	});
	$("#num_totar_1, #num_totar_2").on("keyup", function(){ slider_range('totar'); });
	//대지면적
	$(function() {
		var min = 0;
		var max = 10000000;
	    $("#slider_plot_ar").slider({
	    	range: true, min: min, max: max, values: [min, max],
	    	slide: function( event, ui ){
		    	var type = $(this).prop("id").replace("slider_", "");
		        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
		        $("#num_"+type+"_1").val( ui.values[0] );
			    $("#num_"+type+"_2").val( ui.values[1] );
	    	}
	    });
	    slider_range('plot_ar');
	});
	$("#num_plot_ar_1, #num_plot_ar_2").on("keyup", function(){ slider_range('plot_ar'); });
	//건폐율
	$(function() {
		var min = 0;
		var max = 100;
	    $("#slider_bdtldr").slider({
	    	range: true, min: min, max: max, values: [min, max],
	    	slide: function( event, ui ){
		    	var type = $(this).prop("id").replace("slider_", "");
		        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
		        $("#num_"+type+"_1").val( ui.values[0] );
			    $("#num_"+type+"_2").val( ui.values[1] );
	    	}
	    });
	    slider_range('bdtldr');
	});
	$("#num_bdtldr_1, #num_bdtldr_2").on("keyup", function(){ slider_range('bdtldr'); });
	//용적률
	$(function() {
		var min = 0;
		var max = 1000;
	    $("#slider_cpcty_rt").slider({
	    	range: true, min: min, max: max, values: [min, max],
	    	slide: function( event, ui ){
		    	var type = $(this).prop("id").replace("slider_", "");
		        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
		        $("#num_"+type+"_1").val( ui.values[0] );
			    $("#num_"+type+"_2").val( ui.values[1] );
	    	}
	    });
	    slider_range('cpcty_rt');
	});
	$("#num_cpcty_rt_1, #num_cpcty_rt_2").on("keyup", function(){ slider_range('cpcty_rt'); });

	//사업지구-------------------------------------------
	//고시면적
	$(function() {
		var min = 0;
		var max = 10000000;
	    $("#slider_solar").slider({
	    	range: true, min: min, max: max, values: [min, max],
	    	slide: function( event, ui ){
		    	var type = $(this).prop("id").replace("slider_", "");
		        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
		        $("#num_"+type+"_1").val( ui.values[0] );
			    $("#num_"+type+"_2").val( ui.values[1] );
	    	}
	    });
	    slider_range('solar');
	});
	$("#num_solar_1, #num_solar_2").on("keyup", function(){ slider_range('solar'); });
	//건폐율
	$(function() {
		var min = 0;
		var max = 100;
	    $("#slider_hbdtldr").slider({
	    	range: true, min: min, max: max, values: [min, max],
	    	slide: function( event, ui ){
		    	var type = $(this).prop("id").replace("slider_", "");
		        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
		        $("#num_"+type+"_1").val( ui.values[0] );
			    $("#num_"+type+"_2").val( ui.values[1] );
	    	}
	    });
	    slider_range('hbdtldr');
	});
	$("#num_hbdtldr_1, #num_hbdtldr_2").on("keyup", function(){ slider_range('hbdtldr'); });
	//용적률
	$(function() {
		var min = 0;
		var max = 1000;
	    $("#slider_hcpcty_rt").slider({
	    	range: true, min: min, max: max, values: [min, max],
	    	slide: function( event, ui ){
		    	var type = $(this).prop("id").replace("slider_", "");
		        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
		        $("#num_"+type+"_1").val( ui.values[0] );
			    $("#num_"+type+"_2").val( ui.values[1] );
	    	}
	    });
	    slider_range('hcpcty_rt');
	});
	$("#num_hcpcty_rt_1, #num_hcpcty_rt_2").on("keyup", function(){ slider_range('hcpcty_rt'); });



    //읍면동리스트 조회
	$("select[id$='_sig']").change(function() {
		var sig = $(this);
		var sigcd = sig.val();
		emd_list(sig, sigcd);
	});


	//멀티셀렉트
	$(".chosen").chosen();


    //열닫 - 하위메뉴
    $('.dropdown-menu').on('click', function(e) {
        e.stopPropagation();
    });


	
	//클릭 시 정보조회 
	// 변경이력 : 더블(지도상 클릭), 싱클(정보조회 아이콘 클릭)
	clickEvent(clickType);
	
	
	
    function numberWithCommas(x) { return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","); }


});

//읍면동리스트 조회
function emd_list(sig, sigcd){
	$.ajax({
		type: 'POST',
		url: "/ajaxDB_emd_list.do",
		data: { "sigcd" : sigcd },
		async: false,
		dataType: "json",
		success: function( data ) {
			if( data != null ) {
				var emd_nm = null;
				var emd_cd = null;
				var emd = sig.parent().next('div').children("select");
				emd.children("option").remove();
				emd.append('<option value="0000" selected>전체 선택</option>');
				for (i=0; i<data.emd_cd.length; i++) {
					emd_nm = data.emd_nm[i];
					emd_cd = data.emd_cd[i];
					emd.append('<option value="'+ emd_cd + '">' + emd_nm + '</option>');
				}
				emd.trigger("chosen:updated");
			}
		}
	});
}

//슬라이더바 범위적용
function slider_range(type, reset){
	var mim = $("#slider_"+type).slider("option", "min");
	var max = $("#slider_"+type).slider("option", "max");
	var now_min = document.getElementById('num_'+type+'_1').value;
	var now_max = document.getElementById('num_'+type+'_2').value;
	if( now_min == '' ){ now_min = mim; }
	if( now_max == '' ){ now_max = max; }
	if(reset){
		now_min = mim; now_max = max;
		$("#num_"+type+"_1").val(null);
	    $("#num_"+type+"_2").val(null);
	}
	now_min = parseInt( now_min );
	now_max = parseInt( now_max );
	if(now_max < now_min){ now_max = now_min; }else if(now_min > now_max){ now_min = now_max; }else if(now_min > max){ now_min = max; }
	var now_val = [now_min, now_max];
	$("#slider_"+type).slider( "option", "values", now_val);
	$("#amount_"+type).text(nCommas($("#slider_"+type).slider("values", 0)) + "  ~  " + nCommas($("#slider_"+type).slider("values", 1)) );
}

//초기화
function gis_clear(){
	//기본검색
	$("select[id$='_sig']").val('0000').trigger("chosen:updated");
	$("select[id$='_emd'] option").remove();
	$("select[id$='_emd']").append('<option value="0000" selected>전체 선택</option>');
	$("select[id$='_emd']").val('0000').trigger("chosen:updated");
	$("#tab-01_Form input[type=checkbox], #tab-02_Form input[type=checkbox], #tab-03_Form input[type=checkbox]").attr("checked", false);

	//상세검색
	$("#tab-01_Form_item .chosen, #tab-02_Form_item .chosen, #tab-03_Form_item .chosen").val('').trigger("chosen:updated");
	$("#tab-01_Form_item div[id^='slider_'], #tab-02_Form_item div[id^='slider_'], #tab-03_Form_item div[id^='slider_']").each(function(){
	  var type = $(this).prop("id").replace("slider_", "");
	  slider_range(type, true);
	});
	$("#fn_cp_date_select").val("00");
	$("#num_cp_date_1").val(null);
	$("#num_cp_date_2").val(null);

	//자산검색
	$("#tab-01_Form_data input[type=checkbox], #tab-02_Form_data input[type=checkbox], #tab-03_Form_data input[type=checkbox]").attr("checked", false);

	//공간분석
	space_clear();
}

//화폐 단위(3자리 쉼표)
function nCommas(x) {    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");}

//페이징처리
function drawPage(goTo, type, n, t, kind){
	var pagesize = n;
	var totalCount = t; //전체 건수
    var totalPage = Math.ceil(totalCount/pagesize);//한 페이지에 나오는 행수
    var PageNum;
	var page = goTo;
    var pageGroup = Math.ceil(page/10);    //페이지 수
    var next = pageGroup*10;
    var prev = next - 9;
    var goNext = next+1;
    var goPrev;

    if(prev-1<=0){
        goPrev = 1;
    }else{
        goPrev = prev-1;
    }

    if(next>totalPage){
        goNext = totalPage;
        next = totalPage;
    }else{
        goNext = next+1;
    }

    $("#pageZone").empty();
    var prevStep =	"<li>";
    	prevStep +=		"<a ";
    	if(Number(goTo) == 1){ prevStep += "href=\"#\""; }
    	else{ prevStep += "href=\"javascript:"+type+"("+goPrev+", '"+kind+"');\""; }
    	prevStep +=		"><i class=\"fa fa-angle-left\"></i></a>";
    	prevStep +=	"</li>";
	$("#pageZone").append(prevStep);
	for(var i=prev; i<=next;i++){
    	if(i == goTo){
    		PageNum =	"<li class=\"active\">";
    		PageNum +=		"<a href=\"#\">"+i+"</a>";
    		PageNum +=	"</li>";
    	}else{
    		PageNum =	"<li>";
    		PageNum +=		"<a href=\"javascript:"+type+"("+i+", '"+kind+"');\">"+i+"</a>";
    		PageNum +=	"</li>";
    	}
        $("#pageZone").append(PageNum);
    }
	var nextStep =	"<li>";
		nextStep +=		"<a ";
		if(Number(goTo) == Number(totalPage)){ nextStep += "href=\"#\""; }
		else{ nextStep += "href=\"javascript:"+type+"("+goNext+", '"+kind+"');\""; }
		nextStep +=		"><i class=\"fa fa-angle-right\"></i></a>";
		nextStep +=	"</li>";
	$("#pageZone").append(nextStep);
}

//검색버튼
var tab_name = null;
function gis_sherch(a) {
	$("#tab-01, #tab-02, #tab-03").each(function(){
		var tab = $(this);
		if( tab.css("display") == 'block' ){
			tab_name = tab.prop("id");
			//필수입력사항-1
			if		( tab_name == 'tab-01' ){	if( $("#fs_sig").val() == "0000" ){ alert("검색속도를 위해 [시군구]를 반드시 선택하세요."); $("#fs_sig").focus(); return; } }
			else if	( tab_name == 'tab-02' ){ 	if( $("#fn_sig").val() == "0000" ){ alert("검색속도를 위해 [시군구]를 반드시 선택하세요."); $("#fn_sig").focus(); return; } }
//			else if	( tab_name == 'tab-03' ){ 	if( $("#fg_gb").val() == null ){ alert("기본항목은 필수입력 항목입니다."); return; } }
			//필수입력사항-2
			if		( tab_name == 'tab-01' ){	if( $("input[id^=fs_gb_]:checked, #land-datalist input[id^=fs_]:checked").length == 0 ){ alert("[기본검색] 또는 [자산검색] 항목을 선택해주세요."); return; } }
			else if	( tab_name == 'tab-02' ){ 	if( $("input[id^=fn_gb_]:checked, #buld-datalist input[id^=fn_]:checked").length == 0 ){ alert("[기본검색] 또는 [자산검색] 항목을 선택해주세요."); return; } }
//			else if	( tab_name == 'tab-03' ){ 	if( $("input[id^=fg_gb_]:checked, #dist-datalist input[id^=fg_]:checked").length == 0 ){ alert("[기본검색] 또는 [자산검색] 항목을 선택해주세요."); return; } }
			//필수입력사항-3
			/*도시재생관련사업*/
			if		( $("#sa01-01").val() != "00" 	&& $("#sa01-02").val() == null ){ alert("관련사업 레이어를 선택해주세요.(중분류 까지 선택필요)"); return; }
			/*복합쇠퇴지역*/
			else if	( $("#sa01-04").val() != "00" 	&& $("#sa01-05").val() == null ){ alert("관련사업 레이어를 선택해주세요.(중분류 까지 선택필요)"); return; }
			/*대중교통역세권*/
			else if	( $("#sa01-07").val() != "00" 	&& $("#sa01-08").val() == null ){ alert("관련사업 레이어를 선택해주세요.(중분류 까지 선택필요)"); return; }
			/*사업가능여건*/
			else if	( $("#land01-08").val() != "00" && $("#land01-09").val() == null ){ alert("관련사업 레이어를 선택해주세요.(중분류 까지 선택필요)"); return; }
			/*대중교통역세권*/
			else if	( $("#land01-11").val() != "00" && $("#land01-12").val() == null ){ alert("관련사업 레이어를 선택해주세요.(중분류 까지 선택필요)"); return; }
			/*입지여건*/
			else if	( $("#buld01-04").val() != "00" && $("#buld01-05").val() == null ){ alert("관련사업 레이어를 선택해주세요.(중분류 까지 선택필요)"); return; }
			/*복합쇠퇴지역*/
			else if	( $("#buld01-07").val() != "00" && $("#buld01-08").val() == null ){ alert("관련사업 레이어를 선택해주세요.(중분류 까지 선택필요)"); return; }

			gis_sherch_go(a);
		}
	});
}

var SearchWindow =null;
function gis_sherch_go(a) {
	//검색조건 저장
	save_search();

	//초기화
    Redraw();

    //창 닫기
	if(SearchWindow != null) {
		SearchWindow.close();
	}

    var params = $("#GISinfoForm").serialize();
	console.log("params : ", params);
    SearchWindow = window.open("/searchList_popup.do?"+params, "searchList", "toolbar=no, width=1100, height=720,directories=no,status=no,scrollorbars=yes,resizable=yes");

	geoMap.render();
	geoMap.renderSync();
}


//검색조건 저장
function save_search(){
	$("#GISinfoForm").html(null);
	//검색종류
	var kind = null;
	var tab_name = null;
	$("#tab-01, #tab-02, #tab-03").each(function(){
		var tab = $(this);
		if( tab.css("display") == 'block' ){ tab_name = tab.prop("id"); }
	});
	//검색 구분(토지/건물/사업지구)
	$("#GISinfoForm").append("<input type=\"hidden\" name=\"kind\" value=\""+tab_name+"\">");
	//보기 개수
	$("#GISinfoForm").append("<input type=\"hidden\" name=\"cnt_kind\" value=\""+$("#cnt_kind").val()+"\">");

	if( tab_name == 'tab-01' ){
		kind = "fs";
		//추가항목 - 토지
		for(j=0; j<fs_KindList.length; j++){
			var tagName = $("#"+kind+"_"+fs_KindList[j]+"").prop("tagName");
			if( tagName != "DIV" ){
				var List = $("#"+kind+"_"+fs_KindList[j]+"").val();
				if( List != null ){
					for(i=0; i<List.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\""+fs_KindList[j]+"\" value=\""+List[i]+"\">"); }
				}
			}else{
				var val01 = $("#num_"+fs_KindList[j]+"_1").val();
				if( val01 != null && val01 != "" ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\""+fs_KindList[j]+"_1\" value=\""+$("#num_"+fs_KindList[j]+"_1").val()+"\">"); }
				var val02 = $("#num_"+fs_KindList[j]+"_2").val();
				if( val02 != null && val02 != "" ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\""+fs_KindList[j]+"_2\" value=\""+$("#num_"+fs_KindList[j]+"_2").val()+"\">"); }
			}
		}
		//자산데이터
		for(i=0; i<fs_dataList.length; i++){
			var dataList = $("#"+tab_name+"_Form_data input[id^="+kind+"_"+fs_dataList[i]+"_]:checked");
			if( dataList.length > 0 ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\""+fs_dataList[i]+"\" value=\""+kind+"\">");
				for(j=0; j<dataList.length; j++){
					$("#GISinfoForm").append("<input type=\"hidden\" name=\""+dataList[j].id.replace(kind+"_", "")+"\" value=\""+dataList[j].id.replace(""+kind+"_"+fs_dataList[i]+"_", "")+"\">");
				}
			}
		}
	}else if( tab_name == 'tab-02' ){
		kind = "fn";
		//추가항목 - 건물
		for(j=0; j<fn_KindList.length; j++){
			var tagName = $("#"+kind+"_"+fn_KindList[j]+"").prop("tagName");
			if( tagName != "DIV" ){
				var List = $("#"+kind+"_"+fn_KindList[j]+"").val();
				if( List != null ){
					for(i=0; i<List.length; i++){ $("#GISinfoForm").append("<input type=\"hidden\" name=\""+fn_KindList[j]+"\" value=\""+List[i]+"\">"); }
				}
			}else{
				var val01 = $("#num_"+fn_KindList[j]+"_1").val();
				if( val01 != null && val01 != "" ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\""+fn_KindList[j]+"_1\" value=\""+$("#num_"+fn_KindList[j]+"_1").val()+"\">"); }
				var val02 = $("#num_"+fn_KindList[j]+"_2").val();
				if( val02 != null && val02 != "" ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\""+fn_KindList[j]+"_2\" value=\""+$("#num_"+fn_KindList[j]+"_2").val()+"\">"); }
			}
		}
		//자산데이터
		for(i=0; i<fn_dataList.length; i++){
			var dataList = $("#"+tab_name+"_Form_data input[id^="+kind+"_"+fn_dataList[i]+"_]:checked");
			if( dataList.length > 0 ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\""+fn_dataList[i]+"\" value=\""+kind+"\">");
				for(j=0; j<dataList.length; j++){
					$("#GISinfoForm").append("<input type=\"hidden\" name=\""+dataList[j].id.replace(kind+"_", "")+"\" value=\""+dataList[j].id.replace(""+kind+"_"+fn_dataList[i]+"_", "")+"\">");
				}
			}
		}
	}else if( tab_name == 'tab-03' ){
		kind = "fg";
		//추가항목 - 사업지구
		for(j=0; j<fg_KindList.length; j++){
			var tagName = $("#"+kind+"_"+fg_KindList[j]+"").prop("tagName");
			if( tagName != "DIV" ){
				var List = $("#"+kind+"_"+fg_KindList[j]+"").val();
				if( List != null ){
					for(i=0; i<List.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\""+fg_KindList[j]+"\" value=\""+List[i]+"\">"); }
				}
			}else if( tagName == "INPUT" ){
				var List = $("#"+kind+"_"+fg_KindList[j]+"").val();
				if( List != null ){
					$("#GISinfoForm").append("<input type=\"hidden\" name=\""+fg_KindList[j]+"\" value=\""+List+"\">");
				}
			}else{
				var val01 = $("#num_"+fg_KindList[j]+"_1").val();
				if( val01 != null && val01 != "" ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\""+fg_KindList[j]+"_1\" value=\""+$("#num_"+fg_KindList[j]+"_1").val()+"\">"); }
				var val02 = $("#num_"+fg_KindList[j]+"_2").val();
				if( val02 != null && val02 != "" ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\""+fg_KindList[j]+"_2\" value=\""+$("#num_"+fg_KindList[j]+"_2").val()+"\">"); }
			}
		}
		//자산데이터
		for(i=0; i<fg_dataList.length; i++){
			var dataList = $("#"+tab_name+"_Form_data input[id^="+kind+"_"+fg_dataList[i]+"_]:checked");
			if( dataList.length > 0 ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\""+fg_dataList[i]+"\" value=\""+kind+"\">");
				for(j=0; j<dataList.length; j++){
					$("#GISinfoForm").append("<input type=\"hidden\" name=\""+dataList[j].id.replace(kind+"_", "")+"\" value=\""+dataList[j].id.replace(""+kind+"_"+fg_dataList[i]+"_", "")+"\">");
				}
			}
		}
	}


	//기본항목
	var gbList = $("#"+tab_name+"_Form input[id^="+kind+"_gb_]:checked");
	if( gbList != null ){
		for(i=0; i<gbList.length; i++){ $("#GISinfoForm").append("<input type=\"hidden\" name=\"gb\" value=\""+gbList[i].id.replace(kind+"_gb_", "")+"\">"); }
	}
	if( tab_name == 'tab-02' ){
		if( $("#fn_gbname").val() != null && $("#fn_gbname").val() != "" ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\"gbname\" value=\""+$("#fn_gbname").val()+"\">"); }
	}

	//사업지구는 시군구,읍면동 분류가 없음 (문의필요)
//	if( tab_name != 'tab-03' ){
		if( $("#"+kind+"_sig").val() != null ){
			$("#GISinfoForm").append("<input type=\"hidden\" name=\"sig\" value=\""+$("#"+kind+"_sig").val()+"\">");
		}
		if( $("#"+kind+"_emd").val() != null ){
			$("#GISinfoForm").append("<input type=\"hidden\" name=\"emd\" value=\""+$("#"+kind+"_emd").val()+"\">");
		}
//	}

	//공간분석
	if( $("#searching_space").css("display") == 'block' ){
		var sel = $("#sel").val()
		$("#GISinfoForm").append("<input type=\"hidden\" name=\"sel\" value=\""+sel+"\">");
		if(sel == "sa01"){ //관련사업 검색
			if( $("#sa01-01").val() != "00" ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\"space_gb\" value=\""+$("#sa01-01").val()+"\">");	//도시재생관련사업 - 대분류
				var List02 = $("#sa01-02").val(); //도시재생관련사업 - 중분류
				if( List02 != null ){
					for(i=0; i<List02.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"space_gb_cd02\" value=\""+List02[i]+"\">"); }
				}
				var List03 = $("#sa01-03").val(); //도시재생관련사업 - 소분류
				if( List03 != null ){
					for(i=0; i<List03.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"space_gb_cd03\" value=\""+List03[i]+"\">"); }
				}
			}
			if( $("#sa01-04").val() != "00" ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\"sub_p_decline_gb\" value=\""+$("#sa01-04").val()+"\">");	//복합쇠퇴지역 - 대분류
				var List05 = $("#sa01-05").val(); //복합쇠퇴지역 - 중분류
				if( List05 != null ){
					for(i=0; i<List05.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"sub_p_decline_val\" value=\""+List05[i]+"\">"); }
				}
				var List06 = $("#sa01-06").val(); //복합쇠퇴지역 - 소분류
				if( List06 != null ){
					for(i=0; i<List06.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"sub_p_decline\" value=\""+List06[i]+"\">"); }
				}
			}
			if( $("#sa01-07").val() != "00" ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\"public_transport_val\" value=\""+$("#sa01-07").val()+"\">");	//대중교통역세권 - 중분류
				var List08 = $("#sa01-08").val(); //대중교통역세권 - 소분류
				if( List08 != null ){
					for(i=0; i<List08.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"public_transport\" value=\""+List08[i]+"\">"); }
				}
			}
		}else if(sel == "sa02"){ //버퍼분석 검색

		}else if(sel == "sa03"){ //역세권 사업 추진 대상 검토

		}else if(sel == "buld01"){ //낙후(저층)주거지 찾기
			$("#GISinfoForm").append("<input type=\"hidden\" name=\"outher\" value=\"99\">");

			var List1 = $("#buld01-01").val();
			if( List1 != null ){
				for(i=0; i<List1.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"spfc\" value=\""+List1[i]+"\">"); }
			}
			var List2 = $("#buld01-02").val();
			if( List2 != null ){
				for(i=0; i<List2.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"road_side\" value=\""+List2[i]+"\">"); }
			}
			var List3 = $("#buld01-03").val();
			if( List3 != null ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\"buffer\" value=\""+List3+"\">");
			}


			if( $("#buld01-04").val() != "00" ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\"space_gb\" value=\""+$("#buld01-04").val()+"\">");	//입지여건 - 대분류
				var List02 = $("#buld01-05").val(); //입지여건 - 중분류
				if( List02 != null ){
					for(i=0; i<List02.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"space_gb_cd02\" value=\""+List02[i]+"\">"); }
				}
				var List03 = $("#buld01-06").val(); //입지여건 - 소분류
				if( List03 != null ){
					for(i=0; i<List03.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"space_gb_cd03\" value=\""+List03[i]+"\">"); }
				}
			}

			if( $("#buld01-07").val() != "00" ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\"sub_p_decline_gb\" value=\""+$("#buld01-07").val()+"\">");	//복합쇠퇴지역 - 대분류
				var List05 = $("#buld01-08").val(); //복합쇠퇴지역 - 중분류
				if( List05 != null ){
					for(i=0; i<List05.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"sub_p_decline_val\" value=\""+List05[i]+"\">"); }
				}
				var List06 = $("#buld01-09").val(); //복합쇠퇴지역 - 소분류
				if( List06 != null ){
					for(i=0; i<List06.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"sub_p_decline\" value=\""+List06[i]+"\">"); }
				}
			}
		}else if(sel == "land01"){ //국공유지 개발/활용 대상지
			$("#GISinfoForm").append("<input type=\"hidden\" name=\"outher\" value=\"99\">");

			var List1 = $("#land01-02").val();
			if( List1 != null ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\"cp_date_1\" value=\""+List1+"\">"); }
			var List2 = $("#land01-03").val();
			if( List2 != null ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\"cp_date_2\" value=\""+List2+"\">"); }
			var List3 = $("#land01-04").val();
			if( List3 != null ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\"bdtldr_1\" value=\""+List3+"\">"); }
			var List4 = $("#land01-05").val();
			if( List4 != null ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\"bdtldr_2\" value=\""+List4+"\">"); }
			var List5 = $("#land01-06").val();
			if( List5 != null ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\"cpcty_rt_1\" value=\""+List5+"\">"); }
			var List6 = $("#land01-07").val();
			if( List6 != null ){ $("#GISinfoForm").append("<input type=\"hidden\" name=\"cpcty_rt_2\" value=\""+List6+"\">"); }

			if( $("#land01-08").val() != "00" ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\"space_gb\" value=\""+$("#land01-08").val()+"\">");	//사업가능여건 - 대분류
				var List02 = $("#land01-09").val(); //사업가능여건 - 중분류
				if( List02 != null ){
					for(i=0; i<List02.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"space_gb_cd02\" value=\""+List02[i]+"\">"); }
				}
				var List03 = $("#land01-10").val(); //사업가능여건 - 소분류
				if( List03 != null ){
					for(i=0; i<List03.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"space_gb_cd03\" value=\""+List03[i]+"\">"); }
				}
			}

			if( $("#land01-11").val() != "00" ){
				$("#GISinfoForm").append("<input type=\"hidden\" name=\"public_transport_val\" value=\""+$("#land01-11").val()+"\">");	//대중교통역세권 - 중분류
				var List08 = $("#land01-12").val(); //대중교통역세권 - 소분류
				if( List08 != null ){
					for(i=0; i<List08.length; i++){	$("#GISinfoForm").append("<input type=\"hidden\" name=\"public_transport\" value=\""+List08[i]+"\">"); }
				}
			}

		}






	}

}


//도형 그리기
function map_draw(geom){
	if(geom == null){
		alert("도형정보가 없습니다.");
	}else{
		//그래픽 초기화
		if(vectorLayer != null || vectorLayer != ''){
			vectorSource.clear();
			geoMap.removeLayer(vectorLayer);
		}

		if(geom.indexOf('POINT') >= 0) {
			//create the style
			var iconStyle2 = new ol.style.Style({
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

		    var reader = new ol.format.WKT();
		    var geometry = reader.readGeometry(geom, {
		    	  dataProjection: 'EPSG:4326',
		    	  featureProjection: 'EPSG:3857'
		    	});
			var iconFeature2 = new ol.Feature({
		           geometry: geometry
		    });
			vectorSource.addFeature(iconFeature2);
		} else {
			//create the style
			var iconStyle2 =[ 
				new ol.style.Style({
		    	stroke: new ol.style.Stroke({
		    		color: 'white',
		      		width: 3
		    	})
		    	}),
		    	new ol.style.Style({
		        	stroke: new ol.style.Stroke({
		        		color: 'red',
		          		width: 2,
		          		lineDash: [4]
		        	})
		        })
			];
			
		    vectorLayer = new ol.layer.Vector({
		        source: vectorSource,
		        style: iconStyle2
		    });

			var coord_v = geom;
			coord_v = coord_v.replace('MULTIPOLYGON', '');
			coord_v = coord_v.replace('(((', '');
			coord_v = coord_v.replace('))),', '');
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

			var iconFeature2 = new ol.Feature({
		           geometry: new ol.geom.Polygon([ coord_sp_t ])
		    });
			vectorSource.addFeature(iconFeature2);
		}
		//레이어 제일위에 표출하기
	    vectorLayer.setZIndex(parseInt(10000));
	    
	    geoMap.addLayer(vectorLayer);
	}
	geoMap.renderSync();
	geoMap.render();
}

//도형 그리기 - 테스트
function map_drawss(geom){
	if(geom == null){
		alert("도형정보가 없습니다.");
	}else{
		//그래픽 초기화
		if(vectorLayer != null || vectorLayer != ''){
			vectorSource.clear();
			geoMap.removeLayer(vectorLayer);
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
	    vectorLayer = new ol.layer.Vector({
	        source: vectorSource,
	        style: iconStyle2
	    });

		var coord_v = geom;
		coord_v = coord_v.replace('MULTIPOLYGON', '');
		coord_v = coord_v.replace('(((', '');
		coord_v = coord_v.replace('))),', '');
		coord_v = coord_v.replace(')))', '');
		var coord_sp = coord_v.split(",");
		var coord_sp_t = new Array();

		for(j=0; j<coord_sp.length; j++){
			if(coord_sp[j] != ""){
				var arry1 = coord_sp[j].split(' ');
				var val = ol.proj.transform([ Number( arry1[0] ), Number( arry1[1] ) ], 'EPSG:5181', 'EPSG:900913');
				coord_sp_t[j] = new Array( val[0], val[1] );
			}
		}

		var iconFeature2 = new ol.Feature({
	           geometry: new ol.geom.Polygon([ coord_sp_t ])
	    });
		vectorSource.addFeature(iconFeature2);

	    geoMap.addLayer(vectorLayer);
	}
	geoMap.renderSync();
	geoMap.render();
}

//화면이동
function map_move(addr_x, addr_y, geom){
	//화면 클리어
	if(toggles){
		main_toggle();
	}


	if(geom != null && geom != ""){
		map_draw(geom);
	}else{
		alert("도형정보가 없습니다.");
		return;
	}
	var spot = ol.proj.transform([Number(addr_x), Number(addr_y)], 'EPSG:4326', 'EPSG:900913');
	view.setCenter(spot);
	view.setZoom(18);
	geoMap.renderSync();
	geoMap.render();
}

//지번검색 결과 클릭시 해당좌표로 이동 - 240404추가 (왼쪽 메뉴 유지)
function map_move_search(addr_x, addr_y, geom){

	if(geom != null && geom != ""){
		map_draw(geom);
	}else{
		alert("도형정보가 없습니다.");
		return;
	}
	var spot = ol.proj.transform([Number(addr_x), Number(addr_y)], 'EPSG:4326', 'EPSG:900913');
	view.setCenter(spot);
	view.setZoom(18);
	geoMap.renderSync();
	geoMap.render();
}





//지도화면에 도형 그리기 - 검색결과 전체
function GISSearchList_Draw(){
	var geomList = $("input[name='geom[]']").val();
	geomList = geomList.replace(",MULTIPOLYGON", "MULTIPOLYGON");
	geomList = geomList.split("MULTIPOLYGON");

	//검색결과 draw reset
	if(vectorLayer2 != null || vectorLayer2 != ''){
		vectorSource2.clear();
		geoMap.removeLayer(vectorLayer2);
		$( ".tooltip").remove();
	}
	//화면 클리어
	if(toggles){
		main_toggle();
	}


	//create the style
    var iconStyle2 = new ol.style.Style({
    	stroke: new ol.style.Stroke({
    		color: 'blue',
      		width: 1.2
//      		,lineDash: [4]
    	})
    });
    vectorLayer2 = new ol.layer.Vector({
        source: vectorSource2,
        style: iconStyle2
    });

	for (i=1; i<geomList.length; i++) {
		coord = geomList[i];

		//검색결과 draw
		if( coord != null ){
			var coord_v = coord;
			coord_v = coord_v.replace('(((', '');
			coord_v = coord_v.replace('))),', '');
			coord_v = coord_v.replace(')))', '');
			var coord_sp = coord_v.split(",");
			var coord_sp_t = new Array();

			for(j=0; j<coord_sp.length; j++){
				var arry1 = coord_sp[j].split(' ');
				var val = ol.proj.transform([ Number( arry1[0] ), Number( arry1[1] ) ], 'EPSG:4326', 'EPSG:900913');
				coord_sp_t[j] = new Array( val[0], val[1] );
			}

			var iconFeature2 = new ol.Feature({
		           geometry: new ol.geom.Polygon([ coord_sp_t ])
		    });
			vectorSource2.addFeature(iconFeature2);

		}
	}
	geoMap.addLayer(vectorLayer2);
	geoMap.renderSync();
	geoMap.render();

}





//엑셀 다운로드
function GISSearchList_downExcel(type){
	  //if(!confirm("엑셀파일 다운로드 하시겠습니까?")){return;}
	  $("#GISinfoForm").attr("target","_parent");
	    $("#GISinfoForm").attr("method", "post");
	    $("#GISinfoForm").attr("action","/GISSearchList_Excel_Download.do?target="+type);
	    $("#GISinfoForm").submit();
	}

//SHP 다운로드
function GISSearchList_downSHP(){
	alert("준비중입니다.");
}


//유창범 검색결과 전체표출 추가 20180626
function GISSearchList_DrawAll(geomList){
	//검색결과 draw reset
	if(vectorLayer2 != null || vectorLayer2 != ''){
		vectorSource2.clear();
		geoMap.removeLayer(vectorLayer2);
		$( ".tooltip").remove();
	}
	//화면 클리어
	if(toggles){
		main_toggle();
	}

	vectorSource2 = new ol.source.Vector({
        features: (new ol.format.GeoJSON()).readFeatures(geomList)
      });

	//create the style
    var iconStyle2 = new ol.style.Style({
    	stroke: new ol.style.Stroke({
    		color: 'blue',
      		width: 1.2
//      		,lineDash: [4]
    	})
    });
    vectorLayer2 = new ol.layer.Vector({
        source: vectorSource2,
        style: iconStyle2
    });

	geoMap.addLayer(vectorLayer2);
	geoMap.renderSync();
	geoMap.render();
}














