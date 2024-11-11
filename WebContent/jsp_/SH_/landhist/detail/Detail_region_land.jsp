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
		    	<th scope="row">재산구분</th>				
		        <td id="detail_sh_a2"><c:out value="${sh_list[0].a2}"/></td>
		        <th scope="row">자치구별</th>						
		        <td id="detail_sh_a3"><c:out value="${sh_list[0].a3}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">소재지</th>				
		        <td id="detail_sh_a4"><c:out value="${sh_list[0].a4}"/></td>
		        <th scope="row">면적</th>						
		        <td id="detail_sh_a5"><c:out value="${sh_list[0].a5}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">이용현황</th>				
		        <td id="detail_sh_a6"><c:out value="${sh_list[0].a6}"/></td>
		        <th scope="row">관리현황</th>						
		        <td id="detail_sh_a7"><c:out value="${sh_list[0].a7}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">변상금</th>				
		        <td id="detail_sh_a8"><c:out value="${sh_list[0].a8}"/></td>
		        <th scope="row">현황</th>				
		        <td id="detail_sh_a9"><c:out value="${sh_list[0].a9}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">가액</th>				
		        <td id="detail_sh_a10"><c:out value="${sh_list[0].a10}"/></td>
		        <th scope="row">특이사항</th>				
		        <td id="detail_sh_a11"><c:out value="${sh_list[0].a11}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">기타</th>				
		        <td id="detail_sh_a12"><c:out value="${sh_list[0].a12}"/></td>
		        <th scope="row"></th>				
		        <td></td>
		    </tr>
	     
	    </tbody>
	</table>
	
	
	
    