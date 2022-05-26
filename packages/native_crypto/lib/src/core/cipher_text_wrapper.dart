// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: cipher_text_wrapper.dart
// Created Date: 26/05/2022 14:27:32
// Last Modified: 26/05/2022 15:53:46
// -----
// Copyright (c) 2022

import 'dart:typed_data';

import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto/src/utils/extensions.dart';

class CipherTextWrapper {
  final CipherText? _single;
  final List<CipherText>? _list;

  CipherTextWrapper._(this._single, this._list);

  factory CipherTextWrapper.single(CipherText cipherText) =>
      CipherTextWrapper._(cipherText, null);

  factory CipherTextWrapper.list(List<CipherText> cipherTexts) =>
      CipherTextWrapper._(null, cipherTexts);

  factory CipherTextWrapper.fromBytes(
      // Uint8List bytes, {
      // required int ivLength,
      // required int dataLength,
      // int tagLength = 0,
      // int? chunkSize,
      // }
      ) {
        // TODO(hpcl): implement fromBytes
    throw UnimplementedError();
  }

  bool get isSingle => _single.isNotNull;
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
  Uint8List get raw {
    if (isSingle) {
      return single.bytes;
    } else {
      return list.map((cipherText) => cipherText.bytes).toList().sum();
    }
  }

  int get chunkCount {
    _single.isNull;
    if (_single.isNotNull) {
      return 1;
    } else {
      return _list?.length ?? 0;
    }
  }
}
