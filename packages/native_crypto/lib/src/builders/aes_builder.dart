// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: aes_builder.dart
// Created Date: 28/12/2021 12:03:11
// Last Modified: 28/12/2021 13:39:23
// -----
// Copyright (c) 2021

import '../builder.dart';
import '../ciphers/aes.dart';
import '../exceptions.dart';
import '../keys/secret_key.dart';

class AESBuilder implements Builder<AES> {
  SecretKey? _sk;
  Future<SecretKey>? _fsk;
  AESMode _mode = AESMode.gcm;

  AESBuilder withGeneratedKey(int bitsCount) {
    _fsk = SecretKey.fromSecureRandom(bitsCount);
    return this;
  }

  AESBuilder withKey(SecretKey secretKey) {
    _sk = secretKey;
    return this;
  }

  AESBuilder using(AESMode mode) {
    _mode = mode;
    return this;
  }

  @override
  Future<AES> build() async {
    if (_sk == null) {
      if (_fsk == null) {
        throw CipherInitException("You must specify or generate a secret key.");
      } else {
        _sk = await _fsk;
      }
    }
    return AES(_sk!, _mode);
  }
}