// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: cipher_text_test.dart
// Created Date: 26/05/2022 20:45:38
// Last Modified: 26/05/2022 21:29:51
// -----
// Copyright (c) 2022

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:native_crypto/native_crypto.dart';

void main() {
  setUp(() {
    Cipher.bytesCountPerChunk = Cipher.defaultBytesCountPerChunk;
  });

  group('fromBytes', () {
    test('throws if length is not the one expected', () {
      final Uint8List bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      expect(
        () => CipherText.fromBytes(
          bytes,
          ivLength: 1,
          messageLength: 1,
          tagLength: 1,
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
                contains('Invalid cipher text length'),
              ),
        ),
      );
    });

    test('throws if length is bigger than expected', () {
      final Uint8List bytes = Uint8List.fromList([1, 3, 3, 3, 1]);
      Cipher.bytesCountPerChunk = 2;
      expect(
        () => CipherText.fromBytes(
          bytes,
          ivLength: 1,
          messageLength: 3,
          tagLength: 1,
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
                contains('Cipher text is too big'),
              ),
        ),
      );
    });

    test('throws if data is empty', () {
      final Uint8List bytes = Uint8List(0);
      expect(
        () => CipherText.fromBytes(
          bytes,
          ivLength: 1,
          messageLength: 3,
          tagLength: 1,
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
                contains('Passed data is empty'),
              ),
        ),
      );
    });

    test('throws if one of the length is negative', () {
      final Uint8List bytes = Uint8List(0);
      expect(
        () => CipherText.fromBytes(
          bytes,
          ivLength: -1,
          messageLength: 1,
          tagLength: 1,
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
                contains('Invalid length'),
              ),
        ),
      );
    });
  });

  group('get.cipherAlgorithm', () {
    test('throws if not set', () {
      final CipherText cipherText = CipherText.fromBytes(
        Uint8List.fromList([1, 2, 3]),
        ivLength: 1,
        messageLength: 1,
        tagLength: 1,
      );
      expect(
        () => cipherText.cipherAlgorithm,
        throwsA(
          isA<NativeCryptoException>()
              .having(
                (e) => e.code,
                'code',
                'invalid_cipher',
              )
              .having(
                (e) => e.message,
                'message',
                contains('Cipher algorithm is not specified'),
              ),
        ),
      );
    });

    test('returns the expected value', () {
      final CipherText cipherText = CipherText.fromBytes(
        Uint8List.fromList([1, 2, 3]),
        ivLength: 1,
        messageLength: 1,
        tagLength: 1,
        cipherAlgorithm: CipherAlgorithm.aes,
      );
      expect(cipherText.cipherAlgorithm, CipherAlgorithm.aes);
    });
  });

  group('Lengths', () {
    test('get.ivLength returns the expected value', () {
      final CipherText cipherText = CipherText.fromBytes(
        Uint8List.fromList([1, 2, 3]),
        ivLength: 1,
        messageLength: 1,
        tagLength: 1,
      );
      expect(cipherText.ivLength, 1);
    });

    test('get.messageLength returns the expected value', () {
      final CipherText cipherText = CipherText.fromBytes(
        Uint8List.fromList([1, 2, 3]),
        ivLength: 1,
        messageLength: 1,
        tagLength: 1,
      );
      expect(cipherText.messageLength, 1);
    });

    test('get.tagLength returns the expected value', () {
      final CipherText cipherText = CipherText.fromBytes(
        Uint8List.fromList([1, 2, 3]),
        ivLength: 1,
        messageLength: 1,
        tagLength: 1,
      );
      expect(cipherText.tagLength, 1);
    });
  });
}
