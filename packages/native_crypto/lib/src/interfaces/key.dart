// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: key.dart
// Created Date: 16/12/2021 16:28:00
// Last Modified: 23/05/2022 23:02:10
// -----
// Copyright (c) 2021

import 'package:native_crypto/src/interfaces/byte_array.dart';

/// A class representing a key.
abstract class Key extends ByteArray {
  const Key(super.bytes);
  Key.fromBase16(super.encoded) : super.fromBase16();
  Key.fromBase64(super.encoded) : super.fromBase64();
  Key.fromUtf8(super.input) : super.fromUtf8();
}
