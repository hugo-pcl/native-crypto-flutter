// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of native_crypto must implement.
///
/// Platform implementations should extend this class rather than implement
/// it as `NativeCrypto` does not consider newly added methods to be
/// breaking changes. Extending this class (using `extends`) ensures
/// that the subclass will get the default implementation, while platform
/// implementations that `implements` this interface will be
/// broken by newly added [NativeCryptoPlatform] methods.
abstract class NativeCryptoPlatform extends PlatformInterface {
  /// Constructs a NativeCryptoPlatform.
  NativeCryptoPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeCryptoPlatform _instance = BasicMessageChannelNativeCrypto();

  /// The default instance of [NativeCryptoPlatform] to use.
  ///
  /// Defaults to [BasicMessageChannelNativeCrypto].
  static NativeCryptoPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [NativeCryptoPlatform] when they register themselves.
  static set instance(NativeCryptoPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Returns the hash of the given data.
  Future<Uint8List?> hash(Uint8List data, {required String algorithm}) {
    throw UnimplementedError('hash is not implemented');
  }

  /// Returns the hmac of the given data using the given key.
  Future<Uint8List?> hmac(
    Uint8List data, {
    required Uint8List key,
    required String algorithm,
  }) {
    throw UnimplementedError('hmac is not implemented');
  }

  /// Generates a secure random of the given length in bytes.
  Future<Uint8List?> generateSecureRandom(int length) {
    throw UnimplementedError('generateSecureRandom is not implemented');
  }

  /// Derives a key from the given password and salt using pbkdf2.
  Future<Uint8List?> pbkdf2({
    required Uint8List password,
    required Uint8List salt,
    required int length,
    required int iterations,
    required String hashAlgorithm,
  }) {
    throw UnimplementedError('pbkdf2 is not implemented');
  }

  /// Encrypts the given data using the given key and algorithm.
  Future<Uint8List?> encrypt(
    Uint8List plainText, {
    required Uint8List key,
    required String algorithm,
  }) {
    throw UnimplementedError('encrypt is not implemented');
  }

  /// Encrypts the given data using the given key, algorithm and iv.
  ///
  /// Users should use [encrypt] instead if they don't need to specify the iv.
  Future<Uint8List?> encryptWithIV({
    required Uint8List plainText,
    required Uint8List iv,
    required Uint8List key,
    required String algorithm,
  }) {
    throw UnimplementedError('encryptWithIV is not implemented');
  }

  /// Decrypts the given data using the given key and algorithm.
  Future<Uint8List?> decrypt(
    Uint8List cipherText, {
    required Uint8List key,
    required String algorithm,
  }) {
    throw UnimplementedError('decrypt is not implemented');
  }

  /// Encrypts the given file using the given key and algorithm.
  Future<bool?> encryptFile({
    required String plainTextPath,
    required String cipherTextPath,
    required Uint8List key,
    required String algorithm,
  }) {
    throw UnimplementedError('encryptFile is not implemented');
  }

  /// Encrypts the given file using the given key, algorithm and iv.
  ///
  /// Users should use [encryptFile] instead if they don't need to specify
  /// the iv.
  Future<bool?> encryptFileWithIV({
    required String plainTextPath,
    required String cipherTextPath,
    required Uint8List iv,
    required Uint8List key,
    required String algorithm,
  }) {
    throw UnimplementedError('encryptFileWithIV is not implemented');
  }

  /// Decrypts the given file using the given key and algorithm.
  Future<bool?> decryptFile({
    required String cipherTextPath,
    required String plainTextPath,
    required Uint8List key,
    required String algorithm,
  }) {
    throw UnimplementedError('decryptFile is not implemented');
  }
}
