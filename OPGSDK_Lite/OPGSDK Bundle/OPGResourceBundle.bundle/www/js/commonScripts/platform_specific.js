var platformSpecific = {

	checkConnection : function() {
		try {
			if (!navigator.network.connection)
				utils.displayAlert("Network is not supported by this mobile.");
			var networkState = navigator.connection.type;
			return networkState;
		} catch (err) {
			return;
			console.log("Check Connection Error: " + err);
		}
	},
	splashScreen : function(action){
		try{
			if(action == 'show')
				navigator.splashscreen.show();
			else //hide splash is default action
				navigator.splashscreen.hide();
		}catch(e){}
		
	},
	checkLocale : function(callback) {
		try {
			navigator.globalization.getLocaleName(function(locale) {
            if(locale.value == "ar-EG"){
             $('#signin_form #username,#signin_form #password').css({'text-align':'right','unicode-bidi':'bidi-override'});
             }
				callback(locale.value);
			}, function(err) {
				callback(false);
				//console.log("Check locale Error: " + err);
			});
		} catch (err) {
			callback(false);
			//console.log("Check locale Error: " + err);
		}
	},

	getLocation : function(positionElm, mapHolder, callback) {
		var options = {
			enableHighAccuracy : false,
			timeout : 10000,
			maximumAge : 30000
		};

		var self = this;
		try {
			if (navigator.geolocation) {
				navigator.geolocation.getCurrentPosition(function(position) {
					self.showPosition(position, positionElm, mapHolder,
							callback);
				}, function(error) {
					self.showError(error, callback);
				}, options);
			} else {
				callback("Geolocation is not supported by this browser.");
			}
		} catch (err) {
			//console.log("An error occured in navigator geolocation: " + err);
			callback(false);
		}
	},
	showPosition : function(position, positionElm, mapHolder, callback) {
		try {
			lat = position.coords.latitude;
			lon = position.coords.longitude;
			var txt = '<img src="images/location.png"/>'+languageScript.translate('geolocation_text2') || 'Your location is';
			positionElm.html(txt+'&nbsp;&nbsp;'+lat + ", " + lon);
			latlon = new google.maps.LatLng(lat, lon);
			var myOptions = {
				center : latlon,
				zoom : 14,
				mapTypeId : google.maps.MapTypeId.ROADMAP,
				mapTypeControl : false,
				navigationControlOptions : {
					style : google.maps.NavigationControlStyle.SMALL
				}
			};
			var mapholder = mapHolder[0];
			var map = new google.maps.Map(mapholder, myOptions);
			var marker = new google.maps.Marker({
				position : latlon,
				map : map,
				title : "You are here!"
			});
			callback(true);
		} catch (err) {
			//console.log('An error occured in displaying geolocation: ' + err);
			callback(false);
		}
	},
	showError : function(error, callback) {
		var returnData = [ {
			"code" : 0,
			"msg" : ""
		} ];
		try {
			switch (error.code) {
			case error.PERMISSION_DENIED:
				returnData.code = 1;
				returnData.msg = "User denied the request for Geolocation."
				break;
			case error.POSITION_UNAVAILABLE:
				returnData.code = 2;
				returnData.msg = "Location information is unavailable.";
				break;
			case error.TIMEOUT:
				returnData.code = 3;
				returnData.msg = "The request to get user location timed out.";
				break;
			case error.UNKNOWN_ERROR:
				returnData.code = 4;
				returnData.msg = "An unknown error occurred.";
				break;
			}
			callback(returnData);
		} catch (err) {
			//console.log('Error occured in geolocation error module : ' + err);
			callback(false);
		}
	},
	barcodeScan : function(callback) {
		cordova.plugins.barcodeScanner.scan(function(result) {
			callback(result);
		}, function(error) {
			callback();
		});
	},
	getImage : function(source, destination, callback, position) {
        
        if(position)
            var popover = new CameraPopoverOptions(position[0], 60 ,null , null, Camera.PopoverArrowDirection.ANY);
        else var popover = null;
        
        navigator.camera.getPicture(function(imageURI) {
			callback(imageURI);
		}, function(error) {
			//console.log('Failed getImage because: ' + error);
		}, {
			quality : 100,
			destinationType : destination,
			sourceType : source,
			MediaType : 0,
			EncodingType : 0,
			saveToPhotoAlbum : false,
			allowEdit : true,
			targetWidth : 160,
			correctOrientation : true,
            popoverOptions: popover
		});
	},

	datepicker : function(elm, position) {
		var currentField = elm;
		var today = new Date();
		var minDay = new Date();
		minDay.setTime(today.getTime() - (120 * 365 * 24 * 60 * 60 * 1000));
        
        xpos = (position.left + elm.width() / 2) || 0;
        ypos = (position.top-80) + elm.height() || 0;
       // console.log(position);
		var options = {
			date : today,
			mode : 'date',
			maxDate : today,
			minDate : minDay,
            allowFutureDates : false,
            x : xpos,
            y : ypos
		};

		datePicker.show(options, function(returnDate) {
			if (returnDate !== "" && returnDate != "undefined"
					&& !isNaN(returnDate)) {
				var dateString = platformSpecific.formatDate(returnDate);
				currentField.val(dateString);
				// This fixes the problem you mention at the bottom of this
				// script with it not working a second/third time around,
				// because it is in focus.
				currentField.blur();
			}
		});
	},
	formatDate : function(newDate) {
		var m_names = new Array(languageScript.languageFile['Jan'], languageScript.languageFile['Feb'],languageScript.languageFile['Mar'],languageScript.languageFile['Apr'], languageScript.languageFile['May'], languageScript.languageFile['Jun'],languageScript.languageFile['Jul'], languageScript.languageFile['Aug'], languageScript.languageFile['Sep'], languageScript.languageFile['Oct'], languageScript.languageFile['Nov'], languageScript.languageFile['Dec']);
		var curr_date, curr_month, curr_year, d;
		if (!newDate)
			return "";
		if (typeof (newDate) == 'object') {
			d = newDate;
			curr_date = d.getDate();
			curr_month = d.getMonth();
			curr_year = d.getFullYear();
		}
		if (typeof (newDate) == 'string') {
			if (newDate.substring(4, 5) == '-')
				newDate = newDate + 'Z';
			d = new Date(newDate);
			curr_date = d.getUTCDate();
			curr_month = d.getUTCMonth();
			curr_year = d.getUTCFullYear();
		}
		return (m_names[curr_month] + " " + curr_date + ", " + curr_year);
	},
    formatSurveyDate : function(newDate) {
        var m_names = new Array(languageScript.languageFile['Jan'], languageScript.languageFile['Feb'],languageScript.languageFile['Mar'],languageScript.languageFile['Apr'], languageScript.languageFile['May'], languageScript.languageFile['Jun'],languageScript.languageFile['Jul'], languageScript.languageFile['Aug'], languageScript.languageFile['Sep'], languageScript.languageFile['Oct'], languageScript.languageFile['Nov'], languageScript.languageFile['Dec']);
        var curr_date, curr_month, curr_year, d;
        if (!newDate)
            return "";
        if (typeof (newDate) == 'object') {
            d = newDate;
            curr_date = d.getDate();
            curr_month = d.getMonth();
            curr_year = d.getFullYear();
        }
        if (typeof (newDate) == 'string') {
            if (newDate.substring(4, 5) == '-')
                newDate = newDate + 'Z';
            d = new Date(newDate);
            curr_date = d.getUTCDate();
            curr_month = d.getUTCMonth();
            curr_year = d.getUTCFullYear();
        }
        return (m_names[curr_month].substr(0,3) + " " + curr_date + ", " + curr_year);
    },
	getISOString : function(dateString) {
		if (!dateString)
			return '0000-00-00T00:00:00';
        
        
		var d = new Date(dateString);
       
		var curr_date = d.getDate();
		var curr_month = d.getMonth() + 1; // Months are zero based
		var curr_year = d.getFullYear();
		if (curr_month < 10)
			curr_month = '0' + curr_month;
		if (curr_date < 10)
			curr_date = '0' + curr_date;
		var dateISO = curr_year + '-' + curr_month + '-' + curr_date
				+ 'T00:00:00';
        
		return dateISO;
	},
	getLocalDate : function(dateString) {
		var dateObj = new Date(dateString);
		var dateLocal = new Date(dateObj.getTime()
				- dateObj.getTimezoneOffset() * 60000);
		return dateLocal;
	},
	getDiff : function(isoDate) {

		var dateLocal = new Date(isoDate);
		var then = dateLocal.getTime();

		var d = new Date();
		var now = d.getTime();

		var diffMs = (now - then);
		// var diffSc = Math.round(diffMs/1000);
		var diffMns = Math.round(diffMs / 60000);
		var diffHrs = Math.round(diffMs / 3600000);

		var diff = null;

		// if(diffSc < 60)
		// diff = diffSc+ " secs ago";
		// else
		if (diffMns < 60)
			diff = diffMns + " mins ago";
		else if (diffHrs >= 1 && diffHrs < 24)
			diff = diffHrs + " hrs ago";
		else if (diffHrs >= 24 && diffHrs < 48)
			diff = 'yesterday';
		else
			diff = platformSpecific.formatDate(dateLocal);

		return diff;
		
	}

};
