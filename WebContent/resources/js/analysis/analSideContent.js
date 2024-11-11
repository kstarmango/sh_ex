/* 
  분석에 필요한 컴포넌트를 동적으로 생성하기 위한 템플릿 return 
  필요한 데이터 삽입 후, 아래 템플릿 return function들을 재사용하여 여러 번 호출

  사업기획대상지 & 입력 레이어 >> #input_features.val()
  필드 검색이 추가된 field >> $('#output_field').find('.selected').val() 
  중첩레이어 검색 >> 
  $('#output_select li').map(function() {
    return $(this).attr('value');
	}).get().join(',');
 
   주소 검색 >> #addrOptionContainer 
  인근 거리 설정 >> #distanceInput.val()
 
*/

//* 전체 랜더링
function doRenderSearchComp(componentData) {
  var container = $('.areaSearch.full');
  container.children().not('#basic').remove();

  componentData.forEach(function(c) {
    if (c.type === 'search') {
      container.append(SearchBiz(c));
    } else if(c.type === 'choose') {
      container.append(ChooseBiz(c));
    } else if (c.type === 'addr') {
      container.append(SearchAddr(c));
    } else if (c.type === 'field') {
      container.append(ChooseField(c));
    } else if (c.type === 'button') {
      container.append(SelectAnalMethod(c));
    } else if (c.type === 'searchOverlap') {
      container.append(SearchOverlap(c));
    } else if (c.type === 'distanceInput') {
      container.append(SingleInput(c));
    } else if (c.type === 'walkMinInput') {
	  container.append(SingleInput(c));
		} else if (c.type === 'overlapLayer') {
      container.append(OverlapLayer(c));
    } else if (c.type === 'drawTool'){
      container.append(DrawTool(c));
    } else if (c.type === 'myData'){
      container.append(MyData(c));
    } else if (c.type === 'sggSelect') {
      container.append(ChooseSgg(c));
    } else if (c.type === 'fieldSelect') {
      container.append(NameField(c));
    }
  });
  container.children().find('select').trigger("chosen:updated");
}

function NameField(props) {
	return `
		<h3 class="tit" id="search">${props.title}</h3>
		<div class="selectWrap">
			<div class="disFlex" id="${props.id}">
				<select class="form-control chosen">
					<option value="">시설명 필드선택</option>
				</select>
			</div>
		</div>
	`
}

// 각 검색 조건 컴포넌트 start ------------------------------------------------------------------------------------------

//* 사업대상지 검색 & 입력 레이어 검색
function SearchBiz(props) {
  return `
		<h3 class="tit" id="search">${props.title} 검색</h3>
		<div class="inputWrap">
			<input type="text" id=${props.inputType} onkeyup="searchLayersNameNew(event, '${props.input}')" placeholder="검색할 데이터를 입력해주세요.">
			<button class="searchBtn" type="button" onclick="searchLayersNameNew(event, '${props.input}')">
				<img src="${contextPath}/resources/img/map/IcSearch.svg" alt="검색">
			</button>
		</div>

		<h3 class="tit" id="result">${props.title} 검색 결과</h3>
		<div class="inputWrap">
			<ul id=${props.features}></ul>
		</div>
  `;
}

//* 사업대상지 선택 목록
function ChooseBiz(props) {
  return `
    <h3 class="tit" id="result">${props.title} 선택 목록</h3>
		<div class="inputWrap">
			<ul id="output_select"></ul>
		</div>
  `
}

//* 중첩레이어 검색
function SearchOverlap(props) {
  return `
    <h3 class="tit" id="search">중첩 레이어 검색</h3>
    <div class="inputWrap">
      <input type="text" id="input_overlap" onkeyup="searchLayersNameNew(event, 'overlap')" placeholder="검색할 데이터를 입력해주세요.">
      <button class="searchBtn" type="button" onclick="searchLayersNameNew(event, 'overlap')">
        <img src="${contextPath}/resources/img/map/IcSearch.svg" alt="검색">
      </button>
    </div>

    <h3 class="tit" id="result">중첩 레이어 검색 결과</h3>
    <div class="inputWrap">
	<ul id="overlayLyrs">
    	<li onclick="selectEvt('overlayLyrs', this, 'overlay')" value="landsys_ex.v_thaep" headkorinfo="[HIDDEN,순서,구분,경로,레이어한글명,레이어영문명,설명]" headeninfo="[layer_no,no,grp_nm,grp_path,layer_nm,layer_tp_nm,layer_desc]">업무연계 빈집 매매</li>
        <li onclick="selectEvt('overlayLyrs' , this, 'overlay')" value="landsys_ex.v_b_thabm0001" headkorinfo="[HIDDEN,순서,구분,경로,레이어한글명,레이어영문명,설명]" headeninfo="[layer_no,no,grp_nm,grp_path,layer_nm,layer_tp_nm,layer_desc]">업무연계 건축물</li>
        <li onclick="selectEvt('overlayLyrs' , this, 'overlay')" value="landsys_ex.v_vpppd0b01" headkorinfo="[HIDDEN,순서,구분,경로,레이어한글명,레이어영문명,설명]" headeninfo="[layer_no,no,grp_nm,grp_path,layer_nm,layer_tp_nm,layer_desc]">업무연계 사업기획</li>
    </ul>
	</div>
    
    <h3 class="tit" id="result">선택 레이어 목록</h3>
		<div class="inputWrap">
			<ul id="output_select"></ul>
		</div>
  `
}

