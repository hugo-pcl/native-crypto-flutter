// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: pbkdf2.dart
// Created Date: 17/12/2021 14:50:42
// Last Modified: 23/05/2022 21:47:43
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:native_crypto/src/exceptions.dart';
import 'package:native_crypto/src/hasher.dart';
import 'package:native_crypto/src/keyderivation.dart';
import 'package:native_crypto/src/keys/secret_key.dart';
import 'package:native_crypto/src/platform.dart';
import 'package:native_crypto/src/utils.dart';

class PBKDF2 extends KeyDerivation {
  final int _keyBytesCount;
  final int _iterations;
  final HashAlgorithm _hash;

  @override
  KdfAlgorithm get algorithm => KdfAlgorithm.pbkdf2;

  PBKDF2(
    int keyBytesCount,
    int iterations, {
    HashAlgorithm algorithm = HashAlgorithm.sha256,
  })  : _keyBytesCount = keyBytesCount,
        _iterations = iterations,
        _hash = algorithm;

  @override
  Future<SecretKey> derive({String? password, String? salt}) async {
    if (password == null || salt == null) {
      throw KeyDerivationException("Password or Salt can't be null!");
    }

    final Uint8List derivation = (await platform.pbkdf2(
          password,
          salt,
          _keyBytesCount,
          _iterations,
          Utils.enumToStr(_hash),
        )) ??
        Uint8List(0);

    return SecretKey(derivation);
  }
}
