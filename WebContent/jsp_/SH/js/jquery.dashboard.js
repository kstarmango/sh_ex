
/**
* Theme: Zircos  Admin Template
* Author: Coderthemes
* Dashboard
*/


 //creating donut chart
		var installCctv = [	
				   			{ y: '2009', a: 77 },
							{ y: '2010', a: 109 },
							{ y: '2011', a: 89 },
							{ y: '2012', a: 182 },
							{ y: '2013', a: 144 },
							{ y: '2014', a: 114 },
							{ y: '2015', a: 156 },
							{ y: '2016', a: 178 },
							{ y: '2017', a: 80 }
						];
		
		var brokenCctv = [
		         			{ y: '2009', a: 10 },
		        			{ y: '2010', a: 4 },
		        			{ y: '2011', a: 13 },
		        			{ y: '2012', a: 8 },
		        			{ y: '2013', a: 7 },
		        			{ y: '2014', a: 15 },
		        			{ y: '2015', a: 18 },
		        			{ y: '2016', a: 26 },
		        			{ y: '2017', a: 12 }
		        		];
		
		var installEmgrbell = [
				   			{ y: '2009', a: 8 },
							{ y: '2010', a: 15 },
							{ y: '2011', a: 13 },
							{ y: '2012', a: 46 },
							{ y: '2013', a: 40 },
							{ y: '2014', a: 32 },
							{ y: '2015', a: 47 },
							{ y: '2016', a: 76 },
							{ y: '2017', a: 22 }
						];
		
		var brokenEmgrbell = [
		         			{ y: '2009', a: 1 },
		        			{ y: '2010', a: 2 },
		        			{ y: '2011', a: 3 },
		        			{ y: '2012', a: 3 },
		        			{ y: '2013', a: 7 },
		        			{ y: '2014', a: 3 },
		        			{ y: '2015', a: 4 },
		        			{ y: '2016', a: 8 },
		        			{ y: '2017', a: 6 }
		        		];
		
        
        
		var donutData1 = [  
			                {label: "생활방범", value: 989},
							{label: "어린이보호", value: 235},
							{label: "시설/치수관리", value: 185},
							{label: "쓰레기단속", value: 32},							
							{label: "교통단속/교통정보", value: 29},							
							{label: "기타", value: 45}
			              ];
        
        var donutData2 = [
                          {label: "아날로그", value: 354},
                          {label: "디지털", value: 345}                          
                      ];
        
        var donutData3 = [
                            {label: "생활방범", value: 7},
							{label: "어린이보호", value: 2},
							{label: "시설/치수관리", value: 1},
							{label: "쓰레기단속", value: 1},							
							{label: "교통단속/교통정보", value: 1},							
							{label: "기타", value: 2}
                      ];
        
        var donutData4 = [
                          {label: "아날로그", value: 4},
                          {label: "디지털", value: 2}
                      ];
        

        
        var donutData5 = [
                          {label: "시간제", value: 4},
                          {label: "계약직", value: 5},
                          {label: "경찰공무원", value: 1},
                          {label: "용역업체", value: 15}                          
                      ];

