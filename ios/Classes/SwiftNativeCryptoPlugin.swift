//
//  NativeCryptoPlugin
//
//  Copyright (c) 2020
//  Author: Hugo Pointcheval
//
import Flutter

extension FlutterStandardTypedData {
  var uint8Array: Array<UInt8> {
    return Array(data)
  }
  var int8Array: Array<Int8> {
    return data.withUnsafeBytes { raw in
      [Int8](raw.bindMemory(to: Int8.self))
    }
  }
}

public class SwiftNativeCryptoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "native.crypto", binaryMessenger: registrar.messenger())
    let instance = SwiftNativeCryptoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "digest":
        let args = call.arguments as! NSDictionary
        
        let message = (args["message"] as! FlutterStandardTypedData).data
        let algo = args["algorithm"] as! String
        
        let algorithm : HashAlgorithm? = HashAlgorithm.init(rawValue: algo)
        
        let hash = Hash().digest(data: message, algorithm: algorithm!)
        
        if hash != nil {
            result(FlutterStandardTypedData.init(bytes: hash!))
        } else {
            result(FlutterError(code: "DIGESTERROR",
                                message: "DIGEST IS NIL.",
                                details: nil)
            )
        }
    case "pbkdf2":
        let args = call.arguments as! NSDictionary
        
        let password = args["password"] as! String
        let salt = args["salt"] as! String
        let keyLength = args["keyLength"] as! NSNumber
        let iteration = args["iteration"] as! NSNumber
        let algo = args["algorithm"] as! String
        
        let algorithm : HashAlgorithm? = HashAlgorithm.init(rawValue: algo)
        
        let key = KeyDerivation().pbkdf2(password: password, salt: salt, keyLength: keyLength.intValue, iteration: iteration.intValue, algorithm: algorithm!)
        
        if key != nil {
            result(FlutterStandardTypedData.init(bytes: key!))
        } else {
            result(FlutterError(code: "PBKDF2ERROR",
                                message: "PBKDF2 KEY IS NIL.",
                                details: nil)
            )
        }
    case "keygen":
        let args = call.arguments as! NSDictionary
        
        let size = args["size"] as! NSNumber
        
        let key = KeyGeneration().keygen(size: size)
        
        if key != nil {
            result(FlutterStandardTypedData.init(bytes: key!))
        } else {
            result(FlutterError(code: "KEYGENERROR",
                                message: "GENERATED KEY IS NIL.",
                                details: nil))
        }
    case "encrypt":
        let args = call.arguments as! NSDictionary
        
        let data = (args["data"] as! FlutterStandardTypedData).data
        let key = (args["key"] as! FlutterStandardTypedData).data
        let algo = args["algorithm"] as! String
        let mode = args["mode"] as! String
        let padding = args["padding"] as! String
        
        let algorithm : CipherAlgorithm? = CipherAlgorithm.init(rawValue: algo)
        let modeEnum : BlockCipherMode? = BlockCipherMode.init(rawValue: mode)
        let paddingEnum : Padding? = Padding.init(rawValue: padding)
        
        let ciphertext = Cipher().encrypt(data: data, key: key, algorithm: algorithm!, mode: modeEnum!, padding: paddingEnum!)
        
        if ciphertext != nil {
            result(ciphertext)
        } else {
            result(FlutterError(code: "ENCRYPTIONERROR",
                                message: "ENCRYPTED PAYLOAD IS EMPTY.",
                                details: nil))
        }
    case "decrypt":
        let args = call.arguments as! NSDictionary
        
        let payload = args["payload"] as! NSArray
        let key = (args["key"] as! FlutterStandardTypedData).data
        let algo = args["algorithm"] as! String
        let mode = args["mode"] as! String
        let padding = args["padding"] as! String
        
        let encrypted = (payload[0] as! FlutterStandardTypedData).data
        let iv = (payload[1] as! FlutterStandardTypedData).data
        let encryptedPayload = [encrypted, iv]
        
        let algorithm : CipherAlgorithm? = CipherAlgorithm.init(rawValue: algo)
        let modeEnum : BlockCipherMode? = BlockCipherMode.init(rawValue: mode)
        let paddingEnum : Padding? = Padding.init(rawValue: padding)
                
        let decrypted = Cipher().decrypt(payload: encryptedPayload, key: key, algorithm: algorithm!, mode: modeEnum!, padding: paddingEnum!)
        
        if decrypted != nil {
            result(FlutterStandardTypedData.init(bytes: decrypted!))
        } else {
            result(FlutterError(code: "DECRYPTIONERROR",
                                message: "DECRYPTED PAYLOAD IS NIL. MAYBE VERIFICATION MAC IS UNVALID.",
                                details: nil))
        }
    default: result(FlutterMethodNotImplemented)
    }
  }
}
