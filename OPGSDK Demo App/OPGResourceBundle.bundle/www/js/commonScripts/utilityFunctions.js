var utils = {
	scroll : null,
	userFullName : null,
	userImage : null,
	theme : [],
	panelID : 0,
	panels : {},
	surveyID : 0,
	initial_screenHeight : window.innerHeight,
	initial_screenWidth : window.innerWidth,
	dragging : false,
	// set dynamic css style
	styleBody : function() {
		var cond1 = window.innerWidth == this.initial_screenWidth && window.innerHeight < this.initial_screenHeight;
		var cond2 = window.innerHeight == this.initial_screenHeight && window.innerWidth < this.initial_screenWidth;
		//console.log("window Inner Width = "+window.innerWidth+" , window Inner Height = "+window.innerHeight+" , Initial Screen width = "+this.initial_screenWidth+" , Initial Screen Height = "+this.initial_screenHeight);
		var is_keyboard = cond1 || cond2;
		//console.log("is KeyBoard--"+is_keyboard);
		if(is_keyboard)
		  return;
		else{
		   this.initial_screenWidth = this.initial_screenWidth ;
		   this.initial_screenHeight = this.initial_screenHeight;
		}
		
        var windowHeight = window.innerHeight ? window.innerHeight : $(window).height();
        
		var bodyHeight = windowHeight - $('.header').outerHeight();
        
        if(isMobile.iOS())
            bodyHeight -= 20;

		$('.body_container').css('height', bodyHeight);
		
		var headerHeight = 0,footerHeight = 0,wrapperHeight = 0;
		
		if($('.pageHeader').length > 0 && $('.pageHeader').is(':visible'))
			headerHeight = $('.pageHeader').outerHeight();
		if($('.pageFooter').length > 0 && $('.pageFooter').is(':visible'))
			footerHeight = $('.pageFooter').outerHeight();
		
		wrapperHeight = bodyHeight - headerHeight - footerHeight;
		
		$('.wrapper').css('height', wrapperHeight);
		$('.headImgWrapo').css('height', wrapperHeight/2);
        
		$('.bodyWrapper').css('height', windowHeight);
		$('#navigationWrapper').css('height', windowHeight - $('#userDetails').outerHeight());
		
	},
	//check if the app is online/offline..Display username
	appstatus : function(callback) {
		cordovaFunction.getData("selectedPanel",function(data){
			utils.panelID = data.value;
			if(!utils.panelID || utils.panelID == ""){
				utils.logoutFunction();
				return;
			}
		},function(data){
			utils.logoutFunction();
			return;
		});
		try {
			if (platformSpecific.checkConnection() != Connection.NONE)
				$('.loggedStatus').addClass("online");
		} catch (err) {
			console.log("App is not online , error: " + err);
		}
		this.profileUpdate(callback);
	},
	profileUpdate : function(callback){
		cordovaFunction.fetchProfile({},function(data){
			utils.userFullName = data.PanellistProfileData.FirstName;
			$('.loggedUserName').text(utils.userFullName);
			if(data.PanellistProfileData.MediaID){
				var imageDataToSend = {"mediaType":"Image", "mediaID": data.PanellistProfileData.MediaID};
				cordovaFunction.downloadImage(imageDataToSend,function(data){
					utils.userImage = data.path || "images/profile.png";
					$('.loggedPic img').attr('src',utils.userImage+"?"+new Date().getTime());
					utils.panelUpdate(callback);
				},function(data){
					utils.userImage = "images/profile.png";
					$('.loggedPic img').attr('src',utils.userImage+"?"+new Date().getTime());
					utils.panelUpdate(callback);
				});
			} else{
				utils.userImage = "images/profile.png";
				$('.loggedPic img').attr('src',utils.userImage+"?"+new Date().getTime());
				utils.panelUpdate(callback);
			}
		},function(){
			utils.panelUpdate(callback)
		});
	},
	panelUpdate : function(callback){
		cordovaFunction.fetchPanels({}, function(data){
            themeScript.applyTheme(data,utils.panelID,function(){
                if(callback)
                    callback();
            });
		}, function(){
			if(callback)
                callback();
		});
	},
	IScrollRefresh : function(field) {
		try {
			if (utils.scroll)
				utils.scroll.destroy();
			utils.scroll = new IScroll(field, {
				hScrollbar : false,
				hScroll : false,
				mouseWheel : true
			});
			utils.scroll.on('scrollStart', function () {
				utils.dragging = true;
	        	});
			utils.scroll.on('scrollEnd',function () {
	                //had to use a timeout here because without it it would fire on links at the end of the drag / dragging slowly
	                setTimeout(function () { 
	                	utils.dragging = false;
	                }, 1000);
	            });
			setTimeout(function() {
				utils.scroll.refresh();
			}, 500);
			setTimeout(function() {
				utils.scroll.refresh();
			}, 1000);
		} catch (e) {
		}
	},
	displayAlert : function(message){
		  if (isMobile.Android() && isMobile.getAndroidVersion() < 3.0)
		      alert(message);
		  else{
			  try{
				  navigator.notification.alert(message, null, "MySurveys",languageScript.translate('ok'));
			  }catch(e){alert(e);}
		  }
	},
	showPrompt : function(message,callback){
		 if (isMobile.Android() && isMobile.getAndroidVersion() < 3.0){
			 var results = prompt(message);
			 callback(results);
		 }
		  else{
			  try{
                  navigator.notification.prompt(
                                                message,
                                                function(results){
                                                if(results.buttonIndex == 1)
                                                callback(results.input1)
                                                },
                                                languageScript.translate('barcode_text2'),
                                                [languageScript.translate('ok'),languageScript.translate('cancel')],
                                                null);
			  }catch(e){alert(e);}
		  }
		
	},
	exitApp : function(){
		if (isMobile.Android() && isMobile.getAndroidVersion() < 3){
			var r = confirm(languageScript.translate('exitapp'));
			if (r == true)
				navigator.app.exitApp();
		}else{
			try{
				navigator.notification.confirm(languageScript.translate('exitapp'),
					function(data) {
						if (data == 1)
							navigator.app.exitApp()
					},languageScript.translate('confirm'),
					[languageScript.translate('ok'),languageScript.translate('cancel')]);
			 }catch(e){utils.displayAlert(e);}
		}
	},
    signOut : function(){
        $('input').attr('readonly',true);
        $('select').attr('disabled',true);
        document.activeElement.blur();
         $(this).blur();
        if (isMobile.Android() && isMobile.getAndroidVersion() < 3){
			var r = confirm(languageScript.translate('signout'));
			if (r == true)
				utils.logoutFunction();
		}else{
			try{
				navigator.notification.confirm(languageScript.translate('signoutTxt'),
                     function(data) {
                                               if (data == 1){
                              utils.logoutFunction();
                                               }
                                               else{
                             $('input').attr('readonly',false);
                            $('select').attr('disabled',false);
                          $(this).blur();
                                               }
                      },languageScript.translate('signout'),
                          [languageScript.translate('ok'),languageScript.translate('cancel')]);
            }catch(e){utils.displayAlert(e);}
		}
       
    },
    logoutFunction : function(){
		$('.bodyWrapper').show();
		cordovaFunction.logout(function(){
            window.open('index.html','_self');
        $('.bodyWrapper').hide();
        },function(){
            $('.bodyWrapper').hide();
            utils.displayAlert(languageScript.translate('networkError'));
        });
	}
};

