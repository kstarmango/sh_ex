/**
 * 
 */
// 창 minimize / maxmise
var shape_is_min = false;
var shape_mini_width;
var shape_mini_height;
   
//모달 초기화
function initModal(obj){
   console.log(1)
   var w = $(window).outerWidth();
   var h = $(window).outerHeight();

   //$('#'+obj).css("top", Math.max(0, (($(window).height() - 600) / 2) + $(window).scrollTop()) + "px");
   //$('#'+obj).css("left", Math.max(0, (($(window).width() - 900) / 2) + $(window).scrollLeft()) + "px");
   
   //모달 드래그
   //$('#'+obj).draggable(); 
   $('#convert_title').css("cursor","move");

   //$('#'+obj).css("cursor","move");
}
//모달 최소화 
function fn_modal_min(obj){
   if(!shape_is_min) {
      shape_mini_width = $('#'+obj).width();
      shape_mini_height = $('#'+obj).height();
      $('#modal_content').css('display', 'none');
      $('#modal_foot').css('display', 'none');
      /*$("#shpaeRecordContents").parent().parent().css('display', 'none');
      $("#shape_convert_condition").css('display', 'none')
      $("#shape_convert_button_group").css('display', 'none')*/

      $("#convert_title").css('border-radius', '0px / 0px');
      $('#'+obj).css('border-radius', '0px / 0px');
      $('#'+obj).css('width', 600);
      $('#'+obj).css('height', 40);
      $('#'+obj).css('top',  ($(window).height()-42)+ "px");
      $('#'+obj).css('left', ($(window).width()-830)+ "px");

      shape_is_min = true;
   }
}

//모달 최대화
function fn_modal_max(obj){
   if(shape_is_min) {
       /*$("#shpaeRecordContents").parent().parent().css('display', 'block');

       $("#shape_convert_condition").css('display', 'block')
      $("#shape_convert_button_group").css('display', 'block')*/

	   $('#modal_content').css('display', 'block');
	   $('#modal_foot').css('display', 'block');
       $("#convert_title").css('border-radius', '10px 10px 0 0');
       $('#'+obj).css('border-radius', '10px 10px 10px 10px');
       $('#'+obj).css('width','auto');
       $('#'+obj).css('height', 'auto');     
       $('#'+obj).css("left", "42%");
       $('#'+obj).css("top", "20%");

      shape_is_min = false;
   }
}

//모달 열기_닫기
function fn_modal_onOff(obj){
   if($('#'+obj).css("display") == "none"){
      $('#'+obj).show();
   }else{
      $('#'+obj).hide();
   }
}

//모달 리사이징
function fn_modal_resize(obj){
    $('#'+obj).resizable({
        minWidth: 800,
        minHeight: 600,
        maxHeight: 600,
    });
}