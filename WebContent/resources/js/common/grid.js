/**
 * 
 */
/**
 * 그리드 생성
 * Statements
 * @returns {ax5ui.Grid}
 */

/**
 * 
 */
var isLoaded = false;

/**
 * 그리드 생성
 * Statements
 * @returns {ax5.ui.grid}
 */
function create_grid() {
    var gridObj = new ax5.ui.grid();
    return gridObj;
}
/**
 * 그리드 설정 셋팅
 * Statements
 * @param gridObj
 * @param target
 * @param header
 * @param onClick
 * @param columns
 * @param extOpts 다른 config args...
 * @param dataSet(그리드에 데이터 셋팅)
 * @param isMenu(CONTEXT_MENU 사용유무)
 * @param onDataChange
 */
function grid_config(gridObj, target, header, onClick, columns, extOpts, dataSet, isMenu, onDataChange) {
    
    var status;
    var contextMenu = {};
    
    var onDataChangeEvent;
    
    if(onDataChange) {
        onDataChangeEvent = onDataChange;
    }else{
        onDataChangeEvent = function(){
            if(this.list[this.dindex].__modified__ == true){
            	status = "U";
            	/*console.log("data change~~~~~~", this.list[this.dindex].__selected__)
                if( fn_grid_isUndefined(this.list[this.dindex].__selected__) == '' ){
                    status = "I";
                } else {
                    status = "U";
                }*/
                gridObj.updateRow($.extend({}, gridObj.list[this.dindex], {status:status}), this.dindex);
                this.self.select(this.dindex,{selected: true});
            }
        };
    }
    
    if(isMenu || isMenu == undefined){
        contextMenu = {
                iconWidth: 30,
                acceleratorWidth: 200,
                itemClickAndClose: true,
                icons: {
                    'arrow': '<i class="fa fa-caret-right"></i>'
                },
                items: [
                    {type: 2, id:"fix", label: "<spring:message code='label.grid.context1'/>"},
                    {type: 2, id:"unfix", label: "<spring:message code='label.grid.context2'/>"},
                    {divide: true},
                    {type: 1, id:"rowadd", label: "<spring:message code='label.grid.context3'/>"},
//                     {type: 1, id:"", label: "<spring:message code='label.grid.context4'/>"},
                    {divide: true},
                    {type: 2, id:"save", label: "<spring:message code='label.grid.context5'/>"},
                    {type: 2, id:"delete", label: "<spring:message code='label.grid.context6'/>"}
                ],
                popupFilter: function (item, param) {
                    //console.log(item, param);
                    if(param.element) {
                        return true;
                    }else{
                        return item.type == 1;
                    }
                },
                onClick: function (item, param) {
                    //console.log(item, param);
                    //console.log('item.type ==> ' + item.type);
                    if( item.id == 'fix' ){
                        gridObj.setConfig({frozenColumnIndex:param.colIndex});
                    } else if( item.id == 'unfix' ){
                        if( gridObj.config.frozenColumnIndex > 0 ){
                            gridObj.setConfig({frozenColumnIndex:0});    
                        }
                        gridObj.repaint();
                    } else if( item.id == 'rowadd' ){
                        
                        if( dataSet == 'dataSet' ){
                            fn_dataSet(gridObj, gridObj.list.length);
                        } else {
                            gridObj.addRow($.extend({}, gridObj.list[Math.floor(gridObj.list.length)], {__index: undefined, status: "I"}), "last", {focus: "END"});
                        }
                        
                    } else if( item.id == 'save' ){
                        console.log(gridObj);
                        fn_save(gridObj);
                        //console.log(gridObj.getList("selected"));
                    } else if( item.id == 'delete' ){ 
                        fn_delete(gridObj);
                    }
                    //firstGrid.contextMenu.close();
                    //return true;
                }
            }
    }
    
    gridObj.setConfig({
         target: $('[data-ax5grid="'+target+'"]'),
         header: header,
         body: {
             columnHeight: 40,
             onDataChanged: onDataChangeEvent,
             onClick: onClick
         },
         contextMenu: contextMenu,
         columns: columns,
         page: {
             navigationItemCount: 9,
             height: 30,
             display: true,
             firstIcon: '<i class="fa fa-step-backward" aria-hidden="true"></i>',
             prevIcon: '<i class="fa fa-caret-left" aria-hidden="true"></i>',
             nextIcon: '<i class="fa fa-caret-right" aria-hidden="true"></i>',
             lastIcon: '<i class="fa fa-step-forward" aria-hidden="true"></i>',
             onChange: function () {
            	// movePage(this.page.selectPage);
            	 gridSetData(gridObj, dataSet, this.page.selectPage);
             }
         }
    });
  
   if(extOpts != null){
        gridObj.setConfig(extOpts);
    }
}

