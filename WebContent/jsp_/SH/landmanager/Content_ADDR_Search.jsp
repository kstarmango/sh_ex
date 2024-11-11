<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
$(document).ready(function(){
	//열닫 - 주소검색결과리스트
    $('#common-search-btn').click(function() {
        $('#common-search').toggleClass('hidden');
    });
	
	
  	//읍면동리스트 조회
	$("#selsggListAl").change(function() {	
		var sig = $(this);
		var sigcd = sig.val();				
		$.ajax({
			type: 'POST',
			url: "/ajaxDB_emd_list.do",
			data: { "sigcd" : sigcd },
			dataType: "json",
			success: function( data ) {
				if( data != null ) {		
					var emd = $("#selEmdListAl");
					var emd_coord = $("#selEmdListAl_coord"); 
					emd.children("option").remove();					
					emd.append('<option style="display:none;">선택</option>');
					emd_coord.html(null);
					$("label[for=selEmdListAl]").text("선택");
					for (i=0; i<data.emd_cd.length; i++) {	
						emd.append('<option value="'+data.emd_cd[i]+'" label="'+data.emd_nm[i]+'">'+data.emd_nm[i]+'</option>');
						emd_coord.append("<input type=\"hidden\" id=\""+data.emd_cd[i]+"_addr_x\" value=\""+data.addr_x[i]+"\"/>");
						emd_coord.append("<input type=\"hidden\" id=\""+data.emd_cd[i]+"_addr_y\" value=\""+data.addr_y[i]+"\"/>");
					}
				}
			}
		});	
		
		go_line(sigcd);
		$("label[for=selsggListAl]").text( $("#selsggListAl :selected").text() );
	});
	$("#selEmdListAl").change(function() {	
		var emd = $(this);
		var emdcd = emd.val();
		
		go_line(emdcd);
		$("label[for=selEmdListAl]").text( $("#selEmdListAl :selected").text() );
	});
	
});

/**
 	도로명주소 API : http://localhost:8091
 	검색API : U01TX0FVVEgyMDE3MTIwNjExMjQ1NTEwNzUzMzE=
 	좌표API : U01TX0FVVEgyMDE3MTIwNjExNTU0NDEwNzUzMzM=
	 
	 우편번호
	 API : d015fd0c92dde7fdb1512533449476
 */
 
//도로명검색
function addr_search(a){
	var nm =  $("#search").val().replace(" ","");
	var pagesize = 10;
	$(".pin_select").remove();
	
	//주소검색 탭 활성화
	$("#main-tabs li").removeClass("active");
	$("#main-tabs li").eq(0).addClass("active");
	
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
			$("#addr_list").html(null);
			$("#addr_keyword").text( "\"\"" );
			$("#addr_cnt").text("0");			
			$("#addr_page").html(null);
			
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
						
					$("#addr_list").append(con);
				}
				$("#addr_keyword").text( "\""+$("#search").val()+"\"" );
				$("#addr_cnt").text( data.results.common.totalCount );
				
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
			}else{
				var pag = "	<li class=\"disabled\"><a href=\"#\"><i class=\"fa fa-angle-left\"></i></a></li>";
					pag += "<li class=\"active\"><a href=\"#\">1</a></li>";
					pag += "<li class=\"disabled\"><a href=\"#\"><i class=\"fa fa-angle-right\"></i></a></li>";
				$("#addr_page").append(pag);
				alert("\""+$("#search").val()+"\""+"에 대한 검색내용이 없습니다.");
			}
		},
		error: function(data, status, er) { alert("해당 검색내용이 없습니다."); }
	});	
}

