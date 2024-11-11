<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@
taglib prefix="sf" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<script type="text/javascript">
        var contextPath = "${contextPath}";
        var reader = new ol.format.WKT();
        var inputFeatures;
        let analysisResultData = {};
        let selectedResultMenu = 'buld';
        let analysisList = [];
        let currentPage = 1;
        let itemName1 = {
            buld: [
                // ['주용도코드명', 'mainPurpsCdNm'],
                // ['기타용도', 'etcPurps'],
                // ['지붕코드', 'roofCd'],
                // ['지붕코드명', 'roofCdNm'],
                // ['기타지붕', 'etcRoof'],
                ['높이(m)', 'heit'],
                ['지상층수', 'grndFlrCnt'],
                ['지하층수', 'ugrndFlrCnt'],
                ['가구 수(가구)', 'fmlyCnt'],
                ['세대 수(세대)', 'hhldCnt'],
                // ['승용승강기수', 'rideUseElvtCnt'],
                // ['비상용승강기수', 'emgenUseElvtCnt'],
                // ['부속건축물수', 'atchBldCnt'],
                // ['부속건축물면적(㎡)', 'atchBldArea'],
                // ['총동연면적(㎡)', 'totDongTotArea'],
                // ['옥내기계식대수(대)', 'indrMechUtcnt'],
                // ['옥내기계식면적(㎡)', 'indrMechArea'],
                // ['옥외기계식대수(대)', 'oudrMechUtcnt'],
                // ['옥외기계식면적(㎡)', 'oudrMechArea'],
                // ['옥내자주식대수(대)', 'indrAutoUtcnt'],
                // ['옥내자주식면적(㎡)', 'indrAutoArea'],
                // ['옥외자주식대수(대)', 'oudrAutoUtcnt'],
                // ['옥외자주식면적(㎡)', 'oudrAutoArea'],
                // ['허가일', 'pmsDay'],
                // ['착공일', 'stcnsDay'],
                // ['사용승인일', 'useAprDay'],
                // ['허가번호년', 'pmsnoYear'],
                // ['허가번호기관코드', 'pmsnoKikCd'],
                // ['허가번호기관코드명', 'pmsnoKikCdNm'],
                // ['허가번호구분코드', 'pmsnoGbCd'],
                // ['허가번호구분코드명', 'pmsnoGbCdNm'],
                // ['호수(호)', 'hoCnt'],
                // ['에너지효율등급', 'engrGrade'],
                // ['에너지절감율', 'engrRat'],
                // ['EPI점수', 'engrEpi'],
                // ['친환경건축물등급', 'gnBldGrade'],
                // ['친환경건축물인증점수', 'gnBldCert'],
                // ['지능형건축물등급', 'itgBldGrade'],
                // ['지능형건축물인증점수', 'itgBldCert'],
                // ['생성일자', 'crtnDay'],
                // ['null', 'Items'],
                // ['순번', 'rnum'],
                // ['대지위치', 'platPlc'],
                // ['시군구코드', 'sigunguCd'],
                // ['법정동코드', 'bjdongCd'],
                // ['대지구분코드', 'platGbCd'],
                // ['번', 'bun'],
                // ['지', 'ji'],
                // ['관리건축물대장PK', 'mgmBldrgstPk'],
                // ['대장구분코드', 'regstrGbCd'],
                // ['대장구분코드명', 'regstrGbCdNm'],
                // ['대장종류코드', 'regstrKindCd'],
                // ['대장종류코드명', 'regstrKindCdNm'],
                ['도로명대지위치', 'newPlatPlc'],
                // ['건물명', 'bldNm'],
                // ['특수지명', 'splotNm'],
                // ['블록', 'block'],
                // ['로트', 'lot'],
                // ['외필지수', 'bylotCnt'],
                // ['새주소도로코드', 'naRoadCd'],
                // ['새주소법정동코드', 'naBjdongCd'],
                // ['새주소지상지하코드', 'naUgrndCd'],
                // ['새주소본번', 'naMainBun'],
                // ['새주소부번', 'naSubBun'],
                // ['동명칭', 'dongNm'],
                // ['주부속구분코드', 'mainAtchGbCd'],
                // ['주부속구분코드명', 'mainAtchGbCdNm'],
                // ['대지면적(㎡)', 'platArea'],
                // ['건축면적(㎡)', 'archArea'],
                // ['건폐율(%)', 'bcRat'],
                // ['연면적(㎡)', 'totArea'],
                // ['용적률산정연면적(㎡)', 'vlRatEstmTotArea'],
                // ['용적률(%)', 'vlRat'],
                // ['구조코드', 'strctCd'],
                // ['구조코드명', 'strctCdNm'],
                // ['기타구조', 'etcStrct'],
                // ['주용도코드', 'mainPurpsCd'],
                // ['내진설계적용여부', 'rserthqkDsgnApplyYn'],
                // ['내진능력', 'rserthqkAblty'],
            ],
            land: [
                ['고유번호', 'pnu'],
                // ['법정동코드', 'ldCode'],
                // ['법정동명', 'ldCodeNm'],
                // ['대장구분코드', 'regstrSeCode'],
                // ['대장구분명', 'regstrSeCodeNm'],
                // ['지번', 'mnnmSlno'],
                // ['토지일련번호', 'ladSn'],
                // ['기준연도', 'stdrYear'],
                // ['기준월', 'stdrMt'],
                // ['지목코드', 'lndcgrCode'],
                // ['지목명', 'lndcgrCodeNm'],
                ['토지면적', 'lndpclAr'],
                // ['용도지역코드1', 'prposArea1'],
                // ['용도지역명1', 'prposArea1Nm'],
                // ['용도지역코드2', 'prposArea2'],
                // ['용도지역명2', 'prposArea2Nm'],
                // ['토지이용상황코드', 'ladUseSittn'],
                // ['토지이용상황', 'ladUseSittnNm'],
                // ['지형높이코드', 'tpgrphHgCode'],
                // ['지형높이', 'tpgrphHgCodeNm'],
                // ['지형형상코드', 'tpgrphFrmCode'],
                // ['지형형상', 'tpgrphFrmCodeNm'],
                // ['도로접면코드', 'roadSideCode'],
                // ['도로접면', 'roadSideCodeNm'],
                // ['공시지가', 'pblntfPclnd'],
                // ['데이터기준일자', 'lastUpdtDt'],
            ],
            landPrice: [
                ['고유번호', 'pnu'],
                // ['법정동코드', 'ldCode'],
                // ['법정동명', 'ldCodeNm'],
                // ['특수지구분코드', 'regstrSeCode'],
                // ['특수지구분명', 'regstrSeCodeNm'],
                // ['지번', 'mnnmSlno'],
                // ['기준연도', 'stdrYear'],
                // ['기준월', 'stdrMt'],
                ['공시지가', 'pblntfPclnd'],
                // ['공시일자', 'pblntfDe'],
                // ['표준지여부', 'stdLandAt'],
                // ['데이터기준일자', 'lastUpdtDt'],
            ],
            apartPrice: [
                ['고유번호', 'pnu'],
                // ['법정동코드', 'ldCode'],
                // ['법정동명', 'ldCodeNm'],
                // ['특수지구분코드', 'regstrSeCode'],
                // ['특수지구분명', 'regstrSeCodeNm'],
                // ['지번', 'mnnmSlno'],
                // ['기준연도', 'stdrYear'],
                // ['기준월', 'stdrMt'],
                // ['공동주택코드', 'aphusCode'],
                // ['공동주택구분코드', 'aphusSeCode'],
                // ['공동주택구분명', 'aphusSeCodeNm'],
                // ['특수지명', 'spclLandNm'],
                // ['공동주택명', 'aphusNm'],
                // ['동명', 'dongNm'],
                // ['층명', 'floorNm'],
                // ['호명', 'hoNm'],
                // ['전용면적', 'prvuseAr'],
                ['공시가격', 'pblntfPc'],
                // ['데이터기준일자', 'lastUpdtDt'],
            ],
            indvdPrice: [
                ['고유번호', 'pnu'],
                // ['법정동코드', 'ldCode'],
                // ['법정동명', 'ldCodeNm'],
                // ['특수지구분코드', 'regstrSeCode'],
                // ['특수지구분명', 'regstrSeCodeNm'],
                // ['지번', 'mnnmSlno'],
                // ['건축물대장고유번호', 'bildRegstrEsntlNo'],
                // ['기준연도', 'stdrYear'],
                // ['기준월', 'stdrMt'],
                // ['동코드', 'dongCode'],
                // ['동명', 'dongNm'],
                // ['건물산정연면적', 'ladRegstrAr'],
                // ['토지대장면적', 'calcPlotAr'],
                // ['산정대지면적', 'buldAllTotAr'],
                // ['건물전체연면적', 'buldCalcTotAr'],
                ['주택가격', 'housePc'],
                // ['표준지여부', 'stdLandAt'],
                // ['데이터기준일자', 'lastUpdtDt'],
            ],
        };
        let itemName2 = {
            buld: [
                ['주용도코드명', 'mainPurpsCdNm'],
                // ['기타용도', 'etcPurps'],
                // ['지붕코드', 'roofCd'],
                // ['지붕코드명', 'roofCdNm'],
                // ['기타지붕', 'etcRoof'],
                ['세대 수(세대)', 'hhldCnt'],
                ['가구 수(가구)', 'fmlyCnt'],
                ['높이(m)', 'heit'],
                ['지상층수', 'grndFlrCnt'],
                ['지하층수', 'ugrndFlrCnt'],
                // ['승용승강기수', 'rideUseElvtCnt'],
                // ['비상용승강기수', 'emgenUseElvtCnt'],
                // ['부속건축물수', 'atchBldCnt'],
                // ['부속건축물면적(㎡)', 'atchBldArea'],
                // ['총동연면적(㎡)', 'totDongTotArea'],
                // ['옥내기계식대수(대)', 'indrMechUtcnt'],
                // ['옥내기계식면적(㎡)', 'indrMechArea'],
                // ['옥외기계식대수(대)', 'oudrMechUtcnt'],
                // ['옥외기계식면적(㎡)', 'oudrMechArea'],
                // ['옥내자주식대수(대)', 'indrAutoUtcnt'],
                // ['옥내자주식면적(㎡)', 'indrAutoArea'],
                // ['옥외자주식대수(대)', 'oudrAutoUtcnt'],
                // ['옥외자주식면적(㎡)', 'oudrAutoArea'],
                ['허가일', 'pmsDay'],
                // ['착공일', 'stcnsDay'],
                ['사용승인일', 'useAprDay'],
                // ['허가번호년', 'pmsnoYear'],
                // ['허가번호기관코드', 'pmsnoKikCd'],
                // ['허가번호기관코드명', 'pmsnoKikCdNm'],
                // ['허가번호구분코드', 'pmsnoGbCd'],
                // ['허가번호구분코드명', 'pmsnoGbCdNm'],
                ['호수(호)', 'hoCnt'],
                // ['에너지효율등급', 'engrGrade'],
                // ['에너지절감율', 'engrRat'],
                // ['EPI점수', 'engrEpi'],
                // ['친환경건축물등급', 'gnBldGrade'],
                // ['친환경건축물인증점수', 'gnBldCert'],
                // ['지능형건축물등급', 'itgBldGrade'],
                // ['지능형건축물인증점수', 'itgBldCert'],
                // ['생성일자', 'crtnDay'],
                // ['null', 'Items'],
                // ['순번', 'rnum'],
                ['대지위치', 'platPlc'],
                // ['시군구코드', 'sigunguCd'],
                // ['법정동코드', 'bjdongCd'],
                // ['대지구분코드', 'platGbCd'],
                // ['번', 'bun'],
                // ['지', 'ji'],
                // ['관리건축물대장PK', 'mgmBldrgstPk'],
                // ['대장구분코드', 'regstrGbCd'],
                // ['대장구분코드명', 'regstrGbCdNm'],
                // ['대장종류코드', 'regstrKindCd'],
                // ['대장종류코드명', 'regstrKindCdNm'],
                ['도로명대지위치', 'newPlatPlc'],
                // ['건물명', 'bldNm'],
                // ['특수지명', 'splotNm'],
                // ['블록', 'block'],
                // ['로트', 'lot'],
                // ['외필지수', 'bylotCnt'],
                // ['새주소도로코드', 'naRoadCd'],
                // ['새주소법정동코드', 'naBjdongCd'],
                // ['새주소지상지하코드', 'naUgrndCd'],
                // ['새주소본번', 'naMainBun'],
                // ['새주소부번', 'naSubBun'],
                // ['동명칭', 'dongNm'],
                // ['주부속구분코드', 'mainAtchGbCd'],
                // ['주부속구분코드명', 'mainAtchGbCdNm'],
                // ['대지면적(㎡)', 'platArea'],
                // ['건축면적(㎡)', 'archArea'],
                // ['건폐율(%)', 'bcRat'],
                ['연면적(㎡)', 'totArea'],
                // ['용적률산정연면적(㎡)', 'vlRatEstmTotArea'],
                // ['용적률(%)', 'vlRat'],
                // ['구조코드', 'strctCd'],
                ['구조코드명', 'strctCdNm'],
                // ['기타구조', 'etcStrct'],
                // ['주용도코드', 'mainPurpsCd'],
                // ['내진설계적용여부', 'rserthqkDsgnApplyYn'],
                // ['내진능력', 'rserthqkAblty'],
            ],
            land: [
                ['고유번호', 'pnu'],
                // ['법정동코드', 'ldCode'],
                ['법정동명', 'ldCodeNm'],
                // ['대장구분코드', 'regstrSeCode'],
                ['대장구분명', 'regstrSeCodeNm'],
                ['지번', 'mnnmSlno'],
                ['토지일련번호', 'ladSn'],
                ['기준연도', 'stdrYear'],
                ['기준월', 'stdrMt'],
                // ['지목코드', 'lndcgrCode'],
                ['지목명', 'lndcgrCodeNm'],
                ['토지면적', 'lndpclAr'],
                // ['용도지역코드1', 'prposArea1'],
                ['용도지역명1', 'prposArea1Nm'],
                // ['용도지역코드2', 'prposArea2'],
                ['용도지역명2', 'prposArea2Nm'],
                // ['토지이용상황코드', 'ladUseSittn'],
                ['토지이용상황', 'ladUseSittnNm'],
                // ['지형높이코드', 'tpgrphHgCode'],
                ['지형높이', 'tpgrphHgCodeNm'],
                // ['지형형상코드', 'tpgrphFrmCode'],
                ['지형형상', 'tpgrphFrmCodeNm'],
                // ['도로접면코드', 'roadSideCode'],
                ['도로접면', 'roadSideCodeNm'],
                ['공시지가', 'pblntfPclnd'],
                ['데이터기준일자', 'lastUpdtDt'],
            ],
            landPrice: [
                ['고유번호', 'pnu'],
                // ['법정동코드', 'ldCode'],
                ['법정동명', 'ldCodeNm'],
                // ['특수지구분코드', 'regstrSeCode'],
                ['특수지구분명', 'regstrSeCodeNm'],
                ['지번', 'mnnmSlno'],
                ['기준연도', 'stdrYear'],
                ['기준월', 'stdrMt'],
                ['공시지가', 'pblntfPclnd'],
                ['공시일자', 'pblntfDe'],
                ['표준지여부', 'stdLandAt'],
                ['데이터기준일자', 'lastUpdtDt'],
            ],
            apartPrice: [
                ['고유번호', 'pnu'],
                // ['법정동코드', 'ldCode'],
                ['법정동명', 'ldCodeNm'],
                // ['특수지구분코드', 'regstrSeCode'],
                ['특수지구분명', 'regstrSeCodeNm'],
                ['지번', 'mnnmSlno'],
                ['기준연도', 'stdrYear'],
                ['기준월', 'stdrMt'],
                // ['공동주택코드', 'aphusCode'],
                // ['공동주택구분코드', 'aphusSeCode'],
                ['공동주택명', 'aphusNm'],
                ['공동주택구분명', 'aphusSeCodeNm'],
                ['특수지명', 'spclLandNm'],
                // ['동명', 'dongNm'],
                ['층명', 'floorNm'],
                ['호명', 'hoNm'],
                ['전용면적', 'prvuseAr'],
                ['공시가격', 'pblntfPc'],
                ['데이터기준일자', 'lastUpdtDt'],
            ],
            indvdPrice: [
                ['고유번호', 'pnu'],
                // ['법정동코드', 'ldCode'],
                ['법정동명', 'ldCodeNm'],
                // ['특수지구분코드', 'regstrSeCode'],
                ['특수지구분명', 'regstrSeCodeNm'],
                ['지번', 'mnnmSlno'],
                ['건축물대장고유번호', 'bildRegstrEsntlNo'],
                ['기준연도', 'stdrYear'],
                ['기준월', 'stdrMt'],
                ['동코드', 'dongCode'],
                // ['동명', 'dongNm'],
                ['건물산정연면적', 'ladRegstrAr'],
                ['토지대장면적', 'calcPlotAr'],
                ['산정대지면적', 'buldAllTotAr'],
                ['건물전체연면적', 'buldCalcTotAr'],
                ['주택가격', 'housePc'],
                ['표준지여부', 'stdLandAt'],
                ['데이터기준일자', 'lastUpdtDt'],
            ],
        };
        var componentData = [];
        
        $(document).ready(function () {

            $('#sub_content').show();
            clearAnalysisResult();

            $('#loading_area')[0].style.display = 'none';
            $('#modalCnt')[0].innerHTML +=
                `<div id="analysisResultMenu" style="display:flex; justify-content: center;">` +
                `   <button onclick="selectresultMenu('buld')">건축물대장</botton>` +
                `   <button onclick="selectresultMenu('land')">토지특성</botton>` +
                `   <button onclick="selectresultMenu('landPrice')">개별공시지가</botton>` +
                `   <button onclick="selectresultMenu('apartPrice')">공동주택가격</botton>` +
                `   <button onclick="selectresultMenu('indvdPrice')">개별주택가격</botton>` +
                `</div>` +
                `<div id="analysisResult" style="overflow-x: hidden; overflow-y: auto; max-height:500px">` +
                `   <div id="analysisChart"><canvas id="chartCanvas" width="400" height="300"></canvas></div>` +
                `   <div id="analysisInfo" style="display: flex; flex-direction: column; align-items: center;"></div>` +
                `</div>`;
            
            componentData = [{ type: 'drawTool',name:'destination' }];
            doRenderSearchComp(componentData);
            
            $('.areaSearch')[0].innerHTML += `<div id="draw_circle_condition">
                <label for="draw_cicle_radius">반지름</label>
                <input type="number" id="draw_cicle_radius" />
            </div>`;

            $('#search_list_bottom').draggable({ handle: '#search_list_bottom_handler'});
            
            $("#search_list_bottom").on("mousedown", function() {
                $(this).css("cursor", "move");
            });

            $(document).on("mouseup", function() {
                $("#search_list_bottom").css("cursor", "default");
            });

            document.getElementById('draw_cicle_radius')

            $('#draw_cicle_radius').on('keydown', function(event) {
                if (event.key === "Enter") {
                    event.preventDefault();
                    makeCircle();
                }
            });
                
        });
        
        function drawChart(chartData, chartType) {
            let chartStatus = Chart.getChart('chartCanvas');
            if (chartStatus !== undefined) chartStatus.destroy();

            const ctx = $('#chartCanvas')[0];
            const myChart = new Chart(ctx, {
                name: 'analysisChart',
                type: chartType,
                data: chartData,
                options: {
                    elements: {
                        line: {
                            borderWidth: 3,
                        },
                    },
                },
            });
        }

        function showInfo() {

            let contentHtml = '<table>';
            contentHtml += '<tr>';
            itemName1[selectedResultMenu].map((ele) => {
                contentHtml += '<th>' + ele[0] + '</th>';
                // contentHtml += '<td>' + analysisData[ele[1]] + '</td>';
            });
            contentHtml += '</tr>';

            analysisList.map((analysisData) => {
                contentHtml += '<tr>';
                itemName1[selectedResultMenu].map((ele) => {
                    // contentHtml += '<td>' + ele[0] + '</td>';
                    contentHtml += '<td>' + analysisData[ele[1]] + '</td>';
                });
                contentHtml += '</tr>';
            });
            if(analysisList.length == 0) {
                contentHtml += '<tr><td colspan="' + itemName1[selectedResultMenu].length + '">선택지역에 대한 데이터가 존재하지 않습니다.</td></tr>';
            }
            contentHtml += '</table>';
            contentHtml += '<hr />';
            $('#analysisInfo')[0].innerHTML = contentHtml;

            let contentHtml2 = '<table>';
            contentHtml2 += '<tr>';
            itemName2[selectedResultMenu].map((ele) => {
                contentHtml2 += '<th>' + ele[0] + '</th>';
                // contentHtml += '<td>' + analysisData[ele[1]] + '</td>';
            });
            contentHtml2 += '</tr>';

            analysisList.map((analysisData) => {
                contentHtml2 += '<tr>';
                itemName2[selectedResultMenu].map((ele) => {
                    // contentHtml += '<td>' + ele[0] + '</td>';
                    contentHtml2 += '<td>' + analysisData[ele[1]] + '</td>';
                });
                contentHtml2 += '</tr>';
            });

            if(analysisList.length == 0) {
                contentHtml2 += '"<tr><td colspan="' + itemName2[selectedResultMenu].length + '">선택지역에 대한 데이터가 존재하지 않습니다.</td></tr>"';
            }
            contentHtml2 += '</table>';
            $('#analysisInfo2')[0].innerHTML = contentHtml2;
        }

        function selectresultMenu(menu) {
            selectedResultMenu = menu;
            showResult();
        }
        
        function showResult() {

            var targetString = "검색결과";

            $("#search_list_bottom").show();
            $("#search_list_bottom_handler p b").text(function(_, currentText) {
                return currentText.includes(targetString) ? targetString : null;
            });
            
            let selectedData = analysisResultData[selectedResultMenu];
            let chartData = {};
            let chartType = '';
            
            $('#search_list_mini').css('display', 'block');
            $('#search_list_bottom').css('display', 'block');
            $('#search_list_mini #loading_area').hide();

            analysisList = [];
            if (selectedResultMenu === 'buld') {
                $("#search_list_bottom_handler p b").prepend("건축물대장 ");

                let statisticsData = analysisResultData.statistics.filter((ele) => ele.gubun === '건축물대장')[0];
                // 통계		fmly_co : 가구수	ground_floor : 지상층수	hg : 높이	hshld : 세대수		undgrnd : 지하층 개수
                
                for (let i = 0; i < selectedData.length; i++) {
                    let itemArr = selectedData[i].totalCount === 1 ? [selectedData[i].items.item] : selectedData[i].items.item;
                    itemArr.map((ele) => {
                        ele.pnu = selectedData[i].pnu;
                        return ele;
                    });
                    analysisList.push(...itemArr);
                }
                
                chartType = 'radar';
                chartData = {
                    labels: ['높이', '지상층수', '지하층개수', '가구 수', '세대수'],
                    datasets: [
                        {
                            label: '선택 지역 평균 ',
                            data: [
                                analysisList.reduce((acc,cur,idx)=>acc+cur.heit,0)/analysisList.length,
                                analysisList.reduce((acc,cur,idx)=>acc+cur.grndFlrCnt,0) / analysisList.length,
                                analysisList.reduce((acc,cur,idx)=>acc+cur.ugrndFlrCnt,0) / analysisList.length,
                                analysisList.reduce((acc,cur,idx)=>acc+cur.fmlyCnt,0) / analysisList.length,
                                analysisList.reduce((acc,cur,idx)=>acc+cur.hhldCnt,0) / analysisList.length,
                                 
                            ],
                            fill: true,
                            backgroundColor: 'rgba(75, 192, 192, 0.2)',
                            borderColor: 'RGB(75, 192, 192)',
                            pointBackgroundColor: 'RGB(75, 192, 192)',
                            pointBorderColor: '#fff',
                            pointHoverBackgroundColor: '#fff',
                            pointHoverBorderColor: 'RGB(75, 192, 192)',
                        },
                        {
                            label: statisticsData.signgu_nm + ' 평균',
                            data: [
                                statisticsData.hg_sg_avg,
                                statisticsData.ground_floor_co_sg_avg,
                                statisticsData.undgrnd_floor_co_sg_avg,
                                statisticsData.fmly_co_sg_avg,
                                statisticsData.hshld_co_sg_avg,
                            ],
                            fill: true,
                            backgroundColor: 'rgba(255, 99, 132, 0.2)',
                            borderColor: 'rgb(255, 99, 132)',
                            pointBackgroundColor: 'rgb(255, 99, 132)',
                            pointBorderColor: '#fff',
                            pointHoverBackgroundColor: '#fff',
                            pointHoverBorderColor: 'rgb(255, 99, 132)',
                        },
                        {
                            label: '서울시 평균',
                            data: [
                                statisticsData.hg_sid_avg,
                                statisticsData.ground_floor_co_sid_avg,
                                statisticsData.undgrnd_floor_co_sid_avg,
                                statisticsData.fmly_co_sid_avg,
                                statisticsData.hshld_co_sid_avg,
                            ],
                            fill: true,
                            backgroundColor: 'rgba(54, 162, 235, 0.2)',
                            borderColor: 'rgb(54, 162, 235)',
                            pointBackgroundColor: 'rgb(54, 162, 235)',
                            pointBorderColor: '#fff',
                            pointHoverBackgroundColor: '#fff',
                            pointHoverBorderColor: 'rgb(54, 162, 235)',
                        },
                    ],
                };
            }
            if (selectedResultMenu === 'land') {
                $("#search_list_bottom_handler p b").prepend("토지특성 ");
                
                for (let i = 0; i < selectedData.length; i++) {
                    let itemArr = selectedData[i].field;
                    analysisList.push(...itemArr);
                }
                chartType = 'bar';
                chartData = {
                    labels: ['토지면적'],
                    datasets: [
                        {
                            label: '선택 지역 토지면적 최소값',
                            data: [Math.min(...analysisList.map(ele=>ele.lndpclAr*1))],
                            fill: true,
                            backgroundColor: 'rgba(75, 192, 192, 0.2)',
                            borderColor: 'RGB(75, 192, 192)',
                            pointBackgroundColor: 'RGB(75, 192, 192)',
                            pointBorderColor: '#fff',
                            pointHoverBackgroundColor: '#fff',
                            pointHoverBorderColor: 'RGB(75, 192, 192)',
                        },
                        {
                            label: '선택 지역 토지면적 평균',
                            data: [+(analysisList.map(ele=>ele.lndpclAr*1).reduce((acc,cur)=>+acc.toFixed(1)+cur)/analysisList.length).toFixed(2)],
                            fill: true,
                            backgroundColor: 'rgba(255, 99, 132, 0.2)',
                            borderColor: 'rgb(255, 99, 132)',
                            pointBackgroundColor: 'rgb(255, 99, 132)',
                            pointBorderColor: '#fff',
                            pointHoverBackgroundColor: '#fff',
                            pointHoverBorderColor: 'rgb(255, 99, 132)',
                        },
                        {
                            label: '선택 지역 토지면적 최대값',
                            data: [Math.max(...analysisList.map(ele=>ele.lndpclAr*1))],
                            fill: true,
                            backgroundColor: 'rgba(54, 162, 235, 0.2)',
                            borderColor: 'rgb(54, 162, 235)',
                            pointBackgroundColor: 'rgb(54, 162, 235)',
                            pointBorderColor: '#fff',
                            pointHoverBackgroundColor: '#fff',
                            pointHoverBorderColor: 'rgb(54, 162, 235)',
                        },
                    ],
                };
                
            }
            if (selectedResultMenu === 'landPrice') {
                $("#search_list_bottom_handler p b").prepend("개별공시지가 ");
                let statisticsData = analysisResultData.statistics.filter((ele) => ele.gubun === '개별공시지가')[0];
                chartType = 'bar';

                chartData = {
                    labels: ['공시지가 (원/㎡)'],
                    datasets: [
                        {
                            label: '선택 지역 공시지가 평균 (원/㎡)',
                            data: [selectedData[selectedData.length - 1].avg],
                            fill: true,
                            backgroundColor: 'rgba(75, 192, 192, 0.2)',
                            borderColor: 'RGB(75, 192, 192)',
                            pointBackgroundColor: 'RGB(75, 192, 192)',
                            pointBorderColor: '#fff',
                            pointHoverBackgroundColor: '#fff',
                            pointHoverBorderColor: 'RGB(75, 192, 192)',
                        },
                        {
                            label: statisticsData.signgu_nm + ' 공시지가 평균 (원/㎡)',
                            data: [statisticsData.sg_avg],
                            fill: true,
                            backgroundColor: 'rgba(255, 99, 132, 0.2)',
                            borderColor: 'rgb(255, 99, 132)',
                            pointBackgroundColor: 'rgb(255, 99, 132)',
                            pointBorderColor: '#fff',
                            pointHoverBackgroundColor: '#fff',
                            pointHoverBorderColor: 'rgb(255, 99, 132)',
                        },
                        {
                            label: '서울시 공시지가 평균 (원/㎡)',
                            data: [statisticsData.sid_avg],
                            fill: true,
                            backgroundColor: 'rgba(54, 162, 235, 0.2)',
                            borderColor: 'rgb(54, 162, 235)',
                            pointBackgroundColor: 'rgb(54, 162, 235)',
                            pointBorderColor: '#fff',
                            pointHoverBackgroundColor: '#fff',
                            pointHoverBorderColor: 'rgb(54, 162, 235)',
                        },
                    ],
                };

                for (let i = 0; i < selectedData.length - 1; i++) {
                    let item = selectedData[i].totalCount === 1 ? selectedData[i].field : selectedData[i].field[selectedData[i].totalCount - 1];

                    analysisList.push(item);
                }
            }
            if (selectedResultMenu === 'apartPrice') {
                $("#search_list_bottom_handler p b").prepend("공동주택가격 ");
                let statisticsData = analysisResultData.statistics.filter((ele) => ele.gubun === '공동주택가격')[0];

                chartType = 'bar';

                chartData = {
                    labels: ['공시가격 (원)'],
                    datasets: [
                        {
                            label: '선택 지역 공시가격(원)',
                            data: [selectedData[selectedData.length - 1].avg],
                            fill: true,
                            backgroundColor: 'rgba(75, 192, 192, 0.2)',
                            borderColor: 'RGB(75, 192, 192)',
                            pointBackgroundColor: 'RGB(75, 192, 192)',
                            pointBorderColor: '#fff',
                            pointHoverBackgroundColor: '#fff',
                            pointHoverBorderColor: 'RGB(75, 192, 192)',
                        },
                        {
                            label: statisticsData.signgu_nm + ' 공시가격 평균(원)',
                            data: [statisticsData.sg_avg],
                            fill: true,
                            backgroundColor: 'rgba(255, 99, 132, 0.2)',
                            borderColor: 'rgb(255, 99, 132)',
                            pointBackgroundColor: 'rgb(255, 99, 132)',
                            pointBorderColor: '#fff',
                            pointHoverBackgroundColor: '#fff',
                            pointHoverBorderColor: 'rgb(255, 99, 132)',
                        },
                        {
                            label: '서울시 공시가격 평균(원)',
                            data: [statisticsData.sid_avg],
                            fill: true,
                            backgroundColor: 'rgba(54, 162, 235, 0.2)',
                            borderColor: 'rgb(54, 162, 235)',
                            pointBackgroundColor: 'rgb(54, 162, 235)',
                            pointBorderColor: '#fff',
                            pointHoverBackgroundColor: '#fff',
                            pointHoverBorderColor: 'rgb(54, 162, 235)',
                        },
                    ],
                };
                
                for (let i = 0; i < selectedData.length - 1; i++) {
                    let itemArr = selectedData[i].totalCount === 1 ? [selectedData[i].field] : selectedData[i].field;

                    analysisList.push(...itemArr);
                }
            }
            if (selectedResultMenu === 'indvdPrice') {
                $("#search_list_bottom_handler p b").prepend("개별주택가격 ");
                let statisticsData = analysisResultData.statistics.filter((ele) => ele.gubun === '개별주택가격')[0];
                chartType = 'bar';
                chartData = {
                    labels: ['주택가격(원)'],
                    datasets: [
                        {
                            label: '선택 지역 주택가격(원)',
                            data: [selectedData[selectedData.length - 1].avg],
                            fill: true,
                            backgroundColor: 'rgba(75, 192, 192, 0.2)',
                            borderColor: 'RGB(75, 192, 192)',
                            pointBackgroundColor: 'RGB(75, 192, 192)',
                            pointBorderColor: '#fff',
                            pointHoverBackgroundColor: '#fff',
                            pointHoverBorderColor: 'RGB(75, 192, 192)',
                        },
                        {
                            label: statisticsData.signgu_nm + ' 주택가격 평균(원)',
                            data: [statisticsData.sg_avg],
                            fill: true,
                            backgroundColor: 'rgba(255, 99, 132, 0.2)',
                            borderColor: 'rgb(255, 99, 132)',
                            pointBackgroundColor: 'rgb(255, 99, 132)',
                            pointBorderColor: '#fff',
                            pointHoverBackgroundColor: '#fff',
                            pointHoverBorderColor: 'rgb(255, 99, 132)',
                        },
                        {
                            label: '서울시 주택가격 평균(원)',
                            data: [statisticsData.sid_avg],
                            fill: true,
                            backgroundColor: 'rgba(54, 162, 235, 0.2)',
                            borderColor: 'rgb(54, 162, 235)',
                            pointBackgroundColor: 'rgb(54, 162, 235)',
                            pointBorderColor: '#fff',
                            pointHoverBackgroundColor: '#fff',
                            pointHoverBorderColor: 'rgb(54, 162, 235)',
                        },
                    ],
                };
                for (let i = 0; i < selectedData.length - 1; i++) {
                    let itemArr = selectedData[i].totalCount === 1 ? [selectedData[i].field] : selectedData[i].field;

                    analysisList.push(...itemArr);
                }
            }

            drawChart(chartData, chartType);
            showInfo(selectedData);

            // clickevent
            $('#search-list-mini-close, #search_list_close').click(function() {
    			$("#search_list_bottom").hide();
    	    });

        }

        function onClickAnalysis() {

            doBeforeAnalysis();

            const duplicate = geoMap
                .getLayers()
                .getArray()
                .filter((lyr) => lyr.get('title') === 'destinationAnalysis');
            if (duplicate.length > 0) {
                geoMap.removeLayer(duplicate[0]);
            }

            const drawLayer = geoMap
                .getLayers()
                .getArray()
                .filter((lyr) => lyr.get('title') === 'draw layer')[0];

            let targetFeature = drawLayer.getSource().getFeatures();
            let inputWKT = '';

            if(
                targetFeature.filter(f => f.getGeometry().getType() == 'Circle')[0]
            ){
                targetFeature = targetFeature.filter(f => f.getGeometry().getType() == 'Circle')[0];
                inputWKT = reader.writeGeometry(ol.geom.Polygon.fromCircle(targetFeature.getGeometry()));
            } else {
                targetFeature = targetFeature[0];
                inputWKT = reader.writeGeometry(targetFeature.getGeometry());
            }
                
            if(!drawLayer || !inputWKT){
                alert('영역을 입력해주세요.');
				doAfterAnalysis();
                clearAnalysisResult();
				return;
            }

            callAnalResult({ inputWKT });

            // 테스트용 WKT, API 수정 되면 제거 필요
            /* let inputWKT = 'MULTIPOLYGON(((126.89556787708153 37.52200868333391,126.89556787708153 37.521866188934474,126.89431023568378 37.521866188934474,126.89422040415536 37.521794941632706,126.89404074109854 37.521794941632706,126.89359158345647 37.521866188934474,126.89350175192806 37.521866188934474,126.89350175192806 37.522079930431566,126.89341192039964 37.522079930431566,126.89314242581442 37.52215117746119,126.893052594286 37.52215117746119,126.89287293122916 37.52222242442278,126.89287293122916 37.522436164899325,126.89296276275759 37.522792397666194,126.893052594286 37.522934890296675,126.893052594286 37.52314862873214,126.89377124651328 37.523077382655025,126.89422040415536 37.52300613650988,126.89502888791105 37.52286364401545,126.89574754013836 37.522792397666194,126.89583737166677 37.52272115124889,126.89574754013836 37.52250741158877,126.89565770860995 37.52222242442278,126.89556787708153 37.52200868333391)))'; */
            /*
                $.ajax({
                    type: 'POST',
                    async: true,
                    url: '<%=RequestMappingConstants.WEB_ANAL_QUEST_STAT%>',
                    dataType: 'json',
                    data: {
                        inputWKT,
                    },
                    error: function (response, status, xhr) {
                        if (xhr.status == '404') {
                            alert('분석에 실패 했습니다.');
                        }
                    },
                    success: function (res, status, xhr) {
                        try {

                            if(!res) return;
                            const data = res.result;
                            const lsmd = data.lsmd;
                            const vector = new ol.source.Vector();

                            if(
                                !res.result.apartPrice[0].avg && 
                                !res.result.buld.length &&
                                !res.result.indvdPrice[0].avg && 
                                !res.result.land.length && 
                                !res.result.lsmd.length && 
                                !res.result.statistics.length 
                            ){
                                initAnalService('destination');
                            	alert('조건에 충족하는 분석결과가 존재하지 않습니다. 영역을 수정해주십시오.');
                                $('#search_list_bottom').hide();
                            	return 
                            }

                            callAnalResult(data);

                            data.lsmd.forEach(item => {
                            	const reader = new ol.format.WKT();
                            	
                            	if(item.geom && item.pnu){
    	                            const feature = new ol.Feature({ geometry: reader.readGeometry(item.geom) });
        	                        feature.setProperties({ pnu: item.pnu });
            	                    vector.addFeatures([feature]);
                            	} 
                            });

                            geoMap.getLayers().getArray()
                                .filter(lyr => lyr.get('title') === 'analysis').map(ele => geoMap.removeLayer(ele));

                            var vectorLayer = new ol.layer.Vector({
                                title: 'analysis', //destinationAnalysis
                                serviceNm: '대상지 탐색(통계)',
                                source: vector,
                                style: new ol.style.Style({
                                    fill: new ol.style.Fill({ color: 'rgb(158, 158, 158, 0.5)' }),
                                    stroke: new ol.style.Stroke({ color: 'rgb(69, 39, 160)', width: 2 }),
                                }),
                            });

                            geoMap.getView().fit(vectorLayer.getSource().getExtent(), geoMap.getSize());
                            geoMap.addLayer(vectorLayer, contextPath);
                            var exportKey = xhr.getResponseHeader('export_key');
                            analLayer(contextPath, exportKey, data);

                            // analysisResultData = data;
                            // showResult();
                            // $('.progress-circle')[0].style.display='';
                            
                        } catch (error) {
                            debugger;
                            console.log(error);
                            $('#search_list_mini').hide();
                            $('#search_list_bottom').hide();                	
    						alert('분석에 실패 했습니다.');
                        } finally {
    						doAfterAnalysis();
                        }
                    },
                    complete: function(xhr, status) {
        				doAfterAnalysis();
        			}
                });
            */
        }
    
        function clearAnalysisResult() {
            doAfterAnalysis();
            initAnalService('destination');
            $('#search_list_bottom').hide();
        }

        function callAnalResult(data){

            const form = document.createElement("form");
            form.method = "POST";
            form.action = '<%=RequestMappingConstants.WEB_ANAL_QUEST_STAT%>';
            form.target = "SearchWindow";

            Object.entries(data).forEach(([key, value]) => {
                const hiddenField = document.createElement("input");
                hiddenField.type = "hidden";

                hiddenField.name = key;
                hiddenField.value = encodeURIComponent(JSON.stringify(value));

                form.appendChild(hiddenField);
            })

            document.body.appendChild(form);
            window.open("", "SearchWindow", "toolbar=no, width=1100, height=720, directories=no, status=no, scrollbars=yes, resizable=yes");
            form.submit();

            document.body.removeChild(form);
        }

    </script>
