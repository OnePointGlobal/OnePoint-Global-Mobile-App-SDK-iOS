
/*
 * opgQuery - the OnePoint Query JavaScript file.
 * Copyright (c) 2014 OnePoint Global Ltd. All rights reseved.
 */
var opgQ = {
    mediaType: 0,
    video: 0,
    picture: 1,
    audio: 2,
    mediaField: "unknown",
    uploadButton: "unknown",
    captureButton: "unknown",
    galleryButton: "unknown",
    mediaURI: "unknown",
    mediaOptions: { "gallery": 0,
					"camera": 1 },
	self: this,

	getMediaFile: function(filename) {
		opgQ.mediaURI = filename;
		opgQ.mediaField.val(filename);
	},

    galleryClick: function(param) {
        try {
            var source = param.mediaOptions["gallery"];
            switch (param.mediaType) {
                case param.video:
                    platformSpecific.getVideo(source, param.getMediaFile);
                    break;
                case param.picture:
                    platformSpecific.getPicture(source, param.getMediaFile);
                    break;
                case param.audio:
                    platformSpecific.getAudio(source, param.getMediaFile, param.mediaURI);
                    break;
            }

            $(param.uploadButton).text("Upload");
            $(param.uploadButton).buttonMarkup({ icon: "cloud" });
        } catch (e) {
            alert(e);
        }
    },

    captureClick: function(param) {
        try {
            var source = param.mediaOptions["camera"];
            switch (param.mediaType) {
                case param.video:
                    platformSpecific.getVideo(source, param.getMediaFile);
                    break;
                case param.picture:
                    platformSpecific.getPicture(source, param.getMediaFile);
                    break;
                case param.audio:
                    platformSpecific.getAudio(source, param.getMediaFile, param.mediaURI);
                    break;
            }

            $(param.uploadButton).text("Upload");
            $(param.uploadButton).buttonMarkup({ icon: "cloud" });
        } catch (e) {
            alert(e);
        }
    },

    uploadClick: function(param) {
        try {
            if (param.mediaURI == "unknown") {
                alert("No file to upload!");
                return;
            }

            var comments = "Unknown Media from Survey";
            switch(param.mediaType) {
                case param.video:
                    comments = "Video Feedback";
                    break;
                case param.picture:
                    comments = "Picture Feedback";
                    break;
                case param.audio:
                    comments = "Audio Feedback";
                    break;
            }

            $(param.uploadButton).text("Uploading");
            var imageDataToSend = {
                "mediaPath": param.mediaURI,
                "comments": comments
            };
	        var page = $(':mobile-pagecontainer').pagecontainer('getActivePage');
            cordovaFunction.uploadImage(imageDataToSend, function(data) {
                param.mediaField.val(data.MediaID);
                $(param.uploadButton).text("Uploaded");
                $(param.uploadButton).buttonMarkup({ icon: "check" });
            }, function() {});
        } catch (e) {
            alert(e);
        }
    },

    initButtons: function(mType, uButton, cButton, gButton) {
        var page = $(':mobile-pagecontainer').pagecontainer('getActivePage')
		this.mediaType = mType;
		this.uploadButton = uButton;
		this.captureButton = cButton;
		this.galleryButton = gButton;
        this.mediaField = page.find("#_Q0");
        // this.mediaField.hide();
        if (this.galleryButton != "unknown") {
            page.find(this.galleryButton).on('click', function(param) { return function() { param.galleryClick(param); } }(this));
        }

        if (this.captureButton != "unknown") {
            page.find(this.captureButton).on('click', function(param) { return function() { param.captureClick(param); } }(this));
        }

        var temp = page.find(this.uploadButton);
        temp.on('click', function(param) { return function() { param.uploadClick(param); } }(this));

    },
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
                    platformSpecific.getVideo(source, param.mediaURI);
                    break;
                case this.picture:
                    platformSpecific.getPicture(source, param.mediaURI);
                    break;
                case this.audio:
                    platformSpecific.getAudio(source, param.mediaURI, param.mediaURI);
                    break;
            }

            $(param.uploadButton).text("Upload");
            $(param.uploadButton).buttonMarkup({ icon: "cloud" });
        } catch (e) {
            alert(e);
        }
    };

    this.CaptureClick = function(param) {
        try {
            var source = param.mediaOptions["camera"];
            switch (param.mediaType) {
                case this.video:
                    platformSpecific.getVideo(source, param.mediaURI);
                    break;
                case this.picture:
                    platformSpecific.getPicture(source, param.mediaURI);
                    break;
                case this.audio:
                    platformSpecific.getAudio(source, param.mediaURI);
                    break;
            }

            $(param.uploadButton).text("Upload");
            $(param.uploadButton).buttonMarkup({ icon: "cloud" });
        } catch (e) {
            alert(e);
        }
    };

    this.UploadClick = function(param) {
        try {
            if (param.mediaURI == "unknown") {
                alert("No file to upload!");
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
                $("#_Q0").val(data.MediaID);
                $(param.uploadButton).text("Uploaded");
                $(param.uploadButton).buttonMarkup({ icon: "check" });
            }, function() {});
        } catch (e) {
            alert(e);
        }
    };

    this.initButtons = function(param) {
        param.mediaField = document.getElementById('_Q0');
        if (param.galleryButton != "unknown") {
            $(param.galleryButton).on('click', function(param) { return function() { param.GalleryClick(param); } }(this));
        }

        if (param.captureButton != "unknown") {
            $(param.captureButton).on('click', function(param) { return function() { param.CaptureClick(param); } }(this));
        }

        $(param.uploadButton).on('click', function(param) { return function() { param.UploadClick(param); } }(this));
    };


    var init = function() {
        $(document).on('pagechange', self.initButtons(self));
    }();
};

