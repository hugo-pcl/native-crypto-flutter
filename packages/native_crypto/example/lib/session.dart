// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: session.dart
// Created Date: 28/12/2021 13:54:29
// Last Modified: 28/12/2021 13:58:49
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_crypto/native_crypto.dart';

class Session {
  SecretKey secretKey;
  Session() : secretKey = SecretKey(Uint8List(0));

  void setKey(SecretKey sk) {
    secretKey = sk;
  }
}

// Providers

final sessionProvider = StateProvider<Session>((ref) => Session());
