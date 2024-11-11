/**
 * 
 */

var _myData_Status = {
	base:{
		currentProgrm : ''
	}
	,shpUpload:{
		layer:{
			name:'',
			type:'',
			selectedFeature:'',
			style:{
		  		fillColor: 'white',
		        color: '#00897B',           
		        weight: 1,              
		        opacity: 0.7,
		        fillOpacity: 0.3
		        // dashArray: [10, 10]
		  	}
		}
	}
	,geocode:{
		layer:{
			name:'',
			type:'',
			selectedFeature:'',
			style:{
		  		fillColor: 'white',
		        color: '#00897B',           
		        weight: 1,              
		        opacity: 0.7,
		        fillOpacity: 0.3
		        // dashArray: [10, 10]
		  	}
		}
	}
	,myData:{
		
	}
}

// ///////////////////////////////////////////////////전역변수///////////////////////////////////////////////////////
var grid = ""; // gridObject
var shareGrid = ""; // 개별 공유 그리드
var myDataInfo;
// ///////////////////////////////////////////////////그리드
// 초기화///////////////////////////////////////////////////////
function fn_initGrid(){
	// 그리드 생성
	grid = create_grid();
	// 그리드 설정 세팅
	grid.setConfig({
		target: $('[data-ax5grid="first-grid"]'),
        showLineNumber: false,
	   	  showRowSelector: false,
	   	  multipleSelect: false,
	   	  header: {align:'center',columnHeight: 40},
        columns: [
   		 {key: "user_nm", label: "부서", align: "left", width: 100, treeControl: true},
           {
               key: "isChecked", label: "Checkbox", width: 50, sortable: false, align: "center", editor: {
               type: "checkbox", config: {height: 17, trueValue: true, falseValue: false}
               }
           }
  	],
        body: {
            columnHeight: 26,
            onDataChanged: function () {
            	var item = this.list[this.doindex];
            	
                if (this.key == 'isChecked' && this.value) { 		// 체크박스에 체크가
																	// 되었을 경우
                	this.self.updateChildRows(this.dindex, {isChecked: true});
                	if(item.__children__.length != 0 ){								// 부서를
																					// 클릭했을
																					// 경우
                		shareUserList = shareUserList.concat(item.__children__); 	// 부서별
																					// 선택
																					// __children__이
																					// 배열이기
																					// 때문에
																					// concat사용
                	}else{								// 개별 사용자를 클릭했을 경우
                		shareUserList.push(item.id); 	// 개별 사용자 선택 id가
														// String이기 때문에 push사용
                	}
                }else if(this.key == 'isChecked' && !this.value){ 	// 체크박스에 체크가 해제 되었을 경우
                	this.self.updateChildRows(this.dindex, {isChecked: false});
                	if(item.__children__.length != 0 ){													// 부서를
																										// 클릭했을
																										// 경우
                		shareUserList = shareUserList.filter((e) => !item.__children__.includes(e));  	// 부서별
																										// 선택
																										// __children__배열
																										// 삭제
                	}else{																// 개별
																						// 사용자를
																						// 클릭했을
																						// 경우
                		shareUserList = shareUserList.filter((e) => e !== item.id); 	// 개별
																						// 사용자
																						// 선택
																						// id값으로
																						// 배열
																						// 삭제
                	}
                }
                
                if(this.key == '__selected__'){
                    this.self.updateChildRows(this.dindex, {__selected__: this.item.__selected__});
                }
            }
        },
        tree: {
            use: true,
            indentWidth: 10,
            arrowWidth: 15,
            iconWidth: 18,
            icons: {
                openedArrow: '<i class="fa fa-caret-down" aria-hidden="true"></i>',
                collapsedArrow: '<i class="fa fa-caret-right" aria-hidden="true"></i>',
                groupIcon: '<i class="fa fa-folder-open" aria-hidden="true"></i>',
                collapsedGroupIcon: '<i class="fa fa-folder" aria-hidden="true"></i>',
                itemIcon: '<i class="fa fa-circle" aria-hidden="true"></i>'
            }
	          ,columnKeys: {
	              parentKey: "pid",
	              selfKey: "id",
	              collapse:"pid"
	          }
        }
	});
	
	grid.setData(userGridList);
}

// EPSG 목록 - SHAPE UPLOADz
function fn_shp_epsg_list_reload() {
	$.ajax({
	    type : "POST",
	    url : "/web/cmmn/gisShapeUploadEpsgList.do",
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
			
			$('#t_srs').val('4326');
			$('#t_srs').attr('disabled', true);
			// 미리보기 디폴트 좌표 설정
			// 기존$('#shape_load_to_map').trigger('click');
		}
	});
}

