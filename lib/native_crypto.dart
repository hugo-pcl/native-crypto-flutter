// Copyright (c) 2020
// Author: Hugo Pointcheval
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

/// Plugin class.
/// Contains raw functions.
/// 
/// You can use [symmetrical_crypto] for an **AES Helper**.
class NativeCrypto {
  static const MethodChannel _channel =
      const MethodChannel('native.crypto.helper');

  /// Generates AES key.
  ///
  /// Size of **256 bits** by design.
  /// And returns `Uint8List`.
  Future<Uint8List> symKeygen() async {
    final Uint8List aesKey = await _channel.invokeMethod('symKeygen');
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