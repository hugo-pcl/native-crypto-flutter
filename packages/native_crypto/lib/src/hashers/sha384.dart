// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: sha384.dart
// Created Date: 17/12/2021 11:31:53
// Last Modified: 18/12/2021 12:09:45
// -----
// Copyright (c) 2021

import '../hasher.dart';

class SHA384 extends Hasher{
  @override
  HashAlgorithm get algorithm => HashAlgorithm.sha384;
}