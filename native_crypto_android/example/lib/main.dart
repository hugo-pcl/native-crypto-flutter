// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: main.dart
// Created Date: 27/12/2021 22:43:20
// Last Modified: 28/12/2021 18:18:44
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

void main() {
  runApp(const MyApp());
}

void run() async {
  NativeCryptoPlatform _nativeCryptoPlatform = NativeCryptoPlatform.instance;
  
  debugPrint("Benchmark");

  int size = 25;
  int iterations = 25;
  int totalEnc = 0;
  int totalDec = 0;

  debugPrint("Size: $size MB");
  Uint8List? secretKey = await _nativeCryptoPlatform.generateSecretKey(128);

  debugPrint("Generate random data...");
  var before = DateTime.now();
  Uint8List data = Uint8List(size * 1024 * 1024);
  var after = DateTime.now();
  debugPrint("Generate random data: ${after.difference(before).inMilliseconds} ms");

  for (var _ in List.generate(iterations, (index) => index)) {
    debugPrint("Encrypt data...");
    before = DateTime.now();
    Uint8List? encrypted = await _nativeCryptoPlatform.encrypt(data, secretKey!, "aes");
    after = DateTime.now();
    debugPrint("Encrypt data: ${after.difference(before).inMilliseconds} ms");
    totalEnc += after.difference(before).inMilliseconds;

    debugPrint("Decrypt data...");
    before = DateTime.now();
    data = (await _nativeCryptoPlatform.decrypt(encrypted!, secretKey, "aes"))!;
    after = DateTime.now();
    debugPrint("Decrypt data: ${after.difference(before).inMilliseconds} ms");
    totalDec += after.difference(before).inMilliseconds;
  }

  debugPrint("Average Encrypt: ${totalEnc/iterations} ms for $size MB");
  debugPrint("Average Decrypt: ${totalDec/iterations} ms for $size MB");
  
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    run();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: const Center(
        child: Text("Check the console"),
      ),
    );
  }
}
