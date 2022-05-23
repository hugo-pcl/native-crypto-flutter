// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: kdf.dart
// Created Date: 18/12/2021 11:56:43
// Last Modified: 23/05/2022 22:37:04
// -----
// Copyright (c) 2021

import 'package:native_crypto/src/keys/secret_key.dart';
import 'package:native_crypto/src/utils/kdf_algorithm.dart';

/// Represents a Key Derivation Function
abstract class KeyDerivation {
  /// Returns the standard algorithm name for this key derivation function
  KdfAlgorithm get algorithm;

  /// Derive key
  Future<SecretKey> derive();
}
