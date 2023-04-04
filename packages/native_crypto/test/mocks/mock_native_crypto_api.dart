// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:native_crypto_platform_interface/native_crypto_platform_interface_gen.dart';

class MockNativeCryptoAPI implements NativeCryptoAPI {
  static Uint8List? Function(int length)? generateSecureRandomFn;

  static Uint8List? Function(
    Uint8List data,
    String algorithm,
  )? hashFn;

  static Uint8List? Function(
    Uint8List data,
    Uint8List key,
    String algorithm,
  )? hmacFn;

  static Uint8List? Function(
    Uint8List cipherText,
    Uint8List key,
    String algorithm,
  )? decryptFn;

  static bool? Function(
    String cipherTextPath,
    String plainTextPath,
    Uint8List key,
    String algorithm,
  )? decryptFileFn;

  static Uint8List? Function(
    Uint8List plainText,
    Uint8List key,
    String algorithm,
  )? encryptFn;

  static Uint8List? Function(
    Uint8List plainText,
    Uint8List key,
    Uint8List iv,
    String algorithm,
  )? encryptWithIVFn;

  static bool? Function(
    String plainTextPath,
    String cipherTextPath,
    Uint8List key,
    String algorithm,
  )? encryptFileFn;

  static bool? Function(
    String plainTextPath,
    String cipherTextPath,
    Uint8List key,
    Uint8List iv,
    String algorithm,
  )? encryptFileWithIVFn;

  static Uint8List? Function(
    Uint8List password,
    Uint8List salt,
    int iterations,
    int length,
    String algorithm,
  )? pbkdf2Fn;

  @override
  Future<Uint8List?> decrypt(
    Uint8List argCiphertext,
    Uint8List argKey,
    CipherAlgorithm argAlgorithm,
  ) async {
    if (decryptFn != null) {
      return decryptFn!(argCiphertext, argKey, argAlgorithm.toString());
    } else {
      return Uint8List.fromList([1, 2, 3]);
    }
  }

  @override
  Future<bool?> decryptFile(
    String argCiphertextpath,
    String argPlaintextpath,
    Uint8List argKey,
    CipherAlgorithm argAlgorithm,
  ) async {
    if (decryptFileFn != null) {
      return decryptFileFn!(
        argCiphertextpath,
        argPlaintextpath,
        argKey,
        argAlgorithm.toString(),
      );
    } else {
      return Future.value(true);
    }
  }

  @override
  Future<Uint8List?> encrypt(
    Uint8List argPlaintext,
    Uint8List argKey,
    CipherAlgorithm argAlgorithm,
  ) async {
    if (encryptFn != null) {
      return encryptFn!(argPlaintext, argKey, argAlgorithm.toString());
    } else {
      return Uint8List.fromList([1, 2, 3]);
    }
  }

  @override
  Future<bool?> encryptFile(
    String argPlaintextpath,
    String argCiphertextpath,
    Uint8List argKey,
    CipherAlgorithm argAlgorithm,
  ) async {
    if (encryptFileFn != null) {
      return encryptFileFn!(
        argPlaintextpath,
        argCiphertextpath,
        argKey,
        argAlgorithm.toString(),
      );
    } else {
      return Future.value(true);
    }
  }

  @override
  Future<bool?> encryptFileWithIV(
    String argPlaintextpath,
    String argCiphertextpath,
    Uint8List argIv,
    Uint8List argKey,
    CipherAlgorithm argAlgorithm,
  ) async {
    if (encryptFileWithIVFn != null) {
      return encryptFileWithIVFn!(
        argPlaintextpath,
        argCiphertextpath,
        argKey,
        argIv,
        argAlgorithm.toString(),
      );
    } else {
      return Future.value(true);
    }
  }

  @override
  Future<Uint8List?> encryptWithIV(
    Uint8List argPlaintext,
    Uint8List argIv,
    Uint8List argKey,
    CipherAlgorithm argAlgorithm,
  ) async {
    if (encryptWithIVFn != null) {
      return encryptWithIVFn!(
        argPlaintext,
        argKey,
        argIv,
        argAlgorithm.toString(),
      );
    } else {
      return Future.value(Uint8List.fromList([1, 2, 3]));
    }
  }

  @override
  Future<Uint8List?> generateSecureRandom(int argLength) {
    if (generateSecureRandomFn != null) {
      return Future.value(generateSecureRandomFn!(argLength));
    } else {
      return Future.value(Uint8List.fromList([1, 2, 3]));
    }
  }

  @override
  Future<Uint8List?> hash(Uint8List argData, HashAlgorithm argAlgorithm) {
    if (hashFn != null) {
      return Future.value(hashFn!(argData, argAlgorithm.toString()));
    } else {
      return Future.value(Uint8List.fromList([1, 2, 3]));
    }
  }

  @override
  Future<Uint8List?> hmac(
    Uint8List argData,
    Uint8List argKey,
    HashAlgorithm argAlgorithm,
  ) {
    if (hmacFn != null) {
      return Future.value(hmacFn!(argData, argKey, argAlgorithm.toString()));
    } else {
      return Future.value(Uint8List.fromList([1, 2, 3]));
    }
  }

  @override
  Future<Uint8List?> pbkdf2(
    Uint8List argPassword,
    Uint8List argSalt,
    int argLength,
    int argIterations,
    HashAlgorithm argAlgorithm,
  ) {
    if (pbkdf2Fn != null) {
      return Future.value(pbkdf2Fn!(
        argPassword,
        argSalt,
        argIterations,
        argLength,
        argAlgorithm.toString(),
      ),);
    } else {
      return Future.value(Uint8List.fromList([1, 2, 3]));
    }
  }
}
