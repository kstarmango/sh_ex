/* 파라미터로 전달한 레이어에서 vector source에 접근할 수 가 없어 
sourceLit 를 넘기고 map에서 레이어 리스트 불러와 setVisible */
function analLayer(contextPath, exportKey, data) {
    try {   
        $('.mapModal #layerAnalInner #noResults')[0].style.display = 'none'
        $('.mapModal #layerAnalInner #map-layerlistAnal')[0].style.display = 'block';
        $('.mapModal #layerAnalInner #map-layerlistAnal .listWrap').empty();
        
        var layer = geoMap.getLayers().getArray().filter(f => f.get('title') === 'analysis')[0];
        const resultTit = layer.get('serviceNm') + '_' + '분석결과';

        $('.mapModal #layerAnalInner #map-layerlistAnal .listWrap').append(getLiHtml(resultTit, contextPath, exportKey));
    
        let layerOnOffBtn = $('.mapModal #layerAnalInner #map-layerlistAnal .listWrap li .swichBtn input')[0];
        let layerDownloadBtn = $('.mapModal #layerAnalInner #map-layerlistAnal .listWrap li .downloadBtn')[0];
        layerOnOffBtn.checked = true
    
        layerOnOffBtn.addEventListener('click', () => layerOnOff(layer));

        if(exportKey && layerDownloadBtn){
            layerDownloadBtn.addEventListener('click',() => executeDownload(exportKey, resultTit));
        } 

        $('#map-analyResult').show();

        const html = `
            <div id="analysisResult" style="overflow-x: hidden; overflow-y: hidden; max-height:300px">
              
			</div>`;

        $('#map-analyResult').append(html);

        showResultTest(data);

    } catch (error) {
        console.log(error);        
    }
}



var selectedResultMenu = 'buld';

function showResultTest(data) {
    try {

        function selectedData(type) {
			return data[type];
		}

        let buldList = [];
        let landList = [];

        function statisticsData(type) {
            const statistics = data.statistics?.find(ele => ele.gubun === type);
            return statistics || { [type]: null };
        }
        // 통계		fmly_co : 가구수	ground_floor : 지상층수	hg : 높이	hshld : 세대수		undgrnd : 지하층 개수
      
        for (let i = 0; i < selectedData('buld').length; i++) {
          let itemArr = selectedData('buld')[i].totalCount === 1 ? [selectedData('buld')[i].items.item] : selectedData('buld')[i].items.item;
          itemArr.map((ele) => {
            ele.pnu = selectedData('buld')[i].pnu;
            return ele;
          });
          buldList.push(...itemArr);
        }

        for (let i = 0; i < selectedData('land').length; i++) {
          let itemArr = selectedData('land')[i].field;
          landList.push(...itemArr);
        }

        const selectedAreaStyle = {
            fill: true,
            backgroundColor: 'rgba(75, 192, 192, 0.2)',
            borderColor: 'RGB(75, 192, 192)',
            pointBackgroundColor: 'RGB(75, 192, 192)',
            pointBorderColor: '#fff',
            pointHoverBackgroundColor: '#fff',
            pointHoverBorderColor: 'RGB(75, 192, 192)',
        }

        const seoulAreaStyle = {
            fill: true,
            backgroundColor: 'rgba(54, 162, 235, 0.2)',
            borderColor: 'rgb(54, 162, 235)',
            pointBackgroundColor: 'rgb(54, 162, 235)',
            pointBorderColor: '#fff',
            pointHoverBackgroundColor: '#fff',
            pointHoverBorderColor: 'rgb(54, 162, 235)',
        }

        const chartData = {
            labels: [
                '가구 수 (0.1가구)', 
                '세대수 (0.1세대)', 
                '토지면적 (100㎡)', 
                '개별공시지가 (100만원/㎡)', 
                '공동주택가격 (천만원)', 
                '개별주택가격 (천만원)'
            ],
            datasets: [
                {
                    label: '선택지역 지역 평균',
                    data: [
                        normalizeValueTest(Number(buldList.reduce((acc,cur) => acc + Number(cur.fmlyCnt || 0), 0) / buldList.length), '가구수'),
                        normalizeValueTest(Number(buldList.reduce((acc,cur) => acc + Number(cur.hhldCnt || 0), 0) / buldList.length), '세대수'),
                        normalizeValueTest(Number(+(landList.map(ele => Number(ele.lndpclAr || 0)).reduce((acc,cur) => +acc.toFixed(1) + cur, 0)/landList.length).toFixed(2)), '면적'),
                        normalizeValueTest(Number(selectedData('landPrice')[selectedData('landPrice').length - 1].avg || 0), '공시지가'),
                        normalizeValueTest(Number(selectedData('apartPrice')[selectedData('apartPrice').length - 1].avg || 0), '가격'),
                        normalizeValueTest(Number(selectedData('indvdPrice')[selectedData('indvdPrice').length - 1].avg || 0), '가격')
                    ],
                    ...selectedAreaStyle
                },
                {
                    label: '서울시 평균',
                    data: [
                        normalizeValueTest(Number(statisticsData('건축물대장')['fmly_co_sid_avg'] || 0), '가구수'),
                        normalizeValueTest(Number(statisticsData('건축물대장')['hshld_co_sid_avg'] || 0), '세대수'),
                        normalizeValueTest(Number(statisticsData('토지대장')['lndpcl_ar_sid_avg'] || 0), '면적'),
                        normalizeValueTest(Number(statisticsData('개별공시지가')['sid_avg'] || 0), '공시지가'),
                        normalizeValueTest(Number(statisticsData('공동주택가격')['sid_avg'] || 0), '가격'),
                        normalizeValueTest(Number(statisticsData('개별주택가격')['sid_avg'] || 0), '가격')
                    ],
                    ...seoulAreaStyle
                },
            ],
        };

        drawChartTest(chartData, 'radar');
        
    } catch (error) {
        console.log(error)
    }
}

