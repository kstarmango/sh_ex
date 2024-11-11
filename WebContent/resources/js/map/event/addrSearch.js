/**
 * 공통 - 지도 주소검색 기능을 위한js
 * 
 * ======================= 함수 목록 ======================= 
  1. searchToggle(type)												: 주소검색 결과 DIV toggle
  2. searchKeyword(page, type)										: 주소검색 결과 목록 가져오기 || 검색어(type, tot : 전체, road: 도로명, jibun: 지번, pino: 피노지오)
  3. getPagingNavi(type, currNo, lastNo) 							: 페이지 네비게이션 || 검색어(type, tot : 전체, road: 도로명, jibun: 지번, pino: 피노지오), currNo(현재 페이지번호), lastNo(마지막 페이지번호) 
  4. getAddrRoad(data,page)											: 도로명 주소 결과 뿌려주기
  5. getAddrJibun(data,page)										: 지번 주소 결과 뿌려주기
  6. getAddrPinogeo(data,page)										: 피노지오 결과 뿌려주기
  7. addr_pointSpot(x,y)											: 주소 위치 포인트 좌표찍기
  8. addr_coordnate_geom(pnu)										: 주소 필지 지오메트리 표출
  9. go_addr_search(admCd, rnMgtSn, udrtYn, buldMnnm, buldSlno)		: 도로명주소 API x,y좌표 가져오기
  10. showSearchList(type, isMoreClick) 							: 검색종류별 화면표출 || 검색어(type, tot : 전체, road: 도로명, jibun: 지번, pino: 피노지오)
 */

function searchToggle(type){
	if(type == "open") $('#searchResults').show();
	else $('#searchResults').toggle();
}

//함수명 : searchKeyword
//내 용 :  주소검색 결과 목록 가져오기
//인 자 :  _id(검색창 id), page(현재 페이지번호), 검색어(type, tot : 전체, road: 도로명, jibun: 지번, pino: 피노지오)
//반환값 : 없음
//사용법 :
function searchKeyword(page, type){
	var _keyowrd = $('#searchKeword').val();
	$('#addr_keyword_result').html("'"+_keyowrd+"'");

	$.ajax({
	     type: 'GET',
	     url: "/search/getProxy.do",
	     data: {	
	    	 	keyword : _keyowrd,
	    	 	type : type,
	    	 	page : page
			},
		dataType: "json",		
	    beforeSend: function() { $('html').css("cursor", "wait"); },
	    complete: function() { $('html').css("cursor", "auto"); },
		success: function(data) {	
			var searchInfo = data.search;
			$("#addr_list1").html(null);
			$("#addr_list2").html(null);
			$("#addr_list3").html(null);
			
			if(type == "summary"){
				$("#addr_tot_cnt").text(searchInfo.RoadCount+searchInfo.JibunCount+searchInfo.PinoCount)
				$("#addr_cnt1").text(searchInfo.RoadCount);	
				$("#addr_cnt2").text(searchInfo.JibunCount);		
				$("#addr_cnt3").text(searchInfo.PinoCount);		
				//$("#addr_page").html(null);
				getAddrRoad(searchInfo.Road, searchInfo.RoadCount); 		//도로명 주소 결과
				getAddrJibun(searchInfo.Jibun, searchInfo.JibunCount); 		//지번 주소 결과
				getAddrPinogeo(searchInfo.Pino, searchInfo.PinoCount); 		//피노지오 주소 결과
			}else if(type == "road"){
				getAddrRoad(searchInfo.Road, searchInfo.RoadCount); 		//도로명 주소 결과
				var pagingHtml = getPagingNavi(type, page, Math.ceil(searchInfo.RoadCount/10));
				$("#addr_page").html(pagingHtml);
			}else if(type == "jibun"){
				getAddrJibun(searchInfo.Jibun, searchInfo.JibunCount); 	//지번 주소 결과
				var pagingHtml = getPagingNavi(type, page, Math.ceil(searchInfo.JibunCount/10));
				$("#addr_page").html(pagingHtml);
			}else if(type == "pino"){
				getAddrPinogeo(searchInfo.Pino, searchInfo.PinoCount); 	//피노지오 주소 결과
				var pagingHtml = getPagingNavi(type, page, Math.ceil(searchInfo.PinoCount/10));
				$("#addr_page").html(pagingHtml);
			}
		},
		error: function(data, status, er) { alert("해당 검색내용이 없습니다."); }
	});
}

