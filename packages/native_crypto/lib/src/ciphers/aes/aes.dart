// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:io';
import 'dart:typed_data';

import 'package:native_crypto/src/ciphers/aes/aes_cipher_chunk.dart';
import 'package:native_crypto/src/ciphers/aes/aes_key_size.dart';
import 'package:native_crypto/src/ciphers/aes/aes_mode.dart';
import 'package:native_crypto/src/ciphers/aes/aes_padding.dart';
import 'package:native_crypto/src/core/constants/constants.dart';
import 'package:native_crypto/src/core/extensions/uint8_list_extension.dart';
import 'package:native_crypto/src/core/utils/cipher_text.dart';
import 'package:native_crypto/src/core/utils/platform.dart';
import 'package:native_crypto/src/domain/cipher.dart';
import 'package:native_crypto/src/keys/secret_key.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

export 'aes_cipher_chunk.dart';
export 'aes_key_size.dart';
export 'aes_mode.dart';
export 'aes_padding.dart';

/// {@template aes}
/// AES cipher.
///
/// [AES] is a symmetric cipher which means that the same key is used to encrypt
/// and decrypt the data.
/// {@endtemplate}
class AES implements Cipher<AESCipherChunk> {
  const AES({
    required this.key,
    required this.mode,
    required this.padding,
    this.chunkSize = Constants.defaultChunkSize,
  });

  static const String _algorithm = 'aes';

  /// The key used to encrypt and decrypt the data.
  final SecretKey key;

  /// The [AESMode] used by this [AES].
  final AESMode mode;

  /// The [AESPadding] used by this [AES].
  final AESPadding padding;

  /// The size of the cipher text chunks.
  final int chunkSize;

  @override
  Future<Uint8List> decrypt(CipherText<AESCipherChunk> cipherText) async {
    final BytesBuilder plainText = BytesBuilder(copy: false);
    final chunks = cipherText.chunks;

    int i = 0;
    for (final chunk in chunks) {
      plainText.add(await _decryptChunk(chunk.bytes, count: i++));
    }

    return plainText.toBytes();
  }

  @override
  Future<void> decryptFile(File cipherTextFile, File plainTextFile) {
    if (!cipherTextFile.existsSync()) {
      throw ArgumentError.value(
        cipherTextFile.path,
        'cipherTextFile.path',
        'File does not exist!',
      );
    }

    if (plainTextFile.existsSync()) {
      throw ArgumentError.value(
        plainTextFile.path,
        'plainTextFile.path',
        'File already exists!',
      );
    }

    return platform.decryptFile(
      cipherTextPath: cipherTextFile.path,
      plainTextPath: plainTextFile.path,
      key: key.bytes,
      algorithm: _algorithm,
    );
  }

  @override
  Future<CipherText<AESCipherChunk>> encrypt(Uint8List plainText) async {
    final chunks = <AESCipherChunk>[];
    final chunkedPlainText = plainText.chunked(chunkSize);

    int i = 0;
    for (final plainTextChunk in chunkedPlainText) {
      final bytes = await _encryptChunk(plainTextChunk, count: i++);
      chunks.add(
        AESCipherChunk(
          bytes,
          ivLength: mode.ivLength,
          tagLength: mode.tagLength,
        ),
      );
    }

    return CipherText.fromChunks(
      chunks,
      chunkFactory: (bytes) => AESCipherChunk(
        bytes,
        ivLength: mode.ivLength,
        tagLength: mode.tagLength,
      ),
      chunkSize: chunkSize,
    );
  }

  @override
  Future<void> encryptFile(File plainTextFile, File cipherTextFile) {
    if (!plainTextFile.existsSync()) {
      throw ArgumentError.value(
        plainTextFile.path,
        'plainTextFile.path',
        'File does not exist!',
      );
    }

    if (cipherTextFile.existsSync()) {
      throw ArgumentError.value(
        cipherTextFile.path,
        'cipherTextFile.path',
        'File already exists!',
      );
    }

    return platform.encryptFile(
      plainTextPath: plainTextFile.path,
      cipherTextPath: cipherTextFile.path,
      key: key.bytes,
      algorithm: _algorithm,
    );
  }

