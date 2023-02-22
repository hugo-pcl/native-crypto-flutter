// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:native_crypto/src/domain/byte_array.dart';

/// {@template cipher_chunk}
/// A [CipherChunk] is a [ByteArray] that is used to store a chunk of data
/// encrypted by a Cipher.
/// {@endtemplate}
abstract class CipherChunk extends ByteArray {
  /// {@macro cipher_chunk}
  const CipherChunk(super.bytes);

  /// Creates a [CipherChunk] from a [List<int>].
  CipherChunk.fromList(super.list) : super.fromList();

  /// Creates a [CipherChunk] from a [String] encoded in UTF-8.
  CipherChunk.fromUtf8(super.encoded) : super.fromUtf8();

  /// Creates a [CipherChunk] from a [String] encoded in UTF-16.
  CipherChunk.fromUtf16(super.encoded) : super.fromUtf16();

  /// Creates a [CipherChunk] from a [String] encoded in Hexadecimal.
  CipherChunk.fromBase16(super.encoded) : super.fromBase16();

  /// Creates a [CipherChunk] from a [String] encoded in Base64.
  CipherChunk.fromBase64(super.encoded) : super.fromBase64();
}
