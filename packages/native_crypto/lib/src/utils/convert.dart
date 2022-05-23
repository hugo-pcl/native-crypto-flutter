// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: convert.dart
// Created Date: 16/12/2021 16:28:00
// Last Modified: 23/05/2022 22:39:19
// -----
// Copyright (c) 2021

import 'dart:typed_data';

abstract class Convert {
  static Uint8List decodeHexString(String input) {
    assert(input.length.isEven, 'Input needs to be an even length.');

    return Uint8List.fromList(
      List.generate(
        input.length ~/ 2,
        (i) => int.parse(input.substring(i * 2, (i * 2) + 2), radix: 16),
      ).toList(),
    );
  }
}
