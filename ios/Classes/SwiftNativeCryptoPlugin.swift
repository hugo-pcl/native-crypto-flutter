import Flutter
import UIKit
import CryptoKit
import Foundation
import CommonCrypto

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

func crypt(operation: Int, algorithm: Int, options: Int, key: Data,
        initializationVector: Data, dataIn: Data) -> Data? {
    return key.withUnsafeBytes { keyUnsafeRawBufferPointer in
        return dataIn.withUnsafeBytes { dataInUnsafeRawBufferPointer in
            return initializationVector.withUnsafeBytes { ivUnsafeRawBufferPointer in
                // Give the data out some breathing room for PKCS7's padding.
                let dataOutSize: Int = dataIn.count + kCCBlockSizeAES128*2
                let dataOut = UnsafeMutableRawPointer.allocate(byteCount: dataOutSize,
                    alignment: 1)
                defer { dataOut.deallocate() }
                var dataOutMoved: Int = 0
                let status = CCCrypt(CCOperation(operation), CCAlgorithm(algorithm),
                    CCOptions(options),
                    keyUnsafeRawBufferPointer.baseAddress, key.count,
                    ivUnsafeRawBufferPointer.baseAddress,
                    dataInUnsafeRawBufferPointer.baseAddress, dataIn.count,
                    dataOut, dataOutSize, &dataOutMoved)
                guard status == kCCSuccess else { return nil }
                return Data(bytes: dataOut, count: dataOutMoved)
            }
        }
    }
}

func randomGenerateBytes(count: Int) -> Data? {
    let bytes = UnsafeMutableRawPointer.allocate(byteCount: count, alignment: 1)
    defer { bytes.deallocate() }
    let status = CCRandomGenerateBytes(bytes, count)
    guard status == kCCSuccess else { return nil }
    return Data(bytes: bytes, count: count)
}

extension Data {
    /// Encrypts for you with all the good options turned on: CBC, an IV, PKCS7
    /// padding (so your input data doesn't have to be any particular length).
    /// Key can be 128, 192, or 256 bits.
    /// Generates a fresh IV for you each time, and prefixes it to the
    /// returned ciphertext.
    func encryptAES256_CBC_PKCS7_IV(key: Data) -> Data? {
        guard let iv = randomGenerateBytes(count: kCCBlockSizeAES128) else { return nil }
        // No option is needed for CBC, it is on by default.
        guard let ciphertext = crypt(operation: kCCEncrypt,
                                    algorithm: kCCAlgorithmAES,
                                    options: kCCOptionPKCS7Padding,
                                    key: key,
                                    initializationVector: iv,
                                    dataIn: self) else { return nil }
        return iv + ciphertext
    }
    
    /// Decrypts self, where self is the IV then the ciphertext.
    /// Key can be 128/192/256 bits.
    func decryptAES256_CBC_PKCS7_IV(key: Data) -> Data? {
        guard count > kCCBlockSizeAES128 else { return nil }
        let iv = prefix(kCCBlockSizeAES128)
        let ciphertext = suffix(from: kCCBlockSizeAES128)
        return crypt(operation: kCCDecrypt, algorithm: kCCAlgorithmAES,
            options: kCCOptionPKCS7Padding, key: key, initializationVector: iv,
            dataIn: ciphertext)
    }
}

@available(iOS 13.0, *)
public class SwiftNativeCryptoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "native.crypto.helper", binaryMessenger: registrar.messenger())
    let instance = SwiftNativeCryptoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "symKeygen":
        
        let keyBytes = symKeygen()
        
        result(FlutterStandardTypedData.init(bytes: keyBytes))

    case "symEncrypt":
        let args = call.arguments as! NSDictionary
        let payload = (args["payload"] as! FlutterStandardTypedData).data
        let aesKey = (args["aesKey"] as! FlutterStandardTypedData).data
        let encryptedPayloadIV = symEncrypt(payload: payload, aesKey: aesKey)
        
        result(encryptedPayloadIV)
    
    case "symDecrypt":
        let args = call.arguments as! NSDictionary
        let payload = args["payload"] as! NSArray
        
        let encrypted = (payload[0] as! FlutterStandardTypedData).data
        let iv = (payload[1] as! FlutterStandardTypedData).data
        let encryptedPayload = [encrypted, iv]
        
        let aesKey = (args["aesKey"] as! FlutterStandardTypedData).data
        let decryptedPayload = symDecrypt(payload: encryptedPayload, aesKey: aesKey)
        
        result(decryptedPayload)
        
    default: result(FlutterMethodNotImplemented)
        
    }
  }
    
    func symKeygen() -> Data {
        let key = SymmetricKey(size: .bits256)
        let keyBytes = key.withUnsafeBytes {return Data(Array($0))}
        return keyBytes
    }
    
    func symEncrypt(payload : Data, aesKey : Data) -> [Data] {
        var encrypted = payload.encryptAES256_CBC_PKCS7_IV(key: aesKey)!
        
        // Create a range based on the length of data to return
        let range = 0..<16

        // Get a new copy of data
        let iv = encrypted.subdata(in: range)
        
        encrypted.removeSubrange(range)
        
        return [encrypted, iv]
    }
    
    func symDecrypt(payload : [Data], aesKey : Data) -> Data {
        let encrypted = payload[1] + payload[0]
        let decrypted = encrypted.decryptAES256_CBC_PKCS7_IV(key: aesKey)!
        
        return decrypted
    }
    
}
