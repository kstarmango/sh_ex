/* 
 *    Description : 시스템의 공통 차트 스크립트
 *    used Menu : 관리자 > 통계관리 
 */

// chartCommon.js


// 전역 객체에 차트 인스턴스를 저장
var chartInstances = {};


//차트 그리기 함수
function drawChart(chartType, data, options, plugins, id) {
    
    // 기존 차트가 있으면 파괴
    if (chartInstances[id]) {
        chartInstances[id].destroy();
    }

    var ctx = document.getElementById(id) ? document.getElementById(id).getContext('2d') : null;
    		
    if(!ctx) return;

    
    var config = getChartConfig(chartType, data, options, plugins);
    chartInstances[id] = new Chart(ctx, config);
    
}

//차트 설정 가져오기 함수
function getChartConfig(chartType, data, options, plugins) {
	
	return getDrawChartConfig(chartType, data, options, plugins);
	
}

//차트 설정 함수
function getDrawChartConfig(chartType, data, options, plugins) {
	
	return config = {
    		 type: chartType,
             data: data,
             options: options,
             plugins: plugins || []
        };
        
}

/////////////누계 막대차트 설정함수//////////////
function fn_random(){
	var random = ((new Date().getTime()) *9301+49297)%233280/(233280.0);
	random = random.toString();
	var randomNum = random.charAt(random.length-1);
	 return randomNum;
}
	
//색상 랜덤 함수 (시각적 차이를 위해)
function getRandomColor() {
  var letters = '0123456789ABCDEF';
  var color = '#';
  for (var i = 0; i < 6; i++) {
      //color += letters[Math.floor(Math.random() * 16)];
      color += letters[Math.floor(fn_random())];
  }
  return color;
} 

var colorMapping = {
	   "2020": "#FF8343", //주황
	    "2021": "#CCE0AC", //연두
	    "2022": "#179BAE", //청록
	   	"2023": "#4158A6", //보라
		"2024": "#0D7C66", //진녹 
		"2025": "#BDE8CA", //파스텔_연
		"2026": "#D7C3F1", //파스텔_보
		"2027": "#F4CE14", //노랑
		"2028": "#EE99C2", //분홍
		"2029": "#EF9C66", //파랑
		"2030": "#FF8A8A" //주황
	    // 필요한 만큼 색상 추가
	};

function calculateMaxYValue(datasets) {

    let maxYValue = 0;

    if (Array.isArray(datasets)) {
        // 데이터셋이 단순 배열인 경우
        if (datasets.length > 0 && typeof datasets[0] === 'number') {
            // 단순 배열일 경우: 숫자 배열의 최대값을 계산
            maxYValue = Math.max(...datasets);
        }else  if(datasets.length > 0 && typeof datasets[0] === 'string') {
            // 문자열 배열일 경우: 문자열을 숫자로 변환하여 최대값을 계산
            const numericValues = datasets.map(item => parseFloat(item));
            maxYValue = Math.max(...numericValues);
        } 
        
        // 데이터셋이 객체 배열인 경우
        else if (datasets.length > 0 && Array.isArray(datasets[0].data)) {
            // 각 데이터셋의 데이터를 기반으로 최대값 계산
            const numDataPoints = datasets[0].data.length; // 데이터 포인트 수
            
            for (let i = 0; i < numDataPoints; i++) {
                // 현재 인덱스(i)의 모든 데이터셋 값 합산
                const totalAtIndex = datasets.reduce((sum, dataset) => {
                    // 데이터셋의 data가 배열일 경우 처리
                    const data = Array.isArray(dataset.data) ? dataset.data[i] : 0;
                    return sum + (typeof data === 'number' ? data : 0);
                }, 0);

                // 최대값 갱신
                maxYValue = Math.max(maxYValue, totalAtIndex);
            }
        }
    }
    // 최대값에 100을 더해 반환
    maxYValue += 100;
    return maxYValue;
}

