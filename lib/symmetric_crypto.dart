// Copyright (c) 2020
// Author: Hugo Pointcheval
import 'dart:typed_data';

import 'package:native_crypto/src/native_crypto.dart';
import 'package:native_crypto/src/exceptions.dart';

/// Defines all available key sizes.
enum KeySize { bits128, bits192, bits256 }

/// Defines all available ciphers.
enum Cipher { AES }

/// Key Helper
///
/// You can generate Secret keys of different sizes.
class KeyGenerator {
  /// Generate a secret key.
  ///
  /// You can specify a `keySize`. Default is 256 bits.
  Future<Uint8List> secretKey({KeySize keySize}) async {
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
    return await NativeCrypto().symKeygen(size);
  }
}

/// AES Helper
///
/// You can encrypt and decrypt data.
class AES {
  Uint8List _key;

  bool _isInitialized = false;

  KeySize _keySize;

  /// You can pass a key in constructor.
  AES({Uint8List key}) {
    this._key = key;
    try {
      this._isInitialized = _testKey();
    } on KeyException {
      this._isInitialized = false;
      throw KeyException('Invalid key length: ${this.key.length} Bytes');
    }
  }

  /// This key is used for encryption and decryption.
  Uint8List get key => this._key;

  /// Check if the AES object is intialized with a valid key before perform any operation.
  bool get isInitialized => this._isInitialized;

  /// Defines the size of the generated or passed key.
  KeySize get keySize => this._keySize;

  /// [Private]
  /// Tests if the key is valid.
  ///
  /// The key must be 128, 192 or 256 bits long.
  bool _testKey() {
    if (this.key != null) {
      switch (this.key.length) {
        case 16:
          this._keySize = KeySize.bits128;
          break;
        case 24:
          this._keySize = KeySize.bits192;
          break;
        case 32:
          this._keySize = KeySize.bits256;
          break;
        default:
          throw KeyException('Invalid key length: ${this.key.length} Bytes');
      }
      return true;
    } else {
      return false;
    }
  }

  /// Generate an AES key.
  ///
  /// You have to specify a `keySize`.
  /// Return `null` if the key is already set.
  init(KeySize keySize) async {
    if (this.key != null) return null;

    this._keySize = keySize;
    this._key = await KeyGenerator().secretKey(keySize: keySize);

    try {
      this._isInitialized = _testKey();
    } on KeyException {
      this._isInitialized = false;
      throw KeyException('Invalid key length: ${this.key.length} Bytes');
    }
  }

  /// Encrypts data.
  ///
  /// Takes `Uint8List` data as parameter.
  /// And returns an `Uint8List` **list**.
  ///
  /// You can pass a different key.
  ///
  /// The first member of this list is the `cipher data`,
  /// and the second member is the `IV`.
  Future<List<Uint8List>> encrypt(Uint8List data, {Uint8List key}) async {
    if (!this._isInitialized && key == null)
      throw EncryptionException(
          'Instance not initialized. You can pass a key directly in encrypt method.');

    List<Uint8List> encryptedPayload =
        await NativeCrypto().symEncrypt(data, key ?? this.key);
    return encryptedPayload;
  }

  /// Decrypts data.
  ///
  /// Takes `Uint8List` **list** as parameter.
  /// And returns plain text data as `Uint8List`.
  /// 
  /// You can pass a different key.
  Future<Uint8List> decrypt(List<Uint8List> encryptedPayload, {Uint8List key}) async {
    if (!this._isInitialized && key == null)
      throw DecryptionException(
          'Instance not initialized. You can pass a key directly in encrypt method.');
    Uint8List decryptedPayload =
        await NativeCrypto().symDecrypt(encryptedPayload, key ?? this.key);
    return decryptedPayload;
  }
}
