//
//  HashAlgorithmParser.swift
//  native_crypto_ios
//
//  Created by Hugo Pointcheval on 04/04/2023.
//

import Foundation
import CommonCrypto
import CryptoKit

public class HashAlgorithmParser {
    static func getMessageDigest(algorithm: HashAlgorithm) -> any HashFunction {
        switch algorithm {
        case .sha256: return SHA256.init()
        case .sha384: return SHA384.init()
        case .sha512: return SHA512.init()
        @unknown default: fatalError("Unknown algorithm")
        }
    }
    
    static func getPbkdf2Identifier(algorithm: HashAlgorithm) -> UInt32 {
        switch algorithm {
        case .sha256: return CCPBKDFAlgorithm(kCCPRFHmacAlgSHA256)
        case .sha384: return CCPBKDFAlgorithm(kCCPRFHmacAlgSHA384)
        case .sha512: return CCPBKDFAlgorithm(kCCPRFHmacAlgSHA512)
        @unknown default: fatalError("Unknown algorithm")
        }
    }

}
