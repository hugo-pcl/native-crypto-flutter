// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: native_crypto.dart
// Created Date: 16/12/2021 16:28:00
// Last Modified: 28/12/2021 15:06:48
// -----
// Copyright (c) 2021

export 'src/byte_array.dart';
export 'src/cipher.dart';
export 'src/cipher_text.dart';
export 'src/ciphers/aes.dart';
export 'src/exceptions.dart';
export 'src/hasher.dart';
export 'src/hashers/sha256.dart';
export 'src/hashers/sha384.dart';
export 'src/hashers/sha512.dart';
export 'src/kdf/pbkdf2.dart';
export 'src/keyderivation.dart';
export 'src/keys/secret_key.dart';
export 'src/utils.dart';

const String version = "0.1.0";
const String author = "Hugo Pointcheval";
const String website = "https://hugo.pointcheval.fr/";
const List<String> repositories = ["https://github.com/hugo-pcl/native-crypto-flutter", "https://git.pointcheval.fr/NativeCrypto/native-crypto-flutter"];
