// Copyright (c) 2020
// Author: Hugo Pointcheval
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:native_crypto/exceptions.dart';

/// [Sources]
/// Plugin class.
/// Contains raw functions and specific platform calls.
/// 
/// Use [symmetrical_crypto] for an **AES Layer API**.
class NativeCrypto {
  /// [Private]
  /// Contains the channel for platform specific code.
  static const MethodChannel _channel =
      const MethodChannel('native.crypto.helper');

  /// PBKDF2.
  ///
  /// [keyLength] is in Bytes. 
  /// It returns an `Uint8List`.
  Future<Uint8List> pbkdf2(String password, String salt, {int keyLength: 32, int iteration: 10000}) async {
    Uint8List key;
    try {
      key = await _channel.invokeMethod('pbkdf2', <String, dynamic>{
      'password': password,
      'salt': salt,
      'keyLength': keyLength,
      'iteration': iteration,
    });
    } on PlatformException catch (e) {
      throw e;
    }
    return key;
  }
  
  /// Generates AES key.
  ///
  /// [size] is in bits, 128, 192 or 256. 
  /// It returns an `Uint8List`.
  Future<Uint8List> symKeygen(int size) async {
    Uint8List aesKey;
    try {
      aesKey = await _channel.invokeMethod('symKeygen', <String, dynamic>{
      'size': size,
    });
    } on PlatformException catch (e) {
      throw e;
    }
    return aesKey;
  }

  /// Encrypts passed data with a given AES key.
  ///
  /// Generates a random **IV**. Returns a list
  /// of `Uint8List` with encrypted cipher as first
  /// and IV as second member.
  Future<List<Uint8List>> symEncrypt(
      Uint8List payloadbytes, Uint8List aesKey) async {
    final List<Uint8List> encryptedPayload =
        await _channel.invokeListMethod('symEncrypt', <String, dynamic>{
      'payload': payloadbytes,
      'aesKey': aesKey,
    });
    return encryptedPayload;
  }

  /// Decrypts a passed payload with a given AES key.
  ///
  /// The payload must be a list of `Uint8List`
  /// with encrypted cipher as first and IV as second member.
  Future<Uint8List> symDecrypt(
      List<Uint8List> payloadbytes, Uint8List aesKey) async {
    Uint8List decryptedPayload;
    try {
      decryptedPayload = await _channel.invokeMethod('symDecrypt', <String, dynamic>{
      'payload': payloadbytes,
      'aesKey': aesKey,
    });
    } on PlatformException catch (e) {
      throw DecryptionException(e.message);
    }
    return decryptedPayload;
  }
}