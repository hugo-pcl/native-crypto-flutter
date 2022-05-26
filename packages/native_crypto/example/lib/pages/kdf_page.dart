// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: kdf_page.dart
// Created Date: 28/12/2021 13:40:34
// Last Modified: 26/05/2022 20:30:31
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto/native_crypto_ext.dart';
import 'package:native_crypto_example/widgets/button.dart';

import '../session.dart';
import '../widgets/output.dart';

class KdfPage extends ConsumerWidget {
  KdfPage({Key? key}) : super(key: key);

  final Output keyContent = Output();
  final Output keyStatus = Output();
  final Output pbkdf2Status = Output();
  final Output hashStatus = Output(large: true);

  final TextEditingController _pwdTextController = TextEditingController()..text = 'Password';
  final TextEditingController _messageTextController = TextEditingController()..text = 'Message';

  Future<void> _generate(WidgetRef ref) async {
    Session state = ref.read(sessionProvider.state).state;
    try {
      SecretKey sk = await SecretKey.fromSecureRandom(256);
      state.setKey(sk);
      keyStatus.print(
          "SecretKey successfully generated.\nLength: ${state.secretKey.bytes.length} bytes");
      keyContent.print(state.secretKey.bytes.toString());
      debugPrint("As hex :\n${sk.base16}");
    } catch (e) {
      keyStatus.print(e.toString());
    }
  }

  Future<void> _pbkdf2(WidgetRef ref) async {
    Session state = ref.read(sessionProvider.state).state;
    final password = _pwdTextController.text.trim();

    if (password.isEmpty) {
      pbkdf2Status.print('Password is empty');
    } else {
      Pbkdf2 _pbkdf2 = Pbkdf2(32, 1000, algorithm: HashAlgorithm.sha512);
      SecretKey sk = await _pbkdf2.derive(password: password, salt: 'salt');
      state.setKey(sk);
      pbkdf2Status.print('Key successfully derived.');
      keyContent.print(state.secretKey.bytes.toString());
      debugPrint("As hex :\n${sk.base16}");
    }
  }

  Future<void> _hash(HashAlgorithm hasher) async {
    final message = _messageTextController.text.trim();
    if (message.isEmpty) {
      hashStatus.print('Message is empty');
    } else {
      Uint8List hash = await hasher.digest(message.toBytes());
      hashStatus.print(
          'Message successfully hashed with $hasher :${hash.toStr(to: Encoding.base16)}');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Align(
              child: Text("SecretKey"),
              alignment: Alignment.centerLeft,
            ),
            keyContent,
            Button(
              () => _generate(ref),
              "Generate SecretKey",
            ),
            keyStatus,
            TextField(
              controller: _pwdTextController,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            Button(
              () => _pbkdf2(ref),
              "Apply PBKDF2",
            ),
            pbkdf2Status,
            TextField(
              controller: _messageTextController,
              decoration: const InputDecoration(
                hintText: 'Message',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Button(
                  () => _hash(HashAlgorithm.sha256),
                  "SHA256",
                ),
                Button(
                  () => _hash(HashAlgorithm.sha384),
                  "SHA384",
                ),
                Button(
                  () => _hash(HashAlgorithm.sha512),
                  "SHA512",
                ),
              ],
            ),
            hashStatus,
          ],
        ),
      ),
    );
  }
}
