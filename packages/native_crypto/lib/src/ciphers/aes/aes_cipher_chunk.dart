// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:native_crypto/src/domain/cipher_chunk.dart';

class AESCipherChunk extends CipherChunk {
  const AESCipherChunk(
    super.bytes, {
    required this.ivLength,
    required this.tagLength,
  });

  /// Creates a [AESCipherChunk] from a [List<int>].
  AESCipherChunk.fromList(
    super.list, {
    required this.ivLength,
    required this.tagLength,
  }) : super.fromList();

  /// Creates a [AESCipherChunk] from a [String] encoded in UTF-8.
  AESCipherChunk.fromUtf8(
    super.encoded, {
    required this.ivLength,
    required this.tagLength,
  }) : super.fromUtf8();

  /// Creates a [AESCipherChunk] from a [String] encoded in UTF-16.
  AESCipherChunk.fromUtf16(
    super.encoded, {
    required this.ivLength,
    required this.tagLength,
  }) : super.fromUtf16();

  /// Creates a [AESCipherChunk] from a [String] encoded in Hexadecimal.
  AESCipherChunk.fromBase16(
    super.encoded, {
    required this.ivLength,
    required this.tagLength,
  }) : super.fromBase16();

  /// Creates a [AESCipherChunk] from a [String] encoded in Base64.
  AESCipherChunk.fromBase64(
    super.encoded, {
    required this.ivLength,
    required this.tagLength,
  }) : super.fromBase64();

  /// Intialization vector length.
  final int ivLength;

  /// Tag length.
  final int tagLength;

  /// Returns the initialization vector, or nonce of the [AESCipherChunk].
  Uint8List get iv => bytes.sublist(0, ivLength);

  /// Returns the tag of the [AESCipherChunk].
  Uint8List get tag => bytes.sublist(bytes.length - tagLength, bytes.length);

  /// Returns the message of the [AESCipherChunk].
  Uint8List get message => bytes.sublist(ivLength, bytes.length - tagLength);
}
