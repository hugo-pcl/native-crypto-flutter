// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto_example/domain/entities/log_message.dart';
import 'package:native_crypto_example/domain/entities/states.dart';
import 'package:native_crypto_example/domain/entities/test_vector.dart';
import 'package:native_crypto_example/domain/repositories/crypto_repository.dart';
import 'package:native_crypto_example/domain/repositories/logger_repository.dart';

part 'test_vectors_state.dart';

class TestVectorsCubit extends Cubit<TestVectorsState> {
  TestVectorsCubit({
    required this.loggerRepository,
    required this.cryptoRepository,
  }) : super(const TestVectorsState.initial());
  final LoggerRepository loggerRepository;
  final CryptoRepository cryptoRepository;

  final tests = [
    TestVector(
      key: 'b52c505a37d78eda5dd34f20c22540ea1b58963cf8e5bf8ffa85f9f2492505b4',
      nonce: '516c33929df5a3284ff463d7',
      plainText: '',
      cipherText: '',
      tag: 'bdc1ac884d332457a1d2664f168c76f0',
    ),
    TestVector(
      key: '5fe0861cdc2690ce69b3658c7f26f8458eec1c9243c5ba0845305d897e96ca0f',
      nonce: '770ac1a5a3d476d5d96944a1',
      plainText: '',
      cipherText: '',
      tag: '196d691e1047093ca4b3d2ef4baba216',
    ),
    TestVector(
      key: '7620b79b17b21b06d97019aa70e1ca105e1c03d2a0cf8b20b5a0ce5c3903e548',
      nonce: '60f56eb7a4b38d4f03395511',
      plainText: '',
      cipherText: '',
      tag: 'f570c38202d94564bab39f75617bc87a',
    ),
    TestVector(
      key: '31bdadd96698c204aa9ce1448ea94ae1fb4a9a0b3c9d773b51bb1822666b8f22',
      nonce: '0d18e06c7c725ac9e362e1ce',
      plainText: '2db5168e932556f8089a0622981d017d',
      cipherText: 'fa4362189661d163fcd6a56d8bf0405a',
      tag: 'd636ac1bbedd5cc3ee727dc2ab4a9489',
    ),
    TestVector(
      key: '460fc864972261c2560e1eb88761ff1c992b982497bd2ac36c04071cbb8e5d99',
      nonce: '8a4a16b9e210eb68bcb6f58d',
      plainText: '99e4e926ffe927f691893fb79a96b067',
      cipherText: '133fc15751621b5f325c7ff71ce08324',
      tag: 'ec4e87e0cf74a13618d0b68636ba9fa7',
    ),
    TestVector(
      key: 'f78a2ba3c5bd164de134a030ca09e99463ea7e967b92c4b0a0870796480297e5',
      nonce: '2bb92fcb726c278a2fa35a88',
      plainText: 'f562509ed139a6bbe7ab545ac616250c',
      cipherText: 'e2f787996e37d3b47294bf7ebba5ee25',
      tag: '00f613eee9bdad6c9ee7765db1cb45c0',
    ),
  ];

  FutureOr<void> launchAllTests() async {
    emit(const TestVectorsState.loading());
    int i = 0;
    for (final test in tests) {
      final sk = SecretKey(test.keyBytes);
      final iv = test.nonceBytes;

      // Encryption
      final encryption =
          await cryptoRepository.encryptWithIV(test.plainTextBytes, sk, iv);
      final testCipherText = await encryption
          .foldAsync((cipherText) async => cipherText, (error) async {
        await loggerRepository.addLog(
          LogError(
            'TEST $i :: ${error.message ?? 'Error during encryption.'} ❌',
          ),
        );
      });

      final encryptionSuccess = test.validateCipherText(testCipherText);

      if (encryptionSuccess) {
        await loggerRepository.addLog(
          LogInfo('TEST $i :: Encryption test passed ✅'),
        );
      } else {
        await loggerRepository.addLog(
          LogError('TEST $i :: Encryption test failed ❌'),
        );
      }

      // Decryption
      final decryption =
          await cryptoRepository.decrypt(test.cipherTextBytes, sk);
      final testPlainText = await decryption
          .foldAsync((plainText) async => plainText, (error) async {
        await loggerRepository.addLog(
          LogError(
            'TEST $i :: ${error.message ?? 'Error during decryption. ❌'}',
          ),
        );
      });

      final decryptionSuccess = test.validatePlainText(testPlainText);

      if (decryptionSuccess) {
        await loggerRepository.addLog(
          LogInfo('TEST $i :: Decryption test passed ✅'),
        );
      } else {
        await loggerRepository.addLog(
          LogError('TEST $i :: Decryption test failed ❌'),
        );
      }
      i++;
    }

    if (i == tests.length) {
      emit(const TestVectorsState.success());
    } else {
      emit(const TestVectorsState.failure('Error during the test suite'));
    }

    return;
  }

  FutureOr<void> launchTest(String number) async {
    try {
      final id = int.parse(number);

      final test = tests.elementAt(id);

      final sk = SecretKey(test.keyBytes);
      final iv = test.nonceBytes;

      // Encryption
      final encryption =
          await cryptoRepository.encryptWithIV(test.plainTextBytes, sk, iv);
      final testCipherText = await encryption
          .foldAsync((cipherText) async => cipherText, (error) async {
        await loggerRepository.addLog(
          LogError(
            'TEST $id :: ${error.message ?? 'Error during encryption.'} ❌',
          ),
        );
      });

      final encryptionSuccess = test.validateCipherText(testCipherText);

      if (encryptionSuccess) {
        await loggerRepository.addLog(
          LogInfo('TEST $id :: Encryption test passed ✅'),
        );
      } else {
        await loggerRepository.addLog(
          LogError('TEST $id :: Encryption test failed ❌'),
        );
      }

      // Decryption
      final decryption =
          await cryptoRepository.decrypt(test.cipherTextBytes, sk);
      final testPlainText = await decryption
          .foldAsync((plainText) async => plainText, (error) async {
        await loggerRepository.addLog(
          LogError(
            'TEST $id :: ${error.message ?? 'Error during decryption. ❌'}',
          ),
        );
      });

      final decryptionSuccess = test.validatePlainText(testPlainText);

      if (decryptionSuccess) {
        await loggerRepository.addLog(
          LogInfo('TEST $id :: Decryption test passed ✅'),
        );
      } else {
        await loggerRepository.addLog(
          LogError('TEST $id :: Decryption test failed ❌'),
        );
      }
      emit(const TestVectorsState.success());
    } catch (e) {
      final error = 'Invalid vector number: $number';
      await loggerRepository.addLog(LogError(error));
      emit(TestVectorsState.failure(error));
    }

    return;
  }
}
