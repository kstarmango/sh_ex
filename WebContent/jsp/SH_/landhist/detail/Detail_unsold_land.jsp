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
		    	<th scope="row">연번</th>				
		        <td id="detail_sh_a2"><c:out value="${sh_list[0].a2}"/></td>
		        <th scope="row">지구명</th>						
		        <td id="detail_sh_a3"><c:out value="${sh_list[0].a3}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">필지명</th>				
		        <td id="detail_sh_a4"><c:out value="${sh_list[0].a4}"/></td>
		        <th scope="row">대분류코드</th>						
		        <td id="detail_sh_a5"><c:out value="${sh_list[0].a5}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">중분류코드</th>				
		        <td id="detail_sh_a6"><c:out value="${sh_list[0].a6}"/></td>
		        <th scope="row">소분류코드</th>						
		        <td id="detail_sh_a7"><c:out value="${sh_list[0].a7}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">위치</th>				
		        <td id="detail_sh_a8"><c:out value="${sh_list[0].a8}"/></td>
		        <th scope="row">매각대상여부</th>						
		        <td id="detail_sh_a9"><c:out value="${sh_list[0].a9}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">대상면적</th>				
		        <td id="detail_sh_a10"><c:out value="${sh_list[0].a10}"/></td>
		        <th scope="row">매각면적</th>						
		        <td id="detail_sh_a11"><c:out value="${sh_list[0].a11}"/></td>	
		    </tr>
		      <tr>
		    	<th scope="row">존치면적</th>				
		        <td id="detail_sh_a12"><c:out value="${sh_list[0].a12}"/></td>
		        <th scope="row">평가금액</th>						
		        <td id="detail_sh_a13"><c:out value="${sh_list[0].a13}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">단가</th>				
		        <td id="detail_sh_a14"><c:out value="${sh_list[0].a14}"/></td>
		        <th scope="row">가격시점</th>						
		        <td id="detail_sh_a15"><c:out value="${sh_list[0].a15}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">판매방법</th>				
		        <td id="detail_sh_a16"><c:out value="${sh_list[0].a16}"/></td>
		        <th scope="row">가격기준</th>						
		        <td id="detail_sh_a17"><c:out value="${sh_list[0].a17}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">공급대상기준</th>				
		        <td id="detail_sh_a18"><c:out value="${sh_list[0].a18}"/></td>
		        <th scope="row">용도지역</th>					
		        <td id="detail_sh_a19"><c:out value="${sh_list[0].a19}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">건폐율</th>				
		        <td id="detail_sh_a20"><c:out value="${sh_list[0].a20}"/></td>
		        <th scope="row">용적률</th>						
		        <td id="detail_sh_a21"><c:out value="${sh_list[0].a21}"/></td>	
		    </tr>
		     <tr>
		    	<th scope="row">층수제한</th>				
		        <td id="detail_sh_a22"><c:out value="${sh_list[0].a22}"/></td>
		        <th scope="row">미판매사유</th>						
		        <td id="detail_sh_a23"><c:out value="${sh_list[0].a23}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">분양공고협의이력</th>				
		        <td id="detail_sh_a24"><c:out value="${sh_list[0].a24}"/></td>
		    </tr>
		    
	    </tbody>
	</table>
	
	
	
    

    