// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: benchmark_page.dart
// Created Date: 28/12/2021 15:12:39
// Last Modified: 28/12/2021 17:01:41
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto_example/widgets/button.dart';

import '../session.dart';
import '../widgets/output.dart';

class BenchmarkPage extends ConsumerWidget {
  BenchmarkPage({Key? key}) : super(key: key);

  final Output keyContent = Output();
  final Output benchmarkStatus = Output(large: true);

  Future<void> _test(WidgetRef ref, Cipher cipher) async {
    Session state = ref.read(sessionProvider.state).state;

    if (state.secretKey.bytes.isEmpty) {
      benchmarkStatus
          .print('No SecretKey!\nGo in Key tab and generate or derive one.');
      return;
    }

    int size = 64;
    benchmarkStatus.print("Benchmark Test\n");

    // Encryption
    var before = DateTime.now();
    var encryptedBigFile = await cipher.encrypt(Uint8List(size * 1000000));
    var after = DateTime.now();
    var benchmark =
        after.millisecondsSinceEpoch - before.millisecondsSinceEpoch;
    benchmarkStatus.append('[$size MB] Encryption took $benchmark ms\n');

    // Decryption
    var befored = DateTime.now();
    await cipher.decrypt(encryptedBigFile);
    var afterd = DateTime.now();
    var benchmarkd =
        afterd.millisecondsSinceEpoch - befored.millisecondsSinceEpoch;
    benchmarkStatus.append('[$size MB] Decryption took $benchmarkd ms\n');
  }

  Future<void> _benchmark(WidgetRef ref, Cipher cipher) async {
    Session state = ref.read(sessionProvider.state).state;

    if (state.secretKey.bytes.isEmpty) {
      benchmarkStatus
          .print('No SecretKey!\nGo in Key tab and generate or derive one.');
      return;
    }

    benchmarkStatus.print("Benchmark 2/4/8/16/32/64/128/256MB\n");
    List<int> testedSizes = [2, 4, 8, 16, 32, 64, 128, 256];
    String csv =
        "size;encryption time;encode time;decryption time;crypto time\n";

    var beforeBench = DateTime.now();
    for (int size in testedSizes) {
      var b = ByteData(size * 1000000);
      //var bigFile = Uint8List.view();
      csv += "${size * 1000000};";
      var cryptoTime = 0;

      // Encryption
      var before = DateTime.now();
      var encryptedBigFile = await cipher.encrypt(b.buffer.asUint8List());
      var after = DateTime.now();

      var benchmark =
          after.millisecondsSinceEpoch - before.millisecondsSinceEpoch;
      benchmarkStatus.append('[$size MB] Encryption took $benchmark ms\n');

      csv += "$benchmark;";
      cryptoTime += benchmark;

      // Decryption
      before = DateTime.now();
      await cipher.decrypt(encryptedBigFile);
      after = DateTime.now();

      benchmark = after.millisecondsSinceEpoch - before.millisecondsSinceEpoch;
      benchmarkStatus.append('[$size MB] Decryption took $benchmark ms\n');

      csv += "$benchmark;";
      cryptoTime += benchmark;
      csv += "$cryptoTime\n";
    }
    var afterBench = DateTime.now();
    var benchmark =
        afterBench.millisecondsSinceEpoch - beforeBench.millisecondsSinceEpoch;
    var sum = testedSizes.reduce((a, b) => a + b);
    benchmarkStatus.append(
        'Benchmark finished.\nGenerated, encrypted and decrypted $sum MB in $benchmark ms');
    debugPrint("[Benchmark cvs]\n$csv");
  }

  void _clear() {
    benchmarkStatus.clear();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Session state = ref.read(sessionProvider.state).state;
    if (state.secretKey.bytes.isEmpty) {
      keyContent
          .print('No SecretKey!\nGo in Key tab and generate or derive one.');
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Align(
                child: Text("Secret Key"),
                alignment: Alignment.centerLeft,
              ),
              keyContent,
            ],
          ),
        ),
      );
    }
    keyContent.print(state.secretKey.bytes.toString());

    AES cipher = AES(state.secretKey, AESMode.gcm);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Align(
              child: Text("Secret Key"),
              alignment: Alignment.centerLeft,
            ),
            keyContent,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Button(
                  () => _benchmark(ref, cipher),
                  "Launch benchmark",
                ),
                Button(
                  () => _test(ref, cipher),
                  "Test benchmark",
                ),
                Button(
                  _clear,
                  "Clear",
                ),
              ],
            ),
            benchmarkStatus,
          ],
        ),
      ),
    );
  }
}
