<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="utf-8">
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <meta name="description" content="SH서울주택도시공사 | 토지자원관리시스템">

    <link rel="shortcut icon" href="/jsp/SH/img/favicon.ico">    

    <!--DatePicker css-->
    <link href="/jsp/SH/css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <!-- DateTimePicker -->
    <link href="/jsp/SH/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />

	<!--Morris Chart CSS -->
    <link href="/jsp/SH/css/morris.css" rel="stylesheet" />
    
    <!-- App css -->
    <link href="/jsp/SH/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/components.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/icons.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/core.css" rel="stylesheet" type="text/css" />

    
    <!-- jQuery Library -->
	<script src="/jsp/SH/js/jquery.min.js"></script>
	<script src="/jsp/SH/js/bootstrap.min.js"></script>
	
	<!-- Table Sort -->
	<script src="/jsp/SH/js/stupidtable.js"></script>
	
	<!--Morris Chart-->
	<script src="/jsp/SH/js/morris.min.js"></script>
	<script src="/jsp/SH/js/raphael-min.js"></script>
	
	<!-- App js -->
	<script src="/jsp/SH/js/jquery.app.js"></script>
	<script src="/jsp/SH/js/add_chart.js"></script>    	
	
<script type="text/javascript">
$(document).ready(function(){
	//탭 활성화
	$("#SH_SearchList_tab li").eq(0).addClass("active");
	$("#SH_SearchList div[id^=SH_SearchList_]").eq(0).removeClass("fade");
	$("#SH_SearchList div[id^=SH_SearchList_]").eq(0).addClass("active");
	save_searchList(1, $("#SH_SearchList div[id^=SH_SearchList_]").eq(0).prop("id").replace("SH_SearchList_", "") );
	
	//탭클릭시 리스트 갱신
	$("#SH_SearchList_tab li").on("click", function(){
    	var type = $(this).find("a").attr("href").replace("#SH_SearchList_", ""); 
    	save_searchList(1, type);
    });
	
	//그래프 숨기기
	$("#SH_ChartList").addClass("hide");
});

//차순정리 기능
$(function(){
    // Helper function to convert a string of the form "Mar 15, 1987" into a Date object.
    var date_from_string = function(str) {
      var months = ["jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"];
      var pattern = "^([a-zA-Z]{3})\\s*(\\d{1,2}),\\s*(\\d{4})$";
      var re = new RegExp(pattern);
      var DateParts = re.exec(str).slice(1);

      var Year = DateParts[2];
      var Month = $.inArray(DateParts[0].toLowerCase(), months);
      var Day = DateParts[1];

      return new Date(Year, Month, Day);
    }

    var table = $("#SH_SearchList table").stupidtable({
      "date": function(a,b) {
        // Get these into date objects for comparison.
        aDate = date_from_string(a);
        bDate = date_from_string(b);
        return aDate - bDate;
      }
    });

    table.on("beforetablesort", function (event, data) {
      // Apply a "disabled" look to the table while sorting.
      // Using addClass for "testing" as it takes slightly longer to render.
      $("#msg").text("Sorting...");
      $("table").addClass("disabled");
    });

    table.on("aftertablesort", function (event, data) {
      // Reset loading message.
      $("#msg").html("&nbsp;");
      $("table").removeClass("disabled");

      var th = $(this).find("th");
      th.find(".arrow").remove();
      var dir = $.fn.stupidtable.dir;

//       var arrow = data.direction === dir.ASC ? "&uarr;" : "&darr;";
      var arrow = data.direction === dir.ASC ? "&nbsp;▲" : "&nbsp;▼";
      th.eq(data.column).append('<span class="arrow">' + arrow +'</span>');
    });
});
   
          
//페이징처리
function drawPage(goTo, type, n, t, kind){   
	var pagesize = n;
	var totalCount = t; //전체 건수
    var totalPage = Math.ceil(totalCount/pagesize);//한 페이지에 나오는 행수
    var PageNum;
	var page = goTo;    
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

    $("#pageZone").empty();        
    var prevStep =	"<li>";
    	prevStep +=		"<a ";
    	if(Number(goTo) == 1){ prevStep += "href=\"#\""; }
    	else{ prevStep += "href=\"javascript:"+type+"("+goPrev+", '"+kind+"');\""; }
    	prevStep +=		"><i class=\"fa fa-angle-left\"></i></a>";
    	prevStep +=	"</li>";
	$("#pageZone").append(prevStep);
	for(var i=prev; i<=next;i++){
    	if(i == goTo){
    		PageNum =	"<li class=\"active\">";
    		PageNum +=		"<a href=\"#\">"+i+"</a>";
    		PageNum +=	"</li>";
    	}else{        		
    		PageNum =	"<li>";
    		PageNum +=		"<a href=\"javascript:"+type+"("+i+", '"+kind+"');\">"+i+"</a>";
    		PageNum +=	"</li>";
    	}
        $("#pageZone").append(PageNum);
    }   
	var nextStep =	"<li>";
		nextStep +=		"<a ";
		if(Number(goTo) == Number(totalPage)){ nextStep += "href=\"#\""; }
		else{ nextStep += "href=\"javascript:"+type+"("+goNext+", '"+kind+"');\""; }
		nextStep +=		"><i class=\"fa fa-angle-right\"></i></a>";
		nextStep +=	"</li>";
	$("#pageZone").append(nextStep);      
}    
	



//검색결과 show & save
function save_searchList(a, type){	
	var pagesize = Number( ${cnt_kind} );
	var pageindex = (a-1)*pagesize + 1;
	var pageindex_max = pagesize*a;
	var num = 0;	
		
	var totcnt = $("#SH_SearchList_"+type+" tbody tr[id!=nothing]").length;	
	$("#total_cnt").text( nCommas( totcnt ) ); 
	
	
	//이전리스트 비활성화
	$("#SH_SearchList_"+type+" tbody tr").each(function( index ) {
		if(index >= pageindex-1 && index <= pageindex_max-1){
			$(this).show();
			$(this).prop("disabled", false);
		}else{
			$(this).hide();
			$(this).prop("disabled", true);
		}
	});
	
	//페이징
	var a = (pageindex - 1)/pagesize + 1;
	if(totcnt <= 0){totcnt = 1;}
	drawPage(a, 'save_searchList', pagesize, totcnt, type);
}

