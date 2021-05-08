# NativeCrypto for Flutter

![NativeCrypto Logo](/assets/native_crypto.png)
---

Fast and powerful cryptographic functions thanks to **javax.crypto** and **CommonCrypto**.

## 📝 Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Example](#example)
- [Usage](#usage)
- [Built Using](#built_using)
- [TODOS](#todos)
- [Authors](#authors)

## 🧐 About <a name = "about"></a>

The goal of this plugin is to provide simple access to fast and powerful cryptographic functions by calling native libraries. So on **Android** the plugin uses *javax.crypto* and on **iOS** it uses *CommonCrypto*.

I started this project because using **Pointy Castle** I faced big performance issues on smartphone. It's quite simple, an encryption of 1MB of data in AES256 on an Android device takes **20s** with Pointy Castle against **27ms** using NativeCrypto.

![Pointy Castle Benchmark](/assets/benchmark_pointycastle.png)

> We also notice on this benchmark that the AES encryption time does not even increase linearly with size.

As for NativeCrypto, here is a benchmark realized on an iPhone 11.

| Size (kB) | NativeCrypto **encryption** time (ms) |
|-----------|---------------------------------------|
| 2 mB | 13 ms
| 4 mB | 17 ms
| 8 mB | 56 ms
| 16 mB | 73 ms
| 32 mB | 120 ms
| 64 mB | 243 ms
| 128 mB | 509 ms
| 256 mB | 1057 ms

> ~1s for 256 mB !

In short, **NativeCrypto** is incomparable to **Pointy Castle** in terms of performance.

## 🏁 Getting Started <a name = "getting_started"></a>

### Prerequisites

You'll need:

- Flutter

### Installing

Add these lines in your **pubspec.yaml**:

```yaml
native_crypto:
    git:
        url: https://github.com/hugo-pcl/native-crypto-flutter.git
        ref: v0.0.x
```

> Replace "x" with the current version!

Then in your code:

```dart
import 'package:native_crypto/native_crypto.dart';
```

## 🔍 Example <a name="example"></a>

Look in **example/lib/** for an example app.

## 🎈 Usage <a name="usage"></a>

To derive a key with **PBKDF2**.

```dart
PBKDF2 _pbkdf2 = PBKDF2(keyLength: 32, iteration: 1000, hash: HashAlgorithm.SHA512);
await _pbkdf2.derive(password: "password123", salt: 'salty');
SecretKey key = _pbkdf2.key;
```

To generate a key, and create an **AES Cipher** instance.

```dart
AESCipher aes = await AESCipher.generate(
  AESKeySize.bits256,
  CipherParameters(
    BlockCipherMode.CBC,
    PlainTextPadding.PKCS5,
  ),
);
```

You can also generate key, then create **AES Cipher**.

```dart
SecretKey _key = await SecretKey.generate(256, CipherAlgorithm.AES);
AESCipher aes = AESCipher(
  _key,
  CipherParameters(
    BlockCipherMode.CBC,
    PlainTextPadding.PKCS5,
  ),
);
```

Then you can encrypt/decrypt data with this cipher.

```dart
CipherText cipherText = await aes.encrypt(data);
Uint8List plainText = await aes.decrypt(cipherText);
```

You can easely get encrypted bytes and IV from a CipherText

```dart
Uint8List bytes = cipherText.bytes;
Uint8List iv = cipherText.iv;
```

To create a cipher text with custom data.

```dart
CipherText cipherText = AESCipherText(bytes, iv);
```

To create a hashed message

```dart
MessageDigest md = MessageDigest.getInstance("sha256");
Uint8List hash = await md.digest(message);
```

## ⛏️ Built Using <a name = "built_using"></a>

- [Dart](https://dart.dev)
- [Flutter](https://flutter.dev) - Framework
- [Kotlin](https://kotlinlang.org) - Android Specific code
- [Swift](https://www.apple.com/fr/swift/) - iOS Specific code

## 🚀 TODOS <a name = "todos">

Here you can check major changes, roadmap and todos.

I plan to deal with asymmetric cryptography with the implementation of a Key Encapsulation Mechanism.

- [x] Add PBKDF2 support.
- [x] Implement working cross platform AES encryption/decryption.
- [x] Add Different key sizes support.
- [x] Add exceptions.
- [x] Clean platform specific code.
- [x] Add digest.
- [x] Rework exposed API.
- [x] Add KeyPair generation.
- [ ] Add KEM.
- [ ] Porting NativeCrypto to other platforms...

You can contribute to this project.

## ✍️ Authors <a name = "authors"></a>

- [Hugo Pointcheval](https://github.com/hugo-pcl) - Idea & Initial work
- [Chisom Maxwell](https://github.com/maxcotech) - For the chunks idea [#2](https://github.com/hugo-pcl/native-crypto-flutter/issues/2)
