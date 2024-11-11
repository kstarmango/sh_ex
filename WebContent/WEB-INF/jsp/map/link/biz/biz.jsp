<%@page import="egovframework.mango.config.SHResource"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form"%> 
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%> 
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>

<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.Properties" %>

<%
	String syGisURL = SHResource.getValue("sh.geoserver.url");
	String mangoServerURL = SHResource.getValue("sh.server.schema") + "://" + SHResource.getValue("sh.server.url") + "/shex";
%>

<!DOCTYPE html>
<html lang="ko">
	<style>
		.bizFeatureInfoPop{
		    position: absolute;
		    /* top: 50%; */
		    left: 50%;
		    /* transform: translate(-50%, -50%); */
		    border-radius: 8px;
		    background-color: #f7f9fb;
		    box-shadow: 0px 0px 12px 0 rgba(0, 0, 0, 0.16);
		    overflow: hidden;
		    z-index: 3;
		    bottom: 15px;
		    /* left: -50px; */
		    user-select: none;
	    }
	    .bizFeatureInfoPop .header{
		    display: flex;
		    align-items: center;
		    padding: 0.8rem 1.2rem;
		    background-color: #f5f6fa;
		    border-top: 1px solid #e0e6ec;
		    border-bottom: 1px solid #e0e6ec;
		    cursor: move;
	    }
	    .bizFeatureInfoPop .header h1{
	        font-size: 1.6rem;
		    font-weight: 500;
		    line-height: 2.4rem;
		    color: #778690;
	    }
	
	    .bizFeatureInfoPop .header .closeBtn{
    	    margin-left: auto;
    		cursor: pointer;
	    }
	    
	    .bizFeatureInfoPop .body{
	    	margin: 1.2rem;
	    }
	    .bizFeatureInfoPop .body .tableWrap{
    	    min-width: 40rem;
		    max-height: 50vh;
		    /* word-break: break-all; */
		    word-break: keep-all;
		    overflow-y: auto;
	        margin-top: -0.1rem;
		    background-color: #fff;
		    padding: 1.2rem;
		    border: 1px solid #e0e6ec;
		    border-radius: 0 0 4px 4px;
		    max-width: 42rem;
	    }
	    .bizFeatureInfoPop .body .w100Btn{
	    	boder: none;
    	    margin-top: 1.2rem;
		    width: 100%;
		    padding: 8px;
		    border-radius: 4px;
		    background: #ee9b25;
		    font-size: 1.6rem;
		    font-weight: 500;
		    text-align: center;
		    color: #fff;
	    }
	    .bizFeatureInfoPop .body .tableWrap table{
    	    padding: 0.8rem;
		    border-spacing: 0;
		    border-collapse: collapse;
		    border: 1px solid #e0e6ec;
		    font-size: 1.4rem;
		    font-weight: 400;
		    vertical-align: middle;
	    }
	    
	    .bizFeatureInfoPop .body .tableWrap table th, .bizFeatureInfoPop .body .tableWrap table td{
   	        padding: 0.8rem;
	    	border-spacing: 0;
		    border-collapse: collapse;
		    border: 1px solid #e0e6ec;
		    font-size: 1.4rem;
		    font-weight: 400;
		    vertical-align: middle;
	    }
	    .bizFeatureInfoPop .body .tableWrap table th{
	        background-color: #f7f9fb;
    		color: #778690;
	    }
	    .bizFeatureInfoPop .body .tableWrap table td{
            color: #1a1a1a;
	    }
	    .tableTab span{
	        display: inline-block;
		    font-size: 1.5rem;
		    font-weight: 500;
		    color: #778690;
		    height: 4.1rem;
		    line-height: 4rem;
		    padding: 0 1.6rem;
		    background-color: #f7f9fb;
		    border: 1px solid #e0e6ec;
		    border-radius: 4px 4px 0 0;
		    cursor: pointer;
	    }
	    .tableTab span.hover {
		    background-color: #fff;
		    border-bottom: 0;
		}
		
		.legendModal {
		    position: absolute;
		    bottom: 10.5rem;
		    right: 7rem;
		    padding: 1.2rem;
		    background-color: #fff;
		    border-radius: 4px;
		    box-shadow: 0px 0px 12px 0 rgba(0, 0, 0, 0.08);
		    z-index: 2;
		    max-height: 50rem;
		    overflow: auto;
		    transition: all 0.5s linear;
		}
		.legendModal .header {
		    margin-bottom: 0.8rem;
		    font-size: 1.4rem;
		    color: #778690;
		    font-weight: 600;
		}
		.legendModal .legendList li {
		    display: flex;
		    align-items: center;
		    font-size: 1.4rem;
		    color: #778690;
		    font-weight: 400;
		    line-height: 2.4rem;
		}
		.legendList .legendBox.biz {
		    background-color: #a5dff9;
		}
		.legendList .legendBox {
		    display: inline-block;
		    margin-right: 0.4rem;
		    width: 1.6rem;
		    height: 1.2rem;
		}
		.legendList p{
			cursor: pointer;
		}
	</style>
   <script type="text/javascript">
   
  		const mangoServer = '<%=mangoServerURL%>';
  		
   let bizData = {data: [],
   	    selected: {},
   	    dwithin: []};
   
   let bizLayer; 
   
	   let select;
	   let codeInfo;
	   
	   let logFeature;
	   
	   /* 피쳐정보 popup element */
	    let popContainer = document.querySelector('.bizFeatureInfoPop');
	    
	    /* 피쳐정보 popup overlay */
	    let popup = new ol.Overlay({
	    	id: 'biz_overlay',
	    	element: popContainer
	    });
	    
	    dragElement(popContainer);
	    /* 피쳐정보 popup 드래그 기능 추가 */
	    function dragElement(elmnt) {
	    	  var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
	    	  if (document.querySelector(".bizFeatureInfoPop .header")) {
	    	    /* if present, the header is where you move the DIV from:*/
	    	    document.querySelector(".bizFeatureInfoPop .header").onmousedown = dragMouseDown;
	    	  } else {
	    	    /* otherwise, move the DIV from anywhere inside the DIV:*/
	    	    elmnt.onmousedown = dragMouseDown;
	    	  }

	    	  function dragMouseDown(e) {
	    	    e = e || window.event;
	    	    e.preventDefault();
	    	    // get the mouse cursor position at startup:
	    	    pos3 = e.clientX;
	    	    pos4 = e.clientY;
	    	    document.onmouseup = closeDragElement;
	    	    // call a function whenever the cursor moves:
	    	    document.onmousemove = elementDrag;
	    	  }

	    	  function elementDrag(e) {
	    	    e = e || window.event;
	    	    e.preventDefault();
	    	    // calculate the new cursor position:
	    	    pos1 = pos3 - e.clientX;
	    	    pos2 = pos4 - e.clientY;
	    	    pos3 = e.clientX;
	    	    pos4 = e.clientY;
	    	    // set the element's new position:
	    	    elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
	    	    elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
	    	    elmnt.style.bottom = 'auto';
	    	  }

	    	  function closeDragElement() {
	    	    /* stop moving when mouse button is released:*/
	    	    document.onmouseup = null;
	    	    document.onmousemove = null;
	    	  }
    	}
	    
	    /* 반경거리 레이어 생성 */
        const bufferLyr = new ol.layer.Vector({
        	title: 'biz_buffer',
        	source: new ol.source.Vector({}),
       		style: (feature) => bufferStyleFunction(feature)
        });
        /* 반경거리 레이어 스타일 생성 */
        const bufferStyleFunction = (feature) => {
            const font = 'bold 13px Roboto';
            let title = '';

            if (Number(feature.get('distance')) >= 1000) {
                title = Number(feature.get('distance')) / 1000 + 'km';
            } else {
                title = feature.get('distance') + 'm';
            }

            return [
                new ol.style.Style({
                    stroke: new ol.style.Stroke({
                        color: [227, 26, 28, 0.3],
                        width: 2,
                    }),
                    text: new ol.style.Text({
                        font: font,
                        text: title,
                        fill: new ol.style.Fill({ color: '#000000' }),
                        stroke: new ol.style.Stroke({ color: '#ffffff', width: 3 }),
                        placement: 'line',
                        // offsetX: Number(feature.get('distance'))/100,
                    }),
                }),
            ];
        };

	    window.addEventListener( 'message', receiveMsgFromChild );
	    
    $(document).ready(function () {
      $('#sub_content').show();
	     // loadBizLayer(null);
    });
		const colors = [
			'rgba(255, 173, 173,0.6)', 
			'rgba(255, 214, 165,0.6)', 
			'rgba(253, 255, 182,0.6)',
			'rgba(202, 255, 191,0.6)',
			'rgba(155, 246, 255,0.6)',
			'rgba(160, 196, 255,0.6)',
			'rgba(189, 178, 255,0.6)',
			'rgba(255, 255, 252,0.6)',

		];
	  	geoMap.addOverlay(popup);
	  	
	    geoMap.addLayer(bufferLyr);
        
	    // biz layer 불러오기
	    function loadBizLayer(filter){
	    	//geoMap.addLayer();
	    	$('.legendList p')[0].style.color = '';
    	
	    	let cqlFilter = filter;
	    	let featureIdFilter = null;
    	
	    	const duplicateLyr = geoMap.getLayers().getArray().filter(l => l.get('title') === '사업기획 레이어');
	    	if(duplicateLyr.length > 0){
	    		geoMap.removeLayer(duplicateLyr[0]);
    		}
    	 
    	let typeName = 'LANDSYS:v_vpppd0b01'
	        const urlTemplate = '<%=syGisURL%>/geoserver' + '/LANDSYS/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=' + typeName + '&CQL_FILTER={{CQLFILTER}}&outputFormat=application/json&srsname=EPSG:3857';
        // const urlTemplate = 'https://shgis.syesd.co.kr/geoserver' + '/LANDSYS/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=' + typeName + '&CQL_FILTER={{CQLFILTER}}&FEATUREID={{FEATUREID}}&outputFormat=application/json&srsname=EPSG:3857';
    	
    	let url = cqlFilter ? urlTemplate.replace('{{CQLFILTER}}', cqlFilter) : urlTemplate.replace('&CQL_FILTER={{CQLFILTER}}', '');
        // url = featureIdFilter ? url.replace('{{FEATUREID}}', featureIdFilter) : url.replace('&FEATUREID={{FEATUREID}}', '');
        
    	$.ajax({
			dataType: 'json',
				url: "/api/cmmn/proxy.do?url=" + url,
			// url: 
			success: function(res) {
				

				bizLayer = new ol.layer.Vector({
					source: new ol.source.Vector({}),
					title: '사업기획 레이어',
						style: function (feature) {
							
							let color ='';
							if(isNaN(Number(feature.values_.end_ty_cd))){
								color = colors[7];
							}else{
								color = colors[Number(feature.values_.end_ty_cd-1)];
							}
							

							return new ol.style.Style({ 
								fill: new ol.style.Fill({ color : color }), 
								stroke: new ol.style.Stroke({ color: 'rgb(79, 201, 222)', width: 2 }),
								text: new ol.style.Text({
									font: 'bold 13px Roboto',
									text: feature.get('loc_addr'),
									fill: new ol.style.Fill({ color: '#000000' }),
									stroke: new ol.style.Stroke({ color: '#ffffff', width: 3 }),
								})
							});
						}
				})
				const features = new ol.format.GeoJSON().readFeatures(res);
				bizLayer.getSource().addFeatures(features);
				
				geoMap.getView().fit(bizLayer.getSource().getExtent(), geoMap.getSize());
					if(geoMap.getLayers().getArray().filter(lyr => lyr.get('title') === '사업기획 레이어').length === 0){						
				geoMap.addLayer(bizLayer);
				
				
			}
					
					for(let interaction of geoMap.getInteractions().getArray()){
						if(interaction instanceof ol.interaction.Select){
							geoMap.removeInteraction(interaction);
							break;
						}
					}
					
					select = new ol.interaction.Select({
						title: 'biz_select',
						source: bizLayer.getSource(),
						wrapX:false,
						style: function(feature){
							return new ol.style.Style({ 
								fill: new ol.style.Fill({ color : 'rgb(0, 136, 168, 0.5)' }), 
								stroke: new ol.style.Stroke({ color: 'rgb(255, 0, 0)', width: 2 }),
								text: new ol.style.Text({
		                            font: 'bold 13px Roboto',
		                            text: feature.get('loc_addr'),
		                            fill: new ol.style.Fill({ color: '#000000' }),
		                            stroke: new ol.style.Stroke({ color: '#ffffff', width: 3 }),
		                        })
							})
						}
					})
					
					select.on('select', function(e) {
						if(logFeature && e.selected[0] === logFeature.selectFeature){
							return;
						};
	
						/* select 시 tab 초기 */
						$('#tableTab01').removeClass('hover');
						$('#tableTab00').addClass('hover');

						/* 이전 feautre(검색) 있을시 초기화 */
						if(logFeature){
							const lyr = geoMap.getLayers().getArray().filter(lyr => lyr.get('title') === '사업기획 레이어');
							if(lyr.length > 0){
								lyr[0].getSource().removeFeature(logFeature.selectFeature);
								const feature = lyr[0].getSource().getFeatures().filter((feature) => feature.get('plng_biz_sn') === logFeature.beforeFeature.get('plng_biz_sn'))[0];
								feature.setStyle(new ol.style.Style({ 
										fill: new ol.style.Fill({ color : 'rgba(165,223,249,0.6)' }), 
										stroke: new ol.style.Stroke({ color: 'rgb(79, 201, 222)', width: 2 }),
										text: new ol.style.Text({
								                font: 'bold 13px Roboto',
								                text: feature.get('loc_addr'),
								                fill: new ol.style.Fill({ color: '#000000' }),
								                stroke: new ol.style.Stroke({ color: '#ffffff', width: 3 }),
							        		})
								   		})
									);
								logFeature = null;
							}
						}
						
						/* deselect 시 popup null */
						if(e.selected.length === 0){
							popup.setPosition(null);
							return;
						}
						
						/* 1개만 select */
						if(e.target.getFeatures().getArray().length >1){							
							const length = e.target.getFeatures().getArray().length;
							for(let i=length -2; i>=0; i--){
								e.target.getFeatures().remove(e.target.getFeatures().getArray()[i]);
							}
						}
						const center = e.mapBrowserEvent.coordinate;
						setPopContent(0);
						popup.setPosition(center);
						/* 이전 popup 이동했을때 초기화 */
						popup.element.children[0].style.left = '50%';
						popup.element.children[0].style.top = '';
						popup.element.children[0].style.bottom = '15px';
					})
					
					geoMap.addInteraction(select);
					popup.setPosition(null);
					
					const urlParams = new URL(location.href).searchParams;
					if(urlParams.get('key')){
						const feature = bizLayer.getSource().getFeatures().filter(f => 
							f.getProperties()['plng_biz_sn'] === Number(urlParams.get('key'))
						);
						if(feature.length > 0){
		        			select.getFeatures().push(feature[0]);
		        			geoMap.getView().fit(feature[0].getGeometry().getExtent());
		        			if(geoMap.getView().getZoom() > 20){
		        				geoMap.getView().setZoom(19)
		        			}
						}
					}
					
				},
				error: function(err){
					console.log(err);
				}
    	});
    }
    
	    /* popup conten 만들기 idx 0일때 상세, 1일때 이력 */
	    function setPopContent(idx){
	    	
	    	const feature = select.getFeatures().getArray()[0];
	    	$('.bizFeatureInfoPop .body .tableWrap').empty();
	    	
	    	const properties = feature.getProperties();
	    	//const table = document.createElement('table');
	   
	    	let table;
	    	if(idx === 0){	    		
	            let addr = properties.spl_guofc_cd + ' ' + properties.rprs_dng_cd + ' ' + properties.rprs_lotno_addr;
		    	table = "<table>" +
		    					'<tr>' +
		    						'<th width="20%">기획사업명</th><td width="30%">' + (properties.plng_biz_nm ? properties.plng_biz_nm : '-') + '</td>' +
		    						'<th>기획사업유형</th><td>' + (properties.plng_biz_ty_cd ? getCodeByName('plng_biz_ty_cd', properties.plng_biz_ty_cd) : '-') + '</td>' +
		    					'</tr>' +
		    					'<tr>' +
		    						'<th>사업 시작일</th><td width="30%">' + (properties.biz_bgng_ymd ? properties.biz_bgng_ymd : '-') + '</td>' +
		    						'<th>사업 종료일</th><td>' + (properties.biz_end_ymd ? properties.biz_end_ymd : '-') + '</td>' +
		    					'</tr>' +
		    					'<tr>' +
		    						'<th>관리부서</th><td>' + (properties.mng_dpt_cd ? properties.mng_dpt_cd : '-') + '</td>' +
		    						'<th>부지소유</th><td>' + (properties.plt_own_se_cd ? getCodeByName('plt_own_se_cd', properties.plt_own_se_cd) : '-') + '</td>' +
		    					'</tr>' +
		    					'<tr>' +
		    						'<th>담당자</th><td>' + (properties.pic_id ? properties.pic_id : '-') + '</td>' +
		    						'<th>담당자의부서</th><td>' + (properties.chr_dpt_cd ? properties.chr_dpt_cd : '-') + '</td>' +
		    					'</tr>' +
		    					'<tr>' +
		    						'<th>대상지명</th><td colspan="3">' + (properties.loc_addr ? properties.loc_addr : '-') + '</td>' +
	    						'</tr>' +
		    					'<tr>' +
		    						'<th>대상지 주소</th><td colspan="3">' + (addr) + '</td>' +
								'</tr>' +
		    					'<tr>' +
		    						'<th>개요</th><td colspan="3">' + (properties.plng_biz_brief ? properties.plng_biz_brief : '-') + '</td>' +
								'</tr>' +
		    					'<tr>' +
		    						'<th>추진여부</th><td>' + (properties.plng_biz_sta_cd ? getCodeByName('plng_biz_sta_cd', properties.plng_biz_sta_cd)  : '-') + '</td>' +
		    						'<th>세부추진단계</th><td>' + (properties.end_ty_cd ? getCodeByName('end_ty_cd', properties.end_ty_cd) : '-') + '</td>' +
								'</tr>' +
		    					'<tr>' +
	    							'<th>비고</th><td colspan="3">' + (properties.biz_cn ? properties.biz_cn : '-') + '</td>' +
								'</tr>' +
		    					'<tr>' +
		    						'<th>사업계획승인일자</th><td>' + (properties.biz_plan_aprv_ymd ? properties.biz_plan_aprv_ymd : '-') + '</td>' +
		    						'<th>투자심사일자</th><td>' + (properties.inv_srng_ymd ? properties.inv_srng_ymd : '-') + '</td>' +
		    					'</tr>' +
		    					'<tr>' +
		    						'<th>이사회 일자</th><td>' + (properties.bodt_ymd ? properties.bodt_ymd : '-') + '</td>' +
		    						'<th>지구지정일자</th><td>' + (properties.rgn_dsgn_ymd ? properties.rgn_dsgn_ymd : '-') + '</td>' +
		    					'</tr>' +
		    					'<tr>' +
		    						'<th>공사착공일자</th><td>' + (properties.cstrn_bgncst_ymd ? properties.cstrn_bgncst_ymd : '-') + '</td>' +
		    						'<th>공사준공일자</th><td>' + (properties.cstrn_cmcn_ymd ? properties.cstrn_cmcn_ymd : '-') + '</td>' +
		    					'</tr>' +
		    					'<tr>' +
		    						'<th>사업준공일자</th><td>' + (properties.biz_cmcn_ymd ? properties.biz_cmcn_ymd : '-') + '</td>' +
		    						'<th>사업주체</th><td>' + (properties.biz_pragt_cd ? getCodeByName('biz_pragt_cd', properties.biz_pragt_cd) : '-') + '</td>' +
		    					'</tr>' +
		    					'<tr>' +
		    						'<th>GIS객체비공개</th><td>' + (properties.gis_objt_indct_yn ? properties.gis_objt_indct_yn : '-') + '</td>' +
		    						'<th>GIS정보비공개</th><td>' + (properties.gis_info_indct_yn ? properties.gis_info_indct_yn : '-') + '</td>' +
		    					'</tr>' +
		    				"</table>";
		    	$('.bizFeatureInfoPop .body .tableWrap').append($(table));
	    	}else{
	    		$.ajax({
	    			type:'GET',
	    			url:'/api/cmmn/proxy.do?url='+ mangoServer +'/api/slctn/getLogGeom.json?tFid=' + properties.plng_biz_sn,
	    			success:function(res) {
	    				if(res.response.code === 200){

	    					table = '<table>' +
	    						'<tr><th width="30%">메모</th><th>등록/수정일</th><th>조회</th></tr>';

	    					for(let item of res.response.data){
	    						table += '<tr><td>' + item.memo + '</td><td>' + timestamp(new Date(item.createdt)) + 
	    							'</td><td><button type="button" id="' + item.createdt + '" class="smWhiteBtn">검색</button></td></tr>';
	    					}
	    					table += '</table>';

	    			    	$('.bizFeatureInfoPop .body .tableWrap').append($(table));

	    			    	for(let item of res.response.data){
	    						$('#' + item.createdt).on('click', function(e){ handleSlctnPopSearchBtn(item)});
	    					}
	    				}
	    			}
	    		})
	    	}
	    }
	    
	    // 이력 검색 시 event
	    function handleSlctnPopSearchBtn (info) {
	    	const { tfid, geom } = info;
	    	
	    	const slctnLayer = geoMap.getLayers().getArray().filter((lyr) => lyr.get('title') === '사업기획 레이어')[0];
	    	
	    	const wkt = new ol.format.WKT();
	    	
	    	const beforeFeature = slctnLayer.getSource().getFeatures().filter((feature) => feature.get('plng_biz_sn') === tfid)[0];
			
	    	beforeFeature.setStyle(
	            new ol.style.Style({
	                fill: new ol.style.Fill({ color: 'rgba(0,0,0,0)' }),
	                stroke: new ol.style.Stroke({ color: 'rgba(0,0,0,0)' }),
	            })
	    		
	    	);
	    	
	    	const targetFeature = new ol.Feature({
	    		geometry: wkt.readGeometry(geom)
	    	});
	    	
	    	//const transFeature = new ol.Feature({
	    		//geometry: targetFeature.getGeometry()
	    		// geometry: targetFeature.getGeometry().transform('EPSG:3857', 'EPSG:4326')
	    	//});
	    	
	    	targetFeature.setStyle(
	                new ol.style.Style({
	                    fill: new ol.style.Fill({ color: 'rgba( 255, 255, 0, 0.7)' }),
	                })
            );
	    	
	    	slctnLayer.getSource().addFeature(targetFeature);
	    	logFeature = {selectFeature: transFeature, beforeFeature };
	    }
	    
	    // timestamp
	    function timestamp (date) {
	        date.setHours(date.getHours() + 9);
	        return date.toISOString().replace('T', ' ').substring(0, 19);
	    };
	    
	    // code 이름 가져오기
	    function getCodeByName(field, code){
	    	
	    	const fieldInfo = codeInfo.filter(code => code.column === field);
	    	if(fieldInfo.length > 0){
	    		const codeInfo = fieldInfo[0].list.filter(info => info.code === code);
	    		if(codeInfo.length >0){
	    			return codeInfo[0].codeNm;
	    		}else{
	    			return '-';	
	    		}	    		
	    	}else{
	    		return '-';
	    	}
	    }
	    
    function enterKey(e) {
        if (e.keyCode === 13) {
            e.preventDefault();
            // 엔터키가 눌렸을 때
            searchLand();
        }
    }
    function searchLand() {
    	const params = $('#slctn-search').serializeObject();
		
        if (typeof params.ownrNm !== 'undefined') {
            params.ownrNm = params.ownrNm.toString();
        }

        if (typeof params.area !== 'undefined') {
            params.area1 = params.area[0];
            params.area2 = params.area[1];

            delete params.area;
        }

        if (typeof params.trgt1 !== 'undefined') {
            params.trgt1 = selectedAuto.trgt.map(i => i).join('|');
        }

        //params.trgtAreaNm = props.trgtAreaNm;

        Object.keys(params).forEach((key) => {
            if (params[key] === '전체') {
                delete params[key];
            }
        });
 
        $.ajax({
			type: 'POST',
			// url: process.env.BACKEND + '/api/slctn/list.json',
			// url: 'https://shgis.syesd.co.kr/shex' + '/api/slctn/list.json',
			url: '<%=syGisURL%>/shex' + '/api/slctn/list.json',
			data: params,
			success: function(res) {
                bizData.data = res.response.data;
				
                const searchResultList = $('#searchResultList');
                searchResultList[0].innerHTML = null;
                const dataLength = $('#dataLength');
                dataLength[0].innerHTML = null;
                let list ='';
                if(bizData.data.length == 0){
                	list = '<p>검색결과가 없습니다.</p>';
                }
                else if (bizData.data.length > 0){
      
                	dataLength[0].innerHTML = '총 ' + bizData.data.length+'건'
                	for (let i=0; i<bizData.data.length; i++){
                		list += '<p ';
                   		list += ' key = ' + i;
                   		// list += ` onclick = selectBizLayer(${bizData.data[i]})`;
                   		list += ' onclick = selectBizLayer(' + JSON.stringify(bizData.data[i]) + ')';
                   		list += ' >';
                   		list += '· ' + bizData.data[i].locAddr;
                   		list += '</p>';
                	}
                }
                searchResultList.append(list)
                
             
                // let obj = res.response.data.map((row) => row.ogcFid);

                /* MapManager.filterResultLayer(0, obj, 'ogc_fid'); */
			},
		});
    }
    
    function selectBizLayer(data){
    	bizData.selected = data;
    }
    
 	// 메시지 수신 받는 eventListener 등록

		//window.removeEventListener('message', receiveMsgFromChild);
	
	    // 자식으로부터 메시지 수신 (iframe event)
    function receiveMsgFromChild( e ) {
	        const messageNm = e.data.name;
	        
	        if(messageNm === 'columnInfo'){
	        	codeInfo = e.data.value;
	        }else if(messageNm =='검색 목록'){
	        	const data =e.data.value.data;
	        	codeInfo = data;
	        	const snList =data.map((_data) => {
	        		return _data.plngBizSn;
	       		});

	        	const filter = 'plng_biz_sn in (' + snList.toString() + ')';
	        	loadBizLayer(filter);
	        }else if(messageNm === '선택 데이터'){
	        	const data =e.data.value;
	        	const layer = geoMap.getLayers().getArray().filter((l) => l.get('title') === '사업기획 레이어');
	        	if(layer.length > 0){
	        		const feature = layer[0].getSource().getFeatures().filter((f) => f.getProperties()['plng_biz_sn'] === data.plngBizSn);
	        		if(feature.length > 0){
	        			geoMap.getView().fit(feature[0].getGeometry().getExtent());
	        			if(geoMap.getView().getZoom() > 20){
	        				geoMap.getView().setZoom(19);
	        			}
	        			select.getFeatures().clear();
	        			select.getFeatures().push(feature[0]);
	        			//popup.setPosition(ol.extent.getCenter(feature[0].getGeometry().getExtent()));
	        		}
	        	}
	        }else if(messageNm === 'buffer'){
  
	            bufferLyr.getSource().clear();

	        	const wkt = new ol.format.WKT();

	        	const geom = wkt.readGeometry(e.data.value.geom);

	            const feature = new ol.Feature({
	                geometry: geom,
	                distance: e.data.value.distance,
	            });

	            /* const transFeature = new ol.Feature({
		    		geometry: feature.getGeometry().transform('EPSG:3857', 'EPSG:4326')
		    	}); */

	            bufferLyr.getSource().addFeature(feature);

	            /*mapRef.current.getView().fit(bufferLayerRef.current.getSource().getExtent(), mapRef.current.getSize());
	            mapRef.current.getView().setZoom(mapRef.curren t.getView().getZoom() - 0.8);*/
	        }else if(messageNm === 'handleParcelSlider'){
				
				$('#sh_iframe_parcel').toggleClass('move');
				
			}
	    }

		function closePopup(){
			popup.setPosition(null);
		}
		
		/* popup 상세, 이력 tab 이동 */
		function handlePopIndex(idx){
			if(idx === 0){
				$('#tableTab01').removeClass('hover');
				$('#tableTab00').addClass('hover');
			}else{
				$('#tableTab00').removeClass('hover');
				$('#tableTab01').addClass('hover');
			}

			popup.element.children[0].style.top = '';
			popup.element.children[0].style.bottom = '15px';
			
			setPopContent(idx);
		}
		
		// popup 창에서 선택 event
		function handleSelResult() {
	    	const iframe_biz = document.getElementById('sh_iframe_biz').contentWindow;
	    	const iframe_parcel = document.getElementById('sh_iframe_parcel').contentWindow;
	    	const properties = select.getFeatures().getArray()[0].getProperties();
	    	
	    	const wkt = new ol.format.WKT();
	    	const wktGeom = wkt.writeGeometry(properties.geometry);
	    	
	    	const camelProperties = camelCase(properties);
	    	iframe_biz.postMessage({selectData: JSON.parse(JSON.stringify(camelProperties))}, mangoServer);
	    	iframe_parcel.postMessage({selectData: wktGeom}, mangoServer);
	    	
	    	popup.setPosition(null);
	    	
	    	geoMap.getView().fit(select.getFeatures().getArray()[0].getGeometry().getExtent());

			if(geoMap.getView().getZoom() > 20){
				geoMap.getView().setZoom(19);
			}
		}
		
		// snake case to camelcase
		function camelCase(obj) {
			 var newObj = {};
			 for (d in obj) {
			   if (obj.hasOwnProperty(d)) {
			     newObj[d.replace(/(\_\w)/g, function(k) {
			       return k[1].toUpperCase();
			     })] = obj[d];
			   }
			 }
			 return newObj;
		}
		
		// 초기화 이벤트
		function leaveBiz () {
			geoMap.removeInteraction(select);
			geoMap.removeOverlay(popup);
			geoMap.removeLayer(bufferLyr);
			geoMap.removeLayer(bizLayer);
			
		}
		function olStyleFunc (fc, sc, sw){
			const style = new ol.style.Style({ 
				fill: new ol.style.Fill({ color : fc}),
				stroke: new ol.style.Stroke({ color: sc })
			})
			if(sw){
				style.getStroke().setWidth(sw);
			}
			
			return style;
		}
		function handleLayerSwitch (val) {
			const layer = geoMap.getLayers().getArray().filter(lyr => lyr.get('title') === '사업기획 레이어');
			if(layer.length > 0){
				if(val === 'biz1'){
					if(!$('#biz1')[0].style.color){
						$('#biz1')[0].style.color = '#b6b6b6';
						
						layer[0].getSource().getFeatures().forEach(feature => {
							const featureVal = feature.getProperties()['end_ty_cd'];
							if (featureVal === '1') {
								feature.setStyle(olStyleFunc('rgba(0,0,0,0)', 'rgba(0,0,0,0)', null))
							}
						})
					}else{
						$('#biz1')[0].style.color = '';
						layer[0].getSource().getFeatures().forEach(feature => {
							const featureVal = feature.getProperties()['end_ty_cd'];
							if (featureVal === '1') {
								feature.setStyle(new ol.style.Style({ 
									fill: new ol.style.Fill({ color : colors[0] }), 
									stroke: new ol.style.Stroke({ color: 'rgb(79, 201, 222)', width: 2 }),
									text: new ol.style.Text({
											font: 'bold 13px Roboto',
											text: feature.get('loc_addr'),
											fill: new ol.style.Fill({ color: '#000000' }),
											stroke: new ol.style.Stroke({ color: '#ffffff', width: 3 }),
										})
									})
								);
							}
						})
					}
    			}
				else if(val === 'biz2'){
					if(!$('#biz2')[0].style.color){
						$('#biz2')[0].style.color = '#b6b6b6';
						
						layer[0].getSource().getFeatures().forEach(feature => {
							const featureVal = feature.getProperties()['end_ty_cd'];
							if (featureVal === '2') {
								feature.setStyle(olStyleFunc('rgba(0,0,0,0)', 'rgba(0,0,0,0)', null))
							}
						})
					}else{
						$('#biz2')[0].style.color = '';
						layer[0].getSource().getFeatures().forEach(feature => {
							const featureVal = feature.getProperties()['end_ty_cd'];
							if (featureVal === '2') {
								feature.setStyle(new ol.style.Style({ 
									fill: new ol.style.Fill({ color : colors[1] }), 
									stroke: new ol.style.Stroke({ color: 'rgb(79, 201, 222)', width: 2 }),
									text: new ol.style.Text({
											font: 'bold 13px Roboto',
											text: feature.get('loc_addr'),
											fill: new ol.style.Fill({ color: '#000000' }),
											stroke: new ol.style.Stroke({ color: '#ffffff', width: 3 }),
										})
									})
								);
							}
						})
					}
    			}
				else if(val === 'biz3'){
					if(!$('#biz3')[0].style.color){
						$('#biz3')[0].style.color = '#b6b6b6';
						
						layer[0].getSource().getFeatures().forEach(feature => {
							const featureVal = feature.getProperties()['end_ty_cd'];
							if (featureVal === '3') {
								feature.setStyle(olStyleFunc('rgba(0,0,0,0)', 'rgba(0,0,0,0)', null))
							}
						})
					}else{
						$('#biz3')[0].style.color = '';
						layer[0].getSource().getFeatures().forEach(feature => {
							const featureVal = feature.getProperties()['end_ty_cd'];
							if (featureVal === '3') {
								feature.setStyle(new ol.style.Style({ 
									fill: new ol.style.Fill({ color : colors[2] }), 
									stroke: new ol.style.Stroke({ color: 'rgb(79, 201, 222)', width: 2 }),
									text: new ol.style.Text({
											font: 'bold 13px Roboto',
											text: feature.get('loc_addr'),
											fill: new ol.style.Fill({ color: '#000000' }),
											stroke: new ol.style.Stroke({ color: '#ffffff', width: 3 }),
										})
									})
								);
							}
						})
					}
    			}
				else if(val === 'biz4'){
					if(!$('#biz4')[0].style.color){
						$('#biz4')[0].style.color = '#b6b6b6';
						
						layer[0].getSource().getFeatures().forEach(feature => {
							const featureVal = feature.getProperties()['end_ty_cd'];
							if (featureVal === '4') {
								feature.setStyle(olStyleFunc('rgba(0,0,0,0)', 'rgba(0,0,0,0)', null))
							}
						})
					}else{
						$('#biz4')[0].style.color = '';
						layer[0].getSource().getFeatures().forEach(feature => {
							const featureVal = feature.getProperties()['end_ty_cd'];
							if (featureVal === '4') {
								feature.setStyle(new ol.style.Style({ 
									fill: new ol.style.Fill({ color : colors[3] }), 
									stroke: new ol.style.Stroke({ color: 'rgb(79, 201, 222)', width: 2 }),
									text: new ol.style.Text({
											font: 'bold 13px Roboto',
											text: feature.get('loc_addr'),
											fill: new ol.style.Fill({ color: '#000000' }),
											stroke: new ol.style.Stroke({ color: '#ffffff', width: 3 }),
										})
									})
								);
							}
						})
					}
    			}
				else if(val === 'biz5'){
					if(!$('#biz5')[0].style.color){
						$('#biz5')[0].style.color = '#b6b6b6';
						
						layer[0].getSource().getFeatures().forEach(feature => {
							const featureVal = feature.getProperties()['end_ty_cd'];
							if (featureVal === '5') {
								feature.setStyle(olStyleFunc('rgba(0,0,0,0)', 'rgba(0,0,0,0)', null))
							}
						})
					}else{
						$('#biz5')[0].style.color = '';
						layer[0].getSource().getFeatures().forEach(feature => {
							const featureVal = feature.getProperties()['end_ty_cd'];
							if (featureVal === '5') {
								feature.setStyle(new ol.style.Style({ 
									fill: new ol.style.Fill({ color : colors[4] }), 
									stroke: new ol.style.Stroke({ color: 'rgb(79, 201, 222)', width: 2 }),
									text: new ol.style.Text({
											font: 'bold 13px Roboto',
											text: feature.get('loc_addr'),
											fill: new ol.style.Fill({ color: '#000000' }),
											stroke: new ol.style.Stroke({ color: '#ffffff', width: 3 }),
										})
									})
								);
							}
						})
					}
    			}
				else if(val === 'biz6'){
					if(!$('#biz6')[0].style.color){
						$('#biz6')[0].style.color = '#b6b6b6';
						
						layer[0].getSource().getFeatures().forEach(feature => {
							const featureVal = feature.getProperties()['end_ty_cd'];
							if (featureVal === '6') {
								feature.setStyle(olStyleFunc('rgba(0,0,0,0)', 'rgba(0,0,0,0)', null))
							}
						})
					}else{
						$('#biz6')[0].style.color = '';
						layer[0].getSource().getFeatures().forEach(feature => {
							const featureVal = feature.getProperties()['end_ty_cd'];
							if (featureVal === '6') {
								feature.setStyle(new ol.style.Style({ 
									fill: new ol.style.Fill({ color : colors[5] }), 
									stroke: new ol.style.Stroke({ color: 'rgb(79, 201, 222)', width: 2 }),
									text: new ol.style.Text({
											font: 'bold 13px Roboto',
											text: feature.get('loc_addr'),
											fill: new ol.style.Fill({ color: '#000000' }),
											stroke: new ol.style.Stroke({ color: '#ffffff', width: 3 }),
										})
									})
								);
							}
						})
					}
    			}
				else if(val === 'biz7'){
					if(!$('#biz7')[0].style.color){
						$('#biz7')[0].style.color = '#b6b6b6';
						
						layer[0].getSource().getFeatures().forEach(feature => {
							const featureVal = feature.getProperties()['end_ty_cd'];
							if (featureVal === '7') {
								feature.setStyle(olStyleFunc('rgba(0,0,0,0)', 'rgba(0,0,0,0)', null))
							}
						})
					}else{
						$('#biz7')[0].style.color = '';
						layer[0].getSource().getFeatures().forEach(feature => {
							const featureVal = feature.getProperties()['end_ty_cd'];
							if (featureVal === '7') {
								feature.setStyle(new ol.style.Style({ 
									fill: new ol.style.Fill({ color : colors[6] }), 
									stroke: new ol.style.Stroke({ color: 'rgb(79, 201, 222)', width: 2 }),
									text: new ol.style.Text({
											font: 'bold 13px Roboto',
											text: feature.get('loc_addr'),
											fill: new ol.style.Fill({ color: '#000000' }),
											stroke: new ol.style.Stroke({ color: '#ffffff', width: 3 }),
										})
									})
								);
							}
						})
					}
    			}
				else if(val === 'biz8'){
					if(!$('#biz8')[0].style.color){
						$('#biz8')[0].style.color = '#b6b6b6';
						
						layer[0].getSource().getFeatures().forEach(feature => {
							const featureVal = feature.getProperties()['end_ty_cd'];
							if (featureVal === ' 미정 ') {
								feature.setStyle(olStyleFunc('rgba(0,0,0,0)', 'rgba(0,0,0,0)', null))
							}
						})
					}else{
						$('#biz8')[0].style.color = '';
						layer[0].getSource().getFeatures().forEach(feature => {
							const featureVal = feature.getProperties()['end_ty_cd'];
							if (featureVal === ' 미정 ') {
								feature.setStyle(new ol.style.Style({ 
									fill: new ol.style.Fill({ color : colors[7] }), 
									stroke: new ol.style.Stroke({ color: 'rgb(79, 201, 222)', width: 2 }),
									text: new ol.style.Text({
											font: 'bold 13px Roboto',
											text: feature.get('loc_addr'),
											fill: new ol.style.Fill({ color: '#000000' }),
											stroke: new ol.style.Stroke({ color: '#ffffff', width: 3 }),
										})
									})
								);
							}
						})
					}
    			}
				
			}
		}
  </script>

  <body>  	
    <div class="bizFeatureInfoPop">
  		<div class="header">
            <h1 class="BGboderTit">· 사업기획 데이터 조회</h1>
            <img src="${pageContext.request.contextPath}../../resources/img/icons/Ic_Close.svg" alt="닫기" class="closeBtn" id="PopClose" onclick="closePopup()"/>
		</div>
        <div class="body">
        	<div class="tableTab">
                <span id="tableTab00" class="hover" onclick="handlePopIndex(0)">
                    상세정보
				</span>
                <span id="tableTab01" class onclick="handlePopIndex(1)">
                    이력정보
                </span>
			</div>
        	<div class="tableWrap">
			</div>
        	<button type="button" class="w100Btn" onclick="handleSelResult()">선택</button>
		</div>
	</div>
    <div class='leftTModalWrap slctn' style="height: 100%;">
		<iframe title="SH업무연계-사업기획iframe" id="sh_iframe_biz" src="<%=mangoServerURL%>/iframe_slctn" style="height: 100%;">
		</iframe>
	</div>
	
		<iframe title="SH업무연계-지적도iframe" name="sh_iframe_parcel_name" id="sh_iframe_parcel" src="<%=mangoServerURL%>/iframe_parcel" >
		</iframe>
	
			
	<div class="legendModal">
	    <h1 class="header">사업기획</h1>
	    <ul class="legendList">
	        

			<li>
				<span class="legendBox" style="background-color: #FFADAD"></span>
				<p id = 'biz1' onclick="handleLayerSwitch('biz1')">사업추진</p>
			</li>
			<li>
				<span class="legendBox" style="background-color: #FFD6A5"></span>
				<p id = 'biz2' onclick="handleLayerSwitch('biz2')">종결</p>
			</li>
			<li>
				<span class="legendBox" style="background-color: #FDFFB6"></span>
				<p id = 'biz3' onclick="handleLayerSwitch('biz3')">사전협의 및 내부검토</p>
			</li>
			<li>
				<span class="legendBox" style="background-color: #CAFFBF"></span>
				<p id = 'biz4' onclick="handleLayerSwitch('biz4')">용역시행</p>
			</li>
			<li>
				<span class="legendBox" style="background-color: #9BF6FF"></span>
				<p id = 'biz5' onclick="handleLayerSwitch('biz5')">투자심사위원회완료</p>
			</li>
			<li>
				<span class="legendBox" style="background-color: #A0C4FF"></span>
				<p id = 'biz6' onclick="handleLayerSwitch('biz6')">이사회완료</p>
			</li>
			<li>
				<span class="legendBox" style="background-color: #BDB2FF"></span>
				<p id = 'biz7' onclick="handleLayerSwitch('biz7')">시의회완료</p>
			</li>
			<li>
				<span class="legendBox" style="background-color: #FFFFFC"></span>
				<p id = 'biz8' onclick="handleLayerSwitch('biz8')">미정</p>
			</li>


	    </ul>
	</div>
	
	
	
	
  </body>
</html>
