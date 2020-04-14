// Copyright (c) 2020
// Author: Hugo Pointcheval
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class NativeCrypto {
  static const MethodChannel _channel =
      const MethodChannel('native.crypto.helper');

  Future<Uint8List> sumKeygen() async {
    final Uint8List aesKey = await _channel.invokeMethod('symKeygen');

    return aesKey;
  }

  Future<List<Uint8List>> symEncrypt(
      Uint8List payloadbytes, Uint8List aesKey) async {
    final List<Uint8List> encyptedPayload =
        await _channel.invokeListMethod('symEncrypt', <String, dynamic>{
      'payload': payloadbytes,
      'aesKey': aesKey,
    });

    return encyptedPayload;
  }

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