!function($) {
    "use strict";

    var Dashboard1 = function() {
    	this.$realData = []
    };

    //creates Bar chart
    Dashboard1.prototype.createBarChart  = function(element, data, xkey, ykeys, labels, lineColors) {
        Morris.Bar({
            element: element,
            data: data,
            xkey: xkey,
            ykeys: ykeys,
            labels: labels,
            hideHover: 'auto',
            resize: true, //defaulted to true
            gridLineColor: '#eeeeee',
            barSizeRatio: 0.5,
            barColors: lineColors
            //postUnits: 'k'
        });
    },

    //creates line chart
    Dashboard1.prototype.createLineChart = function(element, data, xkey, ykeys, labels, opacity, Pfillcolor, Pstockcolor, lineColors) {
        Morris.Line({
          element: element,
          data: data,
          xkey: xkey,
          ykeys: ykeys,
          labels: labels,
          fillOpacity: opacity,
          pointFillColors: Pfillcolor,
          pointStrokeColors: Pstockcolor,
          behaveLikeLine: true,
          gridLineColor: '#eef0f2',
          hideHover: 'auto',
          resize: true, //defaulted to true
          pointSize: 0,
          lineColors: lineColors,
            //postUnits: 'k'
        });
    },

    //creates Donut chart
    Dashboard1.prototype.createDonutChart = function(element, data, colors) {
        Morris.Donut({
            element: element,
            data: data,
            resize: true, //defaulted to true
            colors: colors
        });
    }
    
    
    
    Dashboard1.prototype.init = function() {




        //creating bar chart

       /* var $barData2  = [
            { y: '2011', a: 11, b:40 },
            { y: '2012', a: 45, b:88 },
            { y: '2013', a: 15, b:70 },
            { y: '2014', a: 30, b:20 },
            { y: '2015', a: 11, b:40 },
            { y: '2016', a: 19, b:70 },
            { y: '2017', a: 93, b:20 }
        ];
        this.createBarChart('morris-bar-example2', $barData2, 'y', ['a', 'b'], ['Series A', 'Series B'], ['#3ac9d6', '#ff9800']);

        var $barData3  = [
            { y: '2011', a: 55, b:22 },
            { y: '2012', a: 63, b:93 },
            { y: '2013', a: 98, b:70 },
            { y: '2014', a: 70, b:20 },
            { y: '2015', a: 11, b:19 },
            { y: '2016', a: 70, b:68 },
            { y: '2017', a: 28, b:19 }
        ];
        this.createBarChart('morris-bar-example3', $barData3, 'y', ['a', 'b'], ['Series A', 'Series B'], ['#3ec0c4', '#b6a2ce']);*/

        //create line chart
        
        this.createLineChart('morris-line-cctv', installCctv, 'y', ['a'], ['총 대수'], ['0.9'],['#ffffff'],['#999999'],['#188ae2']);

        this.createLineChart('morris-line-emrgbell', installEmgrbell, 'y', ['a'], ['총 대수'],['0.9'],['#ffffff'],['#999999'], ['#10c469']);
       
        this.createDonutChart('morris-donut-example', donutData1, ['#3885c6', '#5fc090', "#f9c851", "#f27079", "#6c5faa", "#46c3d1"]);
    },
    //init
    $.Dashboard1 = new Dashboard1, $.Dashboard1.Constructor = Dashboard1



    var container = document.getElementById('tui-chart');
    var data = {
        categories: ['2017', '2016', '2015', '2014', '2013'],
        series: [
            {
                name: '설치 예산',
                data: [4510524, 3911135, 3526321, 2966126, 2362433]
            },
            {
                name: '유지보수 예산',
                data: [4359815, 3743214, 3170926, 2724383, 2232516]
            }
        ]
    };
    var options = {
        chart: {
            width: 550,
            height: 400,
            format: '1,000'
        },
        yAxis: {
            align: 'left'
        },
        series: {
            diverging: true
        },
        legend: {
            align: 'top'
        },
        chartExportMenu: {
            visible: false
        }
    };
    var theme = {
        series: {
            colors: ['#46C3D1', '#3885C6']
        }
    };

    tui.chart.registerTheme('myTheme', theme);
    options.theme = 'myTheme';

    tui.chart.barChart(container, data, options);







    var container2 = document.getElementById('tui-chart2');
    var data2 = {
        categories: ['2017', '2016', '2015', '2014', '2013'],
        series: [
            {
                name: '설치 예산',
                data: [4510524, 3911135, 3526321, 2966126, 2362433]
            },
            {
                name: '유지보수 예산',
                data: [3170926, 2724383, 2232516, 4359815, 3743214 ]
            }
        ]
    };
    var options2 = {
        chart: {
            width: 550,
            height: 400,
            format: '1,000'
        },
        yAxis: {
            align: 'left'
        },
        series: {
            diverging: true
        },
        legend: {
            align: "top"
        },
        chartExportMenu: {
            visible: false
        }
    };
    var theme2 = {
        series: {
            colors: ['#F9C851', '#5FC090']
        }
    };

    tui.chart.registerTheme('myTheme2', theme2);
    options2.theme = 'myTheme2';

    tui.chart.barChart(container2, data2, options2);


}(window.jQuery),

//initializing 
function($) {
    "use strict";
    $.Dashboard1.init();
}(window.jQuery);