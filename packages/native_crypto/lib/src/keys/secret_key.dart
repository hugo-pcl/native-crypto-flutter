// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: secret_key.dart
// Created Date: 28/12/2021 13:36:54
// Last Modified: 26/05/2022 19:26:35
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:native_crypto/src/interfaces/base_key.dart';
import 'package:native_crypto/src/interfaces/cipher.dart';
import 'package:native_crypto/src/platform.dart';
import 'package:native_crypto/src/utils/extensions.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

/// Represents a secret key in NativeCrypto.
///
/// [SecretKey] is a [BaseKey] that can be used to store secret keys.
/// A [SecretKey] is a key that can be used to encrypt or decrypt data with
/// a symmetric [Cipher].
class SecretKey extends BaseKey {
  const SecretKey(super.bytes);
  SecretKey.fromBase16(super.encoded) : super.fromBase16();
  SecretKey.fromBase64(super.encoded) : super.fromBase64();
  SecretKey.fromUtf8(super.input) : super.fromUtf8();

  static Future<SecretKey> fromSecureRandom(int bitsCount) async {
    Uint8List? key;
    try {
      key = await platform.generateSecretKey(bitsCount);
    } catch (e, s) {
      throw NativeCryptoException(
        message: '$e',
        code: NativeCryptoExceptionCode.platform_throws.code,
        stackTrace: s,
      );
    }
    if (key.isNull) {
      throw NativeCryptoException(
        message: 'Failed to generate a secret key! Platform returned null.',
        code: NativeCryptoExceptionCode.platform_returned_null.code,
      );
    }

    if (key!.isEmpty) {
      throw NativeCryptoException(
        message: 'Failed to generate a secret key! '
            'Platform returned no data.',
        code: NativeCryptoExceptionCode.platform_returned_empty_data.code,
      );
    }
    return SecretKey(key);
  }
}
