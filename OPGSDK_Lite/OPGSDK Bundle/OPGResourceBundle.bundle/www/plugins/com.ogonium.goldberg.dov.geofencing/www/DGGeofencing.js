cordova.define("com.ogonium.goldberg.dov.geofencing.DGGeofencing", function(require, exports, module) { /**
 * Geofencing.js
 *
 * Phonegap Geofencing Plugin
 * Copyright (c) Dov Goldberg 2014
 * http://www.ogonium.com
 * dov.goldberg@ogonium.com
 *
 */

function DGGeofencing() {
}

/*
 Params:
 NONE
 */
DGGeofencing.prototype.initCallbackForRegionMonitoring = function (params, success, fail) {
    return Cordova.exec(success, fail, "DGGeofencing", "initCallbackForRegionMonitoring", params);
};


/*
 Params:
 NONE
 */
DGGeofencing.prototype.startMonitoringSignificantLocationChanges = function (success, fail) {
    return Cordova.exec(success, fail, "DGGeofencing", "startMonitoringSignificantLocationChanges", []);
};

/*
 Params:
 NONE
 */
DGGeofencing.prototype.stopMonitoringSignificantLocationChanges = function (success, fail) {
    return Cordova.exec(success, fail, "DGGeofencing", "stopMonitoringSignificantLocationChanges", []);
};

DGGeofencing.install = function () {
    if (!window.plugins) {
        window.plugins = {};
    }

    window.plugins.DGGeofencing = new DGGeofencing();
    return window.plugins.DGGeofencing;
};

cordova.addConstructor(DGGeofencing.install);
});
