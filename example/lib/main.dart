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

    final hardCodedIOSAESkey = Uint8List.fromList([126, 193, 178, 226, 223, 97, 231, 48, 181, 172, 41, 25, 243, 79, 104, 172, 180, 10, 241, 188, 40, 44, 242, 142, 217, 148, 47, 199, 17, 72, 243, 75]);

    final hardCodedIOSCipher = Uint8List.fromList([62, 66, 70, 151, 117, 25, 153, 74, 76, 59, 216, 186, 125, 121, 23, 103, 226, 239, 79, 177, 252, 237, 41, 195, 176, 128, 137, 89, 97, 140, 206, 53, 88, 144, 5, 41, 197, 87, 25, 127, 237, 190, 23, 152, 89, 95, 2, 66, 50, 179, 12, 207, 86, 159, 155, 35, 72, 143, 133, 9, 148, 91, 240, 195]);

    final hardCodedIOSIv = Uint8List.fromList([42, 53, 43, 236, 4, 149, 16, 114, 130, 244, 94, 75, 63, 196, 199, 231]);

    final hardCodedAndroidAESkey = Uint8List.fromList([163, 161, 49, 53, 13, 251, 12, 210, 46, 79, 148, 162, 134, 124, 236, 233, 18, 245, 48, 8, 81, 158, 94, 192, 248, 10, 254, 139, 198, 163, 41, 99]);

    final hardCodedAndroidCipher = Uint8List.fromList([175, 223, 113, 228, 201, 163, 195, 52, 191, 75, 216, 148, 81, 38, 56, 70, 36, 73, 113, 61, 64, 89, 135, 49, 121, 46, 240, 9, 47, 209, 90, 66, 168, 100, 214, 80, 137, 247, 218, 146, 185, 62, 39, 15, 250, 45, 75, 142, 148, 238, 156, 154, 52, 12, 134, 149, 252, 214, 25, 205, 121, 204, 7, 193]);
    
    final hardCodedAndroidIV = Uint8List.fromList([39, 192, 131, 12, 181, 252, 191, 178, 138, 135, 125, 251, 53, 162, 70, 99]);

    // Test payload with some hardcoded values
    aeskey = hardCodedAndroidAESkey;
    encryptedPayload = [hardCodedAndroidCipher, hardCodedAndroidIV];

    var output;
    if (encryptedPayload == null || encryptedPayload.isEmpty) {
      output = 'Encrypt before.';
    } else {
      decryptedPayload = await NativeCrypto().symDecrypt(encryptedPayload, aeskey);
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
                    onPressed: encrypt,
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
