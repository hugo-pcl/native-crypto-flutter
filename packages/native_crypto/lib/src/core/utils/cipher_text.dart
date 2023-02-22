// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:native_crypto/src/core/constants/constants.dart';
import 'package:native_crypto/src/core/extensions/uint8_list_extension.dart';
import 'package:native_crypto/src/core/utils/chunk_factory.dart';
import 'package:native_crypto/src/domain/byte_array.dart';
import 'package:native_crypto/src/domain/cipher_chunk.dart';

/// {@template cipher_text}
/// A [CipherText] is a [ByteArray] that is used to store a text encrypted by a
/// Cipher.
/// {@endtemplate}
class CipherText<T extends CipherChunk> extends ByteArray {
  /// {@macro cipher_text}
  CipherText(
    super.bytes, {
    required ChunkFactory<T> this.chunkFactory,
    this.chunkSize = Constants.defaultChunkSize,
  }) : chunks = bytes.chunked(chunkSize).map(chunkFactory).toList();

  /// Creates a [CipherText] from a [List<T>] of [CipherChunk].
  CipherText.fromChunks(
    this.chunks, {
    required ChunkFactory<T> this.chunkFactory,
    this.chunkSize = Constants.defaultChunkSize,
  }) : super(
          chunks.fold<Uint8List>(
            Uint8List(0),
            (acc, chunk) => acc | chunk.bytes,
          ),
        );

  /// Factory used to create [CipherChunk] from an Uint8List.
  final ChunkFactory<T>? chunkFactory;

  /// List of [CipherChunk] that compose the [CipherText].
  final List<T> chunks;

  /// Size of one chunk.
  final int chunkSize;
}
