<%@page import="egovframework.mango.config.SHResource"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> <%@
taglib prefix="sf" uri="http://www.springframework.org/tags/form"%> <%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%> <%@ taglib prefix="fn"
uri="http://java.sun.com/jsp/jstl/functions"%> <%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%> <%@ page
import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>


<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.Properties" %>

<%
    String vworldKey = SHResource.getValue("vworld.api.key"); 
	String syGisURL = SHResource.getValue("sh.geoserver.url");
	String mangoServerURL = SHResource.getValue("sh.server.schema") + "://" + SHResource.getValue("sh.server.url") + "/shex";
%>

<!DOCTYPE html>
<html lang="ko">
	<style>
		.legendModal{
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
		.legendModal .header{
		    margin-bottom: 0.8rem;
		    font-size: 1.4rem;
		    color: #778690;
		    font-weight: 600;
		}
		.legendModal .legendList li{
		    display: flex;
		    align-items: center;
		    font-size: 1.4rem;
		    color: #778690;
		    font-weight: 400;
		    line-height: 2.4rem;
		}
		.legendList .legendBox{
			display: inline-block;
		    margin-right: 0.4rem;
		    width: 1.6rem;
		    height: 1.2rem;
		}
		.legendList .legendBox.bld1{
		    background-color: #9e9e9e;
		}
		.legendList .legendBox.bld2{
		    background-color: #ffa500;
		}
		.legendList .legendBox.bld3{
		    background-color: #ff0000;
		}
		
		.bldFeatureInfoPop{
			position: absolute;
		    bottom: 1.6rem;
		    right: 0rem;
		    border-radius: 8px;
		    background-color: #F7F9FB;
		    box-shadow: 0px 0px 12px 0 rgba(0, 0, 0, 0.16);
		    z-index: 5;
		}
		.bldFeatureInfoPop .header{
			position: relative;
		    display: flex;
		    gap: 8px;
		    width: 100%;
		    align-items: center;
		    border-top: 1px solid #E0E6EC;
		    border-bottom: 1px solid #E0E6EC;
		    justify-content: space-between;
		}
		.bldFeatureInfoPop .BGboderTit{
		    padding: 1.2rem 1.6rem;
		    font-size: 1.6rem;
		    font-weight: 600;
		    line-height: 2.4rem;
		    color: #778690;
		    background-color: #F5F6FA;
		}
		.bldFeatureInfoPop .header .closeBtn{
		    margin-right: 1.6rem;
    		cursor: pointer;
		}
		.bldFeatureInfoPop .body{
			display: flex;
		    flex-wrap: wrap;
		    gap: 0 1.6rem;
		    padding: 1.2rem;
		}
		.bldFeatureInfoPop .body > div{
		    flex-grow: 1;
		}
		.bldFeatureInfoPop .body .tableTab{
		    margin-bottom: 0;
		}
		.tableTab span.hover{
		    background-color: #fff;
    		border-bottom: 0;
		}
		.tableTab span {
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
		.bldFeatureInfoPop .tableWrap {
		    max-height: 70vh;
		    overflow-y: auto;
		}	
		.tableWrap {
		    margin-top: -0.1rem;
		    background-color: #fff;
		    padding: 1.2rem;
		    border: 1px solid #e0e6ec;
		    border-radius: 0 0 4px 4px;
		    max-width: 42rem;
		}
		.bldFeatureInfoPop .tableWrap table {
		    min-width: 18.4rem;
		}
		.tableWrap table, .tableWrap table th, .tableWrap table td {
		    padding: 0.8rem;
		    border-spacing: 0;
		    border-collapse: collapse;
		    border: 1px solid #e0e6ec;
		    font-size: 1.4rem;
		    font-weight: 400;
		    vertical-align: middle;
		}
		.tableWrap table {
		    margin-top: 0.8rem;
		    width: 100%;
		}
		.bldFeatureInfoPop .tableWrap caption {
		    padding-bottom: 0.4rem;
		    font-size: 1.4rem;
		    line-height: 2rem;
		    font-weight: 400;
		    text-align: left;
		    color: #778690;
	        display: table-caption;
		}
		.tableWrap table th {
		    background-color: #f7f9fb;
		    color: #778690;
		}
		.tableWrap table td {
		    color: #1a1a1a;
		}
		
	    .bldFeatureInfoPop .body .w100Btn{
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
	    
		.legendList p{
			cursor: pointer;
		}
		.sup {
		    font-size: small !important;
		    vertical-align: super !important;
		}
		.basForm select {
		    min-width: 17rem;
		    height: 3.2rem;
		    padding: 0 0.8rem;
		    border: 1px solid #E0E6EC;
		    border-radius: 4px;
		    background-color: #fff;
		    font-weight: 300;
		    background: transparent;
		    cursor: pointer;
		    font-family: 'SUIT';
		}
		option {
		    font-weight: normal;
		    display: block;
		    padding-block-start: 0px;
		    padding-block-end: 1px;
		    min-block-size: 1.2em;
		    padding-inline: 2px;
		    white-space: nowrap;
		}
	</style>
   <script type="text/javascript">
   
	let bldLayer;
	
	let select;
	
	let codeInfo;
	
	let cqlFilter = "lotno_addr like '%25%25' or road_nm_addr like '%25%25'";
	
	let bldLandData;

    window.addEventListener( 'message', receiveMsgFromChild );
    
    $(document).ready(function () {
      $('#sub_content').show();
      loadBldLayer();
    });
    
 	// bld layer 불러오기
    function loadBldLayer(){
 		if($('#bld_10_less').length > 0){ 			
	 		$('#bld_10_less')[0].style.color = '';
	 		$('#bld_20_less')[0].style.color = '';
	 		$('#bld_20_more')[0].style.color = '';
 		}
 		
    	//geoMap.addLayer();
    	let featureIdFilter = null;
    	
    	const duplicateLyr = geoMap.getLayers().getArray().filter(l => l.get('title') === '건축물 레이어');
    	if(duplicateLyr.length > 0){
    		geoMap.removeLayer(duplicateLyr[0]);
    	}
    	 
    	let typeName = 'LANDSYS:v_b_thabm0001'
        const urlTemplate = '<%=syGisURL%>/geoserver' + '/LANDSYS/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=' + typeName + '&CQL_FILTER={{CQLFILTER}}&outputFormat=application/json&srsname=EPSG:3857';
        // const urlTemplate = 'https://shgis.syesd.co.kr/geoserver' + '/LANDSYS/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=' + typeName + '&CQL_FILTER={{CQLFILTER}}&FEATUREID={{FEATUREID}}&outputFormat=application/json&srsname=EPSG:3857';
    	
    	let url = cqlFilter ? urlTemplate.replace('{{CQLFILTER}}', cqlFilter) : urlTemplate.replace('&CQL_FILTER={{CQLFILTER}}', '');
        // url = featureIdFilter ? url.replace('{{FEATUREID}}', featureIdFilter) : url.replace('&FEATUREID={{FEATUREID}}', '');
        
    	$.ajax({
			dataType: 'json',
			url: "/api/cmmn/proxy.do?url=" + url,
			// url:
			success: function(res) {
				bldLayer = new ol.layer.Vector({
					source: new ol.source.Vector({}),
					title: '건축물 레이어',
					style: function (feature) {
						
						const val = feature.getProperties()['pasg_ycnt'];
						
						const colors = ['rgba(158,158,158,0.6)', 'rgba(255,165,0,0.6)', 'rgba(255,0,0,0.6)'];
						const strokeColors = ['#5D5D5D', '#CC723D', '#CC3D3D'];
						
						let fillColor = colors[0];
		                let strokeColor = strokeColors[0];

		                if (val >= 1 && val < 10) {
		                } else if (val >= 10 && val < 20) {
		                    fillColor = colors[1];
		                    strokeColor = strokeColors[1];
		                } else if (val >= 20) {
		                    fillColor = colors[2];
		                    strokeColor = strokeColors[2];
		                }

		                return olStyleFunc(fillColor, strokeColor, 1);
					}
				})
				const features = new ol.format.GeoJSON().readFeatures(res);
				bldLayer.getSource().addFeatures(features);

				geoMap.getView().fit(bldLayer.getSource().getExtent(), geoMap.getSize());

				geoMap.addLayer(bldLayer);
				
				select = new ol.interaction.Select({
					title: 'bld_select',
					layers:[bldLayer],
					source:bldLayer.getSource(),
					wrapX:false,
					style: function(feature){
						
						const val = feature.getProperties()['pasg_ycnt'];
						
						const colors = ['rgba(158,158,158,0.6)', 'rgba(255,165,0,0.6)', 'rgba(255,0,0,0.6)'];
						
						let fillColor = colors[0];

						if (val >= 1 && val < 10) {
						} else if (val >= 10 && val < 20) {
							fillColor = colors[1];
						} else if (val >= 20) {
							fillColor = colors[2];
						}
						
						return olStyleFunc(fillColor, 'rgb(255, 0, 0)', 2);
						
						
					}
				})
				select.on('select', function(e) {

					/* 1개만 select */
					if(e.target.getFeatures().getArray().length >1){							
						const length = e.target.getFeatures().getArray().length;
						for(let i=length -2; i>=0; i--){
							e.target.getFeatures().remove(e.target.getFeatures().getArray()[i]);
						}
					}
					
					if(e.selected.length > 0){
				    	documentDisplay('bldFeatureInfoPop', 'block');
						setPopContent();
						excuteBld(e.selected[0].getProperties()['pnu_cd']);
					}else{
				    	documentDisplay('bldFeatureInfoPop', 'none');
					}
					
				})

				geoMap.addInteraction(select);
		    	documentDisplay('bldFeatureInfoPop', 'none');
				
				const urlParams = new URL(location.href).searchParams;
				if(urlParams.get('bldg_mng_no')){
					const feature = bldLayer.getSource().getFeatures().filter(f => 
						f.getProperties()['bldg_mng_no'] === urlParams.get('bldg_mng_no')
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
    	
		let elapsedYearsData = {
			count: ['cnt_under10', 'cnt_under20', 'cnt_over20'],
			title: ['경과년수 10년 미만 현황', '경과년수 10년 이상 20년 미만 현황', '경과년수 20년 이상 현황'],
			styleColor: [
				[
					[250, 250, 250, 0.7],
					[189, 189, 189, 0.7],
					[128, 128, 128, 0.7],
					[66, 66, 66, 0.7],
					[5, 5, 5, 0.7],
				],
				[
					[255, 255, 212, 0.7],
					[254, 217, 142, 0.7],
					[254, 153, 41, 0.7],
					[217, 95, 14, 0.7],
					[153, 52, 4, 0.7],
				],
				[
					[255, 245, 240, 0.7],
					[252, 190, 165, 0.7],
					[251, 112, 80, 0.7],
					[211, 32, 32, 0.7],
					[103, 0, 13, 0.7],
				],
			],
			visible: [false, false, true],
		};
    	$.ajax({
			type: 'GET',
			// url: '/api/cmmn/proxy.do?url=<%=mangoServerURL%>/api/buld/getLegendData.json',
			url: '<%=mangoServerURL%>/api/buld/getLegendData.json',
			
			// url:
			success: function(res) {
				let data = res.response.data;
				const format = new ol.format.GeoJSON();

				for (let i = 0; i < 3; i++) {
					const vectorSource = new ol.source.Vector();
					const housLayer = new ol.layer.Vector({
						title: elapsedYearsData.title[i],
						source: vectorSource,
						visible: elapsedYearsData.visible[i],
						maxZoom: 13,
					});
					
					const features = format.readFeatures(data.legend_feature.feature_colletion.value);
					/* features.map((ele)=>{
						// ele.getGeometry().transform('EPSG:3857', 'EPSG:4326');
					}) */
					
					
					vectorSource.addFeatures(features);
					
					let intervalsName = elapsedYearsData.count[i];
					housLayer.setStyle((feature) => {
						let count = feature.get(intervalsName);
						const style = new ol.style.Style({
							// stroke: new Stroke({ color: '#000', width: 1 }),
							fill: new ol.style.Fill({ color: [255, 255, 255, 0.5] }),
						});
						
						if (count > data.legend_intervals[intervalsName][1].start && count <= data.legend_intervals[intervalsName][1].end) {
							style.getFill().setColor(elapsedYearsData.styleColor[i][0]);
						} else if (count > data.legend_intervals[intervalsName][2].start && count <= data.legend_intervals[intervalsName][2].end) {
							style.getFill().setColor(elapsedYearsData.styleColor[i][1]);
						} else if (count > data.legend_intervals[intervalsName][3].start && count <= data.legend_intervals[intervalsName][3].end) {
							style.getFill().setColor(elapsedYearsData.styleColor[i][2]);
						} else if (count > data.legend_intervals[intervalsName][4].start && count <= data.legend_intervals[intervalsName][4].end) {
							style.getFill().setColor(elapsedYearsData.styleColor[i][3]);
						} else if (count > data.legend_intervals[intervalsName][5].start && count <= data.legend_intervals[intervalsName][5].end) {
							style.getFill().setColor(elapsedYearsData.styleColor[i][4]);
						}
						return style;
					});
					geoMap.addLayer(housLayer);

					// let legend = {
					// 	[intervalsName]: [
					// 		data.legend_intervals[intervalsName][1].start+'-'+data.legend_intervals[intervalsName][1].end,
					// 		data.legend_intervals[intervalsName][2].start+'-'+data.legend_intervals[intervalsName][2].end,
					// 		data.legend_intervals[intervalsName][3].start+'-'+data.legend_intervals[intervalsName][3].end,
					// 		data.legend_intervals[intervalsName][4].start+'-'+data.legend_intervals[intervalsName][4].end,
					// 		data.legend_intervals[intervalsName][5].start+'-'+data.legend_intervals[intervalsName][5].end,
					// 	],
					// };

					let legendHTML = 
						'<li>' +
						'<span class="legendBox" style="background-color: #'+elapsedYearsData.styleColor[i][0][0].toString(16).padStart(2,"0")+elapsedYearsData.styleColor[i][0][1].toString(16).padStart(2,"0")+elapsedYearsData.styleColor[i][0][2].toString(16).padStart(2,"0")+'"></span>' +
						'<p id="'+elapsedYearsData.count[i]+'_'+i+'" >'+data.legend_intervals[intervalsName][1].start+'-'+data.legend_intervals[intervalsName][1].end+'</p>' +
						'</li>' +
						'<li>' +
						'<span class="legendBox" style="background-color: #'+elapsedYearsData.styleColor[i][1][0].toString(16).padStart(2,"0")+elapsedYearsData.styleColor[i][1][1].toString(16).padStart(2,"0")+elapsedYearsData.styleColor[i][1][2].toString(16).padStart(2,"0")+'"></span>' +
						'<p id="'+elapsedYearsData.count[i]+'_'+i+'" >'+data.legend_intervals[intervalsName][2].start+'-'+data.legend_intervals[intervalsName][2].end+'</p>' +
						'</li>' +
						'<li>' +
						'<span class="legendBox" style="background-color: #'+elapsedYearsData.styleColor[i][2][0].toString(16).padStart(2,"0")+elapsedYearsData.styleColor[i][2][1].toString(16).padStart(2,"0")+elapsedYearsData.styleColor[i][2][2].toString(16).padStart(2,"0")+'"></span>' +
						'<p id="'+elapsedYearsData.count[i]+'_'+i+'" >'+data.legend_intervals[intervalsName][3].start+'-'+data.legend_intervals[intervalsName][3].end+'</p>' +
						'</li>' +
						'<li>' +
						'<span class="legendBox" style="background-color: #'+elapsedYearsData.styleColor[i][3][0].toString(16).padStart(2,"0")+elapsedYearsData.styleColor[i][3][1].toString(16).padStart(2,"0")+elapsedYearsData.styleColor[i][3][2].toString(16).padStart(2,"0")+'"></span>' +
						'<p id="'+elapsedYearsData.count[i]+'_'+i+'" >'+data.legend_intervals[intervalsName][4].start+'-'+data.legend_intervals[intervalsName][4].end+'</p>' +
						'</li>' +
						'<li>' +
						'<span class="legendBox" style="background-color: #'+elapsedYearsData.styleColor[i][4][0].toString(16).padStart(2,"0")+elapsedYearsData.styleColor[i][4][1].toString(16).padStart(2,"0")+elapsedYearsData.styleColor[i][4][2].toString(16).padStart(2,"0")+'"></span>' +
						'<p id="'+elapsedYearsData.count[i]+'_'+i+'" >'+data.legend_intervals[intervalsName][5].start+'-'+data.legend_intervals[intervalsName][5].end+'</p>' +
						'</li>' ;
					
					$('.legendModal .legendDiv #'+elapsedYearsData.count[i])[0].innerHTML = legendHTML;
	
					
				}
				
				

			},
			error: function(err){
				console.log(err);
			}
    	});
    	
    }
 	
 	function setPopContent () {
 		$('.bldFeatureInfoPop .body .tableWrap #shBldTable').empty();
 		$('.bldFeatureInfoPop .body .tableWrap #shLandTable').empty();
 		
    	const feature = select.getFeatures().getArray()[0];

    	const properties = feature.getProperties();
    	
    	let bldTable = '<tr><th>지번주소</th><td>' + (properties.lotno_addr ? properties.lotno_addr : '-') + '</td></tr>' +
    		'<tr><th>동번호</th><td>' + (properties.dng_no ? properties.dng_no : '-') + '</td></tr>' +
    		'<tr><th>총가구호수</th><td>' + (properties.hshd_ho_cnt ? properties.hshd_ho_cnt : '-') + '</td></tr>' +
    		'<tr><th>반지하호수</th><td>' + (properties.smbm_ho_cnt ? properties.smbm_ho_cnt : '-') + '</td></tr>' +
    		'<tr><th>주택형태</th><td>' + (properties.hs_shap_se_cd ? getCodeByName(properties.hs_shap_se_cd) : '-') + '</td></tr>' +
    		'<tr><th>건축연면적</th><td>' + (numberWithCommas(properties.bld_tfar)) + '</td></tr>' +
    		'<tr><th>지상층수</th><td>' + (properties.grnd_nofl ? properties.grnd_nofl : '-') + '</td></tr>' +
    		'<tr><th>지하층수</th><td>' + (properties.smbm_fl_cnt ? properties.smbm_fl_cnt : '-') + '</td></tr>' +
    		'<tr><th>구조형식명</th><td>' + (properties.strc_frm_nm ? properties.strc_frm_nm : '-') + '</td></tr>' +
    		'<tr><th>건축허가일</th><td>' + (properties.bld_prmsn_ymd ? properties.bld_prmsn_ymd : '-') + '</td></tr>' +
    		'<tr><th>사용승인일</th><td>' + (properties.use_aprv_ymd ? properties.use_aprv_ymd : '-') + '</td></tr>' +
    		'<tr><th>경과년수</th><td>' + (properties.pasg_ycnt ? properties.pasg_ycnt : '-') + '</td></tr>';
    		
    	let landTable = '<tr><th>대지면적</th><td>' + (numberWithCommas(properties.bldst_ar)) + 'm<sup class="sup">2</sup></td></tr>';
    	
    	$('.bldFeatureInfoPop .body .tableWrap #shBldTable').append($(bldTable));
    	$('.bldFeatureInfoPop .body .tableWrap #shLandTable').append($(landTable));
 	}
 	
 	function excuteBld (pnu) {

		$('#bldTable').empty();
		$('#landTable').empty();
		
 		if (pnu !== undefined && pnu !== '0000') { 			
	 		const url = '<%=mangoServerURL%>/utils/excuteBld.json?pnu=' + pnu;

	 		$.ajax({
	            type: 'GET',
	            url: '/api/cmmn/proxy.do?url=' + url,
	            success: function (res) {
	                try {
	                    const data = res.response.data;

	                    if (data === null || Object.keys(res.response.data).length === 0) {
	                    	createNullBldTable();
	                        return;
	                    }

	                    const result = data.body.items.item;
	                    bldLandData = {};

	                    if (typeof result !== 'undefined') {
	                        bldLandData.bld = result;
	                        // });
	                    } else {
	                        bldLandData.bld = [];
	                    }

	                    excuteLand(pnu);
	                } catch (error) {
	                }
	            },
	            error: function () {
	            },
	        });
 		}else{
 			createNullBldTable();
 		}
 	}
 	
 	function excuteLand(pnu) {
 		const params = {
            pnu: pnu,
            pageNo: 1,
            numOfRows: 10,
            format: 'json',
            key: '<%=vworldKey%>'
        };
 		
 		const getBrBasisOulnInfo = '<%=mangoServerURL%>/utils/excuteLand.json?pnu=' + pnu;;

 		$.ajax({
            type: 'GET',
            url: '/api/cmmn/proxy.do?url=' + getBrBasisOulnInfo,
            success: function (response) {
                const result = response.response.data.landCharacteristicss;

                if (typeof result !== 'undefined' && result.field.length > 0) {
                	bldLandData.land = result.field[result.field.length - 1];
                } else {
                	bldLandData.land = {};
                }

               	const basForm = $('.tableWrap .basForm');
                if(bldLandData.bld.length > 1){
                	if(basForm.length > 0){                		
	                	basForm[0].style.display = 'block';
	                	
	                	let options = '';
	               		for(let i = 0; i < bldLandData.bld.length; i++){
	                		const bld = bldLandData.bld[i];
	                		
	                		let bldname = '-';
	
	                        if (typeof bld.bldNm !== 'undefined') {
	                            bldname = bld.bldNm;
	                        }
	
	                        if (typeof bld.dongNm !== 'undefined') {
	                            bldname += ' ' + bld.dongNm;
	                        }
	
	                        options += '<option value=' + i +'>' + bldname + '</option>';
	
	                	}
	
	               		$('#search1').append($(options));
                	}
                }

            	if(basForm.length > 0){            	
	                createBldTable(0);
	            	createLandTable();
            	}
            },
            error: function () {
            	bldLandData.land = {};
            },
        });
 	}
 	
 	function createBldTable (idx) {
 		
 		let data;
 		if(bldLandData.bld.length > 1){
 			data = bldLandData.bld[idx];
 		}else{ 			
	        data = bldLandData.bld;
 		}

        $('#bldTable').empty();
        
 		if(data.length === 0){
 			const message1 = $('<tr><th colspan="2">해당 지역에 데이터가 없습니다.</th></tr>');

 			$('#bldTable').append(message1);
 			return;
 		}
 		
        if (data.length > 0) {
            data = data[idx];
        }

        const theadList = {
            platPlc: '지번주소',
            hoCnt: '호수',
            totArea: '연면적(㎡)',
            grndFlrCnt: '지상층수',
            ugrndFlrCnt: '지하층수',
            mainPurpsCdNm: '주용도',
            strctCdNm: '구조',
            pmsDay: '허가일',
            useAprDay: '사용승인일',
        };

        $.each(data, function (key, value) {
            let tbodyTr = $('<tr></tr>');
            if (typeof theadList[key] !== 'undefined') {
                tbodyTr.append('<th>' + theadList[key] + '</th>');
                tbodyTr.append('<td>' + value + '</td>');

                $('#bldTable').append(tbodyTr);
            }
        });
    };
    
    function createLandTable () {
        const data = bldLandData.land;

        const theadList = {
            lndpclAr: '대지면적(㎡)',
            lndcgrCodeNm: '지목',
            prposArea1Nm: '용도지역',
        };

        $('#landTable').empty();

        $.each(data, function (key, value) {
            let tbodyTr = $('<tr></tr>');
            if (typeof theadList[key] !== 'undefined') {
                tbodyTr.append('<th>' + theadList[key] + '</th>');
                tbodyTr.append('<td>' + value + '</td>');

                $('#landTable').append(tbodyTr);
            }
        });
    };
 	
 	function createNullBldTable () {
 		const message1 = $('<tr><th colspan="2">해당 지역에 데이터가 없습니다.</th></tr>');
		const message2 = $('<tr><th colspan="2">해당 지역에 데이터가 없습니다.</th></tr>');

		$('#bldTable').append(message1);

		$('#landTable').append(message2);
 	}
 	
 	// code 이름 가져오기
    function getCodeByName(code){
   		const _codeInfo = codeInfo.filter(info => info.code === code);
   		if(_codeInfo.length > 0){
   			return _codeInfo[0].codeNm;
   		}else{
   			return '-';	
   		}
    }
 	
    function numberWithCommas (x) {
        if (!x) {
            return 0;
        }

        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    };
    
 	// 메시지 수신 받는 eventListener 등록
	//window.removeEventListener('message', receiveMsgFromChild);

    // 자식으로부터 메시지 수신 (iframe event)
    function receiveMsgFromChild( e ) {
        const messageNm = e.data.name;
        
        if(messageNm === 'columnInfo'){
        	codeInfo = e.data.value;
        }else if(messageNm =='검색 목록'){
        	let _cqlFilter = e.data.value.cqlFilter;
        	if(e.data.value.obj && (cqlFilter === '' || !cqlFilter)){
        		_cqlFilter = 'ogc_fid in (' + e.data.value.obj.toString() +')';
        	}
        	
        	cqlFilter = _cqlFilter;
        	loadBldLayer();
        }else if(messageNm === '선택 데이터'){
        	const data =e.data.value;
        	const layer = geoMap.getLayers().getArray().filter((l) => l.get('title') === '건축물 레이어');

        	if(layer.length > 0){
        		const feature = layer[0].getSource().getFeatures().filter((f) => f.getProperties()['ogc_fid'] === data.ogcFid);
        		if(feature.length > 0){
        			geoMap.getView().fit(feature[0].getGeometry().getExtent());
        			if(geoMap.getView().getZoom() > 20){
        				geoMap.getView().setZoom(19);
        			}
        			select.getFeatures().clear();
        			select.getFeatures().push(feature[0]);

        	    	documentDisplay('bldFeatureInfoPop', 'none');
        		}
        	}
        }
    }
    
    function closePopup(){
    	documentDisplay('bldFeatureInfoPop', 'none');
    }
    
    function handleLayerSwitch (val){
    	const layer = geoMap.getLayers().getArray().filter(lyr => lyr.get('title') === '건축물 레이어');
    	if(layer.length > 0){
    		if(val === 1){
    			if(!$('#bld_10_less')[0].style.color){
    				$('#bld_10_less')[0].style.color = '#b6b6b6';
    				layer[0].getSource().getFeatures().forEach(feature => {
    					const val = feature.getProperties()['pasg_ycnt'];
    					if (val >= 1 && val < 10) {
    						feature.setStyle(olStyleFunc('rgba(0,0,0,0)', 'rgba(0,0,0,0)', null))
		                }
    				})
    			}else{
    				$('#bld_10_less')[0].style.color = '';
    				layer[0].getSource().getFeatures().forEach(feature => {
    					const val = feature.getProperties()['pasg_ycnt'];
    					if (val >= 1 && val < 10) {
    						feature.setStyle(olStyleFunc('rgba(158,158,158,0.6)', '#5D5D5D', null));
		                }
    				})
    			}
    		}else if(val === 2){
    			if(!$('#bld_20_less')[0].style.color){
    				$('#bld_20_less')[0].style.color = '#b6b6b6';
    				layer[0].getSource().getFeatures().forEach(feature => {
    					const val = feature.getProperties()['pasg_ycnt'];
    					if (val >= 10 && val < 20) {
    						feature.setStyle(olStyleFunc('rgba(0,0,0,0)', 'rgba(0,0,0,0)', null))
		                }
    				})
    			}else{
    				$('#bld_20_less')[0].style.color = '';
    				layer[0].getSource().getFeatures().forEach(feature => {
    					const val = feature.getProperties()['pasg_ycnt'];
    					if (val >= 10 && val < 20) {
    						feature.setStyle(olStyleFunc('rgba(255,165,0,0.6)', '#CC723D', null));
		                }
    				})
    			}
    		}else if(val === 3){
    			if(!$('#bld_20_more')[0].style.color){
    				$('#bld_20_more')[0].style.color = '#b6b6b6';
    				layer[0].getSource().getFeatures().forEach(feature => {
    					const val = feature.getProperties()['pasg_ycnt'];
    					if (val >= 20) {
    						feature.setStyle(olStyleFunc('rgba(0,0,0,0)', 'rgba(0,0,0,0)', null))
		                }
    				})
    			}else{
    				$('#bld_20_more')[0].style.color = '';
    				layer[0].getSource().getFeatures().forEach(feature => {
    					const val = feature.getProperties()['pasg_ycnt'];
    					if (val >= 20) {
    						feature.setStyle(olStyleFunc('rgba(255,0,0,0.6)', '#CC3D3D', null));
		                }
    				})
    			}
    		}
    	}
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
    
    function handleSelResult(){
    	geoMap.getView().fit(select.getFeatures().getArray()[0].getGeometry().getExtent());
    	if(geoMap.getView().getZoom() > 20){
    		geoMap.getView().setZoom(19);
    	}
    	const iframe = document.getElementById('sh_iframe_bld').contentWindow;
    	const properties = select.getFeatures().getArray()[0].getProperties();
    	const camelProperties = camelCase(properties);
    	iframe.postMessage({selectData: JSON.parse(JSON.stringify(camelProperties))}, '<%=mangoServerURL%>');
    	
    	documentDisplay('bldFeatureInfoPop', 'none');
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
    
    function handleChangeBldTable(e){
    	const idx = Number(e.value);
    	createBldTable(idx);
   	}

	// 초기화 이벤트
	function leaveBiz () {
		geoMap.removeInteraction(select);
		geoMap.removeLayer(bldLayer);
	}
	
	function documentDisplay (name, val){
		if(document.getElementsByClassName(name).length > 0){			
			document.getElementsByClassName(name)[0].style.display = val;
		}
	}
  </script>
  


  <body>
   		<div class="bldFeatureInfoPop" style="display:none;">
	  		<div class="header">
	            <h1 class="BGboderTit">· 속성정보 비교</h1>
	            <img src="${pageContext.request.contextPath}../../resources/img/icons/Ic_Close.svg" alt="닫기" class="closeBtn" id="PopClose" onclick="closePopup()"/>
	        </div>
	        <div class="body">
	        	<div>
                    <div class="tableTab">
                        <span class="hover">전사자원관리시스템</span>
                    </div>

                    <div class="tableWrap">

                        <table>
                            <caption>건물</caption>
                            <tbody id="shBldTable"></tbody>
                        </table>

                        <table>
                            <caption>토지</caption>
                            <tbody id="shLandTable"></tbody>
                        </table>
                    </div>
                </div>
                
                <div>
                    <div class="tableTab">
                        <span class="hover">공공데이터포털</span>
                    </div>

                    <div class="tableWrap">
                        <form class="basForm" style="display:none;">
                            <select id="search1" onchange="handleChangeBldTable(this)">
                            </select>
                        </form>

                        <table>
                            <caption>건물</caption>
                            <tbody id="bldTable"></tbody>
                        </table>

                        <table>
                            <caption>토지</caption>
                            <tbody id="landTable"></tbody>
                        </table>
                    </div>
                </div>
                
	        	<button type="button" class="w100Btn" onclick="handleSelResult()">선택</button>
	        </div>
	  	</div>
	    <div class='leftTModalWrap bld' style="height: 100%;">
			<iframe title="SH업무연계-건축물iframe" id="sh_iframe_bld" src="<%=mangoServerURL%>/iframe_bld" style="height: 100%;">
			</iframe>
		</div>
	<!-- </div> -->
		<div class="legendModal">
			<div class='legendDiv bld-4'>
				<h1 class="header">경과년수</h1>
				<ul class="legendList">
					<li>
				        <span class="legendBox bld1"></span>
				        <p id="bld_10_less" onclick="handleLayerSwitch(1)">10년 미만</p>
				    </li>
				    <li>
				        <span class="legendBox bld2"></span>
				        <p id="bld_20_less" onclick="handleLayerSwitch(2)">10년 이상</p>
				    </li>
				    <li>
				        <span class="legendBox bld3"></span>
				        <p id="bld_20_more" onclick="handleLayerSwitch(3)">20년 이상</p>
				    </li>
				</ul>

				<h1 class="header">현황 : 경과년수 20년 이상</h1>
				<ul class="legendList" id="cnt_over20">
					
				</ul>
				
				<h1 class="header">현황 : 경과년수 10년 ~ 20년</h1>
				<ul class="legendList" id="cnt_under20">
					
				</ul>

				<h1 class="header">현황 : 경과년수 10년 미만</h1>
				<ul class="legendList" id="cnt_under10">
					
				</ul>
			</div>
		</div>
  </body>
</html>
