// legend item 추가 및 legend show
// items = [{color: '', name: ''}, {color: '', name: ''}, ...];
function showLegend(items, option){
	opener.$('.analLegendModal').show();
	const listEl = opener.$('.legendList');
	listEl.empty();
	
	for(let item of items){			
		const li = document.createElement('li');
		const span = document.createElement('span');
		const p = document.createElement('p');
		
		span.className = 'legendBox';
		span.style.backgroundColor = item.color;
		p.innerText = item.name;

		if(option === 'analysis'){
			p.setAttribute('id', item.type)
		}

		li.append(span);
		li.append(p);
		listEl.append(li);

		if(option === 'analysis'){
			const inputId = '.legendList li p#' + item.type;
			
			$(inputId).click(function(){
				const layer = geoMap.getLayers().getArray()
					.filter(gl => gl.get('title') === 'analysis')[0].getLayers().getArray()
					.filter(lyr => lyr.get('title') === item.type)[0];
				
				if(!$(inputId)[0].style.color){
					$(inputId)[0].style.color = '#b6b6b6';
					layer.setVisible(false);
				} else {
					layer.setVisible(true);
					$(inputId)[0].style.color = '';
				}
			})
		}
	}	
}

// legend item 초기화 및 hide 
function resetLegend(){
	$('.analLegendModal').hide();
	$('.analLegendModal h1').text('');
	$('.analLegendModal ul').empty();
}

let legendTxtArr = [];

function addLegendContent({gradeList, field, legendTit}){
	$(".mapLegendWrap").show();
	
	legendTxtArr.forEach((v, i) => {
		$("#gradeInterval" +(i + 1) + "*").html("<span class='legend-colorbox grade_level" + (i + 1) +"'></span>")
	})
	$(".regionTit").remove();
	
	legendTxtArr = gradeList.map((grade, idx) => {
		let txt = "";
		
		if(idx == 0 ){
			txt = "0 - " + grade + "  " + field;
		} else {			
			txt = gradeList[idx - 1] + " - " + grade + "  " + field;
		}

		return txt;
	});	
	
	legendTxtArr.forEach((v, i) => {
		$("#gradeInterval" +(i + 1)).append(` ${v}`);
	})
	
	$(".regionTit").append(`${legendTit}`);
}

function closeLegendContent(){
	$(".mapLegendWrap").hide();
	$(".regionTit").empty();
}

const devAnalLayerStyleList = {
	biotopeTypes: new ol.style.Style({
		fill: new ol.style.Fill({ color: 'rgba(255,0, 0, 0.5)' }),
		stroke: new ol.style.Stroke({ color: '#ff0033', width: 2 })
	}),
	biotopeIndivisuals: new ol.style.Style({
		fill : new ol.style.Fill({ color: 'rgba(255,255, 0, 0.5)' }),
		stroke: new ol.style.Stroke({ color: '#ffcc33', width: 2 })
	}),
	permit: new ol.style.Style({
		fill : new ol.style.Fill({ color: 'rgba(0,255, 0, 0.5)' }),
		stroke: new ol.style.Stroke({ color: '#00cc33', width: 2 })
	})
};