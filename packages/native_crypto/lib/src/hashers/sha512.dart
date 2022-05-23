// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: sha512.dart
// Created Date: 17/12/2021 11:32:14
// Last Modified: 23/05/2022 21:47:35
// -----
// Copyright (c) 2021

import 'package:native_crypto/src/hasher.dart';

class SHA512 extends Hasher {
  @override
  HashAlgorithm get algorithm => HashAlgorithm.sha512;
}
