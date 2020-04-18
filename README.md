# NativeCrypto

Fast crypto functions for Flutter.

* Table of content
  * [Background](#background)
  * [Performances](#performances)
  * [Installation](#installation)
  * [Usage](#usage)
  * [Example](#example)
  * [How](#how)
  * [Todo](#todo)

## Background

🤔 Why I started this project ?
Because I faced a performance issue when I was using **PointyCastle**.

It's quite simple, judge for yourself, these are times for AES256 encryption on an Android device (**Huawei P30 Pro**).

| Size | PointyCastle |
|------|--------------|
| 100 kB | 190 ms
| 200 kB | 314 ms
| 300 kB | 1138 ms
| 400 kB | 2781 ms
| 500 kB | 4691 ms
| 600 kB | 7225 ms
| 700 kB | 10264 ms
| 800 kB | 13582 ms
| 900 kB | 17607 ms

> We notice that these times, in addition to being far too big, are not even linear.

## Performances

⏱ On an **Android 10** device: **Huawei P30 Pro**

| Size | NativeCrypto |
|------|--------------|
| 1 mB | 27 ms
| 2 mB | 43 ms
| 3 mB | 78 ms
| 4 mB | 93 ms
| 5 mB | 100 ms
| 10 mB | 229 ms
| 50 mB | 779 ms

## Installation

🚧 You can easely setup a Flutter project with this plugin.

Just add these lines in your **pubspec.yaml**:

```
native_crypto:
    git:
        url: https://gogs.pointcheval.fr/hugo/native-crypto-flutter.git
        ref: v0.0.x
```

> Replace "x" with the current version!

Then in your code:

```dart
// Symmetric crypto.
import 'package:native_crypto/symmetric_crypto.dart';

// To handle exceptions.
import 'package:native_crypto/exceptions.dart';
```

## Usage

To create an AES instance, and generate a key.

```dart
AES aes = AES();
await aes.init(KeySize.bits256)
```

You can also generate key, then use it in AES.

```dart
Uint8List aeskey = await KeyGenerator().secretKey(keySize: KeySize.bits256);
AES aes = AES(key: aeskey);
```

You can create a key with PBKDF2.

```dart
Uint8List key = await KeyGenerator().pbkdf2(password, salt, keyLength: 32, iteration: 10000);
AES aes = AES(key: key);
```

Then you can encrypt/decrypt data with this instance.

```dart
encryptedPayload = await aes.encrypt(data);
decryptedPayload = await aes.decrypt(encryptedPayload);
```

Or you can also use AES on the fly with different keys.

```dart
Uint8List aeskey = await KeyGenerator().secretKey(keySize: KeySize.bits256);
encryptedPayload = await AES().encrypt(data, key: aeskey);
decryptedPayload = await AES().decrypt(encryptedPayload, key: aeskey);
```

## Example

🔍 Look in **example/lib/** for an example app.

## How

🔬 But how it is possible ??

Using the native implementation of crypto libs available on each OS.

For **Android**:

* [javax.crypto](https://docs.oracle.com/javase/7/docs/api/javax/crypto/package-summary.html)
* [java.security](https://docs.oracle.com/javase/7/docs/api/java/security/package-summary.html)

For **iOS**:

* [CommonCrypto](https://developer.apple.com/library/archive/documentation/Security/Conceptual/cryptoservices/Introduction/Introduction.html)

## Todos

🚀 You can contribute to this project.

* [x] Implement working cross platform AES encryption/decryption.
* [x] Different key sizes support.
* [x] Improve performances.
* [x] Add exceptions.
* [x] PBKDF2 support.
* [ ] Add other ciphers.
* [ ] Clean platform specific code.
* [ ] Add asym crypto support...
