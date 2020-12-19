//
//  KeyDerivation.swift
//
//  NativeCryptoPlugin
//
//  Copyright (c) 2020
//  Author: Hugo Pointcheval
//

import Foundation
import CommonCrypto

class KeyDerivation {
    func pbkdf2(password: String, salt: String, keyLength: Int, iteration: Int, algorithm: HashAlgorithm) -> Data? {
        
        let passwordData = password.data(using: .utf8)!
        let saltData = salt.data(using: .utf8)!
        
        var derivedKeyData = Data(repeating: 0, count: keyLength)
        var localDerivedKeyData = derivedKeyData
            
        let derivationStatus = derivedKeyData.withUnsafeMutableBytes { derivedKeyBytes in
            saltData.withUnsafeBytes { saltBytes in
                CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    password, passwordData.count,
                    saltBytes, saltData.count,
                    algorithm.pbkdf2,
                    UInt32(iteration),
                    derivedKeyBytes, localDerivedKeyData.count)
            }
        }
        if (derivationStatus != kCCSuccess) {
            print("Error: \(derivationStatus)")
            return nil;
        }
        
        return derivedKeyData
    }
}
