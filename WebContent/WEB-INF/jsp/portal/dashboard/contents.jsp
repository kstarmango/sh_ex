
		<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
		<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
		<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
		<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
		<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
		<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>
		
		<script type="text/javascript" src="<c:url value='/resources/js/util/jquery/jquery-gallery.js'/>"></script> 
		<link rel="stylesheet" href="<c:url value='/resources/css/util/jquery/jquery-gallery.css'/>" />

		<script type="text/javascript">

			$(document).ready(function() {
				function fn_infographic_reload() {
					
					$.ajax({
		  				type : "POST",
		  				async : false,
		  				url : "<%=RequestMappingConstants.WEB_DASHBOARD_LIST%>",
		  				dataType : "json",
		  				data : {},
		  				error : function(response, status, xhr){
		  					if(xhr.status =='403'){
		  						alert('인포그래픽 목록 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
		  					}
		  				},
		  				success : function(data) {
		  					if(data.result == 'Y' && data.dashInfo.length > 0) {
		  						for(var i=0; i < data.dashInfo.length; i++) {
		  	  						var path = "<%=RequestMappingConstants.UPLOAD_FOLDER_FOR_WEB%>" + data.dashInfo[i].save_path + data.dashInfo[i].save_name;
		  	  						path = path.replace(/\\/g, '/');

		  	  						// 이미지 등록
		  	  						var strHtml = '<li><img style="width:100%; height:100%" id="dashboard_img' + (i+1) +
		  	  												'" src="' + path +
		  	  												'" data-infographic-url="'+ data.dashInfo[i].infographic_url +
		  	  												'" data-layer-dp-nm="' +  data.dashInfo[i].layer_dp_nm +
		  	  												'" data-layer-tp-nm="' + data.dashInfo[i].layer_tp_nm +
		  	  												'" title="클릭하시면 연결 페이지로 이동합니다."></li>'
		  							$("#dashboard-slide-image-container").append(strHtml);

		  	  						// 이미지 클릭시 연결페이지 이동
		  							$('#dashboard_img' + (i+1)).click(function() {
										if($(this).attr('data-infographic-url') != '') {
		  									window.open($(this).attr('data-infographic-url'));
										}
		  							})
		  						}
		  					}

		  					// 이미지 슬다이드 시작
		  					if(data.dashInfo.length > 0) {
			  					$('#dashboard-slide-image-container').slideshow({
			  					    // default: 2000
			  					    interval: 5000,
			  					    // default: 500
			  					    width: $('.wrapper-content').width(),
			  					    // default: 350
			  					    height: $('.wrapper-content').height()
			  					});
		  					}
		  				}
		  			});
				}

				// 지도보기 버튼 클릭시
				$('#dashboard_map').click(function() {
					$("img[id^='dashboard_img']").each(function(index, item){
						if($(this).closest('li').css('display') == 'list-item') {
							//console.log($(this).attr('data-layer-dp-nm'), $(this).attr('data-layer-tp-nm'), $(this).attr('src'))

							// 현재 클릭 이미지 레이어 ON
							if($("input:checkbox[id='"+$(this).attr('data-layer-tp-nm')+"']").is(":checked") == false) {
								$('#' + $(this).attr('data-layer-tp-nm')).trigger('click')
							}

							// 행정구역 ON
							if($("input:checkbox[id='tl_scco_ctprvn']").is(":checked") == false) {
								$('#tl_scco_ctprvn').trigger('click');
							}

							// 대시보드 닫기
							$('#dashboard').hide();
						}
					});
				});

				// 윈도우 사이즈 변경시
	  			$( window ).resize(function() {
	  				if($('header').css('display') == 'none')
	  					$('#dashboard').css('top', '0px')
	  				else
	  					$('#dashboard').css('top', '114px')

	  				$('#dashboard-slide-image-container').width($('.wrapper-content').width());
	  				$('#dashboard-slide-image-container').height($('.wrapper-content').height());
	  			});

				// 초기 로딩시
				fn_infographic_reload();
				
				
				function setCookie( name, value, expiredays )
			    {
				    var todayDate = new Date();
				    todayDate.setDate( todayDate.getDate() + expiredays );
				    document.cookie = name + '=' + escape( value ) + '; path=/; expires=' + todayDate.toGMTString() + ';'
			    }

			    //쿠키 불러오기
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
				
				$('#dashclose').click(function() {
			        if($("#dashcloseyn").prop("checked"))
			        {
			            setCookie('dash_close', 'Y' , 7);
			        }

					$("#dashboard").hide();
			    });
				
			});

		</script>

	    <div id='dashboard' class="wrapper-content asset" style='z-index: 2000; display: none;'>
        	<div class="dashboard-box">
				<ul class="gallery-slideshow" id="dashboard-slide-image-container"></ul>
			</div>
      		<div class="btn-wrap dashboard text-right" style='opacity: 0.6;'>
      			
				<input type='checkbox' name='chkbox' id='dashcloseyn' value='Y' style = "margin-top: 15px;" checked>
				<label for="checkbox" style = "color: #000000; margin-top: 15px;">일주일 닫기</label>
      			<button type="button" class="btn btn-sm btn-inverse" id="dashclose">닫기</button>
      			<button type="button" class="btn btn-sm btn-orange"  id="dashboard_map" title='지도보기'>지도보기</button>
      		</div>
	    </div>
