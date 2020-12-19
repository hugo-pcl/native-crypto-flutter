// Copyright (c) 2020
// Author: Hugo Pointcheval

import 'dart:typed_data';

import '../cipher.dart';
import '../exceptions.dart';
import '../key.dart';
import '../platform.dart';
import '../utils.dart';

/// Defines all available key sizes.
enum AESKeySize { bits128, bits192, bits256 }

extension AESKeySizeExtension on AESKeySize {
  int get length {
    int l;
    switch (this) {
      case AESKeySize.bits128:
        l = 128;
        break;
      case AESKeySize.bits192:
        l = 192;
        break;
      case AESKeySize.bits256:
        l = 256;
        break;
    }
    return l;
  }
}

class AESCipher implements Cipher {
  SecretKey _sk;
  CipherParameters _params;
  bool _isInit;

  @override
  CipherAlgorithm get algorithm => CipherAlgorithm.AES;

  @override
  SecretKey get secretKey => _sk;

  @override
  CipherParameters get parameters => _params;

  @override
  bool get isInitialized => _isInit;

  @override
  List<CipherParameters> get supportedParameters => [
        CipherParameters(BlockCipherMode.CBC, PlainTextPadding.PKCS5),
      ];

  /// Creates an AES cipher with specified secretKey and mode/padding
  AESCipher(SecretKey secretKey, CipherParameters parameters) {
    if (secretKey.algorithm != CipherAlgorithm.AES.name) {
      List<int> _supportedSizes = [128, 192, 256];
      if (!_supportedSizes.contains(secretKey.encoded.length)) {
        throw CipherInitException("Invalid key length!");
      }
    } else if (!supportedParameters.contains(parameters)) {
      throw CipherInitException("Invalid cipher parameters.");
    }
    _sk = secretKey;
    _params = parameters;
    _isInit = true;
  }

  /// Generates a secret key of specified size, then creates an AES cipher.
  static Future<AESCipher> generate(
      AESKeySize size, CipherParameters parameters) async {
    SecretKey _sk = await SecretKey.generate(size.length, CipherAlgorithm.AES);
    return AESCipher(_sk, parameters);
  }

  @override
  Future<CipherText> encrypt(Uint8List data) async {
    if (!_isInit) {
      throw CipherInitException('Cipher not properly initialized.');
    } else if (_sk == null || _sk.isEmpty) {
      throw CipherInitException('Invalid key size.');
    }
    List<Uint8List> c =
        await Platform().encrypt(data, _sk.encoded, algorithm, _params);
    return AESCipherText(c[0], c[1]);
  }

  @override
  Future<Uint8List> decrypt(CipherText cipherText) async {
    if (cipherText.algorithm != CipherAlgorithm.AES) {
      throw DecryptionException("This cipher text's algorithm is not AES: " +
          cipherText.algorithm.name +
          "\nYou must use an AESCipherText.");
    } else if (!_isInit) {
      throw CipherInitException('Cipher not properly initialized.');
    } else if (_sk == null || _sk.isEmpty) {
      throw CipherInitException('Invalid key size.');
    }
    List<Uint8List> payload = [cipherText.bytes, cipherText.iv];
    Uint8List d =
        await Platform().decrypt(payload, _sk.encoded, algorithm, _params);
    return d;
  }
}

class AESCipherText implements CipherText {
  Uint8List _bytes;
  Uint8List _iv;

  @override
  CipherAlgorithm get algorithm => CipherAlgorithm.AES;

  @override
  Uint8List get bytes => _bytes;

  @override
  Uint8List get iv => _iv;

  AESCipherText(Uint8List bytes, Uint8List iv) {
    _bytes = bytes;
    _iv = iv;
  }
}
