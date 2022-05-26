// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: hash_algorithm.dart
// Created Date: 23/05/2022 22:01:59
// Last Modified: 26/05/2022 22:59:04
// -----
// Copyright (c) 2022

import 'dart:typed_data';

import 'package:native_crypto/src/platform.dart';
import 'package:native_crypto/src/utils/extensions.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

/// Defines the hash algorithms.
enum HashAlgorithm {
  sha256,
  sha384,
  sha512;

  /// Digest the [data] using this [HashAlgorithm].
  Future<Uint8List> digest(Uint8List data) async {
    Uint8List? hash;
    try {
      hash = await platform.digest(data, name);
    } catch (e, s) {
      throw NativeCryptoException(
        message: '$e',
        code: NativeCryptoExceptionCode.platform_throws.code,
        stackTrace: s,
      );
    }

    if (hash.isNull) {
      throw NativeCryptoException(
        message: 'Failed to digest data! Platform returned null.',
        code: NativeCryptoExceptionCode.platform_returned_null.code,
      );
    }

    if (hash!.isEmpty) {
      throw NativeCryptoException(
        message: 'Failed to digest data! Platform returned no data.',
        code: NativeCryptoExceptionCode.platform_returned_empty_data.code,
      );
    }

    return hash;
  }
}
