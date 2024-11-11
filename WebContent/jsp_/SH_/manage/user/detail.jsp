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
	<script src="/jsp/SH/js/add_manage_user.js"></script>
        
	<!-- HTML5 Shiv and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->
    
	<title>SH | 토지자원관리시스템</title>
	
	<script type="text/javascript">
	$(document).ready(function(){
		var raCheck =  "<c:out value='${view01.user_auth}' />";
		$("input:radio[id='rd0"+raCheck+"']").prop('checked', true);
		
		//사용자목록
		$('#btnRegCancel').click(function(e){
			e.preventDefault();
			window.location.replace('<c:url value="/manage_user_list.do"/>');
		});
		$('#btnPassInit').click(function(e){
			e.preventDefault();
			 $("form").attr("method", "post");
			 $("form").attr("action","user_pass_reset.do");
			 $("form").submit();
		});
		
		$('#btnRegSave').click(function(e){
			e.preventDefault();
			 $("form").attr("method", "post");
			 $("form").attr("action","user_auth_upt.do");
			 $("form").submit();
		});
	});
	</script>
</head>

<body>	
	
	<c:import url="/main_header.do"></c:import>
	
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
	                                <a href="manage_user_list.do">시스템 관리</a>
	                            </li>
	                            <li class="active">
	                                                                사용자 관리
	                            </li>
	                        </ol>
	                    </div>
	                    <h4 class="page-title">사용자 관리</h4>
	                </div>
	            </div>
	        </div>
	        <!-- End Page-Title -->
	        <form id="userInfoForm" name="userInfoForm" method = "post">
			<input type="hidden" name="user_id" value="<c:out value="${view01.user_id}" />"/>
	        <div class="row">
	            <div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
	
	                    <!-- Table-Content-Wrap -->
	                    <h5 class="header-title"><b>사용자 관리</b></h5>
	
	                    <div class="table-wrap col-sm-10 col-sm-offset-1 m-t-30 m-b-40">
	                        <!-- User-Register -->
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
	                                    <label for="nAddField-2" class="control-label">아이디</label>
	                                </th>
	                                <td>
	                                    <c:out value="${view01.user_id}" />
	                                </td>
	                                <th scope="row">
	                                    <label for="nAddField-1">이름</label>
	                                </th>
	                                <td>
	                                    <c:out value="${view01.user_name}" />
	                                </td>
	                            </tr>
	                            <tr>
                                    <th scope="row">부서명</th>
                                    <td><c:out value="${view01.user_position}" /></td>
                                    <th scope="row">전화번호</th>
                                    <td><c:out value="${view01.user_phone}" /></td>
                                </tr>
                                <tr>
                                    <th scope="row">등록일</th>
                                    <td><c:out value='${view01.reg_date}' /></td>
                                    <th scope="row">마지막수정일</th>
                                    <td><c:out value='${view01.updt_date}' /></td>
                                </tr>
                                <tr>
                                  <th scope="row">탈퇴여부</th>
                                  <td colspan="3">
                                      <select name="del_yn" id="del_yn" class="form-control col-md-3 input-sm">
                                        <c:choose>
                                           <c:when test="${view01.del_yn eq 'N'}">
                                              <option value='N' selected="selected">회원</option>
                                              <option value='Y'>탈퇴</option>
                                           </c:when>
                                           <c:otherwise>
                                              <option value='N'>회원</option>
                                              <option value='Y' selected="selected">탈퇴</option>
                                           </c:otherwise>
                                        </c:choose>
                                   </select>
	                               </td>
                               </tr>
	                            <tr>
	                                <th scope="row">사용여부</th>	
	                                <td colspan="3" class="td-expand">
	<!-- 
	                                    <div class="card-box">
	                                        <p class="card-box-title">기능별 권한부여</p>
	                                        <div class="card-box-inner p-30 p-t-0">
	                                            <div class="row">
	                                                <div class="col-xs-4">
	                                                    <div class="checkbox col-xs-12 parent-checkbox">
	                                                        <input type="checkbox" value="" id="ch01"><label for="ch01">시스템관리</label>
	                                                    </div>
	                                                    <div class="checkbox-group">
	                                                        <div class="checkbox col-xs-12">
	                                                            <input type="checkbox" value="" id="ch01"><label for="ch01">사용자관리</label>
	                                                        </div>
	                                                        <div class="checkbox col-xs-12">
	                                                            <input type="checkbox" value="" id="ch01"><label for="ch01">시스템현황</label>
	                                                        </div>
	                                                        <div class="checkbox col-xs-12">
	                                                            <input type="checkbox" value="" id="ch01"><label for="ch01">게시판관리</label>
	                                                        </div>
	                                                    </div>
	                                                </div>
	
	                                                <div class="col-xs-4">
	                                                    <div class="checkbox col-xs-12 parent-checkbox">
	                                                        <input type="checkbox" value="" id="ch01"><label for="ch01">자산검색</label>
	                                                    </div>
	                                                    <div class="checkbox-group">
	                                                        <div class="checkbox col-xs-12">
	                                                            <input type="checkbox" value="" id="ch01"><label for="ch01">즐겨찾기</label>
	                                                        </div>
	                                                        <div class="checkbox col-xs-12">
	                                                            <input type="checkbox" value="" id="ch01"><label for="ch01">검색항목</label>
	                                                        </div>
	                                                        <div class="checkbox col-xs-12">
	                                                            <input type="checkbox" value="" id="ch01"><label for="ch01">공간분석</label>
	                                                        </div>
	                                                        <div class="checkbox col-xs-12">
	                                                            <input type="checkbox" value="" id="ch01"><label for="ch01">자산등록</label>
	                                                        </div>
	                                                        <div class="checkbox col-xs-12">
	                                                            <input type="checkbox" value="" id="ch01"><label for="ch01">자산수정</label>
	                                                        </div>
	                                                        <div class="checkbox col-xs-12">
	                                                            <input type="checkbox" value="" id="ch01"><label for="ch01">자산삭제</label>
	                                                        </div>
	                                                    </div>
	                                                </div>
	
	                                                <div class="col-xs-4">
	                                                    <div class="checkbox col-xs-12 parent-checkbox">
	                                                        <input type="checkbox" value="" id="ch01"><label for="ch01">주제도면</label>
	                                                    </div>
	                                                    <div class="checkbox-group">
	                                                        <div class="checkbox col-xs-12">
	                                                            <input type="checkbox" value="" id="ch01"><label for="ch01">등록</label>
	                                                        </div>
	                                                        <div class="checkbox col-xs-12">
	                                                            <input type="checkbox" value="" id="ch01"><label for="ch01">수정</label>
	                                                        </div>
	                                                        <div class="checkbox col-xs-12">
	                                                            <input type="checkbox" value="" id="ch01"><label for="ch01">삭제</label>
	                                                        </div>
	                                                    </div>
	                                                </div>
	                                            </div>
	                                        </div>
	                                    </div> -->
	
	                                    <div class="card-box m-b-0">
	                                        <p class="card-box-title">등급(단계)별 권한부여</p>
	                                        <div class="card-box-inner p-30 p-t-0">
	                                            <div class="row">
	                                                <div class="col-xs-12">
	                                                    <div class="radio">
	                                                        <input type="radio" name="user_auth" value="0" id="rd00"><label for="rd01">관리자 - 1등급</label>
	                                                        <span class="text-teal">: 모든 기능 사용 O</span>
	                                                    </div>
	                                                </div>
	                                                <div class="col-xs-12">
	                                                    <div class="radio">
	                                                        <input type="radio" name="user_auth" value="1" id="rd01"><label for="rd01">관리자 - 2등급</label>
	                                                        <span class="text-muted">: 기본검색 O, 공간분석 O, 자산데이터 관리 O, 게시판 관리 X</span>
	                                                    </div>
	                                                </div>
	                                                <div class="col-xs-12">
	                                                    <div class="radio">
	                                                        <input type="radio" name="user_auth" value="2" id="rd02"><label for="rd01">사용자 - 1등급</label>
	                                                        <span class="text-muted">: 기본검색 O, 공간분석 O, 자산데이터 관리 X, 게시판 관리 X</span>
	                                                    </div>
	                                                </div>
	                                                <div class="col-xs-12">
	                                                    <div class="radio">
	                                                        <input type="radio" name="user_auth" value="3" id="rd03"><label for="rd01">사용자 - 2등급</label>
	                                                        <span class="text-muted">: 기본검색 O, 공간분석 X, 자산데이터 관리 X, 게시판 관리 X</span>
	                                                    </div>
	                                                </div>
	                                            </div>
	                                        </div>
	                                    </div>
	
	                                </td>
	                            </tr>
	                            </tbody>
	                        </table>
	                        <!--// End User-Register -->
	                    </div>
	
	                    <div class="clearfix"></div>
						
	                    <!-- Button-Group -->
	                    <div class="modal-footer">
	                       <div class="btn-wrap pull-left">
                            	<button class="btn btn btn-info" id="btnPassInit" type="button">비밀번호 초기화</button>
                           </div>
                           <div class="btn-wrap pull-right">
                               <button class="btn btn btn-custom" id="btnRegSave" type="button">저장</button>
                               <button class="btn btn btn-danger" id="btnRegCancel" type="button">목록</button>
                           </div> 
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