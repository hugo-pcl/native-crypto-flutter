// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'aes_cubit.dart';

@immutable
class AESState {
  const AESState(
    this.state,
    this.plainText,
    this.cipherText,
    this.plainTextFile,
    this.cipherTextFile,
    this.error,
  );

  const AESState.initial()
      : state = State.initial,
        plainText = null,
        plainTextFile = null,
        cipherText = null,
        cipherTextFile = null,
        error = null;

  final State state;
  final Uint8List? plainText;
  final Uint8List? cipherText;
  final String? plainTextFile;
  final String? cipherTextFile;
  final String? error;

  AESState copyWith({
    State? state,
    Uint8List? plainText,
    Uint8List? cipherText,
    String? plainTextFile,
    String? cipherTextFile,
    String? error,
  }) =>
      AESState(
        state ?? this.state,
        plainText ?? this.plainText,
        cipherText ?? this.cipherText,
        plainTextFile ?? this.plainTextFile,
        cipherTextFile ?? this.cipherTextFile,
        error ?? this.error,
      );
}
