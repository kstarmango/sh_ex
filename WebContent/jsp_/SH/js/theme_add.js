$(document).ready(function() {
    
});       

//상세보기
function detail(postSeq){
	$("form").attr("action", "/theme_Content.do");
	$("form").attr("method", "post");
	$('<input />', {
		type : 'hidden',
		value : postSeq,
		name : 'post_seq'
	}).appendTo($("form"));
	$("form").submit();
}

//취소버튼
function cancel(){
	$("form").attr("action", "/theme_home.do");
	$("form").attr("method", "post");
	$("form").submit();
}

//등록버튼 - 1단계
function register_map(){
	$("form").attr("action", "/theme_regit_01.do");
	$("form").attr("method", "post");
	$("form").submit();
}

//등록버튼 - 2단계
function register_item(){
	geoMap.once('postcompose', function(event) {
        var canvas = event.context.canvas;
        $form = $('form:first');
        $form.attr("action", "/theme_regit_02.do");
    	$form.attr("method", "post");
    	$('input[name="imgSrcs"]').val(canvas.toDataURL('image/png'));
    	$form.submit();
		/*for(i=0;i<geoMap.getLayers().getLength();i++) {
			var source = geoMap.getLayers().getArray()[0].getSource();
			source.on('tileloadend', function() {
				var canvas = this;
				console.log(canvas.toDataURL('image/png'));
			}, event.context.canvas);
		}*/
      });
      geoMap.renderSync();
}

//등록버튼 - 3단계
function register_prev(){
	$("form").attr("action", "/theme_regit_03.do");
	$("form").attr("method", "post");
	$("form").submit();
}

function register_post() {
	$("form").attr("action", "/theme_regit_post.do");
	$("form").attr("method", "post");
	$("form").submit();
}

function modify_mapitem(post_seq) {
	$("form").attr("action", "/theme_modif_01.do");
	$("form").attr("method", "post");
	$('<input />', {
		type: 'hidden',
		name: 'post_seq',
		value: post_seq
	}).appendTo($("form"));
	$("form").submit();
}

function modify_prev(){
	$("form").attr("action", "/theme_modif_02.do");
	$("form").attr("method", "post");
	$("form").submit();
}

function modify_mappost() {
	$("form").attr("action", "/theme_modif_post.do");
	$("form").attr("method", "post");
	$("form").submit();

	


}