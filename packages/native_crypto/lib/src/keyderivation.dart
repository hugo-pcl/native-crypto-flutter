// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: kdf.dart
// Created Date: 18/12/2021 11:56:43
// Last Modified: 28/12/2021 13:38:02
// -----
// Copyright (c) 2021

import './keys/secret_key.dart';

enum KdfAlgorithm { pbkdf2 }

/// Represents a Key Derivation Function
abstract class KeyDerivation {
  /// Returns the standard algorithm name for this key derivation function
  KdfAlgorithm get algorithm;

  /// Derive key
  Future<SecretKey> derive();
}