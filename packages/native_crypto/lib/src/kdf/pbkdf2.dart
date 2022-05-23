// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: pbkdf2.dart
// Created Date: 17/12/2021 14:50:42
// Last Modified: 28/12/2021 13:38:50
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import '../exceptions.dart';
import '../hasher.dart';
import '../keyderivation.dart';
import '../keys/secret_key.dart';
import '../platform.dart';
import '../utils.dart';

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

    Uint8List derivation = (await platform.pbkdf2(
      password,
      salt,
      _keyBytesCount,
      _iterations,
      Utils.enumToStr(_hash),
    )) ?? Uint8List(0);

    return SecretKey(derivation);
  }
}
