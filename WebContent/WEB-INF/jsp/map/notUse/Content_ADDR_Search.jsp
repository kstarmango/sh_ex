<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
$(document).ready(function(){
	
});

/**
 	도로명주소 API : http://localhost:8091
 	검색API : U01TX0FVVEgyMDE3MTIwNjExMjQ1NTEwNzUzMzE=
 	좌표API : U01TX0FVVEgyMDE3MTIwNjExNTU0NDEwNzUzMzM=
	 
	 우편번호
	 API : d015fd0c92dde7fdb1512533449476
 */
 
 // 도로명 주소 U01TX0FVVEgyMDIyMTIyMzEyNTkyNTExMzM2OTM=
 
//도로명검색
function addr_search(a){
	//지번검색으로 이동  240401추가
	$("#search").attr("edit","Y");
	//$("#selsggListAl").change();
			
	var nm =  $("#search").val().replace(" ","");
	var pagesize = 10;
	$(".pin_select").remove();
	
	//주소검색 탭 활성화
	$("#main-tabs li").removeClass("active");
	$("#main-tabs li").eq(0).addClass("active");
	
	if( $('#addr_search').css("display") == "none"){
		$('#addr_search').show();
	} else {
		$('#addr_search').hide();
	}
	
	$("#main-panel .tab-content div[id$=-search-tab]").removeClass("active in");
	$("#main-panel .tab-content div[id$=-search-tab]").eq(0).addClass("active in");
	if( $("#searching_item").css("display") == 'block' ){
		gis_item();
	}
	
	$.ajax({
		type: 'GET',
		url: "http://www.juso.go.kr/addrlink/addrLinkApi.do",			
		data: {	confmKey : "U01TX0FVVEgyMDE3MTIwNjExMjQ1NTEwNzUzMzE=",
				currentPage : a,
				countPerPage : pagesize,
				keyword : nm,
				resultType : "json"
		},
		dataType: "json",		
	    beforeSend: function() { $('html').css("cursor", "wait"); },
	    complete: function() { $('html').css("cursor", "auto"); },
		success: function( data ) {	
			$("#addr_list1").html(null);
			$("#addr_keyword").text( "\"\"" );
			$("#addr_cnt1").text("0");			
			$("#addr_page").html(null);
			$("#addr_keyword").text( "\""+$("#search").val()+"\"" );

			console.log("data.results",data.results)
			if( data.results.common.totalCount > 0 ){
				for(i=0; i<data.results.juso.length; i++){
				    var con = 	"<li class=\"list-group-item\" onclick=\"javascript:go_addr_search('"
							+data.results.juso[i].admCd+"', '"+data.results.juso[i].rnMgtSn+"', '"+data.results.juso[i].udrtYn+"', '"
							+data.results.juso[i].buldMnnm+"', '"+data.results.juso[i].buldSlno+"');\">";
						con += "	<div class=\"pin\">핀아이콘</div>";
						con += "	<div class=\"list-group-item-text-wrap\">";
						con += "		<h5 class=\"list-group-item-heading\">"+data.results.juso[i].roadAddr+"</h5>";		
						con += "		<p class=\"list-group-item-text\">"+data.results.juso[i].jibunAddr+" </p>";
						con += "	</div>";
						con += "</li>";
						
					$("#addr_list1").append(con);
				}
				//$("#addr_keyword").text( "\""+$("#search").val()+"\"" );  240403 위치수정
				$("#addr_cnt1").text( data.results.common.totalCount );
				
				//페이징
			    var pag = "";
				var last = Math.ceil( data.results.common.totalCount / 10 );  
				
				var totalCount = data.results.common.totalCount; //전체 건수
			    var totalPage = Math.ceil(totalCount/pagesize);//한 페이지에 나오는 행수
				var page = a;    
			    var pageGroup = Math.ceil(page/10);    //페이지 수
			    var next = pageGroup*10;
			    var prev = next - 9;            
			    var goNext = next+1;
			    var goPrev;
				if(prev-1<=0){
			        goPrev = 1;
			    }else{
			        goPrev = prev-1;
			    }            

			    if(next>totalPage){
			        goNext = totalPage;
			        next = totalPage;
			    }else{
			        goNext = next+1;
			    }  
				
				if(a == 1){ pag += "<li class=\"disabled\"><a href=\"javascript:addr_search("+goPrev+")\"><i class=\"fa fa-angle-left\"></i></a></li>"; }
				else{ pag += "<li><a href=\"javascript:addr_search("+goPrev+")\"><i class=\"fa fa-angle-left\"></i></a></li>"; }
				
				for(i=prev; i<=next; i++){
					if(i == a){ pag += "<li class=\"active\"><a href=\"javascript:addr_search("+i+")\">"+i+"</a></li>"; }
					else{ pag += "<li><a href=\"javascript:addr_search("+i+")\">"+i+"</a></li>"; }
				}	
				
				if(a == last){ pag += "<li class=\"disabled\"><a href=\"javascript:addr_search("+goNext+")\"><i class=\"fa fa-angle-right\"></i></a></li>"; }
				else{ pag += "<li><a href=\"javascript:addr_search("+goNext+")\"><i class=\"fa fa-angle-right\"></i></a></li>"; }	
					
				$("#addr_page").append(pag);
				
				//화면 열기
				if( $('#main-panel').css("display") == 'none'  ){
					$('#main-panel').toggleClass('hidden');				
				}
				
				//지번검색 초기화
				if($("#search").attr("edit") == "N"){
					$("label[for=selsggListAl]").text( '선택' );
					$("label[for=selEmdListAl]").text( '선택' );
					$("input:checkbox[id='san']").prop('checked', false); 
					$("#jibun").val('');
					$("#addr_cnt2").text("0");			
					$("#addr_list2").html(null);
					
					var con = 	"<li class=\"list-group-item\">";
					con += "		<h5 class=\"list-group-item-heading\">검색 결과가 없습니다.</h5>";		
					con += "</li>";
					
					$("#addr_list2").append(con);
				}
				
				//도로명주소검색결과가 없을시, 지번검색으로 이동
				$("#search").attr("edit","Y");
				$("#selsggListAl").change();
				
			}else{
				//도로명주소검색결과가 없을시, 지번검색으로 이동
				//$("#search").attr("edit","Y");
				//$("#selsggListAl").change();
				
					var con = 	"<li class=\"list-group-item\">";
						con += "		<h5 class=\"list-group-item-heading\">검색 결과가 없습니다.</h5>";		
						con += "</li>";
						
					$("#addr_list1").append(con);
					
				/*  var pag = "	<li class=\"disabled\"><a href=\"#\"><i class=\"fa fa-angle-left\"></i></a></li>";
						pag += "<li class=\"active\"><a href=\"#\">1</a></li>";
						pag += "<li class=\"disabled\"><a href=\"#\"><i class=\"fa fa-angle-right\"></i></a></li>";
					$("#addr_page").append(pag);
					alert("\""+$("#search").val()+"\""+"에 대한 검색내용이 없습니다."); 
				*/
			}
		},
		error: function(data, status, er) { alert("해당 검색내용이 없습니다."); }
	});	
}

