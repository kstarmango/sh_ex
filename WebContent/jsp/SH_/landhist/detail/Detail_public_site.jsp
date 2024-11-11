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
	    		<th scope="row">기관</th>				
		        <td id="detail_sh_a1"><c:out value="${sh_list[0].a1}"/></td>
		    	<th scope="row">실주소</th>				
		        <td id="detail_sh_a8"><c:out value="${sh_list[0].a8}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">중복</th>				
		        <td id="detail_sh_a9"><c:out value="${sh_list[0].a9}"/></td>
		        <th scope="row">시역</th>				
		        <td id="detail_sh_a10"><c:out value="${sh_list[0].a10}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">이전</th>				
		        <td id="detail_sh_a11"><c:out value="${sh_list[0].a11}"/></td>
		        <th scope="row">이전일</th>				
		        <td id="detail_sh_a12"><c:out value="${sh_list[0].a12}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">이전결</th>				
		        <td id="detail_sh_a13"><c:out value="${sh_list[0].a13}"/></td>
		    	<th scope="row">비고</th>				
		        <td id="detail_sh_a16"><c:out value="${sh_list[0].a16}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">부처</th>				
		        <td id="detail_sh_a17"><c:out value="${sh_list[0].a17}"/></td>
		        <th scope="row">유형</th>				
		        <td id="detail_sh_a18"><c:out value="${sh_list[0].a18}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">설립일</th>				
		        <td id="detail_sh_a20"><c:out value="${sh_list[0].a20}"/></td>
		        <th scope="row">부가</th>				
		        <td id="detail_sh_a21"><c:out value="${sh_list[0].a21}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">설립법</th>				
		        <td id="detail_sh_a22"><c:out value="${sh_list[0].a22}"/></td>
		        <th scope="row">기능군</th>				
		        <td id="detail_sh_a23"><c:out value="${sh_list[0].a23}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">업무</th>				
		        <td id="detail_sh_a24"><c:out value="${sh_list[0].a24}"/></td>
		        <th scope="row">부지면</th>				
		        <td id="detail_sh_a25"><c:out value="${sh_list[0].a25}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">건물면</th>				
		        <td id="detail_sh_a26"><c:out value="${sh_list[0].a26}"/></td>
		        <th scope="row">매각액</th>				
		        <td id="detail_sh_a27"><c:out value="${sh_list[0].a27}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">기타</th>				
		        <td id="detail_sh_a28"><c:out value="${sh_list[0].a28}"/></td>
		        <th scope="row">출처</th>				
		        <td id="detail_sh_a29"><c:out value="${sh_list[0].a29}"/></td>
		    </tr>
	     
	    </tbody>
	</table>
	
	
	
    