// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: byte_array.dart
// Created Date: 16/12/2021 17:54:16
// Last Modified: 26/05/2022 14:25:05
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:native_crypto/src/utils/encoding.dart';
import 'package:native_crypto/src/utils/extensions.dart';

@immutable
abstract class ByteArray {
  final Uint8List _bytes;

  /// Creates a [ByteArray] from a [Uint8List].
  const ByteArray(this._bytes);

  /// Creates a [ByteArray] object from a hexdecimal string.
  ByteArray.fromBase16(String encoded)
      : _bytes = encoded.toBytes(from: Encoding.base16);

  /// Creates a [ByteArray] object from a Base64 string.
  ByteArray.fromBase64(String encoded)
      : _bytes = encoded.toBytes(from: Encoding.base64);

  /// Creates a [ByteArray] object from an UTF-8 string.
  ByteArray.fromUtf8(String encoded)
      : _bytes = encoded.toBytes(from: Encoding.utf8);

  /// Creates a [ByteArray] object from an UTF-16 string.
  ByteArray.fromUtf16(String encoded) : _bytes = encoded.toBytes();

  /// Creates an empty [ByteArray] object from a length.
  ByteArray.fromLength(int length) : _bytes = Uint8List(length);

  /// Creates a [ByteArray] object from a [List] of [int].
  ByteArray.fromList(List<int> list) : _bytes = list.toTypedList();

  /// Gets the [ByteArray] bytes.
  Uint8List get bytes => _bytes;

  /// Gets the [ByteArray] bytes as a Hexadecimal representation.
  String get base16 => _bytes.toStr(to: Encoding.base16);

  /// Gets the [ByteArray] bytes as a Base64 representation.
  String get base64 => _bytes.toStr(to: Encoding.base64);

  /// Gets the [ByteArray] bytes as an UTF-8 representation.
  String get utf8 => _bytes.toStr(to: Encoding.utf8);

  /// Gets the [ByteArray] bytes as an UTF-16 representation.
  String get utf16 => _bytes.toStr();

  @override
  bool operator ==(Object other) {
    if (other is ByteArray) {
      for (int i = 0; i < _bytes.length; i++) {
        if (_bytes[i] != other._bytes[i]) {
          return false;
        }
      }

      return true;
    }

    return false;
  }

  @override
  int get hashCode {
    int hash = 0;
    for (int i = 0; i < _bytes.length; i++) {
      hash = _bytes[i] + (hash << 6) + (hash << 16) - hash;
    }

    return hash;
  }
}
