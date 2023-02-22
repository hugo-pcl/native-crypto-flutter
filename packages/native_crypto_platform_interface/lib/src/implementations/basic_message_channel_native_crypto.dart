// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

/// An implementation of [NativeCryptoPlatform] that uses Pigeon generated code.
class BasicMessageChannelNativeCrypto extends NativeCryptoPlatform {
  /// Creates a new instance of [BasicMessageChannelNativeCrypto].
  ///
  /// The [api] parameter permits to override the default Pigeon API used to
  /// interact with the native platform. This is useful for testing.
  BasicMessageChannelNativeCrypto({NativeCryptoAPI? api})
      : api = api ?? NativeCryptoAPI();

  /// The Pigeon API used to interact with the native platform.
  final NativeCryptoAPI api;

  @override
  Future<Uint8List?> hash(Uint8List data, {required String algorithm}) async {
    try {
      return api
          .hash(
            HashRequest(
              data: data,
              algorithm: algorithm,
            ),
          )
          .then((value) => value.hash);
    } catch (e, s) {
      NativeCryptoException.convertPlatformException(e, s);
    }
  }

  @override
  Future<Uint8List?> hmac(
    Uint8List data, {
    required Uint8List key,
    required String algorithm,
  }) async {
    try {
      return api
          .hmac(
            HmacRequest(
              data: data,
              key: key,
              algorithm: algorithm,
            ),
          )
          .then((value) => value.hmac);
    } catch (e, s) {
      NativeCryptoException.convertPlatformException(e, s);
    }
  }

  @override
  Future<Uint8List?> generateSecureRandom(int length) async {
    try {
      return api
          .generateSecureRandom(
            GenerateSecureRandomRequest(
              length: length,
            ),
          )
          .then((value) => value.random);
    } catch (e, s) {
      NativeCryptoException.convertPlatformException(e, s);
    }
  }

  @override
  Future<Uint8List?> pbkdf2({
    required Uint8List password,
    required Uint8List salt,
    required int length,
    required int iterations,
    required String hashAlgorithm,
  }) async {
    try {
      return api
          .pbkdf2(
            Pbkdf2Request(
              password: password,
              salt: salt,
              length: length,
              iterations: iterations,
              hashAlgorithm: hashAlgorithm,
            ),
          )
          .then((value) => value.key);
    } catch (e, s) {
      NativeCryptoException.convertPlatformException(e, s);
    }
  }

  @override
  Future<Uint8List?> encrypt(
    Uint8List plainText, {
    required Uint8List key,
    required String algorithm,
  }) async {
    try {
      return api
          .encrypt(
            EncryptRequest(
              plainText: plainText,
              key: key,
              algorithm: algorithm,
            ),
          )
          .then((value) => value.cipherText);
    } catch (e, s) {
      NativeCryptoException.convertPlatformException(e, s);
    }
  }

  @override
  Future<Uint8List?> decrypt(
    Uint8List cipherText, {
    required Uint8List key,
    required String algorithm,
  }) async {
    try {
      return api
          .decrypt(
            DecryptRequest(
              cipherText: cipherText,
              key: key,
              algorithm: algorithm,
            ),
          )
          .then((value) => value.plainText);
    } catch (e, s) {
      NativeCryptoException.convertPlatformException(e, s);
    }
  }

  @override
  Future<bool?> encryptFile({
    required String plainTextPath,
    required String cipherTextPath,
    required Uint8List key,
    required String algorithm,
  }) async {
    try {
      return api
          .encryptFile(
            EncryptFileRequest(
              plainTextPath: plainTextPath,
              cipherTextPath: cipherTextPath,
              key: key,
              algorithm: algorithm,
            ),
          )
          .then((value) => value.success);
    } catch (e, s) {
      NativeCryptoException.convertPlatformException(e, s);
    }
  }

  @override
  Future<bool?> decryptFile({
    required String cipherTextPath,
    required String plainTextPath,
    required Uint8List key,
    required String algorithm,
  }) async {
    try {
      return api
          .decryptFile(
            DecryptFileRequest(
              cipherTextPath: cipherTextPath,
              plainTextPath: plainTextPath,
              key: key,
              algorithm: algorithm,
            ),
          )
          .then((value) => value.success);
    } catch (e, s) {
      NativeCryptoException.convertPlatformException(e, s);
    }
  }

  @override
  Future<Uint8List?> encryptWithIV({
    required Uint8List plainText,
    required Uint8List iv,
    required Uint8List key,
    required String algorithm,
  }) async {
    try {
      return api
          .encryptWithIV(
            EncryptWithIVRequest(
              plainText: plainText,
              iv: iv,
              key: key,
              algorithm: algorithm,
            ),
          )
          .then((value) => value.cipherText);
    } catch (e, s) {
      NativeCryptoException.convertPlatformException(e, s);
    }
  }
}
