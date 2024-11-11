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
	    		<th scope="row">주소</th>				
		        <td id="detail_sh_a3"><c:out value="${sh_list[0].a2}"/>&nbsp;<c:out value="${sh_list[0].a3}"/></td>
		        <th scope="row">사용승인</th>				
		        <td id="detail_sh_a4"><c:out value="${sh_list[0].a4}"/></td>
		    </tr>
		    <tr>		    	
		        <th scope="row">부지면적</th>						
		        <td id="detail_sh_a5"><c:out value="${sh_list[0].a5}"/></td>	
		        <th scope="row">계</th>				
		        <td id="detail_sh_a6"><c:out value="${sh_list[0].a6}"/></td>
		    </tr>
		    <tr>		    	
		        <th scope="row">거주</th>						
		        <td id="detail_sh_a7"><c:out value="${sh_list[0].a7}"/></td>	
		        <th scope="row">공가</th>				
		        <td id="detail_sh_a8"><c:out value="${sh_list[0].a8}"/></td>
		    </tr>
		    <tr>		    	
		        <th scope="row">폐쇄</th>						
		        <td id="detail_sh_a9"><c:out value="${sh_list[0].a9}"/></td>	
		        <th scope="row">우선순위</th>				
		        <td id="detail_sh_a10"><c:out value="${sh_list[0].a10}"/></td>
		    </tr>
		    <tr>		    	
		        <th scope="row">기타</th>				
		        <td id="detail_sh_a16"><c:out value="${sh_list[0].a17}"/></td>
		        <th scope="row"></th>				
		        <td></td>	
		    </tr>
	     	<tr>
		    	<th scope="row" rowspan="3">첨부파일<br/>(전수조사)</th>				
		        <td colspan="3" align="left">
		        	<button type="button" class="btn btn-teal btn-sm" onclick="location.href='/ajax_factual_fileDownload.do?year=2017&ty=declining&pnu=${pnu}'">2017년</button>
		        </td>
		    </tr>
	    </tbody>
	</table>
	
	
	
    