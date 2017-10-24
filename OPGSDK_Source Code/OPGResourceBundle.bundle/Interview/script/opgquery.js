
/*
 * opgQuery - the OnePoint Query JavaScript file.
 * Copyright (c) 2014 OnePoint Global Ltd. All rights reseved.
 */

var opgSlider = {
	init: function(questionid, minValue, maxValue) {
		var $sliders = $(questionid);
		$sliders.each(
			function (i, slider) {
				var $slider = $(slider);
				$slider.slider({
					value: $slider.val(),
					min: $slider.minValue,
					max: $slider.maxValue,
					animate: true,
				});
				$slider.slider('refresh');
			}
		);
	}
};


function opgQuery(mType, upload, capture, gallery) {

    this.mediaType = mType;
    this.mediaField = "unknown";
    this.uploadButton = upload;
    this.captureButton = capture;
    this.galleryButton = gallery;
    var self = this;

    this.video = 0;
    this.picture = 1;
    this.audio = 2;
    this.mediaFile = "";
    this.audioURI = "unknown";
    this.mediaURI = "unknown";
    this.mediaOptions = {
        "gallery": 0,
        "camera": 1
    };

    this.GalleryClick = function(param) {
        try {
            var source = param.mediaOptions["gallery"];
            switch (param.mediaType) {
                case this.video:
                    platformSpecific.getVideo(source, param.setMediaURI);
                    break;
                case this.picture:
                    platformSpecific.getPicture(source, param.setMediaURI);
                    break;
                case this.audio:
                    if (param.mediaURI == "unknown") {
                        platformSpecific.displayAlert("No media has been captured");
                        return;
                    }
                    var audioSrc;
                    if(param.audioURI != "unknown" && param.audioURI != "undefined")
                        audioSrc = param.audioURI;
                    else audioSrc = param.mediaURI;
                    console.log("audio src: "+audioSrc);
                    platformSpecific.getAudio(source, param.setMediaURI, audioSrc );
                    break;
            }

            $(param.uploadButton).text("Upload");
            $(param.uploadButton).buttonMarkup({ icon: "cloud" });
        } catch (e) {
            console.log("Error in gallery click: "+e);
        }
    };

    this.CaptureClick = function(param) {
        try {
            var source = param.mediaOptions["camera"];
            switch (param.mediaType) {
                case this.video:
                    platformSpecific.getVideo(source, param.setMediaURI);
                    break;
                case this.picture:
                    platformSpecific.getPicture(source, param.setMediaURI);
                    break;
                case this.audio:
                    platformSpecific.getAudio(source, param.setMediaURI);
                    break;
            }

            $(param.uploadButton).text("Upload");
            $(param.uploadButton).buttonMarkup({ icon: "cloud" });
        } catch (e) {
            console.log("Error in capture click: "+e);
        }
    };

    this.UploadClick = function(param) {
        try {
            if (param.mediaURI == "unknown") {
                platformSpecific.displayAlert("No file to upload!");
                return;
            }

            var comments = "Unknown Media from Survey";
            switch(param.mediaType) {
                case this.video:
                    comments = "Video Feedback";
                    break;
                case this.picture:
                    comments = "Picture Feedback";
                    break;
                case this.audio:
                    comments = "Audio Feedback";
                    break;
            }

            $(param.uploadButton).text("Uploading");
            var imageDataToSend = {
                "mediaPath": param.mediaURI,
                "comments": comments
            };
            cordovaFunction.uploadImage(imageDataToSend, function(data) {
                if(!data.Percent){
                    param.mediaField.attr('value',data.MediaID).val(data.MediaID);
                    $(param.uploadButton).text("Uploaded");
                    $(param.uploadButton).buttonMarkup({ icon: "check" });
                }
            }, function() {});
        } catch (e) {
            console.log("Error in upload click: "+e);
        }
    };

    this.initButtons = function(param) {
        $('form').off('click');
        if (param.galleryButton != "unknown") {
            $('form').on('click', param.galleryButton, function(param) { return function() { param.GalleryClick(param); } }(this));
        }

        if (param.captureButton != "unknown") {
            $('form').on('click', param.captureButton,function(param) { return function() { param.CaptureClick(param); } }(this));
        }

        $('form').on('click',param.uploadButton, function(param) { return function() { param.UploadClick(param); } }(this));
    };


    var init = function() {
        $(document).bind('pageinit', function() {
			$(".mrUpload").parents('label').siblings('.ui-input-text').hide();
            self.mediaField = $(".mrUpload").parents('label').siblings('.ui-input-text').find('input');
		});
        $(document).on('pagechange', self.initButtons(self));
    }();

    this.setMediaURI = function(filename,uri) {
        self.mediaURI = filename;
        self.audioURI = uri || "unknown";
    };
};