//* 주소 검색
function SearchAddr(props) {
  return `
    <h3 class="tit" id="search">주소 검색</h3>
		<div class="inputWrap">
			<input type="text" id="input_addr" onkeyup="searchAddrName(event)" placeholder="검색할 데이터를 입력해주세요.">
			<button class="searchBtn" type="button" onclick="searchAddrName(event)">
				<img src="${contextPath}/resources/img/map/IcSearch.svg" alt="검색">
			</button>
		</div>

		<h3 class="tit" id="result">주소 검색 결과</h3>
		<div class="inputWrap">
			<div class="disFlex" id="addrOptionContainer">
				<ul id="input_features">
			    </ul>
			</div>
		</div>
  `;
}

function ChooseSgg(props) {
	
	/*const divElement = document.createElement('div');
				
	divElement.append(`<h3 class="tit" id="search">${props.title}</h3>`);
	
	const selectWrap = document.createElement('div');
	selectWrap.className = "selectWrap";
	divElement.append(selectWrap);
	
	const disFlex = document.createElement('div');
	
	selectWrap.append(disFlex);
	
	const selectElment = document.createElement('select');
	selectElment.className = "form-control chosen";
	
	disFlex.append(selectElment);*/
	let str = `<div>
				<h3 class="tit" id="search">${props.title}</h3>
				<div class="selectWrap">
					<div class="disFlex">`;
	
	$.ajax({
		type: 'POST',
		url: global_props.domain+"/ajaxDB_sig_list.do",
		data: { "sidocd" : "11" },
		async: false,
		dataType: "json",
		success: function( data ) {
			if( data != null ) {				
				
				str += `<select class="form-control chosen" value="${data.sig_cd[0]}" id="${props.id}"}>`;
				
				for (i=0; i<data.sig_cd.length; i++) {
					let sig_nm = data.sig_nm[i];
					let sig_cd = data.sig_cd[i];
					
					str += `<option value="${sig_cd}">${sig_nm}</option>`;
				}
			}
		}
	});
	
	str += `</select>
				</div>
			</div>
		</div>`;
		
	return str;
}

//* 필드 검색
function ChooseField(props) {
  return `
		<h3 class="tit" id="search">입력 영역 필드 선택</h3>
		<div class="selectWrap">
			<div class="disFlex" id="optionContainer">
				<select class="form-control chosen">
					<option value="" onclick=""></option>
				</select>
			</div>
		</div>

		<h3 class="tit" id="search">필드 내 데이터 검색</h3>
		<div class="inputWrap">
			<input type="text" id="input_field" onkeyup="searchFieldData(event, ${props.isSlope})" placeholder="검색할 데이터를 입력해주세요.">
			<button class="searchBtn" type="button" onclick="searchFieldData(event, ${props.isSlope})">
				<img src="${contextPath}/resources/img/map/IcSearch.svg" alt="검색">
			</button>
		</div>

		<h3 class="tit" id="result">필드 내 데이터 검색 결과</h3>
		<div class="inputWrap">
			<ul id="output_field"></ul>
		</div>
  `;
}

//* 네트워크 기준, 분석방법 선택, 버퍼 설정
function SelectAnalMethod(props) {
  var str = '<div>';
  var option = 'network';

  str += `<h3 class="tit">${props.title}</h3> 
		<div class="selectWrap">
			<div id=${props.id} class="disFlex">`;

  if (props.id === 'bufferSpace') {
	  option = props.id;
  } else if(props.option === 'similar'){
		option = props.option
	}
  
  props.arr.forEach((val, idx) => {
    str += `<button type="button" onclick="selectEvt('${val.id}', this, '${option}')" size="10" 
            	value="${val.id}" id=`+ val.id + ` class="form-control input-ib network ${val.className? val.className:''} ${idx===0? 'selected' : ''}">
            	${val.name}
        		</button>`;
  });

  str += `</div></div></div>`;
  return str;
}

