(function($) {

    $.widget("opg.geocode", {

        initSelector: "input[data-role=geocode]",
        width : '100%',
        height : window.innerHeight / 3,

        // the constructor
        _create: function() {

            var domElement = document.createElement("div");
            var domHandle = $(domElement);

            this.changer = $("<input>", {
                value: "Click to Get Location",
                type: "button",
                "data-inline": "true"

            }).appendTo(domHandle).button().buttonMarkup({
                inline: true
            });

            this.positionElm = $("<div>").css("padding", "10px 0").appendTo(domHandle);

            this.mapHolder = $("<div>").css({
                "height": this.height,
                "width": this.width
            }).appendTo(domHandle);

            var wrapper = this.element.parent('.ui-input-text');

            if (wrapper)
                wrapper.before(domHandle); //.hide();
            else
                this.element.before(domHandle); //.hide();

            // bind click events on the changer button to the random method
            this._on(this.changer, {
                // _on won't call random when widget is disabled
                click: "_getLocation"
            });

            var script = document.createElement('script');
            script.type = 'text/javascript';
            script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&' +
                'callback=initialize';
            script.setAttribute('async', true);
            document.body.appendChild(script);
        },

        // called when created, and later when changing options
        _refresh: function() {
            this.changer.click();
        },

        // events bound via _on are removed automatically
        // revert other modifications here
        _destroy: function() {
            // remove generated elements
            this.changer.remove();

        },
        _getLocation: function(positionElm, mapHolder) {
            var options = {
                enableHighAccuracy: false,
                timeout: 10000,
                maximumAge: 30000
            };

            var self = this;
            try {
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition($.proxy(this._showPosition, this), $.proxy(this._showError, this), options);
                } else {
                    $.alertOpg("Geolocation is not supported by this browser.");
                }
            } catch (err) {
                $.alertOpg("Geolocation error : " + err);
            }
        },
        _showPosition: function(position) {
            try {
                lat = position.coords.latitude;
                lon = position.coords.longitude;
                var txt = "Your location is : " + lat + ", " + lon;
                this.element.attr('value', lat + "," + lon);
                this.positionElm.html(txt);
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
                var mapholder = this.mapHolder[0];
                var map = new google.maps.Map(mapholder, myOptions);
                var marker = new google.maps.Marker({
                    position: latlon,
                    map: map,
                    title: "You are here!"
                });
                this.changer.val('Click to Update Location').button("refresh");
            } catch (err) {
                $.alertOpg('An error occured in displaying geolocation: ' + err);
            }
        },
        _showError: function(error) {
            var msg = "";
            switch (error.code) {
                case error.PERMISSION_DENIED:
                    msg = "User denied the request for Geolocation."
                    break;
                case error.POSITION_UNAVAILABLE:
                    msg = "Location information is unavailable.";
                    break;
                case error.TIMEOUT:
                    msg = "The request to get user location timed out.";
                    break;
                case error.UNKNOWN_ERROR:
                    msg = "An unknown error occurred.";
                    break;
            }
            this.element.attr('value', '');
            $.alertOpg(msg);
        }
    });

    $.widget("opg.barcode", {

        initSelector: "input[data-role=barcode]",

        // the constructor
        _create: function() {

            var domElement = document.createElement("div");
            var domHandle = $(domElement);

            this.changer = $("<input>", {
                value: "Click to Get Barcode",
                type: "button",
                "data-inline": "true"
            }).appendTo(domHandle).button().buttonMarkup({
                inline: true
            });;

            this.barcodeElm = $("<div>")
                .css("padding", "10px 0")
                .appendTo(domHandle);

            var wrapper = this.element.parent('.ui-input-text');

            if (wrapper)
                wrapper.before(domHandle); //.hide();
            else
                this.element.before(domHandle); //.hide();

            // bind click events on the changer button to the random method
            this._on(this.changer, {
                // _on won't call random when widget is disabled
                click: "_getBarcode"
            });

        },

        // called when created, and later when changing options
        _refresh: function() {
            this.changer.click();
        },

        // events bound via _on are removed automatically
        // revert other modifications here
        _destroy: function() {
            // remove generated elements
            this.changer.remove();

        },

        _getBarcode: function() {
            var self = this;
            try{
                cordova.plugins.barcodeScanner.scan(function(result) {
                    $.proxy(self._writeBarcode(result), this);
                }, function(error) {
                    $.proxy(self._writeBarcode(), this);
                });
            } catch (e) {
                $.proxy(self._writeBarcode(), this);
            }

        },
        _writeBarcode: function(result) {

            var txt = '',
                barcode;

            var func = function(barcode,self){
                txt = barcode ? ("Barcode Entered is : " + barcode) : "No barcode entered";
                self.barcodeElm.html(txt);
                self.element.attr('value', barcode);
            };

            if (!result || result.cancelled){
                var self = this;
                $.promptOpg("Please enter the barcode","","My Surveys",function(r){
                    func(r,self);
                });
            }
            else if (!result.cancelled)
                func(result.text,this);
        }
    });

    $.widget("opg.Ranking", {
        initSelector: "ul[data-role=Ranking]",
        _create: function() {
            this.element.find('li').addClass('ui-btn');
            this.element.sortable();
        },
        _destroy: function() {
            // remove generated elements
            this.element.find('li').removeClass('ui-btn');
            this.element.sortable('disable');
        }
    });

    $.widget("opg.star", {
        initSelector: "input[data-role=star]",
        _create: function() {

            var options = {
                max : 5
            };

            var domHandle = $('<div />');

            var stars = $('<ul />').addClass('opg-starHandle');
            var star = $('<div />').addClass('opg-star');

            for(var i = 0 ; i < options.max; i++){
                var temp = $('<li />').append(star.clone());
                stars.append(temp);
            }

            domHandle.append(stars);

            var elm = this.element;
            var wrapper = elm.parent('.ui-input-text');

            if (wrapper)
                wrapper.before(domHandle).hide();
            else
                this.element.before(domHandle).hide();

            // bind click events on the changer button to the random method
            this._on(stars.find('li'), {
                // _on won't call random when widget is disabled
                click: function(evt){
                    stars.find('li').removeClass('active');
                    var $elm = $(evt.target);
                    $elm = $elm.is('li')? $elm : $elm.parent();
                    $elm.prevAll().andSelf().addClass('active');
                    elm.val($elm.index()+1);
                },
                mouseenter: function(evt){
                    stars.find('li').removeClass('active');
                    var $elm = $(evt.target);
                    $elm = $elm.is('li')? $elm : $elm.parent();
                    $elm.prevAll().andSelf().addClass('active');
                },
                mouseleave: function(evt){
                    stars.find('li').removeClass('active');
                    var index = elm.val() - 1;
                    if(index > 0){
                        var $elm = stars.find('li').eq(index);
                        $elm.prevAll().andSelf().addClass('active');
                    }
                }
            });

            domHandle.on('change',function(){
                elm.val($(this).val());
            });
        },
        _destroy: function() {
            // remove generated elements
            domHandle.remove();
        }
    });

    $.widget("opg.rating", {
        initSelector: "input[data-role=rating]",
        _create: function() {
            var elm = this.element;
            elm.hide();
            var domHandle = $('<input value="0" min="1" max="10" step="1" data-mini="true"/>')
                            .addClass('ui-shadow-inset ui-body-inherit ui-corner-all ui-slider-input');

            var wrapper = elm.parent('.ui-input-text');

            var smileyHtml = '<div class="left-eye eye">&nbsp;</div>'
                           + '<div class="right-eye eye">&nbsp;</div>'
                           + '<div class="mouth up">&nbsp;</div>'
                           + '<div class="mouth down">&nbsp;</div>';

            var smiley_sad = $('<div />').addClass('opg-smiley sad').html(smileyHtml);
            var smiley_happy = $('<div />').addClass('opg-smiley happy').html(smileyHtml);

            if (wrapper)
                wrapper.before(domHandle).hide();
            else
                this.element.before(domHandle).hide();

            domHandle.slider({
                "highlight": true,
                create: function(event, ui) {
                    $(this).before(smiley_sad);
                    $(this).after(smiley_happy);
                    $(this).parent('.ui-slider').css({'padding-top':'25px','position':'relative'});
                }
            });

            domHandle.on('change',function(){
                elm.val($(this).val());
            });
        },
        _destroy: function() {
            // remove generated elements
            domHandle.remove();
        }
    });

    $.widget("opg.Picture", {

        initSelector: "input[data-role=Picture]",

        // the constructor
        _create: function() {

            this.fileURI = null;

            var domElement = document.createElement("div");
            var domHandle = $(domElement);

            var captureBtn = $("<input>", {
                value: "Capture Image",
                type: "button",
                "data-inline": "true"
            }).appendTo(domHandle).button().buttonMarkup({
                inline: true
            });

            var galleryBtn = $("<input>", {
                value: "Choose from Gallery",
                type: "button",
                "data-inline": "true"
            }).appendTo(domHandle).button().buttonMarkup({
                inline: true
            });

            this.uploadBtn = $("<input>", {
                value: "Upload Image",
                type: "button",
                "data-inline": "true"
            }).appendTo(domHandle).button().buttonMarkup({
                inline: true
            });

            this.imageBox = $("<div>")
                .css({
                    "padding" : "10px",
                    "min-height" : "50px",
                    "max-height" : window.innerHeight / 3,
                    "overflow" : "hidden"
                })
                .appendTo(domHandle);

            var wrapper = this.element.parent('.ui-input-text');

            if (wrapper)
                wrapper.before(domHandle); //.hide();
            else
                this.element.before(domHandle); //.hide();

            // bind click events on the button to the random method
            // _on won't call random when widget is disabled
            this._on(captureBtn, {
                click: function() {
                    this._getImage(1);
                }
            });

            this._on(galleryBtn, {
                click: function() {
                    this._getImage(0);
                }
            });

            this._on(this.uploadBtn, {
                click: "_uploadImage"
            });

        },

        // called when created, and later when changing options
        _refresh: function() {
            this._create();
        },

        // events bound via _on are removed automatically
        // revert other modifications here
        _destroy: function() {
            // remove generated elements
            this.domHandle.remove();
        },
        _getImage: function(source) {
            var self = this;
            try {
                navigator.camera.getPicture(function(fileName) {
                    $.proxy(self._writeImage(true,fileName), this);
                }, function(error) {
                    $.proxy(self._writeImage(false,error), this);
                }, {
                    quality: 100,
                    sourceType: source,
                    mediaType: 0,
                    EncodingType: 0,
                    saveToPhotoAlbum: true,
                    allowEdit: true,
                    targetWidth: 160,
                    correctOrientation: true,
                    destinationType: Camera.DestinationType.FILE_URI
                });
            }
            catch(e) {
                $.proxy(self._writeImage(false,e), this);
            }
        },
        _writeImage: function(result,value) {
            console.log("_writeImage : "+result+'--'+value);
             if(!result){
               // $.alertOpg('Get picture failed because: ' + value);
             }
            else if(result){
                this.imageBox.html('<img src="'+ value +'" style="width:100%;height:100%"/>');
                this.fileURI = value;
            }
        },
        _uploadImage: function(result,value) {

            if(!this.fileURI){
                $.alertOpg('No Image selected');
                return;
            }
            var self = this;
            this.uploadBtn.val('Uploading').button('refresh');

            try{
                var imageDataToSend = {
                    "mediaPath": this.fileURI,
                    "comments": "Uploading Image"
                };
                cordovaFunction.uploadImage(imageDataToSend, function(data) {
                    if(!data.Percent){
                        self.uploadBtn.val('Uploaded').button('refresh');
                        self.element.attr('value', data.MediaID);
                    }
                }, function(e) {
                    $.alertOpg('Image upload failed : '+e);
                });
            } catch (e) {
                self.uploadBtn.val('Upload').button('refresh');
                $.alertOpg('Image upload failed : '+e);
            }        
        }
    });

    $.widget("opg.Audio", {

        initSelector: "input[data-role=Audio]",
        file : null,
        uri :null,
        audio : null,

        // the constructor
        _create: function() {

            var domElement = document.createElement("div");
            var domHandle = $(domElement);

            var captureBtn = $("<input>", {
                value: "Record Audio",
                type: "button",
                "data-inline": "true"
            }).appendTo(domHandle).button().buttonMarkup({
                inline: true
            });

            var galleryBtn = $("<input>", {
                value: "Choose from Gallery",
                type: "button",
                "data-inline": "true"
            }).appendTo(domHandle).button().buttonMarkup({
                inline: true
            });

            this.playBtn = $("<input>", {
                value: "Play",
                type: "button",
                "data-inline": "true"
            }).appendTo(domHandle).button().buttonMarkup({
                inline: true
            });

            var stopBtn = $("<input>", {
                value: "Stop",
                type: "button",
                "data-inline": "true"
            }).appendTo(domHandle).button().buttonMarkup({
                inline: true
            });

            this.uploadBtn = $("<input>", {
                value: "Upload audio",
                type: "button",
                "data-inline": "true"
            }).appendTo(domHandle).button().buttonMarkup({
                inline: true
            });

            var wrapper = this.element.parent('.ui-input-text');

            if (wrapper)
                wrapper.before(domHandle); //.hide();
            else
                this.element.before(domHandle); //.hide();

            // bind click events on the button to the random method
            this._on(captureBtn, {
                // _on won't call random when widget is disabled
                click: "_recordAudio"
            });

            this._on(galleryBtn, {
                click: "_getAudio"
            });

            this._on(this.playBtn, {
                click: function(){
                    this._audioControl('play');
                }
            });

            this._on(stopBtn, {
                click: function(){
                    this._audioControl('stop');
                }
            });

            this._on(this.uploadBtn, {
                click: "_uploadAudio"
            });

        },

        // called when created, and later when changing options
        _refresh: function() {
            this._create();
        },

        // events bound via _on are removed automatically
        // revert other modifications here
        _destroy: function() {
            // remove generated elements
            this.domHandle.remove();

        },
        _recordAudio: function(source) {
            var self = this;
            try {
                navigator.device.capture.captureAudio(function(mediaFiles) {
                    var i, len;
                    for (i = 0, len = mediaFiles.length; i < len; i += 1) {
                        var file = mediaFiles[i].fullPath;
                        var uri = mediaFiles[i].uri;
                    }
                    $.proxy(self._storeFile(true,file,uri), this);
                }, function(error) {
                    $.proxy(self._storeFile(false,error), this);
                });
            }
            catch(e) {
                $.proxy(self._storeFile(false,e), this);
            }

        },
        _getAudio : function(){
            var self = this;
            try {
                navigator.camera.getPicture(function(fileName) {
                    $.proxy(self._storeFile(true,fileName), this);
                }, function(error) {
                    $.proxy(self._storeFile(false,error), this);
                }, {
                    sourceType: Camera.PictureSourceType.PHOTOLIBRARY,
                    mediaType: Camera.MediaType.ALLMEDIA
                });
            }
            catch(e) {
                $.proxy(self._storeFile(false,e), this);
            }
        },
        _storeFile: function(result,value,uri) {
            //console.log('_storeAudio '+ value+'--'+uri);
            if(!result)
                $.alertOpg('Capture Audio failed because: ' + value);
            else if(result){
                this.file = value;
                this.uri = uri;
            }
        },
        _uploadAudio: function() {
            if(!this.file){
                $.alertOpg('No Audio selected');
                return;
            }
            
            var self = this;
            this.uploadBtn.val('Uploading').button('refresh');

            try{
                var imageDataToSend = {
                    "mediaPath": this.file,
                    "comments": "Uploading Audio"
                };
                cordovaFunction.uploadImage(imageDataToSend, function(data) {
                    if(!data.Percent){
                        self.uploadBtn.val('Uploaded').button('refresh');
                        self.element.val(data.MediaID);
                    }
                }, function(e) {
                    $.alertOpg('Audio upload failed : '+e);
                });
            } catch (e) {
                $.alertOpg('Audio upload failed : '+e);
            }        
        },
        _audioControl : function(type){

            if(!this.file){
                $.alertOpg('No Audio selected');
                return;
            }
            var src = this.uri ? this.uri : this.file;
            try{
                if(this.audio && type == "stop")
                    this.audio.stop();
                else if(type == "play"){
                    this.audio = new Media(src,function(){},function(){});
                    this.audio.play();
                } 
            }catch(e){
                $.alertOpg('Audio play failed : '+e);
                return;
            }
        }
    });

    $.widget("opg.Video", {

        initSelector: "input[data-role=Video]",

        // the constructor
        _create: function() {

            this.fileURI = null;
            this.video = null;
            this.height = window.innerHeight / 3;

            var domElement = document.createElement("div");
            var domHandle = $(domElement);

            var captureBtn = $("<input>", {
                value: "Record Video",
                type: "button",
                "data-inline": "true"
            }).appendTo(domHandle).button().buttonMarkup({
                inline: true
            });

            var galleryBtn = $("<input>", {
                value: "Choose from Gallery",
                type: "button",
                "data-inline": "true"
            }).appendTo(domHandle).button().buttonMarkup({
                inline: true
            });

            this.uploadBtn = $("<input>", {
                value: "Upload video",
                type: "button",
                "data-inline": "true"
            }).appendTo(domHandle).button().buttonMarkup({
                inline: true
            });

            this.videoBox = $("<div />")
                .css({
                    "padding" : "10px",
                    "min-height" : "50px",
                    "max-height" : window.innerHeight / 3,
                    "overflow" : "hidden"
                })
                .appendTo(domHandle);

            var wrapper = this.element.parent('.ui-input-text');

            if (wrapper)
                wrapper.before(domHandle); //.hide();
            else
                this.element.before(domHandle); //.hide();

            // bind click events on the button to the random method
            this._on(captureBtn, {
                // _on won't call random when widget is disabled
                click: "_captureVideo"
            });

            this._on(galleryBtn, {
                click: "_getVideo"
            });

            this._on(this.uploadBtn, {
                click: "_uploadVideo"
            });

        },

        // called when created, and later when changing options
        _refresh: function() {
            this._create();
        },

        // events bound via _on are removed automatically
        // revert other modifications here
        _destroy: function() {
            // remove generated elements
            this.domHandle.remove();

        },
        _captureVideo: function(source) {
            var self = this;
            try {
                navigator.device.capture.captureVideo(function(mediaFiles) {
                    var i, len;
                    for (i = 0, len = mediaFiles.length; i < len; i += 1)
                        var mediaFile = mediaFiles[i].fullPath;
                    $.proxy(self._storeFile(true,mediaFile), this);
                }, function(error) {
                    $.proxy(self._storeFile(false,error), this);
                });
            }
            catch(e) {
                $.proxy(self._storeFile(false,e), this);
            }

        },
        _getVideo : function(){
            var self = this;
            try {
                navigator.camera.getPicture(function(fileName) {
                    $.proxy(self._storeFile(true,fileName), this);
                }, function(error) {
                    $.proxy(self._storeFile(false,error), this);
                }, {
                    sourceType: Camera.PictureSourceType.PHOTOLIBRARY,
                    mediaType: Camera.MediaType.VIDEO
                });
            }
            catch(e) {
                $.proxy(self._storeFile(false,e), this);
            }
        },
        _storeFile: function(result,value) {
           // console.log('_storeVideo :'+result+'--'+value);
            if(!result)
                $.alertOpg('Capture Video failed because: ' + value);
            else if(result){
                this.fileURI = value;
                var temp = '<video width="100%" height="'+this.height+'" controls>'
                        + '<source src="'+ value +'" type="video/mp4">'
                        + '<source src="'+ value +'" type="video/webm">'
                        + '<source src="'+ value +'" type="video/ogg">'
                        +  'Your browser does not support the video tag.'
                        + '</video>';

                this.videoBox.html(temp);
            }
        },
        _uploadVideo: function(result,value) {

            if(!this.fileURI){
                $.alertOpg('No Video selected');
                return;
            }
            var self = this;
            this.uploadBtn.val('Uploading').button('refresh');
            try{
                var imageDataToSend = {
                    "mediaPath": this.fileURI,
                    "comments": "Uploading Video"
                };
                cordovaFunction.uploadImage(imageDataToSend, function(data) {
                    if(!data.Percent){
                        self.uploadBtn.val('Uploaded').button('refresh');
                        self.element.val(data.MediaID);
                    }
                }, function(e) {
                    $.alertOpg('Video upload failed : '+e);
                });
            } catch (e) {
                $.alertOpg('Video upload failed : '+e);
                this.uploadBtn.val('Upload').button('refresh');
            }        
        }
    });

}(jQuery));