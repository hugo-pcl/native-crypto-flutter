# NativeCrypto

Fast crypto functions for Flutter.

## Why 🤔

Because I faced a performance issue when I was using **PointyCastle**.

It's quite simple, judge for yourself, these are times for AES256 encryption on an Android device.

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

## Performances ⏱

| Size | NativeCrypto |
|------|--------------|
| 1 mB | 27 ms
| 2 mB | 43 ms
| 3 mB | 78 ms
| 4 mB | 93 ms
| 5 mB | 100 ms
| 10 mB | 229 ms
| 50 mB | 779 ms

## How 🔬

Using the native implementation of the crypto libs available on each OS.

For Android:

* [javax.crypto](https://docs.oracle.com/javase/7/docs/api/javax/crypto/package-summary.html)
* [java.security](https://docs.oracle.com/javase/7/docs/api/java/security/package-summary.html)

For iOS:

* [CommonCrypto](https://developer.apple.com/library/archive/documentation/Security/Conceptual/cryptoservices/Introduction/Introduction.html)
* [CryptoKit](https://developer.apple.com/documentation/cryptokit/)

## Todo 🚀

* ✅ Implement working cross platform AES encryption/decryption.
* ✅ Different key sizes support.
* ✅ Improve performances.
* Add other ciphers.
* ... add asym crypto support.