function fn_upload(_this){
	
}

var filesShapeAllow = ['shp', 'shx', 'dbf', 'prj', 'zip', 'SHP', 'SHX', 'DBF', 'PRJ', 'ZIP'];
var filesShapeTempArr = [];

function addShapeFiles(e) {
	console.log("shp파일 업로드 시작!!!!!")
	$('#shape_load_file_nm_display > tbody > tr').remove();
    var files = e.files;
    var filesArr = Array.prototype.slice.call(files);
    var filesArrLen = filesArr.length;
    var filesTempArrLen = filesShapeTempArr.length;

    if(filesArrLen == 0)
    	return;

	filesShapeTempArr = [];

    for(var i=0; i<filesArrLen; i++ ) {
        var ext  = filesArr[i].name.split('.').pop().toLowerCase();
        var msg  = ($.inArray(ext, filesShapeAllow) == -1 ? '허용되지 않은 파일 입니다.' : '');
        if(msg == "허용되지 않은 파일 입니다."){
				alert(msg);	
			return false;
		}
        var size = Math.round(filesArr[i].size / 1024, 2)

        if($.inArray(ext, filesShapeAllow) == -1) {
        	continue;
        }

        if(filesArr[i].name.indexOf('.prj') > 0) {
	        var formData = new FormData();
			formData.append("files", filesArr[i]);

			$.ajax({
			    type : "POST",
			    url : "/api/cmmn/uploadPrj.do",
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
  	// $("#shape_load_file_nm").off("change")
}

// 저장 버튼 클릭 시
function fn_shp_to_upload() {
	console.log("업로드 버튼 클릭!!!!")
	/*
	 * if(fn_shape_processing_condition()) { if(confirm('변환을 요청하셨습니다. 작업을 진행
	 * 하시겠습니까?')) { var s_srs = $("#s_srs option:checked").val(); var t_srs =
	 * $("#t_srs option:checked").val(); setTimeout(fn_shape_processing('ESRI
	 * Shapefile', s_srs, t_srs, true, true), 1000); isConverting = true; } else {
	 * alert('작업을 취소 하셨습니다.') } }
	 */
	
	/*
	 * $("#t_srs").val('3857'); $('#t_srs').attr('disabled', true);
	 */
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
}

// shpUpload 변환 유효성 검사
function fn_shape_processing_condition() {
	var origin_epsg  = $("#s_srs option:checked").val();
	var convert_epsg = $("#t_srs option:checked").val();
	var convert_file = $("#shape_load_file_nm").val();

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
	/*
	 * else if(origin_epsg != '' && convert_epsg != '' && origin_epsg ==
	 * convert_epsg) { alert('동일한 좌표룰 선택하셨습니다. 변환을 실행하지 않습니다.'); return false; }
	 */

	return true;
}

var isConverting = false;
var shapeData = '';
// shpUpload 진행
function fn_shape_processing(format, s_srs, t_srs, s_delete, t_delete) {
    var formData = new FormData();
	for(var i=0, filesTempArrLen = filesShapeTempArr.length; i<filesTempArrLen; i++) {
	   formData.append("files", filesShapeTempArr[i]);
	}
	formData.append("format", format);
	formData.append("s_srs", 'EPSG:' + s_srs);
	formData.append("t_srs", 'EPSG:' + t_srs);
	// formData.append("s_delete", s_delete);
	// formData.append("t_delete", t_delete);
	$('#load').show();
	$.ajax({
	    type : "POST",
	    url : "/api/cmmn/uploadShp.do",
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
			$('#load').hide();
			$('#myMapResult').show();   // 미리보기 uploadShp성공 시 shp 결과창 표출
			$('#shape_to_save').show(); // 미리보기 uploadShp성공 시 저장 버튼 표출
			if(data.result == 'Y' && data.groupSourceInfo != '') {
				var groupSourceInfo  = data.groupSourceInfo; // file_grp
				var saveName  = data.saveName; 				// saveName
				var savePath  = data.savePath; 				// savePath
				var dataUrl 	= data.dataUrl;
				var columnCount = data.columnCount;
				var columnHeadr = data.columnInfo;
				var recordCount = 0;
				var recordTotal = [];

				console.log("상단 data!",data)
				if(format == 'GeoJSON') {
					// fn_shapeToTable(data)
					$.getJSON(dataUrl, function(data) {
						$('#colorPicker').show(); // 스타일 설정 DIV 활성화
						
						$('#PolygonStyleBox').hide();
						$('#MultiPolygonStyleBox').hide();
						$('#LineStringStyleBox').hide();
						$('#PointStyleBox').hide();
						
						console.log("data!!!",data)
						_myData_Status['shpUpload']['layer']['type'] = getGeometryType(data); 	// shpUpload
																								// geometry
																								// type
						_myData_Status['shpUpload']['layer']['name'] = saveName;// data.name;
																				// //shpUpload
																				// layer
																				// name
						$('#'+_myData_Status['shpUpload']['layer']['type']+'StyleBox').show();
						
						recordCount = data.features.length;
						recordTotal = data.features;
						
						$('#shpUpload_save_file_nm').attr('grp', groupSourceInfo); 	// 파일
																					// 저장 시
																					// file_grp부여
						$('#shpUpload_save_file_nm').attr('path', savePath); 		// 파일
																					// 저장 시
																					// savePath부여
						$('#shpUpload_save_file_nm').attr('fileNm', saveName); 		// 파일
																					// 저장 시
																					// saveName부여
						// 미리보기 건수
						var loopCount = 5// $("#preview_count").val();

						// 전체 데이터 건수
						 $("#shpaeRecordListCount").text(loopCount + " / " + recordCount);

						// 테이블 커럼 추가
						$("#shpaeRecordContentsHead").empty();

						var strHtml = '<tr>';
						strHtml += ('<th style= "position: sticky; top: 0;">순서</th>');
						for(i = 0; i < columnCount; i++) {
							strHtml += ('<th style= "position: sticky; top: 0;">' + columnHeadr[i] + '</th>');
						}
						// strHtml += ('<th style= "position: sticky; top:
						// 0;">좌표</th>');
						$('#shpaeRecordContentsHead').append(strHtml + '</tr>');
						// 테이블 데이터 추가
						$("#shapeRecordContentsBody").empty();
						for(i = 0; i < loopCount; i++) {
							strHtml = '<tr>';
							strHtml += ('<td>' + (i+1) + '</td>');
							for(j = 0; j < columnCount; j++) {
								strHtml += ('<td>' + recordTotal[i].properties[columnHeadr[j]] + '</td>');
							}
							// strHtml += ('<td>' +
							// recordTotal[i].geometry.coordinates + '</td>');
							$('#shapeRecordContentsBody').append(strHtml + '</tr>');
						}

				    	$('#shape_to_local_save').show();
				    	$('#shape_to_server_save').show();
				    	$('#shape_to_view_map').show();
				    	

						shapeData = data;
						fn_gis_map_draw_geojson(shapeData,null,saveName);
						changeSymbol('shpUpload');
						alert('총 ' + recordCount + '입니다.');
					});
				} 

				/*
				 * 첨부파일 삭제로직 if(s_delete == true && groupSourceInfo != '') {
				 * $.ajax({ type : "POST", url : "/api/cmmn/updatelist.do",
				 * //API DELETE data : { groupNo: groupSourceInfo }, dataType:
				 * 'json', error : function(response, status, xhr){
				 * if(xhr.status =='403'){ alert('파일 삭제 요청이 실패 했습니다.\n\n관리자에게
				 * 문의하시길 바랍니다.'); } }, success: function(data) {
				 * console.log("update1!",data); } }); }
				 * 
				 * if(t_delete == true && groupConvertInfo != '') { $.ajax({
				 * type : "POST", url : "/api/cmmn/updatelist.do", //API DELETE
				 * data : { groupNo: groupConvertInfo }, dataType: 'json', error :
				 * function(response, status, xhr){ if(xhr.status =='403'){
				 * alert('파일 삭제 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.'); } },
				 * success: function(data) { console.log("update2",data); } }); }
				 */
			}
		}
	});
}

// shp파일 저장하기
function fn_shape_to_save(actionType){
	switch (actionType){
	case "init":
		if($('#shpUpload_save_file_nm').val() == '') { // validation
			alert('제목을 입력하세요.'); 
			return;
		}
		
		var styleJson = styleToJson(styles[_myData_Status['shpUpload']['layer']['type']][0], _myData_Status['shpUpload']['layer']['type']);
		
		var param = {
			title : $('#shpUpload_save_file_nm').val()
			,share : shareUserList.toString()
			,grp : $('#shpUpload_save_file_nm').attr('grp')
			,savePath : $('#shpUpload_save_file_nm').attr('path')
			,fileNm : $('#shpUpload_save_file_nm').attr('fileNm')
			,style : JSON.stringify(styleJson)
		}
		$('#load').show();
		gfn_transaction("/data/shp/ins.do", "POST", param, "shp_insert"); // url,
																			// type,
																			// param,
																			// actionType
		break;
	case "row":
		var param = {
			shapeId : $('#rowShareDiv').attr('target')
			,share : shareUserList.toString()
		}
		gfn_transaction("/data/shp/shareIns.do", "POST", param, "shere_insert"); // url,
																					// type,
																					// param,
																					// actionType
		break;
	}
	
}

// 마이데이터 레이어 on/off
function fn_myData_onoff(_this){
	var idx = $(_this).attr('data-idx');
	var type = $(_this).attr('data-type');
	var path  = $(_this).attr('data-save-path');
//	
	var filename = $(_this).attr('data-filename');
	var layer_nm = filename.substring(filename, filename.indexOf("."));
	
	console.log("layer_nm!!",layer_nm)
	
	if($(_this).is(":checked") == true) { 	// 마이데이터 레이어 On
		var _url = path+filename;
		fn_getGeoJson(_url, idx, type,layer_nm)
	}else{									// 마이데이터 레이어 Off
		console.log("off!!")
		geoMap.getLayers().forEach(function (v) {
			console.log("vvvv",v.get('name'))
			if (v.get('name') == layer_nm){
				geoMap.removeLayer(v)
			}
		});
	}
}

// geoJson 가져오기
function fn_getGeoJson(_url, idx, type,layer_nm){
	var dataUrl = '/upload/'+_url;
	$.getJSON(dataUrl, function(data) {
		if(type == "shpUpload"){	// shp
			fn_gis_map_draw_geojson(data,idx,layer_nm);
		}else{	// geocode
			geocoder_draw(data,idx,layer_nm);
		}
	});
	
}

function fn_shpDownload(grpNo){
	var param = {
			groupNo:grpNo
	}
	
	var formObj = $("#shpDownloadForm");

	$('#groupNo').val(grpNo);
	formObj.attr("action", "/api/cmmn/download.do");
	formObj.attr("method", "POST");
	formObj.submit();
	
	// gfn_file_transaction("/api/cmmn/download.do", "POST", param, "down");
	// //url, type, param, actionType
}



function fn_reset(){
	$('#shape_load_file_nm_display').text('선택 파일이 없습니다.');
	$('#shape_load_file_nm_display > tbody > tr').remove();
	filesShapeTempArr = [];

	$("#shpaeRecordListCount").text("0 / 0");

	$("#shpaeRecordContentsHead").empty();
	$("#shapeRecordContentsBody").empty();

	// $("#fileShapeAddForm")[0].reset();

	// $("#t_srs").val('3857');
	// $('#t_srs').attr('disabled', true);
	// $("#shape_load_to_map").prop("checked", true);

	// $('#shape_to_local_save').hide();
	// $('#shape_to_server_save').hide();
	// $('#shape_to_view_map').hide();
	
	$('#s_srs').val(''); // 추가
	$("#t_srs").val(''); // 추가
	$('#t_srs').attr('disabled', true);
	$('#shape_load_file_nm').val(''); // 추가
	$('#shpUpload_save_file_nm').val(''); // 추가
	$('#myMapResult').hide(); // 추가
	$('#shape_to_save').hide(); // 추가
	
	shapeData = '';
	if(vectorLayer != null || vectorLayer != ''){
		vectorSource.clear();
		geoMap.removeLayer(vectorLayer);
	}
}
function fn_delete(target_no, file_grp,path){
	if(!confirm("저장한 SHP파일을 삭제하시겠습니까?")){return;}
	else{
		console.log("target_no ::",target_no)
		console.log("file_grp ::",file_grp)
		gfn_transaction("/data/shp/del.do", "POST", {targetNo : target_no, fileGrp: file_grp, path:path }, "shp_delete"); //url, type, param, actionType
	}
}
// ///////////////////////////////////////////////////콜백함수///////////////////////////////////////////////////////
function fn_callback(actionType, data){
	switch (actionType) {
	  case "select": // 결과 목록 조회 콜백
		  // data.myDataInfo
		  myDataInfo = data.myDataInfo;
		  
		  var cnt = data.myDataCnt; //전체 리스트 개수
		  var page = data.curPage; //현재 페이지
		  var _html = "";
		  for(var i = 0; i < data.myDataInfo.length; i++){
			  var savePath = data.myDataInfo[i].file_save_path;
			  savePath = savePath.replace(/\\/g, '/');
			  _html += '<li>';
			  _html += '<div class="mydataItem">';
			  
			  
			  if(data.myDataInfo[i].share){ // 공유 받은 것
				  _html += '<p class="tit crop">';
				  _html += '<span class="lock">공유</span>'	;							
				  _html += '<span class="itemTit">'+data.myDataInfo[i].main_title+'</span>';
				  _html += '<span class="swichBtn">';
				  _html += '<label>';
				  _html += '<input type="checkbox" data-type="shpUpload" data-save-path="'+savePath+'" data-fileName="'+data.myDataInfo[i].file_save_nm+'" data-idx="'+i+'" onClick=fn_myData_onoff(this);>';
				  _html += '</label>';
				  _html += '</span>';
				  _html += '</p>';
				  
				  _html += '<ul class="note">';
				  _html += '<li class="dot">';
				  _html += '<b>작성자</b>';
				  _html += '<p>'+data.myDataInfo[i].ins_user+'</p>';
				  _html += '</li>';
				  _html += '</ul>';
			  }else{
				  _html += '<p class="tit crop">';
				 // _html += '<span class="lock">공유</span>' ;
				  _html += '<span class="itemTit">'+data.myDataInfo[i].main_title;
				  _html += '<img src="/resources/img/map/icClose24.svg" onClick=fn_delete(\"'+data.myDataInfo[i].shape_no+'\",\"'+data.myDataInfo[i].file_grp+'\",\"'+savePath+data.myDataInfo[i].file_save_nm+'\"); alt="닫기" style="width: 12px;margin-left: 5px;cursor: pointer;">';
				  _html += '</span>';
				  _html += '<span class="swichBtn">';
				  _html += '<label>';
				  _html += '<input type="checkbox" data-type="shpUpload" data-save-path="'+savePath+'" data-fileName="'+data.myDataInfo[i].file_save_nm+'" data-idx="'+i+'" onClick=fn_myData_onoff(this);>';
				  _html += '</label>';
				  _html += '</span>';
				  _html += '</p>';
			  }
			  
			  
			  _html += '<div class="btns2">';
			  _html += '<span class="day">등록 '+data.myDataInfo[i].ins_dt+'</span>'	
			  if(!data.myDataInfo[i].share){ // 공유받지 않은 것
				  _html += '<button class="link" onClick="fn_getRowShare(\''+data.myDataInfo[i].shape_no+'\',this);">공유</button>';
			  }
			  _html += '<button class="link" onClick="fn_shpDownload(\''+data.myDataInfo[i].file_grp+'\');">다운로드</button>';
			  _html +=  '</div>';
			  _html += '</div>';
			  _html += '</li>';
			  
			  
			  /*
				 * _html += '<li style="height: 40px;">' ; _html += '<a
				 * onClick=fn_getGeoJson(\''+savePath+data.myDataInfo[i].file_save_nm+'\','+i+');
				 * style="cursor: pointer;">'; _html += '<div
				 * class="mydata_title" style="float:
				 * left;">'+data.myDataInfo[i].main_title+'</div>'; _html += '</a>';
				 * _html += '<div class="mydata_info">'; _html += '<span
				 * style="font-size: small;">'+data.myDataInfo[i].ins_dt+'</span>';
				 * _html += '<div style="float: right">'
				 * if(!data.myDataInfo[i].share){ //공유받지 않은 것 _html += '<button
				 * class="btn btn-darkgray btn-sm"
				 * onClick="fn_getRowShare(\''+data.myDataInfo[i].shape_no+'\');">공유</button>'; }
				 * _html += '<i class="fa fa-download i_btn_wrap btn_download"
				 * style="margin: 7px;" aria-hidden="true"
				 * onClick="fn_shpDownload(\''+data.myDataInfo[i].file_grp+'\');"></i>';
				 * _html += '</div>'; _html += '</div>'; _html += '</li>';
				 */
		  }
		  $('#shareDataLoadList').html(_html);
		  
		  var pagingHtml = getMyPagingNavi('shpUpload', page, Math.ceil(cnt/10));
		  $("#mydata_page").html(pagingHtml)
		  break;
	  case "shp_insert": // 마이데이터 - shp업로드 등록
		  alert(data.msg);
		  gfn_transaction("/data/shp/sel.do", "POST", {progrmNo:_myData_Status['base']['currentProgrm'],curPage:1, firstIndex:1,lastIndex:10}, "select"); // url,
																														// type,
																														// param,
																														// actionType
	    break;
	  case "shere_insert": // 마이데이터 - 개별 공유
		  alert(data.msg);
		  break;
	  case "shp_delete":
		  alert(data.msg);
		  gfn_transaction("/data/shp/sel.do", "POST", {progrmNo:_myData_Status['base']['currentProgrm'],curPage:1, firstIndex:1,lastIndex:10}, "select");  //url, type, param, actionType
	  default:
	    null; 
	}
}
