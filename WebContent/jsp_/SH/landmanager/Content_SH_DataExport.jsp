<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
$(document).ready(function(){
	
	geoMap.addLayer(dr_layer);
	
});

var typeSelect = 'None';
var dr_vector;
var dr_source = new ol.source.Vector();
var dr_layer = new ol.layer.Vector({
	source: dr_source,
	style: new ol.style.Style({ stroke: new ol.style.Stroke({ color: "blue", width: 3 }) })
});
function add_vector_interaction() {
  	if (typeSelect !== 'None') {
  		dr_source.clear();
		dr_vector = new ol.interaction.Draw({ source: dr_source, type: typeSelect });
		dr_vector.on('drawend', function() { 
			typeSelect = 'None';
			add_vector_interaction();
	  	});
		dr_source.on('addfeature', function(evt){
		    var feature = evt.feature;
		    coords = feature.getGeometry().getCoordinates();
		});
    	geoMap.addInteraction(dr_vector);    	
  	}else{
  		geoMap.removeInteraction(dr_vector);
  	}
}


//범위선택
function area_sect() {
	//click정보조회
	clickselect = false; $("#geomap").css('cursor', 'default');
	
	typeSelect = "Polygon";	
	add_vector_interaction();
}




//테스트
var coords;
function exportLeaflet(){
	if(coords == null){
		alert("데이터추출 범위를 선택하세요");
		return null;
	}else{
		var b = "POLYGON((";
		for(i=0; i<coords[0].length; i++){
			var cor = ol.proj.transform(coords[0][i], 'EPSG:900913', 'EPSG:4326');
			b += cor.toString().replace(",", " ")+",";
		}
		b = b.substring(0, b.length-1);
		b += "))";
	}
	
	var graphicArray = [];
	$.ajax({
		type: 'POST',
		url: "/ajaxDB_data_list.do",
		data: { "pk" : b },
// 		async: false,
		dataType: "json",
		success: function( data ) {		
			if(data.pnu.length > 3000){ alert("해당 검색내용이 너무 많습니다. 범위를 다시 설정해주세요. (검색 건수 : "+data.pnu.length+"개)"); return;}
			for(i=0; i<data.pnu.length; i++){
				var geom = data.geom[i].replace('MULTIPOLYGON(((', '').replace(')))', '').split(",");
				var geom1 = [];
				var geom2 = [];
				var geom3 = [];
				for(j=0; j<geom.length; j++){
					var add = geom[j].split(" ");
					geom1.push( [Number(add[0]), Number(add[1])] ); 
				}
				geom2.push(geom1);
// 				geom3.push(geom2);
				var graphic = 
				{	geometry: 
//	 				{ x: Math.random()*50000+xmin,  y: Math.random()*50000+ymin, type: "point" },
					{
// 						rings: [[
// 						         [-122.63,45.52],[-122.57,45.53],[-122.52,45.50],[-122.49,45.48],
// 	   							 [-122.64,45.49],[-122.63,45.52],[-122.63,45.52]
// 						]],
						rings: geom2, type: "polygon"
						},
					attributes:
					{
						pnu: 	data.pnu[i]+"",
						jimok: 	data.jimok[i]+"",
						parea: 	data.parea[i]+"",
						pnilp: 	data.pnilp[i]+"",
						spfc: 	data.spfc[i]+"",
						land_use: 	data.land_use[i]+"",
						geo_hl: 	data.geo_hl[i]+"",
						geo_form: 	data.geo_form[i]+"",
						road_side: 	data.road_side[i]+"",
						prtown: 	data.prtown[i]+""
					}
				};
				graphicArray.push(graphic);
			}
			
			var someGraphics = graphicArray;
			if(someGraphics != null){
				var shapewriter = new Shapefile();
		        shapewriter.addESRIGraphics(someGraphics);
		        var outputObject = {
		            points: shapewriter.getShapefile("POINT"),
		            lines: shapewriter.getShapefile("POLYLINE"),
		            polygons: shapewriter.getShapefile("POLYGON")
		        };
		        var saver = new BinaryHelper();
		        var anythingToDo = false;
		        for (var shapefiletype in outputObject) {
		            if (outputObject.hasOwnProperty(shapefiletype)) {
		                if (outputObject[shapefiletype]['successful']) {
		                    anythingToDo = true;
		                    for (actualfile in outputObject[shapefiletype]['shapefile']) {
		                        if (outputObject[shapefiletype]['shapefile'].hasOwnProperty(actualfile)) {
		                            saver.addData({
		                                filename: shapefiletype + "_shapefile_from_jsapi_draw",
		                                extension: actualfile,
		                                datablob: outputObject[shapefiletype]['shapefile'][actualfile]
		                            });
		                        }
		                    }
		                }
		            }
		        }

		        if (anythingToDo) {
//		         	for (var i = 0; i < saver.data.length; i++) {
//		         		var filenm = saver.data[i]['filename']+"."+saver.data[i]['extension'];
//		                 saveAs(saver.data[i]['datablob'], filenm);
//		             }
//		 			var blob = new Blob([saver.data[0]['datablob']], {type: "application/zip"});
//		 			saveAs(blob, "data.zip"); 
		            saver.saveNative();
//		 			var f = saver.data[0]['datablob'];
//		 			var n = saver.data[0]['filename']+"."+saver.data[0]['extension'];
//		 			saveAs(f, n);
//		         	saveAs(saver.data[0]['datablob'], saver.data[0]['filename']+"."+saver.data[0]['extension']);
//		         	saveAs(saver.data[1]['datablob'], saver.data[1]['filename']+"."+saver.data[1]['extension']);
//		         	saveAs(saver.data[2]['datablob'], saver.data[2]['filename']+"."+saver.data[2]['extension']);
		        }
		        else {
		            alert("No shapefiles created!");
		            
		        }
			}
			$('#load').hide(); 
			
			
		}
	});	
		
}
	
	
</script>	



    	<!-- 데이터추출 Side-Panel -->
		<div class="tab-pane fade toptab" role="tabpanel" id="data-search-tab">
            <div class="pane-content map">

				<div class="search-condition in-data">
                    <div class="btn-wrap">
                        <button class="btn btn-orange btn-sm" id="area_sect" onclick="area_sect()">범위선택</button>
                    </div>
                </div>
                    
                <div class="search-result-list in-data">
	                <div class="list-group-wrap in-data">
	                    <ul class="list-group" id="addr_list">
	                        <li class="list-group-item">
	                            <div class="list-group-item-text-wrap">
<!-- 	                                <h5 class="list-group-item-heading">준비중입니다.</h5> -->
									<div class="form-group row">
										<div class="col-xs-6">
											<input type="radio" id="export_land" name="exports" value="01" checked="checked"/>&nbsp;
											<label for="export_land">토지(지적도)</label>
										</div>
										<div class="col-xs-6">
											<input type="radio" id="export_buld" name="exports" value="02" disabled="disabled"/>&nbsp;
											<label for="export_buld">건물(수치지도)</label>
										</div>
									</div>
	                            </div>
	                        </li>
	                    </ul>
	                </div>
	
	            </div>
		            
	            <div class="btn-wrap tab text-right" id="saveButtonDiv">
					<button class="btn btn-teal btn-sm" onclick="exportLeaflet()">내려받기</button>
                </div>
                
            </div>
        </div>
        <!-- End 데이터추출 Side-Panel -->
    
    
    
    
    