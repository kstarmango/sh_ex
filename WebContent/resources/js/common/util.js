/**
 * utility 관련 스크립트
 */

// 슬라이더 초기화
function initSlider(type){
	var min = 0;
	var max = 10000000;
	 $("#slider_"+type).slider({
    	range: true, min: min, max: max, values: [min, max],
    	slide: function( event, ui ){
	    	var type = $(this).prop("id").replace("slider_", "");
	        $("#amount_"+type).text( nCommas(ui.values[0])+" ~  "+nCommas(ui.values[1]) );
	        $("#num_"+type+"_1").val( ui.values[0] );
		    $("#num_"+type+"_2").val( ui.values[1] );
    	}
    });
	slider_range(type);
}

//슬라이더바 범위적용
function slider_range(type, reset){
	var mim = $("#slider_"+type).slider("option", "min");
	var max = $("#slider_"+type).slider("option", "max");
	var now_min = document.getElementById('num_'+type+'_1').value;
	var now_max = document.getElementById('num_'+type+'_2').value;
	if( now_min == '' ){ now_min = mim; }
	if( now_max == '' ){ now_max = max; }
	if(reset){
		now_min = mim; now_max = max;
		$("#num_"+type+"_1").val(null);
	    $("#num_"+type+"_2").val(null);
	}
	now_min = parseInt( now_min );
	now_max = parseInt( now_max );
	if(now_max < now_min){ now_max = now_min; }else if(now_min > now_max){ now_min = now_max; }else if(now_min > max){ now_min = max; }
	var now_val = [now_min, now_max];
	$("#slider_"+type).slider( "option", "values", now_val);
	$("#amount_"+type).text(nCommas($("#slider_"+type).slider("values", 0)) + "  ~  " + nCommas($("#slider_"+type).slider("values", 1)) );
}


