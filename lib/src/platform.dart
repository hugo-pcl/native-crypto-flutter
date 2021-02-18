// Copyright (c) 2020
// Author: Hugo Pointcheval

import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'cipher.dart';
import 'digest.dart';
import 'exceptions.dart';
import 'utils.dart';

/// Represents a platform, and is usefull to calling
/// methods from a specific platform.
class Platform {
  /// Contains the channel for platform specific code.
  static const MethodChannel _channel = const MethodChannel('native.crypto');

  /// Calls native code.
  static Future<T> call<T>(String method, [Map<String, dynamic> arguments]) {
    return _channel.invokeMethod(method, arguments);
  }

  /// Calls native code that return list.
  static Future<List<T>> callList<T>(String method,
      [Map<String, dynamic> arguments]) {
    return _channel.invokeListMethod(method, arguments);
  }

  /// Digests a message with a specific algorithm
  ///
  /// Takes message and algorithm as parameters.
  ///
  /// Returns a hash as [Uint8List].
  Future<Uint8List> digest(
    Uint8List message,
    HashAlgorithm algorithm,
  ) async {
    try {
      final Uint8List hash = await call('digest', <String, dynamic>{
        'message': message,
        'algorithm': algorithm.name,
      });
      return hash;
    } on PlatformException catch (e) {
      throw DigestException(e.code + " : " + e.message);
    }
  }

  /// Calls native PBKDF2.
  ///
  /// Takes password and salt as parameters.
  /// And optionnally keyLength in bytes, number of iterations and hash algorithm.
  ///
  /// Returns a key as [Uint8List].
  Future<Uint8List> pbkdf2(
    String password,
    String salt, {
    int keyLength: 32,
    int iteration: 10000,
    HashAlgorithm algorithm: HashAlgorithm.SHA256,
  }) async {
    try {
      final Uint8List key = await call('pbkdf2', <String, dynamic>{
        'password': password,
        'salt': salt,
        'keyLength': keyLength,
        'iteration': iteration,
        'algorithm': algorithm.name,
      });
      return key;
    } on PlatformException catch (e) {
      throw KeyDerivationException(e.code + " : " + e.message);
    }
  }

  /// Generates a random key.
  ///
  /// Takes size in bits.
  ///
  /// Returns a key as [Uint8List].
  Future<Uint8List> keygen(int size) async {
    try {
      final Uint8List key = await call('keygen', <String, dynamic>{
        'size': size,
      });
      return key;
    } on PlatformException catch (e) {
      throw KeyGenerationException(e.code + " : " + e.message);
    }
  }

  /// Generates an RSA key pair.
  ///
  /// Takes size in bits.
  ///
  /// Returns a key pair as list of [Uint8List], the public key is the
  /// first element, and the private is the last.
  Future<List<Uint8List>> rsaKeypairGen(int size) async {
    try {
      final List<Uint8List> keypair =
          await call('rsaKeypairGen', <String, dynamic>{
        'size': size,
      });
      return keypair;
    } on PlatformException catch (e) {
      throw KeyPairGenerationException(e.code + " : " + e.message);
    }
  }

  /// Encrypts data with a secret key and algorithm.
  ///
  /// Takes data, key, algorithm, mode and padding as parameters.
  ///
  /// Encrypts data and returns cipher text
  /// and IV as a list of [Uint8List].
  Future<List<Uint8List>> encrypt(
    Uint8List data,
    Uint8List key,
    CipherAlgorithm algorithm,
    CipherParameters parameters,
  ) async {
    try {
      final List<Uint8List> payload =
          await callList('encrypt', <String, dynamic>{
        'data': data,
        'key': key,
        'algorithm': algorithm.name,
        'mode': parameters.mode.name,
        'padding': parameters.padding.name,
      });
      return payload;
    } on PlatformException catch (e) {
      throw EncryptionException(e.code + " : " + e.message);
    }
  }

  /// Decrypts a payload with a secret key and algorithm.
  ///
  /// The payload must be a list of `Uint8List`
  /// with encrypted cipher as first and IV as second member.
  Future<Uint8List> decrypt(
    List<Uint8List> payload,
    Uint8List key,
    CipherAlgorithm algorithm,
    CipherParameters parameters,
  ) async {
    try {
      final Uint8List data =
          await _channel.invokeMethod('decrypt', <String, dynamic>{
        'payload': payload,
        'key': key,
        'algorithm': algorithm.name,
        'mode': parameters.mode.name,
        'padding': parameters.padding.name,
      });
      return data;
    } on PlatformException catch (e) {
      throw DecryptionException(e.code + " : " + e.message);
    }
  }
  Future<Uint8List> encryptFile(
    String inputFilePath,
    String outputFilePath,
    Uint8List key,
    CipherAlgorithm algorithm,
    CipherParameters parameters
  ) async {
    try{
      final Uint8List iv = await _channel.invokeMethod('encryptFile',<String,dynamic>{
        'inputFilePath':inputFilePath,
        'outputFilePath':outputFilePath,
        'key':key,
        'algorithm':algorithm.name,
        'mode':parameters.mode.name,
        'padding':parameters.padding.name
      });
      return iv;
    } on PlatformException catch(e){
        throw EncryptionException(e.code+" : "+e.message);
    }
  }
  Future<bool> decryptFile(
    String inputFilePath,
    String outputFilePath,
    Uint8List key,
    Uint8List iv,
    CipherAlgorithm algorithm,
    CipherParameters parameters
  ) async {
    try{
      final bool result = await _channel.invokeMethod('decryptFile',<String,dynamic>{
        'inputFilePath':inputFilePath,
        'outputFilePath':outputFilePath,
        'key':key,
        'algorithm':algorithm.name,
        'mode':parameters.mode.name,
        'padding':parameters.padding.name,
        'iv':iv
      });
      return result;
    }
    on PlatformException catch(e){
      throw DecryptionException(e.code+" : "+e.message);
    }
  }
}
