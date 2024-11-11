<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>


	<link rel="stylesheet" href="<c:url value='/resources/css/util/bootstrap/bootstrap-treeview.min.css'/>">
	<script src="<c:url value='/resources/js/util/bootstrap/bootstrap-treeview.min.js'/>"></script> 
	
    <!-- <style type="text/css">
		.ellipsis {
		    width: 250px;
		    text-overflow: ellipsis;
		    -o-text-overflow: ellipsis;
		    overflow: hidden;
		    white-space: nowrap;
		    word-wrap: normal !important;
		    display: block;
		}
    </style> -->


	<script>

	// 초기화 및 이벤트 등록
	$(document).ready(function() {

		// 해당 메소드 절대 삭제 금지
		if (!String.prototype.repeat) {
			  String.prototype.repeat = function(count) {
			    'use strict';
			    if (this == null) {
			      throw new TypeError('can\'t convert ' + this + ' to object');
			    }
			    var str = '' + this;
			    count = +count;
			    if (count != count) {
			      count = 0;
			    }
			    if (count < 0) {
			      throw new RangeError('repeat count must be non-negative');
			    }
			    if (count == Infinity) {
			      throw new RangeError('repeat count must be less than infinity');
			    }
			    count = Math.floor(count);
			    if (str.length == 0 || count == 0) {
			      return '';
			    }
			    // Ensuring count is a 31-bit integer allows us to heavily optimize the
			    // main part. But anyway, most current (August 2014) browsers can't handle
			    // strings 1 << 28 chars or longer, so:
			    if (str.length * count >= 1 << 28) {
			      throw new RangeError('repeat count must not overflow maximum string size');
			    }
			    var maxCount = str.length * count;
			    count = Math.floor(Math.log(count) / Math.log(2));
			    while (count) {
			       str += str;
			       count--;
			    }
			    str += str.substring(0, maxCount - str.length);
			    return str;
			  }
		}

		if (!String.prototype.padStart) {
		    String.prototype.padStart = function padStart(targetLength, padString) {
		        targetLength = targetLength >> 0; //truncate if number, or convert non-number to 0;
		        padString = String(typeof padString !== 'undefined' ? padString : ' ');
		        if (this.length >= targetLength) {
		            return String(this);
		        } else {
		            targetLength = targetLength - this.length;
		            if (targetLength > padString.length) {
		                padString += padString.repeat(targetLength / padString.length);
		            }
		            return padString.slice(0, targetLength) + String(this);
		        }
		    };
		}

        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// 테이블 리스트 관련
        var defaultData1 = [
                          	{
                             	text: '등록된 데이터가 없습니다.',
                             	href: '#'  ,
                             	tags: ['']
                           	}
                          ];

		// 테이블 선택
        function fn_table_node_selected(event, data) {
        	var desc = data.tags.toString();
        	var arrDesc = desc.split('#');

        	$("#t_table_space").val(    arrDesc[0]);
        	$("#t_table_nm").text(      arrDesc[1]);
        	$("#t_table_comment").val(  arrDesc[2]);
        	$("#geom_column_nm").text(  arrDesc[3]);
        	$("#geom_srid").text(       arrDesc[4]);
        	$("#geom_type").text(       arrDesc[5]);

        	fn_column_reload(arrDesc[0], arrDesc[1]);

	        $('#taleEditForm *').filter(':input').each(function(){
	        	$(this).attr("readonly", true);
	        });
			$("#btnTableEdit").css('visibility', 'visible');

	        $('#columnEditForm *').filter(':input').each(function(){
	        	$(this).attr("readonly", true);
	        });
			$("#btnColumnEdit").css('visibility', 'visible');
        }

		// 컬럼 리스트
		function fn_column_reload(sp, nm) {
  			$.ajax({
  				type : "POST",
  				async : false,
  				url : "<%=RequestMappingConstants.WEB_MNG_COLUMN_COMMENT_LIST%>",
  				dataType : "json",
  				data : {
  					space: sp,
  					nm: nm
  				},
  				error : function(response, status, xhr){
  					if(xhr.status =='403'){
  						alert('선택하신 테이블의 상세 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
  					}
  				},
  				success : function(data) {
  					$('#columnEditRow > tbody > tr').remove();
  					if(data.result == "Y" && data.columnInfo.length > 0) {
						for(i=0; i<data.columnInfo.length;i++)
						{
		   			       var row = 	"  	<tr>" +
							            "    	 <td>" + data.columnInfo[i].column_seq + "</td>" +
							            "        <td style='text-align: left;' name='t_column_nm' id='t_column_nm'>" + data.columnInfo[i].column_nm + "</td>" +
							            "        <td><input class='form-control required' name='t_column_comment' id='t_column_comment'  type='text' maxlength='100' title='코멘트' value='" + data.columnInfo[i].column_comment+ "' /></td>" +
							            "        <td style='text-align: left;'>" + data.columnInfo[i].column_type +    "</td>   " +
						            	"   </tr>";
							$('#columnEditRow > tbody').append(row);
						}
  					}
  				}
  			});
		}

        // 테이블 리스트
        function fn_table_reload() {
  			$.ajax({
  				type : "POST",
  				async : false,
  				url : "<%=RequestMappingConstants.WEB_MNG_TABLE_COMMENT_LIST%>",
  				dataType : "json",
  				data : {
  					gis_yn: $('#s_serch_table_gis_yn').val(),
  					space: $('#s_serch_table_space').val(),
  					nm: $('#s_serch_table_nm').val()
  				},
  				error : function(response, status, xhr){
  					if(xhr.status =='403'){
  						alert('데이블 목록 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
  					}
  				},
  				success : function(data) {
					defaultData1 = [];
					var item = {};

					for(i=0; i<data.tableInfo.length;i++)
					{
						item =  {
					             	//text: '<span class="ellipsis" title="' + data.tableInfo[i].table_nm + '"><font color="#ff9900">[' + data.tableInfo[i].no.toString().padStart(3, '0') + ']</font> <font color="#00AA40">' + data.tableInfo[i].table_nm + '</font></span>',
					             	text: '<font color="#ff9900">[' + data.tableInfo[i].no.toString().padStart(3, '0') + ']</font> <font color="#00AA40">'+ data.tableInfo[i].table_nm + '</font>' ,
					             	href: '#',
					             	tags: [ data.tableInfo[i].table_schema_nm+ '#' +
					             	        data.tableInfo[i].table_nm+ '#' +
					             	        data.tableInfo[i].table_comment+ '#' +
											data.tableInfo[i].geom_column_nm+ '#' +
											data.tableInfo[i].geom_srid+ '#' +
											data.tableInfo[i].geom_type ]
					           	};
						defaultData1.push(item);
					}
					$("#tableListCount").text(data.tableInfo.length);

					$('#tableTreeView').empty();
					$('#tableTreeView').treeview({
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
			            showIcon:false,
			            showCheckbox:false,
			            showTags:false,
			            highlightSelected:true,
			            highlightSearchResults:true,
			            multiSelect:false
			    	});
					$('#tableTreeView').on('nodeSelected', fn_table_node_selected);
  				}
  			});
        }

 		// 테이블 수정
        $('#btnTableEdit').click(function(e) {
        	if($('#btnTableEdit').text() == '수정')
        	{
		        $('#tableEditForm *').filter(':input').each(function(){
		        	$(this).attr("readonly", false);
		        });
				$("#btnTableEditCancel").css('visibility', 'visible');

				$('#btnTableEdit').text('저장');
        	}
        	else
        	{
				// 저장
	  			$.ajax({
	  				type : "POST",
	  				async : false,
	  				url : "<%=RequestMappingConstants.WEB_MNG_TABLE_COMMENT_EDIT%>",
	  				dataType : "json",
	  				data : {
	  					space: $("#t_table_space").val(),
	  					nm: $('#t_table_nm').text(),
	  					comment: $('#t_table_comment').val()
	  				},
	  				error : function(response, status, xhr){
	  					if(xhr.status =='403'){
	  						alert('선택하신 테이블 수정 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
	  					}
	  				},
	  				success : function(data) {
	  					if(data.result == "Y") {
	  						fn_table_reload();
	  					}
	  				}
	  			});

				// 초기화
				$('#tableEditForm *').filter(':input').each(function(){
			        	$(this).attr("readonly", true);
			    });
				$("#btnTableEditCancel").css('visibility', 'hidden');

        		$('#btnTableEdit').text('수정');
        	}
        });

		// 테이블 수정 - 취소
		$('#btnTableEditCancel').click(function(e) {
			$('#tableEditForm *').filter(':input').each(function(){
	        	$(this).attr("readonly", true);
		    });
			$("#btnTableEditCancel").css('visibility', 'hidden');

			$('#btnTableEdit').text('수정');
		});

		$('#btnTableEditCancel').trigger("click");


 		// 컬럼 수정
        $('#btnColumnEdit').click(function(e) {
        	if($('#btnColumnEdit').text() == '수정')
        	{
		        $('#columnEditForm *').filter(':input').each(function(){
		        	$(this).attr("readonly", false);
		        });
				$("#btnColumnEditCancel").css('visibility', 'visible');

				$('#btnColumnEdit').text('저장');
        	}
        	else
        	{
				// 저장
				var sendData = [];
				$('#columnEditRow > tbody > tr').each(function(index, tr) {
					var _nm = $(tr).find('#t_column_nm').text();
					var _comment = $(tr).children().find('input[name="t_column_comment"]').val();

					if(_nm != undefined)
						sendData.push({column_nm: _nm, column_comment: _comment});
				});
				//console.log(sendData);
				//return;

	  			$.ajax({
	  				type : "POST",
	  				async : false,
	  				url : "<%=RequestMappingConstants.WEB_MNG_COLUMN_COMMENT_EDIT%>",
	  				dataType : "json",
	  				data : {
	  					space: $("#t_table_space").val(),
	  					nm: $('#t_table_nm').text(),
	  					column_data: JSON.stringify(sendData)
	  				},
	  				error : function(response, status, xhr){
	  					if(xhr.status =='403'){
	  						alert('선택하신 컬럼 수정 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
	  					}
	  				},
	  				success : function(data) {
	  					if(data.result == "Y") {
	  						fn_column_reload($('#t_table_nm').text());
	  					}
	  				}
	  			});

				// 초기화
				$('#columnEditForm *').filter(':input').each(function(){
			        	$(this).attr("readonly", true);
			    });
				$("#btnColumnEditCancel").css('visibility', 'hidden');

        		$('#btnColumnEdit').text('수정');
        	}
        });

		// 컬럼 수정 - 취소
		$('#btnColumnEditCancel').click(function(e) {
			$('#columnEditForm *').filter(':input').each(function(){
	        	$(this).attr("readonly", true);
		    });
			$("#btnColumnEditCancel").css('visibility', 'hidden');

			$('#btnColumnEdit').text('수정');
		});

		$('#btnColumnEditCancel').trigger("click");


		// 검색어 엔터 이벤트
	    $("#s_serch_table_nm").keydown(function( event ) {
			if ( event.which == 13 ) {
				fn_table_reload();
			 	return;
			}
	    });

	    // 검색 버튼 클릭
		$('#btnSearch').click(function(){
			fn_table_reload();
		});

		// 검색 초기화 버튼 클릭
		$('#btnReset').click(function(){
			$("select[name=s_serch_table_gis_yn]").val("");
			$("select[name=s_serch_table_space]").val("");
			$("input[name=s_serch_table_nm]").val("");
		});

		// 테이블 스페이스 로딩
		$.ajax({
			type : "POST",
			async : false,
			url : "<%= RequestMappingConstants.WEB_MNG_TABLE_SPACE_LIST %>",
			dataType : "json",
			data : { },
			error : function(response, status, xhr){
				if(xhr.status =='403'){
					alert('데이터 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
				}
			},
			success : function(data) {
		        if(data.result == "Y") {
		        	$("#s_serch_table_space").find("option").remove();
		        	$("#s_serch_table_space").append('<option value=>전체</option>');
		        	for(var i=0; i<data.spaceInfo.length; i++){
		        		$("#s_serch_table_space").append("<option value='" + data.spaceInfo[i].schemaname + "'>" + data.spaceInfo[i].schemaname + "</option>");
	                }

		        	// 테이블 목록 로딩
		        	fn_table_reload();
		        }
			}
		});

    });
	</script>

	<div class="contWrap">
        <h1>${sesMenuNavigation.progrm_nm}</h1>
        <div class="whiteCont">
        	<p class="pageNav">
                <a href="<%=RequestMappingConstants.WEB_MAIN%>">HOME</a> &nbsp;&nbsp; |  &nbsp;&nbsp;  <a href="<%=RequestMappingConstants.WEB_MNG_USER%>">${sesMenuNavigation.p_progrm_nm}</a>  &nbsp;&nbsp;  |  &nbsp;&nbsp;  	${sesMenuNavigation.progrm_nm}
            </p>
            
            <!-- Code Detail Page-Body -->
	        <div class="row hei_100" id="tableEdit" style='display: block;'>
	        	<div class="col-sm-12 hei_100">
	            	<div class="card-box big-card-box last table-responsive searchResult hei_100" style= "padding-bottom: 0px;">

	                    <div class="sysstat-wrap">

							<div class="form-group">
	                        <form id="tableListForm" name="tableListForm" class="form-horizontal">
		                        <h5 class="header-title m-t-0 m-b-20"><b>검색 조건</b></h5>
							    <div class="row">
		                           	<div class="col-md-10">
		                            	<div class="form-group">
		                                     <label for="s_serch_table_space" class="col-md-1 control-label" style="font-size: 11.5pt;">테이블영역</label>
		                                     <div class="col-md-3">
		                                         <select class="form-control" id="s_serch_table_space" name="s_serch_table_space" title ="테이블스페이스">
		                                         	<option value="">전체</option>
		                                         </select>
		                                     </div>
		                                     <label for="s_serch_table_gis_yn" class="col-md-1 control-label" style="font-size: 11.5pt;">GIS 여부</label>
		                                     <div class="col-md-3">
		                                         <select class="form-control" id="s_serch_table_gis_yn" name="s_serch_table_gis_yn" title ="승인여부">
		                                         	<option value="">전체</option>
													<option value="Y">예</option>
													<option value="N">아니요</option>
		                                         </select>
		                                     </div>
		                                     <label for="s_serch_table_nm" class="sr-only">검색어</label>
		                                     <div class="col-md-4">
		                                         <input  class="form-control" title ="검색어" id="s_serch_table_nm" name="s_serch_table_nm" placeholder="검색어를 입력하세요">
		                                     </div>
		                                </div>
		                            </div>
		                            <div class="col-md-2">
		                                <button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnSearch'>검색</button>
		                                <button type="reset" class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id='btnReset' style = "width: 64px; height: 38px; padding-left: 8px; padding-right: 8px;">초기화</button>
		                            </div>
								</div>
	                        </form>
	                        </div>

	                        <div class="row">
	                            <div class="col-sm-4">
	                                <div class="card-box">
					                    <h5 class="header-title"><b>테이블 목록</b> <span class="small">(전체 <b class="text-orange"><span id='tableListCount'>0</span></b>건)</span></h5>

                           				<div class="table-wrap m-t-30" style='height: 478px; overflow-y:auto' id='tableTreeView'></div>

	                                </div>
	                            </div>
	                            <div class="col-sm-8">
	                                <div class="card-box">

	                                    <h5 class="header-title"><b>테이블 상세</b></h5>

								        <!-- Edit Page-Body -->
								        <form class="clearfix" id="tableEditForm" name="tableEditForm">
								        <input id="t_table_space" type='hidden'>
					                    <div class="table-wrap m-t-30">
					                        <table class="table table-custom table-cen table-num text-center table-hover" >
					                        	<caption class="none">테이블 상세 테이블</caption>
					                            <colgroup>
					                            	<col style="width:20%">
				                        			<col style="width:16%">
				                        			<col style="width:16%">
				                        			<col style="width:16%">
				                        			<col style="width:16%">
				                        			<col style="width:16%">
					                            </colgroup>
					                            <tbody>
				                                	<tr>
				                                       <th scope="row">테이블명 <span class="text-danger"></span></th>
				                                       <td colspan="5" id='t_table_nm' style='text-align: left;'></td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">코멘트 <span class="text-danger">*</span></th>
				                                       <td colspan="5">
				                                       <input class="form-control required" id="t_table_comment"  type="text" maxlength="100" title="코멘트" placeholder="">
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">GIS 컬럼명</th>
				                                       <td colspan="1" id='geom_column_nm' style='text-align: left;'></td>
				                                       <th scope="row">GIS EPSG</th>
				                                       <td colspan="1" id='geom_srid' style='text-align: left;'></td>
				                                       <th scope="row">GIS 유형</th>
				                                       <td colspan="1" id='geom_type' style='text-align: left;'></td>
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
				                            	<button type="button" class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id='btnTableEditCancel' style='visibility: hidden'>취소</button>
				                            </div>
				                            <div class="col-xs-1">
												<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnTableEdit' style='visibility: hidden'>수정</button>
				                            </div>
				                        </div>

								       	<h5 class="header-title"><b>컬럼 상세</b></h5>

								        <!-- Edit Page-Body -->
								        <form class="clearfix" id="columnEditForm" name="columnEditForm">
					                    <div class="table-wrap m-t-30" style='height: 186px;  overflow-y:auto'>
					                        <table class="table table-custom table-cen table-num text-center table-hover"  id='columnEditRow'>
					                        	<caption class="none">컬럼 상세 테이블</caption>
					                            <colgroup>
					                                <col style="width:5%">
				                        			<col style="width:25%">
				                        			<col style="width:40%">
				                        			<col style="width:30%">
					                            </colgroup>
						                        <thead>
							                        <tr>
							                            <th>번호</th>
							                            <th>컬럼명</th>
							                            <th>코멘트</th>
							                            <th>데이터 타입</th>
							                        </tr>
						                        </thead>
					                            <tbody>
				                               	</tbody>
				                       		</table>
					                    </div>
					                    </form>
								       	<!-- End Edit Page-Body -->

				                        <div class="row text-right">
				                            <div class="col-xs-10">
				                            </div>
				                            <div class="col-xs-1">
				                            	<button type="button" class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id='btnColumnEditCancel' style='visibility: hidden'>취소</button>
				                            </div>
				                            <div class="col-xs-1">
												<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnColumnEdit' style='visibility: hidden'>수정</button>
				                            </div>
				                        </div>

	                            	</div>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </div>
			<!-- End code Detail Page-Body -->
        </div>
	</div>
