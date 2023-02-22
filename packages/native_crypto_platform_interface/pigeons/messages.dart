// ignore_for_file: public_member_api_docs, sort_constructors_first
// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    copyrightHeader: 'pigeons/copyright_header.txt',
    dartOut: 'lib/src/pigeon/messages.pigeon.dart',
    // We export in the lib folder to expose the class to other packages.
    dartTestOut: 'lib/src/pigeon/test_api.dart',
    javaOut:
        '../native_crypto_android/android/src/main/java/fr/pointcheval/native_crypto_android/GeneratedAndroidNativeCrypto.java',
    javaOptions: JavaOptions(
      package: 'fr.pointcheval.native_crypto_android',
      className: 'GeneratedAndroidNativeCrypto',
    ),
    objcHeaderOut: '../native_crypto_ios/ios/Classes/Public/messages.g.h',
    objcSourceOut: '../native_crypto_ios/ios/Classes/messages.g.m',
  ),
)
class HashRequest {
  const HashRequest({
    this.data,
    this.algorithm,
  });

  final Uint8List? data;
  final String? algorithm;
}

class HashResponse {
  const HashResponse({
    this.hash,
  });

  final Uint8List? hash;
}

class HmacRequest {
  const HmacRequest({
    this.data,
    this.key,
    this.algorithm,
  });

  final Uint8List? data;
  final Uint8List? key;
  final String? algorithm;
}

class HmacResponse {
  const HmacResponse({
    this.hmac,
  });

  final Uint8List? hmac;
}

class GenerateSecureRandomRequest {
  const GenerateSecureRandomRequest({
    this.length,
  });

  final int? length;
}

class GenerateSecureRandomResponse {
  const GenerateSecureRandomResponse({
    this.random,
  });

  final Uint8List? random;
}

class Pbkdf2Request {
  const Pbkdf2Request({
    this.password,
    this.salt,
    this.length,
    this.iterations,
    this.hashAlgorithm,
  });

  final Uint8List? password;
  final Uint8List? salt;
  final int? length;
  final int? iterations;
  final String? hashAlgorithm;
}

class Pbkdf2Response {
  const Pbkdf2Response({
    this.key,
  });

  final Uint8List? key;
}

class EncryptRequest {
  const EncryptRequest({
    this.plainText,
    this.key,
    this.algorithm,
  });

  final Uint8List? plainText;
  final Uint8List? key;
  final String? algorithm;
}

class EncryptResponse {
  const EncryptResponse({
    this.cipherText,
  });

  final Uint8List? cipherText;
}

class DecryptRequest {
  const DecryptRequest({
    this.cipherText,
    this.key,
    this.algorithm,
  });

  final Uint8List? cipherText;
  final Uint8List? key;
  final String? algorithm;
}

class DecryptResponse {
  const DecryptResponse({
    this.plainText,
  });

  final Uint8List? plainText;
}

class EncryptFileRequest {
  const EncryptFileRequest({
    this.plainTextPath,
    this.cipherTextPath,
    this.key,
    this.algorithm,
  });

  final String? plainTextPath;
  final String? cipherTextPath;
  final Uint8List? key;
  final String? algorithm;
}

class EncryptFileResponse {
  const EncryptFileResponse({
    this.success,
  });

  final bool? success;
}

class DecryptFileRequest {
  const DecryptFileRequest({
    this.cipherTextPath,
    this.plainTextPath,
    this.key,
    this.algorithm,
  });

  final String? cipherTextPath;
  final String? plainTextPath;
  final Uint8List? key;
  final String? algorithm;
}

class DecryptFileResponse {
  const DecryptFileResponse({
    this.success,
  });

  final bool? success;
}

class EncryptWithIVRequest {
  const EncryptWithIVRequest({
    this.plainText,
    this.iv,
    this.key,
    this.algorithm,
  });

  final Uint8List? plainText;
  final Uint8List? iv;
  final Uint8List? key;
  final String? algorithm;
}

@HostApi(dartHostTestHandler: 'TestNativeCryptoAPI')
abstract class NativeCryptoAPI {
  HashResponse hash(HashRequest request);
  HmacResponse hmac(HmacRequest request);

  GenerateSecureRandomResponse generateSecureRandom(
    GenerateSecureRandomRequest request,
  );

  Pbkdf2Response pbkdf2(Pbkdf2Request request);

  EncryptResponse encrypt(EncryptRequest request);

  DecryptResponse decrypt(DecryptRequest request);

  EncryptFileResponse encryptFile(EncryptFileRequest request);

  DecryptFileResponse decryptFile(DecryptFileRequest request);

  EncryptResponse encryptWithIV(EncryptWithIVRequest request);
}
