$(document).ready(function() {
	$('.date').datetimepicker({
		locale: 'ko',
		defaultDate:new Date(),
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
	
	
	$('.searchBtn').click(function(){
		fnSearchList();
	});
	
	
});       

//상세보기 - 공지사항
function detail_notice(){
	$("form").attr("action", "/board_notice_Content.do");
	$("form").attr("method", "post");
	$("form").submit();
}

//취소버튼 - 공지사항
function cancel_notice(){
	$("form").attr("action", "/board_notice_home.do");
	$("form").attr("method", "post");
	$("form").submit();
}

//등록버튼 - 공지사항
function register_notice(){
	$("form").attr("action", "/board_notice_register.do");
	$("form").attr("method", "post");
	$("form").submit();
}


//상세보기 - Q&A
function detail_qna(a){
	$("#seq").val(a);
	$("form").attr("action", "/board_qna_Content.do");
	$("form").attr("method", "post");
	$("form").submit();
}

//취소버튼 - Q&A
function cancel_qna(){
	$("form").attr("action", "/board_qna_home.do");
	$("form").attr("method", "post");
	$("form").submit();
}

//글쓰기버튼 - Q&A
function register_qna(){
	$("form").attr("action", "/board_qna_register.do");
	$("form").attr("method", "post");
	$("form").submit();
}

//등록버튼 - Q&A
function add_qna(){
	 $("form").attr("action","/qnaInserteStart.do");
	 $("form").attr("method", "post");
	 $("form").submit(); 
}

//답글등록버튼 - Q&A
function add_reqna(){
	 var re_levparam = $("#re_lev").val();
	 $("#re_lev").val(re_levparam*1+1);
	 $("form").attr("action","/qna_reInserteStart.do");
	 $("form").attr("method", "post");
	 $("form").submit(); 
}




