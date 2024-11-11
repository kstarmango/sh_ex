<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="utf-8">
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <meta name="description" content="SH서울주택도시공사 | 토지자원관리시스템">

    <link rel="shortcut icon" href="/jsp/SH/img/favicon.ico">

    <!-- App css -->
    <link href="/jsp/SH/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/components.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/icons.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/core.css" rel="stylesheet" type="text/css" />
	<link href="/jsp/SH/css/colpick.css" rel="stylesheet" type="text/css" />
	<link href="/jsp/SH/css/messagebox.css" rel="stylesheet" type="text/css"/>

      <style>
      .color-box {
			float:left;
			width:30px;
			height:30px;
			margin:5px;
			border: 1px solid white;
		}
      </style>

    <!-- jQuery Library -->
	<script src="/jsp/SH/js/jquery.min.js"></script>
	<script src="/jsp/SH/js/bootstrap.min.js"></script>
	<script src="/jsp/SH/js/colpick.js"></script>

	<!-- Validate -->
<!--     <script src="/jsp/SH/js/jquery.validate.min.js"></script> -->

	<!-- Jquery UI for Draggable-->
	<script src="/jsp/SH/js/jquery-ui.min.js"></script>

    <!-- OpenLayers4 -->
	<link href="/jsp/SH/js/openLayers/v4.3.1/ol.css" rel="stylesheet" />
	<script src="/jsp/SH/js/openLayers/v4.3.1/ol.js"></script>
	<script src="/jsp/SH/js/openLayers/v4.3.1/polyfill.min.js"></script>
	<script src="/jsp/SH/js/messagebox.js"></script>
	<script src="/jsp/SH/js/html2canvas.js"></script>

	<!-- App js -->
	<script src="/jsp/SH/js/add_theme.js"></script>

	<!-- HTML5 Shiv and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->

    <script src="/jsp/SH/js/fabric.js"></script>

	<title>SH | 토지자원관리시스템</title>

	<script language="javascript">
	function searchBookmark() {
		var nm = $('#searchBookmark_nm').val();
		$("button[id^='del_']").parent().parent().parent().parent("li").hide();
		$("#bookmark_list span:contains('"+nm+"')").parent().parent().parent("li").show();
	}

	var typeSelect = 'None';
	var dr_source = new ol.source.Vector();
	var dr_vector;

    function add_vector_interaction() {
      if (typeSelect !== 'None') {
    	  dr_vector = new ol.interaction.Draw({
	          source: dr_source,
	          type: typeSelect
	      });
    	  dr_vector.on('drawend', function(e) {
    		  console.log(typeSelect);
    		  switch(typeSelect) {
	  			case 'Point':
	  				$.MessageBox({
	    			    input    : true,
	    			    message  : "원하시는 텍스트를 입력하세요."
	    			}).done(function(data){
	    				e.feature.setProperties({
	    					'description':$.trim(data),
	        			    'bgcolor': $('#bgColor').css('backgroundColor'),
	        			    'lncolor': $('#lnColor').css('backgroundColor')
	        			  });
	    			});
	  				break;
	  			default:
	  				e.feature.setProperties({
	    			    'bgcolor': $('#bgColor').css('backgroundColor'),
	    			    'lncolor': $('#lnColor').css('backgroundColor')
	    			  });
	  			break;
	    	  }
    		 });
        	geoMap.addInteraction(dr_vector);
      	}
    }


	var dr_layer = new ol.layer.Vector({
		source: dr_source,
		style: function(feature, resolution) {
			var style;

			style = new ol.style.Style({
				fill: new ol.style.Fill({
			          color: feature.get('bgcolor')
			        }),
		        stroke: new ol.style.Stroke({
		          color: feature.get('lncolor'),
		          width: 1
		        }),
		        text: new ol.style.Text({
		            font: '20px Calibri,sans-serif',
		            fill: new ol.style.Fill({ color: feature.get('bgcolor') }),
		            stroke: new ol.style.Stroke({
		              color: feature.get('lncolor'), width: 2
		            }),
		            // get the text from the feature - `this` is ol.Feature
		            // and show only under certain resolution
		            text: feature.get('description')
		          })
			});
			return [style];
		}
	});

	$(document).ready(function() {
		geoMap.addLayer(dr_layer);
		$('div[name="Drawtool"]').each(function() {
			$(this).on('click', function() {
				$this = $(this);
				if($this.hasClass('active')) {
					$(this).removeClass('active');
					typeSelect = 'None';
				}
				else {
					typeSelect = $(this).attr('value');
					geoMap.removeInteraction(dr_vector);
					$(this).addClass('active');
					add_vector_interaction();
				}
				$('div[name="Drawtool"]').each(function() {
					if($this != $(this)) {
						$(this).removeClass('active');
					}
				});
			});
		});
		add_vector_interaction();

		$("#toggle_layersLine li>div>a").click(function(){
			$("#toggle_layersLine li").not($(this).parent().parent()).removeClass("active");
			$(this).parent().parent().toggleClass("active");
		});

		$("#toggle_layers li>div>a").click(function(){
			$("#toggle_layers li").not($(this).parent().parent()).removeClass("active");
			$(this).parent().parent().toggleClass("active");
		});

		$("#toggle_layersCity1 li>div>a").click(function(){
			$("#toggle_layersCity1 li").not($(this).parent().parent()).removeClass("active");
			$(this).parent().parent().toggleClass("active");
		});

		$("#toggle_layersCity2 li>div>a").click(function(){
			$("#toggle_layersCity2 li").not($(this).parent().parent()).removeClass("active");
			$(this).parent().parent().toggleClass("active");
		});

		$("#toggle_layersCity3 li>div>a").click(function(){
			$("#toggle_layersCity3 li").not($(this).parent().parent()).removeClass("active");
			$(this).parent().parent().toggleClass("active");
		});

	});

	function showTooltip(a){
		$("#"+a).toggleClass("hide");
	}


	</script>
