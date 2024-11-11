$(function() {

                !function ($) {
                    "use strict";

                    var MorrisCharts = function () {
                    };

                    //creates line chart
                    MorrisCharts.prototype.createLineChart = function (element, data, xkey, ykeys, labels, opacity, Pfillcolor, Pstockcolor, lineColors) {
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
                            lineWidth: '3px',
                            pointSize: 0,
                            preUnits: '$',
                            resize: true, //defaulted to true
                            lineColors: lineColors
                        });
                    },
                        //creates area chart
                        MorrisCharts.prototype.createAreaChart = function (element, pointSize, lineWidth, data, xkey, ykeys, labels, lineColors) {
                            Morris.Area({
                                element: element,
                                pointSize: 0,
                                lineWidth: 0,
                                data: data,
                                xkey: xkey,
                                ykeys: ykeys,
                                labels: labels,
                                hideHover: 'auto',
                                resize: true,
                                gridLineColor: '#eef0f2',
                                lineColors: lineColors
                            });
                        },
                        //creates area chart with dotted
                        MorrisCharts.prototype.createAreaChartDotted = function (element, pointSize, lineWidth, data, xkey, ykeys, labels, Pfillcolor, Pstockcolor, lineColors) {
                            Morris.Area({
                                element: element,
                                pointSize: 3,
                                lineWidth: 1,
                                data: data,
                                xkey: xkey,
                                ykeys: ykeys,
                                labels: labels,
                                hideHover: 'auto',
                                pointFillColors: Pfillcolor,
                                pointStrokeColors: Pstockcolor,
                                resize: true,
                                smooth: false,
                                gridLineColor: '#eef0f2',
                                lineColors: lineColors
                            });
                        },
                        //creates Bar chart
                        MorrisCharts.prototype.createBarChart = function (element, data, xkey, ykeys, labels, lineColors) {
                            Morris.Bar({
                                element: element,
                                data: data,
                                xkey: xkey,
                                ykeys: ykeys,
                                labels: labels,
                                hideHover: 'auto',
                                resize: true, //defaulted to true
                                gridLineColor: '#eeeeee',
                                barSizeRatio: 0.4,
                                xLabelAngle: 35,
                                barColors: lineColors
                            });
                        },
                        //creates Stacked chart
                        MorrisCharts.prototype.createStackedChart = function (element, data, xkey, ykeys, labels, lineColors) {
                            Morris.Bar({
                                element: element,
                                data: data,
                                xkey: xkey,
                                ykeys: ykeys,
                                stacked: true,
                                labels: labels,
                                hideHover: 'auto',
                                resize: true, //defaulted to true
                                gridLineColor: '#eeeeee',
                                barColors: lineColors
                            });
                        },
                        //creates Donut chart
                        MorrisCharts.prototype.createDonutChart = function (element, data, colors) {
                            Morris.Donut({
                                element: element,
                                data: data,
                                resize: true, //defaulted to true
                                colors: colors
                            });
                        },
                        MorrisCharts.prototype.init = function () {

                            //create line chart
                            var $data = [
                                {y: '2017-01', a: 50, b: 0},
                                {y: '2017-02', a: 75, b: 50},
                                {y: '2017-03', a: 30, b: 80},
                                {y: '2017-04', a: 50, b: 50},
                                {y: '2017-05', a: 75, b: 10},
                                {y: '2017-06', a: 50, b: 40},
                                {y: '2017-07', a: 75, b: 50},
                                {y: '2017-08', a: 100, b: 70},
                                {y: '2017-09', a: 85, b: 70},
                                {y: '2017-10', a: 65, b: 60},
                                {y: '2017-11', a: 80, b: 65},
                                {y: '2017-12', a: 100, b: 75}
                            ];
                            this.createLineChart('morris-line-example', $data, 'y', ['a', 'b'], ['20대', '30대'], ['0.1'], ['#ffffff'], ['#999999'], ['#188ae2', '#4bd396']);

                            //creating area chart
                            var $areaData = [
                                {y: '2011', a: 10, b: 20},
                                {y: '2012', a: 75, b: 65},
                                {y: '2013', a: 50, b: 40},
                                {y: '2014', a: 75, b: 65},
                                {y: '2015', a: 50, b: 40},
                                {y: '2016', a: 75, b: 65},
                                {y: '2017', a: 90, b: 60}
                            ];
                            this.createAreaChart('morris-area-example', 0, 0, $areaData, 'y', ['a', 'b'], ['토지', '건물'], ['#8d6e63', "#bdbdbd"]);

                            //creating bar chart
                            var $barData = [
                                {y: '2014', a: 75, b: 65, c: 95},
                                {y: '2015', a: 50, b: 40, c: 22},
                                {y: '2016', a: 75, b: 65, c: 56},
                                {y: '2017', a: 100, b: 90, c: 60}
                            ];
                            this.createBarChart('morris-bar-example', $barData, 'y', ['a', 'b', 'c'], ['토지', '건물', '사업지구'], ['#3ac9d6', '#ff9800', "#f5707a"]);

                            //creating Stacked chart
                            var $stckedData = [
                                {y: '강남구'	,	a: 27	,	b: 18	},
                                {y: '강동구'	,	a: 25	,	b: 18	},
                                {y: '강북구'	,	a: 35	, 	b: 15	},
                                {y: '강서구'	,	a: 17	,	b: 36	},
                                {y: '관악구'	,	a: 36	,	b: 21	},
                                {y: '광진구'	,	a: 20	,	b: 11	},
                                {y: '구로구'	,	a: 60	,	b: 20	},
                                {y: '금천구'	,	a: 24	,	b: 90	},
                                {y: '노원구'	,	a: 27	,	b: 20	},
                                {y: '도봉구'	, 	a: 21	,	b: 10	},
                                {y: '동대문구'	,	a: 20	,	b: 18	},
                                {y: '동작구'	,	a: 73	,	b: 18	},
                                {y: '마포구'	,	a: 87	,	b: 39	},
                                {y: '서대문구'	,	a: 105	,	b: 43	},
                                {y: '서초구'	,	a: 36	,	b: 31	},
                                {y: '성동구'	,	a: 51	,	b: 18	},
                                {y: '성북구'	,	a: 98	,	b: 29	},
                                {y: '송파구'	,	a: 18	,	b: 21	},
                                {y: '양천구'	,	a: 4	,	b: 6	},
                                {y: '영등포구'	,	a: 79	,	b: 24	},
                                {y: '용산구'	, 	a: 83	,	b: 28	},
                                {y: '은평구'	,	a: 45	,	b: 27	},
                                {y: '종로구'	,	a: 109	,	b: 32	},
                                {y: '중구'	,	a: 45	,	b: 21	},
                                {y: '중랑구'	,	a: 38	,	b: 14	}
                            ];
                            this.createStackedChart('morris-bar-stacked', $stckedData, 'y', ['a', 'b'], ['토지', '건물'], ['#26a69a', '#ebeff2']);
                            
                        },
                        //init
                        $.MorrisCharts = new MorrisCharts, $.MorrisCharts.Constructor = MorrisCharts
                }(window.jQuery);

                $.MorrisCharts.init();

        });






