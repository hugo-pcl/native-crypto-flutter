// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: aes.dart
// Created Date: 16/12/2021 16:28:00
// Last Modified: 23/05/2022 23:06:05
// -----
// Copyright (c) 2022

import 'dart:typed_data';

import 'package:native_crypto/src/ciphers/aes/aes_key_size.dart';
import 'package:native_crypto/src/ciphers/aes/aes_mode.dart';
import 'package:native_crypto/src/ciphers/aes/aes_padding.dart';
import 'package:native_crypto/src/core/cipher_text.dart';
import 'package:native_crypto/src/core/cipher_text_list.dart';
import 'package:native_crypto/src/core/exceptions.dart';
import 'package:native_crypto/src/interfaces/cipher.dart';
import 'package:native_crypto/src/keys/secret_key.dart';
import 'package:native_crypto/src/platform.dart';
import 'package:native_crypto/src/utils/cipher_algorithm.dart';

export 'package:native_crypto/src/ciphers/aes/aes_key_size.dart';
export 'package:native_crypto/src/ciphers/aes/aes_mode.dart';
export 'package:native_crypto/src/ciphers/aes/aes_padding.dart';

class AES implements Cipher {
  final SecretKey key;
  final AESMode mode;
  final AESPadding padding;

  @override
  CipherAlgorithm get algorithm => CipherAlgorithm.aes;

  AES(this.key, this.mode, {this.padding = AESPadding.none}) {
    if (!AESKeySize.supportedSizes.contains(key.bytes.length * 8)) {
      throw CipherInitException('Invalid key length!');
    }

    final Map<AESMode, List<AESPadding>> _supported = {
      AESMode.gcm: [AESPadding.none],
    };

    if (!_supported[mode]!.contains(padding)) {
      throw CipherInitException('Invalid padding!');
    }
  }

  @override
  Future<Uint8List> decrypt(CipherText cipherText) async {
    final BytesBuilder decryptedData = BytesBuilder(copy: false);
    if (cipherText is CipherTextList) {
      for (final CipherText ct in cipherText.list) {
        final Uint8List d = await platform.decrypt(
              ct.bytes,
              key.bytes,
              algorithm.name,
            ) ??
            Uint8List(0);
        decryptedData.add(d);
      }
    } else {
      final Uint8List d = await platform.decrypt(
            cipherText.bytes,
            key.bytes,
            algorithm.name,
          ) ??
          Uint8List(0);
      decryptedData.add(d);
    }

    return decryptedData.toBytes();
  }

  @override
  Future<CipherText> encrypt(Uint8List data) async {
    Uint8List dataToEncrypt;
    final CipherTextList cipherTextList = CipherTextList();
    // If data is bigger than 32mB -> split in chunks
    if (data.length > CipherTextList.chunkSize) {
      final int chunkNb = (data.length / CipherTextList.chunkSize).ceil();
      for (var i = 0; i < chunkNb; i++) {
        dataToEncrypt = i < (chunkNb - 1)
            ? data.sublist(
                i * CipherTextList.chunkSize,
                (i + 1) * CipherTextList.chunkSize,
              )
            : data.sublist(i * CipherTextList.chunkSize);
        final Uint8List c = await platform.encrypt(
              dataToEncrypt,
              key.bytes,
              algorithm.name,
            ) ??
            Uint8List(0);
        cipherTextList.add(
          CipherText(
            c.sublist(0, 12),
            c.sublist(12, c.length - 16),
            c.sublist(c.length - 16, c.length),
          ),
        ); // TODO(hpcl): generify this
      }
    } else {
      final Uint8List c =
          await platform.encrypt(data, key.bytes, algorithm.name) ??
              Uint8List(0);

      return CipherText(
        c.sublist(0, 12),
        c.sublist(12, c.length - 16),
        c.sublist(c.length - 16, c.length),
      ); // TODO(hpcl): generify this
    }

    return cipherTextList;
  }
}
