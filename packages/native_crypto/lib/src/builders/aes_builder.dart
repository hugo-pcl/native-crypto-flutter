// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: aes_builder.dart
// Created Date: 28/12/2021 12:03:11
// Last Modified: 25/05/2022 10:47:11
// -----
// Copyright (c) 2021

import 'package:native_crypto/src/ciphers/aes/aes.dart';
import 'package:native_crypto/src/interfaces/builder.dart';
import 'package:native_crypto/src/keys/secret_key.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

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
        throw const CipherInitException(
          message: 'You must specify or generate a secret key.',
          code: 'missing_key',
        );
      } else {
        _sk = await _fsk;
      }
    }
    return AES(_sk!, _mode);
  }
}
