// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:native_crypto/src/core/utils/platform.dart';
import 'package:native_crypto/src/domain/random.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

/// {@template secure_random}
/// A [SecureRandom] is a source of secure random bytes.
/// {@endtemplate}
class SecureRandom extends Random {
  /// {@macro secure_random}
  const SecureRandom();

  @override
  Future<Uint8List> generate(int length) async {
    if (length < 0) {
      throw ArgumentError.value(length, 'length', 'must be positive');
    }
    if (length == 0) {
      // If the length is 0, return an empty list
      return Uint8List(0);
    }
    // Call the platform interface to generate the secure random bytes
    final bytes = await platform.generateSecureRandom(length);

    // TODO(hpcl): move these checks to the platform interface
    if (bytes == null) {
      throw const NativeCryptoException(
        code: NativeCryptoExceptionCode.nullError,
        message: 'Platform returned null bytes',
      );
    }

    if (bytes.length != length) {
      throw NativeCryptoException(
        code: NativeCryptoExceptionCode.invalidData,
        message: 'Platform returned bytes of wrong length: '
            'expected $length, got ${bytes.length}',
      );
    }

    return bytes;
  }
}
