#import "RaveFlutterPlugin.h"
#import <rave_flutter/rave_flutter-Swift.h>

@implementation RaveFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRaveFlutterPlugin registerWithRegistrar:registrar];
}
@end