//함수명 : getPagingNavi
//내 용 : 페이지 네비게이션
//인 자 : 검색어(type, tot : 전체, road: 도로명, jibun: 지번, pino: 피노지오), currNo(현재 페이지번호), lastNo(마지막 페이지번호) 
//반환값 : html
//사용법 :
function getPagingNavi(type, currNo, lastNo) {
	
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
	if(currNo == 1){ pag += "<li class=\"disabled\"><a href=\"javascript:searchKeyword("+goPrev+",'"+type+"')\"><i class=\"fa fa-angle-left\"></i></a></li>"; }
	else{ pag += "<li><a href=\"javascript:searchKeyword("+goPrev+",'"+type+"')\"><i class=\"fa fa-angle-left\"></i></a></li>"; }
	
	for(i=prev; i<=next; i++){
		if(i == currNo){ pag += "<li class=\"active\"><a href=\"javascript:searchKeyword("+i+",'"+type+"')\">"+i+"</a></li>"; }
		else{ pag += "<li><a href=\"javascript:searchKeyword("+i+",'"+type+"')\">"+i+"</a></li>"; }
	}	
	if(currNo == lastNo){ pag += "<li class=\"disabled\"><a href=\"javascript:searchKeyword("+goNext+",'"+type+"')\"><i class=\"fa fa-angle-right\"></i></a></li>"; }
	else{ pag += "<li><a href=\"javascript:searchKeyword("+goNext+",'"+type+"')\"><i class=\"fa fa-angle-right\"></i></a></li>"; }
	
	return pag;
}
function activeList(_this){
	$('.listBox li').css('background' ,'white');
	$(_this).css('background', 'rgba(203, 221, 255, 0.3)');
}
//도로명 주소 결과 뿌려주기
function getAddrRoad(data,cnt){
	if(0 < cnt){ //결과가 있을 경우
		for(i=0; i<data.length; i++){
		    var con = 	"<li onclick=\"javascript:activeList(this); go_addr_search('"
					+data[i].admCd+"', '"+data[i].rnMgtSn+"', '"+data[i].udrtYn+"', '"
					+data[i].buldMnnm+"', '"+data[i].buldSlno+"');\">";
				con += "		<span>"+data[i].roadAddr+"</span>";		
				con += "		<p class=\"list-group-item-text\">"+data[i].jibunAddr+" </p>";
				con += "</li>";
			$("#addr_list1").append(con);
		}
	}else{
		var con = "<div style='font-size: 1.3rem;font-weight: 400;'>";
		con += 		"		<span>검색 결과가 없습니다.</span>";		
		con += 		"</div>";
		$("#addr_list1").append(con);
	}
}

//지번 주소 결과 뿌려주기
function getAddrJibun(data,cnt){
	if(0 < cnt){ //결과가 있을 경우
		for(i=0; i<data.length; i++){
			
			var addr_x = Number(data[i].point.x);
			var addr_y = Number(data[i].point.y);
	
			var spot = ol.proj.transform([addr_x,addr_y], 'EPSG:4326', 'EPSG:900913');
		    //var con = 	"<li onclick=\"javascript:addr_pointSpot('"+data[i].point.x+"' , '"+data[i].point.y+"');addr_coordnate_geom('"+data[i].id+"')\">"; //기존 data.geom[i]
			var con = 	"<li onclick=\"javascript:addr_pointSpot('"+spot[0]+"' , '"+spot[1]+"');addr_coordnate_geom('"+data[i].id+"')\">"; //기존 data.geom[i]
				con += "		<span>"+data[i].address.parcel+"</span>";		
				con += "</li>";
			$("#addr_list2").append(con);
		}
	}else{
		var con = "<div style='font-size: 1.3rem;font-weight: 400;'>";
		con += 		"		<span>검색 결과가 없습니다.</span>";		
		con += 		"</div>";
		$("#addr_list2").append(con);
	}
}

