// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: native_crypto_method_channel.dart
// Created Date: 25/12/2021 16:58:04
// Last Modified: 25/12/2021 18:58:53
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../native_crypto_platform_interface.dart';

/// An implementation of [NativeCryptoPlatform] that uses method channels.
class MethodChannelNativeCrypto extends NativeCryptoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  MethodChannel methodChannel =
      const MethodChannel('plugins.hugop.cl/native_crypto');

  @override
  Future<Uint8List?> digest(Uint8List data, String algorithm) {
    return methodChannel.invokeMethod<Uint8List>(
      'digest',
      <String, dynamic>{
        'data': data,
        'algorithm': algorithm,
      },
    );
  }

  @override
  Future<Uint8List?> generateSecretKey(int bitsCount) {
    return methodChannel.invokeMethod<Uint8List>(
      'generateSecretKey',
      <String, dynamic>{
        'bitsCount': bitsCount,
      },
    );
  }

  @override
  Future<Uint8List?> generateKeyPair() {
    return methodChannel.invokeMethod<Uint8List>('generateKeyPair');
  }

  @override
  Future<Uint8List?> pbkdf2(String password, String salt, int keyBytesCount,
      int iterations, String algorithm) {
    return methodChannel.invokeMethod<Uint8List>(
      'pbkdf2',
      <String, dynamic>{
        'password': password,
        'salt': salt,
        'keyBytesCount': keyBytesCount,
        'iterations': iterations,
        'algorithm': algorithm,
      },
    );
  }

  @override
  Future<Uint8List?> encrypt(Uint8List data, Uint8List key, String algorithm) {
    return methodChannel.invokeMethod<Uint8List>(
      'encrypt',
      <String, dynamic>{
        'data': data,
        'key': key,
        'algorithm': algorithm,
      },
    );
  }

  @override
  Future<Uint8List?> decrypt(Uint8List data, Uint8List key, String algorithm) {
    return methodChannel.invokeMethod<Uint8List>(
      'decrypt',
      <String, dynamic>{
        'data': data,
        'key': key,
        'algorithm': algorithm,
      },
    );
  }

  @override
  Future<Uint8List?> generateSharedSecretKey(
      Uint8List salt,
      int keyBytesCount,
      Uint8List ephemeralPrivateKey,
      Uint8List otherPublicKey,
      String hkdfAlgorithm) {
    return methodChannel.invokeMethod<Uint8List>(
      'generateSharedSecretKey',
      <String, dynamic>{
        'salt': salt,
        'keyBytesCount': keyBytesCount,
        'ephemeralPrivateKey': ephemeralPrivateKey,
        'otherPublicKey': otherPublicKey,
        'hkdfAlgorithm': hkdfAlgorithm,
      },
    );
  }
}
