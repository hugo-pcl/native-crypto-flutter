// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: secret_key.dart
// Created Date: 28/12/2021 13:36:54
// Last Modified: 23/05/2022 21:52:05
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'package:native_crypto/src/exceptions.dart';
import 'package:native_crypto/src/key.dart';
import 'package:native_crypto/src/platform.dart';

/// A class representing a secret key.
/// A secret key is a key that is not accessible by anyone else.
/// It is used to encrypt and decrypt data.
class SecretKey extends Key {
  SecretKey(Uint8List bytes) : super(bytes);
  SecretKey.fromBase16(String encoded) : super.fromBase16(encoded);
  SecretKey.fromBase64(String encoded) : super.fromBase64(encoded);
  SecretKey.fromUtf8(String input) : super.fromUtf8(input);

  static Future<SecretKey> fromSecureRandom(int bitsCount) async {
    try {
      final Uint8List _key =
          (await platform.generateSecretKey(bitsCount)) ?? Uint8List(0);

      return SecretKey(_key);
    } on PlatformException catch (e) {
      throw KeyException(e.toString());
    }
  }
}
