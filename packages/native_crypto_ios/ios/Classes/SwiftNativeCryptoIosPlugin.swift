import Flutter
import UIKit

@available(iOS 13.0, *)
public class SwiftNativeCryptoIosPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger : FlutterBinaryMessenger = registrar.messenger()
        let api : NativeCryptoAPI & NSObjectProtocol = NativeCrypto.init()
        NativeCryptoAPISetup.setUp(binaryMessenger: messenger, api: api);
    }
}
