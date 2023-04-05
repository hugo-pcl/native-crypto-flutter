// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:native_crypto/native_crypto.dart';
import 'package:wyatt_architecture/wyatt_architecture.dart';

abstract class CryptoDataSource extends BaseDataSource {
  Future<SecretKey> generateSecureRandom(int length);
  Future<SecretKey> deriveKeyFromPassword(
    String password, {
    required String salt,
  });
  Future<Uint8List> encrypt(Uint8List data, SecretKey key);
  Future<void> encryptFile(
    File plainText,
    Uri folderResult,
    SecretKey key,
  );
  Future<Uint8List> encryptWithIV(
    Uint8List data,
    SecretKey key,
    Uint8List iv,
  );
  Future<Uint8List> decrypt(Uint8List data, SecretKey key);
  Future<void> decryptFile(
    File cipherText,
    Uri folderResult,
    SecretKey key,
  );
  Future<Uint8List> hash(Hash hasher, Uint8List data);
  Future<Uint8List> hmac(Hmac hmac, Uint8List data, SecretKey key);
}
