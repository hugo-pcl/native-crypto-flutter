// Copyright (c) 2020
// Author: Hugo Pointcheval
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:native_crypto/native_crypto.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final textController = TextEditingController();
  String _output = 'none';
  
  Uint8List aeskey;
  List<Uint8List> encryptedPayload;
  Uint8List decryptedPayload;

  void generateKey() async {
    aeskey = await NativeCrypto().symKeygen();
    setState(() {
      _output = 'Key generated.';
    });
  }

  void encrypt() async {
    final plainText = textController.text.trim();

    var output;
    if (plainText.isEmpty) {
      output = 'Entry is empty';
    } else {
      var stringToBytes = TypeHelper().stringToBytes(plainText);
      encryptedPayload = await NativeCrypto().symEncrypt(stringToBytes, aeskey);
      output = 'String successfully encrypted.';
    }
    setState(() {
      _output = output;
    });
  }

  void decrypt() async {

    var output;
    if (encryptedPayload == null || encryptedPayload.isEmpty) {
      output = 'Encrypt before decrypting!';
    } else {
      decryptedPayload = await NativeCrypto().symDecrypt(encryptedPayload, aeskey);
      output = 'String successfully decrypted:\n\n${TypeHelper().bytesToString(decryptedPayload)}';
    }
    setState(() {
      _output = output;
    });
  }

  void benchmark(int megabytes) async {

    var output;
    var bigFile = Uint8List(megabytes * 1000000);

    var before = DateTime.now();
    var encrypted = await NativeCrypto().symEncrypt(bigFile, aeskey);
    var after = DateTime.now();
    
    var benchmark = after.millisecondsSinceEpoch - before.millisecondsSinceEpoch;

    output = '$megabytes MB\n\nAES Encryption:\n$benchmark ms\n\n';

    before = DateTime.now();
    var decrypted = await NativeCrypto().symDecrypt(encrypted, aeskey);
    after = DateTime.now();

    print(listEquals(bigFile, decrypted));

    benchmark = after.millisecondsSinceEpoch - before.millisecondsSinceEpoch;

    output += 'AES Decryption:\n$benchmark ms';

    setState(() {
      _output = output;
    });

  }

  @override
  void initState() {
    // Generate AES key on init.
    generateKey();
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
        body: Padding(
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
                    onPressed: encrypt,
                    color: Colors.blue,
                    child: Text(
                      'Encrypt String',
                      style: TextStyle(color: Colors.white),
                    )),
                (encryptedPayload != null && encryptedPayload.isNotEmpty)
                ? Text(encryptedPayload.first.toList().toString())
                : Container(),
                FlatButton(
                    onPressed: decrypt,
                    color: Colors.blue,
                    child: Text(
                      'Decrypt String',
                      style: TextStyle(color: Colors.white),
                    )),
                SizedBox(height: 20),
                // Output
                Text(_output,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 20),
                FlatButton(
                    onPressed: () {benchmark(1);},
                    color: Colors.blue,
                    child: Text(
                      'Benchmark 1 MB',
                      style: TextStyle(color: Colors.white),
                    )),
                FlatButton(
                    onPressed: () {benchmark(10);},
                    color: Colors.blue,
                    child: Text(
                      'Benchmark 10 MB',
                      style: TextStyle(color: Colors.white),
                    )),
                FlatButton(
                    onPressed: () {benchmark(20);},
                    color: Colors.blue,
                    child: Text(
                      'Benchmark 20 MB',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
