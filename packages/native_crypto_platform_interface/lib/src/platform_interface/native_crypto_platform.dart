// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: native_crypto_platform_interface.dart
// Created Date: 25/12/2021 16:43:49
// Last Modified: 25/05/2022 22:11:02
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:native_crypto_platform_interface/src/method_channel/method_channel_native_crypto.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of path_provider must implement.
///
/// Platform implementations should extend this class rather than implement
/// it as `NativeCrypto` does not consider newly added methods to be
/// breaking changes. Extending this class (using `extends`) ensures
/// that the subclass will get the default implementation, while platform
/// implementations that `implements` this interface will be
/// broken by newly added [NativeCryptoPlatform] methods.
abstract class NativeCryptoPlatform extends PlatformInterface {
  /// Constructs a NativeCryptoPlatform.
  NativeCryptoPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeCryptoPlatform _instance = MethodChannelNativeCrypto();

  /// The default instance of [NativeCryptoPlatform] to use.
  ///
  /// Defaults to [MethodChannelNativeCrypto].
  static NativeCryptoPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [NativeCryptoPlatform] when they register themselves.
  static set instance(NativeCryptoPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  Future<Uint8List?> digest(Uint8List data, String algorithm) {
    throw UnimplementedError('digest is not implemented');
  }

  Future<Uint8List?> generateSecretKey(int bitsCount) {
    throw UnimplementedError('generateSecretKey is not implemented');
  }

  Future<Uint8List?> pbkdf2(
    String password,
    String salt,
    int keyBytesCount,
    int iterations,
    String algorithm,
  ) {
    throw UnimplementedError('pbkdf2 is not implemented');
  }

  Future<List<Uint8List>?> encryptAsList(
    Uint8List data,
    Uint8List key,
    String algorithm,
  ) {
    throw UnimplementedError('encryptAsList is not implemented');
  }

  Future<Uint8List?> decryptAsList(
    List<Uint8List> data,
    Uint8List key,
    String algorithm,
  ) {
    throw UnimplementedError('decryptAsList is not implemented');
  }

  Future<Uint8List?> encrypt(
    Uint8List data,
    Uint8List key,
    String algorithm,
  ) {
    throw UnimplementedError('encrypt is not implemented');
  }

  Future<Uint8List?> decrypt(
    Uint8List data,
    Uint8List key,
    String algorithm,
  ) {
    throw UnimplementedError('decrypt is not implemented');
  }
}
