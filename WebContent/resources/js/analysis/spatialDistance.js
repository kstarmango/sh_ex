//* 전체 랜더링

const uniqueColumnSet = new Set();

const targetTextMatch = {
	'subway_statn': '지하철',
	univ: '대학 캠퍼스',
	road: '간선도로',
}

const typeTextMatch = {
	'multiring': '멀티링 분석',
	'intersect': '교집합 분석',
}

const layerNameMatch = {
	univ: '대학캠퍼스',
	z_upis_c_uq151: '간선도로',
	subway_statn: '지하철',
}

function doRenderModal(modalData) {

	$('#search_list_mini').css('display', 'block');
	document.getElementById('loading_area').style.display = 'none';
	document.getElementById('content_area').style.display = 'block';

  var container = $('#content_area');
  container.children().not('#content_area').remove();

	/// 분기 태워야 하는 부분
  modalData.forEach(function(c) {
    if (c.type === 'graph') { // 그래프 
      	container.append(ResultGraph(c));
    } else if (c.type === 'table') { // 표
      	container.append(ResultTable(c));
    } else if (c.type === 'list') { // 목록
      	container.append(ResultList(c));
    } else if (c.type === 'btnCnt') { // 위 항목 선택 버튼
		container.append(BtnContent(c));
	}});
};


function loadExternalScript(url, callback) { // 그래프 
	const script = document.createElement('script');
	script.src = url;
	script.type = 'text/javascript';
	script.onload = callback;  // 스크립트 로드 완료 시 콜백 실행
	document.head.appendChild(script);
}

//* 그래프
function Graph(props) { // nCount yCount title
	loadExternalScript('https://cdn.jsdelivr.net/npm/chart.js', function() {
		const chartElement = document.getElementById("myPieChart");
	
		const data = props.data;

		// 초기화
		var canvas = $('#myPieChart');
		if (canvas.data('chartInstance')) {
			canvas.data('chartInstance').destroy();
		}
	
		var myPieChart = new Chart(chartElement, {
			type: 'pie',
			data: {
				labels: props.labels, // 데이터의 라벨 (예: 과일 이름)
				datasets: [{
					data: data, // 데이터 값 (예: 각 과일의 개수)
					backgroundColor: props.color,
					borderColor: props.color,
					borderWidth: 1
				}]
			},
			options: {
				responsive: true,
				maintainAspectRatio : false,
				animation: false,
				legend: {
					position: 'left',
					display: true
				},
				plugins: {
					legend: {
						position: 'left',
					},
					title: {
						display: true,
						text: props.title,
						font: { 
							size: 25
						}
					},
					tooltip: {
						callbacks: {
							label: function(tooltipItem) {
								return tooltipItem.formattedValue + '%'; // 사용자 정의 값
							}
						}
					}
				}
			}
		})
		chartElement.append(myPieChart);

		// 저장
		canvas.data('chartInstance', myPieChart);
	})
};

const makeList = (data) => {
	const theadElement = document.getElementById('resultThead');
	const tBodyElement = document.getElementById('resultTbody');
	const theadRowElement = document.createElement('tr');
	data.forEach((d, idx) => {
		const tbodyRowElement = document.createElement('tr');
		d.attribute.forEach(row => {
			if(row.title !== 'the_geom' && row.title !== 'id' && row.title !== 'object_id') {

				if(idx === 0) {
					const theadColumnElement = document.createElement('td');
					theadColumnElement.innerHTML = row.title;
					theadRowElement.append(theadColumnElement);
				}
				const tBodyColumnElement = document.createElement('td');
				tBodyColumnElement.innerHTML = row.value;
				tbodyRowElement.append(tBodyColumnElement);
			}
		});
		tBodyElement.append(tbodyRowElement);
	});

	theadElement.append(theadRowElement);

	document.getElementById('search_list_count').innerHTML = data.length;
}

