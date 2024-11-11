
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>


<script type="text/javascript">
			$(document).ready(function(){

				// 창 minimize / maxmise
				var geocoding_is_min = false;
				var geocoding_mini_width;
				var geocoding_mini_height;
				$('#geocoding-mini-min').click(function() {
					if(!geocoding_is_min) {
						geocoding_mini_width = $("#geocoding-mini").width();
						geocoding_mini_height = $("#geocoding-mini").height();

						$("#geocoding_convert_condition").css('display', 'none')
						$("#geocoding_convert_button_group").css('display', 'none')

						$("#geocoding_convert_title").css('border-radius', '0px / 0px');
						$("#geocoding-mini").css('border-radius', '0px / 0px');
						$("#geocoding-mini").css('width', 600);
						$("#geocoding-mini").css('height', 40);

						geocoding_is_min = true;
					}
			    });

			    $('#geocoding-mini-max').click(function() {
			    	if(geocoding_is_min) {
				    	$("#geocoding_convert_title").css('border-radius', '10px 10px 0 0');
				    	$("#geocoding-mini").css('border-radius', '10px 10px 10px 10px');
				    	$("#geocoding-mini").css('width', geocoding_mini_width);
				    	$("#geocoding-mini").css('height', geocoding_mini_height);

				    	$("#geocoding_convert_condition").css('display', 'block')
						$("#geocoding_convert_button_group").css('display', 'block')

						geocoding_is_min = false;
			    	}
			    });

			    // 닫기
			    $('#geocoding-mini-close, #geocoding_close').click(function() {
					$("#geocoding-mini").hide();
					$('#geocoding_epsg_pop').hide();
			    });

			    // 창 크기조절
			    $("#geocoding-mini").resizable({
			   		minWidth: 800,
			    	minHeight: 600,
			    	maxHeight: 600,
			    });

			    // 컨텐츠 시작
			    $("#geocoding_reset").click(function() {
			    	$('#geocoding_load_file_nm_display').text('선택 파일이 없습니다.');
			    	$('#geocoding_load_file_nm_display > tbody > tr').remove();
			    	filesGeocodingTempArr = [];

			    	$('#geocoding_save_file_nm').val('');

			    	$("span[name*='geocodingListCount']").text("0 / 0");

			    	$("#geocodingContentsHead").empty();
					$("#geocodingContentsBody").empty();

					$("#fileGeocodingAddForm")[0].reset();

			    	$('#geocoding_to_excel_save').hide();
			    	//$('#geocoding_on_server').hide();
			    	$('#geocoding_on_map').hide();

			    	$('#geocoding_start').hide();

			    	geocoderData.length = 0;
			    	if(geocoderLayer != null || geocoderLayer != ''){
						geocoderLayer.getSource().clear();
						geoMap.removeLayer(geocoderLayer);
					}
			    });

			    $("#geocoding_epsg_desc").click(function() {
			    	if($('#geocoding_epsg_pop').css('display') == 'none') {
				    	$('#geocoding_epsg_pop').show();
				    	$('#geocoding_epsg_pop').center();
			    	} else {
			    		$('#geocoding_epsg_pop').hide();
			    	}
			    });
			    $("#geocoding_epsg_pop").click(function() {
			    	$('#geocoding_epsg_pop').hide();
			    });

			    var zoom = 17;
				var recordCount = 0;
				var processCount = 0;
			    var isComplete = false;
			    var isConverting = false;
			    var geocoderData = [];

			    var geocoder_move = function(epsg, x,y){
			        geoMap.getView().setCenter(ol.proj.transform([ x, y ], 'EPSG:' + epsg , "EPSG:3857")); // 지도 이동
			        geoMap.getView().setZoom(zoom);
			    }

			    var geocoder_draw = function(data) {
					if(geocoderLayer != null || geocoderLayer != ''){
						geocoderLayer.getSource().clear();
						geoMap.removeLayer(geocoderLayer);
					}

			        for(i=0; i<data.length; i++) {
						var x = data[i].x;
						var y = data[i].y;
						var s = data[i].status;
						var epsg = data[i].epsg;
						var point = ol.proj.transform([ x, y ], 'EPSG:' + epsg , "EPSG:3857")
						var feature = new ol.Feature({ geometry: new ol.geom.Point(point) });
						feature.set('status', s);

						geocoderLayer.getSource().addFeature(feature);
			        }

			        geoMap.addLayer(geocoderLayer);
			        geoMap.getView().fit(geocoderLayer.getSource().getExtent(), geoMap.getSize());
			        geoMap.getView().animate({
			      	  zoom: geoMap.getView().getZoom() - 1,
			      	  duration: 500
			      	});
			    	geoMap.renderSync();
			    	geoMap.render();
			    }

			    /**
			     *  지오코더 호출
			     *  crs는 output 좌표 체계
			     */
			    // C1314EF3-8396-3600-95A8-AC6FE95A4A91 (예전)
			    //37C45FB4-085E-33DF-BE02-E9E505572E78 (예전)
			    var geocoder = function(param){
			        $.ajax({
			            type: "get",
			            url: "http://api.vworld.kr/req/address?service=address&version=2.0&request=getcoord&format=json",
			            data : {
			    			apiKey : '6436A16F-8375-331E-A0C0-FB4157C858C9',
			    			address : param.addr,
			    			type: $("#geocoding_convert_addr option:checked").val(),
			    			crs: 'EPSG:' + $("#geocoding_convert_epsg option:checked").val()
			    		},
			            dataType: 'jsonp',
			            success: function(data) {
			                //console.log(data);

							processCount++;
							$("span[name*='geocodingListCount']").text(processCount + " / " + recordCount);

						    if(data.response.status == 'OK' && data.response.result.point != undefined) {
								var epsg = $("#geocoding_convert_epsg option:checked").val();
				    			var row_index = param.index;
								var x_index = param.x_index;
								var y_index = param.y_index;
								var x_cell = '#geocodingContentsBody > tr:eq(' + row_index + ')' + ' > td:eq(' + x_index + ')';
								var y_cell = '#geocodingContentsBody > tr:eq(' + row_index + ')' + ' > td:eq(' + y_index + ')';
								var x_pos = data.response.result.point.x*1;
								var y_pos = data.response.result.point.y*1;

								// 셀은 요청 좌표계 표출
								$(x_cell).text(x_pos);
								$(y_cell).text(y_pos);

								$('#geocodingContentsBody > tr:eq(' + row_index + ')').click(function() {
									geocoder_move(epsg, x_pos,y_pos);
								})

								// 지도 표출용 데이터 추가
								geocoderData.push({epsg: epsg, x: x_pos, y: y_pos, status: data.response.status})
							}

							if(processCount == recordCount && geocoderData.length > 0) {
					    		geocoder_draw(geocoderData);
					    	}
			            }
			        });
			    }
			     
			    /**
			     *  역 지오코더 호출
			     *  crs는 input 좌표 체계
			     */
			    var geocoder_reverse = function(param){
			        $.ajax({
			            type: "get",
			            url: "http://api.vworld.kr/req/address?service=address&version=2.0&request=getaddress&format=json",
			            data : {
			    			apiKey : '6436A16F-8375-331E-A0C0-FB4157C858C9',
			    			point : param.x + "," + param.y,
			    			type: $("#geocoding_convert_addr option:checked").val(),
			    			crs: 'EPSG:' + $("#geocoding_convert_epsg option:checked").val()
			    		},
			            dataType: 'jsonp',
			            success: function(data) {
			            	//console.log(data);

							processCount++;
							$("span[name*='geocodingListCount']").text(processCount + " / " + recordCount);

							var epsg = $("#geocoding_convert_epsg option:checked").val();
			    			var row_index = param.index;
							var addr_index = param.addr_index;
							var add_cell = '#geocodingContentsBody > tr:eq(' + row_index + ')' + ' > td:eq(' + addr_index + ')';
							var point = ol.proj.transform([ param.x*1, param.y*1], 'EPSG:' + $("#geocoding_convert_epsg option:checked").val(), "EPSG:3857");

							$('#geocodingContentsBody > tr:eq(' + row_index + ')').click(function() {
								geocoder_move(epsg, param.x, param.y);
							})

			    			if(data.response.status == 'OK') {
			    				$(add_cell).text(data.response.result[0].text);

								geocoderData.push({epsg: epsg, x: param.x, y: param.y, status: data.response.status})
			    			} else {
			    				geocoderData.push({epsg: epsg, x: param.x, y: param.y, status: data.response.status})
			    			}

							if(processCount == recordCount && geocoderData.length > 0) {
					    		geocoder_draw(geocoderData);
					    	}
			            }
			        });
			    }

			    var fn_geocoding_processing = function() {
			    	console.log('fn_geocoding_processing start!');
			    	processCount = 0;
			    	$("span[name*='geocodingListCount']").text("0 / " + recordCount);

					//var data_array = new Array();

					geocoderData.length = 0;

			    	if($("#geocoding_convert_type option:checked").val() == 'CONVER_TYPE_A') {
				    	var addr_index = $("#geocoding_convert_column1 option:checked").val();
				    	var x_index = $('#geocodingContentsBody > tr:eq(0) > td').length - 3;
				    	var y_index = $('#geocodingContentsBody > tr:eq(0) > td').length - 2;

				    	$('#geocodingContentsBody > tr').each(function(index, tr) {
				    		if(isConverting == true) {
								var td = $(tr).children();
								td.each(function(i) {
									if(i == addr_index) {
										//data_array.push({index: index, addr : td.eq(i).text(), x: x_index, y: y_index});
										geocoder({index: index, addr : td.eq(i).text(), x_index: x_index, y_index: y_index});
									}
								});
				    		} else {
				    			return false;
				    		}
				    	})
			    	} else {
				    	var x_index = $("#geocoding_convert_column1 option:checked").val();
				    	var y_index = $("#geocoding_convert_column2 option:checked").val();
				    	var addr_index = $('#geocodingContentsBody> tr:eq(0) > td').length - 1;

				    	$('#geocodingContentsBody > tr').each(function(index, tr) {
				    		if(isConverting == true) {
								var td = $(tr).children();
								var x = -1;
								var y = -1;
								td.each(function(i) {
									if(i == x_index) {
										x = td.eq(i).text();
									}
									if(i == y_index) {
										y = td.eq(i).text();
									}
								});

								if(x > -1 && y > -1) {
									//data_array.push({index: index, x: x, y: y, addr: addr_index});
									geocoder_reverse({index: index, x: x, y: y, addr_index: addr_index});
								}
				    		} else {
				    			return false;
				    		}
				    	})
			    	}

					//console.log(JSON.stringify(data_array));
			    	//data_array = [];

			    	isConverting = false;
			    	isComplete = true;
			    	if(confirm('변환 작업이 완료 되었습니다.지도로 이동 하시겠습니까?')) {
			    		$('#geocoding_on_map').trigger('click');
			    	}

			    	$('#geocoding_to_excel_save').show();
			    	//$('#geocoding_on_server').show();
			    	$('#geocoding_on_map').show();

			    }

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

				var filesGeocodingAllow = ['csv','CSV'];
				var filesGeocodingTempArr = [];

				function addGeocodingFiles(e) {
					$('#geocoding_load_file_nm_display > tbody > tr').remove();

				    var files = e.target.files;
				    var filesArr = Array.prototype.slice.call(files);
				    var filesArrLen = filesArr.length;
				    var filesTempArrLen = filesGeocodingTempArr.length;

				    if(filesArrLen == 0)
				    	return;

					filesGeocodingTempArr = [];

				    for(var i=0; i<filesArrLen; i++ ) {
				        var ext  = filesArr[i].name.split('.').pop().toLowerCase();
				        var msg  = ($.inArray(ext, filesGeocodingAllow) == -1 ? '허용되지 않은 파일 입니다.' : '');
				        var size = Math.round(filesArr[i].size / 1024, 2)

				        if($.inArray(ext, filesGeocodingAllow) == -1) {
				        	continue;
				        }

				        filesGeocodingTempArr.push(filesArr[i]);

				        $('#geocoding_load_file_nm_display').html(filesArr[i].name);
				        $("#geocoding_load_file_nm_display > tbody").append("<tr class='template-upload fade in'><td</td></tr>");

				        $('#geocoding_save_file_nm').val(filesArr[i].name.replace(/.csv/g, '.xls'));
				    };

				    if(filesGeocodingTempArr.length > 0) {
						var formData = new FormData();
						for(var i=0, filesTempArrLen = filesGeocodingTempArr.length; i<filesTempArrLen; i++) {
						   formData.append("files", filesGeocodingTempArr[i]);
						}
						//formData.append("separator", $("#geocoding_line_seperator option:selected").val())

						$.ajax({
						    type : "POST",
						    url : "<%=RequestMappingConstants.API_UPLOAD_CSV%>",
						    data : formData,
						    processData: false,
						    contentType: false,
			  				error : function(response, status, xhr){
			  					if(xhr.status =='403'){
			  						alert('파일 업로드를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
			  					}
			  				},
							success: function(data) {
								if(data.result == 'Y' && data.groupInfo != '') {
									recordCount = 0;
									processCount = 0;

									var dataUrl = data.dataUrl;
									var columnCount = data.columnCount;
									var columnHeadr = data.columnInfo;
									var recordTotal = [];

									$.getJSON(dataUrl, function(data) {
										recordCount = data.features.length;
										recordTotal = data.features;

										//console.log(columnCount, columnHeadr)
										//console.log(recordCount, recordTotal)

										// 컬럼 선택 옵션 추가
										$('#geocoding_convert_column1').empty();
										$('#geocoding_convert_column1').append('<option value=>선택</option>')
										$('#geocoding_convert_column2').empty();
										$('#geocoding_convert_column2').append('<option value=>선택</option>')
										for(i = 0; i < columnCount; i++) {
											var option1 = $("<option value='" + i + "'>" + columnHeadr[i] + "</option>");
		                					$('#geocoding_convert_column1').append(option1);
											var option2 = $("<option value='" + i + "'>" + columnHeadr[i] + "</option>");
		                					$('#geocoding_convert_column2').append(option2);
										}


										// 전체 데이터 건수
										$("span[name*='geocodingListCount']").text("0 / " + recordCount);

										// 테이블 커럼 추가
										$("#geocodingContentsHead").empty();
										var strHtml = '<tr>';
										for(i = 0; i < columnCount; i++) {
											strHtml += ('<th style= "">' + columnHeadr[i] + '</th>');
										}
										$('#geocodingContentsHead').append(strHtml + '</tr>');

										// 테이블 데이터 추가
										$("#geocodingContentsBody").empty();
										for(i = 0; i < recordCount; i++) {
											strHtml = '<tr>';
											for(j = 0; j < columnCount; j++) {
												strHtml += ('<td>' + recordTotal[i].properties[columnHeadr[j]] + '</td>');
											}
											$('#geocodingContentsBody').append(strHtml + '</tr>');
										}
										$('#geocoding_start').show();

										alert('총 ' + recordCount + '건이 로딩 되었습니다.');
									});
								}
							}
						});
				    } else {
				    	alert('선택한 파일이 없습니다. 다시 선택해 주세요.')
				    }

			    	$('#geocoding_to_excel_save').hide();
			    	//$('#geocoding_on_server').hide();
			    	$('#geocoding_on_map').hide();

				    $(this).val('');
				}

			    $('#geocoding_load_file_choose').click(function() {
			    	$('#geocoding_load_file_nm').trigger('click');
			    });

				$("#geocoding_load_file_nm").on("change", addGeocodingFiles);

			    $('#geocoding_convert_type').change(function() {
			    	$("select[name=geocoding_convert_addr]").val('road')
			    	$("select[name=geocoding_convert_column1]").val('')
			    	$("select[name=geocoding_convert_column2]").val('')
			    	$("select[name=geocoding_convert_epsg]").val('3857')

			    	if($("#geocoding_convert_type option:checked").val() == 'CONVER_TYPE_A') {
			    		$('#geocoding_convert_column2').attr('disabled', true);
			    	} else {
				    	$('#geocoding_convert_column2').attr('disabled', false);
			    	}
			    });

			    $('#geocoding_start').click(function() {
			    	console.log('geocoding start!');
			    	var convert_file   = $("#geocoding_load_file_nm_display").text();
			    	var convert_type   = $("#geocoding_convert_type option:checked").text();
			    	var convert_addr  = $("#geocoding_convert_addr option:checked").text();
			    	var convert_column1 = $("#geocoding_convert_column1 option:checked").val();
			    	var convert_column2 = $("#geocoding_convert_column2 option:checked").val();
			    	var convert_epsg   = $("#geocoding_convert_epsg option:checked").val();
			    	if(convert_file == '' || convert_file.indexOf('.csv') < 1) {
			    		alert('변환할 파일을 선택하세요');
			    		return;
					}
			    	if($("#geocoding_convert_type option:checked").val() == 'CONVER_TYPE_A') {	// 주소 -> 좌표
				    	if(convert_addr == '') {
				    		alert('입력 주소 유형을 선택하세요.');
				    		$("#geocoding_convert_addr").focus();
				    		return;
				    	}
				    	if(convert_column1 == '') {
				    		alert('입력 주소 필드를 선택하세요.');
				    		$("#geocoding_convert_column1").focus();
				    		return;
				    	}
						if(convert_epsg == '') {
				    		alert('반환 좌표를 선택하세요.');
				    		$("#geocoding_convert_epsg").focus();
				    		return;
				    	}
			    	} else {																	// 좌표 -> 주소
				    	if(convert_column1 == '') {
				    		alert('입력 X좌표 필드를 선택하세요.');
				    		$("#geocoding_convert_column1").focus();
				    		return;
				    	}
				    	if(convert_column2 == '') {
				    		alert('입력 Y좌표 필드를 선택하세요.');
				    		$("#geocoding_convert_column2").focus();
				    		return;
				    	}
						if(convert_epsg == '') {
				    		alert('입력 좌표계를 선택하세요.');
				    		$("#geocoding_convert_epsg").focus();
				    		return;
				    	}
			    	}

			    	if(confirm(convert_type +' 변환을 요청하셨습니다. 작업을 진행 하시겠습니까?')) {
			    		isComplete = false;
			    		isConverting = true;
			    		setTimeout(fn_geocoding_processing, 1000);
			    	} else {
			    		alert('작업을 취소 하셨습니다.')
			    	}
			    });

			    $('#geocoding_stop').click(function() {
			    	if(isConverting == true) {
			    		if(confirm('진행중인 변환 작업을 취소 하시겠습니까?'))
			    			isConverting = false;
			    	} else {
			    		alert('진행중인 변환 작업이 없습니다.')
			    	}
			    });

			    $('#geocoding_to_excel_save').click(function() {
			    	if(isComplete == true) {
				    	var file = $("#geocoding_save_file_nm").val();
				    	if(file == '') {
				    		alert('저장할 파일명을 입력하세요');
				    		return;
						}

						$('#geocodingContentsHead').attr('border', '1');
						$('#geocodingContentsHead th').css({"background-color": "yellow"});
						$('#geocodingContentsHead th').css({"color": "blue"});

						$('#geocodingContentsBody').attr('border', '1');
						$('#geocodingContentsBody td').css({"background-color": "#CDCDCD"});

						exportTableToExcel('geocodingContents', file);

						$('#geocodingContentsHead').attr('border', '0');
						$('#geocodingContentsHead th').css({"background-color": ""});
						$('#geocodingContentsHead th').css({"color": ""});

						$('#geocodingContentsBody').attr('border', '0');
						$('#geocodingContentsBody td').css({"background-color": ""});
			    	}
			    });

			    $('#geocoding_on_server').click(function() {
			    	alert('기능 지원 예정 입니다.');
		        	return;
			    });

			    $('#geocoding_on_map').click(function() {
			    	$('#geocoding-mini-min').trigger('click');
			    	$('#geocoding-mini').css('top', '');
			    	$('#geocoding-mini').css('left', '');
			    	$('#geocoding-mini').css('right', '');
			    	$('#geocoding-mini').css('bottom', '');
			    	$("#geocoding-mini").css("top", "20px");
			    	$("#geocoding-mini").css("left", "70px");

					if(toggles){
						main_toggle();
					}

					if(geocoderData.length > 0) {
			    		geocoder_draw(geocoderData);
			    	}
			    });

			    function fn_geo_epsg_list_reload() {
					$.ajax({
					    type : "POST",
					    url : "<%=RequestMappingConstants.WEB_GIS_GEOCODING_EPSG_LIST%>",
					    data : {},
					    dataType: 'json',
		  				error : function(response, status, xhr){
		  					if(xhr.status =='403'){
		  						alert('좌표 체계 목륵 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
		  					}
		  				},
						success: function(data) {
							$('#geocoding_convert_epsg').empty();
							$('#geocoding_convert_epsg').append('<option value="">선택</option>');
							for(i = 0; i < data.epsgInfo.length; i++) {
								var option = $("<option value='" + data.epsgInfo[i].srid + "'>EPSG:" + data.epsgInfo[i].srid + "</option>");
            					$('#geocoding_convert_epsg').append(option);
							}
						}
					});
			    }

			    fn_geo_epsg_list_reload();
			    $('.hScroll_geo').scroll(function() {
	                $('.vScroll_geo').width($('.hScroll_geo').width() + $('.hScroll_geo').scrollLeft());
	            });
			});
		</script>

<!-- 지오코딩 Side-Panel -->
<div class="side-pane info-mini layer-pop" id="geocoding-mini"
	style="width: 900px; height: 600px; top: 0px; display: none;">

	<!-- Page-Title -->
	<div class="row page-title-box-wrap tit info-mini"
		id='geocoding_convert_title'>
		<div class="page-title-box info-mini col-xs-12">
			<p class="page-title m-b-0" id="info_mini_address">
				<i class="fa fa-map-o m-r-5"></i> <b>주소변환</b>
			</p>
		</div>
		<!-- <div class="close-btn tab"> -->
		<div class="pop_head_btn close-btn tab">
			<button type="button" class="w-min tab" id="geocoding-mini-min">최소화</button>
			<button type="button" class="w-max tab" id="geocoding-mini-max">최대화</button>
			<button type="button" class="w-cls tab" id="geocoding-mini-close">×</button>
			<!-- <button type="button" class="close tab" id="geocoding-mini-close">×</button> -->
		</div>
	</div>
	<!-- End Page-Title -->

	<!--정보 Panel-Content -->
	<div class="row" id='geocoding_convert_condition'
		style='display: block;'>
		<div class="col-sm-12">
			<div class="card-box big-card-box last table-responsive searchResult"
				style='border: 0px'>
				<form id='fileGeocodingAddForm' enctype="multipart/form-data">
					<div class="form-group">
						<h5 class="header-title m-t-0 m-b-30">
							<b>조건 선택</b>
						</h5>
						<div class="row">
							<div class="col-md-12">
								<!-- <label for="geocoding_line_separator" class="col-md-1 control-label">구분자</label>
                                    <div class="col-md-2">
                                    	<select class="form-control" id=geocoding_line_separator name=geocoding_line_seperator title ="변환유형">
											<option value="," selected>쉼표(,)</option>
											<option value=";">세미콜론(;)</option>
                                        </select>
                                    </div> -->
								<input type="hidden" id="geocoding_group_no" /> <input
									id='geocoding_load_file_nm' name="geocoding_load_file_nm"
									type="file" style='display: none;' maxlength="1"
									data-maxsize="51200" data-maxfile="51200" accept=".csv" /> <label
									for="geocoding_load_file_nm" class="col-md-1 control-label">변환파일</label>
								<div class="col-md-3" id="geocoding_load_file_nm_display">
									선택 파일이 없습니다.</div>
								<div class="col-md-2">
									<button type="button" class="btn btn-custom btn-md"
										id="geocoding_load_file_choose">
										<span><i class="fa fa-check-circle m-r-5"></i>파일선택</span>
									</button>
								</div>
								<label for="geocoding_save_file_nm"
									class="col-md-1 control-label">저장파일</label>
								<div class="col-md-5">
									<input class="form-control" title="저장 파일명"
										id="geocoding_save_file_nm" name="geocoding_save_file_nm"
										placeholder="저장 파일명를 입력하세요" />
								</div>
							</div>
						</div>
						<p></p>
						<div class="row">
							<div class="col-md-12">
								<label for="geocoding_convert_type"
									class="col-md-1 control-label">변환유형</label>
								<div class="col-md-5">
									<select class="form-control" id=geocoding_convert_type
										name=geocoding_convert_type title="변환유형">
										<option value="CONVER_TYPE_A">주소->좌표</option>
										<option value="CONVER_TYPE_B">좌표->주소</option>
									</select>
								</div>
								<label for="geocoding_convert_type"
									class="col-md-1 control-label">주소유형</label>
								<div class="col-md-5">
									<select class="form-control" id="geocoding_convert_addr"
										name="geocoding_convert_addr" title="주소유형">
										<option value="">선택</option>
										<option value="road">새주소</option>
										<option value="parcel">구주소</option>
									</select>
								</div>
							</div>
						</div>
						<p></p>
						<div class="row">
							<div class="col-md-12">
								<label for="geocoding_convert_column1"
									class="col-md-1 control-label">주소필드<br>(경도)
								</label>
								<div class="col-md-3">
									<select class="form-control" id="geocoding_convert_column1"
										name="geocoding_convert_column1" title="주소필드">
										<option value="">선택</option>
									</select>
								</div>
								<label for="geocoding_convert_column2"
									class="col-md-1 control-label">주소필드<br>(위도)
								</label>
								<div class="col-md-3">
									<select class="form-control" id="geocoding_convert_column2"
										name="geocoding_convert_column2" title="주소필드" disabled>
										<option value="">선택</option>
									</select>
								</div>
								<label for="geocoding_convert_epsg"
									class="col-md-1 control-label" id='geocoding_epsg_desc'
									style='cursor: pointer' title='클릭하시면 간락한 좌표계 정보를 확인 할 수 있습니다.'>좌표계</label>
								<div class="col-md-3">
									<select class="form-control" id="geocoding_convert_epsg"
										name="geocoding_convert_epsg" title="좌표계">
										<option value="">선택</option>
									</select>
								</div>
							</div>
						</div>
						<div class="row" style='display: block'>
							<h5 class="header-title">
								<b>목록</b> <span class="small">(전체 <b class="text-orange"><span
										name='geocodingListCount'>0 / 0</span></b>건)
								</span>
							</h5>
							<div class="table-wrap m-t-10 fixed_table">
								<div class="hScroll_geo" id='geocodingContents'>
										<table
											class="table table-custom table-cen table-num text-center table-hover">
											<thead id='geocodingContentsHead'>
											</thead>
											</table>
											<div class="vScroll_geo" style="width: 820px;">
											<table
										class="table table-custom  table-cen table-num text-center table-hover">
											<tbody id='geocodingContentsBody'>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
	<!-- End 정보 Panel-Content -->
	<div class="btn-wrap tab text-right"
		id='geocoding_convert_button_group' style="position:static;">
		<button type="button" class="btn btn-sm btn-teal"
			style='display: none' id="geocoding_to_excel_save">저장(xls)</button>
		<button type="button" class="btn btn-sm btn-teal"
			style='display: none' id="geocoding_on_server">서버저장</button>
		<button type="button" class="btn btn-sm btn-teal"
			style='display: none' id="geocoding_on_map">지도로 보기</button>

		<button type="button" class="btn btn-sm btn-teal"
			style='display: none' id="geocoding_start">변환</button>
		<!-- <button type="button" class="btn btn-gray btn-sm" id="geocoding_stop">정지</button> -->
		<button type="button" class="btn btn-sm btn-inverse"
			id="geocoding_reset">초기화</button>
		<button type="button" class="btn btn-sm btn-inverse"
			id="geocoding_close">닫기</button>
	</div>
</div>

<div id='geocoding_epsg_pop'
	style='position: absolute; display: none; z-index: 1500'>
	<div class="col-sm-12">
		<div class="card-box big-card-box last table-responsive searchResult">
			<table
				class="table table-custom table-cen table-num text-center table-hover">
				<caption>지원좌표계</caption>
				<colgroup>
					<col style="width: 25%">
					<col>
				</colgroup>
				<thead>
					<tr>
						<th scope="col">좌표계</th>
						<th scope="col">설명</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>WGS84 경위도</td>
						<td>EPSG:4326</td>
					</tr>
					<tr>
						<td>GRS80 경위도</td>
						<td>EPSG:4019</td>
					</tr>
					<tr>
						<td>Google Mercator</td>
						<td><b class="text-orange"><span>EPSG:3857(현 시스템
									사용 좌표)</span></b>, EPSG:900913</td>
					</tr>
					<tr>
						<td>서부원점(GRS80)</td>
						<td>EPSG:5180(50만), EPSG:5185</td>
					</tr>
					<tr>
						<td>중부원점(GRS80)</td>
						<td>EPSG:5181(50만), EPSG:5186</td>
					</tr>
					<tr>
						<td>제주원점(GRS80, 55만)</td>
						<td>EPSG:5182</td>
					</tr>
					<tr>
						<td>동부원점(GRS80)</td>
						<td>EPSG:5183(50만), EPSG:5187</td>
					</tr>
					<tr>
						<td>동해(울릉)원점(GRS80)</td>
						<td>EPSG:5184(50만), EPSG:5188</td>
					</tr>
					<tr>
						<td>UTM-K(GRS80)</td>
						<td>EPSG:5179</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>
<!-- End 지오코딩 Side-Panel -->