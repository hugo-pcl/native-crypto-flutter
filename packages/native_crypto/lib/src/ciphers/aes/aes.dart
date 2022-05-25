// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: aes.dart
// Created Date: 16/12/2021 16:28:00
// Last Modified: 25/05/2022 15:40:07
// -----
// Copyright (c) 2022

import 'dart:typed_data';

import 'package:native_crypto/src/ciphers/aes/aes_key_size.dart';
import 'package:native_crypto/src/ciphers/aes/aes_mode.dart';
import 'package:native_crypto/src/ciphers/aes/aes_padding.dart';
import 'package:native_crypto/src/core/cipher_text.dart';
import 'package:native_crypto/src/core/cipher_text_list.dart';
import 'package:native_crypto/src/interfaces/cipher.dart';
import 'package:native_crypto/src/keys/secret_key.dart';
import 'package:native_crypto/src/platform.dart';
import 'package:native_crypto/src/utils/cipher_algorithm.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

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
      throw const CipherInitException(
        message: 'Invalid key length!',
        code: 'invalid_key_length',
      );
    }

    final Map<AESMode, List<AESPadding>> _supported = {
      AESMode.gcm: [AESPadding.none],
    };

    if (!_supported[mode]!.contains(padding)) {
      throw const CipherInitException(
        message: 'Invalid padding!',
        code: 'invalid_padding',
      );
    }
  }

  Future<Uint8List> _decrypt(CipherText cipherText) async {
    return await platform.decryptAsList(
          [cipherText.iv, cipherText.payload],
          key.bytes,
          algorithm.name,
        ) ??
        Uint8List(0);
  }

  Future<CipherText> _encrypt(Uint8List data) async {
    final List<Uint8List> cipherText =
        await platform.encryptAsList(data, key.bytes, algorithm.name) ??
            List.empty();
    return CipherText.fromPairIvAndBytes(
      cipherText,
      dataLength: cipherText.last.length,
    );
  }

  @override
  Future<Uint8List> decrypt(CipherText cipherText) async {
    final BytesBuilder decryptedData = BytesBuilder(copy: false);

    if (cipherText is CipherTextList) {
      for (final CipherText ct in cipherText.list) {
        decryptedData.add(await _decrypt(ct));
      }
    } else {
      decryptedData.add(await _decrypt(cipherText));
    }

    return decryptedData.toBytes();
  }

  @override
  Future<CipherText> encrypt(Uint8List data) async {
    Uint8List dataToEncrypt;

    final CipherTextList cipherTextList = CipherTextList();

    if (data.length > Cipher.bytesCountPerChunk) {
      final int chunkNb = (data.length / Cipher.bytesCountPerChunk).ceil();
      for (var i = 0; i < chunkNb; i++) {
        dataToEncrypt = i < (chunkNb - 1)
            ? data.sublist(
                i * Cipher.bytesCountPerChunk,
                (i + 1) * Cipher.bytesCountPerChunk,
              )
            : data.sublist(i * Cipher.bytesCountPerChunk);
        cipherTextList.add(await _encrypt(dataToEncrypt));
      }
    } else {
      return _encrypt(data);
    }
    return cipherTextList;
  }
}
