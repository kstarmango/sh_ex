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
		.legendList .legendBox.hous1{
		    background-color: #30a9de;
		}
		.legendList .legendBox.hous2{
		    background-color: #efdc05;
		}
		.legendList .legendBox.hous3{
		    background-color: #e53a40;
		}
		
		.housFeatureInfoPop{
			position: absolute;
		    bottom: 1.6rem;
		    right: 0rem;
		    border-radius: 8px;
		    background-color: #F7F9FB;
		    box-shadow: 0px 0px 12px 0 rgba(0, 0, 0, 0.16);
		    z-index: 5;
		}
		.housFeatureInfoPop .header{
			position: relative;
		    display: flex;
		    gap: 8px;
		    width: 100%;
		    align-items: center;
		    border-top: 1px solid #E0E6EC;
		    border-bottom: 1px solid #E0E6EC;
		    justify-content: space-between;
		}
		.housFeatureInfoPop .BGboderTit{
		    padding: 1.2rem 1.6rem;
		    font-size: 1.6rem;
		    font-weight: 600;
		    line-height: 2.4rem;
		    color: #778690;
		    background-color: #F5F6FA;
		}
		.housFeatureInfoPop .header .closeBtn{
		    margin-right: 1.6rem;
    		cursor: pointer;
		}
		.housFeatureInfoPop .body{
			display: flex;
		    flex-wrap: wrap;
		    gap: 0 1.6rem;
		    padding: 1.2rem;
		}
		.housFeatureInfoPop .body > div{
		    flex-grow: 1;
		}
		.housFeatureInfoPop .body .tableTab{
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
		.housFeatureInfoPop .tableWrap {
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
		.housFeatureInfoPop .tableWrap table {
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
		.housFeatureInfoPop .tableWrap caption {
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
		
	    .housFeatureInfoPop .body .w100Btn{
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
   
	let housLayer;
	
	let select;
	
	let codeInfo;
	
	let layerNm = 'LANDSYS:v_thaep';

    window.addEventListener( 'message', receiveMsgFromChild );
	
    $(document).ready(function () {
      $('#sub_content').show();
      loadhousLayer(null);
    });
    
 	// hous layer 불러오기
    function loadhousLayer(filter){
 		if($('#hous_01').length > 0){ 			
	 		$('#hous_01')[0].style.color = '';
	 		$('#hous_02')[0].style.color = '';
	 		$('#hous_03')[0].style.color = '';
 		}
 		
    	//geoMap.addLayer();
    	let cqlFilter = filter;
    	let featureIdFilter = null;
    	
    	const duplicateLyr = geoMap.getLayers().getArray().filter(l => l.get('title') === '빈집 레이어');
    	if(duplicateLyr.length > 0){
    		geoMap.removeLayer(duplicateLyr[0]);
    	}
    	 
    	let typeName = layerNm;
        const urlTemplate = '<%=syGisURL%>/geoserver' + '/LANDSYS/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=' + typeName + '&CQL_FILTER={{CQLFILTER}}&outputFormat=application/json&srsname=EPSG:3857';
        // const urlTemplate = 'https://shgis.syesd.co.kr/geoserver' + '/LANDSYS/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=' + typeName + '&CQL_FILTER={{CQLFILTER}}&FEATUREID={{FEATUREID}}&outputFormat=application/json&srsname=EPSG:3857';
    	
    	let url = cqlFilter ? urlTemplate.replace('{{CQLFILTER}}', cqlFilter) : urlTemplate.replace('&CQL_FILTER={{CQLFILTER}}', '');
        // url = featureIdFilter ? url.replace('{{FEATUREID}}', featureIdFilter) : url.replace('&FEATUREID={{FEATUREID}}', '');
        
    	$.ajax({
			dataType: 'json',
			url: "/api/cmmn/proxy.do?url=" + url,
			// url:
			success: function(res) {
				housLayer = new ol.layer.Vector({
					source: new ol.source.Vector({}),
					title: '빈집 레이어',
					style: function (feature) {
						
						const val = feature.getProperties()['emph_rcpt_prgr_cd'];
						
						const colors = ['rgba(48,169,222,0.6)', 'rgba(239,220,5,0.6)', 'rgba(229,58,64,0.6)'];
						const strokeColors = ['#006F84', '#D3C64A', '#840000'];
						let fillColor = colors[0];
						let strokeColor = strokeColors[0];

		                if (val === '02') {
		                    fillColor = colors[1];
		                    strokeColor = strokeColors[1];
		                } else if (val === '03') {
		                    fillColor = colors[2];
		                    strokeColor = strokeColors[2];
		                }

		                return olStyleFunc(fillColor, strokeColor, 1);
					}
				})
				const features = new ol.format.GeoJSON().readFeatures(res);
				housLayer.getSource().addFeatures(features);

				geoMap.getView().fit(housLayer.getSource().getExtent(), geoMap.getSize());

				geoMap.addLayer(housLayer);
				
				select = new ol.interaction.Select({
					title: 'hous_select',
					layers:[housLayer],
					source: housLayer.getSource(),
					wrapX:false,
					style: function(feature){
						
						const val = feature.getProperties()['emph_rcpt_prgr_cd'];

						const colors = ['rgba(48,169,222,0.6)', 'rgba(239,220,5,0.6)', 'rgba(229,58,64,0.6)'];
						
						let fillColor = colors[0];

						 if (val === '02') {
		                    fillColor = colors[1];
		                } else if (val === '03') {
		                    fillColor = colors[2];
		                }
						
						return olStyleFunc(fillColor, 'rgb(255, 0, 0)', 2);
					}
				})
				select.on('select', function(e) {

                	const basForm = $('.tableWrap .basForm');
                	if(basForm.length > 0){                		
	                	basForm[0].style.display = 'none';
	                	
						/* 1개만 select */
						if(e.target.getFeatures().getArray().length >1){							
							const length = e.target.getFeatures().getArray().length;
							for(let i=length -2; i>=0; i--){
								e.target.getFeatures().remove(e.target.getFeatures().getArray()[i]);
							}
						}
						
						if(e.selected.length > 0){
					    	documentDisplay('housFeatureInfoPop', 'block');
							setPopContent(layerNm);
							excuteBld(e.selected[0].getProperties()['pnu_cd']);
						}else{
					    	documentDisplay('housFeatureInfoPop', 'none');
						}
                	}
					
				})
				
				geoMap.addInteraction(select);
		    	documentDisplay('housFeatureInfoPop', 'none');
				
				
				const urlParams = new URL(location.href).searchParams;
				if(urlParams.get('pnu')){
					const feature = housLayer.getSource().getFeatures().filter(f => 
						f.getProperties()['pnu_cd'] === urlParams.get('pnu')
					);

					if(feature.length > 0){
	        			//select.getFeatures().push(feature[0]);
	        			geoMap.getView().fit(feature[0].getGeometry().getExtent());
	        			if(geoMap.getView().getZoom() > 20){
	        				geoMap.getView().setZoom(19);
	        			}
					}
				}
				
			},
			error: function(err){
				console.log(err);
			}
    	});


		$.ajax({
			type: 'GET',
			url: '<%=mangoServerURL%>/api/hous/getStatusLayer.json',

			success: (res) => {
				const vectorSource = new ol.source.Vector({});
				const emptyHousStatusLayer = new ol.layer.Vector({
					title: '빈집매입 현황',
					visible: true,
					sytles: '',
					maxZoom: 13,
					source: vectorSource
				});
				const features = new ol.format.GeoJSON().readFeatures(res);
				vectorSource.addFeatures(features);
				

				let countArray = res.features.map((ele) => ele.properties.count).sort((a, b) => a - b);
				let arrayLength = countArray.length;
				let separationArray = [countArray[0]];
				for (let i = 1; i <= 5; i++) {
					separationArray.push(countArray[parseInt((arrayLength / 5) * i) - 1]);
				}

				emptyHousStatusLayer.setStyle((feature)=>{
					let count = feature.get('count');

					const style = new ol.style.Style({
						// stroke: new Stroke({ color: '#000', width: 1 }),
						fill: new ol.style.Fill({ color: [255, 255, 255, 0.5] }),
					});

					if (count === 0) {
						return style;
					} else if (count > separationArray[0] && count <= separationArray[1]) {
						style.getFill().setColor([237, 248, 251, 0.7]);
					} else if (count > separationArray[1] && count <= separationArray[2]) {
						style.getFill().setColor([178, 226, 226, 0.7]);
					} else if (count > separationArray[2] && count <= separationArray[3]) {
						style.getFill().setColor([102, 194, 164, 0.7]);
					} else if (count > separationArray[3] && count <= separationArray[4]) {
						style.getFill().setColor([44, 162, 95, 0.7]);
					} else if (count > separationArray[4] && count <= separationArray[5]) {
						style.getFill().setColor([0, 109, 44, 0.7]);
					}
					return style;
				});

				geoMap.addLayer(emptyHousStatusLayer);

				let legendHTML = '<li>' +
						'<span class="legendBox" style="background-color: #edf8fb"></span>' +
						'<p id="emptyHousStatusLayer_1" >'+separationArray[0]+'-'+separationArray[1]+'</p>' +
						'</li>' +
						'<li>' +
						'<span class="legendBox" style="background-color: #b2e2e2"></span>' +
						'<p id="emptyHousStatusLayer_2" >'+separationArray[1]+'-'+separationArray[2]+'</p>' +
						'</li>' +
						'<li>' +
						'<span class="legendBox" style="background-color: #66c2a4"></span>' +
						'<p id="emptyHousStatusLayer_3" >'+separationArray[2]+'-'+separationArray[3]+'</p>' +
						'</li>' +
						'<li>' +
						'<span class="legendBox" style="background-color: #2ca25f"></span>' +
						'<p id="emptyHousStatusLayer_4" >'+separationArray[3]+'-'+separationArray[4]+'</p>' +
						'</li>' +
						'<li>' +
						'<span class="legendBox" style="background-color: #006d2c"></span>' +
						'<p id="emptyHousStatusLayer_5" >'+separationArray[4]+'-'+separationArray[5]+'</p>' +
						'</li>' ;
					
				$('.legendModal .legendDiv #emptyHousStatus')[0].innerHTML = legendHTML;
			},
			error: (err) => {
				reject(err);
			},
		});
		// const emptyHousStatusLayer = new ol.layer.Vector({
		// 	title: '빈집매입 현황',
		// 	visible: true,
		// 	sytles: '',
		// 	maxZoom: 13,
		// 	source: new ol.source.Vector({
		// 		url: '<%=mangoServerURL%>/shex/api/hous/getStatusLayer.json',
		// 		format: new ol.format.GeoJSON(),
		// 	}),
		// });



		// 
		// geoMap.addLayer(emptyHousStatusLayer);

    }
 	
 	function setPopContent (layerNm) {
 		$('.housFeatureInfoPop .body .tableWrap #shBldTable').empty();
 		
    	const feature = select.getFeatures().getArray()[0];

    	const properties = feature.getProperties();
    	let bldTable;
    	if(layerNm === 'LANDSYS:v_thaep'){
    		bldTable = '<tr><th width="35%">공고유형코드</th><td>' + (properties.pbanc_ty_cd ? properties.pbanc_ty_cd : '-') + '</td></tr>' +
	    		'<tr><th>매입신청번호</th><td>' + (properties.acqr_aply_no ? properties.acqr_aply_no : '-') + '</td></tr>' +
	    		'<tr><th>접수순서</th><td>' + (properties.rcpt_ord ? properties.rcpt_ord : '-') + '</td></tr>' +
	    		'<tr><th>매도희망가격내용</th><td>' + (properties.sell_hop_prc_cn ? (numberWithCommas(properties.sell_hop_prc_cn)) : '-') + '</td></tr>' +
	    		'<tr><th>빈집주소</th><td>' + (properties.emph_addr ? properties.emph_addr : '-') + '</td></tr>' +
	    		'<tr><th>PNU코드</th><td>' + (properties.pnu_cd ? properties.pnu_cd : '-') + '</td></tr>' +
	    		'<tr><th>빈집접수진행</th><td>' + (properties.emph_rcpt_prgr_cd ? (getCodeByName('emph_rcpt_prgr_cd', properties.emph_rcpt_prgr_cd)) : '-') + '</td></tr>' +
	    		'<tr><th>토지면적</th><td>' + (numberWithCommas(properties.land_ar)) + '</td></tr>' +
	    		'<tr><th>특이사항</th><td>' + (properties.pclr_mtr ? properties.pclr_mtr : '-') + '</td></tr>';
    	}else{
    		bldTable = '<tr><th width="35%">활용관리번호</th><td>' + (properties.puse_mng_no ? properties.puse_mng_no : '-') + '</td></tr>' +
	    		'<tr><th>매입신청번호</th><td>' + (properties.acqr_aply_no ? properties.acqr_aply_no : '-') + '</td></tr>' +
	    		'<tr><th>매매관리번호</th><td>' + (properties.snb_mng_no ? properties.snb_mng_no : '-') + '</td></tr>' +
	    		'<tr><th>활용그룹관리번호</th><td>' + (properties.puse_grp_mng_no ? properties.puse_grp_mng_no : '-') + '</td></tr>' +
	    		'<tr><th>필지활용분류</th><td>' + (properties.lotl_puse_cls_cd ? properties.lotl_puse_cls_cd : '-') + '</td></tr>' +
	    		'<tr><th>매매계약일자</th><td>' + (properties.snb_ctrt_ymd ? properties.snb_ctrt_ymd : '-') + '</td></tr>' +
	    		'<tr><th>PNU코드</th><td>' + (properties.pnu_cd ? properties.pnu_cd : '-') + '</td></tr>' +
	    		'<tr><th>건축연면적</th><td>' + (numberWithCommas(properties.bld_tfar)) + '</td></tr>' +
	    		'<tr><th>토지면적</th><td>' + (numberWithCommas(properties.land_ar)) + '</td></tr>';
    	}
		
    	$('.housFeatureInfoPop .body .tableWrap #shBldTable').append($(bldTable));
 	}
 	

    function numberWithCommas (x) {
        if (!x) {
            return 0;
        }

        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
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

        $('#landTable').empty();

        const theadList = {
            lndpclAr: '대지면적(㎡)',
            lndcgrCodeNm: '지목',
            prposArea1Nm: '용도지역',
        };


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
    
 	// 메시지 수신 받는 eventListener 등록
	//window.removeEventListener('message', receiveMsgFromChild);

    // 자식으로부터 메시지 수신 (iframe event)
    function receiveMsgFromChild( e ) {
        const messageNm = e.data.name;
        
        if(messageNm === 'columnInfo'){
        	codeInfo = e.data.value;
        }else if(messageNm =='검색 목록'){
        	let cqlFilter = e.data.value.cqlFilter;
        	if(e.data.value.obj && (cqlFilter === '' || !cqlFilter)){
        		cqlFilter = 'ogc_fid in (' + e.data.value.obj.toString() +')';
        	}
        	
			layerNm = e.data.value.layerNm;
        	
        	loadhousLayer(cqlFilter);
        }else if(messageNm === '선택 데이터'){
        	const data =e.data.value;
        	const layer = geoMap.getLayers().getArray().filter((l) => l.get('title') === '빈집 레이어');
        	if(layer.length > 0){
        		const feature = layer[0].getSource().getFeatures().filter((f) => f.getProperties()['ogc_fid'] === data.ogcFid);
        		if(feature.length > 0){
        			geoMap.getView().fit(feature[0].getGeometry().getExtent());
        			if(geoMap.getView().getZoom() > 20){
        				geoMap.getView().setZoom(19);
        			}
        			select.getFeatures().clear();
        			select.getFeatures().push(feature[0]);

        	    	documentDisplay('housFeatureInfoPop', 'none');
        			//popup.setPosition(ol.extent.getCenter(feature[0].getGeometry().getExtent()));
        		}
        	}
        }
    }
    function handleLayerSwitch (value) {
    	const layer = geoMap.getLayers().getArray().filter(lyr => lyr.get('title') === '빈집 레이어');
    	if(layer.length > 0){
    		if(!$('#hous_' + value)[0].style.color){
				$('#hous_' + value)[0].style.color = '#b6b6b6';
				layer[0].getSource().getFeatures().forEach(feature => {
					const val = feature.getProperties()['emph_rcpt_prgr_cd'];
					if (val === value) {
						feature.setStyle(olStyleFunc('rgba(0,0,0,0)', 'rgba(0,0,0,0)', null));
	                }else if(value === '01' && !val){
						feature.setStyle(olStyleFunc('rgba(0,0,0,0)', 'rgba(0,0,0,0)', null));
					}
				})
			}else{
				const colors = ['rgba(48,169,222,0.6)', 'rgba(239,220,5,0.6)', 'rgba(229,58,64,0.6)'];
				const strokeColors = ['#006F84', '#D3C64A', '#840000'];
				const fillColor = colors[Number(value) -1];
				const strokeColor = strokeColors[Number(value) -1];
				
				$('#hous_' + value)[0].style.color = '';
				layer[0].getSource().getFeatures().forEach(feature => {
					const val = feature.getProperties()['emph_rcpt_prgr_cd'];
					if (val === value) {
						feature.setStyle(olStyleFunc(fillColor, strokeColor, 1));
	                }else if(value === '01' && !val){
	                	feature.setStyle(olStyleFunc(fillColor, strokeColor, 1));
					}
				})
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
    
    function closePopup () {
    	documentDisplay('housFeatureInfoPop', 'none');
    }

    function handleSelResult(){
    	geoMap.getView().fit(select.getFeatures().getArray()[0].getGeometry().getExtent());
    	if(geoMap.getView().getZoom() > 20){
    		geoMap.getView().setZoom(19);
    	}
    	const iframe = document.getElementById('sh_iframe_hous').contentWindow;
    	const properties = select.getFeatures().getArray()[0].getProperties();
    	const camelProperties = camelCase(properties);
    	iframe.postMessage({selectData: JSON.parse(JSON.stringify(camelProperties))}, '<%=mangoServerURL%>');
    	
    	documentDisplay('housFeatureInfoPop', 'none');
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
		geoMap.removeLayer(housLayer);
	}

	function documentDisplay (name, val){
		if(document.getElementsByClassName(name).length > 0){			
			document.getElementsByClassName(name)[0].style.display = val;
		}
	}
  </script>
  


  <body>
		<div class="housFeatureInfoPop" style="display:none;">
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
	    <div class='leftTModalWrap hous' style="height: 100%;">
			<iframe title="SH업무연계-빈집iframe" id="sh_iframe_hous" src="<%=mangoServerURL %>/iframe_hous" style="height: 100%;">
			</iframe>
		</div>
		
		<div class="legendModal">
			<div class='legendDiv hous-2'>
				<h1 class="header">접수진행상황</h1>
				<ul class="legendList">
					<li>
				        <span class="legendBox hous1"></span>
				        <p id="hous_01" onclick="handleLayerSwitch('01')">진행중</p>
				    </li>
				    <li>
				        <span class="legendBox hous2"></span>
				        <p id="hous_02" onclick="handleLayerSwitch('02')">진행중단</p>
				    </li>
				    <li>
				        <span class="legendBox hous3"></span>
				        <p id="hous_03" onclick="handleLayerSwitch('03')">심의완료</p>
				    </li>
				</ul>

				<h1 class="header">현황 : 분포</h1>
				<ul class="legendList" id="emptyHousStatus">

				</ul>
			</div>
		</div>
  </body>
</html>
