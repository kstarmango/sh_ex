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
	    		<th scope="row">사업코드</th>				
		        <td id="detail_sh_a1"><c:out value="${sh_list[0].a1}"/></td>
		        <th scope="row">공급순번</th>				
		        <td id="detail_sh_a4"><c:out value="${sh_list[0].a4}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">동</th>				
		        <td id="detail_sh_a2"><c:out value="${sh_list[0].a2}"/></td>
		        <th scope="row">호</th>						
		        <td id="detail_sh_a3"><c:out value="${sh_list[0].a3}"/></td>	
		    </tr>
		    <tr>		    	
		        <th scope="row">세대원순번</th>						
		        <td id="detail_sh_a5"><c:out value="${sh_list[0].a5}"/></td>	
		        <th scope="row">단지변경구분</th>				
		        <td id="detail_sh_a6"><c:out value="${sh_list[0].a6}"/></td>
		    </tr>
		    <tr>		    	
		        <th scope="row">상세변경구분</th>						
		        <td id="detail_sh_a7"><c:out value="${sh_list[0].a7}"/></td>	
		        <th scope="row">계약자변경구분</th>				
		        <td id="detail_sh_a8"><c:out value="${sh_list[0].a8}"/></td>
		    </tr>
		    <tr>		    	
		        <th scope="row">세대원변경구분</th>						
		        <td id="detail_sh_a9"><c:out value="${sh_list[0].a9}"/></td>	
		        <th scope="row">임대주택구분</th>				
		        <td id="detail_sh_a10"><c:out value="${sh_list[0].a10}"/></td>
		    </tr>
		    <tr>		    	
		        <th scope="row">도로명주소</th>						
		        <td id="detail_sh_a11"><c:out value="${sh_list[0].a11}"/>&nbsp;<c:out value="${sh_list[0].a12}"/>&nbsp;<c:out value="${sh_list[0].a18}"/></td>
		        <th scope="row">주택유형</th>				
		        <td id="detail_sh_a17"><c:out value="${sh_list[0].a17}"/></td>	
		    </tr>
		    <tr>
		        <th scope="row">준공일자</th>				
		        <td id="detail_sh_a19"><c:out value="${sh_list[0].a19}"/></td>
		        <th scope="row">분양전환예정일자</th>				
		        <td id="detail_sh_a20"><c:out value="${sh_list[0].a20}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">세대수</th>				
		        <td id="detail_sh_a21"><c:out value="${sh_list[0].a21}"/></td>
		        <th scope="row">건물형태</th>				
		        <td id="detail_sh_a22"><c:out value="${sh_list[0].a22}"/></td>
		    </tr>
		    <tr>		    	
		        <th scope="row">난방방식</th>				
		        <td id="detail_sh_a23"><c:out value="${sh_list[0].a23}"/></td>
		        <th scope="row">주차대수</th>				
		        <td id="detail_sh_a24"><c:out value="${sh_list[0].a24}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">승강기설치여부</th>				
		        <td id="detail_sh_a25"><c:out value="${sh_list[0].a25}"/></td>
		        <th scope="row"></th>				
		        <td></td>
		    </tr>
		    <tr>
		    	<th scope="row">동명칭</th>				
		        <td id="detail_sh_a26"><c:out value="${sh_list[0].a26}"/></td>
		        <th scope="row">형명칭</th>				
		        <td id="detail_sh_a27"><c:out value="${sh_list[0].a27}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">총층수</th>				
		        <td id="detail_sh_a28"><c:out value="${sh_list[0].a28}"/></td>
		        <th scope="row">공급면적_전용면적(㎡)</th>				
		        <td id="detail_sh_a29"><c:out value="${sh_list[0].a29}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">공급면적_공용면적(㎡)</th>				
		        <td id="detail_sh_a30"><c:out value="${sh_list[0].a30}"/></td>
		        <th scope="row">방개수</th>				
		        <td id="detail_sh_a31"><c:out value="${sh_list[0].a31}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">호명칭</th>				
		        <td id="detail_sh_a32"><c:out value="${sh_list[0].a32}"/></td>
		        <th scope="row">공급유형</th>				
		        <td id="detail_sh_a33"><c:out value="${sh_list[0].a33}"/></td>
		    </tr>		    
		    <tr>
		    	<th scope="row">공가여부</th>				
		        <td id="detail_sh_a34"><c:out value="${sh_list[0].a34}"/></td>
		        <th scope="row">공가사유</th>				
		        <td id="detail_sh_a35"><c:out value="${sh_list[0].a35}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">매입일자</th>				
		        <td id="detail_sh_a36"><c:out value="${sh_list[0].a36}"/></td>
		        <th scope="row">층</th>				
		        <td id="detail_sh_a37"><c:out value="${sh_list[0].a37}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">취득유형</th>				
		        <td id="detail_sh_a38"><c:out value="${sh_list[0].a38}"/></td>
		        <th scope="row">분양전환여부</th>				
		        <td id="detail_sh_a39"><c:out value="${sh_list[0].a39}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">분양전환일자</th>				
		        <td id="detail_sh_a40"><c:out value="${sh_list[0].a40}"/></td>
		        <th scope="row">기준임대보증금(원)</th>				
		        <td id="detail_sh_a41"><c:out value="${sh_list[0].a41}"/></td>
		    </tr>		    
		    <tr>
		    	<th scope="row">기준임대료(원)</th>				
		        <td id="detail_sh_a42"><c:out value="${sh_list[0].a42}"/></td>
		        <th scope="row">기준전환보증금한도(원)</th>				
		        <td id="detail_sh_a43"><c:out value="${sh_list[0].a43}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">계약자 자격</th>				
		        <td id="detail_sh_a44"><c:out value="${sh_list[0].a44}"/></td>
		        <th scope="row">계약일자</th>				
		        <td id="detail_sh_a45"><c:out value="${sh_list[0].a45}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">실입주일자</th>				
		        <td id="detail_sh_a46"><c:out value="${sh_list[0].a46}"/></td>
		        <th scope="row">임대차기간_시작일자</th>				
		        <td id="detail_sh_a47"><c:out value="${sh_list[0].a47}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">임대차기간_종료일자</th>				
		        <td id="detail_sh_a48"><c:out value="${sh_list[0].a48}"/></td>
		        <th scope="row">임대보증금(원)</th>				
		        <td id="detail_sh_a49"><c:out value="${sh_list[0].a49}"/></td>
		    </tr>
		    
		    <tr>
		    	<th scope="row">월임대료(원)</th>				
		        <td id="detail_sh_a50"><c:out value="${sh_list[0].a50}"/></td>
		        <th scope="row">전환보증금(원)</th>				
		        <td id="detail_sh_a51"><c:out value="${sh_list[0].a51}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">전세_지원금(원)</th>				
		        <td id="detail_sh_a52"><c:out value="${sh_list[0].a52}"/></td>
		        <th scope="row">기본_보증금(원)</th>				
		        <td id="detail_sh_a53"><c:out value="${sh_list[0].a53}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">추가_보증금(원)</th>				
		        <td id="detail_sh_a54"><c:out value="${sh_list[0].a54}"/></td>
		        <th scope="row">월_임대료_임대인(원)</th>				
		        <td id="detail_sh_a55"><c:out value="${sh_list[0].a55}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">쪽방_지원금(원)</th>				
		        <td id="detail_sh_a56"><c:out value="${sh_list[0].a56}"/></td>
		        <th scope="row">퇴거일자</th>				
		        <td id="detail_sh_a57"><c:out value="${sh_list[0].a57}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">동호상태</th>				
		        <td id="detail_sh_a58"><c:out value="${sh_list[0].a58}"/></td>
		        <th scope="row">비고</th>				
		        <td id="detail_sh_a59"><c:out value="${sh_list[0].a59}"/></td>
		    </tr>
		    
	     
	    </tbody>
	</table>
	
	
	
    