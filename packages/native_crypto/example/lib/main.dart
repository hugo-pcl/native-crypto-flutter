// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: main.dart
// Created Date: 27/12/2021 21:15:12
// Last Modified: 10/01/2023 14:59:05
// -----
// Copyright (c) 2021

import 'package:flutter/material.dart';
import 'package:native_crypto_example/core/get_it.dart';
import 'package:native_crypto_example/presentation/app/app.dart';

Future<void> main() async {
  await GetItInitializer.init();

  runApp(App());
}
