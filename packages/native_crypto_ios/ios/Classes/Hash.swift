/**
 * Author: Hugo Pointcheval
 * Email: git@pcl.ovh
 * -----
 * File: Hash.swift
 * Created Date: 25/12/2021 18:31:11
 * Last Modified: 25/12/2021 18:38:20
 * -----
 * Copyright (c) 2021
 */

import Foundation
import CommonCrypto
import CryptoKit

enum HashAlgorithm: String {
    case HashSHA256 = "sha256"
    case HashSHA384 = "sha384"
    case HashSHA512 = "sha512"
    
    var commonCrypto: UInt32 {
        switch self {
        case .HashSHA256: return CCPBKDFAlgorithm(kCCPRFHmacAlgSHA256)
        case .HashSHA384: return CCPBKDFAlgorithm(kCCPRFHmacAlgSHA384)
        case .HashSHA512: return CCPBKDFAlgorithm(kCCPRFHmacAlgSHA512)
        }
    }
}

@available(iOS 13.0, *)
class Hash {
    /// Hash a message with a specified HashAlgorithm
    static func digest(data: Data, algorithm: HashAlgorithm) -> Data {
        switch algorithm {
            case .HashSHA256:
                return Data(SHA256.hash(data: data))
            case .HashSHA384:
                return Data(SHA384.hash(data: data))
            case .HashSHA512:
                return Data(SHA512.hash(data: data))
        }
    }
}
