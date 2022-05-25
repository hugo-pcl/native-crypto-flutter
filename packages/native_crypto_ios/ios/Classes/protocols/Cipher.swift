//
//  Cipher.swift
//  native_crypto_ios
//
//  Created by Hugo Pointcheval on 25/05/2022.
//

import Foundation

protocol Cipher {
    var algorithm: CipherAlgorithm { get }
    func encrypt(data: Data, key: Data) throws -> Data
    func decrypt(data: Data, key: Data) throws -> Data
    func encryptAsList(data: Data, key: Data) throws -> [Data]
    func decryptAsList(data: [Data], key: Data) throws-> Data
}
