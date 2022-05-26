// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: kdf.dart
// Created Date: 18/12/2021 11:56:43
// Last Modified: 26/05/2022 18:47:15
// -----
// Copyright (c) 2021

import 'package:native_crypto/src/keys/secret_key.dart';
import 'package:native_crypto/src/utils/kdf_algorithm.dart';

/// Represents a Key Derivation Function (KDF) in NativeCrypto.
/// 
/// [KeyDerivation] function is a function that takes some 
/// parameters and returns a [SecretKey].
abstract class KeyDerivation {
  /// Returns the standard algorithm for this key derivation function
  KdfAlgorithm get algorithm;

  /// Derive a [SecretKey].
  Future<SecretKey> derive();
}
