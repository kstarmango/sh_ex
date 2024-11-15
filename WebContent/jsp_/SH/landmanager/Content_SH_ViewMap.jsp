<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

<script type="text/javascript">
$(document).ready(function(){

	$("#map-search-tab_Landlist input").click(function(){
		toggle_layersLand("SH_LM:"+$(this).prop("id"));
		$("#map-search-tab_Landlist input[id!="+$(this).prop("id")+"]").prop("checked", false);
	});
	$("#map-search-tab_Buldlist input").click(function(){
		toggle_layersBuld("SH_LM:"+$(this).prop("id"));
		$("#map-search-tab_Buldlist input[id!="+$(this).prop("id")+"]").prop("checked", false);
	});
	$("#map-search-tab_Distlist input").click(function(){
		toggle_layersDist("SH_LM:"+$(this).prop("id"));
		$("#map-search-tab_Distlist input[id!="+$(this).prop("id")+"]").prop("checked", false);
	});
	$("#map-search-tab_SHlist input").click(function(){
		toggle_layersSH("SH_LM:"+$(this).prop("id"));
		$("#map-search-tab_SHlist input[id!="+$(this).prop("id")+"]").prop("checked", false);
	});

});


//검색 버튼
function searchLayersName() {
	var nm = $('#Layers_nm').val();
	if( nm != ""){
		$("#map-search-tab_keyword").text("\""+nm+"\"");
	}else{
		$("#map-search-tab_keyword").text("전체리스트");
	}

	$("#map-search-tab_Landlist input, #map-search-tab_Buldlist input, #map-search-tab_Distlist input, #map-search-tab_SHlist input").parent().parent("div").hide();
	$("#map-search-tab_Landlist label:contains('"+nm+"')").parent().parent("div").show();
	$("#map-search-tab_Buldlist label:contains('"+nm+"')").parent().parent("div").show();
	$("#map-search-tab_Distlist label:contains('"+nm+"')").parent().parent("div").show();
	$("#map-search-tab_SHlist label:contains('"+nm+"')").parent().parent("div").show();
}


