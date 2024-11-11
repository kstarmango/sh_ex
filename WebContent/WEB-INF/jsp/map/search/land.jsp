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
	
	initSlider("parea"); //토지면적 슬라이드 초기화
	initSlider("pnilp"); //공시지가 슬라이드 초기화
	
	$("select[id$='_sido']").trigger('change');
	$("select[id$='_sig']").trigger('change');
	
	//현재 안쓰임
	$("#fn_cp_date_select").change(function() {
		var sel = $("#fn_cp_date_select").val();
		var today = new Date(); // 현재 시간
		var year = today.getFullYear();
		var month = today.getMonth()+1;
		var day = today.getDate();		
		
		if( sel == "00" ){
			$("#num_cp_date_1").val( null );
			$("#num_cp_date_2").val( null );
		}else if( sel == "01" ){
			$("#num_cp_date_1").val( null );
			$("#num_cp_date_2").val( (year-20)+"/"+month+"/"+day );
		}else if( sel == "02" ){ 		
			$("#num_cp_date_1").val( null );
			$("#num_cp_date_2").val( (year-30)+"/"+month+"/"+day );
		}else if( sel == "03" ){
			$("#num_cp_date_1").val( null );
			$("#num_cp_date_2").val( (year-40)+"/"+month+"/"+day );
		}else if( sel == "04" ){ 
			$("#num_cp_date_1").val( null );
			$("#num_cp_date_2").val( (year-50)+"/"+month+"/"+day );			
		}
		
	});
});
var fs_KindList 	= ["gb", "jimok", "parea", "pnilp", "spfc", "land_use", "geo_hl", "geo_form", "road_side"];
var fs_dataList 	= ["guk_land", "tmseq_land", "region_land", "owned_city", "owned_guyu", "residual_land", "unsold_land", "invest", "public_site", "public_parking", "generations", "council_land", "minuse", "industry", "priority"];
</script>
	<title>토지검색</title>
