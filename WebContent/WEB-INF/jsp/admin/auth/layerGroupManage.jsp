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

	<script>

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
		// 레이어 그룹 관련
        var defaultData1 = [
                          	{
                             	text: '등록된 데이터가 없습니다.',
                             	href: '#'  ,
                             	tags: ['']
                           	}
                          ];

		// 리스트 선택
        function fn_group_node_selected(event, data) {
        	if($('#btnLayerGroupEdit').text() == '저장') {
	    		alert('현재 편집 모드 상태입니다. 취소 후 진행 가능 합니다.');
	    		return;
	    	}

        	var desc = data.tags.toString();
        	var arrDesc = desc.split('#');

			$("#grp_no").val(    	arrDesc[0]);
        	$("#p_grp_no").val(  	arrDesc[1]);
			$("#grp_order").val( 	arrDesc[2]);
			$("#grp_nm").val(    	arrDesc[3]);
			$("#grp_desc").val(  	arrDesc[4]);
        	$("#grp_ins_user").text(arrDesc[5]);
			$("#grp_ins_dt").text( 	arrDesc[6]);
			$("#grp_upd_user").text(arrDesc[7]);
			$("#grp_upd_dt").text( 	arrDesc[8]);

	        $('#layerGroupEditForm *').filter(':input').each(function(){
	        	$(this).attr("readonly", true);
	        });
			$("#btnLayerGroupEdit").css('visibility', 'visible');
        }

        // 리스트
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

					$('#layerGroupTreeView').empty();
					$('#layerGroupTreeView').treeview({
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
					$('#layerGroupTreeView').on('nodeSelected', fn_group_node_selected);

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
					//$('#mapngGroupTreeView').on('nodeSelected', fn_group_node_selected);
  				}
  			});
        }

        fn_group_reload();

 		// 레이어 그룹 수정
        $('#btnLayerGroupEdit').click(function(e) {
        	/* alert('기능 지원 예정 입니다.');
        	return; */

        	if($('#btnLayerGroupEdit').text() == '수정')
        	{
		        $('#layerGroupEditForm *').filter(':input').each(function(){
		        	$(this).attr("readonly", false);
		        });
				$("#btnLayerGroupEditCancel").css('visibility', 'visible');

				$('#btnLayerGroupEdit').text('저장');
        	}
        	else
        	{
				// 저장
				{
		  			$.ajax({
		  				type : "POST",
		  				async : false,
		  				url : "<%=RequestMappingConstants.WEB_MNG_LAYER_GROUP_EDIT%>",
		  				dataType : "json",
		  				data : jQuery("#layerGroupEditForm").serialize(),
		  				error : function(response, status, xhr){
		  					if(xhr.status =='403'){
		  						alert('레이어 정보 업데이트를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
		  					}
		  				},
		  				success : function(data) {
		  					if(data.result == 'Y') {
		  						fn_group_reload();
			
		  						alert('레이어 그룹 정보가  정상적으로 수정되었습니다.');
		  					}
		  				}
		  			});
				}

				// 초기화
				$('#layerGroupEditForm *').filter(':input').each(function(){
			        	$(this).attr("readonly", true);
			    });
				$("#btnLayerGroupEditCancel").css('visibility', 'hidden');

        		$('#btnLayerGroupEdit').text('수정');
        	}
        });

		// 수정 - 취소
		$('#btnLayerGroupEditCancel').click(function(e) {
			$('#layerGroupEditForm *').filter(':input').each(function(){
	        	$(this).attr("readonly", true);
		    });
			$("#btnLayerGroupEditCancel").css('visibility', 'hidden');

			$('#btnLayerGroupEdit').text('수정');
		});

		$('#btnLayerGroupEditCancel').trigger("click");

		// 등록
		$('#btnLayerGroupAdd').click(function(e) {
			$('#layerGroupAdd').modal('show'); 
			$('#layerGroupAdd').show();
			$('#layerGroupAdd').center();
			
			$.ajax({
  				type : "POST",
  				async : false,
  				url : "<%=RequestMappingConstants.WEB_MNG_LAYER_GROUP_ADD_SETTING%>",
  				dataType : "json",
  				data : '',
  				error : function(response, status, xhr){
  					if(xhr.status =='403'){
  						alert('서버정보 업데이트를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
  					}
  				},
  				success : function(data) {
  					var maxLayerGroupNo = data.maxLayerGroupNo;
  					var layerGroupOrderList = data.layerGroupOrderList;
  					
  					$('#newGroupNo').val(maxLayerGroupNo);
  					
  					$.each(layerGroupOrderList, function(index, item){ 
  						$('#newGroupOrder').append('<option value=' + item.order + '>' + item.order + '</option>');
  						$('#newGroupOrder').val(item.order).attr('selected','true');
  					});
  					
  				}
			});
			
		});
		
		// 등록 취소
		$('#btnGroupAddCancel').click(function(e) {
			$('#layerGroupAdd').modal('hide'); 
			$('#layerGroupAdd').hide();
		});
		
		// 레이어 그룹 추가
		$('#btnGroupAddSave').click(function(e) {
			 console.log('레이어 그룹 추가 진입');
			 $.ajax({
	  				type : "POST",
	  				async : false,
	  				url : "<%=RequestMappingConstants.WEB_MNG_LAYER_GROUP_ADD%>",
	  				dataType : "json",
	  				data : jQuery("#layerGroupAddForm").serialize(),
	  				success : function(data) {
	  					console.log(data);
	  					$('#layerGroupAdd').modal('hide'); 
	  					$('#layerGroupAdd').hide();
	  					alert('레이어 그룹이 정상적으로 추가되었습니다.');
						//window.location.reload();
						
	  				}
	  			});
			 
       });

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    });
	</script>


	<div class="contWrap">
        <h1>${sesMenuNavigation.progrm_nm}</h1>
        <div class="whiteCont">
        	<p class="pageNav">
                <a href="<%=RequestMappingConstants.WEB_MAIN%>">HOME</a> &nbsp;&nbsp; |  &nbsp;&nbsp;  <a href="<%=RequestMappingConstants.WEB_MNG_USER%>">${sesMenuNavigation.p_progrm_nm}</a>  &nbsp;&nbsp;  |  &nbsp;&nbsp;  	${sesMenuNavigation.progrm_nm}
            </p>
	        
			<!-- LayerGroup Detail Page-Body -->
	        <div class="row hei_100" id="layerGroupEdit">
	        	<div class="col-sm-12 hei_100">
	            	<div class="card-box big-card-box last table-responsive searchResult hei_100" style= "padding-bottom: 0px;">

	                    <div class="sysstat-wrap">

	                        <div class="row">
	                            <div class="col-sm-4">
	                                <div class="card-box">
					                    <h5 class="header-title"><b>그룹 목록</b> <span class="small">(전체 <b class="text-orange"><span id='groupListCount'>0</span></b>건)</span></h5>

                           				<div class="table-wrap m-t-30" style='height: 590px; overflow-y:auto' id='layerGroupTreeView'></div>

	                                </div>
	                            </div>
	                            <div class="col-sm-8">
	                                <div class="card-box">
	                                    <h5 class="header-title"><b>그룹 상세</b></h5>

								        <!-- Edit Page-Body -->
								        <form class="clearfix" id="layerGroupEditForm" name="layerGroupEditForm">
					                    <div class="table-wrap m-t-30">
					                        <table class="table table-custom table-cen table-num text-center table-hover" >
					                        	<caption class="none">레이어 그룹 상세 테이블</caption>
					                            <colgroup>
					                            	<col style="width:20%">
				                        			<col style="width:30%">
				                        			<col style="width:20%">
				                        			<col style="width:30%">
					                            </colgroup>
					                            <tbody>
				                                	<tr>
				                                       <th scope="row">그룹 NO. <span class="text-danger">*</span></th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="grp_no" id="grp_no"  type="text" maxlength="20" title="그룹 NO." placeholder="">
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">상위 그룹 NO. <span class="text-danger">*</span></th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="p_grp_no" id="p_grp_no"  type="text" maxlength="20" title="상위 그룹 NO." placeholder="">
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">표출 순서</th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="grp_order" id="grp_order"  type="text" maxlength="3" title="표출 순서" placeholder="">
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">그룹명</th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="grp_nm" id="grp_nm"  type="text" maxlength="100" title="그룹명" placeholder="">
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">등록자</th>
				                                       <td id="grp_ins_user"></td>
				                                       <th scope="row">등록일시</th>
				                                       <td id="grp_ins_dt"></td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">수정자</th>
				                                       <td id="grp_upd_user"></td>
				                                       <th scope="row">수정일시</th>
				                                       <td id="grp_upd_dt"></td>
				                                   	</tr>
				                                   	<tr>
					                                    <th scope="row">설명</th>
					                                    <td colspan="3">
					                                    	<textarea name="grp_desc" id="grp_desc" rows="4" cols="60" class="form-control" title="설명" placeholder=""  style="resize: none;"></textarea>
					                                	</td>
				                                  	</tr>
				                               	</tbody>
				                       		</table>
					                    </div>
					                    </form>
								       	<!-- End Edit Page-Body -->

				                        <div class="row text-right">
				                            <div class="col-xs-10">
				                            </div>
				                            <div class="col-xs-1">
				                            	<button type="button" class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id='btnLayerGroupEditCancel' style='visibility: hidden'>취소</button>
				                            </div>
				                            <div class="col-xs-1">
												<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnLayerGroupEdit' style='visibility: hidden'>수정</button>
				                            </div>
				                        </div>

	                            	</div>
	                            	 <div class="row text-right">
			                            <div class="col-xs-11">
			                            </div>
			                            <div class="col-xs-1">
											<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnLayerGroupAdd'>신규</button>
			                            </div>
			                        </div>
	                            </div>
	                        </div>

	                       <!--  <div class="row text-right">
	                            <div class="col-xs-11">
	                            </div>
	                            <div class="col-xs-1">
									<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnLayerGroupAdd'>신규</button>
	                            </div>
	                        </div> -->

	                    </div>

	                </div>
	            </div>
	        </div>
			<!-- End LayerGroup Detail Page-Body -->
		</div>
	</div>

 <!-- Add Page-Body -->
