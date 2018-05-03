(function(e) {
    e.widget("opg.geocode", {
        initSelector: "input[data-role=geocode]",
        width: "100%",
        height: window.innerHeight / 3,
        _create: function() {
            var t = document.createElement("div");
            var n = e(t);
            this.changer = e("<input>", {
                value: "Click to get location",
                type: "button",
                "data-inline": "true"
            }).addClass("getLocation").appendTo(n).button().buttonMarkup({
                inline: true
            });
            this.changer.parent().addClass("geolocator");
            this.positionElm = e("<div>").css("padding", "0").appendTo(n);
            this.mapHolder = e("<div id='geoLocation'></div>").css({
                height: this.height,
                width: this.width
            }).appendTo(n).hide();
            var r = this.element.parent(".ui-input-text");
            if (r) r.before(n).hide();
            else this.element.before(n).hide();
            this._on(this.changer, {
                click: "_getLocation"
            });
            var i = document.createElement("script");
            i.type = "text/javascript";
            i.src = "https://maps.googleapis.com/maps/api/js?v=3.exp&" + "callback=initialize";
            i.setAttribute("async", true);
			document.body.appendChild(i);
			var co_ords = this.element[0].value.split(",");
			var thisElem  = this;
			if(this.element[0].value){
				$("#geoLocation").show();
				var n = "Your location is : " + co_ords[0] + ", " + co_ords[1];
                this.positionElm.html(n);
				setTimeout(function(){
					var myLatlng = new google.maps.LatLng(co_ords[0], co_ords[1]);
					var mapOptions = {
						zoom: 15,
						center: myLatlng,
						mapTypeId: google.maps.MapTypeId.ROADMAP
				};
					var map = new google.maps.Map(document.getElementById("geoLocation"),
					mapOptions);
					var i = thisElem.mapHolder[0];
					var s = new google.maps.Map(i, mapOptions);
					var o = new google.maps.Marker({
								position: myLatlng,
								map: s,
								title: "You are here!"
							});					
				},1000);
				   
			}
        },
        _refresh: function() {
            this.changer.click()
        },
        _destroy: function() {
            this.changer.remove()
        },
        _getLocation: function(t, n) {
            $("#geoLocation").show();
            var r = {
                enableHighAccuracy: false,
                timeout: 10000000,
                maximumAge: 30000000
            };
            var i = this;
            try {

                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(e.proxy(this._showPosition, this), e.proxy(this._showError, this), r)
                } else {
                    e.alertOpg("Geolocation is not supported by this browser.","My Surveys")
                }
                this.changer.parent().addClass("updatedgeoLocator");
            } catch (s) {
                e.alertOpg("Geolocation error.","My Surveys")
            }
        },
        _showPosition: function(t) {

            try {
                lat = t.coords.latitude;
                lon = t.coords.longitude;
                var n = "Your location is : " + lat + ", " + lon;
                this.element.attr("value", lat + "," + lon);
                this.positionElm.html(n);
                latlon = new google.maps.LatLng(lat, lon);
                var r = {
                    center: latlon,
                    zoom: 14,
                    mapTypeId: google.maps.MapTypeId.ROADMAP,
                    mapTypeControl: false,
                    navigationControlOptions: {
                        style: google.maps.NavigationControlStyle.SMALL
                    }
                };
                var i = this.mapHolder[0];
                var s = new google.maps.Map(i, r);
                var o = new google.maps.Marker({
                    position: latlon,
                    map: s,
                    title: "You are here!"
                });
                this.changer.val("Click to update location").button("refresh")
            } catch (u) {
                e.alertOpg("An error occured in displaying geolocation.","My Surveys")
            }
        },
        _showError: function(t) {
            var n = "";
            switch (t.code) {
                case t.PERMISSION_DENIED:
                    n = "User denied the request for Geolocation.";
                    break;
                case t.POSITION_UNAVAILABLE:
                    n = "We cannot collect your location at the moment in time. Please try again later";
                    break;
                case t.TIMEOUT:
                    n = "The request to get user location timed out.";
                    break;
                case t.UNKNOWN_ERROR:
                    n = "An unknown error occurred.";
                    break;
               default : n = "Please switch on your location services.";
                        break;
             
            }
            this.element.attr("value", "");
            e.alertOpg(n,"My Surveys")
        }
    });
    e.widget("opg.barcode", {
        initSelector: "input[data-role=barcode]",
        _create: function() {
	        var t = document.createElement("div");
            var n = e(t);
            this.changer = e("<input>", {
                value: "Click to Get Barcode",
                type: "button",
                "data-inline": "true"
            }).appendTo(n).button().buttonMarkup({
                inline: true
            });
            this.barcodeElm = e("<div>").css("padding", "10px 0").appendTo(n);
            var r = this.element.parent(".ui-input-text");
            if (r) r.before(n).hide();
            else this.element.before(n).hide();
			if(this.element[0].value != ""){
				var n = "Barcode Entered is : " + this.element[0].value;
				this.barcodeElm.html(n);	
			}
            this._on(this.changer, {
                click: "_getBarcode"
            });
        },
        _refresh: function() {
            this.changer.click();
        },
        _destroy: function() {
            this.changer.remove();
        },
        _getBarcode: function() {
            var t = this;
            try {
                cordova.plugins.barcodeScanner.scan(function(n) {
	                  e.proxy(t._writeBarcode(n), this);
					  if(tMobile.Android()){
					      $(".ui-popup-container").css({"left":"55px","top":"183px"});
					  }
	                 
                }, function(n) {
			          e.proxy(t._writeBarcode(), this);
                });
            } catch (n) {
	              e.proxy(t._writeBarcode(), this);
            }
        },
        _writeBarcode: function(t) {
            var n = "",
                r;
            var i = function(e, t) {
                n = e ? "Barcode Entered is : " + e : "No barcode entered";
                t.barcodeElm.html(n);
                var val = e?e:"";
                t.element.attr("value", val);
            };
            if (!t || t.cancelled) {
                var s = this;

                e.promptOpg("Please enter the barcode", "", "My Surveys", function(e) {
                    i(e, s)
                });
                         $(".ui-page").css("margin-top","70px");
                $(".ui-page.ui-page-theme-a.ui-page-active").css("position","");
            } else if (!t.cancelled) i(t.text, this)
        }
    });
    e.widget("opg.Ranking", {
        initSelector: "ul[data-role=rank]",
        _create: function() {
            var t = this.element;
            t.css({
                margin: "0",
                padding: "0"
            });
            t.find("li").each(function(t, n) {
                e(n).addClass("ui-btn").css("text-align", "center");
                e(n).find(".ui-input-text, input").hide();
                e(n).find("input").val(t + 1).attr("value", t + 1)
            });
            t.sortable({
                axis: "y",
                update: function(n, r) {
                    t.find("li").each(function(t, n) {
                        e(n).find("input").val(t + 1).attr("value", t + 1)
                    })
                }
            })
        },
        _destroy: function() {
            this.element.sortable("disable")
        }
    });
    e.widget("opg.star", {
        initSelector: "input[data-role=star]",
        _create: function() {
            var t = this.element.attr("max");
            if (!t) t = 5;
            var n = e("<div />");
            var r = e("<ul />").addClass("opg-starHandle").css({
                padding: "0",
                margin: "0"
            });
            var i = e("<div />").addClass("opg-star");

            for (var s = 0; s < t; s++) {
                var o = e("<li />").append(i.clone());
                r.append(o)
            }
            var mintext = this.element.attr("low");
            var maxtext = this.element.attr("high");
            var minDiv = e("<div />").css({
                position: "absolute",
                "max-width": "30%",
                overflow: "hidden",
                "text-overflow": "ellipsis",
                "white-space": "nowrap",
                "display":"none"
            }).html(mintext).addClass("star_min_label");
            var maxDiv = e("<div />").css({
                position: "absolute",
               "max-width": "30%",
                overflow: "hidden",
                "text-overflow": "ellipsis",
                "white-space": "nowrap",
                "display":"none"
            }).html(maxtext).addClass("star_max_label");
            n.append(r);
            n.append(minDiv);
            n.append(maxDiv);
            n.append(r);
            var u = this.element;
            var a = u.parent(".ui-input-text");
            if (a) a.before(n).hide();
            else this.element.before(n).hide();
            var selected = this.element.val();
            for (var i= 0 ; (i < selected && selected != 0); i++) {
              r.find("li:eq("+i+")").addClass("active");
            }
			 if(tMobile.anyMobile() != null || navigator.userAgent.match(/X11; Linux x86_64/i)){
				  this._on(r.find("li"), {
						touchstart:function(t) {
							var n = e(t.target);
                            n = n.is("li") ? n : n.parent();
                            if(r.find("li:eq("+n.index()+")").hasClass("active") == false){
                                 r.find("li:eq("+n.index()+")").addClass("active");
                                 n.prevAll().andSelf().addClass("active");
                                 u.val(n.index() + 1).attr("value", n.index() + 1);
                             }else{

                                if((n.index()+1) < u.val()){
                                        r.find("li:gt("+n.index()+")").removeClass("active");
                                        u.val(n.index()+1).attr("value", n.index()+1);
                                 }else{
                                    r.find("li:eq("+n.index()+")").removeClass("active");
                                       u.val(n.index()).attr("value", n.index());
                                 }

                             }
						},
					 })
			}else{
				 this._on(r.find("li"), {
				 click: function(t) {
						//console.log("click");
						var n = e(t.target);
						n = n.is("li") ? n : n.parent();
						if(r.find("li:eq("+n.index()+")").hasClass("active") == false){
							 r.find("li:eq("+n.index()+")").addClass("active");
							 n.prevAll().andSelf().addClass("active");
							 u.val(n.index() + 1).attr("value", n.index() + 1);
						 }else{
							 r.find("li:eq("+n.index()+")").removeClass("active");
							 if((n.index()+1) < u.val()){
									r.find("li:gt("+n.index()+")").removeClass("active");
									u.val(n.index()+1).attr("value", n.index()+1);
							 }else{
								   u.val(n.index()).attr("value", n.index());
							 }

						 }
					},
					mouseover: function(t) {
						r.find("li").removeClass("hover");
						var n = e(t.target);
						n = n.is("li") ? n : n.parent();
						if((n.index()+1) < u.val()){
								r.find("li:gt("+n.index()+")").removeClass("active").removeClass("hover");
						 }
						n.prevAll().andSelf().addClass("hover");
					},
				   mouseout: function(ev) {
						r.find("li").removeClass("hover");
						var t = u.val() ;
						var n = e(ev.target);
						if (t > 0) {
							var n = r.find("li").eq((t-1));
							n.prevAll().andSelf().addClass("active")
						}
					},

				})
			}
          },
        _destroy: function() {
            domHandle.remove()
        }
    });
    e.widget("opg.rating", $.mobile.slider, {
        initSelector: "input[data-type = range][low][high]",
        options: {
            vertical: false,
        },

        _create: function() {
            if(typeof this.element.attr("data-vertical") == "undefined"){
                    this.options.vertical = false;
            }else{
                 this.options.vertical = true;
            }
            var lowLabel = this.element.attr("low");
            var highLabel = this.element.attr("high");
            if (this.options.vertical) {
                // TODO: Each of these should have comments explain what they're for
                var self = this,
                    control = this.element,
                    trackTheme = this.options.trackTheme || $.mobile.getAttribute( control[ 0 ], "theme" ),
                    trackThemeClass = trackTheme ? " ui-bar-" + trackTheme : " ui-bar-inherit",
                    cornerClass = ( this.options.corners || control.jqmData( "corners" ) ) ? " ui-corner-all" : "",
                    miniClass = ( this.options.mini || control.jqmData( "mini" ) ) ? " ui-mini" : "",
                    cType = control[ 0 ].nodeName.toLowerCase(),
                    isToggleSwitch = ( cType === "select" ),
                    isRangeslider = control.parent().is( ":jqmData(role='rangeslider')" ),
                    selectClass = ( isToggleSwitch ) ? "ui-slider-switch" : "",
                    controlID = control.attr( "id" ),
                    $label = $( "[for='" + controlID + "']" ),
                    labelID = $label.attr( "id" ) || controlID + "-label",
                    trueMin = !isToggleSwitch ? parseFloat( control.attr( "min" ) ) : 0,
                    trueMax =  !isToggleSwitch ? parseFloat( control.attr( "max" ) ) : control.find( "option" ).length-1,
                    min = trueMax * -1,
                    max = trueMin * -1,
                    step = window.parseFloat( control.attr( "step" ) || 1 ),
                    domHandle = document.createElement( "a" ),
                    handle = $( domHandle ),
                    domSlider = document.createElement( "div" ),
                    slider = $( domSlider ),
                    valuebg = this.options.highlight && !isToggleSwitch ? (function() {
                        var bg = document.createElement( "div" );
                        bg.className = "ui-slider-bg " + $.mobile.activeBtnClass;
                        return $( bg ).prependTo( slider );
                    })() : false,
                    options,
                    wrapper,
                    j, length,
                    i, optionsCount, origTabIndex,
                    side, activeClass, sliderImg;

                $label.attr( "id", labelID );
                this.isToggleSwitch = isToggleSwitch;

               domHandle.setAttribute( "href", "#" );
                domSlider.setAttribute( "role", "application" );
                domSlider.setAttribute( "id", "verticalBar" );
                domSlider.className = [ this.isToggleSwitch ? "ui-slider ui-slider-track ui-shadow-inset " : "ui-slider-track ui-shadow-inset ", selectClass, trackThemeClass, cornerClass, miniClass ].join( "" );
                domHandle.className = "ui-slider-handle";
                domSlider.appendChild( domHandle );

                handle.attr({
                    "role": "slider",
                    "aria-valuemin": min,
                    "aria-valuemax": max,
                    "aria-valuenow": this._value(),
                    "aria-valuetext": this._value(),
                    "title": this._value(),
                    "aria-labelledby": labelID
                });

                $.extend( this, {
                    slider: slider,
                    handle: handle,
                    control: control,
                    type: cType,
                    step: step,
                    max: max,
                    min: min,
                    valuebg: valuebg,
                    isRangeslider: isRangeslider,
                    dragging: false,
                    beforeStart: null,
                    userModified: false,
                    mouseMoved: false
                });

                if ( isToggleSwitch ) {
                    // TODO: restore original tabindex (if any) in a destroy method
                    origTabIndex = control.attr( "tabindex" );
                    if ( origTabIndex ) {
                        handle.attr( "tabindex", origTabIndex );
                    }
                    control.attr( "tabindex", "-1" ).focus(function() {
                        $( this ).blur();
                        handle.focus();
                    });

                    wrapper = document.createElement( "div" );
                    wrapper.className = "ui-slider-inneroffset";

                    for ( j = 0, length = domSlider.childNodes.length; j < length; j++ ) {
                        wrapper.appendChild( domSlider.childNodes[j] );
                    }

                    domSlider.appendChild( wrapper );


                    // slider.wrapInner( "<div class='ui-slider-inneroffset'></div>" );

                    // make the handle move with a smooth transition
                    handle.addClass( "ui-slider-handle-snapping" );

                    options = control.find( "option" );

                    for ( i = 0, optionsCount = options.length; i < optionsCount; i++ ) {
                        side = !i ? "b" : "a";
                        activeClass = !i ? "" : " " + $.mobile.activeBtnClass;
                        sliderImg = document.createElement( "span" );

                        sliderImg.className = [ "ui-slider-label ui-slider-label-", side, activeClass ].join( "" );
                        sliderImg.setAttribute( "role", "img" );
                        sliderImg.appendChild( document.createTextNode( options[i].innerHTML ) );
                        $( sliderImg ).prependTo( slider );
                    }

                    self._labels = $( ".ui-slider-label", slider );

                }

                // monitor the input for updated values
                control.addClass( isToggleSwitch ? "ui-slider-switch" : "ui-slider-input" );

                this._on( control, {
                    "change": "_controlChange",
                    "keyup": "_controlKeyup",
                    "blur": "_controlBlur",
                    "vmouseup": "_controlVMouseUp"
                });

                slider.bind( "vmousedown", $.proxy( this._sliderVMouseDown, this ) )
                    .bind( "vclick", false );

                // We have to instantiate a new function object for the unbind to work properly
                // since the method itself is defined in the prototype (causing it to unbind everything)
                this._on( document, { "vmousemove": "_preventDocumentDrag" });
                this._on( slider.add( document ), { "vmouseup": "_sliderVMouseUp" });

                slider.insertAfter( control );

                // wrap in a div for styling purposes
                if ( !isToggleSwitch && !isRangeslider ) {
                    wrapper = this.options.mini ? "<div class='ui-slider ui-mini'>" : "<div class='ui-slider'>";

                    control.add( slider ).wrapAll( wrapper );
                }

                // bind the handle event callbacks and set the context to the widget instance
                this._on( this.handle, {
                    "vmousedown": "_handleVMouseDown",
                    "keydown": "_handleKeydown",
                    "keyup": "_handleKeyup"
                });

                this.handle.bind( "vclick", false );

                this._handleFormReset();

                this.refresh( undefined, undefined, true );

                this.slider.attr("style", "width:10px !important; margin: 0 0 0 70px !important;;")
                $(this.control).detach()
                $(this.slider).parent().append(this.control)
              //  $(this.slider).parent().css("margin-bottom", (this.options.height + 30) + "px")
                var elm = this.element;
                var labeltype = elm.attr('slider-type');
                var low = elm.attr('min');
                var high = elm.attr('max');
                var midValue = (low+high)/2;
                var height = '30px';
                if (labeltype == "Images") {
                    low = '<img src="' + low + '" height="30px" width="30px"/>';
                    high = '<img src="' + high + '" height="30px" width="30px"/>';
                } else {
                    var lowtemp = low.split('_');
                    low = "";
                    for (var i = 0; i < lowtemp.length; i++) {
                        low += lowtemp[i];
                        if (i < lowtemp.length - 1)
                            low += '<br>';
                    }
                    hightemp = high.split('_');
                    high = "";
                    for (var i = 0; i < hightemp.length; i++) {
                        high += hightemp[i];
                        if (i < hightemp.length - 1)
                            high += '<br>';
                    }
                    height = lowtemp.length > hightemp.length ? lowtemp.length * 20 : hightemp.length * 20;
                    height += 'px';
                }

                  var midValueHeight = Math.floor($(".ui-slider-track").height()/2);
                 var lowLabelDiv = $('<div />')
                    .css({
                        'position': 'absolute',
                        'left': '0',
                        'max-width': '100%',
                        'overflow': 'hidden',
                        'white-space': 'pre-line',
                        'word-break':'word-break',
                        'top':'-25px'
                    })
                    .html(lowLabel);

                var highLabelDiv = $('<div />')
                    .css({
                        'position': 'absolute',
                        'left': '0',
                        'max-width': '100%',
                        'overflow': 'hidden',
                        'white-space': 'pre-line',
                        'word-break':'word-break',
                        'white-space': 'pre-line',
                        'top':'100%'
                    })
                    .html(highLabel);
                slider.parent().find("input[type='number']").css({"position":"absolute","top":midValueHeight});
                var Count = 10;
                var NoOfSlides = ($(domSlider).height()  / Count);
                var percentCount = ($(domSlider).height() / NoOfSlides);
                var pips=""
                for(i=Count,j=0;i>=0;j++,i--){
                    if(i==Count){
                        pips +=  "<div class='number' id='number90' style=top:"+(j*NoOfSlides-5)+"px>"+(i*percentCount)+"</div>";
                    }else   if(i===0){
                         pips +=  "<div class='number' id='number90' style=top:"+(j*NoOfSlides-5)+"px>"+(i*percentCount)+"</div>";
                    }else{
                        pips +=  "<div class='tick' id='percent' style=top:"+(j*NoOfSlides)+"px></div><div class='number' id='number90' style=top:"+(j*NoOfSlides-5)+"px>"+(i*percentCount)+"</div>";
                    }


                }
                 $(domSlider).parent().append(pips);
                $(window).bind("resize",function(){
                        var NoOfSlides = ($(domSlider).height()  / Count);
                        var percentCount = ($(domSlider).height() / NoOfSlides);
                        var pips=""
                        $(".tick").remove();
                        $(".number").remove();
                        var midValueHeight = Math.floor($(".ui-slider-track").height()/2);
                        slider.parent().find("input[type='number']").css({"position":"absolute","top":midValueHeight});
                        for(i=Count,j=0;i>=0;j++,i--){
                           if(i==Count){
                                pips +=  "<div class='number' id='number90' style=top:"+(j*NoOfSlides-5)+"px>"+(i*percentCount)+"</div>";
                            }else   if(i===0){
                                 pips +=  "<div class='number' id='number90' style=top:"+(j*NoOfSlides-5)+"px>"+(i*percentCount)+"</div>";
                            }else{
                                pips +=  "<div class='tick' id='percent' style=top:"+(j*NoOfSlides)+"px></div><div class='number' id='number90' style=top:"+(j*NoOfSlides-5)+"px>"+(i*percentCount)+"</div>";
                            }
                         }
                        $(domSlider).parent().append(pips);
                })

                $(lowLabelDiv).insertBefore(domSlider);
                $(highLabelDiv).insertAfter(domSlider);
            } else {
                var elm = this.element;
                var labeltype = elm.attr('slider-type');
                var low = elm.attr('low');
                var high = elm.attr('high');
                var height = '30px';

                if (labeltype == "Images") {
                    low = '<img src="' + low + '" height="30px" width="30px"/>';
                    high = '<img src="' + high + '" height="30px" width="30px"/>';
                } else {
                    var lowtemp = low.split('_');
                    low = "";
                    for (var i = 0; i < lowtemp.length; i++) {
                        low += lowtemp[i];
                        if (i < lowtemp.length - 1)
                            low += '<br>';
                    }
                    hightemp = high.split('_');
                    high = "";
                    for (var i = 0; i < hightemp.length; i++) {
                        high += hightemp[i];
                        if (i < hightemp.length - 1)
                            high += '<br>';
                    }
                    height = lowtemp.length > hightemp.length ? lowtemp.length * 20 : hightemp.length * 20;
                    height += 'px';
                }

                var lowDiv = $('<div />')
                    .css({
                        'position': 'absolute',
                        'left': '68px',
                        'top': '0',
                        'max-width': '100%',
                        'overflow': 'hidden',
                        'white-space': 'nowrap',
                        'word-break':'break-word'
                    }).addClass("slider_low_count").html(low);

                var highDiv = $('<div />')
                    .css({
                        'position': 'absolute',
                        'right': '15px',
                        'top': '0',
                        'max-width': '100%',
                        'overflow': 'hidden',
                        'text-overflow': 'ellipsis',
                        'white-space': 'nowrap',
                         'word-break':'break-word'
                    }).addClass("slider_high_count").html(high);
                elm.before(lowDiv);
                elm.after(highDiv);
                elm.parent('.ui-slider').css({
                    'padding-top': height,
                    'position': 'relative'
                });
            }
        },

        _value: function() {
            if (!this.options.vertical) {
                this._super()
            } else {
                return  this.isToggleSwitch ? this.element[0].selectedIndex : parseFloat( this.element.val() * -1 );
            }
        },

        refresh: function(val, isfromControl, preventInputUpdate) {
            if (!this.options.vertical) {
                this._super(val, isfromControl, preventInputUpdate)
            } else {
                var self = this,
                    parentTheme = $.mobile.getAttribute( this.element[ 0 ], "theme" ),
                    theme = this.options.theme || parentTheme,
                    themeClass =  theme ? " ui-btn-" + theme : "",
                    trackTheme = this.options.trackTheme || parentTheme,
                    trackThemeClass = trackTheme ? " ui-bar-" + trackTheme : " ui-bar-inherit",
                    cornerClass = this.options.corners ? " ui-corner-all" : "",
                    miniClass = this.options.mini ? " ui-mini" : "",
                    top, height, data, tol,
                    pyStep, percent,
                    control, isInput, optionElements, min, max, step,
                    newval, valModStep, alignValue, percentPerStep,
                    handlePercent, aPercent, bPercent,
                    valueChanged;

                self.slider[0].className = [ this.isToggleSwitch ? "ui-slider ui-slider-switch ui-slider-track ui-shadow-inset" : "ui-slider-track ui-shadow-inset", trackThemeClass, cornerClass, miniClass ].join( "" );
                if ( this.options.disabled || this.element.prop( "disabled" ) ) {
                    this.disable();
                }

                // set the stored value for comparison later
                this.value = this._value();
                if ( this.options.highlight && !this.isToggleSwitch && this.slider.find( ".ui-slider-bg" ).length === 0 ) {
                    this.valuebg = (function() {
                        var bg = document.createElement( "div" );
                        bg.className = "ui-slider-bg " + $.mobile.activeBtnClass;
                        return $( bg ).prependTo( self.slider );
                    })();
                }
                this.handle.addClass( "ui-btn" + themeClass + " ui-shadow" );

                control = this.element;
                isInput = !this.isToggleSwitch;
                optionElements = isInput ? [] : control.find( "option" );

         // invert min and max
                trueMin =  isInput ? parseFloat( control.attr( "min" ) ) : 0
                trueMax = isInput ? parseFloat( control.attr( "max" ) ) : optionElements.length - 1;
                min = trueMax * -1
                max = trueMin * -1

                /* original
                min =  isInput ? parseFloat( control.attr( "min" ) ) : 0
                max = isInput ? parseFloat( control.attr( "max" ) ) : optionElements.length - 1;*/


                step = ( isInput && parseFloat( control.attr( "step" ) ) > 0 ) ? parseFloat( control.attr( "step" ) ) : 1;

                if ( typeof val === "object" ) {
                    data = val;
                    // a slight tolerance helped get to the ends of the slider
                    tol = 8;

                    top = this.slider.offset().top;
                    height = this.slider.height();
                    pyStep = height/((max-min)/step);
                    if ( !this.dragging ||
                            data.pageY < top - tol ||
                            data.pageY > top + height + tol ) {
                        return;
                    }
                    if ( pyStep > 1 ) {
                        percent = ( ( data.pageY - top ) / height ) * 100;
                    } else {
                        percent = Math.round( ( ( data.pageY - top ) / height ) * 100 );
                    }
                } else {
                    if ( val == null ) {
                        val = isInput ? parseFloat( control.val() * -1 || 0 ) : control[0].selectedIndex;
                    }
                    percent = ( parseFloat( val ) - min ) / ( max - min ) * 100;
                }

                if ( isNaN( percent ) ) {
                    return;
                }

                newval = ( percent / 100 ) * ( max - min ) + min;

                //from jQuery UI slider, the following source will round to the nearest step
                valModStep = ( newval - min ) % step;
                alignValue = newval - valModStep;

                if ( Math.abs( valModStep ) * 2 >= step ) {
                    alignValue += ( valModStep > 0 ) ? step : ( -step );
                }

                percentPerStep = 100/((max-min)/step);
                // Since JavaScript has problems with large floats, round
                // the final value to 5 digits after the decimal point (see jQueryUI: #4124)
                newval = parseFloat( alignValue.toFixed(5) );

                if ( typeof pyStep === "undefined" ) {
                    pyStep = height / ( (max-min) / step );
                }
                if ( pyStep > 1 && isInput ) {
                    percent = ( newval - min ) * percentPerStep * ( 1 / step );
                }
                if ( percent < 0 ) {
                    percent = 0;
                }

                if ( percent > 100 ) {
                    percent = 100;
                }

                if ( newval < min ) {
                    newval = min;
                }

                if ( newval > max ) {
                    newval = max;
                }

                newval *= -1;

                this.handle.css( "top", percent + "%" );
                this.handle.css("margin-left", "-4px");

                this.handle[0].setAttribute( "aria-valuenow", isInput ? newval : optionElements.eq( newval ).attr( "value" ) );

                this.handle[0].setAttribute( "aria-valuetext", isInput ? newval : optionElements.eq( newval ).getEncodedText() );

                this.handle[0].setAttribute( "title", isInput ? newval : optionElements.eq( newval ).getEncodedText() );

                if ( this.valuebg ) {
                    this.valuebg.css( "height", percent + "%" );
                }

                // drag the label heights
                if ( this._labels ) {
                    handlePercent = this.handle.height() / this.slider.height() * 100;
                    aPercent = percent && handlePercent + ( 100 - handlePercent ) * percent / 100;
                    bPercent = percent === 100 ? 0 : Math.min( handlePercent + 100 - aPercent, 100 );

                    this._labels.each(function() {
                        var ab = $( this ).hasClass( "ui-slider-label-a" );
                        $( this ).height( ( ab ? aPercent : bPercent  ) + "%" );
                    });
                }

                if ( !preventInputUpdate ) {
                    valueChanged = false;

                    // update control"s value
                    if ( isInput ) {
                        valueChanged = control.val() !== newval;
                        control.val( newval );
                    } else {
                        valueChanged = control[ 0 ].selectedIndex !== newval;
                        control[ 0 ].selectedIndex = newval;
                    }
                    if ( this._trigger( "beforechange", val ) === false) {
                            return false;
                    }
                    if ( !isfromControl && valueChanged ) {
                        control.trigger( "change" );
                    }
                }
            }
        }
    }),
    e.widget("opg.Picture", {
        initSelector: "input[data-role=Picture]",
        _create: function() {
            this.fileURI = null;
            var t = this.element.attr("control-attr").split(";");
            this.controls = {
                capture: t.indexOf("AccessNew") == -1 ? false : true,
                gallery: t.indexOf("AccessGallery") == -1 ? false : true,
                preview: t.indexOf("AllowPlayback") == -1 ? false : true,
                upload: t.indexOf("AllowUpload") == -1 ? false : true
            };
            var n = document.createElement("div");
			n.className = "imagecontainer";
            var r = e(n);
            var i = e('<div class="ui-block-a">');
            var s = e('<div class="ui-block-b">');
            if (this.controls.capture) var o = e("<input>", {
                value: "Camera",
                type: "button",
                "data-mini": "true"
            });
            if (this.controls.gallery) this.galleryBtn = e("<input>", {
                value: "Gallery",
                type: "button",
                "data-mini": "true"
            });
            if (this.controls.capture && this.controls.gallery) {
                o.appendTo(i).button();
                this.galleryBtn.appendTo(s).button();
                var u = e("<div />").addClass("ui-grid-a").append(i).append(s)
            } else if (this.controls.capture) {
                o.appendTo(r).button()
            } else if (this.controls.gallery) {
                this.galleryBtn.appendTo(r).button()
            }
            r.append(u);
            if (this.controls.preview) var a = e("<input>", {
                value: "Preview Image",
                type: "button"
            }).appendTo(r).button();
            if (this.controls.upload) this.uploadBtn = e("<input>", {
                value: "Upload Image",
                type: "button"
            }).appendTo(r).button();
            var f = this.element.parent(".ui-input-text");
            if (f) f.before(r).hide();
            else this.element.before(r).hide();
            this._on(o, {
                click: "_captureImage"
            });
            this._on(a, {
                click: "_previewImage"
            });
            this._on(this.galleryBtn, {
                click: "_galleryImage"
            });
            this._on(this.uploadBtn, {
                click: "_uploadImage"
            });
			if(this.element[0].value != ""){
				var img = e('<img/>').attr({'src':'OPG_Surveys_Media/'+this.element[0].value,'alt':'uploaded image'});
				e('<div class=customuploadedImage></div>').html(img).appendTo(r);
			}
        },
        _refresh: function() {
            this._create()
        },
        _destroy: function() {
            this.domHandle.remove()
        },
        _captureImage: function() {
            var t = this;
            try {
                cordova.exec(function(e) {
                    var n = jQuery.parseJSON(e);
                    t._writeImage(true, n)
                }, function(e) {
                    t._writeImage(false, e)
                }, "MediaPickerAndPreviewPlugin", "pickImageFromCamera", [])
            } catch (n) {
                e.proxy(this._writeImage(false, n), this)
            }
        },
        _galleryImage: function() {
            var t = this;
            var n = e(this.galleryBtn).offset();
            var r = n.top - e(window).scrollTop();
            var i = n.left - e(window).scrollLeft();
            var s = {
                left: i,
                top: r
            };
            try {
                cordova.exec(function(e) {
                    
                    var n = jQuery.parseJSON(e);
                    t._writeImage(true, n)
                }, function(e) {
                    t._writeImage(false, e)
                }, "MediaPickerAndPreviewPlugin", "pickImageFromGallery", [s])
            } catch (o) {
                e.proxy(this._writeImage(false, o), this)
            }
        },
        _previewImage: function() {
            if (!this.fileURI) {
                e.alertOpg("No Image selected","My Surveys");
                return
            }
            var t = {
                path: this.fileURI
            };
            //console.log("path: " + JSON.stringify(t));
            try {
                cordova.exec(function(e) {
                    
                }, function(e) {
                    
                }, "ImagePreviewPlugin", "showImageFromPath", [t])
            } catch (n) {
               // console.log("error in preview image " + n)
            }
        },
        _writeImage: function(t, n) {
             if (!t) {
               // e.alertOpg("Get picture failed because: " + n);
             }
            else if (t) {
                this.fileURI = n.path
            }
        },
        _uploadImage: function(t, n) {
            if (!this.fileURI) {
                e.alertOpg("No Image selected","My Surveys");
                return
            }
            var r = this;
            this.uploadBtn.val("Uploading").button("refresh");
            try {
                var i = {
                    mediaPath: this.fileURI,
                    comments: "Uploading Image"
                };
                //console.log(JSON.stringify(i));
                cordovaFunction.uploadImage(i, function(e) {
                    if (!e.Percent) {
                        r.uploadBtn.val("Uploaded").button("refresh");
						var fileUrl = 'OPG_Surveys_Media/'+e.MediaID;
                        r.element.attr("value", e.MediaID);
						if($(".customuploadedImage").find("img").length != 0){
							$("img").attr('src',fileUrl);				
						}else{
							var img = $('<img/>').attr({'src':fileUrl,'alt':'uploaded image'});
						$('<div class=customuploadedImage></div>').html(img).appendTo($(".imagecontainer"));
						}
							
                    }
                }, function(t) {
                                            });
            } catch (s) {
                r.uploadBtn.val("Upload").button("refresh");
                e.alertOpg("Image upload failed : " + s,"My Surveys")
            }
        }
    });
    e.widget("opg.Audio", {
        initSelector: "input[data-role=Audio]",
        file: null,
        uri: null,
        audio: null,
        _create: function() {
            this.fileURI = null;
            var n = this.element.attr("control-attr").split(";");
            this.controls = {
                capture: n.indexOf("AccessNew") == -1 ? false : true,
                gallery: n.indexOf("AccessGallery") == -1 ? false : true,
                preview: n.indexOf("AllowPlayback") == -1 ? false : true,
                upload: n.indexOf("AllowUpload") == -1 ? false : true
            };
            if (tMobile.iOS()) this.controls.gallery = false;
            var r = document.createElement("div");
			r.className = "audiocontainer";
            var i = e(r);
            var s = e('<div class="ui-block-a">');
            var o = e('<div class="ui-block-b">');
            if (this.controls.capture) this.captureBtn = e("<input>", {
                value: "Record Audio",
                type: "button",
                "data-mini": "true"
            });
            if (this.controls.gallery) var u = e("<input>", {
                value: "Gallery",
                type: "button",
                "data-mini": "true"
            });
            if (this.controls.capture && this.controls.gallery) {
                this.captureBtn.appendTo(s).button();
                u.appendTo(o).button();
                var a = e("<div />").addClass("ui-grid-a").append(s).append(o)
            } else if (this.controls.capture) {
                this.captureBtn.appendTo(i).button()
            } else if (this.controls.gallery) {
                u.appendTo(i).button()
            }
            i.append(a);
            this.playBtn = e("<input>", {
                value: "Play Audio",
                type: "button"
            }).appendTo(i).button();
            this.uploadBtn = e("<input>", {
                value: "Upload audio",
                type: "button"
            }).appendTo(i).button();
            var f = this.element.parent(".ui-input-text");
            if (f) f.before(i).hide();
            else this.element.before(i).hide();
            this._on(this.captureBtn, {
                click: "_recordAudio"
            });
            this._on(u, {
                click: "_getAudio"
            });
            this._on(this.playBtn, {
                click: "_playAudio"
            });
            this._on(this.uploadBtn, {
                click: "_uploadAudio"
            });
			if(this.element[0].value != ""){
			var audioUrl = 'OPG_Surveys_Media/'+this.element[0].value;
				$('<audio controls><source id=customUploadedAudio   src='+audioUrl+'></audio>').appendTo(r);
			}
        },
        _refresh: function() {
            this._create()
        },
        _destroy: function() {
            this.domHandle.remove()
        },
        _recordAudio: function(t) {
            var n = this;
            if (this.captureBtn.val() == "Record Audio") {
                n.captureBtn.val("Stop Recording").button("refresh");
                try {
                    cordova.exec(function(e) {}, function(t) {
                        e.alertOpg("Error while recording audio. Please try again.", "My Surveys")
                    }, "MediaPickerAndPreviewPlugin", "startRecordingAudio", [])
                } catch (r) {
                    n._storeFile(false, r)
                }
            } else {
                n.captureBtn.val("Record Audio").button("refresh");
                n.playBtn.button("enable");
                try {
                    cordova.exec(function(t) {
                        
                        var r = jQuery.parseJSON(t);
                        e.proxy(n._storeFile(true, r), this)
                    }, function(t) {
                        e.alertOpg("Couldn't stop recording audio. Please try again.", "My Surveys")
                    }, "MediaPickerAndPreviewPlugin", "stopRecordingAudio", [])
                } catch (r) {
                    n._storeFile(false, r)
                }
            }
        },
        _playAudio: function() {
            if (!this.file) {
                e.alertOpg("No Audio selected","My Surveys");
                return
            }
            var t = this;
            if (this.playBtn.val() == "Play Audio") {
                this.playBtn.val("Stop Playing").button("refresh");
                try {
                    var n = {
                        path: this.file
                    };
                    //console.log("path " + JSON.stringify(n));
                    cordova.exec(function(e) {
                        t.playBtn.val("Play Audio").button("refresh")
                    }, function(e) {
                       //  console.log("play displayError : " + e);
                         t.playBtn.val("Play Audio").button("refresh");
                    }, "MediaPickerAndPreviewPlugin", "startPlayingRecordedAudio", [n])
                } catch (r) {
                    t._storeFile(false, r)
                }
            } else {
                t.playBtn.val("Play Audio").button("refresh");
                try {
                    cordova.exec(function(e) {}, function(e) {
                       // console.log("stop displayError : " + e);
                        var n = jQuery.parseJSON(e);
                        t._storeFile(true, n)
                    }, "MediaPickerAndPreviewPlugin", "stopPlayingRecordedAudio", [])
                } catch (r) {
                    t._storeFile(false, r)
                }
            }
        },
        _getAudio: function() {
            var e = this;
            try {
                cordova.exec(function(t) {
                    
                    e.playBtn.button("enable");
                    var n = jQuery.parseJSON(t);
                    e._storeFile(true, n)
                }, function(t) {
                    
                    var n = jQuery.parseJSON(t);
                    e._storeFile(true, n)
                }, "MediaPickerAndPreviewPlugin", "pickAudioFromGallery", [])
            } catch (t) {
                e._storeFile(false, t)
            }
        },
        _storeFile: function(t, n) {
           // console.log("_storeAudio " + n);
            if (!t) e.alertOpg("Capture Audio failed because: " + n,"My Surveys");
            else if (t) {
                this.file = n.path
            }
        },
        _uploadAudio: function() {
            if (!this.file) {
                e.alertOpg("No Audio selected","My Surveys");
                return
            }
            var t = this;
            this.uploadBtn.val("Uploading").button("refresh");
            try {
                var n = {
                    mediaPath: this.file,
                    comments: "Uploading Audio"
                };
                cordovaFunction.uploadImage(n, function(e) {
                    if (!e.Percent) {
                        t.uploadBtn.val("Uploaded").button("refresh");
						var audioUrl = 'OPG_Surveys_Media/'+e.MediaID;
                        t.element.val(e.MediaID);
						t.element.attr("value", e.MediaID);
						if($("audio").length != 0){
							$("audio").remove();
							$('<audio controls><source id=customUploadedAudio   src='+audioUrl+'></audio>').appendTo($(".audiocontainer"));
						}else{
							$('<audio controls><source src='+audioUrl+'></audio>').appendTo($(".audiocontainer"));
						}				
                    }
                }, function(t) {
                    e.alertOpg("Audio upload failed : " + t,"My Surveys")
                                            });
            } catch (r) {
                e.alertOpg("Audio upload failed : " + r,"My Surveys")
            }
        }
    });
    e.widget("opg.Video", {
        initSelector: "input[data-role=Video]",
        _create: function() {
            this.fileURI = null;
            this.height = window.innerHeight / 3;
            var t = this.element.attr("control-attr").split(";");
            this.controls = {
                capture: t.indexOf("AccessNew") == -1 ? false : true,
                gallery: t.indexOf("AccessGallery") == -1 ? false : true,
                preview: t.indexOf("AllowPlayback") == -1 ? false : true,
                upload: t.indexOf("AllowUpload") == -1 ? false : true
            };
            var n = document.createElement("div");
			n.className = "videocontainer";
            var r = e(n);
            var i = e('<div class="ui-block-a">');
            var s = e('<div class="ui-block-b">');
            if (this.controls.capture) var o = e("<input>", {
                value: "Record",
                type: "button",
                "data-mini": "true"
            });
            if (this.controls.gallery) this.galleryBtn = e("<input>", {
                value: "Gallery",
                type: "button",
                "data-mini": "true"
            });
            if (this.controls.capture && this.controls.gallery) {
                o.appendTo(i).button();
                this.galleryBtn.appendTo(s).button();
                var u = e("<div />").addClass("ui-grid-a").append(i).append(s)
            } else if (this.controls.capture) {
                o.appendTo(r).button()
            } else if (this.controls.gallery) {
                this.galleryBtn.appendTo(r).button()
            }
            r.append(u);
            var a = e("<input>", {
                value: "Preview video",
                type: "button"
            }).appendTo(r).button();
            this.uploadBtn = e("<input>", {
                value: "Upload video",
                type: "button"
            }).appendTo(r).button();
            var f = this.element.parent(".ui-input-text");
            if (f) f.before(r).hide();
            else this.element.before(r).hide();
            this._on(o, {
                click: "_captureVideo"
            });
            this._on(this.galleryBtn, {
                click: "_getVideo"
            });
            this._on(a, {
                click: "_previewVideo"
            });
            this._on(this.uploadBtn, {
                click: "_uploadVideo"
            });
			var videoUrl = 'OPG_Surveys_Media/'+this.element[0].value;
			if(this.element[0].value != ""){
					$('<video controls><source id=customUploadedVideo   src='+videoUrl+'></video>').appendTo(r);
			}
        },
        _refresh: function() {
            this._create()
        },
        _destroy: function() {
            this.domHandle.remove()
        },
        _captureVideo: function(t) {
            var n = this;
            try {
                cordova.exec(function(e) {
                    
                    var t = jQuery.parseJSON(e);
                    n._storeFile(t.path)
                }, function(t) {
                    //console.log("Error in capture video : " + JSON.stringify(t));
                   // e.alertOpg("Capture Video failed. Please try again.")
                }, "MediaPickerAndPreviewPlugin", "pickVideoFromCamera", [])
            } catch (r) {
                //console.log("Exception in capture video : " + r);
                e.alertOpg("Capture Video failed. Please try again.","My Surveys")
            }
        },
        _getVideo: function() {
            var t = this;
            var n = e(this.galleryBtn).offset();
            var r = n.top - e(window).scrollTop();
            var i = n.left - e(window).scrollLeft();
            var s = {
                left: i,
                top: r
            };
            try {
                cordova.exec(function(e) {
                    
                    var n = jQuery.parseJSON(e);
                    t._storeFile(n.path)
                }, function(t) {
                    //console.log("Error in pick video : " + JSON.stringify(t));
                    //e.alertOpg("Pick Video failed. Please try again.")
                }, "MediaPickerAndPreviewPlugin", "pickVideoFromGallery", [s])
            } catch (o) {
               // console.log("Exception in pick video : " + o);
                e.alertOpg("Pick Video failed. Please try again.","My Surveys")
            }
        },
        _storeFile: function(e) {
           // console.log("_storeVideo :" + e);
            this.fileURI = e
        },
        _previewVideo: function() {
            if (!this.fileURI) {
                e.alertOpg("No Video selected","My Surveys");
                return
            }
            var t = {
                path: this.fileURI
            };
            //console.log("path: " + JSON.stringify(t));
            try {
                cordova.exec(function(e) {
                    
                }, function(e) {
                    
                }, "MediaPickerAndPreviewPlugin", "playVideoSelectedPath", [t])
            } catch (n) {
               // console.log("error in preview video " + n)
            }
        },
        _uploadVideo: function(t, n) {
            if (!this.fileURI) {
                e.alertOpg("No Video selected" ,"My Surveys");
                return
            }
            var r = this;
            this.uploadBtn.val("Uploading").button("refresh");
            try {
                var i = {
                    mediaPath: this.fileURI,
                    comments: "Uploading Video"
                };
                cordovaFunction.uploadImage(i, function(e) {
                    if (!e.Percent) {
                        r.uploadBtn.val("Uploaded").button("refresh");
						var videoUrl = 'OPG_Surveys_Media/'+e.MediaID;
                        r.element.val(e.MediaID);
						if($("video").length != 0){
							$("video").remove();
								$('<video controls><source id=customUploadedVideo   src='+videoUrl+'></video>').appendTo($(".videocontainer"));
						}else{
                                            $('<video controls><source id=customUploadedVideo   src='+videoUrl+'></video>').appendTo($(".videocontainer"));
		
						}
						
                    }
                }, function(t) {
                    e.alertOpg("Video upload failed : " + t,"My Surveys")
                })
            } catch (s) {
                e.alertOpg("Video upload failed : " + s,"My Surveys");
                this.uploadBtn.val("Upload").button("refresh")
            }
        }
    });
    e.widget("opg.datetimepicker", e.mobile.widget, {
        initSelector: "input[type=date],input[type=time],input[type=datetime]",
        options: {
            date: null,
            originalDate: null,
            currentDate: null,
            type: "date",
            dateformat: "dd-MMM-yyyy",
            timeformat: "hh:mm TT",
            datetimeformat: "dd-MMM-yyyy hh:mm TT",
            redateformat: "yyyy-MM-dd",
            retimeformat: "HH:mm",
            redatetimeformat: "dd-MM-yyyy HH:mm",
            maxDate: null,
            minDate: null,
            popup: {
                dismissible: false,
                history: false,
                overlayTheme: "a",
                positionTo: "window",
                theme: "a",
                transition: "none"
            }
        },
        _picker: e([]),
        destroy: function() {
            this._close();
            this.element.off("tap click");
            this._picker.popup("destroy");
            e.Widget.prototype.destroy.call(this)
        },
        _create: function() {
            this._initOptions();
            this._createView();
            this.element.on("tap click", e.proxy(this.open, this))
        },
        _initOptions: function() {
            var e = this.element.val() || this.options.date,
                t = this.element.attr("min") || this.options.minDate,
                n = this.element.attr("max") || this.options.maxDate,
                r = this.element.attr("type") || this.options.type;
            if (e) {
                this._setOption("date", e)
            }
            if (r) {
                this._setOption("type", r.toLowerCase())
            }
            if (n) {
                this._setOption("maxDate", n)
            }
            if (t) {
                this._setOption("minDate", t)
            }
        },
        open: function(e) {
            if (e) {
                e.stopPropagation();
                e.preventDefault()
            }
            var t = this._getDate();
            if (!this._isXDate(t)) {
                t = new XDate
            }
            this._setOption("date", this._fitDate(t));
            this._setOption("originalDate", this._getDate());
            this._showView();
            this._updateView();
            this._bindEvents()
        },
        _bindEvents: function() {
            var t = this,
                n = this._picker,
                r = e.proxy(this._confirmDate, this),
                i = e.proxy(this._cancelDate, this),
                s = e.proxy(this._cancelDateOnEsc, this);
            n.find(".datebox-set").off().on("tap click", r);
            n.find(".datebox-cancel").off().on("tap click", i);
            e(document).off("keyup", s).on("keyup", s);
            var o = {
                ".datebox-prev-day": "_prevDay",
                ".datebox-prev-month": "_prevMonth",
                ".datebox-prev-year": "_prevYear",
                ".datebox-next-day": "_nextDay",
                ".datebox-next-month": "_nextMonth",
                ".datebox-next-year": "_nextYear",
                ".datebox-prev-hour": "_prevHour",
                ".datebox-prev-minute": "_prevMinute",
                ".datebox-prev-meridian": "_prevMeridian",
                ".datebox-next-hour": "_nextHour",
                ".datebox-next-minute": "_nextMinute",
                ".datebox-next-meridian": "_nextMeridian"
            };
            for (var u in o) {
                (function() {
                    var r = t[o[u]];
                    var i = -1;var count = 0;
                    n.find(u).off().on("mousedown touchstart", e.proxy(function() {
                       	if( i == -1){
                       	  i = setInterval(function() {
                        	 ++count;
                        	 if(count > (i%10)){
                        		 clearInterval(i);
                        		 i=-1;count = 0;
                        	 }else{
                        		t._handleDate(r)
                        	 }
                          },300);  
                        }                 
                    }, t)).on("mouseup mouseout touchend", e.proxy(function() {
                    	if( i != -1){
                       	  clearInterval(i);
                       	  count = 0;i=-1;
	                    }
                    }, t)).on("click",e.proxy(function(){
                    	return t._handleDate(r)
                    },t));
                })()
            }
        },
        _close: function() {
            this._hideView()
        },
        _handleDate: function(e) {
            this._setOption("currentDate", this._getDate());
            this._setOption("date", this._fitDate(e.apply(this)));
            return false
        },
        _confirmDate: function() {
            var e = true,
                t = this._getDate().diffDays(this.options.originalDate),
                n = t !== 0 || this.element.val() === "";
            if (this.options.close && typeof this.options.close === "function") {
                e = this.options.close.call() !== false
            }
            if (e && n) {
                this._setOption("originalDate", this._getDate());
                this.updateDateInput();
                this.element.trigger("change")
            } else {
                this._setOption("date", this.options.originalDate)
            }
            this._close();
            return false
        },
        _cancelDate: function() {
            this._setOption("date", this.options.originalDate);
            this._close();
            return false
        },
        _setOption: function(t, n) {
            switch (t) {
                case "date":
                    var r = this._sanitizeDate(n);
                    this.options[t] = r ? r.toDate() : r;
                    break;
                case "originalDate":
                    this.options[t] = this._sanitizeDate(n).toDate();
                    break;
                case "currentDate":
                    this.options[t] = this._sanitizeDate(n).toDate();
                    break;
                case "maxDate":
                    this.options[t] = this._sanitizeMaxDate(n).toDate();
                    break;
                case "minDate":
                    this.options[t] = this._sanitizeMinDate(n).toDate();
                    break;
                case "type":
                    this.options[t] = n;
                default:
                    return e.Widget.prototype._setOption.apply(this, arguments)
            }
            this._updateView()
        },
        _sanitizeDate: function(e) {
            if (e === null) {
                return null
            }
            var t = e;
            if (typeof t === "string") {
                t = new XDate(t)
            }
            if (this._isXDate(t)) {
                t = t.toDate()
            }
            if (!this._isDate(t)) {
                throw "Parameter 'date' must be a Date."
            }
            return new XDate(t)
        },
        _sanitizeMinDate: function(e) {
            var t = this._sanitizeDate(e);
            if (this._isAfterMaxDate(t)) {
                throw "Min date must be before max date."
            }
            return t
        },
        _sanitizeMaxDate: function(e) {
            var t = this._sanitizeDate(e);
            if (this._isBeforeMinDate(t)) {
                throw "Max date must be after min date."
            }
            return t
        },
        _getFormat: function(e) {
            switch (this.options.type) {
                case "date":
                    return this.options[e + "dateformat"];
                case "time":
                    return this.options[e + "timeformat"];
                case "datetime":
                    return this.options[e + "datetimeformat"];
                default:
                    return this.options.dateformat
            }
        },
        returnString: function() {
            var e = this._getFormat("re"),
                t = this._getDate();
            return !t ? "" : t.toString(e)
        },
        formattedString: function() {
            var e = this._getFormat(""),
                t = this._getDate();
            return !t ? "" : t.toString(e)
        },
        _fitDate: function(e) {
            if (this.options.currentDate == null) return this._isAfterMaxDate(e) ? this._getMaxDate() : this._isBeforeMinDate(e) ? this._getMinDate() : e;
            else return this._isAfterMaxDate(e) || this._isBeforeMinDate(e) ? this.options.currentDate : e
        },
        _isAfterMaxDate: function(e) {
            var t = this._getMaxDate();
            return this._isXDate(t) && parseInt(e.diffDays(t)) < 0
        },
        _isBeforeMinDate: function(e) {
            var t = this._getMinDate();
            return this._isXDate(t) && t.diffDays(e) < 0
        },
        _isDate: function(e) {
            return typeof e === "object" && e !== null && e.constructor === Date
        },
        _isXDate: function(e) {
            return typeof e === "object" && e !== null && e.constructor === XDate
        },
        _getMaxDate: function() {
            var e = this.options.maxDate;
            return this._isDate(e) ? new XDate(e) : null
        },
        _getMinDate: function() {
            var e = this.options.minDate;
            return this._isDate(e) ? new XDate(e) : null
        },
        _getDate: function() {
            var e = this.options.date;
            return this._isDate(e) ? new XDate(e) : null
        },
        _prevDay: function() {
            return this._addDay(-1)
        },
        _nextDay: function() {
            return this._addDay(1)
        },
        _prevMonth: function() {
            return this._addMonth(-1)
        },
        _nextMonth: function() {
            return this._addMonth(1)
        },
        _prevYear: function() {
            return this._addYear(-1)
        },
        _nextYear: function() {
            return this._addYear(1)
        },
        _prevHour: function() {
            return this._addHour(-1)
        },
        _nextHour: function() {
            return this._addHour(1)
        },
        _prevMinute: function() {
            return this._addMinute(-1)
        },
        _nextMinute: function() {
            return this._addMinute(1)
        },
        _prevMeridian: function() {
            return this._addHour(-12)
        },
        _nextMeridian: function() {
            return this._addHour(12)
        },
        _addYear: function(e) {
            return this._getDate().addYears(e, true)
        },
        _addMonth: function(e) {
            var t = this._getDate(),
                n = t.getMonth(),
                r = (12 + n + e) % 12;
            return t.setMonth(r, true)
        },
        _addDay: function(e) {
            var t = this._getDate(),
                n = XDate.getDaysInMonth(t.getFullYear(), t.getMonth());
            return t.setDate((t.getDate() - 1 + n + e) % n + 1)
        },
        _addHour: function(e) {
            var t = this._getDate(),
                n = t.getHours(),
                r = (24 + n + e) % 24;
            if (e > 0 && r % 12 == 0) r = 12 - r;
            else if (e < 0 && (r + 1) % 12 == 0) r = (r - 12 + 24) % 24;
            return t.setHours(r, true)
        },
        _addMinute: function(e) {
            var t = this._getDate(),
                n = t.getMinutes(),
                r = (60 + n + e) % 60;
            return t.setMinutes(r, true)
        },
        _getMarkUp: function() {
            var e = "<div class='datebox-main'><div class='datebox-date-formatted'>Date</div>";
            if (this.options.type.indexOf("date") != -1) e += "<ul class='datebox-groups'><li>" + "<ul><li><a class='datebox-next-day' data-role='button'>+</a></li>" + "<li><input type='text' class='datebox-input datebox-day' /></li>" + "<li><a class='datebox-prev-day' data-role='button'>-</a></li></ul>" + "</li><li>" + "<ul><li><a class='datebox-next-month' data-role='button'>+</a></li>" + "<li><input type='text' class='datebox-input datebox-month' /></li>" + "<li><a class='datebox-prev-month' data-role='button'>-</a></li></ul>" + "</li><li>" + "<ul><li><a class='datebox-next-year' data-role='button'>+</a></li>" + "<li><input type='text' class='datebox-input datebox-year' /></li>" + "<li><a class='datebox-prev-year' data-role='button'>-</a></li>" + "</ul></li></ul>";
            if (this.options.type.indexOf("time") != -1) e += "<ul class='datebox-groups'><li>" + "<ul><li><a class='datebox-next-hour' data-role='button'>+</a></li>" + "<li><input type='text' class='datebox-input datebox-hour' /></li>" + "<li><a class='datebox-prev-hour' data-role='button'>-</a></li></ul>" + "</li><li>" + "<ul><li><a class='datebox-next-minute' data-role='button'>+</a></li>" + "<li><input type='text' class='datebox-input datebox-minute' /></li>" + "<li><a class='datebox-prev-minute' data-role='button'>-</a></li></ul>" + "</li><li>" + "<ul><li><a class='datebox-next-meridian' data-role='button'>+</a></li>" + "<li><input type='text' class='datebox-input datebox-meridian' /></li>" + "<li><a class='datebox-prev-meridian' data-role='button'>-</a></li>" + "</ul></li></ul>";
            e += "<ul class='datebox-buttons'><li><a class='datebox-set' data-role='button'>Set</a></li>" + "<li><a class='datebox-cancel' data-role='button'>Cancel</a></li></ul></div>";
            return e
        },
        _applyTheme: function() {
            var e = this._picker,
                t = {
                    bottom: "ul.datebox-groups ul > li:first-child > a",
                    top: "ul.datebox-groups ul > li:last-child > a"
                };
            e.addClass("ui-body-" + this.options.popup.theme + " ");
            e.find("a").attr("href", "#").addClass("ui-body-a").css("margin", "0");
            e.find("input").attr("disabled", "disabled")
        },
        _createView: function() {
            this.element.attr("readonly", "readonly");
            this._picker = e(this._getMarkUp()).enhanceWithin().popup(this.options.popup);
            e.data(this.element, "datebox", this);
            this._applyTheme()
        },
        _updateView: function() {
            var e = this._getDate(),
                t = this._picker;
            if (this._isXDate(e) && this.options.type.indexOf("date") != -1) {
                t.find(".datebox-year").val(e.toString("yyyy"));
                t.find(".datebox-month").val(e.toString("MMM"));
                t.find(".datebox-day").val(e.toString("dd"));
                t.find(".datebox-date-formatted").text(this.formattedString())
            }
            if (this._isXDate(e) && this.options.type.indexOf("time") != -1) {
                t.find(".datebox-meridian").val(e.toString("TT"));
                t.find(".datebox-minute").val(e.toString("mm"));
                t.find(".datebox-hour").val(e.toString("hh"));
                t.find(".datebox-date-formatted").text(this.formattedString())
            }
        },
        _showView: function() {
            this._picker.show().popup("open").focus()
        },
        _hideView: function() {
            this._picker.popup("close")
        },
        updateDateInput: function() {
            this.element.val(this.returnString())
        }
    });
    e.widget("opg.number", {
        initSelector: "input[data-mask]",
        _create: function() {
            var t = this.element.attr("data-mask");
            var n = this.element.attr("data-placeholder") || "";
            e(this.element).attr("placeholder", n);
            this.element.mask(t)
        }
    });
    e.widget("opg.email", {
        initSelector: "input[type='email']",
        _create: function() {
            this.element.attr("type", this.element.attr("type").toLowerCase());
            this._on(this.element, {
                keyup: "_emailValidation"
            });
            errorLabel = e("<label/>")
        },
        _emailValidation: function(e) {
            var t = this.element.val();
            var n = /[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/;
            if (t !== "" && !n.test(t) || t == "") {
                this.element.parent().css("border", "2px solid #FF6A6A");
                this.element.parent().after(errorLabel.html("Invalid Email!").css({
                    color: "red"
                }))
            } else {
                this.element.parent().css("border", "2px solid #82CD82");
                this.element.parent().after(errorLabel.html("Its Valid!").css({
                    color: "green"
                }));
                return true
            }
        },
        _destroy: function() {
            domHandle.remove()
        }
    });

    e.widget("opg.slider", $.mobile.slider, {
    options: {
        vertical: false,
        height: 250
    },

    _create: function() {
        if (this.options.vertical) {
            // TODO: Each of these should have comments explain what they're for
            var self = this,
                control = this.element,
                trackTheme = this.options.trackTheme || $.mobile.getAttribute( control[ 0 ], "theme" ),
                trackThemeClass = trackTheme ? " ui-bar-" + trackTheme : " ui-bar-inherit",
                cornerClass = ( this.options.corners || control.jqmData( "corners" ) ) ? " ui-corner-all" : "",
                miniClass = ( this.options.mini || control.jqmData( "mini" ) ) ? " ui-mini" : "",
                cType = control[ 0 ].nodeName.toLowerCase(),
                isToggleSwitch = ( cType === "select" ),
                isRangeslider = control.parent().is( ":jqmData(role='rangeslider')" ),
                selectClass = ( isToggleSwitch ) ? "ui-slider-switch" : "",
                controlID = control.attr( "id" ),
                $label = $( "[for='" + controlID + "']" ),
                labelID = $label.attr( "id" ) || controlID + "-label",
                trueMin = !isToggleSwitch ? parseFloat( control.attr( "min" ) ) : 0,
                trueMax =  !isToggleSwitch ? parseFloat( control.attr( "max" ) ) : control.find( "option" ).length-1,
                min = trueMax * -1,
                max = trueMin * -1,
                step = window.parseFloat( control.attr( "step" ) || 1 ),
                domHandle = document.createElement( "a" ),
                handle = $( domHandle ),
                domSlider = document.createElement( "div" ),
                slider = $( domSlider ),
                valuebg = this.options.highlight && !isToggleSwitch ? (function() {
                    var bg = document.createElement( "div" );
                    bg.className = "ui-slider-bg " + $.mobile.activeBtnClass;
                    return $( bg ).prependTo( slider );
                })() : false,
                options,
                wrapper,
                j, length,
                i, optionsCount, origTabIndex,
                side, activeClass, sliderImg;

            $label.attr( "id", labelID );
            this.isToggleSwitch = isToggleSwitch;

            domHandle.setAttribute( "href", "#" );
            domSlider.setAttribute( "role", "application" );
            domSlider.className = [ this.isToggleSwitch ? "ui-slider ui-slider-track ui-shadow-inset " : "ui-slider-track ui-shadow-inset ", selectClass, trackThemeClass, cornerClass, miniClass ].join( "" );
            domHandle.className = "ui-slider-handle";
            domSlider.appendChild( domHandle );

            handle.attr({
                "role": "slider",
                "aria-valuemin": min,
                "aria-valuemax": max,
                "aria-valuenow": this._value(),
                "aria-valuetext": this._value(),
                "title": this._value(),
                "aria-labelledby": labelID
            });

            $.extend( this, {
                slider: slider,
                handle: handle,
                control: control,
                type: cType,
                step: step,
                max: max,
                min: min,
                valuebg: valuebg,
                isRangeslider: isRangeslider,
                dragging: false,
                beforeStart: null,
                userModified: false,
                mouseMoved: false
            });

            if ( isToggleSwitch ) {
                // TODO: restore original tabindex (if any) in a destroy method
                origTabIndex = control.attr( "tabindex" );
                if ( origTabIndex ) {
                    handle.attr( "tabindex", origTabIndex );
                }
                control.attr( "tabindex", "-1" ).focus(function() {
                    $( this ).blur();
                    handle.focus();
                });

                wrapper = document.createElement( "div" );
                wrapper.className = "ui-slider-inneroffset";

                for ( j = 0, length = domSlider.childNodes.length; j < length; j++ ) {
                    wrapper.appendChild( domSlider.childNodes[j] );
                }

                domSlider.appendChild( wrapper );

                // slider.wrapInner( "<div class='ui-slider-inneroffset'></div>" );

                // make the handle move with a smooth transition
                handle.addClass( "ui-slider-handle-snapping" );

                options = control.find( "option" );

                for ( i = 0, optionsCount = options.length; i < optionsCount; i++ ) {
                    side = !i ? "b" : "a";
                    activeClass = !i ? "" : " " + $.mobile.activeBtnClass;
                    sliderImg = document.createElement( "span" );

                    sliderImg.className = [ "ui-slider-label ui-slider-label-", side, activeClass ].join( "" );
                    sliderImg.setAttribute( "role", "img" );
                    sliderImg.appendChild( document.createTextNode( options[i].innerHTML ) );
                    $( sliderImg ).prependTo( slider );
                }

                self._labels = $( ".ui-slider-label", slider );

            }

            // monitor the input for updated values
            control.addClass( isToggleSwitch ? "ui-slider-switch" : "ui-slider-input" );

            this._on( control, {
                "change": "_controlChange",
                "keyup": "_controlKeyup",
                "blur": "_controlBlur",
                "vmouseup": "_controlVMouseUp"
            });

            slider.bind( "vmousedown", $.proxy( this._sliderVMouseDown, this ) )
                .bind( "vclick", false );

            // We have to instantiate a new function object for the unbind to work properly
            // since the method itself is defined in the prototype (causing it to unbind everything)
            this._on( document, { "vmousemove": "_preventDocumentDrag" });
            this._on( slider.add( document ), { "vmouseup": "_sliderVMouseUp" });

            slider.insertAfter( control );

            // wrap in a div for styling purposes
            if ( !isToggleSwitch && !isRangeslider ) {
                wrapper = this.options.mini ? "<div class='ui-slider ui-mini'>" : "<div class='ui-slider'>";

                control.add( slider ).wrapAll( wrapper );
            }

            // bind the handle event callbacks and set the context to the widget instance
            this._on( this.handle, {
                "vmousedown": "_handleVMouseDown",
                "keydown": "_handleKeydown",
                "keyup": "_handleKeyup"
            });

            this.handle.bind( "vclick", false );

            this._handleFormReset();

            this.refresh( undefined, undefined, true );

            this.slider.attr("style", "width:20px !important; margin: 0 0 20px 14px !important; height:"+this.options.height+"px !important;")
            $(this.control).detach()
            $(this.slider).parent().append(this.control)
            $(this.slider).parent().css("margin-bottom", (this.options.height + 30) + "px")
        } else {
            this._super()
        }
    },

    _value: function() {
        if (!this.options.vertical) {
            this._super()
        } else {
            return  this.isToggleSwitch ? this.element[0].selectedIndex : parseFloat( this.element.val() * -1 );
        }
    },

    refresh: function(val, isfromControl, preventInputUpdate) {
        if (!this.options.vertical) {
            this._super(val, isfromControl, preventInputUpdate)
        } else {
            var self = this,
                parentTheme = $.mobile.getAttribute( this.element[ 0 ], "theme" ),
                theme = this.options.theme || parentTheme,
                themeClass =  theme ? " ui-btn-" + theme : "",
                trackTheme = this.options.trackTheme || parentTheme,
                trackThemeClass = trackTheme ? " ui-bar-" + trackTheme : " ui-bar-inherit",
                cornerClass = this.options.corners ? " ui-corner-all" : "",
                miniClass = this.options.mini ? " ui-mini" : "",
                top, height, data, tol,
                pyStep, percent,
                control, isInput, optionElements, min, max, step,
                newval, valModStep, alignValue, percentPerStep,
                handlePercent, aPercent, bPercent,
                valueChanged;

            self.slider[0].className = [ this.isToggleSwitch ? "ui-slider ui-slider-switch ui-slider-track ui-shadow-inset" : "ui-slider-track ui-shadow-inset", trackThemeClass, cornerClass, miniClass ].join( "" );
            if ( this.options.disabled || this.element.prop( "disabled" ) ) {
                this.disable();
            }

            // set the stored value for comparison later
            this.value = this._value();
            if ( this.options.highlight && !this.isToggleSwitch && this.slider.find( ".ui-slider-bg" ).length === 0 ) {
                this.valuebg = (function() {
                    var bg = document.createElement( "div" );
                    bg.className = "ui-slider-bg " + $.mobile.activeBtnClass;
                    return $( bg ).prependTo( self.slider );
                })();
            }
            this.handle.addClass( "ui-btn" + themeClass + " ui-shadow" );

            control = this.element;
            isInput = !this.isToggleSwitch;
            optionElements = isInput ? [] : control.find( "option" );

// invert min and max
            trueMin =  isInput ? parseFloat( control.attr( "min" ) ) : 0
            trueMax = isInput ? parseFloat( control.attr( "max" ) ) : optionElements.length - 1;
            min = trueMax * -1
            max = trueMin * -1

            /* original
            min =  isInput ? parseFloat( control.attr( "min" ) ) : 0
            max = isInput ? parseFloat( control.attr( "max" ) ) : optionElements.length - 1;*/


            step = ( isInput && parseFloat( control.attr( "step" ) ) > 0 ) ? parseFloat( control.attr( "step" ) ) : 1;

            if ( typeof val === "object" ) {
                data = val;
                // a slight tolerance helped get to the ends of the slider
                tol = 8;

                top = this.slider.offset().top;
                height = this.slider.height();
                pyStep = height/((max-min)/step);
                if ( !this.dragging ||
                        data.pageY < top - tol ||
                        data.pageY > top + height + tol ) {
                    return;
                }
                if ( pyStep > 1 ) {
                    percent = ( ( data.pageY - top ) / height ) * 100;
                } else {
                    percent = Math.round( ( ( data.pageY - top ) / height ) * 100 );
                }
            } else {
                if ( val == null ) {
                    val = isInput ? parseFloat( control.val() * -1 || 0 ) : control[0].selectedIndex;
                }
                percent = ( parseFloat( val ) - min ) / ( max - min ) * 100;
            }

            if ( isNaN( percent ) ) {
                return;
            }

            newval = ( percent / 100 ) * ( max - min ) + min;

            //from jQuery UI slider, the following source will round to the nearest step
            valModStep = ( newval - min ) % step;
            alignValue = newval - valModStep;

            if ( Math.abs( valModStep ) * 2 >= step ) {
                alignValue += ( valModStep > 0 ) ? step : ( -step );
            }

            percentPerStep = 100/((max-min)/step);
            // Since JavaScript has problems with large floats, round
            // the final value to 5 digits after the decimal point (see jQueryUI: #4124)
            newval = parseFloat( alignValue.toFixed(5) );

            if ( typeof pyStep === "undefined" ) {
                pyStep = height / ( (max-min) / step );
            }
            if ( pyStep > 1 && isInput ) {
                percent = ( newval - min ) * percentPerStep * ( 1 / step );
            }
            if ( percent < 0 ) {
                percent = 0;
            }

            if ( percent > 100 ) {
                percent = 100;
            }

            if ( newval < min ) {
                newval = min;
            }

            if ( newval > max ) {
                newval = max;
            }

            newval *= -1;

            this.handle.css( "top", percent + "%" );
            this.handle.css("margin-left", "-5px");

            this.handle[0].setAttribute( "aria-valuenow", isInput ? newval : optionElements.eq( newval ).attr( "value" ) );

            this.handle[0].setAttribute( "aria-valuetext", isInput ? newval : optionElements.eq( newval ).getEncodedText() );

            this.handle[0].setAttribute( "title", isInput ? newval : optionElements.eq( newval ).getEncodedText() );

            if ( this.valuebg ) {
                this.valuebg.css( "height", percent + "%" );
            }

            // drag the label heights
            if ( this._labels ) {
                handlePercent = this.handle.height() / this.slider.height() * 100;
                aPercent = percent && handlePercent + ( 100 - handlePercent ) * percent / 100;
                bPercent = percent === 100 ? 0 : Math.min( handlePercent + 100 - aPercent, 100 );

                this._labels.each(function() {
                    var ab = $( this ).hasClass( "ui-slider-label-a" );
                    $( this ).height( ( ab ? aPercent : bPercent  ) + "%" );
                });
            }

            if ( !preventInputUpdate ) {
                valueChanged = false;

                // update control"s value
                if ( isInput ) {
                    valueChanged = control.val() !== newval;
                    control.val( newval );
                } else {
                    valueChanged = control[ 0 ].selectedIndex !== newval;
                    control[ 0 ].selectedIndex = newval;
                }
                if ( this._trigger( "beforechange", val ) === false) {
                        return false;
                }
                if ( !isfromControl && valueChanged ) {
                    control.trigger( "change" );
                }
            }
        }
    }
})


       var tMobile = {
        Android: function() {
            return navigator.userAgent.match(/Android/i)
        },
        BlackBerry: function() {
            return navigator.userAgent.match(/BlackBerry/i)
        },
        iOS: function() {
            return navigator.userAgent.match(/iPhone|iPad|iPod/i)
        },
        iPad: function() {
            return navigator.userAgent.match(/iPad/i)
        },
        Opera: function() {
            return navigator.userAgent.match(/Opera Mini/i)
        },
        Windows: function() {
            return navigator.userAgent.match(/IEMobile/i)
        },
        anyMobile: function() {
            return tMobile.Android() || tMobile.BlackBerry() || tMobile.iOS() || tMobile.Opera() || tMobile.Windows()
        },
        anyComputer: function() {
            if (!navigator.userAgent.match(/mobile|android|ipad|tablet|kindle/i)) return navigator.userAgent.match(/Windows|Macintosh|Linux|Unix/i);
            else return null
        },
        any: function() {
            return tMobile.anyComputer() || tMobile.anyMobile()
        },
        getAndroidVersion: function() {
            var e = navigator.userAgent;
            if (this.Android()) return parseFloat(e.slice(e.indexOf("Android") + 8));
            else false
        },
        getIosVersion: function() {
            var e = navigator.userAgent;
            if (this.iOS()) return parseFloat(e.slice(e.indexOf("iOS") + 8));
            else false
        }
    }
})(jQuery)
