<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />

<div class="addrSearch">
	<!-- 주소검색검색-Bar -->
	<form class="searchTxtInput" onsubmit="return false;" style="width: 28rem;">
	    <label>
	        <input type="text" title="주소검색창" placeholder="행정구역, 지번, 도로명, 건물명을 띄어서 입력해주세요." id="searchKeword" onkeypress="if(event.keyCode==13) {searchToggle('open');searchKeyword('1','summary');}" maxlength="50">
	    </label>
	    <button onClick="searchToggle('open');searchKeyword('1','summary');">
	            <img src="${pageContext.request.contextPath}/resources/img/map/IcSearch.svg" alt="검색">
        </button>
	</form>
	<!-- End 주소검색-Bar -->
	
	<!-- 주소검색 결과 -->
	<div class="mapModal" id="searchResults" style="display:none; max-width: 28rem;">
		<div class="head disFlex">
            <h2><span class="text-orange" id="addr_keyword_result">""</span> 검색결과</h2>
            <img class="closeBtn" src="${pageContext.request.contextPath}/resources/img/map/icClose24.svg" alt="닫기" onClick="searchToggle();">
        </div>
        
        <div class="cont">
        	<div class="tableTop disFlex">
                <h4 class="dataNum">총 <span id="addr_tot_cnt">0</span>건</h4>
                <select class="selectSM" onChange="showSearchList(this.value);" title="주소 선택">
                    <option value="summary">전체</option>
                    <option value="road">도로명주소</option>
                    <option value="jibun">지번</option>
                    <option value="pino">피노지오</option>
                </select>
            </div>
            
            <div class="ListWrap" id='roadWrap'>
	            <div class="tit disFlex">
	                <h3>도로명주소 검색결과</h3>
	                <h4 class="dataNum"><span id="addr_cnt1">0</span>건</h4>
	            </div>
	            <ul class="listBox" id="addr_list1">
	                <!-- <li class="hover" onclick="">서울특별시 <span class="searchText">용산구</span> 용산동4가 19-4</li> -->
	                
	            </ul>
	        </div>
	        
	        <div class="ListWrap" id='jibunWrap'>
	            <div class="tit disFlex">
	                <h3>지번주소 검색결과</h3>
	                <h4 class="dataNum"><span id="addr_cnt2">0</span>건</h4>
	            </div>
	            <ul class="listBox" id="addr_list2">
	               <!--  <li class="hover" onclick="">서울특별시 <span class="searchText">용산구</span> 용산동4가 19-4</li> -->
	                
	            </ul>
	        </div>
	        
	        <div class="ListWrap" id='pinoWrap'>
	            <div class="tit disFlex">
	                <h3>피노지오 검색결과</h3>
	                <h4 class="dataNum"><span id="addr_cnt3">0</span>건</h4>
	            </div>
	            <ul class="listBox" id="addr_list3">
	                <!-- <li class="hover" onclick="">서울특별시 <span class="searchText">용산구</span> 용산동4가 19-4</li> -->
	            </ul>
	        </div>
	        
	        <div class="text-center" style="height: 4rem;display: none;" id="search_page_wrap">
                 <ul class="pagination m-b-5 m-t-10 pagination-sm " id="addr_page">
                     <!-- <li class="disabled">
                         <a href="#"><i class="fa fa-angle-left" aria-hidden="true"></i></a>
                     </li>
                     <li class="active">
                         <a href="#">1</a>
                     </li>
                     <li class="disabled">
                         <a href="#"><i class="fa fa-angle-right" aria-hidden="true"></i></a>
                     </li> -->
                 </ul>
             </div>
        </div>
	</div>
	<!-- End 주소검색 결과 -->
</div>