/**
 * 메시지 그리드 설정 셋팅
 * Statements
 * @param gridObj
 * @param target
 * @param header
 * @param onClick
 * @param columns
 * @param extOpts 다른 config args...
 */
function message_grid_config(gridObj, target, header, onClick, columns, extOpts, langObj) {
    var status;
    var msgKey;
    gridObj.setConfig({
                     target: target,
                     header: header,
                     body: {
                         columnHeight: 28,
                         onDataChanged: function(){
                             console.log(fn_grid_isUndefined(this.list[this.dindex].rgnDt));
                             if(this.list[this.dindex].__modified__ == true){
                                 if( fn_grid_isUndefined(this.list[this.dindex].rgnDt) == '' ){
                                     console.log('undefined');
                                     status = "I";
                                 } else {
                                     console.log('update');
                                     status = "U";
                                 }
                                 console.log('this.list[this.dindex].msgKey ==> ' + this.list[this.dindex].msgKey);
                                 console.log('this.list[this.dindex].msgType ==> ' + this.list[this.dindex].msgType);
                                 
                                 if( this.list[this.dindex].msgKey == undefined ){
                                     msgKey = fn_getKey(gridObj, this.list[this.dindex].key, this.list[this.dindex].msgType);    
                                 } else {
                                     msgKey = this.list[this.dindex].msgKey;
                                 }
                                 
                                 console.log('msgKey ==> ', msgKey);
                                 for( var i = 0; i < gridObj.list.length; i++ ){
                                     if( this.list[this.dindex].key == gridObj.list[i].key ){
                                         gridObj.updateRow($.extend({}, gridObj.list[i], {status:status, msgType: this.list[this.dindex].msgType}), i);
                                         this.self.select(i,{selected: true});
                                     }
                                     
                                     if( this.list[this.dindex].msgKey == gridObj.list[i].msgKey ){
                                         gridObj.updateRow($.extend({}, gridObj.list[i], {status:status}), i);
                                         this.self.select(i,{selected: true});
                                     }
                                 }
                             }
                         },
                         onClick: onClick
                     },
                     contextMenu: {
                         iconWidth: 30,
                         acceleratorWidth: 200,
                         itemClickAndClose: true,
                         icons: {
                             'arrow': '<i class="fa fa-caret-right"></i>'
                         },
                         items: [
                             {type: 2, id:"fix", label: "<spring:message code='label.grid.context1'/>"},
                             {type: 2, id:"unfix", label: "<spring:message code='label.grid.context2'/>"},
                             {divide: true},
                             {type: 1, id:"rowadd", label: "<spring:message code='label.grid.context3'/>"},
//                              {type: 1, id:"", label: "<spring:message code='label.grid.context4'/>"},
                             {divide: true},
                             {type: 2, id:"save", label: "<spring:message code='label.grid.context5'/>"},
                             {type: 2, id:"delete", label: "<spring:message code='label.grid.context6'/>"}
                         ],
                         popupFilter: function (item, param) {
                             //console.log(item, param);
                             if(param.element) {
                                 return true;
                             }else{
                                 return item.type == 1;
                             }
                         },
                         onClick: function (item, param) {
                             //console.log(item, param);
                             //console.log('item.type ==> ' + item.type);
                             if( item.id == 'fix' ){
                                 gridObj.setConfig({frozenColumnIndex:param.colIndex});
                             } else if( item.id == 'unfix' ){
                                 if( gridObj.config.frozenColumnIndex > 0 ){
                                     gridObj.setConfig({frozenColumnIndex:0});    
                                 }
                                 gridObj.repaint();
                             } else if( item.id == 'rowadd' ){
                                 var guid = ax5.getGuid();
                                 for( var i = 0; i < langObj.length; i++ ){
                                     gridObj.addRow($.extend({}, gridObj.list[Math.floor(gridObj.list.length)], {__index: undefined, status: "I", msgLanguage: langObj[i].cd, key: guid }), "last", {focus: "END"});
                                 }
                             } else if( item.id == 'save' ){
                                 console.log(gridObj);
                                 fn_save(gridObj);
                                 //console.log(gridObj.getList("selected"));
                             } else if( item.id == 'delete' ){ 
                                 fn_delete(gridObj);
                             }
                             //firstGrid.contextMenu.close();
                             //return true;
                         }
                     },
                     columns: columns
    });
    
    /**
    * {
        frozenColumnIndex=0,
        frozenRowIndex=0,
        showLineNumber=false,
        showRowSelector=false
        etc...
    }
    */
    if(extOpts != null){
        gridObj.setConfig(extOpts);
    }
}

