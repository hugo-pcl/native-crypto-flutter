// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:native_crypto/native_crypto.dart';
import 'package:wyatt_architecture/wyatt_architecture.dart';

abstract class CryptoRepository extends BaseRepository {
  FutureOrResult<SecretKey> generateSecureRandom(int length);
  FutureOrResult<SecretKey> deriveKeyFromPassword(
    String password, {
    required String salt,
  });
  FutureOrResult<Uint8List> encrypt(Uint8List data, SecretKey key);
  FutureOrResult<void> encryptFile(
    File plainText,
    Uri folderResult,
    SecretKey key,
  );
  FutureOrResult<Uint8List> encryptWithIV(
    Uint8List data,
    SecretKey key,
    Uint8List iv,
  );
  FutureOrResult<Uint8List> decrypt(Uint8List data, SecretKey key);
  FutureOrResult<void> decryptFile(
    File cipherText,
    Uri folderResult,
    SecretKey key,
  );

  FutureOrResult<Uint8List> hash(Hash hasher, Uint8List data);
  FutureOrResult<Uint8List> hmac(Hmac hmac, Uint8List data, SecretKey key);
}
