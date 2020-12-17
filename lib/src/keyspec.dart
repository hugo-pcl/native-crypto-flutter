// Copyright (c) 2020
// Author: Hugo Pointcheval

/// This represents security parameters.
abstract class KeySpec {
  /// Returns the standard algorithm name for this key
  String get algorithm;
}

class RSAKeySpec implements KeySpec {
  int _size;

  String get algorithm => "RSA";

  /// Returns the size of RSA keys
  int get size => _size;

  RSAKeySpec(int size) {
    _size = size;
  }
}
