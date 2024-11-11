/**
 * 
 */
var zoom = 17;
var recordCount = 0;
var processCount = 0;
var isComplete = false;
var isConverting = false;
var geocoderData = [];

var filesGeocodingAllow = ['csv','CSV'];
var filesGeocodingTempArr = [];

var gfn_gridDataChange = function(){
	console.log("grid DataChange!!!!")
}
var gfn_gridClick = function (_this){
	console.log("grid click item!!!",_this )
	console.log("grid click dindex!!!",_this.dindex )
}
function fn_convertType(){
	//$("select[name=geocoding_convert_addr]").val('road')
	$("select[name=geocoding_convert_column1]").val('')
	$("select[name=geocoding_convert_column2]").val('')

	if($("#geocoding_convert_type option:checked").val() == 'CONVER_TYPE_A') {
		$("select[name=geocoding_convert_epsg]").val('4326')
		$('#geocoding_convert_column2').attr('disabled', true);
	} else {
    	$('#geocoding_convert_column2').attr('disabled', false);
	}
}

function fn_geo_epsg_list_reload() {
	$.ajax({
	    type : "POST",
	    url : "/web/cmmn/gisGeocodingEpsgList.do",
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

//grid 행 삭제 geocode 개별함수
function fn_rowRemove(){
	if(!confirm("행을 삭제하시겠습니까?")){return;}
	if(removeIdx.length == 0) {
		alert("삭제할 행이 선택되지 않았습니다.");
		return;
	}
	for(i = 0; i < removeIdx.length; i++){
		gfn_romoveAdd(geocode_grid,removeIdx[i]);
	}
	alert("삭제되었습니다.");
	
	removeIdx = [];
}
var removeIdx = [];


function fn_directGeom(idx){
	var item = idx//this.list[this.doindex];
	$('#geocodeMap_mini').html("");
	$('#geocodeDirect').attr('idx',idx);
	$('#directDiv').css('display','block');
	
	var view_mini = new ol.View({
	    center: center_xy, //초기화면 중심
		projection: projection,
		maxZoom: 19,
  		minZoom: 11,
	    zoom: center_zoom	
	});
	
	var vBase_mini = new ol.layer.Tile({ 
		source: new ol.source.XYZ({
            url: "/getProxy.do?url=http://api.vworld.kr/req/wmts/1.0.0/"+global_props['vworldKey']+"/Base/{z}/{y}/{x}.png", 
            //url: proxy_url+"/req/wmts/1.0.0/C1314EF3-8396-3600-95A8-AC6FE95A4A91/Base/{z}/{y}/{x}.png", //개발
            params: { 'FORMAT': 'image/png', 'TILED': true },
            crossOrigin: null })
    });
	
	//지도
	geocodeMap_mini = new ol.Map({
		  layers: [vBase_mini], 
		  controls:  [ scaleLineControl ],
		  interactions: ol.interaction.defaults({ 
		  }),	              
		  target: document.getElementById('geocodeMap_mini'),	  
		  view: view_mini
	});	
	
	
	var clickIcon = new ol.style.Style({
		image: new ol.style.Icon({
			anchor: [0.5, 40],
			anchorXUnits: 'fraction',
			anchorYUnits: 'pixels',
			opacity: 1,
			size: [40, 40],
			scale: 0.5,
			src: '/resources/img/pin04_sil.png'
		})
    });
	
	var mini_featureLayer = new ol.layer.Vector ({
		 source: new ol.source.Vector()
	});
	
	geocodeMap_mini.on("click", function(evt) {
		var geom  = evt.coordinate;			// 클릭한 지점의 좌표정보
		var coord = ol.proj.transform(geom, 'EPSG:900913', 'EPSG:4326');
	  	var coord_x = coord[0];
	  	var coord_y = coord[1];
	  	console.log("coord_x",coord_x)
	  	console.log("coord_y",coord_y)
	  	
	  	
	  	if(mini_featureLayer != null || mini_featureLayer != '' || mini_featureLayer != undefined){
	  		mini_featureLayer.getSource().clear();
	  		geocodeMap_mini.removeLayer(mini_featureLayer);
		}
	  	
	  	var featureSource = new ol.source.Vector({})
	  	
	  	/* 객체를 담아주는 역할 점의 좌표 라던지 .. */
	  	var pointFeature = new ol.Feature({
	  	    geometry: new ol.geom.Point(geom)
	  	});

	  	featureSource.addFeature(pointFeature);
	  	/* 실제 Layer를 띄워주게 하는 역할 */
	  	mini_featureLayer = new ol.layer.Vector ({
	  	    source: featureSource,
	        style: clickIcon
	  	})

	  	geocodeMap_mini.addLayer(mini_featureLayer);
	  	
	  	$('#geocodeDirect').attr('posx',coord[0]);
	  	$('#geocodeDirect').attr('posy',coord[1]);
	  	
	});
	
}

function addGeocodingFiles(e) {
	//$('#geocoding_load_file_nm_display > tbody > tr').remove();

    var files = e.files;
    var filesArr = Array.prototype.slice.call(files);
    var filesArrLen = filesArr.length;
    var filesTempArrLen = filesGeocodingTempArr.length;

    if(filesArrLen == 0)
    	return;

	filesGeocodingTempArr = [];

    for(var i=0; i<filesArrLen; i++ ) {
        var ext  = filesArr[i].name.split('.').pop().toLowerCase();
        var msg  = ($.inArray(ext, filesGeocodingAllow) == -1 ? '허용되지 않은 파일 입니다.' : '');
        if(msg == "허용되지 않은 파일 입니다."){
			alert(msg);	
			return false;
        }
        
        var size = Math.round(filesArr[i].size / 1024, 2)

        if($.inArray(ext, filesGeocodingAllow) == -1) {
        	continue;
        }

        filesGeocodingTempArr.push(filesArr[i]);

       // $('#geocoding_load_file_nm_display').html(filesArr[i].name);
       // $("#geocoding_load_file_nm_display > tbody").append("<tr class='template-upload fade in'><td</td></tr>");

        //$('#geocoding_save_file_nm').val(filesArr[i].name.replace(/.csv/g, '.xls'));
    };

    $('#load').show();
    if(filesGeocodingTempArr.length > 0) {
		var formData = new FormData();
		for(var i=0, filesTempArrLen = filesGeocodingTempArr.length; i<filesTempArrLen; i++) {
		   formData.append("files", filesGeocodingTempArr[i]);
		}
		//formData.append("separator", $("#geocoding_line_seperator option:selected").val())

		$.ajax({
		    type : "POST",
		    url : "/api/cmmn/uploadCsv.do",
		    data : formData,
		    processData: false,
		    contentType: false,
				error : function(response, status, xhr){
					if(xhr.status =='403'){
						alert('파일 업로드를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
					}
				},
			success: function(data) {
				
				console.log("data!!!",data)
				$('#load').hide();
				$('#myMapResult').css('display','block');
				var groupSourceInfo  = data.groupSourceInfo; //file_grp
				var saveName  = data.saveName; 				//saveName
				var savePath  = data.savePath; 				//savePath
				var groupInfo = data.groupInfo;
				var dataUrl 	= data.dataUrl;
				
				
				var columns = [];
				var columnInfo = data.columnInfo;
				
				var opt = {label : "결과", key : "result", treeControl: false, align: "center","width":50};
				columns.push(opt);
				opt = {label:"등록",key:"register","treeControl":false,align:"center", formatter: function(){
					return '<button class= "primaryLine" style="height: 25px;" onClick="fn_directGeom('+this.item.__index+');">좌표등록</button>'
					}
				}
				columns.push(opt);
				for(var i = 0; i <columnInfo.length; i++){
						var opt = {label : columnInfo[i], key : columnInfo[i], treeControl: false, align: "center", "editor": {"type": "text"}}
						columns.push(opt);	
				}
				
				geocode_grid.setConfig({
					target: $('[data-ax5grid="result-grid"]')
					,showLineNumber: true
                    ,showRowSelector: true
                    ,multipleSelect: true   
                    //,lineNumberColumnWidth: 40
                    //,rowSelectorColumnWidth: 25
                    ,header: {align:'center' ,selector : false}
					,columns:columns
					,body: {
						columnHeight: 35,
						onDataChanged: function () {
							var item = this.list[this.doindex];
							if(item != undefined){
								if(item.__selected__){  
									removeIdx.push(item.__index); 
								}else{
									removeIdx = removeIdx.filter((e) => e !== item.__index); 	//개별  row 선택 id값으로 배열 삭제
								}
				            	console.log("onDataChanged", item);
				            	
				            	var status = "U";
								geocode_grid.updateRow($.extend({}, geocode_grid.list[this.dindex], {status:status}), this.dindex);
								geocode_grid.setValue(this.doindex, "result", "수정");
							}
						}
						,onDataChangeEvent : function () {
			            	var item = this.list[this.doindex];
			            	
			            	//removeIdx
			            	console.log("onDataChangeEvent",item);
						}
					}
				});
				
				
				if(data.result == 'Y' && data.groupInfo != '') {
					recordCount = 0;
					processCount = 0;

					var dataUrl = data.dataUrl;
					var columnCount = data.columnCount;
					var columnHeadr = data.columnInfo;
					var recordTotal = [];

					$.getJSON(dataUrl, function(data) {
						$('#colorPicker').show(); //스타일 설정 DIV 활성화
						
						recordCount = data.features.length;
						recordTotal = data.features; 
						
						_myData_Status['geocode']['layer']['type'] = 'Point';//getGeometryType(data); 	//geocode geometry type
						_myData_Status['geocode']['layer']['name'] = data.name+"_"; 				//geocode layer name
						$('#'+_myData_Status['geocode']['layer']['type']+'StyleBox').show();
						
						$('#geocode_save_file_nm').attr('grp', groupSourceInfo); 	//파일 저장 시 file_grp부여
						$('#geocode_save_file_nm').attr('path', savePath); 			//파일 저장 시 savePath부여
						$('#geocode_save_file_nm').attr('fileNm', saveName); 		//파일 저장 시 saveName부여
						$('#geocode_save_file_nm').attr('fileNmJson', dataUrl);
						
						console.log(columnCount, columnHeadr)
						console.log(recordCount, recordTotal)

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
						
						var gridData = [];
						// 전체 데이터 건수
						$("#geocodingListCount").text("0 / " + recordCount);

						for(i = 0; i < recordCount; i++) {
							gridData.push(recordTotal[i].properties);
						}
						geocode_grid.setData(gridData); //그리드 값 세팅
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


function fn_geocode_start(){
	var convert_file   = $("#geocoding_load_file_nm").val();
	var convert_type   = $("#geocoding_convert_type option:checked").text();
	//var convert_addr  = $("#geocoding_convert_addr option:checked").text();
	var convert_column1 = $("#geocoding_convert_column1 option:checked").val();
	var convert_column2 = $("#geocoding_convert_column2 option:checked").val();
	var convert_epsg   = $("#geocoding_convert_epsg option:checked").val();
	if(convert_file == '' || convert_file.indexOf('.csv') < 1) {
		alert('변환할 파일을 선택하세요');
		return;
	}
	if($("#geocoding_convert_type option:checked").val() == 'CONVER_TYPE_A') {	// 주소 -> 좌표
    	/*if(convert_addr == '') {
    		alert('입력 주소 유형을 선택하세요.');
    		$("#geocoding_convert_addr").focus();
    		return;
    	}*/
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
		$('#load').show();
		setTimeout(fn_geocoding_processing, 1000);
	} else {
		alert('작업을 취소 하셨습니다.')
	}
}

//주소변환 과정
var fn_geocoding_processing = function() {
	processCount = 0;
	$("#geocodingListCount").text("0 / " + recordCount);

	//var data_array = new Array();

	geocoderData.length = 0;

	if($("#geocoding_convert_type option:checked").val() == 'CONVER_TYPE_A') {
    	var addr_index = $("#geocoding_convert_column1 option:checked").text();
    	var x_index = $('#geocodingContentsBody > tr:eq(0) > td').length - 3;
    	var y_index = $('#geocodingContentsBody > tr:eq(0) > td').length - 2;
    	
    	var body = geocode_grid.getList();
    	for(var i=0; i < body.length; i++){
    		if(isConverting == true) {
    			var index = i;
    			var addr = body[i][addr_index];
    			geocoder({index: index, addr : addr, x_index: x_index, y_index: y_index});
    		}else{
    			return false;
    		}
    	}
    	

    	$('#geocodingContentsBody > tr').each(function(index, tr) {
    		if(isConverting == true) {
				var td = $(tr).children();
				td.each(function(i) {
					if(i == addr_index) {
						//data_array.push({index: index, addr : td.eq(i).text(), x: x_index, y: y_index});
						var test = {index: index, addr : td.eq(i).text(), x_index: x_index, y_index: y_index};
						geocoder({index: index, addr : td.eq(i).text(), x_index: x_index, y_index: y_index});
					}
				});
    		} else {
    			return false;
    		}
    	})
	} else {
    	var x_index = $("#geocoding_convert_column1 option:checked").text();
    	var y_index = $("#geocoding_convert_column2 option:checked").text();
    	var addr_index = $('#geocodingContentsBody> tr:eq(0) > td').length - 1;

    	var body = geocode_grid.getList();
    	for(var i=0; i < body.length; i++){
    		if(isConverting == true) {
    			var index = i;
    			var x = body[i][x_index];
    			var y = body[i][y_index];
    			geocoder_reverse({index: index, x: x, y: y, addr_index: addr_index});
    		}else{
    			return false;
    		}
    	}
    	/*$('#geocodingContentsBody > tr').each(function(index, tr) {
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
    	})*/
	}

	//console.log(JSON.stringify(data_array));
	//data_array = [];

	isConverting = false;
	isComplete = true;
	$('#load').hide();
	if(confirm('변환 작업이 완료 되었습니다.지도로 이동 하시겠습니까?')) {
		geocoder_draw(geocoderData);
		changeSymbol('geocode');
		//$('#geocoding_on_map').trigger('click');
	}

	$('#geocoding_to_excel_save').show();
	//$('#geocoding_on_server').show();
	$('#geocoding_on_map').show();

	$('#geocode_to_save').show();
}

function geocoder_move(epsg, x,y){
    geoMap.getView().setCenter(ol.proj.transform([ x, y ], 'EPSG:' + epsg , "EPSG:3857")); // 지도 이동
    geoMap.getView().setZoom(zoom);
}

function geocoder_draw(data,idx,layer_nm) {
	if(geocoderLayer != null || geocoderLayer != ''){
		geocoderLayer.getSource().clear();
		geoMap.removeLayer(geocoderLayer);
	}
	var featureSource = new ol.source.Vector({});
	//changeSymbol('geocode');
	var iconStyle = styles['Point'];
	if(idx != null || idx != undefined ){
		var type = getGeometryType(data);
		_myData_Status['geocode']['layer']['name'] = layer_nm//data.name;
		
		
		iconStyle = jsonToStyle(myDataInfo[idx].style,type);
		var reader = new ol.format.GeoJSON();
		featureSource.addFeatures(reader.readFeatures(data));
		console.log("featureSource",featureSource)
		   var features = reader.readFeatures(data, {
		        featureProjection: 'EPSG:900913' //기본값 4326
		    }); 
		    
		featureSource.addFeatures(features);
	}else{
		for(i=0; i<data.length; i++) {
			var x = data[i].x;
			var y = data[i].y;
			//var s = data[i].status;
			var epsg = data[i].epsg;
			//var point = [ x, y ]//ol.proj.transform([ x, y ], 'EPSG:' + epsg , "EPSG:3857")
			var point = ol.proj.transform([ x, y ], 'EPSG:' + epsg , "EPSG:3857");
			var feature = new ol.Feature({ geometry: new ol.geom.Point(point) });
			feature.setProperties(geocode_grid.list[i]);
			//feature.set('status', s);
			featureSource.addFeature(feature);
			//geocoderLayer.getSource().addFeature(feature);
	    }
		
		iconStyle = new ol.style.Style({
	    	/* fill: new ol.style.Fill({
      		color: 'red'
	    	}), */
	    	stroke: new ol.style.Stroke({
	    		color: 'red',
	      		width: 1.5,
	      		lineDash: [4]
	    	}),
	    	image: new ol.style.RegularShape({
	  		  fill: fill,
	  		  stroke: stroke,
	  		  points: 4,
	  		  radius: parseInt(5),
	  		  angle: Math.PI / 4
	  		})
	    });
	}

	geocoderLayer = new ol.layer.Vector({
		source: featureSource, 
		name : _myData_Status['geocode']['layer']['name'],
        style: iconStyle//styles['Point']
	    // 여기에서 위에서 생성한 Source를 포함하여 레이어를 생성해줍니다.
	});
		
    geoMap.addLayer(geocoderLayer);
    //geoMap.getView().fit(geocoderLayer.getSource().getExtent(), geoMap.getSize());
   /* geoMap.getView().fit(geocoderLayer.getSource().getExtent(), {
        size: geoMap.getSize(),
        maxZoom: 18 
    });*/
    geoMap.getView().animate({
  	  zoom: geoMap.getView().getZoom() - 1,
  	  duration: 500
  	});
	geoMap.renderSync();
	geoMap.render();
	
}
//geoJson 변환
function convertJsonToGeoJson(jsonArray){
	// GeoJSON 객체 생성
	var geojson = {
	  "type": "FeatureCollection",
	  "features": []
	};
	
	// JSON 배열을 GeoJSON으로 변환
	jsonArray.forEach(function(item) {
	  // X, Y 좌표가 유효한지 확인 (빈 값이 아닌 경우에만 변환)
	  var feature = {
	      "type": "Feature",
	      "geometry": {
	        "type": "Point",
	        "coordinates": [parseFloat(item.newX), parseFloat(item.newY)] // 좌표를 숫자로 변환
	      },
	      "properties": {}
	    };
	    
	  	// 나머지 속성들을 properties에 추가
	    for (var key in item) {
	      if (key !== '__index' && key !== '__modified__' && key !== '__original_index' && key !== 'status') { // newX, newY는 geometry로 사용했으므로 제외
	        feature.properties[key] = item[key];
	      }
	    }

	    // features 배열에 추가
	    geojson.features.push(feature);
	});

	// 변환된 GeoJSON 출력
	console.log(geojson); // 보기 좋게 출력
	
	return geojson
}

//지오코딩 저장
function fn_geocode_to_save(actionType){
	switch (actionType){
	case "init":
		if($('#geocode_save_file_nm').val() == '') { //validation
			alert('제목을 입력하세요.'); 
			return;
		}
		
		var styleJson = styleToJson(styles[_myData_Status['geocode']['layer']['type']][0], _myData_Status['geocode']['layer']['type']);
		
		var writer=new ol.format.GeoJSON();
		var geoJsonStr = writer.writeFeatures(geocoderLayer.getSource().getFeatures());
		var pointToGeom = JSON.parse(geoJsonStr).features;
		var pointToGeomArr = [];
		for(var i=0; i < pointToGeom.length; i++){
			pointToGeomArr.push(pointToGeom[i].geometry);
		}
		
		/* geojson 가져오기
		 * var features; 
		geoMap.getLayers().forEach(function (v) {
			if (v.get('name') == _myData_Status['geocode']['layer']['name']){
        		features = v.getSource().getFeatures();
            }
		});
		 var geojsonFormat = new ol.format.GeoJSON();
		    
		 var geojson = geojsonFormat.writeFeaturesObject(features);
		 
		 */
		
		var geojson = convertJsonToGeoJson(geocode_grid.list);
		console.log("geojson!!",geojson)
		
		
		var param = {
			title : $('#geocode_save_file_nm').val()
			,share : shareUserList.toString()
			,grp : $('#geocode_save_file_nm').attr('grp')
			,savePath : $('#geocode_save_file_nm').attr('path')
			,fileNm : $('#geocode_save_file_nm').attr('fileNm')
			,style : JSON.stringify(styleJson)
			,geomStr : JSON.stringify(geojson)//JSON.stringify(pointToGeomArr)
		}
		
		gfn_transaction("/data/geocode/ins.do", "POST", param, "geocode_insert"); //url, type, param, actionType
		break;
	case "row":
		var param = {
			shapeId : $('#rowShareDiv').attr('target')
			,share : shareUserList.toString()
		}
		gfn_transaction("/data/shp/shareIns.do", "POST", param, "shere_insert"); //url, type, param, actionType
		break;
	}
	
}

function fn_delete(target_no, file_grp,path){
	if(!confirm("저장한 주소변환 파일을 삭제하시겠습니까?")){return;}
	else{
		console.log("target_no ::",target_no)
		console.log("file_grp ::",file_grp)
		gfn_transaction("/data/geocode/del.do", "POST", {targetNo : target_no, fileGrp: file_grp, path:path }, "geocode_delete"); //url, type, param, actionType
	}
}
/////////////////////////////////////////////////////콜백함수///////////////////////////////////////////////////////
function fn_callback(actionType, data){
	switch (actionType) {
	  case "select": //결과 목록 조회 콜백
		  //data.myDataInfo
		  myDataInfo = data.myDataInfo;
		  
		  var cnt = data.myDataCnt; //전체 리스트 개수
		  var page = data.curPage; //현재 페이지
		  var _html = "";
		  for(var i = 0; i < data.myDataInfo.length; i++){
			  var savePath = data.myDataInfo[i].file_save_path;
			  savePath = savePath.replace(/\\/g, '/')
			  _html += '<li>' ; 
			  _html += '<div class="mydataItem">';
			  
			  if(data.myDataInfo[i].share){ //공유 받은 것 
				  _html += '<p class="tit crop">';
				  _html += '<span class="lock">공유</span>'	;							
				  _html += '<span class="itemTit">'+data.myDataInfo[i].main_title+'</span>';
				  _html += '<span class="swichBtn">';
				  _html += '<label>';
				  _html += '<input type="checkbox" data-type="geocode" data-save-path="'+savePath+'" data-fileName="'+data.myDataInfo[i].file_save_nm+'" data-idx="'+i+'" onClick=fn_myData_onoff(this);>';
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
				 // _html += '<span class="lock">공유</span>'	;							
				  _html += '<span class="itemTit">'+data.myDataInfo[i].main_title;
				  _html += '<img src="/resources/img/map/icClose24.svg" onClick=fn_delete(\"'+data.myDataInfo[i].shape_no+'\",\"'+data.myDataInfo[i].file_grp+'\",\"'+savePath+data.myDataInfo[i].file_save_nm+'\"); alt="닫기" style="width: 12px;margin-left: 5px;cursor: pointer;">';
				  _html += '</span>';
				  _html += '<span class="swichBtn">';
				  _html += '<label>';
				  _html += '<input type="checkbox" data-type="geocode" data-save-path="'+savePath+'" data-fileName="'+data.myDataInfo[i].file_save_nm+'" data-idx="'+i+'" onClick=fn_myData_onoff(this);>';
				  _html += '</label>';
				  _html += '</span>';
				  _html += '</p>';
			  }
			  _html += '<div class="btns2">';
			  _html += '<span class="day">등록 '+data.myDataInfo[i].ins_dt+'</span>'	
			  if(!data.myDataInfo[i].share){ //공유받지 않은 것 
				  _html += '<button class="link" onClick="fn_getRowShare(\''+data.myDataInfo[i].shape_no+'\',this);">공유</button>';
			  }
			  _html += '<button class="link" onClick="fn_shpDownload(\''+data.myDataInfo[i].file_grp+'\');">다운로드</button>';
			  _html +=  '</div>';
			  _html += '</div>';
			  _html += '</li>';
		  }
		  $('#geocodeDataLoadList').html(_html);
		  
		  var pagingHtml = getMyPagingNavi('geocode', page, Math.ceil(cnt/10));
		  $("#mydata_page").html(pagingHtml)
		  break;
	  case "geocode_insert": //마이데이터 - shp업로드 등록
		  alert(data.msg);
		  gfn_transaction("/data/geocode/sel.do", "POST", {progrmNo:_myData_Status['base']['currentProgrm'],curPage:1, firstIndex:1,lastIndex:10}, "select"); //url, type, param, actionType
	    break;
	  case "shere_insert": //마이데이터 - 개별 공유
		  alert(data.msg);
		  break;
	  case "geocode_delete":
		  alert(data.msg);
		  gfn_transaction("/data/geocode/sel.do", "POST", {progrmNo:_myData_Status['base']['currentProgrm'],curPage:1, firstIndex:1,lastIndex:10}, "select");  //url, type, param, actionType
	  default:
	    null; 
	}
}
/**
 *  지오코더 호출
 *  crs는 output 좌표 체계
 */
function geocoder(param){
	$.ajax({
        type: "get",
        url: global_props['pinogeoUrl']+"/api/geocode/get",
        data : {
			addr : param.addr,
			srid : '4326'
		},
        dataType: 'json',
        success: function(data) {
			
			var result = "실패"; //결과 여부 디폴트가 false
			if(data.DATA.length != 0){
				processCount++;		//성공횟수
				result = "성공";
			}
			
			$("#geocodingListCount").text(processCount + " / " + recordCount);

		    if(data.RESULT) {
				var epsg = $("#geocoding_convert_epsg option:checked").val();
    			var row_index = param.index;
				var x_index = param.x_index;
				var y_index = param.y_index;
				var x_cell = '#geocodingContentsBody > tr:eq(' + row_index + ')' + ' > td:eq(' + x_index + ')';
				var y_cell = '#geocodingContentsBody > tr:eq(' + row_index + ')' + ' > td:eq(' + y_index + ')';
				

				// 셀은 요청 좌표계 표출
				//$(x_cell).text(x_pos);
				//$(y_cell).text(y_pos);
				
				geocode_grid.setValue(row_index, "result", result);
				if(data.DATA.length != 0){
					geocode_grid.setValue(row_index, "newY", data.DATA[0].py4326);
					geocode_grid.setValue(row_index, "newX", data.DATA[0].px4326);
					
					var x_pos = data.DATA[0].px4326;
					var y_pos = data.DATA[0].py4326;
				
					$('#geocodingContentsBody > tr:eq(' + row_index + ')').click(function() {
						//geocoder_move(epsg, x_pos,y_pos);
						
						addr_pointSpot(x_pos,y_pos)
					})

					// 지도 표출용 데이터 추가
					geocoderData.push({epsg: epsg, x: x_pos, y: y_pos})
				}
				
				
			}
		    geocoder_draw(geocoderData);
			/*if(processCount == recordCount && geocoderData.length > 0) {
	    		geocoder_draw(geocoderData);
	    	}
*/        }
    });
}


function geocoder_reverse(param){
	$.ajax({
        type: "get",
        url: global_props['pinogeoUrl']+"/api/geocode/rget",
		data : {
			x : param.x,
			y : param.y,
			srid : '4326'
		},
        dataType: 'json',
        success: function(data) {
	
			var result = "실패"; //결과 여부 디폴트가 false
			if(data.DATA.length != 0){
				processCount++;		//성공횟수
				result = "성공";
			}
			$("#geocodingListCount").text(processCount + " / " + recordCount);

		var epsg = $("#geocoding_convert_epsg option:checked").val();
		var row_index = param.index;
		var addr_index = param.addr_index;
		var add_cell = '#geocodingContentsBody > tr:eq(' + row_index + ')' + ' > td:eq(' + addr_index + ')';
		//var point = ol.proj.transform([ param.x*1, param.y*1], 'EPSG:' + $("#geocoding_convert_epsg option:checked").val(), "EPSG:3857");

		$('#geocodingContentsBody > tr:eq(' + row_index + ')').click(function() {
			//geocoder_move(epsg, param.x, param.y);
			addr_pointSpot(param.x, param.y)
		})
			geocode_grid.setValue(row_index, "result", result);
		if(data.RESULT) {
			
				geocode_grid.setValue(row_index, "newAddr", data.DATA[0].road_addr);
				//$(add_cell).text(data.DATA[0].road_addr);

				geocoderData.push({epsg: epsg, x: param.x, y: param.y})
			} else {
				geocoderData.push({epsg: epsg, x: param.x, y: param.y})
			}

			if(processCount == recordCount && geocoderData.length > 0) {
	    		geocoder_draw(geocoderData);
	    	}
        }
    });
}

function fn_geocodeDirect(_this){
	var idx = $(_this).attr('idx');
	
	geocode_grid.setValue(idx, "newX", $('#geocodeDirect').attr('posx'));
	geocode_grid.setValue(idx, "newY", $('#geocodeDirect').attr('posy'));
	
	$('#directDiv').css('display','none');
	
	geocode_grid.setValue(idx, "result", "수정");
}

