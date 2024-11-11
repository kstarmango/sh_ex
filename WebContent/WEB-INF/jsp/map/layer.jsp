<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />

<div class="mapModal" id="default_layer" style="display: none; z-index: 2;">
	<div class="tabWrapMD">
	    <div class="tab_content hover" id="layerCateTab" title="layerCate" onClick="gfn_tabClick(this);">분류별 찾기</div>
	    <div class="tab_content" id="layerSearchTab"  title="layerSearch" onClick="gfn_tabClick(this);">검색어로 찾기</div>
		<div class="tab_content" id="layeAnalTab" title="layerAnal" onClick="gfn_tabClick(this);">분석결과</div>
	    <span class="favrite" onClick="gfn_validation('myMap',this);">
	        <%-- <img src="${pageContext.request.contextPath}/resources/img/map/icStar.svg" alt="저장 아이콘"> 저장 --%>
	    </span>
	</div>
		
	<!-- 레이어 분류별 찾기 -->
	<div class="contGrayBGInner" id="layerCateInner" style="display:block;">
		<ul class="hideList" id='map-layerlist' style="overflow: scroll;height: 740px;">
               <li class="tit">
                  		생태현황도
                   <img class="arrowBtn" src="${pageContext.request.contextPath}/resources/img/map/btnSelectArrow.svg" alt="접기">
                   <!-- <img class="arrowBtn off" src="../resources/img/map/btnSelectArrow.svg" alt="열기" /> -->
               </li>
               <%-- <ul class="listWrap">
                   <li>
                       · 개별비오톱
                       <button type="button">
                           <img src="${pageContext.request.contextPath}/resources/img/map/icInfo16.svg" alt="정보보기">
                       </button>
                       <button type="button" class="downloadBtn">
                           <img src="${pageContext.request.contextPath}/resources/img/map/icDownload16.svg" alt="다운로드">
                       </button>
                       <form class="swichBtn">
                           <label>
                               <input role="switch" type="checkbox">
                           </label>
                       </form>
                   </li>
               </ul> --%>
           </ul>
	</div>
	<!-- END 레이어 분류별 찾기 -->
	
	<!-- 레이어 검색어 찾기 -->
    <div class="contGrayBGInner" id="layerSearchInner"  style="display:none;">
        <form class="searchTxtInput" onsubmit="return false;" style="width: 28rem;">
            <label>
                <input type="text" title="레이어 검색창" placeholder="레이어명 검색" maxlength="14" id="Layers_nm" onkeypress="if(event.keyCode==13) {searchLayersNameNew(event,'search');}">  <!-- searchLayersName -->
            </label>
            <button onClick="searchLayersNameNew(event,'search');">
                 <img src="${pageContext.request.contextPath}/resources/img/map/IcSearch.svg" alt="검색">
             </button>
        </form>

        <div class="tableTop disFlex">   
            <h4 class="dataNum"><span class="tit">목록</span>(<span class="tit" id="layer_tot_cnt">0</span>건)</h4>
            <button type="button" class="primaryBG" style="display:none;">
                <img src="${pageContext.request.contextPath}/resources/img/map/btnLayer24.svg" alt="레이어목록 다운로드" id="search_list_download"> 다운로드
            </button>
        </div>

        <ul class="hideList" id='map-layerlistSearch'>
        	<li></li>
        </ul>
    </div>
    <!-- END 레이어 검색어 찾기 -->

	<!-- 분석결과 레이어 -->
    <div class="contGrayBGInner" id="layerAnalInner" style="display:none;">

		
        <div id='noResults' style="display: block;">
        	분석결과가 없습니다.
        </div>
        
        <ul class="hideList" id='map-layerlistAnal' style="overflow: auto;display: none;">
           <li>
	            <ul class="listWrap">
	            	<li></li>
	            </ul>
            </li>
        </ul>

        <div id="map-analyResult" style="overflow: auto; display: none;"></div>
    </div>
    <!-- END 분석결과 레이어 -->
</div>


<!-- 레이어설명 Side-Panel -->
<div class="open-info" id="layer_desc_info" style="display:none; position:absolute; width: 390px;top: 100px;right: 361px;">
    <div class="title" style="overflow: hidden;background: #eff6fa; padding:4px 0;">
        <h3><span id='layer_desc_layer_nm'>레이어 설명</span></h3>
        <button style="margin-right: 32px;float: right; display: none;" class="btn btn-teal btn-sm" id='layer_desc_info_edit' onClick="layer_desc_info_edit();">속성편집</button>
        <a class="close btnClose"><img src="/resources/img/btn-s-x.gif" alt="닫기" style="cursor: pointer" id='layer_desc_info_close' onClick="layer_desc_reset();"></a>
    </div>
    <form class="clearfix" id="layerDescEditForm" name="layerDescEditForm">
	    <input type='hidden' id='edit_desc_no' name='edit_desc_no'>
	    <input type='hidden' id='edit_desc_layer_no' name='edit_desc_layer_no'>
	    <div class="text">
	        <table class="table table-custom table-cen table-num text-center">
	        	<caption>레이어 출처 테이블</caption>
	            <colgroup>
	                <col style="width:30%">
                   	<col style="width:70%">
	            </colgroup>
	            <tbody>
	                <tr>
	                    <th scope="row">데이터명</th>
	                    <td style="vertical-align:center;" id='layer_desc_data_nm'></td>
	                </tr>
	                <tr>
	                    <th scope="row">설명</th>
	                    <td style="vertical-align:center;" id='layer_desc_data_desc'></td>
	                </tr>
	                <tr>
	                    <th scope="row">출처</th>
	                    <td style="vertical-align:center;" id='layer_desc_data_origin'></td>
	                </tr>
	                <tr>
	                    <th scope="row">데이터 기준일</th>
	                    <td style="vertical-align:center;" id='layer_desc_data_stdde'></td>
	                </tr>
	                <!-- <tr>
	                    <th scope="row">원데이터 갱신주기</th>
	                    <td style="vertical-align:center;" id=''> 비정기(수시,자료변경시)</td>
	                </tr> -->
	                <tr>
	                    <th scope="row">시스템 갱신주기</th>
	                    <td style="vertical-align:center;" id='layer_desc_data_upd_cycle'></td>
	                </tr>
	                <tr>
	                
	                    <th scope="row">비고</th>
	                    <td style="vertical-align:center;" id='layer_desc_data_rm'></td>
	                </tr>
	            </tbody>
	        </table>
	    </div>
    </form>
    <div class="mini_pop_bottom" id='edit_sh_district_svc'>
        <div style="text-align: right;right: 24px;">
            <button class="btn btn-teal btn-sm" id='layer_desc_info_save' style='display: none' onClick="layer_desc_info_save();">저장</button>
            <button class="btn btn-gray btn-sm" id='layer_desc_info_cancel' style='display: none' onClick="layer_desc_reset();">취소</button>
        </div>
    </div>
</div>
<!-- End 레이어설명 Side-Panel -->