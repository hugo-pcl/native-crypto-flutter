//
//  NativeCrypto.swift
//  native_crypto_ios
//
//  Created by Hugo Pointcheval on 04/04/2023.
//

import Foundation
import CryptoKit

public class NativeCrypto: NSObject, NativeCryptoAPI {
    func hash(data: FlutterStandardTypedData, algorithm: HashAlgorithm) throws -> FlutterStandardTypedData? {
        var md = HashAlgorithmParser.getMessageDigest(algorithm: algorithm)
        md.update(data: data.data)

        let bytes = Data(md.finalize())
        
        return FlutterStandardTypedData(bytes: bytes)
    }
    
    func hmac(data: FlutterStandardTypedData, key: FlutterStandardTypedData, algorithm: HashAlgorithm) throws -> FlutterStandardTypedData? {
        let symmetricKey : SymmetricKey = SymmetricKey.init(data: key.data)
        
        switch algorithm {
        case .sha256: return FlutterStandardTypedData(bytes: Data(HMAC<SHA256>(key: symmetricKey).finalize()))
        case .sha384: return FlutterStandardTypedData(bytes: Data(HMAC<SHA384>(key: symmetricKey).finalize()))
        case .sha512: return FlutterStandardTypedData(bytes: Data(HMAC<SHA512>(key: symmetricKey).finalize()))
        }
    }
    
    func generateSecureRandom(length: Int64) throws -> FlutterStandardTypedData? {
        let lengthInt = Int(truncatingIfNeeded: length)
        let bitCount = lengthInt * 8
        let symmetricKey = SymmetricKey.init(size: SymmetricKeySize(bitCount: bitCount))
        let bytes = symmetricKey.withUnsafeBytes
        {
            return Data(Array($0))
        }
        
        return FlutterStandardTypedData(bytes: bytes)
    }
    
    func pbkdf2(password: FlutterStandardTypedData, salt: FlutterStandardTypedData, length: Int64, iterations: Int64, algorithm: HashAlgorithm) throws -> FlutterStandardTypedData? {
        let lengthInt = Int(truncatingIfNeeded: length)
        let iterationsInt = Int(truncatingIfNeeded: iterations)
        let pbkdf2 = Pbkdf2(length: lengthInt, iterations: iterationsInt, hashAlgorithm: algorithm)
        pbkdf2.initialize(password: password.data, salt: salt.data)
        let data = try? pbkdf2.derive()
        
        if (data == nil) {
            return nil
        }
        
        return FlutterStandardTypedData(bytes: data!)
    }
    
    func encrypt(plainText: FlutterStandardTypedData, key: FlutterStandardTypedData, algorithm: CipherAlgorithm) throws -> FlutterStandardTypedData? {
        let aes = AESCipher()
        let bytes = try? aes.encrypt(data: plainText.data, key: key.data, predefinedIV: nil)
        
        if (bytes == nil) {
            return nil
        }
        
        return FlutterStandardTypedData(bytes: bytes!)
    }
    
    func encryptWithIV(plainText: FlutterStandardTypedData, iv: FlutterStandardTypedData, key: FlutterStandardTypedData, algorithm: CipherAlgorithm) throws -> FlutterStandardTypedData? {
        let aes = AESCipher()
        let bytes = try? aes.encrypt(data: plainText.data, key: key.data, predefinedIV: iv.data)
        
        if (bytes == nil) {
            return nil
        }
        
        return FlutterStandardTypedData(bytes: bytes!)
    }
    
    func decrypt(cipherText: FlutterStandardTypedData, key: FlutterStandardTypedData, algorithm: CipherAlgorithm) throws -> FlutterStandardTypedData? {
        let aes = AESCipher()
        let bytes = try? aes.decrypt(data: cipherText.data, key: key.data)
        
        if (bytes == nil) {
            return nil
        }
        
        return FlutterStandardTypedData(bytes: bytes!)
    }
    
    func encryptFile(plainTextPath: String, cipherTextPath: String, key: FlutterStandardTypedData, algorithm: CipherAlgorithm) throws -> Bool? {
        let aes = AESCipher()
        let params = FileParameters(input: plainTextPath, output: cipherTextPath)
        let success = try? aes.encryptFile(fileParameters: params, key: key.data, predefinedIV: nil)
        
        return success
    }
    
    func encryptFileWithIV(plainTextPath: String, cipherTextPath: String, iv: FlutterStandardTypedData, key: FlutterStandardTypedData, algorithm: CipherAlgorithm) throws -> Bool? {
        let aes = AESCipher()
        let params = FileParameters(input: plainTextPath, output: cipherTextPath)
        let success = try? aes.encryptFile(fileParameters: params, key: key.data, predefinedIV: iv.data)
        
        return success
    }
    
    func decryptFile(cipherTextPath: String, plainTextPath: String, key: FlutterStandardTypedData, algorithm: CipherAlgorithm) throws -> Bool? {
        let aes = AESCipher()
        let params = FileParameters(input: cipherTextPath, output: plainTextPath)
        let success = try? aes.decryptFile(fileParameters: params, key: key.data)
        
        return success
    }
}
