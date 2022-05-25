//
//  CipherAlgorithm.swift
//  native_crypto_ios
//
//  Created by Hugo Pointcheval on 25/05/2022.
//

import Foundation

enum CipherAlgorithm : String {
    case aes = "aes"
    
    var getCipher: Cipher {
        switch self {
        case .aes: return AESCipher()
        }
    }
}
