// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: extensions.dart
// Created Date: 26/05/2022 12:12:48
// Last Modified: 27/05/2022 12:26:55
// -----
// Copyright (c) 2022

import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:native_crypto/src/utils/encoding.dart';

extension ObjectX on Object? {
  /// Returns `true` if the object is `null`.
  bool get isNull => this == null;

  /// Returns `true` if the object is **not** `null`.
  bool get isNotNull => this != null;

  /// Prints the object to the console.
  void log() => developer.log(toString());
}

extension ListIntX on List<int> {
  /// Converts a [List] of int to a [Uint8List].
  Uint8List toTypedList() => Uint8List.fromList(this);
}

extension ListUint8ListX on List<Uint8List> {
  /// Reduce a [List] of [Uint8List] to a [Uint8List].
  Uint8List combine() {
    if (isEmpty) return Uint8List(0);
    return reduce((value, element) => value.plus(element));
  }
}

extension StringX on String {
  /// Converts a [String] to a [Uint8List] using the specified [Encoding].
  Uint8List toBytes({final Encoding from = Encoding.utf16}) {
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

extension Uint8ListX on Uint8List {
  /// Converts a [Uint8List] to a [String] using the specified [Encoding].
  String toStr({final Encoding to = Encoding.utf16}) {
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

  /// Returns a concatenation of this with the other [Uint8List].
  Uint8List plus(final Uint8List other) => [...this, ...other].toTypedList();

  /// Returns a sublist of this from the [start] index to the [end] index.
  /// If [end] is greater than the length of the list, it is set to the length
  Uint8List trySublist(int start, [int? end]) {
    if (isEmpty) return this;

    int ending = end ?? length;
    if (ending > length) ending = length;

    return sublist(start, ending);
  }
}
