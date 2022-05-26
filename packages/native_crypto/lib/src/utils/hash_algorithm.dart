// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: hash_algorithm.dart
// Created Date: 23/05/2022 22:01:59
// Last Modified: 26/05/2022 18:53:38
// -----
// Copyright (c) 2022

import 'dart:typed_data';

import 'package:native_crypto/src/platform.dart';

/// Defines the hash algorithms.
enum HashAlgorithm {
  sha256,
  sha384,
  sha512;
  
  /// Digest the [data] using this [HashAlgorithm].
  Future<Uint8List> digest(Uint8List data) async {
    final Uint8List hash = (await platform.digest(data, name)) ?? Uint8List(0);

    return hash;
  }
}
