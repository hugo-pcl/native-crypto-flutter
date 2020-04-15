// Copyright (c) 2020
// Author: Hugo Pointcheval
import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class NativeCrypto {
  static const String _tag = 'fr.pointcheval.native_crypto';
  static const MethodChannel _channel =
      const MethodChannel('native.crypto.helper');

  Future<Uint8List> sumKeygen() async {
    final Uint8List aesKey = await _channel.invokeMethod('symKeygen');

    log('AES Key Length: ${aesKey.length}', name: _tag);
    print('AES Key: $aesKey');

    return aesKey;
  }

  Future<List<Uint8List>> symEncrypt(
      Uint8List payloadbytes, Uint8List aesKey) async {
    final List<Uint8List> encryptedPayload =
        await _channel.invokeListMethod('symEncrypt', <String, dynamic>{
      'payload': payloadbytes,
      'aesKey': aesKey,
    });

    log('Payload Length: ${payloadbytes.length}', name: _tag);
    log('Cipher Length: ${encryptedPayload.first.length}', name: _tag);
    print('Cipher: ${encryptedPayload.first}');
    log('IV Length: ${encryptedPayload.last.length}', name: _tag);
    print('IV: ${encryptedPayload.last}');
    
    return encryptedPayload;
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