//주제도 오버레이
var now_layersLand = null;
var now_layersLand_nm = null;
function toggle_layersLand(layers_nm, style){
	if( now_layersLand != null ){
		geoMap.removeLayer(now_layersLand);
	}
	if( now_layersLand_nm == layers_nm ){
		now_layersLand_nm = null;
	}else{
		now_layersLand_nm = layers_nm;
		if(style != null){
			now_layersLand = get_vWorldMap(now_layersLand_nm, style);
		}else{
			now_layersLand = get_WMSlayer(now_layersLand_nm);
		}
		geoMap.addLayer(now_layersLand);
// 		now_layersLand.setOpacity(parseFloat(0.7));
	}
}
var now_layersBuld = null;
var now_layersBuld_nm = null;
function toggle_layersBuld(layers_nm, style){
	if( now_layersBuld != null ){
		geoMap.removeLayer(now_layersBuld);
	}
	if( now_layersBuld_nm == layers_nm ){
		now_layersBuld_nm = null;
	}else{
		now_layersBuld_nm = layers_nm;
		if(style != null){
			now_layersBuld = get_vWorldMap(now_layersBuld_nm, style);
		}else{
			now_layersBuld = get_WMSlayer(now_layersBuld_nm);
		}
		geoMap.addLayer(now_layersBuld);
// 		now_layersBuld.setOpacity(parseFloat(0.7));
	}
}
var now_layersDist = null;
var now_layersDist_nm = null;
function toggle_layersDist(layers_nm, style){
	if( now_layersDist != null ){
		geoMap.removeLayer(now_layersDist);
	}
	if( now_layersDist_nm == layers_nm ){
		now_layersDist_nm = null;
	}else{
		now_layersDist_nm = layers_nm;
		if(style != null){
			now_layersDist = get_vWorldMap(now_layersDist_nm, style);
		}else{
			now_layersDist = get_WMSlayer(now_layersDist_nm);
		}
		geoMap.addLayer(now_layersDist);
// 		now_layersDist.setOpacity(parseFloat(0.7));
	}
}
var now_layersSH = null;
var now_layersSH_nm = null;
function toggle_layersSH(layers_nm, style){
	if( now_layersSH != null ){
		geoMap.removeLayer(now_layersSH);
	}
	if( now_layersSH_nm == layers_nm ){
		now_layersSH_nm = null;
	}else{
		now_layersSH_nm = layers_nm;
		if(style != null){
			now_layersSH = get_vWorldMap(now_layersSH_nm, style);
		}else{
			now_layersSH = get_WMSlayer(now_layersSH_nm);
		}
		geoMap.addLayer(now_layersSH);
		now_layersSH.setOpacity(parseFloat(0.7));
	}
}
</script>



    	<!-- 주제도검색 Side-Panel -->
		<div class="tab-pane fade toptab" role="tabpanel" id="map-search-tab">
            <div class="pane-content map">

                <div class="search-result-list in-assetview">
                	<p class="srl-title"><span class="text-orange" id="map-search-tab_keyword">"전체리스트"</span> 검색결과</p>
                    <div class="list-group-wrap in-assetview">
                        <div class="collapse in">
                            <div class="list-group">

                            	<div class="col-xs-6" id="map-search-tab_Landlist">
                            		<label style="font-size: 16px;"><b>[필지단위]</b></label>
                            		<div class="form-group row">
										<div class="col-xs-12">
											<input id="mv_sn_apmm_nv_land_11" type="checkbox"/>&nbsp;
											<label for="mv_sn_apmm_nv_land_11">국공유지<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('mv_sn_apmm_nv_land_11_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="mv_sn_apmm_nv_land_11_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">국공유지<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('mv_sn_apmm_nv_land_11_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>국공유지</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>토지대장부에 등록된 토지의 상태 및 소유상태에 대한정보</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>공간정보포털 국가중점 데이터</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2018-06-16</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>분기</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>년</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>지목상 도로 등을 제외한 국유지, 시유지, 구유지 현황<br>포함지목 : 대지, 공장용지, 종교용지, 주유소 용지, 주차장, 체육용지, 학교용지</td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:mv_sn_apmm_nv_land_11&RULE=국유지"/>&nbsp;<label>국유지</label></li>
								       			<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:mv_sn_apmm_nv_land_11&RULE=시유지"/>&nbsp;<label>시유지</label></li>
								       			<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:mv_sn_apmm_nv_land_11&RULE=구유지"/>&nbsp;<label>구유지</label></li>
	                                       	</ul>
	                                    </div>
									</div>
                            		<div class="form-group row">
										<div class="col-xs-12">
											<input id="data_guk_land" type="checkbox"/>&nbsp;
											<label for="data_guk_land">국유지(일반재산,캠코)<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('data_guk_land_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="data_guk_land_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">국유지(일반재산,캠코)<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('data_guk_land_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>국유지(일반재산,캠코)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>한국자산관리공사(캠코)에서 관리중안 기획재정부 소관의 일반재산</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>e나라재산, 국유재산포털</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2019-02-01</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시,자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>반기</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>해당정보는 수시 변동될 수 있으니 재산정보에 관한 사항은 관리기관 담당부서에 문의<br>국공유지 필지 shp 데이터 활용</td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_guk_land&RULE=대부대상"/>&nbsp;<label>대부대상</label></li>
								       			<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_guk_land&RULE=매각대상"/>&nbsp;<label>매각대상</label></li>
								       			<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_guk_land&RULE=매각제한대상"/>&nbsp;<label>매각제한대상</label></li>
								       			<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_guk_land&RULE=사용중인재산"/>&nbsp;<label>사용중인재산</label></li>
	                                       	</ul>
	                                    </div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="data_tmseq_land" type="checkbox"/>&nbsp;
											<label for="data_tmseq_land">시유지(일반,SH위탁)<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('data_tmseq_land_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="data_tmseq_land_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">시유지(일반,SH위탁)<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('data_tmseq_land_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>시유지(일반재산,위탁관리)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>서울시(자산관리과)가 소유한 일반재산 중 서울주택도시공사에 위탁관리한 대상</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>[서울주택도시공사] 공유재산관리부</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2019-03-20</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시,자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>분기</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>해당정보는 수시 변동될 수 있으니 상세한 정보는 담당부서에 문의(공유재산관리부)</td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_tmseq_land&RULE=관리대상"/>&nbsp;<label>관리대상</label></li>
								       			<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_tmseq_land&RULE=관리제외"/>&nbsp;<label>관리제외</label></li>
	                                       	</ul>
	                                    </div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="data_region_land" type="checkbox"/>&nbsp;
											<label for="data_region_land">시유지(일반,구위임)<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('data_region_land_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="data_region_land_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">시유지(일반,구위임)<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('data_region_land_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>시유지(일반재산,자치구위임관리)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>서울시(자산관리과)가 소유한 일반재산 중 자치구에 위임하여 관리하고 있는 대상</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>자치구별 재무과</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2017-07-18</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시,자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>년(수급가능여부에 따름)</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>해당정보는 수시 변동될 수 있으니  상세한 정보는 관리기관 및 담당자부서에 문의 (소재지 자치구)</td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_region_land&RULE=자치구위임관리시유지"/>&nbsp;<label>자치구위임관리시유지</label></li>
	                                       	</ul>
	                                    </div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="data_owned_city" type="checkbox"/>&nbsp;
											<label for="data_owned_city">시유지(자치구관리)<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('data_owned_city_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="data_owned_city_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">시유지(자치구관리)<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('data_owned_city_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>시유지(일반재산,자치구위임관리)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>서울시가 소유한 일반재산과 행정재산으로 자치구가 관리하고 있는 대상</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>자치구별 재무과</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2017-06-30</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시,자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>년</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>자치구에 따라 행정재산 등 제공데이터가 다름. 해당정보는 수시 변동될 수 있으니  상세한 정보는 관리기관 및 담당자부서에 문의(소재지 자치구) 데이터 기준시점이 상이하여 참고용으로만 사용하는 것을 권장함</td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_owned_city&RULE=일반재산"/>&nbsp;<label>일반재산</label></li>
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_owned_city&RULE=행정재산"/>&nbsp;<label>행정재산</label></li>
	                                       	</ul>
	                                    </div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="data_owned_guyu" type="checkbox"/>&nbsp;
											<label for="data_owned_guyu">구유지(자치구관리)<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('data_owned_guyu_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="data_owned_guyu_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">구유지(자치구관리)<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('data_owned_guyu_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>구유지(일반재산 및 행정재산,자치구관리)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>자치구가 소유한 일반재산과 행정재산으로 자치구가 관리하고 있는 대상</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>자치구별 재무과</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2017-06-30</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시,자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>년</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>자치구에 따라 행정재산 등 제공데이터가 다름. 해당정보는 수시 변동될 수 있으니  상세한 정보는 관리기관 및 담당자부서에 문의(소재지 자치구) 데이터 기준시점이 상이하여 참고용으로만 사용하는 것을 권장함</td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_owned_guyu&RULE=일반재산"/>&nbsp;<label>일반재산</label></li>
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_owned_guyu&RULE=행정재산"/>&nbsp;<label>행정재산</label></li>
	                                       	</ul>
	                                    </div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="data_public_site" type="checkbox"/>&nbsp;
											<label for="data_public_site">공공기관 이전부지<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('data_public_site_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="data_public_site_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">공공기관 이전부지<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('data_public_site_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>공공기관 이전부지</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>서울시역 내 공공기관 이전(완료)부지</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>관련연구보고서 내 현황 및 계획정보</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2016</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>해당없음</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>해당없음</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>대상지별 관련정보를 취합하여 공간정보로 변환함. 시기별 출처에 따라 정보가 상이할 수 있음. 최신 종전 부동산의 매각현황 정보는 이노시티 홈페이지를 통해 확인 및 문의</td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_public_site&RULE=공공기관이전부지"/>&nbsp;<label>공공기관 이전부지</label></li>
	                                       	</ul>
	                                    </div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="data_public_parking" type="checkbox"/>&nbsp;
											<label for="data_public_parking">공영주차장<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('data_public_parking_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="data_public_parking_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">공영주차장<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('data_public_parking_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>공영주차장</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>서울시 및 자치구 시설관리공단이 관리하고 있는 공영주차장</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>서울시설관리공단, 각자치구별 시설관리공단</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2018-08-31</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>월</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>반기</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>정보는 변동될 수 있으니 상세한 정보는 출처별 사이트를 통해 확인</td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_public_parking&RULE=공영주차장"/>&nbsp;<label>공영주차장</label></li>
	                                       	</ul>
	                                    </div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="data_generations" type="checkbox"/>&nbsp;
											<label for="data_generations">역세권사업 후보지<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('data_generations_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="data_generations_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">역세권사업 후보지<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('data_generations_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>역세권사업 후보지</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>공사에서 역세권 청년주택사업을 추진/검토하고 있는 대상지</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>[서울주택도시공사] 역세권개발부</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2017-12-31</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시,자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>반기(사업진행에 따름)</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>정보는 변동될 수 있으니 진행사항 및 상세한 정보는 담당부서에 문의(역세권사업부)</td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_generations&RULE=완료"/>&nbsp;<label>완료</label></li>
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_generations&RULE=진행"/>&nbsp;<label>진행</label></li>
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_generations&RULE=준비"/>&nbsp;<label>준비</label></li>
	                                       	</ul>
	                                    </div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="data_council_land" type="checkbox"/>&nbsp;
											<label for="data_council_land">임대주택 단지<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('data_council_land_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="data_council_land_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">임대주택 단지<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('data_council_land_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>임대주택 단지</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>서울주택도시공사가 공급/관리하고 있는 임대주택단지</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>[서울주택도시공사] 맞춤임대부</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2017-12-31</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시,자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>반기(사업진행에 따름)</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>[수정 중] 해당부지 영역이 설정되어 있지 않거나, 지번이 부여되지 않은 경우는 제외됨, 단지 및 건물 동 등의 공간정보를 재구축하여 제공할 계획임</td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_council_land&RULE=임대주택단지"/>&nbsp;<label>임대주택 단지</label></li>
	                                       	</ul>
	                                    </div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="data_minuse" type="checkbox"/>&nbsp;
											<label for="data_minuse">저이용공공시설<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('data_minuse_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="data_minuse_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">저이용공공시설<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('data_minuse_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>저이용공공시설</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>SH도시연구원 연구수행 결과물</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>[SH도시연구원] 공공시설 복합개발을 통한 임대주택 공급방안 연구(2011) 연구책임:이영민</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2016</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>해당없음</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>해당없음</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>기준 및 상세대상 설명은 보고서 참고</td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_minuse&RULE=저이용공공시설"/>&nbsp;<label>저이용공공시설</label></li>
	                                       	</ul>
	                                    </div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="data_industry" type="checkbox"/>&nbsp;
											<label for="data_industry">공공부지 혼재지역<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('data_industry_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="data_industry_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">공공부지 혼재지역<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('data_industry_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>공공부지 혼재지역</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>SH도시연구원 연구수행 결과물</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>[SH도시연구원] 공공부지 혼재지역 활용을 위한 기초 연구(2016) 연구책임:김승주</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2016</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>해당없음</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>해당없음</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>기준 및 상세대상 설명은 보고서 참고</td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_industry&RULE=공공부지혼재지역"/>&nbsp;<label>공공부지 혼재지역</label></li>
	                                       	</ul>
	                                    </div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="hjj_group" type="checkbox"/>&nbsp;
											<label for="hjj_group">공공부지 혼재지역(서울)<span class="caret m-l-5"></span></label>
											<!-- img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('hjj_group_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="data_industry_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">공공부지 혼재지역(서울)<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('data_industry_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>공공부지 혼재지역</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>SH도시연구원 연구수행 결과물</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>[SH도시연구원] 공공부지 혼재지역 활용을 위한 기초 연구(2016) 연구책임:김승주</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2016</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>해당없음</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>해당없음</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>기준 및 상세대상 설명은 보고서 참고</td></tr>
													</table>
												</div>
											</div-->
											<ul class="layers_d4" style="padding:10px;">
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:hjj_f_category&RULE=LIST관리"/>&nbsp;<label>LIST관리</label></li>
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:hjj_f_category&RULE=소유권정리"/>&nbsp;<label>소유권정리</label></li>
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:hjj_f_category&RULE=통합활용"/>&nbsp;<label>통합활용</label></li>
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:hjj_f_own&RULE=구유지"/>&nbsp;<label>구유지</label></li>
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:hjj_f_own&RULE=국유지"/>&nbsp;<label>국유지</label></li>
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:hjj_f_own&RULE=법인"/>&nbsp;<label>법인</label></li>
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:hjj_f_own&RULE=시유지"/>&nbsp;<label>시유지</label></li>
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:hjj_f_own&RULE=시유지+"/>&nbsp;<label>시유지+</label></li>
	                                       	</ul>
	                                    </div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="data_priority" type="checkbox"/>&nbsp;
											<label for="data_priority">중점활용 시유지<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('data_priority_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="data_priority_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">중점활용 시유지<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('data_priority_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>중점활용 시유지</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>서울연구원 연구수행 결과물</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>[서울연구원] 공공토지자원 활용 기본구상 및 사업화 방안 수립(2016) 연구책임:민승현(서울연구원)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2016</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>해당없음</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>해당없음</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>서울시 공공개발센터와 우리공사가 공동수행한 연구용역 결과</td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_priority&RULE=중점활용시유지"/>&nbsp;<label>중점활용 시유지</label></li>
	                                       	</ul>
	                                    </div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_31" type="checkbox"/>&nbsp;
											<label for="basic_31">대학교<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('basic_31_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="basic_31_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">대학교<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('basic_31_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>대학교</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>서울시 소재 대학 캠퍼스 현황</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>서울시보 등 (도시계획시설 고시 변경 참조)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2016-</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시, 자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>년 (변경시)</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td></td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_31&RULE=대학교"/>&nbsp;<label>대학교</label></li>
											</ul>
										</div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_34" type="checkbox"/>&nbsp;
											<label for="basic_34">빈집<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('basic_34_svc')" style="cursor:pointer">
 											<div class="open-info hide" id=basic_34_svc style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">빈집<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('basic_34_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>빈집</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>서울시 소재 빈집 현황</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td></td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2019-</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시, 자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>변경시</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td></td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_34&RULE=계약완료"/>&nbsp;<label>계약완료</label></li>
											</ul>
										</div>
									</div>
                            	</div>

								<div class="col-xs-6"  id="map-search-tab_Distlist">
                            		<label style="font-size: 16px;"><b>[사업지구]</b></label>
                            		<div class="form-group row">
										<div class="col-xs-12">
											<input id="sh_district" type="checkbox"/>&nbsp;
											<label for="sh_district">사업지구[수정중]<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('sh_district_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="sh_district_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">사업지구[수정중]<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('sh_district_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>사업지구[수정중]</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>서울주택도시공사가 추진한 택지개발사업 지구</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>[서울주택도시공사] 도시공간기획부, 도시개발계획부 등</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2017(각 사업지구별로 상이)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시,자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>반기(사업진행에 따름)</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>[수정 중] 택지정보시스템(LH) 공개 정보와 공간정보 매칭을 통한 속성정보 수정 작업 후 제공할 계획임</td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
	                                       		<li><label>사업지구 전체</label></li>
	                                       	</ul>
	                                    </div>
									</div>
								</div>

                            	<div class="col-xs-6"  id="map-search-tab_Buldlist">
                            		<label style="font-size: 16px;"><b>[건물단위]</b></label>
                            		<div class="form-group row">
										<div class="col-xs-12">
											<input id="data_cynlst" type="checkbox"/>&nbsp;
											<label for="data_cynlst">재난위험시설<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('data_cynlst_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="data_cynlst_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">재난위험시설<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('data_cynlst_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>재난위험시설</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>2014.12.19년 재난위험시설 조사결과에 따라 D,E급 시설물 중 건물 및 해당부지</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>서울시 내부자료</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2014</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>해당없음</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>해당없음</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>참고용으로만 사용하는 것을 권장함</td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_cynlst&RULE=재난위험시설"/>&nbsp;<label>재난위험시설</label></li>
	                                       	</ul>
	                                    </div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="data_public_buld_c" type="checkbox"/>&nbsp;
											<label for="data_public_buld_c">공공건축물<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('data_public_buld_c_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="data_public_buld_c_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">공공건축물<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('data_public_buld_c_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>공공건축물</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>2014.12.19년 재난위험시설 조사결과에 따라 D,E급 시설물 중 건물 및 해당부지</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>서울시 내부자료</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2014</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>해당없음</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>해당없음</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>참고용으로만 사용하는 것을 권장함</td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_public_buld_c&RULE=공공건축물"/>&nbsp;<label>공공건축물</label></li>
	                                       	</ul>
	                                    </div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="data_purchase" type="checkbox"/>&nbsp;
											<label for="data_purchase">매임임대[수정중]<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('data_purchase_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="data_purchase_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">매임임대[수정중]<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('data_purchase_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>매임임대[수정중]</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>서울주택도시공사에서 매입한 대상(매입형,건설형)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>[서울주택도시공사] 맞춤임대부</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2017</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시,자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>분기(기준 정리 후 반영)</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>[수정 중] 매입시기, 매입(사업)방법, 건물형태, 공급대상 등에 따른 구분기준을 재정리하여 제공할 계획임</td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_purchase&RULE=매입임대"/>&nbsp;<label>매입임대</label></li>
	                                       	</ul>
	                                    </div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="data_declining" type="checkbox"/>&nbsp;
											<label for="data_declining">노후매입임대<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('data_declining_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="data_declining_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">노후매입임대<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('data_declining_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>노후매입임대</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>서울주택도시공사에서 매입한 다구 주택의 전수조사를 실시하여 국고가 미투입된 2002~2003년 매입된 다가구의 노후도 및 사업성 검토 대상(총 196동)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>[서울주택도시공사] 공동체사업부</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2019-03-29</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>해당없음</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>해당없음</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>행정안전부 도로명 주소 안내시스템 건물 DB(도형) 활용</td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_declining&RULE=노후매입임대"/>&nbsp;<label>노후매입임대</label></li>
	                                       	</ul>
	                                    </div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="data_rental" type="checkbox"/>&nbsp;
											<label for="data_rental">서울시 임대주택<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('data_rental_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="data_rental_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">서울시 임대주택<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('data_rental_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>서울시 임대주택</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>서울시에 공급된 임대주택 (사업자 : LH, SH)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>마이홈포털</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2019-02-01</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시, 자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>반기</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>서울시에 공급된 임대주택 전체 정보로 SH공사 공급외 임대주택 현황 파악 가능 정보는 변동될 수 있으니 상세한 정보는 출처별 사이트를 통해 확인</td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_rental&RULE=SH공사"/>&nbsp;<label>SH공사</label></li>
	                                       		<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_rental&RULE=LH서울"/>&nbsp;<label>LH서울</label></li>
	                                       	</ul>
	                                    </div>
									</div>

                            	</div>


								<div class="col-xs-6"  id="map-search-tab_SHlist">
                            		<label style="font-size: 16px;"><b>[기초현황인프라]</b></label>


									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_20_1" type="checkbox"/>&nbsp;
											<label for="basic_20_1">국공립유치원 위치도<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('basic_20_1_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="basic_20_1_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">국공립유치원<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('basic_20_1_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>국공립유치원</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>지역의 기초생활인프라 공급 현황 자료(auri)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>교육부 유아교육정책과(2017국토모니터링보고서)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2016-04-01</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시, 자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>반기</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td></td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_20_1&RULE=국공립유치원"/>&nbsp;<label>국공립유치원</label></li>
											</ul>
										</div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_20_2" type="checkbox"/>&nbsp;
											<label for="basic_20_2">사립유치원 위치도<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('basic_20_2_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="basic_20_2_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">사립유치원<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('basic_20_2_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>사립유치원</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>지역의 기초생활인프라 공급 현황 자료(auri)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>교육부 유아교육정책과(2017국토모니터링보고서)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2016-04-01</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시, 자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>반기</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td></td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_20_2&RULE=사립유치원"/>&nbsp;<label>사립유치원</label></li>
											</ul>
										</div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_20" type="checkbox"/>&nbsp;
											<label for="basic_20">전체유치원 위치도<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('basic_20_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="basic_20_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">전체유치원<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('basic_20_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>전체유치원</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>지역의 기초생활인프라 공급 현황 자료(auri)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>교육부 유아교육정책과(2017국토모니터링보고서)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2016-04-01</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시, 자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>반기</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td></td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_20&RULE=전체유치원"/>&nbsp;<label>전체유치원</label></li>
											</ul>
										</div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_30_1" type="checkbox"/>&nbsp;
											<label for="basic_30_1">초등학교 위치도<span class="caret m-l-5"></span></label>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_30_1&RULE=초등학교"/>&nbsp;<label>초등학교</label></li>
											</ul>
										</div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_18" type="checkbox"/>&nbsp;
											<label for="basic_18">도서관 위치도<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('basic_18_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="basic_18_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">도서관<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('basic_18_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>도서관</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>지역의 기초생활인프라 공급 현황 자료(auri)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>문화체육관광부 국가도서관통계시스템</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2017-12-31</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시, 자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>반기</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td>최신 오픈 데이터 자료 별도 보유 (기초생활인프라 공급 분석 결과_주제도)</td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_18&RULE=도서관"/>&nbsp;<label>도서관</label></li>
											</ul>
										</div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_19_2" type="checkbox"/>&nbsp;
											<label for="basic_19_2">국공립어린이집 위치도<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('BASIC_19_2_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="BASIC_19_2_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">국공립어린이집<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('BASIC_19_2_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>국공립어린이집</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>지역의 기초생활인프라 공급 현황 자료(auri)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>보건복지부 보육정책과(2017국토모니터링 보고서)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2017-07-01</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시, 자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>반기</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td></td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_19_2&RULE=국공립어린이집"/>&nbsp;<label>국공립어린이집</label></li>
											</ul>
										</div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_19_1" type="checkbox"/>&nbsp;
											<label for="basic_19_1">민간어린이집 위치도<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('BASIC_19_1_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="BASIC_19_1_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">민간어린이집<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('BASIC_19_1_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>민간어린이집</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>지역의 기초생활인프라 공급 현황 자료(auri)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>보건복지부 보육정책과(2017국토모니터링 보고서)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2017-07-01</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시, 자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>반기</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td></td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_19_1&RULE=민간어린이집"/>&nbsp;<label>민간어린이집</label></li>
											</ul>
										</div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_19" type="checkbox"/>&nbsp;
											<label for="basic_19">전체 어린이집 위치도<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('BASIC_19_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="BASIC_19_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">전체 어린이집<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('BASIC_19_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>전체 어린이집</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>지역의 기초생활인프라 공급 현황 자료(auri)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>보건복지부 보육정책과(2017국토모니터링 보고서)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2017-07-01</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시, 자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>반기</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td></td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_19&RULE=전체어린이집"/>&nbsp;<label>전체어린이집</label></li>
											</ul>
										</div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_21" type="checkbox"/>&nbsp;
											<label for="basic_21">경로당 위치도<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('basic_21_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="basic_21_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">경로당<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('basic_21_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>경로당</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>지역의 기초생활인프라 공급 현황 자료(auri)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>지자체 공문</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2017-12-31</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시, 자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>반기</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td></td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_21&RULE=경로당"/>&nbsp;<label>경로당</label></li>
											</ul>
										</div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_21_1" type="checkbox"/>&nbsp;
											<label for="basic_21_1">노인교실 위치도<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('basic_21_1_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="basic_21_1_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">노인교실<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('basic_21_1_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>노인교실</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>지역의 기초생활인프라 공급 현황 자료(auri)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>지자체 공문</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2017-12-31</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시, 자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>반기</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td></td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_21_1&RULE=노인교실"/>&nbsp;<label>노인교실</label></li>
											</ul>
										</div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_25" type="checkbox"/>&nbsp;
											<label for="basic_25">의원 위치도<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('basic_25_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="basic_25_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">의원<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('basic_25_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>의원</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>지역의 기초생활인프라 공급 현황 자료(auri)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>사업자주소록</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2018-09-01</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시, 자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>해당없음</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td></td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_25&RULE=의원"/>&nbsp;<label>의원</label></li>
											</ul>
										</div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_26" type="checkbox"/>&nbsp;
											<label for="basic_26">약국 위치도<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('basic_26_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="basic_26_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">약국<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('basic_26_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>약국</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>지역의 기초생활인프라 공급 현황 자료(auri)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>사업자주소록</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2018-09-01</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시, 자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>해당없음</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td></td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_26&RULE=약국"/>&nbsp;<label>약국</label></li>
											</ul>
										</div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_22" type="checkbox"/>&nbsp;
											<label for="basic_22">공공체육 위치도<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('basic_22_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="basic_22_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">공공체육<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('basic_22_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>공공체육</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>지역의 기초생활인프라 공급 현황 자료(auri)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>문화체육관광부 체육진흥관리공당(2017국토모니터링 보고서)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2017-08-01</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시, 자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>반기</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td></td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_22&RULE=공공체육"/>&nbsp;<label>공공체육</label></li>
											</ul>
										</div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_23" type="checkbox"/>&nbsp;
											<label for="basic_23">도시공원 위치도<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('basic_23_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="basic_23_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">도시공원<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('basic_23_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>도시공원</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>지역의 기초생활인프라 공급 현황 자료(auri)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>LH스마트본부 공간정보처(2017국토모니터링 보고서)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2017-01-01</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시, 자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>반기</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td></td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_23&RULE=도시공원"/>&nbsp;<label>도시공원</label></li>
											</ul>
										</div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_27" type="checkbox"/>&nbsp;
											<label for="basic_27">소매점 위치도<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('basic_27_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="basic_27_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">소매점<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('basic_27_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>소매점</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>지역의 기초생활인프라 공급 현황 자료(auri)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>한국체인스토어업체 유통업체연감</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2017-</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시, 자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>해당없음</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td></td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_27&RULE=소매점"/>&nbsp;<label>소매점</label></li>
											</ul>
										</div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_24" type="checkbox"/>&nbsp;
											<label for="basic_24">공영주차장 위치도<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('basic_24_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="basic_24_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">공영주차장<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('basic_24_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>공영주차장</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>지역의 기초생활인프라 공급 현황 자료(auri)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>지자체 공문</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2017-12-31</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시, 자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>반기</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td></td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_24&RULE=공영주차장"/>&nbsp;<label>공영주차장</label></li>
											</ul>
										</div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_28" type="checkbox"/>&nbsp;
											<label for="basic_28">시청/구청/주민센터 위치도<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('basic_28_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="basic_28_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">시청/구청/주민센터 <a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('basic_28_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>시청/구청/주민센터 </td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>서울시 소재 공공기관</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>서울 열린데이터 광장(스마트도시정책관 빅데이터 담당관)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2016-03-03</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시, 자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>년 (변경시)</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td></td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_28&RULE=시청"/>&nbsp;<label>시청</label></li>
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_28&RULE=구청"/>&nbsp;<label>구청</label></li>
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_28&RULE=주민센터"/>&nbsp;<label>주민센터</label></li>
											</ul>
										</div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_29" type="checkbox"/>&nbsp;
											<label for="basic_29">보건소/소방서/우체국 위치도<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('basic_29_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="basic_29_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">보건소/소방서/우체국 <a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('basic_29_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>보건소/소방서/우체국</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>서울시 소재 공공기관</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>서울 열린데이터 광장(스마트도시정책관 빅데이터 담당관)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2016-03-03</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>비정기(수시, 자료변경시)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>년 (변경시)</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td></td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_29&RULE=보건소"/>&nbsp;<label>보건소</label></li>
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_29&RULE=소방서"/>&nbsp;<label>소방서</label></li>
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_29&RULE=우체국"/>&nbsp;<label>우체국</label></li>
											</ul>
										</div>
									</div>

									<div class="form-group row">
										<div class="col-xs-12">
											<input id="basic_30" type="checkbox"/>&nbsp;
											<label for="basic_30">학교(초,중,고) 위치도<span class="caret m-l-5"></span></label>
											<img src="/jsp/SH/img/btn-info01.png" onclick="showTooltip('basic_30_svc')" style="cursor:pointer">
 											<div class="open-info hide" id="basic_30_svc" style="width: 210px;">
												<div class="title">
													<h3 style="font-size:12px">학교(초,중,고) <a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" onclick="showTooltip('basic_30_svc')" style="cursor: pointer"></a></h3>
												</div>
												<div class="text">
													<table style="font-size:11px;">
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데이터명</td><td></td><td>학교(초,중,고)</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>설&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td><td></td><td>서울소재 공시대상 학교기본정보</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처</td><td></td><td>학교알리미 공개용데이터</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>데&nbsp;&nbsp;이&nbsp;&nbsp;터<br/>기&nbsp;&nbsp;준&nbsp;&nbsp;일</td><td></td><td>2018-</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>원데이터<br/>갱신주기</td><td></td><td>년</td></tr>
														<tr style="border-bottom:0.5px solid #B2CCFF;"><td>시&nbsp;&nbsp;스&nbsp;&nbsp;템<br/>갱신주기</td><td></td><td>년 (변경시)</td></tr>
														<tr><td>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td><td></td><td></td></tr>
													</table>
												</div>
											</div>
											<ul class="layers_d4" style="padding:10px;">
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_30&RULE=초등학교"/>&nbsp;<label>초등학교</label></li>
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_30&RULE=중학교"/>&nbsp;<label>중학교</label></li>
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_30&RULE=고등학교"/>&nbsp;<label>고등학교</label></li>
												<li><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:basic_30&RULE=기타학교"/>&nbsp;<label>기타학교</label></li>
											</ul>
										</div>
									</div>

                            	</div>

							</div>
						</div>
                	</div>
                </div>

                <div class="btn-wrap tab text-right">
                	<div class="input-group input-group-sm">
                        <input type="text" class="form-control" placeholder="레이어명 입력" id="Layers_nm" onkeypress="if(event.keyCode==13) {searchLayersName();}">
                        <span class="input-group-btn">
                            <!-- <button class="btn btn-teal btn-sm" onclick="searchLayersName()">검색</button> -->
                            <button class="btn btn-teal btn-sm" onclick="searchLayersNameNew()">검색</button>
                        </span>
                    </div>
                </div>

            </div>
        </div>
        <!-- End 주제도검색 Side-Panel -->
