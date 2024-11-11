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
                <span class="m-r-5"><b>자산 이력 조회</b></span>
            </div>
                            
                    <div class="popover-content p-30">                    
                        <form id="registerForm" name="registerForm" class="form-horizontal"  onsubmit="return false;">
                        <div class="row">
                            <div class="col-xs-8">
                                <h5 class="m-0"><b>자산 이력 내용</b></h5>
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
                                        <li class="active"><a data-toggle="tab" href="#dv-sh">자산이력정보</a></li>
                                    </ul>
                                    <div class="tab-content detail-view">
                                        <div id="dv-sh" class="tab-pane fade in active">
		                                    <div class="tab-content detail-view">
		                                        <div class="table-wrap" id="table_dist_one">
	                                        		<table class="table table-custom table-cen table-num text-center" width="100%" height="100%" id="table_sh">
	                                                    
	                                                    <thead>
		                                                    <tr>
		                                                        <th>내용</th>
		                                                      
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
    