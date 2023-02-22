// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

import '../mocks/mock_native_crypto_api.dart';

void main() {
  setUp(() {
    // Mock the platform interface API
    NativeCryptoPlatform.instance = BasicMessageChannelNativeCrypto(
      api: MockNativeCryptoAPI(),
    );
  });

  group('Hash', () {
    test('$Sha256 digest correctly', () async {
      final hash = await Sha256().digest('abc'.toBytes());
      expect(hash, isNotNull);
      expect(
        hash,
        Uint8List.fromList([1, 2, 3]),
      );
    });

    test('$Sha256 digest throws if platform returns null', () async {
      MockNativeCryptoAPI.hashFn = (input, algorithm) => null;
      expect(
        () async => Sha256().digest('abc'.toBytes()),
        throwsA(isA<NativeCryptoException>()),
      );
    });

    test('$Sha256 digest throws if platform returns invalid data', () async {
      MockNativeCryptoAPI.hashFn = (input, algorithm) => Uint8List(0);
      expect(
        () async => Sha256().digest('abcd'.toBytes()),
        throwsA(isA<NativeCryptoException>()),
      );
    });

    test('$Sha256 returns correct $HashAlgorithm', () async {
      final hash = Sha256();

      expect(hash.algorithm, HashAlgorithm.sha256);
    });

    test('$Sha384 returns correct $HashAlgorithm', () async {
      final hash = Sha384();

      expect(hash.algorithm, HashAlgorithm.sha384);
    });

    test('$Sha512 returns correct $HashAlgorithm', () async {
      final hash = Sha512();

      expect(hash.algorithm, HashAlgorithm.sha512);
    });
  });

  group('Hmac', () {
    test('$HmacSha256 digest correctly', () async {
      final hash = await HmacSha256()
          .digest('abc'.toBytes(), SecretKey.fromUtf16('key'));
      expect(hash, isNotNull);
      expect(
        hash,
        Uint8List.fromList([1, 2, 3]),
      );
    });

    test('$HmacSha256 digest throws if platform returns null', () async {
      MockNativeCryptoAPI.hmacFn = (input, key, algorithm) => null;
      expect(
        () async =>
            HmacSha256().digest('abc'.toBytes(), SecretKey.fromUtf16('key')),
        throwsA(isA<NativeCryptoException>()),
      );
    });

    test('$HmacSha256 digest throws if platform returns invalid data',
        () async {
      MockNativeCryptoAPI.hmacFn = (input, key, algorithm) => Uint8List(0);
      expect(
        () async =>
            HmacSha256().digest('abc'.toBytes(), SecretKey.fromUtf16('key')),
        throwsA(isA<NativeCryptoException>()),
      );
    });

    test('$HmacSha256 returns correct $HashAlgorithm', () async {
      final hash = HmacSha256();

      expect(hash.algorithm, HashAlgorithm.sha256);
    });

    test('$HmacSha384 returns correct $HashAlgorithm', () async {
      final hash = HmacSha384();

      expect(hash.algorithm, HashAlgorithm.sha384);
    });

    test('$HmacSha512 returns correct $HashAlgorithm', () async {
      final hash = HmacSha512();

      expect(hash.algorithm, HashAlgorithm.sha512);
    });
  });
}
