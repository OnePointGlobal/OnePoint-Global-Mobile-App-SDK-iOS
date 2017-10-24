var iosOnly = {
    init : function(){
        this.addCSS();
    },
    addCSS : function(){
        $("body").css({"-webkit-transform": "translateZ(0px)"});
        $('.linkContent').css({"overflow-y":"scroll"});
        
        if($('.body_container').is(':visible')){
            //$('.body_container').css({"overflow-y":"scroll","-webkit-overflow-scrolling":"touch"});
            //$('.body_container').addClass("linkContent"});
            $('iframe').css("pointer-events","none");
        }
    }
};

