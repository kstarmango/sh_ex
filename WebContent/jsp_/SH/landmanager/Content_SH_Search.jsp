<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
$(document).ready(function(){
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

</script>



    	<!-- 자산검색 Side-Panel -->
		<div class="tab-pane fade toptab active in" role="tabpanel" id="asset-search-tab">
            <div class="pane-content map">

                <!-- Tab-Buttons -->
                <ul class="nav nav-tabs" role="tablist" id="SH_Search_tab">
                    <li role="presentation" class="active"><a href="#tab-01" role="tab" data-toggle="tab" class="map-tab01">토지</a></li>
                    <li role="presentation"><a href="#tab-02" role="tab" data-toggle="tab" class="map-tab02">건물</a></li>
                    <li role="presentation"><a href="#tab-03" role="tab" data-toggle="tab" class="map-tab03">사업지구</a></li>
                </ul>
                <!-- End Tab-Buttons -->

                <!-- Tab-Content -->
                <div class="tab-content map tabintab">

                    <div class="search-condition">
                        <div class="btn-wrap">
                            <button class="btn btn-orange btn-sm" onclick="bookmark()">즐겨찾기</button>
<!--                             <button class="btn btn-inverse btn-sm">주제도면 제작</button> -->
<!--                             <button class="btn btn-inverse btn-sm">등록</button> -->
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

                    <!-- Tab-02 -->
                    <div role="tabpanel" class="tab-pane search-result-list" id="tab-02">
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
                    </div>
                    <!-- End Tab-02 -->

                    <!-- Tab-03 -->
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
                    <!-- End Tab-03 -->

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
                        <button class="btn btn-gray btn-sm" onclick="gis_clear()">초기화</button>
                        <button class="btn btn-teal btn-sm" onclick="gis_sherch(1);">검색</button>
                    </div>

					<!-- 검색결과 Form -->
                    <form id="GISinfoResultForm" name="GISinfoResultForm" >
                    	<input type="hidden" name="geom[]">
                    </form>

                </div>
                <!-- End Tab-Content -->

            </div>
        </div>
        <!-- End 자산검색 Side-Panel -->




