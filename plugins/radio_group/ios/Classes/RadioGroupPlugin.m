#import "RadioGroupPlugin.h"
#if __has_include(<radio_group/radio_group-Swift.h>)
#import <radio_group/radio_group-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "radio_group-Swift.h"
#endif

@implementation RadioGroupPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRadioGroupPlugin registerWithRegistrar:registrar];
}
@end