//화폐 단위(3자리 쉼표)
function nCommas(x) {    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");}


//전체 검색결과 그리기
function GISSearchList_Draw(){
	var div_nm = "";	
	$("#SH_SearchList div").each(function(){
		var tab = $(this);
		if( tab.css("display") == 'block' ){
			div_nm = tab.prop("id");
		}		
	});		
			
	var geom = [];
	$("#SH_SearchList div[id='"+div_nm+"'] input[name='geom']").each(function( index ) {
		geom.push( $(this).val() );
	});
	$("input[name='geom[]']", opener.document).val( geom );
	opener.GISSearchList_Draw();
}

//상세보기
var DetailWindow =null;
function infodetailshow(pnu,sn){
	//창 닫기
	if(DetailWindow != null){ DetailWindow.close(); }
	
	var div_nm = "";
	$("#SH_SearchList div").each(function(){
		var tab = $(this);
		if( tab.css("display") == 'block' ){
			div_nm = tab.prop("id");
			div_nm = div_nm.replace("SH_SearchList_", "");
		}else{ }			
	});	
	
	//공간분석 항목
	var item_space = $("#item_space").serialize();	
	DetailWindow = window.open("/Content_SH_View_Detail.do?pnu="+pnu+'&sn='+sn+"&sh_kind="+div_nm+"&"+item_space
			,"searchDetail"
			,"toolbar=no, width=1100, height=750,directories=no,status=no,scrollorbars=yes,resizable=yes");
	
}
//상세보기 - 사업지구
function infodetailshow_sh(gid, dist_ck){	
	var div_nm = "";
	$("#SH_SearchList div").each(function(){
		var tab = $(this);
		if( tab.css("display") == 'block' ){
			div_nm = tab.prop("id");
			div_nm = div_nm.replace("SH_SearchList_", "");
		}		
	});	
	
	DetailWindow = window.open("/Content_SH_View_Detail_sh.do?gid="+gid+"&sh_kind="+div_nm+"&kind="+dist_ck
			,"searchDetail"
			,"toolbar=no, width=1100, height=750,directories=no,status=no,scrollorbars=yes,resizable=yes");
}

//그래프 보기
function GISSearchList_stat(){	
	$("#SH_SearchList").toggleClass("hide");
	$("#total_cnt").parent("span").toggleClass("hide");
	$("#SH_ChartList").toggleClass("hide");
	$("#SH_SearchList_tab").toggleClass("hide");
	$("#pageZone").toggleClass("hide");
}

function GISSearchList_downExcel(){
	var type = null;
	$("#SH_SearchList div[id^=SH_SearchList_]").each(function(){
		
		if( $(this).css("display") == 'block' ){
			type = $(this).prop("id").replace("SH_SearchList_", "");
		}
	});
	opener.GISSearchList_downExcel(type);
}



//ycb 검색결과 전체표출 추가 20180626
function GISSearchList_DrawAll(){
	var div_nm = "";	
	$("#SH_SearchList div").each(function(){
		var tab = $(this);
		if( tab.css("display") == 'block' ){
			div_nm = tab.prop("id");
		}		
	});		
			
	var geom = [];
	$("#SH_SearchList div[id='"+div_nm+"'] input[name='geometry']").each(function( index ) {
		var geometry = $(this).val();
		var json = {
		          'type': 'Feature',
		          'geometry': JSON.parse(geometry)
		          };
		
		geom.push(json);
	});
	var geojsonObject = { 'type': 'FeatureCollection',
	          'features': geom
    	};	        	  
	        	  
	opener.GISSearchList_DrawAll(geojsonObject);	
}
</script>	


	<title>SH | 토지자원관리시스템</title>
		
	

</head>
<body>	
	
	<div id="load">
	    <img src="/jsp/SH/img/ajax-loader.gif"><p>LOADING</p>
	</div>
		
		
	<!-- 자산검색 검색결과-Popup -->
    <div class="popover layer-pop new-pop" id="asset-search-list" style="width:100%; height:100%; top:auto; display:block;">
        <div class="popover-title tit">
            <span class="m-r-5">
                <b>검색결과</b>
            </span>
            <span class="small">(전체 <strong class="text-orange" id="total_cnt">0</strong> 건)</span>
        </div>
        <div class="popover-body">

            <div class="row btn-wrap-group">
                <div class="col-xs-12">
                    <div class="btn-wrap text-right">
<!--                     	<button type="button" class="btn btn-xs btn-gray" onclick="GISSearchList_stat()">그래프 보기</button> -->
                        <!-- <button type="button" class="btn btn-xs btn-info" onclick="GISSearchList_Draw()">검색결과 지도 표출</button> -->
                        <!-- //ycb 검색결과 전체표출 추가 20180626 -->
                        <button type="button" class="btn btn-xs btn-info" onclick="GISSearchList_DrawAll()">검색결과 지도 표출</button>
                        <button type="button" class="btn btn-xs btn-default" onclick="GISSearchList_downExcel()">엑셀 다운로드</button>
<!--                         <button type="button" class="btn btn-xs btn-default" onclick="opener.GISSearchList_downSHP()">SHP 다운로드</button> -->
                    </div>
                </div>
            </div>

			<!-- Tab-Buttons -->
            <ul class="nav nav-tabs" id="SH_SearchList_tab">
            	<c:if test="${!empty gb}">				<li><a data-toggle="tab" href="#SH_SearchList_gb">${gb}</a></li></c:if>
            	                                        
            	<c:if test="${!empty guk_land}">		<li><a data-toggle="tab" href="#SH_SearchList_guk_land">${guk_land}</a></li></c:if>
                <c:if test="${!empty tmseq_land}">		<li><a data-toggle="tab" href="#SH_SearchList_tmseq_land">${tmseq_land}</a></li></c:if>
                <c:if test="${!empty region_land}">		<li><a data-toggle="tab" href="#SH_SearchList_region_land">${region_land}</a></li></c:if>
                <c:if test="${!empty owned_city}">		<li><a data-toggle="tab" href="#SH_SearchList_owned_city">${owned_city}</a></li></c:if>
                <c:if test="${!empty owned_guyu}">		<li><a data-toggle="tab" href="#SH_SearchList_owned_guyu">${owned_guyu}</a></li></c:if>
                <c:if test="${!empty residual_land}">	<li><a data-toggle="tab" href="#SH_SearchList_residual_land">${residual_land}</a></li></c:if>
                <c:if test="${!empty unsold_land}">		<li><a data-toggle="tab" href="#SH_SearchList_unsold_land">${unsold_land}</a></li></c:if>
                <c:if test="${!empty invest}">			<li><a data-toggle="tab" href="#SH_SearchList_invest">${invest}</a></li></c:if>
                <c:if test="${!empty public_site}">		<li><a data-toggle="tab" href="#SH_SearchList_public_site">${public_site}</a></li></c:if>
                <c:if test="${!empty public_parking}">	<li><a data-toggle="tab" href="#SH_SearchList_public_parking">${public_parking}</a></li></c:if>
                <c:if test="${!empty generations}">		<li><a data-toggle="tab" href="#SH_SearchList_generations">${generations}</a></li></c:if>
                <c:if test="${!empty council_land}">	<li><a data-toggle="tab" href="#SH_SearchList_council_land">${council_land}</a></li></c:if>
                <c:if test="${!empty minuse}">			<li><a data-toggle="tab" href="#SH_SearchList_minuse">${minuse}</a></li></c:if>
                <c:if test="${!empty industry}">		<li><a data-toggle="tab" href="#SH_SearchList_industry">${industry}</a></li></c:if>
                <c:if test="${!empty priority}">		<li><a data-toggle="tab" href="#SH_SearchList_priority">${priority}</a></li></c:if>
                                                        
                <c:if test="${!empty guk_buld}">		<li><a data-toggle="tab" href="#SH_SearchList_guk_buld">${guk_buld}</a></li></c:if>
                <c:if test="${!empty tmseq_buld}">		<li><a data-toggle="tab" href="#SH_SearchList_tmseq_buld">${tmseq_buld}</a></li></c:if>
                <c:if test="${!empty region_buld}">		<li><a data-toggle="tab" href="#SH_SearchList_region_buld">${region_buld}</a></li></c:if>
                <c:if test="${!empty owned_region}">	<li><a data-toggle="tab" href="#SH_SearchList_owned_region">${owned_region}</a></li></c:if>
                <c:if test="${!empty owned_seoul}">		<li><a data-toggle="tab" href="#SH_SearchList_owned_seoul">${owned_seoul}</a></li></c:if>
                <c:if test="${!empty cynlst}">			<li><a data-toggle="tab" href="#SH_SearchList_cynlst">${cynlst}</a></li></c:if>
                <c:if test="${!empty public_buld_a}">	<li><a data-toggle="tab" href="#SH_SearchList_public_buld_a">${public_buld_a}</a></li></c:if>
                <c:if test="${!empty public_buld_b}">	<li><a data-toggle="tab" href="#SH_SearchList_public_buld_b">${public_buld_b}</a></li></c:if>
                <c:if test="${!empty public_buld_c}">	<li><a data-toggle="tab" href="#SH_SearchList_public_buld_c">${public_buld_c}</a></li></c:if>
                <c:if test="${!empty public_asbu}">		<li><a data-toggle="tab" href="#SH_SearchList_public_asbu">${public_asbu}</a></li></c:if>
                <c:if test="${!empty purchase}">		<li><a data-toggle="tab" href="#SH_SearchList_purchase">${purchase}</a></li></c:if>
                <c:if test="${!empty declining}">		<li><a data-toggle="tab" href="#SH_SearchList_declining">${declining}</a></li></c:if>
                                                        
                <c:if test="${!empty residual}">		<li><a data-toggle="tab" href="#SH_SearchList_residual">${residual}</a></li></c:if>
                <c:if test="${!empty unsold}">			<li><a data-toggle="tab" href="#SH_SearchList_unsold">${unsold}</a></li></c:if>
            </ul>
            <!-- End Tab-Buttons -->
            
            <div class="popover-content-wrap asset-srl">  
            
            	<!-- Tab-Contents -->  
                <div class="popover-content tab-content" id="SH_SearchList">
                	<!-- space --> 
                	<form id="item_space" name="item_space"  onsubmit="return false;" >
                		<c:if test="${!empty city_activation_02}">	
               				<c:forEach items="${city_activation_02}" var="sa"> <input type="hidden" name="city_activation_val" value="${sa}"/> </c:forEach>
                		</c:if>
                		<c:if test="${!empty city_activation_03}">
                			<c:forEach items="${city_activation_03}" var="sa"> <input type="hidden" name="city_activation" value="${sa}"/> </c:forEach>
                		</c:if>
                		<c:if test="${!empty house_envment_02}">	
               				<c:forEach items="${house_envment_02}" var="sa"> <input type="hidden" name="house_envment_val" value="${sa}"/> </c:forEach>
                		</c:if>
                		<c:if test="${!empty house_envment_03}">
                			<c:forEach items="${house_envment_03}" var="sa"> <input type="hidden" name="house_envment" value="${sa}"/> </c:forEach>
                		</c:if>
                		<c:if test="${!empty hope_land_02}">	
               				<c:forEach items="${hope_land_02}" var="sa"> <input type="hidden" name="hope_land_val" value="${sa}"/> </c:forEach>
                		</c:if>
                		<c:if test="${!empty hope_land_03}">
                			<c:forEach items="${hope_land_03}" var="sa"> <input type="hidden" name="hope_land" value="${sa}"/> </c:forEach>
                		</c:if>
                		<c:if test="${!empty release_area_02}">	
               				<c:forEach items="${release_area_02}" var="sa"> <input type="hidden" name="release_area_val" value="${sa}"/> </c:forEach>
                		</c:if>
                		<c:if test="${!empty release_area_03}">
                			<c:forEach items="${release_area_03}" var="sa"> <input type="hidden" name="release_area" value="${sa}"/> </c:forEach>
                		</c:if>
                		<c:if test="${!empty sub_p_decline_02}">	
               				<c:forEach items="${sub_p_decline_02}" var="sa"> <input type="hidden" name="sub_p_decline_val" value="${sa}"/> </c:forEach>
                		</c:if>
                		<c:if test="${!empty sub_p_decline_03}">
                			<c:forEach items="${sub_p_decline_03}" var="sa"> <input type="hidden" name="sub_p_decline" value="${sa}"/> </c:forEach>
                		</c:if>
                		<c:if test="${!empty public_transport_02}">	
               				<c:forEach items="${public_transport_02}" var="sa"> <input type="hidden" name="public_transport_val" value="${sa}"/> </c:forEach>
                		</c:if>
                		<c:if test="${!empty public_transport_03}">
                			<c:forEach items="${public_transport_03}" var="sa"> <input type="hidden" name="public_transport" value="${sa}"/> </c:forEach>
                		</c:if>
                	</form>                	
                	
                	<c:if test="${!empty gb}">
                		<div class="tab-pane fade" id="SH_SearchList_gb">                			
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>	                            	                           	
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>										
									<c:if test="${kind eq 'tab-01'}">
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
	                            		<th data-sort="string">지목</th>
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">개별공시지가(원)</th>					
										<th data-sort="string">용도지역</th>
										<th data-sort="string">토지이용상황</th>
										<th data-sort="string">지형고저</th>
										<th data-sort="string">지형형상</th>
										<th data-sort="string">도로접면</th>
										<th data-sort="string">소유구분</th>
	                            	</c:if>	
	                            	<c:if test="${kind eq 'tab-02'}">
	                            		<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
	                            		<th data-sort="string">건물명</th>
										<th data-sort="float">건축면적(㎡)</th>
										<th data-sort="float">연면적(㎡)</th>					
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">건폐율(%)</th>
										<th data-sort="float">용적률(%)</th>
										<th data-sort="string">건축년도</th>
	                            	</c:if>
	                            	<c:if test="${kind eq 'tab-03'}">
	                            		<th data-sort="string" width="40px;">판매구분</th>
										<th data-sort="string" width="60px;">지구</th>
										<th data-sort="string">용도지역</th>					
										<th data-sort="string">단지구분</th>
										<th data-sort="string" width="200px;">용도</th>
										<th data-sort="string">세부용도</th>
										<th data-sort="string">필지번호</th>
										<th data-sort="float">고시면적</th>
										<th data-sort="float">건폐율</th>
										<th data-sort="float">용적률</th>
										<th data-sort="string">높이제한</th>
										<th data-sort="string">지정용도</th>
										<th data-sort="string">판매방법</th>
										<th data-sort="string">판매여부</th>
	                            	</c:if> 
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty gbList}">
                            		<c:forEach var="result" items="${gbList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
	                            		</td>	                            		
	                            	<c:if test="${kind eq 'tab-01'}">
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.jimok}">		<c:out value="${result.jimok}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.parea}">		<fmt:formatNumber value="${result.parea}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.pnilp}">		<fmt:formatNumber value="${result.pnilp}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.spfc1}">		<c:out value="${result.spfc1}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.land_use}">		<c:out value="${fn:substring(result.land_use,0,10)}"/><c:if test="${fn:length(result.land_use) gt 9}">..</c:if></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_hl}">		<c:out value="${result.geo_hl}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_form}">		<c:out value="${result.geo_form}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.road_side}">	<c:out value="${result.road_side}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.prtown}">		<c:out value="${result.prtown}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            	</c:if>
	                            	<c:if test="${kind eq 'tab-02'}">
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.buld_nm}">		<c:out value="${result.buld_nm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bildng_ar}">	<fmt:formatNumber value="${result.bildng_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.totar}">		<fmt:formatNumber value="${result.totar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.plot_ar}">		<fmt:formatNumber value="${result.plot_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bdtldr}">		<fmt:formatNumber value="${result.bdtldr}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.cpcty_rt}">		<fmt:formatNumber value="${result.cpcty_rt}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.use_confm}">	<c:out value="${result.use_confm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            	</c:if>
	                            	<c:if test="${kind eq 'tab-03'}">
	                            		<td><c:choose><c:when test="${!empty result.a2}">		<c:out value="${result.a2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a3}">		<c:out value="${result.a3}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a4}">		<c:out value="${result.a4}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a5}">		<c:out value="${result.a5}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a6}">		<c:out value="${result.a6}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a7}">		<c:out value="${result.a7}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a8}">		<c:out value="${result.a8}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a11}">		<c:out value="${result.a11}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a13}">		<c:out value="${result.a13}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a12}">		<c:out value="${result.a12}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a14}">		<c:out value="${result.a14}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a15}">		<c:out value="${result.a15}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a19}">		<c:out value="${result.a19}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a20}">		<c:out value="${result.a20}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow_sh('<c:out value="${result.gid}"/>', '<c:out value="${dist_kind}"/>');"><i class="fa fa-search"></i></button></td>
	                            	</c:if>	     
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<c:if test="${kind eq 'tab-01'}">
                            			<tr id="nothing"><td colspan="14">검색결과 없습니다.</td></tr>
                            		</c:if>
                            		<c:if test="${kind eq 'tab-02'}">
                            			<tr id="nothing"><td colspan="12">검색결과 없습니다.</td></tr>
                            		</c:if>
                            		<c:if test="${kind eq 'tab-03'}">
                            			<tr id="nothing"><td colspan="17">검색결과 없습니다.</td></tr>
                            		</c:if>                            		
                            	</c:otherwise>
	                            </c:choose>	                            	
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
            	
	            	<c:if test="${!empty guk_land}">
						<div class="tab-pane fade" id="SH_SearchList_guk_land">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">지목</th>
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">개별공시지가(원)</th>					
										<th data-sort="string">용도지역</th>
										<th data-sort="string">토지이용상황</th>
										<th data-sort="string">지형고저</th>
										<th data-sort="string">지형형상</th>
										<th data-sort="string">도로접면</th>
										<th data-sort="string">소유구분</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty guk_landList}">
                            		<c:forEach var="result" items="${guk_landList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.jimok}">		<c:out value="${result.jimok}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.parea}">		<fmt:formatNumber value="${result.parea}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.pnilp}">		<fmt:formatNumber value="${result.pnilp}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.spfc1}">		<c:out value="${result.spfc1}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.land_use}">		<c:out value="${fn:substring(result.land_use,0,10)}"/><c:if test="${fn:length(result.land_use) gt 9}">..</c:if></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_hl}">		<c:out value="${result.geo_hl}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_form}">		<c:out value="${result.geo_form}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.road_side}">	<c:out value="${result.road_side}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.prtown}">		<c:out value="${result.prtown}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="14">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
                            	</c:choose>	                            	
	                            </tbody>
	                        </table>
	                    </div>
					</c:if>
	                <c:if test="${!empty tmseq_land}">
                		<div class="tab-pane fade" id="SH_SearchList_tmseq_land">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">지목</th>
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">개별공시지가(원)</th>					
										<th data-sort="string">용도지역</th>
										<th data-sort="string">토지이용상황</th>
										<th data-sort="string">지형고저</th>
										<th data-sort="string">지형형상</th>
										<th data-sort="string">도로접면</th>
										<th data-sort="string">소유구분</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty tmseq_landList}">
                            		<c:forEach var="result" items="${tmseq_landList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.jimok}">		<c:out value="${result.jimok}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.parea}">		<fmt:formatNumber value="${result.parea}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.pnilp}">		<fmt:formatNumber value="${result.pnilp}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.spfc1}">		<c:out value="${result.spfc1}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.land_use}">		<c:out value="${fn:substring(result.land_use,0,10)}"/><c:if test="${fn:length(result.land_use) gt 9}">..</c:if></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_hl}">		<c:out value="${result.geo_hl}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_form}">		<c:out value="${result.geo_form}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.road_side}">	<c:out value="${result.road_side}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.prtown}">		<c:out value="${result.prtown}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="14">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
                            	</c:choose>
	                            </tbody>
	                        </table>
	                    </div>
					</c:if>
	                <c:if test="${!empty region_land}">
	                	<div class="tab-pane fade" id="SH_SearchList_region_land">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">지목</th>
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">개별공시지가(원)</th>					
										<th data-sort="string">용도지역</th>
										<th data-sort="string">토지이용상황</th>
										<th data-sort="string">지형고저</th>
										<th data-sort="string">지형형상</th>
										<th data-sort="string">도로접면</th>
										<th data-sort="string">소유구분</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty region_landList}">
									<c:forEach var="result" items="${region_landList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.jimok}">		<c:out value="${result.jimok}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.parea}">		<fmt:formatNumber value="${result.parea}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.pnilp}">		<fmt:formatNumber value="${result.pnilp}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.spfc1}">		<c:out value="${result.spfc1}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.land_use}">		<c:out value="${fn:substring(result.land_use,0,10)}"/><c:if test="${fn:length(result.land_use) gt 9}">..</c:if></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_hl}">		<c:out value="${result.geo_hl}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_form}">		<c:out value="${result.geo_form}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.road_side}">	<c:out value="${result.road_side}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.prtown}">		<c:out value="${result.prtown}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="14">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty owned_city}">
	                	<div class="tab-pane fade" id="SH_SearchList_owned_city">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">지목</th>
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">개별공시지가(원)</th>					
										<th data-sort="string">용도지역</th>
										<th data-sort="string">토지이용상황</th>
										<th data-sort="string">지형고저</th>
										<th data-sort="string">지형형상</th>
										<th data-sort="string">도로접면</th>
										<th data-sort="string">소유구분</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty owned_cityList}">
									<c:forEach var="result" items="${owned_cityList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.jimok}">		<c:out value="${result.jimok}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.parea}">		<fmt:formatNumber value="${result.parea}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.pnilp}">		<fmt:formatNumber value="${result.pnilp}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.spfc1}">		<c:out value="${result.spfc1}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.land_use}">		<c:out value="${fn:substring(result.land_use,0,10)}"/><c:if test="${fn:length(result.land_use) gt 9}">..</c:if></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_hl}">		<c:out value="${result.geo_hl}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_form}">		<c:out value="${result.geo_form}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.road_side}">	<c:out value="${result.road_side}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.prtown}">		<c:out value="${result.prtown}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="14">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty owned_guyu}">
	                	<div class="tab-pane fade" id="SH_SearchList_owned_guyu">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">지목</th>
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">개별공시지가(원)</th>					
										<th data-sort="string">용도지역</th>
										<th data-sort="string">토지이용상황</th>
										<th data-sort="string">지형고저</th>
										<th data-sort="string">지형형상</th>
										<th data-sort="string">도로접면</th>
										<th data-sort="string">소유구분</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty owned_guyuList}">
									<c:forEach var="result" items="${owned_guyuList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.jimok}">		<c:out value="${result.jimok}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.parea}">		<fmt:formatNumber value="${result.parea}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.pnilp}">		<fmt:formatNumber value="${result.pnilp}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.spfc1}">		<c:out value="${result.spfc1}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.land_use}">		<c:out value="${fn:substring(result.land_use,0,10)}"/><c:if test="${fn:length(result.land_use) gt 9}">..</c:if></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_hl}">		<c:out value="${result.geo_hl}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_form}">		<c:out value="${result.geo_form}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.road_side}">	<c:out value="${result.road_side}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.prtown}">		<c:out value="${result.prtown}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="14">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty residual_land}">
	                	<div class="tab-pane fade" id="SH_SearchList_residual_land">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">지목</th>
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">개별공시지가(원)</th>					
										<th data-sort="string">용도지역</th>
										<th data-sort="string">토지이용상황</th>
										<th data-sort="string">지형고저</th>
										<th data-sort="string">지형형상</th>
										<th data-sort="string">도로접면</th>
										<th data-sort="string">소유구분</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty residual_landList}">
									<c:forEach var="result" items="${residual_landList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.jimok}">		<c:out value="${result.jimok}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.parea}">		<fmt:formatNumber value="${result.parea}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.pnilp}">		<fmt:formatNumber value="${result.pnilp}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.spfc1}">		<c:out value="${result.spfc1}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.land_use}">		<c:out value="${fn:substring(result.land_use,0,10)}"/><c:if test="${fn:length(result.land_use) gt 9}">..</c:if></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_hl}">		<c:out value="${result.geo_hl}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_form}">		<c:out value="${result.geo_form}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.road_side}">	<c:out value="${result.road_side}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.prtown}">		<c:out value="${result.prtown}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="14">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>	                            	
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty unsold_land}">
	                	<div class="tab-pane fade" id="SH_SearchList_unsold_land">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">지목</th>
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">개별공시지가(원)</th>					
										<th data-sort="string">용도지역</th>
										<th data-sort="string">토지이용상황</th>
										<th data-sort="string">지형고저</th>
										<th data-sort="string">지형형상</th>
										<th data-sort="string">도로접면</th>
										<th data-sort="string">소유구분</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty unsold_landList}">
									<c:forEach var="result" items="${unsold_landList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
	                            			<input type="hidden" id="sn" name="sn" value="${result.sn}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.jimok}">		<c:out value="${result.jimok}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.parea}">		<fmt:formatNumber value="${result.parea}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.pnilp}">		<fmt:formatNumber value="${result.pnilp}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.spfc1}">		<c:out value="${result.spfc1}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.land_use}">		<c:out value="${fn:substring(result.land_use,0,10)}"/><c:if test="${fn:length(result.land_use) gt 9}">..</c:if></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_hl}">		<c:out value="${result.geo_hl}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_form}">		<c:out value="${result.geo_form}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.road_side}">	<c:out value="${result.road_side}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.prtown}">		<c:out value="${result.prtown}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>','<c:out value="${result.sn}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.tt_geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="14">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty invest}">
	                	<div class="tab-pane fade" id="SH_SearchList_invest">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">지목</th>
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">개별공시지가(원)</th>					
										<th data-sort="string">용도지역</th>
										<th data-sort="string">토지이용상황</th>
										<th data-sort="string">지형고저</th>
										<th data-sort="string">지형형상</th>
										<th data-sort="string">도로접면</th>
										<th data-sort="string">소유구분</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty investList}">
									<c:forEach var="result" items="${investList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.jimok}">		<c:out value="${result.jimok}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.parea}">		<fmt:formatNumber value="${result.parea}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.pnilp}">		<fmt:formatNumber value="${result.pnilp}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.spfc1}">		<c:out value="${result.spfc1}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.land_use}">		<c:out value="${fn:substring(result.land_use,0,10)}"/><c:if test="${fn:length(result.land_use) gt 9}">..</c:if></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_hl}">		<c:out value="${result.geo_hl}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_form}">		<c:out value="${result.geo_form}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.road_side}">	<c:out value="${result.road_side}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.prtown}">		<c:out value="${result.prtown}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="14">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty public_site}">
	                	<div class="tab-pane fade" id="SH_SearchList_public_site">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">지목</th>
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">개별공시지가(원)</th>					
										<th data-sort="string">용도지역</th>
										<th data-sort="string">토지이용상황</th>
										<th data-sort="string">지형고저</th>
										<th data-sort="string">지형형상</th>
										<th data-sort="string">도로접면</th>
										<th data-sort="string">소유구분</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty public_siteList}">
									<c:forEach var="result" items="${public_siteList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.jimok}">		<c:out value="${result.jimok}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.parea}">		<fmt:formatNumber value="${result.parea}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.pnilp}">		<fmt:formatNumber value="${result.pnilp}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.spfc1}">		<c:out value="${result.spfc1}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.land_use}">		<c:out value="${fn:substring(result.land_use,0,10)}"/><c:if test="${fn:length(result.land_use) gt 9}">..</c:if></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_hl}">		<c:out value="${result.geo_hl}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_form}">		<c:out value="${result.geo_form}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.road_side}">	<c:out value="${result.road_side}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.prtown}">		<c:out value="${result.prtown}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="14">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty public_parking}">
	                	<div class="tab-pane fade" id="SH_SearchList_public_parking">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">지목</th>
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">개별공시지가(원)</th>					
										<th data-sort="string">용도지역</th>
										<th data-sort="string">토지이용상황</th>
										<th data-sort="string">지형고저</th>
										<th data-sort="string">지형형상</th>
										<th data-sort="string">도로접면</th>
										<th data-sort="string">소유구분</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty public_parkingList}">
									<c:forEach var="result" items="${public_parkingList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.jimok}">		<c:out value="${result.jimok}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.parea}">		<fmt:formatNumber value="${result.parea}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.pnilp}">		<fmt:formatNumber value="${result.pnilp}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.spfc1}">		<c:out value="${result.spfc1}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.land_use}">		<c:out value="${fn:substring(result.land_use,0,10)}"/><c:if test="${fn:length(result.land_use) gt 9}">..</c:if></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_hl}">		<c:out value="${result.geo_hl}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_form}">		<c:out value="${result.geo_form}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.road_side}">	<c:out value="${result.road_side}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.prtown}">		<c:out value="${result.prtown}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="14">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty generations}">
	                	<div class="tab-pane fade" id="SH_SearchList_generations">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">지목</th>
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">개별공시지가(원)</th>					
										<th data-sort="string">용도지역</th>
										<th data-sort="string">토지이용상황</th>
										<th data-sort="string">지형고저</th>
										<th data-sort="string">지형형상</th>
										<th data-sort="string">도로접면</th>
										<th data-sort="string">소유구분</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty generationsList}">
									<c:forEach var="result" items="${generationsList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.jimok}">		<c:out value="${result.jimok}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.parea}">		<fmt:formatNumber value="${result.parea}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.pnilp}">		<fmt:formatNumber value="${result.pnilp}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.spfc1}">		<c:out value="${result.spfc1}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.land_use}">		<c:out value="${fn:substring(result.land_use,0,10)}"/><c:if test="${fn:length(result.land_use) gt 9}">..</c:if></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_hl}">		<c:out value="${result.geo_hl}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_form}">		<c:out value="${result.geo_form}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.road_side}">	<c:out value="${result.road_side}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.prtown}">		<c:out value="${result.prtown}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="14">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty council_land}">
	                	<div class="tab-pane fade" id="SH_SearchList_council_land">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">지목</th>
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">개별공시지가(원)</th>					
										<th data-sort="string">용도지역</th>
										<th data-sort="string">토지이용상황</th>
										<th data-sort="string">지형고저</th>
										<th data-sort="string">지형형상</th>
										<th data-sort="string">도로접면</th>
										<th data-sort="string">소유구분</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty council_landList}">
									<c:forEach var="result" items="${council_landList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.jimok}">		<c:out value="${result.jimok}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.parea}">		<fmt:formatNumber value="${result.parea}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.pnilp}">		<fmt:formatNumber value="${result.pnilp}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.spfc1}">		<c:out value="${result.spfc1}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.land_use}">		<c:out value="${fn:substring(result.land_use,0,10)}"/><c:if test="${fn:length(result.land_use) gt 9}">..</c:if></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_hl}">		<c:out value="${result.geo_hl}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_form}">		<c:out value="${result.geo_form}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.road_side}">	<c:out value="${result.road_side}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.prtown}">		<c:out value="${result.prtown}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="14">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty minuse}">
	                	<div class="tab-pane fade" id="SH_SearchList_minuse">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">지목</th>
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">개별공시지가(원)</th>					
										<th data-sort="string">용도지역</th>
										<th data-sort="string">토지이용상황</th>
										<th data-sort="string">지형고저</th>
										<th data-sort="string">지형형상</th>
										<th data-sort="string">도로접면</th>
										<th data-sort="string">소유구분</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty minuseList}">
									<c:forEach var="result" items="${minuseList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.jimok}">		<c:out value="${result.jimok}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.parea}">		<fmt:formatNumber value="${result.parea}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.pnilp}">		<fmt:formatNumber value="${result.pnilp}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.spfc1}">		<c:out value="${result.spfc1}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.land_use}">		<c:out value="${fn:substring(result.land_use,0,10)}"/><c:if test="${fn:length(result.land_use) gt 9}">..</c:if></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_hl}">		<c:out value="${result.geo_hl}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_form}">		<c:out value="${result.geo_form}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.road_side}">	<c:out value="${result.road_side}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.prtown}">		<c:out value="${result.prtown}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="14">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>	                            	
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty industry}">
	                	<div class="tab-pane fade" id="SH_SearchList_industry">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">지목</th>
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">개별공시지가(원)</th>					
										<th data-sort="string">용도지역</th>
										<th data-sort="string">토지이용상황</th>
										<th data-sort="string">지형고저</th>
										<th data-sort="string">지형형상</th>
										<th data-sort="string">도로접면</th>
										<th data-sort="string">소유구분</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty industryList}">
									<c:forEach var="result" items="${industryList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.jimok}">		<c:out value="${result.jimok}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.parea}">		<fmt:formatNumber value="${result.parea}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.pnilp}">		<fmt:formatNumber value="${result.pnilp}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.spfc1}">		<c:out value="${result.spfc1}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.land_use}">		<c:out value="${fn:substring(result.land_use,0,10)}"/><c:if test="${fn:length(result.land_use) gt 9}">..</c:if></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_hl}">		<c:out value="${result.geo_hl}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_form}">		<c:out value="${result.geo_form}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.road_side}">	<c:out value="${result.road_side}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.prtown}">		<c:out value="${result.prtown}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="14">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>	                            	
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty priority}">
	                	<div class="tab-pane fade" id="SH_SearchList_priority">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">지목</th>
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">개별공시지가(원)</th>					
										<th data-sort="string">용도지역</th>
										<th data-sort="string">토지이용상황</th>
										<th data-sort="string">지형고저</th>
										<th data-sort="string">지형형상</th>
										<th data-sort="string">도로접면</th>
										<th data-sort="string">소유구분</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty priorityList}">
									<c:forEach var="result" items="${priorityList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.jimok}">		<c:out value="${result.jimok}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.parea}">		<fmt:formatNumber value="${result.parea}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.pnilp}">		<fmt:formatNumber value="${result.pnilp}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.spfc1}">		<c:out value="${result.spfc1}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.land_use}">		<c:out value="${fn:substring(result.land_use,0,10)}"/><c:if test="${fn:length(result.land_use) gt 9}">..</c:if></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_hl}">		<c:out value="${result.geo_hl}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.geo_form}">		<c:out value="${result.geo_form}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.road_side}">	<c:out value="${result.road_side}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.prtown}">		<c:out value="${result.prtown}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="14">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>	                            	
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                
	                <c:if test="${!empty guk_buld}">
	                	<div class="tab-pane fade" id="SH_SearchList_guk_buld">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">건물명</th>
										<th data-sort="float">건축면적(㎡)</th>
										<th data-sort="float">연면적(㎡)</th>					
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">건폐율(%)</th>
										<th data-sort="float">용적률(%)</th>
										<th data-sort="string">건축년도</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty guk_buldList}">
									<c:forEach var="result" items="${guk_buldList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.buld_nm}">		<c:out value="${result.buld_nm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bildng_ar}">	<fmt:formatNumber value="${result.bildng_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.totar}">		<fmt:formatNumber value="${result.totar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.plot_ar}">		<fmt:formatNumber value="${result.plot_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bdtldr}">		<fmt:formatNumber value="${result.bdtldr}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.cpcty_rt}">		<fmt:formatNumber value="${result.cpcty_rt}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.use_confm}">	<c:out value="${result.use_confm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="12">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>	                            	
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty tmseq_buld}">
	                	<div class="tab-pane fade" id="SH_SearchList_tmseq_buld">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">건물명</th>
										<th data-sort="float">건축면적(㎡)</th>
										<th data-sort="float">연면적(㎡)</th>					
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">건폐율(%)</th>
										<th data-sort="float">용적률(%)</th>
										<th data-sort="string">건축년도</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty tmseq_buldList}">
									<c:forEach var="result" items="${tmseq_buldList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.buld_nm}">		<c:out value="${result.buld_nm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bildng_ar}">	<fmt:formatNumber value="${result.bildng_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.totar}">		<fmt:formatNumber value="${result.totar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.plot_ar}">		<fmt:formatNumber value="${result.plot_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bdtldr}">		<fmt:formatNumber value="${result.bdtldr}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.cpcty_rt}">		<fmt:formatNumber value="${result.cpcty_rt}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.use_confm}">	<c:out value="${result.use_confm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="12">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>	                            	
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty region_buld}">
	                	<div class="tab-pane fade" id="SH_SearchList_region_buld">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">건물명</th>
										<th data-sort="float">건축면적(㎡)</th>
										<th data-sort="float">연면적(㎡)</th>					
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">건폐율(%)</th>
										<th data-sort="float">용적률(%)</th>
										<th data-sort="string">건축년도</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty region_buldList}">
									<c:forEach var="result" items="${region_buldList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.buld_nm}">		<c:out value="${result.buld_nm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bildng_ar}">	<fmt:formatNumber value="${result.bildng_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.totar}">		<fmt:formatNumber value="${result.totar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.plot_ar}">		<fmt:formatNumber value="${result.plot_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bdtldr}">		<fmt:formatNumber value="${result.bdtldr}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.cpcty_rt}">		<fmt:formatNumber value="${result.cpcty_rt}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.use_confm}">	<c:out value="${result.use_confm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="12">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>	                            	
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty owned_region}">
	                	<div class="tab-pane fade" id="SH_SearchList_owned_region">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">건물명</th>
										<th data-sort="float">건축면적(㎡)</th>
										<th data-sort="float">연면적(㎡)</th>					
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">건폐율(%)</th>
										<th data-sort="float">용적률(%)</th>
										<th data-sort="string">건축년도</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty owned_regionList}">
									<c:forEach var="result" items="${owned_regionList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.buld_nm}">		<c:out value="${result.buld_nm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bildng_ar}">	<fmt:formatNumber value="${result.bildng_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.totar}">		<fmt:formatNumber value="${result.totar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.plot_ar}">		<fmt:formatNumber value="${result.plot_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bdtldr}">		<fmt:formatNumber value="${result.bdtldr}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.cpcty_rt}">		<fmt:formatNumber value="${result.cpcty_rt}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.use_confm}">	<c:out value="${result.use_confm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="12">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>	                            	
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty owned_seoul}">
	                	<div class="tab-pane fade" id="SH_SearchList_owned_seoul">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">건물명</th>
										<th data-sort="float">건축면적(㎡)</th>
										<th data-sort="float">연면적(㎡)</th>					
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">건폐율(%)</th>
										<th data-sort="float">용적률(%)</th>
										<th data-sort="string">건축년도</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty owned_seoulList}">
									<c:forEach var="result" items="${owned_seoulList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.buld_nm}">		<c:out value="${result.buld_nm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bildng_ar}">	<fmt:formatNumber value="${result.bildng_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.totar}">		<fmt:formatNumber value="${result.totar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.plot_ar}">		<fmt:formatNumber value="${result.plot_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bdtldr}">		<fmt:formatNumber value="${result.bdtldr}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.cpcty_rt}">		<fmt:formatNumber value="${result.cpcty_rt}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.use_confm}">	<c:out value="${result.use_confm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="12">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>	                            	
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty cynlst}">
	                	<div class="tab-pane fade" id="SH_SearchList_cynlst">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">건물명</th>
										<th data-sort="float">건축면적(㎡)</th>
										<th data-sort="float">연면적(㎡)</th>					
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">건폐율(%)</th>
										<th data-sort="float">용적률(%)</th>
										<th data-sort="string">건축년도</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty cynlstList}">
									<c:forEach var="result" items="${cynlstList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.buld_nm}">		<c:out value="${result.buld_nm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bildng_ar}">	<fmt:formatNumber value="${result.bildng_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.totar}">		<fmt:formatNumber value="${result.totar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.plot_ar}">		<fmt:formatNumber value="${result.plot_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bdtldr}">		<fmt:formatNumber value="${result.bdtldr}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.cpcty_rt}">		<fmt:formatNumber value="${result.cpcty_rt}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.use_confm}">	<c:out value="${result.use_confm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="12">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>	                            	
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty public_buld_a}">
	                	<div class="tab-pane fade" id="SH_SearchList_public_buld_a">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">건물명</th>
										<th data-sort="float">건축면적(㎡)</th>
										<th data-sort="float">연면적(㎡)</th>					
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">건폐율(%)</th>
										<th data-sort="float">용적률(%)</th>
										<th data-sort="string">건축년도</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty public_buld_aList}">
									<c:forEach var="result" items="${public_buld_aList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.buld_nm}">		<c:out value="${result.buld_nm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bildng_ar}">	<fmt:formatNumber value="${result.bildng_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.totar}">		<fmt:formatNumber value="${result.totar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.plot_ar}">		<fmt:formatNumber value="${result.plot_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bdtldr}">		<fmt:formatNumber value="${result.bdtldr}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.cpcty_rt}">		<fmt:formatNumber value="${result.cpcty_rt}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.use_confm}">	<c:out value="${result.use_confm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="12">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>	                            	
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty public_buld_b}">
	                	<div class="tab-pane fade" id="SH_SearchList_public_buld_b">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">건물명</th>
										<th data-sort="float">건축면적(㎡)</th>
										<th data-sort="float">연면적(㎡)</th>					
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">건폐율(%)</th>
										<th data-sort="float">용적률(%)</th>
										<th data-sort="string">건축년도</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty public_buld_bList}">
									<c:forEach var="result" items="${public_buld_bList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.buld_nm}">		<c:out value="${result.buld_nm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bildng_ar}">	<fmt:formatNumber value="${result.bildng_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.totar}">		<fmt:formatNumber value="${result.totar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.plot_ar}">		<fmt:formatNumber value="${result.plot_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bdtldr}">		<fmt:formatNumber value="${result.bdtldr}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.cpcty_rt}">		<fmt:formatNumber value="${result.cpcty_rt}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.use_confm}">	<c:out value="${result.use_confm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="12">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>	                            	
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty public_buld_c}">
	                	<div class="tab-pane fade" id="SH_SearchList_public_buld_c">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">건물명</th>
										<th data-sort="float">건축면적(㎡)</th>
										<th data-sort="float">연면적(㎡)</th>					
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">건폐율(%)</th>
										<th data-sort="float">용적률(%)</th>
										<th data-sort="string">건축년도</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty public_buld_cList}">
									<c:forEach var="result" items="${public_buld_cList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.buld_nm}">		<c:out value="${result.buld_nm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bildng_ar}">	<fmt:formatNumber value="${result.bildng_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.totar}">		<fmt:formatNumber value="${result.totar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.plot_ar}">		<fmt:formatNumber value="${result.plot_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bdtldr}">		<fmt:formatNumber value="${result.bdtldr}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.cpcty_rt}">		<fmt:formatNumber value="${result.cpcty_rt}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.use_confm}">	<c:out value="${result.use_confm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="12">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>	                            	
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty public_asbu}">
	                	<div class="tab-pane fade" id="SH_SearchList_public_asbu">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">건물명</th>
										<th data-sort="float">건축면적(㎡)</th>
										<th data-sort="float">연면적(㎡)</th>					
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">건폐율(%)</th>
										<th data-sort="float">용적률(%)</th>
										<th data-sort="string">건축년도</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty public_asbuList}">
									<c:forEach var="result" items="${public_asbuList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.buld_nm}">		<c:out value="${result.buld_nm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bildng_ar}">	<fmt:formatNumber value="${result.bildng_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.totar}">		<fmt:formatNumber value="${result.totar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.plot_ar}">		<fmt:formatNumber value="${result.plot_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bdtldr}">		<fmt:formatNumber value="${result.bdtldr}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.cpcty_rt}">		<fmt:formatNumber value="${result.cpcty_rt}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.use_confm}">	<c:out value="${result.use_confm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="12">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>	                            	
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty purchase}">
	                	<div class="tab-pane fade" id="SH_SearchList_purchase">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">건물명</th>
										<th data-sort="float">건축면적(㎡)</th>
										<th data-sort="float">연면적(㎡)</th>					
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">건폐율(%)</th>
										<th data-sort="float">용적률(%)</th>
										<th data-sort="string">건축년도</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty purchaseList}">
									<c:forEach var="result" items="${purchaseList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.buld_nm}">		<c:out value="${result.buld_nm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bildng_ar}">	<fmt:formatNumber value="${result.bildng_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.totar}">		<fmt:formatNumber value="${result.totar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.plot_ar}">		<fmt:formatNumber value="${result.plot_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bdtldr}">		<fmt:formatNumber value="${result.bdtldr}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.cpcty_rt}">		<fmt:formatNumber value="${result.cpcty_rt}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.use_confm}">	<c:out value="${result.use_confm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="12">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>	                            	
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty declining}">
	                	<div class="tab-pane fade" id="SH_SearchList_declining">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string" width="200px;">소재지</th>
										<th data-sort="string" width="70px;">자산구분</th>
										<th data-sort="string">건물명</th>
										<th data-sort="float">건축면적(㎡)</th>
										<th data-sort="float">연면적(㎡)</th>					
										<th data-sort="float">대지면적(㎡)</th>
										<th data-sort="float">건폐율(%)</th>
										<th data-sort="float">용적률(%)</th>
										<th data-sort="string">건축년도</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty decliningList}">
									<c:forEach var="result" items="${decliningList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.addr1}">		<c:out value="${result.addr1}"/>&nbsp;<c:out value="${result.addr2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.gb}">			<c:out value="${result.gb}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.buld_nm}">		<c:out value="${result.buld_nm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bildng_ar}">	<fmt:formatNumber value="${result.bildng_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.totar}">		<fmt:formatNumber value="${result.totar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.plot_ar}">		<fmt:formatNumber value="${result.plot_ar}" groupingUsed="true"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.bdtldr}">		<fmt:formatNumber value="${result.bdtldr}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td align="right"><c:choose><c:when test="${!empty result.cpcty_rt}">		<fmt:formatNumber value="${result.cpcty_rt}" pattern="#,###.##"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.use_confm}">	<c:out value="${result.use_confm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.pnu}"/>');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="12">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>	                            	
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                                                        
	                <c:if test="${!empty residual}">
	                	<div class="tab-pane fade" id="SH_SearchList_residual">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string">판매구분</th>
										<th data-sort="string">지구</th>
										<th data-sort="string">용도지역</th>					
										<th data-sort="string">단지구분</th>
										<th data-sort="string" width="200px;">용도</th>
										<th data-sort="string">세부용도</th>
										<th data-sort="string">필지번호</th>
										<th data-sort="float">고시면적</th>
										<th data-sort="float">건폐율</th>
										<th data-sort="float">용적률</th>
										<th data-sort="string">높이제한</th>
										<th data-sort="string">지정용도</th>
										<th data-sort="string">판매방법</th>
										<th data-sort="string">판매여부</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty residualList}">
									<c:forEach var="result" items="${residualList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.a2}">		<c:out value="${result.a2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a3}">		<c:out value="${result.a3}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a4}">		<c:out value="${result.a4}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a5}">		<c:out value="${result.a5}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a6}">		<c:out value="${result.a6}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a7}">		<c:out value="${result.a7}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a8}">		<c:out value="${result.a8}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a11}">		<c:out value="${result.a11}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a13}">		<c:out value="${result.a13}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a12}">		<c:out value="${result.a12}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a14}">		<c:out value="${result.a14}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a15}">		<c:out value="${result.a15}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a19}">		<c:out value="${result.a19}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a20}">		<c:out value="${result.a20}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow_sh('<c:out value="${result.gid}"/>', '11');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="17">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>	                            	
	                            </tbody>
	                        </table>
	                    </div>
	                </c:if>
	                <c:if test="${!empty unsold}">
	                	<div class="tab-pane fade" id="SH_SearchList_unsold">
	                        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	                            <thead>
	                            	<tr>
										<th data-sort="int" width="40px;">번호</th>
										<th data-sort="string">판매구분</th>
										<th data-sort="string">지구</th>
										<th data-sort="string">용도지역</th>					
										<th data-sort="string">단지구분</th>
										<th data-sort="string" width="200px;">용도</th>
										<th data-sort="string">세부용도</th>
										<th data-sort="string">필지번호</th>
										<th data-sort="float">고시면적</th>
										<th data-sort="float">건폐율</th>
										<th data-sort="float">용적률</th>
										<th data-sort="string">높이제한</th>
										<th data-sort="string">지정용도</th>
										<th data-sort="string">판매방법</th>
										<th data-sort="string">판매여부</th>
										<th width="60px;">정보확인</th>
										<th width="60px;">화면이동</th>
									</tr>
	                            </thead>
	                            <tbody>
	                            <c:choose>
                            	<c:when test="${!empty unsoldList}">
									<c:forEach var="result" items="${unsoldList}" varStatus="status">
	                            	<tr>
	                            		<td>
	                            			<c:out value="${status.count}"/>
		                            		<input type="hidden" id="geom" name="geom" value="${result.geom}"/>
		                            		<!-- 유창범 검색결과 전체표출 추가 20180626 -->
		                            		<input type="hidden" id="geometry" name="geometry" value='${result.geometry}'/>
		                            	</td>
	                            		<td><c:choose><c:when test="${!empty result.a2}">		<c:out value="${result.a2}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a3}">		<c:out value="${result.a3}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a4}">		<c:out value="${result.a4}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a5}">		<c:out value="${result.a5}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a6}">		<c:out value="${result.a6}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a7}">		<c:out value="${result.a7}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a8}">		<c:out value="${result.a8}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a11}">		<c:out value="${result.a11}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a13}">		<c:out value="${result.a13}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a12}">		<c:out value="${result.a12}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a14}">		<c:out value="${result.a14}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a15}">		<c:out value="${result.a15}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a19}">		<c:out value="${result.a19}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><c:choose><c:when test="${!empty result.a20}">		<c:out value="${result.a20}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow_sh('<c:out value="${result.gid}"/>', '11');"><i class="fa fa-search"></i></button></td>
	                            		<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
	                            	</tr>
	                            	</c:forEach>
                            	</c:when>
                            	<c:otherwise>
                            		<tr id="nothing"><td colspan="17">검색결과 없습니다.</td></tr>
                            	</c:otherwise>
	                            </c:choose>	                            	
	                            </tbody>
	                        </table>
	                    </div>
	            	</c:if>

                </div>
                <!-- End Tab-Contents -->
                
                <!-- Tab-Chart -->
                <div class="popover-content addition tab-content" id="SH_ChartList">
	                <div class="card-box">
	                    <div class="row">
	                        <div class="col-xs-6 m-t-15">
	                            <div class="demo-box">
	                                <h4 class="header-title m-t-0">위탁관리 현황</h4>
	                                <div class="text-center">
	                                    <ul class="list-inline chart-detail-list">
	                                        <li class="list-inline-item">
	                                            <h5 class="text-teal"><i class="mdi mdi-crop-square m-r-5"></i>토지</h5>
	                                        </li>
	                                        <li class="list-inline-item">
	                                            <h5><i class="mdi mdi-details m-r-5"></i>건물</h5>
	                                        </li>
	                                    </ul>
	                                </div>
	                                <div id="morris-bar-stacked" style="height: 160px;"></div>	
	                            </div>
	                        </div>
	                        <div class="col-xs-6 m-t-15">	
	                            <div class="demo-box">
	                                <h4 class="header-title m-t-0">자산데이터 현황</h4>	
	                                <div class="text-center">
	                                    <ul class="list-inline chart-detail-list">
	                                        <li class="list-inline-item">
	                                            <h5 class="text-brown"><i class="mdi mdi-crop-square m-r-5"></i>토지</h5>
	                                        </li>
	                                        <li class="list-inline-item">
	                                            <h5><i class="mdi mdi-details m-r-5"></i>건물</h5>
	                                        </li>
	                                    </ul>
	                                </div>
	                                <div id="morris-area-example" style="height: 160px;"></div>
	                            </div>
	                        </div>
	                    </div>	
	                    <div class="row">
	                        <div class="col-xs-6 m-t-15">	
	                            <div class="demo-box">
	                                <h4 class="header-title m-t-0">연령별 유동인구</h4>	
	                                <div class="text-center">
	                                    <ul class="list-inline chart-detail-list">
	                                        <li class="list-inline-item">
	                                            <h5 class="text-primary"><i class="mdi mdi-crop-square m-r-5"></i>20대</h5>
	                                        </li>
	                                        <li class="list-inline-item">
	                                            <h5 class="text-success"><i class="mdi mdi-details m-r-5"></i>30대</h5>
	                                        </li>
	                                    </ul>
	                                </div>	
	                                <div id="morris-line-example" style="height: 160px;"></div>	
	                            </div> 
	                        </div>
	                        <div class="col-xs-6 m-t-15">
	                            <div class="demo-box">
	                                <h4 class="header-title m-t-0">데이터 보유 현황</h4>
	                                <div class="text-center">
	                                    <ul class="list-inline chart-detail-list">
	                                        <li class="list-inline-item">
	                                            <h5 class="text-info"><i class="mdi mdi-crop-square m-r-5"></i>토지</h5>
	                                        </li>
	                                        <li class="list-inline-item">
	                                            <h5 class="text-orange"><i class="mdi mdi-details m-r-5"></i>건물</h5>
	                                        </li>
	                                        <li class="list-inline-item">
	                                            <h5 class="text-danger"><i class="mdi mdi-checkbox-blank-circle-outline m-r-5"></i>사업지구</h5>
	                                        </li>
	                                    </ul>
	                                </div>
	                                <div id="morris-bar-example" style="height: 180px;"></div>	
	                            </div>
	                        </div>
	                    </div>
	                </div>
                </div>
                <!-- End Tab-Chart -->
                
            </div>
        </div>
        <div class="popover-footer">
            <div class="srl-pagination text-center">
                <ul class="pagination m-b-5 m-t-10 pagination-sm" id="pageZone">                	
<!--                     <li class="disabled"> -->
<!--                         <a href="#"><i class="fa fa-angle-left"></i></a> -->
<!--                     </li> -->
<!--                     <li> -->
<!--                         <a href="#">1</a> -->
<!--                     </li> -->
<!--                     <li class="active"> -->
<!--                         <a href="#">2</a> -->
<!--                     </li> -->
<!--                     <li> -->
<!--                         <a href="#">3</a> -->
<!--                     </li> -->
<!--                     <li> -->
<!--                         <a href="#">4</a> -->
<!--                     </li> -->
<!--                     <li> -->
<!--                         <a href="#">5</a> -->
<!--                     </li> -->
<!--                     <li> -->
<!--                         <a href="#"><i class="fa fa-angle-right"></i></a> -->
<!--                     </li> -->
                </ul>
            </div>
        </div>
    </div>

    <!-- End 자산검색 검색결과-Popup -->
    
    
    
    	
    	

    
</body>
 
 




    
    
    
    
    
    