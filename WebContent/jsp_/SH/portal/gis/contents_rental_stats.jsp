    	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
		<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

		<!-- TreeMap -->
		<script src='/jsp/SH/js/jquery-treemap.js'></script>

		<script type="text/javascript">
			$(document).ready(function(){

				// 창 minimize / maxmise
				var rental_stats_is_min = false;
				var rental_stats_mini_width;
				var rental_stats_mini_height;

				$('#rental-stats-mini-min').click(function() {
					if(!rental_stats_is_min) {
						rental_stats_mini_width = $("#rental_stats_mini").width();
						rental_stats_mini_height = $("#rental_stats_mini").height();

						$("#rental_stats_contents_group").css('display', 'none');
						$("#rental_stats_button_group").css('display', 'none');

						$("#rental_stats_mini_title").css('border-radius', '0px / 0px');
						$("#rental_stats_mini").css('border-radius', '0px / 0px');
						$("#rental_stats_mini").css('width', 600);
						$("#rental_stats_mini").css('height', 40);

						rental_stats_is_min = true;
					}
			    });

			    $('#rental-stats-mini-max').click(function() {
					if(rental_stats_is_min) {
				    	$("#rental_stats_contents_group").css('display', 'block');
						$("#rental_stats_button_group").css('display', 'block');

						$("#rental_stats_mini_title").css('border-radius', '10px 10px 0 0');
				    	$("#rental_stats_mini").css('border-radius', '10px 10px 10px 10px');
				    	$("#rental_stats_mini").css('width', rental_stats_mini_width);
				    	$("#rental_stats_mini").css('height', rental_stats_mini_height);

				    	rental_stats_is_min = false;
					}
			    });

			    $('#rental-stats-mini-close, #rental_stats_close').click(function() {
			        if($("#todaycloseyn").prop("checked"))
			        {
			            setCookie('rental_stats_mini', 'Y' , 1);
			        }

					$("#rental_stats_mini").hide();
			    });

			    $( "#rental_stats_mini" ).resizable({
			   		minWidth: 900,
			    	minHeight: 600,
			    	maxHeight: 600,
			    });

			    $('.fa-chevron-up').click(function() {
			    	//console.log($(this))
					$(this).toggleClass("fa-chevron-up fa-chevron-down");

			    	if($(this).hasClass('fa-chevron-down')) {
			    		$(this).parent().next().css('display', 'none')
			    	} else {
			    		$(this).parent().next().css('display', 'block')
			    	}
			    });
			});

		    //쿠키 설정
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

		    // 숫자 콤마 설정
			function numberFormat(inputNumber) {
				   return inputNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			}

		    /////////////////////////////////////////////////////////////////////////////////////////
		    function fn_rental_stats_show(data) {

		    	var today_close = getCookie("rental_stats_mini");
			    if(today_close != '' && today_close == "Y"){
		            return;
		        }

		    	console.log('아파트 단지수', data.statAptInfo.hsmp_cnt, '아파트 동수', data.statAptInfo.aptcmpl_cnt)
		    	$('#rental_stats_apt').treemap([
		    		{
			    		label: '단지 ' + numberFormat(data.statAptInfo.hsmp_cnt),
			    		value:  data.statAptInfo.hsmp_cnt,
			    		data:'label 1 data'
			    	},
			    	{
			    		label: '동수 ' + numberFormat(data.statAptInfo.aptcmpl_cnt),
			    		value:  data.statAptInfo.aptcmpl_cnt,
			    		data:'label 2 data'

			    	}],
			    	{
		    		nodeClass:function(node, box) {
			    		if(node.label.indexOf('단지수')){
			    			return 'treemap-color1';
			    		}
			    		return 'treemap-color2';
			    	},
			    	itemMargin: 2
		    	});

		    	console.log('아파트 전체 세대수', data.statAptInfo.hshld_sum, '아파트 임대세대수', data.statAptInfo.rent_hshld_cnt, '아파트 분양세대수', data.statAptInfo.lttot_hshld_cnt)
		    	$('#rental_stats_apt_detail').treemap([
		    		{
			    		label:'전체 ' + numberFormat(data.statAptInfo.hshld_sum),
			    		value:  data.statAptInfo.hshld_sum,
			    		data:'label 1 data'
			    	},
		    		{
			    		label:'임대세대수 ' + numberFormat(data.statAptInfo.rent_hshld_cnt),
			    		value:  data.statAptInfo.rent_hshld_cnt,
			    		data:'label 2 data'
			    	},
			    	{
			    		label:'분양세대수 ' + numberFormat(data.statAptInfo.lttot_hshld_cnt),
			    		value: data.statAptInfo.lttot_hshld_cnt,
			    		data:'label 3 data'

			    	}],
			    	{
		    		nodeClass:function(node, box) {
			    		if(node.label.indexOf('전체')){
			    			return 'treemap-color4';
			    		} else if(node.label.indexOf('임대세대수')){
			    			return 'treemap-color3';
			    		}
			    		return 'treemap-color3';
			    	},
			    	itemMargin: 2
		    	});

		    	console.log('다가구 전체 동수', data.statMltdwlInfo.mltdwl_aptcmpl_cnt)
		    	$('#rental_stats_mltdwl').treemap([
		    		{
			    		label:'전체 동수 ' + numberFormat(data.statMltdwlInfo.mltdwl_aptcmpl_cnt),
			    		value:  data.statMltdwlInfo.mltdwl_aptcmpl_cnt,
			    		data:'label 1 data'
			    	}],
			    	{
		    		nodeClass:function(node, box) {
			    		return 'treemap-color1';
			    	},
			    	itemMargin: 2
		    	});

		    	console.log('다가구 전체 세대수', data.statMltdwlInfo.tot_hshld_cnt)
		    	$('#rental_stats_mltdwl_1').treemap([
		    		{
			    		label:'전체 세대수 ' + numberFormat(data.statMltdwlInfo.tot_hshld_cnt),
			    		value:  data.statMltdwlInfo.tot_hshld_cnt,
			    		data:'label 1 data'
			    	}],
			    	{
		    		nodeClass:function(node, box) {
			    		return 'treemap-color5';
			    	},
			    	itemMargin: 2
		    	});

		    	console.log('도시형 전체 동수', data.statCityLvlhInfo.tot_aptcmpl_cnt)
		    	$('#rental_stats_citylvlh').treemap([
		    		{
			    		label:'전체 동수 ' + numberFormat(data.statCityLvlhInfo.tot_aptcmpl_cnt),
			    		value:  data.statCityLvlhInfo.tot_aptcmpl_cnt,
			    		data:'label 1 data'
			    	}],
			    	{
		    		nodeClass:function(node, box) {
			    		return 'treemap-color1';
			    	},
			    	itemMargin: 2
		    	});

		    	console.log('도시형 전체 세대수', data.statCityLvlhInfo.sum)
		    	$('#rental_stats_citylvlh_1').treemap([
		    		{
			    		label:'전체 세대수 ' + numberFormat(data.statCityLvlhInfo.sum),
			    		value:  data.statCityLvlhInfo.sum,
			    		data:'label 1 data'
			    	}],
			    	{
		    		nodeClass:function(node, box) {
			    		return 'treemap-color5';
			    	},
			    	itemMargin: 2
		    	});

		    	console.log('전세임대 전체 세대수', data.statLfstsRentInfo.dong_cnt)
		    	$('#rental_stats_lfsts_rent').treemap([
		    		{
			    		label:'전체 세대수 ' + numberFormat(data.statLfstsRentInfo.dong_cnt),
			    		value:  data.statLfstsRentInfo.dong_cnt,
			    		data:'label 1 data'
			    	}],
			    	{
		    		nodeClass:function(node, box) {
			    		return 'treemap-color5';
			    	},
			    	itemMargin: 2
		    	});

		    	console.log('장기안심 전체 세대수', data.statLngtrSafetyInfo.dong_cnt)
		    	$('#rental_stats_lngtr_safety').treemap([
		    		{
			    		label:'전체 세대수 ' + numberFormat(data.statLngtrSafetyInfo.dong_cnt),
			    		value:  data.statLngtrSafetyInfo.dong_cnt,
			    		data:'label 1 data'
			    	}],
			    	{
		    		nodeClass:function(node, box) {
			    		return 'treemap-color5';
			    	},
			    	itemMargin: 2
		    	});

		    	$("#rental_stats_mini").show();
		    }

		</script>

    	<!-- 임대주택 현황 Side-Panel -->
		<div class="side-pane info-mini layer-pop" id="rental_stats_mini" style="width: 900px; height:600px; display: none;">

            <!-- Page-Title -->
            <div class="row page-title-box-wrap tit info-mini" id='rental_stats_mini_title'>
                <div class="page-title-box info-mini col-xs-12">
                    <p class="page-title m-b-0" id="info_mini_address">
                    	<i class="fa fa-map-o m-r-5"></i>
                  		<b>SH임대주택 현황</b>
                    </p>
                </div>
                <!-- <div class="close-btn tab"> -->
                <div class="pop_head_btn close-btn tab">
                    <button type="button" class="w-min tab" id="rental-stats-mini-min">최소화</button>
					<button type="button" class="w-max tab" id="rental-stats-mini-max">최대화</button>
                    <button type="button" class="w-cls tab" id="rental-stats-mini-close">×</button>
                    <!-- <button type="button" class="close tab" id="rental_stats_mini_close">×</button> -->
                </div>
            </div>
            <!-- End Page-Title -->

		    <style>
				.jb-table {
				  	display: table;
				  	width: 100%;
				}
				.jb-table-row {
				  	display: table-row;
				}
				.jb-table-cell {
				  	display: table-cell;
				  	height: 100px;
				}
				.jb-top {
				  	vertical-align: top;
				}
				.jb-middle {
				  	vertical-align: middle;
				}
				.jb-bottom {
				  	vertical-align: bottom;
				}
				.treemap-red {
					background-color: red;
					color: white;
				}
				.treemap-green {
					background-color: green;
					color: white;
				}
				.treemap-blue {
					background-color: blue;
					color: white;
				}

				.treemap-color1 {
					background-color: #214E4D;
					color: white;
				}
				.treemap-color2 {
					background-color: #2C867E;
					color: white;
				}
				.treemap-color3 {
					background-color: #BD3A3A;
					color: white;
				}
				.treemap-color4 {
					background-color: #156564;
					color: white;
				}
				.treemap-color5 {
					background-color: #24557F;
					color: white;
				}
		    </style>
			<!--정보 Panel-Content -->
            <div class="card-box big-card-box last table-responsive searchResult" style='border: 0px; height: 500px; overflow-y: auto' id='rental_stats_contents_group'>
            	<div class="sp-content-inner">
			    	<div class="sp-box m-b-20 position_re" style="display: block;text-align: right;margin-bottom: 5px;">
						<b> 기준일 : 2023년 12월</b>
	                </div>
			    	<div class="sp-box m-b-20 position_re" style='display: block'>
						<h4 class="header-title m-t-0" style="color: #F16521;cursor:pointer;" data-toggle="collapse" data-target="#a_info" aria-expanded="true">
		                    <i class="fas fa-city" aria-hidden="true"></i><b> 아파트 단지</b>
		                    <i class="fa fa-chevron-up" style="" aria-hidden="true"></i>
	                    </h4>
	                    <div class="show_lr_wrap clearfix" style='height:100px; margin-bottom: 25px;'>
						    <div class="jb-table">
								<div class="jb-table-row">
									<div class="jb-table-cell" style='width: 40%' id="rental_stats_apt" name="rental_stats_apt">
									</div>
									<div class="jb-table-cell" style='width: 10%'>
									</div>
									<div class="jb-table-cell" style='width: 50%' id="rental_stats_apt_detail" name="rental_stats_apt_detail">
									</div>
								</div>
						   	</div>
	   		            </div>
			    	</div>
			        <div class="sp-box m-b-20 position_re">
						<h4 class="header-title m-t-0" style="color: #F16521;cursor:pointer;" data-toggle="collapse" data-target="#b_info" aria-expanded="true">
		                    <i class="fas fa-users" aria-hidden="true"></i><b> 다가구</b>
		                    <i class="fa fa-chevron-up" style="" aria-hidden="true"></i>
						</h4>
	                    <div class="table-wrap m-t-5" style='height:100px; margin-bottom: 25px;'>
						    <div class="jb-table">
								<div class="jb-table-row">
									<div class="jb-table-cell" style='width: 40%' id="rental_stats_mltdwl" name="rental_stats_mltdwl">
									</div>
									<div class="jb-table-cell" style='width: 10%'>
									</div>
									<div class="jb-table-cell" style='width: 50%' id="rental_stats_mltdwl_1" name="rental_stats_mltdwl_1">
									</div>
								</div>
						   	</div>
	   		            </div>
			    	</div>
			        <div class="sp-box m-b-20 position_re">
	                    <h4 class="header-title m-t-0" style="color: #F16521;cursor:pointer;" data-toggle="collapse" data-target="#c_info" aria-expanded="true">
		                    <i class="fas fa-home" aria-hidden="true"></i><b> 도시형생활주택</b>
		                    <i class="fa fa-chevron-up" style="" aria-hidden="true"></i>
						</h4>
	                    <div class="table-wrap m-t-5" style='height:100px; margin-bottom: 25px;'>
						    <div class="jb-table">
								<div class="jb-table-row">
									<div class="jb-table-cell" style='width: 40%' id="rental_stats_citylvlh" name="rental_stats_citylvlh">
									</div>
									<div class="jb-table-cell" style='width: 10%'>
									</div>
									<div class="jb-table-cell" style='width: 50%' id="rental_stats_citylvlh_1" name="rental_stats_citylvlh_1">
									</div>
								</div>
						   	</div>
	   		            </div>
			    	</div>
					<!-- <div class="jb-table">
						<div class="jb-table-row">
							<div class="jb-table-cell" style='width: 45%'>
								<h4 class="header-title m-t-0" style="color: #F16521;cursor:pointer;" data-toggle="collapse" data-target="#d_info" aria-expanded="true">
	                            	<i class="fas fa-building" style="padding:0 .4rem;" aria-hidden="true"></i><b> 전세임대</b>
	                            	<i class="fa fa-chevron-up" style="" aria-hidden="true"></i>
	                            </h4>
						        <div class="row" style='height:100px;' id="rental_stats_lfsts_rent" name="rental_stats_lfsts_rent">
					            </div>
							</div>
							<div class="jb-table-cell" style='width: 10%'>
							</div>
							<div class="jb-table-cell" style='width: 45%'>
								<h4 class="header-title m-t-0" style="color: #F16521;cursor:pointer;" data-toggle="collapse" data-target="#e_info" aria-expanded="true">
	                            	<i class="fas fa-hand-holding-heart" aria-hidden="true"></i><b> 장기안심</b>
	                            	<i class="fa fa-chevron-up" style="" aria-hidden="true"></i>
	                            </h4>
						        <div class="row" style='height:100px;' id="rental_stats_lngtr_safety" name="rental_stats_lngtr_safety">
					            </div>
							</div>
						</div>
					</div> -->
					<div class="sp-box m-b-20 position_re half-sp-box half-sp-left-box">
	                    <h4 class="header-title m-t-0" style="color: #F16521;cursor:pointer;" data-toggle="collapse" data-target="#d_info" aria-expanded="true">
	                        <i class="fas fa-building" style="padding:0 .4rem;" aria-hidden="true"></i><b> 전세임대</b>
	                        <i class="fa fa-chevron-up" style="" aria-hidden="true"></i>
	                    </h4>
	                    <div id="d_info" class="collapse in" aria-expanded="true" style="">
                            <div class="show_lr_wrap show_half_wrap clearfix">
                                <div class="row" style='width:99%; height:100px;' id="rental_stats_lfsts_rent" name="rental_stats_lfsts_rent">
				            	</div>
                            </div>
	                    </div>
	                </div>
					<div class="ssp-box m-b-20 position_re half-sp-box half-sp-right-box">
	                    <h4 class="header-title m-t-0" style="color: #F16521;cursor:pointer;" data-toggle="collapse" data-target="#d_info" aria-expanded="true">
	                        <i class="fas fa-building" style="padding:0 .4rem;" aria-hidden="true"></i><b> 장기안심</b>
	                        <i class="fa fa-chevron-up" style="" aria-hidden="true"></i>
	                    </h4>
	                    <div id="d_info" class="collapse in" aria-expanded="true" style="">
                            <div class="show_lr_wrap show_half_wrap clearfix">
                                <div class="row" style='width:100%; height:100px;' id="rental_stats_lngtr_safety" name="rental_stats_lngtr_safety">
				            	</div>
                            </div>
	                    </div>
	                </div>
				</div>
			</div>
			<!-- End 정보 Panel-Content -->

      		<div class="btn-wrap tab text-right" id='rental_stats_button_group'>
      			<input type='checkbox' name='chkbox' id='todaycloseyn' value='Y' checked>오늘하루 닫기</button>
      			<button type="button" class="btn btn-sm btn-inverse" id="rental_stats_close">닫기</button>
      		</div>

		</div>
        <!-- End 임대주택 현황 Side-Panel -->