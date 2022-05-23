// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: cipher_page.dart
// Created Date: 28/12/2021 13:33:15
// Last Modified: 28/12/2021 15:20:43
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto_example/widgets/button.dart';

import '../session.dart';
import '../utils.dart';
import '../widgets/output.dart';

// ignore: must_be_immutable
class CipherPage extends ConsumerWidget {
  CipherPage({Key? key}) : super(key: key);

  final Output keyContent = Output();
  final Output encryptionStatus = Output();
  final Output decryptionStatus = Output();

  final TextEditingController _plainTextController = TextEditingController();
  CipherText? cipherText;

  Future<void> _encrypt(WidgetRef ref, Cipher cipher) async {
    Session state = ref.read(sessionProvider.state).state;
    final plainText = _plainTextController.text.trim();

    if (state.secretKey.bytes.isEmpty) {
      encryptionStatus
          .print('No SecretKey!\nGo in Key tab and generate or derive one.');
    } else if (plainText.isEmpty) {
      encryptionStatus.print('Entry is empty');
    } else {
      var stringToBytes = plainText.toBytes();
      cipherText = await cipher.encrypt(stringToBytes);
      encryptionStatus.print('String successfully encrypted.\n');
      encryptionStatus.append("Nonce: " +
          cipherText!.iv.toString() +
          "\nData: " +
          cipherText!.data.toString() +
          "\nTag: " +
          cipherText!.tag.toString());
    }
  }

  Future<void> _alter() async {
    if (cipherText == null) {
      decryptionStatus.print('Encrypt before altering CipherText!');
    } else {
      // Add 1 to the first byte
      Uint8List _altered = cipherText!.data;
      _altered[0] += 1;
      // Recreate cipher text with altered data
      cipherText = CipherText(cipherText!.iv, _altered, cipherText!.tag);
      encryptionStatus.print('String successfully encrypted.\n');
      encryptionStatus.append("Nonce: " +
          cipherText!.iv.toString() +
          "\nData: " +
          cipherText!.data.toString() +
          "\nTag: " +
          cipherText!.tag.toString());
      decryptionStatus.print('CipherText altered!\nDecryption will fail.');
    }
  }

  void _decrypt(WidgetRef ref, Cipher cipher) async {
    Session state = ref.read(sessionProvider.state).state;

    if (state.secretKey.bytes.isEmpty) {
      decryptionStatus
          .print('No SecretKey!\nGo in Key tab and generate or derive one.');
    } else if (cipherText == null) {
      decryptionStatus.print('Encrypt before decrypting!');
    } else {
      try {
        Uint8List plainText = await cipher.decrypt(cipherText!);
        var bytesToString = plainText.toStr();
        decryptionStatus
            .print('String successfully decrypted:\n\n$bytesToString');
      } on DecryptionException catch (e) {
        decryptionStatus.print(e.message);
      }
    }
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
            TextField(
              controller: _plainTextController,
              decoration: const InputDecoration(
                hintText: 'Plain text',
              ),
            ),
            Button(
              () => _encrypt(ref, cipher),
              "Encrypt",
            ),
            encryptionStatus,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Button(
                  _alter,
                  "Alter cipher",
                ),
                Button(
                  () => _decrypt(ref, cipher),
                  "Decrypt",
                ),
              ],
            ),
            decryptionStatus,
          ],
        ),
      ),
    );
  }
}
