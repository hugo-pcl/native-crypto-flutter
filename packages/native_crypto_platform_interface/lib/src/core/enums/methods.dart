// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

enum NativeCryptoMethod {
  hash,
  hmac,
  generateSecureRandom,
  pbkdf2,
  encrypt,
  decrypt,
  encryptFile,
  decryptFile,
  encryptWithIV
}
