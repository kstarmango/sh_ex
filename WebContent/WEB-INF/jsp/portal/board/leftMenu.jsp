<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />


<script type="text/javascript">
//초기화 및 이벤트 등록
$(document).ready(function() {
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
	$.ajax({
		type: 'POST',
		url: "${contextPath}/getLeft.do",
		data: { "lcode" : "40" },
		async: false,
		dataType: "json",
		success: function( data ) {
			
			var menu = data.list;
			console.log("menu!!!",menu)
			var _html = '';
			for(var i = 0; i < menu.length; i++){
				if(menu[i].isleaf){
					if(i == 0) _html += '<div class="dropdown-container" style="display:block;">' 
					if(menu[i].progrm_param == null){
						_html += '<a href=javascript:changeContents("'+menu[i].progrm_url +'")><img src="../../resources/img/icons/Icon_SidnavLi.svg" alt="depth"/>'+menu[i].progrm_nm+'</a>'	
					}else{
						_html += '<a href=javascript:changeContents("'+menu[i].progrm_url +'?'+menu[i].progrm_param+'")><img src="../../resources/img/icons/Icon_SidnavLi.svg" alt="depth" />'+menu[i].progrm_nm+'</a>'
					}
					
					if(i != 0) _html += '</div>' 
				}else{
					if(i != 0){
						console.log("ddd",menu[i].progrm_nm)
						_html += '</div>'
					}
					_html += '<button class="dropdown-btn">'+menu[i].progrm_nm+'<i class="fa fa-caret-down"></i></button>'
					_html += '<div class="dropdown-container">' 
				}
			}
			
			$('#nav_list').html(_html);
		}
	});
}
function alert_msg(){
	alert("현재 개발중인 관계로 서비스를 실행할 수 없습니다.");
}
function changeContents(url){
	
	 $.ajax({
		//type		:	"get",
		url			:	 url,
		datatype	:	'html',
		data : {"tile" : "tile"},
		success		:	function(data){
			//console.log(data);
			$("#content").children().remove();
			$("#content").html(data);
			history.pushState({"html":data},'',url);
			//접속 URL만 페이지 변환없이 변경
			// IE 10 이상에서만 지원
			//history.pushState({"html":data},'',url)
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
        <img src="${pageContext.request.contextPath}../../resources/img/icons/Icon_NavManager.svg" alt="map" /> 게시판
    </div>
    <div class="sidenav" id="nav_list">
       
    </div>
</div>
