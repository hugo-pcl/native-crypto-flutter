// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: implementation_imports

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto_example/domain/data_sources/crypto_data_source.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';

class PointyCastleDataSourceImpl extends CryptoDataSource {
  FortunaRandom? _secureRandom;

  @override
  Future<Uint8List> decrypt(Uint8List data, SecretKey key) async {
    final iv = Uint8List.fromList(data.sublist(0, 12));
    final cipherTextWithoutIv = Uint8List.fromList(
      data.sublist(12),
    );

    final gcm = GCMBlockCipher(AESEngine())
      ..init(
        false,
        AEADParameters(
          KeyParameter(key.bytes),
          16 * 8,
          iv,
          Uint8List(0),
        ),
      );
    final paddedPlainText = gcm.process(cipherTextWithoutIv);

    return paddedPlainText;
  }

  @override
  Future<void> decryptFile(
    File cipherText,
    Uri folderResult,
    SecretKey key,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<SecretKey> deriveKeyFromPassword(
    String password, {
    required String salt,
  }) async {
    final derivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(
        Pbkdf2Parameters(salt.toBytes(), 1000, 32),
      );

    final Uint8List sk = derivator.process(password.toBytes());

    return SecretKey(sk);
  }

  @override
  Future<Uint8List> hash(Hash hasher, Uint8List data) async {
    final Digest? digest;

    switch (hasher.runtimeType) {
      case Sha256:
        digest = SHA256Digest();
        break;
      case Sha384:
        digest = SHA384Digest();
        break;
      case Sha512:
        digest = SHA512Digest();
        break;
      default:
        throw UnsupportedError(
          'Unsupported hash algorithm: ${hasher.runtimeType}',
        );
    }

    return digest.process(data);
  }

  @override
  Future<Uint8List> hmac(Hmac hmac, Uint8List data, SecretKey key) async {
    final HMac? digest;

    switch (hmac.runtimeType) {
      case HmacSha256:
        digest = HMac.withDigest(SHA256Digest());
        digest.init(KeyParameter(key.bytes));
        break;
      case Sha384:
        digest = HMac.withDigest(SHA384Digest());
        digest.init(KeyParameter(key.bytes));
        break;
      case Sha512:
        digest = HMac.withDigest(SHA512Digest());
        digest.init(KeyParameter(key.bytes));
        break;
      default:
        throw UnsupportedError(
          'Unsupported hmac algorithm: ${hmac.runtimeType}',
        );
    }

    return digest.process(data);
  }

  @override
  Future<Uint8List> encrypt(Uint8List data, SecretKey key) async {
    final iv = (await generateSecureRandom(12 * 8)).bytes;

    final gcm = GCMBlockCipher(AESEngine())
      ..init(
        true,
        AEADParameters(
          KeyParameter(key.bytes),
          16 * 8,
          iv,
          Uint8List(0),
        ),
      );

    final cipherText = gcm.process(data);

    return Uint8List.fromList(
      iv + cipherText,
    );
  }

  @override
  Future<Uint8List> encryptWithIV(
    Uint8List data,
    SecretKey key,
    Uint8List iv,
  ) async {
    final gcm = GCMBlockCipher(AESEngine())
      ..init(
        true,
        AEADParameters(
          KeyParameter(key.bytes),
          16 * 8,
          iv,
          Uint8List(0),
        ),
      );

    final cipherText = gcm.process(data);

    return Uint8List.fromList(
      iv + cipherText,
    );
  }

  @override
  Future<void> encryptFile(
    File plainText,
    Uri folderResult,
    SecretKey key,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<SecretKey> generateSecureRandom(int length) async {
    if (_secureRandom == null) {
      _secureRandom = FortunaRandom();
      _secureRandom!.seed(
        KeyParameter(Platform.instance.platformEntropySource().getBytes(32)),
      );
    }

    final sk = _secureRandom!.nextBytes(length);

    return SecretKey(sk);
  }
}
