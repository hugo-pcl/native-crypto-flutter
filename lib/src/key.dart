// Copyright (c) 2020
// Author: Hugo Pointcheval

import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'platform.dart';

import 'exceptions.dart';
import 'keyspec.dart';

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
  List<String> _supportedAlgorithms = ["AES", "Blowfish"];

  /// Creates a key from raw byte array
  SecretKey.fromBytes(Uint8List bytes) : super(bytes: bytes);

  /// Creates a key from a specific size.
  SecretKey.generate(String algorithm, int size) {
    if (!_supportedAlgorithms.contains(algorithm)) {
      throw KeyException(algorithm + " not supported!");
    } else if (algorithm == "AES") {
      List<int> supportedSizes = [128, 192, 256];
      if (!supportedSizes.contains(size)) {
        throw KeyException("AES must be 128, 192 or 256 bits long.");
      }
    } else if (algorithm == "Blowfish") {
      List<int> supportedSizes =
          List<int>.generate(52, (int index) => (index + 4) * 8);
      if (!supportedSizes.contains(size)) {
        throw KeyException(
            "Blowfish must be between 4 and 56 bytes (32 and 448 bits) long.");
      }
    }
    _generate(algorithm, size);
  }

  Future<void> _generate(String algo, int size) async {
    try {
      _bytes = await Platform().keygen(size);
      _algo = algo;
      log("Generated SecretKey size: ${_bytes.length * 8} bits (${_bytes.length} bytes)",
          name: "NativeCrypto");
    } on PlatformException catch (e) {
      log(e.message, name: "NativeCrypto");
      throw KeyException(e);
    }
  }
}

/// This represents a keypair, usefull in
/// algorithms like RSA.
class KeyPair extends Key {
  List<String> _supportedAlgorithms = ["RSA"];

  PublicKey _publicKey;
  PrivateKey _privateKey;

  /// Returns public key of this key pair.
  PublicKey get publicKey => _publicKey;

  /// Returns private key of this key pair.
  PrivateKey get privateKey => _privateKey;

  /// Returns true if key pair contains public AND private keys
  bool get isComplete => (_publicKey != null && _privateKey != null);

  /// Creates a key pair from public and private keys.
  KeyPair.from(PublicKey publicKey, PrivateKey privateKey) {
    _publicKey = publicKey;
    _privateKey = privateKey;
  }

  /// Creates a key pair from a specific size.
  KeyPair.generate(KeySpec keySpec) {
    if (!_supportedAlgorithms.contains(keySpec.algorithm)) {
      throw KeyException(keySpec.algorithm + " not supported!");
    }
    _generate(keySpec);
  }

  Future<void> _generate(KeySpec keySpec) async {
    if (keySpec.algorithm == "RSA") {
      RSAKeySpec spec = keySpec;
      try {
        List<Uint8List> kp = await Platform().rsaKeypairGen(spec.size);
        _publicKey = PublicKey.fromBytes(kp.first);
        _privateKey = PrivateKey.fromBytes(kp.last);
        _algo = "RSA";
        log("Generated public and private keys size: ${_publicKey.encoded.length * 8} bits (${_publicKey.encoded.length} bytes)",
            name: "NativeCrypto");
      } on PlatformException catch (e) {
        log(e.message, name: "NativeCrypto");
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
  PublicKey.fromBytes(Uint8List bytes) : super(bytes: bytes);
}

/// This represents a private key
class PrivateKey extends Key {
  /// Creates a private key from raw byte array
  PrivateKey.fromBytes(Uint8List bytes) : super(bytes: bytes);
}
