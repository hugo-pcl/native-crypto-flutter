// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: cipher_text_list.dart
// Created Date: 23/05/2022 22:59:02
// Last Modified: 23/05/2022 23:05:02
// -----
// Copyright (c) 2022

import 'dart:typed_data';

import 'package:native_crypto/src/core/cipher_text.dart';

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
