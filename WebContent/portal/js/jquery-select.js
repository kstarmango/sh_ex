/**
 * V1.0.1
 * </> with <3 by Adrien
 * https://github.com/kaddyadriano/jquery-styled-select-box
 */
var arrSelect = new Array();
var arrhtml = new Array();

(function($, d){
    $(d).ready(function(){
        $('select.styled').styledSelect();
        $(d).on('click', function(e){
            var el = $(e.target),
                isSelect = el.closest('.styled-select').length;
            var selectStyled = el.closest('.styled-select');
            if(!isSelect){
                $('.styled-select .options').hide();
                $('.styled-select').removeClass('open');
            }
            for(var i = 0; i < arrhtml.length; i++){
            	var html = arrhtml[i];
            	if(selectStyled[0] != null && selectStyled[0].id != html[0].id) {
            		$('.options', html).hide();
            		html.removeClass('open');
            	}
            }
        });
    });
    
    $.fn.refresh_JS = function(param){
    	for(var i = 0; i < arrSelect.length; i++){
    		var targetSelect = arrSelect[i];
        	if(param['0'].nextSibling.value === targetSelect['0'].value){
                opt = $("option[value='"+targetSelect.val()+"']", targetSelect),
                optTitle = opt.html();
                $('.selected-display', param).html(optTitle);
                $('.option', targetSelect).removeClass('selected');
                $('.option[data-value="'+targetSelect.val()+'"]', param).addClass('selected');
                break;
        	}else{
        		continue;
        	}
    	}
    }
    
    $.fn.styledSelect = function() {
        if (!this.length) return false;
        
        this.each(function(k, select){
            select = $(select);
        	if(this.length > 1){
        		arrSelect.push(select);
        	} var val = select.val(),
            selectedTitle = $('option[value="' + val + '"]').html(),
            options = $('option', select),
            html = '';
		    html += '<div class="styled-select" id="'+select.context.id+'_st'+'"><span class="selected-display">' + selectedTitle + '</span><span class="arrow-wrap"></span></span>';
		    html += '<div class="options">';
		    var length = 0;
		    options.each(function (k, opt) {
		        opt = $(opt);
		        length = Math.max(length, opt.html().trim().length);
		        html += '<div class="option' + (opt.attr('value') == val ? ' selected' : '') + '" data-value="' + opt.attr('value') + '">' + opt.html() + '</div>';
		    });
		    html += '</div>';
		    html += '</div>';
		    var htmlSelect = $(html);
		    arrhtml.push(htmlSelect);
		    var number = Math.max(Number(parseInt(select.css('width'))),  number = 60 + (length * 10));
		    htmlSelect.css({width:number + 'px'});
		    select.hide().before(htmlSelect);
            $('.option', htmlSelect).on('click', function (e) {
                var opt = $(this),
                    optVal = opt.attr('data-value'),
                    optTitle = opt.html(),
                    val = select.val();
                if (optVal != val) {
                    $('.selected-display', htmlSelect).html(optTitle);
                    select.val(optVal).trigger('change');
                }
                $('.option', htmlSelect).removeClass('selected');
                opt.addClass('selected');
                toggleOptions(htmlSelect);
            });

            $('.selected-display, .arrow-wrap', htmlSelect).on('click', function (e) {
                toggleOptions(htmlSelect);
            });

            refresh = function(){
                var val = select.val(),
                    opt = $("option[value='"+val+"']", select),
                    optTitle = opt.html();
                    $('.selected-display', htmlSelect).html(optTitle);
                    $('.option', htmlSelect).removeClass('selected');
                    $('.option[data-value="'+val+'"]', htmlSelect).addClass('selected');
            }

            toggleOptions = function (htmlSelect) {
                if (htmlSelect.hasClass('open')) {
                    $('.options', htmlSelect).hide();
                    htmlSelect.removeClass('open');
                } else {
                    htmlSelect.addClass('open');
                    $('.options', htmlSelect).show();
                }
            }
            
            //events
            select.on('refresh', function(e){
                refresh();
            });
        });
    };
})(jQuery, document);