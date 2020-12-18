// Copyright (c) 2020
// Author: Hugo Pointcheval

import 'package:flutter/foundation.dart';

import 'cipher.dart';
import 'digest.dart';
import 'exceptions.dart';
import 'kem.dart';
import 'keyderivation.dart';

extension HashAlgorithmExtension on HashAlgorithm {
  String get name => describeEnum(this).toLowerCase();
}

extension KdfAlgorithmExtension on KdfAlgorithm {
  String get name => describeEnum(this).toLowerCase();
}

extension CipherAlgorithmExtension on CipherAlgorithm {
  String get name => describeEnum(this).toLowerCase();
}

extension KemAlgorithmExtension on KemAlgorithm {
  String get name => describeEnum(this).toLowerCase();
}

extension BlockCipherModeExtension on BlockCipherMode {
  String get name => describeEnum(this).toLowerCase();
}

extension PaddingExtension on Padding {
  String get name => describeEnum(this).toLowerCase();
}

class Utils {
  /// Returns [HashAlgorithm] from his name.
  static HashAlgorithm getHashAlgorithm(String algorithm) {
    String _query = algorithm.toLowerCase();
    for (HashAlgorithm h in HashAlgorithm.values) {
      if (_query == h.name) {
        return h;
      }
    }
    throw UtilsException("Unknown hash algorithm!");
  }

  /// Returns all available [HashAlgorithm] as String list
  static List<String> getAvailableHashAlgorithms() {
    List<String> _res = [];
    for (HashAlgorithm h in HashAlgorithm.values) {
      _res.add(h.name);
    }
    return _res;
  }

  /// Returns [KdfAlgorithm] from his name.
  static KdfAlgorithm getKdfAlgorithm(String algorithm) {
    String _query = algorithm.toLowerCase();
    for (KdfAlgorithm h in KdfAlgorithm.values) {
      if (_query == h.name) {
        return h;
      }
    }
    throw UtilsException("Unknown key derivation algorithm!");
  }

  /// Returns all available [KdfAlgorithm] as String list
  static List<String> getAvailableKdfAlgorithms() {
    List<String> _res = [];
    for (KdfAlgorithm h in KdfAlgorithm.values) {
      _res.add(h.name);
    }
    return _res;
  }

  /// Returns [CipherAlgorithm] from his name.
  static CipherAlgorithm getCipherAlgorithm(String algorithm) {
    String _query = algorithm.toLowerCase();
    for (CipherAlgorithm c in CipherAlgorithm.values) {
      if (_query == c.name) {
        return c;
      }
    }
    throw UtilsException("Unknown cipher algorithm!");
  }

  /// Returns all available [CipherAlgorithm] as String list
  static List<String> getAvailableCipherAlgorithms() {
    List<String> _res = [];
    for (CipherAlgorithm c in CipherAlgorithm.values) {
      _res.add(c.name);
    }
    return _res;
  }

  /// Returns [KemAlgorithm] from his name.
  static KemAlgorithm getKemAlgorithm(String algorithm) {
    String _query = algorithm.toLowerCase();
    for (KemAlgorithm k in KemAlgorithm.values) {
      if (_query == k.name) {
        return k;
      }
    }
    throw UtilsException("Unknown KEM algorithm!");
  }

  /// Returns all available [KemAlgorithm] as String list
  static List<String> getAvailableKemAlgorithms() {
    List<String> _res = [];
    for (KemAlgorithm k in KemAlgorithm.values) {
      _res.add(k.name);
    }
    return _res;
  }

  /// Returns [CipherParameters] from string.
  ///
  /// For example, `CBC/PKCS5` gives a CipherParameters with
  /// CBC mode and PKCS5 as padding.
  static CipherParameters getCipherParameters(String parameters) {
    List<String> _query = parameters.toLowerCase().split("/");
    BlockCipherMode _mode;
    Padding _padding;
    for (BlockCipherMode b in BlockCipherMode.values) {
      if (_query[0] == b.name) {
        _mode = b;
      }
    }
    for (Padding p in Padding.values) {
      if (_query[1] == p.name) {
        _padding = p;
      }
    }
    if (_mode == null || _padding == null) {
      throw UtilsException("Unknown parameters!");
    } else {
      return CipherParameters(_mode, _padding);
    }
  }
}
