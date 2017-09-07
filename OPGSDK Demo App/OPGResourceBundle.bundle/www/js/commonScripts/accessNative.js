var accessNative = {

	init : function() {
		document.addEventListener('deviceready', accessNative.bindListeners, false);
		document.addEventListener("resume", accessNative.bindListeners, false);
	},
	bindListeners : function() {
		$('.mrCaptureImage').on('click', function() {
			accessNative.getPictureCordova();
		});
	},
	getPictureNative : function() {
		cordovaFunction.pickMedia(accessNative.loadMedia);
	},
	getPictureCordova : function() {
		platformSpecific.getImage(1, 1,accessNative.loadMedia);
	},
	loadMedia : function(imgUri) {
		//console.log(imgUri);
		var img = '<img src="' + imgUri + '" style="width:200px;"/>'
		$("body").append(img);
	}
};
$(function() {
	"use strict";
	accessNative.init();
});