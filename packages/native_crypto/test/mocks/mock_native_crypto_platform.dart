// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: mock_native_crypto_platform.dart
// Created Date: 25/05/2022 23:34:34
// Last Modified: 26/05/2022 11:40:24
// -----
// Copyright (c) 2022

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNativeCryptoPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements NativeCryptoPlatform {
  Uint8List? data;
  List<Uint8List>? dataAsList;
  Uint8List? key;
  String? algorithm;
  int? bitsCount;
  String? password;
  String? salt;
  int? keyBytesCount;
  int? iterations;

  Uint8List? Function()? response;
  List<Uint8List>? Function()? responseAsList;

  // ignore: use_setters_to_change_properties
  void setResponse(Uint8List? Function()? response) {
    this.response = response;
  }

  // ignore: use_setters_to_change_properties
  void setResponseAsList(List<Uint8List>? Function()? responseAsList) {
    this.responseAsList = responseAsList;
  }

  void setDecryptExpectations({
    required Uint8List data,
    required Uint8List key,
    required String algorithm,
  }) {
    this.data = data;
    this.key = key;
    this.algorithm = algorithm;
  }

  @override
  Future<Uint8List?> decrypt(
    Uint8List data,
    Uint8List key,
    String algorithm,
  ) async {
    expect(data, this.data);
    expect(key, this.key);
    expect(algorithm, this.algorithm);
    return response?.call();
  }

  void setDecryptAsListExpectations({
    required List<Uint8List> data,
    required Uint8List key,
    required String algorithm,
  }) {
    dataAsList = data;
    this.key = key;
    this.algorithm = algorithm;
  }

  @override
  Future<Uint8List?> decryptAsList(
    List<Uint8List> data,
    Uint8List key,
    String algorithm,
  ) async {
    expect(data, dataAsList);
    expect(key, this.key);
    expect(algorithm, this.algorithm);

    return response?.call();
  }

  void setDigestExpectations({
    required Uint8List data,
    required String algorithm,
  }) {
    this.data = data;
    this.algorithm = algorithm;
  }

  @override
  Future<Uint8List?> digest(Uint8List data, String algorithm) async {
    expect(data, this.data);
    expect(algorithm, this.algorithm);

    return response?.call();
  }

  void setEncryptExpectations({
    required Uint8List data,
    required Uint8List key,
    required String algorithm,
  }) {
    this.data = data;
    this.key = key;
    this.algorithm = algorithm;
  }

  @override
  Future<Uint8List?> encrypt(
    Uint8List data,
    Uint8List key,
    String algorithm,
  ) async {
    expect(data, this.data);
    expect(key, this.key);
    expect(algorithm, this.algorithm);

    return response?.call();
  }

  void setEncryptAsListExpectations({
    required Uint8List data,
    required Uint8List key,
    required String algorithm,
  }) =>
      setEncryptExpectations(
        data: data,
        key: key,
        algorithm: algorithm,
      );

  @override
  Future<List<Uint8List>?> encryptAsList(
    Uint8List data,
    Uint8List key,
    String algorithm,
  ) async {
    expect(data, this.data);
    expect(key, this.key);
    expect(algorithm, this.algorithm);

    return responseAsList?.call();
  }

  // ignore: use_setters_to_change_properties
  void setGenerateKeyExpectations({required int bitsCount}) {
    this.bitsCount = bitsCount;
  }

  @override
  Future<Uint8List?> generateSecretKey(int bitsCount) async {
    expect(bitsCount, this.bitsCount);

    return response?.call();
  }

  void setPbkdf2Expectations({
    required String password,
    required String salt,
    required int keyBytesCount,
    required int iterations,
    required String algorithm,
  }) {
    this.password = password;
    this.salt = salt;
    this.iterations = iterations;
    this.keyBytesCount = keyBytesCount;
    this.algorithm = algorithm;
  }

  @override
  Future<Uint8List?> pbkdf2(
    String password,
    String salt,
    int keyBytesCount,
    int iterations,
    String algorithm,
  ) async {
    expect(password, this.password);
    expect(salt, this.salt);
    expect(keyBytesCount, this.keyBytesCount);
    expect(iterations, this.iterations);
    expect(algorithm, this.algorithm);

    return response?.call();
  }
}
