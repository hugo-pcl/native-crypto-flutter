// Copyright 2019-2023 Hugo Pointcheval
// 
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:native_crypto_platform_interface/src/gen/messages.g.dart';

abstract class EnumParser {
  static HashAlgorithm hashAlgorithmFromString(String value) {
    for (final algorithm in HashAlgorithm.values) {
      if (algorithm.name == value) {
        return algorithm;
      }
    }
    throw ArgumentError('Invalid algorithm: $value');
  }

  static CipherAlgorithm cipherAlgorithmFromString(String value) {
    for (final algorithm in CipherAlgorithm.values) {
      if (algorithm.name == value) {
        return algorithm;
      }
    }
    throw ArgumentError('Invalid algorithm: $value');
  }
}
