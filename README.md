# cordova-plugin-audioroute

**This plugin works on iOS only.**

This plugin allows applications to get notified audio about route changes (for example when a headset is connected),
and also to query and override the audio device in use.


## Installation

The plugin can be installed using the Cordova CLI tool:

    cordova plugin add cordova-plugin-audioroute --save


## API

All these functions are available in the `cordova.plugins.audioroute` namespace.

### currentOutputs(succesCallback, errorCallback)

Get an Array of the currently connected audio ports. The possible elements are:

* line-out
* headphones
* bluetooth-a2dp
* builtin-receiver
* builtin-speaker
* hdmi
* airplay
* bluetooth-le
* unknown

## overrideOutput(output, successCallback, errorCallback)

Overrides the audio ouput device. `options` must be one of `default` or `speaker`.

## "audioroute-changed" event

When the audio route has changed a 'audioroute-changed' event will be fired in `document`.
It contains the reason as associated data, which can be one of:

* unknown
* new-device-available
* old-device-unavailable
* category-change
* override
* wake-from-sleep
* no-suitable-route-for-category
* route-config-change

Example:

    document.addEventListener('audioroute-changed',
                              function(reason) {
                                  console.log('Audio route changed: ' + reason);
                              });


## License

MIT


## Author

Saúl Ibarra Corretgé <saghul@gmail.com>

This work has been sponsored by [AG Projects](http://ag-projects.com).
