//
//  KeyDerivation.swift
//  native_crypto_ios
//
//  Created by Hugo Pointcheval on 25/05/2022.
//

import Foundation

protocol KeyDerivation {
    func derive() throws -> Data?
}
