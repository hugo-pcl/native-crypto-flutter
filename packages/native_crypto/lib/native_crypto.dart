// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: native_crypto.dart
// Created Date: 16/12/2021 16:28:00
// Last Modified: 26/05/2022 12:10:42
// -----
// Copyright (c) 2021

/// Fast and powerful cryptographic functions
/// thanks to javax.crypto, CommonCrypto and CryptoKit.
///
/// Author: Hugo Pointcheval
library native_crypto;

export 'package:native_crypto_platform_interface/src/utils/exception.dart';

export 'src/builders/builders.dart';
export 'src/ciphers/ciphers.dart';
export 'src/core/core.dart';
export 'src/interfaces/interfaces.dart';
export 'src/kdf/kdf.dart';
export 'src/keys/keys.dart';
// Utils
export 'src/utils/cipher_algorithm.dart';
export 'src/utils/hash_algorithm.dart';
export 'src/utils/kdf_algorithm.dart';

// ignore: constant_identifier_names
const String AUTHOR = 'Hugo Pointcheval';
