// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: aes_key_size.dart
// Created Date: 23/05/2022 22:10:07
// Last Modified: 26/05/2022 18:45:01
// -----
// Copyright (c) 2022

/// Defines all available key sizes.
enum AESKeySize {
  bits128(128),
  bits192(192),
  bits256(256);

  /// Returns the number of bits supported by an [AESKeySize].
  static final List<int> supportedSizes = [128, 192, 256];

  /// Returns the number of bits in this [AESKeySize].
  final int bits;

  /// Returns the number of bytes in this [AESKeySize].
  int get bytes => bits ~/ 8;

  const AESKeySize(this.bits);
}
