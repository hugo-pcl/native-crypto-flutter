// Copyright (c) 2020
// Author: Hugo Pointcheval
import 'dart:typed_data';

import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto/src/exceptions.dart';

enum KeySize { bits128, bits192, bits256 }
enum Cipher { AES }

/// AES Helper
///
/// You can generate AES keys, encrypt and decrypt data.
class AES {
  Uint8List key;

  bool isInitialized = false;
  KeySize keySize;

  /// You can pass a key in constructor.
  AES({this.key}) {
    try {
      bool isValidKey = _testKey();
      this.isInitialized = isValidKey;
    } on KeyException {
      this.isInitialized = false;
      throw KeyException('Invalid key length.');
    }
  }

  /// Tests if the key is valid.
  ///
  /// The key must be 128, 192 or 256 bits long.
  bool _testKey() {
    if (this.key != null) {
      switch (this.key.length) {
        case 16:
          this.keySize = KeySize.bits128;
          break;
        case 24:
          this.keySize = KeySize.bits192;
          break;
        case 32:
          this.keySize = KeySize.bits256;
          break;
        default:
          throw KeyException('Invalid key length.');
      }
      return true;
    } else {
      return false;
    }
  }

  /// Generate an AES key.
  init(KeySize keySize) async {
    if (this.key != null) return null;

    if (keySize != KeySize.bits256)
      throw NotImplementedException('This key size is not implemented yet.');

    this.key = await NativeCrypto().symKeygen();
    try {
      bool isValidKey = _testKey();
      this.isInitialized = isValidKey;
    } on KeyException {
      this.isInitialized = false;
      throw KeyException('Invalid key length.');
    }
  }

  /// Encrypt data
  ///
  /// Returns an `Encrypted` object.
  Future<Encrypted> encrypt(Uint8List data) async {
    if (!this.isInitialized) throw EncryptionException('Instance not initialized.');
    List<Uint8List> encryptedPayload =
        await NativeCrypto().symEncrypt(data, this.key);
    Encrypted encrypted = Encrypted.fromList(Cipher.AES, encryptedPayload);

    return encrypted;
  }

  Future<Uint8List> decrypt(Encrypted encrypted) async {
    if (!this.isInitialized) throw DecryptionException('Instance not initialized.');
    Uint8List decryptedPayload =
        await NativeCrypto().symDecrypt(encrypted.toList(), this.key);
    return decryptedPayload;
  }
}

/// Contains data of an encrypted payload.
/// More practical than a list.
class Encrypted {
  Cipher cipher;
  Uint8List cipherText;
  Uint8List iv;
  Uint8List mac;

  Encrypted();

  Encrypted.fromList(this.cipher, List<Uint8List> encryptedPayload) {
    this.mac = encryptedPayload[0].sublist(0, 32);
    this.cipherText = encryptedPayload[0].sublist(32, encryptedPayload[0].length);
    this.iv = encryptedPayload[1];
  }

  List<Uint8List> toList() {
    List<Uint8List> encryptedPayload = [Uint8List.fromList(this.mac + this.cipherText), this.iv];
    return encryptedPayload;
  }
}
