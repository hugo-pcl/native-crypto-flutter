// Copyright (c) 2020
// Author: Hugo Pointcheval
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

/// [Sources]
/// Plugin class.
/// Contains raw functions.
/// 
/// Use [symmetrical_crypto] for an **AES API**.
class NativeCrypto {
  /// [Private]
  /// Contains the channel for platform specific code.
  static const MethodChannel _channel =
      const MethodChannel('native.crypto.helper');

  /// Generates AES key.
  ///
  /// [size] is in bits, 128, 192 or 256. 
  /// It returns an `Uint8List`.
  Future<Uint8List> symKeygen(int size) async {
    final Uint8List aesKey = await _channel.invokeMethod('symKeygen', <String, dynamic>{
      'size': size
    });
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
    final Uint8List decryptedPayload =
        await _channel.invokeMethod('symDecrypt', <String, dynamic>{
      'payload': payloadbytes,
      'aesKey': aesKey,
    });
    return decryptedPayload;
  }
}