//cjw 지번검색 paging 처리 및 위치이동 
 function addr_search_jibun(a){
	 
	if($("#search").attr("edit") == "N" || $("#search").attr("edit") == undefined){  //select로 지번검색했을시, input창 변경
		
		var address  = "";
		var Gu_nm  = $("#selsggListAl option:selected").text();
		var Dong_nm = $("#selEmdListAl option:selected").text();
		var San_nm = $("input:checkbox[id='san']").is(":checked") ? " 산" :" ";
		var Jibun_nm = $("#jibun").val();
		
		address = Gu_nm + " " + Dong_nm + San_nm + " " + Jibun_nm;
		$("#search").val(address);
		$("#addr_keyword").text( "\""+$("#search").val()+"\"" );
		
		addr_search(1)
	}

	//var sgg = $("#selEmdListAl").val().replace(" ","");
	var sgg = $("#selEmdListAl").val(); // 셀렉트 요소의 값 가져오기
	if (sgg.includes(" ")) { // 공백이 포함되어 있는지 확인
	    sgg = sgg.replace(" ",""); // 공백 제거
	}
	var li = '00';
	var san = $("input:checkbox[id='san']").is(":checked") ? "2" :"1";
	var jibun = $("#jibun").val();
	
	$(".pin_select").remove();
	
	//주소검색 탭 활성화
	$("#main-tabs li").removeClass("active");
	$("#main-tabs li").eq(0).addClass("active");
	
	$("#main-panel .tab-content div[id$=-search-tab]").removeClass("active in");
	$("#main-panel .tab-content div[id$=-search-tab]").eq(0).addClass("active in");
	if( $("#searching_item").css("display") == 'block' ){
		gis_item();
	}

	/* 240401 san 삭제 data: {  sgg : sgg + li,
        san : san,
        jibun : jibun
  }, */
	$.ajax({
     type: 'GET',
     url: "/ajaxDB_jibun_list.do",      
     data: {  sgg : sgg + li,
           jibun : jibun
     },
     dataType: "json",    
       beforeSend: function() { 
           if(vectorLayer != null || vectorLayer != ''){ 
       		vectorSource.clear();
       		geoMap.removeLayer(vectorLayer);			
           }
    	   $('html').css("cursor", "wait"); 
       },
       complete: function() { $('html').css("cursor", "auto"); },
       success: function( data ) {	
			$("#addr_list2").html(null);
			//$("#addr_keyword").text( "\"\"" );
			$("#addr_cnt2").text("0");			
			$("#addr_page2").html(null);
			
			if( data != null && data.addr_x != null && data.addr_x != "" ){
				for(i=0; i<data.addr.length; i++){
					var con = 	"<li class=\"list-group-item\" onclick=\"javascript:map_move_search('"+data.addr_x[i]+"' , '"+data.addr_y[i]+"' , '"+ data.geom[i]+"');\">";
										
						con += "	<div class=\"pin\">핀아이콘</div>";
						con += "	<div class=\"list-group-item-text-wrap\">";
						con += "		<h5 class=\"list-group-item-heading\">"+data.addr[i]+"</h5>";		
						con += "		<p class=\"list-group-item-text\">"+data.jibun2[i]+" </p>";
						con += "	</div>";
						con += "</li>";
						
						
					$("#addr_list2").append(con);
					
				}
				//$("#addr_keyword").text( "\""+jibun+"\"" );  240403 검색키워드 주석
				$("#addr_cnt2").text( data.addr.length );
				
				//화면 열기
				if( $('#main-panel').css("display") == 'none'  ){
					$('#main-panel').toggleClass('hidden');				
				}
			}else{
				var con = 	"<li class=\"list-group-item\">";
				con += "		<h5 class=\"list-group-item-heading\">검색 결과가 없습니다.</h5>";		
				con += "</li>";
				
				$("#addr_list2").append(con);
			
				/* 240401 주석처리
				var pag = "	<li class=\"disabled\"><a href=\"#\"><i class=\"fa fa-angle-left\"></i></a></li>";
					pag += "<li class=\"active\"><a href=\"#\">1</a></li>";
					pag += "<li class=\"disabled\"><a href=\"#\"><i class=\"fa fa-angle-right\"></i></a></li>";
				$("#addr_page2").append(pag);
				alert("\""+jibun+"\""+"에 대한 검색내용이 없습니다."); */
			}
		},
		error: function(data, status, er) { alert("해당 검색내용이 없습니다."); }
	});	 
} 