<div class="row"  id="layerGroupAdd" style='position: absolute; display: none; z-index:100'>
	<div class="col-sm-10">
    	<div class="card-box big-card-box last table-responsive searchResult">
        	<h5 class="header-title"><b>레이어 그룹 신규 등록</b></h5>
    		<form class="clearfix" id="layerGroupAddForm" name="layerGroupAddForm">
    			<input name="newLayerNo" id="newLayerNo"  type="hidden">
             	<div class="table-wrap m-t-30">
                	<table class="table table-custom table-cen table-num text-center table-hover" >
                		<caption class="none">레이어 그룹 신규 등록 테이블</caption>
                    	<colgroup>
                         	<col style="width:50%">
                   			<col style="width:50%">
                     	</colgroup>
                     	<tbody>
                       		<tr>
                               <th scope="row">그룹 NO <span class="text-danger">*</span></th>
                               <td>
                               	<input class="form-control required" name="newGroupNo" id="newGroupNo"  type="text" maxlength="100" title="순서" placeholder="" readonly>
                               </td>
                           	</tr>
                        	<tr>
                            	<th scope="row">상위 그룹 NO <span class="text-danger">*</span></th>
                             	<td>
	                                <select name="newParentGroupNo" id="newParentGroupNo" class="form-control col-md-3 input-sm"  title="상위 그룹 NO">
	                           			<option value = "">최상위 그룹</option>	
									</select>
                               	</td>
                           	</tr>
                           	<tr>
                            	<th scope="row">표출순서</th>
                               	<td>
                               		<select name="newGroupOrder" id="newGroupOrder" class="form-control col-md-3 input-sm" title="메뉴 여부" >
	                               	</select>
                               	</td>
                           	</tr>
							<tr>
								<th scope="row">그룹명</th>
								<td>
									<input class="form-control required" name="newGroupNm" id="newGroupNm"  type="text" maxlength="1024" title="CSS Style" placeholder="">
								</td>
							</tr>
							<tr>
								<th scope="row">설명</th>
	                            <td>
	                             	<textarea name="newGroupDesc" id="newGroupDesc" rows="6" cols="60" class="form-control" title="설명" placeholder="" style="resize: none;"></textarea>
	                         	</td>
							</tr>
                       	</tbody>
               		</table>
				</div>
			</form>
            <div>
	           	<div class="btn-wrap pull-left">
	          	</div>
               	<div class="btn-wrap pull-right">
               		<button class="btn btn-custom btn-md pull-right searchBtn" id="btnGroupAddCancel" type="button">닫기</button>
               	   	<button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id="btnGroupAddSave" type="button">저장</button>
               	</div>
             </div>
        </div>
    </div>
</div>