<body>
	<div role="tabpanel" class="areaSearch full" id="tab-01"
		style="overflow: auto">
		<div id="basic">
			<h2 class="tit">대상지 탐색(통계)</h2>
			<h3 class="tit">사용자 그리기 도구</h3>

		</div>
		<!-- TabContent start -->
		<!-- 
            <div id="draw_circle_condition">
                <label for="draw_cicle_radius">반지름</label>
                <input type="number" id="draw_cicle_radius" />
            </div> 
        -->
	</div>
	<!-- TabContent end -->
	<!-- End Tab-04 -->
	<!-- 검색조건 Form -->
	<div class="breakLine"></div>
	<div class="disFlex smBtnWrap" style="padding: 1.6rem">
		<button type="button" class="primaryLine" onclick="clearAnalysisResult()">초기화</button>
		<button type="button" class="primarySearch" onclick="onClickAnalysis()">분석</button>
	</div>

	<!-- 검색결과 Form -->
	<form id="GISinfoResultForm" name="GISinfoResultForm">
		<input type="hidden" name="geom[]" />
	</form>

	<!-- 검색결과 2 -->
	<div class="side-pane info-mini layer-pop" id="search_list_bottom"
		style="position: absolute; bottom: 2rem; left: 41rem; z-index: 3; width: 60rem; border-radius: 10px;">
		<div class="row page-title-box-wrap tit info-mini" id="search_list_bottom_handler">
			<div class="page-title-box info-mini col-xs-12">
				<p class="page-title m-b-0" id="info_mini_address">
					<i class="fa fa-map-o m-r-5"></i> 
                    <b><span id='search_list_mini_title'></span> 검색결과</b>
				</p>
			</div>
			<!-- <div class="close-btn tab"> -->
			<div class="pop_head_btn close-btn tab">
			<!-- <button type="button" class="w-min tab" id="search-list-mini-min">최소화</button> -->
            <button type="button" class="w-cls tab" id="search-list-mini-close">×</button> 
			<!-- 
                <button type="button" class="w-max tab" id="search-list-mini-max">최대화</button>
            -->
			</div>
		</div>
		<div id="analysisInfo2" style="overflow: auto; height: 51rem;"></div>
	</div>
</body>
<script type="text/javascript" src="<c:url value='/resources/js/map/draw.js'/>"></script>
</html>