//피노지오 결과 뿌려주기
function getAddrPinogeo(data,cnt){
	if(0 < cnt){ //결과가 있을 경우
		for(i=0; i<data.length; i++){
			
			var addr_x = Number(data[i].px4326);
			var addr_y = Number(+data[i].py4326);
	
			var spot = ol.proj.transform([addr_x,addr_y], 'EPSG:4326', 'EPSG:900913');
			
		    //var con = 	"<li onclick=\"javascript:addr_pointSpot('"+data[i].px4326+"' , '"+data[i].py4326+"');addr_coordnate_geom('"+data[i].pnu+"')\">"; //기존 data.geom[i]
			var con = 	"<li onclick=\"javascript:addr_pointSpot('"+spot[0]+"' , '"+spot[1]+"');addr_coordnate_geom('"+data[i].pnu+"')\">"; //기존 data.geom[i]
				con += "		<span>"+data[i].parcel_addr+"</span>";		
				con += "</li>";
			$("#addr_list3").append(con);
		}
	}else{
		var con = "<div style='font-size: 1.3rem;font-weight: 400;'>";
		con += 		"		<span>검색 결과가 없습니다.</span>";		
		con += 		"</div>";
		
		$("#addr_list3").append(con);
	}
}

function addr_pointSpot(x,y){
	$(".pin_select").remove();
		
	var spot = [x, y];
	var measureTooltipElement = document.createElement('div');
  	measureTooltipElement.className = "pin_select";
  	measureTooltipElement.innerHTML = "핀아이콘";
  	var measureTooltip = new ol.Overlay({
    	element: measureTooltipElement,
    	offset: [0,0],
    	positioning: 'bottom-center',
    	position: spot
  	});
  	geoMap.addOverlay(measureTooltip);
	view.setCenter(spot);
	view.setZoom(17);
}

function addr_coordnate_geom(pnu){
	$.ajax({
	     type: 'GET',
	     url: "/getGeom.do",
	     data: {	
	    	 	pnu : pnu
			},
		dataType: "json",		
	    beforeSend: function() { $('html').css("cursor", "wait"); },
	    complete: function() { $('html').css("cursor", "auto"); },
		success: function(data) {	
			console.log("data!!!",data.geom)
			map_draw(data.geom); //도형그리기
		},
		error: function(data, status, er) { alert("해당 검색내용이 없습니다."); }
	});
}

//도로명주소 API x,y좌표 가져오기
function go_addr_search(admCd, rnMgtSn, udrtYn, buldMnnm, buldSlno){

	$.ajax({
		type: 'GET',
		url: "https://www.juso.go.kr/addrlink/addrCoordApi.do",
		data: {	confmKey : "U01TX0FVVEgyMDE3MTIwNjExNTU0NDEwNzUzMzM=",
				admCd : admCd,
				rnMgtSn : rnMgtSn,
				udrtYn : udrtYn,
				buldMnnm : buldMnnm,
				buldSlno : buldSlno,
				resultType : "json"
		},
		dataType: "json",
	    beforeSend: function() { $('html').css("cursor", "wait"); },
	    complete: function() { $('html').css("cursor", "auto"); },
		success: function( data ) {			
			var addr_x = Number(data.results.juso[0].entX);
			var addr_y = Number(data.results.juso[0].entY);
	
			
			Proj4js.defs['EPSG:4326'] = '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs';
			Proj4js.defs['EPSG:5179'] = '+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +units=m +no_defs';
			var wgs84 = new Proj4js.Proj('EPSG:4326');
			var utm_k = new Proj4js.Proj('EPSG:5179');
			var p = new Proj4js.Point(addr_x, addr_y);
			Proj4js.transform(utm_k, wgs84, p);
			

			//그래픽 초기화
			if(vectorLayer != null || vectorLayer != ''){
				vectorSource.clear();
				geoMap.removeLayer(vectorLayer);
			}
			var spot = ol.proj.transform([p.x, p.y], 'EPSG:4326', 'EPSG:900913');
			
			addr_pointSpot(spot[0], spot[1]); //주소검색 포인트 찍기
			
		},
		error: function(data, status, er) { alert("해당 검색내용이 없습니다."); }
	});	
}

//함수명 : showSearchList
//내 용 : 검색종류별 화면표출
//인 자 : 검색어(type, tot : 전체, road: 도로명, jibun: 지번, pino: 피노지오), isMoreClick(더보기 여부)
//반환값 : 없음
//사용법 :
function showSearchList(type, isMoreClick){	
	if(type == "summary"){
		$('.ListWrap').css('display','block');
		$('.ListWrap ul').removeAttr("style");
		$('#search_page_wrap').css('display','none');
	}else{
		$('.ListWrap').css('display','none');
		$('.ListWrap ul').css('height','350px');
		$('#'+type+'Wrap').css('display','block');
		$('#'+type+'Wrap ul').css('height','350px');
		$('#search_page_wrap').css('display','block');
	}
	searchKeyword(1,type);
}