// Copyright (c) 2020
// Author: Hugo Pointcheval
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:native_crypto/native_crypto.dart';

import '../session.dart';
import '../utils.dart';
import '../widgets/button.dart';
import '../widgets/output.dart';

class CipherPage extends StatefulWidget {
  const CipherPage({key}) : super(key: key);

  @override
  _CipherPageState createState() => _CipherPageState();
}

class _CipherPageState extends State<CipherPage> {
  final Output keyContent = Output(
    textEditingController: TextEditingController(),
  );
  final Output encryptionStatus = Output(
    textEditingController: TextEditingController(),
  );
  final Output decryptionStatus = Output(
    textEditingController: TextEditingController(),
  );
  final Output cipherExport = Output(
    textEditingController: TextEditingController(),
    large: true,
    editable: true,
  );

  final TextEditingController _plainTextController = TextEditingController();
  CipherText cipherText;

  void _encrypt() async {
    final plainText = _plainTextController.text.trim();

    if (Session.secretKey == null || Session.secretKey.isEmpty) {
      encryptionStatus
          .print('No SecretKey!\nGo in Key tab and generate or derive one.');
    } else if (!Session.aesCipher.isInitialized) {
      encryptionStatus.print(
          'Cipher not initialized!\nGo in Key tab and generate or derive one.');
    } else if (plainText.isEmpty) {
      encryptionStatus.print('Entry is empty');
    } else {
      var stringToBytes = TypeHelper.stringToBytes(plainText);
      cipherText = await Session.aesCipher.encrypt(stringToBytes);
      encryptionStatus.print('String successfully encrypted.\n');
      encryptionStatus.append("IV: " +
          cipherText.iv.toString() +
          "\nCipherText: " +
          cipherText.bytes.toString());
    }
  }

  void _alter() async {
    if (cipherText == null || cipherText.bytes.isEmpty) {
      decryptionStatus.print('Encrypt before altering CipherText!');
    } else {
      // Add 1 to the first byte
      Uint8List _altered = cipherText.bytes;
      _altered[0] += 1;
      // Recreate cipher text with altered data
      cipherText = AESCipherText(_altered, cipherText.iv);
      encryptionStatus.print('String successfully encrypted.\n');
      encryptionStatus.append("IV: " +
          cipherText.iv.toString() +
          "\nCipherText: " +
          cipherText.bytes.toString());
      decryptionStatus.print('CipherText altered!\nDecryption will fail.');
    }
  }

  void _decrypt() async {
    if (Session.secretKey == null || Session.secretKey.isEmpty) {
      decryptionStatus
          .print('No SecretKey!\nGo in Key tab and generate or derive one.');
    } else if (!Session.aesCipher.isInitialized) {
      decryptionStatus.print(
          'Cipher not initialized!\nGo in Key tab and generate or derive one.');
    } else if (cipherText == null || cipherText.bytes.isEmpty) {
      decryptionStatus.print('Encrypt before decrypting!');
    } else {
      try {
        Uint8List plainText = await Session.aesCipher.decrypt(cipherText);
        var bytesToString = TypeHelper.bytesToString(plainText);
        decryptionStatus
            .print('String successfully decrypted:\n\n$bytesToString');
      } on DecryptionException catch (e) {
        decryptionStatus.print(e.message);
      }
    }
  }

  void _export() async {
    if (cipherText == null) {
      decryptionStatus.print('Encrypt data before export!');
    } else {
      Uint8List payload = Uint8List.fromList(cipherText.iv + cipherText.bytes);
      String data = TypeHelper.bytesToBase64(payload);
      decryptionStatus.print('CipherText successfully exported');
      cipherExport.print(data);
    }
  }

  void _import() async {
    final String data = cipherExport.read();
    if (data.isEmpty) {
      encryptionStatus.print('CipherText import failed');
    } else {
      Uint8List payload = TypeHelper.base64ToBytes(data);
      Uint8List iv = payload.sublist(0, 16);
      Uint8List bytes = payload.sublist(16);
      cipherText = AESCipherText(bytes, iv);
      encryptionStatus.print('CipherText successfully imported\n');
      encryptionStatus.append("IV: " +
          cipherText.iv.toString() +
          "\nCipherText: " +
          cipherText.bytes.toString());
    }
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
  void dispose() {
    super.dispose();
    _plainTextController.dispose();
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
            TextField(
              controller: _plainTextController,
              decoration: InputDecoration(
                hintText: 'Plain text',
              ),
            ),
            Button(
              onPressed: _encrypt,
              label: "Encrypt",
            ),
            encryptionStatus,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Button(
                  onPressed: _alter,
                  label: "Alter cipher",
                ),
                Button(
                  onPressed: _decrypt,
                  label: "Decrypt",
                ),
              ],
            ),
            decryptionStatus,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Button(
                  onPressed: _export,
                  label: "Export cipher",
                ),
                Button(
                  onPressed: _import,
                  label: "Import cipher",
                ),
              ],
            ),
            cipherExport
          ],
        ),
      ),
    );
  }
}