function selectEvt(containerId, ele, option) {
  $(ele).siblings().removeClass('selected');
  $(ele).addClass('selected');
  
  if (option == 'overlay') {
    const selectedValue = $(ele).attr('value');
    const selectedKorInfo = $(ele).attr('headkorinfo');
    const selectedEnInfo = $(ele).attr('headeninfo');

    const exists = $('#output_select li').filter(function() {
        return $(this).attr('value') === selectedValue;
    }).length > 0;

    if (!exists) { // 중복된 값이 없을 때만 추가
	   	const li = document.createElement('li');
	   	li.setAttribute('value', selectedValue);
	   	li.setAttribute('headkorinfo', selectedKorInfo);
	   	li.setAttribute('headeninfo', selectedEnInfo);
	   	li.innerText = $(ele).text();
	   	
	   	const p = document.createElement('p');
	   	p.innerText = 'X';
	   	p.onclick = function (){
				li.remove();
			}
		
			li.append(p);
	
		$('#output_select').append(li);
    } else {
		  alert('이미 선택된 레이어 입니다.');
	}
  } else if (option == 'network') {
	  if (containerId == 'distanceBtn') { //거리기준
			$('#distance').closest('div').parent().css('display', 'block');
    		$('#walkMin').closest('div').parent().css('display', 'none');
    		$('#walkMin').val('');
    		
  		if (containerId == 'multiring' || containerId == 'intersect') {
    		$('#touchBoundaryDistance').closest('div').parent().css('display', 'block');				
			} else {
    		$('#touchBoundaryDistance').css('display', 'block');
    		$('#touchBoundaryWalkMin').css('display', 'none');	
				$('#touchBoundaryWalkMin').val('');
			}
	  } else { //시간기준
		  	$('#walkMin').closest('div').parent().css('display', 'block');
    		$('#distance').closest('div').parent().css('display', 'none');
    		$('#distance').val('');

    		if (containerId == 'multiring' || containerId == 'intersect') {
    		$('#touchBoundaryWalkMin').closest('div').parent().css('display', 'block');	
			} else {	
    		$('#touchBoundaryWalkMin').css('display', 'block');
    		$('#touchBoundaryDistance').css('display', 'none');
				$('#touchBoundaryDistance').val('');
			} 
	  }
  } 

  if (containerId == 'nearby' || containerId == 'multiring') {
    $('#touchBoundaryDistance').closest('div').parent().css('display', 'block');
    $('#univCheckbox').closest('div').parent().css('display', 'none');
    $('#bufferSpace').closest('div').parent().parent().css('display', 'block');
  } else if (containerId == 'overlap' || containerId == 'adjoin' || containerId == 'intersect'){
    $('#touchBoundaryDistance').closest('div').parent().css('display', 'none');
    $('#univCheckbox').closest('div').parent().css('display', 'block');
    $('#bufferSpace').closest('div').parent().parent().css('display', 'none');
  } else if(containerId == 'output_field'){

		geoMap.getLayers().getArray().filter(lyr => lyr.get('title') === 'analInputLayer').map(ele=>{
			geoMap.removeLayer(ele);
		});

		const reader = new ol.format.WKT();
		var feature_4326 = new ol.Feature({
			geometry: reader.readGeometry(ele.attr('value'))
		});

		const vectorSource = new ol.source.Vector();
		const feature_3857 = new ol.Feature(feature_4326.getGeometry().transform('EPSG:4326', 'EPSG:3857'));
		vectorSource.addFeature(feature_3857);
		
		addAnalInputLayer(vectorSource);
	}

  // 선택된 값으로 containerId의 값을 설정
  $(`#${containerId}`).attr('value', $(ele).attr('value'));
}

//* 거리(m), 쉼표로 구분된 거리값(m)
function SingleInput(props) {
  var str = ''
  //if(props.id == 'touchBoundaryDistance' || props.id == 'walkMin') str += 'style="display: none;"'
  if(props.id == 'walkMin') str += 'style="display: none;"'

  return `
    <div ${str}>
      <h3 class="tit">${props.title}</h3> 
      <div class="inputWrap">
        <input type=${props.inputType} class="input-sm" id="${props.id}"/>
      </div>
    </div>
  `;
}

