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
                                                  console.log("checllocale"+platformSpecific)
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
        navigator.camera.getPicture(function(fileName) {
            callback(fileName);
        }, function(error) {
            alert('Failed because: ' + error);
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
    },

    videocallback: function(mediaFiles, callback) {
        var i, len;
        for (i = 0, len = mediaFiles.length; i < len; i += 1) {
            this.mediaFile = mediaFiles[i].fullPath;
            if (callback != null) {
                callback(this.mediaFile);
            }

            return;
        }
    },

    getVideo: function(source, callback) {
        navigator.device.capture.captureVideo(function(mediaFiles) {
            videocallback(mediaFiles, callback);
        }, function(error) {
            alert('Failed because: ' + error);
        }, {
            quality: 100,
            sourceType: source
        });
    },

    getAudio: function(source, callback) {
        if (source == 0) {
            navigator.device.capture.captureAudio(function(mediaFiles) {
                videocallback(mediaFiles, callback);
            }, function(error) {
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