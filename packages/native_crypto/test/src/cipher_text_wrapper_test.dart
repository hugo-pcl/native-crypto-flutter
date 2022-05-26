// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: cipher_text_wrapper_test.dart
// Created Date: 26/05/2022 21:35:41
// Last Modified: 26/05/2022 22:27:31
// -----
// Copyright (c) 2022

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:native_crypto/native_crypto.dart';

void main() {
  late CipherText single;
  late List<CipherText> list;

  setUp(() {
    Cipher.bytesCountPerChunk = Cipher.defaultBytesCountPerChunk;
    single = CipherText.fromBytes(
      Uint8List.fromList([1, 2, 3]),
      ivLength: 1,
      messageLength: 1,
      tagLength: 1,
    );
    list = [
      CipherText.fromBytes(
        Uint8List.fromList([1, 2, 3]),
        ivLength: 1,
        messageLength: 1,
        tagLength: 1,
      ),
      CipherText.fromBytes(
        Uint8List.fromList([4, 5, 6]),
        ivLength: 1,
        messageLength: 1,
        tagLength: 1,
      ),
    ];
  });

  group('single', () {
    test('makes isSingle true', () {
      final wrapper = CipherTextWrapper.single(single);
      expect(wrapper.isSingle, isTrue);
    });

    test('makes isList false', () {
      final wrapper = CipherTextWrapper.single(single);
      expect(wrapper.isList, isFalse);
    });

    test('makes CipherText the single value', () {
      final wrapper = CipherTextWrapper.single(single);
      expect(wrapper.single, single);
    });

    test('throws when trying to get list', () {
      final wrapper = CipherTextWrapper.single(single);
      expect(
        () => wrapper.list,
        throwsA(
          isA<NativeCryptoException>()
              .having(
                (e) => e.code,
                'code',
                'invalid_data',
              )
              .having(
                (e) => e.message,
                'message',
                contains('is not list'),
              ),
        ),
      );
    });

    test('makes wrapper returns bytes of CipherText', () {
      final wrapper = CipherTextWrapper.single(single);
      expect(wrapper.bytes, single.bytes);
    });

    test('makes chunkCount = 1', () {
      final wrapper = CipherTextWrapper.single(single);
      expect(wrapper.chunkCount, 1);
    });

    test('makes unwrap() returns only CipherText', () {
      final wrapper = CipherTextWrapper.single(single);
      expect(wrapper.unwrap<CipherText>(), single);
    });

    test('makes unwrap() throws when trying to unwrap List', () {
      final wrapper = CipherTextWrapper.single(single);
      expect(
        () => wrapper.unwrap<List<CipherText>>(),
        throwsA(
          isA<NativeCryptoException>()
              .having(
                (e) => e.code,
                'code',
                'invalid_data',
              )
              .having(
                (e) => e.message,
                'message',
                contains('you should use unwrap'),
              ),
        ),
      );
    });

    test('makes adding is not supported', () {
      final wrapper = CipherTextWrapper.single(single);
      expect(
        () => wrapper.add(single),
        throwsA(
          isA<NativeCryptoException>()
              .having(
                (e) => e.code,
                'code',
                'invalid_data',
              )
              .having(
                (e) => e.message,
                'message',
                contains('is already single'),
              ),
        ),
      );
    });
  });

  group('list', () {
    test('makes isList true', () {
      final wrapper = CipherTextWrapper.list(list);
      expect(wrapper.isList, isTrue);
    });

    test('makes isSingle false', () {
      final wrapper = CipherTextWrapper.list(list);
      expect(wrapper.isSingle, isFalse);
    });

    test('makes List<CipherText> the list value', () {
      final wrapper = CipherTextWrapper.list(list);
      expect(wrapper.list, list);
    });

    test('throws when trying to get single', () {
      final wrapper = CipherTextWrapper.list(list);
      expect(
        () => wrapper.single,
        throwsA(
          isA<NativeCryptoException>()
              .having(
                (e) => e.code,
                'code',
                'invalid_data',
              )
              .having(
                (e) => e.message,
                'message',
                contains('is not single'),
              ),
        ),
      );
    });

    test('makes wrapper returns bytes of all CipherText joined', () {
      final wrapper = CipherTextWrapper.list(list);
      expect(wrapper.bytes, Uint8List.fromList([1, 2, 3, 4, 5, 6]));
    });

    test('makes chunkCount = 2', () {
      final wrapper = CipherTextWrapper.list(list);
      expect(wrapper.chunkCount, 2);
    });

    test('makes unwrap() returns List<CipherText>', () {
      final wrapper = CipherTextWrapper.list(list);
      expect(wrapper.unwrap<List<CipherText>>(), list);
    });

    test('makes unwrap() throws when trying to unwrap single', () {
      final wrapper = CipherTextWrapper.list(list);
      expect(
        () => wrapper.unwrap<CipherText>(),
        throwsA(
          isA<NativeCryptoException>()
              .having(
                (e) => e.code,
                'code',
                'invalid_data',
              )
              .having(
                (e) => e.message,
                'message',
                contains('you should use unwrap'),
              ),
        ),
      );
    });

    test('makes adding is supported', () {
      final originalList = List<CipherText>.from(list);
      final wrapper = CipherTextWrapper.list(list)..add(single);
      printOnFailure(list.length.toString());
      expect(wrapper.list, [...originalList, single]);
    });
  });

  group('empty', () {
    test('makes isList true', () {
      final wrapper = CipherTextWrapper.empty();
      expect(wrapper.isList, isTrue);
    });

    test('makes isSingle false', () {
      final wrapper = CipherTextWrapper.empty();
      expect(wrapper.isSingle, isFalse);
    });

    test('makes List<CipherText> the list value', () {
      final wrapper = CipherTextWrapper.empty();
      expect(wrapper.list, <CipherText>[]);
    });

    test('throws when trying to get single', () {
      final wrapper = CipherTextWrapper.empty();
      expect(
        () => wrapper.single,
        throwsA(
          isA<NativeCryptoException>()
              .having(
                (e) => e.code,
                'code',
                'invalid_data',
              )
              .having(
                (e) => e.message,
                'message',
                contains('is not single'),
              ),
        ),
      );
    });

    test('makes wrapper returns empty bytes', () {
      final wrapper = CipherTextWrapper.empty();
      expect(wrapper.bytes, Uint8List.fromList([]));
    });

    test('makes chunkCount = 0', () {
      final wrapper = CipherTextWrapper.empty();
      expect(wrapper.chunkCount, 0);
    });

    test('makes unwrap() returns empty List<CipherText>', () {
      final wrapper = CipherTextWrapper.empty();
      expect(wrapper.unwrap<List<CipherText>>(), <CipherText>[]);
    });

    test('makes unwrap() throws when trying to unwrap single', () {
      final wrapper = CipherTextWrapper.empty();
      expect(
        () => wrapper.unwrap<CipherText>(),
        throwsA(
          isA<NativeCryptoException>()
              .having(
                (e) => e.code,
                'code',
                'invalid_data',
              )
              .having(
                (e) => e.message,
                'message',
                contains('you should use unwrap'),
              ),
        ),
      );
    });

    test('makes adding is supported', () {
      final wrapper = CipherTextWrapper.empty()..add(single);
      expect(wrapper.list, [single]);
    });
  });

  group('fromBytes', () {
    test('creates single from bytes when no too big', () {
      final wrapper = CipherTextWrapper.fromBytes(
        Uint8List.fromList([1, 2, 3]),
        ivLength: 1,
        messageLength: 1,
        tagLength: 1,
      );
      expect(wrapper.isSingle, isTrue);
      expect(wrapper.single, single);
    });

    test('creates list from bytes when too big', () {
      Cipher.bytesCountPerChunk = 3;
      final wrapper = CipherTextWrapper.fromBytes(
        Uint8List.fromList([1, 2, 3, 4, 5, 6]),
        ivLength: 1,
        messageLength: 1,
        tagLength: 1,
      );
      expect(wrapper.isList, isTrue);
      expect(wrapper.list, list);
    });

    test('modifies Cipher.bytesCountPerChunk', () {
      expect(Cipher.bytesCountPerChunk, Cipher.defaultBytesCountPerChunk);
      CipherTextWrapper.fromBytes(
        Uint8List.fromList([1, 2, 3]),
        ivLength: 1,
        messageLength: 1,
        tagLength: 1,
        chunkSize: 3,
      );
      expect(Cipher.bytesCountPerChunk, 3);
    });
  });
}
