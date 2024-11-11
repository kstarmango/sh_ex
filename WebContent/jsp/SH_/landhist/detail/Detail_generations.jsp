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
	    		<th scope="row">사업</th>				
		        <td id="detail_sh_a1"><c:out value="${sh_list[0].a1}"/></td>
		    	<th scope="row">지번</th>				
		        <td id="detail_sh_a2"><c:out value="${sh_list[0].a2}"/></td>	
		    </tr>
		    <tr>
		        <th scope="row">소유주</th>						
		        <td id="detail_sh_a3"><c:out value="${sh_list[0].a3}"/></td>
		    	<th scope="row">소재지</th>				
		        <td id="detail_sh_a4"><c:out value="${sh_list[0].a4}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">인접역</th>						
		        <td id="detail_sh_a11"><c:out value="${sh_list[0].a11}"/></td>
		        <th scope="row">면적</th>						
		        <td id="detail_sh_a12"><c:out value="${sh_list[0].a12}"/></td>	
		        <th scope="row">용도_기</th>						
		        <td id="detail_sh_a13"><c:out value="${sh_list[0].a13}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">용도_변</th>				
		        <td id="detail_sh_a14"><c:out value="${sh_list[0].a14}"/></td>
		        <th scope="row">상황</th>				
		        <td id="detail_sh_a15"><c:out value="${sh_list[0].a15}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">세대_계</th>				
		        <td id="detail_sh_a16"><c:out value="${sh_list[0].a16}"/></td>		        
		    	<th scope="row">세대_공</th>				
		        <td id="detail_sh_a17"><c:out value="${sh_list[0].a17}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">세대_민</th>				
		        <td id="detail_sh_a18"><c:out value="${sh_list[0].a18}"/></td>
		        <th scope="row">호_계</th>				
		        <td id="detail_sh_a19"><c:out value="${sh_list[0].a19}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">호_공</th>				
		        <td id="detail_sh_a20"><c:out value="${sh_list[0].a20}"/></td>
		        <th scope="row">호_민</th>				
		        <td id="detail_sh_a21"><c:out value="${sh_list[0].a21}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">공급</th>				
		        <td id="detail_sh_a22"><c:out value="${sh_list[0].a22}"/></td>
		        <th scope="row">비고</th>				
		        <td id="detail_sh_a23"><c:out value="${sh_list[0].a23}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">사업구분</th>				
		        <td id="detail_sh_a24"><c:out value="${sh_list[0].a24}"/></td>
		        <th scope="row">구분</th>				
		        <td id="detail_sh_a25"><c:out value="${sh_list[0].a25}"/></td>
		    </tr>
		    
	    </tbody>
	</table>
	
	
	
    