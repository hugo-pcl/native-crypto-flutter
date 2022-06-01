// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: native_crypto_platform_test.dart
// Created Date: 25/05/2022 21:43:25
// Last Modified: 25/05/2022 23:26:18
// -----
// Copyright (c) 2022

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:native_crypto_platform_interface/src/platform_interface/native_crypto_platform.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

void main() {
  late ExtendsNativeCryptoPlatform nativeCryptoPlatform;

  group('$NativeCryptoPlatform', () {
    setUpAll(() {
      nativeCryptoPlatform = ExtendsNativeCryptoPlatform();
    });
    test('Constructor', () {
      expect(nativeCryptoPlatform, isA<NativeCryptoPlatform>());
      expect(nativeCryptoPlatform, isA<PlatformInterface>());
    });

    test('get.instance', () {
      expect(
        NativeCryptoPlatform.instance,
        isA<NativeCryptoPlatform>(),
      );
    });
    test('set.instance', () {
      NativeCryptoPlatform.instance = ExtendsNativeCryptoPlatform();
      expect(
        NativeCryptoPlatform.instance,
        isA<NativeCryptoPlatform>(),
      );
    });

    test('Cannot be implemented with `implements`', () {
      expect(
        () {
          NativeCryptoPlatform.instance = ImplementsNativeCryptoPlatform();
        },
        throwsA(isInstanceOf<AssertionError>()),
      );
    });

    test('Can be mocked with `implements`', () {
      final MockNativeCryptoPlatform mock = MockNativeCryptoPlatform();
      NativeCryptoPlatform.instance = mock;
    });

    test('Can be extended', () {
      NativeCryptoPlatform.instance = ExtendsNativeCryptoPlatform();
    });

    test('throws if .digest() not implemented', () async {
      await expectLater(
        () => nativeCryptoPlatform.digest(Uint8List(0), 'sha256'),
        throwsA(
          isA<UnimplementedError>().having(
            (e) => e.message,
            'message',
            'digest is not implemented',
          ),
        ),
      );
    });

    test('throws if .generateSecretKey() not implemented', () async {
      await expectLater(
        () => nativeCryptoPlatform.generateSecretKey(256),
        throwsA(
          isA<UnimplementedError>().having(
            (e) => e.message,
            'message',
            'generateSecretKey is not implemented',
          ),
        ),
      );
    });

    test('throws if .pbkdf2() not implemented', () async {
      await expectLater(
        () => nativeCryptoPlatform.pbkdf2('password', 'salt', 0, 0, 'sha256'),
        throwsA(
          isA<UnimplementedError>().having(
            (e) => e.message,
            'message',
            'pbkdf2 is not implemented',
          ),
        ),
      );
    });

    test('throws if .encryptAsList() not implemented', () async {
      await expectLater(
        () => nativeCryptoPlatform.encryptAsList(
          Uint8List(0),
          Uint8List(0),
          'aes',
        ),
        throwsA(
          isA<UnimplementedError>().having(
            (e) => e.message,
            'message',
            'encryptAsList is not implemented',
          ),
        ),
      );
    });

    test('throws if .decryptAsList() not implemented', () async {
      await expectLater(
        () => nativeCryptoPlatform
            .decryptAsList([Uint8List(0)], Uint8List(0), 'aes'),
        throwsA(
          isA<UnimplementedError>().having(
            (e) => e.message,
            'message',
            'decryptAsList is not implemented',
          ),
        ),
      );
    });

    test('throws if .encrypt() not implemented', () async {
      await expectLater(
        () => nativeCryptoPlatform.encrypt(Uint8List(0), Uint8List(0), 'aes'),
        throwsA(
          isA<UnimplementedError>().having(
            (e) => e.message,
            'message',
            'encrypt is not implemented',
          ),
        ),
      );
    });

    test('throws if .decrypt() not implemented', () async {
      await expectLater(
        () => nativeCryptoPlatform.decrypt(Uint8List(0), Uint8List(0), 'aes'),
        throwsA(
          isA<UnimplementedError>().having(
            (e) => e.message,
            'message',
            'decrypt is not implemented',
          ),
        ),
      );
    });
  });
}

class ExtendsNativeCryptoPlatform extends NativeCryptoPlatform {}

class ImplementsNativeCryptoPlatform extends Mock
    implements NativeCryptoPlatform {}

class MockNativeCryptoPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements NativeCryptoPlatform {}
