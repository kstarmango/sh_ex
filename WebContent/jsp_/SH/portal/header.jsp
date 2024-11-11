
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page
	import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

<script type="text/javascript">

		$(document).ready(function(){

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
							url : "<%= RequestMappingConstants.WEB_MNG_USER_PWD_DUP %>",
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
										url : "<%= RequestMappingConstants.WEB_MNG_USER_PWD %>",
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
				url : "<%= RequestMappingConstants.WEB_MNG_USER_PWD_RST %>",
				dataType : "json",
				data : {id: '${sesUserId}'},
				error : function(response, status, xhr){
					if(xhr.status =='403'){
					}
				},
				success : function(data) {
			        if(data.result == "Y") {
			        	alert('임시 생성된 패스워드 이므로 반드시<%=RequestMappingConstants.WEB_MNG_USER_PWD_NUM%><%=RequestMappingConstants.WEB_MNG_USER_PWD_UNIT_KOR%> 내에 변경 하셔야 합니다.');
			        	$('#my_user_pass').attr('disabled', false);
		        		$('#my_re_user_pass').attr('disabled', false);
		        		$('#MyPwdChangeReq').text('비밀번호 적용');
		        		editMode = true;
			        	$("#MyPwdChangeOpen").trigger('click');
			        }
				}
			});

			// 공지사항 및 질의응답 최근 글 알림 체크
			$.ajax({
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
			});

			if('<%= request.getParameter("theme") %>' == 'geoCoding') {
				menuGeocoding();
			}
		});

		// 로그 - 레이어 이력
		function layerUseLog(layer_no) {
			$.ajax({
				type : "POST",
				async : true,
				url : "<%= RequestMappingConstants.API_LOG_LAYER %>",
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
				url : "<%= RequestMappingConstants.API_LOG_DATA %>",
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
				url : "<%= RequestMappingConstants.API_LOG_DOWNLOAD %>",
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
				url : "<%= RequestMappingConstants.API_LOG_PROGRM %>",
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

		// 메뉴 - 대시보드
		function menuDashboard()
	 	{
			if($('img[id^=dashboard_img]').length == 0) {
				alert('등록된 대시보드 정보가 없습니다.');
				return;
			}

			if($("#theme").css("display") == "block"){
				$("#theme").hide();
			}
			if($("#geocoding-mini").css("display") == "block"){
				$("#geocoding-mini").hide();
			}

			$("#dashboard").css('top', '114px');
			if($("#dashboard").css("display") == "none"){
				$("#dashboard").show();

				menuUseLog('<%= RequestMappingConstants.WEB_DASHBOARD%>');
			}else{
				$("#dashboard").hide();
			}
	 	}

		// 메뉴 - 주제도면
		function menuTheme()
	 	{
			console.log("들어옴");
			if($("#theme").height() > $("body").height()) {
				$('html').css("overflow","hidden");
				$("#theme").css('overflow-y', 'auto');
			} else {
				$("#theme").css('overflow-y', '');
			}

			if($("#dashboard").css("display") == "block"){
				$("#dashboard").hide();
			}
			if($("#geocoding-mini").css("display") == "block"){
				$("#geocoding-mini").hide();
			}

			$("#theme").css('top', '114px');
			$("#themeDetail").css('top', '114px');
			$("#themeAdd").css('top', '114px');
			if($("#theme").css("display") == "none"){
				$("#theme").show();

				menuUseLog('<%= RequestMappingConstants.WEB_THEME%>');
				console.log("menuUseLog : " , menuUseLog('<%= RequestMappingConstants.WEB_THEME%>'));
			}else{
				$("#theme").hide();
			}
	 	}

		// 메뉴 - 주소변환
		function menuGeocoding()
		{
			if($('#boardList').length > 0) {
				location.href = '<%= RequestMappingConstants.WEB_GIS %>?theme=geoCoding';
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

				menuUseLog('<%= RequestMappingConstants.WEB_GEOCODE %>');
			}else{
				$("#geocoding-mini").hide();
			}
		}

	    // 브라우저 및 버전을 구하기 위한 변수들.
	    var agent = navigator.userAgent.toLowerCase(),
	        name = navigator.appName,
	        browser;

		function checkBrowser(){ // 외부 라이브러리와 충돌을 막고자 모듈화.


		    // MS 계열 브라우저를 구분하기 위함.
		    if(name === 'Microsoft Internet Explorer' || agent.indexOf('trident') > -1 || agent.indexOf('edge/') > -1) {
		        browser = 'ie';
		        if(name === 'Microsoft Internet Explorer') { // IE old version (IE 10 or Lower)
		            agent = /msie ([0-9]{1,}[\.0-9]{0,})/.exec(agent);
		            browser += parseInt(agent[1]);
		        } else { // IE 11+
		            if(agent.indexOf('trident') > -1) { // IE 11
		                browser += 11;
		            } else if(agent.indexOf('edge/') > -1) { // Edge
		                browser = 'edge';
		            }
		        }
		    } else if(agent.indexOf('safari') > -1) { // Chrome or Safari
		        if(agent.indexOf('opr') > -1) { // Opera
		            browser = 'opera';
		        } else if(agent.indexOf('chrome') > -1) { // Chrome
		            browser = 'chrome';
		        } else { // Safari
		            browser = 'safari';
		        }
		    } else if(agent.indexOf('firefox') > -1) { // Firefox
		        browser = 'firefox';
		    }

		    // IE: ie7~ie11, Edge: edge, Chrome: chrome, Firefox: firefox, Safari: safari, Opera: opera
		}

		checkBrowser();
	</script>

<!-- Navigation Bar-->
<header id="topnav" class="map">
	<div class="topbar-main">

		<div class="container">

			<!-- Logo container-->
			<div class="logo">
				<!-- Image Logo -->
				<a href="/web/portal/gis.do" class="logo"
					title='SH서울주택도시공사  토지자원관리시스템'> <img
					src="/jsp/SH/img/sh_logo.png" alt="SH서울주택도시공사" height="48">
					<span class="v-bar"></span> <img src="/jsp/SH/img/logo.png"
					alt="토지자원관리시스템" height="19">
				</a>
			</div>
			<!-- End Logo container-->

			<div class="menu-extras">

				<ul class="nav navbar-nav navbar-right pull-right">

					<li class="dropdown navbar-c-items"><a
						class="dropdown-toggle waves-effect waves-light profile"
						data-toggle="dropdown" aria-expanded="true">
							<div class="text-white" id='MyPwdChangeOpen'
								style='cursor: pointer' title='내 정보 수정'>
								<i class="fa fa-user fa-fw"> </i><b class="top-nav-text"> <c:out
										value="${sesUserName}"></c:out>(<c:out
										value="${sesUserPosition}"></c:out>)
								</b>
							</div>
					</a></li>

					<li class="navbar-c-items">
						<!-- <a href="/actionLogout.do" class="right-menu-item"> --> <!-- <a href="/web/cmmn/logout.do" class="right-menu-item"> -->
						<a href="<%=RequestMappingConstants.WEB_LOGOUT%>"
						class="right-menu-item" title='로그아웃'> <span><i
								class="fa fa-power-off fa-fw m-r-5"></i>로그아웃</span>
					</a>
					</li>

				</ul>

				<div class="menu-item">
					<!-- Mobile menu toggle-->
					<a class="navbar-toggle">
						<div class="lines">
							<span></span> <span></span> <span></span>
						</div>
					</a>
					<!-- End mobile menu toggle-->
				</div>

			</div>
			<!-- end menu-extras -->

		</div>
		<!-- end container -->

	</div>
	<!-- end topbar-main -->
	<div style="margin-right: 3%;">
          <span class="map_caption" style="font-size: 17px;color: #df0d1a;font-weight: 600;float: right;margin-top: 0.7%;">※아래의 지도 더블클릭시 정보조회가 가능합니다.</span>
    </div>

	<div class="navbar-custom active">
		<div class="container">
			<div id="navigation" class="active">

				<!-- Navigation Menu-->
				<ul class="navigation-menu">

					<!--
	                    <li class="has-submenu">
	                        <a href="/dashboard.do"><i class="mdi mdi-view-dashboard"></i>대시보드</a>
	                        <ul class="submenu hidden">
	                            <li><a href="/dashboard.do">대시보드</a></li>
	                        </ul>
	                    </li>

	                    <li class="has-submenu">
	                        <a href="/gisinfo_home.do"><i class="mdi mdi-magnify"></i>지도검색</a>
	                        <ul class="submenu hidden">
	                            <li><a href="/gisinfo_home.do">지도검색</a></li>
	                        </ul>
	                    </li>

	                    <li class="has-submenu">
	                        <a href="/theme_home.do"><i class="mdi mdi-image"></i>주제도면</a>
	                        <ul class="submenu hidden">
	                            <li><a href="/theme_home.do">주제도면</a></li>
	                        </ul>
	                    </li>
	                    <li class="has-submenu">
	                        <a href="/board_notice_home.do"><i class="mdi mdi-comment-text"></i>게시판</a>
	                        <ul class="submenu">
	                            <li><a href="/board_notice_home.do">공지사항</a></li>
 		                            <li><a href="/board_qna_home.do">질의응답</a></li>
	                        </ul>
	                    </li>

	                    <li class="has-submenu admin-menu">
	                        <a href="/manage_user_list.do"><i class="mdi mdi-settings"></i>시스템관리</a>
	                        <ul class="submenu">
	                            <li><a href="/manage_user_list.do">사용자 관리</a></li>
	                            <li><a href="/noticeAdminListPage.do">공지사항 관리</a></li>
	                            <li><a href="/memAccessed.do">사용자 접속현황</a></li>
	                            <li><a href="/manage_stat_home.do">시스템 현황</a></li>
	                            <li><a href="#">게시판 관리</a></li>
	                        </ul>
	                    </li>
	                    -->

					<c:forEach var="item1" items="${userTopMenu}">
						<li
							class="has-submenu ${item1.admin_yn eq 'Y' ? 'admin-menu' : '' }">
							<c:if test="${item1.pop_yn eq 'Y' && item1.pop_func ne ''}">
								<a href="#" onclick='javascript:${item1.pop_func};'><i
									class="${item1.progrm_class}" title='${item1.progrm_nm}'></i><span
									name="${item1.progrm_param}" id="${item1.progrm_param}">${item1.progrm_nm}</span></a>
							</c:if> <c:if test="${item1.pop_yn eq 'N' || item1.pop_func eq ''}">
								<a href="${item1.progrm_url}?${item1.progrm_param}"><i
									class="${item1.progrm_class}" title='${item1.progrm_nm}'></i><span
									name="${item1.progrm_param}" id="${item1.progrm_param}">${item1.progrm_nm}</span></a>
							</c:if> <c:set var="hash_sub" value="false" /> <c:forEach var="item2"
								items="${userSubMenu}">
								<c:if test="${not hash_sub }">
									<c:if test="${item1.progrm_no eq item2.p_progrm_no}">
										<c:set var="hash_sub" value="true" />
									</c:if>
								</c:if>
							</c:forEach> <c:if test="${hash_sub eq true}">
								<ul class="submenu">
									<c:forEach var="item2" items="${userSubMenu}">
										<c:if test="${item1.progrm_no eq item2.p_progrm_no}">
											<li><a href="${item2.progrm_url}?${item2.progrm_param}"
												title='${item2.progrm_nm}'>${item2.progrm_nm}</a></li>
										</c:if>
									</c:forEach>
								</ul>
							</c:if>
						</li>
					</c:forEach>
					

				</ul>
				<!-- End navigation menu -->

			</div>
			<!-- end #navigation -->
	
		
		</div>
		
		
		<!-- end container -->

	</div>
	<!-- end navbar-custom -->

	<!-- User Detail Page-Body -->
	<div class="row" id='myDetail'
		style='position: absolute; display: none; z-index: 1000'>
		<div class="col-sm-12">
			<div class="card-box big-card-box last table-responsive searchResult">
				<div class="table-wrap m-t-30">
					<form class="clearfix" id="MyPwdChangeForm" name="MyPwdChangeForm"
						onSubmit="return false;">
						<table
							class="table table-custom table-cen table-num text-center table-hover"
							width="100%">
							<colgroup>
								<col width="20%">
								<col width="30%">
								<col width="20%">
								<col width="30%">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">아이디</th>
									<td id='my_user_id'></td>
									<th scope="row">이름</th>
									<td id='my_user_nm'></td>
								</tr>
								<tr>
									<th scope="row">부서명</th>
									<td id='my_dept_nm'></td>
									<th scope="row">전화번호</th>
									<td id='my_telno'></td>
								</tr>
								<tr>
									<th scope="row">등록일</th>
									<td id='my_ins_dt'></td>
									<th scope="row">마지막수정일</th>
									<td id='my_upd_dt'></td>
								</tr>
								<tr>
									<th scope="row">프로그램 권한</th>
									<td class="td-expand" id='my_p_auth_no'></td>
									<th scope="row">지도레이어 권한</th>
									<td colspan="3" class="td-expand" id='my_l_auth_no'></td>
								</tr>
								<tr>
									<th scope="row">비밀번호</th>
									<td><input class="form-control required" name="user_pass"
										id="user_pass" type="password" maxlength="64" title="비밀번호"
										placeholder="비밀번호를 입력해주세요." disabled /></td>
									<th scope="row">비밀번호 확인</th>
									<td><input id="re_user_pass" name="re_user_pass"
										type="password" title="비밀번호 확인" class="form-control required"
										placeholder="비밀번호 확인을 입력해주세요." disabled></td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>
				<div class="clearfix"></div>
				<div class="modal-footer">
					<div class="btn-wrap pull-left">
						<button class="btn btn btn-info" id="MyPwdChangeReq" type="button">비밀번호
							변경</button>
					</div>
					<div class="btn-wrap pull-right">
						<button class="btn btn btn-danger" id="MyPwdChangeClose"
							type="button">닫기</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- End User Detail Page-Body -->

</header>
<!-- End Navigation Bar-->
