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
		        <td id="detail_sh_juso"><c:out value="${sh_list[0].juso}"/>&nbsp;<c:out value="${sh_list[0].jibun_2}"/></td>
		        <th scope="row">지목</th>						
		        <td id="detail_sh_jimok_2"><c:out value="${sh_list[0].jimok_2}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">면적</th>				
		        <td id="detail_sh_area"><c:out value="${sh_list[0].area}"/></td>
		        <th scope="row">소유구분</th>						
		        <td id="detail_sh_own"><c:out value="${sh_list[0].own}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">명칭</th>				
		        <td id="detail_sh_name"><c:out value="${sh_list[0].name}"/></td>
		        <th scope="row">건축년도</th>						
		        <td id="detail_sh_build_year"><c:out value="${sh_list[0].build_year}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">현재개</th>				
		        <td id="detail_sh_stat_count"><c:out value="${sh_list[0].stat_count}"/></td>
		        <th scope="row">법정개</th>						
		        <td id="detail_sh_court_number"><c:out value="${sh_list[0].court_number}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">추가개</th>				
		        <td id="detail_sh_additional_number"><c:out value="${sh_list[0].additional_number}"/></td>
		        <th scope="row"></th>						
		        <td></td>	
		    </tr>
		    
	    </tbody>
	</table>
	
	
	
    