//* 중첩 레이어 선택 및 네트워크/버퍼 설정
function OverlapLayer(props) {  
  var str = ''

  if (typeof props.display !== 'undefined' && props.display === false) {	  
	  str += 'style="display: none;"'
  } else if(props.id == 'touchBoundaryDistance') {
	  if (typeof props.display == 'undefined') {
		  str += 'style="display: none;"';
	  }
  }

  return `
	  <div ${str} id="${props.id}">
	    <h3 class="tit">중첩레이어 선택 및 ${props.title} 설정</h3> 
	    <div class="inputWrap disFlexGap">
	      <input type="checkbox" class="input-sm" id="${props.id === "touchBoundaryWalkMin" ? "univTimeCheckbox" : "univCheckbox"}" style="width: 30px" />
	      <div style="width: 80px">대학교</div>
	      <input type="number" class="input-sm" id="univInput_${props.id}" value="${props.id === 'touchBoundaryDistance' ? '500' : '10'}" />
	      <span>
	      	${props.id === 'touchBoundaryDistance' ? 'm' : '분'}
	      </span>
	    </div>
	    <div class="inputWrap disFlexGap">
	      <input type="checkbox" class="input-sm" id="${props.id === "touchBoundaryWalkMin" ? "subwayTimeCheckbox" : "subwayCheckbox"}" style="width: 30px" />
	      <div style="width: 80px">지하철</div>
	      <input type="number" class="input-sm" id="subwayInput_${props.id}" value="${props.id === 'touchBoundaryDistance' ? '500' : '10'}" />
	      <span>
	      	${props.id === 'touchBoundaryDistance' ? 'm' : '분'}
	      </span>
	    </div>
	  </div>
  `
}

function DrawTool(props) {
  let result =``;
  result += `<div class="draw_tool_box">`;
  result += `<div class="draw_item" id="draw_polygon" title="폴리곤 그리기">
	    <img src="/resources/img/draw_polygon.svg" class="draw_polygon" alt="폴리곤 그리기" />
	  </div>`;
  result += `<div class="draw_item" id="draw_square" title="사각형 그리기">
		  <img src="/resources/img/draw_square.svg" class="draw_square" alt="사각형 그리기" />
		</div>`;
  if(props.name === 'destination'){
    result += `<div class="draw_item" id="draw_circle" title="원형 그리기">
			  <img src="/resources/img/draw_circle.svg" class="draw_circle" alt="원형 그리기" />
			</div>`;  
  } 
  result += `<div class="draw_item" id="draw_snap" title="스냅 ON/OFF">
		  <img src="/resources/img/draw_snap.svg" class="draw_snap" alt="스냅 ON/OFF" />
		</div>`;
  
  result += `<div class="draw_item" id="draw_remove" title="도형 삭제">
		  <img src="/resources/img/draw_remove.svg" class="draw_remove" alt="도형 삭제" />
		</div>`;
  result += `</div>`;
  return result;
}

//* my data 검색
function MyData(){
  return `
    <h3 class="tit" id="search">MYData 검색</h3>
	  <div class="inputWrap">
			<input type="text" id="input_MyData" onkeyup="searchMyDataName(event)" placeholder="검색할 데이터를 입력해주세요." />
			<button class="searchBtn" type="button" onclick="searchMyDataName(event)">
				<img src="${contextPath}/resources/img/map/IcSearch.svg" alt="검색">
			</button>
		</div>

		<h3 class="tit" id="result">MYData 검색 결과</h3>
		<div class="selectWrap">
			<div class="inputWrap" >
				<ul id="input_features"></ul>
			</div>
		</div>

		<h3 class="tit" id="search">입력 영역 필드 선택</h3>
		<div class="selectWrap" id="optionContainer">
			<div class="disFlex" >
				<select class="form-control chosen" >
					<option value="" onclick=""></option>
				</select>
			</div>
		</div>

		<h3 class="tit" id="search">필드 내 데이터 검색</h3>
		<div class="inputWrap">
			<input type="text" id="input_field" onkeyup="searchFieldData(event)" placeholder="검색할 데이터를 입력해주세요.">
			<button class="searchBtn" type="button" onclick="searchFieldData(event)">
				<img src="${contextPath}/resources/img/map/IcSearch.svg" alt="검색">
			</button>
		</div>

		<h3 class="tit" id="result">필드 내 데이터 검색 결과</h3>
		<div class="inputWrap">
			<ul id="output_field"></ul>
		</div>
  `
}
