// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:native_crypto/src/core/extensions/uint8_list_extension.dart';

extension ListUint8ListExtension on List<Uint8List> {
  /// Reduce a [List] of [Uint8List] to a [Uint8List].
  Uint8List combine() {
    if (isEmpty) {
      return Uint8List(0);
    }
    return reduce((value, element) => value | element);
  }
}
