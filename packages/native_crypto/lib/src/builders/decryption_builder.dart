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

/// {@template decryption_builder}
/// A [StatelessWidget] that builds a [FutureBuilder] that will decrypt a
/// [CipherText] using a [Cipher].
/// {@endtemplate}
class DecryptionBuilder<T extends CipherChunk> extends StatelessWidget {
  /// {@macro decryption_builder}
  const DecryptionBuilder({
    required this.cipher,
    required this.cipherText,
    required this.onLoading,
    required this.onError,
    required this.onSuccess,
    super.key,
  });

  /// The [Cipher] that will be used to decrypt the [CipherText].
  final Cipher<T> cipher;

  /// The [CipherText] that will be decrypted.
  final CipherText<T> cipherText;

  /// The [Widget] that will be displayed while the [CipherText] is being
  /// decrypted.
  final Widget Function(BuildContext context) onLoading;

  /// The [Widget] that will be displayed if an error occurs while decrypting
  /// the [CipherText].
  final Widget Function(BuildContext context, Object error) onError;

  /// The [Widget] that will be displayed once the [CipherText] has been
  /// decrypted.
  final Widget Function(BuildContext context, Uint8List plainText) onSuccess;

  @override
  Widget build(BuildContext context) => FutureBuilder<Uint8List>(
        future: cipher.decrypt(cipherText),
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
