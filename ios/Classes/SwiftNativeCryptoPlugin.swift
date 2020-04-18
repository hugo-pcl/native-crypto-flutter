//
//  NativeCryptoPlugin
//
//  Copyright (c) 2020
//  Author: Hugo Pointcheval
//
import Flutter
import UIKit
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

func pbkdf2(hash: CCPBKDFAlgorithm, password: String, salt: String, keyByteCount: Int, rounds: Int) -> Data? {
    let passwordData = password.data(using: .utf8)!
    let saltData = salt.data(using: .utf8)!
    var derivedKeyData = Data(repeating: 0, count: keyByteCount)
    
    var localDerivedKeyData = derivedKeyData
    
    let derivationStatus = derivedKeyData.withUnsafeMutableBytes { derivedKeyBytes in
        saltData.withUnsafeBytes { saltBytes in
            
            CCKeyDerivationPBKDF(
                CCPBKDFAlgorithm(kCCPBKDF2),
                password, passwordData.count,
                saltBytes, saltData.count,
                hash,
                UInt32(rounds),
                derivedKeyBytes, localDerivedKeyData.count)
        }
    }
    if (derivationStatus != kCCSuccess) {
        print("Error: \(derivationStatus)")
        return nil;
    }
    
    return derivedKeyData
}

func pbkdf2sha256(password: String, salt: String, keyByteCount: Int, rounds: Int) -> Data? {
    return pbkdf2(hash: CCPBKDFAlgorithm(kCCPRFHmacAlgSHA256), password: password, salt: salt, keyByteCount: keyByteCount, rounds: rounds)
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
    
    enum Algorithm {
        case sha256
        
        var digestLength: Int {
            switch self {
            case .sha256: return Int(CC_SHA256_DIGEST_LENGTH)
            }
        }
    }
    
    func hash(for algorithm: Algorithm) -> Data {
        let hashBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: algorithm.digestLength)
        defer { hashBytes.deallocate() }
        switch algorithm {
        case .sha256:
            withUnsafeBytes { (buffer) -> Void in
                CC_SHA256(buffer.baseAddress!, CC_LONG(buffer.count), hashBytes)
            }
        }
        
        return Data(bytes: hashBytes, count: algorithm.digestLength)
    }

}

public class SwiftNativeCryptoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "native.crypto.helper", binaryMessenger: registrar.messenger())
    let instance = SwiftNativeCryptoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "pbkdf2":
        let args = call.arguments as! NSDictionary
        let password = args["password"] as! String
        let salt = args["salt"] as! String
        let keyLength = args["keyLength"] as! NSNumber
        let iteration = args["iteration"] as! NSNumber
        
        let keyBytes = pbkdf2sha256(password: password, salt: salt, keyByteCount: keyLength.intValue, rounds: iteration.intValue)
        
        if keyBytes != nil {
            result(FlutterStandardTypedData.init(bytes: keyBytes!))
        } else {
            result(FlutterError(code: "PBKDF2ERROR",
                                message: "PBKDF2 KEY IS NIL.",
                                details: nil))
        }
        
                    
    case "symKeygen":
        let args = call.arguments as! NSDictionary
        let keySize = args["size"] as! NSNumber
        
        let keyBytes = symKeygen(keySize: keySize)
        
        if keyBytes != nil {
            result(FlutterStandardTypedData.init(bytes: keyBytes!))
        } else {
            result(FlutterError(code: "SYMKEYGENERROR",
                                message: "GENERATED KEY IS NIL.",
                                details: nil))
        }

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
        
        if decryptedPayload != nil {
            result(FlutterStandardTypedData.init(bytes: decryptedPayload!))
        } else {
            result(FlutterError(code: "DECRYPTIONERROR",
                                message: "DECRYPTED PAYLOAD IS NIL. MAYBE VERIFICATION MAC IS UNVALID.",
                                details: nil))
        }
        
    default: result(FlutterMethodNotImplemented)
        
    }
  }
    
    func digest(input : Data) -> Data {
        let hashed = input.hash(for: .sha256)
        return hashed
    }
    
    func symKeygen(keySize : NSNumber) -> Data? {
        var bytes = [Int8](repeating: 0, count: keySize.intValue / 8)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)

        if status == errSecSuccess { // Always test the status.
            let keyBytes = bytes.withUnsafeBytes {return Data(Array($0))}
            return keyBytes
        }
        return nil
    }
    
    func symEncrypt(payload : Data, aesKey : Data) -> [Data] {
        let mac = digest(input: aesKey + payload)
        let dataToEncrypt = mac + payload
        var encrypted = dataToEncrypt.encryptAES256_CBC_PKCS7_IV(key: aesKey)!
        
        // Create a range based on the length of data to return
        let range = 0..<16

        // Get a new copy of data
        let iv = encrypted.subdata(in: range)
        
        encrypted.removeSubrange(range)
        
        return [encrypted, iv]
    }
    
    func symDecrypt(payload : [Data], aesKey : Data) -> Data? {
        let encrypted = payload[1] + payload[0]
        var decrypted = encrypted.decryptAES256_CBC_PKCS7_IV(key: aesKey)!
        
        // Create a range based on the length of data to return
        let range = 0..<32

        // Get a new copy of data
        let mac = decrypted.subdata(in: range)
        decrypted.removeSubrange(range)
        
        let verificationMac = digest(input: aesKey + decrypted)
        
        if (mac.base64EncodedData() == verificationMac.base64EncodedData()) {
            return decrypted
        } else {
            return nil
        }
    }
}
