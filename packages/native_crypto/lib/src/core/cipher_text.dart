// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: cipher_text.dart
// Created Date: 16/12/2021 16:59:53
// Last Modified: 24/05/2022 21:27:44
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:native_crypto/src/interfaces/byte_array.dart';

class CipherText extends ByteArray {
  final int _ivLength;
  final int _dataLength;
  final int _tagLength;

  final Uint8List _iv;

  CipherText(Uint8List iv, Uint8List data, Uint8List? tag)
      : _ivLength = iv.length,
        _dataLength = data.length,
        _tagLength = tag?.length ?? 0,
        _iv = iv,
        super((tag != null) ? Uint8List.fromList(data + tag) : data);

  CipherText.fromBytes(
    Uint8List bytes, {
    required int ivLength,
    required int dataLength,
    int tagLength = 0,
  })  : _ivLength = ivLength,
        _dataLength = dataLength,
        _tagLength = tagLength,
        _iv = bytes.sublist(0, ivLength),
        super(bytes.sublist(ivLength, bytes.length - tagLength));

  const CipherText.fromIvAndBytes(
    Uint8List iv,
    super.data, {
    required int dataLength,
    int tagLength = 0,
  })  : _ivLength = iv.length,
        _dataLength = dataLength,
        _tagLength = tagLength,
        _iv = iv;

  CipherText.fromPairIvAndBytes(
    List<Uint8List> pair, {
    required int dataLength,
    int tagLength = 0,
  })  : _ivLength = pair.first.length,
        _dataLength = dataLength,
        _tagLength = tagLength,
        _iv = pair.first,
        super(pair.last);

  /// Gets the CipherText IV.
  Uint8List get iv => _iv;

  /// Gets the CipherText data.
  Uint8List get data => _tagLength > 0
      ? bytes.sublist(0, _dataLength - _tagLength)
      : bytes;

  /// Gets the CipherText tag.
  Uint8List get tag => _tagLength > 0
      ? bytes.sublist(_dataLength - _tagLength, _dataLength)
      : Uint8List(0);

  /// Gets the CipherText data and tag.
  Uint8List get payload => bytes;

  /// Gets the CipherText IV length.
  int get ivLength => _ivLength;

  /// Gets the CipherText data length.
  int get dataLength => _dataLength;

  /// Gets the CipherText tag length.
  int get tagLength => _tagLength;
}
