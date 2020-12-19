//
//  Cipher.swift
//
//  NativeCryptoPlugin
//
//  Copyright (c) 2020
//  Author: Hugo Pointcheval
//

import Foundation
import CommonCrypto

enum CipherAlgorithm: String {
    case AES = "aes"
    case BlowFish = "blowfish"
    
    var instance: Int {
        switch self {
        case .AES: return kCCAlgorithmAES
        case .BlowFish: return kCCAlgorithmBlowfish
        }
    }
}

enum BlockCipherMode: String {
    case ECB = "ecb"
    case CBC = "cbc"
    
    var instance: Int {
        switch self {
        case .CBC: return 0
        case .ECB: return kCCOptionECBMode
        }
    }
}

enum Padding: String {
    case PKCS5 = "pkcs5"
    case None = "none"
    
    var instance: Int {
        switch self {
        case .PKCS5: return kCCOptionPKCS7Padding
        case .None: return 0
        }
    }
}

class Cipher {
    func encrypt(data : Data, key : Data, algorithm : CipherAlgorithm, mode : BlockCipherMode, padding : Padding) -> [Data]? {
        // Calculate Mac
        let mac = Hash().digest(data: key + data, algorithm: .SHA256)
        let payload = mac! + data
        
        // Generate IV
        let ivBytes = UnsafeMutableRawPointer.allocate(byteCount: kCCBlockSizeAES128, alignment: 1)
        defer { ivBytes.deallocate() }
        let ivStatus = CCRandomGenerateBytes(ivBytes, kCCBlockSizeAES128)
        if (ivStatus != kCCSuccess) {
            return nil
        }
        let ivData = Data(bytes: ivBytes, count: kCCBlockSizeAES128)
        
        let algo = algorithm.instance
        let options: CCOptions = UInt32(mode.instance + padding.instance)

        
        guard var ciphertext = crypt(operation: kCCEncrypt,
                                    algorithm: algo,
                                    options: options,
                                    key: key,
                                    initializationVector: ivData,
                                    dataIn: payload) else { return nil }
                
        return [ciphertext, ivData]
    }
    
    func decrypt(payload : [Data], key : Data, algorithm : CipherAlgorithm, mode : BlockCipherMode, padding : Padding) -> Data? {
        let encrypted = payload[1] + payload[0]
        
        guard encrypted.count > kCCBlockSizeAES128 else { return nil }
        let iv = encrypted.prefix(kCCBlockSizeAES128)
        let ciphertext = encrypted.suffix(from: kCCBlockSizeAES128)
        
        let algo = algorithm.instance
        let options: CCOptions = UInt32(mode.instance + padding.instance)
        
        guard var decrypted = crypt(operation: kCCDecrypt,
                                    algorithm: algo,
                                    options: options,
                                    key: key,
                                    initializationVector: iv,
                                    dataIn: ciphertext) else {return nil}
        
        
        // Create a range based on the length of data to return
        let range = 0..<32

        // Get a new copy of data
        let mac = decrypted.subdata(in: range)
        decrypted.removeSubrange(range)
        
        let vmac = Hash().digest(data: key + decrypted, algorithm: .SHA256)
        
        if (mac.base64EncodedData() == vmac!.base64EncodedData()) {
            return decrypted
        } else {
            return nil
        }
    }
    
    private func crypt(operation: Int, algorithm: Int, options: UInt32, key: Data,
            initializationVector: Data, dataIn: Data) -> Data? {
        
        return key.withUnsafeBytes { keyUnsafeRawBufferPointer in
            return dataIn.withUnsafeBytes { dataInUnsafeRawBufferPointer in
                return initializationVector.withUnsafeBytes { ivUnsafeRawBufferPointer in
                    let dataOutSize: Int = dataIn.count + kCCBlockSizeAES128*2
                    let dataOut = UnsafeMutableRawPointer.allocate(byteCount: dataOutSize,
                        alignment: 1)
                    defer { dataOut.deallocate() }
                    var dataOutMoved: Int = 0
                    let status = CCCrypt(CCOperation(operation), CCAlgorithm(algorithm),
                        CCOptions(options),
                        keyUnsafeRawBufferPointer.baseAddress, key.count,
                        ivUnsafeRawBufferPointer.baseAddress,
                        dataInUnsafeRawBufferPointer.baseAddress, dataIn.count,
                        dataOut, dataOutSize, &dataOutMoved)
                    guard status == kCCSuccess else { return nil }
                    return Data(bytes: dataOut, count: dataOutMoved)
                }
            }
        }
    }
}
