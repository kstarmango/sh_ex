<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	if (session.getAttribute("SSO_ID") != null && !session.getAttribute("SSO_ID").equals("")) {
		response.sendRedirect("/portal/main.jsp");  // edit
	}
%>
<!doctype html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" type="text/css" href="css/msso_style.css">	
<!--[if lte IE 8 ]>
<link rel="stylesheet" type="text/css" href="css/layout_ie8.css">
<script type="text/javascript" src="js/poly-checked.js"></script>
<![endif]-->
<script src="js/jquery-3.5.1.min.js"></script>
<script src="js/jquery-1.11.1.min.js"></script>
<script src="js/common.js"></script>
<script src="js/jquery-nav.js"></script>
<script src="js/jquery-select.js"></script>
<script src="js/jquery-autoclear.min.js"></script>
<script src="js/jquery.tablesorter.min.js"></script>
<title>Magic SSO - Login</title>

</head>

<body>
<div class="wrap">
    <div class="con_wrap">
        <div class="contents_box02">
            <div class="login_area">
                <div class="login_box">                       
                    <div class="login_tit"><img src="images/login_logo.png" alt="Magic SSO"><br/></div>
                    <div class="input_wrap02">
	        <form name="loginForm" id="loginForm" method="post">
		<input type="hidden" id="RelayState" name="RelayState" value=""/>
                        <input type="text" class="input_box width_80p mb_10" placeholder="ID" name="loginId" id="loginId"/>
                        <input type="password" class="input_box width_80p mb_20" placeholder="PW" name="loginPw" id="loginPw"/>  
                        <button class="blue_btn02 width_80p" ><a href="#a" data-modal-id="popup3">로그인</a></button>                     
                    </div>
                    <div class="noti_wrap width_80p">
                        <span class="float_left"><input type="checkbox" id="01" name="지급상태" value="02"><label for="01"><span></span></label> ID 저장하기</span>
                        <span class="find_pw_box float_right"><a href="#a" data-modal-id="popup1">아이디 찾기</a> / <a href="#a" data-modal-id="popup2">비밀번호 찾기</a></span>
                    </div>
                    <div class="add_wrap width_80p">
                        <span class="add_box float_right"><button class="blue_btn_line02 width_80p"><a href="#a" data-modal-id="">사용자 등록</a></button></span>
                    </div>
                    <div class="clear"></div>
                </div>

            </div>
            <div class="contact_noti">
                <span>Copyright ⓒ Dream Security Co.,Ltd. All rights reserved.</span>
            </div>
        </div>
    </div>
</div>
   

</body>

<!--alert01-->
<div id="popup1" class="modal-box-al">
	<div class="modal_header">
        <p class="modal_tit">아이디 찾기</p>
        <p class="modal_sub">입력하신 담당자명과 고객사 ID에 등록되어 있는 Email이 일치하는 경우 Email로 아이디 정보가 발송 됩니다.</p>
	</div>
	<div class="modal_body">
		<div class="modal_col_tr">
            <span class="modal_con_tit width_80">담당자 이름</span><input type="text" class="input_box width_40p"/><span class="width_10"></span>
        </div>
        <div class="modal_col_tr">
            <span class="modal_con_tit width_80">Email</span><input type="text" class="input_box width_40p"/><span class="width_10"></span>
		</div>
	</div>
	<div class="modal_footer">
		   <div class="modal_footer_box">
		   <!--버튼-->
				<span class="pop_btn blue_btn_line width_160 "><a class="js-modal-close">취소</a></span><span class="width_30"></span>
				<span class="pop_btn blue_btn02 width_160 "><a class="#a">아이디 확인 요청</a></span>
	 	   <!--//버튼-->
		   </div>
	</div>
</div>

<!--alert02-->
<div id="popup2" class="modal-box-al">
	<div class="modal_header">
        <p class="modal_tit">비밀번호 찾기</p>
        <p class="modal_sub">고객사 정보가 확인되면 가입된 이메일로 비밀번호가 발송됩니다.</p>
	</div>
	<div class="modal_body">
		<div class="modal_col_tr">
            <span class="modal_con_tit width_80">아이디</span><input type="text" class="input_box width_40p"/><span class="width_10"></span>
        </div>
        <div class="modal_col_tr">
            <span class="modal_con_tit width_80">사업자 번호</span><input type="number" class="input_box width_40p" placeholder="-없이 입력해 주시기 바랍니다."/><span class="width_10"></span>
		</div>
	</div>
	<div class="modal_footer">
		   <div class="modal_footer_box">
		   <!--버튼-->
				<span class="pop_btn blue_btn_line width_160 "><a class="js-modal-close">취소</a></span><span class="width_30"></span>
				<span class="pop_btn blue_btn02 width_160 "><a class="#a">비밀번호 확인 요청</a></span>
	 	   <!--//버튼-->
		   </div>
	</div>
</div>

<!--alert03-->
<div id="popup3" class="modal-box-al">
	<div class="modal_header">
        <p class="modal_tit">로그인 실패</p>
	</div>
	<div class="modal_body">
		<div class="modal_con">
            <span class="modal_con_tit02 width_80p">아이디 혹은 비밀번호가 올바르지 않습니다.</span>
        </div>
	</div>
	<div class="modal_footer">
		   <div class="modal_footer_box">
		   <!--버튼-->
				<span class="pop_btn blue_btn02 width_160 "><a class="js-modal-close">확인</a></span>
	 	   <!--//버튼-->
		   </div>
	</div>
</div>





<script>
    document.onkeypress = getKey;

    var slideIndex = 1;
    showSlides(slideIndex);
    
    function plusSlides(n) {
      showSlides(slideIndex += n);
    }
    
    function currentSlide(n) {
      showSlides(slideIndex = n);
    }
    
    function showSlides(n) {
      var i;
      var slides = document.getElementsByClassName("mySlides");
      var dots = document.getElementsByClassName("sl_dot");
      if (n > slides.length) {slideIndex = 1}    
      if (n < 1) {slideIndex = slides.length}
      for (i = 0; i < slides.length; i++) {
          slides[i].style.display = "none";  
      }
      for (i = 0; i < dots.length; i++) {
          dots[i].className = dots[i].className.replace(" active", "");
      }
      slides[slideIndex-1].style.display = "block";  
      dots[slideIndex-1].className += " active";
    }

	function getKey(keyStroke)
	{
		if (window.event.keyCode == 13)
			loginStart();
	}

	function loginStart()
	{
		var frm = document.getElementById("loginForm");

		frm.action = "/sso/RequestAuth.jsp";
		frm.submit();
	}
</script>
</html>