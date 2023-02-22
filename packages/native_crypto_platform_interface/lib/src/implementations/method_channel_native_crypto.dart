// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

/// An implementation of [NativeCryptoPlatform] that uses method channels.
class MethodChannelNativeCrypto extends NativeCryptoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  MethodChannel channel = const MethodChannel('plugins.hugop.cl/native_crypto');

  Future<T?> _invokeMethod<T>(
    NativeCryptoMethod method, [
    Map<String, dynamic>? arguments,
  ]) async {
    try {
      return await channel.invokeMethod<T>(method.name, arguments);
    } on PlatformException catch (e, s) {
      NativeCryptoException.convertPlatformException(e, s);
    }
  }

  @override
  Future<Uint8List?> hash(Uint8List data, {required String algorithm}) =>
      _invokeMethod<Uint8List>(
        NativeCryptoMethod.hash,
        {
          'data': data,
          'algorithm': algorithm,
        },
      );

  @override
  Future<Uint8List?> hmac(
    Uint8List data, {
    required Uint8List key,
    required String algorithm,
  }) =>
      _invokeMethod<Uint8List>(
        NativeCryptoMethod.hmac,
        {
          'data': data,
          'key': key,
          'algorithm': algorithm,
        },
      );

  @override
  Future<Uint8List?> generateSecureRandom(int length) =>
      _invokeMethod<Uint8List>(
        NativeCryptoMethod.generateSecureRandom,
        {
          'length': length,
        },
      );

  @override
  Future<Uint8List?> pbkdf2({
    required Uint8List password,
    required Uint8List salt,
    required int length,
    required int iterations,
    required String hashAlgorithm,
  }) =>
      _invokeMethod<Uint8List>(
        NativeCryptoMethod.pbkdf2,
        {
          'password': password,
          'salt': salt,
          'length': length,
          'iterations': iterations,
          'hashAlgorithm': hashAlgorithm,
        },
      );

  @override
  Future<Uint8List?> encrypt(
    Uint8List plainText, {
    required Uint8List key,
    required String algorithm,
  }) =>
      _invokeMethod<Uint8List>(
        NativeCryptoMethod.encrypt,
        {
          'plainText': plainText,
          'key': key,
          'algorithm': algorithm,
        },
      );

  @override
  Future<Uint8List?> decrypt(
    Uint8List cipherText, {
    required Uint8List key,
    required String algorithm,
  }) =>
      _invokeMethod<Uint8List>(
        NativeCryptoMethod.decrypt,
        {
          'cipherText': cipherText,
          'key': key,
          'algorithm': algorithm,
        },
      );

  @override
  Future<bool?> encryptFile({
    required String plainTextPath,
    required String cipherTextPath,
    required Uint8List key,
    required String algorithm,
  }) =>
      _invokeMethod<bool>(
        NativeCryptoMethod.encryptFile,
        {
          'plainTextPath': plainTextPath,
          'cipherTextPath': cipherTextPath,
          'key': key,
          'algorithm': algorithm,
        },
      );

  @override
  Future<bool?> decryptFile({
    required String cipherTextPath,
    required String plainTextPath,
    required Uint8List key,
    required String algorithm,
  }) =>
      _invokeMethod<bool>(
        NativeCryptoMethod.decryptFile,
        {
          'cipherTextPath': cipherTextPath,
          'plainTextPath': plainTextPath,
          'key': key,
          'algorithm': algorithm,
        },
      );

  @override
  Future<Uint8List?> encryptWithIV({
    required Uint8List plainText,
    required Uint8List iv,
    required Uint8List key,
    required String algorithm,
  }) =>
      _invokeMethod<Uint8List>(
        NativeCryptoMethod.encryptWithIV,
        {
          'plainText': plainText,
          'iv': iv,
          'key': key,
          'algorithm': algorithm,
        },
      );
}
