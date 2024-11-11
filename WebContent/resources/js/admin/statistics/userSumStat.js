/* 
 *    JS Name : userSumStat.js
 *    Description : 시스템의  사용자 접속 이력 누계통계페이지용 스크립트
 *    used Menu : 관리자 > 통계관리 > 누계 - 접속자
 */

function initGridA(Hearder, footSum){
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
	        }
	    },
	    columns: [
	    	 {key: "DEPT_NM", label: "부서별"	, align: "center", width: 200},
	        {
	            key: undefined, label: "시스템 접속 수(회)", columns : Hearder
	        },
	        {
	        	key: "total", label: "합계"	, align: "center", width: 100, sortable: true,
	        	//,styleClass: "total-column"  합계 스타일 지정시
	        	
	        },
	       
	    ],
        footSum: [
        	footSum
        	]
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
