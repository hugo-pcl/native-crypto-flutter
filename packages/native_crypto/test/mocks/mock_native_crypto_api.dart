// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

class MockNativeCryptoAPI implements NativeCryptoAPI {
  static Uint8List? Function(int length)? generateSecureRandomFn;

  static Uint8List? Function(
    Uint8List data,
    String algorithm,
  )? hashFn;

  static Uint8List? Function(
    Uint8List data,
    Uint8List key,
    String algorithm,
  )? hmacFn;

  static Uint8List? Function(
    Uint8List cipherText,
    Uint8List key,
    String algorithm,
  )? decryptFn;

  static bool? Function(
    String cipherTextPath,
    String plainTextPath,
    Uint8List key,
    String algorithm,
  )? decryptFileFn;

  static Uint8List? Function(
    Uint8List plainText,
    Uint8List key,
    String algorithm,
  )? encryptFn;

  static bool? Function(
    String plainTextPath,
    String cipherTextPath,
    Uint8List key,
    String algorithm,
  )? encryptFileFn;

  static Uint8List? Function(
    Uint8List plainText,
    Uint8List key,
    Uint8List iv,
    String algorithm,
  )? encryptWithIVFn;

  static Uint8List? Function(
    Uint8List password,
    Uint8List salt,
    int iterations,
    int length,
    String algorithm,
  )? pbkdf2Fn;

  @override
  Future<DecryptResponse> decrypt(DecryptRequest argRequest) async =>
      decryptFn != null
          ? DecryptResponse(
              plainText: decryptFn!(
                argRequest.cipherText!,
                argRequest.key!,
                argRequest.algorithm!,
              ),
            )
          : DecryptResponse(
              plainText: Uint8List.fromList([1, 2, 3]),
            );

  @override
  Future<DecryptFileResponse> decryptFile(
    DecryptFileRequest argRequest,
  ) async =>
      decryptFileFn != null
          ? DecryptFileResponse(
              success: decryptFileFn!(
                argRequest.cipherTextPath!,
                argRequest.plainTextPath!,
                argRequest.key!,
                argRequest.algorithm!,
              ),
            )
          : DecryptFileResponse(success: true);

  @override
  Future<EncryptResponse> encrypt(EncryptRequest argRequest) async =>
      encryptFn != null
          ? EncryptResponse(
              cipherText: encryptFn!(
                argRequest.plainText!,
                argRequest.key!,
                argRequest.algorithm!,
              ),
            )
          : EncryptResponse(
              cipherText: Uint8List.fromList([1, 2, 3]),
            );

  @override
  Future<EncryptFileResponse> encryptFile(
    EncryptFileRequest argRequest,
  ) async =>
      encryptFileFn != null
          ? EncryptFileResponse(
              success: encryptFileFn!(
                argRequest.plainTextPath!,
                argRequest.cipherTextPath!,
                argRequest.key!,
                argRequest.algorithm!,
              ),
            )
          : EncryptFileResponse(success: true);

  @override
  Future<EncryptResponse> encryptWithIV(
    EncryptWithIVRequest argRequest,
  ) async =>
      encryptWithIVFn != null
          ? EncryptResponse(
              cipherText: encryptWithIVFn!(
                argRequest.plainText!,
                argRequest.key!,
                argRequest.iv!,
                argRequest.algorithm!,
              ),
            )
          : EncryptResponse(
              cipherText: Uint8List.fromList([1, 2, 3]),
            );

  @override
  Future<GenerateSecureRandomResponse> generateSecureRandom(
    GenerateSecureRandomRequest argRequest,
  ) async =>
      generateSecureRandomFn != null
          ? GenerateSecureRandomResponse(
              random: generateSecureRandomFn!(argRequest.length!),
            )
          : GenerateSecureRandomResponse(
              random: Uint8List.fromList([1, 2, 3]),
            );

  @override
  Future<HashResponse> hash(HashRequest argRequest) async => hashFn != null
      ? HashResponse(
          hash: hashFn!(
            argRequest.data!,
            argRequest.algorithm!,
          ),
        )
      : HashResponse(
          hash: Uint8List.fromList([1, 2, 3]),
        );

  @override
  Future<HmacResponse> hmac(HmacRequest argRequest) async => hmacFn != null
      ? HmacResponse(
          hmac: hmacFn!(
            argRequest.data!,
            argRequest.key!,
            argRequest.algorithm!,
          ),
        )
      : HmacResponse(
          hmac: Uint8List.fromList([1, 2, 3]),
        );

  @override
  Future<Pbkdf2Response> pbkdf2(Pbkdf2Request argRequest) async =>
      pbkdf2Fn != null
          ? Pbkdf2Response(
              key: pbkdf2Fn!(
                argRequest.password!,
                argRequest.salt!,
                argRequest.iterations!,
                argRequest.length!,
                argRequest.hashAlgorithm!,
              ),
            )
          : Pbkdf2Response(
              key: Uint8List.fromList([1, 2, 3]),
            );
}
