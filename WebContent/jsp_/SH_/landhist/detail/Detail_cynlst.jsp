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
		    	<th scope="row">종류</th>				
		        <td id="detail_sh_a2"><c:out value="${sh_list[0].a2}"/></td>
		        <th scope="row">공동주택</th>						
		        <td id="detail_sh_a3"><c:out value="${sh_list[0].a3}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">구분명(공동주택)</th>				
		        <td id="detail_sh_a4"><c:out value="${sh_list[0].a4}"/></td>
		        <th scope="row">구분명(개별)</th>						
		        <td id="detail_sh_a5"><c:out value="${sh_list[0].a5}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">중복</th>				
		        <td id="detail_sh_a8"><c:out value="${sh_list[0].a8}"/></td>
		        <th scope="row">기타사항</th>						
		        <td id="detail_sh_a9"><c:out value="${sh_list[0].a9}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">기준주소</th>				
		        <td id="detail_sh_a19"><c:out value="${sh_list[0].a19}"/></td>
		        <th scope="row">이유</th>				
		        <td id="detail_sh_a18"><c:out value="${sh_list[0].a18}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">위치(원본)</th>				
		        <td id="detail_sh_a20"><c:out value="${sh_list[0].a20}"/></td>
		        <th scope="row">도로명주소</th>				
		        <td id="detail_sh_a21"><c:out value="${sh_list[0].a21}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">준공년도</th>				
		        <td id="detail_sh_a22"><c:out value="${sh_list[0].a22}"/></td>
		        <th scope="row">안전등급</th>				
		        <td id="detail_sh_a23"><c:out value="${sh_list[0].a23}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">지정일자</th>				
		        <td id="detail_sh_a24"><c:out value="${sh_list[0].a24}"/></td>
		        <th scope="row">위험유형</th>				
		        <td id="detail_sh_a25"><c:out value="${sh_list[0].a25}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">최종점검일자</th>				
		        <td id="detail_sh_a26"><c:out value="${sh_list[0].a26}"/></td>
		        <th scope="row">관리번호</th>				
		        <td id="detail_sh_a27"><c:out value="${sh_list[0].a27}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">재난관리책임기관</th>				
		        <td id="detail_sh_a28"><c:out value="${sh_list[0].a28}"/></td>
		        <th scope="row">관리주체</th>				
		        <td id="detail_sh_a29"><c:out value="${sh_list[0].a29}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">면적1</th>				
		        <td id="detail_sh_a30"><c:out value="${sh_list[0].a30}"/></td>
		        <th scope="row">면적2</th>				
		        <td id="detail_sh_a31"><c:out value="${sh_list[0].a31}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">연면적</th>				
		        <td id="detail_sh_a32"><c:out value="${sh_list[0].a32}"/></td>
		        <th scope="row">층수</th>				
		        <td id="detail_sh_a33"><c:out value="${sh_list[0].a33}"/></td>
		    </tr>		    
		    <tr>
		    	<th scope="row">동수</th>				
		        <td id="detail_sh_a34"><c:out value="${sh_list[0].a34}"/></td>
		        <th scope="row">세대수</th>				
		        <td id="detail_sh_a35"><c:out value="${sh_list[0].a35}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">건물구조</th>				
		        <td id="detail_sh_a36"><c:out value="${sh_list[0].a36}"/></td>
		        <th scope="row">소유주체</th>				
		        <td id="detail_sh_a37"><c:out value="${sh_list[0].a37}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">사업명</th>				
		        <td id="detail_sh_a38"><c:out value="${sh_list[0].a38}"/></td>
		        <th scope="row">지역지구</th>				
		        <td id="detail_sh_a39"><c:out value="${sh_list[0].a39}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">사업방식</th>				
		        <td id="detail_sh_a40"><c:out value="${sh_list[0].a40}"/></td>
		        <th scope="row">역사이격거리</th>				
		        <td id="detail_sh_a41"><c:out value="${sh_list[0].a41}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">특이사항</th>				
		        <td id="detail_sh_a42"><c:out value="${sh_list[0].a42}"/></td>
		        <th scope="row">추진위승인</th>				
		        <td id="detail_sh_a43"><c:out value="${sh_list[0].a43}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">조합설립</th>				
		        <td id="detail_sh_a44"><c:out value="${sh_list[0].a44}"/></td>
		        <th scope="row">사업시행인가</th>				
		        <td id="detail_sh_a45"><c:out value="${sh_list[0].a45}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">관리처분인가</th>				
		        <td id="detail_sh_a46"><c:out value="${sh_list[0].a46}"/></td>
		        <th scope="row">검토의견</th>				
		        <td id="detail_sh_a47"><c:out value="${sh_list[0].a47}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">검토내용</th>				
		        <td id="detail_sh_a48"><c:out value="${sh_list[0].a48}"/></td>
		        <th scope="row">대상지검토대상</th>				
		        <td id="detail_sh_a49"><c:out value="${sh_list[0].a49}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">년도</th>				
		        <td id="detail_sh_a50"><c:out value="${sh_list[0].a50}"/></td>
		        <th scope="row">사업명</th>				
		        <td id="detail_sh_a51"><c:out value="${sh_list[0].a51}"/></td>
		    </tr>
	     
	    </tbody>
	</table>
	
	
	
    