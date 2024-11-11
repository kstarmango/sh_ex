<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

		<c:choose>
		    <c:when test="${sesUserId eq 'admin'}"><c:set var="auth_yn" value="Y"/><!-- 로그인 유무 --></c:when>
		    <c:otherwise>  <c:set var="auth_yn" value="N"/><!-- 로그인 유무 --></c:otherwise>
		</c:choose>	

		<!-- Navigation Bar-->
		<header id="topnav" class="map">
		    <div class="topbar-main">
		    	        
		        <div class="container">
		
		            <!-- Logo container-->
		            <div class="logo">
		                <!-- Image Logo -->
		                <a href="<%=RequestMappingConstants.WEB_DASHBOARD%>" class="logo">
		                    <img src="/jsp/SH/img/sh_logo.png" alt="SH서울주택도시공사" height="48" >
		                    <span class="v-bar"></span>
		                    <img src="/jsp/SH/img/logo.png" alt="토지자원관리시스템" height="19">
		                </a>
		            </div>
		            <!-- End Logo container-->
		
		
		            <div class="menu-extras">
		
		                <ul class="nav navbar-nav navbar-right pull-right">
		
		                    <li class="dropdown navbar-c-items">
		                        <a class="dropdown-toggle waves-effect waves-light profile" data-toggle="dropdown" aria-expanded="true">
		                            <div class="text-white">
										<i class="fa fa-user fa-fw">
                                      </i><b class="top-nav-text">
                                          <c:out value="${sesUserName}"></c:out>(<c:out value="${sesUserPosition}"></c:out>) 
                                     </b>
									</div>
		                        </a>
		                        <!-- <ul class="dropdown-menu dropdown-menu-right arrow-dropdown-menu arrow-menu-right user-list notify-list">
		                            <li><a href="#"><i class="ti-settings m-r-5"></i> 내 정보 수정</a></li>
		                            
		                        </ul> -->
		                    </li>
		
		                    <li class="navbar-c-items">
		                        <!-- <a href="/actionLogout.do" class="right-menu-item"> -->
		                        <a href="/web/cmmn/logout.do" class="right-menu-item">
		                            <span><i class="fa fa-power-off fa-fw m-r-5"></i>로그아웃</span>
		                        </a>
		                    </li>
		
		                </ul>
		                
		                <div class="menu-item">
		                    <!-- Mobile menu toggle-->
		                    <a class="navbar-toggle">
		                        <div class="lines">
		                            <span></span>
		                            <span></span>
		                            <span></span>
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
		
		    <div class="navbar-custom active">
		        <div class="container">
		            <div id="navigation" class="active" >
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
		                    <li class="has-submenu ${item1.admin_yn eq 'Y' ? 'admin-menu' : '' }">
		                        <a href="${item1.progrm_url}"><i class="${item1.progrm_class}">${item1.progrm_nm}</i></a>

								<c:set var="hash_sub"  value="false" />
								<c:forEach var="item2" items="${userSubMenu}">
									<c:if test="${not hash_sub }">
										<c:if test="${item1.progrm_no eq item2.p_progrm_no}">
											<c:set var="hash_sub"  value="true" />
										</c:if>
									</c:if>
								</c:forEach>
								
								<c:if test="${hash_sub eq true}">
		                        <ul class="submenu">
		                        <c:forEach var="item2" items="${userSubMenu}">
		                        	<c:if test="${item1.progrm_no eq item2.p_progrm_no}">
		                        	<li><a href="${item2.progrm_url}">${item2.progrm_nm}</a></li>
		                        	</c:if>
		                        </c:forEach>
		                        </ul>
		                        </c:if>
							</li>		                    		                    
		                    </c:forEach>
		                    
		                    
		                    <li class="has-submenu admin-menu">
		                    	<a href="/apikey/login.do?apiKey=4ca9f6c4055f353c2eda128dd26a0076"><i class="mdi mdi-settings"></i>API_TEST</a>
		                    </li>
		                                        
		                     
		                </ul>
		                <!-- End navigation menu -->
		            </div>
		            <!-- end #navigation -->
		        </div>
		        <!-- end container -->
		    </div>
		    <!-- end navbar-custom -->
		</header>
		<!-- End Navigation Bar-->