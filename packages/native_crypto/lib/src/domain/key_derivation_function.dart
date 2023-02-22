// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

/// {@template key_derivation_function}
/// A [KeyDerivationFunction] is a function that derives a key from an
/// [Uint8List] key material.
/// {@endtemplate}
abstract class KeyDerivationFunction {
  /// {@macro key_derivation_function}
  const KeyDerivationFunction();

  /// Derives a key from a [keyMaterial].
  Future<Uint8List> derive(
    Uint8List keyMaterial,
  );

  /// Verifies a [keyMaterial] against an [expected] value.
  Future<bool> verify(
    Uint8List keyMaterial,
    Uint8List expected,
  );
}
