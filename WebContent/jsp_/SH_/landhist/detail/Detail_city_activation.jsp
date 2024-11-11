<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	
	
	<table class="table table-custom table-cen table-num text-center" width="100%" id="table_sh">
	    <colgroup>
	        <col width="20%"/>
	        <col width="30%"/>
	        <col width="20%"/>
	        <col width="30%"/>
	    </colgroup>
	    <caption align="top"><b>데이터기준일자 : </b>
	   		<c:choose>
	       		<c:when test="${!empty sh_list}"><span id="detail_sh_a0">2020</span></c:when>
	       		<c:otherwise><span id="detail_sh_a0">정보없음</span></c:otherwise>
	       	</c:choose>
	   	</caption>
	   	
	   																	
	    <tbody>
		    <tr>
		    	<th scope="row">구분</th>				
		        <td id="detail_sh_gubun"><c:out value="${sh_list[0].gubun}"/></td>
		        <th scope="row">구역명</th>						
		        <td id="detail_sh_area_name"><c:out value="${sh_list[0].area_name}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">사업유형</th>				
		        <td id="detail_sh_business_type"><c:out value="${sh_list[0].business_type}"/></td>
		        <th scope="row">서울시유형</th>						
		        <td id="detail_sh_seoul_type"><c:out value="${sh_list[0].seoul_type}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">자치구</th>				
		        <td id="detail_sh_jache_gu"><c:out value="${sh_list[0].jache_gu}"/></td>
		        <th scope="row">위치</th>						
		        <td id="detail_sh_location"><c:out value="${sh_list[0].location}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">면적</th>				
		        <td id="detail_sh_area_space"><c:out value="${sh_list[0].area_space}"/></td>
		        <th scope="row">선정방식</th>						
		        <td id="detail_sh_choice_howto"><c:out value="${sh_list[0].choice_howto}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">총 사업비</th>				
		        <td id="detail_sh_total_money"><c:out value="${sh_list[0].total_money}"/></td>
		        <th scope="row">사업기간</th>						
		        <td id="detail_sh_business_date"><c:out value="${sh_list[0].business_date}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">추진단계</th>				
		        <td id="detail_sh_execution_phase"><c:out value="${sh_list[0].execution_phase}"/></td>
		        <th scope="row"></th>						
		        <td></td>	
		    </tr>
	     
	    </tbody>
	</table>
	
	
	
    