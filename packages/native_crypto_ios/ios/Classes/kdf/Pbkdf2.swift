//
//  Pbkdf2.swift
//  native_crypto_ios
//
//  Created by Hugo Pointcheval on 25/05/2022.
//

import Foundation
import CommonCrypto

class Pbkdf2 : KeyDerivation {
    var length: Int
    var iterations: Int
    var hashAlgorithm: HashAlgorithm
    
    var password: Data? = nil
    var salt: Data? = nil
    
    init(length: Int, iterations: Int, hashAlgorithm: HashAlgorithm) {
        self.length = length
        self.iterations = iterations
        self.hashAlgorithm = hashAlgorithm
    }
    
    func initialize(password: Data, salt: Data) {
        self.password = password
        self.salt = salt
    }
    
    func derive() throws -> Data? {
        if (password == nil || salt == nil) {
            throw NativeCryptoError.kdfError(reason: "Password and salt cannot be null.")
        }
        
        var derivedKeyData = Data(repeating: 0, count: length)
        let localDerivedKeyData = derivedKeyData
        let identifier = HashAlgorithmParser.getPbkdf2Identifier(algorithm: hashAlgorithm)
        
        let status = derivedKeyData.withUnsafeMutableBytes { (derivedKeyBytes: UnsafeMutableRawBufferPointer) in
            salt!.withUnsafeBytes { (saltBytes: UnsafeRawBufferPointer) in
                CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    (password! as NSData).bytes,
                    password!.count,
                    saltBytes.bindMemory(to: UInt8.self).baseAddress,
                    salt!.count,
                    identifier,
                    UInt32(iterations),
                    derivedKeyBytes.bindMemory(to: UInt8.self).baseAddress,
                    localDerivedKeyData.count)
            }
        }
        
        if (status != kCCSuccess) {
            throw NativeCryptoError.kdfError()
        }
        
        return derivedKeyData
    }
}
