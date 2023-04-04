//
//  NativeCryptoError.swift
//  native_crypto_ios
//
//  Created by Hugo Pointcheval on 25/05/2022.
//

import Foundation

enum NativeCryptoError : LocalizedError {
    /// When an operation is not supported
    case notSupported(reason: String? = nil)
    /// When the key is invalid
    case invalidKey(reason: String? = nil)
    /// When the key length is invalid
    case invalidKeySize(reason: String? = nil)
    /// When operation parameter is invalid
    case invalidParameter(reason: String? = nil)
    /// When an authentication process fails
    case authenticationError(reason: String? = nil)
    /// When a input/output process (like file manipulation) fails
    case ioError(reason: String? = nil)
    /// When cipher initialization fails
    case cipherError(reason: String? = nil)
    /// When a digest process fails
    case digestError(reason: String? = nil)
    /// When a key derivation process fails
    case kdfError(reason: String? = nil)
    /// When any other expection is thrown
    case unknownError(reason: String? = nil)

    var errorDescription: String? {
        switch self {
        case .notSupported(reason: let reason):
            return reason ?? "This operation is not supported."
        case .invalidKey(reason: let reason):
            return reason ?? "Invalid key."
        case .invalidKeySize(reason: let reason):
            return reason ?? "Invalid key size."
        case .invalidParameter(reason: let reason):
            return reason ?? "Invalid parameter."
        case .authenticationError(reason: let reason):
            return reason ?? "Authentication fails."
        case .ioError(reason: let reason):
            return reason ?? "IO operation fails."
        case .cipherError(reason: let reason):
            return reason ?? "Cipher initialization fails."
        case .digestError(reason: let reason):
            return reason ?? "Digest fails."
        case .kdfError(reason: let reason):
            return reason ?? "Key derivation fails."
        case .unknownError(reason: let reason):
            return reason ?? "An unknown error occurred during the operation."
        }
    }
    
}
