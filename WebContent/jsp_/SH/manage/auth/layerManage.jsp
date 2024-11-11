<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <meta name="description" content="SH서울주택도시공사 | 토지자원관리시스템">

    <link rel="shortcut icon" href="/jsp/SH/img/favicon.ico">

    <!-- App css -->
    <link href="/jsp/SH/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/components.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/icons.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/core.css" rel="stylesheet" type="text/css" />
    <link href="/jsp/SH/css/bootstrap-treeview.min.css" rel="stylesheet" type="text/css" />

	<link rel="stylesheet" type="text/css" href="/jsp/SH/css/ap-image-zoom.css"/>
	<link rel="stylesheet" type="text/css" href="/jsp/SH/css/ap-image-fullscreen.css"/>
	<link rel="stylesheet" type="text/css" href="/jsp/SH/css/ap-image-fullscreen-themes.css"/>

	<link rel="stylesheet" type="text/css" href="/jsp/SH/css/jquery-gallery.css"/>

    <!-- jQuery Library -->
	<script src="/jsp/SH/js/jquery.min.js"></script>
	<script src="/jsp/SH/js/jquery-ui.min.js"></script>
	<script src="/jsp/SH/js/jquery.form.min.js"></script>
	<script src="/jsp/SH/js/jquery.validate.min.js"></script>
	<script src="/jsp/SH/js/jquery.validate.extend.js"></script>
	<script src="/jsp/SH/js/moment-with-locales.min.js"></script>
	<script src="/jsp/SH/js/bootstrap.min.js"></script>
    <script src="/jsp/SH/js/bootstrap-datetimepicker.min.js"></script>
	<script src="/jsp/SH/js/bootstrap-treeview.min.js"></script>

	<script src="/jsp/SH/js/screenfull.min.js"></script>
	<script src="/jsp/SH/js/ap-image-zoom.js"></script>
	<script src="/jsp/SH/js/ap-image-fullscreen.js"></script>

	<script src="/jsp/SH/js/jquery-gallery.js"></script>

	<!-- Validate -->
	<!-- <script src="/jsp/SH/js/jquery.validate.min.js"></script> -->

	<!-- HTML5 Shiv and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->

	<title>SH | 토지자원관리시스템</title>

	<script type="text/javascript">

	// 초기화 및 이벤트 등록
	$(document).ready(function() {

		jQuery.fn.center = function () {
			this.css("position","absolute");
			this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()) + "px");
			this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()) + "px");
			return this;
		};

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

		$("input[name=manageType]").change( function() {
			var manage = $(this).val();

			$('#layerEdit').hide();
			$('#layerGroupEdit').hide();
			$('#mapngEdit').hide();
			$('#serverEdit').hide();

			if(manage == 'LAYER') $('#layerEdit').show();
			if(manage == 'GROUP') $('#layerGroupEdit').show();
			if(manage == 'MAPNG') $('#mapngEdit').show();
			if(manage == 'SERVER') $('#serverEdit').show();
		});

		$('#layerEdit').show();

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// 레이어 관련
        var defaultData2 = [
                          	{
                             	text: '등록된 데이터가 없습니다.',
                             	href: '#'  ,
                             	tags: [ '' ]
                           	}
                          ];

		function fn_file_reload(groupNo) {
  			$.ajax({
  				type : "POST",
  				async : false,
  				url : "<%=RequestMappingConstants.API_VIEWLIST%>",
  				dataType : "json",
  				data : {
  					id: groupNo
  				},
  				error : function(response, status, xhr){
  					if(xhr.status =='403'){
  						alert('파일 목록 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
  					}
  				},
  				success : function(data) {
  					if(data.result == 'Y' && data.fileInfo.length > 0) {
  						for(var i=0; i < data.fileInfo.length; i++) {
  	  						var path = "<%=RequestMappingConstants.UPLOAD_FOLDER_FOR_WEB%>" + data.fileInfo[i].save_path + data.fileInfo[i].save_name;
  	  						path = path.replace(/\\/g, '/');

  	  						// 이미지 리스트
  							$("#fileInfo").append(
  												  "<table style='width: 100%'>" +
  												  "<colgroup><col width='55%'><col width='450%'></colgroup>" +
  												  "<tbody>" +
  												  "<tr>"  +
  												  "<td>"  +
  												  "		<span class='preview'>" +
  												  "		<img src='" + path + "' style='width:130px; height:50px' alt='" + data.fileInfo[i].file_name + "'>" +
  												  "		</span>" +
  												  "</td>" +
  												  "<td>"  +
  														data.fileInfo[i].file_name + '<br>' + data.fileInfo[i].upd_dt +
												  "</td>" +
  												  "</tr>" +
  												  "<tbody>" +
  												  "</table>"
  												 );

  	  						// 확대 이미지 컨테이너
  							$("#zoom-image-container").append('<li><a href="' + path + '" data-background-color="#ccc"></a></li>');

  	  						// 슬라이드 이미지 컨테이너
  							$("#slide-image-container").append('<li><img src="' + path + '" data-background-color="#ccc"></li>');
  						}
  					}
  				}
  			});
		}

		// 리스트 선택
        function fn_layer_node_selected(event, data) {
        	if($('#btnlayerEdit').text() == '저장') {
	    		alert('현재 편집 모드 상태입니다. 취소 후 진행 가능 합니다.');
	    		return;
	    	}

        	// 폼 리셋
        	$('#layerEditForm')[0].reset();

			// 이미지 리스트
			$('#fileInfo > table').remove();

    		// 확대 이미지  컨테이너
			$('#zoom-image-container').html('');

    		// 확대 이미지  버튼
			$('#spanZoomFileWrap').hide();

    		// 슬라이드 이미지 컨테이너
			$('#slide-image-container').html('');

    		// 슬라이드 WRAP 이미지  컨테이너
			$('#slide-image-container-wrap').hide();

    		// 슬라이드 이미지 버튼
			$('#spanSlideFileWrap').hide();

        	var desc = data.tags.toString();
        	var arrDesc = desc.split('#');

        	$("#layer_no").val(        arrDesc[0]);
        	$("#server_no").val(       arrDesc[1]);
        	$("#server_nm").val(       arrDesc[1]);
        	$("#layer_cd").val(        arrDesc[3]);
        	
        	$.ajax({
  				type : "POST",
  				async : false,
  				url : "<%=RequestMappingConstants.WEB_MNG_LAYER_TYPE_SET%>",
  				dataType : "json",
  				data : jQuery("#layerEditForm").serialize(),
  				error : function(response, status, xhr){
  					//if(xhr.status =='403'){
  						//alert('코드 정보 업데이트를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
  					//}
  				},
  				success : function(data) {
  					console.log(data.result);
  					console.log(arrDesc[4]);
  					var codenm = data.result;
  					
  					 $('#layer_cd_nm').empty();
  					
  					$.each(codenm, function(key, value){
  						$("#layer_cd_nm").append('<option value=' + value.code + '>' + value.code_nm + '</option>');
  	                });
  					$("#layer_cd_nm").val(arrDesc[3]).prop("selected", true);
  				}
  			});
        	
        	//$("#layer_cd_nm").val(     arrDesc[4]);
        	
        	$("#layer_dp_nm").val(     arrDesc[5]);
        	$("#layer_tp_nm").val(     arrDesc[6]);
        	$("#layer_desc").val(      arrDesc[7]);
        	$("#min_zoom").val(        arrDesc[8] == '' ? 8  : arrDesc[8]);
        	$("#max_zoom").val(        arrDesc[9] == '' ? 19 : arrDesc[9]);
        	$("#styles_nm").val(       decodeURIComponent(arrDesc[10]));
        	$("#paramtr").val(         arrDesc[11]);
        	$("#flter").val(           arrDesc[12]);
        	$("#prjctn").val(          arrDesc[13]);
        	$("#file_grp").val(        arrDesc[14]);
        	$("#infographic_url").val( arrDesc[15]);
        	$("#table_nm").val(        arrDesc[16]);
        	$("#use_yn").val(          arrDesc[17]);
        	$("#layer_ins_user").text(  arrDesc[18]);
        	$("#layer_ins_dt").text(    arrDesc[19]);
        	$("#layer_upd_user").text(  arrDesc[20]);
        	$("#layer_upd_dt").text(    arrDesc[21]);

        	//console.log("after ", decodeURIComponent(arrDesc[10]));

        	if(arrDesc[14] != '') {
        		// 이미지 로딩
        		fn_file_reload(arrDesc[14]);

        		// 이미지 확대
				$("#spanZoomFileWrap").show();

        		// 이미지 슬라이드
				$("#spanSlideFileWrap").show();
        	}

	        $('#layerEditForm *').filter(':input').each(function(){
	        	$(this).attr("readonly", true);
	        });
			$("#btnlayerEdit").css('visibility', 'visible');
			$("#btnlayerDescEdit").css('visibility', 'visible');
        }

        // 리스트
        function fn_layer_reload() {
  			$.ajax({
  				type : "POST",
  				async : false,
  				url : "<%=RequestMappingConstants.WEB_MNG_LAYER_LIST%>",
  				dataType : "json",
  				data : '',
  				error : function(response, status, xhr){
  					if(xhr.status =='403'){
  						alert('레이어 목록 요청이  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
  					}
  				},
  				success : function(data) {
					defaultData2 = [];
					var item = {};

					for(i=0; i<data.layerInfo.length;i++)
					{
						//console.log("before", data.layerInfo[i].styles_nm);
						//console.log("after ", encodeURIComponent(data.layerInfo[i].styles_nm));

						item =  {
					             	text: '<font color="#ff9900">[' + data.layerInfo[i].no.toString().padStart(2, '0') + ']</font> <font color="#00AA40">'+ data.layerInfo[i].layer_dp_nm + '</font>' ,
					             	href: '#'  ,
		                         	tags: [ data.layerInfo[i].layer_no+ '#' +
											data.layerInfo[i].server_no+ '#' +
											data.layerInfo[i].server_nm+ '#' +
											data.layerInfo[i].layer_cd+ '#' +
											data.layerInfo[i].layer_cd_nm+ '#' +
											data.layerInfo[i].layer_dp_nm+ '#' +
											data.layerInfo[i].layer_tp_nm+ '#' +
											data.layerInfo[i].layer_desc+ '#' +
											data.layerInfo[i].min_zoom+ '#' +
											data.layerInfo[i].max_zoom+ '#' +
											encodeURIComponent(data.layerInfo[i].styles_nm)+ '#' +
											data.layerInfo[i].paramtr+ '#' +
											data.layerInfo[i].flter+ '#' +
											data.layerInfo[i].prjctn+ '#' +
											data.layerInfo[i].file_grp+ '#' +
											data.layerInfo[i].infographic_url+ '#' +
											data.layerInfo[i].table_nm+ '#' +
											data.layerInfo[i].use_yn+ '#' +
						             	    data.layerInfo[i].ins_user+ '#' +
						             	    data.layerInfo[i].ins_dt+ '#' +
						             	    data.layerInfo[i].upd_user+ '#' +
						             	    data.layerInfo[i].upd_dt ]
					           	};
						defaultData2.push(item);
					}
					$("span[name*='layerListCount']").text(data.layerInfo.length);

					$('#layerTreeView').empty();
					$('#layerTreeView').treeview({
			            data: defaultData2,
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
					$('#layerTreeView').on('nodeSelected', fn_layer_node_selected);

					$('#mapngLayerTreeView').empty();
					$('#mapngLayerTreeView').treeview({
			            data: defaultData2,
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
					//$('#mapngLayerTreeView').on('nodeSelected', fn_layer_node_selected);
  				}
  			});
        }

        fn_layer_reload();
		
        
        
        $('#FileDelete').click(function(e) {
        	console.log('파일 삭제 진입')
        	if(confirm('이미지를 삭제하시겠습니까?') === true){
        	$.ajax({
			    type : "POST",
			    async : false,
			    url : "<%=RequestMappingConstants.WEB_MNG_LAYER_FILE_DELETE%>",
			    dataType : "json",
			    data : jQuery("#layerEditForm").serialize(),
  				error : function(response, status, xhr){
  					if(xhr.status =='403'){
  						alert('레이어 정보 업데이트를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
  					}
  				},
				success: function(data) {
					console.log("성공 했나요");
					// 이미지 리스트
					$('#fileInfo > table').remove();

		    		// 확대 이미지  컨테이너
					$('#zoom-image-container').html('');

		    		// 슬라이드 이미지 컨테이너
					$('#slide-image-container').html('');

					// 레이어 인포그래픽 파일 화면 표출
					fn_file_reload(groupNo);
				}
			});
        	}
        });
        
        
        
 		// 수정 - 저장
        $('#btnlayerEdit').click(function(e) {
        	

        	if($('#btnlayerEdit').text() == '수정')
        	{
		        $('#layerEditForm *').filter(':input').each(function(){
		        	$(this).attr("readonly", false);
		        });
				$("#btnlayerEditCancel").css('visibility', 'visible');
				$("#spanEditFileWrap").show();
				$("#FileDelete").show();

				$('#btnlayerEdit').text('저장');
        	}
        	else
        	{
				// 저장
				{
					$('#layer_cd').val($('#layer_cd_nm').val());
		  			$.ajax({
		  				type : "POST",
		  				async : false,
		  				url : "<%=RequestMappingConstants.WEB_MNG_LAYER_EDIT%>",
		  				dataType : "json",
		  				data : jQuery("#layerEditForm").serialize(),
		  				error : function(response, status, xhr){
		  					if(xhr.status =='403'){
		  						alert('레이어 정보 업데이트를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
		  					}
		  				},
		  				success : function(data) {
		  					if(data.result == 'Y') {
		  						fn_layer_reload();

		  						alert('레이어 정보가  정상적으로 수정되었습니다.');
		  					}
		  				}
		  			});
				}

				// 초기화
				$('#layerEditForm *').filter(':input').each(function(){
			        	$(this).attr("readonly", true);
			    });
				$("#btnlayerEditCancel").css('visibility', 'hidden');
				$("#spanEditFileWrap").hide();
				
        		$('#btnlayerEdit').text('수정');
        		window.location.reload();
        	}
        });

		// 수정 - 취소
		$('#btnlayerEditCancel').click(function(e) {
			$('#layerEditForm *').filter(':input').each(function(){
	        	$(this).attr("readonly", true);
		    });
			$("#btnlayerEditCancel").css('visibility', 'hidden');
			$("#spanEditFileWrap").hide();
			$("#FileDelete").hide();

			$('#btnlayerEdit').text('수정');
		});

		$('#btnlayerEditCancel').trigger("click");

		// 첨부 파일 관리
		$('#spanEditFile').click(function(e) {
			$('#fileAdd').show()
			$('#fileAdd').center();
		});
		
		$('#new_spanEditFileWrap').click(function(e) {
			console.log('file add 진입');
			$('#new_fileAdd').show()
			$('#new_fileAdd').center();
		});

		// 이미지 확대
		$('#spanZoomFile').on('click',function(event){
			$('#zoom-image-container a').apImageFullscreen({
				lazyLoad: 'visible',
				imageZoom: {
					loadingAnimation: 'image',
					loadingAnimationData: '/jsp/SH/img/hourglass_b.png'
				}
			});

			//var pos = $(this).attr('id').split('_');
			$('#zoom-image-container a:first')
				.apImageFullscreen('option', 'enableScreenfull', $('#use-fullscreen').is(':checked'))
				.apImageFullscreen('open', 0);

			$('.apifs-close-button').on('click',function(event){
				$('.apifs-container').remove();
			});
		});

		// 이미지 슬라이드
		$('#spanSlideFile').on('click',function(event){
			$('#slide-image-container').slideshow({
				    // default: 2000
				    interval: 3000,
				    // default: 500
				    width: 1024,
				    // default: 350
				    height: 768
			});

			$('#slide-image-container-wrap').center();
			$('#slide-image-container-wrap').show();
		});

		$('#btnSlideClose').on('click',function(event){
			$('#slide-image-container-wrap').hide();
		});



        // 등록
		$('#btnlayerAdd').click(function(e) {
 					$("#layerAddForm")[0].reset();
 		        	$('#layerAdd').show();
 		        	$('#layerAdd').center();
 					$("#new_spanEditFileWrap").show();
 					
 					$.ajax({
 		  				type : "POST",
 		  				async : false,
 		  				url : "<%=RequestMappingConstants.WEB_MNG_LAYER_TYPE_SET%>",
 		  				dataType : "json",
 		  				error : function(response, status, xhr){
 		  					//if(xhr.status =='403'){
 		  						//alert('코드 정보 업데이트를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
 		  					//}
 		  				},
 		  				success : function(data) {
 		  					console.log(data.result);
 		  					var codenm = data.result;
 		  					
 		  					 $('#new_layer_cd_nm').empty();
 		  					
 		  					$.each(codenm, function(key, value){
 		  						$("#new_layer_cd_nm").append('<option value=' + value.code + '>' + value.code_nm + '</option>');
 		  	                });
 		  					$("#new_layer_cd_nm").val('CD00000010').prop("selected", true);
 		  				}
 		  			});
 					
 		        	//$("#new_p_progrm_no").val($('#progrm_no').val()).attr("selected",'selected');
 	        	
		});

		// 설명 수정
        $('#btnlayerDescEdit').click(function(e) {
  			$.ajax({
  				type : "POST",
  				async : false,
  				url : "<%=RequestMappingConstants.WEB_MNG_LAYER_DESC%>",
  				dataType : "json",
  				data : { id: $("#layer_no").val() },
  				error : function(response, status, xhr){
  					if(xhr.status =='403'){
  						alert('레이어 설명 정보 요청이 실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
  					}
  				},
  				success : function(data) {
  					if(data.result == "Y" && data.layerDesc != '' && data.layerDesc != undefined) {
  						$('#desc_no').val(data.layerDesc.desc_no);
  						$('#desc_layer_no').val(data.layerDesc.layer_no);
  						$('#desc_data_nm').val(data.layerDesc.data_nm);
  						$('#desc_data_desc').val(data.layerDesc.data_desc);
  						$('#desc_data_stdde').val(data.layerDesc.data_stdde);
  						$('#desc_data_origin').val(data.layerDesc.data_origin);
  						$('#desc_data_rm').val(data.layerDesc.data_rm);
  						$('#desc_data_upd_cycle').val(data.layerDesc.data_upd_cycle);
  						$('#desc_ins_user').text(data.layerDesc.ins_user);
  						$('#desc_upd_user').text(data.layerDesc.upd_user);
  						$('#desc_ins_dt').text(data.layerDesc.ins_dt);
  						$('#desc_upd_dt').text(data.layerDesc.upd_dt);
  					} else {
  						$('#desc_no').val('');
  						$('#desc_layer_no').val($("#layer_no").val());

  						alert('등록된 정보가 없습니다.\n\n 신규 등록 가능합니다.');
  					}

  					$('#layerDescEdit').show();
		        	$('#layerDescEdit').center();
  				}
  			});
        });

		// 설명 수정 - 저장
        $('#btnLayerDescSave').click(function(e) {
        	var desc_no = $('#desc_no').val();
        	var req_url = (desc_no == '' ? "<%=RequestMappingConstants.WEB_MNG_LAYER_DESC_ADD%>" : "<%=RequestMappingConstants.WEB_MNG_LAYER_DESC_EDIT%>");

  			$.ajax({
  				type : "POST",
  				async : false,
  				url : req_url,
  				dataType : "json",
  				data : jQuery("#layerDescEditForm").serialize(),
  				error : function(response, status, xhr){
  					if(xhr.status =='403'){
  						if(desc_no == '')
  							alert('레이어 설명 등록을  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
  						else
  							alert('레이어 설명 업데이트를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
  					}
  				},
  				success : function(data) {
  					$('#layerDescEdit').hide();
  				}
  			});
        });

        // 설명 수정 - 닫기
        $('#btnLayerDescClose').click(function(e) {
        	$("#layerDescEditForm")[0].reset();
        	$('#layerDescEdit').hide();
        });


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
					$("span[name*='groupListCount']").text(data.groupInfo.length);

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
			
		  						alert('레이어 정보가  정상적으로 수정되었습니다.');
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
	  					$('#layerGroupAdd').hide();
	  					alert('레이어 그룹이 정상적으로 추가되었습니다.');
						//window.location.reload();
						
	  				}
	  			});
			 
       });
		

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// 매핑 관련


		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// 서버 관련

        var defaultData4 = [
                          	{
                             	text: '등록된 데이터가 없습니다.',
                             	href: '#'  ,
                             	tags: [ '' ]
                           	}
                          ];

		// 리스트 선택
        function fn_server_node_selected(event, data) {
        	if($('#btnServerEdit').text() == '저장') {
	    		alert('현재 편집 모드 상태입니다. 취소 후 진행 가능 합니다.');
	    		return;
	    	}

        	var desc = data.tags.toString();
        	var arrDesc = desc.split('#');

        	$("#m_server_no").val(      arrDesc[0]);
        	$("#m_server_cd").val(      arrDesc[1]);
        	$("#m_server_nm").val(      arrDesc[2]);
        	$("#server_url").val(       arrDesc[3]);
        	$("#server_desc").val(      arrDesc[4]);
        	$("#server_user_id").val(   arrDesc[5]);
        	$("#server_user_pwd").val(  arrDesc[6]);
        	$("#server_workspace").val( arrDesc[7]);
        	$("#server_ins_user").text( arrDesc[10]);
        	$("#server_ins_dt").text(   arrDesc[11]);
        	$("#server_upd_user").text( arrDesc[12]);
        	$("#server_upd_dt").text(   arrDesc[13]);

	        $('#serverEditForm *').filter(':input').each(function(){
	        	$(this).attr("readonly", true);
	        });
			$("#btnServerEdit").css('visibility', 'visible');
        }

        // 리스트
        function fn_server_reload() {
  			$.ajax({
  				type : "POST",
  				async : false,
  				url : "<%=RequestMappingConstants.WEB_MNG_SERVER_LIST%>",
  				dataType : "json",
  				data : '',
  				error : function(response, status, xhr){
  					if(xhr.status =='403'){
  						alert('서버정보 업데이트를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
  					}
  				},
  				success : function(data) {
					defaultData4 = [];
					var item = {};
					for(i=0; i<data.serverInfo.length;i++)
					{
						item =  {
					             	text: '<font color="#ff9900">[' + data.serverInfo[i].no.toString().padStart(2, '0') + ']</font> <font color="#00AA40">'+ data.serverInfo[i].server_nm + '</font>' ,
					             	href: '#'  ,
		                         	tags: [ data.serverInfo[i].server_no + '#' +
		                         	        data.serverInfo[i].server_cd + '#' +
		                         	        data.serverInfo[i].server_nm + '#' +
		                         	       	data.serverInfo[i].server_url + '#' +
		                         	      	data.serverInfo[i].server_desc + '#' +
		                         	     	data.serverInfo[i].user_id + '#' +
		                         	    	data.serverInfo[i].user_pwd + '#' +
		                         	   		data.serverInfo[i].workspace + '#' +
		                         	  		data.serverInfo[i].server_type + '#' +
		                         	 		data.serverInfo[i].server_type_desc + '#' +
		                         			data.serverInfo[i].ins_user + '#' +
		                         			data.serverInfo[i].ins_dt + '#' +
		                         			data.serverInfo[i].upd_user + '#' +
		                         			data.serverInfo[i].upd_dt ]
					           	};
						defaultData4.push(item);
					}
					$("span[name*='serverListCount']").text(data.serverInfo.length);

					$('#serverTreeView').empty();
					$('#serverTreeView').treeview({
			            data: defaultData4,
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
					$('#serverTreeView').on('nodeSelected', fn_server_node_selected);
  				}
  			});
        }

        fn_server_reload();

 		// 수정 - 저장
        $('#btnServerEdit').click(function(e) {
        	if($('#btnServerEdit').text() == '수정')
        	{
		        $('#serverEditForm *').filter(':input').each(function(){
		        	$(this).attr("readonly", false);
		        });
				$("#btnServerEditCancel").css('visibility', 'visible');

				$('#btnServerEdit').text('저장');
        	}
        	else
        	{
				// 저장
	  			$.ajax({
	  				type : "POST",
	  				async : false,
	  				url : "<%=RequestMappingConstants.WEB_MNG_SERVER_EDIT%>",
	  				dataType : "json",
	  				data : jQuery("#serverEditForm").serialize(),
	  				error : function(response, status, xhr){
	  					if(xhr.status =='403'){
	  						alert('서버정보 업데이트를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
	  					}
	  				},
	  				success : function(data) {
				        if(data.result == "Y" && data.serverInfo == "1") {
				        	fn_server_reload();
				        	alert('정보 변경이 정상적으로 완료 되었습니다.');
				        }
	  				}
	  			});

				// 초기화
				$('#serverEditForm')[0].reset();
				$('#serverEditForm *').filter(':input').each(function(){
			        	$(this).attr("readonly", true);
			    });
				$("#btnServerEditCancel").css('visibility', 'hidden');
				$("#btnServerEdit").css('visibility', 'hidden');

        		$('#btnServerEdit').text('수정');
        	}
        });

		// 수정 - 취소
		$('#btnServerEditCancel').click(function(e) {
			$('#serverEditForm *').filter(':input').each(function(){
	        	$(this).attr("readonly", true);
		    });
			$("#btnServerEditCancel").css('visibility', 'hidden');

			$('#btnServerEdit').text('수정');
		});

		$('#btnServerEditCancel').trigger("click");

		// 등록
		$('#btnServerAdd').click(function(e) {
			$('#serverAddForm')[0].reset();
			$('#serverAdd').show();
        	$('#serverAdd').center();

		});

		// 등록 - 저장
		$('#btnServerAddSave').click(function(e) {
  			$.ajax({
  				type : "POST",
  				async : false,
  				url : "<%=RequestMappingConstants.WEB_MNG_SERVER_ADD%>",
  				dataType : "json",
  				data : jQuery("#serverAddForm").serialize(),
  				error : function(response, status, xhr){
  					if(xhr.status =='403'){
  						alert('서버정보 신규 등록을  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
  					}
  				},
  				success : function(data) {
			        if(data.result == "Y" && data.serverInfo != "") {
			        	$('#serverAdd').hide();

			        	fn_server_reload();
			        	alert('서버정보가 정상적으로 등록 되었습니다.');
			        }
  				}
  			});
		});

		// 등록 - 취소
		$('#btnServerAddClose').click(function(e) {
			$('#serverAdd').hide();
		});

		$('#serverOpen').click(function(e) {
			if($('#server_url').val() != '') {
				window.open($('#server_url').val(), '_blank');
			}
		});

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// 파일 추가

		var filesAllow = ['jpg','jpeg','gif','png', 'bmp'];
		var filesTempArr = [];

		function addFiles(e) {
			//filesTempArr = [];
			//$('#fileAddRow > tbody > tr').remove();

		    var files = e.target.files;
		    var filesArr = Array.prototype.slice.call(files);
		    var filesArrLen = filesArr.length;
		    var filesTempArrLen = filesTempArr.length;
		    for(var i=0; i<filesArrLen; i++ ) {

		        var ext  = filesArr[i].name.split('.').pop().toLowerCase();
		        var msg  = ($.inArray(ext, filesAllow) == -1 ? '허용되지 않은 파일 입니다.' : '');
		        var size = Math.round(filesArr[i].size / 1024, 2)

		        if($.inArray(ext, filesAllow) == -1) {
		        	continue;
		        }

		        $("#fileAddRow > tbody").append("   <tr class='template-upload fade in'>							" +
										        "      <td>                                                         " +
										        "          <span class='preview'><img id='thumbnail"+i+"' src=''></img</span> " +
										        "      </td>                                                        " +
										        "      <td>                                                         " +
										        "          <p class='name'>" + filesArr[i].name + "</p>             " +
										        "          <strong class='error text-danger'>" + msg +"</strong>    " +
										        "      </td>                                                        " +
										        "      <td>                                                         " +
										        "          <p class='size'>" + size + "KB</p>                       " +
										        "      </td>                                                        " +
										        "  </tr>                                                            ");

		        filesTempArr.push(filesArr[i]);

		        (function(file) {
		        	var j = i;
			     	var reader = new FileReader();
			        reader.onload = function(e) {
			            //썸네일 이미지 생성
			            var tempImage = new Image(); 	//drawImage 메서드에 넣기 위해 이미지 객체화
			            tempImage.src = e.target.result; 	//data-uri를 이미지 객체에 주입
			            tempImage.onload = function () {
			            	 //리사이즈를 위해 캔버스 객체 생성
			                var canvas = document.createElement('canvas');
			                var canvasContext = canvas.getContext("2d");

			                //캔버스 크기 설정
			                canvas.width = 100; //가로 100px
			                canvas.height = 50; //세로 100px

			                //이미지를 캔버스에 그리기
			                canvasContext.drawImage(this, 0, 0, 100, 50);

			                //캔버스에 그린 이미지를 다시 data-uri 형태로 변환
			                dataURI = canvas.toDataURL("image/jpeg");

			                //썸네일 이미지 보여주기
			                document.querySelector('#thumbnail' + j).src = dataURI;
			            };
			        };

			        reader.readAsDataURL(file);
		        })(filesArr[i]);
		    };

		    $(this).val('');
		}
		
		// 이벤트 트리거
		$("#spanAddFile").click(function() {
			  $("#inputAddFile").trigger('click');
		});
		

		// 이벤트 등록
		$("#inputAddFile").on("change", addFiles);
		
		$("#btnFileDelete").click(function(e) {
			$('#fileAddRow > tbody > tr').remove();
			$("#fileAddForm")[0].reset();
			filesTempArr = [];
		});

		$("#btnFileAddSave").click(function(e) {
			if($("#layer_no").val() != '') {
				var formData = new FormData();
				for(var i=0, filesTempArrLen = filesTempArr.length; i<filesTempArrLen; i++) {
				   formData.append("files", filesTempArr[i]);
				}

				$.ajax({
				    type : "POST",
				    url : "<%=RequestMappingConstants.API_UPLOAD%>",
				    data : formData,
				    processData: false,
				    contentType: false,
	  				error : function(response, status, xhr){
	  					if(xhr.status =='403'){
	  						alert('인포그래픽 정보 업데이트를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
	  					}
	  				},
					success: function(data) {
						// 레이어 인포그래픽 데이터 저장
						if(data.result == 'Y' && data.groupInfo != '') {
							var groupNo = data.groupInfo;
							$.ajax({
							    type : "POST",
							    async : false,
							    url : "<%=RequestMappingConstants.WEB_MNG_LAYER_INFOG_EDIT%>",
							    dataType : "json",
							    data : {
							    	id: $("#layer_no").val(),
							    	file_grp: data.groupInfo
							    },
				  				error : function(response, status, xhr){
				  					if(xhr.status =='403'){
				  						alert('레이어 정보 업데이트를  실패 했습니다.\n\n관리자에게 문의하시길 바랍니다.');
				  					}
				  				},
								success: function(data) {
									// 이미지 리스트
									$('#fileInfo > table').remove();

						    		// 확대 이미지  컨테이너
									$('#zoom-image-container').html('');

						    		// 슬라이드 이미지 컨테이너
									$('#slide-image-container').html('');

									// 레이어 인포그래픽 파일 화면 표출
									fn_file_reload(groupNo);
								}
							});
						}

						$("#btnFileAddCancel").trigger('click');
					},
				});
			}
        });
		
		$("#btnAddSave").click(function(e) {
			$('#new_layer_cd').val($('#new_layer_cd_nm').val());
			 $.ajax({
	  				type : "POST",
	  				async : false,
	  				url : "<%=RequestMappingConstants.WEB_MNG_LAYER_ADD%>",
	  				dataType : "json",
	  				data : jQuery("#layerAddForm").serialize(),
	  				success : function(data) {
	  					console.log(data);
	  					$('#layerAdd').hide();
	  					alert('레이어가 정상적으로 추가되었습니다.');
						window.location.reload();
						
	  				}
	  			});
			
		});
		
		

		$("#btnFileAddCancel").click(function(e) {
			$('#fileAddRow > tbody > tr').remove();
        	$("#fileAddForm")[0].reset();
        	filesTempArr = [];
        	$('#fileAdd').hide();
		});
		
		$("#btnAddCancel").click(function(e) {
        	$('#layerAdd').hide();
		});
		
		$("#btnlayerDelete").click(function(e) {
			$.ajax({
  				type : "POST",
  				async : false,
  				url : "<%=RequestMappingConstants.WEB_MNG_LAYER_DELETE%>",
  				dataType : "json",
  				data : jQuery("#layerEditForm").serialize(),
  				success : function(data) {
  					console.log(data);
  					alert('레이어가 정상적으로 삭제되었습니다.');
					window.location.reload();
					
  				}
  			});
		});
		
    });
	</script>

</head>
<body>

	<%-- <c:import url="/web/admin_header.do"></c:import> --%>
	<c:import url="<%= RequestMappingConstants.WEB_MAIN_HEADER %>"></c:import>

	<div class="wrapper">
	    <div class="container">

	        <!-- Page-Title -->
	        <div class="row">
	            <div class="col-sm-12">
	                <div class="page-title-box">
	                    <div class="btn-group pull-right">
	                        <ol class="breadcrumb hide-phone p-0 m-0">
	                            <li>
	                                <a href="<%=RequestMappingConstants.WEB_MAIN%>">HOME</a>
	                            </li>
	                            <li>
	                                <a href="<%=RequestMappingConstants.WEB_MNG_USER%>">${sesMenuNavigation.p_progrm_nm}</a>
	                            </li>
	                            <li class="active">
	                              	${sesMenuNavigation.progrm_nm}
	                            </li>
	                        </ol>
	                    </div>
	                    <h4 class="page-title">${sesMenuNavigation.progrm_nm}</h4>
	                </div>
	            </div>
	        </div>
	        <!-- End Page-Title -->

	        <!-- Page-Select -->
	        <div class="row">
	            <div class="col-sm-12">
	                    <div class="btn-group pull-right">
	                            <input type="radio" name="manageType" id="manageType" value="LAYER" checked><label for="">&nbsp;&nbsp;레이어 관리&nbsp;&nbsp;&nbsp;</label>
	                            <input type="radio" name="manageType" id="manageType" value="GROUP"><label for="">&nbsp;&nbsp;레이어 그룹 관리&nbsp;&nbsp;&nbsp;</label>
	                            <input type="radio" name="manageType" id="manageType" value="MAPNG"><label for="">&nbsp;&nbsp;그룹-레이어 매핑 관리&nbsp;&nbsp;</label>
	                            <input type="radio" name="manageType" id="manageType" value="SERVER"><label for="">&nbsp;&nbsp;지도 서버 관리&nbsp;&nbsp;</label>
	                    </div>
	            </div>
	        </div>
	        <!-- End Page-Select -->


			<!-- Layer Detail Page-Body -->
	        <div class="row" id="layerEdit" style='display: none;'>
	        	<div class="col-sm-12">
	            	<div class="card-box big-card-box last table-responsive searchResult">

	                    <div class="sysstat-wrap m-t-30 m-b-30">

	                        <div class="row">
	                            <div class="col-sm-4">
	                                <div class="card-box">
					                    <h5 class="header-title"><b>레이어 목록</b> <span class="small">(전체 <b class="text-orange"><span name='layerListCount'>0</span></b>건)</span></h5>

                           				<div class="table-wrap m-t-30" style='height: 740px; overflow-y: auto' id='layerTreeView'></div>

	                                </div>
	                            </div>
	                            <div class="col-sm-8">
	                                <div class="card-box">
	                                    <h5 class="header-title"><b>레이어 상세</b></h5>

								        <!-- Edit Page-Body -->
								        <form class="clearfix" id="layerEditForm" name="layerEditForm">
								        <input class="form-control required" name="layer_no" id="layer_no"  type="hidden" maxlength="20" title="레이어 NO." placeholder="" />
					                    <div class="table-wrap m-t-30">
					                        <table class="table table-custom table-cen table-num text-center table-hover" width="100%">
					                            <colgroup>
					                            	<col width="20%">
					                                <col width="30%">
					                                <col width="20%">
					                                <col width="30%">
					                            </colgroup>
					                            <tbody>
				                                   	<tr>
				                                       <th scope="row">표출명 <span class="text-danger"></span></th>
				                                       <td>
				                                       <input class="form-control required" name="layer_dp_nm" id="layer_dp_nm"  type="text" maxlength="100" title="표출명" placeholder="" />
				                                       </td>
				                                       <th scope="row">물리명 <span class="text-danger"></span></th>
				                                       <td>
				                                       <input class="form-control required" name="layer_tp_nm" id="layer_tp_nm"  type="text" maxlength="100" title="물리명" placeholder="" />
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">확대 최소 <span class="text-danger"></span></th>
				                                       <td>
				                                       <!-- <input class="form-control required" name="min_zoom" id="min_zoom"  type="text" maxlength="10" title="확대 최소" placeholder="" /> -->
													   <select name="min_zoom" id="min_zoom" class="form-control col-md-3 input-sm">
														   <option value=""></option>
														   <option value="8">8</option>
											        	   <option value='9'>9</option>
											               <option value='10'>10</option>
														   <option value="11">11</option>
											        	   <option value='12'>12</option>
											               <option value='13'>13</option>
														   <option value="14">14</option>
											        	   <option value='15'>15</option>
											               <option value='16'>16</option>
														   <option value="17">17</option>
											        	   <option value='18'>18</option>
											               <option value='19'>19</option>
											    	   </select>
				                                       </td>
				                                       <th scope="row">확대 최대 <span class="text-danger"></span></th>
				                                       <td>
				                                       <!-- <input class="form-control required" name="max_zoom" id="max_zoom"  type="text" maxlength="10" title="확대 최대" placeholder="" /> -->
													   <select name="max_zoom" id="max_zoom" class="form-control col-md-3 input-sm">
													   	   <option value=""></option>
														   <option value="8">8</option>
											        	   <option value='9'>9</option>
											               <option value='10'>10</option>
														   <option value="11">11</option>
											        	   <option value='12'>12</option>
											               <option value='13'>13</option>
														   <option value="14">14</option>
											        	   <option value='15'>15</option>
											               <option value='16'>16</option>
														   <option value="17">17</option>
											        	   <option value='18'>18</option>
											               <option value='19'>19</option>
											    	   </select>
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">레이어 유형 <span class="text-danger"></span></th>
				                                       <td>
				                                       <input class="form-control required" name="layer_cd" id="layer_cd"  type="hidden" maxlength="10" title="레이어 유형" placeholder="" />
				                                        <select name="layer_cd_nm" id="layer_cd_nm" class="form-control col-md-3 input-sm">
													   		<option value=""></option>
													   	</select>
				                                       </td>
				                                       <th scope="row">서버명 <span class="text-danger"></span></th>
				                                       <td>
				                                       <input class="form-control required" name="server_no" id="server_no"  type="hidden" maxlength="20" title="서버 NO." placeholder="" />
													   <select name="server_nm" id="server_nm" class="form-control col-md-3 input-sm">
													   		<option value=""></option>
													    <c:choose>
														<c:when test="${!empty serverList}">
															<c:forEach items="${serverList}" var="result" varStatus="status">
															<option value="${result.server_no}">${result.server_nm}</option>
															</c:forEach>
														</c:when>
														</c:choose>
													   </select>
				                                       </td>
				                                   	</tr>
													<tr>
													    <th scope="row">사용여부</th>
													    <td>
															<select name="use_yn" id="use_yn" class="form-control col-md-3 input-sm">
																<option value=""></option>
													        	<option value='Y'>사용</option>
													        	<option value='N'>미사용</option>
													    	</select>
													    </td>
				                                       <th scope="row">레이어 스타일명 <span class="text-danger"></span></th>
				                                       <td>
				                                       <textarea class="form-control required" name="styles_nm" id="styles_nm"  type="text" maxlength="512" title="레이어 스타일명" placeholder=""></textarea>
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">파라메터 <span class="text-danger"></span></th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="paramtr" id="paramtr"  type="text" maxlength="512" title="물리명" placeholder="" />
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">필터 <span class="text-danger"></span></th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="flter" id="flter"  type="text" maxlength="512" title="물리명" placeholder="" />
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">투영 EPSG NO. <span class="text-danger"></span></th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="prjctn" id="prjctn"  type="text" maxlength="512" title="투영 NO." placeholder="" />
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">인포그래픽 이미지 <span class="text-danger"></span>
				                                       <input class="form-control required" name="file_grp" id="file_grp"  type="hidden" />
				                                       </th>
				                                       <td colspan="2" id='fileInfo'>
				                                       </td>
				                                       <td>
															<span class="btn btn-success fileinput-button" id='spanEditFileWrap' style='display: none'>
												              <i class="glyphicon glyphicon-plus"></i>
												              <span id='spanEditFile'>파일선택</span>
												            </span>
															<span class="btn btn-primary start" id='spanZoomFileWrap' style='display: none'>
												              <i class="glyphicon glyphicon-ban-circle"></i>
												              <span id='spanZoomFile'>파일확대</span>
												            </span>
															<span class="btn btn-warning cancel" id='spanSlideFileWrap' style='display: none'>
												              <i class="glyphicon glyphicon-upload"></i>
												              <span id='spanSlideFile'>슬라이드</span>
												            </span>
												            <button type="button" class="btn btn-danger delete" id="FileDelete" style ='display:none; width: 100.8px; height: 33px;'>
												              <i class="glyphicon glyphicon-trash"></i>
												              <span>파일삭제</span>
												            </button>
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">인포그래픽 URL <span class="text-danger"></span></th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="infographic_url" id="infographic_url"  type="text" maxlength="512" title="투영 NO." placeholder="" />
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">테이블명 <span class="text-danger"></span></th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="table_nm" id="table_nm"  type="text" maxlength="100" title="테이블명" placeholder="" />
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">등록자</th>
				                                       <td id="layer_ins_user"></td>
				                                       <th scope="row">등록일시</th>
				                                       <td id="layer_ins_dt"></td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">수정자</th>
				                                       <td id="layer_upd_user"></td>
				                                       <th scope="row">수정일시</th>
				                                       <td id="layer_upd_dt"></td>
				                                   	</tr>
				                                   	<tr>
					                                    <th scope="row">설명 <span class="text-danger"></span></th>
					                                    <td colspan="3">
					                                    	<textarea name="layer_desc" id="layer_desc" rows="4" cols="60" class="form-control" title="설명" placeholder=""  style="resize: none;"></textarea>
					                                	</td>
				                                  	</tr>
				                               	</tbody>
				                       		</table>
					                    </div>
					                    </form>
								       	<!-- End Edit Page-Body -->

				                        <div class="row text-right">
				                            <div class="col-xs-8">
				                            </div>
				                            <div class="col-xs-1">
				                            	<button type="button" class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id='btnlayerEditCancel' style='visibility: hidden'>취소</button>
				                            </div>
				                            <div class="col-xs-1">
												<button type="button" class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id='btnlayerDelete' >삭제</button>
				                            </div>
				                            <div class="col-xs-1">
												<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnlayerEdit' style='visibility: hidden'>수정</button>
				                            </div>
				                            <div class="col-xs-2">
				                            	<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnlayerDescEdit' style='visibility: hidden'>레이어설명</button>
				                            </div>
				                        </div>

	                            	</div>
	                            </div>
	                        </div>

	                        <div class="row text-right">
	                            <div class="col-xs-11">
	                            </div>
	                            <div class="col-xs-1">
									<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnlayerAdd'>신규</button>
	                            </div>
	                        </div>

	                    </div>

	                </div>
	            </div>
	        </div>
			<!-- End Layer Detail Page-Body -->

			<!-- Layer Desc Detail Page-Body -->
	        <div class="row" id="layerDescEdit" style='display: none;'>
	        	<div class="col-sm-12">
	            	<div class="card-box big-card-box last table-responsive searchResult">
	                    <h5 class="header-title"><b>레이어 출처 설명</b></h5>
				        <!-- Edit Page-Body -->
				        <form class="clearfix" id="layerDescEditForm" name="layerDescEditForm">
				        <input class="form-control required" name="desc_no" id="desc_no"  type="hidden" maxlength="20" title="레이어 NO." placeholder="" />
				        <input class="form-control required" name="desc_layer_no" id="desc_layer_no"  type="hidden" maxlength="20" title="레이어 NO." placeholder="" />
	                    <div class="table-wrap m-t-30">
	                        <table class="table table-custom table-cen table-num text-center table-hover" width="100%">
	                            <colgroup>
	                            	<col width="20%">
	                                <col width="30%">
	                                <col width="20%">
	                                <col width="30%">
	                            </colgroup>
	                            <tbody>
                                   	<tr>
                                       <th scope="row">데이터명 <span class="text-danger"></span></th>
                                       <td colspan="3">
                                       <input class="form-control required" name="desc_data_nm" id="desc_data_nm"  type="text" maxlength="512" title="데이터명" placeholder="" />
                                       </td>
                                   	</tr>
                                   	<tr>
                                       <th scope="row">데이터설명 <span class="text-danger"></span></th>
                                       <td colspan="3">
                                       		<textarea name="desc_data_desc" id="desc_data_desc" rows="2" cols="20" class="form-control" title="데이터설명" placeholder=""  style="resize: none;"></textarea>
                                       </td>
                                   	</tr>
                                   	<tr>
                                       <th scope="row">데이터기준일 <span class="text-danger"></span></th>
                                       <td colspan="3">
                                       <input class="form-control required" name="desc_data_stdde" id="desc_data_stdde"  type="text" maxlength="512" title="데이터기준일" placeholder="" />
                                       </td>
                                   	</tr>
                                   	<tr>
                                       <th scope="row">데이터출처 <span class="text-danger"></span></th>
                                       <td colspan="3">
                                       <input class="form-control required" name="desc_data_origin" id="desc_data_origin"  type="text" maxlength="512" title="데이터출처" placeholder="" />
                                       </td>
                                   	</tr>
                                   	<tr>
                                       <th scope="row">데이터갱신주기<span class="text-danger"></span></th>
                                       <td colspan="3">
                                       <input class="form-control required" name="desc_data_upd_cycle" id="desc_data_upd_cycle"  type="text" maxlength="512" title="데이터갱신주기" placeholder="" />
                                       </td>
                                   	</tr>
                                   	<tr>
                                       <th scope="row">데이터비고 <span class="text-danger"></span></th>
                                       <td colspan="3">
                                       <input class="form-control required" name="desc_data_rm" id="desc_data_rm"  type="text" maxlength="512" title="데이터비고" placeholder="" />
                                       </td>
                                   	</tr>
									<tr>
	                                      <th scope="row">등록자</th>
	                                      <td id="desc_ins_user"></td>
	                                      <th scope="row">등록일시</th>
	                                      <td id="desc_ins_dt"></td>
                                  	</tr>
                                  	<tr>
	                                      <th scope="row">수정자</th>
	                                      <td id="desc_upd_user"></td>
	                                      <th scope="row">수정일시</th>
	                                      <td id="desc_upd_dt"></td>
                                  	</tr>
                              	</tbody>
                      		</table>
	                    </div>
	                    </form>
				       	<!-- End Edit Page-Body -->
	                    <div>
                           	<div class="btn-wrap pull-left">
                           		<button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id="btnLayerDescSave" type="button">저장</button>
                          	</div>
                           	<div class="btn-wrap pull-right">
                               <button class="btn btn-custom btn-md pull-right searchBtn" id="btnLayerDescClose" type="button">닫기</button>
                           	</div>
	                    </div>
	                </div>
	            </div>
	        </div>
			<!-- End Layer Desc Detail Page-Body -->


			<!-- LayerGroup Detail Page-Body -->
	        <div class="row" id="layerGroupEdit" style='display: none;'>
	        	<div class="col-sm-12">
	            	<div class="card-box big-card-box last table-responsive searchResult">

	                    <div class="sysstat-wrap m-t-30 m-b-30">

	                        <div class="row">
	                            <div class="col-sm-4">
	                                <div class="card-box">
					                    <h5 class="header-title"><b>그룹 목록</b> <span class="small">(전체 <b class="text-orange"><span name='groupListCount'>0</span></b>건)</span></h5>

                           				<div class="table-wrap m-t-30" style='height: 740px; overflow-y:auto' id='layerGroupTreeView'></div>

	                                </div>
	                            </div>
	                            <div class="col-sm-8">
	                                <div class="card-box">
	                                    <h5 class="header-title"><b>그룹 상세</b></h5>

								        <!-- Edit Page-Body -->
								        <form class="clearfix" id="layerGroupEditForm" name="layerGroupEditForm">
					                    <div class="table-wrap m-t-30">
					                        <table class="table table-custom table-cen table-num text-center table-hover" width="100%">
					                            <colgroup>
					                            	<col width="20%">
					                                <col width="30%">
					                                <col width="20%">
					                                <col width="30%">
					                            </colgroup>
					                            <tbody>
				                                	<tr>
				                                       <th scope="row">그룹 NO. <span class="text-danger">*</span></th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="grp_no" id="grp_no"  type="text" maxlength="20" title="그룹 NO." placeholder="" />
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">상위 그룹 NO. <span class="text-danger">*</span></th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="p_grp_no" id="p_grp_no"  type="text" maxlength="20" title="상위 그룹 NO." placeholder="" />
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">표출 순서</th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="grp_order" id="grp_order"  type="text" maxlength="3" title="표출 순서" placeholder="" />
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">그룹명</th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="grp_nm" id="grp_nm"  type="text" maxlength="100" title="그룹명" placeholder="" />
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
	            </div>
	        </div>
			<!-- End LayerGroup Detail Page-Body -->

			<!-- Mapping Detail Page-Body -->
	        <div class="row" id="mapngEdit" style='display: none;'>
	        	<div class="col-sm-12">
	            	<div class="card-box big-card-box last table-responsive searchResult">

	                    <div class="sysstat-wrap m-t-30 m-b-30">

	                        <div class="row">
	                            <div class="col-sm-5">
	                                <div class="card-box">
					                    <h5 class="header-title"><b>그룹 목록</b> <span class="small">(전체 <b class="text-orange"><span name='groupListCount'>0</span></b>건)</span></h5>

                           				<div class="table-wrap m-t-30" style='height: 320px; overflow-y:auto' id='mapngGroupTreeView'></div>

	                                </div>
	                                <div class="card-box">
					                    <h5 class="header-title"><b>레이어 목록</b> <span class="small">(전체 <b class="text-orange"><span name='layerListCount'>0</span></b>건)</span></h5>

                           				<div class="table-wrap m-t-30" style='height: 320px; overflow-y:auto' id='mapngLayerTreeView'></div>

	                                </div>
	                            </div>
	                            <div class="col-sm-1" style='padding-left: 40px'>
	                            	<table style='height: 900px; width:100%;'>
	                            		<tr>
	                            			<td>
				                            	<div>
				                            		<div id='mapngGroupAdd' style='cursor: pointer' title='그룹 추가'>▶</div>
				                            		<div id='mapngGroupRemove' style='cursor: pointer' title='그룹 제외'>◀</div>
				                            	</div>
				                            </td>
				                        </tr>
				                        <tr>
				                        	<td>
				                            	<div>
				                            		<div id='mapngLayerAdd' style='cursor: pointer' title='레이어 추가'>▶</div>
				                            		<div id='mapngLayerRemove' style='cursor: pointer' title='레이어 제외'>◀</div>
				                            	</div>
				                            </td>
				                    	</tr>
		                            </table>
	                            </div>
	                            <div class="col-sm-6">
	                                <div class="card-box">
					                    <h5 class="header-title"><b>매핑 목록</b> <span class="small">(전체 <b class="text-orange"><span name='mapngListCount'>0</span></b>건)</span></h5>

                           				<div class="table-wrap m-t-30" style='height: 780px; overflow-y:auto' id='mapngTreeView'></div>

	                                </div>
	                            </div>
	                        </div>
	                	</div>

	                </div>
	            </div>
	        </div>
			<!-- End Mapping Detail Page-Body -->


			<!-- Server Detail Page-Body -->
	        <div class="row" id="serverEdit" style='display: none;'>
	        	<div class="col-sm-12">
	            	<div class="card-box big-card-box last table-responsive searchResult">

	                    <div class="sysstat-wrap m-t-30 m-b-30">

	                        <div class="row">
	                            <div class="col-sm-4">
	                                <div class="card-box">
					                    <h5 class="header-title"><b>서버 목록</b> <span class="small">(전체 <b class="text-orange"><span name='serverListCount'>0</span></b>건)</span></h5>

                           				<div class="table-wrap m-t-30" style='height: 740px; overflow-y: auto' id='serverTreeView'></div>

	                                </div>
	                            </div>
	                            <div class="col-sm-8">
	                                <div class="card-box">
	                                    <h5 class="header-title"><b>서버 상세</b></h5>

								        <!-- Edit Page-Body -->
								        <form class="clearfix" id="serverEditForm" name="serverEditForm">
								        <input class="form-control required" name="m_server_no" id="m_server_no"  type="hidden" maxlength="100" title="서버 NO." placeholder="" />
					                    <div class="table-wrap m-t-30">
					                        <table class="table table-custom table-cen table-num text-center table-hover" width="100%">
					                            <colgroup>
					                            	<col width="20%">
					                                <col width="30%">
					                                <col width="20%">
					                                <col width="30%">
					                            </colgroup>
					                            <tbody>
													<tr>
				                                       <th scope="row">서버명 <span class="text-danger"></span></th>
				                                       <td>
				                                       		<input class="form-control required" name="m_server_nm" id="m_server_nm"  type="text" maxlength="100" title="서버명" placeholder="" />
				                                       </td>
													    <th scope="row">서버유형</th>
													    <td>
															<select name="m_server_cd" id="m_server_cd" class="form-control col-md-3 input-sm">
																<option value=""></option>
				                                         	<c:forEach var="item1" items="${serverType}">
				                                         		<option value="${fn:trim(item1.code)}">${fn:trim(item1.code_nm)}</option>
				                                         	</c:forEach>
				                                         	</select>
													    </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">서버 URL <span class="text-danger"></span></th>
				                                       <td colspan="2">
				                                       <input class="form-control required" name="server_url" id="server_url"  type="text" maxlength="512" title="서버 URL" placeholder="" />
				                                       </td>
				                                       <td id='serverOpen'>
				                                       	서버연결
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">서버설명 <span class="text-danger"></span></th>
				                                       <td colspan="3">
				                                       		<textarea name="server_desc" id="server_desc" rows="2" cols="20" class="form-control" title="서버설명" placeholder=""  style="resize: none;"></textarea>
				                                       </td>
				                                   	</tr>
													<tr>
				                                       <th scope="row">사용자 ID <span class="text-danger"></span></th>
				                                       <td>
				                                       		<input class="form-control required" name="server_user_id" id="server_user_id"  type="text" maxlength="32" title="사용자 ID" placeholder="" />
				                                       </td>
				                                       <th scope="row">사용자 암호 <span class="text-danger"></span></th>
				                                       <td>
				                                       		<input class="form-control required" name="server_user_pwd" id="server_user_pwd"  type="text" maxlength="64" title="사용자 암호" placeholder="" />
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">작업공간 <span class="text-danger"></span></th>
				                                       <td colspan="3">
				                                       		<input class="form-control required" name="server_workspace" id="server_workspace"  type="text" maxlength="512" title="작업공간" placeholder="" />
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">등록자</th>
				                                       <td id="server_ins_user"></td>
				                                       <th scope="row">등록일시</th>
				                                       <td id="server_ins_dt"></td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">수정자</th>
				                                       <td id="server_upd_user"></td>
				                                       <th scope="row">수정일시</th>
				                                       <td id="server_upd_dt"></td>
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
				                            	<button type="button" class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id='btnServerEditCancel' style='visibility: hidden'>취소</button>
				                            </div>
				                            <div class="col-xs-1">
												<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnServerEdit' style='visibility: hidden'>수정</button>
				                            </div>
				                        </div>

	                            	</div>
	                            </div>
	                        </div>

	                        <div class="row text-right">
	                            <div class="col-xs-10">
	                            </div>
	                            <div class="col-xs-1">
									<button type="button" class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id='btnServerAddCancel' style='visibility: hidden'>취소</button>
	                            </div>
	                            <div class="col-xs-1">
									<button type="button" class="btn btn-custom btn-md pull-right searchBtn" id='btnServerAdd'>신규</button>
	                            </div>
	                        </div>

	                    </div>

	                </div>
	            </div>
	        </div>
			<!-- End Server Detail Page-Body -->

			<!-- Server Add Page-Body -->
	        <div class="row" id="serverAdd" style='display: none;'>
	        	<div class="col-sm-12">
	            	<div class="card-box big-card-box last table-responsive searchResult">
                        <h5 class="header-title"><b>서버 신규 등록</b></h5>

				        <!-- Edit Page-Body -->
				        <form class="clearfix" id="serverAddForm" name="serverAddForm">
	                    <div class="table-wrap m-t-30">
	                        <table class="table table-custom table-cen table-num text-center table-hover" width="100%">
	                            <colgroup>
	                            	<col width="20%">
	                                <col width="30%">
	                                <col width="20%">
	                                <col width="30%">
	                            </colgroup>
	                            <tbody>
									<tr>
                                       <th scope="row">서버명 <span class="text-danger"></span></th>
                                       <td>
                                       		<input class="form-control required" name="new_server_nm" id="new_server_nm"  type="text" maxlength="100" title="서버명" placeholder="" />
                                       </td>
									    <th scope="row">서버유형</th>
									    <td>
											<select name="new_server_cd" id="new_server_cd" class="form-control col-md-3 input-sm">
												<option value=""></option>
                                         	<c:forEach var="item1" items="${serverType}">
                                         		<option value="${fn:trim(item1.code)}">${fn:trim(item1.code_nm)}</option>
                                         	</c:forEach>
                                         	</select>
									    </td>
                                   	</tr>
                                   	<tr>
                                       <th scope="row">서버 URL <span class="text-danger"></span></th>
                                       <td colspan="3">
                                       <input class="form-control required" name="new_server_url" id="new_server_url"  type="text" maxlength="512" title="서버 URL" placeholder="" />
                                       </td>
                                   	</tr>
                                   	<tr>
                                       <th scope="row">서버설명 <span class="text-danger"></span></th>
                                       <td colspan="3">
                                       		<textarea name="new_server_desc" id="new_server_desc" rows="2" cols="20" class="form-control" title="서버설명" placeholder=""  style="resize: none;"></textarea>
                                       </td>
                                   	</tr>
									<tr>
                                       <th scope="row">사용자 ID <span class="text-danger"></span></th>
                                       <td>
                                       		<input class="form-control required" name="new_user_id" id="new_user_id"  type="text" maxlength="32" title="사용자 ID" placeholder="" />
                                       </td>
                                       <th scope="row">사용자 암호 <span class="text-danger"></span></th>
                                       <td>
                                       		<input class="form-control required" name="new_user_pwd" id="new_user_pwd"  type="text" maxlength="64" title="사용자 암호" placeholder="" />
                                       </td>
                                   	</tr>
                                   	<tr>
                                       <th scope="row">작업공간 <span class="text-danger"></span></th>
                                       <td colspan="3">
                                       		<input class="form-control required" name="new_workspace" id="new_workspace"  type="text" maxlength="512" title="작업공간" placeholder="" />
                                       </td>
                                   	</tr>
                               	</tbody>
                       		</table>
	                    </div>
	                    </form>
				       	<!-- End Edit Page-Body -->
	                    <div>
                           	<div class="btn-wrap pull-left">
                           		<button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id="btnServerAddSave" type="button">저장</button>
                          	</div>
                           	<div class="btn-wrap pull-right">
                               <button class="btn btn-custom btn-md pull-right searchBtn" id="btnServerAddClose" type="button">닫기</button>
                           	</div>
	                    </div>
	                </div>
	            </div>
	        </div>
			<!-- End Server Add Page-Body -->

	        <!-- File Add & Edit Page-Body -->
		    <div class="row" id="fileAdd" style='display: none; z-index: 999;'>
		    	<div class="col-sm-12">
		    		<div class="card-box big-card-box last table-responsive searchResult">
		    			<h5 class="header-title"><b>첨부 파일</b></h5>

						<form id='fileAddForm' enctype="multipart/form-data">
		 		        	<div class="btn-wrap pull-left">
								<span class="btn btn-success fileinput-button">
					              <i class="glyphicon glyphicon-plus"></i>
					              <span id='spanAddFile'>파일 추가...</span>
					              <input id='inputAddFile' name="files" type="file" style='display: none;' maxlength="5" data-maxsize="25600" data-maxfile="5120" accept=".jpg, .jpeg, .png, .gif, .bmp" multiple />
					            </span>
								<button type="button" class="btn btn-danger delete" id="btnFileDelete" >
					              <i class="glyphicon glyphicon-trash"></i>
					              <span>파일 삭제</span>
					            </button>
				            </div>
						</form>

						<table role="presentation" class="table table-striped" id="fileAddRow" style='width:500px'>
				          <tbody class="files">
				          </tbody>
				        </table>

						<p></p>

						<div>
		                	<div class="btn-wrap pull-right">
								<button type="button" class="btn btn-primary start" id="btnFileAddSave">
					              <i class="glyphicon glyphicon-upload"></i>
					              <span>업로드</span>
					            </button>
					            <button type="reset" class="btn btn-primary cancel" id="btnFileAddCancel">
					              <i class="glyphicon glyphicon-ban-circle"></i>
					              <span>닫기</span>
					            </button>
					    	</div>
						</div>
		            </div>
		        </div>
		    </div>
		    
		    <!-- File Add & Edit Page-Body -->
		    <!-- <div class="row" id="new_fileAdd" style='display: none; z-index: 999;'>
		    	<div class="col-sm-12">
		    		<div class="card-box big-card-box last table-responsive searchResult">
		    			<h5 class="header-title"><b>첨부 파일</b></h5>

						<form id='new_fileAddForm' enctype="multipart/form-data">
		 		        	<div class="btn-wrap pull-left">
								<span class="btn btn-success fileinput-button">
					              <i class="glyphicon glyphicon-plus"></i>
					              <span id='new_spanAddFile'>파일 추가...</span>
					              <input id='new_inputAddFile' name="new_files" type="file" style='display: none;' maxlength="5" data-maxsize="25600" data-maxfile="5120" accept=".jpg, .jpeg, .png, .gif, .bmp" multiple />
					            </span>
								<button type="button" class="btn btn-danger delete" id="new_btnFileDelete" >
					              <i class="glyphicon glyphicon-trash"></i>
					              <span>파일 삭제</span>
					            </button>
				            </div>
						</form>

						<table role="presentation" class="table table-striped" id="new_fileAddRow" style='width:500px'>
				          <tbody class="files">
				          </tbody>
				        </table>

						<p></p>

						<div>
		                	<div class="btn-wrap pull-right">
								<button type="button" class="btn btn-primary start" id="new_btnFileAddSave">
					              <i class="glyphicon glyphicon-upload"></i>
					              <span>등록</span>
					            </button>
					            <button type="reset" class="btn btn-primary cancel" id="new_btnFileAddCancel">
					              <i class="glyphicon glyphicon-ban-circle"></i>
					              <span>닫기</span>
					            </button>
					    	</div>
						</div>
		            </div>
		        </div>
		    </div> -->
		    <!-- End File Add & Edit Page-Body -->

			<!-- 이미지확대 -->
			<div class="controls-container" id='zoom-image-controls-container' style='display: none;'>
				<div class="options">
					<input type="checkbox" id="use-fullscreen" name="use-fullscreen" />
					<label for="use-fullscreen">Use fullscreen</label>
				</div>
			</div>
			<ul id="zoom-image-container">
			</ul>
			<!-- 이미지확대 -->

			<!-- 이미지슬라이드 -->
			<div class="row" id='slide-image-container-wrap' style='display: none;'>
		    	<div class="col-sm-12">
		    		<div class="card-box big-card-box last table-responsive searchResult">
		    			<h5 class="header-title"><b>이미지 슬라이드</b></h5>

						<ul class="gallery-slideshow" id="slide-image-container"></ul>

	                    <div>
                           	<div class="btn-wrap pull-right">
                               <button class="btn btn-custom btn-md pull-right searchBtn" id="btnSlideClose" type="button">닫기</button>
                           	</div>
	                    </div>
					</div>
				</div>
			</div>
			
			<div class="row"  id="layerAdd" style='position: absolute; display: none;'>
	        	<div class="col-sm-10" style = "width: 800px;">
	            	<div class="card-box big-card-box last table-responsive searchResult">
						
                            <h5 class="header-title"><b>레이어 신규 등록</b></h5>

					        <form class="clearfix" id="layerAddForm" name="layerAddForm">
					       <!--  <input class="form-control required" name="new_layer_no" id="new_layer_no"  type="hidden" maxlength="20" title="레이어 NO." placeholder="" /> -->
					                    <div class="table-wrap m-t-30">
					                        <table class="table table-custom table-cen table-num text-center table-hover" width="100%">
					                            <colgroup>
					                            	<col width="20%">
					                                <col width="30%">
					                                <col width="20%">
					                                <col width="30%">
					                            </colgroup>
					                            <tbody>
				                                   	<tr>
				                                       <th scope="row">표출명 <span class="text-danger"></span></th>
				                                       <td>
				                                       <input class="form-control required" name="new_layer_dp_nm" id="new_layer_dp_nm"  type="text" maxlength="100" title="표출명" placeholder="" />
				                                       </td>
				                                       <th scope="row">물리명 <span class="text-danger"></span></th>
				                                       <td>
				                                       <input class="form-control required" name="new_layer_tp_nm" id="new_layer_tp_nm"  type="text" maxlength="100" title="물리명" placeholder="" />
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">확대 최소 <span class="text-danger"></span></th>
				                                       <td>
				                                       <!-- <input class="form-control required" name="min_zoom" id="min_zoom"  type="text" maxlength="10" title="확대 최소" placeholder="" /> -->
													   <select name="new_min_zoom" id="new_min_zoom" class="form-control col-md-3 input-sm">
														   <option value=""></option>
														   <option value="8">8</option>
											        	   <option value='9'>9</option>
											               <option value='10'>10</option>
														   <option value="11">11</option>
											        	   <option value='12'>12</option>
											               <option value='13'>13</option>
														   <option value="14">14</option>
											        	   <option value='15'>15</option>
											               <option value='16'>16</option>
														   <option value="17">17</option>
											        	   <option value='18'>18</option>
											               <option value='19'>19</option>
											    	   </select>
				                                       </td>
				                                       <th scope="row">확대 최대 <span class="text-danger"></span></th>
				                                       <td>
				                                       <!-- <input class="form-control required" name="max_zoom" id="max_zoom"  type="text" maxlength="10" title="확대 최대" placeholder="" /> -->
													   <select name="new_max_zoom" id="new_max_zoom" class="form-control col-md-3 input-sm">
													   	   <option value=""></option>
														   <option value="8">8</option>
											        	   <option value='9'>9</option>
											               <option value='10'>10</option>
														   <option value="11">11</option>
											        	   <option value='12'>12</option>
											               <option value='13'>13</option>
														   <option value="14">14</option>
											        	   <option value='15'>15</option>
											               <option value='16'>16</option>
														   <option value="17">17</option>
											        	   <option value='18'>18</option>
											               <option value='19'>19</option>
											    	   </select>
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">레이어 유형 <span class="text-danger"></span></th>
				                                       <td>
				                                       <input class="form-control required" name="new_layer_cd" id="new_layer_cd"  type="hidden" maxlength="10" title="레이어 유형" placeholder="" />
				                                       <select name="new_layer_cd_nm" id="new_layer_cd_nm" class="form-control col-md-3 input-sm">
																<option value=""></option>
													    </select>
				                                       <!-- <input class="form-control required" name="new_layer_cd_nm" id="new_layer_cd_nm"  type="text" maxlength="10" title="레이어 유형" placeholder="" /> -->
				                                       </td>
				                                       <th scope="row">서버명 <span class="text-danger"></span></th>
				                                       <td>
				                                       <!-- <input class="form-control required" name="new_server_no" id="new_server_no"  type="hidden" maxlength="20" title="서버 NO." placeholder="" /> -->
													   <select name="new_server_nm" id="new_server_nm" class="form-control col-md-3 input-sm">
													   		<option value=""></option>
													    <c:choose>
														<c:when test="${!empty serverList}">
															<c:forEach items="${serverList}" var="result" varStatus="status">
															<option value="${result.server_no}">${result.server_nm}</option>
															</c:forEach>
														</c:when>
														</c:choose>
													   </select>
				                                       </td>
				                                   	</tr>
													<tr>
													    <th scope="row">사용여부</th>
													    <td>
															<select name="new_use_yn" id="new_use_yn" class="form-control col-md-3 input-sm">
																<option value=""></option>
													        	<option value='Y'>사용</option>
													        	<option value='N'>미사용</option>
													    	</select>
													    </td>
				                                       <th scope="row">레이어 스타일명 <span class="text-danger"></span></th>
				                                       <td>
				                                       <textarea class="form-control required" name="new_styles_nm" id="new_styles_nm"  type="text" maxlength="512" title="레이어 스타일명" placeholder=""></textarea>
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">파라메터 <span class="text-danger"></span></th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="new_paramtr" id="new_paramtr"  type="text" maxlength="512" title="물리명" placeholder="" />
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">필터 <span class="text-danger"></span></th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="new_flter" id="new_flter"  type="text" maxlength="512" title="물리명" placeholder="" />
				                                       </td>
				                                   	</tr>
				                                   	<tr>
				                                       <th scope="row">투영 EPSG NO. <span class="text-danger"></span></th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="new_prjctn" id="new_prjctn"  type="text" maxlength="512" title="투영 NO." placeholder="" />
				                                       </td>
				                                   	</tr>
				                                   	<!-- <tr>
				                                       <th scope="row">인포그래픽 이미지 <span class="text-danger"></span>
				                                       <input class="form-control required" name="new_file_grp" id="new_file_grp"  type="hidden" />
				                                       </th>
				                                       <td colspan="2" id='fileInfo'>
				                                       </td>
				                                       <td>
															<span class="btn btn-success fileinput-button" id='new_spanEditFileWrap' style='display: none'>
												              <i class="glyphicon glyphicon-plus"></i>
												              <span id='new_spanEditFile'>파일선택</span>
												            </span>
															<span class="btn btn-primary start" id='new_spanZoomFileWrap' style='display: none'>
												              <i class="glyphicon glyphicon-ban-circle"></i>
												              <span id='new_spanZoomFile'>파일확대</span>
												            </span>
															<span class="btn btn-warning cancel" id='new_spanSlideFileWrap' style='display: none'>
												              <i class="glyphicon glyphicon-upload"></i>
												              <span id='new_spanSlideFile'>슬라이드</span>
												            </span>
												            <button type="button" class="btn btn-danger delete" id="new_FileDelete" style ='display:none; width: 100.8px; height: 33px;'>
												              <i class="glyphicon glyphicon-trash"></i>
												              <span>파일삭제</span>
												            </button>
				                                       </td>
				                                   	</tr> -->
				                                   <!-- 	<tr>
				                                       <th scope="row">인포그래픽 URL <span class="text-danger"></span></th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="new_infographic_url" id="new_infographic_url"  type="text" maxlength="512" title="투영 NO." placeholder="" />
				                                       </td>
				                                   	</tr> -->
				                                   	<tr>
				                                       <th scope="row">테이블명 <span class="text-danger"></span></th>
				                                       <td colspan="3">
				                                       <input class="form-control required" name="new_table_nm" id="new_table_nm"  type="text" maxlength="100" title="테이블명" placeholder="" />
				                                       </td>
				                                   	</tr>
				                                   	<tr>
					                                    <th scope="row">설명 <span class="text-danger"></span></th>
					                                    <td colspan="3">
					                                    	<textarea name="new_layer_desc" id="new_layer_desc" rows="4" cols="60" class="form-control" title="설명" placeholder=""  style="resize: none;"></textarea>
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
	                           	<button class="btn btn-custom btn-md pull-right searchBtn" id="btnAddCancel" type="button">닫기</button>
	                           	 <button class="btn btn-danger waves-effect waves-light btn-md pull-right m-r-10 resetBtn" id="btnAddSave" type="button">저장</button>
	                               
	                           	</div>
		                    </div>

	                </div>
	            </div>
	        </div>
	        <!-- Add Page-Body -->
	        <div class="row"  id="layerGroupAdd" style='position: absolute; display: none; z-index:100'>
	        	<div class="col-sm-10">
	            	<div class="card-box big-card-box last table-responsive searchResult">

                            <h5 class="header-title"><b>레이어 그룹 신규 등록</b></h5>

					        <form class="clearfix" id="layerGroupAddForm" name="layerGroupAddForm">
					        <input name="newLayerNo" id="newLayerNo"  type="hidden" />
		                    <div class="table-wrap m-t-30">
		                        <table class="table table-custom table-cen table-num text-center table-hover" width="100%">
		                            <colgroup>
		                            	<col width="25%">
		                                <col width="25%">
		                                <col width="20%">
		                                <col width="30%">
		                            </colgroup>
		                            <tbody>
	                                	<tr>
	                                       <th scope="row">그룹 NO <span class="text-danger">*</span></th>
	                                       <td colspan="3">
	                                       <input class="form-control required" name="newGroupNo" id="newGroupNo"  type="text" maxlength="100" title="순서" placeholder="" readonly/>
	                                       </td>
	                                   	</tr>
	                                	<tr>
	                                       <th scope="row">상위 그룹 NO <span class="text-danger">*</span></th>
	                                       <td colspan="3">
	                                       <select name="newParentGroupNo" id="newParentGroupNo" class="form-control col-md-3 input-sm"  >
	                                       		<option value = "">최상위 그룹</option>	
										   </select>
	                                       </td>
	                                   	</tr>
	                                   	<tr>
	                                       <th scope="row">표출순서</th>
	                                       <td colspan="3">
	                                       <select name="newGroupOrder" id="newGroupOrder" class="form-control col-md-3 input-sm" title="메뉴 여부" >
	                                       
	                                       </select>
	                                       </td>
	                                   	</tr>
										<tr>
											<th scope="row">그룹명</th>
											<td colspan = "3">
												<input class="form-control required" name="newGroupNm" id="newGroupNm"  type="text" maxlength="1024" title="CSS Style" placeholder="" />
											</td>
										</tr>
										<tr>
											<th scope="row">설명</th>
		                                    <td colspan="3">
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

	    </div>
	</div>

	<c:import url="<%= RequestMappingConstants.WEB_MAIN_FOOTER %>"></c:import>

</body>
</html>