#import <AVFoundation/AVFoundation.h>
#import <Cordova/CDV.h>

@interface AudioRoute :CDVPlugin

- (void) currentOutputs:(CDVInvokedUrlCommand*)command;

@end
