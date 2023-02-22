// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart';
import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

/// {@template pbkdf2}
/// A PBKDF2 is a password-based key derivation function.
/// {@endtemplate}
class Pbkdf2 extends KeyDerivationFunction {
  /// {@macro pbkdf2}
  const Pbkdf2({
    required this.hashAlgorithm,
    required this.iterations,
    required this.salt,
    required this.length,
  });

  /// The [HashAlgorithm] used by this [Pbkdf2].
  final HashAlgorithm hashAlgorithm;

  /// The number of iterations.
  final int iterations;

  /// The salt.
  final Uint8List salt;

  /// The length of the derived key in bytes.
  final int length;

  @override
  Future<Uint8List> derive(Uint8List keyMaterial) async {
    if (length == 0) {
      // If the length is 0, return an empty list
      return Uint8List(0);
    }

    if (length < 0) {
      throw ArgumentError.value(length, 'length', 'must be positive');
    }

    if (iterations <= 0) {
      throw ArgumentError.value(
        iterations,
        'iterations',
        'must greater than 0',
      );
    }

    // Call the platform interface to derive the key
    final bytes = await platform.pbkdf2(
      password: keyMaterial,
      salt: salt,
      iterations: iterations,
      length: length,
      hashAlgorithm: hashAlgorithm.name,
    );

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

  @override
  Future<bool> verify(Uint8List keyMaterial, Uint8List expected) =>
      derive(keyMaterial).then((actual) {
        if (actual.length != expected.length) {
          return false;
        }
        return listEquals(actual, expected);
      });

  Future<SecretKey> call({required String password}) =>
      derive(password.toBytes()).then(SecretKey.new);
}
