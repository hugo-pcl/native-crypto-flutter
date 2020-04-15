// Copyright (c) 2020
// Author: Hugo Pointcheval
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:native_crypto/symmetrical_crypto.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final textController = TextEditingController();
  String _output = 'none';
  String _bench;

  AES aes = AES();
  Encrypted encrypted = Encrypted();
  Uint8List decryptedPayload;

  void _generateKey() async {
    await aes.init(KeySize.bits256);
    setState(() {
      _output = 'Key generated.';
    });
  }

  void _encrypt() async {
    final plainText = textController.text.trim();

    var output;
    if (plainText.isEmpty) {
      output = 'Entry is empty';
    } else {
      var stringToBytes = TypeHelper().stringToBytes(plainText);
      encrypted = await aes.encrypt(stringToBytes);
      output = 'String successfully encrypted.';
    }
    setState(() {
      _output = output;
    });
  }

  void _decrypt() async {
    var output;
    if (encrypted.cipherText == null || encrypted.cipherText.isEmpty) {
      output = 'Encrypt before decrypting!';
    } else {
      decryptedPayload = await aes.decrypt(encrypted);
      var bytesToString = TypeHelper().bytesToString(decryptedPayload);
      output = 'String successfully decrypted:\n\n$bytesToString';
    }
    setState(() {
      _output = output;
    });
  }

  Future<String> _benchmark(int megabytes) async {
    String output;
    var bigFile = Uint8List(megabytes * 1000000);

    var before = DateTime.now();
    var encryptedBigFile = await aes.encrypt(bigFile);
    var after = DateTime.now();

    var benchmark =
        after.millisecondsSinceEpoch - before.millisecondsSinceEpoch;

    output = '$megabytes MB\n\nAES Encryption:\n$benchmark ms\n\n';

    before = DateTime.now();
    await aes.decrypt(encryptedBigFile);
    after = DateTime.now();

    benchmark = after.millisecondsSinceEpoch - before.millisecondsSinceEpoch;

    output += 'AES Decryption:\n$benchmark ms\n\n\n';

    return output;
  }

  void _testPerf({int megabytes}) async {
    var output = '';
    if (megabytes != null) {
      output = await _benchmark(megabytes);
      setState(() {
      _output = output;
    });
    } else {
      setState(() {
        _bench = 'Open the logcat!';
      });
      for (int i=1;i<100;i+=10) {
        var benchmark = await _benchmark(i);
        log(benchmark);
      }
    }
    
  }

  @override
  void initState() {
    // Generate AES instance on init.
    _generateKey();
    super.initState();
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Native Crypto'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
            child: Center(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Text to encrypt.',
                    ),
                  ),
                  SizedBox(height: 20),
                  FlatButton(
                      onPressed: _encrypt,
                      color: Colors.blue,
                      child: Text(
                        'Encrypt String',
                        style: TextStyle(color: Colors.white),
                      )),
                  (encrypted.cipherText != null && encrypted.cipherText.isNotEmpty)
                      ? Text(encrypted.cipherText.toString())
                      : Container(),
                  FlatButton(
                      onPressed: _decrypt,
                      color: Colors.blue,
                      child: Text(
                        'Decrypt String',
                        style: TextStyle(color: Colors.white),
                      )),
                  SizedBox(height: 20),
                  // Output
                  Text(
                    _output,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  FlatButton(
                      onPressed: () {
                        _testPerf(megabytes: 1);
                      },
                      color: Colors.blue,
                      child: Text(
                        'Benchmark 1 MB',
                        style: TextStyle(color: Colors.white),
                      )),
                  FlatButton(
                      onPressed: () {
                        _testPerf(megabytes: 10);
                      },
                      color: Colors.blue,
                      child: Text(
                        'Benchmark 10 MB',
                        style: TextStyle(color: Colors.white),
                      )),
                  FlatButton(
                      onPressed: () {
                        _testPerf(megabytes: 50);
                      },
                      color: Colors.blue,
                      child: Text(
                        'Benchmark 50 MB',
                        style: TextStyle(color: Colors.white),
                      )),
                  SizedBox(height: 20),
                  FlatButton(
                      onPressed: () {
                        _testPerf();
                      },
                      color: Colors.blue,
                      child: Text(
                        'Full benchmark',
                        style: TextStyle(color: Colors.white),
                      )),

                  (_bench != null && _bench.isNotEmpty)
                      ? Text(_bench)
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Contains some useful functions.
class TypeHelper {
  /// Returns bytes `Uint8List` from a `String`.
  Uint8List stringToBytes(String source) {
    var list = source.codeUnits;
    var bytes = Uint8List.fromList(list);
    return bytes;
  }

  /// Returns a `String` from bytes `Uint8List`.
  String bytesToString(Uint8List bytes) {
    var string = String.fromCharCodes(bytes);
    return string;
  }
}
