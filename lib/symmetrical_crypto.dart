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

  bool _isInitialized = false;

  /// Check if the AES object is intialized with a valid key before perform any operation.
  bool get isInitialized => _isInitialized;

  KeySize _keySize;

  /// Defines the size of the generated or passed key.
  KeySize get keySize => _keySize;
  
  /// You can pass a key in constructor.
  AES({this.key}) {
    try {
      bool isValidKey = _testKey();
      this._isInitialized = isValidKey;
    } on KeyException {
      this._isInitialized = false;
      throw KeyException('Invalid key length: ${this.key.length} Bytes');
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
  /// You can specify a `keySize`. Default is 256 bits.
  /// Return `null` if the key is already set.
  init({KeySize keySize}) async {
    if (this.key != null) return null;

    int size;
    this._keySize = keySize;
    
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
      this._isInitialized = isValidKey;
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
  /// The first member of this list is the `cipher data`,
  /// and the second member is the `IV`.
  Future<List<Uint8List>> encrypt(Uint8List data) async {
    if (!this._isInitialized)
      throw EncryptionException('Instance not initialized.');
    List<Uint8List> encryptedPayload =
        await NativeCrypto().symEncrypt(data, this.key);
    return encryptedPayload;
  }

  /// Decrypts data.
  ///
  /// Takes `Uint8List` **list** as parameter.
  /// And returns plain text data as `Uint8List`.
  Future<Uint8List> decrypt(List<Uint8List> encryptedPayload) async {
    if (!this._isInitialized)
      throw DecryptionException('Instance not initialized.');
    Uint8List decryptedPayload =
        await NativeCrypto().symDecrypt(encryptedPayload, this.key);
    return decryptedPayload;
  }
}