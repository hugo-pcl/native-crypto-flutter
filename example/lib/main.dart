// Copyright (c) 2020
// Author: Hugo Pointcheval
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:native_crypto/native_crypto.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final textController = TextEditingController();
  final pwdController = TextEditingController();

  String _output = 'none';
  String _bench;

  AESCipher aes;
  CipherText cipherText;
  Uint8List plainText;
  SecretKey key;

  void _generateKey() async {
    var output;
    try {
      aes = await AESCipher.generate(
        AESKeySize.bits256,
        CipherParameters(
          BlockCipherMode.CBC,
          PlainTextPadding.PKCS5,
        ),
      );
      output = 'Key generated. Length: ${aes.secretKey.encoded.length}';
    } catch (e) {
      print(e);
      output = e.message;
    }

    setState(() {
      _output = output;
    });
  }

  void _pbkdf2() async {
    final password = pwdController.text.trim();

    var output;
    if (password.isEmpty) {
      output = 'Password is empty';
    } else {
      PBKDF2 _pbkdf2 =
          PBKDF2(keyLength: 32, iteration: 1000, hash: HashAlgorithm.SHA512);
      await _pbkdf2.derive(password: password, salt: 'salty');
      key = _pbkdf2.key;
      output = 'Key successfully derived.';
    }
    setState(() {
      _output = output;
    });
  }

  void _encrypt() async {
    final plainText = textController.text.trim();

    var output;
    if (plainText.isEmpty) {
      output = 'Entry is empty';
    } else {
      var stringToBytes = TypeHelper().stringToBytes(plainText);
      cipherText = await aes.encrypt(stringToBytes);
      output = 'String successfully encrypted.';
    }
    setState(() {
      _output = output;
    });
  }

  void _alter() async {
    var output;
    if (cipherText == null || cipherText.bytes.isEmpty) {
      output = 'Encrypt before altering payload!';
    } else {
      // Add 1 to the first byte
      Uint8List _altered = cipherText.bytes;
      _altered[0] += 1;
      // Recreate cipher text with altered data
      cipherText = AESCipherText(_altered, cipherText.iv);
      output = 'Payload altered.';
    }
    setState(() {
      _output = output;
    });
  }

  void _decrypt() async {
    var output;
    if (cipherText == null || cipherText.bytes.isEmpty) {
      output = 'Encrypt before decrypting!';
    } else {
      try {
        plainText = await aes.decrypt(cipherText);
        var bytesToString = TypeHelper().bytesToString(plainText);
        output = 'String successfully decrypted:\n\n$bytesToString';
      } on DecryptionException catch (e) {
        output = e.message;
      }
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

    output = '$megabytes MB\nAES Encryption: $benchmark ms\n';

    before = DateTime.now();
    await aes.decrypt(encryptedBigFile);
    after = DateTime.now();

    benchmark = after.millisecondsSinceEpoch - before.millisecondsSinceEpoch;

    output += 'AES Decryption: $benchmark ms\n\n';

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
      for (int i = 1; i <= 50; i += 10) {
        var benchmark = await _benchmark(i);
        log(benchmark, name: 'fr.pointcheval.native_crypto');
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
    pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                    controller: pwdController,
                    decoration: InputDecoration(
                      hintText: 'Test password',
                    ),
                  ),
                  SizedBox(height: 20),
                  FlatButton(
                      onPressed: _pbkdf2,
                      color: Colors.blue,
                      child: Text(
                        'Pbkdf2',
                        style: TextStyle(color: Colors.white),
                      )),
                  SizedBox(height: 30),
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
                  FlatButton(
                      onPressed: _alter,
                      color: Colors.blue,
                      child: Text(
                        'Alter encrypted payload',
                        style: TextStyle(color: Colors.white),
                      )),
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
    var list = source.runes.toList();
    var bytes = Uint8List.fromList(list);
    return bytes;
  }

  /// Returns a `String` from bytes `Uint8List`.
  String bytesToString(Uint8List bytes) {
    var string = String.fromCharCodes(bytes);
    return string;
  }
}
