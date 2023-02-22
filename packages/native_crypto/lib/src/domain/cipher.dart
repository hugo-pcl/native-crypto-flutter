// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:io';
import 'dart:typed_data';

import 'package:native_crypto/src/core/utils/cipher_text.dart';
import 'package:native_crypto/src/domain/cipher_chunk.dart';

/// {@template cipher}
/// Abstract class that defines the behavior of a Cipher.
/// {@endtemplate}
abstract class Cipher<T extends CipherChunk> {
  /// {@macro cipher}
  const Cipher();
  /// Encrypts a [Uint8List] and returns a [CipherText].
  Future<CipherText<T>> encrypt(Uint8List plainText);

  /// Decrypts a [CipherText] and returns a [Uint8List].
  Future<Uint8List> decrypt(CipherText<T> cipherText);

  /// Encrypts a File located at [plainTextFile] and saves the result
  /// at [cipherTextFile].
  Future<void> encryptFile(File plainTextFile, File cipherTextFile);

  /// Decrypts a File located at [cipherTextFile] and saves the result
  /// at [plainTextFile].
  Future<void> decryptFile(File cipherTextFile, File plainTextFile);
}
