<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
$(document).ready(function(){
	
	$(".list-group-wrap dt").click(function() {

		var active = $(this).hasClass('active');
		if (active) {
			$(this).removeClass('active')
			  $(this).next('dd').css({
				display: "none"
			})  
		} else {

			$(this).addClass('active')
			$(this).next('dd').css({
				display: "block"
			})
			/* 도로명주소, 지번주소 둘다 표출하고 싶으면 아래주석처리----주석처리 없을시, 각각 결과 확인할때 한개씩확인할 수 있음.  */
			/* $(this).siblings('dt').removeClass('active')
			 $(this).siblings().next('dd').css({
				display: "none"
			})   */
			
		}
	});
});
</script>	
    	<!-- 주소검색 Side-Panel -->
        <div class="tab-pane toptab" role="tabpanel" id="addr_search" style="background: white; display : none;top: 100px;height: 450px;z-index: 1095;position: absolute;left: 95px;width: 480px;">
	        <div class="pane-content map">
	
	            <div class="search-result-list in-uni">
	                <p class="srl-title"><span class="text-orange" id="addr_keyword">""</span> 검색결과 </p>
	                <div class="list-group-wrap in-uni" style="margin-top: 10px; height: 100%; padding-bottom: 20px;">
	                 <dt>
	                <a href='#a' > <label for="search_type" style="padding: 0px 30px; font-size: 15px;">도로명주소 검색 결과 ( <b class="text-green" id="addr_cnt1">0</b> 건 )</label></a>
	                 </dt>
	                 <dd>
	                 <ul class="list-group" id="addr_list1"></ul>
		                  <div class="text-center">
		                    <ul class="pagination m-b-5 m-t-10 pagination-sm " id="addr_page">
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
	                 </dd>
	                    <!-- <ul class="list-group" id="addr_list1" style="height: auto; max-height: 43%; overflow-y: auto; position: relative;" > -->
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
	                     
	                    <div class="divider divider-sm in"></div>
	                    
	                     <dt>
	              <a href='#a' > <label for="search_type" style="padding: 0px 30px; font-size: 15px;">지번주소 검색 결과 ( <b class="text-green" id="addr_cnt2">0</b> 건 )</label></a>
	                 </dt>
	                 <dd>
	                 <ul class="list-group" id="addr_list2" >
	                    </ul>
	                 </dd>
	                 
	                </div>
	
	            </div>
	
	           <!-- 240403 주석처리  <div class="pagination-wrap">
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
	            </div> -->
	
	        </div>
	    </div>
        <!-- End 주소검색 Side-Panel -->
    
    
    
    
    