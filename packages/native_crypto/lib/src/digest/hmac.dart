// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:native_crypto/src/core/enums/hash_algorithm.dart';
import 'package:native_crypto/src/core/utils/platform.dart';
import 'package:native_crypto/src/domain/hmac.dart';
import 'package:native_crypto/src/keys/secret_key.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

class _Hmac extends Hmac {
  const _Hmac(this.algorithm);

  @override
  Future<Uint8List> digest(Uint8List data, SecretKey key) async {
    final hmac = await platform.hmac(
      data,
      key: key.bytes,
      algorithm: algorithm.name,
    );

    // TODO(hpcl): move these checks to the platform interface
    if (hmac == null) {
      throw const NativeCryptoException(
        code: NativeCryptoExceptionCode.nullError,
        message: 'Platform returned null bytes',
      );
    }

    if (hmac.isEmpty) {
      throw const NativeCryptoException(
        code: NativeCryptoExceptionCode.invalidData,
        message: 'Platform returned no data.',
      );
    }

    return hmac;
  }

  @override
  final HashAlgorithm algorithm;
}

/// A [Hmac] that uses the SHA-256 algorithm.
class HmacSha256 extends _Hmac {
  factory HmacSha256() => _instance ??= HmacSha256._();
  HmacSha256._() : super(HashAlgorithm.sha256);
  static HmacSha256? _instance;
}

/// A [Hmac] that uses the SHA-384 algorithm.
class HmacSha384 extends _Hmac {
  factory HmacSha384() => _instance ??= HmacSha384._();
  HmacSha384._() : super(HashAlgorithm.sha384);
  static HmacSha384? _instance;
}

/// A [Hmac] that uses the SHA-512 algorithm.
class HmacSha512 extends _Hmac {
  factory HmacSha512() => _instance ??= HmacSha512._();
  HmacSha512._() : super(HashAlgorithm.sha512);
  static HmacSha512? _instance;
}
