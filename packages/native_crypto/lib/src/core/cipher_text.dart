// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: cipher_text.dart
// Created Date: 16/12/2021 16:59:53
// Last Modified: 27/05/2022 12:09:47
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:native_crypto/src/core/cipher_text_wrapper.dart';
import 'package:native_crypto/src/interfaces/byte_array.dart';
import 'package:native_crypto/src/interfaces/cipher.dart';
import 'package:native_crypto/src/utils/cipher_algorithm.dart';
import 'package:native_crypto/src/utils/extensions.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

/// Represents a cipher text in NativeCrypto.
///
/// [CipherText] is a [ByteArray] that can be used to store encrypted data.
/// It is represented like:
/// ```txt
/// [IV + MESSAGE + TAG]
/// ```
/// where:
/// - IV's length is [CipherText.ivLength] bytes.
/// - MESSAGE's length is [CipherText.messageLength] bytes.
/// - TAG's length is [CipherText.tagLength] bytes.
///
/// Check [CipherTextWrapper] for more information.
class CipherText extends ByteArray {
  final int _ivLength;
  final int _messageLength;
  final int _tagLength;

  final CipherAlgorithm? _cipherAlgorithm;

  const CipherText._(
    this._ivLength,
    this._messageLength,
    this._tagLength,
    this._cipherAlgorithm,
    super.bytes,
  );

  factory CipherText.fromBytes(
    Uint8List bytes, {
    required int ivLength,
    required int tagLength,
    int? messageLength,
    CipherAlgorithm? cipherAlgorithm,
  }) {
    messageLength ??= bytes.length - ivLength - tagLength;

    if (ivLength.isNegative ||
        messageLength.isNegative ||
        tagLength.isNegative) {
      throw NativeCryptoException(
        message: 'Invalid length! Must be positive.',
        code: NativeCryptoExceptionCode.invalid_argument.code,
      );
    }

    if (bytes.isEmpty) {
      throw NativeCryptoException(
        message: 'Passed data is empty!',
        code: NativeCryptoExceptionCode.invalid_argument.code,
      );
    }

    if (bytes.length != ivLength + messageLength + tagLength) {
      throw NativeCryptoException(
        message: 'Invalid cipher text length! '
            'Expected: ${ivLength + messageLength + tagLength} bytes '
            'got: ${bytes.length} bytes.',
        code: NativeCryptoExceptionCode.invalid_argument.code,
      );
    }

    if (messageLength > Cipher.bytesCountPerChunk) {
      throw NativeCryptoException(
        message: 'Cipher text is too big! Consider using chunks.',
        code: NativeCryptoExceptionCode.invalid_argument.code,
      );
    }

    return CipherText._(
      ivLength,
      messageLength,
      tagLength,
      cipherAlgorithm,
      bytes,
    );
  }

  /// Gets the [CipherAlgorithm] used to encrypt the [CipherText].
  CipherAlgorithm get cipherAlgorithm {
    if (_cipherAlgorithm.isNotNull) {
      return _cipherAlgorithm!;
    } else {
      throw NativeCryptoException(
        message: 'Cipher algorithm is not specified',
        code: NativeCryptoExceptionCode.invalid_cipher.code,
      );
    }
  }

  /// Gets the length of the [CipherText]'s IV.
  int get ivLength => _ivLength;

  /// Gets the length of the [CipherText]'s Message.
  int get messageLength => _messageLength;

  /// Gets the length of the [CipherText]'s Tag.
  int get tagLength => _tagLength;
}
