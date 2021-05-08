// Copyright (c) 2021
// Author: Hugo Pointcheval

import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'platform.dart';

import 'exceptions.dart';
import 'keyspec.dart';
import 'cipher.dart';
import 'utils.dart';

/// This is the base class of all key types.
abstract class Key {
  Uint8List _bytes;
  String _algo;

  /// Returns key as raw byte array.
  Uint8List get encoded => _bytes;

  /// Returns the standard algorithm name for this key
  String get algorithm => _algo;

  /// Returns the true if this key is null or empty.
  bool get isEmpty => (_bytes == null || _bytes.length == 0);

  Key({Uint8List bytes, String algorithm}) {
    _bytes = bytes;
    _algo = algorithm;
  }
}

/// This represents a secret key, usefull in
/// algorithms like AES or BlowFish.
class SecretKey extends Key {
  /// Creates a key from raw byte array
  SecretKey.fromBytes(Uint8List bytes,
      {CipherAlgorithm algorithm: CipherAlgorithm.None})
      : super(bytes: bytes, algorithm: algorithm.name);

  /// Creates a key from a specific size.
  static Future<SecretKey> generate(int size, CipherAlgorithm algorithm) async {
    if (algorithm == null) {
      throw KeyException("Algorithm can't be null");
    } else if (algorithm == CipherAlgorithm.AES) {
      List<int> _supportedSizes = [128, 192, 256];
      if (!_supportedSizes.contains(size)) {
        throw KeyException("AES must be 128, 192 or 256 bits long.");
      }
    }

    try {
      Uint8List _key = await Platform().keygen(size);
      return SecretKey.fromBytes(_key, algorithm: algorithm);
    } on PlatformException catch (e) {
      throw KeyException(e);
    }
  }
}

/// This represents a keypair, usefull in
/// algorithms like RSA.
class KeyPair extends Key {
  PublicKey _publicKey;
  PrivateKey _privateKey;

  /// Returns public key of this key pair.
  PublicKey get publicKey => _publicKey;

  /// Returns private key of this key pair.
  PrivateKey get privateKey => _privateKey;

  /// Returns true if key pair contains public AND private keys
  bool get isComplete => (_publicKey != null && _privateKey != null);

  /// Creates a key pair from public and private keys.
  KeyPair.from(PublicKey publicKey, PrivateKey privateKey, {String algorithm}) {
    _publicKey = publicKey;
    _privateKey = privateKey;
    _algo = algorithm;
  }

  /// Creates a key pair from a specific size.
  static Future<KeyPair> generate(KeySpec keySpec) async {
    List<String> _supportedAlgorithms = ["RSA"];
    if (!_supportedAlgorithms.contains(keySpec.algorithm)) {
      throw KeyException(keySpec.algorithm + " not supported!");
    }
    if (keySpec.algorithm == "RSA") {
      RSAKeySpec spec = keySpec;
      try {
        List<Uint8List> kp = await Platform().rsaKeypairGen(spec.size);
        PublicKey _publicKey = PublicKey.fromBytes(kp.first, "RSA");
        PrivateKey _privateKey = PrivateKey.fromBytes(kp.last, "RSA");
        return KeyPair.from(_publicKey, _privateKey, algorithm: "RSA");
      } on PlatformException catch (e) {
        throw KeyException(e);
      }
    } else {
      throw NotImplementedException("KeyPair generation not yet implemented.");
    }
  }
}

/// This represents a public key
class PublicKey extends Key {
  /// Creates a public key from raw byte array
  PublicKey.fromBytes(Uint8List bytes, String algorithm)
      : super(bytes: bytes, algorithm: algorithm);
}

/// This represents a private key
class PrivateKey extends Key {
  /// Creates a private key from raw byte array
  PrivateKey.fromBytes(Uint8List bytes, String algorithm)
      : super(bytes: bytes, algorithm: algorithm);
}
