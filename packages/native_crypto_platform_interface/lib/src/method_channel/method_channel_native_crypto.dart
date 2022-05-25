// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: native_crypto_method_channel.dart
// Created Date: 25/12/2021 16:58:04
// Last Modified: 25/05/2022 10:40:29
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

/// An implementation of [NativeCryptoPlatform] that uses method channels.
class MethodChannelNativeCrypto extends NativeCryptoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  MethodChannel channel = const MethodChannel('plugins.hugop.cl/native_crypto');

  @override
  Future<Uint8List?> digest(Uint8List data, String algorithm) async {
    try {
      return await channel.invokeMethod<Uint8List>(
        'digest',
        <String, dynamic>{
          'data': data,
          'algorithm': algorithm,
        },
      );
    } catch (e, s) {
      NativeCryptoException.convertPlatformException(e, s);
    }
  }

  @override
  Future<Uint8List?> generateSecretKey(int bitsCount) async {
    try {
      return await channel.invokeMethod<Uint8List>(
        'generateSecretKey',
        <String, dynamic>{
          'bitsCount': bitsCount,
        },
      );
    } catch (e, s) {
      NativeCryptoException.convertPlatformException(e, s);
    }
  }

  @override
  Future<Uint8List?> pbkdf2(
    String password,
    String salt,
    int keyBytesCount,
    int iterations,
    String algorithm,
  ) async {
    try {
      return await channel.invokeMethod<Uint8List>(
        'pbkdf2',
        <String, dynamic>{
          'password': password,
          'salt': salt,
          'keyBytesCount': keyBytesCount,
          'iterations': iterations,
          'algorithm': algorithm,
        },
      );
    } catch (e, s) {
      NativeCryptoException.convertPlatformException(e, s);
    }
  }

  @override
  Future<List<Uint8List>?> encryptAsList(
    Uint8List data,
    Uint8List key,
    String algorithm,
  ) async {
    try {
      return await channel.invokeListMethod(
        'encryptAsList',
        <String, dynamic>{
          'data': data,
          'key': key,
          'algorithm': algorithm,
        },
      );
    } catch (e, s) {
      NativeCryptoException.convertPlatformException(e, s);
    }
  }

  @override
  Future<Uint8List?> decryptAsList(
    List<Uint8List> data,
    Uint8List key,
    String algorithm,
  ) async {
    try {
      return await channel.invokeMethod<Uint8List>(
        'decryptAsList',
        <String, dynamic>{
          'data': data,
          'key': key,
          'algorithm': algorithm,
        },
      );
    } catch (e, s) {
      NativeCryptoException.convertPlatformException(e, s);
    }
  }

  @override
  Future<Uint8List?> encrypt(
    Uint8List data,
    Uint8List key,
    String algorithm,
  ) async {
    try {
      return await channel.invokeMethod<Uint8List>(
        'encrypt',
        <String, dynamic>{
          'data': data,
          'key': key,
          'algorithm': algorithm,
        },
      );
    } catch (e, s) {
      NativeCryptoException.convertPlatformException(e, s);
    }
  }

  @override
  Future<Uint8List?> decrypt(
    Uint8List data,
    Uint8List key,
    String algorithm,
  ) async {
    try {
      return await channel.invokeMethod<Uint8List>(
        'decrypt',
        <String, dynamic>{
          'data': data,
          'key': key,
          'algorithm': algorithm,
        },
      );
    } catch (e, s) {
      NativeCryptoException.convertPlatformException(e, s);
    }
  }
}
