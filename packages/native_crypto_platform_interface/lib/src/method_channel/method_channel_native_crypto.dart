// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: native_crypto_method_channel.dart
// Created Date: 25/12/2021 16:58:04
// Last Modified: 24/05/2022 22:59:32
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:native_crypto_platform_interface/src/platform_interface/native_crypto_platform.dart';

/// An implementation of [NativeCryptoPlatform] that uses method channels.
class MethodChannelNativeCrypto extends NativeCryptoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  MethodChannel channel = const MethodChannel('plugins.hugop.cl/native_crypto');

  @override
  Future<Uint8List?> digest(Uint8List data, String algorithm) {
    return channel.invokeMethod<Uint8List>(
      'digest',
      <String, dynamic>{
        'data': data,
        'algorithm': algorithm,
      },
    );
  }

  @override
  Future<Uint8List?> generateSecretKey(int bitsCount) {
    return channel.invokeMethod<Uint8List>(
      'generateSecretKey',
      <String, dynamic>{
        'bitsCount': bitsCount,
      },
    );
  }

  @override
  Future<Uint8List?> pbkdf2(
    String password,
    String salt,
    int keyBytesCount,
    int iterations,
    String algorithm,
  ) {
    return channel.invokeMethod<Uint8List>(
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
  Future<List<Uint8List>?> encryptAsList(
    Uint8List data,
    Uint8List key,
    String algorithm,
  ) {
    return channel.invokeListMethod(
      'encryptAsList',
      <String, dynamic>{
        'data': data,
        'key': key,
        'algorithm': algorithm,
      },
    );
  }

  @override
  Future<Uint8List?> decryptAsList(
    List<Uint8List> data,
    Uint8List key,
    String algorithm,
  ) {
    return channel.invokeMethod<Uint8List>(
      'decryptAsList',
      <String, dynamic>{
        'data': data,
        'key': key,
        'algorithm': algorithm,
      },
    );
  }

  @override
  Future<Uint8List?> encrypt(
    Uint8List data,
    Uint8List key,
    String algorithm,
  ) {
    return channel.invokeMethod<Uint8List>(
      'encrypt',
      <String, dynamic>{
        'data': data,
        'key': key,
        'algorithm': algorithm,
      },
    );
  }

  @override
  Future<Uint8List?> decrypt(
    Uint8List data,
    Uint8List key,
    String algorithm,
  ) {
    return channel.invokeMethod<Uint8List>(
      'decrypt',
      <String, dynamic>{
        'data': data,
        'key': key,
        'algorithm': algorithm,
      },
    );
  }
}
