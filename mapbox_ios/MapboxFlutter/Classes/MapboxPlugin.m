#import "MapboxPlugin.h"
#if __has_include(<MapboxFlutter/MapboxFlutter-Swift.h>)
#import <MapboxFlutter/MapboxFlutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "MapboxFlutter-Swift.h"
#endif

@implementation MapboxPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [MapboxFlutterPlugin registerWithRegistrar:registrar];
}
@end
