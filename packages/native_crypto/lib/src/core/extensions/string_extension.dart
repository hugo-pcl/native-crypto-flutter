// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';
import 'dart:typed_data';

import 'package:native_crypto/src/core/enums/encoding.dart';
import 'package:native_crypto/src/core/extensions/list_int_extension.dart';

extension StringExtension on String {
  /// Converts a [String] to a [Uint8List] using the specified [Encoding].
  Uint8List toBytes({Encoding from = Encoding.utf16}) {
    Uint8List bytes;
    switch (from) {
      case Encoding.utf8:
        bytes = utf8.encode(this).toTypedList();
        break;
      case Encoding.utf16:
        bytes = runes.toList().toTypedList();
        break;
      case Encoding.base64:
        bytes = base64.decode(this);
        break;
      case Encoding.base16:
        assert(length.isEven, 'String needs to be an even length.');
        bytes = List.generate(
          length ~/ 2,
          (i) => int.parse(substring(i * 2, (i * 2) + 2), radix: 16),
        ).toList().toTypedList();
    }
    return bytes;
  }
}
