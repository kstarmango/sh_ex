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
	<script src="/jsp/SH/js/add_manage_board.js"></script>
        
	<!-- HTML5 Shiv and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->
    
    
    <!-- 줄바꿈  -->
	<%pageContext.setAttribute("newLineChar", "\n");%>
    
    
	<title>SH | 토지자원관리시스템</title>
	<script type="text/javascript">
	$(document).ready(function() {
		$("form").attr("action", "/board_cnt_UpdateStart.do");
		$("form").attr("method", "post");
		$("form").submit();
	});
	
	//수정버튼
	function select_go(a){
		$("#seq").val(a);
		$("form").attr("action", "/qnaDetailpage.do");
		$("form").attr("method", "post");
		$("form").submit();
	}
	
	//답글쓰기버튼
	function re_register_go(a){
		$("#seq").val(a);
		$("form").attr("action", "/board_qna_re_register.do");
		$("form").attr("method", "post");
		$("form").submit();
	}
	
	
	//삭제버튼
	function delete_go(a){
		if(confirm("삭제하시겠습니까?")){
			$("#seq").val(a);
			$("form").attr("action", "/qnaDeleteStart.do");
			$("form").attr("method", "post");
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
	
	        <div class="row">
	            <div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
	
	                    <!-- Table-Content-Wrap -->
	                    <form id="accessNoticeForm" name="accessNoticeForm" class="form-horizontal">
						<input type="hidden" name="seq" value="${qnaList[0].seq}"/>
	                    <h5 class="header-title"><b>질의•요청 등록</b></h5>
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
	                                    <label for="nAddField-1">제목</label>
	                                </th>
	                                <td colspan="3">
	                                    <!-- <input type="text" class="form-control input-sm" id="nAddField-1" name="nAddField-1" placeholder="제목을 입력해주세요" > -->
	                                    <c:out value="${qnaList[0].board_sjt}"/>
	                                </td>
	                            </tr>
	                            <tr>
	                                <th scope="row">
	                                    <label for="nAddField-2" class="control-label">작성자</label>
	                                </th>
	                                <td>
	                                    <!-- <input type="text" class="form-control input-sm" id="nAddField-2" name="nAddField-2" readonly="" placeholder="홍길동" > -->
	                                    <c:out value="${qnaList[0].regest_id}"/>
	                                </td>
	                                <th>
	                                    <label for="nAddField-3" class="control-label">작성일자</label>
	                                </th>
	                                <td>
	                                    <!-- <input type="text" class="form-control input-sm" id="nAddField-3" name="nAddField-3" readonly="" placeholder="2018.01.01"> -->
	                                    <c:out value="${qnaList[0].regest_date}"/>
	                                </td>
	                            </tr>
	                            <tr>
	                                <th scope="row">조회수</th>
	                                <td colspan="3">
	                                	<c:out value="${qnaList[0].board_cnt}"/>
	                                </td>
	                            </tr>
	                            <tr>
	                                <th scope="row">
	                                    <label for="nAddField-6">내용</label>
	                                </th>
	                                <td colspan="3">
	                                    <%-- <c:out value="${qnaList[0].board_contents}"/> --%>
	                                    <span class="read_text">${fn:replace(qnaList[0].board_contents, newLineChar, "<br/>")}</span>
	                                </td>
	                            </tr>
	
	                            </tbody>
	                        </table>
	                        <!--// End QNA-Register -->
	
	                        <div class="reply-btn m-b-20 text-right">
	                            <button type="button" class="btn btn-sm btn-teal" onclick="re_register_go('<c:out value="${result.seq}"/>')">
                            		<span><i class="fa fa-pencil m-r-5"></i>답글쓰기</span>
                        		</button>
	                        </div>
	
	                        <div class="well m-b-40 font-13"><i class="text-info fa fa-info-circle m-r-5"></i>공지사항에 사용자 매뉴얼을 참고하세요.</div>
	                    </div>
	
	                    <div class="clearfix"></div>
	                    
	                    </form>
	                    	
	
	                    <!-- Button-Group -->
	                    <div class="modal-footer">
	                        <button type="button" class="btn btn-danger btn-md" onclick="cancel_qna()">
	                            <span><i class="fa fa-times-circle m-r-5"></i>목록</span>
	                        </button>
	                        <!-- <button type="button" class="btn btn-custom btn-md" onclick="register_qna()">
	                            <span><i class="fa fa-edit m-r-5"></i>수정</span>
	                        </button> -->
	                        <!-- 20180622 cjw 권한에 따른 수정버튼 뷰 -->
							<c:choose>
								<c:when test="${userid eq 'admin' || userid eq qnaList[0].regest_id}">
									<button type="button" class="btn btn-teal btn-md" onclick="select_go('<c:out value="${result.seq}"/>')">
                            			<span><i class="fa fa-edit m-r-5"></i>수정</span>
                        			</button>
                        			<button type="button" class="btn btn-inverse btn-md" onclick="delete_go('<c:out value="${result.seq}"/>')">
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

</script>


</body>

</html>