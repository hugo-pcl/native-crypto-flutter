import Flutter
import UIKit

@available(iOS 13.0, *)
public class SwiftNativeCryptoIosPlugin: NSObject, FlutterPlugin {
    static let name: String = "plugins.hugop.cl/native_crypto"
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: name, binaryMessenger: registrar.messenger())
        let instance = SwiftNativeCryptoIosPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "digest": _call(task: handleDigest(call: call), result: result)
        case "generateSecretKey": _call(task: handleGenerateSecretKey(call: call), result: result)
        case "pbkdf2": _call(task: handlePbkdf2(call: call), result: result)
        case "encryptAsList": _call(task: handleEncryptAsList(call: call), result: result)
        case "decryptAsList": _call(task: handleDecryptAsList(call: call), result: result)
        case "encrypt": _call(task: handleCrypt(call: call, forEncryption: true), result: result)
        case "decrypt": _call(task: handleCrypt(call: call, forEncryption: false), result: result)
        default: result(FlutterMethodNotImplemented)
        }
    }
    
    private func _call<T>(task: Task<T>, result: @escaping FlutterResult) {
        task.call()
        task.finalize(callback: {(task: Task<T>) in
            if (task.isSuccessful()) {
                result(task.getResult()!)
            } else {
                let exception: Error = task.getException()
                let message = exception.localizedDescription
                result(FlutterError(code: "native_crypto", message: message, details: nil))
            }
        })
    }
    
    private func handleDigest(call: FlutterMethodCall) -> Task<FlutterStandardTypedData> {
        return Task(task: {
            let args : NSDictionary = call.arguments as! NSDictionary
            
            let data : Data = (args["data"] as! FlutterStandardTypedData).data
            let algorithm : String = args["algorithm"] as! String
            
            return FlutterStandardTypedData.init(bytes: try HashAlgorithm.digest(data: data, algorithm: algorithm))
        })
    }
    
    private func handleGenerateSecretKey(call: FlutterMethodCall) -> Task<FlutterStandardTypedData> {
        return Task(task: {
            let args : NSDictionary = call.arguments as! NSDictionary
            
            let bitsCount : NSNumber = args["bitsCount"] as! NSNumber
            
            return FlutterStandardTypedData.init(bytes: SecretKey(fromSecureRandom: bitsCount.intValue).bytes)
        })
    }
    
    private func handlePbkdf2(call: FlutterMethodCall) -> Task<FlutterStandardTypedData> {
        return Task(task: {
            let args : NSDictionary = call.arguments as! NSDictionary
            
            let password : String = args["password"] as! String
            let salt : String = args["salt"] as! String
            let keyBytesCount : NSNumber = args["keyBytesCount"] as! NSNumber
            let iterations : NSNumber = args["iterations"] as! NSNumber
            let algorithm : String = args["algorithm"] as! String
            
            let pbkdf2 : Pbkdf2 = Pbkdf2(keyBytesCount: keyBytesCount.intValue, iterations: iterations.intValue)
            pbkdf2.hash = HashAlgorithm.init(rawValue: algorithm) ?? pbkdf2.hash
            pbkdf2.initialize(password: password, salt: salt)
            
            return FlutterStandardTypedData.init(bytes: try pbkdf2.derive().bytes)
        })
    }
    
    private func handleEncryptAsList(call: FlutterMethodCall) -> Task<Array<Data>> {
        return Task(task: {
            let args : NSDictionary = call.arguments as! NSDictionary
            
            let data : Data = (args["data"] as! FlutterStandardTypedData).data
            let key : Data = (args["key"] as! FlutterStandardTypedData).data
            let algorithm : String = args["algorithm"] as! String
            
            let cipherAlgorithm : CipherAlgorithm? = CipherAlgorithm.init(rawValue: algorithm)
            var cipher : Cipher
            if (cipherAlgorithm != nil) {
                cipher = cipherAlgorithm!.getCipher
            } else {
                throw NativeCryptoError.cipherError
            }
            
            return try cipher.encryptAsList(data: data, key: key)
        })
    }
    
    private func handleDecryptAsList(call: FlutterMethodCall) -> Task<FlutterStandardTypedData> {
        return Task(task: {
            let args : NSDictionary = call.arguments as! NSDictionary
            
            let data = args["data"] as! NSArray
            let key : Data = (args["key"] as! FlutterStandardTypedData).data
            let algorithm : String = args["algorithm"] as! String
            
            let iv = (data[0] as! FlutterStandardTypedData).data
            let encrypted = (data[1] as! FlutterStandardTypedData).data
            
            let cipherAlgorithm : CipherAlgorithm? = CipherAlgorithm.init(rawValue: algorithm)
            var cipher : Cipher
            if (cipherAlgorithm != nil) {
                cipher = cipherAlgorithm!.getCipher
            } else {
                throw NativeCryptoError.cipherError
            }
            
            return FlutterStandardTypedData.init(bytes: try cipher.decryptAsList(data: [iv, encrypted], key: key))
        })
    }
    
    private func handleCrypt(call: FlutterMethodCall, forEncryption: Bool) -> Task<FlutterStandardTypedData> {
        return Task(task: {
            let args : NSDictionary = call.arguments as! NSDictionary
            
            let data : Data = (args["data"] as! FlutterStandardTypedData).data
            let key : Data = (args["key"] as! FlutterStandardTypedData).data
            let algorithm : String = args["algorithm"] as! String
            
            let cipherAlgorithm : CipherAlgorithm? = CipherAlgorithm.init(rawValue: algorithm)
            var cipher : Cipher
            if (cipherAlgorithm != nil) {
                cipher = cipherAlgorithm!.getCipher
            } else {
                throw NativeCryptoError.cipherError
            }
            
            if (forEncryption) {
                return FlutterStandardTypedData.init(bytes: try cipher.encrypt(data: data, key: key))
            } else {
                return FlutterStandardTypedData.init(bytes: try cipher.decrypt(data: data, key: key))
            }
        })
    }
    
}