//cjw 지번검색 paging 처리 및 위치이동 
 function addr_search_jibun(a){
	var sgg = $("#selEmdListAl").val().replace(" ","");
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
			$("#addr_list").html(null);
			$("#addr_keyword").text( "\"\"" );
			$("#addr_cnt").text("0");			
			$("#addr_page").html(null);
			
			if( data != null && data.addr_x != null && data.addr_x != "" ){
				for(i=0; i<data.addr.length; i++){
					var con = 	"<li class=\"list-group-item\" onclick=\"javascript:map_move('"+data.addr_x[i]+"' , '"+data.addr_y[i]+"' , '"+ data.geom[i]+"');\">";
										
						con += "	<div class=\"pin\">핀아이콘</div>";
						con += "	<div class=\"list-group-item-text-wrap\">";
						con += "		<h5 class=\"list-group-item-heading\">"+data.addr[i]+"</h5>";		
						con += "		<p class=\"list-group-item-text\">"+data.jibun2[i]+" </p>";
						con += "	</div>";
						con += "</li>";
						
						
					$("#addr_list").append(con);
				}
				$("#addr_keyword").text( "\""+jibun+"\"" );
				$("#addr_cnt").text( data.addr.totalCount );
				 /*
				//페이징
				var pag = "";
				var last = Math.ceil( data.addr.totalCount / 10 );  
				
				var totalCount = data.addr.totalCount; //전체 건수
			    var totalPage = Math.ceil(totalCount/10);//한 페이지에 나오는 행수
				var page = totalPage;    
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
				
				 if(a == 1){ pag += "<li class=\"disabled\"><a href=\"javascript:addr_search_jibun("+goPrev+")\"><i class=\"fa fa-angle-left\"></i></a></li>"; }
				else{ pag += "<li><a href=\"javascript:addr_search_jibun("+goPrev+")\"><i class=\"fa fa-angle-left\"></i></a></li>"; }
				
				for(i=prev; i<=next; i++){
					if(i == a){ pag += "<li class=\"active\"><a href=\"javascript:addr_search_jibun("+i+")\">"+i+"</a></li>"; }
					else{ pag += "<li><a href=\"javascript:addr_search_jibun("+i+")\">"+i+"</a></li>"; }
				}	
				
				if(a == last){ pag += "<li class=\"disabled\"><a href=\"javascript:addr_search_jibun("+goNext+")\"><i class=\"fa fa-angle-right\"></i></a></li>"; }
				else{ pag += "<li><a href=\"javascript:addr_search_jibun("+goNext+")\"><i class=\"fa fa-angle-right\"></i></a></li>"; }	
					
				$("#addr_page").append(pag); */
				
				//화면 열기
				if( $('#main-panel').css("display") == 'none'  ){
					$('#main-panel').toggleClass('hidden');				
				}
			}else{
				var pag = "	<li class=\"disabled\"><a href=\"#\"><i class=\"fa fa-angle-left\"></i></a></li>";
					pag += "<li class=\"active\"><a href=\"#\">1</a></li>";
					pag += "<li class=\"disabled\"><a href=\"#\"><i class=\"fa fa-angle-right\"></i></a></li>";
				$("#addr_page").append(pag);
				alert("\""+jibun+"\""+"에 대한 검색내용이 없습니다.");
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



    <!-- 통합위치검색-Bar -->
    <div class="form-group search-bar">
        <label for="search" class="control-label sr-only">위치검색</label>
        <div class="input-group">
            <span class="input-group-btn">
                <button class="btn btn-darkgreen" id="main-panel-btn"><i class="fa fa-bars fa-lg text-teal"></i></button>
            </span>
            <input type="search" class="form-control" placeholder="행정구역, 지번, 도로명, 건물명을 띄어서 입력해주세요." id="search" onkeypress="if(event.keyCode==13) {addr_search(1);}">
            <span class="input-group-btn" id="main-panel-02">
                <button class="btn btn-teal" onclick="addr_search(1)"><i class="fa fa-search"></i></button>
            </span>
        </div>
    </div>
    <!--// End 통합위치검색-Bar -->


    <!-- 주소 Select-Bar -->
    <div class="geolocationToolTip"  id="main-panel-01">
    
        <div id="divJibun">
            <div class="select_box first">
                <div class="select_box_in" id="mainMenuSidoCombo">
                	<label for="selSidoListAl" class="ng-binding">서울특별시</label>
                	<select class="color ng-pristine ng-untouched ng-valid" name="selSidoListAl" id="selSidoListAl" ng-model="sidoModel" ng-change="changeSidoCdAl()" ng-options="sido.sidNmAl for sido in sidoListAl">
                		<option value="" disabled="" selected="" style="display:none;" class="">선택</option>
                		<option value="0" label="서울특별시">서울특별시</option>
                	</select>
                	<input type="hidden" id="sidPageIdAl">
                </div>
            </div>

            <div class="select_box">
                <div class="select_box_in" id="mainMenuSggCombo">
                	<label for="selsggListAl" class="ng-binding">자치구</label>
                	<select class="color ng-pristine ng-untouched ng-valid" id="selsggListAl" ng-model="sggModel" ng-change="changeSggCdAl()" ng-options="sgg.sggNm for sgg in sggListAl" ng-disabled="sggListAl == undefined">
                		<option style="display:none;">선택</option>
                		<c:forEach var="result" items="${SIGList}" varStatus="status">
							<option value='<c:out value="${result.sig_cd}"/>' label='<c:out value="${result.sig_kor_nm}"/>'><c:out value="${result.sig_kor_nm}"/></option>
						</c:forEach>
                	</select>
                	<div id="selsggListAl_coord">
                	<c:forEach var="result" items="${SIGList}" varStatus="status">
						<input type="hidden" id="${result.sig_cd}_addr_x" value='<c:out value="${result.addr_x}"/>'/>
						<input type="hidden" id="${result.sig_cd}_addr_y" value='<c:out value="${result.addr_y}"/>'/>
					</c:forEach>
					</div>
                </div>
            </div>
            
            <div class="select_box">
                <div class="select_box_in" id="mainMenuEmdCombo">
                	<label for="selEmdListAl"  class="ng-binding">행정동</label>
                	<select class="color ng-pristine ng-valid ng-touched" id="selEmdListAl" ng-model="emdModel" ng-change="changeEmdCdAl()" ng-options="emd.emdNm for emd in emdListAl" ng-disabled="emdListAl == undefined">
                		<option style="display:none;">선택</option>
                	</select>
                	<div id="selEmdListAl_coord"></div>
                </div>
            </div>
            
			
			<!-- 퍼블완성 지번검색 -->
			<div class="select_box jibun">
            	<div class="select_box_in" id="mainMenuLiCombo">
                	<label><input type="checkbox" class="chbox" name="산" id="san" value="2">산</label>
                	<label class="jibunLabel"><input type="search" class="form-control jibunInput" placeholder="지번 입력" id="jibun" onkeypress="if(event.keyCode==13) {addr_search_jibun(1);}"></label>

            	</div>
        	</div>
        	
			<div class="select_box jibunSearch">
				<button onclick="addr_search_jibun(1)" class="btn btn-sm"><i class="fa fa-search"></i></button>
			</div>
			
			
        </div>
        
        <div class="select_box_end" id="selectArrowBtn">
			<img src="/jsp/SH/img/select_arrow_end.png" id="targetUrl" style="cursor: pointer;" >
		</div>
		
		
        <!-- 검색조건창  -->
        

    </div>
    <!--// End 주소 Select-Bar -->
    
    
    
    
    