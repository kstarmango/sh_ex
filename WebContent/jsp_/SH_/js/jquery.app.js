
(function ($) {

    'use strict';

    function initNavbar() {

        $('.navbar-toggle').on('click', function (event) {
            $(this).toggleClass('open');
            $('#navigation').slideToggle('fast');
        });

        $('.navigation-menu>li').slice(-2).addClass('last-elements');

        $('.navigation-menu li.has-submenu a[href="#"]').on('click', function (e) {
            if ($(window).width() < 992) {
                e.preventDefault();
                $(this).parent('li').toggleClass('open').find('.submenu:first').toggleClass('open');
            }
        });
    }

    function init() {
        initNavbar();
    }

    init();

})(jQuery);


$(document).ready(function () {

    // === following js will activate the menu in left side bar based on url ====
    $(".navigation-menu a").each(function () {
        if (this.href == window.location.href) {
            $(this).parent().addClass("active"); // add active to li of the current link
            $(this).parent().parent().parent().addClass("active"); // add active class to an anchor
            $(this).parent().parent().parent().parent().parent().addClass("active"); // add active class to an anchor
        }
    });

    // ajax 통신 중 로딩 바
    // 현재 페이지에서 ajax 통신이 시작될 경우 실행될 이벤트
    $(document ).ajaxStart(function() {
        // 로딩 바 이미지를 띄우고
        $('#load').show();
    }).ajaxStop(function() {
        // 로딩 바 태그와 이미지를 모두 hide 처리
        $('#load').hide();
    });
    
    

});
