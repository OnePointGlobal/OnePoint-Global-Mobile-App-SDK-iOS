(function($) {

    $.widget("opg.geocode", {

        initSelector: "input[data-role=geocode]",

        // the constructor
        _create: function() {

            this.width = '100%';
            this.height = window.innerHeight / 3;

            var domElement = document.createElement("div");
            domHandle = $(domElement);

            this.changer = $("<input>", {
                value: "Click to Get Location",
                type: "button",
                "data-inline": "true"

            }).appendTo(domHandle).button().buttonMarkup({
                inline: true
            });;

            this.positionElm = $("<div>").css("padding", "10px 0").appendTo(domHandle);

            this.mapHolder = $("<div>").css({
                "height": this.height,
                "width": this.width
            }).appendTo(domHandle);

            var wrapper = this.element.parent('.ui-input-text');

            if (wrapper)
                wrapper.before(domHandle).hide();
            else
                this.element.before(domHandle).hide();

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
                    alert("Geolocation is not supported by this browser.");
                }
            } catch (err) {
                alert("Geolocation error : " + err);
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
                this.changer.attr('value', 'Click to Update Location').button("refresh");
            } catch (err) {
                alert('An error occured in displaying geolocation: ' + err);
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
            this.element.attr('value','');
            alert(msg);
        }
    });

    $.widget("opg.barcode", {

        initSelector: "input[data-role=barcode]",

        // the constructor
        _create: function() {

            var domElement = document.createElement("div");
            domHandle = $(domElement);

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
                wrapper.before(domHandle).hide();
            else
                this.element.before(domHandle).hide();

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
                    $.proxy(self._writeBarcode(result),this);
                }, function(error) {
                    $.proxy(self._writeBarcode(),this);
                });
            }catch(e){
                $.proxy(self._writeBarcode(),this);
            }

        },
        _writeBarcode: function(result) {

            var txt = '', barcode;

            if (!result || result.cancelled)
                barcode = window.prompt('Enter Barcode');                
            else if (!result.cancelled)
                barcode = result.text;

            txt = barcode? ("Barcode Entered is : "+barcode) : "No barcode entered";
            this.barcodeElm.html(txt);
            this.element.attr('value',barcode);
        }
    });

}(jQuery));