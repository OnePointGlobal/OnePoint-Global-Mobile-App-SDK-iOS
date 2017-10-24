(function($) {

    var alerts = {
        boxType : {Alert : 1 , Confirm : 2, Prompt : 3},
        type : null,title : null,msg : null,value : null,result : false,

        alert: function(type,message, title, callback, value) {
            this.type = this.boxType[type];
            this.msg = message;
            this.title = title ? title : type;
            this.value = value;
            this.result = false;
            this._show(function(result) {
                if( callback ) callback(result);
            });
        },
        _show : function(callback){
            var header = this._createHeader();
            var content = this._createContent();
            var footer = this._createFooter();

            var $popUp = $('<div/>')
            .attr('data-role', 'popup')
            .css({
                'min-width': '200px',
                'max-width': '480px'
            });

            $popUp.append(header).append(content).append(footer);

            $popUp.enhanceWithin();

            $popUp.popup({
                dismissible: false,
                transition: 'pop',
                corners: false,
                history: false,
                theme: 'a',
                overlayTheme: 'b'
            })
            .on('popupbeforeposition', alerts._popupbeforeposition)
            .on('popupafterclose', function(event) {
               alerts._popupafterclose(event,callback);
            })
            .popup('open');

        },
        _createHeader : function(){
            return node = $('<div />')
            .attr('data-role', 'header')
            .append($('<h1 />').html(this.title));
        },
        _createContent : function(){
            switch(this.type){
                case 3:
                    var node = $('<div />')
                        .attr('data-role', 'content')
                        .addClass('ui-content')
                        .css('min-height','80px')
                        .append($('<span />').text(this.msg));

                    var input = $('<input />')
                        .attr('type','text')
                        .attr('maxlength','50')
                        .val(this.value)
                        .appendTo(node);
                    return node;
                    break;
                default : 
                    return node = $('<div />')
                    .attr('data-role', 'content')
                    .addClass('ui-content')
                    .append($('<span />').text(this.msg));
            }
        },
        _createFooter : function(){

            switch(this.type){
                case 2:
                case 3:  
                    var node = $('<div />')
                        .attr({
                            'data-role': 'controlgroup',
                            'data-type': 'horizontal'
                        })
                        .css({
                            'margin': '0',
                            'width': '100%'
                        });

                    var okbtn = $('<a />', {
                            text: 'Ok'
                        }).attr('data-rel', 'back')
                        .attr('data-role', 'button')
                        .on('click',function(){
                             alerts.result = true;
                        });

                    var cancelbtn = $('<a>', {
                            text: 'Cancel'
                        })
                        .attr('data-rel', 'back')
                        .attr('data-role', 'button');

                    node.append(cancelbtn).append(okbtn);
                    return node;
                    break;
                case 1:
                default: 
                    var node = $('<div />')
                        .attr({
                            'data-role': 'controlgroup',
                            'data-type': 'vertical'
                        })
                        .css('margin', '0');

                    var closebtn = $('<a>', {
                            text: 'Close'
                        })
                        .attr('data-rel', 'back')
                        .attr('data-role', 'button');

                    closebtn.appendTo(node);

                    return node;
                    break;
                }

        },
        _popupbeforeposition : function(event) {
            var elm = $(event.currentTarget);
            switch(alerts.type){
                case 1 : 
                    elm.find('.ui-controlgroup .ui-btn').css({
                        'border-width': '1px 0 0'
                    });
                    break;
                case 2 :
                case 3 :
                    elm.find('.ui-controlgroup-controls').css('width', '100%');
                    elm.find('.ui-controlgroup .ui-btn').css({
                        'box-sizing': 'border-box',
                        'width': '50%',
                        'border-width': '1px 0 0'
                    });
                    elm.find('.ui-controlgroup .ui-btn.ui-last-child').css({
                        'border-left-width': '1px'
                    });
                    break;
            }
        },
        _popupafterclose : function(event,callback) {
            var elm = $(event.currentTarget);
            if(alerts.result && alerts.type == 3){
                    var text = elm.find('input').val();
                    alerts.result = text ? text : false;
            }
            elm.remove();
            callback(alerts.result);
        }
    };

    // Shortuct functions
    $.alertOpg = function(message, title) {
        alerts.alert('Alert',message, title);
    }
    
    $.confirmOpg = function(message, title, callback) {
        alerts.alert('Confirm',message, title, callback);
    };
        
    $.promptOpg = function(message, value, title, callback) {
        alerts.alert('Prompt',message, title, callback, value);
    };

}(jQuery));