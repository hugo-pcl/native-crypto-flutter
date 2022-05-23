// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: sha384.dart
// Created Date: 17/12/2021 11:31:53
// Last Modified: 23/05/2022 21:47:28
// -----
// Copyright (c) 2021

import 'package:native_crypto/src/hasher.dart';

class SHA384 extends Hasher {
  @override
  HashAlgorithm get algorithm => HashAlgorithm.sha384;
}
