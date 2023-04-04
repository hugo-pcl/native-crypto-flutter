// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    copyrightHeader: 'pigeons/copyright_header.txt',
    dartOut: 'lib/src/gen/messages.g.dart',
    // We export in the lib folder to expose the class to other packages.
    dartTestOut: 'lib/src/gen/test.g.dart',
    kotlinOut:
        '../native_crypto_android/android/src/main/kotlin/fr/pointcheval/native_crypto_android/Pigeon.kt',
    kotlinOptions: KotlinOptions(
      package: 'fr.pointcheval.native_crypto_android',
    ),
    swiftOut: '../native_crypto_ios/ios/Classes/messages.g.swift',
  ),
)
enum HashAlgorithm {
  sha256,
  sha384,
  sha512;
}

enum CipherAlgorithm {
  aes;
}

@HostApi(dartHostTestHandler: 'TestNativeCryptoAPI')
abstract class NativeCryptoAPI {
  Uint8List? hash(Uint8List data, HashAlgorithm algorithm);
  Uint8List? hmac(Uint8List data, Uint8List key, HashAlgorithm algorithm);
  Uint8List? generateSecureRandom(int length);

  Uint8List? pbkdf2(
    Uint8List password,
    Uint8List salt,
    int length,
    int iterations,
    HashAlgorithm algorithm,
  );

  Uint8List? encrypt(
    Uint8List plainText,
    Uint8List key,
    CipherAlgorithm algorithm,
  );

  Uint8List? encryptWithIV(
    Uint8List plainText,
    Uint8List iv,
    Uint8List key,
    CipherAlgorithm algorithm,
  );

  Uint8List? decrypt(
    Uint8List cipherText,
    Uint8List key,
    CipherAlgorithm algorithm,
  );

  bool? encryptFile(
    String plainTextPath,
    String cipherTextPath,
    Uint8List key,
    CipherAlgorithm algorithm,
  );

  bool? encryptFileWithIV(
    String plainTextPath,
    String cipherTextPath,
    Uint8List iv,
    Uint8List key,
    CipherAlgorithm algorithm,
  );

  bool? decryptFile(
    String cipherTextPath,
    String plainTextPath,
    Uint8List key,
    CipherAlgorithm algorithm,
  );

}
