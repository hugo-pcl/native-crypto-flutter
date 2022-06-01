//
//  HashAlgorithm.swift
//  native_crypto_ios
//
//  Created by Hugo Pointcheval on 25/05/2022.
//

import Foundation
import CommonCrypto
import CryptoKit

enum HashAlgorithm: String {
    case HashSHA256 = "sha256"
    case HashSHA384 = "sha384"
    case HashSHA512 = "sha512"
    
    var pbkdf2identifier: UInt32 {
        switch self {
        case .HashSHA256: return CCPBKDFAlgorithm(kCCPRFHmacAlgSHA256)
        case .HashSHA384: return CCPBKDFAlgorithm(kCCPRFHmacAlgSHA384)
        case .HashSHA512: return CCPBKDFAlgorithm(kCCPRFHmacAlgSHA512)
        }
    }
    
    @available(iOS 13.0, *)
    func digest(data: Data) -> Data {
        switch self {
        case .HashSHA256:
            return Data(SHA256.hash(data: data))
        case .HashSHA384:
            return Data(SHA384.hash(data: data))
        case .HashSHA512:
            return Data(SHA512.hash(data: data))
        }
    }
    
    @available(iOS 13.0, *)
    static func digest(data: Data, algorithm: String) throws -> Data {
        let algo = HashAlgorithm.init(rawValue: algorithm)
        if (algo == nil) {
            throw NativeCryptoError.messageDigestError
        }
        return algo!.digest(data: data)
    }
}
