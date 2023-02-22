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

  group('$SecretKey', () {
    test('can be create from Uint8List', () {
      final SecretKey key = SecretKey(Uint8List.fromList([1, 2, 3, 4, 5]));

      expect(key.bytes, Uint8List.fromList([1, 2, 3, 4, 5]));
    });

    test('can be create from base16', () {
      final SecretKey key = SecretKey.fromBase16('0102030405');

      expect(key.bytes, Uint8List.fromList([1, 2, 3, 4, 5]));
    });

    test('can be create from base64', () {
      final SecretKey key = SecretKey.fromBase64('AQIDBAU=');

      expect(key.bytes, Uint8List.fromList([1, 2, 3, 4, 5]));
    });

    test('can be create from utf8', () {
      final SecretKey key = SecretKey.fromUtf8('ABCDE');

      expect(key.bytes, Uint8List.fromList([65, 66, 67, 68, 69]));
    });

    test('can be create from secure random', () async {
      MockNativeCryptoAPI.generateSecureRandomFn =
          (length) => Uint8List.fromList([1, 2, 3, 4, 5]);
      final SecretKey key = await SecretKey.fromSecureRandom(5);

      expect(key.bytes, Uint8List.fromList([1, 2, 3, 4, 5]));
    });
  });
}
