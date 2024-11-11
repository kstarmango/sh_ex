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
	<script src="/jsp/SH/js/add_manage_user.js"></script>
        
	<!-- HTML5 Shiv and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->
    
	<title>SH | 토지자원관리시스템</title>
	
	<script type="text/javascript">
	var maxSize = 31457280;
	var vFileCnt = 0;
	var alreadyFileSnArray = new Array();
	$(document).ready(function(){
		
		$('.date').datetimepicker({
			locale: 'ko',
			format: 'YYYY-MM-DD',
		    icons: {
		        previous: "fa fa-chevron-left",
		        next: "fa fa-chevron-right",
		        time: "fa fa-clock-o",
		        date: "fa fa-calendar",
		        up: "fa fa-arrow-up",
		        down: "fa fa-arrow-down"
		    }
		});
		
		$('#noticeAddForm').validate({
			onsubmit: false,
			rules:{
				board_sjt: {
				  required: true
				},
				board_contents: {
				  required: true
				},
				open_start_date: {
				  required: true
				},
				close_end_date: {
				  required: true
				}
			},
			messages:{
				board_sjt: {
					required: "제목을 입력해주세요"
				},
				board_contents: {
					required: "내용을 입력해주세요"
				},
				open_start_date: {
				  	required: "알림 시작을 입력해주세요"
				},
				close_end_date: {
				  	required: "알림 종료을 입력해주세요"
				}
			},
			invalidHandler: function(form, validator) {
				if (validator.numberOfInvalids()) {
					validator.errorList[0].element.focus();
				}
			},
			errorElement: 'em',
			errorPlacement: function(error, element) {
				if(!element.parent('td').hasClass('form-animate-error')){
					$(element.parent("td").addClass("form-animate-error"));
					
				}
				error.appendTo(element.parent("td"));
			},
			success: function(label) {
				if(label.parent('td').hasClass('form-animate-error')){
					$(label.parent("td").removeClass("form-animate-error"));
				}
			},
			highlight: function(element, errorClass, validClass) {
				if(!$(element).parent('td').hasClass('form-animate-error')){
					$(element).parent("td").addClass("form-animate-error");
					
				}
			},
			unhighlight: function(element, errorClass, validClass) {
			}
		});
		
		$('#btnRegCancel').click(function(e){
			e.preventDefault();
			window.location.replace('<c:url value="/noticeAdminListPage.do"/>');
		});
		
		$('#btnRegSave').click(function(e){
			e.preventDefault();
			if($("#noticeAddForm").valid())
			{
			 $("form").attr("method", "post");
			 $("form").attr("action","noticeInserteStart.do");
			 $("form").submit(); 
			}
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
	                                                   공지사항 관리
	                            </li>
	                        </ol>
	                    </div>
	                    <h4 class="page-title">공지사항 등록</h4>
	                </div>
	            </div>
	        </div>
	        <!-- End Page-Title -->
	        <form id="noticeAddForm" name="noticeAddForm" method = "post" enctype="multipart/form-data">
			<input type="hidden" name="user_id" value="<c:out value="${view01.user_id}" />"/>
	        <div class="row">
	            <div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult">
	
	                    <!-- Table-Content-Wrap -->
	                    <h5 class="header-title"><b>공지사항 등록</b></h5>
	                    <input type="hidden" name="board_gubun" value="NOTICE"/>
	
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
                                        <th scope="row">제목<span class="text-danger">*</span></th>
                                        <td colspan="3">
                                        <input class="form-control required" name="board_sjt" id="board_sjt"  type="text" maxlength="20" title="제목" placeholder="제목을 입력해주세요." />                                            
                                        </td>
                                    </tr>                                       
                                    <tr>
                                        <th scope="row">공개여부<span class="text-danger">*</span></th>
                                        <td colspan="3">
                                           <input type="radio" name="use_at" value="Y" checked="checked"/> 공개
							               <input type="radio" name="use_at"  value="N" /> 비공개
						            	</td>
<!-- 						            	<th > -->
<!-- 		                                    <label for="post_open">공지 설정</label> -->
<!-- 		                                </th> -->
<!-- 		                                <td> -->
<!-- 		                                    <select name="post_open" id="post_open" class="form-control input-sm"> -->
<!-- 		                                        <option value="g">일반설정</option> -->
<!-- 		                                        <option value="p">우선게시</option> -->
<!-- 		                                    </select> -->
<!-- 		                                </td> -->
                                    </tr>
                                    
                                    <tr>
		                                <th scope="row">
		                                    <label for="open_start_date">알림 시작일<span class="text-danger">*</span></label>
		                                </th>
		                                <td>
		                                    <div class="input-group date datetimepickerStart m-b-5">
                                                	<input class="form-control input-group-addon m-b-0" name="open_start_date"  id="open_start_date" title ="알림  시작일"  placeholder="알림  시작일 선택하세요" />
                                                    <span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
                                            </div>
		                                   
		                                </td>
		                                <th scope="row">
		                                    <label for="open_start_date">알림  종료일<span class="text-danger">*</span></label>
		                                </th>
		                                <td>
		                                    <div class="input-group date datetimepickerEnd m-b-5">
                                                	<input class="form-control input-group-addon m-b-0" name="close_end_date" id="close_end_date" title ="알림  종료일 "  placeholder="알림  종료일 선택하세요" />
                                                    <span class="input-group-addon bg-info b-0"><i class="fa fa-calendar text-white"></i></span>
                                            </div>
		                                   
		                                </td>
		                            </tr>                                    	    	
                                    <tr>
                                    
                                    <th scope="row">내용<span class="text-danger">*</span></th>
                                     <td colspan="3">                 
                                             <textarea name="board_contents" id="board_contents" rows="20"  class="form-control" placeholder="내용을 입력해주세요." title="내용" ></textarea>
                                             
                                             <!-- 택스트에디터 소스 미반영중 -->
                                             <!-- <script src="https://cdn.ckeditor.com/ckeditor5/11.1.0/classic/ckeditor.js"></script>
                                             <textarea name="board_contents" id="board_contents">
											        &lt;p&gt;This is some sample content.&lt;/p&gt;
											    </textarea>
											    <script>
											        ClassicEditor.create(document.querySelector('#board_contents')).catch(error=>{console.error(error)});
											    </script> -->
                                     </td>
                                   	</tr>
                                    </tbody>
                                </table>
	                        <!--// End User-Register -->
	                    </div>
	
	                    <div class="clearfix"></div>
	                    <!-- Button-Group -->
	                    <div class="modal-footer">
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
	<div id="alert-reg-msg" class="modal" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">
            <div class="modal-dialog modal-sm">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                        <h4 class="modal-title">공지사항 등록</h4>
                    </div>
                    <div class="modal-body">
                        <p id="pRegMsg"></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary waves-effect waves-light" id="regModalClose" data-dismiss="modal">확인</button>
                    </div>
                </div>
            </div>
        </div>
	
	
	
	<script src="/jsp/SH/js/jquery.app.js"></script>
	
<script type="text/javascript">

</script>


</body>

</html>