<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />

<script>
function hiddenAll(){
	var dropdown = document.getElementsByClassName("group");
	$('.group').removeClass("hover"); 
	for (i = 0; i < dropdown.length; i++) {
		dropdown[i].lastElementChild.classList.remove("active");
	}
}
//초기화 및 이벤트 등록
$(document).ready(function() {
	init();
	var dropdown = document.getElementsByClassName("group");
	var i;
	var status = true;
	var id = null
	
	for (i = 0; i < dropdown.length; i++) {
		dropdown[i].addEventListener("click", function(e) {
			if (e.currentTarget == e.target) {
				var dropdownContent = this.lastElementChild;
				if (!this.classList.contains('hover')) { //대메뉴가 활성화 되어있지 않을 경우
					hiddenAll()
					this.classList.toggle("hover");
				}
				dropdownContent.classList.toggle("active");	
			}
		});
	}

	const urlParams = new URL(location.href).searchParams;
	if(urlParams.get('get')){
		const leftMenu = $('.leftMenu');
		if(urlParams.get('get') === 'biz'){
			gfn_btnClickStyle(this);
			changeContents("/web/link/biz.do?progrm_no=PROGRM00000000000049");
			
			leftMenu[0].firstElementChild.classList.add('hover');
			leftMenu[0].firstElementChild.children[1].classList.add('active');
			leftMenu[0].firstElementChild.children[1].children[0].classList.add('hover');
		}else if(urlParams.get('get') === 'bld'){
			gfn_btnClickStyle(this);
			changeContents("/link/bld.do?progrm_no=PROGRM0000000000005");

			leftMenu[0].firstElementChild.classList.add('hover');
			leftMenu[0].firstElementChild.children[1].classList.add('active');
			leftMenu[0].firstElementChild.children[1].children[1].classList.add('hover');
		}else if(urlParams.get('get') === 'hous'){
			gfn_btnClickStyle(this);
			changeContents("/link/hous.do?progrm_no=PROGRM00000000000051");

			leftMenu[0].firstElementChild.classList.add('hover');
			leftMenu[0].firstElementChild.children[1].classList.add('active');
			leftMenu[0].firstElementChild.children[1].children[2].classList.add('hover');
		}
	}
	
});
function init(){
	$.ajax({
		type: 'POST',
		url: "${contextPath}/getLeft.do",
		data: { "lcode" : "39" },
		async: false,
		dataType: "json",
		success: function( data ) {
			
			var menu = data.list;

			for(var i = 0; i < menu.length; i++){
				if(!menu[i].isleaf){
					var _html = '';
					_html += '<li class="group" value="group">'
					_html += 	'<span>'+menu[i].progrm_nm+'</span>'
					_html += 	'<ul class="subMenu" id='+menu[i].progrm_no+'></ul>'
					_html += '</li>'
					$('#nav_list').append(_html);
				}else{ //리프일 때
					var _html = '';
					_html += '<li id='+menu[i].progrm_no+' onClick=initAnalService();gfn_btnClickStyle(this);changeContents("${contextPath}'+menu[i].progrm_url+'?progrm_no='+menu[i].progrm_no+'")>'+menu[i].progrm_nm+'</li>'
					$('#'+menu[i].p_progrm_no).append(_html);
				}
			}
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
			$("#sub_content").children().remove();
			$("#sub_content").html(data);

			removeLinkLayer();
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

function removeLinkLayer () {
	if(geoMap){		
		const titleList = ['사업기획 레이어', '건축물 레이어', '빈집 레이어','경과년수 10년 미만 현황', '경과년수 10년 이상 20년 미만 현황', '경과년수 20년 이상 현황','빈집매입 현황','analInputLayer'];
		const linkLayerList = geoMap.getLayers().getArray().filter(lyr => titleList.indexOf(lyr.get('title')) !== -1);
		
		if(linkLayerList.length > 0){
			for(let lyr of linkLayerList){
				if(lyr.get('title') === '사업기획 레이어'){
					geoMap.removeOverlay(geoMap.getOverlayById('biz_overlay'));
					geoMap.removeLayer(geoMap.getLayers().getArray().filter(lyr => lyr.get('title') === 'biz_buffer')[0]);
				}else{
					if(document.getElementsByClassName('bldFeatureInfoPop').length > 0){						
        	    		document.getElementsByClassName('bldFeatureInfoPop')[0].style.display = 'none';
					}else if(document.getElementsByClassName('housFeatureInfoPop').length > 0){						
	        	    	document.getElementsByClassName('housFeatureInfoPop')[0].style.display = 'none';
					}
				}
				for(let interaction of geoMap.getInteractions().getArray()){
					if(interaction instanceof ol.interaction.Select){
						geoMap.removeInteraction(interaction);
					}
				}
				geoMap.removeLayer(lyr);
			}
		}
	}
}
</script>

<ul class="leftMenu" id="nav_list">
</ul>

<!-- <div class="nav-sidebar">
	<ul class="nav-list" id="map_nav_list">
	
	</ul>
</div> -->