var isMobile = {
	    Android: function() {
	        return navigator.userAgent.match(/Android/i);
	    },
	    BlackBerry: function() {
	        return navigator.userAgent.match(/BlackBerry/i);
	    },
	    iOS: function() {
	        return navigator.userAgent.match(/iPhone|iPad|iPod/i);
	    },
        iPad: function() {
            return navigator.userAgent.match(/iPad/i);
        },
	    Opera: function() {
	        return navigator.userAgent.match(/Opera Mini/i);
	    },
	    Windows: function() {
	        return navigator.userAgent.match(/IEMobile/i);
	    },
	    anyMobile: function() {
	        return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
	    },
	    anyComputer: function() {
	    	if ( !navigator.userAgent.match(/mobile|android|ipad|tablet|kindle/i) )
	    		return navigator.userAgent.match(/Windows|Macintosh|Linux|Unix/i );
	    	else
	    		return null;
	    },
	    any:function() {
	    	return ( isMobile.anyComputer() || isMobile.anyMobile() );
	    },
	    getAndroidVersion : function(){
	    	var ua = navigator.userAgent;
	    	if(this.Android())
			  return parseFloat(ua.slice(ua.indexOf("Android")+8));
	    	else false;
	    },
        getIosVersion : function(){
            var ua = navigator.userAgent;
            if(this.iOS())
                return parseFloat(ua.slice(ua.indexOf("iOS")+8));
            else false;
        }
    
	};