// Copyright (c) 2020
// Author: Hugo Pointcheval

import 'dart:typed_data';

import 'package:native_crypto/src/digest.dart';
import 'package:native_crypto/src/exceptions.dart';
import 'package:native_crypto/src/key.dart';

import 'platform.dart';

enum KdfAlgorithm { PBKDF2, SCrypt }

/// Represents a Key Derivation Function
abstract class KeyDerivation {
  /// Returns the standard algorithm name for this key derivation function
  KdfAlgorithm get algorithm;

  /// Returns the derivated key
  SecretKey get key;

  /// Derive key
  Future<void> derive();
}

class PBKDF2 implements KeyDerivation {
  SecretKey _sk;

  int _length;
  int _iteration;
  HashAlgorithm _hash;

  @override
  KdfAlgorithm get algorithm => KdfAlgorithm.PBKDF2;

  @override
  SecretKey get key => _sk;

  PBKDF2({
    int keyLength: 32,
    int iteration: 10000,
    HashAlgorithm hash: HashAlgorithm.SHA256,
  }) {
    _length = keyLength;
    _iteration = iteration;
    _hash = hash;
  }

  @override
  Future<void> derive({String password, String salt}) async {
    if (password == null || salt == null) {
      throw KeyDerivationException("Password or Salt can't be null!");
    }
    if (_hash == null) {
      throw KeyDerivationException("Hash Algorithm can't be null!");
    }

    Uint8List derivation = await Platform().pbkdf2(
      password,
      salt,
      keyLength: _length,
      iteration: _iteration,
      algorithm: _hash,
    );

    _sk = SecretKey.fromBytes(derivation);
  }
}

class Scrypt implements KeyDerivation {
  @override
  KdfAlgorithm get algorithm => KdfAlgorithm.SCrypt;

  @override
  SecretKey get key => throw UnimplementedError();

  @override
  Future<void> derive() {
    throw UnimplementedError();
  }
}
