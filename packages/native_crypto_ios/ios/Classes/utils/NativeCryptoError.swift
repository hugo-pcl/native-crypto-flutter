//
//  NativeCryptoError.swift
//  native_crypto_ios
//
//  Created by Hugo Pointcheval on 25/05/2022.
//

import Foundation

enum NativeCryptoError : Error {
case decryptionError
case encryptionError
case messageDigestError
case pbkdf2Error
case cipherError
case resultError
case exceptionError
}
