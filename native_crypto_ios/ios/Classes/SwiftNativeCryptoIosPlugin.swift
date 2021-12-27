import Flutter
import UIKit

@available(iOS 13.0, *)
public class SwiftNativeCryptoIosPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "plugins.hugop.cl/native_crypto", binaryMessenger: registrar.messenger())
    let instance = SwiftNativeCryptoIosPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "digest":
        let args : NSDictionary = call.arguments as! NSDictionary
        
        let data : Data = (args["data"] as! FlutterStandardTypedData).data
        let algo : String = args["algorithm"] as! String
        let algorithm : HashAlgorithm? = HashAlgorithm.init(rawValue: algo)
        // TODO(hpcl): check if algorithm is null
        // TODO(hpcl): check if digest is null
        result(FlutterStandardTypedData.init(bytes: Hash.digest(data: data, algorithm: algorithm!)))
    case "generateSecretKey":
        let args : NSDictionary = call.arguments as! NSDictionary
        
        let bitsCount : NSNumber = args["bitsCount"] as! NSNumber
        // TODO(hpcl): check if secure random is null
        result(FlutterStandardTypedData.init(bytes: Key.fromSecureRandom(bitsCount: bitsCount.intValue)))
    case "generateKeyPair":
        result(FlutterStandardTypedData.init(bytes: KeyPair.fromCurve()))
    case "pbkdf2":
        let args : NSDictionary = call.arguments as! NSDictionary
        
        let password : String = args["password"] as! String
        let salt : String = args["salt"] as! String
        let keyBytesCount : NSNumber = args["keyBytesCount"] as! NSNumber
        let iterations : NSNumber = args["iterations"] as! NSNumber
        let algo : String = args["algorithm"] as! String
        let algorithm : HashAlgorithm? = HashAlgorithm.init(rawValue: algo)
        // TODO(hpcl): check if algorithm is null
        // TODO(hpcl): check if derivation is null
        result(FlutterStandardTypedData.init(bytes: Key.fromPBKDF2(password: password, salt: salt, keyBytesCount: keyBytesCount.intValue, iterations: iterations.intValue, algorithm: algorithm!)!))
    case "encrypt":
        let args : NSDictionary = call.arguments as! NSDictionary
        
        let data : Data = (args["data"] as! FlutterStandardTypedData).data
        let key : Data = (args["key"] as! FlutterStandardTypedData).data
        let algo : String = args["algorithm"] as! String
        // TODO(hpcl): check if algorithm is null
        // TODO(hpcl): check if ciphertext is null
        var ciphertext : Data
        switch algo {
        case "aes":
            ciphertext = AESCipher.encrypt(plaintext: data, key: key)!
        case "chachapoly":
            ciphertext = CHACHACipher.encrypt(plaintext: data, key: key)!
        default:
            ciphertext = Data.init();
        }
        result(FlutterStandardTypedData.init(bytes: ciphertext))
    case "decrypt":
        let args : NSDictionary = call.arguments as! NSDictionary
        
        let data : Data = (args["data"] as! FlutterStandardTypedData).data
        let key : Data = (args["key"] as! FlutterStandardTypedData).data
        let algo : String = args["algorithm"] as! String
        // TODO(hpcl): check if algorithm is null
        // TODO(hpcl): check if ciphertext is null
        var ciphertext : Data
        switch algo {
        case "aes":
            ciphertext = AESCipher.decrypt(ciphertext: data, key: key)!
        case "chachapoly":
            ciphertext = CHACHACipher.decrypt(ciphertext: data, key: key)!
        default:
            ciphertext = Data.init();
        }
        result(FlutterStandardTypedData.init(bytes: ciphertext))
    case "generateSharedSecretKey":
        let args : NSDictionary = call.arguments as! NSDictionary
        
        let salt : Data = (args["salt"] as! FlutterStandardTypedData).data
        let keyBytesCount : NSNumber = args["keyBytesCount"] as! NSNumber
        let ephemeralPrivateKey : Data = (args["ephemeralPrivateKey"] as! FlutterStandardTypedData).data
        let otherPublicKey : Data = (args["otherPublicKey"] as! FlutterStandardTypedData).data
        let hkdfAlgorithm : String = args["hkdfAlgorithm"] as! String
        let algorithm : HashAlgorithm? = HashAlgorithm.init(rawValue: hkdfAlgorithm)
        // TODO(hpcl): check if algorithm is null
        // TODO(hpcl): check if generated key is null
        result(FlutterStandardTypedData.init(bytes: ECDH.generateSharedSecretKey(salt: salt, hash: algorithm!, keyBytesCount: keyBytesCount.intValue, privateKey: ephemeralPrivateKey, publicKey: otherPublicKey)!))
    
    default: result(FlutterMethodNotImplemented)
    }
  }
}