var platformSpecific = {
    checkConnection: function() {
        try {
            if (!navigator.network.connection)
                alert("Network is not supported by this mobile.");
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
        	callback("unknown");
            alert('Failed because: ' + error);
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
            navigator.camera.getPicture(function(filename) {
                callback(filename);
            }, function(error) {
	        	callback("unknown");
                alert('Failed because: ' + error);
            }, {
                quality: 100,
                sourceType: source,
                MediaType: 0,
                EncodingType: 0,
                saveToPhotoAlbum: source != 0,
                allowEdit: true,
                targetWidth: 160,
                correctOrientation: true
            });
        }
        catch(e) {
        	callback("unknown");
            alert('Failed because: ' + e);
        }
    },

    getVideo: function(source, callback) {
        try {
			if (source == 0) {
				navigator.camera.getPicture(function(filename) {
					callback(filename);
				}, function(error) {
					callback("unknown");
					alert('Failed because: ' + error);
				}, {
					quality: 100,
					EncodingType: 0,
					saveToPhotoAlbum: false,
					allowEdit: true,
					targetWidth: 160,
					correctOrientation: true,
					sourceType: navigator.camera.PictureSourceType.PHOTOLIBRARY,
    				mediaType: navigator.camera.MediaType.VIDEO
				});
			}
			else {
				navigator.device.capture.captureVideo(function(mediaFiles) {
					var i, len;
					for (i = 0, len = mediaFiles.length; i < len; i += 1) {
						var mediaFile = mediaFiles[i].fullPath;
						if (callback != null) {
							callback(mediaFile);
						}
					}
				}, function(error) {
					callback("unknown");
					alert('Failed because: ' + error);
				}, {
					quality: 100,
					sourceType: source
				});
			}
        }
        catch(e) {
        	callback("unknown");
            alert("Error:" + e);
        }
    },

    getAudio: function(source, callback, mediaFile) {
        if (source == 1) {
            navigator.device.capture.captureAudio(function(mediaFiles) {
                var i, len;
                for (i = 0, len = mediaFiles.length; i < len; i += 1) {
                    var file = mediaFiles[i].fullPath;
                    if (callback != null) {
			        	callback(file);
                    }
                    return;
                }
            }, function(error) {
	        	callback("unknown");
                alert('Failed because: ' + error);
            });
        } else {
            var temp = new Media(mediaFile);
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
    }

};