function normalizeValueTest(value, type) {
	switch(type) {
		case '가구수':
		case '세대수':
			return value * 10; // 0.1 단위를 1단위로 변환 (곱하기 10)
		case '면적':
			return value / 100; // 100㎡ 단위로 표시
		case '공시지가':
			return value / 1000000; // 100만원 단위로 표시
		case '가격':
			return value / 10000000; // 1000만원 단위로 표시
		default:
			return value;
	}
}

function drawChartTest(chartData, chartType) {
  let chartStatus = Chart.getChart('chartCanvas');
  if (chartStatus !== undefined) chartStatus.destroy();

  const ctx = $('#chartCanvas')[0];
  
  ctx.style.maxHeight = '380px';
  ctx.height = 380;

  const myChart = new Chart(ctx, {
      name: 'analysisChart',
      type: chartType,
      data: chartData,
      options: {
        responsive: true,
        maintainAspectRatio: true,
        aspectRatio: 1,
        plugins: {
          legend: {
            position: 'top',
            labels: {
              font: {
                size: 8,
                weight: 'bold'
              },
              padding: 5,
              boxWidth: 5,
              boxHeight: 5,
              borderWidth: 1
            }
          }
        },
        elements: {
          line: {
            borderWidth: 3,
          },
        },
        layout: {
          padding: 20
        },
        scales: {
          r: {
            beginAtZero: true,
            angleLines: {
              display: true
            },
            ticks: {
              display: false
            },
            pointLabels: {
              font: {
                size: 7
              },
              callback: function(label) {
                const words = label.split(' ');
                const formattedWords = [];
                
                if (words.length > 1) {
                  const unit = words[words.length - 1].match(/\(.*?\)/);
                  if (unit) {
                    formattedWords.push(words.slice(0, -1).join(' '));
                    formattedWords.push(unit[0]);
                  } else {
                    formattedWords.push(label);
                  }
                } else {
                  formattedWords.push(label);
                }
                
                return formattedWords;
              }
            }
          }
        }
      },
  });
}

function executeDownload(key, path) {

    $('#load').show();
    const xhr = new XMLHttpRequest();
    const url = "/web/analysis/cmmn/shpDownload.do";
    xhr.open('POST', url, true);

    const form = new FormData();
    form.append('result_id', key);

    xhr.responseType = 'blob';

    xhr.onload = function (e) {
        try {
            const filename = path + '.zip';
            var reader = new FileReader();
            reader.readAsDataURL(this.response);
            reader.onload =  function(e){
              const link = document.createElement('a');
              link.href = e.target.result;
              link.download = filename;
              link.click();
              link.remove();
            };
        } catch (error) {
            alert('파일 다운로드 요청이 실패했습니다.\n\n관리자에게 문의하시길 바랍니다.');
        } finally {
            $('#load').hide();
        }
    }

    xhr.onerror = function () {
        alert('파일 다운로드 요청이 실패했습니다.\n\n관리자에게 문의하시길 바랍니다.');
        $('#load').hide();
    };

    xhr.send(form);
}

function layerOnOff(layer) {
    layer.setVisible(!layer.getVisible());
}

function getLiHtml(lyrNm, contextPath, key) {

    var str = '';

    str += `
        <li>
            <span>${lyrNm}</span>
            <!-- <button type="button">
                <img src="${contextPath}/resources/img/map/icInfo16.svg" alt="정보보기">
            </button> -->
    `

    if(key){
        str += `<button type="button" class="downloadBtn">
            <img src="${contextPath}/resources/img/map/icDownload16.svg" alt="다운로드">
        </button>`
    }

    str += `
            <form class="swichBtn">
                <label>
                    <input role="switch" type="checkbox">
                </label>
            </form>
        </li>
    `

    return str
} 