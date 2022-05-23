// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: aes_key_size.dart
// Created Date: 23/05/2022 22:10:07
// Last Modified: 23/05/2022 22:33:32
// -----
// Copyright (c) 2022

/// Defines all available key sizes.
enum AESKeySize {
  bits128(128),
  bits192(192),
  bits256(256);

  static final List<int> supportedSizes = [128, 192, 256];

  final int bits;
  int get bytes => bits ~/ 8;

  const AESKeySize(this.bits);
}
