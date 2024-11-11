
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

<link href="/jsp/SH/css/jquery.minicolors.css" rel="stylesheet"
	type="text/css" />
<link href="/jsp/SH/css/messagebox.css" rel="stylesheet" type="text/css" />
<link href="/jsp/SH/css/bootstrap-treeview.min.css" rel="stylesheet"
	type="text/css" />

<script src="/jsp/SH/js/jquery.minicolors.js"></script>
<script src="/jsp/SH/js/messagebox.js"></script>
<script src="/jsp/SH/js/bootstrap-treeview.min.js"></script>
<script src="/jsp/SH/js/html2canvas.js"></script>

<script
	src="https://cdn.polyfill.io/v2/polyfill.min.js?features=fetch,requestAnimationFrame,Element.prototype.classList,URL"></script>

<script type="text/javascript">

			$(document).ready(function() {
				// 검색어 엔터 이벤트
			    $("#s_theme_serch_nm").keydown(function( event ) {
					if ( event.which == 13 ) {
						fn_search_theme_list(1, recordPerPage);
					 	return;
					}
			    });

			    // 검색 버튼 클릭
				$('#btnThemeSearch').click(function() {
					fn_search_theme_list(1, recordPerPage);
				});

				// 검색 초기화 버튼 클릭
				$('#btnThemeReset').click(function() {
					$("select[name=s_theme_serch_gb]").val("");
					$("input[name=s_theme_serch_nm]").val("");
				});

				// 검색 초기화
				$('#btnThemeSearch').trigger('click');


				////////////////////////////////////////////////////////////////////////////////////
				// 이미지 등록 -> 저장
				$('#btnThemeAddImage').click(function() {
					console.log("들어옴");

					if($('#boardList').length > 0) {
						location.href = '<%= RequestMappingConstants.WEB_GIS %>?theme=themeAddImage';
						return;
					}

					// 테마목록 숨기기
					$('#theme').hide();

					// 테마상세 숨기기
					$('#themeDetail').hide();

					// 이미지일경우
					$('#themeAddImageContainer').attr('class', 'col-sm-8');
					$('#themeAddLayerContainer').attr('class', '');
					$('#themeAddImageContainer').show();
					$('#themeAddLayerContainer').hide();
					$('#themeAddFileContainer').show();

					// 이전버튼 숨기기
					$('#btnThemeAddPrevStep').hide();

					// 타이틀 초기화
					$('#themeAddTitle').val('');

					// 공개여부 초기화 - 비공개
					$('input[name="themeAddOthbcYn"]:checked').val()

					// 이미지 초기화
					$('#themeAddImage').attr('src', '')

					// 파일 초기화
	  				if($("#themeAddFileGrp").length == 0)
	        			$("#themeAddStep2").append('<input type="hidden" name="themeAddFileGrp" id="themeAddFileGrp"/>');
					$('#themeAddFileGrp').val('');

					// 2단계 보기
					$('#themeAddStep2').show();
				});

				////////////////////////////////////////////////////////////////////////////////////
				// 지도 등록  1단계 시작
				$('#btnThemeAddStep1, #btnThemeAddPrevStep').click(function() {
					if($('#boardList').length > 0) {
						location.href = '<%= RequestMappingConstants.WEB_GIS %>?theme=themeMapImage';
						return;
					}

					// 테마목록 숨기기
					$('#theme').hide();

					// 테마상세 숨기기
					$('#themeDetail').hide();

					// 지도일경우 - 이미지 및 레이어 정보
					$('#themeAddImageContainer').attr('class', 'col-sm-8');
					$('#themeAddLayerContainer').attr('class', 'col-sm-4');
					$('#themeAddImageContainer').show();
					$('#themeAddLayerContainer').show();
					$('#themeAddFileContainer').hide();

					// 이전버튼 보기
					$('#btnThemeAddPrevStep').show();

					// 타이틀 초기화
					$('#themeAddTitle').val('');

					// 공개여부 초기화 - 비공개
					$('input[name="themeAddOthbcYn"]:checked').val()

					// 이미지 초기화
					$('#themeAddImage').attr('src', '')

					// 파일 초기화
	  				if($("#themeAddFileGrp").length == 0)
	        			$("#themeAddStep2").append('<input type="hidden" name="themeAddFileGrp" id="themeAddFileGrp"/>');
					$('#themeAddFileGrp').val('');

					// 2단계 숨기기
					$('#themeAddStep2').hide();

					// 그래픽 보기
					$('#themeAddGraphic').show();

					// 스텝1 보기
					$('#themeAddStep1').show();

					// 자산형황 패널 이동
					$('#main-tabs').find('a[href="#map-search-tab"]').trigger('click');
					$('a[href="#map-search-tab"]').addClass("selected");
				})

				// 지도 등록 1단계 닫기
				$('#btnThemeAddStep1Cancel').click(function() {
					// 그래픽 닫기
					$('#themeAddGraphic').hide();

					// 스텝1 닫기
					$('#themeAddStep1').hide();

					// 지도 초기화
					dr_source.clear();
					geoMap.removeInteraction(dr_vector);
				});

				// 지도 등록 2단계
				$('#btnThemeAddStep2').click(function() {
					// 그래픽 닫기
					$('#themeAddGraphic').hide();

					// 스텝1 닫기
					$('#themeAddStep1').hide();

					// 이미지 캡쳐
					var dims = {
						a0: [1189, 841],
						a1: [841, 594],
						a2: [594, 420],
						a3: [420, 297],
						a4: [297, 210],
						a5: [210, 148],
					};
				    var format = $('#format').val();
				    var resolution = $('#resolution').val();
				    var dim = dims[format];
				    var width = Math.round((dim[0] * resolution) / 25.4);
				    var height = Math.round((dim[1] * resolution) / 25.4);
				    var size = geoMap.getSize();								// 원본 지도 사이즈
				    var viewResolution = geoMap.getView().getResolution();		// 원본 지도 해상도

					geoMap.once('postcompose', function(event) {
				        //var canvas = event.context.canvas;
						var mapCanvas = document.createElement('canvas');
					    	mapCanvas.width = width;
					      	mapCanvas.height = height;
				      	var mapContext = mapCanvas.getContext('2d');

				      	Array.prototype.forEach.call(
				        	document.querySelectorAll('.ol-viewport canvas'),
				        	function (canvas) {
				          		if (canvas.width > 0) {
				            		var opacity = canvas.parentNode.style.opacity;
						            mapContext.globalAlpha = opacity === '' ? 1 : Number(opacity);
						            mapContext.drawImage(canvas, 0, 0);
				          		}
				        	}
				    	);

						$('#themeAddImage').attr('src', mapCanvas.toDataURL('image/png'))
						$('#themeAddStep2').show();

						geoMap.setSize(size);									// 원본 지도 사이즈 설정
						geoMap.getView().setResolution(viewResolution);			// 원본 지도 해상도 설정

						var layerInfo = [];
						var item = {};

						$('#map-layerlist input').each(function() {
							if(this.checked){
								layer_no = $(this).attr('data-layer-no');
								layer_legend = '';
								$("#map-layerlist .list-answer").each(function() {
									if($(this).attr('data-layer-no') == layer_no) {
										layer_legend = $(this).html()
									}
								});
								item =  {
						             	text: '<font color="#ff9900">[' + (layerInfo.length+1).toString().padStart(2, '0') + ']</font> <font color="#00AA40">'+ $(this).attr('data-layer-dp-nm') + '</font>' ,
						             	href: '#'  ,
			                         	tags: [ layer_legend ]
						           	};
								layerInfo.push(item);
							}
						});

						//console.log(layerInfo);

						$("span[name*='layerListCount']").text(layerInfo.length);

						$('#themeAddLayer').empty();
						$('#themeAddLayer').treeview({
				            data: layerInfo,
				            enableLinks:false,
				            color: undefined,					// '#000000',
				            backColor: undefined,				// '#FFFFFF',
				            borderColor: undefined,				// '#dddddd',
				            onhoverColor:'#F5F5F5',
				            selectedColor:'#000000',
				            selectedBackColor:'#dddddd',
				            searchResultColor:'#D9534F',
				            searchResultBackColor: undefined,	//'#FFFFFF',
				            showBorder:true,
				            showIcon:true,
				            showCheckbox:false,
				            showTags:false,
				            highlightSelected:true,
				            highlightSearchResults:true,
				            multiSelect:false
				    	});

						$('#themeAddLayer').on('nodeSelected', fn_theme_layer_node_selected);
						$('#themeAddLayer').on('mouseover', '.list-group-item', fn_theme_layer_node_mouseover);
						$('#themeAddLayer').on('mouseout', '.list-group-item', fn_theme_layer_node_mouseout);
				    });

				    var printSize = [width, height];
				   	var scaling = Math.min(width / size[0], height / size[1]);

				   	// 변경 된 지도 사이즈,해상도 설정
				    geoMap.setSize(printSize);									// 변경 지도 사이즈 설정
				    geoMap.getView().setResolution(viewResolution / scaling);	// 변경 지도 해상도 설정

				    // 지도 다시 그리기
					geoMap.renderSync();
				});

				// 지도 등록 취소
				$('#btnThemeAddCancel').click(function() {
					// 테마등록 숨기기
					$('#themeAddImage').attr('src', '')
					$('#themeAddStep2').hide();

					// 지도 초기화
					dr_source.clear();
					geoMap.removeInteraction(dr_vector);
				});

				// 지도 등록 저장
				$('#btnThemeAddSave').click(function() {
					var sendData = [];
					$('#map-layerlist input').each(function() {
						if(this.checked){
							var no = $(this).attr('data-layer-no');
							sendData.push({layer_no: no});
						}
					});

					//console.log(sendData);
					//return;

					$.ajax({
						type : "POST",
						async : false,
						url : "<%= RequestMappingConstants.WEB_THEME_ADD %>",
						dataType : "json",
						data : {
							title: $('#themeAddTitle').val(),
							image: $('#themeAddImage').attr('src'),
							othbc_yn: $('input[name="themeAddOthbcYn"]:checked').val(),
							layers:  JSON.stringify(sendData),
							file_grp: $('#themeAddFileGrp').val()
						},
						error : function(response, status, xhr){
							if(xhr.status =='403'){
								alert('테마 등록 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
							}
						},
						success : function(data) {
					        if(data.result == "Y") {
								// 목록 요청
					        	fn_search_theme_list();

								// 테마목록 보이기
								$('#theme').show();

					        	// 지도 초기화
								dr_source.clear();
								geoMap.removeInteraction(dr_vector);

					        	// 2단계 숨기기
								$('#themeAddStep2').hide();
					        }
						}
					});
				});


				////////////////////////////////////////////////////////////////////////////////////
				// 상세 수정
				$('#btnThemeDetailEdit').click(function() {
					if($('#detail_theme_no').val() != '' && confirm("저장 하시겠습니까?")){
						$.ajax({
							type : "POST",
							async : false,
							url : '<%= RequestMappingConstants.WEB_THEME_EDIT %>',
							dataType : "json",
							data: {
								id: $('#detail_theme_no').val(),
								title: $('#themeDetailTitle').val(),
								othbc_yn: $('input[name="themeDetailOthbcYn"]:checked').val()
							},
							error : function(response, status, xhr){
								if(xhr.status =='403'){
									alert('저장 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
								}
							},
							success: function(data) {
								if(data.result == "Y") {
									// 목록 요청
						        	fn_search_theme_list();

									// 테마목록 보이기
									$('#theme').show();

									// 상세 닫기
									$('#themeDetailTitle').attr('disabled', true);
					  	        	$('input:radio[name="themeDetailOthbcYn"]').prop('disabled', true);
					  	        	$('#btnThemeDetailEdit').text('수정');

					  	        	$('#themeDetail').hide();
								}
							}
						});
					}
				});

				// 상세 삭제
				$('#btnThemeDetailDelete').click(function() {
					if($('#detail_theme_no').val() != '' && confirm("삭제 하시겠습니까?")){
						$.ajax({
							type : "POST",
							async : false,
							url : '<%= RequestMappingConstants.WEB_THEME_EDIT %>',
							dataType : "json",
							data: {
								id: $('#detail_theme_no').val(),
								use_yn : 'N'
							},
							error : function(response, status, xhr){
								if(xhr.status =='403'){
									alert('삭제 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
								}
							},
							success: function(data) {
								if(data.result == "Y") {
									// 목록 요청
						        	fn_search_theme_list();

									// 테마목록 보이기
									$('#theme').show();

									// 상세 닫기
									$('#themeDetailTitle').attr('disabled', true);
					  	        	$('input:radio[name="themeDetailOthbcYn"]').prop('disabled', true);
					  	        	$('#btnThemeDetailEdit').text('수정');

					  	        	$('#themeDetail').hide();
								}
							}
						});
					}
				});

				// 상세 닫기
				$('#btnThemeDetailClose').click(function() {
					$('#themeDetail').hide();
				});

				// 그리기 스타일
				/*
				$('.color-box').colpick({
			    	colorScheme:'dark',
			    	layout:'rgbhex',
			    	color:'ff8800',
			    	onSubmit:function(hsb,hex,rgb,el) {
			    		$(el).css('background-color', '#'+hex);
			    		$(el).colpickHide();
			    	}
			    }).css('background-color', '#ff8800');
				 */
				var lnColor = 'rgba(14, 206, 235, .5)';
				var bgColor = 'rgba(14, 206, 235, .5)';
				$('.demo').each( function() {
					$(this).minicolors({
						control      : $(this).attr('data-control') || 'hue',
						defaultValue : $(this).attr('data-defaultValue') || '',
						format       : $(this).attr('data-format') || 'hex',
						keywords     : $(this).attr('data-keywords') || '',
						inline       : $(this).attr('data-inline') === 'true',
						letterCase   : $(this).attr('data-letterCase') || 'lowercase',
						opacity      : $(this).attr('data-opacity'),
						position     : $(this).attr('data-position') || 'bottom',
						swatches     : $(this).attr('data-swatches') ? $(this).attr('data-swatches').split('|') : [],
						change: function(value, opacity) {
						  if( typeof console === 'object' ) {
						    if($(this).attr('id') == 'lnColor')
						  	  lnColor = value;
						    else
						  	  bgColor = value;

						    console.log(value);
						  }
						},
						theme: 'bootstrap'
					});
				});

				// 지도 그리기
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
			    		  	switch(typeSelect) {
					  			case 'Point':
					  				$.MessageBox({
					    				input    : true,
					    			    message  : "원하시는 텍스트를 입력하세요."
					    			}).done(function(data){
					    				e.feature.setProperties({
					    					'description':$.trim(data),
					        			    'bgcolor': bgColor,
					        				'lncolor': lnColor
					        			});
					    			});
					  				break;
				  				default:
					  				e.feature.setProperties({
				        				'bgcolor': bgColor,
				        			    'lncolor': lnColor
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
					            text: feature.get('description')
					          })
						});
						return [style];
					}
				});

				$('div[name="Drawtool"]').each(function() {
					$(this).on('click', function() {
						$this = $(this);
						if($this.hasClass('active')) {
							$(this).removeClass('active');
							typeSelect = 'None';
						}
						else
						{
							$(this).addClass('active');

							typeSelect = $(this).attr('value');
							geoMap.removeInteraction(dr_vector);
							add_vector_interaction();
						}
						$('div[name="Drawtool"]').each(function() {
							if($this != $(this)) {
								$(this).removeClass('active');
							}
						});
					});
				});

				// 지도그리기
				geoMap.addLayer(dr_layer);


				////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// 파일 추가
				var themeFilesAllow = ['jpg','jpeg','gif','png', 'bmp'];
				var themeFilesTempArr = [];

				function addThemeFiles(e) {
					$('#fileAddRow > tbody > tr').remove();

				    var files = e.target.files;
				    var filesArr = Array.prototype.slice.call(files);
				    var filesArrLen = filesArr.length;
				    var filesTempArrLen = themeFilesTempArr.length;

				    if(filesArrLen == 0)
				    	return;

					themeFilesTempArr = [];

				    for(var i=0; i<filesArrLen; i++ ) {
				        var ext  = filesArr[i].name.split('.').pop().toLowerCase();
				        var msg  = ($.inArray(ext, themeFilesAllow) == -1 ? '허용되지 않은 파일 입니다.' : '');
				        var size = Math.round(filesArr[i].size / 1024, 2)

				        if($.inArray(ext, themeFilesAllow) == -1) {
				        	continue;
				        }

				        $("#themeFileAddRow > tbody").append("   <tr class='template-upload fade in'>							" +
													        "      <td>                                                         " +
													        "          <span class='preview'><img id='thumbnail"+i+"' src=''></img</span> " +
													        "      </td>                                                        " +
													        "      <td>                                                         " +
													        "          <p class='name'>" + filesArr[i].name + "</p>             " +
													        "          <strong class='error text-danger'>" + msg +"</strong>    " +
													        "      </td>                                                        " +
													        "      <td>                                                         " +
													        "          <p class='size'>" + size + "KB</p>                       " +
													        "      </td>                                                        " +
													        "  </tr>                                                            ");

				        themeFilesTempArr.push(filesArr[i]);
				    }
				    $(this).val('');
				}

				// 이벤트 트리거
				$("#spanThemeAddFile").click(function() {
					  $("#inputThemeAddFile").trigger('click');
				});

				// 이벤트 등록
				$("#inputThemeAddFile").on("change", addThemeFiles);

				$("#btnThemeFileDelete").click(function(e) {
					$('#themeFileAddRow > tbody > tr').remove();
					$("#themeFileAddForm")[0].reset();
					themeFilesTempArr = [];
				});

				$("#btnThemeFileAddSave").click(function(e) {
					var formData = new FormData();
					for(var i=0, filesTempArrLen = themeFilesTempArr.length; i<filesTempArrLen; i++) {
					   formData.append("files", themeFilesTempArr[i]);
					}

					$.ajax({
					    type : "POST",
					    url : "<%=RequestMappingConstants.API_UPLOAD%>",
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
								var groupNo = data.groupInfo;
					  			$.ajax({
					  				type : "POST",
					  				async : false,
					  				url : "<%=RequestMappingConstants.API_VIEWLIST%>",
					  				dataType : "json",
					  				data : {
					  					id: groupNo
					  				},
					  				error : function(response, status, xhr){
					  					if(xhr.status =='403'){
					  						alert('파일 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
					  					}
					  				},
					  				success : function(data) {
					  					if(data.result == 'Y' && data.fileInfo.length > 0) {
					  						if($("#themeAddFileGrp").length == 0)
					  			        		$("#themeAddStep2").append('<input type="hidden" name="themeAddFileGrp" id="themeAddFileGrp"/>');
				  	  						$('#themeAddFileGrp').val(groupNo);

					  						var path = "<%=RequestMappingConstants.UPLOAD_FOLDER_FOR_WEB%>" + data.fileInfo[0].save_path + data.fileInfo[0].save_name;
				  	  						path = path.replace(/\\/g, '/');

				  	  						$('#themeAddImage').attr('src', path);

				  	  						$("#btnThemeFileAddCancel").trigger('click');
					  					}
					  				}
					  			});
							}
						},
					});
		        });

				$("#btnThemeFileAddCancel").click(function(e) {
					$('#themeFileAddRow > tbody > tr').remove();
		        	$("#themeFileAddForm")[0].reset();
		        	themeFilesTempArr = [];
				});

	  			$( window ).resize(function() {
	  				if($('header').css('display') == 'none')
	  					$('#theme').css('top', '0px')
	  				else
	  					$('#theme').css('top', '114px')
	  			});

	  			if('<%= request.getParameter("theme") %>' == 'themeAddImage')
	  				$('#btnThemeAddImage').trigger('click');
	  			else if('<%= request.getParameter("theme") %>' == 'themeMapImage')
	  				$('#btnThemeAddStep1').trigger('click');
			});

			var gfv_pageIndex;
			var gfv_eventName;

			var pageCount = 10;
			var recordPerPage = 6;

			function fn_pagenation_theme(params) {
			    gfv_pageIndex = params.pageIndex; 								//현재 위치가 저장될 input 태그
			    gfv_eventName = params.eventName;

				var divId = params.divId; 										//페이징이 그려질 div id
			    var totalCount = params.totalCount; 							//전체 조회 건수
			    var currentIndex = $("#"+params.pageIndex).val(); 				//현재 위치
			    if($("#"+params.pageIndex).length == 0){
			        currentIndex = 1;
			    }

			    var recordCount = params.recordCount; 							//페이지당 레코드 수
			    var totalIndexCount = Math.ceil(totalCount / recordCount); 		// 전체 인덱스 수

			    var preStr = "";
			    var postStr = "";
			    var pageStr = "";

			    var first = (parseInt((currentIndex-1) / pageCount) * pageCount) + 1;
			    var last  = (parseInt(totalIndexCount/pageCount) == parseInt(currentIndex/pageCount)) ? totalIndexCount%pageCount : pageCount;
			    var prev  = (parseInt((currentIndex-1)/pageCount)*pageCount) - 4 > 0 ? (parseInt((currentIndex-1)/pageCount)*pageCount) - 4 : 1;
			    var next  = (parseInt((currentIndex-1)/pageCount)+1) * pageCount + 1 < totalIndexCount ? (parseInt((currentIndex-1)/pageCount)+1) * pageCount + 1 : totalIndexCount;

			    if(totalIndexCount > pageCount) { //전체 인덱스가 5가 넘을 경우, 맨앞, 앞 태그 작성
			        preStr += '<li><a href="#this" class="pad_5" onclick="fn_link_theme_list('+prev+')"><i class="fa fa-angle-left"></i></a></li>';
			    } else if(totalIndexCount <= pageCount && totalIndexCount > 1) { //전체 인덱스가 5보다 작을경우, 맨앞 태그 작성
			    	preStr += '<li class="hidden"><a href="#this" class="pad_5" onclick="fn_link_theme_list('+prev+')"><i class="fa fa-angle-left"></i></a></li>';
			    } else {
			    	preStr += '<li class="hidden"><a href="#this" class="pad_5" onclick="fn_link_theme_list('+prev+')"><i class="fa fa-angle-left"></i></a></li>';
			    }

			    if(totalIndexCount > pageCount) { //전체 인덱스가 5가 넘을 경우, 맨뒤, 뒤 태그 작성
			    	postStr += '<li><a href="#" onclick="fn_link_theme_list('+next+')"><i class="fa fa-angle-right"></i></a></li>';
			    } else if(totalIndexCount <= pageCount && totalIndexCount > 1) { //전체 인덱스가 5보다 작을경우, 맨뒤 태그 작성
			        postStr += '<li class="hidden"><a href="#" onclick="fn_link_theme_list('+next+')"><i class="fa fa-angle-right"></i></a></li>';
			    } else {
			    	postStr += '<li class="hidden"><a href="#" onclick="fn_link_theme_list('+next+')"><i class="fa fa-angle-right"></i></a></li>';
			    }

			    for(var i=first; i<(first+last); i++) {
			        if(i != currentIndex) {
			        	pageStr += '<li><a href="#this" class="pad_5" onclick="fn_link_theme_list('+i+')">'+i+'</li>';
			        } else {
			        	pageStr += '<li class="active"><a href="#this" class="pad_5" onclick="fn_link_theme_list('+i+')">'+i+'</a></li>';
			        }
			    }

			    $("#"+divId).empty();
			    $("#"+divId).append(preStr + pageStr + postStr);
			}

			function fn_link_theme_list(value){
			    $("#"+gfv_pageIndex).val(value);

			    if(typeof(gfv_eventName) == "function") {
			        gfv_eventName(value, recordPerPage);
			    } else {
			        eval(gfv_eventName + "(value, " + recordPerPage + ");");
			    }
			}

			function fn_search_theme_list(pageNo, listCnt) {
				if(pageNo === undefined) {
					pageNo = 1;
				}

				if(listCnt === undefined) {
					listCnt = recordPerPage;
				}

				$.ajax({
					type : "POST",
					async : false,
					url : '<%= RequestMappingConstants.WEB_THEME_LIST %>',
					dataType : "json",
					data: {
						pageIndex: pageNo,
						pageUnit: listCnt,
						pageSize: pageCount,
						s_serch_gb:  $("select[name=s_theme_serch_gb]").val(),
						s_serch_nm: encodeURIComponent($("input[name=s_theme_serch_nm]").val())
					},
					error : function(response, status, xhr){
						if(xhr.status =='403'){
							alert('주제도면 리스트 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
						}
					},
					success: function(data) {
						var str = '';
			        	var total = data.total;
			            var body = $("div.theme-list-wrap.m-t-30");
			            body.empty();

			            if(total == 0 || total == undefined)
			            {
			            	str = '<div class="row"><div class="col-sm-12" style="text-align: center;">조회된 결과가 없습니다.</div></div>';
			            }
			            else
			            {
			                var params = {
			                    divId : "pagination",
			                    pageIndex : "CURRENT_INDEX",
			                    totalCount : total,
			                    recordCount : listCnt,
			                    eventName : "fn_search_theme_list"
			                };
			                fn_pagenation_theme(params);

			                for(i=0;i<data.themeInfo.length;i++)
			                {
	  	  						var path = "<%=RequestMappingConstants.UPLOAD_FOLDER_FOR_WEB%>" + data.themeInfo[i].save_path + data.themeInfo[i].save_name;
	  	  						path = path.replace(/\\/g, '/');

			                	if(i%3 == 0)
			                	{
			                		str += '<div class="row">';
			                	}

			                	str += '	<div class="col-sm-4">';
			                    str += '		<div class="thumbnail" onclick=fn_link_theme_detail("' + data.themeInfo[i].theme_no + '")>';
			                    str += '			<img src="' + path + '" class="img-responsive" style="height:200px" alt="'+data.themeInfo[i].theme_main_title +'" title="' + data.themeInfo[i].theme_main_title + '">';
			                    str += '			<div class="caption">';
			                    str += '				<h5 class="text-overflow font-600">' + data.themeInfo[i].theme_main_title + '&nbsp;</h5>';
			                    str += '				<h7>'+ '작성자 :' + data.themeInfo[i].user_nm + '</h7>';
			                    str += '				<div class="text-muted m-b-0" style="float:right">' + data.themeInfo[i].ins_dt + '</div>';
			                    str += '			</div>';
			                    str += '		</div>';
			                    str += '	</div>';

			                    if(data.themeInfo.length > 3 && i%3 == 2)
			                    {
			                		str += '</div>';
			                	}
			                }
			            }

			            $("span[name*='themeListCount']").text(total);

			            body.append(str);
					}
				});
			}

			var clientX;
			var clientY;

			function fn_theme_layer_node_selected(event, data) {
	        	//alert('기능 지원 예정 입니다.');
	        	//return;
				//console.log(data);
				//console.log(data.text);
				//console.log(data.tags);
	        	//var desc = data.tags.toString();
	        	//var arrDesc = desc.split('#');

				$("#layer_legend").css({
					   "position" : "absolute",
					   "top"  : (clientY + 20) + "px",
					   "left" : (clientX - 40) + "px"
				});
				$('#layer_legend_html').html(data.tags);
				$('#layer_legend').show();
			}

			function fn_theme_layer_node_mouseover(event, data) {
                //console.log($(this).attr('data-nodeid'));
				//console.log(event, data)
				//$(this).trigger('click');

				if($('#layer_legend').css('display') == 'none') {
					clientX = event.clientX;
					clientY = event.clientY;

					$(this).trigger('click');
				}
			}

			function fn_theme_layer_node_mouseout(event, data) {
                //console.log($(this).attr('data-nodeid'));
				//console.log(event, data)
				//$(this).trigger('click');

				if($('#layer_legend').css('display') == 'block') {
					clientX = -1000;
					clientY = -1000;

					$('#layer_legend_html').html('');
					$('#layer_legend').hide();
				}
			}

			function fn_link_theme_detail(id) {
				$.ajax({
					type : "POST",
					async : false,
					url : "<%= RequestMappingConstants.WEB_THEME_DETAIL %>",
					dataType : "json",
					data : {id: id},
					error : function(response, status, xhr){
						if(xhr.status =='403'){
							$("#themeDetail").hide();
							alert('테마 상세 데이터 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
						}
					},
					success : function(data) {
				        if(data.result == "Y") {
							var layerInfo = [];
							var item = {};

							for(i=0; i<data.layerInfo.length;i++)
							{
								layer_no = data.layerInfo[i].layer_no;
								layer_legend = '';
								$("#map-layerlist .list-answer").each(function() {
									if($(this).attr('data-layer-no') == layer_no) {
										layer_legend = $(this).html()
									}
								});

								item =  {
							             	text: '<font color="#ff9900">[' + (i+1).toString().padStart(2, '0') + ']</font> <font color="#00AA40">'+ data.layerInfo[i].layer_dp_nm + '</font>' ,
							             	href: '#'  ,
				                         	tags: [ layer_legend ]
							           	};

								layerInfo.push(item);
							}

							//console.log(layerInfo);

							$("span[name*='layerListCount']").text(data.layerInfo.length);

							$('#themeDetailLayer').empty();
							$('#themeDetailLayer').treeview({
					            data: layerInfo,
					            enableLinks:false,
					            color: undefined,					// '#000000',
					            backColor: undefined,				// '#FFFFFF',
					            borderColor: undefined,				// '#dddddd',
					            onhoverColor:'#F5F5F5',
					            selectedColor:'#000000',
					            selectedBackColor:'#dddddd',
					            searchResultColor:'#D9534F',
					            searchResultBackColor: undefined,	//'#FFFFFF',
					            showBorder:true,
					            showIcon:true,
					            showCheckbox:false,
					            showTags:false,
					            highlightSelected:true,
					            highlightSearchResults:true,
					            multiSelect:false
					    	});
							$('#themeDetailLayer').on('nodeSelected', fn_theme_layer_node_selected);
							$('#themeDetailLayer').on('mouseover', '.list-group-item', fn_theme_layer_node_mouseover);
							$('#themeDetailLayer').on('mouseout', '.list-group-item', fn_theme_layer_node_mouseout);


				        	var path = "<%=RequestMappingConstants.UPLOAD_FOLDER_FOR_WEB%>" + data.themeInfo.save_path + data.themeInfo.save_name;
  	  						path = path.replace(/\\/g, '/');

  	  						$('#themeDetailTitle').val(data.themeInfo.theme_main_title);
		  	  				$('input:radio[name="themeDetailOthbcYn"][value="' + data.themeInfo.othbc_yn + '"]').prop('checked', true);
	  	  					$('#themeDetailImage').attr('src', path);
							
		  	  				var agent = navigator.userAgent.toLowerCase();
		  	  				
		  	  				
		  	  				if ( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1)  ) {
		  	  					$('#themeDetailImageLink').off('click');
			  	  				$('#themeDetailImageLink').click(function() {
			  	  					
			  	  					$("#themeDetailImageLink").removeAttr("href");
			  	  					$("#themeDetailImageLink").css('cursor','pointer');
			  	  					var file_name = data.themeInfo.file_name;
				  	  				var image = document.getElementById("themeDetailImage");
					  	  			var canvas = document.createElement("canvas");
					  	  			canvas.width = image.width;
					  	  			canvas.height = image.height;
					  	  			var ctx = canvas.getContext("2d");
					  	  			      		
					  	  			ctx.drawImage(image, 0, 0, image.width, image.height);
					  	  			window.navigator.msSaveBlob(canvas.msToBlob(), file_name + ".png");
					  	  			
			  					});
		  	  				}
		  	  				else{
			  	  				$('#themeDetailImageLink').attr('href', path);
		  	  	  				$('#themeDetailImageLink').attr('download', data.themeInfo.file_name);
		  	  				}
	  	  	  					

  	  						if(data.themeInfo.edit_enable_yn == 'N') {
  								$('#themeDetailTitle').attr('disabled', true);
  				  	        	$('input:radio[name="themeDetailOthbcYn"]').prop('disabled', true);
  				  	        	$('#btnThemeDetailEdit').text('수정');

  	  							$('#btnThemeDetailEdit').hide();
  	  							$('#btnThemeDetailDelete').hide();
  	  						} else {
  								$('#themeDetailTitle').attr('disabled', false);
  				  	        	$('input:radio[name="themeDetailOthbcYn"]').prop('disabled', false);
  				  	        	$('#btnThemeDetailEdit').text('저장');

  	  							$('#btnThemeDetailEdit').show();
  	  							$('#btnThemeDetailDelete').show();
  	  						}

	  	  		        	if($("#detail_theme_no").length == 0)
	  			        		$("#themeDetail").append('<input type="hidden" name="detail_theme_no" id="detail_theme_no"/>');
	  			        	$('#detail_theme_no').val(id);

							$('#themeDetail').show();
				        }
					}
				});
			}
		</script>

<div id='theme' class="wrapper-content asset"
	style='z-index: 2020; background-color: #ffffff; display: none;'>
	<div class="dashboard-box">
		<div class="container">

			<!-- Page-Title -->
			<div class="row">
				<div class="col-sm-12">
					<div class="page-title-box">
						<div class="btn-group pull-right">
							<ol class="breadcrumb hide-phone p-0 m-0">
								<li><a href="<%=RequestMappingConstants.WEB_MAIN%>">HOME</a>
								</li>
								<li class="active">주제도면</li>
							</ol>
						</div>
						<h4 class="page-title">주제도면</h4>
					</div>
				</div>
			</div>
			<!-- End Page-Title -->

			<!-- List Page-Body -->
			<div class="row">
				<div class="col-sm-12">
					<div
						class="card-box big-card-box last table-responsive searchResult">

						<div class="form-group">
							<form id="themeListForm" name="themeListForm"
								class="form-horizontal">
								<h5 class="header-title m-t-0 m-b-30">
									<b>검색 조건</b>
								</h5>
								<div class="row">
									<div class="col-md-10">
										<div class="form-group">
											<label for="s_serch_gb" class="col-md-1 control-label">검색항목</label>
											<div class="col-md-2">
												<select class="form-control" id="s_theme_serch_gb"
													name="s_serch_gb" title="검색항목">
													<option value="">선택</option>
													<option value="title">제목</option>
													<option value="user_id">사용자ID</option>
													<option value="user_nm">사용자명</option>
													<option value="dept_nm">부서</option>
												</select>
											</div>
											<label for="s_serch_nm" class="sr-only">검색어</label>
											<div class="col-md-9">
												<input class="form-control" title="검색어"
													id="s_theme_serch_nm" name="s_serch_nm"
													placeholder="검색어를 입력하세요" />
											</div>
										</div>
									</div>
									<div class="col-md-2">
										<button type="button"
											class="btn btn-custom btn-md pull-right searchBtn"
											id='btnThemeSearch'>검색</button>
										<button type="reset"
											class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn"
											id='btnThemeReset'
											style="width: 64px; height: 38px; padding-left: 8px; padding-right: 8px;">초기화</button>
									</div>
								</div>
							</form>
						</div>

						<h5 class="header-title">
							<b>목록</b> <span class="small">(전체 <b class="text-orange"><span
									name='themeListCount'>0</span></b>건)
							</span>
						</h5>

						<div class="theme-list-wrap m-t-30"></div>

						<div class="text-center m-b-20">
							<input type="hidden" id="CURRENT_INDEX" value="1" />
							<ul class="pagination" id="pagination"></ul>
						</div>

						<div class="modal-footer">
							<button type="button" class="btn btn-custom btn-md"
								id='btnThemeAddImage'>
								<span><i class="fa fa-check-circle m-r-5"></i>이미지 등록</span>
							</button>
							<button type="button" class="btn btn-custom btn-md"
								id='btnThemeAddStep1'>
								<span><i class="fa fa-check-circle m-r-5"></i>지도 등록</span>
							</button>
						</div>

					</div>
				</div>
			</div>
			<!-- End List Page-Body -->

		</div>
	</div>
</div>

<div id='themeDetail' class="wrapper-content asset"
	style='z-index: 2021; background-color: #ffffff; display: none; overflow-y: auto'>
	<div class="dashboard-box">
		<div class="container">

			<!-- Page-Title -->
			<div class="row">
				<div class="col-sm-12">
					<div class="page-title-box">
						<div class="btn-group pull-right">
							<ol class="breadcrumb hide-phone p-0 m-0">
								<li><a href="<%=RequestMappingConstants.WEB_MAIN%>">HOME</a>
								</li>
								<li class="active">주제도면</li>
							</ol>
						</div>
						<h4 class="page-title">주제도면 상세</h4>
					</div>
				</div>
			</div>
			<!-- End Page-Title -->

			<div class="row">
				<div class="col-sm-12">
					<div
						class="card-box big-card-box last table-responsive searchResult">

						<!-- Table-Content-Wrap -->
						<h5 class="header-title">
							<b>상세보기</b>
						</h5>
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<div class="col-sm-8">
										<label for="">제목</label> <input class="form-control"
											type="text" name="themeDetailTitle" id="themeDetailTitle" />
									</div>
									<div class="col-sm-4">
										<label for="">공개</label><br> <input type="radio"
											id="themeDetailOthbcYn" name="themeDetailOthbcYn" value="Y" />
										공개 <input type="radio" id="themeDetailOthbcYn"
											name="themeDetailOthbcYn" value="N" checked="checked" /> 비공개
									</div>
								</div>
							</div>
						</div>

						<div class="preview-wrap m-t-30 m-b-30">
							<div class="row">
								<div class="col-sm-12">
									<div class="card-box-inner">
										<div class="col-sm-8" id='themeDetailImageContainer'>
											<div class="card-box">
												<div class="card-box-inner cb-inner03" style="height: 100%">
													<label for="">주제도면</label> <a href='#'
														id='themeDetailImageLink' target='_blank'><img
														id='themeDetailImage' name='themeDetailImage' src=""
														class="img-responsive" alt='' title='클릭시 이미지 다운로드 됩니다.'></a>
												</div>
											</div>
										</div>
										<div class="col-sm-4" id='themeDetailLayerContainer'>
											<div class="card-box">
												<div class="card-box-inner cb-inner03" style="height: 100%">
													<label for="">레이어 목록</label> <span class="small">(전체
														<b class="text-orange"><span name='layerListCount'>0</span></b>건)
													</span>
													<div id='themeDetailLayer'></div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="btn-wrap pull-left">
							<span>※ 다운로드 하시려면 이미지를 클릭하세요.</span>
						</div>
						<!-- Button-Group -->
						<div class="modal-footer">
							<button type="button" class="btn btn-inverse btn-md"
								id='btnThemeDetailClose'>
								<!-- <span><i class="fa fa-times-circle m-r-5"></i>목록</span> -->
								목록
							</button>
							<button type="button" class="btn btn-teal btn-md"
								id='btnThemeDetailEdit'>
								<!-- <span><i class="fa fa-edit m-r-5"></i>수정</span> -->
								수정
							</button>
							<button type="button" class="btn btn-danger btn-md"
								id='btnThemeDetailDelete'>
								<!-- <span><i class="fa fa-times-circle m-r-5"></i>삭제</span> -->
								삭제
							</button>
						</div>
						<!--// End Button-Group -->

					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="popover layer-pop" id='themeAddGraphic'
	style="width: 310px; left: 520px; top: 135px; bottom: auto; z-index: 2022; display: none;">
	<!-- <div class="popover-title tit"> -->
	<div class="popover-title">
		<span class="m-r-5"> <b>그래픽 추가</b>
		</span>
	</div>
	<div class="row">
		<div class="col-sm-2">
			<div class="btn-group-vertical btn-md graphic-icon">
				<div class="btn btn-md btn-teal" title="텍스트 추가" name="Drawtool"
					value="Point">
					<i class="mdi mdi-format-text"></i>
				</div>
				<div class="btn btn-md btn-teal" title="선 추가" name="Drawtool"
					value="LineString">
					<i class="mdi mdi-pencil"></i>
				</div>
				<div class="btn btn-md btn-teal" title="면 추가" name="Drawtool"
					value="Polygon">
					<i class="mdi mdi-shape-rectangle-plus"></i>
				</div>
				<div class="btn btn-md btn-teal" title="원 추가" name="Drawtool"
					value="Circle">
					<i class="mdi mdi-shape-circle-plus"></i>
				</div>
			</div>
		</div>
		<div class="col-sm-4"
			style="margin-top: 5px; left: 30px; width: 230px;">
			<!--
	            	<div>선색</div>
	            	<div class="color-box" id="lnColor"></div>
	            	<div style="clear: both;">면색(글자색)</div>
					<div class="color-box" id="bgColor"></div>
					 -->
			<div></div>
			<div>선색</div>
			<input type="text" id="lnColor" class="form-control demo"
				data-format="rgb" data-opacity="1"
				data-swatches="#fff|#000|#f00|#0f0|#00f|#ff0|rgba(0,0,255,0.5)"
				value="rgba(14, 206, 235, .5)">
			<div style="clear: both;">면색(글자색)</div>
			<input type="text" id="bgColor" class="form-control demo"
				data-format="rgb" data-opacity="1"
				data-swatches="#fff|#000|#f00|#0f0|#00f|#ff0|rgba(0,0,255,0.5)"
				value="rgba(14, 206, 235, .5)">
		</div>
	</div>
</div>

<div class="alert-box layer-pop" id='themeAddStep1'
	style="z-index: 2023; display: none;">
	<!-- <div class="alert-box-header tit"> -->
	<div class="alert-box-header">
		<div class="alert-box-title">알림</div>
	</div>
	<div class="alert-box-content">
		<h4 class="font-600">지도화면 설정</h4>
		<br> <label>출력 용지 : </label> <select id="format"
			class="form-control col-md-2 input-sm">
			<option value="a0">A0 : [1189, 841] (slow)</option>
			<option value="a1">A1 : [841, 594]</option>
			<option value="a2">A2 : [594, 420]</option>
			<option value="a3">A3 : [420, 297]</option>
			<option value="a4" selected>A4 : [297, 210]</option>
			<option value="a5">A5 : [210, 148] (fast)</option>
		</select> <br> <label>출력 해상도 : </label> <select id="resolution"
			class="form-control col-md-2 input-sm">
			<option value="72">72 dpi (fast)</option>
			<option value="150">150 dpi</option>
			<option value="300">300 dpi (slow)</option>
		</select>
	</div>
	<div class="alert-box-footer">
		<div class="text-right">
			<button class="btn btn-danger" id="btnThemeAddStep1Cancel">
				<i class="fa fa-times m-r-5"></i>취소
			</button>
			<button class="btn btn-custom" id="btnThemeAddStep2">
				다음<i class="fa fa-chevron-right m-l-5"></i>
			</button>
		</div>
	</div>
</div>

<div class="wrapper-content asset" id='themeAddStep2'
	style='z-index: 2024; background-color: #ffffff; display: none; overflow-y: auto'>
	<div class="dashboard-box">
		<div class="container">

			<!-- Page-Title -->
			<div class="row">
				<div class="col-sm-12">
					<div class="page-title-box">
						<div class="btn-group pull-right">
							<ol class="breadcrumb hide-phone p-0 m-0">
								<li><a href="<%=RequestMappingConstants.WEB_MAIN%>">HOME</a>
								</li>
								<li class="active">주제도면</li>
							</ol>
						</div>
						<h4 class="page-title">주제도면 등록</h4>
					</div>
				</div>
			</div>
			<!-- End Page-Title -->

			<div class="row">
				<div class="col-sm-12">
					<div
						class="card-box big-card-box last table-responsive searchResult">

						<!-- Table-Content-Wrap -->
						<h5 class="header-title">
							<b>상세보기</b>
						</h5>
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<div class="col-sm-8">
										<label for="">제목</label> <input class="form-control"
											type="text" name="themeAddTitle" id="themeAddTitle" />
									</div>
									<div class="col-sm-4">
										<label for="">공개</label><br> <input type="radio"
											id="themeAddOthbcYn" name="themeAddOthbcYn" value="Y" /> 공개
										<input type="radio" id="themeAddOthbcYn"
											name="themeAddOthbcYn" value="N" checked="checked" /> 비공개
									</div>
								</div>
							</div>
						</div>

						<div class="preview-wrap m-t-30 m-b-30">
							<div class="row">
								<div class="col-sm-12">
									<div class="card-box-inner">
										<div class="col-sm-8" id='themeAddImageContainer'>
											<div class="card-box">
												<div class="card-box-inner cb-inner03" style="height: 100%">
													<label for="">주제도면</label> <img id='themeAddImage'
														name='themeAddImage' src="" class="img-responsive">
												</div>
											</div>
										</div>
										<div class="col-sm-4" id='themeAddLayerContainer'>
											<div class="card-box">
												<div class="card-box-inner cb-inner03" style="height: 100%">
													<label for="">레이어 목록</label> <span class="small">(전체
														<b class="text-orange"><span name='layerListCount'>0</span></b>건)
													</span>
													<div id='themeAddLayer' name='themeAddLayer'></div>
												</div>
											</div>
										</div>
										<div class="col-sm-4" id='themeAddFileContainer'
											style='display: none;'>
											<div class="card-box">
												<label for="">파일 첨부</label>

												<!-- File Add & Edit Page-Body -->
												<div class="row" id="themeFileAdd">
													<form id='themeFileAddForm' enctype="multipart/form-data">
														<div class="btn-wrap pull-left">
															<span class="btn btn-success fileinput-button"> <i
																class="glyphicon glyphicon-plus"></i> <span
																id='spanThemeAddFile'>파일 추가...</span> <input
																id='inputThemeAddFile' name="files" type="file"
																style='display: none;' maxlength="1"
																data-maxsize="25600" data-maxfile="5120"
																accept=".jpg, .jpeg, .png, .gif, .bmp" />
															</span>
															<button type="button" class="btn btn-danger delete"
																id="btnThemeFileDelete">
																<i class="glyphicon glyphicon-trash"></i> <span>파일
																	삭제</span>
															</button>
														</div>
													</form>

													<table role="presentation" class="table table-striped"
														id="themeFileAddRow">
														<tbody class="files">
														</tbody>
													</table>

													<p></p>

													<div>
														<div class="btn-wrap pull-right">
															<button type="button" class="btn btn-primary start"
																id="btnThemeFileAddSave">
																<i class="glyphicon glyphicon-upload"></i> <span>업로드</span>
															</button>
															<button type="reset" class="btn btn-primary cancel"
																id="btnThemeFileAddCancel" style='display: none;'>
																<i class="glyphicon glyphicon-ban-circle"></i> <span>닫기</span>
															</button>
														</div>
													</div>
												</div>
												<!-- End File Add & Edit Page-Body -->

											</div>
										</div>
									</div>
								</div>
							</div>
						</div>

						<!-- Button-Group -->
						<div class="modal-footer">
							<button type="button" class="btn btn-custom btn-md"
								id='btnThemeAddPrevStep'>
								<span>이전<i class="fa fa-chevron-left m-l-5"></i></span>
							</button>
							<button type="button" class="btn btn-custom btn-md"
								id='btnThemeAddSave'>
								<span><i class="fa fa-check-circle m-r-5"></i>등록</span>
							</button>
							<button type="button" class="btn btn-danger btn-md"
								id='btnThemeAddCancel'>
								<span><i class="fa fa-times m-r-5"></i>취소</span>
							</button>
						</div>
						<!--// End Button-Group -->

					</div>
				</div>
			</div>
		</div>
	</div>


</div>

<div id="legend" class="legend open sma-legend">
	<div class="legend-content">
		<div class="sma-it-legend" id='map-layerlist'>
			<div id="layer_legend" class="list-answer"
				style="display: none; border-radius: 10px 10px 10px 10px; z-index: 4000">
				<div id="layer_legend_html"
					style='border-radius: 10px 10px 10px 10px;'></div>
			</div>
		</div>
	</div>
</div>


