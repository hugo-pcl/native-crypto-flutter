// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';
import 'package:native_crypto_platform_interface/src/core/utils/enum_parser.dart';
import 'package:native_crypto_platform_interface/src/gen/messages.g.dart';

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
      return api.hash(
        data,
        EnumParser.hashAlgorithmFromString(algorithm),
      );
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
      return api.hmac(
        data,
        key,
        EnumParser.hashAlgorithmFromString(algorithm),
      );
    } catch (e, s) {
      NativeCryptoException.convertPlatformException(e, s);
    }
  }

  @override
  Future<Uint8List?> generateSecureRandom(int length) async {
    try {
      return api.generateSecureRandom(length);
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
      return api.pbkdf2(
        password,
        salt,
        length,
        iterations,
        EnumParser.hashAlgorithmFromString(hashAlgorithm),
      );
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
      return api.encrypt(
        plainText,
        key,
        EnumParser.cipherAlgorithmFromString(algorithm),
      );
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
      return api.encryptWithIV(
        plainText,
        iv,
        key,
        EnumParser.cipherAlgorithmFromString(algorithm),
      );
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
      return api.decrypt(
        cipherText,
        key,
        EnumParser.cipherAlgorithmFromString(algorithm),
      );
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
      return api.encryptFile(
        plainTextPath,
        cipherTextPath,
        key,
        EnumParser.cipherAlgorithmFromString(algorithm),
      );
    } catch (e, s) {
      NativeCryptoException.convertPlatformException(e, s);
    }
  }

  @override
  Future<bool?> encryptFileWithIV({
    required String plainTextPath,
    required String cipherTextPath,
    required Uint8List iv,
    required Uint8List key,
    required String algorithm,
  }) async {
    try {
      return api.encryptFileWithIV(
        plainTextPath,
        cipherTextPath,
        iv,
        key,
        EnumParser.cipherAlgorithmFromString(algorithm),
      );
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
      return api.decryptFile(
        cipherTextPath,
        plainTextPath,
        key,
        EnumParser.cipherAlgorithmFromString(algorithm),
      );
    } catch (e, s) {
      NativeCryptoException.convertPlatformException(e, s);
    }
  }
}
