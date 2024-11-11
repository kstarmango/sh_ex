/* 
 *    JS Name : menuSumStat.js
 *    Description : 시스템의 메뉴별 접속 이력 누계통계페이지용 스크립트
 *    used Menu : 관리자 > 통계관리 > 누계 - 메뉴별 조회
 */
function initGridA(Hearder, groupingSum,footSum){
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
			mergeCells: ["P_PROGRM_NM"],
           grouping: {
                by: ["P_PROGRM_NM"],
                columns: groupingSum
            }
	    },
	    columns: [
	        {
	            key: undefined, label: "메뉴 분류체계", columns: [
	            {key: "P_PROGRM_NM", label: "대메뉴", align: "center", width: 200},
	            {key: "PROGRM_NM", label: "소메뉴", align: "center", width: 250}
	        	]
	        },		
	        {key: "DEPT_NM", label: "사용자그룹"	, align: "center", width: 150},
	        {
	            key: undefined, label: "메뉴별 조회 수(회)", columns : Hearder
	        },
	        {key: "TOTAL"	  , label: "합계", formatter:"money", align: "center", width: 100, sortable: true}
	    ],
        footSum: [
        	footSum
        	]
	});	
	
	firstGrid.setColumnSort({
        "originalIndex": {orderBy: "asc", seq: 0}
      });
    
    return firstGrid;
    
}

function initGridB(){
	//console.log('initGridA');
	//그리드 생성	
	secondGrid = create_grid();
	
	secondGrid.setConfig({
	    target: $('[data-ax5grid="second-grid"]'),
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
	        }
	    },
	    columns: [
	    	 {key: "no", label: "구분"	, align: "center", width: 50},
	    	 {key: "dept_nm", label: "부서별"	, align: "center", width: 200},
	    	 {key: "percentage", label: "비율"	, align: "center", width: 120, sortable: true}
	       
	    ]
	});	

	return secondGrid;
    
}