/**
 * 메시지 그리드 설정 셋팅
 * Statements
 * @param gridObj
 * @param target
 * @param header
 * @param onClick
 * @param columns
 * @param extOpts 다른 config args...
 */
function usrGrp_grid_config(gridObj, target, header, onClick, columns, extOpts, dataSet) {
    var status;
    var msgKey;
    gridObj.setConfig({
                     target: target,
                     header: header,
                     body: {
                         columnHeight: 28,
                         onDataChanged: function(){
                             console.log(fn_grid_isUndefined(this.list[this.dindex].rgnDt));
                             if(this.list[this.dindex].__modified__ == true){
                                 if( fn_grid_isUndefined(this.list[this.dindex].rgnDt) == '' ){
                                     console.log('undefined');
                                     status = "I";
                                 } else {
                                     console.log('update');
                                     status = "U";
                                 }
                                 gridObj.updateRow($.extend({}, gridObj.list[this.dindex], {status:status}), this.dindex);
                                 this.self.select(this.dindex,{selected: true});
                             }
                         },
                         onClick: onClick
                     },
                     contextMenu: {
                         iconWidth: 30,
                         acceleratorWidth: 200,
                         itemClickAndClose: true,
                         icons: {
                             'arrow': '<i class="fa fa-caret-right"></i>'
                         },
                         items: [
                             {type: 2, id:"fix", label: "<spring:message code='label.grid.context1'/>"},
                             {type: 2, id:"unfix", label: "<spring:message code='label.grid.context2'/>"},
                             {divide: true},
                             {type: 1, id:"rowadd", label: "<spring:message code='label.grid.context3'/>"},
//                              {type: 1, id:"", label: "<spring:message code='label.grid.context4'/>"},
                             {divide: true},
                             {type: 2, id:"save", label: "<spring:message code='label.grid.context5'/>"},
                             {type: 2, id:"delete", label: "<spring:message code='label.grid.context6'/>"}
                         ],
                         popupFilter: function (item, param) {
                             //console.log(item, param);
                             if(param.element) {
                                 return true;
                             }else{
                                 return item.type == 1;
                             }
                         },
                         onClick: function (item, param) {
                             //console.log(item, param);
                             //console.log('item.type ==> ' + item.type);
                             if( item.id == 'fix' ){
                                 gridObj.setConfig({frozenColumnIndex:param.colIndex});
                             } else if( item.id == 'unfix' ){
                                 if( gridObj.config.frozenColumnIndex > 0 ){
                                     gridObj.setConfig({frozenColumnIndex:0});    
                                 }
                                 gridObj.repaint();
                             } else if( item.id == 'rowadd' ){
                                 if((storeData2.map.orgLv == '2' && storeData2.map.orgCd == 'P')|| (parseInt(storeData2.map.orgLv, 10) == storeData2.map.orgLvMax)){
                                     gridObj.addRow($.extend({}, gridObj.list[Math.floor(gridObj.list.length)], {__index: undefined}), "last", {focus: "END"});

                                     if( dataSet == 'dataSet' ){
                                         fn_dataSet(gridObj.list.length-1);
                                     }
                                 }else{
                                     gmes_dialog('warning'
                                             , '추가'
                                             , '행추가 가능한 레벨은 왼쪽 리스트의 2레벨, 마지막 레벨입니다.'
                                             , 2000
                                             , function(){});
                                 }
                             } else if( item.id == 'save' ){
                                 console.log(gridObj);
                                 fn_save(gridObj);
                                 //console.log(gridObj.getList("selected"));
                             } else if( item.id == 'delete' ){ 
                                 fn_delete(gridObj);
                             }
                             //firstGrid.contextMenu.close();
                             //return true;
                         }
                     },
                     columns: columns
    });
    
    /**
    * {
        frozenColumnIndex=0,
        frozenRowIndex=0,
        showLineNumber=false,
        showRowSelector=false
        etc...
    }
    */
    /*if(extOpts != null){
        gridObj.setConfig(extOpts);
    }*/
}

