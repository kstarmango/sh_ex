<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />
<!DOCTYPE html>
<div class="table-wrap">
   		<table class="table table-custom table-cen table-num text-center" width="100%">
               <colgroup>
                   <%-- <col width="20%"/>
                   <col width="30%"/>
                   <col width="20%"/>
                   <col width="30%"/> --%>
                   <col width="40%"/>
                   <col width="60%"/>
               </colgroup>
               <caption align="top">
               	<b style = "font-size:20px; color:black;">개별공시지가</b>
               </caption>
               <tbody>
                <tr>
                    <th scope="row">기준일</th>
                    <th>개별공시지가(원/m²)	</th>
                </tr>
                <tr>
                	<td id="detail_land_addr">${priceList.pnilp[0].stdyy}-${priceList.pnilp[0].stdmt}</td>
                    <td><c:choose><c:when test="${!empty priceList.pnilp[0].pnilp}"><fmt:formatNumber value="${priceList.pnilp[0].pnilp}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                </tr> 
                <tr>
                	<td id="detail_land_addr1">${priceList.pnilp[0].stdyy-1}-${priceList.pnilp[0].stdmt}</td>
                    <td><c:choose><c:when test="${!empty priceList.pnilp[0].pstyr_1_olnlp}"><fmt:formatNumber value="${priceList.pnilp[0].pstyr_1_olnlp}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                </tr>
                <tr>
                	<td id="detail_land_addr2">${priceList.pnilp[0].stdyy-2}-${priceList.pnilp[0].stdmt}</td>
                    <td><c:choose><c:when test="${!empty priceList.pnilp[0].pstyr_2_olnlp}"><fmt:formatNumber value="${priceList.pnilp[0].pstyr_2_olnlp}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                </tr>
                <tr>
                	<td id="detail_land_addr3">${priceList.pnilp[0].stdyy-3}-${priceList.pnilp[0].stdmt}</td>
                    <td><c:choose><c:when test="${!empty priceList.pnilp[0].pstyr_3_olnlp}"><fmt:formatNumber value="${priceList.pnilp[0].pstyr_3_olnlp}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                </tr>
                <tr>
                	<td id="detail_land_addr4">${priceList.pnilp[0].stdyy-4}-${priceList.pnilp[0].stdmt}</td>
                    <td><c:choose><c:when test="${!empty priceList.pnilp[0].pstyr_4_olnlp}"><fmt:formatNumber value="${priceList.pnilp[0].pstyr_4_olnlp}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                </tr>
               </tbody>
           </table>
           
           <table class="table table-custom table-cen table-num text-center" width="100%">
               <colgroup>
                   <%-- <col width="20%"/>
                   <col width="30%"/>
                   <col width="20%"/>
                   <col width="30%"/> --%>
                   <col width="33%"/>
                   <col width="33%"/>
                   <col width="33%"/>
               </colgroup>
               <caption align="top">
					<b style = "font-size:20px; color:black;">개별주택가격</b>
               		<select id="select_indvdlzHouse" class="form-control input-ib">
		     			<c:choose>
	                		<c:when test="${!empty priceList.indvdlzHouse}">
			               		<c:forEach var="result" items="${priceList.indvdlzHouse}" varStatus="status">
			               			<option value="${result.manage_bild_regstr}"><c:out value="${result.plot_lc}"/></option>
			    				</c:forEach>
		     				</c:when>
		                	<c:otherwise>
	                			<option value="0">정보없음</option>
		                	</c:otherwise>
		                </c:choose>
		   		   </select>
               </caption>
               <tbody>
                <tr>
                    <th scope="row">기준일</th>
                    <th>주택가격(원/m²)	</th>
                    <th>건물산정연면적(㎡)	</th>
                </tr>
                <tr>
                	<td><c:choose><c:when test="${!empty priceList.indvdlzHouse[0].stdyy}">${priceList.indvdlzHouse[0].stdyy}-${priceList.indvdlzHouse[0].stdmt}</c:when><c:otherwise>-</c:otherwise></c:choose></td>
                    <td><c:choose><c:when test="${!empty priceList.indvdlzHouse[0].house_pc}"><fmt:formatNumber value="${priceList.indvdlzHouse[0].house_pc}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                    <td><c:choose><c:when test="${!empty priceList.indvdlzHouse[0].buld_calc_ar}"><fmt:formatNumber value="${priceList.indvdlzHouse[0].buld_calc_ar}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                </tr> 
                <tr>
                    <td><c:choose><c:when test="${!empty priceList.indvdlzHouse[0].stdyy}">${priceList.indvdlzHouse[0].stdyy-1}-${priceList.indvdlzHouse[0].stdmt}</c:when><c:otherwise>-</c:otherwise></c:choose></td>
                    <td><c:choose><c:when test="${!empty priceList.indvdlzHouse[0].pstyr_1_house_pc}"><fmt:formatNumber value="${priceList.indvdlzHouse[0].pstyr_1_house_pc}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                	<td><c:choose><c:when test="${!empty priceList.indvdlzHouse[0].buld_calc_ar}"><fmt:formatNumber value="${priceList.indvdlzHouse[0].buld_calc_ar}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                </tr>
                <tr>
                	<td><c:choose><c:when test="${!empty priceList.indvdlzHouse[0].stdyy}">${priceList.indvdlzHouse[0].stdyy-2}-${priceList.indvdlzHouse[0].stdmt}</c:when><c:otherwise>-</c:otherwise></c:choose></td>
                    <td><c:choose><c:when test="${!empty priceList.indvdlzHouse[0].pstyr_2_house_pc}"><fmt:formatNumber value="${priceList.indvdlzHouse[0].pstyr_2_house_pc}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                	<td><c:choose><c:when test="${!empty priceList.indvdlzHouse[0].buld_calc_ar}"><fmt:formatNumber value="${priceList.indvdlzHouse[0].buld_calc_ar}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                </tr>
                <tr>
                    <td><c:choose><c:when test="${!empty priceList.indvdlzHouse[0].stdyy}">${priceList.indvdlzHouse[0].stdyy-3}-${priceList.indvdlzHouse[0].stdmt}</c:when><c:otherwise>-</c:otherwise></c:choose></td>
                    <td><c:choose><c:when test="${!empty priceList.indvdlzHouse[0].pstyr_3_house_pc}"><fmt:formatNumber value="${priceList.indvdlzHouse[0].pstyr_3_house_pc}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                	<td><c:choose><c:when test="${!empty priceList.indvdlzHouse[0].buld_calc_ar}"><fmt:formatNumber value="${priceList.indvdlzHouse[0].buld_calc_ar}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                </tr>
                <tr>
                    <td><c:choose><c:when test="${!empty priceList.indvdlzHouse[0].stdyy}">${priceList.indvdlzHouse[0].stdyy-4}-${priceList.indvdlzHouse[0].stdmt}</c:when><c:otherwise>-</c:otherwise></c:choose></td>
                    <td><c:choose><c:when test="${!empty priceList.indvdlzHouse[0].pstyr_4_house_pc}"><fmt:formatNumber value="${priceList.indvdlzHouse[0].pstyr_4_house_pc}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                	<td><c:choose><c:when test="${!empty priceList.indvdlzHouse[0].buld_calc_ar}"><fmt:formatNumber value="${priceList.indvdlzHouse[0].buld_calc_ar}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                </tr>
               </tbody>
           </table>
           
           <table class="table table-custom table-cen table-num text-center" width="100%">
               <colgroup>
                   <col width="20%"/>
                   <col width="30%"/>
                   <col width="20%"/>
                   <col width="30%"/>
               </colgroup>
               <caption align="top">
               	<b style = "font-size:20px; color:black;">공동주택가격</b>
               	<select id="select_copertnHouse" class="form-control input-ib" onChange="fn_getSelval(this,'copertnHouse')">
      		<c:choose>
                 	<c:when test="${!empty priceList.copertnHouse}">
                		<c:forEach var="result" items="${priceList.copertnHouse}" varStatus="status">
                			<option value="${result.gis_buld_unity_idntfc_no}"><c:out value="${result.buld_aptcmpl_nm}"/></option>
     				</c:forEach>
      			</c:when>
                 	<c:otherwise>
                 		<option value="0">정보없음</option>
                 	</c:otherwise>
                 </c:choose>
    			</select>
               </caption>
               <tbody>
                <tr>
                    <th scope="row">주용도</th> 
                    <td id="copertnHouse_copertn_house_se_nm">${priceList.copertnHouse[0].copertn_house_se_nm}</td>
                    <th>공동주택명</th>
                    <td id="copertnHouse_aphus_nm">${priceList.copertnHouse[0].aphus_nm}</td>
                </tr>
                <tr>
                    <th scope="row">평균공시가격(원/m&sup2;)</th>
                    <td id="copertnHouse_avrg_potvale"><c:choose><c:when test="${!empty priceList.copertnHouse[0].avrg_potvale}"><fmt:formatNumber value="${priceList.copertnHouse[0].avrg_potvale}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                    <th scope="row">전체공시가격(원/m&sup2;)</th> 
                    <td id="copertnHouse_all_potvale"><c:choose><c:when test="${!empty priceList.copertnHouse[0].all_potvale}"><fmt:formatNumber value="${priceList.copertnHouse[0].all_potvale}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                </tr>
                <tr>
                	<th scope="row">단위면적가격(원/m&sup2;)</th>
                    <td id="copertnHouse_unit_ar_pc"><c:choose><c:when test="${!empty priceList.copertnHouse[0].unit_ar_pc}"><fmt:formatNumber value="${priceList.copertnHouse[0].unit_ar_pc}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                    <th scope="row">산정공동주택호수</th> 
                    <td id="copertnHouse_calc_copertn_house_ho_co"><c:choose><c:when test="${!empty priceList.copertnHouse[0].calc_copertn_house_ho_co}"><fmt:formatNumber value="${priceList.copertnHouse[0].calc_copertn_house_ho_co}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                </tr>
                <tr>
                    <th scope="row">과년도1평균공시가격(원/m&sup2;)</th>
                    <td id="copertnHouse_pstyr_1_avrg_potvale"><c:choose><c:when test="${!empty priceList.copertnHouse[0].pstyr_1_avrg_potvale}"><fmt:formatNumber value="${priceList.copertnHouse[0].pstyr_1_avrg_potvale}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                    <th scope="row">과년도2평균공시가격</th> 
                    <td id="copertnHouse_pstyr_2_avrg_potvale"><c:choose><c:when test="${!empty priceList.copertnHouse[0].pstyr_2_avrg_potvale}"><fmt:formatNumber value="${priceList.copertnHouse[0].pstyr_2_avrg_potvale}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                </tr>
                <tr>
                    <th scope="row">과년도3평균공시가격(원/m&sup2;)</th>
                    <td id="copertnHouse_pstyr_3_avrg_potvale"><c:choose><c:when test="${!empty priceList.copertnHouse[0].pstyr_3_avrg_potvale}"><fmt:formatNumber value="${priceList.copertnHouse[0].pstyr_3_avrg_potvale}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                    <th scope="row">과년도4평균공시가격</th> 
                    <td id="copertnHouse_pstyr_4_avrg_potvale"><c:choose><c:when test="${!empty priceList.copertnHouse[0].pstyr_4_avrg_potvale}"><fmt:formatNumber value="${priceList.copertnHouse[0].pstyr_4_avrg_potvale}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                </tr>
               </tbody>
           </table>
   	</div>