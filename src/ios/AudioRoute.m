#import "AudioRoute.h"

@implementation AudioRoute

NSString *const kLineOut         = @"line-out";
NSString *const kHeadphones      = @"headphones";
NSString *const kBluetoothA2DP   = @"bluetooth-a2dp";
NSString *const kBuiltinReceiver = @"builtin-receiver";
NSString *const kBuiltinSpeaker  = @"builtin-speaker";
NSString *const kHdmi            = @"hdmi";
NSString *const kAirPlay         = @"airplay";
NSString *const kBluetoothLE     = @"bluetooth-le";
NSString *const kBluetoothHFP    = @"bluetooth-hfp";
NSString *const kUnknown         = @"unknown";

NSString *const kNewDeviceAvailable         = @"new-device-available";
NSString *const kOldDeviceUnavailable       = @"old-device-unavailable";
NSString *const kCategoryChange             = @"category-change";
NSString *const kOverride                   = @"override";
NSString *const kWakeFromSleep              = @"wake-from-sleep";
NSString *const kNoSuitableRouteForCategory = @"no-suitable-route-for-category";
NSString *const kRouteConfigurationChange   = @"route-config-change";


- (void)pluginInitialize {
    NSLog(@"Initializing AudioRoute plugin");
    callbackId = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(routeChange:)
                                          name:AVAudioSessionRouteChangeNotification
                                          object:nil];
    NSLog(@"AudioRoute plugin initialized");
}


- (void)routeChange:(NSNotification*)notification {
    if (callbackId != nil) {
        CDVPluginResult* pluginResult;
        NSString* reason;
        NSDictionary* dict = notification.userInfo;
        NSInteger routeChangeReason = [[dict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];

        switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            reason = kNewDeviceAvailable;
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            reason = kOldDeviceUnavailable;
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            reason = kCategoryChange;
            break;
        case AVAudioSessionRouteChangeReasonOverride:
            reason = kOverride;
            break;
        case AVAudioSessionRouteChangeReasonWakeFromSleep:
            reason = kWakeFromSleep;
            break;
        case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory:
            reason = kNoSuitableRouteForCategory;
            break;
        case AVAudioSessionRouteChangeReasonRouteConfigurationChange:
            reason = kRouteConfigurationChange;
            break;
        default:
            reason = kUnknown;
            break;
        }

        NSLog(@"[AudioRoute]routeChange, %@, %ld", reason, (long)routeChangeReason);

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:reason];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    }
}


- (void) setRouteChangeCallback:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    callbackId = command.callbackId;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void) currentOutputs:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    NSMutableArray* outputs = [NSMutableArray array];

    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        NSString* portType = [desc portType];
        NSLog(@"[AudioRoute]currentOutputs, portType %@, %@", portType, desc);
        if ([portType isEqualToString:AVAudioSessionPortLineOut]) {
            [outputs addObject:kLineOut];
        } else if ([portType isEqualToString:AVAudioSessionPortHeadphones]) {
            [outputs addObject:kHeadphones];
        } else if ([portType isEqualToString:AVAudioSessionPortBluetoothA2DP]) {
            [outputs addObject:kBluetoothA2DP];
        } else if ([portType isEqualToString:AVAudioSessionPortBuiltInReceiver]) {
            [outputs addObject:kBuiltinReceiver];
        } else if ([portType isEqualToString:AVAudioSessionPortBuiltInSpeaker]) {
            [outputs addObject:kBuiltinSpeaker];
        } else if ([portType isEqualToString:AVAudioSessionPortHDMI]) {
            [outputs addObject:kHdmi];
        } else if ([portType isEqualToString:AVAudioSessionPortAirPlay]) {
            [outputs addObject:kAirPlay];
        } else if ([portType isEqualToString:AVAudioSessionPortBluetoothLE]) {
            [outputs addObject:kBluetoothLE];
        } else if ([portType isEqualToString:AVAudioSessionPortBluetoothHFP]) {
            [outputs addObject:kBluetoothHFP];
        } else {
            [outputs addObject:kUnknown];
        }
    }

    NSLog(@"[AudioRoute]currentOutputs, %@", outputs);

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:[outputs copy]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void) overrideOutput:(CDVInvokedUrlCommand*)command {
    // make it async, cause in latest IOS it started to take ~1 sec and produce UI thread blocking issues
    [self.commandDelegate runInBackground:^{

    CDVPluginResult* pluginResult;
    NSString* output = [command.arguments objectAtIndex:0];
    BOOL success;
    NSError* error;

    AVAudioSession* session = [AVAudioSession sharedInstance];

    // make sure the AVAudioSession is properly configured
    [session setActive: YES error: nil];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];

    if (output != nil) {
        if ([output isEqualToString:@"speaker"]) {
            success = [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
        } else {
            success = [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:&error];
        }
        if (success) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"'output' was null"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];
}

@end
