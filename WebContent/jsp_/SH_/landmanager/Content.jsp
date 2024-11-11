<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
$(document).ready(function(){
	//$(".maptab").click();
// 	$( "#asset-search-list" ).resizable({
// 	      maxHeight: 500,
// 	      maxWidth: 1800,
// 	      minHeight: 303,
// 	      minWidth: 1593
// 	  });

	//탭 선택시 기능
	$("#main-tabs li").on("click", function(){
    	var type = $(this).find("a").attr("href").replace("#", "");
    	if( type == "asset-search-tab"){


    	}else{
    		if( $("#searching_item").css("display") == 'block' ){
    			gis_item();
    		}
    	}
    });

});
</script>


<div class="wrapper">


	<!-- 상단 대메뉴 토글 버튼 -->
    <div class="menu-toggle-btn">
        <button class="btn btn-darkgreen btn-sm" id="menu-toggle-btn"><i class="fa fa-bars text-teal"></i></button>
    </div>
    <!--// End 상단 대메뉴 토글 버튼 -->

    <!-- wrapper-content -->
    <div class="wrapper-content asset">



	    <!-- 주소검색-Bar -->
	    <c:import url="/jsp/SH_/landmanager/Content_ADDR_Search.jsp"></c:import>
	    <!-- End 주소검색-Bar -->


    	<!-- 주소검색+자산검색 Main-Side-Panel -->
        <div class="side-pane main-panel" role="tabpanel" id="main-panel">

            <!-- Page-Title -->
            <div class="row page-title-box-wrap tit">
            	<div class="tab" id="main-tabs">
                <ul role="tablist">
                    <li class="page-title-box map tab col-xs-3" role="presentation">
                        <h4 class="page-title"><a href="#unified-search-tab" role="tab" data-toggle="tab" >주소검색</a></h4>
                    </li>
                    <li class="page-title-box map tab col-xs-3" role="presentation">
                        <!-- <h4 class="page-title"><a href="#asset-search-tab" role="tab" data-toggle="tab" id="stat-tab-btn">자산검색</a></h4> -->
                        <!-- 2020 추가 -->
                        <h4 class="page-title"><a href="#asset-search-tab" role="tab" data-toggle="tab" id="stat-tab-btn">속성검색</a></h4>
                    </li>
                    <li class="page-title-box map tab col-xs-3 active" role="presentation">
                        <!-- <h4 class="page-title"><a href="#map-search-tab" role="tab" data-toggle="tab" id="stat-tab-btn">자산현황</a></h4> -->
                        <!-- 2020 추가 -->
                        <h4 class="page-title"><a href="#map-search-tab" role="tab" data-toggle="tab" id="stat-tab-btn" class = "maptab">분포현황</a></h4>
                    </li>
                    <li class="page-title-box map tab col-xs-3" role="presentation">
                        <h4 class="page-title"><a href="#data-search-tab" role="tab" data-toggle="tab" id="stat-tab-btn">데이터추출</a></h4>
                    </li>
                    <!-- 2020 추가 -->
                    <!-- 관리자 기능으로 -->
                    <!-- <li class="page-title-box map tab col-xs-3" role="presentation">
                        <h4 class="page-title"><a href="#asset-management-tab" role="tab" data-toggle="tab" id="stat-tab-btn">자산관리</a></h4>
                    </li> -->
                </ul>
                </div>
                <div class="close-btn tab">
                    <button type="button" class="close tab" id="main-panel-close">×</button>
                </div>
            </div>
            <!-- End Page-Title -->

            <div class="tab-content map">
            	<!-- 주소검색 Side-Panel -->
			    <c:import url="/jsp/SH_/landmanager/Content_ADDR_SearchList.jsp"></c:import>
			    <!-- End 주소검색 Side-Panel -->

            	<!-- 자산검색 Side-Panel -->
			    <c:import url="/jsp/SH_/landmanager/Content_SH_Search.jsp"></c:import>
			    <!-- End 자산검색 Side-Panel -->

			    <!-- 주제도검색 Side-Panel -->
			    <c:import url="/jsp/SH_/landmanager/Content_SH_ViewMap.jsp"></c:import>
			    <!-- End 주제도검색 Side-Panel -->

			    <!-- 데이터추출 Side-Panel -->
			    <c:import url="/jsp/SH_/landmanager/Content_SH_DataExport.jsp"></c:import>
			    <!-- End 데이터추출 Side-Panel -->
            </div>

		</div>
        <!-- END 주소검색+자산검색 Main-Side-Panel -->

	<div id="dmsrud">
	    <!-- 자산검색-즐겨찾기-Popup -->
	    <c:import url="/jsp/SH_/landmanager/Content_SH_Search_BoonMark.jsp"></c:import>
	    <!-- End 자산검색-즐겨찾기-Popup -->

	    <!-- 자산검색-상세검색-Popup -->
	    <c:import url="/jsp/SH_/landmanager/Content_SH_Search_ItemList.jsp"></c:import>
	    <!-- End 자산검색-상세검색-Popup -->

	    <!-- 자산검색-자산검색-Popup -->
	    <c:import url="/jsp/SH_/landmanager/Content_SH_Search_DataList.jsp"></c:import>
	    <!-- End 자산검색-자산검색-Popup -->

	    <!-- 자산검색-공간검색-Popup -->
	    <c:import url="/jsp/SH_/landmanager/Content_SH_Search_SpaceList.jsp"></c:import>
	    <!-- End 자산검색-공간검색-Popup -->

	    <!-- click정보조회 -->
	    <c:import url="/jsp/SH_/landmanager/Content_SH_View_mini.jsp"></c:import>
	    <!-- End click정보조회p -->

		<!-- 2020 추가 -->
		<!-- SYESD 신규 -->

		<!--택지지구  -->
		<%-- <c:import url="/jsp/SH/portal/gis/contents_building_land.jsp"></c:import> --%>
		<!--End 택지지구  -->

		<!--임대주택  -->
		<%-- <c:import url="/jsp/SH/portal/gis/contents_rental.jsp"></c:import> --%>
		<!--End 임대주택  -->

		<!--임대주택 현황 -->
	    <c:import url="/jsp/SH/portal/gis/contents_rental_stats.jsp"></c:import>

		<!--임대주택 APT 종합정보 현황 -->
	    <c:import url="/jsp/SH/portal/gis/contents_rental_apt_info.jsp"></c:import>
	    <!-- End 임대주택 APT 정보 -->

		<!--임대주택 APT-K 종합정보 현황 -->
	    <c:import url="/jsp/SH/portal/gis/contents_rental_apt_k_info.jsp"></c:import>
	    <!-- End 임대주택 APT-K 정보  -->

		<!--기타자산  -->
		<%-- <c:import url="/jsp/SH/portal/gis/contents_asset.jsp"></c:import> --%>
		<!--End 기타자산  -->

		<!-- 검색결과  -->
	    <c:import url="/jsp/SH/portal/gis/contents_search_result.jsp"></c:import>
	    <!-- End 검색결과  -->

		<!-- 지오코딩  -->
	    <c:import url="/jsp/SH/portal/gis/contents_geocoding.jsp"></c:import>
	    <!-- End 지오코딩  -->

	    <!-- Shape 업로드 -->
	    <c:import url="/jsp/SH/portal/gis/contents_shape_upload.jsp"></c:import>
	    <!-- End Shape 업로드  -->

	    <!-- End SYESD 신규 -->
	</div>

    </div>
    <!--//End wrapper-content -->

  	<!-- Map-Content -->
    <c:import url="/jsp/SH_/landmanager/Content_Map.jsp"></c:import>
    <!-- End Map-Content -->

</div>
