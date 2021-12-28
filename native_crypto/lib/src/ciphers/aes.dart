// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: aes.dart
// Created Date: 16/12/2021 16:28:00
// Last Modified: 28/12/2021 13:39:00
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import '../cipher.dart';
import '../cipher_text.dart';
import '../exceptions.dart';
import '../keys/secret_key.dart';
import '../platform.dart';
import '../utils.dart';

/// Defines the AES modes of operation.
enum AESMode { gcm }

/// Defines all available key sizes.
enum AESKeySize { bits128, bits192, bits256 }

/// Represents different paddings.
enum AESPadding { none }

extension AESKeySizeExtension on AESKeySize {
  static final Map<AESKeySize, int> sizes = <AESKeySize, int>{
    AESKeySize.bits128: 128,
    AESKeySize.bits192: 192,
    AESKeySize.bits256: 256,
  };
  static final List<int> supportedSizes = sizes.values.toList(growable: false);
  int get length {
    return sizes[this]!; // this is safe because `this` is listed in the enum
  }
}

class AES implements Cipher {
  final SecretKey key;
  final AESMode mode;
  final AESPadding padding;

  @override
  CipherAlgorithm get algorithm => CipherAlgorithm.aes;

  AES(this.key, this.mode, {this.padding = AESPadding.none}) {
    if (!AESKeySizeExtension.supportedSizes.contains(key.bytes.length * 8)) {
      throw CipherInitException("Invalid key length!");
    }

    Map<AESMode, List<AESPadding>> _supported = {
      AESMode.gcm: [AESPadding.none],
    };

    if (!_supported[mode]!.contains(padding)) {
      throw CipherInitException("Invalid padding!");
    }
  }

  @override
  Future<Uint8List> decrypt(CipherText cipherText) async {
    BytesBuilder decryptedData = BytesBuilder(copy: false);
    if (cipherText is CipherTextList) {
      for (CipherText ct in cipherText.list) {
        Uint8List d = await platform.decrypt(
                ct.bytes, key.bytes, Utils.enumToStr(algorithm)) ??
            Uint8List(0);
        decryptedData.add(d);
      }
    } else {
      Uint8List d = await platform.decrypt(
              cipherText.bytes, key.bytes, Utils.enumToStr(algorithm)) ??
          Uint8List(0);
      decryptedData.add(d);
    }

    return decryptedData.toBytes();
  }

  @override
  Future<CipherText> encrypt(Uint8List data) async {
    Uint8List dataToEncrypt;
    CipherTextList cipherTextList = CipherTextList();
    // If data is bigger than 32mB -> split in chunks
    if (data.length > CipherTextList.chunkSize) {
      int chunkNb = (data.length / CipherTextList.chunkSize).ceil();
      for (var i = 0; i < chunkNb; i++) {
        dataToEncrypt = i < (chunkNb - 1)
            ? data.sublist(i * CipherTextList.chunkSize, (i + 1) * CipherTextList.chunkSize)
            : data.sublist(i * CipherTextList.chunkSize);
        Uint8List c = await platform.encrypt(
          dataToEncrypt,
          key.bytes,
          Utils.enumToStr(algorithm)
        ) ?? Uint8List(0);
        cipherTextList.add(CipherText(c.sublist(0, 12), c.sublist(12, c.length - 16), c.sublist(c.length - 16, c.length))); // TODO: generify this
      }
    } else {
      Uint8List c = await platform.encrypt(
        data,
        key.bytes,
        Utils.enumToStr(algorithm)
      ) ?? Uint8List(0);

      return CipherText(c.sublist(0, 12), c.sublist(12, c.length - 16), c.sublist(c.length - 16, c.length)); // TODO: generify this
    }

    return cipherTextList;
  }
}
