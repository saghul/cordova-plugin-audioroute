#import <AVFoundation/AVFoundation.h>
#import <Cordova/CDV.h>

@interface AudioRoute :CDVPlugin {
    NSString* callbackId;
}

- (void) currentOutputs:(CDVInvokedUrlCommand*)command;
- (void) overrideOutput:(CDVInvokedUrlCommand*)command;
- (void) setRouteChangeCallback:(CDVInvokedUrlCommand*)command;

@end
