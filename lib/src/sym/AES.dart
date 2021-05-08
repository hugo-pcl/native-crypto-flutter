// Copyright (c) 2021
// Author: Hugo Pointcheval

import 'dart:typed_data';

import 'package:native_crypto/native_crypto.dart';

import '../cipher.dart';
import '../exceptions.dart';
import '../key.dart';
import '../platform.dart';
import '../utils.dart';

/// Defines all available key sizes.
enum AESKeySize { bits128, bits192, bits256 }

extension AESKeySizeExtension on AESKeySize {
  int get length {
    Map<AESKeySize, int> table = <AESKeySize, int>{
      AESKeySize.bits128: 128,
      AESKeySize.bits192: 192,
      AESKeySize.bits256: 256,
    };
    return table[this];
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
    Uint8List dataToEncrypt;
    int maxSize = 33554432;
    AESCipherText cipherText = AESCipherText.empty();
    // If data is bigger than 32mB -> split in chunks
    if (data.length > maxSize) {
      int chunkNb = (data.length / maxSize).ceil();
      for (var i = 0; i < chunkNb; i++) {
        if (i < (chunkNb - 1)) {
          dataToEncrypt = data.sublist(i * maxSize, (i + 1) * maxSize);
        } else {
          dataToEncrypt = data.sublist(i * maxSize);
        }
        List<Uint8List> c = await Platform()
            .encrypt(dataToEncrypt, _sk.encoded, algorithm, _params);
        cipherText.append(c[0], c[1]);
      }
    } else {
      List<Uint8List> c =
          await Platform().encrypt(data, _sk.encoded, algorithm, _params);
      cipherText.append(c[0], c[1]);
    }
    return cipherText;
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
    } else if (cipherText.bytes.length != cipherText.iv.length) {
      throw DecryptionException(
          "This cipher text's bytes chunks length is not the same as iv chunks length");
    }

    BytesBuilder decryptedData = BytesBuilder();
    if (cipherText.size > 1) {
      for (var i = 0; i < cipherText.size; i++) {
        List<Uint8List> payload = [cipherText.bytes[i], cipherText.iv[i]];
        Uint8List d =
            await Platform().decrypt(payload, _sk.encoded, algorithm, _params);
        decryptedData.add(d);
      }
    } else {
      List<Uint8List> payload = [cipherText.bytes[0], cipherText.iv[0]];
      Uint8List d =
          await Platform().decrypt(payload, _sk.encoded, algorithm, _params);
      decryptedData.add(d);
    }
    return decryptedData.toBytes();
  }
}

class AESCipherText implements CipherText {
  List<Uint8List> _bytes;
  List<Uint8List> _iv;

  @override
  CipherAlgorithm get algorithm => CipherAlgorithm.AES;

  @override
  List<Uint8List> get bytes => _bytes;

  @override
  List<Uint8List> get iv => _iv;

  @override
  int get size => _bytes.length;

  AESCipherText(Uint8List bytes, Uint8List iv) {
    _bytes = List.from([bytes]);
    _iv = List.from([iv]);
  }

  AESCipherText.from(List<Uint8List> bytes, List<Uint8List> iv) {
    _bytes = bytes;
    _iv = iv;
  }

  AESCipherText.empty() {
    _bytes = <Uint8List>[];
    _iv = <Uint8List>[];
  }

  void append(Uint8List bytes, Uint8List iv) {
    _bytes.add(bytes);
    _iv.add(iv);
  }

  /// Returns this ciphertext in [Uint8List] format.
  ///
  /// Encoding
  /// --------
  /// Uint8List encoding is : IV_1 + M_1 + IV_2 + M_2 + ... + IV_n + M_n
  ///
  /// Where **IV_k** is the IV of the cipher text **M_k**
  ///
  /// IV is **always** 16 bytes long, And the **M** are all max
  /// size (of 33 554 480 bytes) except the last one which is shorter than the others.
  Uint8List encode() {
    BytesBuilder builder = BytesBuilder();
    for (var i = 0; i < size; i++) {
      builder.add(_iv[i]);
      builder.add(_bytes[i]);
    }

    return builder.toBytes();
  }

  /// Transforms a [Uint8List] to a *NativeCrypto* cipherText.
  ///
  /// Decoding
  /// --------
  /// See the list as a chain of chunks (IV and Messages)
  /// `[IV][MESSAGE][IV][MESSAGE] ... [IV][MESSA...]`
  ///
  /// Chunk length is IV length + Message length = 16 + 33 554 480 bytes
  void decode(Uint8List src) {
    ByteBuffer buffer = src.buffer;

    int chunkSize = 16 + 33554480;
    int chunkNb = (buffer.lengthInBytes / chunkSize).ceil();

    for (var i = 0; i < chunkNb; i++) {
      _iv.add(buffer.asUint8List(i * chunkSize, 16));
      if (i < (chunkNb - 1)) {
        _bytes.add(buffer.asUint8List(16 + i * chunkSize, 33554480));
      } else {
        _bytes.add(buffer.asUint8List(16 + i * chunkSize));
      }
    }
  }
}
