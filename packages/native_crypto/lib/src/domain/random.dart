// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

/// {@template random}
/// A [Random] is a source of random bytes.
/// {@endtemplate}
abstract class Random {
  /// {@macro random}
  const Random();

  /// Generates a random [Uint8List] of [length] bytes.
  Future<Uint8List> generate(int length);
}
