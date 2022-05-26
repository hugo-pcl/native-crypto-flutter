// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: pbkdf2.dart
// Created Date: 17/12/2021 14:50:42
// Last Modified: 26/05/2022 23:19:46
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:native_crypto/src/interfaces/keyderivation.dart';
import 'package:native_crypto/src/keys/secret_key.dart';
import 'package:native_crypto/src/platform.dart';
import 'package:native_crypto/src/utils/extensions.dart';
import 'package:native_crypto/src/utils/hash_algorithm.dart';
import 'package:native_crypto/src/utils/kdf_algorithm.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

/// Represent a PBKDF2 Key Derivation Function (KDF) in NativeCrypto.
///
/// [Pbkdf2] is a function that takes password, salt, iteration count and
/// derive a [SecretKey] of specified length.
class Pbkdf2 extends KeyDerivation {
  final int _keyBytesCount;
  final int _iterations;
  final HashAlgorithm _hash;

  @override
  KdfAlgorithm get algorithm => KdfAlgorithm.pbkdf2;

  Pbkdf2({
    required int keyBytesCount,
    required int iterations,
    HashAlgorithm algorithm = HashAlgorithm.sha256,
  })  : _keyBytesCount = keyBytesCount,
        _iterations = iterations,
        _hash = algorithm {
    if (keyBytesCount < 0) {
      throw NativeCryptoException(
        message: 'keyBytesCount must be positive.',
        code: NativeCryptoExceptionCode.invalid_argument.code,
      );
    }

    if (iterations <= 0) {
      throw NativeCryptoException(
        message: 'iterations must be strictly positive.',
        code: NativeCryptoExceptionCode.invalid_argument.code,
      );
    }
  }

  @override
  Future<SecretKey> derive({String? password, String? salt}) async {
    Uint8List? derivation;

    if (_keyBytesCount == 0) {
      return SecretKey(Uint8List(0));
    }
    if (password.isNull) {
      throw NativeCryptoException(
        message: 'Password cannot be null.',
        code: NativeCryptoExceptionCode.invalid_argument.code,
      );
    }

    if (salt.isNull) {
      throw NativeCryptoException(
        message: 'Salt cannot be null.',
        code: NativeCryptoExceptionCode.invalid_argument.code,
      );
    }

    try {
      derivation = await platform.pbkdf2(
        password!,
        salt!,
        _keyBytesCount,
        _iterations,
        _hash.name,
      );
    } catch (e, s) {
      throw NativeCryptoException(
        message: '$e',
        code: NativeCryptoExceptionCode.platform_throws.code,
        stackTrace: s,
      );
    }

    if (derivation.isNull) {
      throw NativeCryptoException(
        message: 'Failed to derive a key! Platform returned null.',
        code: NativeCryptoExceptionCode.platform_returned_null.code,
      );
    }

    if (derivation!.isEmpty) {
      throw NativeCryptoException(
        message: 'Failed to derive a key! Platform returned no data.',
        code: NativeCryptoExceptionCode.platform_returned_empty_data.code,
      );
    }

    if (derivation.length != _keyBytesCount) {
      throw NativeCryptoException(
        message: 'Failed to derive a key! Platform returned '
            '${derivation.length} bytes, but expected $_keyBytesCount bytes.',
        code: NativeCryptoExceptionCode.platform_returned_invalid_data.code,
      );
    }

    return SecretKey(derivation);
  }
}