const makeIntersectList = (data) => {
	// const theadElement = document.getElementById('resultThead');
	// const tBodyElement = document.getElementById('resultTbody');
	// const theadRowElement = document.createElement('tr');
	// data.forEach((d, idx) => {
	// 	const tbodyRowElement = document.createElement('tr');
	// 	d.attribute.forEach(row => {
	// 		if(row.title !== 'the_geom' && row.title !== 'id' && row.title !== 'object_id') {

	// 			if(idx === 0) {
	// 				const theadColumnElement = document.createElement('td');
	// 				theadColumnElement.innerHTML = row.title;
	// 				theadRowElement.append(theadColumnElement);
	// 			}
	// 			const tBodyColumnElement = document.createElement('td');
	// 			tBodyColumnElement.innerHTML = row.value;
	// 			tbodyRowElement.append(tBodyColumnElement);
	// 		}
	// 	});
	// 	tBodyElement.append(tbodyRowElement);
	// });

	// theadElement.append(theadRowElement);

	// document.getElementById('search_list_count').innerHTML = data.length;
}

function makeIntersectTableData (data) {
	const subWayNameArr = Object.keys(data[0]).map(k => data[0][k].properties.mllc);
	const subWayDataArr = Object.keys(data[1]).map(k => {
        const obj = {
            univ: 0,
            road: 0,
            rdnmadr_bass_map_subway_statn: 0
        }
        Object.keys(data[1][k]).forEach(key => {
            obj[key] = data[1][k][key].length;
        });
        return obj;
    });

	const subWaySummaryArr = subWayDataArr.map((d) => d.univ + d.road + d.rdnmadr_bass_map_subway_statn);

	const totalUniv = subWayDataArr.reduce((acc, cur) => {
		return acc + cur.univ
	}, 0);
	const totalRoad = subWayDataArr.reduce((acc, cur) => {
		return acc + cur.road

	}, 0);
	const totalSubway = subWayDataArr.reduce((acc, cur) => {
		return acc + cur.rdnmadr_bass_map_subway_statn
	},0);

}

function ResultGraph() {
	return `
		<div id="pieChartDiv">
			<div class="form-group pieChart" id="pieChart">
				<div class="row" style="display: block">
					<canvas id="myPieChart" width="200" height="200"></canvas>
				</div>
			</div>
			<div id="chartTable" style="max-height: 200px; overflow-y: auto">
				<table
					class="table table-custom table-cen table-num text-center"
					width="100%"
				>
					<thead id="chartThead"></thead>
					<tbody id="chartTbody"></tbody>
				</table>
			</div>
		</div>
	`
};

function ResultTable() {
	return `
		<div class="form-group graph" id="graph" style="display: none">
			<div class="text" style="max-height: 430px; overflow-y: auto">
				<table
					class="table table-custom table-cen table-num text-center"
					width="100%"
				>
					<thead id="dataResultTableHd">
					</thead>
        	<tbody id="dataResultTableBd"></tbody>
				</table>
			</div>
		</div>
	`
}

function ResultList() {
  return `
		<div class="form-group list" id="list" style="display: none">
			<div class="row" style="display: block">
				<div style="height: 30px; width: 100%; font-weight: bold">
					<div style="line-height: 20px; float: left">
						<span
							style="
								padding: 0 0px;
								color: #faa765;
								vertical-align: middle;
								display: inline-block;
							"
							><b>목록</b>
							<span class="small"
								>(전체
						 		<b class="text-orange">
									<span name="search_list_count" id="search_list_count"
										>0</span
									></b
								>건)</span
							>
						</span>
					</div>
				</div>

				<div class="text" style="max-height: 430px; overflow-y: auto">
					<table
						class="table table-custom table-cen table-num text-center"
						width="100%"
					>
						<thead id="resultThead"></thead>
						<tbody id="resultTbody"></tbody>
					</table>
				</div>
			</div>
		</div>
	`
}

