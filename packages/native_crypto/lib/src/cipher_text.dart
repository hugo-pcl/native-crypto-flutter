// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: cipher_text.dart
// Created Date: 16/12/2021 16:59:53
// Last Modified: 23/05/2022 21:48:27
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:native_crypto/src/byte_array.dart';

class CipherText extends ByteArray {
  final int _ivLength;
  final int _dataLength;
  final int _tagLength;

  CipherText(Uint8List iv, Uint8List data, Uint8List tag)
      : _ivLength = iv.length,
        _dataLength = data.length,
        _tagLength = tag.length,
        super(Uint8List.fromList(iv + data + tag));

  /// Gets the CipherText IV.
  Uint8List get iv => bytes.sublist(0, _ivLength);

  /// Gets the CipherText data.
  Uint8List get data => bytes.sublist(_ivLength, _ivLength + _dataLength);

  /// Gets the CipherText tag.
  Uint8List get tag => bytes.sublist(
        _ivLength + _dataLength,
        _ivLength + _dataLength + _tagLength,
      );

  /// Gets the CipherText IV length.
  int get ivLength => _ivLength;

  /// Gets the CipherText data length.
  int get dataLength => _dataLength;

  /// Gets the CipherText tag length.
  int get tagLength => _tagLength;
}

class CipherTextList extends CipherText {
  static const int chunkSize = 33554432;
  final List<CipherText> _list;

  CipherTextList()
      : _list = [],
        super(Uint8List(0), Uint8List(0), Uint8List(0));

  void add(CipherText cipherText) {
    _list.add(cipherText);
  }

  List<CipherText> get list => _list;
}
