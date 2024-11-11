<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<script type="text/javascript" src="<c:url value='/resources/js/map/task/searchView.js'/>"></script>
<script type="text/javascript">
$(document).ready(function() {
	//탭 활성화
	$("#SH_SearchList_tab li").eq(0).addClass("active");
	$("#SH_SearchList div[id^=SH_SearchList_]").eq(0).removeClass("fade");
	$("#SH_SearchList div[id^=SH_SearchList_]").eq(0).addClass("active");
	save_searchList(1, $("#SH_SearchList div[id^=SH_SearchList_]").eq(0).prop("id").replace("SH_SearchList_", "") );
	
	//탭클릭시 리스트 갱신
	$("#SH_SearchList_tab li").on("click", function(){
    	var type = $(this).find("a").attr("href").replace("#SH_SearchList_", ""); 
    	console.log("type",type)
    	save_searchList(1, type);
    });
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
	
	DetailWindow = window.open("${contextPath}/Content_SH_View_Detail.do?pnu="+pnu+'&sn='+sn+"&sh_kind="+div_nm
			,"searchDetail"
			,"toolbar=no, width=1100, height=750,directories=no,status=no,scrollorbars=yes,resizable=yes");
	
}

//페이징처리
function drawPage(goTo, type, n, t, kind){   
	console.log("drawPage!!")
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
	console.log("shoow!!!!!!!!!!!!!!!!!!!!!!!",type)
	var pagesize = 10//Number( ${cnt_kind} );
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

function GISSearchList_downExcel(){
	console.log("엑셀다운로드!")
	var type = null;
	$("#SH_SearchList div[id^=SH_SearchList_]").each(function(){
		
		if( $(this).css("display") == 'block' ){
			type = $(this).prop("id").replace("SH_SearchList_", "");
		}
	});
	opener.GISSearchList_downExcel(type);
}
</script>
</head>
<body>
<!-- 검색결과-Popup -->
<div class="popover layer-pop new-pop" id="asset-search-list" style="width:100%; height:100%; top:auto; display:block;">
	<div class="popover-title tit">
	    <span class="m-r-5">
	        <b>검색결과</b>
	    </span>
	    <span class="small">(전체 <strong class="text-orange" id="total_cnt">${fn:length(gbList)}</strong> 건)</span>
	</div>
	<div class="popover-body">
	    <div class="row btn-wrap-group">
	        <div class="col-xs-12">
	            <div class="btn-wrap text-right">
	                   <!-- //ycb 검색결과 전체표출 추가 20180626 -->
	                   <button type="button" class="btn btn-xs btn-info" onclick="GISSearchList_DrawAll()">검색결과 지도 표출</button>
	                   <button type="button" class="btn btn-xs btn-default" onclick="GISSearchList_downExcel()">엑셀 다운로드</button>
            	</div>
	        </div>
	    </div>
	    <!-- Tab-Buttons -->
        <ul class="nav nav-tabs" id="SH_SearchList_tab">
        	<li><a data-toggle="tab" href="#SH_SearchList_gb">기본검색</a></li>   
        </ul>
        <!-- End Tab-Buttons -->
        
        <div class="popover-content-wrap asset-srl">  
           	<!-- Tab-Contents -->  
        <div class="popover-content tab-content" id="SH_SearchList">
	    <div class="tab-pane fade" id="SH_SearchList_gb">                			
	        <table class="table table-custom table-cen table-num text-center table-condensed" width="100%">
	            <thead>
	            	<tr>
	            		<th data-sort="int" width="40px;">번호</th>
	            		<th data-sort="string" width="200px;">소재지</th>
						<th data-sort="string" width="80px;">건축물종류</th>
                    	<th data-sort="string">건물명</th>
                    	<th data-sort="string">주용도명</th>
						<th data-sort="float">대지면적(㎡)</th>
						<th data-sort="float">건축면적(㎡)</th>
						<th data-sort="float">사용승인일</th>
						<th data-sort="float">건폐율(%)</th>
						<th data-sort="float">용적률(%)</th>
						<th width="60px;">정보확인</th>
						<th width="60px;">화면이동</th>
            		</tr>
            	</thead>
            	<tbody>
            		<c:forEach var="result" items="${gbList}" varStatus="status">
            			<tr>
            				<td><c:out value="${status.count}"/></td>
            				<td>${result.addr}</td>  
            				<td>${result.set_buld_se}</td>
            				<td><c:choose><c:when test="${!empty result.buld_nm}"><c:out value="${result.buld_nm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
            				<td><c:choose><c:when test="${!empty result.main_prpos_nm}"><c:out value="${result.main_prpos_nm}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
            				<td align="right"><c:choose><c:when test="${!empty result.bldste_ar}"><fmt:formatNumber value="${result.bldste_ar}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
            				<td align="right"><c:choose><c:when test="${!empty result.buld_bildng_ar}"><fmt:formatNumber value="${result.buld_bildng_ar}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
            				<td><c:choose><c:when test="${!empty result.use_confm_de}"><c:out value="${result.use_confm_de}"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
            				<td align="right"><c:choose><c:when test="${!empty result.bdtldr}"><fmt:formatNumber value="${result.bdtldr}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
            				<td align="right"><c:choose><c:when test="${!empty result.measrmt_rt}"><fmt:formatNumber value="${result.measrmt_rt}" pattern="#,###.#"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
            				<td><button class="btn btn-xs btn-custom" onclick="javascript:infodetailshow('<c:out value="${result.innb}"/>');"><i class="fa fa-search"></i></button></td>
            				<td><button class="btn btn-xs btn-custom" onclick="javascript:opener.map_move('<c:out value="${result.addr_x}"/>', '<c:out value="${result.addr_y}"/>', '<c:out value="${result.geom}"/>');"><i class="fa fa-map-marker"></i></button></td>
            			</tr>
            		</c:forEach>
            	</tbody>
            </table>
		</div>
	</div>
   <!-- End Tab-Contents -->
   </div>
</div>
	
	 <div class="popover-footer">
   		<div class="srl-pagination text-center">
        	<ul class="pagination m-b-5 m-t-10 pagination-sm" id="pageZone">                	
			</ul>
        </div>
    </div>                           	                           	
</div>
 <!-- End 건축물검색 검색결과-Popup -->
</body>
</html>