<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ page
import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script
	type="text/javascript"
	src="<c:url value='/resources/js/common/analysisResult/spatialDistance.js'/>"
></script>

<!-- 기본 입지분석(거리) -->
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
	<div class="form-group pieChart" id="pieChart">
		<div class="row" style="display: block">
			<canvas id="myPieChart" width="200" height="200"></canvas>
		</div>
	</div>
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

			<div class="text" style="max-height: 160px; overflow-y: auto">
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
	<div class="form-group graph" id="graph" style="display: none">
		<div class="text" style="max-height: 160px; overflow-y: auto">
			<table
				class="table table-custom table-cen table-num text-center"
				width="100%"
			>
				<thead>
					<tr>
						<td>중첩 사업대상지 합계</td>
						<td id="intersect_count"></td>
					</tr>
				</thead>
				<tbody id="resultTable"></tbody>
				<!-- <thead id="dataResultTableHd"></thead>
        <tbody id="dataResultTableBd"></tbody> -->
			</table>
		</div>
	</div>
</div>
