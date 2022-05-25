// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: benchmark_page.dart
// Created Date: 28/12/2021 15:12:39
// Last Modified: 25/05/2022 17:16:12
// -----
// Copyright (c) 2021

import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto_example/pointycastle/aes_gcm.dart';
import 'package:native_crypto_example/widgets/button.dart';

import '../session.dart';
import '../widgets/output.dart';

class BenchmarkPage extends ConsumerWidget {
  BenchmarkPage({Key? key}) : super(key: key);

  final Output keyContent = Output();
  final Output benchmarkStatus = Output(large: true);

  Future<void> _benchmark(
    WidgetRef ref,
    Cipher cipher, {
    bool usePc = false,
    bool encryptionOnly = false,
  }) async {
    Session state = ref.read(sessionProvider.state).state;
    AesGcm pc = AesGcm();

    if (state.secretKey.bytes.isEmpty) {
      benchmarkStatus
          .print('No SecretKey!\nGo in Key tab and generate or derive one.');
      return;
    }

    List<int> testedSizes = [2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50];
    int multiplier = pow(2, 20).toInt(); // MiB

    benchmarkStatus.print("[Benchmark] Sizes: ${testedSizes.join('/')}MiB\n");
    benchmarkStatus.appendln(
        "[Benchmark] Engine: " + (usePc ? " PointyCastle" : " NativeCrypto"));
    benchmarkStatus.appendln("[Benchmark] Test: " +
        (encryptionOnly ? " Encryption Only" : " Encryption & Decryption"));
    benchmarkStatus.appendln(
        '[Benchmark] bytesCountPerChunk: ${Cipher.bytesCountPerChunk} bytes/chunk');

    String csv = encryptionOnly
        ? "Run;Size (B);Encryption Time (ms)\n"
        : "Run;Size (B);Encryption Time (ms);Decryption Time (ms)\n";

    int run = 0;
    var beforeBench = DateTime.now();

    for (int size in testedSizes) {
      run++;
      final StringBuffer csvLine = StringBuffer();
      final dummyBytes = Uint8List(size * multiplier);
      csvLine.write('$run;${size * multiplier};');

      // Encryption
      Object encryptedBigFile;
      var before = DateTime.now();
      if (usePc) {
        encryptedBigFile = pc.encrypt(dummyBytes, state.secretKey.bytes);
      } else {
        encryptedBigFile = await cipher.encrypt(dummyBytes);
      }
      var after = DateTime.now();

      var benchmark =
          after.millisecondsSinceEpoch - before.millisecondsSinceEpoch;
      benchmarkStatus
          .appendln('[Benchmark] ${size}MiB => Encryption took $benchmark ms');
      csvLine.write('$benchmark');

      if (!encryptionOnly) {
        // Decryption
        before = DateTime.now();
        if (usePc) {
          pc.decrypt(encryptedBigFile as Uint8List, state.secretKey.bytes);
        } else {
          await cipher.decrypt(encryptedBigFile as CipherText);
        }
        after = DateTime.now();
        benchmark =
            after.millisecondsSinceEpoch - before.millisecondsSinceEpoch;
        benchmarkStatus
            .appendln('[Benchmark] ${size}MiB => Decryption took $benchmark ms');
        csvLine.write(';$benchmark');
      }
      csv += csvLine.toString() + '\n';
    }
    var afterBench = DateTime.now();
    var benchmark =
        afterBench.millisecondsSinceEpoch - beforeBench.millisecondsSinceEpoch;
    var sum = testedSizes.reduce((a, b) => a + b);
    benchmarkStatus
        .appendln('[Benchmark] Finished: ${sum}MiB in $benchmark ms');
    benchmarkStatus.appendln('[Benchmark] Check the console for csv data');
    benchmarkStatus.appendln(csv);
    print(csv);
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
            Wrap(
              children: [
                Button(
                  () => _benchmark(ref, cipher),
                  "NativeCrypto",
                ),
                const SizedBox(width: 8),
                Button(
                  () => _benchmark(ref, cipher, usePc: true),
                  "PointyCastle",
                ),
                const SizedBox(width: 8),
                Button(
                  () => _benchmark(ref, cipher, encryptionOnly: true),
                  "NC Encryption Only",
                ),
                const SizedBox(width: 8),
                Button(
                  () => _benchmark(
                    ref,
                    cipher,
                    usePc: true,
                    encryptionOnly: true,
                  ),
                  "PC Encryption Only",
                ),
                const SizedBox(width: 8),
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
