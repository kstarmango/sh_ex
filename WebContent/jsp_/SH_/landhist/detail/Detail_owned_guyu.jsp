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
		    	<th scope="row">자치구</th>				
		        <td id="detail_sh_a2"><c:out value="${sh_list[0].a2}"/></td>
		        <th scope="row">재산명</th>						
		        <td id="detail_sh_a3"><c:out value="${sh_list[0].a3}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">소유구분코드</th>				
		        <td id="detail_sh_a4"><c:out value="${sh_list[0].a4}"/></td>
		        <th scope="row">재산용도코드</th>						
		        <td id="detail_sh_a5"><c:out value="${sh_list[0].a5}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">행정재산코드</th>				
		        <td id="detail_sh_a6"><c:out value="${sh_list[0].a6}"/></td>
		        <th scope="row">회계구분코드</th>						
		        <td id="detail_sh_a7"><c:out value="${sh_list[0].a7}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">재산관리관</th>				
		        <td id="detail_sh_a8"><c:out value="${sh_list[0].a8}"/></td>
		        <th scope="row">담당부서명</th>				
		        <td id="detail_sh_a9"><c:out value="${sh_list[0].a9}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">분임관리관코드</th>				
		        <td id="detail_sh_a10"><c:out value="${sh_list[0].a10}"/></td>
		        <th scope="row">위임관리관코드</th>				
		        <td id="detail_sh_a11"><c:out value="${sh_list[0].a11}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">재산형태</th>				
		        <td id="detail_sh_a12"><c:out value="${sh_list[0].a12}"/></td>
		        <th scope="row">소재지</th>				
		        <td id="detail_sh_a15"><c:out value="${sh_list[0].a15}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">상세주소</th>				
		        <td id="detail_sh_a22"><c:out value="${sh_list[0].a22}"/></td>
		    	<th scope="row">위치상주소</th>				
		        <td id="detail_sh_a24"><c:out value="${sh_list[0].a24}"/></td>
		        
		    </tr>
		    <tr>
		    	<th scope="row">이유</th>				
		        <td id="detail_sh_a26"><c:out value="${sh_list[0].a17}"/></td>
		        <th scope="row">토지이동코드</th>				
		        <td id="detail_sh_a27"><c:out value="${sh_list[0].a27}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">토지이동사유</th>				
		        <td id="detail_sh_a28"><c:out value="${sh_list[0].a28}"/></td>
		        <th scope="row">토지이동결과</th>				
		        <td id="detail_sh_a29"><c:out value="${sh_list[0].a29}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">기타</th>				
		        <td id="detail_sh_a30"><c:out value="${sh_list[0].a30}"/></td>
		        <th scope="row">대장가액</th>				
		        <td id="detail_sh_a31"><c:out value="${sh_list[0].a31}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">회계기준가액</th>				
		        <td id="detail_sh_a32"><c:out value="${sh_list[0].a32}"/></td>
		        <th scope="row">취득액</th>				
		        <td id="detail_sh_a33"><c:out value="${sh_list[0].a33}"/></td>
		    </tr>		    
		    <tr>
		    	<th scope="row">취득일자</th>				
		        <td id="detail_sh_a34"><c:out value="${sh_list[0].a34}"/></td>
		        <th scope="row">취득방법구분코드</th>				
		        <td id="detail_sh_a35"><c:out value="${sh_list[0].a35}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">취득사유</th>				
		        <td id="detail_sh_a36"><c:out value="${sh_list[0].a36}"/></td>
		        <th scope="row">대부가능여부</th>				
		        <td id="detail_sh_a37"><c:out value="${sh_list[0].a37}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">매각제한여부</th>				
		        <td id="detail_sh_a38"><c:out value="${sh_list[0].a38}"/></td>
		        <th scope="row">매각제한일자</th>				
		        <td id="detail_sh_a39"><c:out value="${sh_list[0].a39}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">비고</th>				
		        <td id="detail_sh_a40"><c:out value="${sh_list[0].a40}"/></td>
		        <th scope="row"></th>				
		        <td></td>
		    </tr>
	     
	    </tbody>
	</table>
	
	
	
    