//* 그래프 표 목록 선택 버튼 리스트
function BtnContent() {
	return `
		<div id="btnContent">
			<button
				type="button"
				id="pieChartBtn"
				size="10"
				class="form-control input-ib network"
			>
				그래프
			</button>
			<button
				type="button"
				id="graphBtn"
				size="10"
				class="form-control input-ib network"
			>
				표
			</button>
			<button
				type="button"
				id="listBtn"
				size="10"
				class="form-control input-ib network"
			>
				목록
			</button>
		</div>
	`
};

function showModalBtn() {
	const pieChartBtn = document.getElementById('pieChartBtn');
	const graphBtn = document.getElementById('graphBtn');
	const listBtn = document.getElementById('listBtn');
	const list = document.getElementById('list');
	const graph = document.getElementById('graph');
	const pieChart=document.getElementById('pieChart');

	// if (pieChartBtn !== null && graphBtn !== null && listBtn !== null && list !== null && graph !== null && pieChart !== null) {
		pieChartBtn.addEventListener('click', function() {
			list.style.display = 'none';
			graph.style.display = 'none';
			pieChart.style.display = 'block';
		});
		graphBtn.addEventListener('click', function() {
			list.style.display = 'none';
			graph.style.display = 'block';
			pieChart.style.display = 'none';
		});
		listBtn.addEventListener('click', function() {
			list.style.display = 'block';
			graph.style.display = 'none';
			pieChart.style.display = 'none';
		});
	// }
};

function ResultTable() {
	return `
		<div class="form-group graph" id="graph" style="display: none">
			<div class="text" style="max-height: 430px; overflow-y: auto">
				<table
					class="table table-custom table-cen table-num text-center"
					width="100%"
				>
					<thead id="dataResultTableHd">
					</thead>
        	<tbody id="dataResultTableBd"></tbody>
				</table>
			</div>
		</div>
	`
}

function ResultList() {
  return `
		<div class="form-group list" id="list" style="display: none">
			<div class="row" style="display: block">
				<div style="height: 30px; width: 100%; font-weight: bold">
					<div style="line-height: 20px; float: left">
						<span
							style="
								padding: 0 0px;
								color: #faa765;
								vertical-align: middle;
								display: inline-block;
							"
							><b>목록</b>
							<span class="small"
								>(전체
								<b class="text-orange">
									<span name="search_list_count" id="search_list_count"
										>0</span
									></b
								>건)</span
							>
						</span>
					</div>
				</div>

				<div id="analListTableCont" class="text" style="max-height: 430px; overflow-y: auto">
					<table
						class="table table-custom table-cen table-num text-center"
						width="100%"
					>
						<thead id="resultThead"></thead>
						<tbody id="resultTbody"></tbody>
					</table>
				</div>
			</div>
		</div>
	`
}

//* 그래프 표 목록 선택 버튼 리스트
function BtnContent() {
	return `
		<div id="btnContent">
			<button
				type="button"
				id="pieChartBtn"
				size="10"
				class="form-control input-ib network"
			>
				그래프
			</button>
			<button
				type="button"
				id="graphBtn"
				size="10"
				class="form-control input-ib network"
			>
				표
			</button>
			<button
				type="button"
				id="listBtn"
				size="10"
				class="form-control input-ib network"
			>
				목록
			</button>
		</div>
	`
};

function showModalBtn() {
	const pieChartBtn = document.getElementById('pieChartBtn');
	const graphBtn = document.getElementById('graphBtn');
	const listBtn = document.getElementById('listBtn');
	const list = document.getElementById('list');
	const graph = document.getElementById('graph');
	const pieChart=document.getElementById('pieChartDiv');

	// if (pieChartBtn !== null && graphBtn !== null && listBtn !== null && list !== null && graph !== null && pieChart !== null) {
		pieChartBtn.addEventListener('click', function() {
			list.style.display = 'none';
			graph.style.display = 'none';
			pieChart.style.display = 'block';
		});
		graphBtn.addEventListener('click', function() {
			list.style.display = 'none';
			graph.style.display = 'block';
			pieChart.style.display = 'none';
		});
		listBtn.addEventListener('click', function() {
			list.style.display = 'block';
			graph.style.display = 'none';
			pieChart.style.display = 'none';
		});
	// }
};

