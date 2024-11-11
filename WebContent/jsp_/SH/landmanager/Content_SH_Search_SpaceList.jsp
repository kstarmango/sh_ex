<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
$(document).ready(function(){
	//숫자만 입력
	$("#buld01-03, #land01-02, #land01-03, #land01-04, #land01-05, #land01-06, #land01-07").keyup(function(){
		$(this).val($(this).val().replace(/[^0-9]/gi,""));
	});
	//건축년도
	$("#land01-01").change(function() {
		var sel = $("#land01-01").val();
		var today = new Date(); // 현재 시간
		var year = today.getFullYear();
		var month = today.getMonth()+1;
		var day = today.getDate();		
		
		if( sel == "00" ){
			$("#land01-02").val( null );
			$("#land01-03").val( null );
		}else if( sel == "01" ){
			$("#land01-02").val( null );
			$("#land01-03").val( (year-20)+"/"+month+"/"+day );
		}else if( sel == "02" ){ 	
			$("#land01-02").val( null );
			$("#land01-03").val( (year-30)+"/"+month+"/"+day );
		}else if( sel == "03" ){
			$("#land01-02").val( null );
			$("#land01-03").val( (year-40)+"/"+month+"/"+day );
		}else if( sel == "04" ){ 
			$("#land01-02").val( null );
			$("#land01-03").val( (year-50)+"/"+month+"/"+day );		
		}
	});
	
	
	
	//분석기법 선택
	$("#sel").change(function() {
		$("#sa01, #sa02, #sa03, #buld01, #land01").hide();
		space_clear();
		var a = $(this).val();
		$("#"+a+"").show();
		
		sa_view(a);
	});
	
	//레이어 대상 중분류 조회
	$("#sa01-01, #sa01-04, #buld01-04, #buld01-07, #land01-08").change(function() {	
		var target = $(this);
		var gb = target.prop("id").replace("#", "");
		var gb_cd = target.val();	
		sel_gb2(target, gb, gb_cd);
	});	
	//레이어 대상 소분류 조회
	$("#sa01-02, #sa01-05, #buld01-05, #buld01-08, #land01-09").change(function() {	
		var target = $(this);
		var gb = target.prop("id").replace("#", "");
		var gb_cd = target.parent().prev("div").children("select").val();	
		var gb_val = $(this).val();
		
		var select = target.parent().next("div").children("select");
		if(gb_val != null && gb_val.length == 1){
			sel_gb3(select, gb, gb_cd, gb_val[0]);			
		}else{
			select.children("option").remove();
			select.trigger("chosen:updated");	
		}		
	});
	//레이어 대상 소분류 조회(단일) - 대중교통역세권
	$("#sa01-07, #land01-11").change(function() {	
		var target = $(this);
		var gb = target.prop("id").replace("#", "");
		var gb_val = $(this).val();
		
		var select = target.parent().next("div").children("select");
		if(gb_val != null && gb_val != "00"){
			sel_gb4(select, gb, gb_val);
		}else{
			select.children("option").remove();
			select.trigger("chosen:updated");	
		}		
	});
	
});

