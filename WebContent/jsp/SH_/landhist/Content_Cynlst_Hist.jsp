<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="utf-8">
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <meta name="description" content="SH서울주택도시공사 | 토지자원관리시스템">

    <link rel="shortcut icon" href="/jsp/SH/img/favicon.ico">    

    <!--DatePicker css-->
    <link href="/jsp/SH/css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <!-- DateTimePicker -->
    <link href="/jsp/SH/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />

	<!--Morris Chart CSS -->
    <link href="/jsp/SH/css/morris.css" rel="stylesheet" />
    
    <!-- App css -->
    <link href="/jsp/SH/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/components.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/icons.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/core.css" rel="stylesheet" type="text/css" />
       
    <!-- jQuery Library -->
	<script src="/jsp/SH/js/jquery.min.js"></script>
	<script src="/jsp/SH/js/bootstrap.min.js"></script>
	
	<!-- Table Sort -->
	<script src="/jsp/SH/js/stupidtable.js"></script>
	
	<!-- App js -->
	<script src="/jsp/SH/js/jquery.app.js"></script>
	<script type="text/javascript" src="<c:url value='/jsp/SH/js/jquery.validate.min.js'/>"></script>
	<!-- OpenLayers4 -->
	<link href="/jsp/SH/js/openLayers/v4.3.1/ol.css" rel="stylesheet" />
	<script src="/jsp/SH/js/openLayers/v4.3.1/ol.js"></script>
	<script src="/jsp/SH/js/openLayers/v4.3.1/polyfill.min.js"></script>
	
<script type="text/javascript">
$(document).ready(function(){

	
});

</script>	

	<title>SH | 토지자원관리시스템</title>

