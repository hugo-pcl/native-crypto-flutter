// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: cipher_text.dart
// Created Date: 16/12/2021 16:59:53
// Last Modified: 26/05/2022 16:22:49
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:native_crypto/src/utils/cipher_algorithm.dart';
import 'package:native_crypto/src/utils/extensions.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

/// Represents a cipher text in Native Crypto.
///
/// It is represented as a [List] of [Uint8List] like:
/// ```txt
/// [[NONCE], [MESSAGE + TAG]]
/// ```
/// where:
/// - `[NONCE]` is a [Uint8List] of length [CipherText.ivLength]
/// - `[MESSAGE + TAG]` is a [Uint8List] of length [CipherText.dataLength]
/// 
/// To 
///
/// So accessing just the Message or just the Tag is costly and should be 
/// done only when needed.
class CipherText {
  final int _ivLength;
  final int _messageLength;
  final int _tagLength;

  final CipherAlgorithm? _cipherAlgorithm;

  final Uint8List? _iv;
  final Uint8List? _data; // Contains the message + tag (if any)

  CipherText._(
    this._ivLength,
    this._messageLength,
    this._tagLength,
    this._cipherAlgorithm,
    this._iv,
    this._data,
  );

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

  /// Gets the [Uint8List] of the [CipherText]'s IV.
  Uint8List get iv {
    if (_iv.isNotNull) {
      return _iv!;
    } else {
      throw NativeCryptoException(
        message: 'IV is not specified',
        code: NativeCryptoExceptionCode.invalid_data.code,
      );
    }
  }

  /// Gets the length of the [CipherText]'s IV.
  int get ivLength => _ivLength;

  /// Gets the [Uint8List] of the [CipherText]'s data.
  Uint8List get data {
    if (_data.isNotNull) {
      return _data!;
    } else {
      throw NativeCryptoException(
        message: 'Data is not specified',
        code: NativeCryptoExceptionCode.invalid_data.code,
      );
    }
  }

  /// Gets the length of the [CipherText]'s data.
  int get dataLength => _messageLength + _tagLength;

  // CipherText.fromBytes(
  //   Uint8List bytes, {
  //   required int ivLength,
  //   required int dataLength,
  //   int tagLength = 0,
  // })  : _ivLength = ivLength,
  //       _dataLength = dataLength,
  //       _tagLength = tagLength,
  //       _iv = bytes.sublist(0, ivLength),
  //       super(bytes.sublist(ivLength, bytes.length - tagLength));

  // const CipherText.fromIvAndBytes(
  //   Uint8List iv,
  //   super.data, {
  //   required int dataLength,
  //   int tagLength = 0,
  // })  : _ivLength = iv.length,
  //       _dataLength = dataLength,
  //       _tagLength = tagLength,
  //       _iv = iv;

  // CipherText.fromPairIvAndBytes(
  //   List<Uint8List> pair, {
  //   required int dataLength,
  //   int tagLength = 0,
  // })  : _ivLength = pair.first.length,
  //       _dataLength = dataLength,
  //       _tagLength = tagLength,
  //       _iv = pair.first,
  //       super(pair.last);

  // /// Gets the CipherText IV.
  // Uint8List get iv => _iv;

  // /// Gets the CipherText data.
  // Uint8List get data => _tagLength > 0
  //     ? bytes.sublist(0, _dataLength - _tagLength)
  //     : bytes;

  // /// Gets the CipherText tag.
  // Uint8List get tag => _tagLength > 0
  //     ? bytes.sublist(_dataLength - _tagLength, _dataLength)
  //     : Uint8List(0);

  // /// Gets the CipherText data and tag.
  // Uint8List get payload => bytes;

  // /// Gets the CipherText IV length.
  // int get ivLength => _ivLength;

  // /// Gets the CipherText data length.
  // int get dataLength => _dataLength;

  // /// Gets the CipherText tag length.
  // int get tagLength => _tagLength;
}
