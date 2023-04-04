// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart';
import 'package:native_crypto/native_crypto.dart';

class TestVector {
  TestVector({
    required this.key,
    required this.nonce,
    required this.plainText,
    required this.cipherText,
    required this.tag,
  });

  final String key;
  final String nonce;
  final String plainText;
  final String cipherText;
  final String tag;

  Uint8List get keyBytes => key.toBytes(from: Encoding.base16);
  Uint8List get nonceBytes => nonce.toBytes(from: Encoding.base16);
  Uint8List get tagBytes => tag.toBytes(from: Encoding.base16);
  Uint8List get plainTextBytes => plainText.toBytes(from: Encoding.base16);
  Uint8List get cipherTextBytes {
    final iv = nonceBytes;
    final data = cipherText.toBytes(from: Encoding.base16);
    final tag = tagBytes;
    return Uint8List.fromList(iv + data + tag);
  }

  bool validateCipherText(Uint8List? testCipherText) {
    final result = listEquals(testCipherText, cipherTextBytes);
    if (!result) {
      debugPrint('Cipher texts differs:\n$cipherTextBytes\n$testCipherText');
    }
    return result;
  }

  bool validatePlainText(Uint8List? testPlainText) {
    final result = listEquals(testPlainText, plainTextBytes);
    if (!result) {
      debugPrint('Plain texts differs:\n$plainTextBytes\n$testPlainText');
    }
    return result;
  }

  bool validate(Uint8List? testPlainText, Uint8List? testCipherText) =>
      validateCipherText(testCipherText) && validatePlainText(testPlainText);
}
