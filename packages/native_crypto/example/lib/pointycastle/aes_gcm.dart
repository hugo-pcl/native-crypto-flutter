// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: aes_gcm.dart
// Created Date: 24/05/2022 16:34:54
// Last Modified: 24/05/2022 17:15:22
// -----
// Copyright (c) 2022

import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';

class AesGcm {
  FortunaRandom? _secureRandom;

  Uint8List encrypt(Uint8List data, Uint8List key) {
    final iv = generateRandomBytes(12);

    final gcm = GCMBlockCipher(AESEngine())
      ..init(
        true,
        AEADParameters(
          KeyParameter(key),
          16 * 8,
          iv!,
          Uint8List(0),
        ),
      ); // true=encrypt

    final cipherText = gcm.process(data);

    return Uint8List.fromList(
      iv + cipherText,
    );
  }

  Uint8List decrypt(Uint8List cipherText, Uint8List key) {
    final iv = Uint8List.fromList(cipherText.sublist(0, 12));
    final cipherTextWithoutIv = Uint8List.fromList(
      cipherText.sublist(12),
    );

    final gcm = GCMBlockCipher(AESEngine())
      ..init(
        false,
        AEADParameters(
          KeyParameter(key),
          16 * 8,
          iv,
          Uint8List(0),
        ),
      ); // false=decrypt

    // Decrypt the cipherText block-by-block

    final paddedPlainText = gcm.process(cipherTextWithoutIv);

    return paddedPlainText;
  }

  /// Generate random bytes to use as the Initialization Vector (IV).
  Uint8List? generateRandomBytes(int numBytes) {
    if (_secureRandom == null) {
      // First invocation: create _secureRandom and seed it

      _secureRandom = FortunaRandom();
      _secureRandom!.seed(
          KeyParameter(Platform.instance.platformEntropySource().getBytes(32)));
    }

    // Use it to generate the random bytes

    final iv = _secureRandom!.nextBytes(numBytes);
    return iv;
  }
}
