/**
 * Author: Hugo Pointcheval
 * Email: git@pcl.ovh
 * -----
 * File: KEM.swift
 * Created Date: 25/12/2021 18:31:48
 * Last Modified: 25/12/2021 18:40:00
 * -----
 * Copyright (c) 2021
 */

import Foundation
import CryptoKit

class KeyPair {
    /// Generate a keypair.
    @available(iOS 13.0, *)
    static func fromCurve() -> Data {
        let sk = P256.KeyAgreement.PrivateKey()
        var kp = sk.rawRepresentation
        kp.append(contentsOf: sk.publicKey.rawRepresentation)
        return kp;
    }
    
    /// Import private key from Data
    @available(iOS 13.0, *)
    static func importPrivateKey(privateKey: Data) throws -> P256.KeyAgreement.PrivateKey {
        let sk = try P256.KeyAgreement.PrivateKey(rawRepresentation: privateKey)
        
        return sk;
    }
    
    /// Import public key from Data
    @available(iOS 13.0, *)
    static func importPublicKey(publicKey: Data) throws -> P256.KeyAgreement.PublicKey {
        let pk = try P256.KeyAgreement.PublicKey(rawRepresentation: publicKey)
        
        return pk;
    }
}

class ECDH {
    /// Generate a shared secret with your private key and other party public key.
    @available(iOS 13.0, *)
    static func generateSharedSecretKey(salt: Data, hash: HashAlgorithm, keyBytesCount: Int ,privateKey: Data, publicKey: Data) -> Data? {
        let sk = try? KeyPair.importPrivateKey(privateKey: privateKey)
        if (sk == nil) {return nil}
        
        let pk = try? KeyPair.importPublicKey(publicKey: publicKey)
        if (pk == nil) {return nil}

        let secret = try? sk!.sharedSecretFromKeyAgreement(with: pk!)
        
        switch hash {
        case .HashSHA256:
            let key = secret?.hkdfDerivedSymmetricKey(using: SHA256.self, salt: salt, sharedInfo: Data(), outputByteCount: keyBytesCount)
            if (key == nil) {
                return nil
            } else {
                return Key.toBytes(key: key!)
            }
        case .HashSHA384:
            let key = secret?.hkdfDerivedSymmetricKey(using: SHA384.self, salt: salt, sharedInfo: Data(), outputByteCount: keyBytesCount)
            if (key == nil) {
                return nil
            } else {
                return Key.toBytes(key: key!)
            }
        case .HashSHA512:
            let key = secret?.hkdfDerivedSymmetricKey(using: SHA512.self, salt: salt, sharedInfo: Data(), outputByteCount: keyBytesCount)
            if (key == nil) {
                return nil
            } else {
                return Key.toBytes(key: key!)
            }
        }
    }
}