//cjw 지번 검색
/*  function addr_search_jibun(a){
	var sgg = $("#selEmdListAl").val().replace(" ","");
	var li = '00';
	var san = $("input:checkbox[id='san']").is(":checked") ? "2" :"1";
	var jibun = $("#jibun").val();
	
   $.ajax({
     type: 'GET',
     url: "/ajaxDB_jibun_list.do",      
     data: {  sgg : sgg + li,
           san : san,
           jibun : jibun,
     },
     dataType: "json",    
       beforeSend: function() { 
           if(vectorLayer != null || vectorLayer != ''){ 
       		vectorSource.clear();
       		geoMap.removeLayer(vectorLayer);			
           }
    	   $('html').css("cursor", "wait"); 
       },
       complete: function() { $('html').css("cursor", "auto"); },
     success: function( data ) {
       if( data != null && data.addr_x != null && data.addr_x != "") {
         map_move(data.addr_x, data.addr_y, "" + data.geom);
       } else {
         alert("해당 검색내용이 없습니다.");
       }       
    },
    error: function(data, status, er) { alert("해당 검색내용이 없습니다."); }
  });  
} */ 

//화면이동
function go_addr_search(admCd, rnMgtSn, udrtYn, buldMnnm, buldSlno){
    $(".pin_select").remove();
	
	$.ajax({
		type: 'GET',
		url: "http://www.juso.go.kr/addrlink/addrCoordApi.do",
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
			var spot = ol.proj.transform([p.x, p.y], 'EPSG:4326', 'EPSG:900913');
			
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
		},
		error: function(data, status, er) { alert("해당 검색내용이 없습니다."); }
	});	
}

