// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: sha256.dart
// Created Date: 17/12/2021 11:31:20
// Last Modified: 23/05/2022 21:47:23
// -----
// Copyright (c) 2021

import 'package:native_crypto/src/hasher.dart';

class SHA256 extends Hasher {
  @override
  HashAlgorithm get algorithm => HashAlgorithm.sha256;
}
