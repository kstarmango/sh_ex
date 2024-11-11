/**
 * 속성검색 팝업 관련 함수
 */
/////////////////////////////////////////////////////전역변수///////////////////////////////////////////////////////
var grid = ""; //gridObject
var columns = []; //column
var gridData = "";//gridData
var status = true;
var geom_type = "";
/////////////////////////////////////////////////////그리드 초기화///////////////////////////////////////////////////////
function fn_initGrid(){
	//그리드 생성	
	grid = create_grid();
	hideGrid = create_grid();
	var param = window.opener.$(opener.c_sendData).serialize();
	gfn_transaction(opener.c_url, "POST", param, "select"); //url, type, param, actionType
}

/////////////////////////////////////////////////////버튼 이벤트///////////////////////////////////////////////////////
function fn_clickEvnt(type,gridObj){
	switch (type) {
    case "excel":
    	var curPage = gridObj.page.currentPage;
    	gridObj.removeColumn(0);
    	gridObj.setData(gridData); //전체 목록 다운로드를 위하여 전체 데이터 세팅
    	gridObj.exportExcel(opener.c_title+" 목록.xls");
    	gridObj.addColumn({label: "도형", key : "shp"
			,  formatter: function(value) {
				var url = "";
				if(geom_type.indexOf('POINT') >= 0) {
					url = opener.global_props.domain+"/resources/img/point.png";
					'<img src="' + url + '" width="40" height="40" />'
				} else if(geom_type.indexOf('LINE') >= 0) {
					url = opener.global_props.domain+"/resources/img/line.png";
				} else if(geom_type.indexOf('POLYGON') >= 0) {
					url = opener.global_props.domain+"/resources/img/polygon.png";
				}else{
					url = opener.global_props.domain+"/resources/img/polygon.png";
				}
                return '<img src="' + url + '" width="30" height="30" />';
            }
		},0);
    	gridSetData(grid, gridData, curPage); //엑셀 다운로드 후 보고있던 화면으로 다시 그리드 값 세팅
    	break;
    case "excel-string":
        console.log(gridObj.exportExcel());
        break;
	}
}

function GISSearchList_DrawAll(){
	var geom = [];
	
	for(var i = 0; i <gridData.length; i++){
		if(gridData[i].geom != null){
			var geometry = gridData[i].geom.value
			var json = {
			          'type': 'Feature',
			          'geometry': JSON.parse(geometry)
			          };
			
			geom.push(json);
		}
	}
	var geojsonObject = { 'type': 'FeatureCollection',
	          'features': geom
    	};	        	  
	        	  
	opener.GISSearchList_DrawAll(geojsonObject);	
}

/////////////////////////////////////////////////////콜백함수///////////////////////////////////////////////////////
function fn_callback(actionType, data){
	switch (actionType) {
	  case "select": //결과 목록 조회 콜백
		console.log("data : ", data);
		gridData = data.dataInfo; 
		
		var column = data.headEngInfo;
		var tblKey = data.tablePkInfo; //해당 테이블의 pk컬럼
		var cnt = data.dataInfo.length; //전체 데이터 수
		var title = opener.c_title; //자식 창 title명
		
		$('#total_cnt').html(cnt);
		$('#c_title').html(title);
		
		var opt = {label: "도형", key : "shp"
			,  formatter: function(value) {
				geom_type = data.geometryInfo;
				var url = "";
				if(geom_type.indexOf('POINT') >= 0) {
					url = opener.global_props.domain+"/resources/img/point.png";
					'<img src="' + url + '" width="40" height="40" />'
				} else if(geom_type.indexOf('LINE') >= 0) {
					url = opener.global_props.domain+"/resources/img/line.png";
				} else if(geom_type.indexOf('POLYGON') >= 0) {
					url = opener.global_props.domain+"/resources/img/polygon.png";
				}else{
					url = opener.global_props.domain+"/resources/img/polygon.png";
				}
                return '<img src="' + url + '" width="30" height="30" />';
            }
		}
		columns.push(opt);
		for(var i = 0; i <column.length; i++){
			if(column[i] != data.tablePkInfo){  //해당 테이블의 pk컬럼은 기입안함
				var opt = {label : data.headKorInfo[i], key : column[i], treeControl: false, align: "center"}
				columns.push(opt)	
			}
		}
		
		 var extOpts =  { //그리드 세부 option
			      name:"grid1",
			      showLineNumber: false,       
			      showRowSelector: false,      
			      multipleSelect: false,       
			     // rowSelectorColumnWidth: 25, 
			      sortable: false,             
			      multiSort: false,           
			      remoteSort: false       
		}
		 
		//그리드 설정
	    grid_config(
	            grid 				//gridObject
	          , "first-grid" 		//target
	          ,{
	             align: "center",	//header
	             columnHeight: 40
	           }, 
	          function(){  //onClick
	        	   //console.log("클릭!",this.item)
	        	   this.self.select(this.dindex); //행 클릭 시 활성화 표시
	               //firstGridOnClick(this.item.comTypeCd);
	        	    var param = {
			    			search_type : opener.c_search_type,//"ASSET_APT",
			    			pk_key: tblKey,
			    			pk_value: this.item[tblKey]
			    		}
	        	   gfn_transaction(opener.global_props.domain+"/web/cmmn/gisDataGeometry.do", "POST", param, "selectGeo") 
	           },
	           columns, 		//columns
	           extOpts,//extOpts
	           gridData, //dataSet
	           //isMenu
	           false
	          //onDataChange
	    	);
		
		    gridSetData(grid, gridData, 0); //그리드 값 세팅
		    break;
	  case "selectGeo": //결과 목록 행 클릭 공간데이터 콜백
		  var geomData = data.dataInfo;
		  opener.fn_gis_map_move(geomData);
		  //opener.map_move(data.dataInfo[0].x, data.dataInfo[0].y, data.dataInfo[0].geom)
	    break;
	  default:
	    null; 
	}
}