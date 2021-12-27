/**
 * Author: Hugo Pointcheval
 * Email: git@pcl.ovh
 * -----
 * File: KDF.swift
 * Created Date: 25/12/2021 17:45:28
 * Last Modified: 25/12/2021 17:45:38
 * -----
 * Copyright (c) 2021
 */

import Foundation
import CryptoKit
import CommonCrypto

class Key {
    /// Generate secret key of a specified length
    @available(iOS 13.0, *)
    static func fromSecureRandom(bitsCount : Int) -> Data {
        let symmetricKey = SymmetricKey.init(size: SymmetricKeySize(bitCount: bitsCount))
        return toBytes(key: symmetricKey)
    }
    
    /// Encode key as Data
    @available(iOS 13.0, *)
    static func toBytes(key: SymmetricKey) -> Data {
        let keyBytes = key.withUnsafeBytes
            {
                return Data(Array($0))
            }
        return keyBytes
    }
    
    /// Derive a new secret key with PBKDF2 algorithm
    static func fromPBKDF2(password: String, salt: String, keyBytesCount: Int, iterations: Int, algorithm: HashAlgorithm) -> Data? {
        let passwordData = password.data(using: .utf8)!
        let saltData = salt.data(using: .utf8)!
        
        var derivedKeyData = Data(repeating: 0, count: keyBytesCount)
        let localDerivedKeyData = derivedKeyData
        
        let status = derivedKeyData.withUnsafeMutableBytes { (derivedKeyBytes: UnsafeMutableRawBufferPointer) in
            saltData.withUnsafeBytes { (saltBytes: UnsafeRawBufferPointer) in
                CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    password,
                    passwordData.count,
                    saltBytes.bindMemory(to: UInt8.self).baseAddress,
                    saltData.count,
                    algorithm.commonCrypto,
                    UInt32(iterations),
                    derivedKeyBytes.bindMemory(to: UInt8.self).baseAddress,
                    localDerivedKeyData.count)
            }
        }
        if (status != kCCSuccess) {
            return nil;
        }
        
        return derivedKeyData
    }
}
