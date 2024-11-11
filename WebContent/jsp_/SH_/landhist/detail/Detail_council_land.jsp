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
	    		<th scope="row">단지코드</th>				
		        <td id="detail_sh_a1"><c:out value="${sh_list[0].a1}"/></td>
		        <th scope="row">구분</th>						
		        <td id="detail_sh_a3"><c:out value="${sh_list[0].a3}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">관리 방법</th>				
		        <td id="detail_sh_a4"><c:out value="${sh_list[0].a4}"/></td>
		        <th scope="row">공급유형</th>						
		        <td id="detail_sh_a5"><c:out value="${sh_list[0].a5}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">단지명</th>				
		        <td id="detail_sh_a6"><c:out value="${sh_list[0].a6}"/></td>
		        <th scope="row">센터</th>						
		        <td id="detail_sh_a7"><c:out value="${sh_list[0].a7}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">구청별</th>				
		        <td id="detail_sh_a8"><c:out value="${sh_list[0].a8}"/></td>
		        <th scope="row">(구)주소</th>						
		        <td id="detail_sh_a9"><c:out value="${sh_list[0].a9}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">도로명주소</th>				
		        <td id="detail_sh_a10"><c:out value="${sh_list[0].a10}"/></td>
		        <th scope="row">우편번호</th>						
		        <td id="detail_sh_a11"><c:out value="${sh_list[0].a11}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">유형</th>				
		        <td id="detail_sh_a12"><c:out value="${sh_list[0].a12}"/></td>
		        <th scope="row">공급일</th>						
		        <td id="detail_sh_a13"><c:out value="${sh_list[0].a13}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">준공일</th>				
		        <td id="detail_sh_a14"><c:out value="${sh_list[0].a14}"/></td>
		        <th scope="row">단지수</th>				
		        <td id="detail_sh_a16"><c:out value="${sh_list[0].a16}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">bu_cout</th>				
		        <td id="detail_sh_a17"><c:out value="${sh_list[0].a17}"/></td>
		        <th scope="row">tol_hohd</th>				
		        <td id="detail_sh_a18"><c:out value="${sh_list[0].a18}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">위탁전환일</th>				
		        <td id="detail_sh_a19"><c:out value="${sh_list[0].a19}"/></td>
		    	<th scope="row">지상층수</th>				
		        <td id="detail_sh_a20"><c:out value="${sh_list[0].a20}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">지하층수</th>				
		        <td id="detail_sh_a21"><c:out value="${sh_list[0].a21}"/></td>
		    	<th scope="row">지상최저층</th>				
		        <td id="detail_sh_a22"><c:out value="${sh_list[0].a22}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">지상최고층</th>				
		        <td id="detail_sh_a23"><c:out value="${sh_list[0].a23}"/></td>
		    	<th scope="row">난방</th>				
		        <td id="detail_sh_a24"><c:out value="${sh_list[0].a24}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">주차대수</th>				
		        <td id="detail_sh_a25"><c:out value="${sh_list[0].a25}"/></td>
		    	<th scope="row">승강기대수</th>				
		        <td id="detail_sh_a26"><c:out value="${sh_list[0].a26}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">경비초소</th>				
		        <td id="detail_sh_a27"><c:out value="${sh_list[0].a27}"/></td>
		    	<th scope="row">복도유형</th>				
		        <td id="detail_sh_a28"><c:out value="${sh_list[0].a28}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">행정번호</th>				
		        <td id="detail_sh_a29"><c:out value="${sh_list[0].a29}"/></td>
		    	<th scope="row">행정번호2</th>				
		        <td id="detail_sh_a30"><c:out value="${sh_list[0].a30}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">전화번호</th>				
		        <td id="detail_sh_a31"><c:out value="${sh_list[0].a31}"/></td>
		    	<th scope="row">팩스번호</th>				
		        <td id="detail_sh_a32"><c:out value="${sh_list[0].a32}"/></td>
		    </tr>		    
		    <tr>
		        <th scope="row">관리비 부과 면적(공급,계약면적)</th>				
		        <td id="detail_sh_a33"><c:out value="${sh_list[0].a33}"/></td>
		    	<th scope="row">공급면적(임대분)</th>				
		        <td id="detail_sh_a34"><c:out value="${sh_list[0].a34}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">공급면적(㎡)</th>				
		        <td id="detail_sh_a35"><c:out value="${sh_list[0].a35}"/></td>
		    	<th scope="row">계약면적(㎡)</th>				
		        <td id="detail_sh_a36"><c:out value="${sh_list[0].a36}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">대지면적(㎡)</th>				
		        <td id="detail_sh_a37"><c:out value="${sh_list[0].a37}"/></td>
		    	<th scope="row">대지면적2</th>				
		        <td id="detail_sh_a38"><c:out value="${sh_list[0].a38}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">flo_area</th>				
		        <td id="detail_sh_a39"><c:out value="${sh_list[0].a39}"/></td>
		    	<th scope="row">시공회사</th>				
		        <td id="detail_sh_a40"><c:out value="${sh_list[0].a40}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">전용면적1</th>				
		        <td id="detail_sh_a42"><c:out value="${sh_list[0].a42}"/></td>
		    	<th scope="row">전용면적2</th>				
		        <td id="detail_sh_a43"><c:out value="${sh_list[0].a43}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">전용면적3</th>				
		        <td id="detail_sh_a44"><c:out value="${sh_list[0].a44}"/></td>
		    	<th scope="row">전용면적4</th>				
		        <td id="detail_sh_a45"><c:out value="${sh_list[0].a45}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">전용면적5</th>				
		        <td id="detail_sh_a46"><c:out value="${sh_list[0].a46}"/></td>
		    	<th scope="row"></th>				
		        <td></td>
		    </tr>
		    <tr>
		        <th scope="row">최저보증금현황</th>				
		        <td id="detail_sh_a47"><c:out value="${sh_list[0].a47}"/></td>
		    	<th scope="row">최고보증금현황</th>				
		        <td id="detail_sh_a48"><c:out value="${sh_list[0].a48}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">최저임대료현황</th>				
		        <td id="detail_sh_a49"><c:out value="${sh_list[0].a49}"/></td>
		    	<th scope="row">최고임대료현황</th>				
		        <td id="detail_sh_a50"><c:out value="${sh_list[0].a50}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">성명</th>				
		        <td id="detail_sh_a51"><c:out value="${sh_list[0].a51}"/></td>
		    	<th scope="row">인원</th>				
		        <td id="detail_sh_a52"><c:out value="${sh_list[0].a52}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">겸직현황</th>				
		        <td id="detail_sh_a53"><c:out value="${sh_list[0].a53}"/></td>
		    	<th scope="row">단지수</th>				
		        <td id="detail_sh_a54"><c:out value="${sh_list[0].a54}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">위탁관리 업체명</th>				
		        <td id="detail_sh_a55"><c:out value="${sh_list[0].a55}"/></td>
		    	<th scope="row">계약방법</th>				
		        <td id="detail_sh_a56"><c:out value="${sh_list[0].a56}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">소장성명</th>				
		        <td id="detail_sh_a57"><c:out value="${sh_list[0].a57}"/></td>
		        <th scope="row">소장인원</th>				
		        <td id="detail_sh_a62"><c:out value="${sh_list[0].a62}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">위탁수수료총계약금액</th>				
		        <td id="detail_sh_a58"><c:out value="${sh_list[0].a58}"/></td>
		        <th scope="row">위탁수수료 비고</th>				
		        <td id="detail_sh_a59"><c:out value="${sh_list[0].a59}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">계약시작일</th>				
		        <td id="detail_sh_a60"><c:out value="${sh_list[0].a60}"/></td>
		        <th scope="row">계약종료일</th>				
		        <td id="detail_sh_a61"><c:out value="${sh_list[0].a61}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">사무원</th>				
		        <td id="detail_sh_a63"><c:out value="${sh_list[0].a63}"/></td>
		        <th scope="row"></th>				
		        <td></td>
		    </tr>
		    <tr>
		    	<th scope="row">기계전기</th>				
		        <td id="detail_sh_a64"><c:out value="${sh_list[0].a64}"/></td>
		    	<th scope="row">위탁·용역인원</th>				
		        <td id="detail_sh_a65"><c:out value="${sh_list[0].a65}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">경비관리업체명</th>				
		        <td id="detail_sh_a66"><c:out value="${sh_list[0].a66}"/></td>
		    	<th scope="row">위탁·용역인원</th>				
		        <td id="detail_sh_a67"><c:out value="${sh_list[0].a67}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">청소관리업체명</th>				
		        <td id="detail_sh_a68"><c:out value="${sh_list[0].a68}"/></td>
		        <th scope="row">위탁·용역인원</th>				
		        <td id="detail_sh_a69"><c:out value="${sh_list[0].a69}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">소계</th>				
		        <td id="detail_sh_a70"><c:out value="${sh_list[0].a70}"/></td>
		        <th scope="row">1단지</th>				
		        <td id="detail_sh_a71"><c:out value="${sh_list[0].a71}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">2단지</th>				
		        <td id="detail_sh_a72"><c:out value="${sh_list[0].a72}"/></td>
		        <th scope="row">3단지</th>				
		        <td id="detail_sh_a73"><c:out value="${sh_list[0].a73}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">4단지</th>				
		        <td id="detail_sh_a74"><c:out value="${sh_list[0].a74}"/></td>
		        <th scope="row">겸직단지</th>				
		        <td id="detail_sh_a75"><c:out value="${sh_list[0].a75}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">비고</th>				
		        <td id="detail_sh_a76"><c:out value="${sh_list[0].a76}"/></td>
		        <th scope="row"></th>				
		        <td></td>
		    </tr>
	     
	    </tbody>
	</table>
	
	
	
    