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
    <link href="/jsp/SH/css/core.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/components.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/icons.css" rel="stylesheet" type="text/css" />

      
    <!-- jQuery Library -->
	<script src="/jsp/SH/js/jquery.min.js"></script>
	<script src="/jsp/SH/js/bootstrap.min.js"></script>
	
	<!-- Validate -->
<!--     <script src="/jsp/SH/js/jquery.validate.min.js"></script> -->
    
	<!-- App js -->
	<script src="/jsp/SH/js/jquery.app.js"></script>
	<script src="/jsp/SH/js/add_theme.js"></script>
        
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
	    <form>
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
	                    <h5 class="header-title"><b>항목설정</b></h5>
	                    <div class="itemset-wrap m-t-30 m-b-30">
	                        <div class="row">
	                            <!-- <div class="col-sm-3">
	                                <div class="card-box">
	                                    <p class="card-box-title">템플릿</p>
	                                    <div class="card-box-inner p-30 p-t-0 cb-inner01">
	                                        <div class="row">
	                                            <div class="col-xs-12">
	                                                <div class="form-group m-b-0">
	                                                    <div class="radio">
	                                                        <input type="radio" name="radio" value="" id="rd01" checked><label for="rd01">기본 템플릿 1</label>
	                                                    </div>
	                                                    <div class="radio">
	                                                        <input type="radio" name="radio" value="" id="rd02"><label for="rd02">기본 템플릿 2</label>
	                                                    </div>
	                                                    <div class="radio">
	                                                        <input type="radio" name="radio" value="" id="rd03"><label for="rd03">기본 템플릿 3</label>
	                                                    </div>
	                                                </div>
	                                            </div>
	                                        </div>
	                                    </div>
	                                </div>
	                            </div>
	                            <div class="col-sm-7">
	                                <div class="card-box">
	                                    <p class="card-box-title">템플릿 미리보기</p>
	                                    <div class="card-box-inner cb-inner02">
	                                        <div class="tp-preview">
	                                            템플릿 미리보기 영역
	                                        </div>
	                                    </div>
	                                </div>
	                            </div> --> 
								
								
								<div class="col-sm-7">	                                
	                                    <p class="card-box-title">템플릿 미리보기</p>	                                
	                                        <img src="/userfile/motif/${imgName}" class="img-responsive" >
	                            </div>
								
								
	                            <div class="col-sm-5">
	                                <div class="card-box">
	                                    <p class="card-box-title">항목 입력</p>
	                                    <div class="card-box-inner cb-inner03">
	                                        <div class="form-group">
	                                            <label for="">주 제목</label>
	                                            <input type="text" class="form-control input-sm" placeholder="주제를 입력해주세요." name="subject" value="${subject}">
	                                        </div>
	                                        <div class="form-group">
	                                            <label for="">부 제목</label>
	                                            <input type="text" class="form-control input-sm" placeholder="제목을 입력해주세요." name="title" value="${title}">
	                                        </div>
	                                        <div class="form-group">
	                                            <label for="">추가 항목 1</label>
	                                            <input type="text" class="form-control input-sm" placeholder="항목을 입력해주세요." name="sub1" value="${sub1}">
	                                        </div>
	                                        <div class="form-group">
	                                            <label for="">추가 항목 2</label>
	                                            <input type="text" class="form-control input-sm" placeholder="항목을 입력해주세요." name="sub2" value="${sub2}">
	                                        </div>
	                                        <div class="form-group">
	                                        	<th scope="row">공개여부<span class="text-danger">*</span></th>
	                                        	<td colspan="3">
	                                           <input type="radio" name="use_at" value="Y" <c:if test="${use_at eq 'Y'}">checked="checked"</c:if>/> 공개
								               <input type="radio" name="use_at" value="N" <c:if test="${use_at eq 'N'}">checked="checked"</c:if>/> 비공개
							            	</td>
	                                        </div>
	                                    </div>
	                                </div>
	                            </div>
	                        </div>
	
	                        <%-- <div class="row">
	                            <div class="col-sm-6">
	                                <div class="card-box">
	                                    <p class="card-box-title">범례선택 <span class="text-danger small">(최대 0개까지 선택 가능)</span></p>
	                                    <div class="card-box-inner p-30 p-t-0 cb-inner04">
	                                        <div class="row">
	                                            <div class="col-xs-12">
	                                                <div class="form-group m-b-0">
	                                                    <div class="checkbox checkbox-info col-xs-4">
	                                                        <input type="checkbox" value="" id="ch01"><label for="ch01">용도지역</label>
	                                                    </div>
	                                                    <div class="checkbox checkbox-info col-xs-4">
	                                                        <input type="checkbox" value="" id="ch02"><label for="ch02">용도지역</label>
	                                                    </div>
	                                                    <div class="checkbox checkbox-info col-xs-4">
	                                                        <input type="checkbox" value="" id="ch03"><label for="ch03">용도지역</label>
	                                                    </div>
	                                                    <div class="checkbox checkbox-info col-xs-4">
	                                                        <input type="checkbox" value="" id="ch04"><label for="ch04">용도지역</label>
	                                                    </div>
	                                                    <div class="checkbox checkbox-info col-xs-4">
	                                                        <input type="checkbox" value="" id="ch05"><label for="ch05">용도지역</label>
	                                                    </div>
	                                                    <div class="checkbox checkbox-info col-xs-4">
	                                                        <input type="checkbox" value="" id="ch06"><label for="ch06">용도지역</label>
	                                                    </div>
	                                                    <div class="checkbox checkbox-info col-xs-4">
	                                                        <input type="checkbox" value="" id="ch07"><label for="ch07">용도지역</label>
	                                                    </div>
	                                                    <div class="checkbox checkbox-info col-xs-4">
	                                                        <input type="checkbox" value="" id="ch08"><label for="ch08">용도지역</label>
	                                                    </div>
	                                                    <div class="checkbox checkbox-info col-xs-4">
	                                                        <input type="checkbox" value="" id="ch09"><label for="ch09">용도지역</label>
	                                                    </div>
	                                                </div>
	                                            </div>
	                                        </div>
	                                    </div>
	                                </div>
	                            </div>
	                            <div class="col-sm-6">
	                                <div class="card-box">
	                                    <p class="card-box-title">범례 미리보기 및 편집</p>
	                                    <div class="card-box-inner cb-inner05">
	                                        <div class="lb-preview">
	                                            범례 미리보기 및 편집 영역
	                                        </div>
	                                    </div>
	                                </div>
	                            </div>
	                        </div>--%>
	                    </div>
	
						
	                    <!-- Button-Group -->
	                    <div class="modal-footer">
	                        <button type="button" class="btn btn-danger btn-md" onclick="cancel();">
	                            <span><i class="fa fa-times-circle m-r-5"></i>취소</span>
	                        </button>
	                        <button type="button" class="btn btn-custom btn-md" onclick="modify_prev();">
	                            <span>다음<i class="fa fa-chevron-right m-l-5"></i></span>
	                        </button>
	                    </div>
	                    <!--// End Button-Group -->
	                    <input type="hidden" name="imgName" id="imgName" value="${imgName}"/>
	                    <input type="hidden" name="post_seq" value="${post_seq}"/>
						</form>
	                </div>
	            </div>
	        </div>
	
	    </div>
	</div>
	
	<c:import url="/main_footer.do"></c:import>	
		
	
<script type="text/javascript">
$(document).ready(function() {
	var i_name = '${imgName}';
	var img = document.createElement('img'); // 이미지 객체 생성
	
    img.src = '/userfile/motif/' + i_name;
	img.width = $('.tp-preview').width();
	img.height = $('.tp-preview').height();
	
	$(img).appendTo($('.img-responsive'));
});
</script>


</body>

</html>