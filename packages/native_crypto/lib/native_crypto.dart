// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

/// Fast and powerful cryptographic functions
/// thanks to javax.crypto, CommonCrypto and CryptoKit.
///
/// Author: Hugo Pointcheval
library native_crypto;

export 'package:native_crypto_platform_interface/src/core/exceptions/exception.dart';

export 'src/builders/builders.dart';
export 'src/ciphers/ciphers.dart';
export 'src/core/core.dart';
export 'src/digest/digest.dart';
export 'src/domain/domain.dart';
export 'src/kdf/pbkdf2.dart';
export 'src/keys/secret_key.dart';
export 'src/random/secure_random.dart';
