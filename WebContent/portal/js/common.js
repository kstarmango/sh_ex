/* layout */
$( document ).ready(function() {
	"use strict";
	
	$('.nav-toggle').click(function(e) {
	  e.preventDefault();
	  $('#container').toggleClass('closeNav');
	  $('.nav-toggle').toggleClass('active');
	  $("#lnb ul ul").hide();
	});

});

/* resize_layout */
$(document).ready(function(){
	"use strict";
	$(window).resize(function (){
		 var width = window.outerWidth;
		 if (width < 1125) {
			$('body').addClass('mobileNav');
			$('#container').removeClass('closeNav');

			$('.nav-toggle').click(function(e) {
			  e.preventDefault();
			  $('.nav-toggle').toggleClass('m_active');
			}); 
		 }
		 else if(width > 1125){
		 	$('body').removeClass('mobileNav');
			$( '.menu' ).hover(function() {
				$( '.menu' ).toggleClass('menu_hv');
			});
		 }
		 });
	}); 





/*Datepicker*/
  $(function() {
	"use strict";
    $(".S_date, .E_date").datepicker();
  });

  $(function() {
	"use strict";
	  $(".S_date, .E_date").attr( 'readOnly' , 'true' );
  });



/* 탭 메뉴*/ 
$(function () {
	"use strict";
    $(".tab_content").hide();
    $(".tab_content:first").show();

    $(".tabs ul li").click(function () {
        $(".tabs ul li").removeClass("active");
        $(this).addClass("active");
        $(".tab_content").hide();
        var activeTab = $(this).find("a").attr("href"); 
        $(activeTab).fadeIn();
		return false;
    });
});

/*alert popup*/
$(function(){
	"use strict";
	var appendthis =  ("<div class='modal-overlay js-modal-close'></div>");
	$('a[data-modal-id]').click(function(e) {
		e.preventDefault();
    $("body").append(appendthis);
    $(".modal-overlay").fadeTo(500, 0.7);
    //$(".js-modalbox").fadeIn(500);
		var modalBox = $(this).attr('data-modal-id');
		$('#'+modalBox).fadeIn($(this).data());
	});  
	$(".js-modal-close, .modal-overlay").click(function() {
		$(".modal-box, .modal-box-al, .modal-overlay").fadeOut(500, function() {
			$(".modal-overlay").remove();
		});
	});
	$(window).resize(function() {
		$(".modal-box, .modal-box-al").css({
			top: ($(window).height() - $(".modal-box, .modal-box-al").outerHeight()) / 2,
			left: ($(window).width() - $(".modal-box, .modal-box-al").outerWidth()) / 2
		});
	});
	$(window).resize();
});



/*select*/
$(document).ready(function(){
	"use strict";
	$("select").styledSelect();
});




/*placeholder*/
$(document).ready(function(){
	"use strict";
    $('.placeholder').autoClear();
});


/* add search box*/
$( document ).ready(function() {
	"use strict";
$(".search_more_btn").click(function () { $(".add_search_info_box").toggle(); });

});

/* add box*/
$( document ).ready(function() {
	"use strict";
$(".view_btn").click(function () { $(".view_info_box").toggle(); });

});





/*alert popup02*/
$(function(){
	"use strict";
	var appendthis =  ("<div class='modal-overlay js-modal-close'></div>");
	$('a[data-modal-id]').click(function(e) {
		e.preventDefault();
    $("body").append(appendthis);
    $(".modal-overlay").fadeTo(500, 0.7);
    //$(".js-modalbox").fadeIn(500);
		var modalBox = $(this).attr('data-modal-id');
		$('#'+modalBox).fadeIn($(this).data());
	});  
	$(".js-modal-close, .modal-overlay").click(function() {
		$(".modal-box_a, .modal-overlay").fadeOut(500, function() {
			$(".modal-overlay").remove();
		});
	});
	$(window).resize(function() {
		$(".modal-box_a").css({
			top: ($(window).height() - $(".modal-box_a").outerHeight()) / 2,
			left: ($(window).width() - $(".modal-box_a").outerWidth()) / 2
		});
	});
	$(window).resize();
});




