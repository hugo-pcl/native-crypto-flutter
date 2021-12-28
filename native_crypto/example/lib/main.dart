// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: main.dart
// Created Date: 27/12/2021 21:15:12
// Last Modified: 28/12/2021 13:51:36
// -----
// Copyright (c) 2021

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_crypto_example/home.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Home());
  }
}
