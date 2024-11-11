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
		        <td id="detail_sh_gu"><c:out value="${sh_list[0].gu}"/></td>
		    	<th scope="row">자료출처</th>				
		        <td id="detail_sh_data_s"><c:out value="${sh_list[0].data_s}"/></td>	
		    </tr>
		    <tr>
		    	<th scope="row">주차장명</th>				
		        <td id="detail_sh_p_n"><c:out value="${sh_list[0].p_n}"/></td>
		        <th scope="row">주소</th>				
		        <td id="detail_sh_juso"><c:out value="${sh_list[0].juso}"/></td>
		    </tr>
		    <tr>
		        <th scope="row">비고</th>				
		        <td id="detail_sh_note"><c:out value="${sh_list[0].note}"/></td>
		        <th scope="row">이전일</th>				
		        <td id="detail_sh_a12"><c:out value="${sh_list[0].a12}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">위치상 주소</th>				
		        <td id="detail_sh_l_juso"><c:out value="${sh_list[0].l_juso}"/></td>
		    	<th scope="row">구분</th>				
		        <td id="detail_sh_gb"><c:out value="${sh_list[0].gb}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">운영</th>				
		        <td id="detail_sh_op"><c:out value="${sh_list[0].op}"/></td>
		        <th scope="row">주차면 시설관리공단</th>				
		        <td id="detail_sh_p_nb"><c:out value="${sh_list[0].p_nb}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">급지</th>				
		        <td id="detail_sh_l_gb"><c:out value="${sh_list[0].l_gb}"/></td>
		        <th scope="row">형식</th>				
		        <td id="detail_sh_p_form"><c:out value="${sh_list[0].p_form}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">업데이트</th>				
		        <td id="detail_sh_update"><c:out value="${sh_list[0].update}"/></td>
		        <th scope="row">주차장코드</th>				
		        <td id="detail_sh_p_code"><c:out value="${sh_list[0].p_code}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">운영구분</th>				
		        <td id="detail_sh_o_gb_kor"><c:out value="${sh_list[0].o_gb_kor}"/></td>
		        <th scope="row">전화번호</th>				
		        <td id="detail_sh_t_nb"><c:out value="${sh_list[0].t_nb}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">주차현황 정보 제공여부</th>				
		        <td id="detail_sh_p_if_kor"><c:out value="${sh_list[0].p_if_kor}"/></td>
		        <th scope="row">유무료구분</th>				
		        <td id="detail_sh_f_gb_kor"><c:out value="${sh_list[0].f_gb_kor}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">야간무료개방여부</th>				
		        <td id="detail_sh_nfo_gb_k"><c:out value="${sh_list[0].nfo_gb_k}"/></td>
		        <th scope="row">최종데이터 동기화 시간</th>				
		        <td id="detail_sh_f_d_syn"><c:out value="${sh_list[0].f_d_syn}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">평일 운영 시작시각</th>				
		        <td id="detail_sh_wd_o_t"><c:out value="${sh_list[0].wd_o_t}"/></td>
		        <th scope="row">평일 운영 종료시각</th>				
		        <td id="detail_sh_wd_c_t"><c:out value="${sh_list[0].wd_c_t}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">주말 운영 시작시각</th>				
		        <td id="detail_sh_we_o_t"><c:out value="${sh_list[0].we_o_t}"/></td>
		        <th scope="row">주말 운영 종료시각</th>				
		        <td id="detail_sh_we_c_t"><c:out value="${sh_list[0].we_c_t}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">공휴일 운영 시작시각</th>				
		        <td id="detail_sh_hd_o_t"><c:out value="${sh_list[0].hd_o_t}"/></td>
		        <th scope="row">공휴일 운영 종료시각</th>				
		        <td id="detail_sh_hd_c_t"><c:out value="${sh_list[0].hd_c_t}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">토요일 유,무료 구분</th>				
		        <td id="detail_sh_sat_f_kor"><c:out value="${sh_list[0].sat_f_kor}"/></td>
		        <th scope="row">공휴일 유,무료 구분</th>				
		        <td id="detail_sh_hd_f_kor"><c:out value="${sh_list[0].hd_f_kor}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">월 정기권 금액</th>				
		        <td id="detail_sh_month_f"><c:out value="${sh_list[0].month_f}"/></td>
		        <th scope="row">노상 주차장 관리그룹번호</th>				
		        <td id="detail_sh_p_ad_nb"><c:out value="${sh_list[0].p_ad_nb}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">기본 주차 요금</th>				
		        <td id="detail_sh_un_f"><c:out value="${sh_list[0].un_f}"/></td>
		        <th scope="row">기본 주차 시간(분 단위)</th>				
		        <td id="detail_sh_un_t"><c:out value="${sh_list[0].un_t}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">추가 단위 요금</th>				
		        <td id="detail_sh_add_f"><c:out value="${sh_list[0].add_f}"/></td>
		        <th scope="row">추가 단위 시간(분 단위)</th>				
		        <td id="detail_sh_add_t"><c:out value="${sh_list[0].add_t}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">버스 기본 주차 요금</th>				
		        <td id="detail_sh_bus_un_f"><c:out value="${sh_list[0].bus_un_f}"/></td>
		        <th scope="row">버스 기본 주차 시간(분 단위)</th>				
		        <td id="detail_sh_bus_un_t"><c:out value="${sh_list[0].bus_un_t}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">버스 추가 단위 시간(분 단위)</th>				
		        <td id="detail_sh_bus_add_t"><c:out value="${sh_list[0].bus_add_t}"/></td>
		        <th scope="row">버스 추가 단위 요금</th>				
		        <td id="detail_sh_b_add_f"><c:out value="${sh_list[0].b_add_f}"/></td>
		    </tr>
		    <tr>
		    	<th scope="row">일 최대 요금</th>				
		        <td id="detail_sh_d_max_f"><c:out value="${sh_list[0].d_max_f}"/></td>
		        <th scope="row"></th>				
		        <td></td>
		    </tr>
	     
	    </tbody>
	</table>
	
	
	
    