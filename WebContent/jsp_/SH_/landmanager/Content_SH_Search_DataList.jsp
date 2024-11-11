<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
$(document).ready(function(){
	//자산검색 전체선택
	$("#searching_data input[type=checkbox]").change(function(){
		var ck = $(this).prop("id");
		var cklist = ck.split("_");
		var mainck = cklist[cklist.length-1];
		var otherck = "";
		for(i=0; i<cklist.length-1; i++){
			otherck += cklist[i] + "_";
		}
		var tot_count = $("input[id^="+otherck+"][id!="+otherck+"00]").length;
		var ck_count = $("input[id^="+otherck+"][id!="+otherck+"00]:checked").length;
		if( mainck == "00" ){
			if( $("#"+otherck+mainck).prop("checked") ){
				$("input[id^="+otherck+"]").prop("checked", true);
			}else{
				$("input[id^="+otherck+"]").prop("checked", false);
			}
		}else{			
			if( tot_count == ck_count ){
				$("#"+otherck+"00").prop("checked", true);
			}else{
				$("#"+otherck+"00").prop("checked", false);
			}
		}
    });
	
	
});


</script>	



    
    <!-- 자산검색-Popup -->
    <div class="popover" id="searching_data" style="width: 350px; left: 850px; top: 129px; bottom: 20px; display: none;">
        <div class="popover-title tit">
            <span class="m-r-5">
                <b>자산검색</b>
            </span>
            <button type="button" class="close" id="searching_data_close" onclick="gis_item_data()">×</button>
        </div>
        
        <div class="popover-body ani-pop">
            <div class="popover-content-wrap ani-pop">
                <div class="popover-content p-0">                
                    <div class="tab-content p-20">
                    
                    
                    
                    
                    	<!-- 토지 항목 -->
	                    <div class="tab-pane active list-group-wrap in-asset" id="tab-01-datalist">
	                    <form id="tab-01_Form_data" name="tab-01_Form_data"  onsubmit="return false;">
	                    
	                    	<div class="row">
		                        <div class="col-xs-12">
		                            <div id="land-datalist">
		                                <div class="list-group">  
		                                
		                                	<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label><i class="fa fa-caret-square-o-right m-r-5"></i>국유지 일반재산(캠코)</label>
		                                       		<div class="row ch-box">
			                                       		<div class="col-xs-12">
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fs_guk_land_00"/>&nbsp;<label for="fs_guk_land_00" >일반재산(토지)</label>
			                                       				<label style="cursor:pointer;" data-toggle="collapse" data-target="#fs_guk_land_list"><span class="caret m-l-5"></span></label>
			                                       			</div>
			                                       			<div class="row collapse in" id="fs_guk_land_list">
				                                       			<div class="col-xs-6"><input type="checkbox" id="fs_guk_land_01"/>&nbsp;<label for="fs_guk_land_01">대부대상</label></div>
				                                       			<div class="col-xs-6"><input type="checkbox" id="fs_guk_land_02"/>&nbsp;<label for="fs_guk_land_02">매각대상</label></div>
				                                       			<div class="col-xs-6"><input type="checkbox" id="fs_guk_land_03"/>&nbsp;<label for="fs_guk_land_03">매각제한재산</label></div>
				                                       			<div class="col-xs-6"><input type="checkbox" id="fs_guk_land_04"/>&nbsp;<label for="fs_guk_land_04">사용중인재산</label></div>
			                                       			</div>
			                                       		</div>
		                                       		</div>	
												</div>                                           
											</div>  
											
											<div class="divider divider-sm in"></div>
											                                  
		                                	<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label><i class="fa fa-caret-square-o-right m-r-5"></i>시유지(자산관리과)</label>
		                                       		<div class="row ch-box">
			                                       		<div class="col-xs-12">
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fs_tmseq_land_00"/>&nbsp;<label for="fs_tmseq_land_00">SH위탁관리</label>
			                                       				<label style="cursor:pointer;" data-toggle="collapse" data-target="#fs_tmseq_land_list"><span class="caret m-l-5"></span></label>
			                                       			</div>			                                       			
				                                       		<div class="row collapse in" id="fs_tmseq_land_list">
				                                       			<div class="col-xs-6"><input type="checkbox" id="fs_tmseq_land_01"/>&nbsp;<label for="fs_tmseq_land_01">관리대상</label></div>
				                                       			<div class="col-xs-6"><input type="checkbox" id="fs_tmseq_land_02"/>&nbsp;<label for="fs_tmseq_land_02">관리제외</label></div>
				                                       		</div> 
				                                       		
				                                       		<div class="row">
			                                       				<input type="checkbox" id="fs_region_land_00"/>&nbsp;<label for="fs_region_land_00">자치구위임관리</label>
			                                       			</div>  
			                                       		</div>                                    			
		                                       		</div>
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
		
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label><i class="fa fa-caret-square-o-right m-r-5"></i>자치구 보유·관리 토지</label>
		                                       		<div class="row ch-box">
			                                       		<div class="col-xs-12">
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fs_owned_city_00"/>&nbsp;<label for="fs_owned_city_00">시유지</label>
			                                       				<label style="cursor:pointer;" data-toggle="collapse" data-target="#fs_owned_city_list"><span class="caret m-l-5"></span></label>
			                                       			</div>			                                       			
			                                       			<div class="row collapse in" id="fs_owned_city_list">
				                                       			<div class="col-xs-6"><input type="checkbox" id="fs_owned_city_01"/>&nbsp;<label for="fs_owned_city_01">일반재산</label></div>
				                                       			<div class="col-xs-6"><input type="checkbox" id="fs_owned_city_02"/>&nbsp;<label for="fs_owned_city_02">행정재산</label></div>
				                                       		</div> 
				                                       		
				                                       		<div class="row">
			                                       				<input type="checkbox" id="fs_owned_guyu_00"/>&nbsp;<label for="fs_owned_guyu_00">구유지</label>
			                                       				<label style="cursor:pointer;" data-toggle="collapse" data-target="#fs_owned_guyu_list"><span class="caret m-l-5"></span></label>
			                                       			</div>			                                       			
			                                       			<div class="row collapse in" id="fs_owned_guyu_list">
				                                       			<div class="col-xs-6"><input type="checkbox" id="fs_owned_guyu_01"/>&nbsp;<label for="fs_owned_guyu_01">일반재산</label></div>
				                                       			<div class="col-xs-6"><input type="checkbox" id="fs_owned_guyu_02"/>&nbsp;<label for="fs_owned_guyu_02">행정재산</label></div>
				                                       		</div>
			                                       		</div>
		                                       		</div>
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label><i class="fa fa-caret-square-o-right m-r-5"></i>SH보유토지</label>
		                                       		<div class="row ch-box">
			                                       		<div class="col-xs-12">
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fs_residual_land_00"/>&nbsp;<label for="fs_residual_land_00">SH잔여지</label>
			                                       			</div>	
				                                       		
				                                       		<div class="row">
			                                       				<input type="checkbox" id="fs_unsold_land_00"/>&nbsp;<label for="fs_unsold_land_00">SH미매각지</label>
			                                       			</div>
			                                       			
			                                       		</div>
		                                       		</div>
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											                                  
		                                	<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label><i class="fa fa-caret-square-o-right m-r-5"></i>공공기관이전부지</label>
		                                       		<div class="row ch-box">
			                                       		<div class="col-xs-12">
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fs_public_site_00"/>&nbsp;<label for="fs_public_site_00">공공기관이전부지</label>
			                                       			</div>			                                       			
			                                       		</div>
		                                       		</div>
												</div>                                           
											</div>
		
											<div class="divider divider-sm in"></div>
		
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label><i class="fa fa-caret-square-o-right m-r-5"></i>공영주차장</label>
		                                       		<div class="row ch-box">
			                                       		<div class="col-xs-12">
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fs_public_parking_00"/>&nbsp;<label for="fs_public_parking_00">공영주차장</label>
			                                       			</div>			                                       			
			                                       		</div>
		                                       		</div>
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
		
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label><i class="fa fa-caret-square-o-right m-r-5"></i>역세권사업 후보지</label>
		                                       		<div class="row ch-box">
			                                       		<div class="col-xs-12">
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fs_generations_00"/>&nbsp;<label for="fs_generations_00">역세권사업 후보지</label>
			                                       				<label style="cursor:pointer;" data-toggle="collapse" data-target="#fs_generations_list"><span class="caret m-l-5"></span></label>
			                                       			</div>			                                       			
				                                       		<div class="form-group row collapse in" id="fs_generations_list">
				                                       			<div class="col-xs-4"><input type="checkbox" id="fs_generations_01"/>&nbsp;<label for="fs_generations_01">완료</label></div>
				                                       			<div class="col-xs-4"><input type="checkbox" id="fs_generations_02"/>&nbsp;<label for="fs_generations_02">진행</label></div>
				                                       			<div class="col-xs-4"><input type="checkbox" id="fs_generations_03"/>&nbsp;<label for="fs_generations_03">준비</label></div>
				                                       		</div> 
			                                       		</div>                                    			
		                                       		</div>
												</div>                                           
											</div>  
											
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label><i class="fa fa-caret-square-o-right m-r-5"></i>임대주택단지</label>
		                                       		<div class="row ch-box">
			                                       		<div class="col-xs-12">
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fs_council_land_00"/>&nbsp;<label for="fs_council_land_00">임대주택단지</label>
			                                       			</div>			                                       			
			                                       		</div>
		                                       		</div>
												</div>                                           
											</div> 
											
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label><i class="fa fa-caret-square-o-right m-r-5"></i>저이용공공시설</label>
		                                       		<div class="row ch-box">
			                                       		<div class="col-xs-12">
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fs_minuse_00"/>&nbsp;<label for="fs_minuse_00">저이용공공시설</label>
			                                       			</div>			                                       			
			                                       		</div>
		                                       		</div>
												</div>                                           
											</div> 
											
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label><i class="fa fa-caret-square-o-right m-r-5"></i>공공부지 혼재지역</label>
		                                       		<div class="row ch-box">
			                                       		<div class="col-xs-12">
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fs_industry_00"/>&nbsp;<label for="fs_industry_00">공공부지 혼재지역</label>
			                                       			</div>			                                       			
			                                       		</div>
		                                       		</div>
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label><i class="fa fa-caret-square-o-right m-r-5"></i>중점활용 시유지</label>
		                                       		<div class="row ch-box">
			                                       		<div class="col-xs-12">
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fs_priority_00"/>&nbsp;<label for="fs_priority_00">중점활용 시유지</label>
			                                       			</div>			                                       			
			                                       		</div>
		                                       		</div>
												</div>                                           
											</div>
											                               
		                                </div>                                
		                            </div> 
		                        </div>
		                    </div>
		                    
		                </form>
	                    </div>
	                    
	                    
	                    
	                    
	                    <!-- 건물 항목 -->
	                    <div class="tab-pane list-group-wrap in-asset" id="tab-02-datalist">
	                    <form id="tab-02_Form_data" name="tab-02_Form_data"  onsubmit="return false;">
                            
	                    	<div class="row">
		                        <div class="col-xs-12">
		                            <div id="buld-datalist">
		                                <div class="list-group">  
		                                
		                                	<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label><i class="fa fa-caret-square-o-right m-r-5"></i>국유지 일반재산(캠코)</label>
		                                       		<div class="row ch-box">
			                                       		<div class="col-xs-12">
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fn_guk_buld_00"/>&nbsp;<label for="fn_guk_buld_00" >일반재산(건물)</label>
			                                       				<label style="cursor:pointer;" data-toggle="collapse" data-target="#fn_guk_buld_list"><span class="caret m-l-5"></span></label>
			                                       			</div>
			                                       			<div class="row collapse in" id="fn_guk_buld_list">
				                                       			<div class="col-xs-6"><input type="checkbox" id="fn_guk_buld_01"/>&nbsp;<label for="fn_guk_buld_01">대부대상</label></div>
				                                       			<div class="col-xs-6"><input type="checkbox" id="fn_guk_buld_02"/>&nbsp;<label for="fn_guk_buld_02">매각대상</label></div>
				                                       			<div class="col-xs-6"><input type="checkbox" id="fn_guk_buld_03"/>&nbsp;<label for="fn_guk_buld_03">매각제한재산</label></div>
				                                       			<div class="col-xs-6"><input type="checkbox" id="fn_guk_buld_04"/>&nbsp;<label for="fn_guk_buld_04">사용중인재산</label></div>
			                                       			</div>
			                                       		</div>
		                                       		</div>
												</div>                                           
											</div>  
											
											<div class="divider divider-sm in"></div>
											                                  
		                                	<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label><i class="fa fa-caret-square-o-right m-r-5"></i>시유건물(**작업중)</label>
		                                       		<div class="row ch-box">
			                                       		<div class="col-xs-12">
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fn_tmseq_buld_00"/>&nbsp;<label for="fn_tmseq_buld_00">SH위탁관리</label>
			                                       				<label style="cursor:pointer;" data-toggle="collapse" data-target="#fn_tmseq_buld_list"><span class="caret m-l-5"></span></label>
			                                       			</div>			                                       			
				                                       		<div class="row collapse in" id="fn_tmseq_buld_list">
				                                       			<div class="col-xs-6"><input type="checkbox" id="fn_tmseq_buld_01"/>&nbsp;<label for="fn_tmseq_buld_01">관리대상</label></div>
				                                       			<div class="col-xs-6"><input type="checkbox" id="fn_tmseq_buld_02"/>&nbsp;<label for="fn_tmseq_buld_02">관리제외</label></div>
				                                       		</div> 
				                                       		
				                                       		<div class="row">
			                                       				<input type="checkbox" id="fn_region_buld_00"/>&nbsp;<label for="fn_region_buld_00">자치구위임관리</label>
			                                       			</div>  
			                                       		</div>                                    			
		                                       		</div>
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
		
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label><i class="fa fa-caret-square-o-right m-r-5"></i>자치구 보유·관리 건물</label>
		                                       		<div class="row ch-box">
			                                       		<div class="col-xs-12">
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fn_owned_region_00"/>&nbsp;<label for="fn_owned_region_00">자치구 보유관리건물(자치구)</label>
			                                       				<label style="cursor:pointer;" data-toggle="collapse" data-target="#fn_owned_region_list"><span class="caret m-l-5"></span></label>
			                                       			</div>			                                       			
			                                       			<div class="row collapse in" id="fn_owned_region_list">
				                                       			<div class="col-xs-6"><input type="checkbox" id="fn_owned_region_01"/>&nbsp;<label for="fn_owned_region_01">일반재산</label></div>
				                                       			<div class="col-xs-6"><input type="checkbox" id="fn_owned_region_02"/>&nbsp;<label for="fn_owned_region_02">행정재산</label></div>
				                                       		</div> 
			                                       		</div>
		                                       		</div>
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label><i class="fa fa-caret-square-o-right m-r-5"></i>재난위험시설</label>
		                                       		<div class="row ch-box">
			                                       		<div class="col-xs-12">
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fn_cynlst_00"/>&nbsp;<label for="fn_cynlst_00">안전등급</label>
			                                       				<label style="cursor:pointer;" data-toggle="collapse" data-target="#fn_cynlst_list"><span class="caret m-l-5"></span></label>
			                                       			</div>			                                       			
			                                       			<div class="row collapse in" id="fn_cynlst_list">
				                                       			<div class="col-xs-6"><input type="checkbox" id="fn_cynlst_01"/>&nbsp;<label for="fn_cynlst_01">D등급</label></div>
				                                       			<div class="col-xs-6"><input type="checkbox" id="fn_cynlst_02"/>&nbsp;<label for="fn_cynlst_02">E등급</label></div>
				                                       		</div> 	
			                                       		</div>
		                                       		</div>
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											                 
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label><i class="fa fa-caret-square-o-right m-r-5"></i>공공건축물</label>
		                                       		<div class="row ch-box">
			                                       		<div class="col-xs-12">
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fn_public_buld_a_00"/>&nbsp;<label for="fn_public_buld_a_00">국공립</label>
			                                       			</div>	
			                                       			
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fn_public_buld_b_00"/>&nbsp;<label for="fn_public_buld_b_00">서울시</label>
			                                       			</div>	
			                                       			
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fn_public_buld_c_00"/>&nbsp;<label for="fn_public_buld_c_00">자치구</label>
			                                       			</div> 	
			                                       		</div>
		                                       		</div>
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											                                  
		                                	<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label><i class="fa fa-caret-square-o-right m-r-5"></i>공공기관이전건물</label>
		                                       		<div class="row ch-box">
			                                       		<div class="col-xs-12">
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fn_public_asbu_00"/>&nbsp;<label for="fn_public_asbu_00">공공기관이전건물</label>
			                                       			</div>			                                       		
			                                       		</div>
		                                       		</div>
												</div>                                           
											</div>
		
											<div class="divider divider-sm in"></div>
		
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label><i class="fa fa-caret-square-o-right m-r-5"></i>매입임대</label>
		                                       		<div class="row ch-box">
			                                       		<div class="col-xs-12">
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fn_purchase_00"/>&nbsp;<label for="fn_purchase_00">SH매입임대</label>
			                                       			</div>
			                                       			
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fn_declining_00"/>&nbsp;<label for="fn_declining_00">SH노후매입임대</label>
			                                       			</div>			                                       		
			                                       		</div>
		                                       		</div>
												</div>                                           
											</div>  
											                               
		                                </div>                                
		                            </div> 
		                        </div>
		                    </div>
		                    
		                </form>
	                    </div>
	                    
	                    
	                    
	                    
	                    
	                    <!-- 사업지구 항목 -->
	                    <div class="tab-pane list-group-wrap in-asset" id="tab-03-datalist">
	                    <form id="tab-03_Form_data" name="tab-03_Form_data"  onsubmit="return false;">
                            
	                    	<div class="row">
		                        <div class="col-xs-12">
		                            <div id="dist-datalist">
		                                <div class="list-group">  
		                                
		                                	<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label><i class="fa fa-caret-square-o-right m-r-5"></i>잔여지</label>
		                                       		<div class="row ch-box">
			                                       		<div class="col-xs-12">
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fg_residual_00"/>&nbsp;<label for="fg_residual_00">잔여지</label>
			                                       			</div>			                                       			
			                                       		</div>
		                                       		</div>
												</div>                                           
											</div>
											
											<div class="divider divider-sm in"></div>
											
											<div class="form-group row">
		                                       	<div class="col-xs-12">
		                                       		<label><i class="fa fa-caret-square-o-right m-r-5"></i>미매각지</label>
		                                       		<div class="row ch-box">
			                                       		<div class="col-xs-12">
			                                       			<div class="row">
			                                       				<input type="checkbox" id="fg_unsold_00"/>&nbsp;<label for="fg_unsold_00">미매각지</label>
			                                       			</div>			                                       			
			                                       		</div>
		                                       		</div>
												</div>                                           
											</div>
											                               
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
            <div class="btn-wrap text-right">
            	<button class="btn btn-custom btn-sm" onclick="gis_item_space()">관련사업</button>
            </div>
        </div>
    </div>
    <!--// End 자산검색-Popup -->
    
    
    
    
    
    
    
    
    