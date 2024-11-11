<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- <link rel="stylesheet" href="https://uicdn.toast.com/grid/latest/tui-grid.css" />
<script src="https://uicdn.toast.com/grid/latest/tui-grid.js"></script>	 -->
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />

		<script type="text/javascript">
		
			$(document).ready(function(){
	
				// 창 minimize / maxmise
				var search_list_is_min = false;
				var search_list_mini_width;
				var search_list_mini_height;

				$('#search-list-mini-min').click(function() {
					if(!search_list_is_min) {
						search_list_mini_width = $("#search_list_mini").width();
						search_list_mini_height = $("#search_list_mini").height();

						$("#search_list_contents_group").css('display', 'none');
						$("#search_list_button_group").css('display', 'none');

						$("#search_list_mini_title_head").css('border-radius', '0px / 0px');
						$("#search_list_mini").css('border-radius', '0px / 0px');
						$("#search_list_mini").css('width', 600);
						$("#search_list_mini").css('height', 40);

						search_list_is_min = true;
					}
			    });

			    $('#search-list-mini-max').click(function() {
					if(search_list_is_min) {
				    	$("#search_list_contents_group").css('display', 'block');
						$("#search_list_button_group").css('display', 'block');

						$("#search_list_mini_title_head").css('border-radius', '10px 10px 0 0');
				    	$("#search_list_mini").css('border-radius', '10px 10px 10px 10px');
				    	$("#search_list_mini").css('width', search_list_mini_width);
				    	$("#search_list_mini").css('height', search_list_mini_height);

				    	search_list_is_min = false;
					}
			    });

			    $('#search-list-mini-close, #search_list_close').click(function() {
			    	$('#search_item_edit').hide();
			    	$('#search_item_edit_save').hide();
			    	$('#search_item_edit_cancel').hide();
			    	$("#search_comprehensive").hide();

					$("#search_list_mini").hide();
			    });

			    $( "#search_list_mini" ).resizable({
			   		minWidth: 900,
			    	minHeight: 600,
			    	maxHeight: 600,
			    });

			    $('#search_item_edit').click(function() {
			    	// 속성 편집 창보기 - 미완성
					{
						console.log('속성 편집 창보기')
					}

			    	$("#search_item_edit").hide();
			    	$("#search_item_edit_save").show();
					$("#search_item_edit_cancel").show();
			    });

			    $('#search_item_edit_save').click(function() {
			    	// 속성 편집 저장 & 창닫기 - 미완성
					{
						console.log('속성 편집 저장')
			    	}

					$('#search_item_edit_cancel').trigger('click');
			    });

			    $('#search_item_edit_cancel').click(function() {
			    	$('#search_item_edit').hide();
			    	$('#search_item_edit_save').hide();
			    	$('#search_item_edit_cancel').hide();
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
				$('#search_list_download').click(function(){
			    	var file = $("#search_list_mini_title").text();

					// 상세
					$('#search_list_contents_head').attr('border', '1');
					$('#search_list_contents_head th').css({"background-color": "yellow"});
					$('#search_list_contents_head th').css({"color": "blue"});
					
					$('#search_list_contents_body').attr('border', '1');
					$('#search_list_contents_body td').css({"background-color": "#CDCDCD"});

					exportTableToExcel('search_list_contents', file);

					// 기본
					$('#search_list_contents_head').attr('border', '0');
					$('#search_list_contents_head th').css({"background-color": ""});
					$('#search_list_contents_head th').css({"color": ""});
					
					$('#search_list_contents_body').attr('border', '0');
					$('#search_list_contents_body td').css({"background-color": ""});
				});

			});

			/////////////////////////////////////////////////////////////////////////////////////////
			// 데이터 조회 목록
		    function fn_search_list_mini_title(title) {
		    	$("#search_list_mini_title").text(title);
		    }

		    function fn_search_list_mini_clear() {
		    	$("#search_list_contents_head > tr").remove();
		    	$("#search_list_contents_body > tr").remove();
		    }

		    function fn_search_comprehensiv(event) {
				//console.log('종합검색 창보기', event.data)
				fn_rental_info_show(event.data.search_title, event.data.search_type, event.data.table_key, event.data.table_value);
		    }

		    function fn_search_layer_item_click(e) {
				var td = $(this).children('td').slice(0, 2);
				var layer_tp_nm = td.attr('data-layer-tp-nm');

				$('#' + layer_tp_nm).trigger('click');
		    }

		    function fn_search_data_item_click(e) {
		    	var table_nm = $('.content_data').attr('data-table-nm');
		    	if(table_nm == "tb_apt_hsmp" || table_nm == "TB_MLTDWL" || table_nm == "tb_cty_lvlh_house" || table_nm == "tb_assets_regstr_apt"|| table_nm == "tb_assets_regstr_mltdwl"|| table_nm == "tb_assets_regstr_etc"){
		    		var td = $(this).children('td').slice(2, 3);
		    	}else{
		    		var td = $(this).children('td').slice(1, 3);
		    	} 
		    	
				//var td = $(this).children('td').slice(1, 3);
				
				var search_title = td.attr('data-search-title');
				var search_type = td.attr('data-search-type'); 	//지도표출에 필요한 컬럼
				var table_space = td.attr('data-table-space');
				var table_nm = td.attr('data-table-nm');
				var table_key = td.attr('data-pk-key');			//지도표출에 필요한 컬럼
				var table_value = td.attr('data-pk-value');		//지도표출에 필요한 컬럼
				var table_edit_yn = td.attr('data-edit-yn');
				var comprehensive = td.attr('data-comprehensive-yn');
				console.log(search_type, table_space, table_nm, table_key, table_value, table_edit_yn, comprehensive);

				// 속성편집 버튼
				if(table_edit_yn == 'Y') {
					$('#search_item_edit').show();
			    	$('#search_item_edit_save').hide();
			    	$('#search_item_edit_cancel').hide();
				} else {
					$('#search_item_edit').hide();
			    	$('#search_item_edit_save').hide();
			    	$('#search_item_edit_cancel').hide();
				}

				// 종합검색 버튼
				if(comprehensive == 'Y') {
					// 종합검색 결과
					$("#rental_info_mini").hide();

					$('#search_comprehensive').off('click');
					$('#search_comprehensive').click({search_title: search_title, search_type: search_type, table_key: table_key, table_value: table_value}, fn_search_comprehensiv);

					$("#search_comprehensive").show();
				} else {
					$("#search_comprehensive").hide();
				}

				// 지도표출
				if(search_type != undefined && search_type != '') {
					console.log("여기들어와야해")
			        $.ajax({
			            type: "POST",
			    		async : true,
			            url: "${contextPath}/<%=RequestMappingConstants.WEB_GIS_DATA_GEOMETRY%>",
			            data : {
			    			search_type : search_type,
			    			pk_key: table_key,
			    			pk_value: table_value
			    		},
			            dataType: 'json',
						error : function(response, status, xhr){
							if(xhr.status =='403'){
								alert('검색 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
							}
						},
			            success: function(data) {
			    			//console.log('도형 로딩 완료')
			    			fn_gis_map_move(data.dataInfo)

			    			$( "#search_list_mini" ).css({
						   		width: "500px",
						   		top: "0px",
						   		left: ($(window).width() - 500) + "px"
						    });
			    		}
				    });
				}
			}

		    function fn_search_layer_list_mini_show(title, pk_column, head_eng, head_kor, data) {
		    	//console.log(title, table_space, table_nm, pk_column, table_edit_yn);

		    	// 초기화
		    	fn_search_list_mini_title(title);
		    	fn_search_list_mini_clear();

				// 전체 데이터 건수
				 $("span[name*='search_list_count']").text(data.length);

				// 테이블 커럼 추가
				$("#search_list_contents_head").empty();
				var strHtml = '<tr>';
				for(i = 0; i < head_kor.length; i++) {
					if(head_eng[i] == pk_column)
						strHtml += ('<th style= "display: none;">' + (head_kor[i] == '' ? head_eng[i] : head_kor[i])+ '</th>');
					else
						strHtml += ('<th style= "">' + (head_kor[i] == '' ? head_eng[i] : head_kor[i])+ '</th>');
				}
				$('#search_list_contents_head').append(strHtml + '</tr>');

				// 테이블 데이터 추가
				$("#search_list_contents_body").empty();
				for(i = 0; i < data.length; i++) {
					strHtml = '<tr>';
					for(j = 0; j < head_eng.length; j++) {
						var key = head_eng[j];
						var value = eval('data[' + i + '].' + key);

						if(value == undefined || value == 'undefined') {
							value = '';
						}

						if(head_eng[j] == pk_column)
							strHtml += ('<td style="display: none"  data-layer-tp-nm="'+eval('data[' + i + '].layer_tp_nm')+'">' + value + '</td>');
						else
							strHtml += ('<td>' + value + '</td>');
					}
					$('#search_list_contents_body').append(strHtml + '</tr>');
				}

				// 테이블 이벤트 추가
				$('#search_list_contents_body').off('click');
				$("#search_list_contents_body").on("click", "tr", fn_search_layer_item_click);

				// 검색결과 보기
			    $("#search_list_mini").show();
		    }

		    function fn_search_list_mini_show(title, search_type, table_space, table_nm, pk_column, table_edit_yn, head_eng, head_kor, data, comprehensive, geom_type) {
		    	//console.log(title, table_space, table_nm, pk_column, table_edit_yn);
		    	
		    	console.log("pk_column : ", pk_column);
		    	
		    	console.log("head_eng : ", head_eng);
		    	

		    	// 초기화
		    	fn_search_list_mini_title(title);
		    	fn_search_list_mini_clear();

				// 전체 데이터 건수
				 $("span[name*='search_list_count']").text(data.length);

				// 테이블 커럼 추가
				$("#search_list_contents_head").empty();
				var strHtml = '<tr>';
				strHtml += ('<th style= "">도형</th>');
				for(i = 0; i < head_kor.length; i++) {
					if(head_eng[i] == pk_column)
						strHtml += ('<th style= "display: none;">' + (head_kor[i] == '' ? head_eng[i] : head_kor[i])+ '</th>');
					else
						strHtml += ('<th style= "">' + (head_kor[i] == '' ? head_eng[i] : head_kor[i])+ '</th>');
				}
				$('#search_list_contents_head').append(strHtml + '</tr>');

				// 테이블 데이터 추가
				$("#search_list_contents_body").empty();
				for(i = 0; i < data.length; i++) {
					strHtml = '<tr>';

					var geom_yn = eval('data[' + i + '].geom_yn');
					if('Y' == geom_yn) {
						if(geom_type.indexOf('POINT') >= 0) {
							strHtml += ('<td style="background-image:url(/jsp/SH/img/point.png);background-repeat:no-repeat;background-position: center center;"></td>');
						} else if(geom_type.indexOf('LINE') >= 0) {
							strHtml += ('<td style="background-image:url(/jsp/SH/img/line.png);background-repeat:no-repeat;background-position: center center;"></td>');
						} else if(geom_type.indexOf('POLYGON') >= 0) {
							strHtml += ('<td style="background-image:url(/jsp/SH/img/polygon.png);background-repeat:no-repeat;background-position: center center;"></td>');
						}
					} else {
						strHtml += ('<td></td>');
					}

					for(j = 0; j < head_eng.length; j++) {
						var key = head_eng[j];
						var value = eval('data[' + i + '].' + key);
						
						if(value == undefined || value == 'undefined') {
							value = '';
						}
						
						if(head_kor[j].includes("면적")||head_kor[j].includes("금액")){
							value = numberWithCommas(value);
						}
						
						if(head_eng[j] == pk_column)
							strHtml += ('<td class="content_data" style="display: none" data-search-title="'+title+'" data-search-type="'+search_type+'" data-table-space="'+table_space+'" data-table-nm="'+table_nm+'" data-pk-key="'+pk_column+'" data-pk-value="'+value+'" data-edit-yn="'+table_edit_yn+'" data-comprehensive-yn="'+comprehensive+'">' + value + '</td>');
						else
							strHtml += ('<td>' + value + '</td>');
					}
					$('#search_list_contents_body').append(strHtml + '</tr>');
				}
				

				// 테이블 이벤트 추가
				$('#search_list_contents_body').off('click');
				$("#search_list_contents_body").on("click", "tr", fn_search_data_item_click);

				// 검색결과 보기
			    $("#search_list_mini").show();
				
			    $('.hScroll').scroll(function() {
	                $('.vScroll').width($('.hScroll').width() + $('.hScroll').scrollLeft());
	            });
		    }
		    
		    //금액 ,표시
		    function numberWithCommas(x) {
		    	if(x==null) return '';
		    	else if(typeof x == 'string') return x.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		    	else return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		    }

		</script>
		
    	<!-- 검색 결과 Side-Panel -->
<div class="side-pane info-mini layer-pop"
	style="width: 900px; height: 600px; display: none;"
	id="search_list_mini">
	
	<!-- Page-Title -->
	<div class="row page-title-box-wrap tit info-mini"
		id='search_list_mini_title_head'>
		<div class="page-title-box info-mini col-xs-12">
			<p class="page-title m-b-0" id="info_mini_address">
				<i class="fa fa-map-o m-r-5"></i> <b><span
					id='search_list_mini_title'></span> 검색결과</b>
			</p>
		</div>
		<!-- <div class="close-btn tab"> -->
		<div class="pop_head_btn close-btn tab">
			<button type="button" class="w-min tab" id="search-list-mini-min">최소화</button>
			<button type="button" class="w-max tab" id="search-list-mini-max">최대화</button>
			<button type="button" class="w-cls tab" id="search-list-mini-close">×</button>
			<!-- <button type="button" class="close tab" id="search_list_mini_close">×</button> -->
		</div>
	</div>
	<!-- End Page-Title -->

	<!--정보 Panel-Content -->
	<div class="row" style='display: block;'id='search_list_contents_group'>
		<div class="col-sm-12">
			<div class="card-box big-card-box last table-responsive searchResult"
				style='border: 0px'>
				<div class="form-group">
					<div class="row" style='display: block'>
						<!-- <h5 class="header-title"><b>목록</b> <span class="small">(전체 <b class="text-orange"><span name='search_list_count'>0</span></b>건)</span></h5> -->
						<div
							style="height: 30px; width: 100%; /* background-color:pink; */ font-weight: bold;">
							<div style="line-height: 20px; float: left;">
								<span
									style="padding: 0 0px; color: #faa765; vertical-align: middle; display: inline-block;"><b>목록</b>
									<span class="small">(전체 <b class="text-orange"><span
											name='search_list_count'>0</span></b>건)
								</span></span>
							</div>
							<div style="float: right">
								<button type="button" class="btn btn-sm btn-teal "
									id='search_list_download'>다운로드</button>
							</div>
						</div>
						<div class="table-wrap m-t-30 fixed_table">
							<div class="hScroll" id="search_list_contents">
								<table
									class="table table-custom table-cen table-num text-center table-hover"
									 style="">
									<thead id="search_list_contents_head">
									</thead>
								</table>
								<div class="vScroll" style="width: 820px;">
									<table
										class="table table-custom  table-cen table-num text-center table-hover">
										<tbody id='search_list_contents_body'>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

<!-- End 정보 Panel-Content -->

      		<div class="btn-wrap tab text-right" id='search_list_button_group'>
      			<!-- <button type="button" class="btn btn-sm btn-teal" style='display: none' id="search_item_edit">속성편집</button> -->
      			<button type="button" class="btn btn-sm btn-custom" style='display: none' id="search_item_edit_save">저장</button>
      			<button type="button" class="btn btn-sm btn-teal" style='display: none' id="search_item_edit_cancel">취소</button>
      			<button type="button" class="btn btn-sm btn-teal" style='display: none' id="search_comprehensive">종합검색</button>
      			<button type="button" class="btn btn-sm btn-inverse" id="search_list_close">닫기</button>
      		</div>
</div>
		
        <!-- End 검색 결과 Side-Panel -->
