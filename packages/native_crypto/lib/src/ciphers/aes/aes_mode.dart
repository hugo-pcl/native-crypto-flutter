// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: aes_mode.dart
// Created Date: 23/05/2022 22:09:16
// Last Modified: 26/05/2022 21:03:26
// -----
// Copyright (c) 2022

import 'package:native_crypto/src/ciphers/aes/aes_padding.dart';

/// Defines the AES modes of operation.
enum AESMode {
  gcm([AESPadding.none], 12, 16);

  /// Returns the list of supported [AESPadding] for this [AESMode].
  final List<AESPadding> supportedPaddings;

  /// Returns the default IV length for this [AESMode].
  final int ivLength;

  /// Returns the default tag length for this [AESMode].
  final int tagLength;

  const AESMode(
    this.supportedPaddings, [
    this.ivLength = 16,
    this.tagLength = 0,
  ]);
}
