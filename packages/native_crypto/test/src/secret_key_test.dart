// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: secret_key_test.dart
// Created Date: 26/05/2022 10:52:41
// Last Modified: 26/05/2022 22:38:07
// -----
// Copyright (c) 2022

import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_crypto/src/keys/secret_key.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

import '../mocks/mock_native_crypto_platform.dart';

void main() {
  final MockNativeCryptoPlatform mock = MockNativeCryptoPlatform();
  NativeCryptoPlatform.instance = mock;

  group('Constructors', () {
    test('handles Uint8List', () {
      final SecretKey key = SecretKey(Uint8List.fromList([1, 2, 3, 4, 5]));

      expect(key.bytes, Uint8List.fromList([1, 2, 3, 4, 5]));
    });

    test('handles base16', () {
      final SecretKey key = SecretKey.fromBase16('0102030405');

      expect(key.bytes, Uint8List.fromList([1, 2, 3, 4, 5]));
    });

    test('handles base64', () {
      final SecretKey key = SecretKey.fromBase64('AQIDBAU=');

      expect(key.bytes, Uint8List.fromList([1, 2, 3, 4, 5]));
    });

    test('handles utf8', () {
      final SecretKey key = SecretKey.fromUtf8('ABCDE');

      expect(key.bytes, Uint8List.fromList([65, 66, 67, 68, 69]));
    });
  });

  group('fromSecureRandom', () {
    test('handles returning random bytes', () async {
      mock
        ..setGenerateKeyExpectations(bitsCount: 5)
        ..setResponse(() => Uint8List.fromList([1, 2, 3, 4, 5]));

      final SecretKey secretKey = await SecretKey.fromSecureRandom(5);

      expect(
        secretKey.bytes,
        Uint8List.fromList([1, 2, 3, 4, 5]),
      );
    });

    test('handles returning empty list', () async {
      mock
        ..setGenerateKeyExpectations(bitsCount: 5)
        ..setResponse(() => Uint8List(0));

      await expectLater(
        () => SecretKey.fromSecureRandom(5),
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
        ..setGenerateKeyExpectations(bitsCount: 5)
        ..setResponse(() => null);

      await expectLater(
        () => SecretKey.fromSecureRandom(5),
        throwsA(
          isA<NativeCryptoException>().having(
            (e) => e.code,
            'code',
            'platform_returned_null',
          ),
        ),
      );
    });

    test('handles throwing PlatformException', () async {
      mock
        ..setGenerateKeyExpectations(bitsCount: 5)
        ..setResponse(
          () => throw PlatformException(
            code: 'native_crypto',
            message: 'dummy error',
          ),
        );

      await expectLater(
        () => SecretKey.fromSecureRandom(5),
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
  });
}
