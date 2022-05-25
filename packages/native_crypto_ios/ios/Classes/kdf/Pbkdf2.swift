//
//  Pbkdf2.swift
//  native_crypto_ios
//
//  Created by Hugo Pointcheval on 25/05/2022.
//

import Foundation
import CommonCrypto

class Pbkdf2 : KeyDerivation {
    var algorithm: KdfAlgorithm = KdfAlgorithm.pbkdf2
    
    var keyBytesCount: Int
    var iterations: Int
    var hash: HashAlgorithm = HashAlgorithm.HashSHA256
    
    var password: String? = nil
    var salt: String? = nil
    
    init(keyBytesCount: Int, iterations: Int) {
        self.keyBytesCount = keyBytesCount
        self.iterations = iterations
    }
    
    func initialize(password: String, salt: String) {
        self.password = password
        self.salt = salt
    }
    
    func derive() throws -> SecretKey {
        if (password == nil || salt == nil) {
            throw NativeCryptoError.pbkdf2Error
        }
        
        let passwordData = password!.data(using: .utf8)!
        let saltData = salt!.data(using: .utf8)!
        
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
                    hash.pbkdf2identifier,
                    UInt32(iterations),
                    derivedKeyBytes.bindMemory(to: UInt8.self).baseAddress,
                    localDerivedKeyData.count)
            }
        }
        
        if (status != kCCSuccess) {
            throw NativeCryptoError.pbkdf2Error
        }
        
        return SecretKey(derivedKeyData)
    }
}
