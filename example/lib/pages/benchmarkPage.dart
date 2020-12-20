// Copyright (c) 2020
// Author: Hugo Pointcheval
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:native_crypto/native_crypto.dart';

import '../session.dart';
import '../widgets/button.dart';
import '../widgets/output.dart';

class BenchmarkPage extends StatefulWidget {
  const BenchmarkPage({key}) : super(key: key);

  @override
  _BenchmarkPageState createState() => _BenchmarkPageState();
}

class _BenchmarkPageState extends State<BenchmarkPage> {
  final Output keyContent = Output(
    textEditingController: TextEditingController(),
  );
  final Output benchmarkStatus = Output(
    textEditingController: TextEditingController(),
    large: true,
  );

  Future<void> _benchmark() async {
    if (Session.secretKey == null || Session.secretKey.isEmpty) {
      benchmarkStatus
          .print('No SecretKey!\nGo in Key tab and generate or derive one.');
      return;
    } else if (!Session.aesCipher.isInitialized) {
      benchmarkStatus.print(
          'Cipher not initialized!\nGo in Key tab and generate or derive one.');
      return;
    }

    benchmarkStatus.print("Benchmark 1/5/10/25/50MB\n");
    List<int> testedSizes = [1, 5, 10, 25, 50];

    var beforeBench = DateTime.now();
    for (int size in testedSizes) {
      var bigFile = Uint8List(size * 1000000);
      var before = DateTime.now();
      var encryptedBigFile = await Session.aesCipher.encrypt(bigFile);
      var after = DateTime.now();
      var benchmark =
          after.millisecondsSinceEpoch - before.millisecondsSinceEpoch;
      benchmarkStatus.append('[$size MB] Encryption took $benchmark ms\n');
      before = DateTime.now();
      await Session.aesCipher.decrypt(encryptedBigFile);
      after = DateTime.now();
      benchmark = after.millisecondsSinceEpoch - before.millisecondsSinceEpoch;
      benchmarkStatus.append('[$size MB] Decryption took $benchmark ms\n\n');
    }
    var afterBench = DateTime.now();
    var benchmark =
        afterBench.millisecondsSinceEpoch - beforeBench.millisecondsSinceEpoch;
    var sum = testedSizes.reduce((a, b) => a + b);
    benchmarkStatus.append(
        'Benchmark finished.\nGenerated, encrypted and decrypted $sum MB in $benchmark ms');
  }

  void _clear() {
    benchmarkStatus.clear();
  }

  @override
  void initState() {
    super.initState();
    if (Session.secretKey != null) {
      keyContent.print(Session.secretKey.encoded.toString());
      Session.aesCipher = AESCipher(
        Session.secretKey,
        CipherParameters(
          BlockCipherMode.CBC,
          PlainTextPadding.PKCS5,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              child: Text("Secret Key"),
              alignment: Alignment.centerLeft,
            ),
            keyContent,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Button(
                  onPressed: _benchmark,
                  label: "Launch benchmark",
                ),
                Button(
                  onPressed: _clear,
                  label: "Clear",
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
