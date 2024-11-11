/* 
 *    JS Name : adminCommon.js
 *    Description : 관리자 기능에서 공통으로 사용하는 스크립트
 *    used Menu : 관리자 페이지 전체
 */
'use strict';

const _select = new ax5.ui.select();
const _calendarpicker = new ax5.ui.calendar();
const _picker = new ax5.ui.picker();

class datePickerClass {
    constructor(name) {
		this.name = name;
		this.EL = $('[data-ax5picker="'+name+'"]');
		
	}
	
	 initDatepicker(triggerFunction){
		let objName = this.name;
		_picker.bind({
	        target: this.EL,
	        direction: "top",
	        content: {
	            width: 270,
	            margin: 10,
	            type: 'date',
	            config: {
	                control: {
	                    left: '<i class="fa fa-chevron-left"></i>',
	                    yearTmpl: '%s',
	                    monthTmpl: '%s',
	                    right: '<i class="fa fa-chevron-right"></i>'
	                },
	                lang: {
	                    yearTmpl: "%s년",
	                    months: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'],
	                    dayTmpl: "%s"
	                },
	                marker: (function () {
	                    var marker = {};
	                    marker[ax5.util.date(new Date(), {'return': 'yyyy-MM-dd', 'add': {d: 0}})] = true;
	 
	                    return marker;
	                })()
	            }
	        },
	        onStateChanged: function () {
				triggerFunction(this,objName);
	        }
	    });
		 
		return _picker;
	}
};

class selectClass {
    constructor(name,options) {
		this.EL = $('[data-ax5select="'+name+'"]');
		this.options = options;
	}
	initSelect(triggerFunction){
		_select.bind({
			theme:'primary',
			//theme: "success",
			//size: "lg",
			target: this.EL ,
	        options: this.options,
		    onChange: function () {
				triggerFunction(this);
		    }
		});
		return _select;
	}
};

class selectCascadeClass extends selectClass{
    constructor(name1,options1
			   ,name2,options2,filterKey,suvFilterKey) {
		super(name1,options1);
		this.cate2 = $('[data-ax5select="'+name2+'"]');
		this.list = options2;
		this.filterKey = filterKey;
		this.suvFilterKey = suvFilterKey;
	}
	initSelect2(triggerFn,v1,v2){
		//console.log("triggerFn",triggerFn);
		//console.log("v1",v1);
		//console.log("v2",v2);
		let options2 = [];
		if (typeof v1 === "undefined"){
			v1 = this.options[0].options[0].value;
		}
		let filterKey = this.filterKey;  //pid
 		let suvFilterKey = this.suvFilterKey; //estmt_ver
		this.list.forEach(function(n){
			if(suvFilterKey == null){
				if(n[filterKey] == v1) options2.push(n)
			}else{
				if(n[filterKey] == v1 && n[suvFilterKey] == v2) options2.push(n);
			}
        });
	/*	console.log("triggerFn",triggerFn);
		console.log("v1",v1);
		let options2 = [];
		if (typeof v1 === "undefined"){
			console.log("option>>>",this.options[0])
			//v1 = this.options[0].options[0].value;
		}
		console.log("????",this.options2);
		let filterKey = this.filterKey;
		this.list.forEach(function(n){
			console.log(">>>n[filterKey]>>>",n[filterKey]);
            if(n[filterKey] == v1) options2.push(n)
        });*/

        if(options2.length < 1){
        	options2.push({id:'',nm:'선택',value:'',text:'선택'});
        }
		_select.bind({
        	theme:'primary',
            target: this.cate2,
            options: options2,
            onChange: function(){
                triggerFn(this);
            }
        });
		return this._select;
	}
};

class selectFilterClass{
    constructor(name,options,filterKey) {
		this.cate = $('[data-ax5select="'+name+'"]');
		this.list = options;
		
		this.filterKey = filterKey;
	}
	initSelect(triggerFn,v1){
		//console.log("triggerFn",triggerFn);
		//console.log("v1",v1);
		let options2 = [];
		if (typeof v1 === "undefined"){
			v1 = this.list[0].pid;
		}
		let filterKey = this.filterKey;
		this.list.forEach(function(n){
            if(n[filterKey] == v1) options2.push(n)
        });

		
        if(options2.length < 1){
        	options2.push({value:'',text:'선택'});
        }

		_select.bind({
        	theme:'primary',
            target: this.cate,
            options: options2,
            onChange: function(){
                triggerFn(this);
            }
        });
		return this._select;
	}
};
