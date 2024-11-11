<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
$(document).ready(function(){
	
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

</script>	



    <!-- 상세검색-Popup -->
    <div class="popover" id="searching_item" style="width: 350px; left: 500px; top:129px; bottom: 20px; display: none;">
        <div class="popover-title tit">
            <span class="m-r-5">
                <b>상세검색</b>
            </span>
            <button type="button" class="close" id="searching_item_close" onclick="gis_item()">×</button>
        </div>
        
        <div class="popover-body ani-pop">
            <div class="popover-content-wrap ani-pop">
                <div class="popover-content p-0">                
                    <div class="tab-content p-20">
                    
                    
                    
                    
                    	<!-- 토지 항목 -->
	                    <div class="tab-pane active list-group-wrap in-asset" id="tab-01-itemlist">
	                    <form id="tab-01_Form_item" name="tab-01_Form_item"  onsubmit="return false;">
	                    	
	                    	<div class="row">
		                        <div class="col-xs-12">
		                            <div id="land-itemlist">
		                                <div class="list-group"> 
		                                
		                                	<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label for="fs_jimok">지목</label>
		                                            <select class="form-control chosen" multiple id="fs_jimok">
		                                            	<c:forEach var="result" items="${GISCodeList}" varStatus="status">
		                                                	<c:if test="${result.type eq 'JIMOK'}">
																<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
															</c:if>
														</c:forEach>
		                                            </select>
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
			                                       	<label for="fs_parea">토지면적</label>
			                                        <div id="fs_parea" class="p-10">
											        	<p class="range-label"><b>범위(㎡) :</b><span id="amount_parea"></span></p>
														<div id="slider_parea" class="slider-margin"></div>
														<input type="text" id="num_parea_1" size="10" class="form-control input-ib"/> ~ <input type="text" id="num_parea_2" size="10" class="form-control input-ib"/>
											        </div> 
										        </div>                                           
											</div>
		
											<div class="divider divider-sm in"></div>
											 
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label for="fs_pnilp">공시지가</label>
		                                            <div id="fs_pnilp" class="p-10">
										          		<p class="range-label"><b>범위(원) :</b><span id="amount_pnilp"></span></p>
														<div id="slider_pnilp" class="slider-margin"></div>
														<input type="text" id="num_pnilp_1" size="10" class="form-control input-ib"/> ~ <input type="text" id="num_pnilp_2" size="10" class="form-control input-ib"/>
										        	</div> 
												</div>                                           
											</div> 
											
											<div class="divider divider-sm in"></div>
											
		                                	<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label for="fs_spfc">용도지역</label>
		                                            <select class="form-control chosen" multiple id="fs_spfc">
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
			                                       	<label for="fs_land_use">토지이용상황</label>
											        <select class="form-control chosen" multiple id="fs_land_use">
		                                            	<c:forEach var="result" items="${GISCodeList}" varStatus="status">
		                                                	<c:if test="${result.type eq 'LAND_USE'}">
																<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
															</c:if>
														</c:forEach>
		                                            </select>
										        </div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											          		
											<div class="form-group row">
		                                       	<div class="col-xs-12">
			                                       	<label for="fs_geo_hl">지형고저</label>
											        <select class="form-control chosen" multiple id="fs_geo_hl">
		                                            	<c:forEach var="result" items="${GISCodeList}" varStatus="status">
		                                                	<c:if test="${result.type eq 'GEO_HL'}">
																<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
															</c:if>
														</c:forEach>
		                                            </select>
										        </div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
			                                       	<label for="fs_geo_form">지형형상</label>
											        <select class="form-control chosen" multiple id="fs_geo_form">
		                                            	<c:forEach var="result" items="${GISCodeList}" varStatus="status">
		                                                	<c:if test="${result.type eq 'GEO_FORM'}">
																<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
															</c:if>
														</c:forEach>
		                                            </select>
										        </div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											          		
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label for="fs_road_side">도로접면</label>
		                                            <select class="form-control chosen" multiple id="fs_road_side">
		                                            	<c:forEach var="result" items="${GISCodeList}" varStatus="status">
		                                                	<c:if test="${result.type eq 'ROAD_SIDE'}">
																<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option>
															</c:if>
														</c:forEach>
		                                            </select>
												</div>                                           
											</div>  
											
											<div class="divider divider-sm in"></div>
                              
		                                </div>                                
		                            </div> 
		                        </div>
		                    </div>
		                </form>
	                    </div>
	                    
	                    
	                    
	                    <!-- 건물 항목 -->
	                    <div class="tab-pane list-group-wrap in-asset" id="tab-02-itemlist">
	                    <form id="tab-02_Form_item" name="tab-02_Form_item"  onsubmit="return false;">
	                    	
                            <div class="row">
                            	<div class="col-xs-12">
                            		<div id="buld-itemlist">
                            			<div class="list-group">    
                            			                                
<!-- 		                                	<div class="form-group row"> -->
<!-- 		                                       	<div class="col-xs-12"> -->
<!-- 			                                       	<label for="fn_buld_nm">건물명</label> -->
<!-- 		                                            <input type="text" class="form-control" placeholder="건물명을 입력하세요." id="fn_buld_nm"> -->
<!-- 										        </div>                                            -->
<!-- 											</div> -->
											
<!-- 											<div class="divider divider-sm in"></div> -->
		
<!-- 											<div class="form-group row"> -->
<!-- 		                                       	<div class="col-xs-12"> -->
<!-- 		                                       		<label for="fn_prpos">용도상세</label> -->
<!-- 		                                       		<select class="form-control chosen" multiple id="fn_prpos"> -->
<%-- 		                                            	<c:forEach var="result" items="${GISCodeList}" varStatus="status"> --%>
<%-- 		                                                	<c:if test="${result.type eq 'PRPOS'}"> --%>
<%-- 		                                                	<c:if test="${result.code ne '01000' && result.code ne '01001' && result.code ne '01002' && result.code ne '01003' && result.code ne '02003' && result.code ne '02002' && result.code ne '02001'}"> --%>
<%-- 																<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option> --%>
<%-- 															</c:if> --%>
<%-- 															</c:if> --%>
<%-- 														</c:forEach> --%>
<!-- 		                                            </select>		                                             -->
<!-- 												</div>                                            -->
<!-- 											</div> -->
											
<!-- 											<div class="divider divider-sm in"></div> -->
											
											<div class="form-group row">
												<div class="col-xs-12">
			                                       	<div class="row m-b-10">
			                                       		<label for="fn_cp_date_select" class="col-xs-3 control-label">건축년도</label>
			                                       		<div class="col-xs-9">
			                                       		<select id="fn_cp_date_select" class="form-control input-sm">
			                                       			<option value="00">::직접입력::</option>
		                                       				<option value="01">건물노후(20년)</option>
		                                       				<option value="02">건물노후(30년)</option>
		                                       				<option value="03">건물노후(40년)</option>
		                                       				<option value="04">건물노후(50년)</option>
		                                       			</select>
		                                       			</div>
	                                       			</div>
		                                            <div id="fn_cp_date" class="row p-10">
		                                                <div class="col-xs-6">
		                                                    <div class="input-group date datetimepicker m-r-5 input-group-sm">
		                                                        <input type="text" class="form-control" placeholder="년/월/일" id="num_cp_date_1">
		                                                        <span class="input-group-addon bg-teal b-0"><i class="fa fa-calendar text-white"></i></span>
		                                                    </div>
		                                                </div>
		                                                <div class="middle-wave">~</div>
		                                                <div class="col-xs-6">
		                                                    <div class="input-group date datetimepicker m-l-5 input-group-sm">
		                                                        <input type="text" class="form-control" placeholder="년/월/일" id="num_cp_date_2">
		                                                        <span class="input-group-addon bg-teal b-0"><i class="fa fa-calendar text-white"></i></span>
		                                                    </div>
		                                                </div>
										        	</div> 
												</div>                                           
											</div> 
											
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label for="fn_bildng_ar">건축면적</label>
		                                            <div id="fn_bildng_ar" class="p-10">
										          		<p class="range-label"><b>범위(㎡) :</b><span id="amount_bildng_ar"></span></p>
														<div id="slider_bildng_ar" class="slider-margin"></div>
														<input type="text" id="num_bildng_ar_1" size="10" class="form-control input-ib"/> ~ <input type="text" id="num_bildng_ar_2" size="10" class="form-control input-ib"/>
										        	</div> 
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
		
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label for="fn_totar">연면적</label>
		                                            <div id="fn_totar" class="p-10">
										          		<p class="range-label"><b>범위(㎡) :</b><span id="amount_totar"></span></p>
														<div id="slider_totar" class="slider-margin"></div>
														<input type="text" id="num_totar_1" size="10" class="form-control input-ib"/> ~ <input type="text" id="num_totar_2" size="10" class="form-control input-ib"/>
										        	</div> 
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
		
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label for="fn_plot_ar">대지면적</label>
		                                            <div id="fn_plot_ar" class="p-10">
										          		<p class="range-label"><b>범위(㎡) :</b><span id="amount_plot_ar"></span></p>
														<div id="slider_plot_ar" class="slider-margin"></div>
														<input type="text" id="num_plot_ar_1" size="10" class="form-control input-ib"/> ~ <input type="text" id="num_plot_ar_2" size="10" class="form-control input-ib"/>
										        	</div> 
												</div>                                           
											</div>
		
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label for="fn_bdtldr">건폐율</label>
		                                            <div id="fn_bdtldr" class="p-10">
										          		<p class="range-label"><b>범위(%) :</b><span id="amount_bdtldr"></span></p>
														<div id="slider_bdtldr" class="slider-margin"></div>
														<input type="text" id="num_bdtldr_1" size="10" class="form-control input-ib"/> ~ <input type="text" id="num_bdtldr_2" size="10" class="form-control input-ib"/>
										        	</div> 
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label for="fn_cpcty_rt">용적률</label>
		                                            <div id="fn_cpcty_rt" class="p-10">
										          		<p class="range-label"><b>범위(%) :</b><span id="amount_cpcty_rt"></span></p>
														<div id="slider_cpcty_rt" class="slider-margin"></div>
														<input type="text" id="num_cpcty_rt_1" size="10" class="form-control input-ib"/> ~ <input type="text" id="num_cpcty_rt_2" size="10" class="form-control input-ib"/>
										        	</div> 
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											
<!-- 											<div class="form-group row"> -->
<!-- 		                                       	<div class="col-xs-12"> -->
<!-- 			                                       	<label for="fn_strct">구조</label> -->
<!-- 											        <select class="form-control chosen" multiple id="fn_strct"> -->
<%-- 		                                            	<c:forEach var="result" items="${GISCodeList}" varStatus="status"> --%>
<%-- 		                                                	<c:if test="${result.type eq 'STRCT'}"> --%>
<%-- 																<option value='<c:out value="${result.code}"/>'><c:out value="${result.name}"/></option> --%>
<%-- 															</c:if> --%>
<%-- 														</c:forEach> --%>
<!-- 		                                            </select> -->
<!-- 										        </div>                                            -->
<!-- 											</div> -->
											
<!-- 											<div class="divider divider-sm in"></div> -->
		
<!-- 											<div class="form-group row"> -->
<!-- 		                                       	<div class="col-xs-12"> -->
<!-- 		                                       		<label for="fn_ground">층수</label> -->
<!-- 		                                            <div id="fn_ground" class="p-10"> -->
<!-- 										          		<p class="range-label"><b>범위(층) :</b><span id="amount_ground"></span></p> -->
<!-- 														<div id="slider_ground" class="slider-margin"></div> -->
<!-- 														<input type="text" id="num_ground_1" size="10" class="form-control input-ib"/> ~ <input type="text" id="num_ground_2" size="10" class="form-control input-ib"/> -->
<!-- 										        	</div>  -->
<!-- 												</div>                                            -->
<!-- 											</div> -->
											
<!-- 											<div class="divider divider-sm in"></div> -->
		                                   
		                                </div>
                            		</div>
                            	</div>
                            </div>
		                </form>
	                    </div>
	                    
	                    
	                    
	                    <!-- 사업지구 항목 -->
	                    <div class="tab-pane list-group-wrap in-asset" id="tab-03-itemlist">
	                    <form id="tab-03_Form_item" name="tab-03_Form_item"  onsubmit="return false;">
	                    	
                            <div class="row">
                            	<div class="col-xs-12">
                            		<div id="dist-itemlist">
                            			<div class="list-group">      
                            			
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label for="fg_soldout">판매구분</label>
		                                       		<select class="form-control chosen" multiple id="fg_soldout">
														<option value="01">판매대상</option>
														<option value="02">자체사용</option>
														<option value="03">무상공급</option>
		                                            </select>
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label for="fg_soldgb">판매여부</label>
		                                            <select class="form-control chosen" multiple id="fg_soldgb">
														<option value="01">미판매</option>
														<option value="02">판매</option>
		                                            </select> 
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
			                                       	<label for="fg_soldkind">판매방법</label>
		                                            <input type="text" class="form-control" placeholder="검색항목을 입력하세요." id="fg_soldkind">
										        </div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>	
		
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label for="fg_sector">지구</label>
		                                            <select class="form-control chosen" multiple id="fg_sector">
														<option value="01">전체</option>
														<option value="02">1지구</option>
														<option value="03">2지구</option>
														<option value="04">3지구</option>
		                                            </select> 
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
		
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label for="fg_spkfc">용도지역</label>
		                                            <select class="form-control chosen" multiple id="fg_spkfc">
		                                                <option value="01">제1종일반주거지역</option>
														<option value="02">제3종일반주거지역</option>
														<option value="03">준주거지역</option>
														<option value="04">준공업지역</option>
														<option value="05">일반상업지역</option>
														<option value="06">제2종일반주거지역</option>
														<option value="07">자연녹지지역</option>
		                                            </select>
												</div>                                           
											</div>
		
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label for="fg_fill_gb">단지구분</label>
		                                            <select class="form-control chosen" multiple id="fg_fill_gb">
														<option value="01">비산업단지</option>
														<option value="02">산업단지</option>
		                                            </select> 
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label for="fg_useu">용도</label>
		                                            <select class="form-control chosen" multiple id="fg_useu">
														<option value="01">주거시설용지</option>
														<option value="02">산업시설용지</option>
														<option value="03">지원시설용지</option>
														<option value="04">상업용지</option>
														<option value="05">업무용지</option>
														<option value="06">기반시설용지</option>
														<option value="07">기타시설용지</option>
		                                            </select> 
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label for="fg_uses">세부용도</label>
		                                            <select class="form-control chosen" multiple id="fg_uses">
														<option value="01">단독주택용지</option>
														<option value="02">공동주택용지</option>
														<option value="03">산업시설용지</option>
														<option value="04">지원시설용지</option>
														<option value="05">상업용지</option>
														<option value="06">업무용지</option>
														<option value="07">종합의료시설용지</option>
														<option value="08">공공청사용지</option>
														<option value="09">학교용지</option>
														<option value="10">사회복지시설</option>
														<option value="11">주차장용지</option>
														<option value="12">열공급설비</option>
														<option value="13">전기공급설비</option>
														<option value="14">보육시설용지</option>
														<option value="15">방수설비용지</option>
														<option value="16">도로</option>
														<option value="17">보행자도로</option>
														<option value="18">철도용지</option>
														<option value="19">광장</option>
														<option value="20">근린공원</option>
														<option value="21">어린이공원</option>
														<option value="22">문화공원</option>
														<option value="23">경관녹지</option>
														<option value="24">연결녹지</option>
														<option value="25">유수지</option>
														<option value="26">종교용지</option>
														<option value="27">주유소용지</option>
														<option value="28">가스충전소용지</option>
														<option value="29">편익시설용지</option>
														<option value="30">택시차고지</option>
		                                            </select> 
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
			                                       	<label for="fg_sector_nm">필지번호</label>
		                                            <input type="text" class="form-control input-sm" placeholder="필지번호를 입력하세요.(대소문자 구분)" id="fg_sector_nm">
										        </div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label for="fg_solar">고시면적</label>
		                                            <div id="fg_solar" class="p-10">
										          		<p class="range-label"><b>범위(㎡) :</b><span id="amount_solar"></span></p>
														<div id="slider_solar" class="slider-margin"></div>
														<input type="text" id="num_solar_1" size="10"/> ~ <input type="text" id="num_solar_2" size="10"/>
										        	</div> 
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label for="fg_hbdtldr">건폐율</label>
		                                            <div id="fg_hbdtldr" class="p-10">
										          		<p class="range-label"><b>범위(%) :</b><span id="amount_hbdtldr"></span></p>
														<div id="slider_hbdtldr" class="slider-margin"></div>
														<input type="text" id="num_hbdtldr_1" size="10" class="form-control input-ib"/> ~ <input type="text" id="num_hbdtldr_2" size="10" class="form-control input-ib"/>
										        	</div> 
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label for="fg_hcpcty_rt">용적률</label>
		                                            <div id="fg_hcpcty_rt" class="p-10">
										          		<p class="range-label"><b>범위(%) :</b><span id="amount_hcpcty_rt"></span></p>
														<div id="slider_hcpcty_rt" class="slider-margin"></div>
														<input type="text" id="num_hcpcty_rt_1" size="10" class="form-control input-ib"/> ~ <input type="text" id="num_hcpcty_rt_2" size="10" class="form-control input-ib"/>
										        	</div> 
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>	
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
			                                       	<label for="fg_hg_limit">높이제한</label>
		                                            <input type="text" class="form-control input-sm" placeholder="검색항목을 입력하세요." id="fg_hg_limit">
										        </div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
			                                       	<label for="fg_taruse">지정용도</label>
		                                            <input type="text" class="form-control input-sm" placeholder="검색항목을 입력하세요." id="fg_taruse">
										        </div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											
											
											
																			
		                                   
		                                </div>                            			
                            		</div>
                            	</div>
                            </div>
		                </form>
	                    </div>
	                    
	                    
	                    
                                
                    </div> 
                </div>
            </div>
        </div>
        <div class="popover-footer ani-pop">
            <!-- 기능삭제
             <div class="btn-wrap text-right">
            	<button class="btn btn-custom btn-sm" onclick="gis_item_data()">자산검색</button>
            </div> 
            -->
        </div>
    </div>
    <!--// End 상세검색-Popup -->
    
    
    
    
    
    
    
    
    
    