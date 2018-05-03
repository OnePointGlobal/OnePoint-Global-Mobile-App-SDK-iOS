
$(function() {
	app.init('loginPage');
	//loginPage.init();
});

var loginPage = {
	scroll : null,
	initial_screenHeight : window.innerHeight,
	initial_screenWidth : window.innerWidth,
	keyboardVisible : false,
	init : function(){
		this.bindEvents();
        languageScript.applyLocalization(function(){$('.wrapper').css('opacity',1);});
		this.resetFields();
		this.styleFooter();
	},
	bindEvents : function(){
		$('#signin_submit').on('click',function() {
			loginPage.submitForm();
		});

        $(".appSite").each(function() {
			var link;
                           $(this).on('click', function() {
                                      var pageName = $(this).attr("data-attr");
                                      try {
                                      navigator.globalization.getLocaleName(function(loc) {
                                                                            var locale = loc.value.replace("_", "-");
                                                                            if(locale == "pt"){
                                                                            locale = "pt-BR";
                                                                            }
                                                                            if(locale.indexOf("en") != -1){
                                                                            locale = "en-US";
                                                                            }
                                                                            if(pageName == "clickhere"){
                                                                            var link = 'http://framework.onepointglobal.com/appwebsite/Home/Step3'+ '?location=mobile&culture='+locale;
                                                                            
                                                                            }
                                                                            else {
                                                                            var link = 'http://framework.onepointglobal.com/appwebsite/' + pageName + '?location=mobile&culture='+locale;
                                                                            
                                                                            }
                                                                            $(".bodyWrapper").show();
                                                                            try {
                                                                            if (platformSpecific.checkConnection() != Connection.NONE) {
                                                                            $('.wrapper').hide();
                                                                            $('.top_gradient').hide();
                                                                            $(".sitePage").show();
                                                                            var height = $(window).height() - $('.header').outerHeight();
                                                                            $('iframe, .linkContent').css('height',height);
                                                                            var e = document.createElement("iframe");
                                                                            if(!e)
                                                                            window.open(link,'_blank','location=no');
                                                                            else
                                                                            $(".sitePage .linkContent").html('<iframe src="'+link+'" onload="loginPage.loadFrame()"><p>Your browser does not support iframes.</p></iframe>');
                                                                            } else {
                                                                            $('.bodyWrapper').hide();
                                                                            utils.displayAlert(languageScript.translate('networkError'));
                                                                            }
                                                                            } catch (err) {
                                                                            $('.bodyWrapper').hide();
                                                                            utils.displayAlert(languageScript.translate('genericError'));
                                                                            }
                                                                            }, function(err) {						
                                                                            //console.log("Check locale Error: " + err);
                                                                            });
                                      } catch (err) {					
                                      console.log("Check locale Error: " + err);
                                      }				
                                      });
                           });
		

		/*document.addEventListener("showkeyboard", function(){
			$('.login_footer').show();
		}, false);
		
		document.addEventListener("hidekeyboard", function(){
			$('.login_footer').show();
	    }, true);*/
		
		$(".sitePage .backButton").on('click',function(){
			loginPage.backtoLogin();
		});
		
		$(window).on('resize', function() {
			
			if($(".sitePage").is(':visible')){
				var height = $(window).height() - $('.header').outerHeight();
				$('iframe, .linkContent').css('height',height);
			}
			var cond1 = window.innerWidth == loginPage.initial_screenWidth && window.innerHeight < loginPage.initial_screenHeight;
			var cond2 = window.innerHeight == loginPage.initial_screenHeight && window.innerWidth < loginPage.initial_screenWidth;
			is_keyboard = cond1 || cond2;
			
		    if(!is_keyboard)
		    	loginPage.styleFooter();
		});
		
		$('img').on('dragstart', function(event) { event.preventDefault(); });
		
		
		$("#username").on('keypress',function(event){
			var elementVal = $(this).val();
			if(event.keyCode == 13){
				if(elementVal == null || !elementVal){
					$("#username")[0].focus();
					$(this).addClass('inputError');
				}
                else{
                    $("#password")[0].focus();
				}
			}else $(this).removeClass('inputError');			
		});
		
		$("#password").on('keypress',function(event){
			var elementVal = $(this).val();
			if(event.keyCode == 13){
				if(elementVal == null || !elementVal){
					$(this).addClass('inputError');
					$("#password")[0].focus();
				}
				else{
					$("#password").blur();
					loginPage.submitForm();
				}
			}else $(this).removeClass('inputError');
		});
	},
	backtoLogin : function(){
		$('.bodyWrapper').hide();
		loginPage.resetFields();
		$('input').val('');
		$(".sitePage").hide();
		$(".sitePage .linkContent").html('');
		$('.top_gradient').show();
		$('.wrapper').show();
		/*$(".sitePage .linkContent").css('height','0');
		$('body').css('height','100%');
		console.log($('.wrapper').css('height'));
		console.log($('body').css('height'));*/
	},
	loadFrame : function(){
		$(".bodyWrapper").hide();
        $('iframe').contents().find(".faq").parent(".wrapper").addClass('faq_scroll');
        $('iframe').contents().find(".globalLink").on('click', function(event) {
                                                      event.preventDefault();
                                                      var link = $(this).attr("href");
                                                      var dataTosend = {"url":link};
                                                      window.open(link, '_system', 'location=no');
                                                      
                                                      });
	},
	loadFailure : function(link){
		$(".bodyWrapper").hide();
		window.open(link,'_blank','location=no');
	},
	submitForm : function(){
		var name = $('#username').val(); 
		var pass = $('#password').val();
 		loginPage.resetFields();
		$('.bodyWrapper').show();

		if(!( name && pass)){
			if(!name)
				$('#username').addClass('inputError');
			if(!pass)
				$('#password').addClass('inputError');
        
			loginPage.displayError(languageScript.translate('emptymsg'));
		}
		else{
			try{
				if(platformSpecific.checkConnection()!=Connection.NONE)
					cordova.exec(loginPage.callAnotherPage, function(){
						loginPage.displayError(languageScript.translate('wrongCredentials'));
                                 }, "AuthenticationPlugin", "login", [{"name":name.trim(),"pass":pass.trim(),"ver":"v2"}]);
				else
					loginPage.displayError(languageScript.translate('networkError'));
			}catch(err){loginPage.displayError(err);}
		}
	},
	callAnotherPage : function (data) {
		window.open('landingPage.html','_self');
	},
	styleFooter : function(){
		var windowHeight = window.innerHeight ? window.innerHeight : $(window).height();
		
		var wrapperHt = windowHeight - $('.top_gradient').height();
		
        $('body').height(windowHeight);
        $('.wrapper').height(wrapperHt);
        
        var footerHt = wrapperHt - $('.login_footer').outerHeight();
         
        if(windowHeight > 500)
        	footerHt -= 50;
       // $('.login_footer').css('margin-top',footerHt);

	},
	displayError : function(str){
		$(".bodyWrapper").hide();
		$('.message').html(str).addClass('error');
	},
	resetFields : function(){
		$('input').removeClass('inputError');
		$('.message').html('').removeClass('error,success');
	}
};
