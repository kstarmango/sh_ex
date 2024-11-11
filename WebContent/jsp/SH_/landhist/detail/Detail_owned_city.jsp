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
		        <th scope="row">재산</th>						
		        <td id="detail_sh_a3"><c:out value="${sh_list[0].a3}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">재산종류</th>				
		        <td id="detail_sh_a4"><c:out value="${sh_list[0].a4}"/></td>
		        <th scope="row">행정재산구분</th>						
		        <td id="detail_sh_a5"><c:out value="${sh_list[0].a5}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">소재지</th>				
		        <td id="detail_sh_a7"><c:out value="${sh_list[0].a7}"/></td>
		        <th scope="row">상세주소</th>						
		        <td id="detail_sh_a14"><c:out value="${sh_list[0].a14}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">실지목</th>				
		        <td id="detail_sh_a17"><c:out value="${sh_list[0].a17}"/></td>
		        <th scope="row">공부지목</th>				
		        <td id="detail_sh_a18"><c:out value="${sh_list[0].a18}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">재산수량</th>				
		        <td id="detail_sh_a19"><c:out value="${sh_list[0].a19}"/></td>
		    	<th scope="row">재산면적</th>				
		        <td id="detail_sh_a20"><c:out value="${sh_list[0].a20}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">건축물세대수</th>				
		        <td id="detail_sh_a21"><c:out value="${sh_list[0].a21}"/></td>
		    	<th scope="row">대장가액(평가및추정가액)</th>				
		        <td id="detail_sh_a22"><c:out value="${sh_list[0].a22}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">기준가액</th>				
		        <td id="detail_sh_a23"><c:out value="${sh_list[0].a23}"/></td>
		    	<th scope="row">재산관리관</th>				
		        <td id="detail_sh_a24"><c:out value="${sh_list[0].a24}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">위임관리관</th>				
		        <td id="detail_sh_a25"><c:out value="${sh_list[0].a25}"/></td>
		    	<th scope="row">취득일자</th>				
		        <td id="detail_sh_a26"><c:out value="${sh_list[0].a26}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">취득승인</th>				
		        <td id="detail_sh_a27"><c:out value="${sh_list[0].a27}"/></td>
		    	<th scope="row">취득방법</th>				
		        <td id="detail_sh_a28"><c:out value="${sh_list[0].a28}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">재산명칭</th>				
		        <td id="detail_sh_a29"><c:out value="${sh_list[0].a29}"/></td>
		    	<th scope="row">등록일자</th>				
		        <td id="detail_sh_a30"><c:out value="${sh_list[0].a30}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">비고</th>				
		        <td id="detail_sh_a31"><c:out value="${sh_list[0].a31}"/></td>
		    	<th scope="row"></th>				
		        <td></td>
		    </tr>		
	     
	    </tbody>
	</table>
	
	
	
    