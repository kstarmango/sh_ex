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
	<script src="/jsp/SH/js/jquery.validate.min.js"></script>
	<script src="/jsp/SH/js/jquery.validate.extend.js"></script> 
	<script src="/jsp/SH/js/moment-with-locales.min.js"></script>
	<script src="/jsp/SH/js/bootstrap-datetimepicker.min.js"></script>
	
	<!-- Validate -->
<!--     <script src="/jsp/SH/js/jquery.validate.min.js"></script> -->
    
	<!-- App js -->
	<script src="/jsp/SH/js/add_manage_board.js"></script>
        
	<!-- HTML5 Shiv and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->
    
	<title>SH | 토지자원관리시스템</title>
<script type="text/javascript">
//목록버튼
function cancel_qna(){
	$("form").attr("action", "/board_qna_home.do");
	$("form").attr("method", "post");
	$("form").submit();
}


//수정바튼
function edit_qna(){
	$("form").attr("action", "/qnaUpdateStart.do");
	$("form").attr("method", "post");
	$("form").submit();
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
	                                <a href="/board_notice_home.do">게시판</a>
	                            </li>
	                            <li class="active">
	                                질의•요청
	                            </li>
	                        </ol>
	                    </div>
	                    <h4 class="page-title">질의•요청</h4>
	                </div>
	            </div>
	        </div>
	        <!-- End Page-Title -->
			<form id="qnaAddForm" name="qnaAddForm" method = "post" enctype="multipart/form-data">
			<input type="hidden" name="seq" value="<c:out value="${qnaList[0].seq}" />"/>
	        <div class="row">
	            <div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
	
	                    <!-- Table-Content-Wrap -->
	                    <h5 class="header-title"><b>질의•요청 등록</b></h5>
	                    <input type="hidden" name="use_at" value="Y"/>
	                    <input type="hidden" name="re_lev" id="re_lev" value="1"/>
	
	                    <div class="table-wrap col-sm-10 col-sm-offset-1 m-t-30">
	                        <!-- QNA-Register -->
	                        <table class="table table-custom">
	                            <colgroup>
	                                <col width="20%">
	                                <col width="30%">
	                                <col width="20%">
	                                <col width="30%">
	                            </colgroup>
	                            <tbody>
	
	                            <tr>
	                                <th scope="row">
	                                    <label for="board_sjt">제목</label>
	                                </th>
	                                <td colspan="3">
	                                    <input type="text" class="form-control input-sm"  name="board_sjt" id="board_sjt" placeholder="제목을 입력해주세요." value="${qnaList[0].board_sjt}">
	                                </td>
	                            </tr>
	                            <tr>
	                                <th scope="row">
	                                    <label for="nAddField-2" class="control-label">작성자</label>
	                                </th>
	                                <td>
	                                    <!-- <input type="text" class="form-control input-sm" id="nAddField-2" name="nAddField-2" readonly="" placeholder="홍길동"> -->
	                                    <input type="text" class="form-control input-sm" name="user_id" readonly="" value="${qnaList[0].regest_id}"/>
	                                </td>
	                                <th>
	                                    <label for="regist_date" class="control-label">작성일자</label>
	                                </th>
	                                <td>
	                                    <div class="input-group date datetimepickerEnd m-b-5">
											<input type="text" class="form-control input-group-addon m-b-0" name="regist_date" id="regist_date" title ="작성일자"  placeholder="작성일자를 선택하세요" value="${qnaList[0].regest_date}"/>
											<span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
										</div>
	                                </td>
	                            </tr>
	                            <tr>
	                                <th scope="row">
	                                    <label for="board_contents">내용</label>
	                                </th>
	                                <td colspan="3">
	                                    <textarea class="form-control" rows="20" id="board_contents" name="board_contents"><c:out value="${qnaList[0].board_contents}"/></textarea>
	                                </td>
	                            </tr>
	
	                            </tbody>
	                        </table>
	                        <!--// End QNA-Register -->
	
	                        <!-- <div class="reply-btn m-b-20 text-right">
	                            <button class="btn btn-sm btn-teal"><i class="fa fa-pencil m-r-5"></i>답글 쓰기</button>
	                        </div> -->
	
	                        <div class="well m-b-40 font-13"><i class="text-info fa fa-info-circle m-r-5"></i>공지사항에 사용자 매뉴얼을 참고하세요.</div>
                    	</div>
	
	                    <div class="clearfix"></div>
	                    
	
	                    <!-- Button-Group -->
	                    <div class="modal-footer">
	                        <button type="button" class="btn btn-danger btn-md" onclick="cancel_qna()">
	                            <span><i class="fa fa-times-circle m-r-5"></i>취소</span>
	                        </button>
	                        <button type="button" class="btn btn-custom btn-md" onclick="edit_qna()">
	                            <span><i class="fa fa-check-circle m-r-5"></i>등록</span>
	                        </button>
	                    </div>
	                    <!--// End Button-Group -->
	                    
	                </div>
	            </div>
	        </div>
			</form>
	    </div>
	</div>
	
	<c:import url="/main_footer.do"></c:import>	
		
	<script src="/jsp/SH/js/jquery.app.js"></script>
	
<script type="text/javascript">

</script>


</body>

</html>