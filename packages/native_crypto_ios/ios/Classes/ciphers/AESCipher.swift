//
//  AESCipher.swift
//  native_crypto_ios
//
//  Created by Hugo Pointcheval on 25/05/2022.
//

import Foundation
import CryptoKit

class AESCipher : Cipher {
    var algorithm: CipherAlgorithm = CipherAlgorithm.aes
    
    /// Encrypts plaintext with key using AES GCM
    @available(iOS 13.0, *)
    func encrypt(data: Data, key: Data) throws -> Data {
        let symmetricKey : SymmetricKey = SymmetricKey.init(data: key)
        let encrypted : AES.GCM.SealedBox? = try? AES.GCM.seal(data, using: symmetricKey)
        
        let encryptedData : Data? = encrypted?.combined
        if (encryptedData == nil) {
            throw NativeCryptoError.encryptionError
        }
        return encryptedData!
    }
    
    /// Decrypts ciphertext with key using AES GCM
    @available(iOS 13.0, *)
    func decrypt(data: Data, key: Data) throws -> Data {
        let symmetricKey = SymmetricKey.init(data: key)
        let sealedBox = try? AES.GCM.SealedBox(combined: data)
        if (sealedBox == nil) { return Data.init() }
        let decryptedData = try? AES.GCM.open(sealedBox!, using: symmetricKey)
        if (decryptedData == nil) {
            throw NativeCryptoError.decryptionError
        }
        return decryptedData!
    }
    
    func encryptAsList(data: Data, key: Data) throws -> [Data] {
        let encryptedData = try encrypt(data: data, key: key)
        
        let iv = encryptedData.prefix(12)
        let data = encryptedData.suffix(from: 12)
        
        return [iv, data]
    }
    
    func decryptAsList(data: [Data], key: Data) throws -> Data {
        var encryptedData = data.first!
        let data = data.last!
        encryptedData.append(data)
        
        let decryptedData = try decrypt(data: encryptedData, key: key)
        return decryptedData
    }
}
