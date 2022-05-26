// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: cipher_text_wrapper.dart
// Created Date: 26/05/2022 14:27:32
// Last Modified: 26/05/2022 22:11:42
// -----
// Copyright (c) 2022

import 'dart:typed_data';

import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto/src/utils/extensions.dart';

/// Wrapper for [CipherText]
///
/// Typically, this object is the result of an encryption operation.
/// For decryption you have to build this before using it.
class CipherTextWrapper {
  final CipherText? _single;
  final List<CipherText>? _list;

  CipherTextWrapper._(this._single, this._list);

  /// Creates a [CipherTextWrapper] from a [CipherText].
  factory CipherTextWrapper.single(CipherText cipherText) =>
      CipherTextWrapper._(cipherText, null);

  /// Creates a [CipherTextWrapper] from a [List] of [CipherText].
  factory CipherTextWrapper.list(List<CipherText> cipherTexts) =>
      CipherTextWrapper._(null, cipherTexts);

  /// Creates an empty [List] in a [CipherTextWrapper].
  ///
  /// This is useful when you want to create a [CipherTextWrapper] then
  /// fill it with data.
  factory CipherTextWrapper.empty() => CipherTextWrapper._(null, []);

  /// Creates a [CipherTextWrapper] from a [Uint8List].
  ///
  /// This is a convenience method to create a [CipherTextWrapper]
  /// from a [Uint8List]. It tries to detect if the [Uint8List] is a
  /// single [CipherText] or a list of [CipherText].
  ///
  /// You can customize the chunk size by passing a [chunkSize] parameter.
  /// The default chunk size is [Cipher.bytesCountPerChunk].
  ///
  /// Throw an [NativeCryptoExceptionCode] with
  /// [NativeCryptoExceptionCode.invalid_argument] if the [Uint8List] is
  /// not a valid [CipherText] or a [List] of [CipherText].
  factory CipherTextWrapper.fromBytes(
    Uint8List bytes, {
    required int ivLength,
    required int messageLength,
    required int tagLength,
    CipherAlgorithm? cipherAlgorithm,
    int? chunkSize,
  }) {
    chunkSize ??= Cipher.bytesCountPerChunk;
    Cipher.bytesCountPerChunk = chunkSize;

    if (bytes.length <= chunkSize) {
      return CipherTextWrapper.single(
        CipherText.fromBytes(
          bytes,
          ivLength: ivLength,
          messageLength: messageLength,
          tagLength: tagLength,
          cipherAlgorithm: cipherAlgorithm,
        ),
      );
    } else {
      final cipherTexts = <CipherText>[];
      for (var i = 0; i < bytes.length; i += chunkSize) {
        final chunk = bytes.sublist(i, i + chunkSize);
        cipherTexts.add(
          CipherText.fromBytes(
            chunk,
            ivLength: ivLength,
            messageLength: messageLength,
            tagLength: tagLength,
            cipherAlgorithm: cipherAlgorithm,
          ),
        );
      }
      return CipherTextWrapper.list(cipherTexts);
    }
  }

  /// Checks if the [CipherText] is a single [CipherText].
  bool get isSingle => _single.isNotNull;

  /// Checks if the [CipherText] is a [List] of [CipherText].
  bool get isList => _list.isNotNull;

  /// Gets the [CipherText] if it's a single one.
  ///
  /// Throws [NativeCryptoException] with
  /// [NativeCryptoExceptionCode.invalid_data] if it's not a single one.
  CipherText get single {
    if (isSingle) {
      return _single!;
    } else {
      throw NativeCryptoException(
        message: 'CipherTextWrapper is not single',
        code: NativeCryptoExceptionCode.invalid_data.code,
      );
    }
  }

  /// Gets the [List] of [CipherText] if it's a list.
  ///
  /// Throws [NativeCryptoException] with
  /// [NativeCryptoExceptionCode.invalid_data] if it's not a list.
  List<CipherText> get list {
    if (isList) {
      return _list!;
    } else {
      throw NativeCryptoException(
        message: 'CipherTextWrapper is not list',
        code: NativeCryptoExceptionCode.invalid_data.code,
      );
    }
  }

  /// Gets the raw [Uint8List] of the [CipherText] or [List] of [CipherText].
  Uint8List get bytes {
    if (isSingle) {
      return single.bytes;
    } else {
      return list.map((cipherText) => cipherText.bytes).toList().combine();
    }
  }

  /// Gets the number of parts of the [CipherText] or [List] of [CipherText].
  ///
  /// Check [Cipher.bytesCountPerChunk] for more information.
  int get chunkCount {
    _single.isNull;
    if (_single.isNotNull) {
      return 1;
    } else {
      return _list?.length ?? 0;
    }
  }

  /// Gets the [CipherText] or the [List] of [CipherText].
  ///
  /// Throws [NativeCryptoException] with
  /// [NativeCryptoExceptionCode.invalid_data] if it's not a single or a list or
  /// if [T] is not [CipherText] or [List] of [CipherText].
  T unwrap<T>() {
    if (isSingle && T == CipherText) {
      return single as T;
    } else if (isList && T == List<CipherText>) {
      return list as T;
    } else {
      final String type =
          isSingle ? 'CipherText' : (isList ? 'List<CipherText>' : 'unknown');
      throw NativeCryptoException(
        message: 'CipherTextWrapper is not a $T but a $type, '
            'you should use unwrap<$type>()',
        code: NativeCryptoExceptionCode.invalid_data.code,
      );
    }
  }

  void add(CipherText cipherText) {
    if (isSingle) {
      throw NativeCryptoException(
        message: 'CipherTextWrapper is already single',
        code: NativeCryptoExceptionCode.invalid_data.code,
      );
    } else if (isList) {
      _list!.add(cipherText);
    } else {
      throw NativeCryptoException(
        message: 'CipherTextWrapper is not single or list',
        code: NativeCryptoExceptionCode.invalid_data.code,
      );
    }
  }
}
