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
		    	<th scope="row">관리상태</th>				
		        <td id="detail_sh_a2"><c:out value="${sh_list[0].a2}"/></td>
		        <th scope="row">수탁일</th>						
		        <td id="detail_sh_a3"><c:out value="${sh_list[0].a3}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">계약체결일</th>				
		        <td id="detail_sh_a4"><c:out value="${sh_list[0].a4}"/></td>
		        <th scope="row">잔금지급일</th>						
		        <td id="detail_sh_a5"><c:out value="${sh_list[0].a5}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">16년</th>				
		        <td id="detail_sh_a6"><c:out value="${sh_list[0].a6}"/></td>
		        <th scope="row">주소</th>						
		        <td id="detail_sh_a13"><c:out value="${sh_list[0].a13}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">지목</th>				
		        <td id="detail_sh_a14"><c:out value="${sh_list[0].a14}"/></td>
		        <th scope="row">현황</th>				
		        <td id="detail_sh_a15"><c:out value="${sh_list[0].a15}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">총면적</th>				
		        <td id="detail_sh_a16"><c:out value="${sh_list[0].a16}"/></td>
		        <th scope="row">구분</th>				
		        <td id="detail_sh_a19"><c:out value="${sh_list[0].a19}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">지분면적(당초)</th>				
		        <td id="detail_sh_a17"><c:out value="${sh_list[0].a17}"/></td>
		        <th scope="row">지분면적(변경)</th>				
		        <td id="detail_sh_a18"><c:out value="${sh_list[0].a18}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">조사기관</th>				
		        <td id="detail_sh_a20"><c:out value="${sh_list[0].a20}"/></td>
		        <th scope="row">조사일자</th>				
		        <td id="detail_sh_a21"><c:out value="${sh_list[0].a21}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">조사자</th>				
		        <td id="detail_sh_a22"><c:out value="${sh_list[0].a22}"/></td>
		        <th scope="row">점유자(주민등록정보)</th>				
		        <td id="detail_sh_a23"><c:out value="${sh_list[0].a23}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">송달주소지</th>				
		        <td id="detail_sh_a24"><c:out value="${sh_list[0].a24}"/></td>
		        <th scope="row">연락처</th>				
		        <td id="detail_sh_a25"><c:out value="${sh_list[0].a25}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">사용형태</th>				
		        <td id="detail_sh_a26"><c:out value="${sh_list[0].a26}"/></td>
		        <th scope="row">대장면적</th>				
		        <td id="detail_sh_a27"><c:out value="${sh_list[0].a27}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">점유면적</th>				
		        <td id="detail_sh_a28"><c:out value="${sh_list[0].a28}"/></td>
		        <th scope="row">공부지목</th>				
		        <td id="detail_sh_a29"><c:out value="${sh_list[0].a29}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">점유현황(지목)</th>				
		        <td id="detail_sh_a30"><c:out value="${sh_list[0].a30}"/></td>
		        <th scope="row">매수의사</th>				
		        <td id="detail_sh_a31"><c:out value="${sh_list[0].a31}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">시설종류</th>				
		        <td id="detail_sh_a32"><c:out value="${sh_list[0].a32}"/></td>
		        <th scope="row">접근성(교통)</th>				
		        <td id="detail_sh_a33"><c:out value="${sh_list[0].a33}"/></td>
		    </tr>		    
		    <tr>
		    	<th scope="row">주변시설</th>				
		        <td id="detail_sh_a34"><c:out value="${sh_list[0].a34}"/></td>
		        <th scope="row">주변현황</th>				
		        <td id="detail_sh_a35"><c:out value="${sh_list[0].a35}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">도로환경</th>				
		        <td id="detail_sh_a36"><c:out value="${sh_list[0].a36}"/></td>
		        <th scope="row">주변탐문</th>				
		        <td id="detail_sh_a37"><c:out value="${sh_list[0].a37}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">기타사항</th>				
		        <td id="detail_sh_a38"><c:out value="${sh_list[0].a38}"/></td>
		        <th scope="row">활용 및 대부가능성</th>				
		        <td id="detail_sh_a39"><c:out value="${sh_list[0].a39}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">측량 필요성(점유구분)</th>				
		        <td id="detail_sh_a40"><c:out value="${sh_list[0].a40}"/></td>
		        <th scope="row">개인정보동의</th>				
		        <td id="detail_sh_a41"><c:out value="${sh_list[0].a41}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row" rowspan="3">첨부파일<br/>(실태조사서)</th>				
		        <td colspan="3" align="left">
		        	<button type="button" class="btn btn-teal btn-sm" onclick="location.href='/ajax_factual_fileDownload.do?year=2015&ty=tmseq_land&pnu=${pnu}'">2015년</button>
		        	<button type="button" class="btn btn-teal btn-sm" onclick="location.href='/ajax_factual_fileDownload.do?year=2016&ty=tmseq_land&pnu=${pnu}'">2016년</button>
		        	<button type="button" class="btn btn-teal btn-sm" onclick="location.href='/ajax_factual_fileDownload.do?year=2017&ty=tmseq_land&pnu=${pnu}'">2017년</button>
		        </td>
		    </tr>
	    </tbody>
	</table>
	
	
	
    