#import "NativeCryptoIosPlugin.h"
#if __has_include(<native_crypto_ios/native_crypto_ios-Swift.h>)
#import <native_crypto_ios/native_crypto_ios-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "native_crypto_ios-Swift.h"
#endif

@implementation NativeCryptoIosPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNativeCryptoIosPlugin registerWithRegistrar:registrar];
}
@end
