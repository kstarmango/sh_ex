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
                        <%=request.getParameter("userId")%> <input type="hidden" name="userId" id="userId" value="<%=request.getParameter("userId")%>"/>
                        <input type="password" class="input_box width_80p mb_20" placeholder="현재 비밀번호" name="cpw" id="cpw"/>  
                        <input type="password" class="input_box width_80p mb_20" placeholder="변경 비밀번호" name="npw" id="npw"/>  
                        <input type="password" class="input_box width_80p mb_20" placeholder="비밀번호 확인" name="npwchk" id="npwchk"/>  
                        <button class="blue_btn02 width_80p" ><a href="#a" data-modal-id="popup3">확인</a></button>                     
                    </div>
                   </div>
                  </div>
                  </div>
                </div>
               </div>
             </body>
                  




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

		frm.action = "/sso/testPwd.jsp";
		frm.submit();
	}
</script>
</html>