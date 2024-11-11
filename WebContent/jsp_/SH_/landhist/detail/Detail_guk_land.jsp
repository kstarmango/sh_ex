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
		    	<th scope="row">소관</th>				
		        <td id="detail_sh_a4"><c:out value="${sh_list[0].a4}"/></td>
		        <th scope="row">회계</th>						
		        <td id="detail_sh_a5"><c:out value="${sh_list[0].a5}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">재산구분</th>				
		        <td id="detail_sh_a6"><c:out value="${sh_list[0].a6}"/></td>
		        <th scope="row">재산종류</th>						
		        <td id="detail_sh_a7"><c:out value="${sh_list[0].a7}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">소재지(지번)</th>				
		        <td id="detail_sh_a8"><c:out value="${sh_list[0].a8}"/></td>
		        <th scope="row">소재지(도로명)</th>						
		        <td id="detail_sh_a9"><c:out value="${sh_list[0].a9}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">대장면적</th>				
		        <td id="detail_sh_a10"><c:out value="${sh_list[0].a10}"/></td>
		        <th scope="row">지목(공부)</th>						
		        <td id="detail_sh_a11"><c:out value="${sh_list[0].a11}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">관리상태</th>				
		        <td id="detail_sh_a12"><c:out value="${sh_list[0].a12}"/></td>
		        <th scope="row">건축년도</th>						
		        <td id="detail_sh_a15"><c:out value="${sh_list[0].a15}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">건물지상층수</th>				
		        <td id="detail_sh_a13"><c:out value="${sh_list[0].a13}"/></td>
		        <th scope="row">건물지하층수</th>				
		        <td id="detail_sh_a14"><c:out value="${sh_list[0].a14}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">활용가능</th>				
		        <td id="detail_sh_a16"><c:out value="${sh_list[0].a16}"/></td>
		        <th scope="row">용도지역</th>				
		        <td id="detail_sh_a17"><c:out value="${sh_list[0].a17}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">담당자연락처</th>				
		        <td id="detail_sh_a18"><c:out value="${sh_list[0].a18}"/></td>
		        <th scope="row">관리기관</th>				
		        <td id="detail_sh_a19"><c:out value="${sh_list[0].a19}"/></td>
		    </tr>
	     
	    </tbody>
	</table>
	
	
	
    