/**
 * 트리구조 셋팅
 * columnKeys : {
     parentKey: 상위키,
     selfKey: 자신키
 }
 */
function gridSetTreeConfig(gridObj, target, header, onClick, columns, columnKeys, extOpts) {
    gridObj.setConfig({
        target: target,
        header: header,
        body: {
            columnHeight: 26,
            onDataChanged: function () {
                if (this.key == 'isChecked') {
                    this.self.updateChildRows(this.dindex, {isChecked: this.item.isChecked});
                }
                else if(this.key == '__selected__'){
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
            },
            columnKeys: columnKeys
        },
        columns: columns
    });
    
    /**
     * {
         frozenColumnIndex=0,
         frozenRowIndex=0,
         showLineNumber=false,
         showRowSelector=false
         etc...
     }
     */
     if(extOpts != null){
         gridObj.setConfig(extOpts);
     }
}
/**
 * 그리드 data 셋팅
 * Statements
 * @param gridObj
 * @param data
 * @param page
 */
function gridSetData(gridObj, data, page) {
	console.log("grid set!!!",page)
    //data status 값 셋팅
 /*   $.each(data, function(key, value){
       $.extend(value, gridObj.list[Math.floor(gridObj.list.length)], {status: "S"})
    });*/
	var tmpData = [];	
	//tmpData=data.slice(0,10)
	tmpData=data.slice(page*10,page*10+10);
	/*for (var i = 1; i <= 10; i++) {
		data.push(gridData[(page-1)*10+i]);
	}
*/
    
  if(page != null) {
	  gridObj.setData({
	        list: tmpData,
	        page: {
	            currentPage: page,
	            pageSize: 10,
	            totalElements: data.length,
	            totalPages: Math.ceil(gridData.length / 10)
	        }
	    });
    }else{
        gridObj.setData(data);
    }
}

function gridSetDataPaging(gridObj, gridData, paramData) {
    //data status 값 셋팅
    $.each(gridData, function(key, value){
       $.extend(value, gridObj.list[Math.floor(gridObj.list.length)], {status: "S"})
    });
    if(paramData.pagingInfo != null) {
	    gridObj.setData({
	        list: gridData,
	        page:{ currentPage: paramData.pagingInfo.currentPageNo,
			            pageSize: paramData.pagingInfo.pageSize,
			            totalElements: paramData.pagingInfo.totalRecordCount,
			            totalPages: paramData.pagingInfo.totalPageCount }
	    });
    }else{
        alert("페이징 정보가 없습니다.");
    }
}

/**
 * 그리드 data 클리어
 * Statements
 */
function gridClear(gridObj, data){
    gridObj.setData(data);
}

function fn_grid_isUndefined(val){
	console.log("undefined check>>>>>>",val)
    var rtn = "";
    if(val != undefined){
        rtn = val;
    }
    return rtn;
}

function gfn_getColData(gridObj, row, col){
    var list = gridObj.getList("");
    var tmp = "";
    if(list.length > 0){
        var rowData = list[0];
        if(rowData.hasOwnProperty(col)){
            tmp = rowData[col];
        }
    }
    return tmp;    
}

function gfn_rowAdd(gridObj, addData) {
    
    var data = {__index: undefined, status: "I"};
    if(addData) data = $.extend(true, {}, data, addData);
    
    //gridObj.addRow($.extend({}, gridObj.list[Math.floor(gridObj.list.length)], data), "last", {focus: "END"}); 포커스 부분 잠시 비활
    gridObj.addRow($.extend({}, gridObj.list[Math.floor(gridObj.list.length)], data));
}

function gfn_romoveAdd(gridObj, idx) {
	idx==undefined ? gridObj.removeRow() :  gridObj.removeRow("selected")
}