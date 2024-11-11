/**
 * 
 */
//마이맵 저장 버튼 클릭 함수
function fn_map_to_save(actionType){
	
	switch (actionType){
	case "init":
		var center = getMapCenter(geoMap);
		var scale = getZoomLevel(geoMap);
		var param = {
				title : $('#map_save_nm').val()
				,posX : center[0]
				,posY : center[1]
				,scale : scale
				,layerList : shareLayerList.toString()
				,share : shareUserList.toString()
		}
		gfn_transaction("/data/map/ins.do", "POST", param, "map_insert"); //url, type, param, actionType
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

//마이맵 지도 불러오기
function fn_myMapLoad(_this){
	
	var x = $(_this).attr('data-posx');
	var y = $(_this).attr('data-posy');
	var scale = $(_this).attr('data-scale');
	var mapNo = $(_this).attr('data-mapno');
	var mapTpName = $(_this).attr('data-tp-name').split(',');
	
	
	if($(_this).is(":checked") == true) { 	// 마이데이터 레이어 On
		geoMap.getView().setCenter([x,y]) 	//setting center
		geoMap.getView().setZoom(scale) 	//setting scale
		
		gfn_transaction("/data/map/selByLayerInfo.do", "POST", {mapNo : mapNo}, "selLayerInfo"); //url, type, param, actionType
	}else{								// 마이데이터 레이어 Off
		geoMap.getLayers().forEach(function (v) {
			for(i=0; i < mapTpName.length; i++){
				if (v.get('name') == mapTpName[i]){
					geoMap.removeLayer(v)
				}
			}
			
		});
	}
	
	
}
function fn_delete(mapNo){
	if(!confirm("저장한 마이맵을 삭제하시겠습니까?")){return;}
	else{
		console.log("mapNo",mapNo)
		gfn_transaction("/data/map/del.do", "POST", {mapNo : mapNo}, "map_delete"); //url, type, param, actionType
	}
}


/////////////////////////////////////////////////////콜백함수///////////////////////////////////////////////////////
function fn_callback(actionType, data){
	console.log("mymap")
	switch (actionType) {
	  case "map_select": //결과 목록 조회 콜백
		  var cnt = data.myDataCnt; //전체 리스트 개수
		  var page = data.curPage; //현재 페이지
		  //data.myDataInfo
		  console.log("data.myDataInfo@@@",data.myDataInfo)
		  var _html = "";
		  for(var i = 0; i < data.myDataInfo.length; i++){
			  _html += '<li>' ;
			  _html += '<div class="mydataItem">';
			  
			  if(data.myDataInfo[i].share){ // 공유 받은 것
				  _html += '<p class="tit crop">';
				  _html += '<span class="lock">공유</span>'	;							
				  _html += '<span class="itemTit">'+data.myDataInfo[i].main_title+'</span>';
				  _html += '<span class="swichBtn">';
				  _html += '<label>';
				  //_html += '<a onClick="fn_myMapLoad(\''+data.myDataInfo[i].pos_x+'\', \''+data.myDataInfo[i].pos_y+'\', \''+data.myDataInfo[i].scale+'\', \''+data.myDataInfo[i].map_no+'\');" style="cursor: pointer;">';
				  _html += '<input type="checkbox" data-type="mymap" data-tp-name="'+data.myDataInfo[i].layer_tp_list+'" data-posX="'+data.myDataInfo[i].pos_x+'" data-posY="'+data.myDataInfo[i].pos_y+'" data-scale="'+data.myDataInfo[i].scale+'" data-mapNo="'+data.myDataInfo[i].map_no+'" onClick=fn_myMapLoad(this);>';
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
				  _html += '<img src="/resources/img/map/icClose24.svg" onClick=fn_delete(\"'+data.myDataInfo[i].map_no+'\"); alt="닫기" style="width: 12px;margin-left: 5px;cursor: pointer;">';
				  _html += '</span>';
				  _html += '<span class="swichBtn">';
				  _html += '<label>';
				  _html += '<input type="checkbox" data-type="mymap" data-tp-name="'+data.myDataInfo[i].layer_tp_list+'" data-posX="'+data.myDataInfo[i].pos_x+'" data-posY="'+data.myDataInfo[i].pos_y+'" data-scale="'+data.myDataInfo[i].scale+'" data-mapNo="'+data.myDataInfo[i].map_no+'" onClick=fn_myMapLoad(this);>';
				 // _html += '<input type="checkbox" data-type="shpUpload" data-save-path="'+savePath+'" data-fileName="'+data.myDataInfo[i].file_save_nm+'" data-idx="'+i+'" onClick=fn_myData_onoff(this);>';
				  _html += '</label>';
				  _html += '</span>';
				  _html += '</p>';
			  }
			  
			  _html += '<div class="btns2">';
			  _html += '<span class="day">등록 '+data.myDataInfo[i].ins_dt_str+'</span>'	
			  if(!data.myDataInfo[i].share){ // 공유받지 않은 것
				  _html += '<button class="link" onClick="fn_getRowShare(\''+data.myDataInfo[i].map_no+'\',this);">공유</button>';
			  }
			  _html +=  '</div>';
			  _html += '</div>';
			  _html += '</li>';
			  
			  
			  
			  
			  
			  /*_html += '<a onClick="fn_myMapLoad(\''+data.myDataInfo[i].pos_x+'\', \''+data.myDataInfo[i].pos_y+'\', \''+data.myDataInfo[i].scale+'\', \''+data.myDataInfo[i].map_no+'\');" style="cursor: pointer;">';
			  _html += '<div class="mydata_title" style="float: left;">'+data.myDataInfo[i].main_title+'</div>';
			  _html += '</a>';
			  _html += '<div class="mydata_info">';
			  _html += '<span style="font-size: small;">'+data.myDataInfo[i].ins_dt_str+'</span>';
			  _html += '<div style="float: right">'
			  if(!data.myDataInfo[i].share){ //공유받지 않은 것 
				  _html += '<button class="btn btn-darkgray btn-sm" onClick="fn_getRowShare(\''+data.myDataInfo[i].map_no+'\');">공유</button>';
			  }
			  _html += '</div>';
			  _html += '</div>';
			  _html += '</li>';*/
		  }
		  $('#shareDataLoadList').html(_html);
		  
		  var pagingHtml = getMyPagingNavi('mymap', page, Math.ceil(cnt/10));
		  $("#mydata_page").html(pagingHtml)
		  break;
	  case "map_insert": //마이데이터 - 마이맵 등록
		  alert(data.msg);
		  gfn_transaction("/data/map/sel.do", "POST", {curPage:1, firstIndex:1,lastIndex:10}, "map_select");  //url, type, param, actionType
	    break;
	  case "selLayerInfo": //레이어 정보 조회 콜백
		  console.log("data.selLayerInfo@@@",data.myLayerInfo);
		 // var layerArr = layerList.split(",");
			for(var i = 0; i < data.myLayerInfo.length; i++){
				//get_WMSlayer
				var info = data.myLayerInfo[i];
				if($('#'+info.layer_tp_nm).is(":checked") == true){
					return;
				}else{
					if(-1 < info.server_nm.indexOf('VWORLD')) {
						geoMap.addLayer( get_vWorldMap(info.layer_tp_nm, info.layer_tp_nm) );
					}else if(-1 < info.server_nm.indexOf('LH')){
						if(info.layer_tp_nm == "lh_district") fn_lh_district_layer()
						else fn_lh_useplan_layer()
					}else {
						layer_url = info.server_url + '/';
						var addLayer = get_WMSlayer(info.layer_tp_nm);
						addLayer.setZIndex(9900);
						geoMap.addLayer( addLayer );
					}
				}
				$('#'+info.layer_tp_nm).prop("checked",true);
				
			}
		  break;
	  case "shere_insert": //마이데이터 - 개별 공유
		  alert(data.msg);
	  case "map_delete":
		  alert(data.msg);
		  gfn_transaction("/data/map/sel.do", "POST", {curPage:1, firstIndex:1,lastIndex:10}, "map_select");  //url, type, param, actionType
	  default:
	    null; 
	}
}

/*var addLayer = get_WMSlayer(layer_nm);
addLayer.setZIndex(9900);
geoMap.addLayer( addLayer );*/