// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';
import 'dart:typed_data';

import 'package:native_crypto/src/core/enums/encoding.dart';
import 'package:native_crypto/src/core/extensions/list_int_extension.dart';

extension Uint8ListExtension on Uint8List {
  /// Returns a concatenation of this with the other [Uint8List].
  Uint8List plus(Uint8List other) => [...this, ...other].toTypedList();

  /// Returns a concatenation of this with the other
  /// [Uint8List] using the `|` operator as a shortcut.
  Uint8List operator |(Uint8List other) => plus(other);

  /// Returns a sublist of this from the [start] index to the [end] index.
  /// If [end] is greater than the length of the list, it is set to the length.
  Uint8List trySublist(int start, [int? end]) {
    if (isEmpty) {
      return this;
    }

    int ending = end ?? length;
    if (ending > length) {
      ending = length;
    }

    return sublist(start, ending);
  }

  /// Returns a [List] of [Uint8List] of the specified [chunkSize].
  List<Uint8List> chunked(int chunkSize) {
    if (isEmpty) {
      return [];
    }

    return List.generate(
      (length / chunkSize).ceil(),
      (i) => trySublist(i * chunkSize, (i * chunkSize) + chunkSize),
    );
  }

  /// Converts a [Uint8List] to a [String] using the specified [Encoding].
  String toStr({Encoding to = Encoding.utf16}) {
    String str;
    switch (to) {
      case Encoding.utf8:
        str = utf8.decode(this);
        break;
      case Encoding.utf16:
        str = String.fromCharCodes(this);
        break;
      case Encoding.base64:
        str = base64.encode(this);
        break;
      case Encoding.base16:
        str = List.generate(
          length,
          (i) => this[i].toRadixString(16).padLeft(2, '0'),
        ).join();
    }
    return str;
  }
}