</head>

<body>

	<c:import url="/main_header.do"></c:import>

	<div id="load">
	    <img src="/jsp/SH/img/ajax-loader.gif"><p>LOADING</p>
	</div>

	<div class="wrapper">
	    <div class="wrapper-content theme">

	        <div class="th-bookmark-btn" id="th-bookmark-mini">
	            <button type="button" class="btn btn-orange btn-sm">즐겨찾기</button>
	        </div>

	        <!-- 주제도면-즐겨찾기-Popup -->
	        <div class="popover layer-pop bookmark-pop in-theme" id="th-bookmark-pop" style="width: 300px; left: 10px; top:10px; bottom: auto; display: block;">
	            <div class="popover-title tit">
	                <span class="m-r-5">
	                    <b>즐겨찾기</b>
	                </span>
	                <button type="button" class="close" id="th-bookmark-pop-close">×</button>
	            </div>
	            <div class="popover-body">
	                <div class="popover-content pop-top-area p-20">
	                    <div class="row">
	                        <div class="col-xs-12">
	                            <div class="input-group input-group-sm">
	                                <input type="search" class="form-control" placeholder="즐겨찾기 검색어 입력">
	                                <span class="input-group-btn">
	                                    <button class="btn btn-teal" onclick="searchBookmark()"><i class="fa fa-search"></i></button>
	                                </span>
	                            </div>
	                        </div>
	                    </div>
	                </div>

	                <div class="popover-content-wrap bookmark-pop">
	                    <div class="popover-content p-20">
	                        <div class="row">
	                            <div class="col-xs-12">
	                                <ul class="list-group m-b-0">
								<c:forEach var="result" items="${GISBookMark}" varStatus="status">
									<li class="list-group-item book-mark">
	                                    <div class="row bookmark-item">
	                                        <div class="col-xs-8">
	                                        	<span class="bookmark-item-text" onclick="javascript:agrBookmark('<c:out value="${result.gid}"/>');"><c:out value="${result.bookmark_nm}"/></span>
	                                        	<span class="bookmark-item-text" style="display:none;">
	                                                <input type="text" class="form-control input-sm" placeholder="즐겨찾기 명칭 입력" value="<c:out value="${result.bookmark_nm}"/>">
	                                            </span>
	                                        </div>
	                                    </div>
	                                </li>
								</c:forEach>

	                                </ul>
	                            </div>
	                        </div>
	                    </div>

	                </div>
	            </div>
	            <div class="popover-footer detail-view p-10">

	            </div>
	        </div>
	        <!--// End 자산검색-즐겨찾기-Popup -->

			<div class="popover layer-pop" style="width: 200px; left: 320px; top:10px; bottom: auto; display: block;z-index:1080;">
			<div class="popover-title tit">
	                <span class="m-r-5">
	                    <b>그래픽 추가</b>
	                </span>
	            </div>
	            <div class="row">
					<div class="col-sm-2">
	                     <div class="btn-group-vertical btn-md graphic-icon">
	                         <div class="btn btn-md btn-teal" title="선 추가" name="Drawtool" value="LineString">
	                             <i class="mdi mdi-pencil"></i>
	                         </div>
	                         <div class="btn btn-md btn-teal" title="텍스트 추가" name="Drawtool" value="Point">
	                             <i class="mdi mdi-format-text"></i>
	                         </div>
	                         <div class="btn btn-md btn-teal" title="면 추가" name="Drawtool" value="Polygon">
	                             <i class="mdi mdi-shape-rectangle-plus"></i>
	                         </div>
	                         <div class="btn btn-md btn-teal" title="원 추가" name="Drawtool" value="Circle">
	                             <i class="mdi mdi-shape-circle-plus"></i>
	                         </div>
	                     </div>
		            </div>
		            <div class="col-sm-2" style="left:50px;width:100px;">
		            	<div>선색</div>
		            	<div class="color-box" id="lnColor"></div>
		            	<div style="clear: both;">면색(글자색)</div>
						<div class="color-box" id="bgColor"></div>
		            </div>
	            </div>
			</div>

	        <div class="alert-box layer-pop">
	            <div class="alert-box-header tit">
	                <div class="alert-box-title">알림</div>
	            </div>
	            <div class="alert-box-content">
	                <h4 class="font-600">지도화면 설정 완료</h4>

	            </div>

	            <form><input type="hidden" id="imgSrc" name="imgSrcs" value="null11"/></form>

	            <div class="alert-box-footer">
	                <div class="text-right">
	                    <button class="btn btn-danger" onclick="cancel()"><i class="fa fa-times m-r-5"></i>취소</button>
	                    <button class="btn btn-custom" onclick="register_item()">다음<i class="fa fa-chevron-right m-l-5"></i></button>
	                </div>
	            </div>
	        </div>



	    </div>

	    <!-- map-container -->
	    <div class="container-fluid map">

	        <!-- Map-Content -->
	        <div class="map-content">

	        	<div id="geomap" style="width:100%; height:100%; float:left; min-height: 800px;"></div>

	            <div class="btn-group sel-map">
	                <button type="button" class="btn btn-sm btn-darkgray" onclick="baseMap_change('Base');">일반</button>
	                <button type="button" class="btn btn-sm btn-darkgray" onclick="baseMap_change('Satellite');">위성</button>
	                <button type="button" class="btn btn-sm btn-darkgray" onclick="baseMap_change('gray');">흑백지도</button>
	                <button type="button" class="btn btn-sm btn-darkgray" onclick="baseMap_change('cbnd');">지적도</button>
	            </div>

	            <div class="map-controls">
	                <div class="btn-group-vertical map-toolbar">
	                    <button type="button" class="btn btn-sm btn-teal m01" data-toggle="tooltip" data-placement="left" title="전체" onclick="FullExtent()">전체</button>
	                    <button type="button" class="btn btn-sm btn-teal m06" data-toggle="tooltip" data-placement="left" title="확대" onclick="ZoomIn()">확대</button>
	                    <button type="button" class="btn btn-sm btn-teal m07" data-toggle="tooltip" data-placement="left" title="축소" onclick="ZoomOut()">축소</button>
	                    <button type="button" class="btn btn-sm btn-teal m02" data-toggle="tooltip" data-placement="left" title="거리재기" onclick="measureLength()">거리</button>
	                    <button type="button" class="btn btn-sm btn-teal m03" data-toggle="tooltip" data-placement="left" title="면적재기" onclick="measureArea()">면적</button>
	                    <button type="button" class="btn btn-sm btn-teal m05" data-toggle="tooltip" data-placement="left" title="새로고침" onclick="Redraw()">지우기</button>
	                </div>
	            </div>

	            <div class="map-layer">
	                <button type="button" class="btn btn-sm btn-darkgray map-layer-btn" style="right: 224px;"><i class="mdi mdi-layers m-r-5"></i>주제도</button>
	                <div class="map-layer-btn-group btn-group-vertical btn-group-sm hidden">

	                	<!-- 범례-Bar -->
					    <c:import url="/jsp/SH_/landmanager/Content_Map_led.jsp"></c:import>
					    <!-- End 범례-Bar -->

	                </div>
                </div>



	        </div>
	        <!-- End Map-Content -->

	</div>



	<script type="text/javascript" src='/jsp/SH/js/map/geoMap.js'></script>
    <script type="text/javascript" src='/jsp/SH/js/map/geoMap_menu.js'></script>

	<script src="/jsp/SH/js/jquery.app.js"></script>

<script type="text/javascript">
$(document).ready(function() {

   	$('.layer-pop, .info-layer-stat').draggable({
       cursor: 'move',
       handle: '.tit',
       containment: 'parent'
   	});



    $('#th-bookmark-pop-close').click(function() {
        $('#th-bookmark-pop').toggleClass('hidden');
    });

    $('#th-bookmark-mini').click(function() {
        $('#th-bookmark-pop').toggleClass('hidden');
    });

    $('.color-box').colpick({
    	colorScheme:'dark',
    	layout:'rgbhex',
    	color:'ff8800',
    	onSubmit:function(hsb,hex,rgb,el) {
    		$(el).css('background-color', '#'+hex);
    		$(el).colpickHide();
    	}
    })
    .css('background-color', '#ff8800');
});
</script>


</body>

</html>