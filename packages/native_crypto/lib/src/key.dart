// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: key.dart
// Created Date: 16/12/2021 16:28:00
// Last Modified: 28/12/2021 13:37:50
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'byte_array.dart';

/// A class representing a key.
class Key extends ByteArray {
  Key(Uint8List bytes) : super(bytes);
  Key.fromBase16(String encoded) : super.fromBase16(encoded);
  Key.fromBase64(String encoded) : super.fromBase64(encoded);
  Key.fromUtf8(String input) : super.fromUtf8(input);
}
