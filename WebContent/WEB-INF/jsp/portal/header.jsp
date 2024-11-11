<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.Property"%> 
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%> 
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />

<script src="<c:url value='/resources/js/portal/init.js'/>"></script>
<script>
// 브라우저 및 버전을 구하기 위한 변수들.
var agent = navigator.userAgent.toLowerCase(),
    name = navigator.appName,
    browser;

checkBrowser();


var global_props = { 
		vworldKey 		: '<%=Property.vworldKey %>',  
		wmsProxyUrl 	: '${contextPath}<%=Property.wmsProxyUrl %>',
		geoserverDomain : '<%=Property.geoserverDomain %>',
		pinogeoUrl 		: '<%=Property.pinogeoUrl %>',
		roadUrl 		: '<%=Property.roadUrl %>',
		vworldAddrUrl 	: '<%=Property.vworldAddrUrl %>',
		roadUrlKey 		: '<%=Property.roadUrlKey %>',
		domain 			: '${contextPath}'
	}

function getContextPath() {
	var hostIndex = location.href.indexOf( location.host ) + location.host.length;
	return location.href.substring( hostIndex, location.href.indexOf('/', hostIndex + 1) );
};

$(document).ready(function(){
	
	//global_props.domain = getContextPath();
	jQuery.fn.center = function () {
	
		this.css("position","absolute");
		this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()) + "px");
		this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()) + "px");
		return this;
	};

   	if (!String.prototype.padStart) {
   	    String.prototype.padStart = function padStart(targetLength,padString) {
   	        targetLength = targetLength>>0;
   	        padString = String((typeof padString !== 'undefined' ? padString : ' '));
   	        if (this.length > targetLength) {
   	        	console.log("header1")
   	            return String(this);
   	        } else {
   	            targetLength = targetLength-this.length;
   	            if (targetLength > padString.length) {
   	                padString += padString.repeat(targetLength/padString.length);
   	            }
   	            return padString.slice(0,targetLength) + String(this);
   	        }
   	    };
   	}

	// 상세페이지 이동
	$("#MyPwdChangeOpen").click(function() {
		$.ajax({
			type : "POST",
			async : false,
			url : "<%= RequestMappingConstants.WEB_MNG_USER_DETAIL %>",
			dataType : "json",
			data : {id: '${sesUserId}'},
			error : function(response, status, xhr){
				if(xhr.status =='403'){
					$("#myDetail").hide();
					alert('사용자 상세 데이터 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
				}
			},
			success : function(data) {
		        if(data.result == "Y") {
		        	$('#my_user_id').text(data.userInfo.user_id);
		        	$('#my_user_nm').text(data.userInfo.user_nm);
		        	$('#my_dept_nm').text(data.userInfo.dept_nm);
		        	$('#my_telno').text(data.userInfo.telno);
		        	$('#my_ins_dt').text(data.userInfo.ins_dt);
		        	$('#my_upd_dt').text(data.userInfo.upd_dt);
		        	$('#my_p_auth_no').text(data.userInfo.p_auth_desc);
		        	$('#my_l_auth_no').text(data.userInfo.l_auth_desc);

		        	$("#myDetail").center();
		        	$("#myDetail").show();
		        }
			}
		});
	});

	// 암호 validate
	$('#MyPwdChangeForm').validate({
		onsubmit: false,
		rules:{
			my_user_pass: {
			  required: true,
			  identicalConsecutively: true,
			  rangelength: [7,15]
			},
			my_re_user_pass: {
				required: true,
			  	equalTo: "#user_pass"
			}
		},
		messages:{
			my_user_pass: {
				required: "비밀번호를 입력해 주세요.",
				identicalConsecutively:"동일한 숫자 및 문자를 연속해서 4번이상 사용하실 수 없습니다.",
				rangelength: "비밀번호는 7~15자 이내입니다."
			},
			my_re_user_pass: {
				required: "비밀번호를 재입력해 주세요.",
				equalTo: "동일한 비밀번호가 아닙니다."
			}
		}
	});

	// 암호 변경
	var editMode = false;
	$('#MyPwdChangeReq').click(function(e) {
		if(editMode == false) {
       		$('#my_user_pass').attr('disabled', false);
       		$('#my_re_user_pass').attr('disabled', false);
       		$('#MyPwdChangeReq').text('비밀번호 적용');
       		editMode = true;
       		return;
		}
		else
		{
			// 패스워드 valid
			if($("#MyPwdChangeForm").valid())
			{
				// 패스워드 재사용 여부 체크
				$.ajax({
					type : "POST",
					async : false,
					url : "${contextPath}<%= RequestMappingConstants.WEB_MNG_USER_PWD_DUP %>",
					dataType : "json",
					data : {
						id: $('#my_user_id').text(),
						pwd: $('#my_user_pass').val(),
						length: 7
					},
					error : function(response, status, xhr){
						if(xhr.status =='403'){
							alert('암호 변경 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
						}
					},
					success : function(data) {
				        if(data.result != "Y") {
				        	// 패스워드 변경
							$.ajax({
								type : "POST",
								async : false,
								url : "${contextPath}<%= RequestMappingConstants.WEB_MNG_USER_PWD %>",
								dataType : "json",
								data : {
									id: $('#my_user_id').text(),
									pwd: $('#my_user_pass').val(),
									length: 7
								},
								error : function(response, status, xhr){
									if(xhr.status =='403'){
										alert('암호 변경 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
									}
								},
								success : function(data) {
							        if(data.result == "Y" && data.userInfo == "1" && data.newPwd != "") {
							        	$('#MyPwdChangeClose').trigger("click");
							        	alert('암호 변경이 정상적으로 완료 되었습니다.');
							        }
								}
							});
				        }
				        else
			        	{
				        	$("#MyPwdChangeForm")[0].reset();
				        	alert('동일한 암호를 사용할 수 없습니다.');
			        	}
					}
				});
			}
		}
	});

	// 사용자 상세 - 닫기
	$('#MyPwdChangeClose').click(function(e) {
      		$('#my_user_pass').attr('disabled', true);
      		$('#my_re_user_pass').attr('disabled', true);

      		$('#MyPwdChangeReq').text('비밀번호 변경');
      		editMode = false;

		$("#MyPwdChangeForm")[0].reset();

		$('#myDetail').hide();
	});

	// 관리자에 의한 초기화 시 - 패스워드 변경 필요 여부 체크
	$.ajax({
		type : "POST",
		async : false,
		url : "${contextPath}<%= RequestMappingConstants.WEB_MNG_USER_PWD_RST %>",
		dataType : "json",
		data : {id: '${sesUserId}'},
		error : function(response, status, xhr){
			if(xhr.status =='403'){
			}
		},
		success : function(data) {
	        if(data.result == "Y") {
	        	alert('임시 생성된 패스워드 이므로 반드시${contextPath}<%=RequestMappingConstants.WEB_MNG_USER_PWD_NUM%>${contextPath}<%=RequestMappingConstants.WEB_MNG_USER_PWD_UNIT_KOR%> 내에 변경 하셔야 합니다.');
	        	$('#my_user_pass').attr('disabled', false);
        		$('#my_re_user_pass').attr('disabled', false);
        		$('#MyPwdChangeReq').text('비밀번호 적용');
        		editMode = true;
	        	$("#MyPwdChangeOpen").trigger('click');
	        }
		}
	});

	// 공지사항 및 질의응답 최근 글 알림 체크
	<%-- $.ajax({
		type : "POST",
		async : false,
		url : "<%= RequestMappingConstants.WEB_NOTICE_CHECK_NEW %>",
		dataType : "json",
		data : {},
		error : function(response, status, xhr){
			if(xhr.status =='403'){
			}
		},
		success : function(data) {
	        if(data.result == "Y") {
	        	for(i=0; i < data.isNew.length; i++) {
	        		if(data.isNew[i].item != '' && data.isNew[i].val == 'Y'){
	        			 var menuNm = $("span[name*='" + data.isNew[i].item + "']").text();
	        			 if(menuNm != undefined)
	        			 	$("span[name*='" + data.isNew[i].item + "']").html(menuNm +'<img src="/jsp/SH/img/ico_new.png" alt="새글아이콘" title="새글">');
	        		}
	        			
	        	}
	        	
	        }
		}
	}); --%>

	<%--사용 X if('<%= request.getParameter("theme") %>' == 'geoCoding') {
		//menuGeocoding();
	} --%>
});

	// 로그 - 레이어 이력
	function layerUseLog(layer_no) {
		$.ajax({
			type : "POST",
			async : true,
			url : "${contextPath}<%= RequestMappingConstants.API_LOG_LAYER %>",
			dataType : "json",
			data : {
				layer_no: layer_no
			},
			error : function(response, status, xhr){
				if(xhr.status =='403'){
				}
			},
			success : function(data) {
		        if(data.result == "Y") {
		        	console.log('레이어 조회 이력 등록 성공');
		        }
			}
		});
	}

	// 로그 - 데이터 이력
	function dataUseLog(layer_no) {
		$.ajax({
			type : "POST",
			async : true,
			url : "${contextPath}<%= RequestMappingConstants.API_LOG_DATA %>",
			dataType : "json",
			data : {
				layer_no: layer_no
			},
			error : function(response, status, xhr){
				if(xhr.status =='403'){
				}
			},
			success : function(data) {
		        if(data.result == "Y") {
		        	console.log('데이터 조회 이력 등록 성공');
		        }
			}
		});
	}

	// 로그 - 다운로드 이력
	function downUseLog(layer_no) {
		$.ajax({
			type : "POST",
			async : true,
			url : "${contextPath}<%= RequestMappingConstants.API_LOG_DOWNLOAD %>",
			dataType : "json",
			data : {
				layer_no: layer_no
			},
			error : function(response, status, xhr){
				if(xhr.status =='403'){
				}
			},
			success : function(data) {
		        if(data.result == "Y") {
		        	console.log('데이터 다운 이력 등록 성공');
		        }
			}
		});
	}

	// 로그 - 메뉴 이력
	function menuUseLog(progrm_url) {
		$.ajax({
			type : "POST",
			async : true,
			url : "${contextPath}<%= RequestMappingConstants.API_LOG_PROGRM %>",
			dataType : "json",
			data : {
				progrm_url: progrm_url
			},
			error : function(response, status, xhr){
				if(xhr.status =='403'){
				}
			},
			success : function(data) {
		        if(data.result == "Y") {
		        	console.log('프로그램 사용 이력 등록 성공');
		        }
			}
		});
	}

		// 메뉴 - 주소변환
		function menuGeocoding()
		{
			console.log("fn주소변환!!")
			if($('#boardList').length > 0) {
				location.href = '${contextPath}<%= RequestMappingConstants.WEB_GIS %>?theme=geoCoding';
				return;
			}

			if($("#dashboard").css("display") == "block"){
				$("#dashboard").hide();
			}
			if($("#theme").css("display") == "block"){
				$("#theme").hide();
			}

			if($("#geocoding-mini").css("display") == "none"){
				$("#geocoding-mini").show();
				menuUseLog('${contextPath}<%= RequestMappingConstants.WEB_GEOCODE %>');
			}else{
				$("#geocoding-mini").hide();
			}
		}
	</script>
	<a href="${pageContext.request.contextPath}/web/main.do"><img class="logo" src="${pageContext.request.contextPath}/resources/img/map/logo.svg" alt="SH서울주택도시공사 로고"></a>
    <nav>
        <ul>
            <li class="hover" onClick="location.href='${pageContext.request.contextPath}/web/main.do'">
                <img src="${pageContext.request.contextPath}/resources/img/map/icNav01.svg" alt="지도 아이콘">
                <span>지도</span>
            </li>
            <li onClick="location.href='${pageContext.request.contextPath}/web/portal/notice.do?boardType=CD00000002&NotiYn=NOTI_NEW_YN'">
                <img src="${pageContext.request.contextPath}/resources/img/map/icNav02.svg" alt="게시판 아이콘">
                <span>게시판</span>
            </li>
            <c:if test="${sesUserAdminYn eq 'Y'}" var="nameHong" scope="session">
            	<li onClick="location.href='${pageContext.request.contextPath}/web/admin/mngUser.do'">
	                <img src="${pageContext.request.contextPath}/resources/img/map/icNav03.svg" alt="관리자 아이콘">
	                <span>관리자</span>
	            </li>
            </c:if>
            <li style="cursor: default;">
                <img src="${pageContext.request.contextPath}/resources/img/map/icNav04.svg" alt="user아이콘">
                <span> ${sesUserPosition}/${sesUserName}</span>
            </li>
        </ul>
    </nav>