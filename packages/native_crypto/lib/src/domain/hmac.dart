// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:native_crypto/src/core/enums/hash_algorithm.dart';
import 'package:native_crypto/src/keys/secret_key.dart';

/// {@template hmac}
/// A HMAC is a cryptographic hash that uses a key to sign a message.
/// The receiver verifies the hash by recomputing it using the same key.
/// {@endtemplate}
abstract class Hmac {
  /// {@macro hmac}
  const Hmac();

  /// The [HashAlgorithm] used by this [Hmac].
  HashAlgorithm get algorithm;

  /// Digests the given [data] and returns the hmac.
  Future<Uint8List> digest(Uint8List data, SecretKey key);
}
