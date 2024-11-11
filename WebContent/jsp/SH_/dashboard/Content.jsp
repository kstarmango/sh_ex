<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
$(document).ready(function(){
	$("input[name=ck]").click(function(){
		var va = $("input[name=ck]:checked").val();
		var chartvector_source = chartvector.getSource();
		if(va == "02"){
			chartvector_source.clear();	
			geoMap.removeLayer(chartvector);
			chartvector = new ol.layer.Vector(
					{	name: 'Vecteur',
						source: new ol.source.Vector({ features: features2 }),
						// y ordering
						renderOrder: ol.ordering.yOrdering(),
						style: function(f) { return getFeatureStyle(f); }
					});
			geoMap.addLayer(chartvector);
		}else if(va == "03"){
			chartvector_source.clear();	
			geoMap.removeLayer(chartvector);
			chartvector = new ol.layer.Vector(
					{	name: 'Vecteur',
						source: new ol.source.Vector({ features: features3 }),
						// y ordering
						renderOrder: ol.ordering.yOrdering(),
						style: function(f) { return getFeatureStyle(f); }
					});
			geoMap.addLayer(chartvector);
		}
		
// 		geoMap.render();
// 		geoMap.renderSync();	
	});
	
});
</script>	


<div class="wrapper map">

    <!-- dashboard-container -->
    <div class="container-fluid dashboard">

        <div class="dashboard-wrap" style="background: url(/jsp/SH/img/background.png) no-repeat center top/100% 100%">
            <!-- Dashboard-Content -->
            <div class="dashboard-box-wrap">
                <div class="dashboard-box-title">
                    <h4>통계 현황 정보</h4>
                </div>
                <div class="dashboard-box">
                
                    <div class="dsb-con left" id="geomap"></div>
                    
                    <div class="dsb-con right">
                        <div class="row">
                            <div class="col-xs-12">
                                <div class="card-box">
                                
                                    <div class="form-group row" >
                                        <div class="col-xs-12">
                                            <div class="demo-box">
                                            	<h4 class="header-title m-t-0" >
                                                	<input type="radio" id="ck02" name="ck" value="02" checked="checked"/>
                                                	<label for="ck02" style="font-size: 16px;">국유지 일반재산(캠코) 현황</label>
                                                </h4> 
                                                <div class="text-center">
                                                    <ul class="list-inline chart-detail-list">
                                                        <li class="list-inline-item">
                                                            <h5 style="color: #7E3F98 !important;"><i class="mdi mdi-crop-square m-r-5"></i>대부대상</h5>
                                                        </li>
                                                        <li class="list-inline-item">
                                                            <h5 style="color: #213F99 !important;"><i class="mdi mdi-crop-square m-r-5"></i>매각대상</h5>
                                                        </li>
                                                        <li class="list-inline-item">
                                                            <h5 style="color: #00A14B !important;"><i class="mdi mdi-crop-square m-r-5"></i>매각제한재산</h5>
                                                        </li>
                                                        <li class="list-inline-item">
                                                            <h5 style="color: #F16521 !important;"><i class="mdi mdi-crop-square m-r-5"></i>사용중인재산</h5>
                                                        </li>
                                                    </ul>
                                                </div>
                                                <div id="morris-bar-stacked2" style="height: 160px;"></div>

                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="form-group row">
                                        <div class="col-xs-12">
                                            <div class="demo-box">
                                                <h4 class="header-title m-t-0" >
                                                	<input type="radio" id="ck03" name="ck" value="03"/>
                                                	<label for="ck03" style="font-size: 16px;">도시재생관련 사업대상지 현황</label>
                                                </h4>                                                
                                                <div class="text-center">
                                                    <ul class="list-inline chart-detail-list">
                                                        <li class="list-inline-item">
                                                            <h5 style="color: #7E3F98 !important;"><i class="mdi mdi-crop-square m-r-5"></i>도시재생활성화</h5>
                                                        </li>
                                                        <li class="list-inline-item">
                                                            <h5 style="color: #213F99 !important;"><i class="mdi mdi-crop-square m-r-5"></i>주거환경관리</h5>
                                                        </li>
                                                        <li class="list-inline-item">
                                                            <h5 style="color: #00A14B !important;"><i class="mdi mdi-crop-square m-r-5"></i>희망지</h5>
                                                        </li>
                                                        <li class="list-inline-item">
                                                            <h5 style="color: #F16521 !important;"><i class="mdi mdi-crop-square m-r-5"></i>해제지역</h5>
                                                        </li>
                                                    </ul>
                                                </div>
                                                <div id="morris-bar-stacked3" style="height: 160px;"></div>

                                            </div>
                                        </div>
                                    </div>

                                    

                                    <div class="row hidden">
                                        <div class="col-xs-12 m-t-15">

                                            <div class="demo-box">
                                                <h4 class="header-title m-t-0">자산데이터 현황</h4>
                                                <div id="morris-donut-example" style="height: 160px;"></div>

                                                <div class="text-center">
                                                    <ul class="list-inline chart-detail-list">
                                                        <li class="list-inline-item">
                                                            <h5 class="text-danger"><i class="mdi mdi-checkbox-blank-circle-outline m-r-5"></i>사업지구</h5>
                                                        </li>
                                                        <li class="list-inline-item">
                                                            <h5 class="text-orange"><i class="mdi mdi-details m-r-5"></i>건물</h5>
                                                        </li>
                                                        <li class="list-inline-item">
                                                            <h5 class="text-info"><i class="mdi mdi-crop-square m-r-5"></i>토지</h5>
                                                        </li>
                                                    </ul>
                                                </div>

                                            </div>
                                        </div>

                                    </div>
                                    
                                    <!-- end row -->
                                </div>
                            </div><!-- end col-->
                        </div>
                    </div>
                </div>
            </div>

            <!-- End Dashboard-Content -->
        </div>


    </div>
    <!--// End dashboard-container -->
        
</div>






	
	
	
	
	
	
	