</head>
<body>	
	
	<div id="load">
	    <img src="/jsp/SH/img/ajax-loader.gif"><p>LOADING</p>
	</div>
	
    	<!-- 상세보기-Popup -->
        
            <div class="popover-title tit">
                <span class="m-r-5"><b>재난위험건축물 이력 조회</b></span>
            </div>
                            
                    <div class="popover-content p-30">                    
                        <form id="registerForm" name="registerForm" class="form-horizontal"  onsubmit="return false;">
                        <div class="row">
                            <div class="col-xs-8">
                                <h5 class="m-0"><b>재난위험건축물 이력 내용</b></h5>
                            </div>
                            <div class="col-xs-4">
                                
                                    <div class="row">
                                        <div class="col-xs-12">
                                            <div class="form-group">

                                            </div>
                                        </div>
                                    </div>
                            </div>
                        </div>
						  
                        <div class="row detail-view">
                            <div class="col-xs-15">
                                <div class="card-box box1 p-0 m-b-0">
                                    <ul class="nav nav-tabs" id="dv-tablist">
                                        <li class="active"><a data-toggle="tab" href="#dv-sh">재난위험건축물이력정보</a></li>
                                    </ul>
                                    <div class="tab-content detail-view">
                                        <div id="dv-sh" class="tab-pane fade in active">
		                                    <div class="tab-content detail-view">
		                                        <div class="table-wrap" id="table_dist_one">
	                                        		<table class="table table-custom table-cen table-num text-center" width="100%" height="100%" id="table_sh">
	                                                    
	                                                    <thead>
		                                                    <tr>
		                                                        <th>내용</th>
		                                                        <th>신연번</th>
																<th>종류</th>
																<th>공동주택</th>
																<th>구분명(공동주택)</th> 
																<th>구분명(개별)</th> 
																<th>새주소 </th>
																<th>수치지형도 </th> 
																<th>중복</th>
																<th>기타사항</th>
																<th>join여부</th>
																<th>이유</th>
																<th>PNU 기준주소 </th>
																<th>위치(원본)</th>
																<th>도로명주소 </th> 
																<th>준공년도</th>
																<th>안전등급</th>
																<th>지정일자</th>
																<th>위험유형</th>
																<th>최종점검일자</th> 
																<th>관리번호</th>
																<th>재난관리책임기관</th>
																<th>관리주체</th>
																<th>면적1 </th>
																<th>면적2 </th>
																<th>연면적 </th>
																<th>층수</th>
																<th>동수</th>
																<th>세대수 </th>
																<th>건물구조</th>
																<th>소유주체</th>
																<th>사업명 </th>
																<th>지역지구</th>
																<th>사업방식</th>
																<th>역사이격거리</th> 
																<th>특이사항</th>
																<th>추진위승인 </th> 
																<th>조합설립</th>
																<th>사업시행인가</th> 
																<th>관리처분인가</th> 
																<th>검토의견</th>
																<th>검토내용</th>
																<th>대상지검토대상</th> 
																<th>년도</th>
																<th>사업명 </th>
																<th>수정자ID</th>
																<th>수정일자</th> 
																<th>변경내역</th>
		                                                    </tr>
	                                                    </thead>	                                                    
	                                                    <tbody>
	                                                    <c:forEach var="result" items="${histShData}" varStatus="status">
	                                                    <c:choose>
                                              				<c:when test ="${status.first}">
		                                                    <tr class="success">
		                                                       <td>
		                                                         <c:choose>
						                                             <c:when test="${result.dmlcn == 'insert'}">
						                                                 	등록		
						                                             </c:when>
						                                             <c:when test="${result.dmlcn == 'update'}">
						                                                 	수정		
						                                             </c:when>
						                                             <c:when test="${result.dmlcn == 'delete'}">
						                                                 	삭제		
						                                             </c:when>
						                                             <c:otherwise>-</c:otherwise>
						                                           </c:choose>
		                                                       </td>
		                                                        <td><c:out value='${result.a1}' /></td>
																<td><c:out value='${result.a2}' /></td>
																<td><c:out value='${result.a3}' /></td>
																<td><c:out value='${result.a4}' /></td>
																<td><c:out value='${result.a5}' /></td>
																<td><c:out value='${result.a6}' /></td>
																<td><c:out value='${result.a7}' /></td>
																<td><c:out value='${result.a8}' /></td>
																<td><c:out value='${result.a9 }' /></td>
																<td><c:out value='${result.a17}' /></td>
																<td><c:out value='${result.a18}' /></td>
																<td><c:out value='${result.a19}' /></td>
																<td><c:out value='${result.a20}' /></td>
																<td><c:out value='${result.a21}' /></td>
																<td><c:out value='${result.a22}' /></td>
																<td><c:out value='${result.a23}' /></td>
																<td><c:out value='${result.a24}' /></td>
																<td><c:out value='${result.a25}' /></td>
																<td><c:out value='${result.a26}' /></td>
																<td><c:out value='${result.a27}' /></td>
																<td><c:out value='${result.a28}' /></td>
																<td><c:out value='${result.a29}' /></td>
																<td><c:out value='${result.a30}' /></td>
																<td><c:out value='${result.a31}' /></td>
																<td><c:out value='${result.a32}' /></td>
																<td><c:out value='${result.a33}' /></td>
																<td><c:out value='${result.a34}' /></td>
																<td><c:out value='${result.a35}' /></td>
																<td><c:out value='${result.a36}' /></td>
																<td><c:out value='${result.a37}' /></td>
																<td><c:out value='${result.a38}' /></td>
																<td><c:out value='${result.a39}' /></td>
																<td><c:out value='${result.a40}' /></td>
																<td><c:out value='${result.a41}' /></td>
																<td><c:out value='${result.a42}' /></td>
																<td><c:out value='${result.a43}' /></td>
																<td><c:out value='${result.a44}' /></td>
																<td><c:out value='${result.a45}' /></td>
																<td><c:out value='${result.a46}' /></td>
																<td><c:out value='${result.a47}' /></td>
																<td><c:out value='${result.a48}' /></td>
																<td><c:out value='${result.a49}' /></td>
																<td><c:out value='${result.a50}' /></td>
																<td><c:out value='${result.a51}' /></td>
																<td><c:out value='${result.updtid}' /></td>
		                                                        <td><c:out value='${result.updtdt}' /></td>
		                                                        <td><c:out value='${result.remarkHist}' /></td>
		                                                    </tr>
		                                                    </c:when>
		                                                    <c:otherwise>
		                                                        <tr>
		                                                       <td>
		                                                         <c:choose>
						                                             <c:when test="${result.dmlcn == 'insert'}">
						                                                 	등록		
						                                             </c:when>
						                                             <c:when test="${result.dmlcn == 'update'}">
						                                                 	수정		
						                                             </c:when>
						                                             <c:when test="${result.dmlcn == 'delete'}">
						                                                 	삭제		
						                                             </c:when>
						                                             <c:otherwise>-</c:otherwise>
						                                           </c:choose>
			                                                       </td>
			                                                        <td><c:out value='${result.a1}' /></td>
																	<td><c:out value='${result.a2}' /></td>
																	<td><c:out value='${result.a3}' /></td>
																	<td><c:out value='${result.a4}' /></td>
																	<td><c:out value='${result.a5}' /></td>
																	<td><c:out value='${result.a6}' /></td>
																	<td><c:out value='${result.a7}' /></td>
																	<td><c:out value='${result.a8}' /></td>
																	<td><c:out value='${result.a9 }' /></td>
																	<td><c:out value='${result.a17}' /></td>
																	<td><c:out value='${result.a18}' /></td>
																	<td><c:out value='${result.a19}' /></td>
																	<td><c:out value='${result.a20}' /></td>
																	<td><c:out value='${result.a21}' /></td>
																	<td><c:out value='${result.a22}' /></td>
																	<td><c:out value='${result.a23}' /></td>
																	<td><c:out value='${result.a24}' /></td>
																	<td><c:out value='${result.a25}' /></td>
																	<td><c:out value='${result.a26}' /></td>
																	<td><c:out value='${result.a27}' /></td>
																	<td><c:out value='${result.a28}' /></td>
																	<td><c:out value='${result.a29}' /></td>
																	<td><c:out value='${result.a30}' /></td>
																	<td><c:out value='${result.a31}' /></td>
																	<td><c:out value='${result.a32}' /></td>
																	<td><c:out value='${result.a33}' /></td>
																	<td><c:out value='${result.a34}' /></td>
																	<td><c:out value='${result.a35}' /></td>
																	<td><c:out value='${result.a36}' /></td>
																	<td><c:out value='${result.a37}' /></td>
																	<td><c:out value='${result.a38}' /></td>
																	<td><c:out value='${result.a39}' /></td>
																	<td><c:out value='${result.a40}' /></td>
																	<td><c:out value='${result.a41}' /></td>
																	<td><c:out value='${result.a42}' /></td>
																	<td><c:out value='${result.a43}' /></td>
																	<td><c:out value='${result.a44}' /></td>
																	<td><c:out value='${result.a45}' /></td>
																	<td><c:out value='${result.a46}' /></td>
																	<td><c:out value='${result.a47}' /></td>
																	<td><c:out value='${result.a48}' /></td>
																	<td><c:out value='${result.a49}' /></td>
																	<td><c:out value='${result.a50}' /></td>
																	<td><c:out value='${result.a51}' /></td>
																	<td><c:out value='${result.updtid}' /></td>
			                                                        <td><c:out value='${result.updtdt}' /></td>
			                                                        <td><c:out value='${result.remarkHist}' /></td>
			                                                    </tr>		                                                    
		                                                    </c:otherwise>
		                                                   </c:choose>
	                                                    </c:forEach>
	                                                    </tbody>
	                                                </table>
		                                    	</div>
		                                    </div>   
                                        </div>
                                        
                                    </div>  
                                </div>
                            </div>

                        </div>
                        </form>
                    </div>
            
			  
            <div class="popover-footer detail-view">
                
            </div>
        
        <!--// End 상세보기-Popup -->
    
</body>    
    