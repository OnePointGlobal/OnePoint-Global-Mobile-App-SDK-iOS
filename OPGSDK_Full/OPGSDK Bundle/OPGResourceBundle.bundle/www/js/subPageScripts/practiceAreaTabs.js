//# sourceURL=practiceAreaTabs.js

var BarcodeModule = {
    init : function() {
        this.bindListeners();
        
    },
    bindListeners : function() {
        $("#getBarcode").on('click', function() {
                            platformSpecific.barcodeScan(BarcodeModule.writeBarcode);
                            });
        $("#mybarcode").on('click',function(e){
                           e.preventDefault();
                           var barcode = $(this).text();
                           if(barcode == languageScript.translate('barcode_text2'))
                           return;
                           if(BarcodeModule.validUrl(barcode))
                           window.open(barcode,'_system','location=yes');
                           else
                           window.open('http://www.google.com/m/products?q='+barcode,'_system','location=yes');
                           });
        
    },
    writeBarcode : function(result){
        
        if(!result.cancelled)
            $("#mybarcode").html(result.text);
        else if(result.cancelled || result == null){
            //set the nativeOpen object to true, to say that back button has been pressed to cancel barcode scanning
            //and it should not trigger backpress event for the app
            app.nativeOpen = true;
            utils.showPrompt(languageScript.translate('enterBarcode'),function(data){
                             var barcode = data;
                             if (barcode != null && barcode.length > 0)
                             $("#mybarcode").html(barcode);
                             else
                             $("#mybarcode").html(languageScript.translate('barcode_text2'));
                             });
        }
    },
    validUrl : function(barcode) {
        var pattern = new RegExp("^(http|https|ftp)\://([a-zA-Z0-9\.\-]+(\:[a-zA-Z0-9\.&amp;%\$\-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|([a-zA-Z0-9\-]+\.)*[a-zA-Z0-9\-]+\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(\:[0-9]+)*(/($|[a-zA-Z0-9\.\,\?\'\\\+&amp;%\$#\=~_\-]+))*$");
        if (!pattern.test(barcode)) {
            return false;
        } else {
            return true;
        }
    }
};

var GeolocationModule = {
    init : function() {
        this.setMapholder();
        this.bindListeners();
    },
    bindListeners : function() {
        $(window).on('resize',function() {
                     GeolocationModule.setMapholder();
                     });
        $('#geoRefresh').on('click',function(){
                            GeolocationModule.getLocation();
                            });
    },
    getLocation : function() {
        $('.bodyWrapper').show();
        if(isMobile.Android())
        {
            try {
                cordova.exec(function(){}, GeolocationModule.displayError, 'EnableGPSPlugin', 'enableGPS',[]);
            } catch (err) {
                console.log('Error in enableGps Plugin : '+err);
            }
        }
        try {
            if (platformSpecific.checkConnection() != Connection.NONE) {
                platformSpecific.getLocation($("#mylocation"),$("#mapholder"),this.getLocationCallback);
            } else {
                GeolocationModule.displayError(languageScript.translate('geoNetworkError'));
            }
        } catch (err) {
            $('.bodyWrapper').hide();
            console.log('Error in geolocation module : '+err);
        }
    },
    getLocationCallback : function(getLoc){
        if(getLoc == true){
            $('.bodyWrapper').hide();
            $('#geoRefreshTxt').html(languageScript.translate('geolocation_text3')+'<br><br>');
            $('#geoRefresh').text(languageScript.translate('refresh'));
        } else if(getLoc == false){
            GeolocationModule.displayError(languageScript.translate('genericError'));
        } else {
            GeolocationModule.displayError(getLoc);
        }
        
    },
    displayError : function(err) {
        var errMsg;
        if(typeof(err) == 'object'){
            switch(err.code){
                case 1:
                    errMsg = languageScript.translate('permissionDenied'); break;
                case 2:
                    errMsg = languageScript.translate('positionUnavailable'); break;
                case 3:
                    errMsg = languageScript.translate('timeout'); break;
                default:
                    errMsg = languageScript.translate('genericError') ; break;
            }	
            $("#mylocation").html(errMsg);
        }else
            $("#mylocation").html(err);
        $('.bodyWrapper').hide();
    },
    setMapholder : function() {
        try {
            var mapholder_height = $(window).height()- $('#mapholder').offset().top;
            $('#mapholder').css('height', mapholder_height);
        } catch (err) {
            console.log("Set Mapholder Error: " + err);
        }
    }
};

var WorkbenchPage = {
    init : function() {
        this.bindListeners();
        GeolocationModule.init();
        BarcodeModule.init();
        $('.pageHeader li').eq(1).css('border-left','2px solid #D0DADC');
    },
    bindListeners : function() {
        $('.pageHeader li').on('click', function() {
                               $('.pageHeader li').removeClass('active');
                               $('.pageHeader li').css('border-left','none');
                               $(this).addClass('active');
                               $(this).next().css('border-left','2px solid #D0DADC');
                               $('.body_content').hide();
                               $('.'+$(this).attr('attrPanel')+'_panel').show();
                               });
    }
};

$(function() {
  WorkbenchPage.init();
  });
