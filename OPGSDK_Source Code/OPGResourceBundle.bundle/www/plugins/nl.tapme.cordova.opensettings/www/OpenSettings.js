cordova.define("nl.tapme.cordova.opensettings.OpenSettings", function(require, exports, module) { module.exports = OpenSettings = {};

OpenSettings.settings = function(app, callback) {
	cordova.exec(
		// Success callback
		callback,
		// Failure callback
		function(err) { console.log('OpenSettins.settings error'); },
		// Native Class Name
		"OpenSettings",
		// Name of method in native class.
		"settings",
		// array of args to pass to method.
		[]
	);
};

OpenSettings.bluetooth = function (app, callback) {
	cordova.exec(
		// Success callback
		callback,
		// Failure callback
		function(err) { console.log('OpenSettins.bluetooth error'); },
		// Native Class Name
		"OpenSettings",
		// Name of method in native class.
		"bluetooth",
		// array of args to pass to method.
		[]
	);
};

OpenSettings.bluetoothStatus = function (app, callback) {
	cordova.exec(
		// Success callback
		callback,
		// Failure callback
		function(err) { console.log('OpenSettins.bluetoothStatus error'); },
		// Native Class Name
		"OpenSettings",
		// Name of method in native class.
		"bluetoothStatus",
		// array of args to pass to method.
		[]
	);
};

OpenSettings.bluetoothChange = function (callback) {
	cordova.exec(
		// Success callback
		callback,
		// Failure callback
		function(err) { console.log('OpenSettins.bluetoothChange error'); },
		// Native Class Name
		"OpenSettings",
		// Name of method in native class.
		"bluetoothChange",
		// array of args to pass to method.
		[]
	);
};

return OpenSettings;

});
