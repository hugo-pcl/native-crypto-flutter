// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

/// The hash algorithm to use in Message Digest and HMAC.
enum HashAlgorithm {
  /// The SHA-256 hash algorithm.
  sha256,

  /// The SHA-384 hash algorithm.
  sha384,

  /// The SHA-512 hash algorithm.
  sha512,
}
