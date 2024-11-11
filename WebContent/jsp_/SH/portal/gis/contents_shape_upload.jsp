    	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
		<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

		<script type="text/javascript">
			$(document).ready(function(){

				Date.prototype.yyyymmdd = function()
				{
				    var yyyy = this.getFullYear().toString();
				    var mm = (this.getMonth() + 1).toString();
				    var dd = this.getDate().toString();

				    return yyyy + (mm[1] ? mm : '0' + mm[0]) + (dd[1] ? dd : '0' + dd[0]);
				}

				// 창 minimize / maxmise
				var shape_is_min = false;
				var shape_mini_width;
				var shape_mini_height;

				$('#shape-mini-min').click(function() {
					if(!shape_is_min) {
						shape_mini_width = $("#shape-mini").width();
						shape_mini_height = $("#shape-mini").height();

						$("#shpaeRecordContents").parent().parent().css('display', 'none');

						$("#shape_convert_condition").css('display', 'none')
						$("#shape_convert_button_group").css('display', 'none')

						$("#shape_convert_title").css('border-radius', '0px / 0px');
						$("#shape-mini").css('border-radius', '0px / 0px');
						$("#shape-mini").css('width', 600);
						$("#shape-mini").css('height', 40);

						shape_is_min = true;
					}
			    });

			    $('#shape-mini-max').click(function() {
					if(shape_is_min) {
				    	$("#shpaeRecordContents").parent().parent().css('display', 'block');

				    	$("#shape_convert_condition").css('display', 'block')
						$("#shape_convert_button_group").css('display', 'block')

						$("#shape_convert_title").css('border-radius', '10px 10px 0 0');
				    	$("#shape-mini").css('border-radius', '10px 10px 10px 10px');
				    	$("#shape-mini").css('width', shape_mini_width);
				    	$("#shape-mini").css('height', shape_mini_height);

						shape_is_min = false;
					}
			    });

			    $('#shape-mini-close, #shape_close').click(function() {
					$("#shape-mini").hide();
			    });

			    $("#shape-mini").resizable({
			   		minWidth: 800,
			    	minHeight: 600,
			    	maxHeight: 600,
			    });

			    $("#shape_reset").click(function() {
			    	$('#shape_load_file_nm_display').text('선택 파일이 없습니다.');
			    	$('#shape_load_file_nm_display > tbody > tr').remove();
			    	filesShapeTempArr = [];

			    	$("span[name*='shpaeRecordListCount']").text("0 / 0");

			    	$("#shpaeRecordContentsHead").empty();
					$("#shapeRecordContentsBody").empty();

					$("#fileShapeAddForm")[0].reset();

		    		$("#t_srs").val('3857');
		    		$('#t_srs').attr('disabled', true);
			    	$("#shape_load_to_map").prop("checked", true);

			    	$('#shape_to_local_save').hide();
			    	$('#shape_to_server_save').hide();
			    	$('#shape_to_view_map').hide();

			    	shapeData = '';
			    	if(vectorLayer != null || vectorLayer != ''){
			    		vectorSource.clear();
			    		geoMap.removeLayer(vectorLayer);
			    	}
			    });

				var filesShapeAllow = ['shp', 'shx', 'dbf', 'prj', 'zip', 'SHP', 'SHX', 'DBF', 'PRJ', 'ZIP'];
				var filesShapeTempArr = [];

				function addShapeFiles(e) {
					$('#shape_load_file_nm_display > tbody > tr').remove();

				    var files = e.target.files;
				    var filesArr = Array.prototype.slice.call(files);
				    var filesArrLen = filesArr.length;
				    var filesTempArrLen = filesShapeTempArr.length;

				    if(filesArrLen == 0)
				    	return;

					filesShapeTempArr = [];

				    for(var i=0; i<filesArrLen; i++ ) {
				        var ext  = filesArr[i].name.split('.').pop().toLowerCase();
				        var msg  = ($.inArray(ext, filesShapeAllow) == -1 ? '허용되지 않은 파일 입니다.' : '');
				        var size = Math.round(filesArr[i].size / 1024, 2)

				        if($.inArray(ext, filesShapeAllow) == -1) {
				        	continue;
				        }

				        if(filesArr[i].name.indexOf('.prj') > 0) {
					        var formData = new FormData();
							formData.append("files", filesArr[i]);

							$.ajax({
							    type : "POST",
							    url : "<%=RequestMappingConstants.API_UPLOAD_PRJ%>",
							    data : formData,
							    processData: false,
							    contentType: false,
				  				error : function(response, status, xhr) {
				  					if(xhr.status =='403'){
				  						alert('PRJ 파일 업로드를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
				  					}
				  				},
				  			    beforeSend: function() { $('html').css("cursor", "wait"); },
				  			    complete: function() { $('html').css("cursor", "auto"); },
								success: function(data) {
									if(data.result == 'Y' && data.epsgInfo != '') {
										$('#s_srs').val(data.epsgInfo.substring(5));
									}
								}
							});
				        }

						filesShapeTempArr.push(filesArr[i]);

				        if(filesArr[i].name.indexOf('.zip') > 0 || filesArr[i].name.indexOf('.shp') > 0 ) {
					        $('#shape_load_file_nm_display').html(filesArr[i].name);
					        $("#shape_load_file_nm_display > tbody").append("<tr class='template-upload fade in'><td</td></tr>");
				        }
				    };

			    	$('#shape_to_local_save').show();
			    	$('#shape_to_server_save').show();
			    	$('#shape_to_view_map').show();

				    $(this).val('');
				  	$("#shape_load_file_nm").off("change")
				}

			    $('#shape_load_file_choose').click(function(e) {
			    	$("#shape_load_file_nm").on("change", addShapeFiles);
			    	$('#shape_load_file_nm').trigger('click');
			    });

			    var isConverting = false;
			    var shapeData = '';
			    function fn_shape_processing(format, s_srs, t_srs, s_delete, t_delete) {
			        var formData = new FormData();
					for(var i=0, filesTempArrLen = filesShapeTempArr.length; i<filesTempArrLen; i++) {
					   formData.append("files", filesShapeTempArr[i]);
					}
					formData.append("format", format);
					formData.append("s_srs", 'EPSG:' + s_srs);
					formData.append("t_srs", 'EPSG:' + t_srs);
					//formData.append("s_delete", s_delete);
					//formData.append("t_delete", t_delete);

					$.ajax({
					    type : "POST",
					    url : "<%=RequestMappingConstants.API_UPLOAD_SHP%>",
					    data : formData,
					    processData: false,
					    contentType: false,
		  				error : function(response, status, xhr) {
		  					if(xhr.status =='403'){
		  						alert('파일 업로드를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
		  					}
		  				},
		  			    beforeSend: function() { $('html').css("cursor", "wait"); },
		  			    complete: function() { $('html').css("cursor", "auto"); },
						success: function(data) {
							if(data.result == 'Y' && data.groupSourceInfo != '') {
								var groupSourceInfo  = data.groupSourceInfo;
								var groupConvertInfo = data.groupConvertInfo;
								var dataUrl 	= data.dataUrl;
								var columnCount = data.columnCount;
								var columnHeadr = data.columnInfo;
								var recordCount = 0;
								var recordTotal = [];

								if(format == 'GeoJSON') {
									$.getJSON(dataUrl, function(data) {
										recordCount = data.features.length;
										recordTotal = data.features;

										//console.log(columnCount, columnHeadr)
										//console.log(recordCount, recordTotal)

										// 미리보기 건수
										var loopCount = $("#preview_count").val();

										// 전체 데이터 건수
										 $("span[name*='shpaeRecordListCount']").text(loopCount + " / " + recordCount);

										// 테이블 커럼 추가
										$("#shpaeRecordContentsHead").empty();

										var strHtml = '<tr>';
										strHtml += ('<th style= "position: sticky; top: 0;">순서</th>');
										for(i = 0; i < columnCount; i++) {
											strHtml += ('<th style= "position: sticky; top: 0;">' + columnHeadr[i] + '</th>');
										}
										//strHtml += ('<th style= "position: sticky; top: 0;">좌표</th>');
										$('#shpaeRecordContentsHead').append(strHtml + '</tr>');

										// 테이블 데이터 추가
										$("#shapeRecordContentsBody").empty();
										for(i = 0; i < loopCount; i++) {
											strHtml = '<tr>';
											strHtml += ('<td>' + (i+1) + '</td>');
											for(j = 0; j < columnCount; j++) {
												strHtml += ('<td>' + recordTotal[i].properties[columnHeadr[j]] + '</td>');
											}
											//strHtml += ('<td>' + recordTotal[i].geometry.coordinates + '</td>');
											$('#shapeRecordContentsBody').append(strHtml + '</tr>');
										}

								    	$('#shape_to_local_save').show();
								    	$('#shape_to_server_save').show();
								    	$('#shape_to_view_map').show();

								    	$('#shape-mini-min').trigger('click');
								    	$('#shape-mini').css('top', '');
								    	$('#shape-mini').css('left', '');
								    	$('#shape-mini').css('right', '');
								    	$('#shape-mini').css('bottom', '');
								    	$("#shape-mini").css("top", "20px");
								    	$("#shape-mini").css("left", "70px");

										if(toggles){
											main_toggle();
										}

										shapeData = data;
										fn_gis_map_draw_geojson(shapeData);

										alert('총 ' + recordCount + '입니다.');
									});
								} else {
									var save_nm = $('#shape_load_file_nm_display').text().toLowerCase().replace(/.zip/g, '') .replace(/.shp/g, '');
									var save_file_nm = save_nm + "_" + s_srs + "_" + t_srs + "_" + (new Date()).yyyymmdd();

									downloadLink = document.createElement("a");
								    document.body.appendChild(downloadLink);
							        downloadLink.href = dataUrl;
							        downloadLink.target = '_blank';
							        downloadLink.download = save_file_nm + ".shp";
							        downloadLink.click();
							        document.body.removeChild(downloadLink);

									downloadLink = document.createElement("a");
								    document.body.appendChild(downloadLink);
							        downloadLink.href = dataUrl.replace(/.shp/g, '.shx')
							        downloadLink.target = '_blank';
							        downloadLink.download = save_file_nm + ".shx";
							        downloadLink.click();
							        document.body.removeChild(downloadLink);

									downloadLink = document.createElement("a");
								    document.body.appendChild(downloadLink);
							        downloadLink.href = dataUrl.replace(/.shp/g, '.dbf')
							        downloadLink.target = '_blank';
							        downloadLink.download = save_file_nm + ".dbf";
							        downloadLink.click();
							        document.body.removeChild(downloadLink);
								}

								if(s_delete == true && groupSourceInfo != '') {
									$.ajax({
									    type : "POST",
									    url : "<%=RequestMappingConstants.API_UPDATELIST%>",
									    data : {
									    	groupNo: groupSourceInfo
									    },
									    dataType: 'json',
						  				error : function(response, status, xhr){
						  					if(xhr.status =='403'){
						  						alert('파일 삭제 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
						  					}
						  				},
										success: function(data) {
											//console.log(data);
										}
									});
								}

								if(t_delete == true && groupConvertInfo != '') {
									$.ajax({
									    type : "POST",
									    url : "<%=RequestMappingConstants.API_UPDATELIST%>",
									    data : {
									    	groupNo: groupConvertInfo
									    },
									    dataType: 'json',
						  				error : function(response, status, xhr){
						  					if(xhr.status =='403'){
						  						alert('파일 삭제 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
						  					}
						  				},
										success: function(data) {
											//console.log(data);
										}
									});
								}
							}
						}
					});
			    }

			    function fn_shape_processing_condition() {
			    	var origin_epsg  = $("#s_srs option:checked").val();
			    	var convert_epsg = $("#t_srs option:checked").val();
			    	var convert_file = $("#shape_load_file_nm_display").text();

			    	if(filesShapeTempArr.length == 0 || convert_file == '' || convert_file == '선택 파일이 없습니다.') {
			    		alert('변환할 파일을 선택하세요.');
			    		return false;
					}
			    	if(convert_file.indexOf('.shp') > 0 && filesShapeTempArr.length < 4) {
			    		alert('변환할 파일을 선택하세요.\n\nShape을 변환하시려면 [.shp], [.shx], [.dbf]를 모두 선택하셔야 합니다.');
			    		return false;
			    	}
					if(origin_epsg == '' && convert_epsg != '') {
			    		alert('원본 좌표를 선택하세요.');
			    		return false;
			    	}
					else if(origin_epsg != '' && convert_epsg == '') {
			    		alert('변환 좌표를 선택하세요.');
			    		return false;
					}
					/*else if(origin_epsg != '' && convert_epsg != '' && origin_epsg == convert_epsg) {
			    		alert('동일한 좌표룰 선택하셨습니다. 변환을 실행하지 않습니다.');
			    		return false;
			    	}*/

					return true;
			    }

			    $('#shape_load_to_map').click(function() {
					if($('input:checkbox[id="shape_load_to_map"]').is(":checked") == true) {
						$("#t_srs").val('3857');
						$('#t_srs').attr('disabled', true);
					} else {
						$("#t_srs").val('');
						$('#t_srs').attr('disabled', false);
					}
			    });

			    $('#shape_to_local_save').click(function() {
			    	if(fn_shape_processing_condition()) {
				    	if(confirm('변환을 요청하셨습니다. 작업을 진행 하시겠습니까?')) {
				    		var s_srs = $("#s_srs option:checked").val();
					    	var t_srs = $("#t_srs option:checked").val();

				    		setTimeout(fn_shape_processing('ESRI Shapefile', s_srs, t_srs, true, true), 1000);
				    		isConverting = true;
				    	} else {
				    		alert('작업을 취소 하셨습니다.')
				    	}
			    	}
			    });

			    $('#shape_to_server_save').click(function() {
		    		$("#t_srs").val('3857');
		    		$('#t_srs').attr('disabled', true);
			    	$("#shape_load_to_map").prop("checked", true);

			    	if(fn_shape_processing_condition()) {
				    	if(confirm('변환을 요청하셨습니다. 작업을 진행 하시겠습니까?')) {
					    	var s_srs = $("#s_srs option:checked").val();
					    	var t_srs = $("#t_srs option:checked").val();

				    		setTimeout(fn_shape_processing('GeoJSON', s_srs, t_srs, true, false), 1000);
				    		isConverting = true;
				    	} else {
				    		alert('작업을 취소 하셨습니다.')
				    	}
			    	}
			    });

			    $('#shape_to_view_map').click(function() {
			    	if(shapeData != '') {
				    	$('#shape-mini-min').trigger('click');
				    	$('#shape-mini').css('top', '');
				    	$('#shape-mini').css('left', '');
				    	$('#shape-mini').css('right', '');
				    	$('#shape-mini').css('bottom', '');
				    	$("#shape-mini").css("top", "20px");
				    	$("#shape-mini").css("left", "70px");

						if(toggles){
							main_toggle();
						}

						fn_gis_map_draw_geojson(shapeData);

			    		return;
			    	}

		    		$("#t_srs").val('3857');
		    		$('#t_srs').attr('disabled', true);
			    	$("#shape_load_to_map").prop("checked", true);

			    	if(fn_shape_processing_condition()) {
				    	if(confirm('변환을 요청하셨습니다. 작업을 진행 하시겠습니까?')) {
					    	var s_srs = $("#s_srs option:checked").val();
					    	var t_srs = $("#t_srs option:checked").val();

				    		setTimeout(fn_shape_processing('GeoJSON', s_srs, t_srs, true, true), 1000);
				    		isConverting = true;
				    	} else {
				    		alert('작업을 취소 하셨습니다.')
				    	}
			    	}
			    });

			    function fn_shp_epsg_list_reload() {
					$.ajax({
					    type : "POST",
					    url : "<%=RequestMappingConstants.WEB_GIS_SHAPEUPLOAD_EPSG_LIST%>",
						data: {},
					    dataType: 'json',
		  				error : function(response, status, xhr){
		  					if(xhr.status =='403'){
		  						alert('좌표 체계 목륵 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
		  					}
		  				},
						success: function(data) {
							// 좌표 설정
							$('#s_srs').empty();
							$('#s_srs').append('<option value=>선택</option>');
							$('#t_srs').empty();
							$('#t_srs').append('<option value=>선택</option>');
							for(i = 0; i < data.epsgInfo.length; i++) {
								var option1 = $("<option value='" + data.epsgInfo[i].srid + "'>EPSG:" + data.epsgInfo[i].srid + "</option>");
								var option2 = $("<option value='" + data.epsgInfo[i].srid + "'>EPSG:" + data.epsgInfo[i].srid + "</option>");
            					$('#s_srs').append(option1);
            					$('#t_srs').append(option2);
							}

							// 미리보기 디폴트 좌표 설정
							$('#shape_load_to_map').trigger('click');
						}
					});
			    }

			    fn_shp_epsg_list_reload();
			    $('.hScroll_shp').scroll(function() {
	                $('.vScroll_shp').width($('.hScroll_shp').width() + $('.hScroll_shp').scrollLeft());
	            });
			});
		</script>

    	<!-- Shape Upload Side-Panel -->
		<div class="side-pane info-mini layer-pop" id="shape-mini" style="width: 900px; height:600px; top: 0px; display: none;">

            <!-- Page-Title -->
            <div class="row page-title-box-wrap tit info-mini" id='shape_convert_title'>
                <div class="page-title-box info-mini col-xs-12">
                    <p class="page-title m-b-0" id="info_mini_address">
                    	<i class="fa fa-map-o m-r-5"></i>
                  		<b>ESRI Shape 업로드</b>
                    </p>
                </div>
                <!-- <div class="close-btn tab"> -->
                <div class="pop_head_btn close-btn tab">
                    <button type="button" class="w-min tab" id="shape-mini-min">최소화</button>
					<button type="button" class="w-max tab" id="shape-mini-max">최대화</button>
                    <button type="button" class="w-cls tab" id="shape-mini-close">×</button>
                    <!-- <button type="button" class="close tab" id="shape-mini-close">×</button> -->
                </div>
            </div>
            <!-- End Page-Title -->

			<!--정보 Panel-Content -->
	    	<div class="row" id='shape_convert_condition' style='display: block;'>
				<div class="col-sm-12">
	                <div class="card-box big-card-box last table-responsive searchResult" style='border: 0px'>
						<form id='fileShapeAddForm' enctype="multipart/form-data">
						<div class="form-group">
	                        <h5 class="header-title m-t-0 m-b-30"><b>조건 선택</b></h5>
							<div class="row">
								<div class="col-md-12">
									<input type="hidden" id="shape_group_no" />
									<input id='shape_load_file_nm' name="shape_load_file_nm" type="file" style='display: none;' maxlength="1" data-maxsize="51200" data-maxfile="51200" accept=".shp, .shx, .dbf, .prj, .zip" multiple />
                                    <label for="shape_load_file_nm" class="col-md-1 control-label">변환파일<br>(50MB)</label>
									<div class="col-md-3" id="shape_load_file_nm_display">
										선택 파일이 없습니다.
                                    </div>
                                    <div class="col-md-2">
	                                     <button type="button" class="btn btn-custom btn-md" id="shape_load_file_choose">
				                        	<span><i class="fa fa-check-circle m-r-5"></i>파일선택</span>
				                    	</button>
				                    </div>
                                     <label for="s_srs" class="col-md-1 control-label">미리보기</label>
                                     <div class="col-md-2">
                                         <select class="form-control" id="preview_count" name="preview_count" title ="미리보기">
                                         	<option value="5">5</option>
                                         	<option value="10">10</option>
                                         	<option value="50">50</option>
                                         	<option value="100">100</option>
                                         </select>
                                     </div>
									<div class="col-md-3" style='text-align: middle'>
										<input   id="shape_load_to_map" name="shape_load_to_map" type="checkbox">&nbsp;&nbsp;지도 좌표로 변환
                                    </div>
	                        	</div>
							</div>
							<p></p>
						    <div class="row">
						    	<div class="col-md-12">
                                     <label for="s_srs" class="col-md-1 control-label">원본좌표</label>
                                     <div class="col-md-5">
                                         <select class="form-control" id="s_srs" name="s_srs" title ="원본좌표">
                                         	<option value="">선택</option>
                                         </select>
                                     </div>
                                     <label for="t_srs" class="col-md-1 control-label">변환좌표</label>
                                     <div class="col-md-5">
                                         <select class="form-control" id="t_srs" name="t_srs" title ="변환좌표">
                                         	<option value="">선택</option>
                                         </select>
                                     </div>
		                    	</div>
	                        </div>
					        <div class="row" style='display: block'>
			                    <h5 class="header-title"><b>목록</b> <span class="small">(전체 <b class="text-orange"><span name='shpaeRecordListCount'>0 / 0</span></b>건)</span></h5>
			                    <div class="table-wrap m-t-30 fixed_table">
			                    <div class="hScroll_shp">
			                        <table class="table table-custom table-cen table-num text-center table-hover" id='shpaeRecordContents'>
			                            <thead id='shpaeRecordContentsHead'>
			                            </thead>
			                            </table>
			                            <div class="vScroll_shp" style="width: 810px;">
			                            <table
										class="table table-custom  table-cen table-num text-center table-hover">
			                            <tbody id='shapeRecordContentsBody'>
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

      		<div class="btn-wrap tab text-right" id='shape_convert_button_group'style="position:static;">
      			<!-- <button type="button" class="btn btn-sm btn-teal" style='display: none' id="shape_to_local_save">변환 & 다운로드</button> -->
      			<!-- <button type="button" class="btn btn-sm btn-teal" style='display: none' id="shape_to_server_save">변환 & 서버등록</button> -->
      			<button type="button" class="btn btn-sm btn-teal" style='display: none' id="shape_to_view_map">지도로 보기</button>

      			<button type="button" class="btn btn-sm btn-inverse" id="shape_reset">초기화</button>
      			<button type="button" class="btn btn-sm btn-inverse" id="shape_close">닫기</button>
      		</div>

		</div>
        <!-- End  Shape Upload Side-Panel -->