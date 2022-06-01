// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: decryption_builder.dart
// Created Date: 26/05/2022 19:07:52
// Last Modified: 26/05/2022 19:21:00
// -----
// Copyright (c) 2022

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:native_crypto/src/core/cipher_text_wrapper.dart';
import 'package:native_crypto/src/interfaces/cipher.dart';

class DecryptionBuilder extends StatelessWidget {
  final Cipher cipher;
  final CipherTextWrapper data;
  final Widget Function(BuildContext context) onLoading;
  final Widget Function(BuildContext context, Object error) onError;
  final Widget Function(BuildContext context, Uint8List plainText) onSuccess;

  const DecryptionBuilder({
    super.key,
    required this.cipher,
    required this.data,
    required this.onLoading,
    required this.onError,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: cipher.decrypt(data),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return onSuccess(context, snapshot.data!);
        } else if (snapshot.hasError) {
          return onError(context, snapshot.error!);
        }
        return onLoading(context);
      },
    );
  }
}
