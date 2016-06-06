
function AudioRoute() {
}

AudioRoute.prototype.currentOutputs = function (successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, 'AudioRoute', 'currentOutputs', []);
};


var audioRoute = new AudioRoute();
module.exports = audioRoute;