/*항상 떠 있는 팝업 스크립트
$(function(){
	"use strict";
	$(".js-modal-close, .modal-overlay").click(function() {
		$(".modal-box-a, .modal-overlay").fadeOut(500, function() {
			$(".modal-overlay").remove();
		});
	});
	$(window).resize(function() {
			$(".modal-box-a").css({
				top: ($(window).height() - $(".modal-box-a").outerHeight()) / 2,
				left: ($(window).width() - $(".modal-box-a").outerWidth()) / 2
			});
		});
});

/*LNB Navigation */
( function( $ ) {
	"use strict";
	$( document ).ready(function() {
	$('.LNB_navi > ul > li > a').click(function() {
	  $('.LNB_navi li').removeClass('active');
	  $(this).closest('li').addClass('active');	
	  var checkElement = $(this).next();

	  if((checkElement.is('ul')) && (!checkElement.is(':visible'))) {
		$('.LNB_navi ul ul:visible').slideUp('normal');
		$(".has_sub_show").attr('id', '0');
		$(".has_sub_show").children('ul').slideUp();
		checkElement.slideDown('normal');
	  }

	});
	});
})( jQuery );


/* table */
	$(function(){
	"use strict";
		$('.tablesorter').tablesorter({
			usNumberFormat : false,
			sortReset      : true,
			sortRestart    : true
		});
	});


/* div 높이 같게 */
$(document).ready(function(){
	"use strict";
	$('.graph_wrap_con_wrap').each(function(){

	var highestBox = 0;
	$('.layout').each(function(){

	if($(this).height() > highestBox)
	highestBox = $(this).height();
	});

	$('.layout').height(highestBox);

});
});

/* ie8 */
/* check */
$(document).ready(function() { 
	"use strict";
	$("input:checkbox").on('click', function() { 
		if ( $(this).prop('checked') ) { 
			$(this).parent().addClass("selected"); 
		} else {
			$(this).parent().removeClass("selected"); 
		} 
	}); 
});
		
		
$(document).ready(function(){
	"use strict";
	var _designRadio = $('.designRadio');
	var _iLabel = $('.iLabel');
	$(_iLabel).click(function(){
		var _thisRadio = $(this).parent().find('> .designRadio');
		var _value = $(this).parent().find('>input').val();
		$(_designRadio).children().removeClass('checked');
		$(_thisRadio).children().addClass('checked');
		console.log(_value);
	});
	$(_designRadio).click(function(){
		var _value = $(this).parent().find('>input').val();
		$(_designRadio).children().removeClass('checked');
		$(this).children().addClass('checked');
		console.log(_value);
	});
});



/*table add*/
   $(document).ready(function(){
	$(".add").click(function(){
    $(".addtbl01:first").clone(true).appendTo("#data_tbl")
     .find('input[type="text"]').val('').end()
		
	});
  $('.delete').click(function(){
    $(this).parents(".addtbl01").remove();
 });
}); 

/*table add*/
   $(document).ready(function(){
	$(".add02").click(function(){
    $(".addtbl02:first").clone(true).appendTo("#data_tbl")
     .find('input[type="text"]').val('').end()
  });
  $('.delete02').click(function(){
    $(this).parents(".addtbl02").remove();
 });
}); 

/*table add*/
   $(document).ready(function(){
	$(".add03").click(function(){
    $(".addtbl03:first").clone(true).appendTo("#data_tbl")
     .find('input[type="text"]').val('').end()
  });
  $('.delete03').click(function(){
    $(this).parents(".addtbl03").remove();
 });
}); 



/*input file*/
$(document).ready(function(){
  var fileTarget = $('.filebox .upload-hidden');

    fileTarget.on('change', function(){
        if(window.FileReader){
            var filename = $(this)[0].files[0].name;
        } else {
            var filename = $(this).val().split('/').pop().split('\\').pop();
        }

        $(this).siblings('.upload-name').val(filename);
    });
}); 

