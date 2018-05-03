var geofencingObj ={
    params : [],//["My Home", "12.892488", "77.628921", "200"],
   // currentLoc : [],
    trackingLoc : [],
    
	init : function(){


       // this.updateCurrentPos();
	    this.bindEvents();
        this.setGeofenceonoff();
	},
    updateCurrentPos :  function(){
        
        /* navigator.geolocation.watchPosition(function(position) {
                              //geofencingObj.currentLoc = [position.coords.latitude , position.coords.longitude];
                          },  function(error) {
                                            alert('code: '    + error.code    + '\n' +
                                                  'message: ' + error.message + '\n');
                                            }); */

    },
    setGeofenceonoff : function(){
        cordovaFunction.getData("geofenceonoff", function(data) {
                                results = data.value;
                                app.offStatus = data.value;
                                //alert(app.offStatus);
                                if(results == "on"){
                                    if (platformSpecific.checkConnection() == Connection.NONE){
                                        utils.displayAlert(languageScript.translate('networkError'));
                                        $(".btn[data-lang='geofencing_on']").removeClass('geo-on');
                                        $(".btn[data-lang='geofencing_off']").addClass('geo-off');
                                        $(".btn[data-lang='geofencing_on']").addClass('second-btn');
                                    }
                                    else{
                                        $(".btn[data-lang='geofencing_on']").addClass('geo-on');
                                        $(".btn[data-lang='geofencing_off']").removeClass('geo-off');
                                    }
                                }else{
                                
                                $(".btn[data-lang='geofencing_on']").removeClass('geo-on');
                                $(".btn[data-lang='geofencing_off']").addClass('geo-off');
                                }
                                }, function(data) {
                                });
    },
	bindEvents : function(){
			/*cordova.exec(app.processRegionMonitorCallback,function(error){
						
						},"DGGeofencing","initCallbackForRegionMonitoring", []);*/
			$('.btn').on('click',function(){
				 if($(this).attr('data-lang') == 'geofencing_off'){
					 $(this).addClass('geo-off');
					 $(this).siblings().removeClass('geo-on');
					 $(this).siblings('#geoOn').addClass('second-btn');
					 $('body').find('ul.scroller div.loggedStatus.online').removeClass('geo-online');
					 $('.first-btn').css('margin-left','4px');
				     cordovaFunction.storeData("geofenceonoff","off",function(data){},function(data){});
                         geofencingObj.setGeofenceonoff();
					 cordova.exec(function(result){
					 					alert('Off-Success');
					 				},function(error){
					 					alert('OFF-Not In The Range');
					 				},"DGGeofencing","stopMonitoringSignificantLocationChanges", []);
                         cordovaFunction.storeData("EnabledSurveyIDs",[],function(data){},function(data){});
                         cordovaFunction.storeData("PopUpSurveyIDs",[],function(data){},function(data){});
                         cordovaFunction.storeData("EnabledAddressIDs",[],function(data){},function(data){});


                         
				 }else if($(this).attr('data-lang') == 'geofencing_on'){
					 $(this).addClass('geo-on');
					 $(this).removeClass('second-btn');
					 $(this).siblings().removeClass('geo-off');
                         
					 $('body').find('ul.scroller li div.loggedStatus.online').addClass('geo-online');
               		 $('.first-btn').css('margin-left','4px');
                     //cordovaFunction.startLocationManager("",function(data){},function(data){})
                         
                         
                         
                     cordovaFunction.storeData("geofenceonoff","on",function(data){},function(data){});
                     geofencingObj.setGeofenceonoff();
                         cordova.exec(function(result){
                                      alert('On Success');
                                     },function(error){
                                      alert('ON-Not In The Range'+error);
                                      },"DGGeofencing","startMonitoringSignificantLocationChanges",[]);
                     /* cordovaFunction.loadGeoFencingLocations(geofencingObj.currentLoc, function(locations){
                                                                  //geofencingObj.trackingLoc =locations;
                                                              //alert(JSON.stringify(locations));
                                                            // $.each(locations,function(i , val){
                                                                     //geofencingObj.params = [ val.Address, val.Latitude , val.Longitude,"300"];
                                                                    cordova.exec(function(result){
                                                                                      alert('On Success');
                                                                                   navigator.notification.confirm(languageScript.translate('GeofencingInitiatorText'),
                                                                                                                function(data) {
                                                                                                                     if(data==1){
                                                                                                                     localStorage.setItem('surveyid', val.SurveyID);
                                                                                                                     applicationPage.loadpage("survey",'appPage');
                                                                                                                     }
                                                                                                                },languageScript.translate('HeaderText'),
                                                                                                                [languageScript.translate('takeSurvey'),languageScript.translate('cancel')]);
                                                                                 
                                                                                 },function(error){
                                                                                 alert('ON-Not In The Range'+error);
                                                                    },"DGGeofencing","startMonitoringSignificantLocationChanges");
                                                              });
                                                         
                                                                 }, function(error){
                                                                 alert(error);
                                                                 });*/
                         
                   
                         /*cordovaFunction.loadGeoFencingLocations(app.currentLoc, function(locations){
                                                                //geofencingObj.trackingLoc =locations;
                                                                 
                                                                 localStorage.setItem('surveyid', JSON.stringify(locations.SurveyIDs));
                                                                 alert(JSON.stringify(locations));
                                                                 $.each(locations.PopUpSurveys, function(i, val){
                                                                 //alert(JSON.stringify(locations.PopUpSurveys[i].SurveyID));
                                                                       navigator.notification.confirm(languageScript.translate('TakeSurveyPopUpText').concat(locations.PopUpSurveys[i].Address),
                                                                                                      function(data) {
                                                                                                      
                                                                                                      
                                                                                                      if(data==1){
                                                                                                      localStorage.setItem('popupsurveyid', locations.PopUpSurveys[i].SurveyID);
                                                                                                      applicationPage.loadpage("survey",'appPage');
                                                                                                      }else{
                                                                                                      localStorage.removeItem('popupsurveyid');
                                                                                                      }
                                                                                                      },languageScript.translate('HeaderText'),
                                                                                                      [languageScript.translate('takeSurvey'),languageScript.translate('NoThanks')]);
                                                                        geofencingObj.notificationObj = {
                                                                        body:languageScript.translate('TakeSurveyPopUpText').concat(locations.PopUpSurveys[i].Address),
                                                                        title:languageScript.translate('HeaderText')
                                                                        };
                                                                        //alert(geofencingObj.notificationObj);
                                                                        cordovaFunction.sendLocalNotification(geofencingObj.notificationObj,function(data){},function(error){});
                                                                        });
                                                                 
                                                                
                                                                }, function(error){
                                                                alert(error);
                                                                });*/
                         
				
				 }
			});
	},
    
 };
 $(function() {
	geofencingObj.init();
});
  

