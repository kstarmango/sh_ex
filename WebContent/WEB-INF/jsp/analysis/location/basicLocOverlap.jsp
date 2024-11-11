<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%>
<%@ page import="egovframework.mango.config.SHResource"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<script type="text/javascript">
  var contextPath = "${contextPath}";
  var shexPath = "<%=SHResource.getValue("sh.server.schema")%>://<%=SHResource.getValue("sh.server.url")%>";
  let btns = document.querySelectorAll(".faq__question");
  var componentData = [];

  $(document).ready(function() {
    $('#sub_content').show();
    initAnalService();

    componentData = [
      { type: 'search', title: '사업대상지', input: 'field', inputType: 'input_Lyr', features: 'input_features' },
      { type: 'field' },
      { type: 'searchOverlap' },
    ];

    doRenderSearchComp(componentData);

    drawLayer = new ol.layer.Vector({
      source: new ol.source.Vector(),
      title: 'analysis' //drawPolygon
    });
    geoMap.addLayer(drawLayer);
  });

  function switchSelectOption(e, type) {
    $(e.target).parent().find('.selected').removeClass('selected');
    $(e.target).addClass('selected');

    if (type == '사업대상지') {
      componentData = [
        { type: 'search', title: '사업대상지', input: 'field', inputType: 'input_Lyr', features: 'input_features' },
        { type: 'field' },
        { type: 'searchOverlap' },
      ];
    } else if (type == '주소검색') {
      componentData = [
        { type: 'addr' },
        { type: 'searchOverlap' },
      ];
    }

    doRenderSearchComp(componentData);
  }

  var overlayLyrs = [];

  function onClickAnalysis() {
    doBeforeAnalysis();
    const duplicate = geoMap.getLayers().getArray().filter(lyr => lyr.get('title') === 'basicAnalysis');
    if (duplicate.length > 0) {
      geoMap.removeLayer(duplicate[0]);
    }

    overlayLyrs = $('#output_select li').map(function() {
      return $(this).attr('value');
    }).get().join(',');

    const inputFeatures = $('#output_field').find('.selected').attr('value') || $('#input_features').find('.selected').attr('data-addrWKT');

    initAnalService(); //지도초기화

    if (inputFeatures && overlayLyrs) {
      callAnalResult({ schema: "landsys_gis", inputFeature: inputFeatures, overlayLyrs: overlayLyrs });
    } else {
      alert('값을 입력해주세요.');
      doAfterAnalysis();
    }
  }

  function callAnalResult(data) {
    const formData = {
      inputLyrIdList: $('#output_select li').map(function() {
        return $(this).attr('value').split('.')[1];
      }).get().join(','),
      ...data
    };

    const form = document.createElement("form");
    form.method = "POST";
    form.action = "<%=RequestMappingConstants.WEB_ANAL_BIZ_BASIC_LOCATION%>";
    form.target = "SearchWindow";

    Object.entries(formData).forEach(([key, value]) => {
      const hiddenField = document.createElement("input");
      hiddenField.type = "hidden";
      hiddenField.name = key;
      hiddenField.value = typeof value === 'object' ? JSON.stringify(value) : value;
      form.appendChild(hiddenField);
    });

    document.body.appendChild(form);
    window.open("", "SearchWindow", "toolbar=no, width=1100, height=720, directories=no, status=no, scrollbars=yes, resizable=yes");
    form.submit();
    document.body.removeChild(form);
  }

  // 차트만 view
  function displayResult(data) {
    try {

      let featuresLg = 0;
      const jsonString = res.trim().replace(/\r?\n|\r/g, '');
      const jsonData = JSON.parse(jsonString);
      const data = jsonData.data;
      let isNullResult = true;

      const inputLyrIdList = $('#output_select li').map(function() {
        return $(this).attr('value').split('.')[1];
      }).get();

      inputLyrIdList.forEach((id) => {
        if (JSON.parse(data[id]).features.length > 0) isNullResult = false;
      });

      if (isNullResult) {
        alert('분석 결과가 존재하지 않습니다. 조건을 변경해주세요');
        return;
      }

      const vectorSource = new ol.source.Vector();
      var layerList = [];

      if (data) {
        const styleColors = {};

        Object.keys(data).forEach((key, idx) => {
          const parseData = JSON.parse(data[key]);
          if (parseData.features.length) {
            featuresLg = parseData.features.length;
            const reader = new ol.format.GeoJSON();

            const features = reader.readFeatures(parseData, {
              dataProjection: 'EPSG:4326',
              featureProjection: 'EPSG:3857'
            });

            features.forEach((feature, fIdx) => {
              feature.set("layer_nm_style", key);
            });

            let [fillColor, strokeColor] = randomColor(0.4);
            styleColors[key] = { fill: fillColor, stroke: strokeColor };

            vectorSource.addFeatures(features);
          }
        });

        if (featuresLg === 0) {
          alert('중첩 레이어가 존재하지 않습니다. 다시 선택해주세요.');
        } else {
          var vectorLayer = new ol.layer.Vector({
            title: 'analysis',
            serviceNm: '기본입지분석(중첩)',
            source: vectorSource,
          });

          vectorLayer.setStyle(createBasicLocLayerStyle(vectorLayer, 'layer_nm_style', styleColors));

          geoMap.getView().fit(vectorSource.getExtent(), geoMap.getSize());
          var exportKey = xhr.getResponseHeader('export_key');
          geoMap.addLayer(vectorLayer);

          analLayer(contextPath, exportKey);
          Table(data, overlayLyrs, styleColors);
          resultLegend(styleColors);
        }
      }
    } catch (error) {
      console.log(error);
      alert('분석 결과 표시 중 오류가 발생했습니다.');
      doAfterAnalysis();
    }
  }

  function resultLegend(styles) {
    const lyrKorNmList = getLayerKorNmItem();
    const legend = Object.entries(styles).map(([key, value]) => {
      const index = lyrKorNmList.lyrIdArr.indexOf(key);
      if (index !== -1) {
        return { color: value.stroke, name: lyrKorNmList.lyrNmArr[index] };
      }
    });

    if (legend.length > 0) showLegend(legend);
  }

</script>

<body>
  <div role="tabpanel" class="areaSearch full" id="tab-02" style="overflow: auto;">
    <div id="basic">
      <h2 class="tit">기본 입지 분석(중첩)</h2>
      <h3 class="tit">입력 데이터 유형</h3>
      <div class="selectWrap">
        <div class="disFlex">
          <button type="button" id="business" size="10" class="form-control input-ib network selected" onclick="switchSelectOption(event, '사업대상지')">사업대상지</button>
          <button type="button" id="address" size="10" class="form-control input-ib network" onclick="switchSelectOption(event, '주소검색')">주소검색</button>
        </div>
      </div>
    </div>

    <div class="selectWrap">
      <div class="disFlex" id="optionContainer">
        <select class="form-control chosen">
          <option value="" onclick=""></option>
        </select>
      </div>
    </div>
  </div>

  <div class="breakLine"></div>
  <div class="disFlex smBtnWrap" style="padding: 1.6rem;">
    <button type="button" class="primaryLine" onclick="initAnalService()">초기화</button>
    <button type="button" class="primarySearch" onclick="onClickAnalysis()">분석</button>
  </div>

  <form id="GISinfoResultForm" name="GISinfoResultForm">
    <input type="hidden" name="geom[]">
  </form>
</body>
</html>