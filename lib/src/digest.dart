// Copyright (c) 2020
// Author: Hugo Pointcheval

import 'dart:typed_data';

import 'exceptions.dart';
import 'platform.dart';
import 'utils.dart';

enum HashAlgorithm { SHA1, SHA128, SHA256, SHA512 }

/// Represents message digest, or hash function.
class MessageDigest {
  HashAlgorithm _algo;

  /// Returns the standard algorithm name for this digest
  HashAlgorithm get algorithm => _algo;

  /// Returns true if digest is initialized
  bool get isInitialized => (_algo != null);

  /// Creates [MessageDigest] with a specific algorithm
  MessageDigest(HashAlgorithm algorithm) {
    _algo = algorithm;
  }

  /// Creates [MessageDigest] from the name of an algorithm
  MessageDigest.getInstance(String algorithm) {
    _algo = Utils.getHashAlgorithm(algorithm);
  }

  /// Hashes a message
  Future<Uint8List> digest(Uint8List data) async {
    if (!isInitialized) {
      throw DigestInitException('Digest not properly initialized.');
    }

    Uint8List hash = await Platform().digest(data, _algo);
    return hash;
  }
}
