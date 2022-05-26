// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: aes_mode.dart
// Created Date: 23/05/2022 22:09:16
// Last Modified: 26/05/2022 18:41:31
// -----
// Copyright (c) 2022

import 'package:native_crypto/src/ciphers/aes/aes_padding.dart';

/// Defines the AES modes of operation.
enum AESMode {
  gcm([AESPadding.none]);

  /// Returns the list of supported [AESPadding] for this [AESMode].
  final List<AESPadding> supportedPaddings;

  const AESMode(this.supportedPaddings);
}
