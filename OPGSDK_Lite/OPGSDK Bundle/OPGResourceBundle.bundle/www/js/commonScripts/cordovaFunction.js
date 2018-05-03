var cordovaFunction = {
	cordovaOnlineCall : function(dataToSend, callback, errorFunction,
			pluginName, actionName) {
		$('.bodyWrapper').show();
		try {
			cordova.exec(function(data) {
 				$('.bodyWrapper').hide();
				//console.log("Success data in " + actionName + " : " + data);
				callback(cordovaFunction.validData(data));
			}, function(data) {
 				$('.bodyWrapper').hide();
				//console.log("Error occured in " + actionName + " : " + data);
				data = cordovaFunction.validData(data);
				if (data.code == 101)
					errorFunction(languageScript.translate('networkError'));
                else if (actionName == "changePassword")
                    errorFunction(languageScript.translate(cordovaFunction.validData(data)));
                else
					errorFunction(languageScript.translate('genericError'));
			}, pluginName, actionName, [ dataToSend ]);
		} catch (err) {
			$('.bodyWrapper').hide();
			//console.log("An error has occured : " + err);
			errorFunction(languageScript.translate('genericError'));
		}
	},
	storeProfile : function(dataToSend, callback, errorFunction) {
		this.cordovaOnlineCall(dataToSend, callback, errorFunction,
				"PanellistDataPlugin", "editProfile_network");
	},
    uploadOfflineResults : function(dataToSend, callback, errorFunction) {
        this.cordovaOnlineCall(dataToSend, callback, errorFunction,
                               "CheckForUpdatesPlugin", "uploadOfflineSurveyResults");
    },
    fetchPushNotificationList : function(dataToSend,callback,errorFunction){
        this.cordovaOfflineCall(dataToSend, callback, errorFunction,
                               "PushNotificationPlugin", "loadNotifications");
    },
    DeletePushNotification : function(dataToSend,callback,errorFunction){
        this.cordovaOnlineCall(dataToSend, callback, errorFunction,
                               "PushNotificationPlugin", "deleteNotification");
    },
    updatePushNotification : function(dataToSend,callback,errorFunction){
        this.cordovaOnlineCall(dataToSend, callback, errorFunction,
                               "PushNotificationPlugin", "updateNotification");
    },
	uploadImage : function(dataToSend, callback, errorFunction) {
		this.cordovaOnlineCall(dataToSend, callback, errorFunction,
				"MediaPlugin", "mediaUpload_network");
	},
	downloadImage : function(dataToSend, callback, errorFunction) {
		this.cordovaOnlineCall(dataToSend, callback, errorFunction,
				"MediaPlugin", "mediaDownload_network");
	},
	changePassword : function(dataToSend, callback, errorFunction) {
		this.cordovaOnlineCall(dataToSend, callback, errorFunction,
				"ChangePasswordPlugin", "changePassword");
	},
	checkForUpdate : function(dataToSend, callback,errorFunction) {
		this.cordovaOnlineCall(dataToSend, callback, errorFunction,
				"CheckForUpdatesPlugin", "checkForUpdate");
	},
	startOnlineSurvey : function(dataToSend, callback, errorFunction) {
		this.cordovaOnlineCall(dataToSend, callback, errorFunction,
				"TakeSurveyPlugin", "takeSurvey");
	},
    appUpdate : function(dataToSend, callback, errorFunction) {
        this.cordovaOnlineCall(dataToSend, callback, errorFunction,
                               "CheckForUpdatesPlugin", "AppUpdate");
    },
    loadGeoFencingLocations :function(dataToSend, callback, errorFunction) {
        this.cordovaOnlineCall(dataToSend, callback, errorFunction,
                               "GeoFencingPlugin", "loadGeoLocations");
    },
	cordovaDbCall : function(dataToSend, callback, errorFunction,
			pluginName, actionName) {
		$('.bodyWrapper').show();
		try {
			cordova.exec(function(data) {
				//console.log("Success data in " + actionName + " : " + data);
				$('.bodyWrapper').hide();
				callback(jQuery.parseJSON(data));
			}, function(data) {
				//console.log("Error occured in " + actionName + " : " + data);
				$('.bodyWrapper').hide();
				errorFunction(languageScript.translate('genericError'));
			}, pluginName, actionName, [ dataToSend ]);
		} catch (err) {
			$('.bodyWrapper').hide();
			//console.log("An error has occured : " + err);
			errorFunction(languageScript.translate('genericError'));
		}
	},
	fetchProfile : function(dataToSend, callback, errorFunction) {
		this.cordovaDbCall(dataToSend, callback, errorFunction,
				"PanellistDataPlugin", "fetchProfile_database");
	},
	fetchPanels : function(dataToSend, callback, errorFunction) {
		this.cordovaDbCall(dataToSend, callback, errorFunction,
				"PanelsPlugin", "panels_database");
	},
	getSurveyList : function(dataToSend, callback, errorFunction) {
		this.cordovaDbCall(dataToSend, callback, errorFunction,
				"SurveysPlugin", "survey_database");
	},
	cordovaOfflineCall : function(dataToSend, callback, errorFunction,
			pluginName, actionName) {
        
		try {
			cordova.exec(function(data) {
				callback(jQuery.parseJSON(data));
			}, function(data) {
 				errorFunction(languageScript.translate('genericError'));
			}, pluginName, actionName, [ dataToSend ]);
		} catch (err) {
            
			errorFunction(languageScript.translate('genericError'));
		}
	},
	getPath : function(dataToSend, callback, errorFunction) {
		this.cordovaOfflineCall(dataToSend, callback, errorFunction,
				"MediaPlugin", "mediaUpload_getPath");
	},
	logout : function(callback,errorFunction){
		this.cordovaOnlineCall([], callback, errorFunction,
				"LogoutPlugin", "logout");
	},
	storeSharedPreference : function(dataToSend, callback, errorFunction) {
		this.cordovaOfflineCall(dataToSend, callback, errorFunction,
				"LocalStoragePlugin", "set");
	},
	getSharedPreference : function(dataToSend, callback, errorFunction) {
		this.cordovaOfflineCall(dataToSend, callback, errorFunction,
				"LocalStoragePlugin", "get");
	},
    sendLocalNotification : function(dataToSend, callback, errorFunction) {
        this.cordovaOfflineCall(dataToSend, callback, errorFunction,
                                "GeoFencingPlugin", "sendLocalNotifications");
    },
    startLocationManager : function(dataToSend, callback, errorFunction) {
        this.cordovaOfflineCall(dataToSend, callback, errorFunction,
                                "GeoFencingPlugin", "startMonitoringLocations");
    },
	storeData : function(key, value, callback, errorFunction) {
		if(typeof(value) != 'object' && isMobile.Android())
			value = "\""+value+"\"";
		var dataToSend = {
			"key" : key,
			"value" : value
		};
		this.storeSharedPreference(dataToSend, callback, errorFunction);
	},
	getData : function(key, callback, errorFunction) {
    
		var dataToSend = {
			"key" : key
		};
		this.getSharedPreference(dataToSend, callback, errorFunction);
	},
	offlineSurveyFunction : function(dataToSend, callback, errorFunction,
			pluginName, actionName){
		try {
			cordova.exec(function(data) {
				console.log("Success data in " + actionName + " : " + data);
				callback(data);
			}, function(data) {
                $('.bodyWrapper').hide();
				errorFunction("Error occured in " + actionName + " : " + data);
			}, pluginName, actionName, [dataToSend]);
		} catch (err) {
			errorFunction(languageScript.translate('genericError'));
		}
	},
	startofflineSurvey : function(dataToSend, callback, errorFunction) {
		this.offlineSurveyFunction(dataToSend, callback, errorFunction,
				"RuntimePlugin", "start");
	},
	nextSurvey:function(dataToSend, callback, errorFunction){
		this.offlineSurveyFunction(dataToSend, callback, errorFunction,
				"RuntimePlugin", "continue");
	},
	stopSurvey:function(dataToSend, callback, errorFunction){
		this.offlineSurveyFunction(dataToSend, callback, errorFunction,
				"RuntimePlugin", "stop");
	},
	backSurvey:function(dataToSend, callback, errorFunction){
		this.offlineSurveyFunction(dataToSend, callback, errorFunction,
				"PlayerPlugin", "back");
	},
	/*pickMedia : function(callback){
		try {
			cordova.exec(function(data) {
				console.log("pick media: " + data);
				callback(data);
			}, function(data) {
				console.log("Error occured in pick media : " + data);
			}, "PickMediaPlugin", "local",  [{"mediaType":"Image", "source":"CAMERA"}]);
		} catch (err) {
			console.log("Error occured in pickMedia : " + err);
		}
	},*/
	uploadImageToLocation : function(mediaOption,callback,position){
		if(mediaOption == 0){
		   this.upload("pickImageFromGallery",callback,position);
		}else if(mediaOption == 1){
			this.upload("pickImageFromCamera",callback);
		}
	},
	upload:function(actionName,callback,position){
		try {
            cordova.exec(function(value) {
                
                var res = jQuery.parseJSON(value);
                callback(res.path);
            }, function(value) {
            	
            }, "MediaPickerAndPreviewPlugin", actionName, [position]);
        } catch (e) {
            console.log('Get picture failed because: ' + e);
        }
	},
	validData : function(data){
		var result;
		try{
			result = jQuery.parseJSON(data);
			if(result.HttpStatusCode == 401)
				utils.logoutFunction();
			else return result;
		}catch(error){}
		return data;
	}
};