//레이어 대상 중분류 조회
function sel_gb2(target, gb, gb_cd){
	$.ajax({
		type: 'POST',
		url: "/ajaxDB_gb02_list.do",
		data: { "gb" : gb, "gb_cd" : gb_cd },
		async: false,
		dataType: "json",
		success: function( data ) {
			if( data != null ) {		
				var select = target.parent().next("div").children("select");
				select.children("option").remove();
				var select_ch = target.parent().next("div").next("div").children("select");
				select_ch.children("option").remove();
				for (i=0; i<data.nm.length; i++) {		
					nm = data.nm[i];
					no = data.no[i];
					select.append('<option value="'+ no + '">' + nm + '</option>');
				}	
				select.trigger("chosen:updated");
				select_ch.trigger("chosen:updated");
			}	
		}
	});
}
//레이어 대상 소분류 조회
function sel_gb3(select, gb, gb_cd, gb_val){
	$.ajax({
		type: 'POST',
		url: "/ajaxDB_gb03_list.do",
		data: { "gb" : gb, "gb_cd" : gb_cd, "gb_val" : gb_val },
		async: false,
		dataType: "json",
		success: function( data ) {
			if( data != null ) {							
				select.children("option").remove();
				for (i=0; i<data.nm.length; i++) {		
					nm = data.nm[i];
					no = data.no[i];
					select.append('<option value="'+ no + '">' + nm + '</option>');
				}	
				select.trigger("chosen:updated");	
			}	
		}
	});
}
//레이어 대상 소분류 조회(단일) - 대중교통역세권
function sel_gb4(select, gb, gb_val){
	$.ajax({
		type: 'POST',
		url: "/ajaxDB_gb03_list.do",
		data: { "gb" : gb, "gb_val" : gb_val },
		async: false,
		dataType: "json",
		success: function( data ) {
			if( data != null ) {							
				select.children("option").remove();
				for (i=0; i<data.nm.length; i++) {		
					nm = data.nm[i];
					no = data.no[i];
					select.append('<option value="'+ no + '">' + nm + '</option>');
				}	
				select.trigger("chosen:updated");	
			}	
		}
	});	
}

//초기화
function space_clear(){
	//관련사업검색
	$("#sa01 select[id^=sa01-][id!=sa01-01][id!=sa01-04][id!=sa01-07] option").remove();
	$("#sa01 .chosen").val('00').trigger("chosen:updated");
	
	//국공유지 개발&활용 대상지
	$("#land01 select[id^=land01-][id!=land01-01][id!=land01-08][id!=land01-11] option").remove();
	$("#land01 .chosen").val('00').trigger("chosen:updated");
	$("#land01-01").val('00');
	$("#land01 input[type=text]").val(null);
	
	//낙후(저층)주거지 찾기
	$("#buld01 select[id^=buld01-][id!=buld01-01][id!=buld01-02][id!=buld01-04][id!=buld01-07] option").remove();
	$("#buld01 .chosen").val('00').trigger("chosen:updated");
}

//분석기법 선택시 강조 + 디폴트 값?
function sa_view(type){
	if(type == "buld01"){ //낙후(저층)주거지 찾기
		$("#buld01_svc").show();
	
		$("#fn_gb_01000").parent().parent().parent().children("label").attr("style", "color:red;");			
		$("label[for=fn_cp_date_select]").attr("style", "color:red;");
		$("label[for=fn_totar]").attr("style", "color:red;");
		$("label[for=fn_plot_ar]").attr("style", "color:red;");
		$("label[for=fn_cpcty_rt]").attr("style", "color:red;");
	}else if(type == "land01"){ //국공유지 개발&활용 대상지
		$("#land01_svc").show();
		
		$("#fs_gb_02").parent().parent().parent().children("label").attr("style", "color:red;");
		$("label[for=fs_jimok]").attr("style", "color:red;");
		$("label[for=fs_parea]").attr("style", "color:red;");
	}else{
		$("#buld01_svc").hide();
		$("#land01_svc").hide();
		
		$("#fn_gb_01000").parent().parent().parent().children("label").removeAttr("style");	
		$("label[for=fn_cp_date_select]").removeAttr("style");
		$("label[for=fn_totar]").removeAttr("style");
		$("label[for=fn_plot_ar]").removeAttr("style");
		$("label[for=fn_cpcty_rt]").removeAttr("style");
		
		$("#fs_gb_02").parent().parent().parent().children("label").removeAttr("style");
		$("label[for=fs_jimok]").removeAttr("style");
		$("label[for=fs_parea]").removeAttr("style");
	}
}
function sa_value(type){
	if(type == "buld01"){ //낙후(저층)주거지 찾기
		$("#fn_gb_01000, #fn_gb_01002, #fn_gb_01003, #fn_gb_02001, #fn_gb_02002, #fn_gb_02003, #fn_gb_01004").prop("checked", true);
	
		$("#fn_cp_date_select").val("02");
		var today = new Date(); // 현재 시간
		var year = today.getFullYear();
		var month = today.getMonth()+1;
		var day = today.getDate();		
		$("#num_cp_date_1").val( (year-30)+"/"+month+"/"+day );
		$("#num_cp_date_2").val( year+"/"+month+"/"+day );
		
		$("#buld01-01").val("14").trigger("chosen:updated");
		
		$("#buld01-02").val(["01","02","03","04","05","06","07","08","09"]).trigger("chosen:updated");
		
		$("#buld01-03").val("2");
	}else if(type == "land01"){ //국공유지 개발&활용 대상지
		$("#fs_gb_02, #fs_gb_04, #fs_gb_05").prop("checked", true);
	
		$("#fs_jimok").val(["28","11"]).trigger("chosen:updated");
		
		$("#land01-01").val("02");
		var today = new Date(); // 현재 시간
		var year = today.getFullYear();
		var month = today.getMonth()+1;
		var day = today.getDate();		
		$("#land01-02").val( (year-30)+"/"+month+"/"+day );
		$("#land01-03").val( year+"/"+month+"/"+day );
		
		$("#land01-04, #land01-05, #land01-06, #land01-07").val("0");
	}else{

	}
}
</script>	



    <!-- 자산검색-공간분석-Popup -->
    <div class="popover" id="searching_space" style="width: 400px; left: 1200px; top: 129px; bottom: 20px; display: none;">
        <div class="popover-title tit">
            <span class="m-r-5">
                <b>관련사업</b>
            </span>
            <button type="button" class="close" id="searching_space_close" onclick="gis_item_space()">×</button>
        </div>
        <div class="popover-body ani-pop">
            <div class="popover-content pop-top-area p-20">
                <div class="row">		 
                    <div class="col-xs-10">
                        <div class="form-group row m-b-0">
                            <label for="sel" class="col-xs-3">분석기법</label>
                            <div class="col-xs-9">
                                <select id="sel" class="form-control input-sm">
                                    <option value="sa01">관련사업 검색</option>
