<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
$(document).ready(function(){
	//열닫
    $('#layerInfo-mini-close').click(function() {
		$("#layerInfo-mini").hide();	//인포그래픽 닫기
    });
});

//var accessToken = null;
//var consumer_key = 'eff289594dc24220b504';
//var consumer_secret = 'ef44c972fb204d328279';

var accessToken = null;
var consumer_key = '901fa1a441694b2689a4';
var consumer_secret = '06af0c831c284955a99f';


//API 요청에 필요한 AccessToken을 획득 하기위한 함수를 만든다.
function createServiceRequest(reqFunc, reqParam) {
	return function () {
		// 인증 API
		$.ajax({
          url : 'https://sgisapi.kostat.go.kr/OpenAPI3/auth/authentication.json'+
          '?consumer_key='+consumer_key+'&consumer_secret='+consumer_secret,
          type:'get',
			success: function (res,status) {
				reqParam.accessToken = res.result.accessToken;
				reqFunc(reqParam);
			}
		});
	}
}


//상세보기
var DetailWindow =null;
function infodetailshow(){
	//창 닫기
	if(DetailWindow != null){ DetailWindow.close(); }

	var sh_kind = null;
	var sh_kind1 = $("#map-search-tab_Landlist input[type=checkbox][id^=data_]:checked").prop("id")+"";
	var sh_kind2 = $("#map-search-tab_Buldlist input[type=checkbox][id^=data_]:checked").prop("id")+"";

	if(sh_kind1 != "undefined" && sh_kind2 != "undefined"){
		alert("자산현황 : [필지단위], [건물단위] \n - 레이어가 동시에 선택된 경우 \n   [필지단위]정보를 우선으로 조회 됩니다.");
		sh_kind1.replace("data_", "");
		sh_kind = sh_kind1; }
	else if(sh_kind1 != "undefined"){ sh_kind = sh_kind1; sh_kind = sh_kind.replace("data_", ""); }
	else if(sh_kind2 != "undefined"){ sh_kind = sh_kind2; sh_kind = sh_kind.replace("data_", ""); }


	var pnu = $("#info_mini_pnu").val();
	DetailWindow = window.open("/Content_SH_View_Detail.do?pnu="+pnu+"&sh_kind="+sh_kind
			,"searchDetail"
			,"toolbar=no, width=1100, height=720,directories=no,status=no,scrollorbars=yes,resizable=yes");
}
</script>



    	<!-- 레이어정보&통계정보 Side-Panel -->
        <div class="side-pane info-mini layer-pop" id="layerInfo-mini" style="display:none;">

            <!-- Page-Title -->
            <div class="row page-title-box-wrap tit info-mini">
                <div class="page-title-box info-mini col-xs-12">
                    <p class="page-title m-b-0" id="info_mini_address">
                    	<i class="fa fa-map-o m-r-5"></i>
                  		<b>주소</b>
                    </p>
                </div>
                <input type="hidden" id="info_mini_pnu" />
                <div class="close-btn tab">
                    <button type="button" class="close tab" id="layerInfo-mini-close">×</button>
                </div>
            </div>
            <!-- End Page-Title -->

			<div class="sp-content-wrap">
				<div class="sp-content">
	            <!--정보 Panel-Content -->
		            <div class="sp-content-inner p-20" id="layer-tab">

	                   	<div class="sp-box m-b-20 position_re" id='info_mini_land'>
	                   		<h4 class="header-title m-t-0 " style="color: #F16521;">토지정보</h4>
	                   		<!-- <button type="button" class="btn btn-sm btn-gray inpop_btn">속성편집</button> -->
	                   		<table class="table table-custom table-cen table-num text-center" width="100%">
	                            <colgroup>
	                                <col width="20%"/> <col width="30%"/> <col width="20%"/> <col width="30%"/>
	                            </colgroup>
	                            <tbody>
	                            	<tr>
	                            		<th scope="row">공시지가</th><td id="info_mini_pnilp"></td>
	                            		<th scope="row">대지면적</th><td id="info_mini_parea"></td>
	                             	</tr>
	                             	<tr>
	                            		<th scope="row">용도지역</th><td id="info_mini_spfc1"></td>
	                            		<th scope="row">공부지목</th><td id="info_mini_jimok"></td>
	                             	</tr>
	                             	<tr>
	                            		<th scope="row">도로접면</th><td id="info_mini_road_side"></td>
	                            		<th scope="row">지형형상</th><td id="info_mini_geo_form"></td>
	                             	</tr>
	                             	<tr>
	                            		<th scope="row">지형고저</th><td id="info_mini_geo_hl"></td>
	                            		<th scope="row">소유구분</th><td id="info_mini_prtown"></td>
	                             	</tr>
	                            </tbody>
	                        </table>
	                    </div>

	                    <div class="sp-box m-b-20 position_re" id='info_mini_build'>
	                    	<h4 class="header-title m-t-0" style="color: #3C55A5;">건물정보</h4>
	                    	<!-- <button type="button" class="btn btn-sm btn-gray inpop_btn">속성편집</button> -->
	                   		<table class="table table-custom table-cen table-num text-center" width="100%">
	                            <colgroup>
	                                <col width="20%"/> <col width="30%"/> <col width="20%"/> <col width="30%"/>
	                            </colgroup>
	                            <tbody>
	                            	<tr>
	                            		<th scope="row">사용승인일자</th><td id="info_mini_a13"></td>
	                            		<th scope="row">건축물용도명</th><td id="info_mini_a9"></td>
	                             	</tr>
	                             	<tr>
	                            		<th scope="row">건축물구조명</th><td id="info_mini_a11"></td>
	                            		<th scope="row">건축물면적</th><td id="info_mini_a12"></td>
	                             	</tr>
	                             	<tr>
	                            		<th scope="row">연면적</th><td id="info_mini_a14"></td>
	                            		<th scope="row">높이</th><td id="info_mini_a16"></td>
	                             	</tr>
	                             	<tr>
	                            		<th scope="row">건폐율</th><td id="info_mini_a17"></td>
	                            		<th scope="row">용적율</th><td id="info_mini_a18"></td>
	                             	</tr>
	                            </tbody>
	                        </table>
	             		</div>

						<div id='info_mini_empty'></div>

	                </div>
                </div>

           		<div class="btn-wrap tab text-right">
           			<button type="button" class="btn btn-sm btn-teal" onclick="javascript:infodetailshow();">상세보기</button>
           		</div>
                <!-- End 정보 Panel-Content -->

			</div>

        </div>
        <div id='testdiv' style='height: 1in; left: -100%; position: absolute; top: -100%; width: 1in;'></div>
        <!-- End 레이어정보&통계정보 Side-Panel -->