//* 검색결과내 수 입력시에 수인지 확인해서 1000자리로 , 찍기
function covertLocaleString(value){
	if(Number(value)){
		return Number(value).toLocaleString('ko-KR');
	} else return value;
}

//* 검색결과내 목록 레이어 이름 한글 이름 가져오기
function getLayerKorNmItem() {
	const lyrNmArrUnSlice = $('#output_select').text().split('X');
	const lyrNmArr = lyrNmArrUnSlice.slice(0, lyrNmArrUnSlice.length - 1);
	const lyrIdArr = $('#output_select li').map( function(){
		return $(this).attr('value').split('.')[1]
	}).get();

	return { lyrNmArr, lyrIdArr }
}

//* 분석 실행시, 선택레이어 목록에 담긴 레이어명으로 한글컬럼 정보 받아와 set 
async function setResultColTit(resultLyrColKorInfo) {
	try {
		const response = await $.ajax({
			type: 'POST',
			url: '/web/cmmn/gisLayerColumnInfo.do',
			data: { table_space, table_nm },
			dataType: 'json',
			success: function(data){
				if(data.result == 'Y' && data.allInfo.length) {
					resultLyrColKorInfo.push();
				}
			}
		});

		for (const params of paramsList) {
			try {
					const response = await $.ajax({
							type: 'POST',
							url: '/web/cmmn/gisLayerColumnInfo.do',
							data: params, // 매번 다른 data 파라미터
							dataType: 'json'
					});
					console.log("요청 성공:", response);
			} catch (xhr) {
					if (xhr.status === 403) {
							alert('요청 실패: 관리자에게 문의하십시오.');
					} else {
							console.error("에러 발생:", xhr);
					}
			}
		}

		return response;
	} catch (xhr) {
		if (xhr.status === 403) {
			alert('검색 요청이 실패했습니다.\n\n관리자에게 문의하시길 바랍니다.');
		} else {
			console.error("에러 발생:", xhr);
		}
	}
}

function fetchData(url, data) {
	return $.ajax({
			url: url,
			type: 'POST',
			data: data,
			dataType: 'json'
	});
}

// 여러 요청을 동시에 보내고 모든 요청이 완료될 때까지 대기
const requests = [
	fetchData('/endpoint1', { param: 'value1' }),
	fetchData('/endpoint2', { param: 'value2' }),
	fetchData('/endpoint3', { param: 'value3' })
];

function searchData(data){
	return $.ajax({
		url: '/web/cmmn/gisLayerSearchFeatures.do',
		type: 'GET',
		data,
		dataType: 'json'
});
}

//* 검색결과내 테이블 헤더 컬럼 한문명있는지 확인하고 없으면 영문 컬럼 정보 get
function getResultColTit(tit) {
	const promiseArr = [];

	$('#output_select li').each(function(idx, ele) {
		// let korInfoArray =  $(ele).attr('headkorinfo').replace(/[\[\]]/g, '').split(',');
		let enInfoArray =  $(ele).attr('headeninfo').replace(/[\[\]]/g, '').split(',')
		
	})

	Promise.all()
		.then(results => {
			results.forEach((result, index) => {
				console.log(`요청 ${index + 1} 결과:`, result);
		});
	})

	// info.map(([korInfoArray, enInfoArray]) => {
	// 	const index = enInfoArray.indexOf(tit);

	// 	if(index !== -1){
	// 		return korInfoArray[index] || tit;
	// 	} else {
	// 		return tit
	// 	}
	// })
}