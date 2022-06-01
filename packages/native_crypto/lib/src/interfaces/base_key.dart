// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: base_key.dart
// Created Date: 16/12/2021 16:28:00
// Last Modified: 26/05/2022 17:40:38
// -----
// Copyright (c) 2021

import 'package:native_crypto/src/interfaces/byte_array.dart';

/// Represents a key in NativeCrypto.
///
/// [BaseKey] is a [ByteArray] that can be used to store keys.
///
/// This interface is implemented by all the key classes.
abstract class BaseKey extends ByteArray {
  const BaseKey(super.bytes);
  BaseKey.fromBase16(super.encoded) : super.fromBase16();
  BaseKey.fromBase64(super.encoded) : super.fromBase64();
  BaseKey.fromUtf8(super.input) : super.fromUtf8();
}
