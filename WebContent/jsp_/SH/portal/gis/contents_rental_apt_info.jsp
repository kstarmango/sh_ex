    	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
		<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

		<script type="text/javascript">
			$(document).ready(function(){

				// 창 minimize / maxmise
				var rental_info_is_min = false;
				var rental_info_mini_width;
				var rental_info_mini_height;

				$('#rental-info-mini-min').click(function() {
					if(!rental_info_is_min) {
						rental_info_mini_width = $("#rental_info_mini").width();
						rental_info_mini_height = $("#rental_info_mini").height();

						$("#rental_info_contents_group").css('display', 'none');

						$("#rental_info_mini_head").css('border-radius', '0px / 0px');
						$("#rental_info_mini").css('border-radius', '0px / 0px');
						$("#rental_info_mini").css('width', 600);
						$("#rental_info_mini").css('height', 40);

						rental_info_is_min = true;
					}
			    });

			    $('#rental-info-mini-max').click(function() {
					if(rental_info_is_min) {
				    	$("#rental_info_contents_group").css('display', 'block');

						$("#rental_info_mini_head").css('border-radius', '10px 10px 0 0');
				    	$("#rental_info_mini").css('border-radius', '10px 10px 10px 10px');
				    	$("#rental_info_mini").css('width', rental_info_mini_width);
				    	$("#rental_info_mini").css('height', rental_info_mini_height);

				    	rental_info_is_min = false;
					}
			    });

			    $('#rental-info-mini-close, #rental_info_close').click(function() {
					$("#rental_info_mini").hide();
			    });

			    $( "#rental_info_mini" ).resizable({
			   		minWidth: 900,
			    	minHeight: 600,
			    	maxHeight: 600,
			    });

			    $('#rental_info_move').click(function() {

			    });

				// 엑셀저장
			    var tableId = '';
			    var fileName = 'export.xls';

			    function exportTableToExcel(id, file) {
				    var downloadLink;
				    var dataType = 'application/vnd.ms-excel';
				    var tableSelect = document.getElementById(id);

				    // Specify file name
				    file = file?file+'.xls':'excel_data.xls';

				    //if(navigator.msSaveOrOpenBlob)
				    if(window.navigator.msSaveBlob)
				    {
				        //var blob = new Blob(['\ufeff', tableHTML], {
				        //    type: dataType
				        //});
				        //window.navigator.msSaveOrOpenBlob( blob, file);

				        var tableHTML = tableSelect.outerHTML

				        var blob = new Blob([ tableHTML ], {
							type : "application/csv;charset=utf-8;"
						});
				        window.navigator.msSaveBlob( blob, file);
				    }
				    else
				    {
				    	var tableHTML = tableSelect.outerHTML.replace(/ /g, '%20');

				    	// Create download link element
					    downloadLink = document.createElement("a");

					    document.body.appendChild(downloadLink);

				        downloadLink.href = 'data:' + dataType + 'charset=utf-8,%EF%BB%BF' + tableHTML;
				        downloadLink.download = file;
				        downloadLink.click();
				    }
				}

			 	// 엑셀저장 버튼 클릭
				$('#rental_info_download').click(function(){
					var file = $("#rental_info_contents_title").text();

					// 기본
					exportTableToExcel('rental_info_contents',  file + '_기본정보');

					// 상세
					if($('#dong_contents_body tr').length > 0) {
						
						$('#dong_contents_head').attr('border', '1');
						$('#dong_contents_head th').css({"background-color": "yellow"});
						$('#dong_contents_head th').css({"color": "blue"});
						
						$('#dong_contents_body').attr('border', '1');
						$('#dong_contents_body td').css({"background-color": "#CDCDCD"});

						exportTableToExcel('rental_info_dongho_contents', file + '_건물정보');

						$('#dong_contents_head').attr('border', '0');
						$('#dong_contents_head th').css({"background-color": ""});
						$('#dong_contents_head th').css({"color": ""});
						
						$('#dong_contents_body').attr('border', '0');
						$('#dong_contents_body td').css({"background-color": ""});
					}
				});
			});


			/////////////////////////////////////////////////////////////////////////////////////////
			// 데이터 조회
			function fn_rental_apt_k(event) {
				fn_rental_apt_k_info_show(event.data.title, event.data.table_value);
			}

		    function fn_rental_info_title(search_title, contents_title) {
		    	$("#rental_info_search_title").text(search_title);
		    	$("#rental_info_contents_title").text(contents_title);
		    }

		    function fn_rental_info_clear() {
		    	$("#rental_info_contents > thead > tr").remove();
		    	$("#rental_info_contents > tbody > tr").remove();

		    	$("#dong_contents_head > tr").remove();
		    	$("#dong_contents_body > tr").remove();
		    }

		    function fn_search_dongho_item_click(e) {
				x = $(this).attr('data-move-x') * 1;
				y = $(this).attr('data-move-y') * 1;
				geom = $(this).attr('data-draw-xy');

		    	//geoMap.getView().setCenter([ x, y ]);
		    	var data = [{x: x, y: y, geom: geom}];
		    	fn_gis_map_move(data);
		    }

			function fn_rental_info_show(search_title, search_type, key, val) {
				var url;
				var title_nm;
				var title_coulmn;
				if(search_type == 'APT') {
					url = "<%=RequestMappingConstants.WEB_GIS_DATA_RENTAL_TOTAL%>";
					title_coulmn = 'hsmp_nm';
				} else if(search_type == 'MLTDWL') {
					url = "<%=RequestMappingConstants.WEB_GIS_DATA_RENTAL_TOTAL%>";
				} else if(search_type == 'CTY_LVLH') {
					url = "<%=RequestMappingConstants.WEB_GIS_DATA_RENTAL_TOTAL%>";
			    } else if(search_type == 'LFSTS_RENT') {
					url = "<%=RequestMappingConstants.WEB_GIS_DATA_RENTAL_TOTAL%>";
				} else if(search_type == 'LNGTR_SAFETY') {
					url = "<%=RequestMappingConstants.WEB_GIS_DATA_RENTAL_TOTAL%>";
				}

		        $.ajax({
		            type: "POST",
		    		async : true,
		            url: url,
		            data : {
		    			search_type: search_type,
		    			key: key,
		    			value: val
		    		},
				    dataType: 'json',
		    		beforeSend: function() { $('html').css("cursor", "wait"); },
			       	complete: function() { $('html').css("cursor", "auto"); },
		            success: function(data) {
						console.log(data)

		    			var head_eng = data.headEngInfo;
		    			var head_kor = data.headKorInfo;
		    			var data_body = data.dataInfo[0];
		    			var col_per_row = 4;
		    			var loop = Math.ceil(data.headEngInfo.length / col_per_row);

						// 초기화
		    			fn_rental_info_clear()

		    			// 마스터 정보
						$("#rental_info_contents tbody").empty();

						for(k=0; k < loop; k++) {
							var strHtml = '<tr>';
							for(i = 0; i < col_per_row; i++) {
								if(k*col_per_row + i < data.headEngInfo.length) {
									var key = head_eng[k*col_per_row + i];
									var value = eval('data_body.' + key);

									if(title_coulmn == key) {
										title_nm = value;
									}

									strHtml += ('<th style= "">' + (head_kor[k*col_per_row + i] == '' ? head_eng[k*col_per_row + i] : head_kor[k*col_per_row + i])+ '</th>');

									if(value != undefined && value != 'undefined') {
										strHtml += ('<td>' + value + '</td>');
									} else {
										strHtml += ('<td></td>');
									}
								} else {
									strHtml += ('<th style= ""></th>');
									strHtml += ('<td></td>');
								}

							}
							$('#rental_info_contents tbody').append(strHtml + '</tr>');
						}

						if(title_nm == '' || title_nm == undefined) {
							title_nm = data.bsnsNmInfo;
						}

		    			// 동호 정보
		    			if(data.subDataInfo != undefined && data.subDataInfo != '' && data.subDataInfo.length > 0) {
			    			var dong_head_eng = data.subHeadEngInfo;
			    			var dong_head_kor = data.subHeadKorInfo;
			    			var dong_data_body = data.subDataInfo;

							// 전체 데이터 건수
							 $("span[name*='rental_info_dongho_count']").text(dong_data_body.length);

							// 테이블 커럼 추가
							$("#dong_contents_head").empty();
							var strHtml = '<tr>';
							for(i = 0; i < dong_head_kor.length; i++) {
								strHtml += ('<th style= "">' + (dong_head_kor[i] == '' ? dong_head_eng[i] : dong_head_kor[i])+ '</th>');
							}
							$('#dong_contents_head').append(strHtml + '</tr>');

							// 테이블 데이터 추가
							$("#dong_contents_body").empty();
							for(i = 0; i < dong_data_body.length; i++) {

								var x = eval('dong_data_body[' + i + '].x');
								var y = eval('dong_data_body[' + i + '].y');
								var geom = eval('dong_data_body[' + i + '].the_geom');

								strHtml = '<tr data-move-x="'+x+'" data-move-y="'+y+'" data-draw-xy="'+geom+'">';
								for(j = 0; j < dong_head_eng.length; j++) {
									var key = dong_head_eng[j];
									var value = eval('dong_data_body[' + i + '].' + key);

									if(value == undefined || value == 'undefined') {
										value = '';
									}

									strHtml += ('<td>' + value + '</td>');
								}
								$('#dong_contents_body').append(strHtml + '</tr>');
							}

							// 테이블 이벤트 추가
							$('#dong_contents_body').off('click');
							$("#dong_contents_body").on("click", "tr", fn_search_dongho_item_click);

							$('#rental_info_dongho').show();
		    			} else {
		    				$('#rental_info_dongho').hide();
		    			}

		    			fn_rental_info_title(search_title, title_nm);

						if(search_type == 'APT') {
							$('#rental_k_apt_info').off('click');
							$('#rental_k_apt_info').click({title: title_nm, table_key: key, table_value: val}, fn_rental_apt_k);

							$('#rental_k_apt_info').show();
						} else {
							$('#rental_k_apt_info').hide();
						}

		    			$('#rental_info_mini').show();
		    		}
			       	
			    });
		    
		    $('.hScroll_dong').scroll(function() {
                $('.vScroll_dong').width($('.hScroll_dong').width() + $('.hScroll_dong').scrollLeft());
            });
		    }

		</script>

		<div class="side-pane info-mini layer-pop ui-draggable ui-resizable" style="width: 900px; height: 600px; display: none; z-index: 20000;" id="rental_info_mini">

	        <!-- Page-Title -->
	        <div class="row page-title-box-wrap tit info-mini ui-draggable-handle" id='rental_info_mini_head'>
	            <div class="page-title-box info-mini col-xs-12">
	            	<!-- <i class="fa fa-map-o m-r-5"></i> -->
	                <p class="page-title m-b-0"><b>임대주택 종합정보</b></p>
	            </div>
                <!-- <div class="close-btn tab"> -->
                <div class="pop_head_btn close-btn tab">
                    <button type="button" class="w-min tab" id="rental-info-mini-min">최소화</button>
					<button type="button" class="w-max tab" id="rental-info-mini-max">최대화</button>
                    <button type="button" class="w-cls tab" id="rental-info-mini-close">×</button>
                    <!-- <button type="button" class="close tab" id="rental-info-mini-close">×</button> -->
                </div>
	        </div>
	        <!-- End Page-Title -->

			<!--정보 Panel-Content -->
			<div class="sp-content-wrap" id="rental_info_contents_group">
			    <div class="sp-content" style='overflow-y:scroll;'>
			        <div class="sp-content-inner p-20">

			            <div style="height: 40px;width:100%;/* background-color:pink; */font-weight: bold;">
			                <div style="line-height: 20px;float:left;">
			                    <div style="vertical-align: middle;display: inline-block;width: 32px;height: 18px;background-color:#d9d9d9;"></div>
			                    <span style="color: #222;vertical-align: middle;display:inline-block;" id='rental_info_contents_title'></span>
			                </div>
			                <div style="float:right">
			                    <button type="button" class="btn btn-sm btn-custom" id='rental_k_apt_info'>K-아파트</button>
			                    <button type="button" class="btn btn-sm btn-teal " id='rental_info_download'>다운로드</button>
			                </div>
			            </div>

			            <div class="sp-box m-b-20 position_re" style="display:block;">
			                <h4 class="header-title m-t-0 b_arrow position_re" style="color: #F16521;cursor:pointer;"><span id='rental_info_search_title'></span>&nbsp;
				                <i class="fa fa-chevron-up" aria-hidden="true"></i>
			                </h4>
			                <div aria-expanded="true">
	                            <table class="table table-custom table-cen table-num text-center table-hover" width="100%" aria-expanded="false" style="height: 0px;" id='rental_info_contents'>
			                        <tbody>
			                        </tbody>
			                    </table>
			                </div>
			            </div>

			            <div class="sp-box m-b-20 position_re" id='rental_info_dongho'>
							<!-- <button type="button" class="btn btn-sm btn-custom inpop_btn" id='rental_info_move'>건물이동</button> -->
			                <h4 class="header-title m-t-0" style="color: #F16521;cursor:pointer;">건물정보&nbsp;
			                	<i class="fa fa-chevron-up" aria-hidden="true"></i>&nbsp;&nbsp;(전체 <b class="text-orange"><span name='rental_info_dongho_count'>0</span></b>건)
			                </h4>
			                <div class="table-wrap m-t-30 fixed_table">
			                <div class="hScroll_dong" id='rental_info_dongho_contents'>
	                            <table class="table table-custom table-cen table-num text-center table-hover" >
			                        <thead id = 'dong_contents_head'>
			                        </thead>
			                        </table>
			                        <div class="vScroll_dong" style="width: 820px;">
			                        <table
										class="table table-custom  table-cen table-num text-center table-hover">
										<tbody id='dong_contents_body'>
			                        </tbody>
			                    </table>
			                    </div>
			                    </div>
			                </div>
			            </div>
			        </div>
			    </div>
			    <div class="btn-wrap tab text-right">
      				<button type="button" class="btn btn-sm btn-inverse" id="rental_info_close">닫기</button>
			    </div>
			</div>
			<!-- End 정보 Panel-Content -->
          
        

		</div>