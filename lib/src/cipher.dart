// Copyright (c) 2020
// Author: Hugo Pointcheval

import 'dart:typed_data';

import 'key.dart';

/// Represents different cipher algorithms
enum CipherAlgorithm { AES, BlowFish, None }

/// Represents different block cipher modes
enum BlockCipherMode { ECB, CBC, CFB, GCM, CGM }

/// Represents different padding
enum PlainTextPadding { PKCS5, None }

/// Represents a cipher.
///
/// In cryptography, a cipher is an algorithm for performing encryption
/// or decryption - a series of well-defined steps that can
/// be followed as a procedure.
abstract class Cipher {
  /// Returns the standard algorithm name for this cipher
  CipherAlgorithm get algorithm;

  /// Returns the secret key used for this cipher
  SecretKey get secretKey;

  /// Returns the parameters used for this cipher
  CipherParameters get parameters;

  /// Returns true if cipher is initialized
  bool get isInitialized;

  /// Returnes list of supported [CipherParameters] for this cipher
  List<CipherParameters> get supportedParameters;

  /// Encrypts data.
  ///
  /// Takes [Uint8List] data as parameter.
  /// Returns a [CipherText].
  Future<CipherText> encrypt(Uint8List data);

  /// Decrypts cipher text.
  ///
  /// Takes [CipherText] as parameter.
  /// And returns plain text data as [Uint8List].
  Future<Uint8List> decrypt(CipherText cipherText);
}

/// Represents a cipher text.
///
/// It's the result of an encryption.
abstract class CipherText {
  /// Returns the standard algorithm name used for this ciphertext
  CipherAlgorithm get algorithm;

  /// Returns the data of this ciphertext
  Uint8List get bytes;

  /// Returns the IV of this cipertext
  Uint8List get iv;
}

/// Represents a pair of [BlockCipherMode] and [Padding]
class CipherParameters {
  BlockCipherMode _mode;
  PlainTextPadding _padding;

  /// Returns mode used in the cipher
  BlockCipherMode get mode => _mode;

  /// Returns padding used in the cipher
  PlainTextPadding get padding => _padding;

  CipherParameters(BlockCipherMode mode, PlainTextPadding padding) {
    _mode = mode;
    _padding = padding;
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CipherParameters &&
        o._mode.index == _mode.index &&
        o._padding.index == _padding.index;
  }

  @override
  int get hashCode => _mode.hashCode ^ _padding.hashCode;
}
