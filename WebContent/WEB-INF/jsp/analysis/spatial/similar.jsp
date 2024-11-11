<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core"%> <%@ taglib prefix="sf"
uri="http://www.springframework.org/tags/form"%> <%@ taglib prefix="ui"
uri="http://egovframework.gov/ctl/ui"%> <%@ taglib prefix="fn"
uri="http://java.sun.com/jsp/jstl/functions"%> <%@ taglib prefix="spring"
uri="http://www.springframework.org/tags"%> <%@ page
import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%> <%@ page
import="egovframework.mango.config.SHResource"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
	<script type="text/javascript">
		var contextPath = '${contextPath}';
		var shexPath = "<%=SHResource.getValue("sh.server.schema")%>://<%=SHResource.getValue("sh.server.url")%>";
		var componentData = [];

		$(document).ready(function(){
			$('#sub_content').show();

			componentData = [
					{ type: 'search', inputType: 'input_Lyr', title: '사업대상지', input: 'field', features:  'input_features'},
					{ type: 'field' },
					{
						id: 'overLyr',
						type: 'button',
						title: '중첩레이어 선택',
						arr: [
							{ id: 'landsys_ex.v_thaep', name: '업무연계 빈집 매매' },
							{ id: 'landsys_ex.v_b_thabm0001', name: '업무연계 건축물' },
							{ id: 'landsys_ex.v_vpppd0b01', name: '업무연계 사업기획' },
						],
						option: 'similar'
					},
					{
						id: 'analyType',
						type: 'button',
						title: '분석방법 선택',
						arr: [
							{ id: 'nearby', name: '인근', option: 'nearby'},
							{ id: 'overlap', name: '중첩' },
							{ id: 'adjoin', name: '인접' },
						],
						option: 'similar'
					},
					{
						id: 'touchBoundaryDistance',
						inputType: 'number',
						type: 'distanceInput',
						title: '인근 거리 설정(m)',
					},
				];

			doRenderSearchComp(componentData);
		})

		function switchSelectOption(e, type){
			$(e.target).parent().find('.selected').removeClass('selected');
			$(e.target).addClass('selected');

			var componentData = [];

			switch (type) {
				case ('사업대상지'):
					componentData.push({ type: 'search', inputType: 'input_Lyr', title: '사업대상지', input: 'field', features:  'input_features'}),
					componentData.push({ type: 'field' });
					break;
				case ('주소검색'):
					componentData.push({ type: 'addr' });
					break;
				case ('myData'):
					componentData.push({ type: 'myData' });
					break;
				default:
					break;
			}

			const commonData = [
				{
					id: 'overLyr',
					type: 'button',
					title: '중첩레이어 선택',
					arr: [
						{ id: 'landsys_ex.v_thaep', name: '업무연계 빈집 매매' },
						{ id: 'landsys_ex.v_b_thabm0001', name: '업무연계 건축물' },
						{ id: 'landsys_ex.v_vpppd0b01', name: '업무연계 사업기획' }
					],
					option: 'similar'
				},
				{
					id: 'analyType',
					type: 'button',
					title: '분석방법 선택',
					arr: [
						{ id: 'nearby', name: '인근' },
						{ id: 'overlap', name: '중첩' },
						{ id: 'adjoin', name: '인접' }
					],
					option: 'similar'
				},
				{
					id: 'touchBoundaryDistance',
					inputType: 'number',
					type: 'distanceInput',
					title: '인근 거리 설정(m)'
				}
			];
			componentData.push(...commonData);

			doRenderSearchComp(componentData);
		}

		function doAnalysis(){
			doBeforeAnalysis();

			geoMap.getLayers().getArray()
			.filter(lyr => lyr.get('title') === 'analysis').map(ele => geoMap.removeLayer(ele));

			const inputFeature = $('#output_field').find('.selected').attr('value') || $('#input_features').find('.selected').attr('data-addrWKT');
			const overlayLyr = $('#overLyr .selected').attr('value');
			const analyType = $('#analyType .selected').attr('value');
			const buffer = $('#touchBoundaryDistance').val();

			const data = { inputFeature, overlayLyr, analyType };
			if(buffer) data.buffer = buffer;
			
			if(inputFeature && overlayLyr && analyType) {
				$.ajax({
					type : "POST",
					async : true,
					url : "<%=RequestMappingConstants.WEB_ANAL_SIMILAR_BIZ%>",
					dataType : "json",
					data,
					error : function(response, status, xhr) {
						if (xhr.status == '404') {
							alert('분석에 실패했습니다.');
						}
					},
					success : function(data, status, xhr){
						if(!data || data.result === false ){
							alert('분석에 실패했습니다.');
							return;
						}
						try {							
							resetLegend();
	
							const featureData = data.data || data.result;
							if(!featureData['features'] || featureData['features'].length == 0){
								alert('분석 결과가 존재하지 않습니다. 조건을 변경해주세요');
								return;
							}
	
							const features_4326 = new ol.format.GeoJSON().readFeatures(featureData);
							const feature_3857 = features_4326.map(f => new ol.Feature(f.getGeometry().transform('EPSG:4326', 'EPSG:3857')))
							
							var exportKey = xhr.getResponseHeader('export_key');
							Table(tableData(features_4326));
							resultMap(feature_3857, exportKey);
							resultLegend();
						} catch (error) {
							console.log(error);
							doAfterAnalysis();
						}
					},
					complete: function(xhr, status) {
						doAfterAnalysis();
					}
				});
			} else {
				alert('값을 입력해주세요.');
				doAfterAnalysis();
			}
		}

		function resultLegend(){
			const analyType_ = $('#analyType .selected').attr('value');
			let legendItem = []
			if(analyType_ === 'nearby')	 legendItem = [{ color: 'rgb(0, 255, 0)', name: '인근' }];
			if(analyType_ === 'overlap') legendItem = [{ color: 'rgb(0, 0, 255)', name: '중첩' }];
			if(analyType_ === 'adjoin')	 legendItem = [{ color: 'rgb(255, 0, 0)', name: '인접' }];

			showLegend(legendItem);
		}

		function resultMap(features, key){
			var vectorLayer = new ol.layer.Vector({
				title: "analysis", // similar
				// serviceNm: $('#overLyr .selected').text(),
				serviceNm: "유사사업 검토",
				source: new ol.source.Vector()
			});

			features.forEach((feature) => {
				vectorLayer.getSource().addFeature(feature);
			})

			const analyType_ = $('#analyType .selected').attr('value');

			vectorLayer.setStyle(new ol.style.Style({
				fill: new ol.style.Fill({
            color: analyType_ === 'nearby' ? 'rgb(0, 255, 0)' : analyType_ === 'overlap' ? 'rgb(0, 0, 255)' : analyType_ === 'adjoin' ? 'rgb(255, 0, 0)' : null,
        })
			}));

			geoMap.addLayer(vectorLayer);
			analLayer(contextPath, key);
			geoMap.getView().fit(vectorLayer.getSource().getExtent());
		}

		function tableData(features){
			var headerTit = [];
			var layerNm = '레이어';

			const inputData = $('#basic .selected').attr('id');
			const overlayLyr = $('#overLyr .selected').attr('value');
			const analyType = $('#analyType .selected').attr('value');

			// if(inputData == 'business'){
			if(overlayLyr==='landsys_ex.v_thaep'){
				headerTit = [['공고유형코드','pbanc_ty_cd'],
					['매입신청번호','acqr_aply_no'],
					['접수순서','rcpt_ord'],
					['빈집접수구분코드','emph_rcpt_se_cd'],
					['빈집매입접수코드','emph_acqr_rcpt_cd'],
					['연접지대상주소','cngr_trgt_addr'],
					['접수일자','rcpt_ymd'],
					['빈집시작연월','emph_bgng_ym'],
					['매도희망가격내용','sell_hop_prc_cn'],
					['우편번호','zip'],
					['빈집주소','emph_addr'],
					['상세주소','daddr'],
					['시군구코드','sgg_cd'],
					['법정동코드','stdg_cd'],
					['본번','mno'],
					['부번','sno'],
					['pnu코드','pnu_cd'],
					['현장조사일자','spot_exmn_ymd'],
					['빈집접수진행코드','emph_rcpt_prgr_cd'],
					['지목코드','ldcg_cd'],
					['지역지구용도명','regn_rgn_us_nm'],
					['토지면적','land_ar'],
					['건축면적','bld_ar'],
					['건축연면적','bld_tfar'],
					['빈집구조명','emph_strc_nm'],
					['사용승인일자','use_aprv_ymd'],
					['건축물용도명','bldng_us_nm'],
					['지상층수','grnd_nofl'],
					['지하층수','udgd_nofl'],
					['탁상감정평가의뢰일자','armc_apasmt_rqst_ymd'],
					['토지가액','land_pram'],
					['탁상감정평가법인명','armc_apasmt_corp_nm'],
					['건물가액','bldg_pram'],
					['소위원회차수','sbcm_tms'],
					['소위원회일자','sbcm_ymd'],
					['본위원회차수','plco_tms'],
					['본위원회일자','plco_ymd'],
					['위원회결과구분코드','cmti_rsl_se_cd'],
					['빈집활용용도명','emph_puse_us_nm'],
					['빈집실태조사구분코드','emph_accn_exmn_se_cd'],
					['비고','rmk'],
					['빈집첨부파일일련번호','emph_atch_file_sn'],
					['특이사항','pclr_mtr'],
					['데이터삭제여부','dat_del_yn'],
					['데이터삭제일시','dat_del_dt'],
					['데이터삭제자id','dat_delr_id'],
					['시스템등록자id','sys_rgtr_id'],
					['시스템등록일시','sys_reg_dt'],
					['시스템수정자id','sys_mdfr_id'],
					['시스템수정일시','sys_mdfcn_dt'],
					['매매관리번호','snb_mng_no'],
					['빈집계약진행코드','emph_ctrt_prgr_cd'],
					['매매협의통보일자','snb_dsc_ntfctn_ymd'],
					['매매협의금액','snb_dsc_amt'],
					['매매협의여부','snb_dsc_yn'],
					['매매협의비고','snb_dsc_rmk'],
					['매입금액','acqr_amt'],
					['매매계약일자','snb_ctrt_ymd'],
					['매매계약금액','snb_ctrt_amt'],
					['계약금지출일자','ctrt_am_expd_ymd'],
					['중도금액','midp_amt'],
					['중도금지출일자','midp_am_expd_ymd'],
					['잔금','blnc'],
					['잔금지출일자','blnc_expd_ymd'],
					['감정평가수수료','apasmt_fee'],
					['중개보수비','medi_rwrd_ct'],
					['법무비','jdaf_ct'],
					['통합업무결재연계처리번호','intgr_busi_atrz_link_prcs_no'],
					['통합업무결재상태코드','intgr_busi_atrz_sta_cd'],
					['소유권이전등기일자','trfos_rg_ymd'],
				]
			}else if(overlayLyr==='landsys_ex.v_b_thabm0001'){
				headerTit = [['단지id','hcpx_id'],
					['동번호','dng_no'],
					['pnu코드','pnu_cd'],
					['사업코드','biz_cd'],
					['주택형태구분코드','hs_shap_se_cd'],
					['경과년수','pasg_ycnt'],
					['노후주택여부','dcrt_hs_yn'],
					['건물관리번호','bldg_mng_no'],
					['우편번호','zip'],
					['지번주소','lotno_addr'],
					['상세주소','daddr'],
					['도로명주소','road_nm_addr'],
					['표기동명','mrk_dng_nm'],
					['공급동명','spl_dng_nm'],
					['반지하호수','smbm_ho_cnt'],
					['지상층수','grnd_nofl'],
					['반지하층수','smbm_fl_cnt'],
					['준공일자','cmcn_ymd'],
					['대지면적','bldst_ar'],
					['건축연면적','bld_tfar'],
					['건축허가일자','bld_prmsn_ymd'],
					['사용승인일자','use_aprv_ymd'],
					['구조형식명','strc_frm_nm'],
					['정비구역여부','serv_regon_yn'],
					['담당부서명','chr_dpt_nm'],
					['센터코드','cntr_cd'],
					['3종시설물여부','kd3_fclty_yn'],
					['철거대상여부','rmvl_trgt_yn'],
					['안전관리첨부파일일련번호','sfty_mng_atch_file_sn'],
					['총가구호수','tl_hshd_ho_cnt'],
					['데이터삭제여부','dat_del_yn'],
					['데이터삭제일시','dat_del_dt'],
					['데이터삭제자id','dat_delr_id'],
					['시스템등록자id','sys_rgtr_id'],
					['시스템등록일시','sys_reg_dt'],
					['시스템수정자id','sys_mdfr_id'],
					['시스템수정일시','sys_mdfcn_dt'],
				]
			}else if(overlayLyr==='landsys_ex.v_vpppd0b01'){
				headerTit = [['기획사업일련번호','plng_biz_sn'],
					['기획사업명','plng_biz_nm'],
					['기획사업요청상태코드','plng_biz_ty_cd'],
					['기획사업요청상태코드','plng_biz_dmnd_sta_cd'],
					['사업종료일자','biz_bgng_ymd'],
					['관리부서코드','biz_end_ymd'],
					['담당자ID','mng_dpt_cd'],
					['담당부서코드','pic_id'],
					['담당부서코드','chr_dpt_cd'],
					['공급구청코드','loc_addr'],
					['대표동코드','spl_guofc_cd'],
					['기획사업개요','rprs_dng_cd'],
					['기획사업개요','plng_biz_brief'],
					['종료유형코드','plng_biz_sta_cd'],
					['대표지번주소','end_ty_cd'],
					['대여금액여부','rprs_lotno_addr'],
					['대여금액여부','lon_amt_yn'],
					['사업내용','biz_cn'],
					['대여금액사업내용','lon_amt_biz_cn'],
					['사업계획승인일자','biz_plan_aprv_ymd'],
					['투자심사일자','inv_srng_ymd'],
					['이사회일자','bodt_ymd'],
					['공사착공일자','cstrn_bgncst_ymd'],
					['공사준공일자','cstrn_cmcn_ymd'],
					['사업준공일자','biz_cmcn_ymd'],
					['지구지정일자','rgn_dsgn_ymd'],
					['통합업무결제연계처리번호','intgr_busi_atrz_link_prcs_no'],
					['파일ID','file_id'],
					['GIS연계처리번호','gis_link_prcs_no'],
					['데이터삭제여부','dat_del_yn'],
					['데이터삭제일시','dat_del_dt'],
					['데이터삭제자ID','dat_delr_id'],
					['시스템등록자ID','sys_rgtr_id'],
					['시스템등록일시','sys_reg_dt'],
					['시스템수정자ID','sys_mdfr_id'],
					['시스템수정일시','sys_mdfcn_dt'],
					['부지소유코드','plt_own_se_cd'],
					['사업주체코드','biz_pragt_cd'],
					['GIS객체표시여부','gis_objt_indct_yn'],
					['GIS정보표시여부','gis_info_indct_yn'],
				]
			}

			if(analyType == 'nearby'){
				layerNm.concat('인근 ');
			} else if(analyType == 'overlap'){
				layerNm.concat('중첩 ');
			} else if(analyType == 'adjoin'){
				layerNm.concat('인접 ');
			}

			const tableRowData = features.map((feature) => {
				return headerTit.map(ele=>feature.get(ele[1])!==undefined ? feature.get(ele[1]) : '-')});

			// 레이어 이름, header, row
			return { layerNm, headerTit, tableRowData }
		}

		function Table(data){
			const { layerNm, headerTit, tableRowData } = data
			const reader = new ol.format.GeoJSON();

			modalData = [{ type: 'table' }];
			doRenderModal(modalData);

			$('#content_area #graph').css('display', 'block');
			$('#content_area #graph table').css('table-layout', 'fixed');

			const bodyElement = document.getElementById('dataResultTableBd');
			const headElement = document.getElementById('dataResultTableHd');

			const colGroup = document.createElement('colgroup');

			const headRow = document.createElement('tr');
			headerTit.map(ele=>{
				const thead = document.createElement('th');
				thead.innerText = ele[0];
				headRow.append(thead);

				const col = document.createElement('col');

				if(ele[0] == '특이사항'){ // 서울 종로구 창덕궁길 113-1
					col.style.width = '400px';
				} else if(ele[0] == '건물관리번호') { // 서울 동대문구 사가정로2길 10-10
					col.style.width = '230px';
				} else {
					col.style.width = '155px';
				}

				colGroup.append(col)
			})

			$('#content_area #graph .text table').prepend(colGroup);
			headElement.append(headRow);

			tableRowData.forEach((tableRow) => {
				const row = document.createElement('tr');
				tableRow.map(ele=> {

					const cell = document.createElement('td');
					cell.textContent = ele;
					row.appendChild(cell);
				})

				bodyElement.appendChild(row);
			})
		}
	</script>

	<body>
		<div
			role="tabpanel"
			class="areaSearch full"
			id="tab-02"
			style="overflow: auto"
		>
			<div id="basic">
				<h2 class="tit">유사사업 검토</h2>
				<h3 class="tit">입력 데이터 유형</h3>
				<div class="selectWrap">
					<div class="disFlex">
						<button
							type="button"
							id="business"
							size="10"
							class="form-control input-ib network selected"
							onclick="switchSelectOption(event, '사업대상지')"
						>
							사업대상지
						</button>
						<button
							type="button"
							id="address"
							size="10"
							class="form-control input-ib network"
							onclick="switchSelectOption(event, '주소검색')"
						>
							주소검색
						</button>
						<button
							type="button"
							id="address"
							size="10"
							class="form-control input-ib network"
							onclick="switchSelectOption(event, 'myData')"
						>
							My Data
						</button>
					</div>
				</div>
			</div>
		</div>

		<div class="breakLine"></div>
		<div class="disFlex smBtnWrap" style="padding: 1.6rem">
			<button type="button" class="primaryLine" onclick="initAnalService()">
				초기화
			</button>
			<button type="button" class="primarySearch" onclick="doAnalysis()">
				분석
			</button>
		</div>

		<form id="GISinfoResultForm" name="GISinfoResultForm">
			<input type="hidden" name="geom[]" />
		</form>
	</body>
</html>
