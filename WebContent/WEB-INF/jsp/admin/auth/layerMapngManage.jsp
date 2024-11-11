<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

	<link rel="stylesheet" href="<c:url value='/resources/css/util/bootstrap/bootstrap-treeview.min.css'/>">
	<script  src="<c:url value='/resources/js/util/bootstrap/bootstrap-treeview.min.js'/>"></script> 
	
    <!-- App css -->
    <link rel="stylesheet" href="<c:url value='/resources/css/util/editor/ap-image-zoom.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/css/util/editor/ap-image-fullscreen.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/css/util/editor/ap-image-fullscreen-themes.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/css/util/jquery/jquery-gallery.css'/>">
    
    <!-- jQuery Library -->
    <script  src="<c:url value='/resources/js/util/editor/ap-image-zoom.js'/>"></script>
    <script  src="<c:url value='/resources/js/util/editor/ap-image-fullscreen.js'/>"></script>
    <script  src="<c:url value='/resources/js/util/jquery/jquery-gallery.js'/>"></script>
    <script  src="<c:url value='/resources/js/util/editor/screenfull.min.js'/>"></script>
    
	<script >
	
	 function fn_callback(actionType, data){

       	switch (actionType) {
       	  
			// 그룹별 매핑 레이어 목록 조회    	
       	  case "selectMapngLayer":
      			var data = data.MapngLayerData;
					$("#groupNm").text(data[0].grp_nm);  //그룹이름
					$("#groupNm").val(data[0].grp_no);  //grp_no
					$("#mapngListCount").text(data.length);  //레이어수
					var row = '';
					// 데이터가 존재하는지 확인
					if (data.length > 0) {
					    var rows = ''; // 모든 행을 저장할 변수
					    // 데이터를 반복하여 각 행을 생성
					    for (var i = 0; i < data.length; i++) {
					        if (data[i].layer_no != '') {
					            // 각 행을 생성
					            rows += "<tr data-row-id='" + data[i].layer_no + "'>" +
					                    "    <td>" +
					                    "        <div class='content-checkbox' style = 'display: flex; justify-content: center; align-items: center;' >" +
					                    "            <label class='box-checkbox text-none'>" +
					                    "                <input type='checkbox' id='c_layerno' name='c_layerno' value='" + data[i].layer_no + "' />" +
					                    "                <span class='checkmark'></span>" +
					                    "            </label>" +
					                    "        </div>" +
					                    "    </td>" +
					                    "    <td style='text-align: left;'>" + data[i].layer_nm + "</td>" +
					                    "</tr>";
					        }

					    }
					    // 모든 행을 tbody에 추가
					    $('#layerGroupMapngData').html(rows);
					}
       		break;
       		
       	 	// 그룹 매핑 없는 레이어 목록 조회
	       	case "selectNonMapngLayer":
	       		$('#mapngAdd').modal('show'); 
	       		var data = data.LayerAddList;
				var row = '';
				// 데이터가 존재하는지 확인
					if (data.length > 0) {
					    var rows = ''; // 모든 행을 저장할 변수
					    // 데이터를 반복하여 각 행을 생성
					    for (var i = 0; i < data.length; i++) {
					        if (data[i].layer_no != '') {
					            // 각 행을 생성
					            rows += "<tr data-row-id='" + data[i].layer_no + "'>" +
					                    "    <td>" +
					                    "        <div class='content-checkbox' style = 'display: flex; justify-content: center; align-items: center;' >" +
					                    "            <label class='box-checkbox text-none'>" +
					                    "                 <input type='checkbox' id='c_Addlayerno' name='c_Addlayerno' value='" + data[i].layer_no + "' />" +
					                    "                <span class='checkmark'></span>" +
					                    "            </label>" +
					                    "        </div>" +
					                    "    </td>" +
					                    "    <td style='text-align: left;'>" + data[i].layer_nm + "</td>" +
					                    "</tr>";
					        }

					    }
					    // 모든 행을 tbody에 추가
					    $('#layerGroupNonMapng').html(rows);
					}else{
						var rows = ''; // 모든 행을 저장할 변수
						rows += "<tr>" +
	                    "    <td colspan = '2' style='text-align: center;'>레이어 없음</td>" +
	                    "</tr>";
						$('#layerGroupNonMapng').html(rows);
					}
				
					$('#mapngAddForm')[0].reset();
					$('#mapngAdd').show();
		        	$('#mapngAdd').center();
	   		break;
	   		
	   		// 그룹 - 레이어 매핑 추가 완료
	       	case "MapngLayerAdd":
	       		alert('레이어 그룹 매핑 추가를 정상적으로 완료하었습니다.');
	       		$('#mapngAdd').modal('hide'); 
	       		$('#mapngAdd').hide();
	       		
	   		break;
	   		
	   		// 그룹 - 레이어 매핑 해제 완료
	       	case "MapngLayerDel":
	   		break;
       		

       	  default:
       	    null; 
       	}
       }
	 
	// 초기화 및 이벤트 등록
	$(document).ready(function() {

    	if (!String.prototype.padStart) {
    	    String.prototype.padStart = function padStart(targetLength,padString) {
    	        targetLength = targetLength>>0;
    	        padString = String((typeof padString !== 'undefined' ? padString : ' '));
    	        if (this.length > targetLength) {
    	            return String(this);
    	        } else {
    	            targetLength = targetLength-this.length;
    	            if (targetLength > padString.length) {
    	                padString += padString.repeat(targetLength/padString.length);
    	            }
    	            return padString.slice(0,targetLength) + String(this);
    	        }
    	    };
    	}
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// 그룹 -레이어 표출
		var defaultData1 = [
                          	{
                             	text: '등록된 데이터가 없습니다.',
                             	href: '#'  ,
                             	tags: ['']
                           	}
                          ];
        
     	// 기존 선택된 노드 ID를 저장할 변수
        var previouslySelectedNodeId = null;
        
		// 그룹 리스트 선택
        function fn_group_node_selected(event, data) {
        	if ($('input[name="c_layerno"]:checked').length > 0) {  // 하나 이상의 레이어가 선택되어 있을 때
        		if (confirm('현재 편집 모드 상태입니다. 그래도 진행하시겠습니까?')) { 
        			 // 사용자가 '확인'을 누르면 다른 그룹으로 이동
                    // 기존 선택된 노드를 새로 저장
                    previouslySelectedNodeId = data.nodeId;
        		
                 	// toggle_mapng 체크박스를 해제
                    $('#toggle_mapng').prop('checked', false);  // 다른 그룹으로 이동할 때 체크 해제
    		    } else {
    		    	// 사용자가 '취소'를 선택했을 때
    	            // 현재 선택을 해제하고, 이전에 선택된 노드를 다시 선택하도록 설정
    	            $('#mapngGroupTreeView').treeview('unselectNode', [data.nodeId, { silent: true }]);

    	            // 이전에 선택된 노드가 있으면, 다시 선택
    	            if (previouslySelectedNodeId !== null) {
    	                $('#mapngGroupTreeView').treeview('selectNode', [previouslySelectedNodeId, { silent: true }]);
    	            }

    	            // 현재 함수 종료
    	            return;
    		    }
            } else {
                // 레이어가 선택되지 않았을 때, 선택된 노드를 새로 저장
                previouslySelectedNodeId = data.nodeId;
                $('#toggle_mapng').prop('checked', false);
            }
        	
        	
        	var desc = data.tags.toString();
        	var arrDesc = desc.split('#');
			
        	 ////////// 선택한 그룹의 레이어 매핑 목록 ////////////////
        	//param = grp_no : 그룹번호
              var param = {
                "grp_no": arrDesc[0]
            };
        	
            gfn_transaction("/MapngLayerList.do", "POST", param, "selectMapngLayer"); 
        }
		
		
        // 그룹 리스트
        function fn_group_reload() {
  			$.ajax({
  				type : "POST",
  				async : false,
  				url : "<%=RequestMappingConstants.WEB_MNG_LAYER_GROUP_LIST%>",
  				dataType : "json",
  				data : '',
  				error : function(response, status, xhr){
  					if(xhr.status =='403'){
  						alert('그룹정보 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
  					}
  				},
  				success : function(data) {
 					defaultData1 = [];
					var item = {};

					for(i=0; i<data.groupInfo.length;i++)
					{
						item =  {
					             	text: data.groupInfo[i].space + '<font color="#ff9900">[' + data.groupInfo[i].grp_order.toString().padStart(2, '0') + ']</font> <font color="#00AA40">'+ data.groupInfo[i].grp_nm + '</font>' ,
					             	href: '#'  ,
					             	tags: [ data.groupInfo[i].grp_no+ '#' +
					             	        data.groupInfo[i].p_grp_no+ '#' +
					             	        data.groupInfo[i].grp_order+ '#' +
					             	        data.groupInfo[i].grp_nm+ '#' +
					             	        data.groupInfo[i].grp_desc+ '#' +
						             	    data.groupInfo[i].ins_user+ '#' +
						             	    data.groupInfo[i].ins_dt+ '#' +
						             	    data.groupInfo[i].upd_user+ '#' +
						             	    data.groupInfo[i].upd_dt ]
					           	};
						defaultData1.push(item);
					}
					$("#groupListCount").text(data.groupInfo.length);

					$('#mapngGroupTreeView').empty();
					$('#mapngGroupTreeView').treeview({
			            data: defaultData1,
			            enableLinks:false,
			            color: undefined,					// '#000000',
			            backColor: undefined,				// '#FFFFFF',
			            borderColor: undefined,				// '#dddddd',
			            onhoverColor:'#F5F5F5',
			            selectedColor:'#000000',
			            selectedBackColor:'#dddddd',
			            searchResultColor:'#D9534F',
			            searchResultBackColor: undefined,	//'#FFFFFF',
			            showBorder:true,
			            showIcon:true,
			            showCheckbox:false,
			            showTags:false,
			            highlightSelected:true,
			            highlightSearchResults:true,
			            multiSelect:false
			    	});
					$('#mapngGroupTreeView').on('nodeSelected', fn_group_node_selected);
  				}
  			});
        }

        fn_group_reload();  //그룹 목록 표출
		

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// 매핑 관련
		// 그룹-레이어 매핑 삭제 - 삭제버튼
		$('#btnMapngDel').click(function(e) {
			if ($("#groupNm").text()=='') {  // 매핑 해제할 그룹이 선택되지 않았을 경우
		        alert('그룹을 선택해 주세요.');
		        return;
		    }
			
			if ($('input[name="c_layerno"]:checked').length == 0) {  // 매핑 해제할 레이어가 선택되지 않았을 경우
		        alert('매핑 해제할 레이어를 선택해 주세요.');
		        return;
		    }
			
			if (confirm('그룹-레이어 매핑을 해제하시겠습니까?\n 작업을 진행하시려면 확인을 눌러주세요.')) {  // 그룹-레이어 매핑 해제 확인
		        /////////////////////그룹-레이어 매핑 해제////////////////////////
		        //layer_no,grp_no 필요
				var grp_no = $("#groupNm").val(); //grp_no
				var layer_arr = [];
				
				$('input[name="c_layerno"]:checked').each(function() {
				    layer_arr.push($(this).val());
				});
				
				// 배열을 문자열로 변환, 값 사이에 &를 추가
				var layer_no_string = layer_arr.join('&'); 
				
				// 데이터 전송을 위한 객체 생성
				var requestData = {
				    grp_no: grp_no,
				    layer_no: layer_no_string 
				};

				gfn_transaction("/MapngLayerDel.do", "POST", requestData, "MapngLayerDel"); 
				
				/////////////////////그룹-레이어 목록 표출////////////////////////
	          	 var param = {
	                     grp_no: grp_no
	                };
	             	
	            gfn_transaction("/MapngLayerList.do", "POST", param, "selectMapngLayer"); 
		        
		    } else {
		        // 매핑 해제 작업 취소
		        alert('작업이 취소되었습니다.');
		    }
		});
        
        
		// 그룹-레이어 매핑 추가버튼
		$('#btnMapngAdd').click(function(e) {
			if ($("#groupNm").text()=='') {  // 매핑 해제할 그룹이 선택되지 않았을 경우
		        alert('그룹을 선택해 주세요.');
		        return;
		    }
			
		  // 그룹 매핑없는 레이어 목록
          gfn_transaction("/NonMapngLayerList.do", "POST", null, "selectNonMapngLayer"); 
          
		});
		
		
		// 그룹-레이어 매핑 추가 등록 - 저장버튼(팝업)
		$('#btnMapngAddSave').click(function(e) {
			if ($('input[name="c_Addlayerno"]:checked').length == 0) {  // 매핑 해제할 레이어가 선택되지 않았을 경우
		        alert('그룹과 매핑 추가할 레이어를 선택해 주세요.');
		        return;
		    }
			/////////////////////그룹-레이어 매핑 연결////////////////////////
			//layer_no,grp_no 필요
			var grp_no = $("#groupNm").val(); //grp_no
			var layer_arr = [];
			
			$('input[name="c_Addlayerno"]:checked').each(function() {
			    layer_arr.push($(this).val());
			});
			
			// 배열을 문자열로 변환, 값 사이에 &를 추가
			var layer_no_string = layer_arr.join('&'); 
			
			// 데이터 전송을 위한 객체 생성
			var requestData = {
				    grp_no: grp_no,
				    layer_no: layer_no_string 
				};

          	gfn_transaction("/MapngLayerAdd.do", "POST", requestData, "MapngLayerAdd"); 
          	
			/////////////////////그룹-레이어 목록 표출////////////////////////
          	 var param = {
                     grp_no: grp_no
                 };
             	
            gfn_transaction("/MapngLayerList.do", "POST", param, "selectMapngLayer"); 
		
		});
		
		// 그룹-레이어 매핑 추가  - 취소버튼(팝업)
		$('#btnMapngAddClose').click(function(e) {
			if ($('input[name="c_Addlayerno"]:checked').length > 0) {  // 매핑 추가할 레이어가 선택되어 있다면 - 확인체크
				if (confirm('작업을 취소하시겠습니까?')) {  // 매핑등록 취소확인
			        // 매핑 해제 작업 승인
			        $('#mapngAdd').modal('hide'); 
					$('#mapngAdd').hide();
			    } else ;
		    }else{ // 안보이게
		    	$('#mapngAdd').modal('hide'); 
		    	$('#mapngAdd').hide();
		    }
		});
		
		
		// 권한삭제체크 - 토글 (매핑목록)
	    $("#toggle_mapng").change(function(){
	    	$('input[name="c_layerno"]').prop('checked', this.checked );
	    });
		
	 	// 권한추가체크 - 토글 (팝업)
	    $("#toggle_mapngAdd").change(function(){
	    	$('input[name="c_Addlayerno"]').prop('checked', this.checked );
	    });
	 	
    });
	</script>

	<div class="contWrap">
        <h1>${sesMenuNavigation.progrm_nm}</h1>
        <div class="whiteCont">
        	<p class="pageNav">
                <a href="<%=RequestMappingConstants.WEB_MAIN%>">HOME</a> &nbsp;&nbsp; |  &nbsp;&nbsp;  <a href="<%=RequestMappingConstants.WEB_MNG_USER%>">${sesMenuNavigation.p_progrm_nm}</a>  &nbsp;&nbsp;  |  &nbsp;&nbsp;  	${sesMenuNavigation.progrm_nm}
            </p>

			<!-- Mapping Detail Page-Body -->
	        <div class="row hei_100" id="mapngEdit">
	        	<div class="col-sm-12 hei_100">
	            	<div class="card-box big-card-box last table-responsive searchResult hei_100" style= "padding-bottom: 0px;">

	                    <div class="sysstat-wrap">

	                        <div class="row">
	                            <div class="col-sm-5">
	                                <div class="card-box">
					                    <h5 class="header-title"><b>그룹 목록</b> <span class="small">(전체 <b class="text-orange"><span id='groupListCount'>0</span></b>건)</span></h5>

                           				<div class="table-wrap m-t-30" style='height: 590px; overflow-y:auto' id='mapngGroupTreeView'></div>

	                                </div>
	                            </div>
	                            <div class="col-sm-7">
	                                <div class="card-box">
					                    <h5 class="header-title"><b>매핑 목록</b> <span class="small">(전체 <b class="text-orange"><span id='mapngListCount'>0</span></b>건)</span></h5>

                           				<!-- 기존주석<div class="table-wrap m-t-30" style='height: 780px; overflow-y:auto' id='mapngTreeView'></div> -->
                           				<div class="row text-right m-t-10" style="display: flex; align-items: center;">
								           	<div class="btn-wrap pull-left">
								           	<span style="flex-grow: 1;"><b style="font-size: 20pt;"><span id='groupNm'></span></b></span>
								          	</div>
							               	<div class="btn-wrap pull-right" style="flex-grow: 1;"><!--id="btnLayerMapngEdit"   -->
							               		<button class="btn btn-custom btn-md pull-right searchBtn" id="btnMapngAdd" type="button">추가</button>
							               	   	<button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id="btnMapngDel" type="button">삭제</button>
							               	</div>
							             </div>
                           				
                           				<!-- Edit Page-Body -->
								        <form class="clearfix" id="layerGroupMapngForm" name="layerGroupMapngForm">
					                    <div class="table-wrap m-t-10" style='height: 545px; overflow-y:auto'>
					                        <table class="table table-custom table-cen table-num text-center table-hover" >
					                        	<caption class="none">레이어 매핑 목록 테이블</caption>
					                            <colgroup>
					   	                         	<col style="width:20%">
               										<col style="width:80%">
					                            </colgroup>
					                            <thead>
					                           		<tr>
				                                       <th>선택 <input name="toggle_mapng" id="toggle_mapng" type="checkbox"  title="선택"></th>
				                                       <th>레이어 목록</th>
			                                   		</tr>
				                                </thead>
					                           <tbody id="layerGroupMapngData">
                     						   </tbody>
				                       		</table>
					                    </div>
					                    </form>
								       	<!-- End Edit Page-Body -->
	                                </div>
	                            </div>
	                        </div>
	                	</div>

	                </div>
	            </div>
	        </div>
			<!-- End Mapping Detail Page-Body -->
			
		</div>
	</div>
	
<!-- Mapping Add Page-Body -->
<div class="row" id="mapngAdd" style='display: none;z-index: 100;'>
	<div class="col-sm-12">
   		<div class="card-box big-card-box last table-responsive searchResult">
        	<h5 class="header-title"><b>그릅-레이어 매핑 추가 등록</b></h5>
		   <!-- Edit Page-Body -->
		   <form class="clearfix" id="mapngAddForm" name="mapngAddForm">
			<div class="table-wrap m-t-30">
                <table class="table table-custom table-cen table-num text-center table-hover" >
                	<caption class="none">레이어 그룹-레이어 매핑 등록 테이블</caption>
                    <colgroup>
                    	<col style="width:20%">
               			<col style="width:80%">
                    </colgroup>
                 	<thead>
               			<tr>
	                         <th>선택 <input name="toggle_mapngAdd" id="toggle_mapngAdd" type="checkbox" title="선택"></th>
	                         <th>레이어 목록</th>
                       	</tr>
                    </thead>
                    <tbody id="layerGroupNonMapng">
						
                   	</tbody>
           		</table>
            </div>
		</form>
		<!-- End Edit Page-Body -->
         <div>
               	<div class="btn-wrap pull-left">
               		<button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id="btnMapngAddSave" type="button">저장</button>
              	</div>
               	<div class="btn-wrap pull-right">
                   <button class="btn btn-custom btn-md pull-right searchBtn" id="btnMapngAddClose" type="button">닫기</button>
               	</div>
         </div>
	</div>
    </div>
</div>
<!-- End Mapping Add Page-Body -->
