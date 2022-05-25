// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: pbkdf2.dart
// Created Date: 17/12/2021 14:50:42
// Last Modified: 25/05/2022 10:45:00
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:native_crypto/src/interfaces/keyderivation.dart';
import 'package:native_crypto/src/keys/secret_key.dart';
import 'package:native_crypto/src/platform.dart';
import 'package:native_crypto/src/utils/hash_algorithm.dart';
import 'package:native_crypto/src/utils/kdf_algorithm.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

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
      throw const KeyDerivationException(
        message: "Password or Salt can't be null!",
        code: 'invalid_password_or_salt',
      );
    }

    final Uint8List derivation = (await platform.pbkdf2(
          password,
          salt,
          _keyBytesCount,
          _iterations,
          _hash.name,
        )) ??
        Uint8List(0);

    return SecretKey(derivation);
  }
}
