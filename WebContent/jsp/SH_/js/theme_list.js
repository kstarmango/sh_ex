/**
 * 
 */

Date.prototype.yyyymmdd = function() {
  var mm = this.getMonth() + 1; // getMonth() is zero-based
  var dd = this.getDate();

  return [this.getFullYear(),
          (mm>9 ? '' : '0') + mm,
          (dd>9 ? '' : '0') + dd
         ].join('');
};

var gfv_pageIndex;

function pagenation_theme(params) {
	var divId = params.divId; //페이징이 그려질 div id
    gfv_pageIndex = params.pageIndex; //현재 위치가 저장될 input 태그
    var totalCount = params.totalCount; //전체 조회 건수
    var currentIndex = $("#"+params.pageIndex).val(); //현재 위치
    if($("#"+params.pageIndex).length == 0){
        currentIndex = 1;
    }
     
    var recordCount = params.recordCount; //페이지당 레코드 수
    
    var totalIndexCount = Math.ceil(totalCount / recordCount); // 전체 인덱스 수
    gfv_eventName = params.eventName;
     
    $("#"+divId).empty();
    var preStr = "";
    var postStr = "";
    var str = "";
     
    var first = (parseInt((currentIndex-1) / 5) * 5) + 1;
    var last = (parseInt(totalIndexCount/5) == parseInt(currentIndex/5)) ? totalIndexCount%5 : 5;
    var prev = (parseInt((currentIndex-1)/5)*5) - 4 > 0 ? (parseInt((currentIndex-1)/5)*5) - 4 : 1;
    var next = (parseInt((currentIndex-1)/5)+1) * 5 + 1 < totalIndexCount ? (parseInt((currentIndex-1)/5)+1) * 5 + 1 : totalIndexCount;
        
    if(totalIndexCount > 5){ //전체 인덱스가 5가 넘을 경우, 맨앞, 앞 태그 작성
        preStr += '<li><a href="#this" class="pad_5" onclick="_moveList('+prev+')"><i class="fa fa-angle-left"></i></a></li>';
    }
    else if(totalIndexCount <=5 && totalIndexCount > 1){ //전체 인덱스가 5보다 작을경우, 맨앞 태그 작성
    	preStr += '<li class="hidden"><a href="#this" class="pad_5" onclick="_moveList('+prev+')"><i class="fa fa-angle-left"></i></a></li>';
    }
    else {
    	preStr += '<li class="hidden"><a href="#this" class="pad_5" onclick="_moveList('+prev+')"><i class="fa fa-angle-left"></i></a></li>';
    }
     
    if(totalIndexCount > 5){ //전체 인덱스가 5가 넘을 경우, 맨뒤, 뒤 태그 작성
    	postStr += '<li><a href="#" onclick="_moveList('+next+')"><i class="fa fa-angle-right"></i></a></li>';
    }
    else if(totalIndexCount <=5 && totalIndexCount > 1){ //전체 인덱스가 5보다 작을경우, 맨뒤 태그 작성
        postStr += '<li class="hidden"><a href="#" onclick="_moveList('+next+')"><i class="fa fa-angle-right"></i></a></li>';
    }
    else {
    	postStr += '<li class="hidden"><a href="#" onclick="_moveList('+next+')"><i class="fa fa-angle-right"></i></a></li>';
    }
    
    for(var i=first; i<(first+last); i++){
        if(i != currentIndex){
            str += '<li><a href="#this" class="pad_5" onclick="_moveList('+i+')">'+i+'</li>';
        }
        else{
            str += '<li class="active"><a href="#this" class="pad_5" onclick="_moveList('+i+')">'+i+'</a></li>';
        }
    }
    $("#"+divId).append(preStr + str + postStr);
}

function _moveList(value){
    $("#"+gfv_pageIndex).val(value);
    if(typeof(gfv_eventName) == "function"){
        gfv_eventName(value, 9);
    }
    else {
        eval(gfv_eventName + "(value, 9);");
    }
}

function list_call(pageNo, listCnt) {
	if(pageNo === undefined) {
		pageNo = 1;
	}
	 
	if(listCnt === undefined) {
		listCnt = 9;
	}
	
	var searchText = encodeURIComponent($('#search').val());
	
	$.ajax({
		url: '/theme_list_call.do',
		data: 'pageNo=' + pageNo + '&listCnt=' + listCnt + '&s=' + searchText,
		type: 'get',
		success: function(response) {
			var data = JSON.parse(response);
        	var total = data.TOTAL_COUNT;
            var body = $("div.theme-list-wrap.m-t-30");
            body.empty();
            if(total == 0 || total == undefined){
            	var str = '<div class="row"><div class="col-sm-4">조회된 결과가 없습니다.</div></div>';
                body.append(str);
            }
            else{
                var params = {
                    divId : "pagination",
                    pageIndex : "CURRENT_INDEX",
                    totalCount : total,
                    recordCount : 9,
                    eventName : "list_call"
                };
                pagenation_theme(params);
                 
                var str = "";
                for(i=0;i<data.list.length;i++) {
                	if(i%3 == 0) {
                		str += '<div class="row">';
                	}
                	str += '<div class="col-sm-4">';
                    str += '<div class="thumbnail" onclick="detail(' + data.list[i].post_seq + ')">';
                    str += '<img src="/userfile/motif/' + data.list[i].images + '" class="img-responsive" style="height:200px">';
                    str += '<div class="caption">';
                    str += '<h5 class="text-overflow font-600">' + data.list[i].subject + '</h5>';
                    str += '<h7>'+ '작성자 :' + data.list[i].ownname + '</h7>'; //cjw 작성자명
                    str += '<div class="text-muted m-b-0" style="float:right">' + (new Date(data.list[i].rdate).toISOString().substring(0, 10)) + '</div>';
                    str += '</div>';
                    str += '</div>';
                    str += '</div>';
                    
                    if(data.list.length > 3 && i%3 == 2) {
                		str += '</div>';
                	}
                }
                
                str += '</div>';
                body.append(str);
                 
                $("a[name='title']").on("click", function(e){ //제목
                    e.preventDefault();
                    pagenation_theme($(this));
                });
            }
		},
		error: function(err, code, response) {
			
		}
	});
}

$(document).ready(function() {
	// 최초 1회 실행
	list_call(1, 9);
});