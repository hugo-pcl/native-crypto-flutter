//
//  KeyDerivation.swift
//  native_crypto_ios
//
//  Created by Hugo Pointcheval on 25/05/2022.
//

import Foundation

protocol KeyDerivation {
    var algorithm : KdfAlgorithm { get }
    func derive() throws -> SecretKey
}
