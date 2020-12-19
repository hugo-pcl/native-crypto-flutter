//
//  KeyGeneration.swift
//
//  NativeCryptoPlugin
//
//  Copyright (c) 2020
//  Author: Hugo Pointcheval
//
import Foundation

class KeyGeneration {
    func keygen(size : NSNumber) -> Data? {
        var bytes = [Int8](repeating: 0, count: size.intValue / 8)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)

        if status == errSecSuccess {
            let keyBytes = bytes.withUnsafeBytes {
                return Data(Array($0))
                
            }
            return keyBytes
        }
        return nil
    }
}
