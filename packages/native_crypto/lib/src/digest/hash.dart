// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:native_crypto/src/core/enums/hash_algorithm.dart';
import 'package:native_crypto/src/core/utils/platform.dart';
import 'package:native_crypto/src/domain/hash.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

class _Hash extends Hash {
  const _Hash(this.algorithm);

  @override
  Future<Uint8List> digest(Uint8List data) async {
    final hash = await platform.hash(data, algorithm: algorithm.name);

    // TODO(hpcl): move these checks to the platform interface
    if (hash == null) {
      throw const NativeCryptoException(
        code: NativeCryptoExceptionCode.nullError,
        message: 'Platform returned null bytes',
      );
    }

    if (hash.isEmpty) {
      throw const NativeCryptoException(
        code: NativeCryptoExceptionCode.invalidData,
        message: 'Platform returned no data.',
      );
    }

    return hash;
  }

  @override
  final HashAlgorithm algorithm;
}

/// A [Hash] that uses the SHA-256 algorithm.
class Sha256 extends _Hash {
  factory Sha256() => _instance ??= Sha256._();
  Sha256._() : super(HashAlgorithm.sha256);
  static Sha256? _instance;
}

/// A [Hash] that uses the SHA-384 algorithm.
class Sha384 extends _Hash {
  factory Sha384() => _instance ??= Sha384._();
  Sha384._() : super(HashAlgorithm.sha384);
  static Sha384? _instance;
}

/// A [Hash] that uses the SHA-512 algorithm.
class Sha512 extends _Hash {
  factory Sha512() => _instance ??= Sha512._();
  Sha512._() : super(HashAlgorithm.sha512);
  static Sha512? _instance;
}
