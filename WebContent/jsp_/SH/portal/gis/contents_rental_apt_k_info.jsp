    	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
		<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

		<script type="text/javascript">
			$(document).ready(function(){
				// 창 minimize / maxmise
				var rental_apt_k_info_is_min = false;
				var rental_apt_k_info_mini_width;
				var rental_apt_k_info_mini_height;

				$('#rental-apt-k-info-mini-min').click(function() {
					if(!rental_apt_k_info_is_min) {
						rental_apt_k_info_mini_width = $("#rental_apt_k_info_mini").width();
						rental_apt_k_info_mini_height = $("#rental_apt_k_info_mini").height();

						$("#rental_apt_k_info_contents_group").css('display', 'none');

						$("#rental_apt_k_info_mini_head").css('border-radius', '0px / 0px');
						$("#rental_apt_k_info_mini").css('border-radius', '0px / 0px');
						$("#rental_apt_k_info_mini").css('width', 600);
						$("#rental_apt_k_info_mini").css('height', 40);

						rental_apt_k_info_is_min = true;
					}
			    });

			    $('#rental-apt-k-info-mini-max').click(function() {
					if(rental_apt_k_info_is_min) {
				    	$("#rental_apt_k_info_contents_group").css('display', 'block');

						$("#rental_apt_k_info_mini_head").css('border-radius', '10px 10px 0 0');
				    	$("#rental_apt_k_info_mini").css('border-radius', '10px 10px 10px 10px');
				    	$("#rental_apt_k_info_mini").css('width', rental_apt_k_info_mini_width);
				    	$("#rental_apt_k_info_mini").css('height', rental_apt_k_info_mini_height);

				    	rental_apt_k_info_is_min = false;
					}
			    });

			    $('#rental-apt-k-info-mini-close, #rental_apt_k_info_close').click(function() {
					$("#rental_apt_k_info_mini").hide();
			    });

			    $( "#rental_apt_k_info_mini" ).resizable({
			   		minWidth: 900,
			    	minHeight: 600,
			    	maxHeight: 600,
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
				$('#rental_apt_k_info_download').click(function(){
			    	var file = $("#rental_apt_k_info_title").text();

					// 상세
					$('#rental_apt_k_contents_head').attr('border', '1');
					$('#rental_apt_k_contents_head th').css({"background-color": "yellow"});
					$('#rental_apt_k_contents_head th').css({"color": "blue"});
					
					$('#rental_apt_k_contents_body').attr('border', '1');
					$('#rental_apt_k_contents_body td').css({"background-color": "#CDCDCD"});

					exportTableToExcel('rental_apt_k_contents', file);

					// 기본
					$('#rental_apt_k_contents_head').attr('border', '0');
					$('#rental_apt_k_contents_head th').css({"background-color": ""});
					$('#rental_apt_k_contents_head th').css({"color": ""});
					
					$('#rental_apt_k_contents_body').attr('border', '0');
					$('#rental_apt_k_contents_body td').css({"background-color": ""});
				});
			});

			/////////////////////////////////////////////////////////////////////////////////////////
			// 데이터 조회
		    function fn_rental_apt_k_info_title(title) {
		    	$("#rental_apt_k_info_title").text(title);
		    }

		    function fn_rental_apt_k_info_clear() {
		    	$("#rental_apt_k_contents_head > tr").remove();
		    	$("#rental_apt_k_contents_body > tr").remove();
		    }

			function fn_rental_apt_k_info_show(title, val) {
		        $.ajax({
		            type: "POST",
		    		async : true,
		            url: "<%=RequestMappingConstants.WEB_GIS_DATA_RENTAL_APT_K%>",
		            data : {
		    			bsns_code: val
		    		},
		            dataType: 'json',
		            success: function(data) {
		    			//console.log(data);

		    			var head_eng = data.headEngInfo;
		    			var head_kor = data.headKorInfo;
		    			var data_body = data.dataInfo;

		    			// 초기화
				    	fn_rental_apt_k_info_title(title);
				    	fn_rental_apt_k_info_clear();

		    			// 전체 데이터 건수
						 $("span[name*='search_apt_k_list_count']").text(data_body.length);

						// 테이블 커럼 추가
						$("#rental_apt_k_contents_head").empty();
						var strHtml = '<tr>';
						for(i = 0; i < head_kor.length; i++) {
							strHtml += ('<th style= "">' + (head_kor[i] == '' ? head_eng[i] : head_kor[i])+ '</th>');
						}
						$('#rental_apt_k_contents_head').append(strHtml + '</tr>');

						// 테이블 데이터 추가
						$("#rental_apt_k_contents_body").empty();
						for(i = 0; i < data_body.length; i++) {
							strHtml = '<tr>';
							for(j = 0; j < head_eng.length; j++) {
								var key = head_eng[j];
								var value = eval('data_body[' + i + '].' + key);

								strHtml += ('<td>' + value + '</td>');
							}
							$('#rental_apt_k_contents_body').append(strHtml + '</tr>');
						}

						// 검색결과 보기
					    $("#rental_apt_k_info_mini").show();
		    		}
			    });
		    $('.hScroll_apt').scroll(function() {
                $('.vScroll_apt').width($('.hScroll_apt').width() + $('.hScroll_apt').scrollLeft());
            });
		    }

		</script>

		<div class="side-pane info-mini layer-pop" style="width: 900px; height: 600px; display: none; z-index: 21000" id="rental_apt_k_info_mini">

	        <!-- Page-Title -->
	        <div class="row page-title-box-wrap tit info-mini ui-draggable-handle" id='rental_apt_k_info_mini_head'>
	            <div class="page-title-box info-mini col-xs-12">
	                <p class="page-title m-b-0"><b>K-아파트 연계정보</b></p>
	            </div>
                <!-- <div class="close-btn tab"> -->
                <div class="pop_head_btn close-btn tab">
                    <button type="button" class="w-min tab" id="rental-apt-k-info-mini-min">최소화</button>
					<button type="button" class="w-max tab" id="rental-apt-k-info-mini-max">최대화</button>
                    <button type="button" class="w-cls tab" id="rental-apt-k-info-mini-close">×</button>
                    <!-- <button type="button" class="close tab" id="rental-apt-k-info-mini-close">×</button> -->
                </div>
	        </div>
	        <!-- End Page-Title -->

			<!--정보 Panel-Content -->
	        <div class="sp-content-wrap" id="rental_apt_k_info_contents_group">
	            <div class="sp-content">
	                <div class="sp-content-inner p-20">
	                    <div style="height: 40px;width:100%;/* background-color:pink; */font-weight: bold;">
	                        <div style="line-height: 20px; float:left;">
	                            <i class="fa fa-info-circle" aria-hidden="true" style="font-size:17px;vertical-align:middle;"></i>
	                            <span style="color: #222;vertical-align: middle;display:inline-block;" id='rental_apt_k_info_title'></span>
	                            <span style="padding: 0 24px;color: #faa765;vertical-align: middle;display:inline-block;">K-아파트정보</span><span class="small"> (전체 <b class="text-orange"><span name='search_apt_k_list_count'>0</span></b>건)</span>
	                        </div>
	                        <div style="float:right">
	                            <button type="button" class="btn btn-sm btn-teal " id='rental_apt_k_info_download'>다운로드</button>
	                        </div>
	                    </div>
	                    <div class="table-wrap m-t-30 fixed_table">
	                    <div class="hScroll_apt" id='rental_apt_k_contents'>
	                            <table class="table table-custom table-cen table-num text-center table-hover"  width="100%">
	                                <thead id='rental_apt_k_contents_head'>
	                                </thead>
	                                </table>
	                                <div class="vScroll_apt" style="width: 820px;">
	                                <table
										class="table table-custom  table-cen table-num text-center table-hover">
	                                <tbody id='rental_apt_k_contents_body'>
	                                </tbody>
	                            </table>
	                        </div>
	                        </div>
	                    </div>
	                </div>
	            </div>
			    <div class="btn-wrap tab text-right">
      				<button type="button" class="btn btn-sm btn-inverse" id="rental_apt_k_info_close">닫기</button>
			    </div>
	        </div>
	    	<!-- End 정보 Panel-Content -->

		</div>