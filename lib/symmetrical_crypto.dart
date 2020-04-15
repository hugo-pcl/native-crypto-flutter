// Copyright (c) 2020
// Author: Hugo Pointcheval
import 'dart:typed_data';

import 'package:native_crypto/src/native_crypto.dart';
import 'package:native_crypto/src/exceptions.dart';

/// Defines all available key sizes.
enum KeySize { bits128, bits192, bits256 }

/// Defines all available ciphers.
enum Cipher { AES }

/// AES Helper
///
/// You can generate AES keys, encrypt and decrypt data.
class AES {
  /// This key is used for encryption and decryption.
  Uint8List key;

  /// Check if the AES object is intialized with a valid key before perform any operation.
  bool isInitialized = false;

  /// Defines the size of the generated or passed key.
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

  /// [Private]
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
  ///
  /// You can specify a `keySize`. Default is 256 bits.
  /// Return `null` if the key is already set.
  init({KeySize keySize}) async {
    if (this.key != null) return null;

    int size;

    switch (keySize) {
      case KeySize.bits128:
        size = 128;
        break;
      case KeySize.bits192:
        size = 192;
        break;
      case KeySize.bits256:
        size = 256;
        break;
      default:
        // Default size = 256 bits
        size = 256;
        break;
    }

    this.key = await NativeCrypto().symKeygen(size);
    try {
      bool isValidKey = _testKey();
      this.isInitialized = isValidKey;
    } on KeyException {
      this.isInitialized = false;
      throw KeyException('Invalid key length.');
    }
  }

  /// Encrypts data.
  /// 
  /// Takes `Uint8List` data as parameter.
  /// And returns an `Encrypted` object.
  Future<Encrypted> encrypt(Uint8List data) async {
    if (!this.isInitialized)
      throw EncryptionException('Instance not initialized.');
    List<Uint8List> encryptedPayload =
        await NativeCrypto().symEncrypt(data, this.key);
    Encrypted encrypted = Encrypted.fromList(Cipher.AES, encryptedPayload);

    return encrypted;
  }

  /// Decrypts data.
  /// 
  /// Takes `Encrypted` object as parameter.
  /// And returns plain text data as `Uint8List`.
  Future<Uint8List> decrypt(Encrypted encrypted) async {
    if (!this.isInitialized)
      throw DecryptionException('Instance not initialized.');
    Uint8List decryptedPayload =
        await NativeCrypto().symDecrypt(encrypted.toList(), this.key);
    return decryptedPayload;
  }
}

/// Contains data of an encrypted payload.
/// More practical than a list.
class Encrypted {
  /// Contains encryption algorithm.
  Cipher cipher;

  /// Contains encrypted bytes.
  Uint8List cipherText;

  /// Contains IV used for encryption.
  /// 
  /// Needed for decryption.
  Uint8List iv;

  /// Contains MAC.
  ///
  /// Used in decryption to authenticate the data.
  Uint8List mac;

  /// Creates an encrypted from payload `List<Uint8List>`.
  Encrypted.fromList(this.cipher, List<Uint8List> encryptedPayload) {
    this.mac = encryptedPayload[0].sublist(0, 32);
    this.cipherText =
        encryptedPayload[0].sublist(32, encryptedPayload[0].length);
    this.iv = encryptedPayload[1];
  }

  /// Returns a payload `List<Uint8List>` from this encrypted.
  List<Uint8List> toList() {
    List<Uint8List> encryptedPayload = [
      Uint8List.fromList(this.mac + this.cipherText),
      this.iv
    ];
    return encryptedPayload;
  }
}
