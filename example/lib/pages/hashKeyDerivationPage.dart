// Copyright (c) 2020
// Author: Hugo Pointcheval
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:native_crypto/native_crypto.dart';

import '../session.dart';
import '../utils.dart';
import '../widgets/button.dart';
import '../widgets/output.dart';

class HashKeyDerivationPage extends StatefulWidget {
  const HashKeyDerivationPage({key}) : super(key: key);

  @override
  _HashKeyDerivationPageState createState() => _HashKeyDerivationPageState();
}

class _HashKeyDerivationPageState extends State<HashKeyDerivationPage> {
  final Output keyContent = Output(
    textEditingController: TextEditingController(),
  );
  final Output keyStatus = Output(
    textEditingController: TextEditingController(),
  );
  final Output keyExport = Output(
    textEditingController: TextEditingController(),
    large: true,
    editable: true,
  );
  final Output pbkdf2Status = Output(
    textEditingController: TextEditingController(),
  );
  final Output hashStatus = Output(
    textEditingController: TextEditingController(),
  );

  final TextEditingController _pwdTextController = TextEditingController();
  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _keyTextController = TextEditingController();

  void _generate() async {
    try {
      Session.secretKey = await SecretKey.generate(256, CipherAlgorithm.AES);
      keyContent.print(Session.secretKey.encoded.toString());
      keyStatus.print(
          "Secret Key successfully generated.\nLength: ${Session.secretKey.encoded.length} bytes");
    } catch (e) {
      keyStatus.print(e.message);
    }
  }

  void _pbkdf2() async {
    final password = _pwdTextController.text.trim();

    if (password.isEmpty) {
      pbkdf2Status.print('Password is empty');
    } else {
      PBKDF2 _pbkdf2 =
          PBKDF2(keyLength: 32, iteration: 1000, hash: HashAlgorithm.SHA512);
      await _pbkdf2.derive(password: password, salt: 'salty');
      SecretKey key = _pbkdf2.key;
      pbkdf2Status.print('Key successfully derived.');
      Session.secretKey = key;
      keyContent.print(Session.secretKey.encoded.toString());
    }
  }

  void _export() async {
    if (Session.secretKey == null || Session.secretKey.isEmpty) {
      keyStatus
          .print('No SecretKey!\nGenerate or derive one before exporting!');
    } else {
      String key = TypeHelper.bytesToBase64(Session.secretKey.encoded);
      keyStatus.print('Key successfully exported');
      keyExport.print(key);
    }
  }

  void _import() async {
    final String key = keyExport.read();
    if (key.isEmpty) {
      keyStatus.print('Key import failed');
    } else {
      Uint8List keyBytes = TypeHelper.base64ToBytes(key);
      Session.secretKey =
          SecretKey.fromBytes(keyBytes, algorithm: CipherAlgorithm.AES);
      keyStatus.print('Key successfully imported');
      keyContent.print(Session.secretKey.encoded.toString());
    }
  }

  void _hash() async {
    final message = _messageTextController.text.trim();

    if (message.isEmpty) {
      hashStatus.print('Message is empty');
    } else {
      MessageDigest md = MessageDigest.getInstance("sha256");
      Uint8List hash = await md.digest(TypeHelper.stringToBytes(message));
      hashStatus.print('Message successfully hashed.\n' + hash.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    if (Session.secretKey != null) {
      keyContent.print(Session.secretKey.encoded.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pwdTextController.dispose();
    _messageTextController.dispose();
    _keyTextController.dispose();
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
            Button(
              onPressed: _generate,
              label: "Generate key",
            ),
            keyStatus,
            TextField(
              controller: _pwdTextController,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            Button(
              onPressed: _pbkdf2,
              label: "Apply PBKDF2",
            ),
            pbkdf2Status,
            TextField(
              controller: _messageTextController,
              decoration: InputDecoration(
                hintText: 'Message',
              ),
            ),
            Button(
              onPressed: _hash,
              label: "Hash",
            ),
            hashStatus,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Button(
                  onPressed: _export,
                  label: "Export key",
                ),
                Button(
                  onPressed: _import,
                  label: "Import key",
                ),
              ],
            ),
            keyExport
          ],
        ),
      ),
    );
  }
}
