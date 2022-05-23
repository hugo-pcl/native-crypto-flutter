/**
 * Author: Hugo Pointcheval
 * Email: git@pcl.ovh
 * -----
 * File: Cipher.swift
 * Created Date: 25/12/2021 18:31:28
 * Last Modified: 25/12/2021 18:38:53
 * -----
 * Copyright (c) 2021
 */

import Foundation
import CryptoKit

class AESCipher {
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

class CHACHACipher {
    /// Encrypts plaintext with key using CHACHAPOLY
    @available(iOS 13.0, *)
    static func encrypt(plaintext: Data, key: Data) -> Data? {
        let symmetricKey = SymmetricKey.init(data: key)
        let encrypted = try? ChaChaPoly.seal(plaintext, using: symmetricKey)
        return encrypted?.combined
    }
    
    /// Decrypts ciphertext with key using CHACHAPOLY
    @available(iOS 13.0, *)
    static func decrypt(ciphertext: Data, key: Data) -> Data? {
        let symmetricKey = SymmetricKey.init(data: key)
        let sealedBox = try? ChaChaPoly.SealedBox(combined: ciphertext)
        if (sealedBox == nil) { return nil }
        let decryptedData = try? ChaChaPoly.open(sealedBox!, using: symmetricKey)
        return decryptedData
    }
}
