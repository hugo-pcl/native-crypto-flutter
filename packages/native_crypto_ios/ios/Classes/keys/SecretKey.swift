//
//  SecretKey.swift
//  native_crypto_ios
//
//  Created by Hugo Pointcheval on 25/05/2022.
//

import Foundation
import CryptoKit

class SecretKey : Key {
    var bytes: Data
    
    init(_ bytes: Data) {
        self.bytes = bytes
    }
    
    init(fromSecureRandom bitsCount: Int) {
        let symmetricKey = SymmetricKey.init(size: SymmetricKeySize(bitCount: bitsCount))
        bytes = symmetricKey.withUnsafeBytes
        {
            return Data(Array($0))
        }
    }
}
