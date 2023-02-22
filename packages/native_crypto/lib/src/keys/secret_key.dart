// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:native_crypto/src/domain/base_key.dart';
import 'package:native_crypto/src/random/secure_random.dart';

/// {@template secret_key}
/// Represents a secret key in NativeCrypto.
///
/// [SecretKey] is a [BaseKey] that can be used to store secret keys.
/// A [SecretKey] is a key that can be used to encrypt or decrypt data with
/// a symmetric Cipher.
/// {@endtemplate}
class SecretKey extends BaseKey {
  /// {@macro secret_key}
  const SecretKey(super.bytes);

  /// Creates a [SecretKey] from a [List<int>].
  SecretKey.fromList(super.list) : super.fromList();

  /// Creates a [SecretKey] from a [String] encoded in UTF-8.
  SecretKey.fromUtf8(super.encoded) : super.fromUtf8();

  /// Creates a [SecretKey] from a [String] encoded in UTF-16.
  SecretKey.fromUtf16(super.encoded) : super.fromUtf16();

  /// Creates a [SecretKey] from a [String] encoded in Hexadecimal.
  SecretKey.fromBase16(super.encoded) : super.fromBase16();

  /// Creates a [SecretKey] from a [String] encoded in Base64.
  SecretKey.fromBase64(super.encoded) : super.fromBase64();

  /// Generates a random [SecretKey] of the given [length] in bytes.
  static Future<SecretKey> fromSecureRandom(int length) async {
    const random = SecureRandom();
    final bytes = await random.generate(length);

    return SecretKey(bytes);
  }
}
