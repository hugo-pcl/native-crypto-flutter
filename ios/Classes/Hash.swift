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
        
        let hashBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: algorithm.digestLength)
        defer { hashBytes.deallocate() }
        
        switch algorithm {
        case .SHA1:
            data!.withUnsafeBytes { (buffer) -> Void in
                CC_SHA1(buffer.baseAddress!, CC_LONG(buffer.count), hashBytes)
            }
        case .SHA224:
            data!.withUnsafeBytes { (buffer) -> Void in
                CC_SHA224(buffer.baseAddress!, CC_LONG(buffer.count), hashBytes)
            }
        case .SHA256:
            data!.withUnsafeBytes { (buffer) -> Void in
                CC_SHA256(buffer.baseAddress!, CC_LONG(buffer.count), hashBytes)
            }
        case .SHA384:
            data!.withUnsafeBytes { (buffer) -> Void in
                CC_SHA384(buffer.baseAddress!, CC_LONG(buffer.count), hashBytes)
            }
        case .SHA512:
            data!.withUnsafeBytes { (buffer) -> Void in
                CC_SHA512(buffer.baseAddress!, CC_LONG(buffer.count), hashBytes)
            }
        }
        
        return Data(bytes: hashBytes, count: algorithm.digestLength)
    }
}
