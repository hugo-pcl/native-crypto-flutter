//
//  AESCipher.swift
//  native_crypto_ios
//
//  Created by Hugo Pointcheval on 25/05/2022.
//

import Foundation
import CryptoKit

class AESCipher : Cipher {
    /// Encrypts plaintext with key using AES GCM
    @available(iOS 13.0, *)
    func encrypt(data: Data, key: Data, predefinedIV: Data?) throws -> Data {
        let symmetricKey : SymmetricKey = SymmetricKey.init(data: key)
        
        // Encryption
        var encrypted : AES.GCM.SealedBox
        do {
            // If predefinedIV is not null use it
            if (predefinedIV != nil) {
                let nonce = try AES.GCM.Nonce(data: predefinedIV!)
                encrypted = try AES.GCM.seal(data, using: symmetricKey, nonce: nonce)
            } else {
                encrypted = try AES.GCM.seal(data, using: symmetricKey)
            }
        } catch CryptoKitError.incorrectKeySize {
            throw NativeCryptoError.invalidKeySize()
        } catch CryptoKitError.invalidParameter, CryptoKitError.incorrectParameterSize {
            throw NativeCryptoError.invalidParameter()
        } catch {
            throw NativeCryptoError.unknownError(reason: "An error occured during encryption.")
        }
        
        // NONCE[12] || CIPHERTEXT[n] || TAG[16]
        let encryptedData : Data? = encrypted.combined
        if (encryptedData == nil) {
            throw NativeCryptoError.unknownError(reason: "An error occured during ciphertext combination.")
        }
        return encryptedData!
    }
    
    /// Decrypts ciphertext with key using AES GCM
    @available(iOS 13.0, *)
    func decrypt(data: Data, key: Data) throws -> Data {
        let symmetricKey = SymmetricKey.init(data: key)
        
        // SealedBox initialization
        var encrypted : AES.GCM.SealedBox
        do {
            encrypted = try AES.GCM.SealedBox(combined: data)
        } catch {
            throw NativeCryptoError.unknownError(reason: "An error occured during sealedbox initialization.")
        }
        
        // Decryption
        var decryptedData : Data
        do {
            decryptedData = try AES.GCM.open(encrypted, using: symmetricKey)
        } catch CryptoKitError.incorrectKeySize {
            throw NativeCryptoError.invalidKeySize()
        } catch CryptoKitError.invalidParameter, CryptoKitError.incorrectParameterSize {
            throw NativeCryptoError.invalidParameter()
        } catch CryptoKitError.authenticationFailure {
            throw NativeCryptoError.authenticationError()
        } catch {
            throw NativeCryptoError.unknownError(reason: "An error occured during decryption.")
        }
        
        return decryptedData
    }
    
    /// Encrypts plaintext file with key using AES GCM
    func encryptFile(fileParameters: FileParameters, key: Data, predefinedIV: Data?) throws -> Bool {
        let fileManager = FileManager.default
        let inputFile = URL(fileURLWithPath: fileParameters.inputPath)

        guard let data = fileManager.contents(atPath: inputFile.path) else {
            throw NativeCryptoError.ioError(reason: "Error while reading input file.")
        }
        
        let encryptedData = try encrypt(data: data, key: key, predefinedIV: predefinedIV)
        
        guard fileManager.createFile(atPath: fileParameters.outputPath, contents: encryptedData, attributes: nil) else {
            throw NativeCryptoError.ioError(reason: "Error while writing output file.")
        }
        
        return true
    }
    
    /// Decrypts ciphertext file with key using AES GCM
    func decryptFile(fileParameters: FileParameters, key: Data) throws -> Bool {
        let fileManager = FileManager.default
        let inputFile = URL(fileURLWithPath: fileParameters.inputPath)

        guard let data = fileManager.contents(atPath: inputFile.path) else {
            throw NativeCryptoError.ioError(reason: "Error while reading input file.")
        }
        
        let decryptedData = try decrypt(data: data, key: key)
        
        guard fileManager.createFile(atPath: fileParameters.outputPath, contents: decryptedData, attributes: nil) else {
            throw NativeCryptoError.ioError(reason: "Error while writing output file.")
        }
        
        return true
    }
}
