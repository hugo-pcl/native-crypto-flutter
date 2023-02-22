// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:native_crypto/src/core/enums/hash_algorithm.dart';

/// {@template hash}
/// A [Hash] is a one-way function that takes arbitrary-sized data and
/// outputs a fixed-sized hash value.
/// {@endtemplate}
abstract class Hash {
  /// {@macro hash}
  const Hash();

  /// The [HashAlgorithm] used by this [Hash].
  HashAlgorithm get algorithm;

  /// Digests the given [data] and returns the hash.
  Future<Uint8List> digest(Uint8List data);
}
