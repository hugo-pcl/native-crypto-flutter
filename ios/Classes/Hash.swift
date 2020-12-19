//
//  Hash.swift
//
//  NativeCryptoPlugin
//
//  Copyright (c) 2020
//  Author: Hugo Pointcheval
//
import Foundation
import CommonCrypto

enum HashAlgorithm: String {
    case SHA1 = "sha1"
    case SHA224 = "sha224"
    case SHA256 = "sha256"
    case SHA384 = "sha384"
    case SHA512 = "sha512"
    
    var digestLength: Int {
        switch self {
        case .SHA1: return Int(CC_SHA1_DIGEST_LENGTH)
        case .SHA224: return Int(CC_SHA224_DIGEST_LENGTH)
        case .SHA256: return Int(CC_SHA256_DIGEST_LENGTH)
        case .SHA384: return Int(CC_SHA384_DIGEST_LENGTH)
        case .SHA512: return Int(CC_SHA512_DIGEST_LENGTH)
        }
    }
    
    var pbkdf2: UInt32 {
        switch self {
        case .SHA1: return CCPBKDFAlgorithm(kCCPRFHmacAlgSHA1)
        case .SHA224: return CCPBKDFAlgorithm(kCCPRFHmacAlgSHA224)
        case .SHA256: return CCPBKDFAlgorithm(kCCPRFHmacAlgSHA256)
        case .SHA384: return CCPBKDFAlgorithm(kCCPRFHmacAlgSHA384)
        case .SHA512: return CCPBKDFAlgorithm(kCCPRFHmacAlgSHA512)
        }
    }
}

class Hash {
    func digest(data: Data?, algorithm: HashAlgorithm) -> Data? {
        if (data == nil) {
            return nil
        }
        let digestData = Data(count: algorithm.digestLength)
        let digestBytes = digestData.withUnsafeBytes { $0.load(as: UnsafeMutablePointer<UInt8>.self) }
        
        let messageBytes = data!.withUnsafeBytes { $0.load(as: UnsafePointer<UInt8>.self) }
        
        switch algorithm {
        case .SHA1:
            CC_SHA1(messageBytes, CC_LONG(data!.count), digestBytes)
        case .SHA224:
            CC_SHA224(messageBytes, CC_LONG(data!.count), digestBytes)
        case .SHA256:
            CC_SHA256(messageBytes, CC_LONG(data!.count), digestBytes)
        case .SHA384:
            CC_SHA384(messageBytes, CC_LONG(data!.count), digestBytes)
        case .SHA512:
            CC_SHA512(messageBytes, CC_LONG(data!.count), digestBytes)
        }
        
        return digestData
    }
}
