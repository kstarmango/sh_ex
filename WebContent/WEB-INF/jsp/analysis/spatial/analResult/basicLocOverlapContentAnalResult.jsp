<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ page
import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script
	type="text/javascript"
	src="<c:url value='/resources/js/common/analysisResult/basicLocAnalResult.js'/>"
></script>

<!-- 기본 입지분석(중첩) -->
<div id="loading_area">데이터 로딩중</div>
<div
	class="card-box last table-responsive searchResult"
	style="border: 0px; display: none"
	id="content_area"
>
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
	<div class="form-group graph" id="graph" style="display: none">
		<div class="text" style="max-height: 160px; overflow-y: auto">
			<table
				class="table table-custom table-cen table-num text-center"
				width="100%"
			>
				<thead id="dataResultTableHd"></thead>
        <tbody id="dataResultTableBd"></tbody>
			</table>
		</div>
	</div>
</div>