var platformSpecific = {
    checkConnection: function() {
        try {
            if (!navigator.network.connection)
                platformSpecific.displayAlert("Network is not supported by this mobile.");
            var networkState = navigator.connection.type;
            return networkState;
        } catch (err) {
            console.log("Check Connection Error: " + err);
        }
    },
    checkLocale: function(callback) {
        try {
            navigator.globalization.getLocaleName(function(locale) {
                callback(locale.value);
            }, function(err) {
                callback(false);
            });
        } catch (err) {
            callback(false);
        }
    },

    getLocation: function() {
        var options = {
            enableHighAccuracy: false,
            timeout: 10000,
            maximumAge: 10000
        };
        try {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(this.showPosition,
                    this.showError, options);
            } else {
                $("#mylocation").html("Geolocation is not supported by this browser.");
            }
        } catch (e) {
            $('.bodyWrapper').hide();
            $("#mylocation").html("An error occured.");
        }
    },
    showPosition: function(position) {
        try {
            lat = position.coords.latitude;
            lon = position.coords.longitude;
            $("#mylocation").html(lat + ", " + lon);
            latlon = new google.maps.LatLng(lat, lon);
            var myOptions = {
                center: latlon,
                zoom: 14,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                mapTypeControl: false,
                navigationControlOptions: {
                    style: google.maps.NavigationControlStyle.SMALL
                }
            };
            var mapholder = $("#mapholder")[0];
            var map = new google.maps.Map(mapholder, myOptions);
            var marker = new google.maps.Marker({
                position: latlon,
                map: map,
                title: "You are here!"
            });
            $('.bodyWrapper').hide();
        } catch (e) {
            $('.bodyWrapper').hide();
            $("#mylocation").html("An error occured.");
        }
    },
    showError: function(error) {
        try {
            switch (error.code) {
                case error.PERMISSION_DENIED:
                    $("#mylocation").html("User denied the request for Geolocation.");
                    break;
                case error.POSITION_UNAVAILABLE:
                    $("#mylocation").html("Location information is unavailable.");
                    break;
                case error.TIMEOUT:
                    $("#mylocation")
                        .html("The request to get user location timed out.");
                    break;
                case error.UNKNOWN_ERROR:
                    $("#mylocation").html("An unknown error occurred.");
                    break;
            }
        } catch (e) {
            $('.bodyWrapper').hide();
            $("#mylocation").html("An error occured.");
        }
    },

    barcodeScan: function(callback) {
        cordova.plugins.barcodeScanner.scan(function(result) {
            callback(result);
        }, function(error) {
            callback();
        });
    },

    getImage: function(source, destination, callback) {
        navigator.camera.getPicture(function(imageURI) {
            $('.pic > img').attr("src", imageURI);
            callback(imageURI);
        }, function(error) {
            //console.log("Get image: "+error);
        }, {
            quality: 100,
            destinationType: destination,
            sourceType: source,
            MediaType: 0,
            EncodingType: 0,
            saveToPhotoAlbum: true,
            allowEdit: true,
            targetWidth: 160,
            correctOrientation: true
        });
    },

    getPicture: function(source, callback) {
        try {
            navigator.camera.getPicture(function(fileName) {
                callback(fileName);
            }, function(error) {
                //console.log('get picture failed because: ' + error);
            }, {
                quality: 100,
                sourceType: source,
                MediaType: 0,
                EncodingType: 0,
                saveToPhotoAlbum: true,
                allowEdit: true,
                targetWidth: 160,
                correctOrientation: true
            });
        }
        catch(e) {
            callback("unknown");
        }
    },

    getVideo: function(source, callback) {
        try {
            navigator.device.capture.captureVideo(function(mediaFiles) {
                var i, len;
                for (i = 0, len = mediaFiles.length; i < len; i += 1) {
                    var mediaFile = mediaFiles[i].fullPath;
                    if (callback != null) {
                        callback(mediaFile);
                    }
                }
            }, function(error) {
                console.log('getVideo Failed because: ' + error);
            }, {
                quality: 100,
                sourceType: source
            });
        }
        catch(e) {
            console.log("getVideo Error:" + e);
        }
    },

    getAudio: function(source, callback, mediaFile) {
        //console.log('audio play called: '+source);
        if (source == 1) {
            navigator.device.capture.captureAudio(function(mediaFiles) {
                var i, len;
                for (i = 0, len = mediaFiles.length; i < len; i += 1) {
                    var file = mediaFiles[i].fullPath;
                    var uri = mediaFiles[i].uri;
                    if (callback != null) {
                        callback(file,uri);
                    }
                    return;
                }
            }, function(error) {
                console.log('getAudio Failed because: ' + error);
            });
        } else {
        	try{
                var temp = new Media(mediaFile,function(){
                	//console.log('success');
                },function(error){
                	//console.log('code: '    + error.code    + '\n' +
                    //        'message: ' + error.message + '\n');
                });
            }catch(err){
                console.log("error in media: "+err);
            }
            temp.play();
        }
    },

    datepicker: function(elm) {

        var currentField = elm;
        var myNewDate = new Date();

        // Same handling for iPhone and Android
        window.plugins.datePicker.show({
            date: myNewDate,
            mode: 'date', // date or time or blank for both
            allowOldDates: true
        }, function(returnDate) {
            if (returnDate !== "") {
                var newDate = new Date(returnDate);
                var dateString = platformSpecific.formatDate(newDate);
                currentField.val(dateString);
                // This fixes the problem you mention at the bottom of this
                // script with it not working a second/third time around,
                // because it is in focus.
                currentField.blur();
            }
        });

    },
    formatDate: function(newDate) {
        var m_names = new Array("Jan", "Feb", "Mar", "Apr", "May",
            "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");

        var d = newDate;
        var curr_date = d.getDate();
        var curr_month = d.getMonth();
        var curr_year = d.getFullYear();
        return (m_names[curr_month] + " " + curr_date + ", " + curr_year);
    },
    getISODate: function(dateString) {
        var dateObj = new Date(dateString);
        var dateISO = dateObj.toISOString();
        return dateISO.substr(0, 19);
    },
    getLocalDate: function(dateString) {
        var dateObj = new Date(dateString);
        var dateLocal = new Date(dateObj.getTime() - dateObj.getTimezoneOffset() * 60000);
        return dateLocal;
    },
    getDiff: function(isoDate) {

        var dateLocal = platformSpecific.getLocalDate(isoDate);
        var then = dateLocal.getTime();

        var d = new Date();
        var now = d.getTime();

        var diffMs = (now - then);
        //var diffSc = Math.round(diffMs/1000);
        var diffMns = Math.round(diffMs / 60000);
        var diffHrs = Math.round(diffMs / 3600000);

        var diff = null;

        //if(diffSc < 60)
        //diff = diffSc+ " secs ago";
        //else
        if (diffMns < 60)
            diff = diffMns + " mins ago";
        else if (diffHrs >= 1 && diffHrs < 24)
            diff = diffHrs + " hrs ago";
        else if (diffHrs >= 24 && diffHrs < 48)
            diff = 'yesterday';
        else diff = platformSpecific.formatDate(dateLocal);

        return diff;
    },
    displayAlert : function(message){
          if (isMobile.Android() && isMobile.getAndroidVersion() < 3.0)
              alert(message);
          else{
              try{
                  navigator.notification.alert(message, null, 'Alert','OK');
              }catch(e){console.log("Error in display Alert: "+e);}
          }
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