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

  group('$SecureRandom', () {
    test('generate random bytes correctly', () async {
      final random = await const SecureRandom().generate(3);
      expect(random, isNotNull);
      expect(random.length, 3);
      expect(
        random,
        Uint8List.fromList([1, 2, 3]),
      );
    });

    test('generate random bytes with invalid length throws', () async {
      expect(
        () => const SecureRandom().generate(-1),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('generate random bytes with 0 length returns empty list', () async {
      final random = await const SecureRandom().generate(0);
      expect(random, isNotNull);
      expect(random.length, 0);
    });

    test('generate random bytes throws if platform returns null', () async {
      MockNativeCryptoAPI.generateSecureRandomFn = (length) => null;
      expect(
        () async => const SecureRandom().generate(3),
        throwsA(isA<NativeCryptoException>()),
      );
    });

    test('generate random bytes throws if platform returns invalid data',
        () async {
      expect(
        () async => const SecureRandom().generate(4),
        throwsA(isA<NativeCryptoException>()),
      );
    });
  });
}