  /// Encrypts the [plainText] with the [iv] chosen by the Flutter side.
  ///
  /// Prefer using [encrypt] instead which will generate a
  /// random [iv] on the native side.
  ///
  /// Note: this method doesn't chunk the data. It can lead to memory issues
  /// if the [plainText] is too big. Use [encrypt] instead.
  Future<AESCipherChunk> encryptWithIV(
    Uint8List plainText,
    Uint8List iv,
  ) async {
    // Check if the cipher is correctly initialized
    _isCorrectlyInitialized();

    if (iv.length != mode.ivLength) {
      throw ArgumentError.value(
        iv.length,
        'iv.length',
        'Invalid iv length! '
            'Expected: ${mode.ivLength}',
      );
    }

    final bytes = await platform.encryptWithIV(
      plainText: plainText,
      iv: iv,
      key: key.bytes,
      algorithm: _algorithm,
    );

    // TODO(hpcl): move these checks to the platform interface
    if (bytes == null) {
      throw const NativeCryptoException(
        code: NativeCryptoExceptionCode.nullError,
        message: 'Platform returned null bytes',
      );
    }

    if (bytes.isEmpty) {
      throw const NativeCryptoException(
        code: NativeCryptoExceptionCode.invalidData,
        message: 'Platform returned no data',
      );
    }

    return AESCipherChunk(
      bytes,
      ivLength: mode.ivLength,
      tagLength: mode.tagLength,
    );
  }

  /// Ensures that the cipher is correctly initialized.
  bool _isCorrectlyInitialized() {
    final keySize = key.length * 8;
    if (!AESKeySize.supportedSizes.contains(keySize)) {
      throw ArgumentError.value(
        keySize,
        'keySize',
        'Invalid key size! '
            'Expected: ${AESKeySize.supportedSizes.join(', ')}',
      );
    }

    if (!mode.supportedPaddings.contains(padding)) {
      throw ArgumentError.value(
        padding,
        'padding',
        'Invalid padding! '
            'Expected: ${mode.supportedPaddings.join(', ')}',
      );
    }

    return true;
  }

  /// Encrypts the plain text chunk.
  Future<Uint8List> _encryptChunk(Uint8List plainChunk, {int count = 0}) async {
    // Check if the cipher is correctly initialized
    _isCorrectlyInitialized();

    Uint8List? bytes;

    try {
      bytes = await platform.encrypt(
        plainChunk,
        key: key.bytes,
        algorithm: _algorithm,
      );
    } on NativeCryptoException catch (e) {
      throw e.copyWith(
        message: 'Failed to encrypt chunk #$count: ${e.message}',
      );
    }

    // TODO(hpcl): move these checks to the platform interface
    if (bytes == null) {
      throw NativeCryptoException(
        code: NativeCryptoExceptionCode.nullError,
        message: 'Platform returned null bytes on chunk #$count',
      );
    }

    if (bytes.isEmpty) {
      throw NativeCryptoException(
        code: NativeCryptoExceptionCode.invalidData,
        message: 'Platform returned no data on chunk #$count',
      );
    }

    return bytes;
  }

  /// Decrypts the cipher text chunk.
  Future<Uint8List> _decryptChunk(
    Uint8List cipherChunk, {
    int count = 0,
  }) async {
    // Check if the cipher is correctly initialized
    _isCorrectlyInitialized();

    Uint8List? bytes;

    try {
      bytes = await platform.decrypt(
        cipherChunk,
        key: key.bytes,
        algorithm: _algorithm,
      );
    } on NativeCryptoException catch (e) {
      throw e.copyWith(
        message: 'Failed to decrypt chunk #$count: ${e.message}',
      );
    }

    // TODO(hpcl): move these checks to the platform interface
    if (bytes == null) {
      throw NativeCryptoException(
        code: NativeCryptoExceptionCode.nullError,
        message: 'Platform returned null bytes on chunk #$count',
      );
    }

    return bytes;
  }
}
