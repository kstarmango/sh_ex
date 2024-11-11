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
	    		<th scope="row">소재지</th>				
		        <td id="detail_sh_juso"><c:out value="${sh_list[0].juso}"/>&nbsp;<c:out value="${sh_list[0].dong}"/>&nbsp;<c:out value="${sh_list[0].jibun}"/></td>
		        <th scope="row">지목</th>						
		        <td id="detail_sh_jimok_n"><c:out value="${sh_list[0].jimok_n}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">면적</th>				
		        <td id="detail_sh_area"><c:out value="${sh_list[0].area}"/></td>
		        <th scope="row">소유구분</th>						
		        <td id="detail_sh_own"><c:out value="${sh_list[0].own}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">구분1</th>				
		        <td id="detail_sh_gb"><c:out value="${sh_list[0].gb}"/></td>
		        <th scope="row">구분2</th>						
		        <td id="detail_sh_gubun"><c:out value="${sh_list[0].gubun}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">시설명</th>						
		        <td id="detail_sh_sisul_name"><c:out value="${sh_list[0].sisul_name}"/></td>
		    	<th scope="row"></th>						
		        <td></td>	
		    </tr>
		    <tr>
		    	<th scope="row">비고1</th>				
		        <td id="detail_sh_bigo"><c:out value="${sh_list[0].bigo}"/></td>
		    	<th scope="row">비고2</th>				
		        <td id="detail_sh_bigo_1"><c:out value="${sh_list[0].bigo_1}"/></td>
		    </tr>
	     
	    </tbody>
	</table>
	
	
	
    