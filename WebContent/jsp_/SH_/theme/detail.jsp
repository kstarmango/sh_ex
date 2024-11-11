<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
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

    <!-- App css -->
    <link href="/jsp/SH/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/components.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/icons.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/core.css" rel="stylesheet" type="text/css" />

      
    <!-- jQuery Library -->
	<script src="/jsp/SH/js/jquery.min.js"></script>
	<script src="/jsp/SH/js/bootstrap.min.js"></script>
	
	<!-- Validate -->
<!--     <script src="/jsp/SH/js/jquery.validate.min.js"></script> -->
    
	<!-- App js -->
	<script src="/jsp/SH/js/add_theme.js"></script>
        
	<!-- HTML5 Shiv and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->
    
	<title>SH | 토지자원관리시스템</title>
	
	<script type="text/javascript">
	
	//삭제버튼
	function delete_go(post_seq){
	if(confirm("삭제하시겠습니까?")){
		$("form").attr("action", "/themeDeleteStart.do");
		$("form").attr("method", "post");
		$('<input />', {
			type : 'hidden',
			value : post_seq,
			name : 'post_seq'
		}).appendTo($("form"));
		$("form").submit();
		}
	}
	
	
	</script>
	
	
	
</head>

<body>	
	
	<c:import url="/main_header.do"></c:import>
	
	<div id="load">
	    <img src="/jsp/SH/img/ajax-loader.gif"><p>LOADING</p>
	</div>
	
	<div class="wrapper">
	    <div class="container">
	        <!-- Page-Title -->
	        <div class="row">
	            <div class="col-sm-12">
	                <div class="page-title-box">
	                    <div class="btn-group pull-right">
	                        <ol class="breadcrumb hide-phone p-0 m-0">
	                            <li>
	                                <a href="/dashboard.do">HOME</a>
	                            </li>
	                            <li>
	                                <a href="/theme_home.do">주제도면</a>
	                            </li>
	                            <li class="active">
	                                등록
	                            </li>
	                        </ol>
	                    </div>
	                    <h4 class="page-title">주제도면 - 등록</h4>
	                </div>
	            </div>
	        </div>
	        <!-- End Page-Title -->
	
	        <div class="row">
	            <div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
	
	                    <!-- Table-Content-Wrap -->
	                    <h5 class="header-title"><b>상세보기</b></h5>
	                    <div class="preview-wrap m-t-30 m-b-30">
	                        <div class="row">	                            
	                            <div class="col-sm-12">
	                                
	                                    <p class="card-box-title">레이아웃 보기</p>
	                                    <div class="card-box-inner">
											<div class="col-sm-4">
	                                        	<!-- <div class="tp-preview"> -->
					                                <div class="card-box">
					                                    <p class="card-box-title">항목</p>
					                                    <div class="card-box-inner cb-inner03" style="height:100%">
					                                        <div class="form-group">
					                                            <label for="">주 제목</label>
					                                            <p for=""  name="subject">${subject}</p>
					                                        </div>
					                                        <div class="form-group">
					                                            <label for="">부 제목</label>
					                                            <p for=""  name="title">${title}</p>
					                                        </div>
					                                        <div class="form-group">
					                                            <label for="">추가 항목1</label>
					                                            <p for=""  name="sub1">${sub1}</p>
					                                        </div>
					                                        <div class="form-group">
					                                            <label for="">추가 항목2</label>
					                                            <p for=""  name="sub2">${sub2}</p>
					                                        </div>
					                                    </div>
					                                </div>
					                            <!-- </div> -->
	                                        </div>
																						
											<div class="col-sm-8">																					
	                                            	<img src="/userfile/motif/${imgNM}" class="img-responsive" >												
											</div>
											
	                                    </div>
	                                
	                            </div>
								
	                        </div>
	
	                    </div>
	                    
	                    <form></form>
	
	                    <!-- Button-Group -->
	                    <div class="modal-footer">	
	                        <button type="button" class="btn btn-danger btn-md" onclick="cancel()">
	                            <span><i class="fa fa-times-circle m-r-5"></i>목록</span>
	                        </button>
	                        <%-- 
	                        <button type="button" class="btn btn-teal btn-md" onclick="modify_mapitem(${post_seq})">
	                            <span><i class="fa fa-edit m-r-5"></i>수정</span>
	                        </button>
	                         --%>
	                         
	                        <!-- 20180607 cjw 권한에 따른 수정버튼 뷰 -->
							<c:choose>
								<c:when test="${userid eq 'admin' || usernm eq ownname}">
									<button type="button" class="btn btn-teal btn-md" onclick="modify_mapitem(${post_seq})">
                            			<span><i class="fa fa-edit m-r-5"></i>수정</span>
                        			</button>
                        			<button type="button" class="btn btn-inverse btn-md" onclick="delete_go(${post_seq})">
                            			<span><i class="fa fa-times-circle m-r-5"></i>삭제</span>
                        			</button>
								</c:when>
								<c:otherwise>
								</c:otherwise>
							</c:choose>
	                        
	                         
	                    </div>
	                    <!--// End Button-Group -->
	                </div>
	            </div>
	        </div>
	
	    </div>
	</div>
	
	<c:import url="/main_footer.do"></c:import>	
		
	<script src="/jsp/SH/js/jquery.app.js"></script>
	
<script type="text/javascript">
$(document).ready(function() {
	
});
</script>


</body>

</html>