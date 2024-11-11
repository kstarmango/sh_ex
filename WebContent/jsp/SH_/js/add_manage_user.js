$(document).ready(function() {
    
});       

//상세보기
function detail(){
	$("form").attr("action", "/manage_user_content.do");
	$("form").attr("method", "post");
	$("form").submit();
}

//취소버튼
function cancel(){
	$("form").attr("action", "/manage_user_home.do");
	$("form").attr("method", "post");
	$("form").submit();
}

//등록버튼
function register(){
	$("form").attr("action", "/manage_user_register.do");
	$("form").attr("method", "post");
	$("form").submit();
}


