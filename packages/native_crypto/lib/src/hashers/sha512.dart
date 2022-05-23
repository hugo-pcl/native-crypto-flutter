// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: sha512.dart
// Created Date: 17/12/2021 11:32:14
// Last Modified: 18/12/2021 12:09:58
// -----
// Copyright (c) 2021

import '../hasher.dart';

class SHA512 extends Hasher{
  @override
  HashAlgorithm get algorithm => HashAlgorithm.sha512;
}