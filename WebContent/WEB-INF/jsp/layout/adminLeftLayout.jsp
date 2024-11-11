<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- <style>
.nav-sidebar {
    position: absolute;
    z-index: 20;
    top: 50px;
    left: -80px;
    overflow: hidden;
    width: 80px;
    height: 100%;
    background: #fbfcff;
    overflow: auto;
    left: 0px;
}
ul, li {
    padding: 0;
}
ol, ul {
    list-style: none;
}
.nav-list{
    padding-top: 30px;
}
.nav-list li {
    width: 100%;
    font-size: 13px;
    text-align: center;
    height: 50px;
}
.nav-list li:nth-child(1) > a, .nav-list li:nth-child(2) > a, .nav-list li:nth-child(3) > a, .nav-list li:nth-child(4) > a, .nav-list li:nth-child(5) > a {
    padding: 35px 0 5px;
}
</style> -->
<script>

//초기화 및 이벤트 등록
$(document).ready(function() {
	
	window.onpopstate = function(event) {  //뒤로가기 이벤트를 캐치합니다.  
		//history.back();   
		// pushState로 인하여 페이지가 하나 더 생성되기 떄문에 한번에 뒤로가기 위해서 뒤로가기를 한번 더 해줍니다.  
		console.log('뒤로가기 체크'); 
	};
	
	init();
	
	
	 var dropdown = document.getElementsByClassName("dropdown-btn");
	 var i;
	 
	 for (i = 0; i < dropdown.length; i++) {
	   dropdown[i].addEventListener("click", function() {
	     this.classList.toggle("active");
	     var dropdownContent = this.nextElementSibling;
	     if (dropdownContent.style.display === "block") {
	       dropdownContent.style.display = "none";
	     } else {
	       dropdownContent.style.display = "block";
	     }
	   });
	 }
	 for(let i =0; i<document.getElementsByClassName("dropdown-container").length; i++){
	     var dropdownSub = document.getElementsByClassName("dropdown-container")[i].children;
	     
	     for (let j = 0; j < dropdownSub.length; j++) {
	         dropdownSub[j].addEventListener("click", function() {
	             for(let k=0; k<this.parentElement.children.length; k++){
	                 for(let l=0; l<this.parentElement.parentElement.children.length; l++){
	                     if(this.parentElement.parentElement.children[l].className === 'dropdown-container'){
	                         if(this.parentElement.parentElement.children[l] !== document.getElementsByClassName("dropdown-container")[i]){
	                             for(let m=0; m<this.parentElement.parentElement.children[l].children.length; m++){
	                                 this.parentElement.parentElement.children[l].children[m].classList.remove("active");
	                             }
	                         }
	                     }
	                 }
	                 if(this.parentElement.children[k] === this){
	                     this.parentElement.children[k].classList.toggle("active");
	                 }else{
	                     this.parentElement.children[k].classList.remove("active");
	                 }
	             }
	         })
	     };
	 }
});

function init(){
	console.log("init!!!")
	$.ajax({
		type: 'POST',
		url: "/getLeft.do",
		data: { "lcode" : 6 },
		async: false,
		dataType: "json",
		success: function( data ) {
			
			var menu = data.list;
			console.log("menu!!!",menu)
			var _html = '';
			for(var i = 0; i < menu.length; i++){
				if(menu[i].isleaf){
					if(menu[i].progrm_param == null){
						_html += '<a href=javascript:changeContents("'+menu[i].progrm_url +'")><img src="../../resources/img/icons/Icon_SidnavLi.svg" alt="depth">'+menu[i].progrm_nm+'</a>'	
					}else{
						_html += '<a href=javascript:changeContents("'+menu[i].progrm_url +'?'+menu[i].progrm_param+'")><img src="../../resources/img/icons/Icon_SidnavLi.svg" alt="depth">'+menu[i].progrm_nm+'</a>'
					}
				}else{
					if(i != 0){
						_html += '</div>'
					}
					_html += '<button class="dropdown-btn">'+menu[i].progrm_nm+'<i class="fa fa-caret-down"></i></button>'
					_html += '<div class="dropdown-container">' 
				}
				/* if(menu[i].progrm_param == null){
					_html += '<li class="has-submenu"><a href=# onClick=changeContents("'+menu[i].progrm_url +'")>'	
				}else{
					_html += '<li class="has-submenu"><a href=# onClick=changeContents("'+menu[i].progrm_url +'?'+menu[i].progrm_param+'")>'
				}
				
			 	_html += '<i class='+menu[i].progrm_class+' title='+menu[i].progrm_nm+'></i>'
				_html += '<span name='+menu[i].progrm_param+' id='+menu[i].progrm_param+'>'+menu[i].progrm_nm+'</span></a></li>' */
			}
			
			$('#admin_nav_list').html(_html);
		}
	});
}



function changeContents(url,data){
	if(data == null){
		data = {"tile" : "tile"};
	}
	 $.ajax({
		//type		:	"get",
		url			:	 url,
		datatype	:	'html',
		data : data,
		success		:	function(data){
			//console.log(data);
			$("#content").children().remove();
			$("#content").html(data);
			
			//접속 URL만 페이지 변환없이 변경
			// IE 10 이상에서만 지원
			history.pushState({"html":data},'',url);
		
			
			/* url = contextPath + url;
			let pageUrl = url.replace('.do',"Page.do")
			history.pushState({"html":data},'',pageUrl)  */
		}
		, beforeSend: function(){
			
		},error: function(request,status,error){
			alert("code = "+ request.status + " message = " + request.responseText + " error = " + error);
			if(request.status=='404'){
				alert("페이지를 찾을수 없습니다.");
			}else{
				//window.location.href = contextPath+'/admin/loginform.do';
			}
		},complete:function(){
			
		}
		
	}); 
}	 
</script>

<div class="leftMenu">
    <div class="leftTop">
        <img src="${pageContext.request.contextPath}../../resources/img/icons/Icon_NavManager.svg" alt="map"> 시스템 관리
    </div>
    <div class="sidenav" id="admin_nav_list">
       
    </div>
</div>
<%-- <div class="nav-sidebar">
	<ul class="nav-list" data="test" id="admin_nav_list">
	
		<c:forEach var="item1" items="${menu}">
			<li class="has-submenu">
				<a href="${item1.progrm_url}?${item1.progrm_param}" onclick='javascript:${item1.pop_func};'><i class="${item1.progrm_class}" title='${item1.progrm_nm}'></i>
					<span name="${item1.progrm_param}" id="${item1.progrm_param}">${item1.progrm_nm}</span>
				</a>
			</li>
		</c:forEach>
	</ul>
</div> --%>
