var app = {
	keyboardVisible:false,
	pageID : '',
    offStatus : '',
    popUpStatus : true,
    surveyIdlist: false,
    notificationObj : {},
    currentLoc : [],
    //allData : {},
    popUpShowId : [],
    popUpAddress : [],
    enableSurvey : [],
	nativeOpen : false,
	// Application Constructor
	init : function(pageID) {
		this.bindEvents();
		this.pageID = pageID;
        this.updateCurrentPos();
	},
	// Bind Event Listeners
	//
	// Bind any events that are required on startup. Common events are:
	// 'load', 'deviceready', 'offline', and 'online'.
	bindEvents : function() {
		document.addEventListener('deviceready', this.onDeviceReady, false);
        document.addEventListener("resume", this.onResume, false);
		document.addEventListener("backbutton", this.onBackKeyDown, false);
    	document.addEventListener("showkeyboard", function(){
    		app.keyboardVisible = true;
		}, false);
		
		document.addEventListener("hidekeyboard", function(){
			app.keyboardVisible = false;
	    }, false);
        
    },
    updateCurrentPos :  function(){
        
       /* navigator.geolocation.watchPosition(function(position) {
                                            
                                            app.currentLoc = [position.coords.latitude , position.coords.longitude];
                                            //alert(app.currentLoc);
                                            },  function(error) {
                                            alert('code: '    + error.code    + '\n' +
                                                  'message: ' + error.message + '\n');
                                            }); */
        
    },
    processRegionMonitorCallback : function(result) {
       // alert(JSON.stringify(result));
        var callbacktype = result.callbacktype;
       // alert(callbacktype);
        if (callbacktype == "initmonitor") {
            
        }
        else if(callbacktype == "locationnotupdated") {
           // alert('in not updated one');
        }
        else if (callbacktype == "locationupdate") {
            
            cordovaFunction.loadGeoFencingLocations([], function(locations){
                                                    //geofencingObj.trackingLoc =locations;
                                                    var popupId = [];
                                                    var popUpaddress = [];
                                                    
                                                    //alert(app.allData);
                                                    //alert(locations.SurveyIDs);
                                                    //alert(JSON.stringify(locations.PopUpSurveys));
                                                    if(locations.PopUpSurveys != ''){
                                                    for(i=0;i<locations.PopUpSurveys.length;i++){
                                                    popupId.push(locations.PopUpSurveys[i].SurveyID);
                                                    popUpaddress.push(locations.PopUpSurveys[i].Address);
                                                    }
                                                
                                                    var enableId = locations.SurveyIDs;
                                                    
                                                    
                                                    //alert(locations.SurveyIDs);
                                                    cordovaFunction.storeData('popUpShowId',popupId,function(data){},function(error){});
                                                    cordovaFunction.storeData('popUpAddress',popUpaddress,function(data){},function(error){});
                                                    
                                                    cordovaFunction.storeData('enableSurvey',enableId,function(data){},function(error){});
                                                    //alert(app.popUpShowId);
                                                    //alert(app.popUpAddress);
                                                    //alert(app.enableSurvey);
                                                    app.geofencingPopToggle();
                                                    }
                                                    
                                                    }, function(error){
                                                    alert(error);
                                                    });
            
            
            
        } else if (callbacktype == "monitorremoved") {
            
        } else if (callbacktype == "monitorfail") {
            
        } else if (callbacktype == "monitorstart") {
            return true;
        } else if (callbacktype == "enter") {
           
            
        } else if (callbacktype == "exit") {
            
            
        }
    },
geofencingPopToggle: function(){

    //alert(app.enableSurvey);
    //alert(app.popUpShowId);
    cordovaFunction.getData('popUpShowId',function(data){
                            //console.log("before appending"+app.popUpShowId);
                           app.popUpShowId = data.value;
                            //alert(JSON.stringify(data));
                            //alert(app.popUpShowId[0]);
                            },function(){});
    cordovaFunction.getData('popUpAddress',function(data){app.popUpAddress = data.value;
                            //alert(app.popUpAddress[0]);
                            },function(){});
    cordovaFunction.getData('enableSurvey',function(data){
                            if(app.popUpShowId && app.popUpStatus){
                            //alert("enable "+data.value);
                            if(data.value.indexOf(app.popUpShowId[0]) == -1){
                                app.popUpAddress.shift();
                                app.popUpShowId.shift();
                                cordovaFunction.storeData('popUpShowId',app.popUpShowId,function(data){},function(error){});
                                cordovaFunction.storeData('popUpAddress',app.popUpAddress,function(data){},function(error){});
                            }
                            else{
                            //alert("else cond" + languageScript.translate('TakeSurveyPopUpText').concat(app.popUpAddress[0]));
                            navigator.notification.confirm(languageScript.translate('TakeSurveyPopUpText').concat(app.popUpAddress[0]),
                                                           function(data) {
                                                           //alert("if cond");

                                                           
                                                           if(data==1){
                                                           
                                                           app.surveyIdlist = true;
                                                           localStorage.setItem('popupsurveyid', app.popUpShowId[0]);
                                                           //alert("LocalStorage Survey ID" + localStorage.setItem('popupsurveyid'));
                                                           applicationPage.loadpage("survey",'appPage');
                                                           app.popUpShowId.shift();
                                                           app.popUpAddress.shift();
                                                           cordovaFunction.storeData('popUpShowId',app.popUpShowId,function(data){},function(error){});
                                                           cordovaFunction.storeData('popUpAddress',app.popUpAddress,function(data){},function(error){});
                                                           app.popUpStatus = false;
                                                           //localStorage.removeItem('popupsurveyid');
                                                           }else{
                                                           localStorage.removeItem('popupsurveyid');
                                                           app.popUpShowId.shift();
                                                           app.popUpAddress.shift();
                                                           cordovaFunction.storeData('popUpShowId',app.popUpShowId,function(data){},function(error){});
                                                           cordovaFunction.storeData('popUpAddress',app.popUpAddress,function(data){},function(error){});
                                                           app.popUpStatus = true;
                                                           app.geofencingPopToggle();
                                                           }
                                                           },languageScript.translate('HeaderText'),
                                                           [languageScript.translate('takeSurvey'),languageScript.translate('NoThanks')]);
                            // app.popUpShowId.shift();
                            // app.popUpAddress.shift();
                            //alert(app.popUpShowId);
                            }
                            }
                        },function(){});
},
	// deviceready Event Handler
	//
	// load js and bind events to DOM after device ready
	onDeviceReady : function() {
		platformSpecific.splashScreen('hide');
       // console.log("device ready");
		document.addEventListener("online", app.onOnline, false);
		document.addEventListener("offline", app.onOffline, false);
		//eval(app.pageID)['init']();
		window[app.pageID].init();
        if(isMobile.iOS())
            iosOnly.init();
        
        var path = window.location.pathname;
        var page = path.split("/").pop();
        //alert(page);
        if(page == 'applicationPage.html'){
          //  alert(page);
        window.plugins.DGGeofencing.initCallbackForRegionMonitoring([], app.processRegionMonitorCallback, function(error) {
                                                                    console.log("init error");
                                                                    });
            if(app.offStatus == 'on'){
                app.popUpStatus = true;
                app.geofencingPopToggle();
            }
        }
        
        
        //alert(localStorage.getItem('allData'));
        cordovaFunction.getData("geofenceonoff", function(data) {
                                results = data.value;
                                app.offStatus = data.value;
                                //alert(data.value);
                                if(results == "on"){
                                cordova.exec(function(result){
                                             //alert('On Success');
                                             },function(error){
                                             //alert('ON-Not In The Range'+error);
                                             },"DGGeofencing","startMonitoringSignificantLocationChanges",[]);
                                $('body').find('ul.scroller li div.loggedStatus.online').addClass('geo-online');
                                }
                                }, function(data) {
                                });
        
        
        
      
	},
    onBackKeyDown : function(e){
		if(app.keyboardVisible == true){}
		else if(app.pageID == 'loginPage'){
			if($('.sitePage').is(':visible'))
				loginPage.backtoLogin();
			else utils.exitApp();
		}
		else if(app.pageID == 'applicationPage'){
			if($('.pageWrapper').css('margin-left') == '0px'){
				applicationPage.toggleNavigation(false);
			}
			else if(applicationPage.old_url == "notification"){
				applicationPage.loadpage('survey','appPage');
			}
			else if($('.notification_bubble').is(':visible')){
				$(".notification_bubble").slideUp(100);
				$('.addSneezeGuard').hide();
			}
			else if($('.mediaWrapper').is(':visible')){
				Profile.hideMediaSelectionPanel(e);
			}
			else if($('.editProfilewrapo').is(':visible')){
				Profile.canceleditting();
			}
			else if($('.selectedSurveywrapo').is(':visible')){
				Survey.goToSurveyList($('.backButton'));
			}
			else if(app.nativeOpen){
				//reset the nativeOpen object once the cancel barcode scanner by pressing back button has been handled. 
				app.nativeOpen = false;
				return;
			}
			else if(applicationPage.old_url != 'survey'){
				applicationPage.loadpage('survey', 'appPage')
			}
			else utils.exitApp();
		}
		else utils.exitApp();
	},
	onOnline : function() {
		if($('.loggedStatus').length > 0)
			$('.loggedStatus').addClass("online");
	},
	onOffline : function() {
		if($('.loggedStatus').length > 0)
			$('.loggedStatus').removeClass("online");
	},
    onResume : function() {
         try{
            cordova.exec(function(data){
                         var result =jQuery.parseJSON(data);
                         var appUpdateUrl = result.AppDownloadURL;
                         if(appUpdateUrl.length != 0){
                         try{
                         navigator.notification.confirm(languageScript.translate('updateDesc'),
                                                        function(data) {
                                                        if (data == 1)
                                                        window.open(appUpdateUrl, '_system')
                                                        },languageScript.translate('confirmUpdate'),
                                                        [languageScript.translate('update'),languageScript.translate('cancel')]);
                         }catch(e){utils.displayAlert(e);}
                         }
                         }, function(err){
                         
                         },"CheckForUpdatesPlugin", "AppUpdate",[]);
        }catch(Ev){
            
        }
        
    }

    
};
