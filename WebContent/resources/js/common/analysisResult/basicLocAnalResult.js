function dataCase() {
// 기본입지 중첩분석
const basicLocOverlapUrl = '/web/analysis/biz/basicLocOverlap.do?inputFeature=POLYGON((126.73850067093974 37.42518362164432,127.169714049846 37.42518362164432,127.169714049846 37.67426427960331,126.73850067093974 37.67426427960331,126.73850067093974 37.42518362164432))37.521794941632706,126.89404074109854 37.521794941632706,126.89359158345647 37.521866188934474,126.89350175192806 37.521866188934474,126.89350175192806 37.522079930431566,126.89341192039964 37.522079930431566,126.89314242581442 37.52215117746119,126.893052594286 37.52215117746119,126.89287293122916 37.52222242442278,126.89287293122916 37.522436164899325,126.89296276275759 37.522792397666194,126.893052594286 37.522934890296675,126.893052594286 37.52314862873214,126.89377124651328 37.523077382655025,126.89422040415536 37.52300613650988,126.89502888791105 37.52286364401545,126.89574754013836 37.522792397666194,126.89583737166677 37.52272115124889,126.89574754013836 37.52250741158877,126.89565770860995 37.52222242442278,126.89556787708153 37.52200868333391)))&overlayLyrs=landsys_gis.cty_reside_envrn_imprmn_newtown, landsys_gis.cty_reside_envrn_imprmn_rtent_manage_zone';
fetch(basicLocOverlapUrl).then(res => res.json()).then(response => {
	const { data } = response;
	createDataTable(data);
	document.getElementById('loading_area').style.display = 'none';
	document.getElementById('content_area').style.display = 'block';
}).catch((err) => {
	console.error(err);
});
}

function createDataTable(data){
	let count = 0;
	const bodyElement = document.getElementById('dataResultTableBd');
	const headElement = document.getElementById('dataResultTableHd');

	document.getElementById('search_list_count').innerHTML = count;
	  
	const headRow = document.createElement('tr');
	const thead1 = document.createElement('td');
	const thead2 = document.createElement('td');
	thead1.innerText = '중첩 레이어명';
	thead2.innerText = '중첩대상 사업명';
	headRow.append(thead1);
	headRow.append(thead2);
	headElement.append(headRow);

	thead1.setAttribute("style", "background-color: rgb(245,245,245); position: sticky; top: 0px; border-top: 1px solid #000; border-bottom: 1px solid #ddd;");
	thead2.setAttribute("style", "background-color: rgb(245,245,245); position: sticky; top: 0px; border-top: 1px solid #000; border-bottom: 1px solid #ddd;");

	Object.keys(data).forEach(key => {
		 console.log(JSON.parse(data[key]));
		 const { features } = JSON.parse(data[key]);
		 count += features.length;

		 features.forEach((feature) => {
				const bodyRow = document.createElement('tr');
				const { basis_law, zone_nm } = feature.properties;
				const layerNameTd = document.createElement('td');
				layerNameTd.innerHTML = basis_law;
				bodyRow.append(layerNameTd);
				
				const zoneNmTd = document.createElement('td');
				zoneNmTd.innerHTML = zone_nm;
				bodyRow.append(zoneNmTd);

				bodyElement.append(bodyRow);
		 });
	});
}

$(document).ready(function(){
	dataCase();
});