//
//  KeyGeneration.swift
//
//  NativeCryptoPlugin
//
//  Copyright (c) 2020
//  Author: Hugo Pointcheval
//
import Foundation
import CommonCrypto

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
    
    @available(iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    func rsaKeypairGen(size : NSNumber) throws -> [Data]? {
        
        let tagData = UUID().uuidString.data(using: .utf8)
        
        let isPermanent = true
        
        let attributes: [CFString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits: (size.intValue * 8),
            kSecPrivateKeyAttrs: [
                kSecAttrIsPermanent: isPermanent,
                kSecAttrApplicationTag: tagData!
            ]
        ]
        
        var error: Unmanaged<CFError>?
        guard let privKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        let pubKey = SecKeyCopyPublicKey(privKey)
        
        
        var errorExport: Unmanaged<CFError>?
        let data1 = SecKeyCopyExternalRepresentation(pubKey!, &errorExport)
        let unwrappedData1 = data1 as Data?
        
        let data2 = SecKeyCopyExternalRepresentation(privKey, &errorExport)
        let unwrappedData2 = data2 as Data?
        
        return [unwrappedData1!, unwrappedData2!]
    }
}
