// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: secret_key.dart
// Created Date: 28/12/2021 13:36:54
// Last Modified: 25/05/2022 10:45:55
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:native_crypto/src/interfaces/key.dart';
import 'package:native_crypto/src/platform.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

/// A class representing a secret key.
/// A secret key is a key that is not accessible by anyone else.
/// It is used to encrypt and decrypt data.
class SecretKey extends Key {
  const SecretKey(super.bytes);
  SecretKey.fromBase16(super.encoded) : super.fromBase16();
  SecretKey.fromBase64(super.encoded) : super.fromBase64();
  SecretKey.fromUtf8(super.input) : super.fromUtf8();

  static Future<SecretKey> fromSecureRandom(int bitsCount) async {
    try {
      final Uint8List _key =
          (await platform.generateSecretKey(bitsCount)) ?? Uint8List(0);

      return SecretKey(_key);
    } catch (e, s) {
      throw KeyException(
        message: 'Failed to generate a secret key!',
        code: 'failed_to_generate_secret_key',
        stackTrace: s,
      );
    }
  }
}
