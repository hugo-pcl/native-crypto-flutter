// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: aes_cipher_test.dart
// Created Date: 26/05/2022 23:20:53
// Last Modified: 27/05/2022 16:39:44
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

  setUp(() {
    Cipher.bytesCountPerChunk = Cipher.defaultBytesCountPerChunk;
  });

  group('Constructor', () {
    test('throws on invalid key length', () {
      expect(
        () => AES(SecretKey(Uint8List(0))),
        throwsA(
          isA<NativeCryptoException>()
              .having(
                (e) => e.code,
                'code',
                'invalid_key_length',
              )
              .having(
                (e) => e.message,
                'message',
                contains('Invalid key'),
              ),
        ),
      );
    });

    test('creates a valid instance', () {
      expect(
        AES(
          SecretKey(Uint8List(16)),
        ),
        isA<AES>(),
      );
    });
  });

  group('encrypt', () {
    test('returns a valid cipher text wrapper', () async {
      mock
        ..setEncryptExpectations(
          data: Uint8List(16),
          key: Uint8List(16),
          algorithm: 'aes',
        )
        ..setResponse(() => Uint8List(16 + 28));

      final aes = AES(SecretKey(Uint8List(16)));

      expect(
        await aes.encrypt(Uint8List(16)),
        isA<CipherTextWrapper>().having((e) => e.isSingle, 'is single', isTrue),
      );
    });

    test('returns a valid cipher text with multiple chunks', () async {
      mock
        ..setEncryptExpectations(
          data: Uint8List(16),
          key: Uint8List(16),
          algorithm: 'aes',
        )
        ..setResponse(() => Uint8List(16 + 28)); // Returns 1 encrypted chunk
      Cipher.bytesCountPerChunk = 16;
      final aes = AES(SecretKey(Uint8List(16)));

      expect(
        await aes.encrypt(Uint8List(16 * 3)),
        isA<CipherTextWrapper>().having((e) => e.isList, 'is list', isTrue),
      );
    });

    test('handles returning empty list', () async {
      mock
        ..setEncryptExpectations(
          data: Uint8List(16),
          key: Uint8List(16),
          algorithm: 'aes',
        )
        ..setResponse(() => Uint8List(0));

      final aes = AES(SecretKey(Uint8List(16)));

      await expectLater(
        () => aes.encrypt(Uint8List(16)),
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
        ..setEncryptExpectations(
          data: Uint8List(16),
          key: Uint8List(16),
          algorithm: 'aes',
        )
        ..setResponse(() => null);

      final aes = AES(SecretKey(Uint8List(16)));

      await expectLater(
        () => aes.encrypt(Uint8List(16)),
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
        ..setEncryptExpectations(
          data: Uint8List(16),
          key: Uint8List(16),
          algorithm: 'aes',
        )
        ..setResponse(
          () => throw PlatformException(
            code: 'native_crypto',
            message: 'dummy error',
          ),
        );

      final aes = AES(SecretKey(Uint8List(16)));

      await expectLater(
        () => aes.encrypt(Uint8List(16)),
        throwsA(
          isA<NativeCryptoException>()
              .having(
                (e) => e.message,
                'message',
                contains(
                  'PlatformException(native_crypto, dummy error, null, null)',
                ),
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

  group('decrypt', () {
    test('returns a valid Uint8List', () async {
      mock
        ..setDecryptExpectations(
          data: Uint8List(16 + 28),
          key: Uint8List(16),
          algorithm: 'aes',
        )
        ..setResponse(() => Uint8List(16));

      final aes = AES(SecretKey(Uint8List(16)));
      final bytes = Uint8List(16 + 28);
      final wrapper = CipherTextWrapper.fromBytes(
        bytes,
        ivLength: 12,
        tagLength: 16,
      );

      expect(
        await aes.decrypt(wrapper),
        isA<Uint8List>().having((e) => e.length, 'length', 16),
      );
    });

    test('returns a valid Uint8List on decrypting multiple chunks', () async {
      const int chunkSize = 8;
      mock
        ..setDecryptExpectations(
          data: Uint8List(chunkSize + 28),
          key: Uint8List(16),
          algorithm: 'aes',
        )
        ..setResponse(() => Uint8List(chunkSize));
      Cipher.bytesCountPerChunk = chunkSize;
      final aes = AES(SecretKey(Uint8List(16)));
      final bytes = Uint8List((chunkSize + 28) * 3);
      final wrapper = CipherTextWrapper.fromBytes(
        bytes,
        ivLength: 12,
        tagLength: 16,
      );

      expect(
        await aes.decrypt(wrapper),
        isA<Uint8List>().having((e) => e.length, 'length', chunkSize * 3),
      );
    });

    test('handles returning empty list', () async {
      mock
        ..setDecryptExpectations(
          data: Uint8List(16 + 28),
          key: Uint8List(16),
          algorithm: 'aes',
        )
        ..setResponse(() => Uint8List(0));

      final aes = AES(SecretKey(Uint8List(16)));
      final bytes = Uint8List(16 + 28);
      final wrapper = CipherTextWrapper.fromBytes(
        bytes,
        ivLength: 12,
        tagLength: 16,
      );

      await expectLater(
        () => aes.decrypt(wrapper),
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
        ..setDecryptExpectations(
          data: Uint8List(16 + 28),
          key: Uint8List(16),
          algorithm: 'aes',
        )
        ..setResponse(() => null);

      final aes = AES(SecretKey(Uint8List(16)));
      final bytes = Uint8List(16 + 28);
      final wrapper = CipherTextWrapper.fromBytes(
        bytes,
        ivLength: 12,
        tagLength: 16,
      );

      await expectLater(
        () => aes.decrypt(wrapper),
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
        ..setDecryptExpectations(
          data: Uint8List(16 + 28),
          key: Uint8List(16),
          algorithm: 'aes',
        )
        ..setResponse(
          () => throw PlatformException(
            code: 'native_crypto',
            message: 'dummy error',
          ),
        );

      final aes = AES(SecretKey(Uint8List(16)));
      final bytes = Uint8List(16 + 28);
      final wrapper = CipherTextWrapper.fromBytes(
        bytes,
        ivLength: 12,
        tagLength: 16,
      );

      await expectLater(
        () => aes.decrypt(wrapper),
        throwsA(
          isA<NativeCryptoException>()
              .having(
                (e) => e.message,
                'message',
                contains(
                  'PlatformException(native_crypto, dummy error, null, null)',
                ),
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
