$(document).ready(function() {
	
	//글쓰기 버튼
	$('#btnNoticeAdd').click(function(){
		fnNoticeRegister();		
	});
});       

//상세보기
function select_go(a){
	$("#seq").val(a);
	$("form").attr("action", "/board_notice_Content.do");
	$("form").attr("method", "post");
	$("form").submit();
}



//취소버튼
function cancel_notice(){
	$("form").attr("action", "/board_notice_home.do");
	$("form").attr("method", "post");
	$("form").submit();
}

//글쓰기 버튼
function fnNoticeRegister()
{
   	$("form").attr("action", "/board_notice_Insert.do");
	$("form").attr("method", "post");
	$("form").submit();
}
