// Copyright (c) 2020
// Author: Hugo Pointcheval
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
  String _inputRawCoded = 'Message à chiffrer WOW';
  String _decryptedString = 'none';
  Uint8List aeskey;
  List<Uint8List> encryptedPayload;
  Uint8List decryptedPayload;

  void generateKey() async {
    aeskey = await NativeCrypto().sumKeygen();
    setState(() {
      _decryptedString = 'Key generated.';
    });
  }

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

  void encrypt() async {
    final plainText = _inputRawCoded;

    var output;
    if (plainText.isEmpty) {
      output = 'Entry is empty';
    } else {
      encryptedPayload = await NativeCrypto().symEncrypt(stringToBytes(plainText), aeskey);
      output = 'String successfully encrypted.';
    }
    setState(() {
      _decryptedString = output;
    });
  }

  void decrypt() async {

    final hardCodedAESkey = Uint8List.fromList([29, 4, 177, 73, 96, 186, 180, 218, 158, 84, 106, 158, 254, 34, 255, 5, 93, 213, 196, 102, 251, 70, 189, 184, 246, 170, 227, 143, 112, 168, 182, 65]);

    final hardCodedIOSCipher = Uint8List.fromList([31, 108, 97, 95, 23, 144, 222, 197, 157, 201, 161, 18, 1, 133, 110, 158, 132, 29, 104, 71, 72, 191, 67, 224, 88, 2, 63, 110, 92, 41, 190, 228]);

    final hardCodedIOSIv = Uint8List.fromList([145, 239, 253, 138, 83, 126, 213, 108, 42, 172, 200, 230, 243, 204, 121, 35]);

    // Test payload with some hardcoded values
    encryptedPayload = [hardCodedIOSCipher, hardCodedIOSIv];    

    var output;
    if (encryptedPayload == null || encryptedPayload.isEmpty) {
      output = 'Encrypt before.';
    } else {
      decryptedPayload = await NativeCrypto().symDecrypt(encryptedPayload, hardCodedAESkey);
      output = 'String successfully Decrypted:\n${bytesToString(decryptedPayload)}';
    }
    setState(() {
      _decryptedString = output;
    });
  }

  @override
  void initState() {
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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Crypto'),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
          child: Center(
            child: Column(
              children: <Widget>[
                Text(_inputRawCoded),
                SizedBox(height: 20),
                FlatButton(
                    onPressed: null,
                    color: Colors.blue,
                    child: Text(
                      'Encrypt',
                      style: TextStyle(color: Colors.white),
                    )),
                (encryptedPayload != null && encryptedPayload.isNotEmpty)
                ? Text(encryptedPayload.first.toList().toString())
                : Container(),
                FlatButton(
                    onPressed: decrypt,
                    color: Colors.blue,
                    child: Text(
                      'Decrypt',
                      style: TextStyle(color: Colors.white),
                    )),
                (decryptedPayload != null && decryptedPayload.isNotEmpty)
                ? Text(decryptedPayload.toList().toString())
                : Container(),
                SizedBox(height: 20),
                Text(_decryptedString),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
