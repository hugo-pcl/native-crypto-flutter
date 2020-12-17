// Copyright (c) 2020
// Author: Hugo Pointcheval

import 'dart:typed_data';

import 'key.dart';

enum KemMode { ENCAPSULATION, DECAPSULATION }

abstract class KeyEncapsulationMechanism {
  /// Returns the standard algorithm name for this kem
  String get algorithm;

  /// Returns the parameters used for this kem
  Object get options;

  /// Returns true if kem is initialized
  bool get isInitialized;

  /// Returns mode used in this kem.
  KemMode get mode;

  /// Returns key pair used in this kem.
  ///
  /// Can be an incomplete if just have public key
  /// for example.
  KeyPair get keypair;

  /// Encapsulate key.
  ///
  /// Returns an [Encapsulation].
  Future<Encapsulation> encapsulate();

  /// Decapsulate key.
  ///
  /// Takes [Encapsulation] as parameter.
  /// And returns plain text key as [SecretKey].
  Future<SecretKey> decapsulate(Encapsulation encapsulation);
}

abstract class Encapsulation {
  /// Returns the standard algorithm name used for this encapsulation
  String get algorithm;

  /// Returns the secret key used in this encapsulation
  SecretKey get secretKey;

  /// Returns the encapsulated key
  Uint8List get key;
}
