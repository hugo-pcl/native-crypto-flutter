//
//  Cipher.swift
//  native_crypto_ios
//
//  Created by Hugo Pointcheval on 25/05/2022.
//

import Foundation

protocol Cipher {
    func encrypt(data: Data, key: Data, predefinedIV: Data?) throws -> Data
    func decrypt(data: Data, key: Data) throws -> Data
    func encryptFile(fileParameters: FileParameters, key: Data, predefinedIV: Data?) throws -> Bool
    func decryptFile(fileParameters: FileParameters, key: Data) throws -> Bool
}
