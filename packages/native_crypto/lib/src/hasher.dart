// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: hasher.dart
// Created Date: 16/12/2021 16:28:00
// Last Modified: 27/12/2021 22:06:29
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'platform.dart';
import 'utils.dart';

enum HashAlgorithm { sha256, sha384, sha512 }

abstract class Hasher {
  /// Returns the standard algorithm name for this digest
  HashAlgorithm get algorithm;

  /// Hashes a message
  Future<Uint8List> digest(Uint8List data) async {
    Uint8List hash =
        (await platform.digest(data, Utils.enumToStr(algorithm))) ??
            Uint8List(0);

    return hash;
  }
}
