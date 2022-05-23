// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: utils.dart
// Created Date: 16/12/2021 16:28:00
// Last Modified: 28/12/2021 14:40:21
// -----
// Copyright (c) 2021

import 'dart:typed_data';
import 'dart:convert';

enum Encoding { utf16, base64, hex }

extension StringX on String {
  Uint8List toBytes({final from = Encoding.utf16}) {
    Uint8List bytes = Uint8List(0);
    switch (from) {
      case Encoding.utf16:
        bytes = Uint8List.fromList(runes.toList());
        break;
      case Encoding.base64:
        bytes = base64.decode(this);
        break;
      case Encoding.hex:
        bytes = Uint8List.fromList(
          List.generate(
            length ~/ 2,
            (i) => int.parse(substring(i * 2, (i * 2) + 2), radix: 16),
          ).toList(),
        );
    }
    return bytes;
  }
}

extension Uint8ListX on Uint8List {
  String toStr({final to = Encoding.utf16}) {
    String str = "";
    switch (to) {
      case Encoding.utf16:
        str = String.fromCharCodes(this);
        break;
      case Encoding.base64:
        str = base64.encode(this);
        break;
      case Encoding.hex:
        str = map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    }
    return str;
  }
}
