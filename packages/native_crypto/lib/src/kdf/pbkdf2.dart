// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: pbkdf2.dart
// Created Date: 17/12/2021 14:50:42
// Last Modified: 26/05/2022 18:51:59
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

  Pbkdf2(
    int keyBytesCount,
    int iterations, {
    HashAlgorithm algorithm = HashAlgorithm.sha256,
  })  : _keyBytesCount = keyBytesCount,
        _iterations = iterations,
        _hash = algorithm;

  @override
  Future<SecretKey> derive({String? password, String? salt}) async {
    if (password == null || salt == null) {
      throw NativeCryptoException(
        message: 'Password and salt cannot be null. '
            'Here is the password: $password, here is the salt: $salt',
        code: NativeCryptoExceptionCode.invalid_argument.code,
      );
    }

    final Uint8List? derivation = await platform.pbkdf2(
      password,
      salt,
      _keyBytesCount,
      _iterations,
      _hash.name,
    );

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
