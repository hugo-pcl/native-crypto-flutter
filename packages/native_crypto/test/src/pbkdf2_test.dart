// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: pbkdf2_test.dart
// Created Date: 26/05/2022 22:37:27
// Last Modified: 26/05/2022 23:20:11
// -----
// Copyright (c) 2022

import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

import '../mocks/mock_native_crypto_platform.dart';

void main() {
  final MockNativeCryptoPlatform mock = MockNativeCryptoPlatform();
  NativeCryptoPlatform.instance = mock;

  group('Constructor', () {
    test('throws if keyBytesCount is negative', () {
      expect(
        () => Pbkdf2(keyBytesCount: -1, iterations: 10000),
        throwsA(
          isA<NativeCryptoException>()
              .having(
                (e) => e.code,
                'code',
                'invalid_argument',
              )
              .having(
                (e) => e.message,
                'message',
                contains('must be positive'),
              ),
        ),
      );
    });

    test('throws if iterations is negative or 0', () {
      expect(
        () => Pbkdf2(keyBytesCount: 32, iterations: -1),
        throwsA(
          isA<NativeCryptoException>()
              .having(
                (e) => e.code,
                'code',
                'invalid_argument',
              )
              .having(
                (e) => e.message,
                'message',
                contains('must be strictly positive'),
              ),
        ),
      );
    });
  });

  group('derive', () {
    test('throws if password is null', () async {
      final pbkdf2 = Pbkdf2(keyBytesCount: 32, iterations: 10000);
      await expectLater(
        () => pbkdf2.derive(
          salt: 'salt',
        ),
        throwsA(
          isA<NativeCryptoException>()
              .having(
                (e) => e.code,
                'code',
                'invalid_argument',
              )
              .having(
                (e) => e.message,
                'message',
                contains('cannot be null'),
              ),
        ),
      );
    });

    test('throws if salt is null', () async {
      final pbkdf2 = Pbkdf2(keyBytesCount: 32, iterations: 10000);
      await expectLater(
        () => pbkdf2.derive(
          password: 'password',
        ),
        throwsA(
          isA<NativeCryptoException>()
              .having(
                (e) => e.code,
                'code',
                'invalid_argument',
              )
              .having(
                (e) => e.message,
                'message',
                contains('cannot be null'),
              ),
        ),
      );
    });

    test('handles returning empty list', () async {
      mock
        ..setPbkdf2Expectations(
          password: 'password',
          salt: 'salt',
          keyBytesCount: 32,
          iterations: 10000,
          algorithm: 'sha256',
        )
        ..setResponse(() => Uint8List(0));

      final pbkdf2 = Pbkdf2(keyBytesCount: 32, iterations: 10000);

      await expectLater(
        () => pbkdf2.derive(
          password: 'password',
          salt: 'salt',
        ),
        throwsA(
          isA<NativeCryptoException>().having(
            (e) => e.code,
            'code',
            'platform_returned_empty_data',
          ),
        ),
      );
    });

    test('handles returning null', () async {
      mock
        ..setPbkdf2Expectations(
          password: 'password',
          salt: 'salt',
          keyBytesCount: 32,
          iterations: 10000,
          algorithm: 'sha256',
        )
        ..setResponse(() => null);

      final pbkdf2 = Pbkdf2(keyBytesCount: 32, iterations: 10000);

      await expectLater(
        () => pbkdf2.derive(
          password: 'password',
          salt: 'salt',
        ),
        throwsA(
          isA<NativeCryptoException>().having(
            (e) => e.code,
            'code',
            'platform_returned_null',
          ),
        ),
      );
    });

    test('handles returning data with wrong length', () async {
      mock
        ..setPbkdf2Expectations(
          password: 'password',
          salt: 'salt',
          keyBytesCount: 32,
          iterations: 10000,
          algorithm: 'sha256',
        )
        ..setResponse(() => Uint8List(33));

      final pbkdf2 = Pbkdf2(keyBytesCount: 32, iterations: 10000);

      await expectLater(
        () => pbkdf2.derive(
          password: 'password',
          salt: 'salt',
        ),
        throwsA(
          isA<NativeCryptoException>().having(
            (e) => e.code,
            'code',
            'platform_returned_invalid_data',
          ),
        ),
      );
    });

    test('handles throwing PlatformException', () async {
      mock
        ..setPbkdf2Expectations(
          password: 'password',
          salt: 'salt',
          keyBytesCount: 32,
          iterations: 10000,
          algorithm: 'sha256',
        )
        ..setResponse(
          () => throw PlatformException(
            code: 'native_crypto',
            message: 'dummy error',
          ),
        );

      final pbkdf2 = Pbkdf2(keyBytesCount: 32, iterations: 10000);

      await expectLater(
        () => pbkdf2.derive(
          password: 'password',
          salt: 'salt',
        ),
        throwsA(
          isA<NativeCryptoException>()
              .having(
                (e) => e.message,
                'message',
                'PlatformException(native_crypto, dummy error, null, null)',
              )
              .having(
                (e) => e.code,
                'code',
                'platform_throws',
              ),
        ),
      );
    });

    test('returns SecretKey on success', () async {
      final data = Uint8List.fromList([1, 2, 3, 4, 5, 6]);
      final sk = SecretKey(data);
      mock
        ..setPbkdf2Expectations(
          password: 'password',
          salt: 'salt',
          keyBytesCount: 6,
          iterations: 10000,
          algorithm: 'sha256',
        )
        ..setResponse(() => data);

      final pbkdf = Pbkdf2(keyBytesCount: 6, iterations: 10000);
      final result = await pbkdf.derive(
        password: 'password',
        salt: 'salt',
      );

      expect(
        result,
        sk,
      );
    });

    test('return empty SecretKey when keyBytesCount is set to 0', () async {
      final sk = SecretKey(Uint8List(0));
      mock
        ..setPbkdf2Expectations(
          password: 'password',
          salt: 'salt',
          keyBytesCount: 0,
          iterations: 10000,
          algorithm: 'sha256',
        )
        ..setResponse(() => Uint8List(0));

      final pbkdf = Pbkdf2(keyBytesCount: 0, iterations: 10000);
      final result = await pbkdf.derive(
        password: 'password',
        salt: 'salt',
      );

      expect(
        result,
        sk,
      );
    });
  });
}
