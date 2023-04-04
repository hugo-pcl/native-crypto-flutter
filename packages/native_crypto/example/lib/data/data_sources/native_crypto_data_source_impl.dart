// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart';
import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto_example/domain/data_sources/crypto_data_source.dart';

class NativeCryptoDataSourceImpl extends CryptoDataSource {
  @override
  Future<Uint8List> decrypt(Uint8List data, SecretKey key) async {
    final AES cipher = AES(
      key: key,
      mode: AESMode.gcm,
      padding: AESPadding.none,
    );
    final Uint8List plainText = await cipher.decrypt(
      CipherText(
        data,
        chunkFactory: (bytes) => AESCipherChunk(
          bytes,
          ivLength: cipher.mode.ivLength,
          tagLength: cipher.mode.tagLength,
        ),
      ),
    );

    return plainText;
  }

  @override
  Future<SecretKey> deriveKeyFromPassword(
    String password, {
    required String salt,
  }) async {
    final Pbkdf2 pbkdf2 = Pbkdf2(
      length: 32,
      iterations: 1000,
      salt: salt.toBytes(),
      hashAlgorithm: HashAlgorithm.sha256,
    );
    return pbkdf2(password: password);
  }

  @override
  Future<Uint8List> hash(Hash hasher, Uint8List data) async {
    final Uint8List digestMessage = await hasher.digest(data);

    return digestMessage;
  }

  @override
  Future<Uint8List> hmac(Hmac hmac, Uint8List data, SecretKey key) async {
    final Uint8List digestMessage = await hmac.digest(data, key);

    return digestMessage;
  }

  @override
  Future<Uint8List> encrypt(Uint8List data, SecretKey key) async {
    final AES cipher = AES(
      key: key,
      mode: AESMode.gcm,
      padding: AESPadding.none,
    );
    final CipherText<AESCipherChunk> cipherText = await cipher.encrypt(data);

    return cipherText.bytes;
  }

  @override
  Future<Uint8List> encryptWithIV(
    Uint8List data,
    SecretKey key,
    Uint8List iv,
  ) async {
    final AES cipher = AES(
      key: key,
      mode: AESMode.gcm,
      padding: AESPadding.none,
    );

    final AESCipherChunk chunk = await cipher.encryptWithIV(data, iv);
    final CipherText<AESCipherChunk> cipherText = CipherText.fromChunks(
      [chunk],
      chunkFactory: (bytes) => AESCipherChunk(
        bytes,
        ivLength: cipher.mode.ivLength,
        tagLength: cipher.mode.tagLength,
      ),
    );

    return cipherText.bytes;
  }

  @override
  Future<SecretKey> generateSecureRandom(int length) async {
    final SecretKey sk = await SecretKey.fromSecureRandom(length);

    return sk;
  }
}
