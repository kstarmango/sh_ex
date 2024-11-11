/**
 * 
 */
function gfn_selectList(type, param){
	gfn_transaction(type, "/admin/system/common/selectAjax.do", "POST", param);
}

function gfn_transaction(url, type, param, actionType){
	$('#load').show();
    $.ajax({
        type : type,
        url : url,
      //  contentType : "text/javascript;charset=UTF-8",
        dataType : 'json',
        async : true,
        data : param,
        success : function(data) {
        	gfn_callback(actionType ,data);
        },
        error  : function(request,status,error) {
        	console.log("request",request);
        	console.log("status",status);
        	console.log("error",error);
        }
    });
    
}



function gfn_file_transaction(url, type, param, actionType){
    $.ajax({
        type : type,
        url : url,
      //  contentType : "text/javascript;charset=UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=UTF-8" 
    		, xhr: function () { 
    				let xhr = new XMLHttpRequest(); 
    				xhr.onreadystatechange = function () { 
                        //response 데이터를 바이너리로 처리한다. 세팅하지 않으면 default가 text 
    					xhr.responseType = "blob"; 
    				}; 
    				return xhr; 
    			},
        async : false,
        data : param,
        success : function(data) {
        	gfn_callback(actionType ,data);
        },
        error  : function(request,status,error) {
        	console.log("request",request);
        	console.log("status",status);
        	console.log("error",error);
        }
    });
    
}

function gfn_callback(actionType, data){
	$('#load').hide();
	fn_callback(actionType, data);
	
};

