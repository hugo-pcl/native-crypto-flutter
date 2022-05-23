// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: byte_array.dart
// Created Date: 16/12/2021 17:54:16
// Last Modified: 23/05/2022 21:44:38
// -----
// Copyright (c) 2021

import 'dart:convert' as convert;
import 'dart:typed_data';

import 'package:native_crypto/src/utils.dart';

class ByteArray {
  Uint8List _bytes;

  ByteArray(this._bytes);

  /// Creates an ByteArray object from a hexdecimal string.
  ByteArray.fromBase16(String encoded)
      : _bytes = Utils.decodeHexString(encoded);

  /// Creates an ByteArray object from a Base64 string.
  ByteArray.fromBase64(String encoded)
      : _bytes = convert.base64.decode(encoded);

  /// Creates an ByteArray object from a UTF-8 string.
  ByteArray.fromUtf8(String input)
      : _bytes = Uint8List.fromList(convert.utf8.encode(input));

  /// Creates an ByteArray object from a length.
  ByteArray.fromLength(int length) : _bytes = Uint8List(length);

  /// Gets the ByteArray bytes.
  // ignore: unnecessary_getters_setters
  Uint8List get bytes => _bytes;

  /// Sets the ByteArray bytes.
  set bytes(Uint8List value) => _bytes = value;

  /// Gets the ByteArray bytes as a Hexadecimal representation.
  String get base16 =>
      _bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

  /// Gets the ByteArray bytes as a Base64 representation.
  String get base64 => convert.base64.encode(_bytes);

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
