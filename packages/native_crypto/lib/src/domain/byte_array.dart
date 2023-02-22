// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:native_crypto/src/core/enums/encoding.dart';
import 'package:native_crypto/src/core/extensions/list_int_extension.dart';
import 'package:native_crypto/src/core/extensions/string_extension.dart';
import 'package:native_crypto/src/core/extensions/uint8_list_extension.dart';

/// {@template byte_array}
/// Represents a byte array.
///
/// [ByteArray] wraps a [Uint8List] and provides some useful conversion methods.
/// {@endtemplate}
abstract class ByteArray extends Equatable {
  /// {@macro byte_array}
  const ByteArray(this._bytes);

  /// Creates a [ByteArray] object from a [List] of [int].
  ByteArray.fromList(List<int> list) : _bytes = list.toTypedList();

  /// Creates an empty [ByteArray] object from a length.
  ByteArray.fromLength(int length, {int fill = 0})
      : _bytes = Uint8List(length)..fillRange(0, length, fill);

  /// Creates a [ByteArray] object from an UTF-16 string.
  ByteArray.fromUtf16(String encoded) : _bytes = encoded.toBytes();

  /// Creates a [ByteArray] object from an UTF-8 string.
  ByteArray.fromUtf8(String encoded)
      : _bytes = encoded.toBytes(from: Encoding.utf8);

  /// Creates a [ByteArray] object from a Base64 string.
  ByteArray.fromBase64(String encoded)
      : _bytes = encoded.toBytes(from: Encoding.base64);

  /// Creates a [ByteArray] object from a hexdecimal string.
  ByteArray.fromBase16(String encoded)
      : _bytes = encoded.toBytes(from: Encoding.base16);

  final Uint8List _bytes;

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

  /// Gets the [ByteArray] length in bytes.
  int get length => _bytes.length;

  @override
  List<Object?> get props => [_bytes];
}
