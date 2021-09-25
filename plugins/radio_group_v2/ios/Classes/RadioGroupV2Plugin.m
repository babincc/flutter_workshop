#import "RadioGroupV2Plugin.h"
#if __has_include(<radio_group_v2/radio_group_v2-Swift.h>)
#import <radio_group_v2/radio_group_v2-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "radio_group_v2-Swift.h"
#endif

@implementation RadioGroupV2Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRadioGroupV2Plugin registerWithRegistrar:registrar];
}
@end
