var days    = 24*60*60,
        hours   = 60*60,
        minutes = 60; 
    
    $.fn.countdown = function(prop){
 
        var options = $.extend({
            callback    : function(){},
            timestamp   : 0
        },prop);
 
        var left, d, h, m, s, positions;
 
        // инициализация
        init(this, options);
 
        positions = this.find('.b-counter__item');
 
        (function tick(){ 
            // осталось времени
            left = Math.floor((options.timestamp - (new Date())) / 1000);
 
            if(left < 0)
                left = 0;

 
            // осталось дней
            d = Math.floor(left / days);
            updateDuo(0, 1, d);
            left -= d*days;
 
            // часов
            h = Math.floor(left / hours);
            updateDuo(2, 3, h);
            left -= h*hours;
 
            // минут
            m = Math.floor(left / minutes);
            updateDuo(4, 5, m);
            left -= m*minutes;
 
            // секунд
            s = left;
            updateDuo(6, 7, s);
 
            options.callback(d, h, m, s);
 
            setTimeout(tick, 1000);
        })();
 
        // обновление двух цифр одновременно
        function updateDuo(minor,major,value){
            switchDigit(positions.eq(minor),Math.floor(value/10)%10);
            switchDigit(positions.eq(major),value%10);
        }
 
        return this;
    };
 
    function init(elem, options){
        elem.addClass('countdownHolder');
        $.each(['Дней','Часов','Минут','Секунд'],function(i, item){
            $('<div class="b-counter__block">').html(
                '<div class="b-counter__item">\
                    <span class="digit static">0</span>\
                </div>\
                <div class="b-counter__item">\
                    <span class="digit static">0</span>\
                </div>\
                <div class="b-counter__label">'+item+'</div>'
            ).appendTo(elem);
        });
     
    }
     

    function switchDigit(position,number){
     
        var digit = position.find('.digit');   
        if(digit.is(':animated')){
            return false;
        }
     
        if(position.data('digit') == number){
            return false;
        }
     
        position.data('digit', number);
     
        var replacement = $('<div>',{
            'class':'digit',
            css:{opacity:0},
            html:number
        });
     
        digit.before(replacement).remove();
        replacement.delay(100).animate({opacity:1},'fast',function(){});
    }