<body>
<!-- Tab-01 토지검색-->
<div role="tabpanel" class="areaSearch full" id="tab-01" style="overflow:auto;">
	<h2 class="tit">토지검색</h2>
	<form id="tab-01_Form" name="tab-01_Form"  onsubmit="return false;" >
		<h3 class="tit">행정구역</h3>
		<div class="selectWrap">
      <div class="disFlex">
      	<label for="fs_sido">· 시도</label>
      	<select class="form-control chosen" id="fs_sido" name="sido_cd" title="시도">
      		<c:forEach var="result" items="${SIDOList}" varStatus="sido_cd">
						<option value='<c:out value="${result.sido_cd}"/>'><c:out value="${result.sido_kor_nm}"/></option>
					</c:forEach>
				</select>
			</div>  
			<div class="disFlex">
	        	<label for="fs_sig">· 시군구</label>
	        	<select class="form-control chosen" id="fs_sig" title="시군구">
                	<!-- <option value="0000" selected="selected">전체선택</option> -->
                    	<c:forEach var="result" items="${SIGList}" varStatus="status">
							<option value='<c:out value="${result.sig_cd}"/>'><c:out value="${result.sig_kor_nm}"/></option>
						</c:forEach>
				</select>
			</div>  
			<div class="disFlex">
	        	<label for="fs_emd">· 읍면동</label>
	        	<select class="form-control chosen" id="fs_emd" title="읍면동">
                      <option value="0000" selected="selected">전체선택</option> 
				</select>
			</div>    
		</div>
		<h3 class="tit">소유</h3>
		<div class="selectWrap">
	        <div class="disFlex">
            	<select class="form-control chosen" multiple id="fs_gb" title="소유">
              			<c:forEach var="result" items="${PRTOWNList}" varStatus="status">
                      		<option value='<c:out value="${result.pcode}"/>'><c:out value="${result.plabel}"/></option>
					</c:forEach>
				</select>
			</div>    
		</div>
		<h3 class="tit">지목</h3>
		<div class="selectWrap">
	        <div class="disFlex">
            	<select class="form-control chosen" multiple id="fs_jimok" title="지목">
                	<c:forEach var="result" items="${JIMOKList}" varStatus="status">
						<option value='<c:out value="${result.pcode}"/>'><c:out value="${result.plabel}"/></option>
					</c:forEach>
				</select>
			</div>    
		</div>
		<h3 class="tit">토지면적</h3>
		<div id="fs_parea">
        	<p class="range-label"><b>범위(㎡) :</b><span id="amount_parea"></span></p>
			<div id="slider_parea" class="slider-margin"></div>
			<div class="disFlex">
				<input type="text" id="num_parea_1" size="10" class="form-control input-ib" title="최소 토지면적" onKeyup="slider_range('parea')"> ~ <input type="text" id="num_parea_2" title="최대 토지면적" size="10" class="form-control input-ib" onKeyup="slider_range('parea')">
			</div>
        </div>
        <h3 class="tit">공시지가</h3>
		<div id="fs_pnilp">
     		<p class="range-label"><b>범위(원) :</b><span id="amount_pnilp"></span></p>
			<div id="slider_pnilp" class="slider-margin"></div>
			<div class="disFlex">
				<input type="text" id="num_pnilp_1" size="10" class="form-control input-ib" title="최소 공시지가" onKeyup="slider_range('pnilp')"> ~ <input type="text" id="num_pnilp_2" title="최대 공시지가" size="10" class="form-control input-ib" onKeyup="slider_range('pnilp')">
  			</div>
  		</div> 
		<h3 class="tit">용도지역</h3>
		<div class="selectWrap">
			<div class="disFlex">
				<select class="form-control chosen" multiple id="fs_spfc" title="용도지역">
                	<optgroup label="주거지역">
	                    <c:forEach var="result" items="${SPFCList}" varStatus="status">
	                    	<c:if test="${fn:substring(result.pcode,0,1) eq '1' }">
								<option value='<c:out value="${result.pcode}"/>'><c:out value="${result.plabel}"/></option>
							</c:if>
						</c:forEach>		
                    </optgroup>
                    <optgroup label="상업지역">
                    	<c:forEach var="result" items="${SPFCList}" varStatus="status">
                        	<c:if test="${ fn:substring(result.pcode,0,1) eq '2' }">
								<option value='<c:out value="${result.pcode}"/>'><c:out value="${result.plabel}"/></option>
							</c:if>
						</c:forEach>
					</optgroup>
                    <optgroup label="공업지역">
                    	<c:forEach var="result" items="${SPFCList}" varStatus="status">
                        	<c:if test="${fn:substring(result.pcode,0,1) eq '3' }">
								<option value='<c:out value="${result.pcode}"/>'><c:out value="${result.plabel}"/></option>
							</c:if>
						</c:forEach>
                   	</optgroup>
                    <optgroup label="녹지지역">
                    	<c:forEach var="result" items="${SPFCList}" varStatus="status">
                        	<c:if test="${fn:substring(result.pcode,0,1) eq '4' }">
								<option value='<c:out value="${result.pcode}"/>'><c:out value="${result.plabel}"/></option>
							</c:if>
						</c:forEach>
					</optgroup>
                    <optgroup label="관리지역">
                    	<c:forEach var="result" items="${SPFCList}" varStatus="status">
                        	<c:if test="${fn:substring(result.pcode,0,1) eq '6' }">
								<option value='<c:out value="${result.pcode}"/>'><c:out value="${result.plabel}"/></option>
							</c:if>
						</c:forEach>
					</optgroup>
                    <optgroup label="기타지역">
	                    <c:forEach var="result" items="${SPFCList}" varStatus="status">
	                 		<c:if test="${fn:substring(result.pcode,0,1) eq '5' }">
								<option value='<c:out value="${result.pcode}"/>'><c:out value="${result.plabel}"/></option>
							</c:if>
							<c:if test="${fn:substring(result.pcode,0,1) eq '7' }">
								<option value='<c:out value="${result.pcode}"/>'><c:out value="${result.plabel}"/></option>
							</c:if>
							<c:if test="${fn:substring(result.pcode,0,1) eq '8' }">
								<option value='<c:out value="${result.pcode}"/>'><c:out value="${result.plabel}"/></option>
							</c:if>
						</c:forEach>
					</optgroup>
				</select>
			</div>
		</div>
		<h3 class="tit">토지이용상황</h3>
		<div class="selectWrap">
	        <div class="disFlex">
            	<select class="form-control chosen" multiple id="fs_land_use" title="토지이용상황">
                	<c:forEach var="result" items="${LANDUSEList}" varStatus="status">
						<option value='<c:out value="${result.pcode}"/>'><c:out value="${result.plabel}"/></option>
					</c:forEach>
				</select>
			</div>    
		</div>
		<h3 class="tit">지형고저</h3>
		<div class="selectWrap">
	        <div class="disFlex">
            	<select class="form-control chosen" multiple id="fs_geo_hl" title="지형고저">
		       		<c:forEach var="result" items="${GEOHLList}" varStatus="status">
						<option value='<c:out value="${result.pcode}"/>'><c:out value="${result.plabel}"/></option>
					</c:forEach>
				</select>
			</div>    
		</div>
		<h3 class="tit">지형형상</h3>
		<div class="selectWrap">
	        <div class="disFlex">
       			<select class="form-control chosen" multiple id="fs_geo_form" title="지형형상">
                	<c:forEach var="result" items="${GEOFORMList}" varStatus="status">
						<option value='<c:out value="${result.pcode}"/>'><c:out value="${result.plabel}"/></option>
					</c:forEach>
				</select>
			</div>    
		</div>
		<h3 class="tit">도로접면</h3>
		<div class="selectWrap">
	        <div class="disFlex">
            	<select class="form-control chosen" multiple id="fs_road_side" title="도로접면">
                	<c:forEach var="result" items="${ROADSIDEList}" varStatus="status">
						<option value='<c:out value="${result.pcode}"/>'><c:out value="${result.plabel}"/></option>
					</c:forEach>
				</select>
			</div>    
		</div>
	
	</form>  
</div>
<!-- End Tab-01 -->
                    
<!-- 검색조건 Form -->
<form id="GISinfoForm" name="GISinfoForm" ></form>
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
    <button type="button" class="primarySearch" onclick="gis_sherch('land');">검색</button>
</div>
 
<!-- 검색결과 Form -->
<form id="GISinfoResultForm" name="GISinfoResultForm">
	<input type="hidden" name="geom[]">
</form>
</body>
