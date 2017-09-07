//Function to detect mobile or computer devices. Call isMobile.deviceName() to get the device name   

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
	    }
	};
