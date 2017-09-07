//# sourceURL=splashScreen.js

var splashScreen = {
	init : function(){
		splashScreen.readGeoFencing();
	    this.bindEvents();
		this.setHtml();
	},
	readGeoFencing : function(){
        //alert(app.offStatus);
        if(app.offStatus == 'off' || app.offStatus == ''){
        navigator.notification.confirm(languageScript.translate('GeofencingInitiatorText'),
                                       function(data) {
                                       if(data==1)
                                       applicationPage.loadpage("geofencing",'appPage');
                                       },languageScript.translate('HeaderText'),
                                       [languageScript.translate('Ok'),languageScript.translate('Notnow')]);
        }
        if(app.offStatus == 'on' && app.popUpShowId){
            app.popUpStatus = true;
            app.geofencingPopToggle();
        }
		
		
	},
	setHtml : function(panelData) {
		if (!themeScript.theme["Splash-html"])
			splashScreen.finishLoad();
		else {
			try{
				$('.body_container').html(themeScript.theme["Splash-html"]);
				if(themeScript.theme["logoMediaID"] != 0 && themeScript.theme["logoMediaID"]){
					var newsrc = themeScript.theme["logoMediaID"] + "?" + new Date().getTime();
					$('.splashScreen .imgwrapo').html('<img src="'+newsrc+'"/>');
				}else
					$('.splashScreen .imgwrapo').text(themeScript.theme["logoTxt"]);
			}catch(e){console.log(e)}
			splashScreen.finishLoad();
		}
	},
	finishLoad : function(){
		$('.splashScreen').css('opacity',1);
        utils.styleBody();
		utils.IScrollRefresh('.splashScreen.wrapper');
		splashScreen.bindEvents();
	},
	bindEvents : function(){
		$('.splashScreen .button').on('click', function() {
			applicationPage.loadpage('survey','appPage');
		});
	}
};

// if DOM loaded, proceed to bind the Cordova's deviceready event
$(function() {
	splashScreen.init();
});