/* 
 *    JS Name : menuStat.js
 *    Description : 시스템의 메뉴별 접속 이력 통계페이지용 스크립트
 *    used Menu : 관리자 > 통계관리 > 통계 - 메뉴별 조회
 */
function initGridA(){
	//console.log('initGridA');
	//그리드 생성	
	firstGrid = create_grid();
	
	firstGrid.setConfig({
	    target: $('[data-ax5grid="first-grid"]'),
	    showLineNumber: false,
	    showRowSelector: false,
	    multipleSelect: false,
	    sortable: false, 
	    multiSort: false,
	    header: {
	        align: "center",
	        columnHeight: 35
	    },
	    body: {
	        align: "center",
	        columnHeight: 35,
	        onClick: function () {
	            this.self.select(this.dindex);
	        },
			mergeCells: ["p_progrm_nm"],
           grouping: {
                by: ["p_progrm_nm"],
                columns: [
                    {
                        label: function () {
                            return this.groupBy.labels.join(", ") + " 합계";
                        }, colspan: 3, align: "center"
                    },
                    {key: "total", collector:"sum", align: "center"}
                ]
            }
	    },
	    columns: [
	        {
	            key: undefined, label: "메뉴 분류체계", columns: [
	            {key: "p_progrm_nm", label: "대메뉴", align: "center", width: 250},
	            {key: "progrm_nm", label: "소메뉴", align: "center", width: 400}
	        	]
	        },		
	        {key: "dept_nm", label: "사용자그룹"	, align: "center", width: 300},
	        {key: "total"	  , label: "조회 수(회)", formatter:"money", align: "center", width: 200}
	    ],
        footSum: [
            [
                {label: "합계", colspan: 3, align: "center"},
                {key: "total", collector:"sum", formatter:"money", align: "center"}
            ]]
	});	
	
	firstGrid.setColumnSort({
        "originalIndex": {orderBy: "asc", seq: 0}
      });
    
    return firstGrid;
    
}