//화폐 단위(3자리 쉼표)
function nCommas(x) {    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");}

//show & hide
function visibleToggle(obj,_this){
	if($('#'+obj).css("display") == "none"){
		$('#'+obj).show();
		$(_this).addClass("on");
	}else{
		$('#'+obj).hide();
		$(_this).removeClass("on");
	}
}

//탭 클릭시 css활성화
function gfn_tabClick(_this){
    var tab_id = $(_this).attr('title');
    var id = $(_this).attr('id');
     console.log(tab_id)
    
     $('.tab_content').removeClass('hover');		
 
     $(this).addClass('hover');							
     $("#" + id).addClass('hover');
     $('.contGrayBGInner').hide();
     $('#'+tab_id+'Inner').show();

}

//버튼 클릭시 css활성화
function gfn_btnClickStyle(_this){
	$('.subMenu > li').removeClass('hover');
	if(!$(_this).hasClass('hover')){
		$(_this).addClass("hover");
	}
	
}

///////////공유대상///////////////
/////////////////////////////////////////////////////전역변수///////////////////////////////////////////////////////
var s_grid = ""; //gridObject
var s_shareGrid = ""; //개별 공유 그리드  
/////////////////////////////////////////////////////그리드 초기화///////////////////////////////////////////////////////
function fn_initGridShare(){
	//그리드 생성	
	s_grid = create_grid();
	//그리드 설정 세팅
	s_grid.setConfig({
		target: $('[data-ax5grid="map_to_share_grid"]'),
        showLineNumber: false,
	   	  showRowSelector: false,
	   	  multipleSelect: false,
	   	  header: {align:'center',columnHeight: 40},
        columns: [
   		 {key: "user_nm", label: "부서", align: "left", width: 300, treeControl: true},
           {
               key: "isChecked", label: "Checkbox", width: 100, sortable: false, align: "center", editor: {
               type: "checkbox", config: {height: 17, trueValue: true, falseValue: false}
               }
           }
  	],
        body: {
            columnHeight: 26,
            onDataChanged: function () {
            	var item = this.list[this.doindex];
            	
                if (this.key == 'isChecked' && this.value) { 		//체크박스에 체크가 되었을 경우
                	this.self.updateChildRows(this.dindex, {isChecked: true});
                	if(item.__children__.length != 0 ){								// 부서를 클릭했을 경우
                		shareUserList = shareUserList.concat(item.__children__); 	//부서별 선택 __children__이 배열이기 때문에 concat사용
                	}else{								// 개별 사용자를 클릭했을 경우
                		shareUserList.push(item.id); 	//개별 사용자 선택 id가 String이기 때문에 push사용
                	}
                }else if(this.key == 'isChecked' && !this.value){ 	//체크박스에 체크가 해제 되었을 경우
                	this.self.updateChildRows(this.dindex, {isChecked: false});
                	if(item.__children__.length != 0 ){													// 부서를 클릭했을 경우
                		shareUserList = shareUserList.filter((e) => !item.__children__.includes(e));  	//부서별 선택 __children__배열 삭제
                	}else{																// 개별 사용자를 클릭했을 경우
                		shareUserList = shareUserList.filter((e) => e !== item.id); 	//개별 사용자 선택 id값으로 배열 삭제
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
	
	s_grid.setData(userGridList);
}

function gfn_validation(type,_this){
	switch (type){
	case "myMap":
		if(shareLayerList.length == 0){
			alert("레이어가 선택되지 않았습니다.")
			return;
		}else{
			fn_modal_onOff('myMap-mini');
			$(_this).toggleClass("on");
		}
		break;
	}
}

function fn_getRowShare(id,_this){
	$('.mydataItem').css('border','1px solid rgba(46, 54, 67, 0.2)');
	$(_this).closest(".mydataItem").css('border','1px solid #4a63e1');
	
	$('#rowShareDiv').css('display','block');
	$('#rowShareDiv').attr("target",id);
	fn_shereGrid();
}
function fn_shereGrid(){
	//그리드 생성	
	shareGrid = create_grid();
	//그리드 설정 세팅
	shareGrid.setConfig({
		target: $('[data-ax5grid="share-grid"]'),
        showLineNumber: false,
	   	  showRowSelector: false,
	   	//  multipleSelect: false,
	   	  header: {align:'center',columnHeight: 40},
        columns: [
   		 {key: "user_nm", label: "부서", align: "left", width: 165, treeControl: true},
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
                if (this.key == 'isChecked' && this.value) { 		//체크박스에 체크가 되었을 경우
                	this.self.updateChildRows(this.dindex, {isChecked: true});
                	if(item.__children__.length != 0 ){								// 부서를 클릭했을 경우
                		shareUserList = shareUserList.concat(item.__children__); 	//부서별 선택 __children__이 배열이기 때문에 concat사용
                	}else{								// 개별 사용자를 클릭했을 경우
                		shareUserList.push(item.id); 	//개별 사용자 선택 id가 String이기 때문에 push사용
                	}
                }else if(this.key == 'isChecked' && !this.value){ 	//체크박스에 체크가 해제 되었을 경우
                	this.self.updateChildRows(this.dindex, {isChecked: false});
                	if(item.__children__.length != 0 ){													// 부서를 클릭했을 경우
                		shareUserList = shareUserList.filter((e) => !item.__children__.includes(e));  	//부서별 선택 __children__배열 삭제
                	}else{																// 개별 사용자를 클릭했을 경우
                		shareUserList = shareUserList.filter((e) => e !== item.id); 	//개별 사용자 선택 id값으로 배열 삭제
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
	
	shareGrid.setData(userGridList);
	 
}

function getMyPagingNavi(type, currNo, lastNo) {
	
	var nCurrNo = Number(currNo);
	var nLastNo = Number(lastNo);

	var pageGroup = Math.ceil(currNo/5);    //페이지 수
    var next = pageGroup*5;
    var prev = next - 4;
    var goNext = next+1;
    var goPrev;
    
	if(prev-1<=0){
        goPrev = 1;
    }else{
        goPrev = prev-1;
    }    

	if(next>=lastNo){
        goNext = lastNo;
        next = lastNo;
    }else{
        goNext = next+1;
    }  

    var pag = "";
	if(currNo == 1){ pag += "<li class=\"disabled\"><a href=\"javascript:movePage("+goPrev+",'"+type+"')\"><</a></li>"; }
	else{ pag += "<li><a href=\"javascript:movePage("+goPrev+",'"+type+"')\"><</a></li>"; }
	
	for(i=prev; i<=next; i++){
		if(i == currNo){ pag += "<li class=\"active\"><a href=\"javascript:movePage("+i+",'"+type+"')\">"+i+"</a></li>"; }
		else{ pag += "<li><a href=\"javascript:movePage("+i+",'"+type+"')\">"+i+"</a></li>"; }
	}	
	if(currNo == lastNo){ pag += "<li class=\"disabled\"><a href=\"javascript:movePage("+goNext+",'"+type+"')\">></a></li>"; }
	else{ pag += "<li><a href=\"javascript:movePage("+goNext+",'"+type+"')\">></a></li>"; }
	
	return pag;
}

function movePage(page, type){
	
	var firstIndex = page*10 - 9;
    var lastIndex = page*10; 
    
    if(type=="shpUpload"){
    	gfn_transaction("/data/shp/sel.do", "POST", {progrmNo:_myData_Status['base']['currentProgrm'],curPage:page, firstIndex:firstIndex, lastIndex:lastIndex}, "select");
    }else if(type=="geocode"){
    	gfn_transaction("/data/geocode/sel.do", "POST", {progrmNo:_myData_Status['base']['currentProgrm'],curPage:page, firstIndex:firstIndex, lastIndex:lastIndex}, "select");
    }else if(type=="mymap"){
    	gfn_transaction("/data/map/sel.do", "POST", {curPage:page, firstIndex:firstIndex, lastIndex:lastIndex}, "map_select");  //url, type, param, actionType
    }
		 
}
