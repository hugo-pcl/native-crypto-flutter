// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:native_crypto/src/ciphers/aes/aes_padding.dart';
import 'package:native_crypto/src/core/constants/constants.dart';

/// {@template aes_mode}
/// Defines the AES modes of operation.
/// {@endtemplate}
enum AESMode {
  /// GCM mode.
  gcm(
    [AESPadding.none],
    Constants.aesGcmNonceLength,
    Constants.aesGcmTagLength,
  );

  /// {@macro aes_mode}
  const AESMode(
    this.supportedPaddings, [
    this.ivLength = 16,
    this.tagLength = 0,
  ]);

  /// Returns the list of supported [AESPadding] for this [AESMode].
  final List<AESPadding> supportedPaddings;

  /// Returns the default IV length for this [AESMode].
  final int ivLength;

  /// Returns the default tag length for this [AESMode].
  final int tagLength;
}
