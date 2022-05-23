// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: sha256.dart
// Created Date: 17/12/2021 11:31:20
// Last Modified: 18/12/2021 12:09:33
// -----
// Copyright (c) 2021

import '../hasher.dart';

class SHA256 extends Hasher{
  @override
  HashAlgorithm get algorithm => HashAlgorithm.sha256;
}