<!--                                     <option value="sa02">버퍼분석 검색</option> -->
<!--                                     <option value="sa03">역세권 사업 추진 대상 검토</option> -->
<!--                                     <option value="buld01">낙후(저층)주거지 찾기</option> -->
                                    <!-- <option value="land01">국공유지 개발/활용 대상지</option> -->
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-2">
                    	<div id="buld01_svc" style="display: none;">
                        	<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('buld01_svc_de')" style="cursor:pointer">
							<div class="open-info hide" id="buld01_svc_de">
								<div class="title">
									<h3>[설명] - 낙후(저층)주거지 찾기<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('buld01_svc_de')" style="cursor: pointer"></a></h3>
								</div>
								<div class="text"><a href="javascript:sa_value('buld01')">기본값 설정</a>
									<br/>검색 주제에 대한 항목은 아래 관련사업 팝업창에 나타난  항목과  좌측에 <b style="color:red;">빨간색</b>으로 표시된 항목을 대상으로 검색합니다.
									<br/><br/>[분석순서]<br/>1. 낙후주거대상 건물여건<br/>2. 필지여건<br/>3. 개발여건<br/>4. 입지여건<br/>5. 시설입지여건										
								</div>
							</div>
                        </div>
                    	<div id="land01_svc" style="display: none;">
                    		<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('land01_svc_de')" style="cursor:pointer">
							<div class="open-info hide" id="land01_svc_de">
								<div class="title">
									<h3>[설명] - 국공유지 개발/활용 대상지<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('land01_svc_de')" style="cursor: pointer"></a></h3>
								</div>
								<div class="text"><a href="javascript:sa_value('land01')">기본값 설정</a>
									<br/>검색 주제에 대한 항목은 아래 관련사업 팝업창에 나타난  항목과  좌측에 <b style="color:red;">빨간색</b>으로 표시된 항목을 대상으로 검색합니다.
									<br/><br/>[분석순서]<br/>1. 공유재산 대상<br/>2. 토지여건<br/>3. 건물여건<br/>4. 사업가능 여건								
								</div>
							</div>
                    	</div>
					</div> 
                </div>
            </div>
            <div class="popover-content-wrap ani-pop ver2">
                <div class="popover-content p-20">

                    <!--관련사업 검색-->
                    <div id="sa01">
                    	<div class="form-group row">                           	                            	
	                        <div class="col-xs-6">
	                        	<label for="sa01-01">도시재생관련사업</label>
	                        	<select class="form-control chosen" id="sa01-01">
	                        		<option value="00">선택하세요.</option>
	                                <option value="01">도시재생활성화지역</option>
	                                <option value="02">주거환경관리사업구역</option>
	                                <option value="03">희망지</option>
	                                <option value="04">해제지역</option>
	                            </select>
	                        </div>                            	
                           	<div class="col-xs-6">
                           		<label for="sa01-02">&nbsp;</label>
                           		<select class="form-control chosen" multiple="multiple" id="sa01-02"></select>
                           	</div>
                           	<div class="col-xs-12">
                           		<label for="sa01-03">&nbsp;</label>
                           		<select class="form-control chosen" multiple="multiple" id="sa01-03"></select>
                           	</div>
                        </div>
                        
                        <div class="divider divider-sm in"></div>
                        
                        <div class="form-group row">                           	                            	
	                        <div class="col-xs-4">
	                        	<label for="sa01-06">복합쇠퇴지역</label>
	                        	<select class="form-control chosen" id="sa01-04">
	                        		<option value="00">선택하세요.</option>
	                                <option value="01">근린</option>
	                                <option value="02">경제</option>
	                                <option value="03">복합</option>
	                            </select>
	                        </div>                            	
                           	<div class="col-xs-4">
                           		<label for="sa01-05">&nbsp;</label>
                           		<select class="form-control chosen" multiple="multiple" id="sa01-05"></select>
                           	</div>
                           	<div class="col-xs-4">
                           		<label for="sa01-06">&nbsp;</label>
                           		<select class="form-control chosen" multiple="multiple" id="sa01-06"></select>
                           	</div>
                        </div>
                        
                        <div class="divider divider-sm in"></div>
                        
                        <div class="form-group row">                           	                            	
	                        <div class="col-xs-6">
	                        	<label for="sa01-07">대중교통역세권</label>
	                        	<select class="form-control chosen" id="sa01-07">
	                        		<option value="00">선택하세요.</option>
	                        		<option value="01">1호선</option>
	                        		<option value="02">2호선</option>
	                        		<option value="03">3호선</option>
	                        		<option value="04">4호선</option>
	                        		<option value="05">5호선</option>
	                        		<option value="06">6호선</option>
	                        		<option value="07">7호선</option>
	                        		<option value="08">8호선</option>
	                        		<option value="09">9호선</option>
	                        		<option value="10">경의중앙선</option>
	                        		<option value="11">분당선</option>
	                        		<option value="12">신분당선</option>
	                            </select>
	                        </div>                            	
                           	<div class="col-xs-6">
                           		<label for="sa01-08">&nbsp;</label>
                           		<select class="form-control chosen" multiple="multiple" id="sa01-08"></select>
                           	</div>
                        </div>
                        
                        <div class="divider divider-sm in"></div>
                        
                        <!--
                        <div class="form-group row">
                            <div class="col-xs-4">
                                <label for="sa01-10">기반시설 수요지역 (준비중)</label>
                                <select class="form-control chosen" id="sa01-10">
                                	<option value="00">선택하세요.</option>
                                	<option value="01">도서관</option>
	                                <option value="02">어린이집</option>
	                                <option value="03">노인여가복지</option>
	                                <option value="04">공공체육</option>
	                                <option value="05">공원</option>
                                </select>
                            </div>
                            <div class="col-xs-4">
                           		<label for="sa01-11">&nbsp;</label>
                           		<select class="form-control chosen" id="sa01-11">
	                                <option value="00">선택하세요.</option>
	                            </select>
                           	</div>
                           	<div class="col-xs-4">
                           		<label for="sa01-12">&nbsp;</label>
                           		<select class="form-control chosen" id="sa01-12">
	                                <option value="00">선택하세요.</option>
	                            </select>
                           	</div>
                        </div>
                         
                        <div class="form-group row">
                            <div class="col-xs-4">
                                <label for="sa01-13">지구단위계획 (준비중)</label>
                                <select class="form-control chosen" id="sa01-13">
                                	<option value="00">선택하세요.</option>
                                </select>
                            </div>
                            <div class="col-xs-4">
                           		<label for="sa01-14">&nbsp;</label>
                           		<select class="form-control chosen" id="sa01-14">
	                                <option value="00">선택하세요.</option>
	                            </select>
                           	</div>
                           	<div class="col-xs-4">
                           		<label for="sa01-15">&nbsp;</label>
                           		<select class="form-control chosen" id="sa01-15">
	                                <option value="00">선택하세요.</option>
	                            </select>
                           	</div>
                        </div>
                        
                        <div class="form-group row">
                            <div class="col-xs-4">
                                <label for="sa01-16">도시관리계획관련사업 (준비중)</label>
                                <select class="form-control chosen" id="sa01-16">
                                	<option value="00">선택하세요.</option>
                                	<option value="01">도시개발사업</option>
	                                <option value="02">재정비촉진사업</option>
	                                <option value="03">정비사업(재개발·재건축)</option>
	                                <option value="04">기타사업</option>
                                </select>
                            </div>
                            <div class="col-xs-4">
                           		<label for="sa01-17">&nbsp;</label>
                           		<select class="form-control chosen" id="sa01-17">
	                                <option value="00">선택하세요.</option>
	                            </select>
                           	</div>
                           	<div class="col-xs-4">
                           		<label for="sa01-18">&nbsp;</label>
                           		<select class="form-control chosen" id="sa01-18">
	                                <option value="00">선택하세요.</option>
	                            </select>
                           	</div>
                        </div>  
                        -->
                        
                    </div>
                    <!--// End 관련사업 검색-->

                    <!--버퍼분석 검색-->
                    <div id="sa02" style="display: none;">
                        <div class="form-group row">
                            <div class="col-xs-12">
                                <label for="sa02-1">레이어선택</label>
                                <select class="form-control chosen" multiple id="sa02-1">
									<option value="01">공용재산</option>
									<option value="02">공공용재산</option>
									<option value="03">일반재산</option>
									<option value="04">행정재산</option>
									<option value="05">기업용재산</option>
									<option value="06">보존재산</option>
									<option value="07">미등록</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-group row">
                            <div class="col-xs-8">
                            	<input type="checkbox" id="sa02-2">
                                <label for="sa02-2">범위 입력 (m)</label>
                            </div>
                            <div class="col-xs-4">
                                <input type="text" class="form-control input-sm" id="sa01-4" disabled="disabled">
                            </div>
                        </div>
                        
                    </div>
                    <!--// End 버퍼분석 검색-->
                    
                    <!--역세권 사업 추진 대상 검토-->
                    <div id="sa03" style="display: none;">
                        <div class="form-group row">
                            <div class="col-xs-12">
                                <label for="sa03-1">대중교통 역세권</label>
                                <select class="form-control chosen" id="sa03-1">
                                	<option value="00" selected="selected">미선택</option>
									<option value="01">2개이상 교차하는 역</option>
									<option value="02">버스전용차로가 위치한 역 (**데이터 준비중)</option>
									<option value="03">폭 25m 이상인 도로에 위치한 역</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group row">
                            <div class="col-xs-12">
                                <label for="sa03-2">용도지역</label>
                                <select class="form-control chosen" multiple id="sa03-2">
	                                <optgroup label="주거지역">
	                                <c:forEach var="result" items="${GISCodeList}" varStatus="status">
	                                	<c:if test="${result.type eq 'SPFC' && fn:substring(result.code,0,1) eq '1' }">
										<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
										</c:if>
									</c:forEach>
	                                </optgroup>
	                                <optgroup label="상업지역">
                                    <c:forEach var="result" items="${GISCodeList}" varStatus="status">
                                 		<c:if test="${result.type eq 'SPFC' && fn:substring(result.code,0,1) eq '2' }">
										<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
										</c:if>
									</c:forEach>
	                                </optgroup>
	                                <optgroup label="공업지역">
	                                <c:forEach var="result" items="${GISCodeList}" varStatus="status">
	                                 	<c:if test="${result.type eq 'SPFC' && fn:substring(result.code,0,1) eq '3' }">
										<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
										</c:if>
									</c:forEach>
	                                </optgroup>
	                                <optgroup label="녹지지역">
	                                <c:forEach var="result" items="${GISCodeList}" varStatus="status">
	                                 	<c:if test="${result.type eq 'SPFC' && fn:substring(result.code,0,1) eq '4' }">
										<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
										</c:if>
									</c:forEach>
	                                </optgroup>
	                                <optgroup label="관리지역">
	                                <c:forEach var="result" items="${GISCodeList}" varStatus="status">
	                                 	<c:if test="${result.type eq 'SPFC' && fn:substring(result.code,0,1) eq '6' }">
										<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
										</c:if>
									</c:forEach>
	                                </optgroup>
	                                <optgroup label="기타지역">
	                                <c:forEach var="result" items="${GISCodeList}" varStatus="status">
	                                 	<c:if test="${result.type eq 'SPFC' && fn:substring(result.code,0,1) eq '5' }">
										<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
										</c:if>
										<c:if test="${result.type eq 'SPFC' && fn:substring(result.code,0,1) eq '7' }">
										<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
										</c:if>
										<c:if test="${result.type eq 'SPFC' && fn:substring(result.code,0,1) eq '8' }">
										<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
										</c:if>
									</c:forEach>
	                                </optgroup>
	                            </select>
                            </div>
                        </div>
                        <div class="form-group row">
                            <div class="col-xs-8">
                                <label for="sa03-3">사업가능 여건</label>
                                <select class="form-control chosen" id="sa03-3">
                                	<option value="00" selected="selected">미선택</option>
									<option value="01">도시재생활성화지역</option>
									<option value="02">희망지, 해제지역 (**데이터 준비중)</option>
									<option value="03">주거환경정비사업지구 (**데이터 준비중)</option>
									<option value="04">역세권</option>
                                </select>
                            </div>
                            <div class="col-xs-4">
                                <label for="sa03-4" class="label-hide">레이어선택</label>
                                <select class="form-control chosen" id="sa03-4">
                                	<option value="00" selected="selected">전체선택</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <!--// End 역세권 사업 추진 대상 검토-->
                    
                    <!--낙후(저층)주거지 찾기-->
                    <div id="buld01" style="display: none;">
                        <div class="form-group row">
                            <div class="col-xs-12">
                                <label for="buld01-01">용도지역 선택</label>
                                <select class="form-control chosen" multiple id="buld01-01">
	                                <optgroup label="주거지역">
	                                <c:forEach var="result" items="${GISCodeList}" varStatus="status">
	                                	<c:if test="${result.type eq 'SPFC' && fn:substring(result.code,0,1) eq '1' }">
										<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
										</c:if>
									</c:forEach>
	                                </optgroup>
	                                <optgroup label="상업지역">
                                    <c:forEach var="result" items="${GISCodeList}" varStatus="status">
                                 		<c:if test="${result.type eq 'SPFC' && fn:substring(result.code,0,1) eq '2' }">
										<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
										</c:if>
									</c:forEach>
	                                </optgroup>
	                                <optgroup label="공업지역">
	                                <c:forEach var="result" items="${GISCodeList}" varStatus="status">
	                                 	<c:if test="${result.type eq 'SPFC' && fn:substring(result.code,0,1) eq '3' }">
										<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
										</c:if>
									</c:forEach>
	                                </optgroup>
	                                <optgroup label="녹지지역">
	                                <c:forEach var="result" items="${GISCodeList}" varStatus="status">
	                                 	<c:if test="${result.type eq 'SPFC' && fn:substring(result.code,0,1) eq '4' }">
										<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
										</c:if>
									</c:forEach>
	                                </optgroup>
	                                <optgroup label="관리지역">
	                                <c:forEach var="result" items="${GISCodeList}" varStatus="status">
	                                 	<c:if test="${result.type eq 'SPFC' && fn:substring(result.code,0,1) eq '6' }">
										<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
										</c:if>
									</c:forEach>
	                                </optgroup>
	                                <optgroup label="기타지역">
	                                <c:forEach var="result" items="${GISCodeList}" varStatus="status">
	                                 	<c:if test="${result.type eq 'SPFC' && fn:substring(result.code,0,1) eq '5' }">
										<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
										</c:if>
										<c:if test="${result.type eq 'SPFC' && fn:substring(result.code,0,1) eq '7' }">
										<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
										</c:if>
										<c:if test="${result.type eq 'SPFC' && fn:substring(result.code,0,1) eq '8' }">
										<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
										</c:if>
									</c:forEach>
	                                </optgroup>
	                            </select>
                            </div>
                        </div>
                        
                        <div class="divider divider-sm in"></div>
                        
                        <div class="form-group row">
                            <div class="col-xs-12">
                                <label for="buld01-02">도로접면</label>
                                <select class="form-control chosen" multiple id="buld01-02">
                                <c:forEach var="result" items="${GISCodeList}" varStatus="status">
                                	<c:if test="${result.type eq 'ROAD_SIDE'}">
									<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
									</c:if>
								</c:forEach>
                                </select>
                            </div>
                        </div>
                        
                        <div class="divider divider-sm in"></div>
                        