//행정경계 화면이동
function go_line(cd){
	var addr_x = $("#"+cd+"_addr_x").val();
	var addr_y = $("#"+cd+"_addr_y").val();
	var spot = ol.proj.transform([Number(addr_x), Number(addr_y)], 'EPSG:4326', 'EPSG:900913');
	view.setCenter(spot);
}
</script>	
<!-- 퍼블받기전 임시 디자인 -->
<style>
.result{
	position: absolute;
    left: 8px;
    bottom: 155px;
    top: 95px;
    z-index: 200;
    display: flex;
    flex-direction: column;
    width: 320px;
    height: auto;
    border-radius: 4px;
    background-color: #fff;
    box-shadow: var(--style-shadow);
    animation: result 0.3s ease forwards;
    transition: all 0.3s;
    margin-left: 214px;
}
</style>
    <!-- 통합위치검색-Bar -->
    <div class="form-group search-bar" style="top: 55px;left:220px; width:324px; display:none;">
        <label for="search" class="control-label sr-only">위치검색</label>
        <div class="input-group">
            <!-- <span class="input-group-btn">
                <button class="btn btn-darkgreen" id="main-panel-btn"><i class="fa fa-bars fa-lg text-teal"></i></button>
            </span> -->
            <input type="search" class="form-control" style="font-size: 11px;" placeholder="행정구역, 지번, 도로명, 건물명을 띄어서 입력해주세요." id="search" onkeypress="if(event.keyCode==13) {searchKeyword('search',1)}">
            <span class="input-group-btn" id="main-panel-02"> 
                <button class="btn btn-teal" onClick="searchKeyword('search',1)"><i class="fa fa-search"></i></button> <!-- addr_search(1) -->
            </span>
        </div>
    </div>
    <!--// End 통합위치검색-Bar -->
	
	<div id="searchResults" class="result" style="display:none;">
		<div class="search-result-list in-uni">
        	<p class="srl-title"><span class="text-orange" id="addr_keyword">""</span> 검색결과 </p>
           	<div class="list-group-wrap in-uni" style="margin-top: 10px; height: 100%; padding-bottom: 20px;">
           		<div>
	            	<dt>
		                <a href='#a' > <label for="search_type" style="padding: 0px 30px; font-size: 15px;">도로명주소 검색 결과 ( <b class="text-green" id="addr_cnt1">0</b> 건 )</label></a>
	                 </dt>
	                 <dd>
		                 <ul class="list-group" id="addr_list1"></ul>
			                  <div class="text-center">
			                    <ul class="pagination m-b-5 m-t-10 pagination-sm " id="addr_page">
			                        <li class="disabled">
			                            <a href="#"><i class="fa fa-angle-left"></i></a>
			                        </li>
			                        <li class="active">
			                            <a href="#">1</a>
			                        </li>
			                        <li class="disabled">
			                            <a href="#"><i class="fa fa-angle-right"></i></a>
			                        </li>
			                    </ul>
			                </div>
	                 </dd>
                 </div>
                 <div class="divider divider-sm in"></div>
                 <div>
	                 <dt>
		             	<a href='#a' > <label for="search_type" style="padding: 0px 30px; font-size: 15px;">지번주소 검색 결과 ( <b class="text-green" id="addr_cnt2">0</b> 건 )</label></a>
	                 </dt>
	                 <dd>
		                 <ul class="list-group" id="addr_list2" >
		                 </ul>
	                 </dd>
                 </div>
                 <div class="divider divider-sm in"></div>
                 <div>
	                 <dt>
		             	<a href='#a' > <label for="search_type" style="padding: 0px 30px; font-size: 15px;">피노지오 검색 결과 ( <b class="text-green" id="addr_cnt3">0</b> 건 )</label></a>
	                 </dt>
	                 <dd>
		                 <ul class="list-group" id="addr_list3" >
		                 </ul>
	                 </dd>
                 </div>
        	</div>
    	</div>
    </div>
    
    
    
    