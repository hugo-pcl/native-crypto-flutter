// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

/// {@template aes_key_size}
/// Defines the key size of an AES cipher.
/// {@endtemplate}
enum AESKeySize {
  bits128(128),
  bits192(192),
  bits256(256);

  /// {@macro aes_key_size}
  const AESKeySize(this.bits);

  /// Returns the number of bits supported by an [AESKeySize].
  static final List<int> supportedSizes = [128, 192, 256];

  /// Returns the number of bits in this [AESKeySize].
  final int bits;

  /// Returns the number of bytes in this [AESKeySize].
  int get bytes => bits ~/ 8;
}
