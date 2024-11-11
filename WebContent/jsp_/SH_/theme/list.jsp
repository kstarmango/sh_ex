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
	
	<!-- List Javascripts -->
	<script src="/jsp/SH/js/theme_list.js"></script>
        
	<!-- HTML5 Shiv and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->
    
	<title>SH | 토지자원관리시스템</title>
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
		                        <li class="active">
		                            주제도면
		                        </li>
		                    </ol>
		                </div>
		                <h4 class="page-title">주제도면</h4>
		            </div>
		        </div>
		    </div>
		    <!-- End Page-Title -->
		
		    <div class="row">
		        <div class="col-sm-12">
		            <div class="card-box big-card-box last table-responsive searchResult">
		
		                <!-- Table-Content-Wrap -->
		                <h5 class="header-title"><b>목록</b></h5>
		                <div class="theme-list-wrap m-t-30">
		                    <!--<div class="row">
		                        <div class="col-sm-4">
		                            <div class="thumbnail" onclick="detail()">
		                                <img src="/jsp/SH/img/small/img-3.jpg" class="img-responsive">
		                                <div class="caption">
		                                    <h5 class="text-overflow font-600">공시지가에 따른 시유지 현황</h5>
		                                    <p class="text-muted m-b-0">2017.01.01</p>
		                                </div>
		                            </div>
		                        </div>
		                        <div class="col-sm-4">
		                            <div class="thumbnail" onclick="detail()">
		                                <img src="/jsp/SH/img/small/img-1.jpg" class="img-responsive">
		                                <div class="caption">
		                                    <h5 class="text-overflow font-600">공시지가에 따른 시유지 현황</h5>
		                                    <p class="text-muted m-b-0">2017.01.01</p>
		                                </div>
		                            </div>
		                        </div>
		                        <div class="col-sm-4">
		                            <div class="thumbnail" onclick="detail()">
		                                <img src="/jsp/SH/img/small/img-6.jpg" class="img-responsive">
		                                <div class="caption">
		                                    <h5 class="text-overflow font-600">공시지가에 따른 시유지 현황</h5>
		                                    <p class="text-muted m-b-0">2017.01.01</p>
		                                </div>
		                            </div>
		                        </div>
		                    </div>
		
		                    <div class="row">
		                        <div class="col-sm-4">
		                            <div class="thumbnail" onclick="detail()">
		                                <img src="/jsp/SH/img/small/img-3.jpg" class="img-responsive">
		                                <div class="caption">
		                                    <h5 class="text-overflow font-600">공시지가에 따른 시유지 현황</h5>
		                                    <p class="text-muted m-b-0">2017.01.01</p>
		                                </div>
		                            </div>
		                        </div>
		                        <div class="col-sm-4">
		                            <div class="thumbnail" onclick="detail()">
		                                <img src="/jsp/SH/img/small/img-1.jpg" class="img-responsive">
		                                <div class="caption">
		                                    <h5 class="text-overflow font-600">공시지가에 따른 시유지 현황</h5>
		                                    <p class="text-muted m-b-0">2017.01.01</p>
		                                </div>
		                            </div>
		                        </div>
		                        <div class="col-sm-4">
		                            <div class="thumbnail" onclick="detail()">
		                                <img src="/jsp/SH/img/small/img-6.jpg" class="img-responsive">
		                                <div class="caption">
		                                    <h5 class="text-overflow font-600">공시지가에 따른 시유지 현황</h5>
		                                    <p class="text-muted m-b-0">2017.01.01</p>
		                                </div>
		                            </div>
		                        </div>
		                    </div> -->
		                </div>
		
		                <div class="text-center m-b-20">
		                <input type="hidden" id="CURRENT_INDEX" value="1"/>
		                    <ul class="pagination" id="pagination">
		                        <!--<li class="disabled">
		                            <a href="#"><i class="fa fa-angle-left"></i></a>
		                        </li>
		                        <li class="active">
		                            <a href="#">1</a>
		                        </li>
		                        <li>
		                            <a href="#">2</a>
		                        </li>
		                        <li>
		                            <a href="#">3</a>
		                        </li>
		                        <li>
		                            <a href="#">4</a>
		                        </li>
		                        <li>
		                            <a href="#">5</a>
		                        </li>
		                        <li>
		                            <a href="#"><i class="fa fa-angle-right"></i></a>
		                        </li> -->
		                    </ul>
		                </div>
		
		                <div class="row m-b-40">
		                    <div class="col-sm-6 col-sm-offset-3">
		                        <div class="col-xs-3">
		                            <select name="" id="" class="form-control input-sm">
		                                <option value="">제목</option>
		                            </select>
		                        </div>
		                        <div class="col-xs-9">
		                            <div class="input-group">
		                                <input type="search" class="form-control input-sm" placeholder="검색어를 입력하세요." id="search">
		                                <span class="input-group-btn"><button class="btn btn-teal btn-sm" onclick="list_call(1, 9)"><i class="fa fa-search"></i></button></span>
		                            </div>
		                        </div>
		                    </div>
		                </div>
		
						<form></form>
		
		                <!-- Button-Group -->
		                <div class="modal-footer">
		                    <!--<button type="button" class="btn btn-danger btn-md" id="fc-del-btn" data-toggle="modal" data-target="#alert-delete-detail">-->
		                    <!--<span><i class="fa fa-times-circle m-r-5"></i>취소</span>-->
		                    <!--</button>-->
		                    <button type="button" class="btn btn-custom btn-md" onclick="register_map()">
		                        <span><i class="fa fa-check-circle m-r-5"></i>등록</span>
		                    </button>
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

</script>


</body>

</html>