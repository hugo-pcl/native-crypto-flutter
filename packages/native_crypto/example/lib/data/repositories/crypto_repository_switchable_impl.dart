// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:io';
import 'dart:typed_data';

import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto_example/domain/data_sources/crypto_data_source.dart';
import 'package:native_crypto_example/domain/entities/mode.dart';
import 'package:native_crypto_example/domain/repositories/crypto_repository.dart';
import 'package:wyatt_architecture/wyatt_architecture.dart';
import 'package:wyatt_type_utils/wyatt_type_utils.dart';

class CryptoRepositorySwitchableImpl extends CryptoRepository {
  CryptoRepositorySwitchableImpl({
    required this.nativeCryptoDataSource,
    required this.pointyCastleDataSource,
    required this.currentMode,
  });

  CryptoDataSource nativeCryptoDataSource;
  CryptoDataSource pointyCastleDataSource;
  Mode currentMode;

  set mode(Mode mode) {
    currentMode = mode;
  }

  CryptoDataSource get cryptoDataSource {
    if (currentMode is NativeCryptoMode) {
      return nativeCryptoDataSource;
    } else if (currentMode is PointyCastleMode) {
      return pointyCastleDataSource;
    } else {
      throw Exception('Unknown mode');
    }
  }

  @override
  FutureOrResult<Uint8List> decrypt(Uint8List data, SecretKey key) =>
      Result.tryCatchAsync(
        () async => cryptoDataSource.decrypt(data, key),
        (error) {
          if (error is NativeCryptoException) {
            return ClientException('${error.message}');
          }
          return ClientException(error.toString());
        },
      );

  @override
  FutureOrResult<void> decryptFile(
    File cipherText,
    Uri folderResult,
    SecretKey key,
  ) =>
      Result.tryCatchAsync(
        () async => cryptoDataSource.decryptFile(cipherText, folderResult, key),
        (error) {
          if (error is NativeCryptoException) {
            return ClientException('${error.message}');
          }
          return ClientException(error.toString());
        },
      );

  @override
  FutureOrResult<SecretKey> deriveKeyFromPassword(
    String password, {
    required String salt,
  }) =>
      Result.tryCatchAsync(
        () async => cryptoDataSource.deriveKeyFromPassword(
          password,
          salt: salt,
        ),
        (error) {
          if (error is NativeCryptoException) {
            return ClientException('${error.message}');
          }
          return ClientException(error.toString());
        },
      );

  @override
  FutureOrResult<Uint8List> hash(Hash hasher, Uint8List data) =>
      Result.tryCatchAsync(
        () async => cryptoDataSource.hash(hasher, data),
        (error) {
          if (error is NativeCryptoException) {
            return ClientException('${error.message}');
          }
          return ClientException(error.toString());
        },
      );

  @override
  FutureOrResult<Uint8List> hmac(Hmac hmac, Uint8List data, SecretKey key) =>
      Result.tryCatchAsync(
        () async => cryptoDataSource.hmac(hmac, data, key),
        (error) {
          if (error is NativeCryptoException) {
            return ClientException('${error.message}');
          }
          return ClientException(error.toString());
        },
      );

  @override
  FutureOrResult<Uint8List> encrypt(Uint8List data, SecretKey key) =>
      Result.tryCatchAsync(
        () async => cryptoDataSource.encrypt(data, key),
        (error) {
          if (error is NativeCryptoException) {
            return ClientException('${error.message}');
          }
          return ClientException(error.toString());
        },
      );

  @override
  FutureOrResult<Uint8List> encryptWithIV(
    Uint8List data,
    SecretKey key,
    Uint8List iv,
  ) =>
      Result.tryCatchAsync(
        () async => cryptoDataSource.encryptWithIV(data, key, iv),
        (error) {
          if (error is NativeCryptoException) {
            return ClientException('${error.message}');
          }
          return ClientException(error.toString());
        },
      );

  @override
  FutureOrResult<void> encryptFile(
    File plainText,
    Uri folderResult,
    SecretKey key,
  ) =>
      Result.tryCatchAsync(
        () async => cryptoDataSource.encryptFile(plainText, folderResult, key),
        (error) {
          if (error is NativeCryptoException) {
            return ClientException('${error.message}');
          }
          return ClientException(error.toString());
        },
      );

  @override
  FutureOrResult<SecretKey> generateSecureRandom(int length) =>
      Result.tryCatchAsync(
        () async => cryptoDataSource.generateSecureRandom(length),
        (error) {
          if (error is NativeCryptoException) {
            return ClientException('${error.message}');
          }
          return ClientException(error.toString());
        },
      );
}
