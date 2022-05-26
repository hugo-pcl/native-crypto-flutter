// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: hash_algorithm_test.dart
// Created Date: 26/05/2022 22:28:53
// Last Modified: 26/05/2022 23:03:03
// -----
// Copyright (c) 2022

import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_crypto/src/utils/hash_algorithm.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

import '../mocks/mock_native_crypto_platform.dart';

void main() {
  final MockNativeCryptoPlatform mock = MockNativeCryptoPlatform();
  NativeCryptoPlatform.instance = mock;

  group('name', () {
    test('is sha256 for HashAlgorithm.sha256', () {
      expect(HashAlgorithm.sha256.name, 'sha256');
    });
    test('is sha384 for HashAlgorithm.sha384', () {
      expect(HashAlgorithm.sha384.name, 'sha384');
    });
    test('is sha512 for HashAlgorithm.sha512', () {
      expect(HashAlgorithm.sha512.name, 'sha512');
    });
  });

  group('digest', () {
    test('handles returning empty list', () async {
      mock
        ..setDigestExpectations(
          data: Uint8List.fromList([1, 2, 3]),
          algorithm: 'sha256',
        )
        ..setResponse(() => Uint8List(0));

      await expectLater(
        () => HashAlgorithm.sha256.digest(Uint8List.fromList([1, 2, 3])),
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
        ..setDigestExpectations(
          data: Uint8List.fromList([1, 2, 3]),
          algorithm: 'sha256',
        )
        ..setResponse(() => null);

      await expectLater(
        () => HashAlgorithm.sha256.digest(Uint8List.fromList([1, 2, 3])),
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
        ..setDigestExpectations(
          data: Uint8List.fromList([1, 2, 3]),
          algorithm: 'sha256',
        )
        ..setResponse(
          () => throw PlatformException(
            code: 'native_crypto',
            message: 'dummy error',
          ),
        );

      await expectLater(
        () => HashAlgorithm.sha256.digest(Uint8List.fromList([1, 2, 3])),
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

    test('returns data on success', () async {
      final hash = Uint8List.fromList([4, 5, 6]);
      mock
        ..setDigestExpectations(
          data: Uint8List.fromList([1, 2, 3]),
          algorithm: 'sha256',
        )
        ..setResponse(() => hash);

      final result = await HashAlgorithm.sha256.digest(
        Uint8List.fromList(
          [1, 2, 3],
        ),
      );

      expect(
        result,
        hash,
      );
    });
  });
}
