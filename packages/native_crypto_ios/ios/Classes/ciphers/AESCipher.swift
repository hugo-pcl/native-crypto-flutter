//
//  AES.swift
//  native_crypto_ios
//
//  Created by Hugo Pointcheval on 25/05/2022.
//

import Foundation

class AES : Cipher {
    /// Encrypts plaintext with key using AES GCM
    @available(iOS 13.0, *)
    static func encrypt(plaintext: Data, key: Data) -> Data? {
        let symmetricKey = SymmetricKey.init(data: key)
        let encrypted = try? AES.GCM.seal(plaintext, using: symmetricKey)
        return encrypted?.combined
    }
    
    /// Decrypts ciphertext with key using AES GCM
    @available(iOS 13.0, *)
    static func decrypt(ciphertext: Data, key: Data) -> Data? {
        let symmetricKey = SymmetricKey.init(data: key)
        let sealedBox = try? AES.GCM.SealedBox(combined: ciphertext)
        if (sealedBox == nil) { return nil }
        let decryptedData = try? AES.GCM.open(sealedBox!, using: symmetricKey)
        return decryptedData
    }
}
