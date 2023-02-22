// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:native_crypto/src/core/utils/cipher_text.dart';

import 'package:native_crypto/src/domain/cipher.dart';
import 'package:native_crypto/src/domain/cipher_chunk.dart';

/// {@template encryption_builder}
/// A [StatelessWidget] that builds a [FutureBuilder] that will
/// encrypt a [Uint8List] using a [Cipher].
/// {@endtemplate}
class EncryptionBuilder<T extends CipherChunk> extends StatelessWidget {
  /// {@macro encryption_builder}
  const EncryptionBuilder({
    required this.cipher,
    required this.plainText,
    required this.onLoading,
    required this.onError,
    required this.onSuccess,
    super.key,
  });

  /// The [Cipher] that will be used to encrypt the [Uint8List].
  final Cipher<T> cipher;

  /// The [Uint8List] that will be encrypted.
  final Uint8List plainText;

  /// The [Widget] that will be displayed while the [Uint8List] is being
  /// encrypted.
  final Widget Function(BuildContext context) onLoading;

  /// The [Widget] that will be displayed if an error occurs while encrypting
  /// the [Uint8List].
  final Widget Function(BuildContext context, Object error) onError;

  /// The [Widget] that will be displayed once the [Uint8List] has been
  /// encrypted.
  final Widget Function(BuildContext context, CipherText<T> cipherText)
      onSuccess;

  @override
  Widget build(BuildContext context) => FutureBuilder<CipherText<T>>(
        future: cipher.encrypt(plainText),
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
