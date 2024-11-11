<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
$(document).ready(function(){
	
});
</script>	



    	<!-- 주소검색 Side-Panel -->
        <div class="tab-pane fade toptab" role="tabpanel" id="unified-search-tab">
	        <div class="pane-content map">
	
	            <div class="search-result-list in-uni">
	                <p class="srl-title"><span class="text-orange" id="addr_keyword">""</span> 검색결과 <b id="addr_cnt">0</b>건</p>
	                <div class="list-group-wrap in-uni">
	                    <ul class="list-group" id="addr_list">
<!-- 	                        <li class="list-group-item"> -->
<!-- 	                            <div class="pin">핀아이콘</div> -->
<!-- 	                            <div class="list-group-item-text-wrap"> -->
<!-- 	                                <h5 class="list-group-item-heading">위치명</h5> -->
<!-- 	                                <p class="list-group-item-text">도로주소명 </p> -->
<!-- 	                                <p class="list-group-item-text">지번주소명 </p> -->
<!-- 	                            </div> -->
<!-- 	                        </li> -->
<!-- 	                        <li class="list-group-item"> -->
<!-- 	                            <div class="pin">핀아이콘</div> -->
<!-- 	                            <div class="list-group-item-text-wrap"> -->
<!-- 	                                <h5 class="list-group-item-heading">위치명</h5> -->
<!-- 	                                <p class="list-group-item-text">도로주소명 </p> -->
<!-- 	                                <p class="list-group-item-text">지번주소명 </p> -->
<!-- 	                            </div> -->
<!-- 	                        </li> -->
<!-- 	                        <li class="list-group-item"> -->
<!-- 	                            <div class="pin">핀아이콘</div> -->
<!-- 	                            <div class="list-group-item-text-wrap"> -->
<!-- 	                                <h5 class="list-group-item-heading">위치명</h5> -->
<!-- 	                                <p class="list-group-item-text">도로주소명 </p> -->
<!-- 	                                <p class="list-group-item-text">지번주소명 </p> -->
<!-- 	                            </div> -->
<!-- 	                        </li> -->
<!-- 	                        <li class="list-group-item"> -->
<!-- 	                            <div class="pin">핀아이콘</div> -->
<!-- 	                            <div class="list-group-item-text-wrap"> -->
<!-- 	                                <h5 class="list-group-item-heading">위치명</h5> -->
<!-- 	                                <p class="list-group-item-text">도로주소명 </p> -->
<!-- 	                                <p class="list-group-item-text">지번주소명 </p> -->
<!-- 	                            </div> -->
<!-- 	                        </li> -->
<!-- 	                        <li class="list-group-item"> -->
<!-- 	                            <div class="pin">핀아이콘</div> -->
<!-- 	                            <div class="list-group-item-text-wrap"> -->
<!-- 	                                <h5 class="list-group-item-heading">위치명</h5> -->
<!-- 	                                <p class="list-group-item-text">도로주소명 </p> -->
<!-- 	                                <p class="list-group-item-text">지번주소명 </p> -->
<!-- 	                            </div> -->
<!-- 	                        </li> -->
<!-- 	                        <li class="list-group-item"> -->
<!-- 	                            <div class="pin">핀아이콘</div> -->
<!-- 	                            <div class="list-group-item-text-wrap"> -->
<!-- 	                                <h5 class="list-group-item-heading">위치명</h5> -->
<!-- 	                                <p class="list-group-item-text">도로주소명 </p> -->
<!-- 	                                <p class="list-group-item-text">지번주소명 </p> -->
<!-- 	                            </div> -->
<!-- 	                        </li> -->
	                    </ul>
	                </div>
	
	            </div>
	
	            <div class="pagination-wrap">
	                <div class="srl-pagination text-center">
	                    <ul class="pagination m-b-5 m-t-10 pagination-sm" id="addr_page">
	                        <li class="disabled">
	                            <a href="#"><i class="fa fa-angle-left"></i></a>
	                        </li>
	                        <li class="active">
	                            <a href="#">1</a>
	                        </li>
	                        <li class="disabled">
	                            <a href="#"><i class="fa fa-angle-right"></i></a>
	                        </li>
	                    </ul>
	                </div>
	            </div>
	
	        </div>
	    </div>
        <!-- End 주소검색 Side-Panel -->
    
    
    
    
    