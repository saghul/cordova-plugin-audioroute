
function AudioRoute() {
}

AudioRoute.prototype.currentOutputs = function(successCallback, errorCallback) {
    cordova.exec(successCallback, errorCallback, 'AudioRoute', 'currentOutputs', []);
};

AudioRoute.prototype.overrideOutput = function(output, successCallback, errorCallback) {
    if (output !== 'default' && output !== 'speaker') {
        throw new Error('output must be one of "default" or "speaker"');
    }
    cordova.exec(successCallback, errorCallback, 'AudioRoute', 'overrideOutput', [output]);
};

var audioRoute = new AudioRoute();
module.exports = audioRoute;
