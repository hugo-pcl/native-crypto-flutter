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

    MockNativeCryptoAPI.pbkdf2Fn = null;
  });

  group('$Pbkdf2', () {
    test('derive key correctly', () async {
      final key = await Pbkdf2(
        salt: Uint8List.fromList([1, 2, 3]),
        iterations: 1,
        length: 3,
        hashAlgorithm: HashAlgorithm.sha256,
      ).derive(
        Uint8List.fromList([1, 2, 3]),
      );

      expect(key, isNotNull);
      expect(key.length, 3);
      expect(
        key,
        Uint8List.fromList([1, 2, 3]),
      );
    });

    test('derive key with invalid length throws', () async {
      expect(
        () => Pbkdf2(
          salt: Uint8List.fromList([1, 2, 3]),
          iterations: 1,
          length: -1,
          hashAlgorithm: HashAlgorithm.sha256,
        ).derive(
          Uint8List.fromList([1, 2, 3]),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('derive key with invalid iterations throws', () async {
      expect(
        () => Pbkdf2(
          salt: Uint8List.fromList([1, 2, 3]),
          iterations: 0,
          length: 3,
          hashAlgorithm: HashAlgorithm.sha256,
        ).derive(
          Uint8List.fromList([1, 2, 3]),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('derive key with 0 length returns empty list', () async {
      final key = await Pbkdf2(
        salt: Uint8List.fromList([1, 2, 3]),
        iterations: 1,
        length: 0,
        hashAlgorithm: HashAlgorithm.sha256,
      ).derive(
        Uint8List.fromList([1, 2, 3]),
      );
      expect(key, isNotNull);
      expect(key.length, 0);
    });

    test('derive key throws if platform returns null', () async {
      MockNativeCryptoAPI.pbkdf2Fn =
          (password, salt, iterations, length, hashAlgorithm) => null;
      expect(
        () => Pbkdf2(
          salt: Uint8List.fromList([1, 2, 3]),
          iterations: 1,
          length: 3,
          hashAlgorithm: HashAlgorithm.sha256,
        ).derive(
          Uint8List.fromList([1, 2, 3]),
        ),
        throwsA(isA<NativeCryptoException>()),
      );
    });

    test('derive key throws if platform returns invalid data', () async {
      expect(
        () async => Pbkdf2(
          salt: Uint8List.fromList([1, 2, 3]),
          iterations: 1,
          length: 4,
          hashAlgorithm: HashAlgorithm.sha256,
        ).derive(
          Uint8List.fromList([1, 2, 3]),
        ),
        throwsA(isA<NativeCryptoException>()),
      );
    });

    test('call returns $SecretKey', () async {
      final pbkdf = Pbkdf2(
        salt: Uint8List.fromList([1, 2, 3]),
        iterations: 1,
        length: 3,
        hashAlgorithm: HashAlgorithm.sha256,
      );

      final key = await pbkdf(password: 'password');

      expect(key, isNotNull);
      expect(key, isA<SecretKey>());
    });

    test('verify key returns true on the same password', () async {
      final pbkdf = Pbkdf2(
        salt: Uint8List.fromList([1, 2, 3]),
        iterations: 1,
        length: 3,
        hashAlgorithm: HashAlgorithm.sha256,
      );
      final pwd = Uint8List.fromList([1, 2, 3]);
      final key = await pbkdf.derive(pwd);
      final sucess = await pbkdf.verify(pwd, key);
      expect(sucess, true);
    });

    test('verify key returns true on the same password', () async {
      final pbkdf = Pbkdf2(
        salt: Uint8List.fromList([1, 2, 3]),
        iterations: 1,
        length: 3,
        hashAlgorithm: HashAlgorithm.sha256,
      );
      final pwd = Uint8List.fromList([1, 2, 3]);
      final key = Uint8List.fromList([1, 2, 3, 4, 5, 6]);
      final sucess = await pbkdf.verify(pwd, key);
      expect(sucess, false);
    });
  });
}
