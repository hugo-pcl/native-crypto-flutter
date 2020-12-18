// Copyright (c) 2020
// Author: Hugo Pointcheval

import 'package:native_crypto/src/exceptions.dart';
import 'package:native_crypto/src/kem.dart';
import 'package:native_crypto/src/key.dart';

/// This represents RSA Key Encapsulation Mechanism
class RSAKeyEncapsulationMechanism implements KeyEncapsulationMechanism {
  bool _isInit = false;
  KemMode _mode;

  PublicKey _publicKey;
  PrivateKey _privateKey;

  @override
  KemAlgorithm get algorithm => KemAlgorithm.RSA;

  @override
  Object get options => null;

  @override
  bool get isInitialized => _isInit;

  @override
  KemMode get mode => _mode;

  @override
  KeyPair get keypair => KeyPair.from(_publicKey, _privateKey);

  RSAKeyEncapsulationMechanism(
    KemMode mode, {
    KeyPair keyPair,
    PublicKey publicKey,
  }) {
    _mode = mode;
    if (_mode == KemMode.ENCAPSULATION) {
      if (publicKey != null) {
        _isInit = true;
        _publicKey = publicKey;
      } else if (keyPair != null) {
        if (keyPair.publicKey != null) {
          _isInit = true;
          _publicKey = keyPair.publicKey;
        }
      }
    } else if (_mode == KemMode.DECAPSULATION) {
      if (keyPair != null) {
        if (keyPair.isComplete) {
          _isInit = true;
          _publicKey = keyPair.publicKey;
          _privateKey = keyPair.privateKey;
        } else {
          throw KemInitException("Keypair must be complete for decapsulation.");
        }
      } else {
        throw KemInitException("You must provide a keypair for decapsulation.");
      }
    }
  }

  @override
  Future<Encapsulation> encapsulate() {
    if (!_isInit) {
      throw KemInitException("KEM not properly initialized.");
    }
    throw UnimplementedError();
  }

  @override
  Future<SecretKey> decapsulate(Encapsulation encapsulation) {
    throw UnimplementedError();
  }
}
