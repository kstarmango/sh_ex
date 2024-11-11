	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
	<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
	<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

	<c:import url="<%= RequestMappingConstants.WEB_DASHBOARD   %>"></c:import>

	<c:import url="<%= RequestMappingConstants.WEB_THEME       %>">
		<c:param name="theme" value='<%= request.getParameter("theme") %>'/>
	</c:import>

	<script type="text/javascript">
	
	function getCookie(name)
    {
        var obj = name + "=";
        var x = 0;
        while ( x <= document.cookie.length )
        {
            var y = (x+obj.length);
            if ( document.cookie.substring( x, y ) == obj )
            {
                if ((endOfCookie=document.cookie.indexOf( ";", y )) == -1 )
                    endOfCookie = document.cookie.length;
                return unescape( document.cookie.substring( y, endOfCookie ) );
            }

            x = document.cookie.indexOf( " ", x ) + 1;
            if ( x == 0 )
                break;
        }

        return "";
    }
	
		$(document).ready(function(){
			var today_close = getCookie("dash_close");
			
			if(today_close === "Y"){
				return;
			}
			else if(window.location.pathname !== '/web/portal/gis.do'){
				menuDashboard();
			}
		});

	</script>

	<!-- Footer -->
    <footer class="footer map p-0">
        <div class="container-fluid">
            <div class="row m-t-10">
                <div class="col-xs-12 text-center"  style="text-align: center;">
                    <p class="m-b-0">도시연구원 / 황종아 / Tel. 02-3410-8504 / Coryright © 2018 서울주택도시공사 All Rights Reserved.</p>
                    <!-- <p>Coryright © 2018 서울주택도시공사 All Rights Reserved.</p> -->
                </div>
            </div>
        </div>
		<!-- 주의사항 -->
		<div id='notice' style="position:absolute;text-align: center; width: 100%;padding: 5px;bottom:15px; font-size:16px;  font-weight: bold ; color:red;">
			본 지도서비스는 법적 효력이 없으며, 참고 자료로만 활용 가능합니다.
		</div>
		<!-- 주의사항 end -->
    </footer>
    <!-- End Footer -->