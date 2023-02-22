// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:native_crypto/src/domain/cipher_chunk.dart';

/// A factory that creates a [CipherChunk] of type [T] from a [Uint8List].
typedef ChunkFactory<T extends CipherChunk> = T Function(Uint8List chunk);
