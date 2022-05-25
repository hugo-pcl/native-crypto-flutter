// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: method_channel_native_crypto_test.dart
// Created Date: 25/05/2022 22:47:41
// Last Modified: 25/05/2022 23:22:44
// -----
// Copyright (c) 2022

import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_crypto_platform_interface/src/method_channel/method_channel_native_crypto.dart';

void main() {
  TestWidgetsFlutterBinding
      .ensureInitialized(); // Required for setMockMethodCallHandler

  group('$MethodChannelNativeCrypto', () {
    const MethodChannel channel =
        MethodChannel('plugins.hugop.cl/native_crypto');
    final List<MethodCall> log = <MethodCall>[];
    final MethodChannelNativeCrypto nativeCrypto = MethodChannelNativeCrypto();

    TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      log.add(call);
      return null;
    });

    // Run after each test.
    tearDown(log.clear);

    test('digest', () async {
      await nativeCrypto.digest(Uint8List(0), 'sha256');
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'digest',
            arguments: <String, dynamic>{
              'data': Uint8List(0),
              'algorithm': 'sha256',
            },
          ),
        ],
      );
    });

    test('generateSecretKey', () async {
      await nativeCrypto.generateSecretKey(256);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'generateSecretKey',
            arguments: <String, dynamic>{
              'bitsCount': 256,
            },
          ),
        ],
      );
    });

    test('pbkdf2', () async {
      await nativeCrypto.pbkdf2(
        'password',
        'salt',
        32,
        10000,
        'sha256',
      );
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'pbkdf2',
            arguments: <String, dynamic>{
              'password': 'password',
              'salt': 'salt',
              'keyBytesCount': 32,
              'iterations': 10000,
              'algorithm': 'sha256',
            },
          ),
        ],
      );
    });

    test('encryptAsList', () async {
      await nativeCrypto.encryptAsList(
        Uint8List(0),
        Uint8List(0),
        'aes',
      );
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'encryptAsList',
            arguments: <String, dynamic>{
              'data': Uint8List(0),
              'key': Uint8List(0),
              'algorithm': 'aes',
            },
          ),
        ],
      );
    });

    test('decryptAsList', () async {
      await nativeCrypto.decryptAsList(
        [Uint8List(0)],
        Uint8List(0),
        'aes',
      );
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'decryptAsList',
            arguments: <String, dynamic>{
              'data': [Uint8List(0)],
              'key': Uint8List(0),
              'algorithm': 'aes',
            },
          ),
        ],
      );
    });

    test('encrypt', () async {
      await nativeCrypto.encrypt(
        Uint8List(0),
        Uint8List(0),
        'aes',
      );
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'encrypt',
            arguments: <String, dynamic>{
              'data': Uint8List(0),
              'key': Uint8List(0),
              'algorithm': 'aes',
            },
          ),
        ],
      );
    });
    
    test('decrypt', () async {
      await nativeCrypto.decrypt(
        Uint8List(0),
        Uint8List(0),
        'aes',
      );
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'decrypt',
            arguments: <String, dynamic>{
              'data': Uint8List(0),
              'key': Uint8List(0),
              'algorithm': 'aes',
            },
          ),
        ],
      );
    });

  });
}