<!--                         <div class="form-group row"> -->
<!--                             <div class="col-xs-12"> -->
<!--                                 <label for="buld01-03">도로구간 검색 범위선택 (m) (**준비중)</label> -->
<!--                                 <input type="text" class="form-control input-sm" id="buld01-03" maxlength="2"> -->
<!--                             </div> -->
<!--                         </div> -->
                        
<!--                         <div class="divider divider-sm in"></div> -->
                        
                        <div class="form-group row">                           	                            	
	                        <div class="col-xs-6">
	                        	<label for="buld01-04">입지여건</label>
	                        	<select class="form-control chosen" id="buld01-04">
	                        		<option value="00">선택하세요.</option>
	                                <option value="01">도시재생활성화지역</option>
	                                <option value="02">주거환경관리사업구역</option>
	                                <option value="03">희망지</option>
	                                <option value="04">해제지역</option>
	                            </select>
	                        </div>                            	
                           	<div class="col-xs-6">
                           		<label for="buld01-05">&nbsp;</label>
                           		<select class="form-control chosen" multiple="multiple" id="buld01-05"></select>
                           	</div>
                           	<div class="col-xs-12">
                           		<label for="buld01-06">&nbsp;</label>
                           		<select class="form-control chosen" multiple="multiple" id="buld01-06"></select>
                           	</div>
                        </div>
                        
                        <div class="divider divider-sm in"></div>
                        
                        <div class="form-group row">                           	                            	
	                        <div class="col-xs-4">
	                        	<label for="buld01-07">복합쇠퇴지역</label>
	                        	<select class="form-control chosen" id="buld01-07">
	                        		<option value="00">선택하세요.</option>
	                                <option value="01">근린</option>
	                                <option value="02">경제</option>
	                                <option value="03">복합</option>
	                            </select>
	                        </div>                            	
                           	<div class="col-xs-4">
                           		<label for="buld01-08">&nbsp;</label>
                           		<select class="form-control chosen" multiple="multiple" id="buld01-08"></select>
                           	</div>
                           	<div class="col-xs-4">
                           		<label for="buld01-09">&nbsp;</label>
                           		<select class="form-control chosen" multiple="multiple" id="buld01-09"></select>
                           	</div>
                        </div>
                    </div>
                    <!--// End 낙후(저층)주거지 찾기-->

                    <!--국공유지 개발/활용 대상지-->
                    <div id="land01" style="display: none;">
                    	<div class="form-group row">
                        	<div class="col-xs-12">
                        		<div class="row m-b-10">
	                            	<label for="land01-01" class="col-xs-3 control-label">건축년도</label>
	                              	<div class="col-xs-9">
		                              	<select id="land01-01" class="form-control input-sm">
		                        			<option value="00">::직접입력::</option>
		                       				<option value="01">건물노후(20년)</option>
		                       				<option value="02">건물노후(30년)</option>
		                       				<option value="03">건물노후(40년)</option>
		                       				<option value="04">건물노후(50년)</option>
		                       			</select>
	                       			</div>
                       			</div>
                                <div class="row p-10">
                                   <div class="col-xs-6">
                                       <div class="input-group date datetimepicker m-r-5 input-group-sm">
                                           <input type="text" class="form-control" placeholder="년/월/일" id="land01-02">
                                           <span class="input-group-addon bg-teal b-0"><i class="fa fa-calendar text-white"></i></span>
                                       </div>
                                   </div>
                                   <div class="middle-wave">~</div>
                                   <div class="col-xs-6">
                                       <div class="input-group date datetimepicker m-l-5 input-group-sm">
                                           <input type="text" class="form-control" placeholder="년/월/일" id="land01-03">
                                           <span class="input-group-addon bg-teal b-0"><i class="fa fa-calendar text-white"></i></span>
                                       </div>
                                   </div>
       							</div> 
							</div> 							                                         
						</div> 

						<div class="divider divider-sm in"></div>
												
                        <div class="form-group row">
                        	<div class="col-xs-12">
                            	<label >건폐율(%)</label>
                                <div class="p-10 form-inline">
									<input type="text" id="land01-04" maxlength="4" class="form-control input-sm"/> ~ <input type="text" id="land01-05" maxlength="4" class="form-control input-sm"/>
					        	</div> 
							</div>                                           
						</div>
						
						<div class="divider divider-sm in"></div>
											
						<div class="form-group row">
                        	<div class="col-xs-12">
                            	<label>용적률(%)</label>
                           		<div class="p-10 form-inline">
									<input type="text" id="land01-06" maxlength="4" class="form-control input-sm"/> ~ <input type="text" id="land01-07" maxlength="4" class="form-control input-sm"/>
					        	</div> 
							</div>                                           
						</div>
						
						<div class="divider divider-sm in"></div>
						
						<div class="form-group row">                           	                            	
	                        <div class="col-xs-6">
	                        	<label for="land01-08">사업가능여건</label>
	                        	<select class="form-control chosen" id="land01-08">
	                        		<option value="00">선택하세요.</option>
	                                <option value="01">도시재생활성화지역</option>
	                                <option value="02">주거환경관리사업구역</option>
	                                <option value="03">희망지</option>
	                                <option value="04">해제지역</option>
	                            </select>
	                        </div>                            	
                           	<div class="col-xs-6">
                           		<label for="land01-09">&nbsp;</label>
                           		<select class="form-control chosen" multiple="multiple" id="land01-09"></select>
                           	</div>
                           	<div class="col-xs-12">
                           		<label for="land01-10">&nbsp;</label>
                           		<select class="form-control chosen" multiple="multiple" id="land01-10"></select>
                           	</div>
                        </div>
                        
                        <div class="divider divider-sm in"></div>
						
						<div class="form-group row">                           	                            	
	                        <div class="col-xs-6">
	                        	<label for="land01-11">대중교통역세권</label>
	                        	<select class="form-control chosen" id="land01-11">
	                        		<option value="00">선택하세요.</option>
	                        		<option value="01">1호선</option>
	                        		<option value="02">2호선</option>
	                        		<option value="03">3호선</option>
	                        		<option value="04">4호선</option>
	                        		<option value="05">5호선</option>
	                        		<option value="06">6호선</option>
	                        		<option value="07">7호선</option>
	                        		<option value="08">8호선</option>
	                        		<option value="09">9호선</option>
	                        		<option value="10">경의중앙선</option>
	                        		<option value="11">분당선</option>
	                        		<option value="12">신분당선</option>
	                            </select>
	                        </div>                            	
                           	<div class="col-xs-6">
                           		<label for="land01-12">&nbsp;</label>
                           		<select class="form-control chosen" multiple="multiple" id="land01-12"></select>
                           	</div>
                        </div>
                    </div>
                    <!--// End 국공유지 개발/활용 대상지-->
                    
                </div>
            </div>

        </div>
        <div class="popover-footer ani-pop p-10">
            <div class="row">
                <div class="col-xs-12">
                    <small>※공간분석은 (좌측)검색 조건 충족 후 이루어 집니다.</small>
                    <small>※팝업창을 닫으시면 분석이 진행되지 않습니다.</small>  
                </div>
            </div>
        </div>
    </div>
    <!--// End 자산검색-공간분석-Popup -->
    
    
    
    
    