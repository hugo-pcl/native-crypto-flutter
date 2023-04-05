// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:native_crypto/src/domain/byte_array.dart';

/// {@template base_key}
/// Represents a key in NativeCrypto.
///
/// [BaseKey] is a [ByteArray] that can be used to store keys.
///
/// This interface is implemented by all the key classes.
///
/// Note: [BaseKey] is named [BaseKey] instead of Key to avoid conflicts with
/// the Key class from Flutter.
/// {@endtemplate}
abstract class BaseKey extends ByteArray {
  /// {@macro base_key}
  const BaseKey(super.bytes);

  /// Creates a [BaseKey] from a [List<int>].
  BaseKey.fromList(super.list) : super.fromList();

  /// Creates a [BaseKey] from a [String] encoded in UTF-8.
  BaseKey.fromUtf8(super.encoded) : super.fromUtf8();

  /// Creates a [BaseKey] from a [String] encoded in UTF-16.
  BaseKey.fromUtf16(super.encoded) : super.fromUtf16();

  /// Creates a [BaseKey] from a [String] encoded in Hexadecimal.
  BaseKey.fromBase16(super.encoded) : super.fromBase16();

  /// Creates a [BaseKey] from a [String] encoded in Base64.
  BaseKey.fromBase64(super.encoded) : super.fromBase64();
}
